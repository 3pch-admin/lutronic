package com.e3ps;

import com.e3ps.common.iba.IBAUtils;
import com.e3ps.common.util.CommonUtil;

import wt.fc.PersistenceHelper;
import wt.fc.PersistenceServerHelper;
import wt.part.QuantityUnit;
import wt.part.WTPart;

public class Test {

	public static void main(String[] args) throws Exception {
		WTPart p = (WTPart) CommonUtil.getObject("wt.part.WTPart:1278829");

		IBAUtils.createIBA(p, "SPECIFICATION", "사양 SAP 전달", "s");
		IBAUtils.createIBA(p, "WEIGHT", "2", "f");

		System.out.println("종료");

		System.exit(0);
	}
}