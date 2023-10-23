package com.e3ps.change.eo.service;

import com.e3ps.change.EChangeOrder;
import com.e3ps.change.eo.dto.EoDTO;

import wt.method.RemoteInterface;

@RemoteInterface
public interface EoService {

	/**
	 * EO 등록 함수
	 */
	public abstract void create(EoDTO dto) throws Exception;

	/**
	 * EO 삭제 함수
	 */
	public abstract void delete(String oid) throws Exception;

	/**
	 * EO 수정
	 */
	public abstract void modify(EoDTO dto) throws Exception;

	/**
	 * EO 최종 승인후 호출될 함수
	 */
	public abstract void afterAction(EChangeOrder eo) throws Exception;
}
