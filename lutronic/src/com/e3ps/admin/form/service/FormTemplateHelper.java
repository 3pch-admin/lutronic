package com.e3ps.admin.form.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.e3ps.admin.form.FormTemplate;
import com.e3ps.admin.form.dto.FormTemplateDTO;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.code.NumberCodeType;
import com.e3ps.common.util.PageQueryUtils;
import com.e3ps.common.util.QuerySpecUtils;

import wt.fc.PagingQueryResult;
import wt.fc.PersistenceHelper;
import wt.fc.QueryResult;
import wt.query.QuerySpec;
import wt.services.ServiceFactory;

public class FormTemplateHelper {

	public static final FormTemplateService service = ServiceFactory.getService(FormTemplateService.class);
	public static final FormTemplateHelper manager = new FormTemplateHelper();

	public Map<String, Object> list(Map<String, Object> params) throws Exception {
		Map<String, Object> map = new HashMap<>();
		ArrayList<FormTemplateDTO> list = new ArrayList<>();

		String name = (String) params.get("name");
		String formType = (String) params.get("formType");

		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(FormTemplate.class, true);
		QuerySpecUtils.toLikeAnd(query, idx, FormTemplate.class, FormTemplate.NAME, name);
		QuerySpecUtils.toEqualsAnd(query, idx, FormTemplate.class, FormTemplate.FORM_TYPE, formType);

		QuerySpecUtils.toOrderBy(query, idx, FormTemplate.class, FormTemplate.MODIFY_TIMESTAMP, true);

		PageQueryUtils pager = new PageQueryUtils(params, query);
		PagingQueryResult result = pager.find();
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			FormTemplate formTemplate = (FormTemplate) obj[0];
			FormTemplateDTO data = new FormTemplateDTO(formTemplate);
			list.add(data);
		}

		map.put("list", list);
		map.put("topListCount", pager.getTotal());
		map.put("pageSize", pager.getPsize());
		map.put("total", pager.getTotalSize());
		map.put("sessionid", pager.getSessionId());
		map.put("curPage", pager.getCpage());
		return map;
	}

	/**
	 * 문서 양식 템플릿 배열
	 */
	public ArrayList<FormTemplate> array() throws Exception {
		ArrayList<FormTemplate> list = new ArrayList<FormTemplate>();
		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(FormTemplate.class, true);
		QuerySpecUtils.toOrderBy(query, idx, FormTemplate.class, FormTemplate.NAME, false);
		QueryResult result = PersistenceHelper.manager.find(query);
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			FormTemplate form = (FormTemplate) obj[0];
			list.add(form);
		}
		return list;
	}

	/**
	 * 문서 타입에 따른 양식 가져오기
	 */
	public ArrayList<FormTemplate> getDataForType(String classType) throws Exception {
		ArrayList<FormTemplate> list = new ArrayList<FormTemplate>();
		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(FormTemplate.class, true);
		QuerySpecUtils.toEqualsAnd(query, idx, FormTemplate.class, FormTemplate.FORM_TYPE, classType);
		QuerySpecUtils.toOrderBy(query, idx, FormTemplate.class, FormTemplate.NAME, false);
		QueryResult result = PersistenceHelper.manager.find(query);
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			FormTemplate form = (FormTemplate) obj[0];
			list.add(form);
		}
		return list;
	}

	/**
	 * 문서 양식 템플릿 이름으로 가져오기
	 */
	public FormTemplate getTemplate(String formType) throws Exception {
		QuerySpec query = new QuerySpec();
		int idx = query.appendClassList(FormTemplate.class, true);
		QuerySpecUtils.toEqualsAnd(query, idx, FormTemplate.class, FormTemplate.FORM_TYPE, formType);
		QueryResult result = PersistenceHelper.manager.find(query);
		while (result.hasMoreElements()) {
			Object[] obj = (Object[]) result.nextElement();
			return (FormTemplate) obj[0];
		}
		return null;
	}
}
