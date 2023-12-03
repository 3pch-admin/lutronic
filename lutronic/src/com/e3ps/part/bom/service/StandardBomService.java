package com.e3ps.part.bom.service;

import java.util.HashMap;
import java.util.Map;

import com.e3ps.common.util.CommonUtil;

import net.sf.json.JSONObject;
import wt.clients.vc.CheckInOutTaskLogic;
import wt.fc.PersistenceHelper;
import wt.folder.Folder;
import wt.part.WTPart;
import wt.part.WTPartMaster;
import wt.part.WTPartUsageLink;
import wt.pom.Transaction;
import wt.services.StandardManager;
import wt.util.WTException;
import wt.vc.wip.CheckoutLink;
import wt.vc.wip.WorkInProgressHelper;

public class StandardBomService extends StandardManager implements BomService {

	public static StandardBomService newStandardBomService() throws WTException {
		StandardBomService instance = new StandardBomService();
		instance.initialize();
		return instance;
	}

	@Override
	public void removeLink(Map<String, String> params) throws Exception {
		String poid = (String) params.get("poid"); // 부모
		String oid = (String) params.get("oid"); // 자식
		String link = (String) params.get("link");
		Transaction trs = new Transaction();
		try {
			trs.start();

			WTPart parent = (WTPart) CommonUtil.getObject(poid);
			if (!WorkInProgressHelper.isCheckedOut(parent)) {
				Folder cFolder = CheckInOutTaskLogic.getCheckoutFolder();
				CheckoutLink clink = WorkInProgressHelper.service.checkout(parent, cFolder, "");
				parent = (WTPart) clink.getWorkingCopy();
			}

			WTPart part = (WTPart) CommonUtil.getObject(oid);
			WTPartMaster child = part.getMaster();

			WTPartUsageLink usageLink = BomHelper.manager.getUsageLink(parent, child);
			if (usageLink != null) {
				PersistenceHelper.manager.delete(usageLink);
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
	public Map<String, Object> undoCheckOut(String oid) throws Exception {
		// 화면에서 막기에 체크 안한다..
		Map<String, Object> result = new HashMap<>();
		Transaction trs = new Transaction();
		try {
			trs.start();

			WTPart part = (WTPart) CommonUtil.getObject(oid);
			WTPart origin = (WTPart) WorkInProgressHelper.service.undoCheckout(part);

			result.put("oid", origin.getPersistInfo().getObjectIdentifier().getStringValue());
			result.put("isCheckOut", false);

			trs.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trs.rollback();
			throw e;
		} finally {
			if (trs != null)
				trs.rollback();
		}
		return result;
	}

	@Override
	public Map<String, Object> checkout(String oid) throws Exception {
		Map<String, Object> map = new HashMap<>();
		WTPart part = (WTPart) CommonUtil.getObject(oid);

		WTPart workingCopy = null;
		if (!WorkInProgressHelper.isCheckedOut(part)) {
			Folder cFolder = CheckInOutTaskLogic.getCheckoutFolder();
			CheckoutLink clink = WorkInProgressHelper.service.checkout(part, cFolder, "");
			workingCopy = (WTPart) clink.getWorkingCopy();
		}

		if (workingCopy != null) {
			JSONObject node = BomHelper.manager.getNode(workingCopy);
			map.put("resNode", node);
		} else {
			JSONObject node = BomHelper.manager.getNode(part);
			map.put("resNode", node);
		}

		return map;
	}
}
