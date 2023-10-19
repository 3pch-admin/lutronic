<%@page import="wt.org.WTUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	ArrayList<NumberCode> manufactureList = (ArrayList<NumberCode>) request.getAttribute("manufactureList");
	ArrayList<NumberCode> moldtypeList = (ArrayList<NumberCode>) request.getAttribute("moldtypeList");
	ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
<script type="text/javascript" src="/Windchill/extcore/js/auigrid.js"></script>
</head>
<body>
	<form>
		<input type="hidden" name="fid" 			id="fid" 					value="">
		<input type="hidden" name="location" 		id="location" 				value="/Default/금형문서">
		<input type="hidden" name="documentType" 	id="documentType" 			value="$$MMDocument">
		
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 금형 정보
					</div>
				</td>
				<td class="right">
					<input type="button" value="기안" title="기안" class="red" onclick="create('false');">
					<input type="button" value="임시저장" title="임시저장" class="" onclick="create('true');">
				</td>
			</tr>
		</table>
		<table class="search-table">
			<colgroup>
				<col width="150">
				<col width="*">
				<col width="150">
				<col width="*">
			</colgroup>
			<tr>
				<th>결재방식 <span class="red">*</span></th>
				<td colspan="3" class="indent5">
					<div class="pretty p-switch">
						<input type="radio" name="lifecycle" value="LC_Default" checked="checked">
						<div class="state p-success">
							<label> <b>기본결재</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="lifecycle" value="LC_Default_NonWF">
						<div class="state p-success">
							<label> <b>일괄결재</b>
							</label>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>문서명 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="3">
					<input type="text" name="name" id="name" class="width-500">
				</td>
			</tr>
			<tr>
				<th>Manufacturer</th>
				<td class="indent5">
					<select name="manufacture" id="manufacture" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode manufacture : manufactureList) {
						%>
						<option value="<%=manufacture.getCode() %>"><%=manufacture.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>금형타입 <span class="red">*</span></th>
				<td class="indent5">
					<select name="moldtype" id="moldtype" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode moldtype : moldtypeList) {
						%>
						<option value="<%=moldtype.getCode() %>"><%=moldtype.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>업체자체금형번호</th>
				<td class="indent5">
					<input type="text" name="moldnumber" id="moldnumber" class="width-500">
				</td>
				<th>금형개발비</th>
				<td class="indent5">
					<input type="text" name="moldcost" id="moldcost" class="width-500">
				</td>
			</tr>
			<tr>
				<th>내부 문서번호 <br>(자산등록번호)</th>
				<td class="indent5">
					<input type="text" name="interalnumber" id="interalnumber" class="width-500">
				</td>
				<th>부서</th>
				<td class="indent5">
					<select name="deptcode" id="deptcode" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode deptcode : deptcodeList) {
						%>
						<option value="<%=deptcode.getCode() %>"><%=deptcode.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>문서설명</th>
				<td class="indent5" colspan="3">
					<input type="text" name="description" id="description" class="width-300">
				</td>
			</tr>
			<tr>
				<th class="req lb">주 첨부파일 <span class="red">*</span></th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-primary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">결재</th>
				<td colspan="3">
					<jsp:include page="/extcore/jsp/workspace/include/approval-register.jsp">
						<jsp:param value="" name="oid" />
						<jsp:param value="create" name="mode" />
					</jsp:include>
				</td>
			</tr>
		</table>
		<br>
		
		<!-- 관련 품목 -->
		<jsp:include page="/extcore/jsp/change/include_selectPart.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
		</jsp:include>
		<br>
		
		<!-- 관련 문서 -->
		<jsp:include page="/extcore/jsp/document/include/document-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="insert90" name="method" />
			<jsp:param value="true" name="multi" />
		</jsp:include>
		
		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="기안" title="기안" class="red" onclick="create('false');">
					<input type="button" value="임시저장" title="임시저장" class="" onclick="create('true');">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			function create(temp) {
				const temprary = JSON.parse(temp);
				const addRows8 = AUIGrid.getAddedRowItems(myGridID8);
				const primary = document.querySelector("input[name=primary]");
				if(isEmpty($("#name").val())) {
					alert("문서명을 입력하세요.");
					return;
				}
				if($("#moldtype").val() == "") {
					alert("금형타입을 선택하세요.");
					return;
				}
				if(primary == null){
					alert("주 첨부파일을 첨부해주세요.");
					return;
				}
				
				if (temprary) {
					if (!confirm("임시저장하시겠습니까??")) {
						return false;
					}
					
					if(addRows8){
						alert("결재선 지정을 해지해주세요.")
						return false;
					}
					
				} else {
					if (!confirm("등록하시겠습니까?")) {
						return false;
					}
				}
				
				let params = new Object();
				params.lifecycle = $('input[name=lifecycle]:checked').val();
				params.name = $("#name").val();
				params.manufacture_code = $("#manufacture").val();
				params.moldtype_code = $("#moldtype").val();
				params.moldnumber = $("#moldnumber").val();
				params.moldcost = $("#moldcost").val();
				params.interalnumber = $("#interalnumber").val();
				params.deptcode_code = $("#deptcode").val();
				params.description = $("#description").val();
				params.documentType = $("#documentType").val();
				params.location = $("#location").val();
				params.primary = primary.value;
				const secondarys = toArray("secondarys");
				params.secondarys = secondarys;
				params.partList = AUIGrid.getGridData(partGridID);
				params.docList = AUIGrid.getGridData(myGridID90);
				params.temprary = temprary;
				
				var url = getCallUrl("/mold/create");
				toRegister(params, addRows8); // 결재선 세팅
				call(url, params, function(data) {
					alert(data.msg);
					if(data.result){
						location.href = getCallUrl("/mold/list");
					}
				});
			}
			
			$("#listBtn").click(function() {
				location.href = getCallUrl("/mold/list");
			});
		
			document.addEventListener("DOMContentLoaded", function() {
				selectbox("manufacture");
				selectbox("moldtype");
				selectbox("deptcode");
				
				createAUIGrid2(columnsPart);
				AUIGrid.resize(partGridID);
				createAUIGrid90(columns90);
				AUIGrid.resize(myGridID90);
				createAUIGrid8(columns8);
				AUIGrid.resize(myGridID8);
			});
			
			window.addEventListener("resize", function() {
				AUIGrid.resize(partGridID);
				AUIGrid.resize(myGridID90);
				AUIGrid.resize(myGridID8);
			});

		</script>
	</form>
</body>
</html>