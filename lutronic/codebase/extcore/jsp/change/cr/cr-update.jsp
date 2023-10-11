<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="com.e3ps.change.cr.dto.CrDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> sectionList = (ArrayList<NumberCode>) request.getAttribute("sectionList");
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
CrDTO dto = (CrDTO) request.getAttribute("dto");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
</head>
<body>
	<form>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						CR 수정
					</div>
				</td>
				<td class="right">
					<input type="button" value="수정" title="수정" class="red" onclick="update();">
					<input type="button" value="결재선 지정" title="결재선 지정" class="blue" onclick="">
					<input type="button" value="임시저장" title="임시저장" class="">
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
				<th class="req lb">CR 제목</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300" value="<%= dto.getName() %>">
				</td>
				<th class="req">CR 번호</th>
				<td class="indent5">
					<input type="text" name="number" id="number" class="width-300" value="<%=dto.getNumber()%>">
				</td>
			</tr>
			<tr>
				<th class="lb">작성일</th>
				<td class="indent5">
					<input type="text" name="createdDate" id="createdDate" class="width-100" value="<%=dto.getCreatedDate() != null ? dto.getCreatedDate() : ""%>">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearDate('createdDate');">
				</td>
				<th>승인일</th>
				<td class="indent5">
					<input type="text" name="approveDate" id="approveDate" class="width-100" value="<%= dto.getApproveDate() != null ? dto.getApproveDate() : "" %>">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="createDate('approveDate');">
				</td>
			</tr>
			<tr>
				<th class="lb">작성부서</th>
				<td class="indent5">
					<select name="createDepart" id="createDepart" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode deptcode : deptcodeList) {
							boolean selected = dto.getCreateDepart_code() == deptcode.getCode();
						%>
						<option value="<%=deptcode.getCode()%>" <% if(selected){%> selected <%} %>><%=deptcode.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>작성자</th>
				<td class="indent5">
					<input type="text" name="writer" id="writer" data-multi="false" class="width-200" value="<%= dto.getWriter_name() != null ? dto.getWriter_name() : ""%>">
					<input type="hidden" name="writerOid" id="writerOid"  value="<%= dto.getWriter_oid() %>">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('writer')">
				</td>
			</tr>
			<tr>
				<th class="req lb">제품명</th>
				<td colspan="3" class="indent5 pt5">
					<jsp:include page="/extcore/jsp/admin/code/include/code-include.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid" />
						<jsp:param value="update" name="mode" />
						<jsp:param value="insert300" name="method" />
						<jsp:param value="MODEL" name="codeType" />
						<jsp:param value="true" name="multi" />
						<jsp:param value="150" name="height" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">제안자</th>
				<td class="indent5" colspan="3">
					<input type="text" name="proposer" id="proposer" data-multi="false" class="width-200" value="<%= dto.getProposer_name() != null ? dto.getProposer() : ""%>">
					<input type="hidden" name="proposerOid" id="proposerOid" value="<%= dto.getProposer_oid()%>">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('proposer')">
				</td>
			</tr>
			<tr>
				<th class="lb">변경구분</th>
				<td class="indent5" colspan="3">
					&nbsp;
					<%
					for (NumberCode section : sectionList) {
						int isInclude = dto.getSections().indexOf(section.getCode());
					%>
					<div class="pretty p-switch">
						<input type="checkbox" name="changeSection" value="<%=section.getCode()%>" <%if(isInclude >= 0){ %>checked<%} %>>
						<div class="state p-success">
							<label>
								<b><%=section.getName()%></b>
							</label>
						</div>
					</div>
					&nbsp;
					<%
					}
					%>
				</td>
			</tr>
			<tr>
				<th class="lb">변경사유</th>
				<td class="indent5" colspan="3">
					<textarea name="eoCommentA" id="eoCommentA" rows="10"><%= dto.getEoCommentA() != null ? dto.getEoCommentA() : "" %></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">변경사항</th>
				<td class="indent5" colspan="3">
					<textarea name="eoCommentB" id="eoCommentB" rows="10"><%= dto.getEoCommentB() != null ? dto.getEoCommentB() : "" %></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">참고사항</th>
				<td class="indent5" colspan="3">
					<textarea name="eoCommentC" id="eoCommentC" rows="10"><%= dto.getEoCommentC() != null ? dto.getEoCommentC() : "" %></textarea>
				</td>
			</tr>
			<tr>
				<th class="req lb">주 첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-primary.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<!-- 	관련 CR -->
		<jsp:include page="/extcore/jsp/change/cr/include/cr-include.jsp">
			<jsp:param value="<%= dto.getOid() %>" name="oid" />
			<jsp:param value="update" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="150" name="height" />
		</jsp:include>

		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="기안" title="기안" class="red" onclick="create();">
					<input type="button" value="결재선 지정" title="결재선 지정" class="blue" onclick="">
					<input type="button" value="임시저장" title="임시저장" class="">
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			function update() {
				const name = document.getElementById("name");
				const number = document.getElementById("number");

				if (!confirm("등록 하시겠습니까?")) {
					return;
				}
				const primary = document.querySelector("input[name=primary]");
				// 관련CR
				const rows101 = AUIGrid.getGridDataWithState(myGridID101, "gridState");
				// 모델
				const rows300 = AUIGrid.getGridDataWithState(myGridID300, "gridState");

				// 변경 구분 배열 처리
				const changeSection = document.querySelectorAll('input[name="changeSection"]:checked');
				const sections = [];
				changeSection.forEach(function(item) {
					sections.push(item.value);
				});
				
				if(isEmpty(name.value)){
					alert("CR 제목을 입력해주세요.");
					name.focus();
					return;
				}
				
				if(isEmpty(number.value)){
					alert("CR 번호를 선택해주세요.");
					number.focus();
					return;
				}
				
				if(rows300.length == 0){
					alert("제품명을 입력해주세요.");
					return;
				}
				
				if(primary == null){
					alert("주 첨부파일을 첨부해주세요.");
					return;
				}
				
				const params = {
					oid: "<%= dto.getOid() %>",
					name : name.value,
					number : number.value,
					createdDate : toId("createdDate"),
					approveDate : toId("approveDate"),
					createDepart : toId("createDepart"),
					writer_oid : toId("writerOid"),
					proposer_oid : toId("proposerOid"),
					eoCommentA : toId("eoCommentA"),
					eoCommentB : toId("eoCommentB"),
					eoCommentC : toId("eoCommentC"),
					sections : sections, //변경 구분
					primary : primary.value,
					rows101 : rows101,
					rows300 : rows300
				}
				params.secondarys = toArray("secondarys");
				const url = getCallUrl("/cr/modify");
				parent.openLayer();
				logger(params);
				parent.openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						document.location.href = getCallUrl("/cr/list");
					} else {
						parent.closeLayer();
					}
				});
			}

			// jquery 삭제를 해가는 쪽으로 한다..
			document.addEventListener("DOMContentLoaded", function() {
				toFocus("name");
				date("createdDate");
				date("approveDate");
				selectbox("createDepart");
				finderUser("writer");
				finderUser("proposer");
				createAUIGrid300(columns300);
				createAUIGrid101(columns101);
				AUIGrid.resize(myGridID300);
				AUIGrid.resize(myGridID101);
			});

			window.addEventListener("resize", function() {
				AUIGrid.resize(myGridID300);
				AUIGrid.resize(myGridID101);
			});
		</script>
	</form>
</body>
</html>