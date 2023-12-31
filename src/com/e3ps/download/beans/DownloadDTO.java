package com.e3ps.download.beans;

import java.sql.Timestamp;

import com.e3ps.change.ECPRRequest;
import com.e3ps.change.ECRMRequest;
import com.e3ps.change.EChangeOrder;
import com.e3ps.change.EChangeRequest;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.download.DownloadHistory;
import com.e3ps.org.People;
import com.e3ps.org.WTUserPeopleLink;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;
import wt.doc.WTDocument;
import wt.epm.EPMDocument;
import wt.fc.Persistable;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.part.WTPart;

@Getter
@Setter
public class DownloadDTO {

	private String oid;
	private String name;
	private String info;
	private String id;
	private String userName;
	private String duty;
	private String department_name;
	private int cnt;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Timestamp createdDate;
	private String createdDate_txt;

	public DownloadDTO() {

	}

	public DownloadDTO(String oid) throws Exception {
		this((DownloadHistory) CommonUtil.getObject(oid));
	}

	public DownloadDTO(DownloadHistory history) throws Exception {
		setOid(history.getPersistInfo().getObjectIdentifier().getStringValue());
		setName(history.getName());
		setPersistInfo(history);
		setUserInfo(history);
		setCnt(history.getCnt());
		setCreatedDate(history.getCreateTimestamp());
		setCreatedDate_txt(history.getCreateTimestamp().toString());
	}

	/**
	 * 사용자 정보 세팅
	 */
	private void setUserInfo(DownloadHistory history) throws Exception {
		WTUser user = history.getUser();
		People people = null;
		QueryResult result = PersistenceHelper.manager.navigate(user, "people", WTUserPeopleLink.class);
		if (result.hasMoreElements()) {
			people = (People) result.nextElement();
		}
		if (people != null) {
			setId(people.getId());
			setUserName(people.getName());
			setDuty(people.getDuty() != null ? people.getDuty() : "지정안됨");
			setDepartment_name(people.getDepartment() != null ? people.getDepartment().getName() : "지정안됨");
		}
	}

	/**
	 * 다온로드 모듈 정보
	 */
	private void setPersistInfo(DownloadHistory history) throws Exception {
		Persistable per = history.getPersist();
		String info = "";
		if (per instanceof WTPart) {
			WTPart part = (WTPart) per;
			info = "[품목] " + part.getNumber() + " - (" + part.getName() + ")";
		} else if (per instanceof EPMDocument) {
			EPMDocument epm = (EPMDocument) per;
			info = "[도면] " + epm.getNumber() + " - (" + epm.getName() + ")";
		} else if (per instanceof WTDocument) {
			WTDocument doc = (WTDocument) per;
			String docType = doc.getDocType().toString();
			if ("$$MMDocument".equals(docType)) {
				info = "[금형문서] " + doc.getNumber() + " - (" + doc.getName() + ")";
			} else if ("$$ROHS".equals(docType)) {
				info = "[ROHS] " + doc.getNumber() + " - (" + doc.getName() + ")";
			} else {
				info = "[문서] " + doc.getNumber() + " - (" + doc.getName() + ")";
			}
		} else if (per instanceof EChangeOrder) {
			EChangeOrder e = (EChangeOrder) per;
			if (e.getEoType().equals("CHANGE")) {
				info = "[ECO] " + e.getEoNumber() + " - (" + e.getEoName() + ")";
			} else {
				info = "[EO] " + e.getEoNumber() + " - (" + e.getEoName() + ")";
			}
		} else if (per instanceof EChangeRequest) {
			EChangeRequest cr = (EChangeRequest) per;
			info = "[CR] " + cr.getEoNumber() + " - (" + cr.getEoName() + ")";
		} else if (per instanceof ECPRRequest) {
			ECPRRequest ecpr = (ECPRRequest) per;
			info = "[ECPR] " + ecpr.getEoNumber() + " - (" + ecpr.getEoName() + ")";
		} else if (per instanceof ECRMRequest) {
			ECRMRequest ecrm = (ECRMRequest) per;
			info = "[ECRM] " + ecrm.getEoNumber() + " - (" + ecrm.getEoName() + ")";
		}
		setInfo(info);
	}
}
