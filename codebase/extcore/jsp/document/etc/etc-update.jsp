<%@page import="com.e3ps.doc.etc.dto.EtcDTO"%>
<%@page import="wt.doc.DocumentType"%>
<%@page import="com.e3ps.admin.form.FormTemplate"%>
<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="com.e3ps.doc.etc.service.EtcHelper"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> preserationList = (ArrayList<NumberCode>) request.getAttribute("preserationList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
ArrayList<FormTemplate> form = (ArrayList<FormTemplate>) request.getAttribute("form");
EtcDTO dto = (EtcDTO) request.getAttribute("dto");
String mode = (String) request.getAttribute("mode");
String type = (String) request.getAttribute("type");
String location = (String) request.getAttribute("location");
String title = "";
if ("modify".equals(mode)) {
	title = "수정";
} else if ("revise".equals(mode)) {
	title = "개정";
}
%>
<style type="text/css">
iframe {
	margin-top: 3px;
}
</style>
<script type="text/javascript" src="/Windchill/extcore/dext5editor/js/dext5editor.js"></script>
<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				문서
				<%=title%>
			</div>
		</td>
		<td class="right">
			<input type="button" value="<%=title%>" title="<%=title%>" class="blue" onclick="<%=mode%>('false');">
			<input type="button" value="임시저장" title="임시저장" class="" onclick="<%=mode%>('true');">
			<input type="button" value="닫기" title="닫기" class="gray" onclick="self.close();">
		</td>
	</tr>
</table>
<table class="create-table">
	<colgroup>
		<col width="150">
		<col width="*">
		<col width="150">
		<col width="*">
		<col width="150">
		<col width="*">
	</colgroup>
	<tr>
		<th class="req lb">문서분류</th>
		<td class="indent5">
			<input type="hidden" name="location" id="location" value="<%=dto.getLocation()%>">
			<span id="locationText"><%=dto.getLocation()%></span>
			<input type="button" value="폴더선택" title="폴더선택" onclick="folder();" class="blue">
		</td>
		<th>개정/수정사유</th>
		<td class="indent5">
			<input type="text" name="iterationNote" id="iterationNote" class="width-300">
		</td>
		<th class="req">문서 템플릿</th>
		<td class="indent5">
			<select name="formType" id="formType" class="width-200" onchange="loadForm();">
				<option value="">선택</option>
				<%
				for (FormTemplate formType : form) {
				%>
				<option value="<%=formType.getPersistInfo().getObjectIdentifier().getStringValue()%>"><%=formType.getName()%></option>
				<%
				}
				%>
			</select>
		</td>
	</tr>
	<tr>
		<th class="req lb">병리연구 문서명</th>
		<td class="indent5">
			<input type="text" name="docName" id="docName" class="width-300" value="<%=dto.getName()%>">
		</td>
		<th>내부 문서번호</th>
		<td class="indent5">
			<input type="text" name="interalnumber" id="interalnumber" class="width-200" value="<%=dto.getInteralnumber()%>">
		</td>
		<th class="req">결재방식</th>
		<td>
			&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="lifecycle" value="LC_Default" checked="checked">
				<div class="state p-success">
					<label>
						<b>기본결재</b>
					</label>
				</div>
			</div>
			&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="lifecycle" value="LC_Default_NonWF">
				<div class="state p-success">
					<label>
						<b>일괄결재</b>
					</label>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<th class="req lb">보존기간</th>
		<td class="indent5">
			<select name="preseration" id="preseration" class="width-200">
				<%
				for (NumberCode preseration : preserationList) {
					// 코드로 처리
					boolean selected = preseration.getCode().equals(dto.getPreseration_code());
				%>
				<option value="<%=preseration.getCode()%>" <%if (selected) {%> selected="selected" <%}%>><%=preseration.getName()%></option>
				<%
				}
				%>
			</select>
		</td>
		<th>프로젝트코드</th>
		<td class="indent5">
			<select name="model" id="model" class="width-200">
				<option value="">선택</option>
				<%
				for (NumberCode model : modelList) {
					boolean selected = model.getCode().equals(dto.getModel_code());
				%>
				<option value="<%=model.getCode()%>" <%if (selected) {%> selected="selected" <%}%>><%=model.getName()%></option>
				<%
				}
				%>
			</select>
		</td>
	</tr>
	<tr>
		<th class="lb">부서</th>
		<td class="indent5">
			<select name="deptcode" id="deptcode" class="width-200">
				<option value="">선택</option>
				<%
				for (NumberCode deptcode : deptcodeList) {
					boolean selected = deptcode.getCode().equals(dto.getDeptcode_code());
				%>
				<option value="<%=deptcode.getCode()%>" <%if (selected) {%> selected="selected" <%}%>><%=deptcode.getName()%></option>
				<%
				}
				%>
			</select>
		</td>

		<th>작성자</th>
		<td class="indent5">
			<input type="text" name="writer" id="writer" data-multi="false" class="width-200" value="<%=dto.getWriter()%>">
		</td>
	</tr>
	<tr>
		<th class="lb">내용</th>
		<td colspan="5" class="indent7 pb8">
			<textarea name="contents" id="contents" rows="15" style="display: none;"><%=dto.getContent() != null ? dto.getContent() : ""%></textarea>
			<script type="text/javascript">
				new Dext5editor('content');
				const content = document.getElementById("contents").value;
				DEXT5.setBodyValue(content, 'content');
			</script>
		</td>
	</tr>
	<tr>
		<th class="lb">문서설명</th>
		<td colspan="5" class="indent5">
			<textarea name="description" id="description" rows="5"><%=dto.getDescription()%></textarea>
		</td>
	</tr>
	<tr>
		<th class="req lb">주 첨부파일</th>
		<td class="indent5" colspan="5">
			<jsp:include page="/extcore/jsp/common/attach-primary.jsp">
				<jsp:param value="<%=dto.getOid()%>" name="oid" />
			</jsp:include>
		</td>
	</tr>
	<tr>
		<th class="lb">첨부파일</th>
		<td class="indent5" colspan="5">
			<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
				<jsp:param value="<%=dto.getOid()%>" name="oid" />
			</jsp:include>
		</td>
	</tr>
</table>

<!-- 관련 품목 -->
<jsp:include page="/extcore/jsp/part/include/part-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>

<!-- 	관련 문서 -->
<jsp:include page="/extcore/jsp/document/include/document-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>

<!-- 	관련 EO -->
<jsp:include page="/extcore/jsp/change/eo/include/eo-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>

<!-- 	관련 CR -->
<jsp:include page="/extcore/jsp/change/cr/include/cr-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>

<!-- 	관련 ECPR -->
<jsp:include page="/extcore/jsp/change/ecpr/include/ecpr-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>

<!-- 	관련 ECO -->
<jsp:include page="/extcore/jsp/change/eco/include/eco-include.jsp">
	<jsp:param value="<%=dto.getOid()%>" name="oid" />
	<jsp:param value="update" name="mode" />
	<jsp:param value="true" name="multi" />
	<jsp:param value="250" name="height" />
	<jsp:param value="true" name="header" />
</jsp:include>
<table class="button-table">
	<tr>
		<td class="center">
			<input type="button" value="<%=title%>" title="<%=title%>" class="blue" onclick="<%=mode%>('false');">
			<input type="button" value="임시저장" title="임시저장" class="" onclick="<%=mode%>('true');">
			<input type="button" value="닫기" title="닫기" class="gray" onclick="self.close();">
		</td>
	</tr>
</table>
<script type="text/javascript">
	function folder() {
		const location = decodeURIComponent("<%=location%>");
		const url = getCallUrl("/folder/popup?location=" + location);
		_popup(url, 500, 600, "n");
	}

	function loadForm() {
		const oid = document.getElementById("formType").value;
		if (oid === "") {
			return false;
		}
		const url = getCallUrl("/form/html?oid=" + oid);
		parent.openLayer();
		call(url, null, function(data) {
			if (data.result) {
				DEXT5.setBodyValue(data.html, 'content');
			} else {
				alert(data.msg);
			}
			parent.closeLayer();
		}, "GET");
	}

	// 문서 등록
	function <%=mode%>(temp) {
		// temp 임시저장 여부 처리
		const oid = document.getElementById("oid").value;
		const location = document.getElementById("location");
		const formType = document.getElementById("formType");
		const name = document.getElementById("docName");
		const description = document.getElementById("description");
		const lifecycle = document.querySelector("input[name=lifecycle]:checked").value;
		const secondarys = toArray("secondarys");
		const primary = document.querySelector("input[name=primary]");
		const model = document.getElementById("model").value;
		const writer = document.getElementById("writer").value;
		const interalnumber = document.getElementById("interalnumber").value;
		const deptcode = document.getElementById("deptcode").value;
		const preseration = document.getElementById("preseration").value;
		const temprary = JSON.parse(temp);
		const iterationNote = document.getElementById("iterationNote").value;
	
		const url = getCallUrl("/etc/<%=mode%>");

		// 관련문서
		const rows90 = AUIGrid.getGridDataWithState(myGridID90, "gridState");
		// 관련품목
		const rows91 = AUIGrid.getGridDataWithState(myGridID91, "gridState");
		// 관련EO
		const rows100 = AUIGrid.getGridDataWithState(myGridID100, "gridState");
		// 관련ECO
		const rows105 = AUIGrid.getGridDataWithState(myGridID105, "gridState");
		// 관련CR
		const rows101 = AUIGrid.getGridDataWithState(myGridID101, "gridState");
		// 관련ECPR
		const rowsEcpr = AUIGrid.getGridDataWithState(myGridID103, "gridState");
		// 내용
		const content = DEXT5.getBodyValue("content");
		
		if(temprary) {
			if (!confirm("임시저장하시겠습니까?")){
				return false;
			}	
		} else {

			if (primary == null) {
				alert("주 첨부파일을 첨부해주세요.");
				return false;
			}
			
			if (!confirm("<%=title%>하시겠습니까?")) {
				return false;
			}	
		}
		
		const params = {
			oid : oid,
			name : name.value,
			lifecycle : lifecycle,
			description : description.value,
			content : content,
			secondarys : secondarys,
			primary : primary==null ? '' : primary.value,
			location : location.value,
			model_code : model,
			deptcode_code : deptcode,
			interalnumber : interalnumber,
			writer : writer,
			preseration_code : preseration,
			iterationNote : iterationNote,
			// 링크 데이터
			rows90 : rows90,
			rows91 : rows91,
			rows100 : rows100,
			rows101 : rows101,
			rowsEcpr : rowsEcpr,
			rows105 : rows105,
			temprary : temprary
		};
		logger(params);
		openLayer();
		call(url, params, function(data) {
			alert(data.msg);
			if (data.result) {
				opener.loadGridData();
				self.close();
			} else {
				closeLayer();
			}
		});
	}

	document.addEventListener("DOMContentLoaded", function() {
// 		toFocus("iterationNote");
		selectbox("formType");
		selectbox("preseration");
		selectbox("model");
		selectbox("deptcode");
		createAUIGrid90(columns90);
		createAUIGrid91(columns91);
		createAUIGrid100(columns100);
		createAUIGrid101(columns101);
		createAUIGrid103(columns103);
		createAUIGrid105(columns105);
		AUIGrid.resize(myGridID90);
		AUIGrid.resize(myGridID91);
		AUIGrid.resize(myGridID100);
		AUIGrid.resize(myGridID101);
		AUIGrid.resize(myGridID103);
		AUIGrid.resize(myGridID105);
	});
	
	window.addEventListener("resize", function() {
		AUIGrid.resize(myGridID90);
		AUIGrid.resize(myGridID91);
		AUIGrid.resize(myGridID100);
		AUIGrid.resize(myGridID101);
		AUIGrid.resize(myGridID103);
		AUIGrid.resize(myGridID105);
	});
</script>