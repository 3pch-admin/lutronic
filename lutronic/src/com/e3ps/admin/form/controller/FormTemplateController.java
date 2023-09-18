package com.e3ps.admin.form.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.e3ps.admin.form.service.FormTemplateHelper;
import com.e3ps.admin.form.service.FormTemplateService;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.code.service.NumberCodeHelper;
import com.e3ps.controller.BaseController;
import com.e3ps.doc.service.DocumentHelper;
import com.e3ps.groupware.notice.service.NoticeHelper;

@Controller
@RequestMapping(value = "/form/**")
public class FormTemplateController extends BaseController {

	@Description(value = "문서 템플릿 등록 페이지")
	@GetMapping(value = "/list")
	public ModelAndView list() throws Exception {
		ModelAndView model = new ModelAndView();
		ArrayList<NumberCode> formType = NumberCodeHelper.manager.getArrayCodeList("DOCFORMTYPE");
		model.addObject("formType", formType);
		model.setViewName("/extcore/jsp/admin/form/form-list.jsp");
		return model;
	}

	@Description(value = "문서 템플릿 조회 함수")
	@ResponseBody
	@PostMapping(value = "/list")
	public Map<String, Object> list(@RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result = FormTemplateHelper.manager.list(params);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}

	@Description(value = "문서 템플릿 등록 페이지")
	@GetMapping(value = "/create")
	public ModelAndView create() throws Exception {
		ModelAndView model = new ModelAndView();
		ArrayList<NumberCode> formType = NumberCodeHelper.manager.getArrayCodeList("DOCFORMTYPE");
		model.addObject("formType", formType);
		model.setViewName("/extcore/jsp/admin/form/form-create.jsp");
		return model;
	}

	@Description(value = "문서 템플릿 등록")
	@ResponseBody
	@PostMapping(value = "/create")
	public Map<String, Object> create(@RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			FormTemplateHelper.service.create(params);
			result.put("msg", SAVE_MSG);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}
}