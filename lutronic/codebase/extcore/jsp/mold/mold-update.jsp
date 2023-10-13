<%@page import="com.e3ps.mold.dto.MoldDTO"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> manufactureList = (ArrayList<NumberCode>) request.getAttribute("manufactureList");
ArrayList<NumberCode> moldtypeList = (ArrayList<NumberCode>) request.getAttribute("moldtypeList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
MoldDTO dto = (MoldDTO) request.getAttribute("dto");
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
		<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
		<input type="hidden" name="location" id="location" value="/Default/금형문서">
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 금형 수정
					</div>
				</td>
			</tr>
		</table>
		<table class="create-table">
			<colgroup>
				<col width="150">
				<col width="*">
				<col width="150">
				<col width="*">
			</colgroup>
			<tr>
				<td colspan="4"><%=dto.getNumber()%>&nbsp;[<%=dto.getName()%>]</td>
			</tr>
			<tr>
				<th class="req lb">문서명</th>
				<td class="indent5" colspan="3">
					<input type="text" name="name" id="name" class="width-500" value="<%=dto.getName()%>">
				</td>
			</tr>
			<tr>
				<th class="lb">문서설명</th>
				<td class="indent5" colspan="3">
					<textarea name="description" id="description" rows="5"><%=dto.getDescription() == null ? "" : dto.getDescription()%></textarea>
				</td>
			</tr>	
			<tr>
				<th class="lb">수정사유</th>
				<td class="indent5" colspan="3">
					<textarea name="iterationNote" id="iterationNote" rows="2"></textarea>
				</td>
			</tr>
			<tr>
				<th class="req lb">주 첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/attach-primary.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
						<jsp:param value="modify" name="mode"/>
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
						<jsp:param value="modify" name="mode"/>
					</jsp:include>
				</td>
			</tr>
		</table>
		
		<!-- 속성 -->
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 속성
					</div>
				</td>
			</tr>
		</table>
		<table class="create-table">
			<colgroup>
				<col width="150">
				<col width="*">
				<col width="150">
				<col width="*">
			</colgroup>
			<tr>
				<th class="lb">Manufacture</th>
				<td class="indent5">
					<select name="manufacture" id="manufacture" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode manufacture : manufactureList) {
						%>
							<option value="<%=manufacture.getCode() %>" <%if (manufacture.getCode().equals(dto.getManufacture_code())) {%> selected="selected" <%}%>><%=manufacture.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th class="lb">금형타입</th>
				<td class="indent5">
					<select name="moldtype" id="moldtype" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode moldtype : moldtypeList) {
						%>
							<option value="<%=moldtype.getCode() %>" <%if (moldtype.getCode().equals(dto.getMoldtype_code())) {%> selected="selected" <%}%>><%=moldtype.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th class="lb">업체자체금형번호</th>
				<td class="indent5">
					<input type="text" name="moldnumber" id="moldnumber" class="width-500" value="<%=dto.getMoldnumber()%>">
				</td>
				<th class="lb">금형개발비</th>
				<td class="indent5">
					<input type="text" name="moldcost" id="moldcost" class="width-500" value="<%=dto.getMoldcost()%>">
				</td>
			</tr>
			<tr>
				<th class="lb">내부 문서번호</th>
				<td class="indent5">
					<input type="text" name="interalnumber" id="interalnumber" class="width-500" value="<%=dto.getInteralnumber()%>">
				</td>
				<th class="lb">부서</th>
				<td class="indent5">
					<select name="deptcode" id="deptcode" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode deptcode : deptcodeList) {
							System.out.println(deptcode.getCode());
							System.out.println(dto.getDeptcode_code());
						%>
							<option value="<%=deptcode.getCode() %>" <%if (deptcode.getCode().equals(dto.getDeptcode_code())) {%> selected="selected" <%}%>><%=deptcode.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
		</table>
		
		<!-- 관련 품목 -->
		<jsp:include page="/extcore/jsp/change/include_selectPart.jsp">
			<jsp:param value="<%=dto.getOid() %>" name="oid" />
			<jsp:param value="update" name="mode" />
			<jsp:param value="doc" name="moduleType" />
			<jsp:param value="true" name="multi" />
		</jsp:include>
		<br>
		
		<!-- 관련 문서 -->
		<jsp:include page="/extcore/jsp/document/include/document-include.jsp">
			<jsp:param value="<%=dto.getOid() %>" name="oid" />
			<jsp:param value="update" name="mode" />
			<jsp:param value="insert90" name="method" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="250" name="height" />
		</jsp:include>
		
		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button"  value="수정"  title="수정"  class="blue"  id="updateBtn">
					<input type="button" value="이전" title="이전" onclick="javascript:history.back();">
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			document.addEventListener("DOMContentLoaded", function() {
				selectbox("manufacture");
				selectbox("moldtype");
				selectbox("deptcode");
				createAUIGrid2(columnsPart);
				AUIGrid.resize(partGridID);
				createAUIGrid90(columns90);
				AUIGrid.resize(myGridID90);
			});
		
			window.addEventListener("resize", function() {
				AUIGrid.resize(partGridID);
				AUIGrid.resize(myGridID90);
			});
			
			$("#updateBtn").click(function(){
				if(isEmpty($("#moldtype").val())) {
					alert("금형타입을 선택하세요.");
					return;
				}
				const primary = document.querySelector("input[name=primary]");
				if(primary == null){
					alert("주 첨부파일을 첨부해주세요.");
					return;
				}
				
				if (!confirm("수정 하시겠습니까?")) {
					return;
				}
				
				let params = new Object();
				params.oid = $("#oid").val();
				params.location = $("#location").val();
				params.name = $("#name").val();
				params.description = $("#description").val();
				params.iterationNote = $("#iterationNote").val();
				params.primary = primary.value;
				const secondarys = toArray("secondarys");
				params.secondarys = secondarys;
				params.manufacture_code = $("#manufacture").val();
				params.moldtype_code = $("#moldtype").val();
				params.moldnumber = $("#moldnumber").val();
				params.moldcost = $("#moldcost").val();
				params.interalnumber = $("#interalnumber").val();
				params.deptcode_code = $("#deptcode").val();
				var lifecycle = "<%=dto.getApprovaltype_code().equals("DEFAULT") ? "LC_Default" : "LC_Default_NonWF"%>";
				params.lifecycle = lifecycle;
				params.partList = AUIGrid.getGridData(partGridID);
				params.docList = AUIGrid.getGridData(myGridID90);
				
				var url = getCallUrl("/mold/update");
				call(url, params, function(data) {
					if(data.result){
						alert(data.msg);
						opener.loadGridData();
						self.close();
					}else{
						alert(data.msg);
					}
				});
			});
		</script>
	</form>	
</body>
</html>	