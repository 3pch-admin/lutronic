package com.e3ps.temprary.service;

import com.e3ps.change.ECPRRequest;
import com.e3ps.change.EChangeNotice;
import com.e3ps.change.EChangeOrder;
import com.e3ps.change.EChangeRequest;
import com.e3ps.common.util.CommonUtil;

import wt.doc.WTDocument;
import wt.epm.EPMDocument;
import wt.fc.Persistable;
import wt.part.WTPart;
import wt.services.StandardManager;
import wt.util.WTException;

public class StandardTempraryService extends StandardManager implements TempraryService {

	public static StandardTempraryService newStandardTempraryService() throws WTException {
		StandardTempraryService instance = new StandardTempraryService();
		instance.initialize();
		return instance;
	}
	
	@Override
	public String getViewIdentity(String oid) {
		Persistable per = CommonUtil.getObject(oid);
		if (per instanceof WTDocument) {
			WTDocument doc = (WTDocument) per;
			if ("$$MMDocument".equals(doc.getDocType().toString())) {
				// 금형
				return "mold";
			} else if("$$ROHS".equals(doc.getDocType().toString())){
				return "rohs";
			}else {
				// 문서
				return "doc";
			}
		} else if (per instanceof EChangeOrder) {
			EChangeOrder eco = (EChangeOrder) per;
			if (eco.getEoType().equals("CHANGE")) {
				// ECO
				return "eco";
			} else {
				// EO
				return "eo";
			}
		} else if (per instanceof EChangeRequest) {
			// CR
			return "cr";
		} else if (per instanceof EChangeNotice) {
			// ECN
			return "ecn";
		} else if (per instanceof ECPRRequest) {
			// ECPR
			return "ecpr";
		} else if (per instanceof WTPart) {
			// 부품
			return "part";
		}else if (per instanceof EPMDocument) {
			// 부품
			return "drawing";
		}
		return null;
	}
}