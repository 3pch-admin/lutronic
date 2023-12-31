package com.e3ps.drawing.beans;

import java.util.HashMap;
import java.util.Map;

import com.e3ps.common.util.AUIGridUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.util.ThumbnailUtil;
import com.e3ps.drawing.service.DrawingHelper;
import com.e3ps.part.service.PartHelper;
import com.ptc.wvs.server.util.PublishUtils;

import lombok.Getter;
import lombok.Setter;
import wt.content.ApplicationData;
import wt.content.ContentHelper;
import wt.content.ContentRoleType;
import wt.enterprise.BasicTemplateProcessor;
import wt.epm.EPMDocument;
import wt.epm.EPMDocumentMaster;
import wt.fc.QueryResult;
import wt.lifecycle.State;
import wt.part.WTPart;
import wt.representation.Representation;
import wt.util.FileUtil;

@Getter
@Setter
public class EpmData {

//	public EPMDocument epm;
	public String oid; // 도면번호
	public String name; // 도면번호
	public String number; // 도면번호
	public String linkRefernceType;
	public String icon;
	public String cadType;
	public String creator;
	private String modifier;
	public String createDate;
	public String modifyDate;
	public boolean isNameSyschronization = true;
	public boolean isUpdate = false;
	public boolean isLatest = false;
	public String location;
	public String state;
	private String stateDisplay;
	public String cadName;
	public String pNum;
	public String applicationType;
	private String version;
	private String description;

	private Map<String, String> pdf = new HashMap<>();
	private Map<String, String> dxf = new HashMap<>();
	private Map<String, String> step = new HashMap<>();

	public EpmData(EPMDocument epm) throws Exception {
		setOid(CommonUtil.getOIDString(epm));
		setName(epm.getName());
		setNumber(epm.getNumber());
		setIcon(BasicTemplateProcessor.getObjectIconImgTag(epm));
		setCadType(epm.getDocType().toString());
		setCreator(epm.getCreatorFullName());
		setModifier(epm.getModifierFullName());
		setCreateDate(epm.getCreateTimestamp().toString().substring(0, 10));
		setModifyDate(epm.getModifyTimestamp().toString().substring(0, 10));
		// true이면 동기화 버튼 활성화, false 이면 비활성
		boolean isDRW = epm.getDocType().toString().equals("CADDRAWING");
		if (!isDRW) {
			setNameSyschronization(false);
		}
		// 수정 가능여부
		boolean wgm = false;
		wgm = epm.getOwnerApplication().toString().equals("EPM") ? true : false;
		if ((State.INWORK).equals(epm.getLifeCycleState()) && CommonUtil.isLatestVersion(epm) && !wgm) {
			setUpdate(true);
		}
		// 최신객체여부
//		setLatest(CommonUtil.isLatestVersion(epm));

		setLocation(StringUtil.checkNull(epm.getLocation()).replaceAll("/Default", ""));
		setState(epm.getLifeCycleState().toString());
		setStateDisplay(epm.getLifeCycleState().getDisplay());
		EPMDocumentMaster master = (EPMDocumentMaster) epm.getMaster();
		String cadName = master.getCADName();
		setCadName(cadName);
//		setAttach(epm);
		WTPart part = null;
		// Creo의 드로잉은 경우 3D의 WTPArt
		if (EpmUtil.isCreoDrawing(epm)) {
			String number = epm.getNumber();
			String version = epm.getVersionIdentifier().getValue();
			number = EpmUtil.getFileNameNonExtension(number);
			part = PartHelper.manager.getPart(number, version);
		} else {
			part = DrawingHelper.service.getWTPart(epm);
		}

		// 연관 파트 번호
		if (part == null) {
			part = getDrawingPart(part);
		}
		if (part != null) {
			pNum = part.getNumber();
		}
		setPNum(StringUtil.checkNull(pNum));

		setApplicationType(epm.getOwnerApplication().toString());
		setVersion(epm.getVersionIdentifier().getValue() + "." + epm.getIterationIdentifier().getValue());
		// 삭제, 수정 권한 - (최신버전 && ( 임시저장 || 작업중 || 일괄결재중 || 재작업))
		if (isLatest() && (getState().equals("INWORK") || getState().equals("TEMPRARY")
				|| getState().equals("BATCHAPPROVAL") || getState().equals("REWORK"))) {
			setUpdate(true);
		}
		setDescription(StringUtil.checkNull(epm.getDescription()));
		setRepresentable(epm);
	}

	// 연관 파트 번호
	public String getpNum(WTPart part) {
		String pNum = "";
		try {
			if (part == null) {
				part = getDrawingPart(part);
			}

			if (part != null) {
				pNum = part.getNumber();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return pNum;
	}

	public WTPart getDrawingPart(WTPart part) {

		try {

			return part;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private void setRepresentable(EPMDocument epm) throws Exception {
		Representation _representation = PublishUtils.getRepresentation(epm);
		if (_representation != null) {
			// step
			QueryResult qr = ContentHelper.service.getContentsByRole(_representation, ContentRoleType.SECONDARY);
			while (qr.hasMoreElements()) {
				ApplicationData data = (ApplicationData) qr.nextElement();
				String ext = FileUtil.getExtension(data.getFileName());
				if ("stp".equalsIgnoreCase(ext)) {
					this.step.put("name", data.getFileName());
					this.step.put("fileSizeKB", data.getFileSizeKB() + "KB");
					this.step.put("url",
							ContentHelper.getDownloadURL(_representation, data, false, data.getFileName()).toString());
				}
			}
		}

		EPMDocument epm2d = PartHelper.manager.getEPMDocument2D(epm);
		if (epm2d != null) {
			Representation representation = PublishUtils.getRepresentation(epm2d);
			if (representation != null) {
				QueryResult result = ContentHelper.service.getContentsByRole(representation, ContentRoleType.SECONDARY);
				while (result.hasMoreElements()) {
					ApplicationData data = (ApplicationData) result.nextElement();
					String ext = FileUtil.getExtension(data.getFileName());
					if ("dxf".equalsIgnoreCase(ext)) {
						this.dxf.put("name", data.getFileName());
						this.dxf.put("fileSizeKB", data.getFileSizeKB() + "KB");
						this.dxf.put("url", ContentHelper
								.getDownloadURL(representation, data, false, data.getFileName()).toString());
					}
				}

				result.reset();
				result = ContentHelper.service.getContentsByRole(representation, ContentRoleType.ADDITIONAL_FILES);
				if (result.hasMoreElements()) {
					ApplicationData data = (ApplicationData) result.nextElement();
					String ext = FileUtil.getExtension(data.getFileName());
					if ("pdf".equalsIgnoreCase(ext)) {
						this.pdf.put("name", data.getFileName());
						this.pdf.put("fileSizeKB", data.getFileSizeKB() + "KB");
						this.pdf.put("url", ContentHelper
								.getDownloadURL(representation, data, false, data.getFileName()).toString());
					}
				}
			}
		}
	}
}