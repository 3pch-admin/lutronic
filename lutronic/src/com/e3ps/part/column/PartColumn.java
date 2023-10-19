package com.e3ps.part.column;

import java.sql.Timestamp;

import com.e3ps.common.iba.AttributeKey;
import com.e3ps.common.iba.IBAUtil;
import com.e3ps.common.util.AUIGridUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.ThumbnailUtil;
import com.e3ps.drawing.beans.EpmData;
import com.e3ps.drawing.service.EpmSearchHelper;
import com.e3ps.part.service.PartHelper;
import com.e3ps.part.service.PartSearchHelper;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;
import wt.epm.EPMDocument;
import wt.epm.EPMDocumentMaster;
import wt.epm.build.EPMBuildRule;
import wt.part.WTPart;
import wt.vc.VersionControlHelper;

@Getter
@Setter
public class PartColumn {

	private boolean latest = false;
	private String part_oid; // 부품
	private String epm_oid; // 3D
	private String drawing_oid; // 2D
	private String _3d;
	private String _2d;
	private String number;
	private String name;
	private String location;
	private String version;
	private String remarks;
	private String state;
	private String creator;
	private String modifier;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp createdDate;
	private String createdDate_txt;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp modifiedDate;
	private String modifiedDate_txt;
	private String ecoNo;
	private String pdf;
	private String step;
	private String dxf;
	private String dwgNo;
	private String dwgOid;
	private String quantity = "1";

	public PartColumn() {

	}

	public PartColumn(Object[] obj) throws Exception {
		this((WTPart) obj[0]);
	}

	public PartColumn(WTPart part) throws Exception {
		setLatest(CommonUtil.isLatestVersion(part));
		setPart_oid(part.getPersistInfo().getObjectIdentifier().getStringValue());
		set_3d(ThumbnailUtil.thumbnailSmall(part));
		setNumber(part.getNumber());
		setName(part.getName());
		setLocation(part.getLocation());
		setVersion(setVersionInfo(part));
		setRemarks(IBAUtil.getAttrValue(part, AttributeKey.IBAKey.IBA_REMARKS));
		setState(part.getLifeCycleState().getDisplay());
		setCreator(part.getCreatorName());
		setCreatedDate(part.getCreateTimestamp());
		setCreatedDate_txt(part.getCreateTimestamp().toString().substring(0, 10));
		setModifier(part.getModifierName());
		setModifiedDate(part.getModifyTimestamp());
		setModifiedDate_txt(part.getModifyTimestamp().toString().substring(0, 10));
		setAttach(part);
		setDwgNoFn(part);
		setQuantity(quantity);
	}

	/**
	 * 최신버건과 함께 표시
	 */
	private String setVersionInfo(WTPart part) throws Exception {
		WTPart latest = PartHelper.manager.latest(getPart_oid());
		String version = VersionControlHelper.getVersionDisplayIdentifier(part) + "."
				+ part.getIterationIdentifier().getSeries().getValue();
		String latest_version = latest.getVersionIdentifier().getSeries().getValue() + "."
				+ latest.getIterationIdentifier().getSeries().getValue();
		if (isLatest()) {
			return version;
		} else {
			return version + " <b><font color='red'>(" + latest_version + ")</font></b>";
		}
	}

	private void setAttach(WTPart part) throws Exception {
		EPMDocument epm = PartHelper.manager.getEPMDocument(part);
		// 3D 캐드 세팅..
		if (epm != null) {
			setStep(AUIGridUtil.step(epm));
			EPMDocument epm2D = PartHelper.manager.getEPMDocument2D(epm);
			if (epm2D != null) {
				set_2d(ThumbnailUtil.thumbnailSmall(epm2D));
				setPdf(AUIGridUtil.pdf(epm2D));
				setDxf(AUIGridUtil.dxf(epm2D));
			}
		}
	}

	public void setDwgNoFn(WTPart part) {
		boolean isDwg = false;
		try {
			EPMBuildRule buildRule = PartSearchHelper.service.getBuildRule(part);
			if (buildRule != null) {
				EPMDocument epm = (EPMDocument) buildRule.getBuildSource();
				EPMDocument epm2D = EpmSearchHelper.service.getEPM2D((EPMDocumentMaster) epm.getMaster());
				// System.out.println("check 1"+(null != epm2D));
				if (epm2D != null) {
					setDwgNo(epm2D.getNumber());
					setDwgOid(CommonUtil.getOIDString(epm2D));
				} else {
					isDwg = true;
					if (epm != null) {

//						EpmData epmData = new EpmData(epm);
						String appType = epm.getOwnerApplication().toString();
						if ("MANUAL".equals(appType)) {
							setDwgNo(epm.getNumber());
							setDwgOid(CommonUtil.getOIDString(epm));
							isDwg = false;
						}
					}
				}

			} else {
				isDwg = true;
			}

			if (isDwg) {
				boolean isAP = PartSearchHelper.service.isHasDocumentType(part, "$$APDocument");
				if (isAP) {
					setDwgNo("AP");
					setDwgOid(PartSearchHelper.service.getHasDocumentOid(part, "$$APDocument"));
				} else {
					setDwgNo("ND");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			setDwgNo("");
		}

	}

}
