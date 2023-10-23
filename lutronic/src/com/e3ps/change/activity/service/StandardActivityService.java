package com.e3ps.change.activity.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.e3ps.change.DocumentActivityLink;
import com.e3ps.change.ECOChange;
import com.e3ps.change.EChangeActivity;
import com.e3ps.change.EChangeActivityDefinition;
import com.e3ps.change.EChangeActivityDefinitionRoot;
import com.e3ps.change.EChangeOrder;
import com.e3ps.common.content.service.CommonContentHelper;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.common.util.WCUtil;

import wt.content.ApplicationData;
import wt.content.ContentRoleType;
import wt.content.ContentServerHelper;
import wt.doc.WTDocument;
import wt.doc.WTDocumentMaster;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.folder.Folder;
import wt.folder.FolderEntry;
import wt.folder.FolderHelper;
import wt.lifecycle.LifeCycleHelper;
import wt.lifecycle.State;
import wt.org.WTUser;
import wt.pom.Transaction;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.services.StandardManager;
import wt.util.WTException;

public class StandardActivityService extends StandardManager implements ActivityService {

	public static StandardActivityService newStandardActivityService() throws WTException {
		StandardActivityService instance = new StandardActivityService();
		instance.initialize();
		return instance;
	}

	@Override
	public Map<String, Object> delete(Map<String, Object> params) throws Exception {
		Map<String, Object> map = new HashMap<>();
		Transaction trs = new Transaction();
		try {
			trs.start();

			String oid = (String) params.get("oid");
			boolean dependency = ActivityHelper.manager.dependency(oid);
			if (dependency) {
				map.put("success", false);
				map.put("msg", "삭제 하려는 루트 활동에 설계변경 활동이 존재합니다.");
				return map;
			}

			EChangeActivityDefinitionRoot def = (EChangeActivityDefinitionRoot) CommonUtil.getObject(oid);
			PersistenceHelper.manager.delete(def);

			map.put("success", true);

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
		return map;
	}

	@Override
	public void create(Map<String, Object> params) throws Exception {
		String type = (String) params.get("type");
		Transaction trs = new Transaction();
		try {
			trs.start();

			if ("root".equals(type)) {
				String name = (String) params.get("name");
				String sort = (String) params.get("sort");
				String description = (String) params.get("description");

				EChangeActivityDefinitionRoot def = EChangeActivityDefinitionRoot.newEChangeActivityDefinitionRoot();
				def.setName(name);
				def.setSortNumber(Integer.parseInt(sort));
				def.setDescription(description);
				PersistenceHelper.manager.save(def);

			} else if ("act".equals(type)) {

				String oid = (String) params.get("oid");
				String name = (String) params.get("name");
				String step = (String) params.get("step");
				String activeType = (String) params.get("activeType");
				String sort = (String) params.get("sort");
				String description = (String) params.get("description");

				EChangeActivityDefinitionRoot def = (EChangeActivityDefinitionRoot) CommonUtil.getObject(oid);
				EChangeActivityDefinition act = EChangeActivityDefinition.newEChangeActivityDefinition();
				act.setName(name);
				act.setStep(step);
				act.setActiveType(activeType);
				act.setDescription(description);
				act.setSortNumber(Integer.parseInt(sort));
				act.setRoot(def);
				PersistenceHelper.manager.save(act);
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
	public void save(HashMap<String, ArrayList<LinkedHashMap<String, Object>>> dataMap) throws Exception {
		ArrayList<LinkedHashMap<String, Object>> editRows = dataMap.get("editRows");
		ArrayList<LinkedHashMap<String, Object>> removeRows = dataMap.get("removeRows");
		Transaction trs = new Transaction();
		try {
			trs.start();

			for (LinkedHashMap<String, Object> editRow : editRows) {
				String oid = (String) editRow.get("oid");
				String step = (String) editRow.get("step");
				String name = (String) editRow.get("name");
				String activity_name = (String) editRow.get("activity_name"); // code..
				int sort = (int) editRow.get("sort");
				String activeUser_oid = (String) editRow.get("activeUser_oid"); // wtuser
				EChangeActivityDefinition act = (EChangeActivityDefinition) CommonUtil.getObject(oid);
				act.setName(name);
				act.setActiveUser((WTUser) CommonUtil.getObject(activeUser_oid));
				act.setSortNumber(sort);
				act.setStep(step);
				act.setActiveType(activity_name);
				PersistenceHelper.manager.modify(act);
			}

			for (LinkedHashMap<String, Object> removeRow : removeRows) {
				String oid = (String) removeRow.get("oid");
				EChangeActivityDefinition act = (EChangeActivityDefinition) CommonUtil.getObject(oid);
				PersistenceHelper.manager.delete(act);
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
	public void modify(Map<String, Object> params) throws Exception {
		String oid = (String) params.get("oid");
		String name = (String) params.get("name");
		String sort = (String) params.get("sort");
		String description = (String) params.get("description");
		Transaction trs = new Transaction();
		try {
			trs.start();
			EChangeActivityDefinitionRoot def = (EChangeActivityDefinitionRoot) CommonUtil.getObject(oid);
			def.setName(name);
			def.setSortNumber(Integer.parseInt(sort));
			def.setDescription(description);
			PersistenceHelper.manager.modify(def);

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
	public void saveActivity(EChangeOrder eo, ArrayList<Map<String, String>> list) throws Exception {
		Transaction trs = new Transaction();
		try {
			trs.start();

			int sort = 0;
			for (Map<String, String> map : list) {
				String step_name = map.get("step_name");
				String name = map.get("name");
				String active_type = map.get("active_type");
				String activeUser_oid = map.get("activeUser_oid");
				String finishDate = map.get("finishDate");

				WTUser user = (WTUser) CommonUtil.getObject(activeUser_oid);

				EChangeActivity eca = EChangeActivity.newEChangeActivity();
				eca.setStep(step_name);
				eca.setName(name);
				eca.setActiveType(active_type);
				eca.setActiveUser(user);
				eca.setFinishDate(DateUtil.convertDate(finishDate));
				eca.setSortNumber(sort);
				eca.setEo(eo);

				String location = "/Default/설계변경/ECA";
				String lifecycle = "LC_ECA_PROCESS";

				Folder folder = FolderHelper.service.getFolder(location, WCUtil.getWTContainerRef());
				FolderHelper.assignLocation((FolderEntry) eca, folder);
				// 문서 lifeCycle 설정
				LifeCycleHelper.setLifeCycle(eca,
						LifeCycleHelper.service.getLifeCycleTemplate(lifecycle, WCUtil.getWTContainerRef())); // Lifecycle

				eca = (EChangeActivity) PersistenceHelper.manager.save(eca);
				sort++;

				// STEP1 코드
				if (eca.getStep().equals("ES001")) {
					State state = State.toState("INWORK");
					// STEP01 단계부터 무조건 시작
					LifeCycleHelper.service.setLifeCycleState(eca, state);
				}
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
	public void deleteActivity(EChangeOrder eo) throws Exception {
		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(EChangeActivity.class, true);
		SearchCondition sc = new SearchCondition(EChangeActivity.class, "eoReference.key.id", "=",
				eo.getPersistInfo().getObjectIdentifier().getId());
		query.appendWhere(sc, new int[] { idx });
		QueryResult result = PersistenceHelper.manager.find(query);
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			EChangeActivity eChangeActivity = (EChangeActivity) obj[0];
			PersistenceHelper.manager.delete(eChangeActivity);
		}

	}

	@Override
	public void saveLink(Map<String, Object> params) throws Exception {
		String oid = (String) params.get("oid");
		ArrayList<String> list = (ArrayList<String>) params.get("list");
		Transaction trs = new Transaction();
		try {
			trs.start();

			EChangeActivity eca = (EChangeActivity) CommonUtil.getObject(oid);
			for (String s : list) {
				WTDocument doc = (WTDocument) CommonUtil.getObject(s);
				DocumentActivityLink link = DocumentActivityLink
						.newDocumentActivityLink((WTDocumentMaster) doc.getMaster(), eca);
				PersistenceHelper.manager.save(link);
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
	public void deleteLink(String oid) throws Exception {
		Transaction trs = new Transaction();
		try {
			trs.start();

			DocumentActivityLink link = (DocumentActivityLink) CommonUtil.getObject(oid);
			PersistenceHelper.manager.delete(link);

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
	public void ccompleteAfterEvent(EChangeActivity eca) throws Exception {
//		String state = eca.getLifeCycleState().toString();
//		Transaction trs = new Transaction();
//		try {
//			trs.start();
//
//			if (!"COMPLETED".equals(state)) {
//				return;
//			}
//
//			trs.commit();
//			trs = null;
//		} catch (Exception e) {
//			e.printStackTrace();
//			trs.rollback();
//			throw e;
//		} finally {
//			if (trs != null)
//				trs.rollback();
//		}
	}

	@Override
	public void complete(Map<String, Object> params) throws Exception {
		String oid = (String) params.get("oid"); // eca oid
		String description = (String) params.get("description"); // 완료 의견
		ArrayList<String> secondarys = (ArrayList<String>) params.get("secondary");
		Transaction trs = new Transaction();
		try {
			trs.start();

			EChangeActivity eca = (EChangeActivity) CommonUtil.getObject(oid);
			eca.setDescription(description);
			PersistenceHelper.manager.modify(eca);

			System.out.println(params);

			for (int i = 0; secondarys != null && i < secondarys.size(); i++) {
				String cacheId = secondarys.get(i);
				File vault = CommonContentHelper.manager.getFileFromCacheId(cacheId);
				ApplicationData applicationData = ApplicationData.newApplicationData(eca);
				applicationData.setRole(ContentRoleType.SECONDARY);
				PersistenceHelper.manager.save(applicationData);
				ContentServerHelper.service.updateContent(eca, applicationData, vault.getPath());
			}

			// 승인됨으로 변경한다.
			LifeCycleHelper.service.setLifeCycleState(eca, State.toState("COMPLETED"));

			String step = eca.getStep();

			// 같은 STEP 단계확인을 하여 해당 스텝이 마지막인지 확인
			QuerySpec query = new QuerySpec();
			int idx = query.appendClassList(EChangeActivity.class, true);
			QuerySpecUtils.toEqualsAnd(query, idx, EChangeActivity.class, "eoReference.key.id", eca.getEo());
			QuerySpecUtils.toEqualsAnd(query, idx, EChangeActivity.class, EChangeActivity.STEP, step);
			QueryResult qr = PersistenceHelper.manager.find(query);
			boolean isLast = true;
			while (qr.hasMoreElements()) {
				Object[] obj = (Object[]) qr.nextElement();
				EChangeActivity ee = (EChangeActivity) obj[0];
				String state = ee.getLifeCycleState().toString();
				if ("INTAKE".equals(state)) {
					isLast = false; // 접수가 있으면 마지막이 아니다.
					break;
				}
			}
			// ES001 ES002 ES003 ES004
			// 스텝 코드 순서
			System.out.println("마지막 작업이 끝났어요 = " + isLast);

			int last = Integer.parseInt(step.substring(4));
			String nextStep = step.substring(0, 4) + (last + 1); // ES001 -> ES002
			// 마지막일경우 다음 스텝의 ECA 활동을 작업중으로 변경처리한다.
			if (isLast) {
				nextValidate(eca.getEo(), nextStep);
			}

			// 모든 ECA가 끝났을 경우 EO, ECO상태값을변경한다.
			boolean isEnd = checkActivityComplete(eca.getEo());
			if (isEnd) {
				LifeCycleHelper.service.setLifeCycleState(eca.getEo(), State.toState("APPROVING"));
			}

			// EChangeActivity

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

	/**
	 * 설변 활동 다음 스텝 체크
	 */
	private void nextValidate(ECOChange eo, String nextStep) throws Exception {

		System.out.println("nextStep=" + nextStep);
		// 5번 스텝으로 되면 끝을낸다.
		if (nextStep.equals("ES005")) {
			return;
		}

		// ES002 가 nextStep 으로 들어옴..
		QuerySpec qs = new QuerySpec(EChangeActivity.class);
		QuerySpecUtils.toEqualsAnd(qs, 0, EChangeActivity.class, "eoReference.key.id", eo);
		QuerySpecUtils.toEqualsAnd(qs, 0, EChangeActivity.class, EChangeActivity.STEP, nextStep);
		QueryResult result = PersistenceHelper.manager.find(qs);

		// 해당사항이 없다면 다음 스텝 체크..
		if (result.size() == 0) {
			int last = Integer.parseInt(nextStep.substring(4));
			String toNext = nextStep.substring(0, 4) + (last + 1); // ES001 -> ES002
			nextValidate(eo, toNext);
		}

		while (result.hasMoreElements()) {
			EChangeActivity next = (EChangeActivity) result.nextElement();
			// 작업중으로 전부 변경한다 다음 스텝
			LifeCycleHelper.service.setLifeCycleState(next, State.toState("INWORK"));
		}
	}

	/**
	 * 해당 EO에 관련된 ECA가 모두 끝낫는지 확인 후 승인중 상태로 변경한다.
	 */
	private boolean checkActivityComplete(ECOChange eo) throws Exception {
		boolean isEnd = true;
		Transaction trs = new Transaction();
		try {
			trs.start();

			QuerySpec qs = new QuerySpec(EChangeActivity.class);
			QuerySpecUtils.toEqualsAnd(qs, 0, EChangeActivity.class, "eoReference.key.id", eo);
			QueryResult qr = PersistenceHelper.manager.find(qs);
			while (qr.hasMoreElements()) {
				EChangeActivity eca = (EChangeActivity) qr.nextElement();
				String state = eca.getLifeCycleState().toString();
				// 승인됨이 아닌게 있을 경우 마지막이 아니다
				if (!"COMPLETED".equals(state)) {
					isEnd = false;
					break;
				}
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
		return isEnd;
	}
}
