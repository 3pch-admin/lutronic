package com.e3ps.rohs.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.e3ps.common.beans.ResultData;
import com.e3ps.rohs.dto.RohsData;

import wt.enterprise.RevisionControlled;
import wt.method.RemoteInterface;
import wt.part.WTPart;
import wt.util.WTException;

@RemoteInterface
public interface RohsService {

	List<Map<String, String>> rohsFileType();

	List<RohsData> include_RohsList(String oid) throws Exception;

	Map<String, Object> delete(String oid) throws Exception;

	void createROHSToPartLink(RevisionControlled rv, String[] oids) throws WTException;

	List<RohsData> include_RohsView(String oid, String module, String roleType) throws Exception;

	void revisePartToROHSLink(WTPart oldPart, WTPart newPart) throws Exception;

	ResultData batchROHSDown(HttpServletRequest request, HttpServletResponse response);

	public void create(Map<String, Object> params) throws Exception;

	public void batch(Map<String, Object> params) throws Exception;

	public void update(Map<String, Object> params) throws Exception;

	public void copyRohs(Map<String, Object> params) throws Exception;

	public void reviseRohs(Map<String, Object> params) throws Exception;

	/**
	 * 물질 일광 링크
	 */
	public abstract void link(Map<String, Object> params) throws Exception;
}
