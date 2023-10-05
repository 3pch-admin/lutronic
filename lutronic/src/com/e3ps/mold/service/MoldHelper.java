package com.e3ps.mold.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.e3ps.common.iba.AttributeKey;
import com.e3ps.common.query.SearchUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.FolderUtils;
import com.e3ps.common.util.PageQueryUtils;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.util.WCUtil;
import com.e3ps.doc.DocLocation;
import com.e3ps.mold.dto.MoldDTO;
import com.e3ps.org.People;

import wt.clients.folder.FolderTaskLogic;
import wt.doc.WTDocument;
import wt.doc.WTDocumentMaster;
import wt.fc.PagingQueryResult;
import wt.fc.ReferenceFactory;
import wt.folder.Folder;
import wt.folder.IteratedFolderMemberLink;
import wt.iba.definition.litedefinition.AttributeDefDefaultView;
import wt.iba.definition.service.IBADefinitionHelper;
import wt.iba.value.StringValue;
import wt.org.WTUser;
import wt.query.ClassAttribute;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.services.ServiceFactory;
import wt.util.WTAttributeNameIfc;
import wt.vc.VersionControlHelper;

public class MoldHelper {
	
	public static final MoldService service = ServiceFactory.getService(MoldService.class);
	public static final MoldHelper manager = new MoldHelper();
	
	/**
	 * 금형 검색
	 */
	public Map<String, Object> list(Map<String, Object> params) throws Exception {
		Map<String, Object> map = new HashMap<>();
		ArrayList<MoldDTO> list = new ArrayList<>();

		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(WTDocument.class, true);

		String location = StringUtil.checkNull((String) params.get("location"));
		String islastversion 	= StringUtil.checkNull((String)params.get("islastversion"));
		String docNumber = StringUtil.checkNull((String) params.get("number"));
		String docName = StringUtil.checkNull((String) params.get("name"));
		String createdFrom = StringUtil.checkNull((String) params.get("createdFrom"));
		String createdTo = StringUtil.checkNull((String) params.get("createdTo"));
		String modifiedFrom = StringUtil.checkNull((String) params.get("modifiedFrom"));
		String modifiedTo = StringUtil.checkNull((String) params.get("modifiedTo"));
		String creator = StringUtil.checkNull((String) params.get("creatorOid"));
		String state = StringUtil.checkNull((String) params.get("state"));
		String interalnumber = StringUtil.checkNull((String) params.get("interalnumber"));
		String deptcode = StringUtil.checkNull((String) params.get("deptcode"));
		String description = StringUtil.checkNull((String) params.get("description"));
		String manufacture = StringUtil.checkNull((String) params.get("manufacture"));
		String moldtype = StringUtil.checkNull((String) params.get("moldtype"));
		String moldCost = StringUtil.checkNull((String) params.get("moldcost"));
		String searchType = StringUtil.checkNull((String) params.get("searchType"));
		String moldNumber = StringUtil.checkNull((String) params.get("moldnumber"));

		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.NUMBER, docNumber);
		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.NAME, docName);
		QuerySpecUtils.creatorQuery(query, idx, WTDocument.class, creator);
		QuerySpecUtils.toTimeGreaterAndLess(query, idx, WTDocument.class, WTDocument.CREATE_TIMESTAMP, createdFrom,
				createdTo);
		QuerySpecUtils.toTimeGreaterAndLess(query, idx, WTDocument.class, WTDocument.CREATE_TIMESTAMP, modifiedFrom,
				modifiedTo);
		QuerySpecUtils.toState(query, idx, WTDocument.class, state);
		QuerySpecUtils.toLikeAnd(query, idx, WTDocument.class, WTDocument.DESCRIPTION, description);
		
		// 일괄 결재시 타입에 따른 LC 상태 검색
		if (searchType.length() > 0) {
			if (query.getConditionCount() > 0) {
				query.appendAnd();
			}
			if ("MOLD".equals(searchType)) {
				query.appendWhere(new SearchCondition(WTDocument.class, WTDocument.DOC_TYPE, SearchCondition.EQUAL, "$$MMDocument"), new int[] { idx });
			}
		}

		// 내부 문서번호
		if (interalnumber.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_INTERALNUMBER);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + interalnumber + "%").toUpperCase(), false), new int[] { _idx });
			}
		} else {
			interalnumber = "";
		}

		// 부서
		if (deptcode.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_DEPTCODE);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + deptcode + "%").toUpperCase()), new int[] { _idx });
			}
		} else {
			deptcode = "";
		}

		// manufacture
		if (manufacture.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MANUFACTURE);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + manufacture + "%").toUpperCase(), false), new int[] { _idx });
			}
		} else {
			manufacture = "";
		}

		// 금형타입
		if (moldtype.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MOLDTYPE);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + moldtype + "%").toUpperCase(), false), new int[] { _idx });
			}
		} else {
			moldtype = "";
		}

		// 금형번호
		if (moldNumber.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MOLDNUMBER);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + moldNumber + "%").toUpperCase(), false), new int[] { _idx });
			}
		} else {
			moldNumber = "";
		}

		// 금형개발비
		if (moldCost.length() > 0) {
			AttributeDefDefaultView aview = IBADefinitionHelper.service
					.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MOLDCOST);
			if (aview != null) {
				if (query.getConditionCount() > 0) {
					query.appendAnd();
				}
				int _idx = query.appendClassList(StringValue.class, false);
				query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id",
						WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID",
						SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
				query.appendAnd();
				query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE,
						("%" + moldCost + "%").toUpperCase(), false), new int[] { _idx });
			}
		} else {
			moldCost = "";
		}

		if (location.length() > 0) {
			if (query.getConditionCount() > 0) {
				query.appendAnd();
			}
			// Folder Search
			int folder_idx = query.addClassList(DocLocation.class, false);
			query.appendWhere(new SearchCondition(DocLocation.class, DocLocation.DOC, WTDocument.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { folder_idx, idx });
			query.appendAnd();

			query.appendWhere(new SearchCondition(DocLocation.class, "loc", SearchCondition.LIKE, location + "%"), new int[] { folder_idx });
		}
    	
    	// 최신 이터레이션.
		if("true".equals(islastversion)) {
			QuerySpecUtils.toLatest(query, idx, WTDocument.class);
		}

		QuerySpecUtils.toOrderBy(query, idx, WTDocument.class, WTDocument.MODIFY_TIMESTAMP, true);

		PageQueryUtils pager = new PageQueryUtils(params, query);
		PagingQueryResult result = pager.find();
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			WTDocument document = (WTDocument) obj[0];
			MoldDTO data = new MoldDTO(document);
			System.out.println("111111111111111111111111");
			list.add(data);
		}
		System.out.println("2222222222222222"+query);

		map.put("list", list);
		map.put("topListCount", pager.getTotal());
		map.put("pageSize", pager.getPsize());
		map.put("total", pager.getTotalSize());
		map.put("sessionid", pager.getSessionId());
		map.put("curPage", pager.getCpage());
		
		return map;

	}
}
