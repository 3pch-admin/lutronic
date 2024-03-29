package com.e3ps.change.ecrm.dto;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Map;

import com.e3ps.change.ECPRRequest;
import com.e3ps.change.ECRMRequest;
import com.e3ps.change.EChangeRequest;
import com.e3ps.change.cr.service.CrHelper;
import com.e3ps.change.ecpr.service.EcprHelper;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.code.service.NumberCodeHelper;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.StringUtil;
import com.e3ps.org.service.MailUserHelper;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;
import wt.session.SessionHelper;

@Getter
@Setter
public class EcrmDTO {
	private String oid;
	private String name;
	private String number;
	private String createdDate;
	private String approveDate;
	private String createDepart_name;
	private String primary;
	private String changeSection;
	private String eoCommentA;
	private String eoCommentB;
	private String eoCommentC;
	private String writer;
	private String contents;
	private String period_name;
	private String period_code;

	// 따로 추가
	private String state;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp modifiedDate;
	private String modifiedDate_text;
	private String creator;
	private String createDepart;
	private String writeDate;
	private String changeCode;
	private String model;

	private ECPRRequest ecpr;
	// auth
	private boolean _modify = false;
	private boolean _delete = false;
	private boolean _withdraw = false;
	private boolean _print = false;

	private boolean _isNew = false;

	// 변수용
	private ArrayList<String> sections = new ArrayList<String>(); // 변경 구분
	private ArrayList<String> secondarys = new ArrayList<>();
	private ArrayList<Map<String, String>> rows101 = new ArrayList<>(); // 관련 CR
	private ArrayList<Map<String, String>> rows90 = new ArrayList<>(); // 관련 문서
	private ArrayList<Map<String, String>> rows105 = new ArrayList<>(); // 관련 CR
	private ArrayList<Map<String, String>> rows300 = new ArrayList<>(); // 모델

	private boolean temprary;

	public EcrmDTO() {

	}

	public EcrmDTO(String oid) throws Exception {
		this((ECRMRequest) CommonUtil.getObject(oid));
	}

	public EcrmDTO(ECRMRequest ecrm) throws Exception {
		setOid(ecrm.getPersistInfo().getObjectIdentifier().getStringValue());
		setName(StringUtil.checkNull(ecrm.getEoName()));
		setNumber(StringUtil.checkNull(ecrm.getEoNumber()));
		setApproveDate(StringUtil.checkNull(ecrm.getApproveDate()));
		setCreateDepart_name(EcprHelper.manager.displayToDept(ecrm.getCreateDepart()));
		setWriter(ecrm.getWriter());
		setChangeSection(ecrm.getChangeSection());
		setEoCommentA(StringUtil.checkNull(ecrm.getEoCommentA()));
		setEoCommentB(StringUtil.checkNull(ecrm.getEoCommentB()));
		setEoCommentC(StringUtil.checkNull(ecrm.getEoCommentC()));
		setContents(StringUtil.checkNull(ecrm.getContents()));

		// 따로 추가
		setState(ecrm.getLifeCycleState().getDisplay());
		setCreatedDate(ecrm.getCreateTimestamp().toString().substring(0, 10));
		setModifiedDate(ecrm.getModifyTimestamp());
		setModifiedDate_text(ecrm.getModifyTimestamp().toString().substring(0, 10));
		setCreator(ecrm.getCreatorFullName());
		setCreateDepart(StringUtil.checkNull(ecrm.getCreateDepart()));
		setWriteDate(StringUtil.checkNull(ecrm.getCreateDate()));
		setModel(EcprHelper.manager.displayToModel(ecrm.getModel()));
		NumberCode period = NumberCodeHelper.manager.getNumberCode(ecrm.getPeriod(), "PRESERATION");
		if (period != null) {
			setPeriod_code(period.getCode());
			setPeriod_name(period.getName());
		}
		set_isNew(ecrm.getIsNew()); // true 신규
		setAuth(ecrm);
	}

	/**
	 * 변경 구분
	 */
	public String getChangeCode() throws Exception {
		this.changeCode = NumberCodeHelper.manager.getNumberCodeName(this.changeSection, "CHANGESECTION");
		return changeCode;
	}

	/**
	 * 권한 설정
	 */
	private void setAuth(ECRMRequest ecrm) throws Exception {
		boolean isAdmin = CommonUtil.isAdmin();
		boolean isCreator = CommonUtil.isCreator(ecrm);

		if (check(ecrm, "APPROVING") && (isAdmin || isCreator)) {
			set_withdraw(true);
		}

		if (check(ecrm, "APPROVED") && is_isNew()) {
			set_print(true);
		}

		if ((check(ecrm, "INWORK") || check(ecrm, "LINE_REGISTER") || check(ecrm, "RETURN"))) {
			set_modify(true);
		}

		if (isAdmin || isCreator) {
			set_delete(true);
		}
	}

	/**
	 * 상태값 여부 체크
	 */
	private boolean check(ECRMRequest ecrm, String state) throws Exception {
		boolean check = false;
		String compare = ecrm.getLifeCycleState().toString();
		if (compare.equals(state)) {
			check = true;
		}
		return check;
	}
}
