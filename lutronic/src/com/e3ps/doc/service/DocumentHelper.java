package com.e3ps.doc.service;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.e3ps.change.EChangeOrder;
import com.e3ps.change.EChangeRequest;
import com.e3ps.change.cr.column.CrColumn;
import com.e3ps.change.eco.column.EcoColumn;
import com.e3ps.change.eo.column.EoColumn;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.util.AUIGridUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.FolderUtils;
import com.e3ps.common.util.PageQueryUtils;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.util.WCUtil;
import com.e3ps.development.devActive;
import com.e3ps.development.devOutPutLink;
import com.e3ps.doc.DocumentCRLink;
import com.e3ps.doc.DocumentECOLink;
import com.e3ps.doc.DocumentEOLink;
import com.e3ps.doc.DocumentToDocumentLink;
import com.e3ps.doc.column.DocumentColumn;
import com.e3ps.doc.dto.DocumentDTO;
import com.e3ps.groupware.workprocess.AsmApproval;
import com.e3ps.groupware.workprocess.service.AsmSearchHelper;
import com.e3ps.part.column.PartColumn;

import net.sf.json.JSONArray;
import wt.clients.folder.FolderTaskLogic;
import wt.doc.DocumentType;
import wt.doc.WTDocument;
import wt.doc.WTDocumentMaster;
import wt.fc.PagingQueryResult;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.folder.Folder;
import wt.folder.FolderHelper;
import wt.folder.IteratedFolderMemberLink;
import wt.folder.SubFolder;
import wt.part.WTPart;
import wt.part.WTPartDescribeLink;
import wt.query.ClassAttribute;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.services.ServiceFactory;
import wt.util.WTAttributeNameIfc;
import wt.vc.VersionControlHelper;
import wt.vc.config.ConfigHelper;
import wt.vc.config.LatestConfigSpec;

public class DocumentHelper {

	/**
	 * 문서 기본 위치
	 */
	public static final String DOCUMENT_ROOT = "/Default/문서";

	public static final DocumentService service = ServiceFactory.getService(DocumentService.class);
	public static final DocumentHelper manager = new DocumentHelper();

	/**
	 * 문서 검색
	 */
	public Map<String, Object> list(Map<String, Object> params) throws Exception {
		Map<String, Object> map = new HashMap<>();
		ArrayList<DocumentColumn> list = new ArrayList<>();

		boolean latest = (boolean) params.get("latest");
		String location = (String) params.get("location");
		String name = (String) params.get("name");
		String number = (String) params.get("number");
		String creatorOid = (String) params.get("creatorOid");
		String state = (String) params.get("state");
		String createdFrom = (String) params.get("createdFrom");
		String createdTo = (String) params.get("createdTo");
		String modifiedFrom = (String) params.get("modifiedFrom");
		String modifiedTo = (String) params.get("modifiedTo");

		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(WTDocument.class, true);
		int idx_m = query.appendClassList(WTDocumentMaster.class, false);

		query.setAdvancedQueryEnabled(true);
		query.setDescendantQuery(false);

		QuerySpecUtils.toInnerJoin(query, WTDocument.class, WTDocumentMaster.class, "masterReference.key.id",
				WTAttributeNameIfc.ID_NAME, idx, idx_m);

		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.NAME, name);
		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.NUMBER, number);
//		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.DESCRIPTION, description);
		QuerySpecUtils.toState(query, idx, WTDocument.class, state);
		QuerySpecUtils.creatorQuery(query, idx, WTDocument.class, creatorOid);
		QuerySpecUtils.toTimeGreaterAndLess(query, idx, WTDocument.class, WTDocument.CREATE_TIMESTAMP, createdFrom,
				createdTo);
		QuerySpecUtils.toTimeGreaterAndLess(query, idx, WTDocument.class, WTDocument.CREATE_TIMESTAMP, modifiedFrom,
				modifiedTo);

		Folder folder = FolderTaskLogic.getFolder(location, WCUtil.getWTContainerRef());
		if (query.getConditionCount() > 0) {
			query.appendAnd();
		}
		int f_idx = query.appendClassList(IteratedFolderMemberLink.class, false);
		ClassAttribute fca = new ClassAttribute(IteratedFolderMemberLink.class, "roleBObjectRef.key.branchId");
		SearchCondition fsc = new SearchCondition(fca, "=",
				new ClassAttribute(WTDocument.class, "iterationInfo.branchId"));
		fsc.setFromIndicies(new int[] { f_idx, idx }, 0);
		fsc.setOuterJoin(0);
		query.appendWhere(fsc, new int[] { f_idx, idx });
		query.appendAnd();

		query.appendOpenParen();
		long fid = folder.getPersistInfo().getObjectIdentifier().getId();
		query.appendWhere(new SearchCondition(IteratedFolderMemberLink.class, "roleAObjectRef.key.id", "=", fid),
				new int[] { f_idx });

		ArrayList<Folder> folders = FolderUtils.getSubFolders(folder, new ArrayList<Folder>());
		for (int i = 0; i < folders.size(); i++) {
			Folder sub = (Folder) folders.get(i);
			query.appendOr();
			long sfid = sub.getPersistInfo().getObjectIdentifier().getId();
			query.appendWhere(new SearchCondition(IteratedFolderMemberLink.class, "roleAObjectRef.key.id", "=", sfid),
					new int[] { f_idx });
		}
		query.appendCloseParen();

		// 최신 이터레이션.
		if (latest) {
			QuerySpecUtils.toLatest(query, idx, WTDocument.class);
		}

		QuerySpecUtils.toOrderBy(query, idx, WTDocument.class, WTDocument.MODIFY_TIMESTAMP, true);

		PageQueryUtils pager = new PageQueryUtils(params, query);
		PagingQueryResult result = pager.find();
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			DocumentColumn data = new DocumentColumn(obj);
			list.add(data);
		}

		map.put("list", list);
		map.put("topListCount", pager.getTotal());
		map.put("pageSize", pager.getPsize());
		map.put("total", pager.getTotalSize());
		map.put("sessionid", pager.getSessionId());
		map.put("curPage", pager.getCpage());
		return map;
	}

	/**
	 * 문서 관련 객체
	 */
	public JSONArray reference(String oid, String type) throws Exception {
		ArrayList<Map<String, Object>> list = new ArrayList<>();
		WTDocument doc = (WTDocument) CommonUtil.getObject(oid);
		if ("doc".equalsIgnoreCase(type)) {
			// 문서
			return JSONArray.fromObject(referenceDoc(doc, list));
		} else if ("part".equalsIgnoreCase(type)) {
			// PART
			return JSONArray.fromObject(referencePart(doc, list));
		} else if ("eo".equalsIgnoreCase(type)) {
			// EO
			return JSONArray.fromObject(referenceEo(doc, list));
		} else if ("eco".equalsIgnoreCase(type)) {
			// ECO
			return JSONArray.fromObject(referenceEco(doc, list));
		} else if ("cr".equalsIgnoreCase(type)) {
			// CR
			return JSONArray.fromObject(referenceCr(doc, list));
		} else if ("ecpr".equalsIgnoreCase(type)) {
			// ECPR
//			return JSONArray.fromObject(referenceEcpr(doc, list));
		}
		return JSONArray.fromObject(list);
	}

	/**
	 * 관련 문서
	 */
	private Object referenceDoc(WTDocument doc, ArrayList<Map<String, Object>> list) throws Exception {

		QueryResult result = PersistenceHelper.manager.navigate(doc, "useBy", DocumentToDocumentLink.class);
		while (result.hasMoreElements()) {
			WTDocument ref = (WTDocument) result.nextElement();
			DocumentColumn dto = new DocumentColumn(ref);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}

	/**
	 * 관련 ECPR
	 */
	private Object referenceEcpr(WTDocument doc, ArrayList<Map<String, Object>> list) throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(doc, "describes", WTPartDescribeLink.class);
		while (result.hasMoreElements()) {
			WTPart part = (WTPart) result.nextElement();
			Map<String, Object> map = new HashMap<>();
			PartColumn dto = new PartColumn(part);
			map.put("part_oid", dto.getPart_oid());
			map.put("_3d", dto.get_3d());
			map.put("_2d", dto.get_2d());
			map.put("number", dto.getNumber());
			map.put("name", dto.getName());
			map.put("version", dto.getVersion());
			map.put("creator", dto.getCreator());
			map.put("createdDate", dto.getCreatedDate().toString().substring(0, 10));
			list.add(map);
		}
		return list;
	}

	/**
	 * 관련 CR
	 */
	private Object referenceCr(WTDocument doc, ArrayList<Map<String, Object>> list) throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(doc, "cr", DocumentCRLink.class);
		while (result.hasMoreElements()) {
			EChangeRequest cr = (EChangeRequest) result.nextElement();
			CrColumn dto = new CrColumn(cr);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}

	/**
	 * 관련 ECO
	 */
	private Object referenceEco(WTDocument doc, ArrayList<Map<String, Object>> list) throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(doc, "eco", DocumentECOLink.class);
		while (result.hasMoreElements()) {
			EChangeOrder eco = (EChangeOrder) result.nextElement();
			EcoColumn dto = new EcoColumn(eco);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}

	/**
	 * 관련 EO
	 */
	private Object referenceEo(WTDocument doc, ArrayList<Map<String, Object>> list) throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(doc, "eo", DocumentEOLink.class);
		while (result.hasMoreElements()) {
			EChangeOrder eo = (EChangeOrder) result.nextElement();
			EoColumn dto = new EoColumn(eo);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}

	/**
	 * 관련 품목
	 */
	private ArrayList<Map<String, Object>> referencePart(WTDocument doc, ArrayList<Map<String, Object>> list)
			throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(doc, "describes", WTPartDescribeLink.class);
		while (result.hasMoreElements()) {
			WTPart part = (WTPart) result.nextElement();
			PartColumn dto = new PartColumn(part);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}

	/**
	 * 문서 이력
	 */
	public JSONArray allIterationsOf(String oid) throws Exception {
		ArrayList<Map<String, String>> list = new ArrayList<>();
		WTDocument doc = (WTDocument) CommonUtil.getObject(oid);
		QueryResult result = VersionControlHelper.service.allIterationsOf(doc.getMaster());
		while (result.hasMoreElements()) {
			WTDocument d = (WTDocument) result.nextElement();
			Map<String, String> map = new HashMap<>();
			DocumentColumn dto = new DocumentColumn(d);
			map.put("oid", dto.getOid());
			map.put("name", dto.getName());
			map.put("number", dto.getNumber());
			map.put("version", dto.getVersion());
			map.put("creator", dto.getCreator());
			map.put("createdDate", dto.getCreatedDate_txt());
			map.put("modifier", dto.getModifier());
			map.put("modifiedDate", dto.getModifiedDate_txt());
			map.put("note", d.getIterationNote());
			map.put("primary", dto.getPrimary());
			map.put("secondary", dto.getSecondary());
			list.add(map);
		}
		return JSONArray.fromObject(list);
	}

	/**
	 * 문서 링크 관계 확인 ( true : 연결, false : 미연결 )
	 */
	public boolean isConnect(String oid, Class<?> target) throws Exception {
		WTDocument doc = (WTDocument) CommonUtil.getObject(oid);
		return isConnect(doc, target);
	}

	/**
	 * 문서 링크 관계 확인 ( true : 연결, false : 미연결 )
	 */
	public boolean isConnect(WTDocument doc, Class<?> target) throws Exception {
		boolean isConnect = false;

		if (target.equals(DocumentEOLink.class)) {
			QueryResult qr = PersistenceHelper.manager.navigate(doc, "eo", DocumentEOLink.class);
			isConnect = qr.size() > 0;
		} else if (target.equals(DocumentECOLink.class)) {
			QueryResult qr = PersistenceHelper.manager.navigate(doc, "eco", DocumentECOLink.class);
			isConnect = qr.size() > 0;
//		} else if (target.equals(DocumentECPRLink.class)) {
//			QueryResult qr = PersistenceHelper.manager.navigate(doc, "ecpr", DocumentECPRLink.class);
//			isConnect = qr.size() > 0;
		} else if (target.equals(DocumentCRLink.class)) {
			QueryResult qr = PersistenceHelper.manager.navigate(doc, "cr", DocumentCRLink.class);
			isConnect = qr.size() > 0;
		} else if (target.equals(WTPartDescribeLink.class)) {
			QueryResult qr = PersistenceHelper.manager.navigate(doc, "describes", WTPartDescribeLink.class);
			isConnect = qr.size() > 0;
		}
		return isConnect;
	}

	/**
	 * 최신버전 문서
	 */
	public WTDocument latest(String oid) throws Exception {
		WTDocument doc = (WTDocument) CommonUtil.getObject(oid);
		LatestConfigSpec config = new LatestConfigSpec();
		QueryResult result = ConfigHelper.service.filteredIterationsOf(doc.getMaster(), config);
		if (result.hasMoreElements()) {
			WTDocument latest = (WTDocument) result.nextElement();
			return latest;
		}
		return null;
	}

	/**
	 * 문서 폴더 가져오기
	 */
	public JSONArray recurcive() throws Exception {
		ArrayList<String> list = new ArrayList<>();
		Folder root = FolderTaskLogic.getFolder(DOCUMENT_ROOT, WCUtil.getWTContainerRef());
		Enumeration result = FolderTaskLogic.getSubFolders(root);
		while (result.hasMoreElements()) {
			Folder folder = (Folder) result.nextElement();
			list.add(folder.getFolderPath());
			recurcive(folder, list);
		}
		return JSONArray.fromObject(list);
	}

	/**
	 * 문서 폴더 가져오기 재귀함수
	 */
	private void recurcive(Folder parent, ArrayList<String> list) throws Exception {
		QueryResult result = FolderHelper.service.findSubFolders(parent);
		while (result.hasMoreElements()) {
			SubFolder folder = (SubFolder) result.nextElement();
			list.add(folder.getFolderPath());
			recurcive(folder, list);
		}
	}

	/**
	 * 문서 타입 JSON - AUI그리드용 - 금형 문서 포함 제외 여부 true, 포함, fasle 제외
	 *
	 */
	public JSONArray toJson() throws Exception {
		return toJson(false);
	}

	/**
	 * 문서 타입 JSON - AUI그리드용 - 금형 문서 포함 제외 여부
	 */
	public JSONArray toJson(boolean include) throws Exception {
		ArrayList<Map<String, String>> list = new ArrayList<>();
		DocumentType[] dlist = DocumentType.getDocumentTypeSet();
		for (DocumentType t : dlist) {
			Map<String, String> map = new HashMap<>();
			if (!include) {
				if (t.toString().equals("$$MMDocument")) {
					continue;
				}
			}
			map.put("key", t.toString());
			map.put("value", t.getDisplay());
			list.add(map);
		}
		return JSONArray.fromObject(list);
	}

	public JSONArray include_DocumentList(String oid, String moduleType) throws Exception {
		ArrayList<Map<String, Object>> list = new ArrayList<>();
		try {
			if (StringUtil.checkString(oid)) {
				if ("part".equals(moduleType)) {
					WTPart part = (WTPart) CommonUtil.getObject(oid);
					QueryResult qr = PersistenceHelper.manager.navigate(part, "describedBy", WTPartDescribeLink.class);
					while (qr.hasMoreElements()) {
						WTDocument doc = (WTDocument) qr.nextElement();
						DocumentDTO data = new DocumentDTO(doc);
						// Part가 최신 버전이면 관련 문서가 최신 버전만 ,Part가 최신 버전이 아니면 모든 버전
						if (CommonUtil.isLatestVersion(part)) {
							if (data.isLatest()) {
								Map<String, Object> map = new HashMap<>();
								map.put("number", data.getNumber());
								map.put("name", data.getName());
								map.put("version", data.getVersion());
								map.put("creator", data.getCreator());
								map.put("createdDate", data.getCreatedDate());
								list.add(map);
							}
						} else {
							Map<String, Object> map = new HashMap<>();
							map.put("number", data.getNumber());
							map.put("name", data.getName());
							map.put("version", data.getVersion());
							map.put("creator", data.getCreator());
							map.put("createdDate", data.getCreatedDate());
							list.add(map);
						}
					}
				} else if ("doc".equals(moduleType)) {
					List<DocumentDTO> dataList = DocumentQueryHelper.service.getDocumentListToLinkRoleName(oid, "used");
					for (DocumentDTO data : dataList) {
						Map<String, Object> map = new HashMap<>();
						map.put("number", data.getNumber());
						map.put("name", data.getName());
						map.put("version", data.getVersion());
						map.put("creator", data.getCreator());
						map.put("createdDate", data.getCreatedDate());
						list.add(map);
					}

					dataList = DocumentQueryHelper.service.getDocumentListToLinkRoleName(oid, "useBy");
					for (DocumentDTO data : dataList) {
						Map<String, Object> map = new HashMap<>();
						map.put("number", data.getNumber());
						map.put("name", data.getName());
						map.put("version", data.getVersion());
						map.put("creator", data.getCreator());
						map.put("createdDate", data.getCreatedDate());
						list.add(map);
					}

				} else if ("active".equals(moduleType)) {
					devActive m = (devActive) CommonUtil.getObject(oid);
					QueryResult qr = PersistenceHelper.manager.navigate(m, "output", devOutPutLink.class);

					while (qr.hasMoreElements()) {
						Object p = (Object) qr.nextElement();
						if (p instanceof WTDocument) {
							DocumentDTO data = new DocumentDTO((WTDocument) p);
							Map<String, Object> map = new HashMap<>();
							map.put("number", data.getNumber());
							map.put("name", data.getName());
							map.put("version", data.getVersion());
							map.put("creator", data.getCreator());
							map.put("createdDate", data.getCreatedDate());
							list.add(map);
						}
					}
				} else if ("asm".equals(moduleType)) {
					AsmApproval asm = (AsmApproval) CommonUtil.getObject(oid);
					List<WTDocument> aList = AsmSearchHelper.service.getObjectForAsmApproval(asm);
					for (WTDocument doc : aList) {
						DocumentDTO data = new DocumentDTO(doc);
						Map<String, Object> map = new HashMap<>();
						map.put("number", data.getNumber());
						map.put("name", data.getName());
						map.put("version", data.getVersion());
						map.put("creator", data.getCreator());
						map.put("createdDate", data.getCreatedDate());
						list.add(map);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return JSONArray.fromObject(list);
	}

	/**
	 * 문서 종류 바인더
	 */
	public ArrayList<Map<String, String>> finder(Map<String, String> params) throws Exception {
		ArrayList<Map<String, String>> list = new ArrayList<Map<String, String>>();
		String value = params.get("value");

		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(NumberCode.class, true);
		QuerySpecUtils.toEqualsAnd(query, idx, NumberCode.class, NumberCode.CODE_TYPE, "DOCUMENTNAME");
		QuerySpecUtils.toLikeAnd(query, idx, NumberCode.class, NumberCode.NAME, value);
		QuerySpecUtils.toOrderBy(query, idx, NumberCode.class, NumberCode.NAME, false);
		QueryResult result = PersistenceHelper.manager.find(query);
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			NumberCode n = (NumberCode) obj[0];
			Map<String, String> map = new HashMap<>();
			map.put("value", n.getName());
			map.put("name", n.getName());
			list.add(map);
		}
		return list;
	}
}
