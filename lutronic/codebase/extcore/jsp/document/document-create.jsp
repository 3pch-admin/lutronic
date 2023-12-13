<%@page import="com.e3ps.doc.DocumentClassType"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.e3ps.doc.dto.DocumentDTO"%>
<%@page import="wt.doc.DocumentType"%>
<%@page import="com.e3ps.admin.form.FormTemplate"%>
<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> preserationList = (ArrayList<NumberCode>) request.getAttribute("preserationList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
ArrayList<FormTemplate> form = (ArrayList<FormTemplate>) request.getAttribute("form");
ArrayList<Map<String, String>> classTypes1 = (ArrayList<Map<String, String>>) request.getAttribute("classTypes1");
JSONArray docTypeList = (JSONArray) request.getAttribute("docTypeList");
DocumentDTO dto = (DocumentDTO) request.getAttribute("dto");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style type="text/css">
iframe {
	margin-top: 3px;
}
</style>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
<script type="text/javascript" src="/Windchill/extcore/dext5editor/js/dext5editor.js"></script>
<!-- 채번스크립트 -->
<script type="text/javascript" src="/Windchill/extcore/jsp/document/js/genNumber.js?v=31"></script>
</head>
<body>
	<form>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						문서 등록
					</div>
				</td>
				<td class="right">
					<input type="button" value="등록" title="등록" class="red" onclick="create('false');">
					<input type="button" value="임시저장" title="임시저장" onclick="create('true');">
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
				<td class="indent5" colspan="3">
					<input type="hidden" name="location" id="location" value="<%=DocumentHelper.DOCUMENT_ROOT%>">
					<span id="locationText"> /Default/문서 </span>
					<input type="button" value="폴더선택" title="폴더선택" onclick="folder();" class="blue">
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
				<th class="lb req">대분류</th>
				<td class="indent5">
					<select name="classType1" id="classType1" class="width-200" onchange="genNumber(this);">
						<option value="">선택</option>
						<%
						for (Map<String, String> map : classTypes1) {
							String value = map.get("value");
							String name = map.get("name");
							String clazz = map.get("clazz");
						%>
						<option value="<%=value%>" data-clazz="<%=clazz%>"><%=name%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>중분류</th>
				<td class="indent5">
					<select name="classType2" id="classType2" class="width-300" onchange="middleNumber();">
						<option value="">선택</option>
					</select>
				</td>
				<th>소분류</th>
				<td class="indent5">
					<select name="classType3" id="classType3" class="width-300" onchange="lastCheck();">
						<option value="">선택</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="lb">문서명</th>
				<td class="indent5">
					<input type="text" name="docName" id="docName" class="width-300">
				</td>
				<th class="req">문서종류</th>
				<td class="indent5">
					<input type="text" name="documentName" id="documentName" class="width-300">
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
				<th class="req lb">문서유형</th>
				<td class="indent5">
					<select name="documentType" id="documentType" class="width-200">
						<option value="">선택</option>
						<%
						for (int i = 0; i < docTypeList.size(); i++) {
							JSONObject obj = (JSONObject) docTypeList.get(i);
							String key = (String) obj.get("key");
							String value = (String) obj.get("value");
						%>
						<option value="<%=key%>"><%=value%></option>
						<%
						}
						%>
					</select>
				</td>
				<th class="req">보존기간</th>
				<td class="indent5">
					<select name="preseration" id="preseration" class="width-200">
						<%
						for (NumberCode preseration : preserationList) {
							// 코드로 처리
						%>
						<option value="<%=preseration.getCode()%>"><%=preseration.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>프로젝트코드</th>
				<td class="indent5">
					<select name="model" id="model" class="width-200" onchange="preNumberCheck(this);">
						<option value="">선택</option>
						<%
						for (NumberCode model : modelList) {
						%>
						<option value="<%=model.getCode()%>"><%=model.getName()%></option>
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
						%>
						<option value="<%=deptcode.getCode()%>"><%=deptcode.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th class="req">내부 문서번호</th>
				<td class="indent5">
					<input type="text" name="interalnumber" id="interalnumber" class="width-200" readonly="readonly">
				</td>
				<th>작성자</th>
				<td class="indent5">
					<input type="text" name="writer" id="writer" data-multi="false" class="width-200">
				</td>
			</tr>
			<tr>
				<th class="lb">내용</th>
				<td colspan="5" class="indent7 pb8">
					<script type="text/javascript">
						new Dext5editor('content');
					</script>
				</td>
			</tr>
			<tr>
				<th class="lb">문서설명</th>
				<td colspan="5" class="indent5">
					<textarea name="description" id="description" rows="5"></textarea>
				</td>
			</tr>
			<tr>
				<th class="req lb">주 첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/attach-primary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<!-- 관련 품목 -->
		<jsp:include page="/extcore/jsp/part/include/part-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<!-- 	관련 문서 -->
		<jsp:include page="/extcore/jsp/document/include/document-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<!-- 	관련 EO -->
		<jsp:include page="/extcore/jsp/change/eo/include/eo-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<!-- 	관련 CR -->
		<jsp:include page="/extcore/jsp/change/cr/include/cr-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<!-- 	관련 ECPR -->
		<jsp:include page="/extcore/jsp/change/ecpr/include/ecpr-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<!-- 	관련 ECO -->
		<jsp:include page="/extcore/jsp/change/eco/include/eco-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>


		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" class="red" onclick="create('false');">
					<input type="button" value="임시저장" title="임시저장" onclick="create('true');">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			function folder() {
				const location = decodeURIComponent("/Default/문서");
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
			function create(temp) {
				// temp 임시저장 여부 처리
				const location = document.getElementById("location");
				const formType = document.getElementById("formType");
				const name = document.getElementById("docName");
				const documentType = document.getElementById("documentType");
				const description = document.getElementById("description");
				const lifecycle = document.querySelector("input[name=lifecycle]:checked").value;
				const secondarys = toArray("secondarys");
				const primary = document.querySelector("input[name=primary]");
				const model = document.getElementById("model").value;
				const writer = document.getElementById("writer").value;
				const interalnumber = document.getElementById("interalnumber").value;
				const deptcode = document.getElementById("deptcode").value;
				const preseration = document.getElementById("preseration").value;
				const documentName = document.getElementById("documentName");
				const temprary = JSON.parse(temp);

				const url = getCallUrl("/doc/create");

				// 관련문서
				const rows90 = AUIGrid.getGridDataWithState(myGridID90, "gridState");
				// 관련품목
				const rows91 = AUIGrid.getGridDataWithState(myGridID91, "gridState");
				// 관련EO
				const rows100 = AUIGrid.getGridDataWithState(myGridID100, "gridState");
				// 관련CR
				const rows101 = AUIGrid.getGridDataWithState(myGridID101, "gridState");
				// 관련ECPR
				const rows103 = AUIGrid.getGridDataWithState(myGridID103, "gridState");
				// 관련ECO
				const rows105 = AUIGrid.getGridDataWithState(myGridID105, "gridState");
				// 내용
				const content = DEXT5.getBodyValue("content");

				if (isNull(documentName.value)) {
					alert("문서종류를 입력해주세요.");
					documentName.focus();
					return false;
				}

				if (isNull(documentType.value)) {
					alert("문서유형을 선택해주세요.");
					return false;
				}

				if (isNull(interalnumber)) {
					alert("내부문서번호를 입력해주세요.");
					return false;
				}

				if (primary == null) {
					alert("주 첨부파일을 첨부해주세요.");
					return false;
				}

				if (temprary) {
					if (!confirm("임시저장하시겠습니까??")) {
						return false;
					}

				} else {
					if (!confirm("등록하시겠습니까?")) {
						return false;
					}
				}

				const params = {
					name : name.value,
					lifecycle : lifecycle,
					documentType_code : documentType.value,
					description : description.value,
					content : content,
					secondarys : secondarys,
					primary : primary.value,
					location : location.value,
					model_code : model,
					deptcode_code : deptcode,
					interalnumber : interalnumber,
					writer : writer,
					preseration_code : preseration,
					documentName : documentName.value,
					// 링크 데이터
					rows90 : rows90,
					rows91 : rows91,
					rows100 : rows100,
					rows101 : rows101,
					rows103 : rows103,
					rows105 : rows105,
					temprary : temprary
				};
				logger(params);
				parent.openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						document.location.href = getCallUrl("/doc/list");
					}
					parent.closeLayer();
				});
			}

			document.addEventListener("DOMContentLoaded", function() {
				selectbox("formType");
				selectbox("preseration");
				selectbox("documentType");
				selectbox("model");
				selectbox("deptcode");
				$("#preseration").bindSelectSetValue("PR001");
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

				// 문서명 규칙
				$("#documentName").bindSelector({
					reserveKeys : {
						options : "list",
						optionValue : "value",
						optionText : "name"
					},
					optionPrintLength : "all",
					onsearch : function(id, obj, callBack) {
						const value = document.getElementById(id).value;
						const url = getCallUrl("/doc/finder");
						const params = {
							value : value,
						};
						logger(params);
						call(url, params, function(data) {
							callBack({
								options : data.list
							})
						})
					},
					onchange : function() {
						const id = this.targetID;
						if (this.selectedOption != null) {
							const value = this.selectedOption.value;
							document.getElementById(id).value = value;
						}
					},
				});
				toUI();
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
	</form>
</body>
</html>