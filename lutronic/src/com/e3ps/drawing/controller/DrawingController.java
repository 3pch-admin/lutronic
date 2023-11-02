package com.e3ps.drawing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.e3ps.common.beans.ResultData;
import com.e3ps.common.code.NumberCode;
import com.e3ps.common.code.service.NumberCodeHelper;
import com.e3ps.common.content.FileRequest;
import com.e3ps.common.message.Message;
import com.e3ps.common.util.CommonUtil;
import com.e3ps.common.util.ControllerUtil;
import com.e3ps.common.util.StringUtil;
import com.e3ps.controller.BaseController;
import com.e3ps.doc.dto.DocumentDTO;
import com.e3ps.doc.service.DocumentHelper;
import com.e3ps.drawing.beans.EpmData;
import com.e3ps.drawing.service.DrawingHelper;
import com.e3ps.drawing.service.EpmSearchHelper;
import com.e3ps.mold.dto.MoldDTO;
import com.e3ps.mold.service.MoldHelper;
import com.e3ps.part.service.PartHelper;

import wt.doc.WTDocument;
import wt.epm.EPMDocument;
import wt.epm.EPMDocumentMaster;
import wt.epm.structure.EPMReferenceLink;
import wt.org.WTUser;
import wt.part.QuantityUnit;
import wt.part.WTPart;
import wt.session.SessionHelper;
import wt.util.WTException;

@Controller
@RequestMapping(value = "/drawing/**")
public class DrawingController extends BaseController{
	
	@Description(value = "도면 검색 페이지")
	@GetMapping(value = "/list")
	public ModelAndView list() throws Exception{
		ArrayList<NumberCode> modelList = NumberCodeHelper.manager.getArrayCodeList("MODEL");
		ArrayList<NumberCode> deptcodeList = NumberCodeHelper.manager.getArrayCodeList("DEPTCODE");
		ArrayList<NumberCode> productmethodList = NumberCodeHelper.manager.getArrayCodeList("PRODUCTMETHOD");
		ArrayList<NumberCode> manufactureList = NumberCodeHelper.manager.getArrayCodeList("MANUFACTURE");
		ArrayList<NumberCode> matList = NumberCodeHelper.manager.getArrayCodeList("MAT");
		ArrayList<NumberCode> finishList = NumberCodeHelper.manager.getArrayCodeList("FINISH");
		List<Map<String,String>> cadTypeList = DrawingHelper.manager.cadTypeList();
		QuantityUnit[] unitList = QuantityUnit.getQuantityUnitSet();
		WTUser sessionUser  = (WTUser) SessionHelper.manager.getPrincipal();
		ModelAndView model = new ModelAndView();
		model.addObject("modelList", modelList);
		model.addObject("deptcodeList", deptcodeList);
		model.addObject("matList", matList);
		model.addObject("productmethodList", productmethodList);
		model.addObject("manufactureList", manufactureList);
		model.addObject("finishList", finishList);
		model.addObject("sessionUser", sessionUser);
		model.addObject("cadTypeList", cadTypeList);
		model.addObject("unitList", unitList);
		model.setViewName("/extcore/jsp/drawing/drawing-list.jsp");
		return model;
	}
	
	@Description(value = "도면 등록 페이지")
	@GetMapping(value = "/create")
	public ModelAndView create() {
		ModelAndView model = new ModelAndView();
		model.setViewName("/extcore/jsp/drawing/drawing-create.jsp");
		return model;
	}
	
	@Description(value = "도면 일괄 등록 페이지")
	@GetMapping(value = "/batch")
	public ModelAndView batch() throws Exception{
		ModelAndView model = new ModelAndView();
		model.setViewName("/extcore/jsp/drawing/drawing-batch.jsp");
		return model;
	}
	
	@Description(value = "도면 일괄 등록")
	@ResponseBody
	@PostMapping(value = "/batch")
	public Map<String, Object> batch(@RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			ArrayList<Map<String, Object>> gridData = (ArrayList<Map<String, Object>>) params.get("gridData");
			for (Map<String, Object> data : gridData) {
				ArrayList<Map<String, Object>> rows91 = (ArrayList<Map<String, Object>>) data.get("rows91");
				if (DrawingHelper.manager.isExist(rows91)) {
					result.put("result", FAIL);
					result.put("msg", "주 도면이 존재합니다.");
					return result;
				}
			}
			DrawingHelper.service.batch(gridData);
			result.put("msg", SAVE_MSG);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}
	
	@Description(value = "도면 검색 리스트 리턴")
	@ResponseBody
	@PostMapping(value = "/list")
	public Map<String,Object> list(@RequestBody Map<String, Object> params) {
		Map<String,Object> result = new HashMap<String, Object>();
		try {
			result = DrawingHelper.manager.list(params);
			result.put("result", SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}
	
	@Description(value = "도면 등록 함수")
	@ResponseBody
	@PostMapping(value = "/create")
	public Map<String,Object> create(@RequestBody Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			DrawingHelper.service.create(params);
			result.put("msg", SAVE_MSG);
			result.put("result", SUCCESS);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}
	
	@Description(value = "도면 상세 페이지")
	@GetMapping(value =  "/view")
	public ModelAndView view(@RequestParam String oid) throws Exception{
		ModelAndView model = new ModelAndView();
		EPMDocument doc = (EPMDocument)CommonUtil.getObject(oid);
		EpmData dto = new EpmData(doc);
		
		boolean isAdmin = CommonUtil.isAdmin();
		model.addObject("isAdmin", isAdmin);
		model.addObject("dto", dto);
		model.setViewName("/extcore/jsp/drawing/drawing-view.jsp");
		return model;
	}
	
	@Description(value = "도면 최신버전 이동")
	@GetMapping(value = "/latest")
	public ModelAndView latest(@RequestParam String oid) throws Exception {
		ModelAndView model = new ModelAndView();
		EPMDocument latest = DrawingHelper.manager.latest(oid);
		boolean isAdmin = CommonUtil.isAdmin();
		EpmData dto = new EpmData(latest);
		model.addObject("isAdmin", isAdmin);
		model.addObject("dto", dto);
		model.setViewName("popup:/drawing/drawing-view");
		return model;
	}
	
	/** CAD 구분 리스트 리턴
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/cadDivisionList")
	public List<Map<String,String>> cadDivisionList(HttpServletRequest request, HttpServletResponse response) {
		List<Map<String,String>> list = DrawingHelper.service.cadDivisionList();
		return list;
	}
	
	/** CAD 타입 리스트 리턴
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/cadTypeList")
	public List<Map<String,String>> cadTypeList(HttpServletRequest request, HttpServletResponse response) {
		List<Map<String,String>> list = DrawingHelper.service.cadTypeList();
		return list;
	}
	
	@RequestMapping("/include_Reference")
	public ModelAndView include_Reference(HttpServletRequest request, HttpServletResponse response) {
		String title = StringUtil.checkReplaceStr(request.getParameter("title"),"참조");
		String moduleType = request.getParameter("moduleType");
		String oid = request.getParameter("oid");
		String distribute = StringUtil.checkNull(request.getParameter("distribute"));
		List<EpmData> list = null;
		try {
			list = DrawingHelper.service.include_Reference(oid,moduleType);
			// HashSet 데이터 형태로 생성되면서 중복 제거됨
			HashSet<EpmData> hs = new HashSet<EpmData>(list);

			// ArrayList 형태로 다시 생성
			list = new ArrayList<EpmData>(hs);
		} catch(Exception e) {
			list = new ArrayList<EpmData>();
			e.printStackTrace();
		}
		ModelAndView model = new ModelAndView();
		model.setViewName("include:/drawing/include_Reference");
		model.addObject("title",title);
		model.addObject("moduleType", moduleType);
		model.addObject("list", list);
		model.addObject("distribute",distribute);
		return model;
	}
	
	@Description(value = "참조 항목")
	@PostMapping("/include_ReferenceBy")
	@ResponseBody
	public Map<String,Object> include_ReferenceBy(@RequestBody Map<String, Object> params) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		String title = StringUtil.checkReplaceStr((String)params.get("title"),"참조 항목");
		String distribute = StringUtil.checkNull((String)params.get("distribute"));
		
		List<EpmData> list = new ArrayList<EpmData>();
		String oid = (String)params.get("oid");
		if(StringUtil.checkString(oid)) {
			EPMDocument epm = (EPMDocument)CommonUtil.getObject(oid);
			List<EPMReferenceLink> refList = EpmSearchHelper.service.getEPMReferenceList((EPMDocumentMaster)epm.getMaster());
			for(EPMReferenceLink link : refList) {
				EPMDocument epmdoc = link.getReferencedBy();
				EpmData data = new EpmData(epmdoc);
				
				data.setLinkRefernceType(link.getReferenceType().getDisplay(Message.getLocale()));
				
				list.add(data);
			}
		}
		result.put("title",title);
		result.put("list", list);
		result.put("distribute", distribute);
		return result;
	}
	
	@Description(value = "도면 삭제")
	@ResponseBody
	@PostMapping(value = "/delete")
	public Map<String,Object> deleteDrwaingAction(HttpServletRequest request, HttpServletResponse response, @RequestParam("oid")String oid) {
		Map<String,Object> result = DrawingHelper.service.delete(oid);
		if ((boolean) result.get("result")) {
			result.put("msg", DELETE_MSG);
			result.put("result", SUCCESS);
		} else {
			result.put("result", FAIL);
			result.put("msg", (String) result.get("msg"));
		}
		return result;
	}
	
	/** 도면 선택 페이지
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/selectDrawingPopup")
	public ModelAndView selectDrawingPopup(HttpServletRequest request, HttpServletResponse response) {
		String mode = StringUtil.checkReplaceStr(request.getParameter("mode"), "mutil");
		ModelAndView model = new ModelAndView();
		model.addObject("mode", mode);
		model.setViewName("popup:/drawing/selectDrawingPopup");
		return model;
	}
	
	@Description(value = "도면 수정 페이지")
	@GetMapping(value = "/update")
	public ModelAndView update(@RequestParam String oid) throws Exception {
		ModelAndView model = new ModelAndView();
		EPMDocument epm = (EPMDocument)CommonUtil.getObject(oid);
		EpmData dto = new EpmData(epm);
		model.addObject("dto", dto);
		model.setViewName("/extcore/jsp/drawing/drawing-update.jsp");
		return model;
	}
	
	@Description(value = "도면 수정 함수")
	@ResponseBody
	@PostMapping(value = "/update")
	public Map<String,Object> update(@RequestBody Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			DrawingHelper.service.update(params);
			result.put("msg", MODIFY_MSG);
			result.put("result", SUCCESS);
		} catch(Exception e) {
			e.printStackTrace();
			result.put("result", FAIL);
			result.put("msg", e.toString());
		}
		return result;
	}
	
	/** 관련 도면 추가
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/include_DrawingSelect")
	public ModelAndView include_DrawingSelect(HttpServletRequest request, HttpServletResponse response) {
		String moduleType = request.getParameter("moduleType");
		String oid = request.getParameter("oid");
		String title = request.getParameter("title");
		String paramName = request.getParameter("paramName");
		String epmType = StringUtil.checkReplaceStr(request.getParameter("epmType"),"");
		
		List<EpmData> list = null;
		try {
			list = DrawingHelper.service.include_DrawingList(oid,moduleType, epmType);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		ModelAndView model = new ModelAndView();
		model.addObject("moduleType", moduleType);
		model.addObject("oid", oid);
		model.addObject("title", title);
		model.addObject("paramName", paramName);
		model.addObject("list", list);
		model.setViewName("include:/drawing/include_DrawingSelect");
		return model;
	}
	
	/** 관련 도면 보기
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/include_DrawingView")
	public ModelAndView include_DrawingView(HttpServletRequest request, HttpServletResponse response) {
		String moduleType = request.getParameter("moduleType");
		String oid = request.getParameter("oid");
		String title = request.getParameter("title");
		String paramName = request.getParameter("paramName");
		String epmType = StringUtil.checkReplaceStr(request.getParameter("epmType"),"");
		String distribute = StringUtil.checkNull(request.getParameter("distribute"));
		//System.out.println("include_DrawingView distribute =" + distribute);
		List<EpmData> list = null;
		try {
			list = DrawingHelper.service.include_DrawingList(oid,moduleType,epmType);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		ModelAndView model = new ModelAndView();
		model.addObject("moduleType", moduleType);
		model.addObject("epmType", epmType);
		model.addObject("oid", oid);
		model.addObject("title", title);
		model.addObject("paramName", paramName);
		model.addObject("list", list);
		model.addObject("distribute", distribute);
		model.setViewName("include:/drawing/include_DrawingView");
		return model;
	}
	
	/** 도면 미리보기
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/thumbview")
	public ModelAndView thumbview(HttpServletRequest request, HttpServletResponse response){
		ModelAndView model = new ModelAndView();
		
		Map<String, Object> thumbInfoMap;
		try {
			thumbInfoMap = DrawingHelper.service.thumbView(request);
			model.addAllObjects(thumbInfoMap);
		} catch (WTException e) {
			e.printStackTrace();
		}
		model.setViewName("include:/drawing/thumbview");
		return model;
	}
	
	@RequestMapping("/include_drawingLink")
	public ModelAndView include_drawingLink(HttpServletRequest request, HttpServletResponse response) {
		String module = request.getParameter("module");
		String oid = request.getParameter("oid");
		String title = StringUtil.checkReplaceStr(request.getParameter("title"), Message.get("관련 도면"));
		String enabled = StringUtil.checkReplaceStr(request.getParameter("enabled"), "false");
		
		List<EpmData> list = DrawingHelper.service.include_drawingLink(module, oid);
		
		ModelAndView model = new ModelAndView();
		model.setViewName("empty:/drawing/include_drawingLink");
		model.addObject("module", module);
		model.addObject("oid", oid);
		model.addObject("title", title);
		model.addObject("list", list);
		model.addObject("enabled", Boolean.valueOf(enabled));
		return model;
	}
	
	@ResponseBody
	@RequestMapping("/linkDrawingAction")
	public ResultData linkDrawingAction(HttpServletRequest request, HttpServletResponse response) {
		return DrawingHelper.service.linkDrawingAction(request, response);
	}
	
	@ResponseBody
	@RequestMapping("/deleteDrwaingLinkAction")
	public ResultData deleteDrwaingLinkAction(HttpServletRequest request, HttpServletResponse response) {
		return DrawingHelper.service.deleteDrawingLinkAction(request, response);
	}
	
	
	
	/** 도면 삭제
	 * @param request
	 * @param response
	 * @param oid
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/updateNameAction")
	public ResultData updateNameAction(HttpServletRequest request, HttpServletResponse response, @RequestParam("oid")String oid) {
	
		return DrawingHelper.service.updateNameAction(request, response);
	}
	
	@RequestMapping("/createPackageDrawing")
	public ModelAndView createPackageDrawing(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.addObject("menu", "menu3");
		model.addObject("module","drawing");
		model.setViewName("default:/drawing/createPackageDrawing");
		return model;
	}
	
	@RequestMapping("/createPackageDrawingAction")
	public ModelAndView createPackageDrawingAction(HttpServletRequest request, HttpServletResponse response) {
		String xmlString = "";

		xmlString = DrawingHelper.service.createPackageDrawingAction(request, response);
		
		ModelAndView model = new ModelAndView();
		model.addObject("xmlString", xmlString);
		model.setViewName("empty:/drawing/createPackageDrawingAction");
		return model;
	}
	/**  BOM Drawing 다운
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="partTreeDrawingDown")
	public ModelAndView partTreeDrawingDown(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		
		try {
			DrawingHelper.service.partTreeDrawingDown(request, response);
			
			
			
		} catch(Exception e) {
			e.printStackTrace();
		}
				//model.addObject("xmlString", xmlString);
				model.setViewName("empty:/drawing/createPackageDrawingAction");
		return model;
	}
	
	@ResponseBody
	@RequestMapping("/cadRePublish")
	public ResultData cadRePublish(HttpServletRequest request, HttpServletResponse response) {
		
		String oid = StringUtil.checkNull(request.getParameter("oid"));
		
		return EpmSearchHelper.service.cadRePublish(oid);
		
	}
	
	/**  부품 상태 수정
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/showThumAction")
	public Map<String,Object> showThumAction(HttpServletRequest request, HttpServletResponse response) {
		Map<String,Object> map = new HashMap<String, Object>();
		
		try{
			String oid = request.getParameter("oid");
			EPMDocument epm = (EPMDocument) CommonUtil.getObject(oid);
			EpmData data = new EpmData(epm);
			
			if(data.getThum() != null) {
				String num = data.number.replaceAll(" ", "_");
				String imgpath = data.getThum();
				String copyTag = data.getCopyTag();
				map.put("num", num);
				map.put("imgpath", imgpath);
				map.put("copyTag", copyTag);
				map.put("result", true);
			}else{
				map.put("result", false);
			}
			
		}catch(Exception e){
			e.printStackTrace();
			map.put("result", false);
		}
		
		
		return map;
	}
}
