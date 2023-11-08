package com.e3ps.sap.service;

import java.io.File;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.e3ps.change.EChangeNotice;
import com.e3ps.change.EChangeOrder;
import com.e3ps.change.EOCompletePartLink;
import com.e3ps.change.PartToSendLink;
import com.e3ps.change.util.EChangeUtils;
import com.e3ps.common.code.service.NumberCodeHelper;
import com.e3ps.common.iba.IBAUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.util.WCUtil;
import com.e3ps.part.service.PartHelper;
import com.e3ps.sap.conn.SAPDevConnection;
import com.e3ps.sap.dto.SAPBomDTO;
import com.e3ps.sap.dto.SAPReverseBomDTO;
import com.e3ps.sap.util.SAPUtil;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

import wt.fc.IdentityHelper;
import wt.fc.PersistenceHelper;
import wt.fc.PersistenceServerHelper;
import wt.folder.Folder;
import wt.folder.FolderEntry;
import wt.folder.FolderHelper;
import wt.org.WTUser;
import wt.part.Quantity;
import wt.part.QuantityUnit;
import wt.part.WTPart;
import wt.part.WTPartMaster;
import wt.part.WTPartMasterIdentity;
import wt.part.WTPartUsageLink;
import wt.pom.Transaction;
import wt.series.MultilevelSeries;
import wt.series.Series;
import wt.services.StandardManager;
import wt.util.WTException;
import wt.vc.IterationIdentifier;
import wt.vc.VersionControlHelper;
import wt.vc.VersionIdentifier;
import wt.vc.views.View;
import wt.vc.views.ViewHelper;

public class StandardSAPService extends StandardManager implements SAPService {

	public static StandardSAPService newStandardSAPService() throws WTException {
		StandardSAPService instance = new StandardSAPService();
		instance.initialize();
		return instance;
	}

	@Override
	public void loaderBom(String path) throws Exception {
		Transaction trs = new Transaction();
		try {
			trs.start();

			File file = new File(path);

			Workbook workbook = new XSSFWorkbook(file);
			Sheet sheet = workbook.getSheetAt(0);

			int rows = sheet.getPhysicalNumberOfRows(); // 시트의 행 개수 가져오기
			DataFormatter df = new DataFormatter();
			// 모든 행(row)을 순회하면서 데이터 가져오기

			HashMap<Integer, WTPart> parentMap = new HashMap<>();
			for (int i = 1; i < rows; i++) {
				Row row = sheet.getRow(i);

				String number = df.formatCellValue(row.getCell(3));
				if (!StringUtil.checkString(number)) {
					System.out.println("값이 없어서 패스 시킨다.");
					continue;
				}

				int level = (int) row.getCell(2).getNumericCellValue();
				double qty = row.getCell(11).getNumericCellValue();
				String name = df.formatCellValue(row.getCell(5));
				String version = df.formatCellValue(row.getCell(6));
				String model = df.formatCellValue(row.getCell(13));
				String dept = df.formatCellValue(row.getCell(14));

				String spec = df.formatCellValue(row.getCell(10));
				String product = df.formatCellValue(row.getCell(16));

				// 지금은 이름...
				String modelCode = SAPHelper.manager.get(model, "MODEL");
				String deptCode = SAPHelper.manager.get(dept, "DEPTCODE");

				String specCode = SAPHelper.manager.get(spec, "SPECIFICATION");
				String productCode = SAPHelper.manager.get(product, "PRODUCTMETHOD");

				System.out.println("version == " + version + ", number=" + number + ", name = " + name + ", model + "
						+ modelCode + ", dept = " + deptCode + ", spec + " + specCode + ", produc = " + productCode);

				WTPart part = create(number, name, version);

				IBAUtil.createIba(part, "string", "MODEL", modelCode);
				IBAUtil.createIba(part, "string", "DEPTCODE", deptCode);
				IBAUtil.createIba(part, "string", "SPECIFICATION", specCode);
				IBAUtil.createIba(part, "string", "PRODUCTMETHOD", productCode);

				WTPart parentPart = parentMap.get(level - 1);
				if (parentPart != null) {
					WTPartUsageLink usageLink = WTPartUsageLink.newWTPartUsageLink(parentPart,
							(WTPartMaster) part.getMaster());
					QuantityUnit quantityUnit = QuantityUnit.toQuantityUnit("ea");
					usageLink.setQuantity(Quantity.newQuantity(qty, quantityUnit));
					PersistenceServerHelper.manager.insert(usageLink);
				}
				// 만들어진게 부모 파트로 ...
				parentMap.put(level, part);
			}

			trs.commit();
			trs = null;
		} catch (Exception e) {
			e.printStackTrace();
			trs.rollback();
			throw e;
		} finally {
			if (trs != null)
				trs.rollback();
		}
	}

	@Override
	public WTPart create(String number, String name, String version) throws Exception {
		// 하나의 프로세스상 트랜잭션 하나로 유지시킨다.
		WTPart part = null;
		int idx = version.indexOf(".");
		String first = version.substring(0, idx);
		String end = version.substring(idx + 1);
		try {

			part = SAPHelper.manager.getPart(number.trim(), first, end);
			if (part == null) {

				WTPartMaster master = SAPHelper.manager.getMaster(number);
				if (master != null) {

					part = WTPart.newWTPart();

					WTPartMasterIdentity identity = (WTPartMasterIdentity) master.getIdentificationObject();
					identity.setNumber(number);
					identity.setName(name);
					master = (WTPartMaster) IdentityHelper.service.changeIdentity(master, identity);

					part.setMaster(master);
//					part.setName(name);
//					part.setNumber(number);
					part.setDefaultUnit(QuantityUnit.toQuantityUnit("ea"));
					View view = ViewHelper.service.getView("Design");
					ViewHelper.assignToView(part, view);

					VersionIdentifier vc = VersionIdentifier.newVersionIdentifier(
							MultilevelSeries.newMultilevelSeries("wt.series.HarvardSeries", first));
					part.getMaster().setSeries("wt.series.HarvardSeries");
					VersionControlHelper.setVersionIdentifier(part, vc);
					// set iteration as "3"
					Series ser = Series.newSeries("wt.vc.IterationIdentifier", end);
					IterationIdentifier iid = IterationIdentifier.newIterationIdentifier(ser);
					VersionControlHelper.setIterationIdentifier(part, iid);

					Folder folder = FolderHelper.service.getFolder("/Default/PART_Drawing/TEST",
							WCUtil.getWTContainerRef());
					FolderHelper.assignLocation((FolderEntry) part, folder);

					PersistenceHelper.manager.save(part);
				} else {
					part = WTPart.newWTPart();
					part.setName(name);
					part.setNumber(number);
					part.setDefaultUnit(QuantityUnit.toQuantityUnit("ea"));
					View view = ViewHelper.service.getView("Design");
					ViewHelper.assignToView(part, view);

					VersionIdentifier vc = VersionIdentifier.newVersionIdentifier(
							MultilevelSeries.newMultilevelSeries("wt.series.HarvardSeries", first));
					part.getMaster().setSeries("wt.series.HarvardSeries");
					VersionControlHelper.setVersionIdentifier(part, vc);
					Series ser = Series.newSeries("wt.vc.IterationIdentifier", end);
					IterationIdentifier iid = IterationIdentifier.newIterationIdentifier(ser);
					VersionControlHelper.setIterationIdentifier(part, iid);

					Folder folder = FolderHelper.service.getFolder("/Default/PART_Drawing/TEST",
							WCUtil.getWTContainerRef());
					FolderHelper.assignLocation((FolderEntry) part, folder);

					PersistenceHelper.manager.save(part);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return part;
	}

	@Override
	public void sendSapToEo(EChangeOrder e, ArrayList<EOCompletePartLink> completeParts) throws Exception {
		// 결재완료 안에서 동작하기에 트랜젝션 제외
		System.out.println("EO SAP 인터페이스 시작");
		// 자재마스터 전송
		sendToSapEoPart(e, completeParts);
		// BOM 전송
		sendToSapEoBom(e, completeParts);
		System.out.println("EO SAP 인터페이스 종료");
	}

	/**
	 * EO 전용 BOM 전송 함수
	 */
	private void sendToSapEoBom(EChangeOrder e, ArrayList<EOCompletePartLink> completeParts) throws Exception {
		System.out.println("시작 SAP 인터페이스 - EO BOM FUN : ZPPIF_PDM_002");
		JCoDestination destination = JCoDestinationManager.getDestination(SAPDevConnection.DESTINATION_NAME);
		JCoFunction function = destination.getRepository().getFunction("ZPPIF_PDM_002");
		if (function == null) {
			throw new RuntimeException("STFC_CONNECTION not found in SAP.");
		}

		DecimalFormat df = new DecimalFormat("0000");
		Timestamp t = new Timestamp(new Date().getTime());
		String today = t.toString().substring(0, 10).replaceAll("-", "");

		JCoParameterList importTable = function.getImportParameterList();
		importTable.setValue("IV_WERKS", "1000"); // 플랜트

		// EO/ECO 헤더 정보 전송
		JCoTable eoTable = function.getTableParameterList().getTable("ET_ECM");

		eoTable.appendRow();
		eoTable.setValue("AENNR8", e.getEoNumber()); // 변경번호 12자리??
		eoTable.setValue("ZECMID", "EO"); // EO/ECO 구분
		eoTable.setValue("DATUV", today); // 보내는 날짜
		eoTable.setValue("AEGRU", "초도발행"); // 변경사유 테스트 일단 한줄
		eoTable.setValue("AETXT", "첫줄 테스트"); // 변경 내역 첫줄만 일단 테스트
		eoTable.setValue("AETXT_L", "테스트1<br>테스트2<br>테스트3"); // 변경 내역 전체 내용

		// 완제품으로 품목을 담는다.
		ArrayList<WTPart> list = new ArrayList<WTPart>();
		for (EOCompletePartLink link : completeParts) {
			String version = link.getVersion();
			WTPart root = PartHelper.manager.getPart(link.getCompletePart().getNumber(), version);
			list.add(root);
		}

		JCoTable bomTable = function.getTableParameterList().getTable("ET_BOM");
		// BOM 전송 한번 돌고 호출하고 하는식???
		for (WTPart part : list) {
			// 완제품에 해당하는 BOM 목록들..
			ArrayList<SAPBomDTO> dataList = SAPHelper.manager.getterBomData(part);

			System.out.println("BOM 리스트 항목 개수  = " + dataList.size());

			// 완제품 기준으로 다시 SEQ 리셋..?
			int idx = 1;
			for (SAPBomDTO dto : dataList) {
				System.out.println("상위품번 = " + dto.getNewParentPartNumber() + ", 하위품번 = " + dto.getNewChildPartNumber()
						+ ", 단위 = " + dto.getUnit());
				bomTable.insertRow(idx);
				bomTable.setValue("AENNR8", e.getEoNumber()); // 변경번호 12자리?
				bomTable.setValue("SEQNO", df.format(idx)); // 항목번호 ?? 고정인지.. 애매한데
				// EO 일경우 NEW 에만
				bomTable.setValue("MATNR_NEW", dto.getNewParentPartNumber()); // 기존 모품번
				bomTable.setValue("IDNRK_NEW", dto.getNewChildPartNumber()); // 기존 자품번
				bomTable.setValue("MENGE", dto.getQty()); // 수량
				bomTable.setValue("MEINS", dto.getUnit()); // 단위
				bomTable.setValue("AENNR12", e.getEoNumber() + df.format(idx)); // 변경번호 12자리
				// AENNR12
				idx++;
			}
		}

		function.execute(destination);
		JCoParameterList result = function.getExportParameterList();
		Object r_type = result.getValue("EV_STATUS");
		Object r_msg = result.getValue("EV_MESSAGE");
		System.out.println("[ SAP JCO ] RETURN - TYPE:" + r_type);
		System.out.println("[ SAP JCO ] RETURN - MESSAGE:" + r_msg);
		System.out.println("종료 SAP 인터페이스 - EO BOM FUN : ZPPIF_PDM_002");

	}

	/**
	 * EO 전용 자재마스터 리스트 전송 함수
	 */
	private void sendToSapEoPart(EChangeOrder e, ArrayList<EOCompletePartLink> completeParts) throws Exception {
		System.out.println("시작 SAP 인터페이스 - EO 자재마스터 FUN : ZPPIF_PDM_001");
		JCoDestination destination = JCoDestinationManager.getDestination(SAPDevConnection.DESTINATION_NAME);
		JCoFunction function = destination.getRepository().getFunction("ZPPIF_PDM_001");
		if (function == null) {
			throw new RuntimeException("STFC_CONNECTION not found in SAP.");
		}

		// 완제품으로 하위에 있는 모든 품목을 조회 해서 전송한다
		ArrayList<WTPart> list = new ArrayList<WTPart>();
		for (EOCompletePartLink link : completeParts) {
			String version = link.getVersion();
			WTPart root = PartHelper.manager.getPart(link.getCompletePart().getNumber(), version);
			// 중복 품목 제외를 한다.
			list = SAPHelper.manager.getterSkip(root);
		}

		JCoParameterList importTable = function.getImportParameterList();
		importTable.setValue("IV_WERKS", "1000"); // 플랜트
		int idx = 1;
		JCoTable insertTable = function.getTableParameterList().getTable("ET_MAT");
		// 자재는 한번에 넘기고 함수 호출
		for (WTPart part : list) {
			insertTable.insertRow(idx);

			String number = part.getNumber();
			// 전송 제외 품목
			if (skip(number)) {
				continue;
			}

			System.out.println("전송된 자재 번호 = " + number);

			// 샘플로 넣기
			insertTable.setValue("AENNR8", e.getEoNumber()); // 변경번호 8자리
			insertTable.setValue("MATNR", number); // 자재번호
			insertTable.setValue("MAKTX", part.getName()); // 자재내역(자재명)
			insertTable.setValue("MEINS", part.getDefaultUnit().toString().toUpperCase()); // 기본단위

			String ZSPEC_CODE = IBAUtil.getStringValue(part, "SPECIFICATION");
			insertTable.setValue("ZSPEC", SAPUtil.sapValue(ZSPEC_CODE, "SPECIFICATION")); // 사양

			String ZMODEL_CODE = IBAUtil.getStringValue(part, "MODEL");
			insertTable.setValue("ZMODEL", SAPUtil.sapValue(ZMODEL_CODE, "MODEL")); // Model:프로젝트

			String ZPRODM_CODE = IBAUtil.getStringValue(part, "PRODUCTMETHOD");
			insertTable.setValue("ZPRODM", SAPUtil.sapValue(ZPRODM_CODE, "PRODUCTMETHOD")); // 제작방법

			String ZDEPT_CODE = IBAUtil.getStringValue(part, "DEPTCODE");
			insertTable.setValue("ZDEPT", SAPUtil.sapValue(ZDEPT_CODE, "DEPTCODE")); // 부서

			// 샘플링 실제는 2D여부 확인해서 전송
			insertTable.setValue("ZDWGNO", part.getNumber() + ".DRW"); // 도면번호

			String v = part.getVersionIdentifier().getSeries().getValue();
			insertTable.setValue("ZEIVR", v); // 버전
			// 테스트 용으로 전송
			insertTable.setValue("ZPREPO", "X"); // 선구매필요

			// ?? 코드: 단위 형태인지
//			insertTable.setValue("BRGEW", "X"); // 중량
//			insertTable.setValue("GEWEI", "X"); // 중량 단위
//			insertTable.setValue("ZMATLT", "X"); // 재질
//			insertTable.setValue("ZPOSTP", "X"); // 후처리
//			insertTable.setValue("ZDEVND", "X"); // 개발공급업체

			idx++;
		}

		function.execute(destination);

		JCoParameterList result = function.getExportParameterList();
		Object r_type = result.getValue("EV_STATUS");
		Object r_msg = result.getValue("EV_MESSAGE");
		System.out.println("[ SAP JCO ] RETURN - TYPE:" + r_type);
		System.out.println("[ SAP JCO ] RETURN - MESSAGE:" + r_msg);
		System.out.println("종료 SAP 인터페이스 - EO 자재마스터 FUN : ZPPIF_PDM_001");
	}

	/**
	 * 품번 기준 전송 제외 품목
	 */
	private boolean skip(String number) throws Exception {

		if (number.startsWith("8")) {
			return true;
		}

		return false;
	}

	@Override
	public void sendSapToEco(EChangeOrder eco) throws Exception {
		System.out.println("ECO SAP 인터페이스 시작");
		// 신규로 발생한 자재 전송??
		sendToSapEcoPart(eco);
		// ECO BOM
		sendToSapEcoBom(eco);
		System.out.println("ECO SAP 인터페이스 종료");
	}

	/**
	 * ECO BOM 전송
	 */
	private void sendToSapEcoBom(EChangeOrder eco) throws Exception {
		System.out.println("시작 SAP 인터페이스 - ECO BOM FUN : ZPPIF_PDM_002");
		// 결재완료 안에서 동작하기에 트랜젝션 제외
		JCoDestination destination = JCoDestinationManager.getDestination(SAPDevConnection.DESTINATION_NAME);
		JCoFunction function = destination.getRepository().getFunction("ZPPIF_PDM_002");
		if (function == null) {
			throw new RuntimeException("STFC_CONNECTION not found in SAP.");
		}

		JCoParameterList importTable = function.getImportParameterList();
		importTable.setValue("IV_WERKS", "1000"); // 플랜트
		int idx = 1;

		DecimalFormat df = new DecimalFormat("0000");
		Timestamp t = new Timestamp(new Date().getTime());
		String today = t.toString().substring(0, 10).replaceAll("-", "");

		// ECO 헤더 정보 전송
		JCoTable ecoTable = function.getTableParameterList().getTable("ET_ECM");
		ecoTable.appendRow();
		ecoTable.setValue("AENNR8", eco.getEoNumber()); // 변경번호 12자리??
		ecoTable.setValue("ZECMID", "ECO"); // EO/ECO 구분
		ecoTable.setValue("DATUV", today); // 보내는 날짜
		ecoTable.setValue("AEGRU", "초도발행"); // 변경사유 테스트 일단 한줄
		ecoTable.setValue("AETXT", "첫줄 테스트"); // 변경 내역 첫줄만 일단 테스트
		ecoTable.setValue("AETXT_L", "테스트1<br>테스트2<br>테스트3"); // 변경 내역 전체 내용

		// 변경 대상품목을 가져온다..
		JCoTable bomTable = function.getTableParameterList().getTable("ET_BOM");

		// ECO 변경 대상품목중 젤 하위만 모아서 역전개로 전송 한다.
		ArrayList<WTPart> list = SAPHelper.manager.getEcoEndParts(eco);
		System.out.println("역전개 데이터 개수 =  " + list.size());
		for (WTPart part : list) {

			// 개정 후 품목이 무조건 오는게 맞나 ...
			ArrayList<SAPReverseBomDTO> dataList = SAPHelper.manager.getReverseBomData(part, eco);

			System.out.println("역전개 개수 = " + dataList.size());

			for (SAPReverseBomDTO dto : dataList) {

				System.out.println(
						"부보품번 = " + dto.getNewParentPartNumber() + ", " + "자식품번 =  " + dto.getNewChildPartNumber()
								+ ", 이전부모 = " + dto.getParentPartNumber() + ", 이전자식 = " + dto.getChildPartNumber());

				bomTable.insertRow(idx);
				bomTable.setValue("AENNR8", eco.getEoNumber()); // 변경번호 12자리?
				bomTable.setValue("SEQNO", df.format(idx)); // 항목번호 ?? 고정인지.. 애매한데
				bomTable.setValue("MATNR_OLD", dto.getParentPartNumber()); // 이전 모품번
				bomTable.setValue("IDNRK_OLD", dto.getChildPartNumber()); // 이전 자품번
				bomTable.setValue("MATNR_NEW", dto.getNewParentPartNumber()); // 기존 모품번
				bomTable.setValue("IDNRK_NEW", dto.getNewChildPartNumber()); // 기존 자품번
				bomTable.setValue("MENGE", dto.getQty()); // 수량
				bomTable.setValue("MEINS", dto.getUnit()); // 단위
				bomTable.setValue("AENNR12", eco.getEoNumber() + df.format(idx)); // 변경번호 12자리
				idx++;
			}

		}

		function.execute(destination);

		JCoParameterList result = function.getExportParameterList();
		Object r_type = result.getValue("EV_STATUS");
		Object r_msg = result.getValue("EV_MESSAGE");
		System.out.println("[ SAP JCO ] RETURN - TYPE:" + r_type);
		System.out.println("[ SAP JCO ] RETURN - MESSAGE:" + r_msg);
		System.out.println("종료 SAP 인터페이스 - ECO BOM FUN : ZPPIF_PDM_002");
	}

	/**
	 * ECO 자재 전송
	 */
	private void sendToSapEcoPart(EChangeOrder eco) throws Exception {
		System.out.println("시작 SAP 인터페이스 - ECO 자재마스터 FUN : ZPPIF_PDM_001");
		JCoDestination destination = JCoDestinationManager.getDestination(SAPDevConnection.DESTINATION_NAME);
		JCoFunction function = destination.getRepository().getFunction("ZPPIF_PDM_001");
		if (function == null) {
			throw new RuntimeException("STFC_CONNECTION not found in SAP.");
		}

		// 완제품으로 하위에 있는 모든 품목을 조회 해서 전송한다

		JCoParameterList importTable = function.getImportParameterList();
		importTable.setValue("IV_WERKS", "1000"); // 플랜트
		int idx = 1;
		JCoTable insertTable = function.getTableParameterList().getTable("ET_MAT");
		// 자재는 한번에 넘기고 함수 호출

		ArrayList<WTPart> list = EChangeUtils.manager.getEcoParts(eco);
		for (WTPart part : list) {

			insertTable.insertRow(idx);
			String v = part.getVersionIdentifier().getSeries().getValue();
			System.out.println("ECO(" + eco.getEoNumber() + ") 자재 마스터 전송 품번 : " + part.getNumber() + ", 변경 버전 = " + v);

			// 샘플로 넣기
			insertTable.setValue("AENNR8", eco.getEoNumber()); // 변경번호 8자리
			insertTable.setValue("MATNR", part.getNumber()); // 자재번호
			insertTable.setValue("MAKTX", part.getName()); // 자재내역(자재명)
			insertTable.setValue("MEINS", part.getDefaultUnit().toString().toUpperCase()); // 기본단위

			String ZSPEC_CODE = IBAUtil.getStringValue(part, "SPECIFICATION");
			insertTable.setValue("ZSPEC", SAPUtil.sapValue(ZSPEC_CODE, "SPECIFICATION")); // 사양

			String ZMODEL_CODE = IBAUtil.getStringValue(part, "MODEL");
			insertTable.setValue("ZMODEL", SAPUtil.sapValue(ZMODEL_CODE, "MODEL")); // Model:프로젝트

			String ZPRODM_CODE = IBAUtil.getStringValue(part, "PRODUCTMETHOD");
			insertTable.setValue("ZPRODM", SAPUtil.sapValue(ZPRODM_CODE, "PRODUCTMETHOD")); // 제작방법

			String ZDEPT_CODE = IBAUtil.getStringValue(part, "DEPTCODE");
			insertTable.setValue("ZDEPT", SAPUtil.sapValue(ZDEPT_CODE, "DEPTCODE")); // 부서

			// 샘플링 실제는 2D여부 확인해서 전송
			insertTable.setValue("ZDWGNO", part.getNumber() + ".DRW"); // 도면번호

			insertTable.setValue("ZEIVR", v); // 버전
			// 테스트 용으로 전송
			insertTable.setValue("ZPREPO", "X"); // 선구매필요
			idx++;
		}

		function.execute(destination);

		JCoParameterList result = function.getExportParameterList();
		Object r_type = result.getValue("EV_STATUS");
		Object r_msg = result.getValue("EV_MESSAGE");
		System.out.println("[ SAP JCO ] RETURN - TYPE:" + r_type);
		System.out.println("[ SAP JCO ] RETURN - MESSAGE:" + r_msg);
		System.out.println("종료 SAP 인터페이스 - ECO 자재마스터 FUN : ZPPIF_PDM_001");
	}

	@Override
	public void sendSapToEcn(Map<String, Object> params) throws Exception {
		System.out.println("시작 SAP 인터페이스 - ECN 확정인허가일 FUN : ZPPIF_PDM_003");
		String oid = (String) params.get("oid");

		JCoDestination destination = JCoDestinationManager.getDestination(SAPDevConnection.DESTINATION_NAME);
		JCoFunction function = destination.getRepository().getFunction("ZPPIF_PDM_003");
		if (function == null) {
			throw new RuntimeException("STFC_CONNECTION not found in SAP.");
		}

		ArrayList<Map<String, Object>> editRows = (ArrayList<Map<String, Object>>) params.get("editRows");
		Transaction trs = new Transaction();
		try {
			trs.start();

			EChangeNotice ecn = (EChangeNotice) CommonUtil.getObject(oid);

			JCoParameterList importTable = function.getImportParameterList();
			importTable.setValue("IV_WERKS", "1000"); // 플랜트

			int idx = 1;
			JCoTable insertTable = function.getTableParameterList().getTable("ET_ECN");
			for (Map<String, Object> editRow : editRows) {
				String part_oid = (String) editRow.get("part_oid");
				WTPart part = (WTPart) CommonUtil.getObject(part_oid);

				ArrayList<Map<String, String>> countrys = NumberCodeHelper.manager.getCountry();
				for (Map<String, String> country : countrys) {
					String code = country.get("code");
					String sendDate = (String) editRow.get(code + "_date");
					Object send = editRow.get(code + "_isSend");
					if (sendDate != null && send == null) {
						PartToSendLink link = PartToSendLink.newPartToSendLink();
						String name = country.get("name");
						link.setNation(code);
						link.setPart(part);
						link.setEcn(ecn);
						link.setIsSend(true);
						link.setSendDate(DateUtil.convertDate(sendDate));
						PersistenceHelper.manager.save(link);

						WTUser sessionUser = CommonUtil.sessionUser();
						System.out.println("전송된 ECN = " + ecn.getEoNumber() + ", 자재번호 = " + part.getNumber()
								+ ", 확정인허가일 = " + sendDate + ", 국가 = " + name + "(" + code + ")");

						String v = part.getVersionIdentifier().getSeries().getValue();
						insertTable.insertRow(idx);
						insertTable.setValue("ECNNO", ecn.getEoNumber());
						insertTable.setValue("MATNR", part.getNumber());
						insertTable.setValue("ZEIVR", part.getVersionIdentifier().getSeries().getValue());
						insertTable.setValue("CNTRY", code);
						insertTable.setValue("APRDT", sendDate.toString().substring(0, 10).replaceAll("-", ""));
						insertTable.setValue("ENNAM", ecn.getCreatorFullName());
						insertTable.setValue("ENDAT",
								ecn.getCreateTimestamp().toString().substring(0, 10).replaceAll("-", ""));
						insertTable.setValue("TRNAM", sessionUser.getFullName());

//						insertTable.setValue("",v);
						idx++;
					}
				}
			}
			function.execute(destination);
			JCoParameterList result = function.getExportParameterList();
			Object r_type = result.getValue("EV_STATUS");
			Object r_msg = result.getValue("EV_MESSAGE");
			System.out.println("[ SAP JCO ] RETURN - TYPE:" + r_type);
			System.out.println("[ SAP JCO ] RETURN - MESSAGE:" + r_msg);
			System.out.println("종료 SAP 인터페이스 - ECN 확정인허가일 FUN : ZPPIF_PDM_003");
			trs.commit();
			trs = null;
		} catch (Exception e) {
			e.printStackTrace();
			trs.rollback();
			throw e;
		} finally {
			if (trs != null)
				trs.rollback();
		}

		System.out.println("ECN SAP SEND END!!");
	}
}
