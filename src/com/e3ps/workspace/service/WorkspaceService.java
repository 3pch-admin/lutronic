package com.e3ps.workspace.service;

import java.util.ArrayList;
import java.util.Map;

import com.e3ps.workspace.WorkData;

import wt.fc.Persistable;
import wt.util.WTException;
import wt.workflow.work.WorkItem;

public interface WorkspaceService {

	/**
	 * 결재 데이터 데이터 컨버팅
	 */
	public abstract void convert() throws Exception;

	/**
	 * 결재 등록
	 */
	public abstract void register(WorkData data, Persistable per, String description,
			ArrayList<Map<String, String>> agreeRows, ArrayList<Map<String, String>> approvalRows,
			ArrayList<Map<String, String>> receiveRows) throws Exception;

	/**
	 * 자가결재
	 */
	public abstract void self(Persistable per) throws Exception;

	/**
	 * 
	 * 개인결재선 저장
	 */
	public abstract void save(Map<String, Object> params) throws Exception;

	/**
	 * 개인결재선 삭제 함수
	 */
	public abstract void delete(String oid) throws Exception;

	/**
	 * 개인결재선 즐겨찾기 저장 함수
	 */
	public abstract void favorite(Map<String, Object> params) throws Exception;

	/**
	 * 결재선 초기화
	 */
	public abstract void _reset(Map<String, ArrayList<String>> params) throws Exception;

	/**
	 * 결재 승인
	 */
	public abstract void _approval(Map<String, String> params) throws Exception;

	/**
	 * 결재 반려
	 */
	public abstract void _reject(Map<String, String> params) throws Exception;

	/**
	 * 결재 읽음 처리
	 */
	public abstract void read(String oid) throws Exception;

	/**
	 * 일괄 수신 처리
	 */
	public abstract void receives(Map<String, ArrayList<Map<String, String>>> params) throws Exception;

	/**
	 * 결재 및 합의 위임
	 */
	public abstract void delegate(Map<String, String> params) throws Exception;

	/**
	 * 수신 처리
	 */
	public abstract void _receive(Map<String, Object> params) throws Exception;

	/**
	 * 합의 처리
	 */
	public abstract void _agree(Map<String, String> params) throws Exception;

	WorkItem getWorkItem(Persistable per) throws WTException;

	/**
	 * 결재 이력 삭제
	 */
	public abstract Persistable removeHistory(Persistable per) throws Exception;

	/**
	 * 설변 활동 전용
	 * 
	 */
	public abstract void stand(Persistable per) throws Exception;

	/**
	 * 설변활동 결재 시작
	 */
	public abstract void start(Persistable per) throws Exception;

	/**
	 * 합의 반려
	 */
	public abstract void _unagree(Map<String, String> params) throws Exception;

	/**
	 * 결재 회수
	 */
	public abstract void withdraw(String oid, String remain) throws Exception;

	/**
	 * 모든 결재 정보를 초기화한다
	 */
	public abstract void resetLines(WorkData data) throws Exception;
}