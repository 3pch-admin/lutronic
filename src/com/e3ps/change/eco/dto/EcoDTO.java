package com.e3ps.change.eco.dto;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashMap;
import java.util.HashMap;
import java.util.Map;

import com.e3ps.change.EChangeOrder;
import com.e3ps.change.eco.service.EcoHelper;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.ContentUtils;
import com.e3ps.common.util.StringUtil;
import com.e3ps.org.service.MailUserHelper;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EcoDTO {

	private String oid;
	private String name;
	private String number;
	private String state;
	private String creator;
	private String sendType;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp createdDate;
	private String createdDate_txt;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp modifiedDate;
	private String modifiedDate_text;
	private String eoCommentA;
	private String eoCommentB;
	private String eoCommentC;
	private String eoCommentD;
	private String licensing;
	private String riskType;
	private String licensing_name;
	private String riskType_name;
	private String eoType;
	private String approveDate = "";
	private String model_name;

	// auth
	private boolean _modify = false;
	private boolean _delete = false;

	// 변수용
	private String primary;
	private ArrayList<String> secondarys = new ArrayList<>();
	private ArrayList<Map<String, String>> rows101 = new ArrayList<>(); // 관련 CR
	private ArrayList<Map<String, String>> rows200 = new ArrayList<>(); // 설변활동
	private ArrayList<Map<String, String>> rows500 = new ArrayList<>(); // 대상품목

	private Map<String, Object> contentMap = null;

	private boolean temprary;

	public EcoDTO() {

	}

	public EcoDTO(String oid) throws Exception {
		this((EChangeOrder) CommonUtil.getObject(oid));
	}

	public EcoDTO(EChangeOrder eco) throws Exception {
		setOid(eco.getPersistInfo().getObjectIdentifier().getStringValue());
		setName(eco.getEoName());
		setNumber(eco.getEoNumber());
		setSendType(eco.getSendType());
		setState(eco.getLifeCycleState().getDisplay());
		setCreator(eco.getCreatorFullName());
		setCreatedDate(eco.getCreateTimestamp());
		setCreatedDate_txt(eco.getCreateTimestamp().toString().substring(0, 10));
		setModifiedDate(eco.getModifyTimestamp());
		setModifiedDate_text(eco.getModifyTimestamp().toString().substring(0, 10));
		setEoCommentA(StringUtil.checkNull(eco.getEoCommentA()));
		setEoCommentB(StringUtil.checkNull(eco.getEoCommentB()));
		setEoCommentC(StringUtil.checkNull(eco.getEoCommentC()));
		setEoCommentD(StringUtil.checkNull(eco.getEoCommentD()));
		setLicensing(eco.getLicensingChange());
		setLicensing_name(licensing(eco.getLicensingChange()));
		setRiskType_name(risk(eco.getRiskType()));
		setRiskType(eco.getRiskType());
		setEoType(eco.getEoType());
		setApproveDate(StringUtil.checkNull(eco.getEoApproveDate()));
		if (eco.getModel() != null) {
			setModel_name(EcoHelper.manager.displayToModel(eco.getModel()));
		}
		setContentMap(ContentUtils.getContentByRole(eco, "ECO"));
		setAuth(eco);
	}

	/**
	 * 위험통제 디스플레이
	 */
	private String risk(String s) throws Exception {
		if ("NONE".equals(s)) {
			return "N/A";
		} else if ("0".equals(s)) {
			return "불필요";
		} else if ("1".equals(s)) {
			return "필요";
		}
		return "";
	}

	/**
	 * 인허가 디스플레이
	 */
	private String licensing(String s) throws Exception {
		if ("NONE".equals(s)) {
			return "N/A";
		} else if ("LI002".equals(s)) {
			return "불필요";
		} else if ("LI001".equals(s)) {
			return "필요";
		}
		return "";
	}

	/**
	 * 권한 설정
	 */
	private void setAuth(EChangeOrder eco) throws Exception {
		boolean isAdmin = CommonUtil.isAdmin();
		if (check(eco, "LINE_REGISTER") || (check(eco, "ACTIVITY")) || isAdmin) {
			set_modify(true);
		}
		if (isAdmin) {
			set_delete(true);
		}
	}

	/**
	 * 상태값 여부 체크
	 */
	private boolean check(EChangeOrder eco, String state) throws Exception {
		boolean check = false;
		String compare = eco.getLifeCycleState().toString();
		if (compare.equals(state)) {
			check = true;
		}
		return check;
	}
}
