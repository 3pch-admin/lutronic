package com.e3ps.org.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONObject;
import wt.method.RemoteInterface;

import com.e3ps.org.Department;

@RemoteInterface
public interface OrgService {

	JSONObject getDepartmentTree(Department root) throws Exception;

	/**
	 * 루트 부서 생성
	 */
	public abstract Department makeRoot() throws Exception;

	/**
	 * 사용자 객체 생성, 서버 시작시 이벤트 발생
	 */
	public abstract void inspectUser(Department department) throws Exception;

	/**
	 * 조직도 그리드 저장 함수
	 */
	public abstract void save(ArrayList<LinkedHashMap<String, Object>> editRows) throws Exception;

	/**
	 * 윈칠 사용자 로더 -> 개발용
	 */
	public abstract void loaderUser(String path) throws Exception;

	/**
	 * 사용자 정보 수정
	 */
	public abstract void modify(Map<String, Object> params) throws Exception;

	/**
	 * 서명 로더
	 */
	public abstract void loaderSign() throws Exception;

}
