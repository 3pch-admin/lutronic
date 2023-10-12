package com.e3ps.change.ecpr.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.e3ps.change.CrToEcprLink;
import com.e3ps.change.ECPRRequest;
import com.e3ps.change.EChangeRequest;
import com.e3ps.change.EcrToEcrLink;
import com.e3ps.change.beans.ECRData;
import com.e3ps.change.cr.column.CrColumn;
import com.e3ps.change.ecpr.column.EcprColumn;
import com.e3ps.change.ecpr.dto.EcprDTO;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.code.dto.NumberCodeDTO;
import com.e3ps.common.code.service.NumberCodeHelper;
import com.e3ps.common.query.SearchUtil;
import com.e3ps.common.util.AUIGridUtil;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.DateUtil;
import com.e3ps.common.util.PageQueryUtils;
import com.e3ps.common.util.QuerySpecUtils;
import com.e3ps.common.util.StringUtil;
import com.e3ps.doc.DocumentEOLink;
import com.e3ps.org.People;

import net.sf.json.JSONArray;
import wt.doc.WTDocument;
import wt.fc.PagingQueryResult;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.org.WTUser;
import wt.query.ClassAttribute;
import wt.query.OrderBy;
import wt.query.QuerySpec;
import wt.query.SearchCondition;
import wt.services.ServiceFactory;

public class EcprHelper {

	public static final EcprService service = ServiceFactory.getService(EcprService.class);
	public static final EcprHelper manager = new EcprHelper();
	
	public Map<String, Object> list(Map<String, Object> params) throws Exception{
		Map<String, Object> map = new HashMap<>();
		ArrayList<EcprColumn> list = new ArrayList<>();
		
		try{
			String name = StringUtil.checkNull((String)params.get("name"));
			String number = StringUtil.checkNull((String)params.get("number"));
			String state = StringUtil.checkNull((String)params.get("state"));
			String creator = StringUtil.checkNull((String)params.get("creator"));
			String createdFrom = StringUtil.checkNull((String)params.get("createdFrom"));
			String createdTo = StringUtil.checkNull((String)params.get("createdTo"));
			String approveFrom = StringUtil.checkNull((String)params.get("approveFrom"));
			String approveTo = StringUtil.checkNull((String)params.get("approveTo"));
			String writer = StringUtil.checkNull((String)params.get("writer"));
			String createDepart = StringUtil.checkNull((String)params.get("createDepart"));
			String writedFrom = StringUtil.checkNull((String)params.get("writedFrom"));
			String writedTo = StringUtil.checkNull((String)params.get("writedTo"));
			String proposer = StringUtil.checkNull((String)params.get("proposer"));
			String changeSection = StringUtil.checkNull((String)params.get("changeSection"));
			String model = StringUtil.checkNull((String)params.get("model"));
			
			QuerySpec query = new QuerySpec();
			int idx = query.appendClassList(ECPRRequest.class, true);
			
			//제목
			QuerySpecUtils.toLikeAnd(query, idx, ECPRRequest.class, ECPRRequest.EO_NAME, name);
			//번호
			QuerySpecUtils.toLikeAnd(query, idx, ECPRRequest.class, ECPRRequest.EO_NUMBER, number);
			//상태
			QuerySpecUtils.toState(query, idx, ECPRRequest.class, state);
			//등록자//creator.key.id
			QuerySpecUtils.creatorQuery(query, idx, ECPRRequest.class, creator);
			//등록일
			QuerySpecUtils.toTimeGreaterAndLess(query, idx, ECPRRequest.class, ECPRRequest.CREATE_TIMESTAMP, createdFrom,
					createdTo);
			//승인일
			QuerySpecUtils.toTimeGreaterAndLess(query, idx, ECPRRequest.class, ECPRRequest.APPROVE_DATE, approveFrom,
					approveTo);
			//작성자
			if(writer.length() > 0) {
				if( query.getConditionCount() > 0 ) {
					query.appendAnd();
				}
				query.appendWhere(new SearchCondition(ECPRRequest.class, ECPRRequest.WRITER, SearchCondition.LIKE , "%"+writer+"%", false), new int[] {idx});
			}
			//작성부서
			QuerySpecUtils.toLikeAnd(query, idx, ECPRRequest.class, ECPRRequest.CREATE_DEPART, createDepart);
			//작성일
			QuerySpecUtils.toTimeGreaterAndLess(query, idx, ECPRRequest.class, ECPRRequest.CREATE_DATE, writedFrom,
					writedTo);
			//제안자
			QuerySpecUtils.toLikeAnd(query, idx, ECPRRequest.class, ECPRRequest.PROPOSER, proposer);
			//변경구분
			QuerySpecUtils.toEqualsAnd(query, idx, ECPRRequest.class, ECPRRequest.CHANGE_SECTION, changeSection);
			//제품명
			QuerySpecUtils.toLikeAnd(query, idx, ECPRRequest.class, ECPRRequest.MODEL, model);
			
			SearchUtil.setOrderBy(query, ECPRRequest.class, idx, ECPRRequest.MODIFY_TIMESTAMP, "sort", true);
			
			PageQueryUtils pager = new PageQueryUtils(params, query);
			PagingQueryResult result = pager.find();
			while (result.hasMoreElements()) {
				Object[] obj = (Object[]) result.nextElement();
				EcprColumn column = new EcprColumn(obj);
				list.add(column);
			}
			map.put("list", list);
			map.put("topListCount", pager.getTotal());
			map.put("pageSize", pager.getPsize());
			map.put("total", pager.getTotalSize());
			map.put("sessionid", pager.getSessionId());
			map.put("curPage", pager.getCpage());
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return map;
	}
	
	/**
	 * 모델명 복수개로 인해서 처리 하는 함수
	 */
	public String displayToModel(String model) throws Exception {
		String display = "";
		if(model != null) {
			String[] ss = model.split(",");
			for (int i = 0; i < ss.length; i++) {
				String s = ss[i];
				if (ss.length - 1 == i) {
					display += NumberCodeHelper.manager.getNumberCodeName(s, "MODEL");
				} else {
					display += NumberCodeHelper.manager.getNumberCodeName(s, "MODEL") + ",";
				}
			}			
		}
		return display;
	}
	
	/**
	 * 변경구분 복수개로 인해서 처리 하는 함수
	 */
	public String displayToSection(String section) throws Exception {
		String display = "";
		if(section != null) {
			String[] ss = section.split(",");
			for (int i = 0; i < ss.length; i++) {
				String s = ss[i];
				if (ss.length - 1 == i) {
					display += NumberCodeHelper.manager.getNumberCodeName(s, "CHANGESECTION");
				} else {
					display += NumberCodeHelper.manager.getNumberCodeName(s, "CHANGESECTION") + ",";
				}
			}
		}
		return display;
	}
	
	/**
	 * 작성부서 코드 -> 값
	 */
	public String displayToDept(String dept) throws Exception {
		return NumberCodeHelper.manager.getNumberCodeName(dept, "DEPTCODE");
	}
	
	/**
	 * 관련 CR
	 */
	public JSONArray reference(String oid, String type) throws Exception {
		ArrayList<Map<String, Object>> list = new ArrayList<>();
		ECPRRequest ecpr = (ECPRRequest) CommonUtil.getObject(oid);
		if ("cr".equalsIgnoreCase(type)) {
			// CR
			return JSONArray.fromObject(referenceCr(ecpr, list));
		} else if ("MODEL".equalsIgnoreCase(type)) {
			// 제품명
			return JSONArray.fromObject(referenceCode(ecpr, list));
		}
		return JSONArray.fromObject(list);
	}
	
	private Object referenceCr(ECPRRequest ecpr, ArrayList<Map<String, Object>> list) throws Exception {
		QueryResult result = PersistenceHelper.manager.navigate(ecpr, "cr", CrToEcprLink.class);
		while (result.hasMoreElements()) {
			ECPRRequest doc = (ECPRRequest) result.nextElement();
			EcprColumn dto = new EcprColumn(doc);
			Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
			list.add(map);
		}
		return list;
	}
	
	private Object referenceCode(ECPRRequest ecpr, ArrayList<Map<String, Object>> list) throws Exception {
		String[] codes = ecpr.getModel() != null ? ecpr.getModel().split(",") : null;
		
		if(codes != null) {
			QuerySpec query = new QuerySpec();
			int idx = query.appendClassList(NumberCode.class, true);
			for(int i = 0; i < codes.length; i++) {
				QuerySpecUtils.toEqualsOr(query, idx, NumberCode.class, NumberCode.CODE, codes[i]);			
			}
			QuerySpecUtils.toEqualsAnd(query, idx, NumberCode.class, NumberCode.CODE_TYPE, "MODEL");
			QuerySpecUtils.toBooleanAnd(query, idx, NumberCode.class, NumberCode.DISABLED, false);
			QueryResult result = PersistenceHelper.manager.find(query);
			while (result.hasMoreElements()) {
				Object[] obj = (Object[]) result.nextElement();
				NumberCode n = (NumberCode) obj[0];
				NumberCodeDTO dto = new NumberCodeDTO(n);
				Map<String, Object> map = AUIGridUtil.dtoToMap(dto);
				list.add(map);
			}
		}
		return list;
	}
	
	/**
	 * 링크 관계 확인 ( true : 연결, false : 미연결 )
	 */
	public boolean isConnect(String oid) throws Exception {
		boolean isConnect = false;
		ECPRRequest ecpr = (ECPRRequest) CommonUtil.getObject(oid);
		QueryResult qr = PersistenceHelper.manager.navigate(ecpr, "cr", CrToEcprLink.class);
		isConnect = qr.size() > 0;
		return isConnect;
	}
}
