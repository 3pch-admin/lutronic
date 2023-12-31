package com.e3ps.org.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.e3ps.common.util.CommonUtil;
import com.e3ps.controller.BaseController;
import com.e3ps.groupware.service.GroupwareHelper;
import com.e3ps.org.Department;
import com.e3ps.org.dto.PeopleDTO;
import com.e3ps.org.service.DepartmentHelper;
import com.e3ps.org.service.OrgHelper;

import net.sf.json.JSONArray;
import wt.org.WTUser;

@Controller
@RequestMapping(value = "/org/**")
public class OrgController extends BaseController {

	@Description(value = "사용자 정보")
	@PostMapping(value = "/finder")
	@ResponseBody
	public Map<String, Object> finder(@RequestBody Map<String, String> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			ArrayList<Map<String, String>> list = OrgHelper.manager.finder(params);
			result.put("result", SUCCESS);
			result.put("list", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", e.toString());
			result.put("result", FAIL);
		}
		return result;
	}

	@Description(value = "조직도 페이지")
	@GetMapping(value = "/organization")
	public ModelAndView organization() throws Exception {
		ModelAndView model = new ModelAndView();
		boolean isAdmin = CommonUtil.isAdmin();
		Department root = DepartmentHelper.manager.getRoot();
		ArrayList<Map<String, String>> list = DepartmentHelper.manager.getAllDepartmentList();
		model.addObject("list", JSONArray.fromObject(list));
		model.addObject("oid", root.getPersistInfo().getObjectIdentifier().getStringValue());
		model.addObject("isAdmin", isAdmin);
		model.setViewName("/extcore/jsp/workspace/organization-list.jsp");
		return model;
	}

	@Description(value = "조직도 조회 함수")
	@ResponseBody
	@PostMapping(value = "/organization")
	public Map<String, Object> organization(@RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result = OrgHelper.manager.organization(params);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}

	@Description(value = "조직도 그리드 저장 함수")
	@PostMapping(value = "/save")
	@ResponseBody
	public Map<String, Object> save(@RequestBody Map<String, ArrayList<LinkedHashMap<String, Object>>> params)
			throws Exception {
		ArrayList<LinkedHashMap<String, Object>> editRows = params.get("editRows");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			OrgHelper.service.save(editRows);
			result.put("result", SUCCESS);
			result.put("msg", SAVE_MSG);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}

	@Description(value = "조직도 페이지 팝업")
	@GetMapping(value = "/popup")
	public ModelAndView popup(String multi, String openerId) throws Exception {
		ModelAndView model = new ModelAndView();
		Department root = DepartmentHelper.manager.getRoot();
		model.addObject("oid", root.getPersistInfo().getObjectIdentifier().getStringValue());
		model.addObject("multi", multi);
		model.addObject("openerId", openerId);
		model.setViewName("popup:/workspace/organization-popup");
		return model;
	}

	@Description(value = "부서명 가져오기")
	@ResponseBody
	@GetMapping(value = "/department")
	public Map<String, Object> department(@RequestParam String oid) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			String department_name = OrgHelper.manager.department(oid);
			result.put("department_name", department_name);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}

	@Description(value = "결재선 지정 홤녀에서 부서별 사용자 리스트 가져오기")
	@GetMapping(value = "/load1000")
	@ResponseBody
	public Map<String, Object> load1000(@RequestParam String oid) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			ArrayList<PeopleDTO> list = OrgHelper.manager.load1000(oid);
			result.put("list", list);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", e.toString());
			result.put("result", FAIL);
		}
		return result;
	}
	
	@Description(value = "사용자 정보상세")
	@GetMapping(value = "/view")
	public ModelAndView view(@RequestParam String oid) throws Exception {
		ModelAndView model = new ModelAndView();
		boolean isAdmin = CommonUtil.isAdmin();
		WTUser user = (WTUser) CommonUtil.getObject(oid);
		PeopleDTO dto = new PeopleDTO(user);
		model.addObject("isAdmin", isAdmin);
		model.addObject("dto", dto);
		model.setViewName("popup:/workspace/user-view");
		return model;
	}
	
	@Description(value = "사용자 정보 수정 페이지")
	@GetMapping(value = "/modify")
	public ModelAndView modify(@RequestParam String oid) throws Exception {
		ModelAndView model = new ModelAndView();
		boolean isAdmin = CommonUtil.isAdmin();
		WTUser user = (WTUser) CommonUtil.getObject(oid);
		PeopleDTO dto = new PeopleDTO(user);
		model.addObject("isAdmin", isAdmin);
		model.addObject("dto", dto);
		model.setViewName("popup:/workspace/user-modify");
		return model;
	}
	
	@Description(value = "사용자 정보 수정")
	@PostMapping(value = "/modify")
	@ResponseBody
	public Map<String, Object> modify(@RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			OrgHelper.service.modify(params);
			result.put("msg", MODIFY_MSG);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", e.toString());
			result.put("result", FAIL);
		}
		return result;
	}
	
}
