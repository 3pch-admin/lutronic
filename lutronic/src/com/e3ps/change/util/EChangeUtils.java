package com.e3ps.change.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import com.e3ps.change.EChangeActivity;
import com.e3ps.change.EChangeOrder;
import com.e3ps.change.EOCompletePartLink;
import com.e3ps.change.activity.service.ActivityHelper;
import com.e3ps.change.ecn.service.EcnHelper;
import com.e3ps.change.eo.service.EoHelper;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.ContentUtils;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.org.Department;
import com.e3ps.org.service.DepartmentHelper;
import com.e3ps.part.service.PartHelper;
import com.e3ps.sap.service.SAPHelper;

import net.sf.json.JSONArray;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.part.WTPart;
import wt.query.QuerySpec;
import wt.vc.VersionControlHelper;
import wt.vc.baseline.BaselineMember;
import wt.vc.baseline.ManagedBaseline;
import wt.vc.views.View;

/**
 * 설변관련 공통으로 사용된 함수 모음
 */
public class EChangeUtils {

	public static final EChangeUtils manager = new EChangeUtils();

	/**
	 * 중복 제거한 베이스 라인 가져오기??
	 */
	public ArrayList<Map<String, String>> getBaseline(String oid) throws Exception {
		ArrayList<Map<String, String>> list = arrayBaseLine(oid);
		ArrayList<Map<String, String>> baseLine = new ArrayList<Map<String, String>>();
		Map<String, String> tempMap = new HashMap<String, String>();
		for (Map<String, String> data : list) {
			Map<String, String> groupMap = new HashMap<String, String>();
			String baseLine_name = data.get("baseLine_name");
			String temp_name = baseLine_name.substring(0, baseLine_name.indexOf(":"));
			String baseLine_oid = data.get("baseLine_oid");
			String part_oid = data.get("part_oid");
			System.out.println(baseLine_name + " , " + temp_name + tempMap.containsKey(temp_name));
			if (tempMap.containsKey(temp_name)) {
				continue;
			} else {
				tempMap.put(temp_name, temp_name);
				groupMap.put("baseLine_name", temp_name);
				groupMap.put("baseLine_oid", baseLine_oid);
				groupMap.put("part_oid", part_oid);
			}
			baseLine.add(groupMap);
		}
		return baseLine;
	}

	/**
	 * 부품과 관련된 베이스 라인 가져오는 함수
	 */
	private ArrayList<Map<String, String>> arrayBaseLine(String oid) throws Exception {
		WTPart part = (WTPart) CommonUtil.getObject(oid);

		QuerySpec query = new QuerySpec();
		int idx_l = query.appendClassList(ManagedBaseline.class, true);
		int idx_m = query.appendClassList(BaselineMember.class, false);
		int idx_p = query.appendClassList(WTPart.class, true);

		QuerySpecUtils.toInnerJoin(query, ManagedBaseline.class, BaselineMember.class,
				"thePersistInfo.theObjectIdentifier.id", "roleAObjectRef.key.id", idx_l, idx_m);
		QuerySpecUtils.toInnerJoin(query, BaselineMember.class, WTPart.class, "roleBObjectRef.key.id",
				"thePersistInfo.theObjectIdentifier.id", idx_m, idx_p);
		QuerySpecUtils.toEqualsAnd(query, idx_p, WTPart.class, "masterReference.key.id", part.getMaster());
		QuerySpecUtils.toOrderBy(query, idx_l, ManagedBaseline.class, ManagedBaseline.CREATE_TIMESTAMP, true);

		QueryResult result = PersistenceHelper.manager.find(query);

		ArrayList<Map<String, String>> list = new ArrayList<Map<String, String>>();

		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			ManagedBaseline baseLine = (ManagedBaseline) obj[0];
			WTPart p = (WTPart) obj[1];
			Map<String, String> map = new HashMap<String, String>();
			map.put("part_oid", p.getPersistInfo().getObjectIdentifier().toString());
			map.put("baseLine_oid", baseLine.getPersistInfo().getObjectIdentifier().toString());
			map.put("baseLine_name", baseLine.getName());
			list.add(map);
		}
		return list;
	}

	/**
	 * 베이스라인에 처리된 부품 목록
	 */
	public void collectBaseLineParts(WTPart part, Vector v) throws Exception {
		ArrayList<WTPart> list = PartHelper.manager.descentsPart(part, (View) part.getView().getObject());

		for (WTPart p : list) {
			String state = p.getLifeCycleState().toString();
			boolean isApproved = state.equals("APPROVED");
			// 승인된거 패스
			if (isApproved) {
				continue;
			}

			WTPart prev = null;
			prev = (WTPart) VersionControlHelper.service.predecessorOf(p);

			if (prev == null) {
				prev = p;
			}
			v.add(prev);
			collectBaseLineParts(prev, v);
		}
	}

	/**
	 * 설변활동 산출물 요약
	 */
	public ArrayList<Map<String, Object>> summary(String oid) throws Exception {
		ArrayList<Map<String, Object>> list = new ArrayList<>();
		EChangeOrder e = (EChangeOrder) CommonUtil.getObject(oid);

		QuerySpec qs = new QuerySpec(EChangeActivity.class);
		QuerySpecUtils.toEqualsAnd(qs, 0, EChangeActivity.class, "eoReference.key.id", e);
		QuerySpecUtils.toEqualsAnd(qs, 0, EChangeActivity.class, EChangeActivity.ACTIVE_TYPE, "DOCUMENT");
		QueryResult result = PersistenceHelper.manager.find(qs);
		while (result.hasMoreElements()) {
			EChangeActivity eca = (EChangeActivity) result.nextElement();

			Map<String, Object> map = new HashMap<>();
			// 담당부서 담당자 상태 요청완료일 완료일 첨부파일 의견 산추룸ㄹ
			Department dept = DepartmentHelper.manager.getDepartment(eca.getActiveUser());
			map.put("oid", eca.getPersistInfo().getObjectIdentifier().getStringValue());
			map.put("department_name", dept != null ? dept.getName() : "지정안됨");
			map.put("activity_user", eca.getActiveUser().getFullName());
			map.put("state", eca.getLifeCycleState().getDisplay());
			map.put("finishDate", eca.getFinishDate() != null ? eca.getFinishDate().toString().substring(0, 10) : "");
			map.put("completeDate", eca.getModifyTimestamp().toString().substring(0, 10));
			map.put("description", eca.getDescription());
			map.put("secondary", ContentUtils.getSecondary(eca));
			JSONArray data = ActivityHelper.manager.docList(eca);
			map.put("data", data);
			list.add(map);
		}
		return list;
	}

	/**
	 * EO 결재후 발생할 내용들 큐로 전환
	 */
	public static void afterEoAction(Hashtable<String, String> hash) throws Exception {
		System.out.println("EO 승인후 호출 !!!");
		try {
			String oid = hash.get("oid");
			EChangeOrder eo = (EChangeOrder) CommonUtil.getObject(oid);

			ArrayList<EOCompletePartLink> completeParts = EoHelper.manager.completeParts(eo);
			System.out.println("완제품 개수 = " + completeParts.size());

			// 모든 부품 대상 수집..
			ArrayList<WTPart> list = EoHelper.manager.getter(eo, completeParts);

			System.out.println("EO 대상 품목 개수 =  " + list.size());
//		completeProduct(partList, eco);

//		ERPHelper.service.sendERP(eco);

			SAPHelper.service.sendSapToEo(eo, completeParts);

			EoHelper.service.saveBaseline(eo, completeParts);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * ECO 결재후 발생할 내용들 큐로 전환
	 */
	public static void afterEcoAction(Hashtable<String, String> hash) throws Exception {
		System.out.println("ECO 승인후 호출 !!!");
		try {
			String oid = hash.get("oid");
			EChangeOrder eco = (EChangeOrder) CommonUtil.getObject(oid);
			
			// ECO 정보로 ECN 자동 생성
			EcnHelper.service.create(eco);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
}
