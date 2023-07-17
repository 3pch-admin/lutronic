package com.e3ps.rohs.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.e3ps.common.iba.AttributeKey;
import com.e3ps.common.query.SearchUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.PageQueryUtils;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.common.util.StringUtil;
import com.e3ps.common.web.PageQueryBroker;
import com.e3ps.doc.beans.DocumentData;
import com.e3ps.org.People;
import com.e3ps.rohs.ROHSMaterial;
import com.e3ps.rohs.beans.RohsData;

import wt.doc.WTDocument;
import wt.fc.PagingQueryResult;
import wt.fc.PagingSessionHelper;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.fc.ReferenceFactory;
import wt.iba.definition.litedefinition.AttributeDefDefaultView;
import wt.iba.definition.service.IBADefinitionHelper;
import wt.iba.value.StringValue;
import wt.org.WTUser;
import wt.query.ClassAttribute;
import wt.query.OrderBy;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.services.ServiceFactory;
import wt.vc.VersionControlHelper;

public class RohsHelper {
	public static final RohsService service = ServiceFactory.getService(RohsService.class);
	public static final RohsHelper manager = new RohsHelper();
	
	public Map<String, Object> list(Map<String, Object> params) throws Exception {
		Map<String, Object> map = new HashMap<>();
		ArrayList<RohsData> list = new ArrayList<>();
    	
    	QuerySpec query = new QuerySpec();
    	int idx = query.addClassList(ROHSMaterial.class, true);
    	ReferenceFactory rf = new ReferenceFactory();
    	
    	try {
    		
    		String foid = StringUtil.checkNull((String) params.get("fid"));
    		if(foid.length() == 0) {
    			foid = StringUtil.checkNull((String) params.get("folder"));
    		}
    		
    		String islastversion 	= StringUtil.checkNull((String)params.get("islastversion"));
    		String rohsNumber 		= StringUtil.checkNull((String) params.get("number"));
    		String rohsName 		= StringUtil.checkNull((String) params.get("name"));
    		String description		= StringUtil.checkNull((String) params.get("description"));
    		String predate 			= StringUtil.checkNull((String) params.get("predate"));
    		String postdate 		= StringUtil.checkNull((String) params.get("postdate"));
    		String predate_modify	= StringUtil.checkNull((String) params.get("predate_modify"));
    		String postdate_modify	= StringUtil.checkNull((String) params.get("postdate_modify"));
    		String creator 			= StringUtil.checkNull((String) params.get("creator"));
    		String state 			= StringUtil.checkNull((String) params.get("state"));
    		String manufacture 		= StringUtil.checkNull((String) params.get("manufacture"));
    		String sortValue 		= StringUtil.checkNull((String) params.get("sortValue"));
    		String sortCheck 		= StringUtil.checkNull((String) params.get("sortCheck"));
			
			if(!StringUtil.checkString(islastversion)) {
	    		islastversion = "true";
	    	}

	    	if(query.getConditionCount() > 0) { query.appendAnd(); }
	    	query.appendWhere(VersionControlHelper.getSearchCondition(ROHSMaterial.class, true), new int[]{idx});
	    	
	    	if("true".equals(islastversion)) {
				 SearchUtil.addLastVersionCondition(query, ROHSMaterial.class, idx);
			}
			
	    	//문서번호
	    	if(rohsNumber.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.NUMBER, SearchCondition.LIKE, "%" + rohsNumber + "%", false), new int[]{idx});
	    	}
	    	
	    	//문서명
	    	if(rohsName.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.NAME, SearchCondition.LIKE, "%" + rohsName + "%", false), new int[]{idx});
	    	}
	    	
	    	// 설명
			if(description.length() > 0) {
				if(query.getConditionCount() > 0) { query.appendAnd(); }
				query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.DESCRIPTION, SearchCondition.LIKE, "%"+description+"%", false), new int[] {idx} );
			}
	    	
	    	//등록일
	    	if(predate.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.CREATE_TIMESTAMP ,SearchCondition.GREATER_THAN,DateUtil.convertStartDate(predate)), new int[]{idx});
	    	}
	    	
	    	if(postdate.length() > 0){
	    		if(query.getConditionCount() > 0)query.appendAnd();
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.CREATE_TIMESTAMP,SearchCondition.LESS_THAN,DateUtil.convertEndDate(postdate)), new int[]{idx});
	    	}
	    	
	    	//수정일
	    	if(predate_modify.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.MODIFY_TIMESTAMP, SearchCondition.GREATER_THAN, DateUtil.convertStartDate(predate_modify)), new int[]{idx});
	    	}
	    	
	    	if(postdate_modify.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.MODIFY_TIMESTAMP, SearchCondition.LESS_THAN, DateUtil.convertEndDate(postdate_modify)), new int[]{idx});
	    	}
	    	
	    	//등록자
	    	if(creator.length() > 0){
	    		People people = (People)rf.getReference(creator).getObject();
	    		WTUser user = people.getUser();
	    		if(query.getConditionCount() > 0) { query.appendAnd(); } 
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class,"iterationInfo.creator.key.id", SearchCondition.EQUAL, CommonUtil.getOIDLongValue(user)), new int[]{idx});
	    	}
	    	
	    	//상태
	    	if(state.length() > 0){
	    		if(query.getConditionCount() > 0) { query.appendAnd(); }
	    		query.appendWhere(new SearchCondition(ROHSMaterial.class, ROHSMaterial.LIFE_CYCLE_STATE, SearchCondition.EQUAL, state), new int[]{idx});
	    	}
	    	
	    	
	    	// 협력 업체
			if (manufacture.length() > 0) {
				AttributeDefDefaultView aview = IBADefinitionHelper.service.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MANUFACTURE);
				if (aview != null) {
					if (query.getConditionCount() > 0) {
						query.appendAnd();
					}
					int _idx = query.appendClassList(StringValue.class, false);
					query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id", ROHSMaterial.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
					query.appendAnd();
					query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID", SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
					query.appendAnd();
					query.appendWhere(new SearchCondition(StringValue.class, "value", SearchCondition.LIKE, ("%" + manufacture + "%").toUpperCase()), new int[] { _idx });
				}
			} else {
				manufacture = "";
			}
			
	    	//소팅
	    	if (sortCheck == null) sortCheck = "true";
			if(sortValue != null && sortValue.length() > 0) {
				if("true".equals(sortCheck)){
					if( "creator".equals(sortValue)){
						if(query.getConditionCount() > 0) query.appendAnd();
						int idx_user = query.appendClassList(WTUser.class, false);
						int idx_people = query.appendClassList(People.class, false);
						
						ClassAttribute ca = new ClassAttribute(ROHSMaterial.class, "creator.key.id");
			            ClassAttribute ca2 = new ClassAttribute(WTUser.class, "thePersistInfo.theObjectIdentifier.id");
			            query.appendWhere(new SearchCondition(ca, "=", ca2), new int[]{idx, idx_user});
						ClassAttribute ca3 = new ClassAttribute(People.class, "userReference.key.id");
						query.appendAnd();
						query.appendWhere(new SearchCondition(ca2, "=", ca3), new int[]{idx_user, idx_people});
						SearchUtil.setOrderBy(query, People.class, idx_people, People.NAME, "sort" , true);
					}else if("manufacture".equals(sortValue)){
						
						
						
						AttributeDefDefaultView aview = IBADefinitionHelper.service.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MANUFACTURE);
						if (aview != null) {
							if (query.getConditionCount() > 0) {
								query.appendAnd();
							}
							int _idx = query.appendClassList(StringValue.class, false);
							query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id", ROHSMaterial.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
							query.appendAnd();
							query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID", SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
							
							query.appendOrderBy(new OrderBy(new ClassAttribute(StringValue.class,"value"), true), new int[] { _idx });
						
						}
					}else{
						query.appendOrderBy(new OrderBy(new ClassAttribute(ROHSMaterial.class,sortValue), true), new int[] { idx });
						
					}
				}else{
					if( "creator".equals(sortValue)){
						if(query.getConditionCount() > 0) query.appendAnd();
						int idx_user = query.appendClassList(WTUser.class, false);
						int idx_people = query.appendClassList(People.class, false);
						
						ClassAttribute ca = new ClassAttribute(ROHSMaterial.class, "creator.key.id");
			            ClassAttribute ca2 = new ClassAttribute(WTUser.class, "thePersistInfo.theObjectIdentifier.id");
			            query.appendWhere(new SearchCondition(ca, "=", ca2), new int[]{idx, idx_user});
						ClassAttribute ca3 = new ClassAttribute(People.class, "userReference.key.id");
						query.appendAnd();
						query.appendWhere(new SearchCondition(ca2, "=", ca3), new int[]{idx_user, idx_people});
						SearchUtil.setOrderBy(query, People.class, idx_people, People.NAME, "sort" , false);
					
						
					}else if("manufacture".equals(sortValue)){
						AttributeDefDefaultView aview = IBADefinitionHelper.service.getAttributeDefDefaultViewByPath(AttributeKey.IBAKey.IBA_MANUFACTURE);
						if (aview != null) {
							if (query.getConditionCount() > 0) {
								query.appendAnd();
							}
							int _idx = query.appendClassList(StringValue.class, false);
							query.appendWhere(new SearchCondition(StringValue.class, "theIBAHolderReference.key.id", ROHSMaterial.class, "thePersistInfo.theObjectIdentifier.id"), new int[] { _idx, idx });
							query.appendAnd();
							query.appendWhere(new SearchCondition(StringValue.class, "definitionReference.hierarchyID", SearchCondition.EQUAL, aview.getHierarchyID()), new int[] { _idx });
							
							query.appendOrderBy(new OrderBy(new ClassAttribute(StringValue.class,"value"), false), new int[] { _idx });
						
						}
					}else{
						query.appendOrderBy(new OrderBy(new ClassAttribute(ROHSMaterial.class,sortValue), false), new int[] { idx });
					}
				}
			}else{
				//query.appendOrderBy(new OrderBy(new ClassAttribute(ROHSMaterial.class,"thePersistInfo.createStamp"), true), new int[] { idx }); 
				SearchUtil.setOrderBy(query, ROHSMaterial.class, idx, ROHSMaterial.MODIFY_TIMESTAMP, "sort", true);
			}
			
			PageQueryUtils pager = new PageQueryUtils(params, query);
			PagingQueryResult result = pager.find();
			while (result.hasMoreElements()) {
				Object[] obj = (Object[]) result.nextElement();
				RohsData data = new RohsData((ROHSMaterial) obj[0]);
				list.add(data);
			}

			map.put("list", list);
			
	    }catch (Exception e) {
			e.printStackTrace();
		}
    	return map;
    	
	}

}
