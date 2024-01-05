<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> preserationList = (ArrayList<NumberCode>) request.getAttribute("preserationList");
ArrayList<NumberCode> sectionList = (ArrayList<NumberCode>) request.getAttribute("sectionList");
String html = (String) request.getAttribute("html");
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
</head>
<body>
	<form>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						ECPR 등록
					</div>
				</td>
				<td class="right">
					<input type="button" value="등록" title="등록" class="red" onclick="create('false');">
				</td>
			</tr>
		</table>
		<table class="create-table">
			<colgroup>
				<col width="150">
				<col width="600">
				<col width="150">
				<col width="600">
			</colgroup>
			<tr>
				<th class="req lb">ECPR 제목</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-400">
				</td>
				<th class="req">보존년한</th>
				<td class="indent5">
					<select name="period" id="period" class="width-200">
						<%
						for (NumberCode preseration : preserationList) {
						%>
						<option value="<%=preseration.getCode()%>"><%=preseration.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<!-- 			<tr> -->
			<!-- 				<th class="lb">작성일</th> -->
			<!-- 				<td class="indent5"> -->
			<!-- 					<input type="text" name="writeDate" id="writeDate" class="width-100"> -->
			<!-- 					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearDate('writeDate');"> -->
			<!-- 				</td> -->
			<!-- 				<th>승인일</th> -->
			<!-- 				<td class="indent5"> -->
			<!-- 					<input type="text" name="approveDate" id="approveDate" class="width-100"> -->
			<!-- 					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="createDate('approveDate');"> -->
			<!-- 				</td> -->
			<!-- 			</tr> -->
			<!-- 			<tr> -->
			<!-- 				<th class="lb">작성부서</th> -->
			<!-- 				<td class="indent5"> -->
			<!-- 					<input type="text" name="createDepart" id="createDepart" class="width-200"> -->
			<!-- 				</td> -->
			<!-- 				<th>작성자</th> -->
			<!-- 				<td class="indent5"> -->
			<!-- 					<input type="text" name="writer" id="writer" data-multi="false" class="width-200">  -->
			<!-- 				</td> -->
			<!-- 			</tr> -->
			<tr>
				<th class="req lb">제품명</th>
				<td colspan="3" class="indent5 pt5">
					<jsp:include page="/extcore/jsp/admin/code/include/code-include.jsp">
						<jsp:param value="" name="oid" />
						<jsp:param value="create" name="mode" />
						<jsp:param value="insert300" name="method" />
						<jsp:param value="MODEL" name="codeType" />
						<jsp:param value="true" name="multi" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">변경구분</th>
				<td colspan="3">
					&nbsp;
					<%
					for (NumberCode section : sectionList) {
					%>
					<div class="pretty p-switch">
						<input type="checkbox" name="changeSection" value="<%=section.getCode()%>">
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
				<th class="lb">내용</th>
				<td colspan="3" class="indent7 pb8">
					<textarea name="contents" id="contents" style="display: none;"><%=html != null ? html : ""%></textarea>
					<script type="text/javascript">
						const html = toId("contents");
						new Dext5editor('content');
						DEXT5.setBodyValue(html, 'content');
					</script>
				</td>
			</tr>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<!-- 	관련 문서 -->
		<jsp:include page="/extcore/jsp/document/include/document-include.jsp">
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

		<!-- 	관련 CR -->
		<jsp:include page="/extcore/jsp/change/cr/include/cr-include.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
			<jsp:param value="true" name="multi" />
			<jsp:param value="true" name="header" />
		</jsp:include>

		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" class="red" onclick="create('false');">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			function create() {
				const name = document.getElementById("name");
				const period = document.getElementById("period").value;
				// 관련문서
				const rows90 = AUIGrid.getGridDataWithState(myGridID90, "gridState");
				// 관련CR
				const rows101 = AUIGrid.getGridDataWithState(myGridID101, "gridState");
				// 관련ECO
				const rows105 = AUIGrid.getGridDataWithState(myGridID105, "gridState");
				// 모델
				const rows300 = AUIGrid.getGridDataWithState(myGridID300, "gridState");

				// 변경 구분 배열 처리
				const changeSection = document.querySelectorAll('input[name="changeSection"]:checked');
				const sections = [];
				changeSection.forEach(function(item) {
					sections.push(item.value);
				});

				if (isEmpty(name.value)) {
					alert("ECPR 제목을 입력해주세요.");
					name.focus();
					return;
				}

				if (isEmpty(period)) {
					alert("보존년한을 선택하세요.");
					return;
				}
				if (rows300.length == 0) {
					alert("제품을 선택해주세요.");
					popup300();
					return;
				}

				if (!confirm("등록하시겠습니까?")) {
					return false;
				}
				const content = DEXT5.getBodyValue("content");

				const params = {
					name : name.value,
					period_code : period,
					contents : content,
					sections : sections, //변경 구분
					rows300 : rows300,
					rows90 : rows90,
					rows101 : rows101,
					rows105 : rows105
				}
				const secondarys = toArray("secondarys");
				params.secondarys = secondarys;
				const url = getCallUrl("/ecpr/create");
				parent.openLayer();
				logger(params);
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						location.href = getCallUrl("/ecpr/list");
					} else {
						parent.closeLayer();
					}
				});
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("name");
				selectbox("period");
				createAUIGrid300(columns300);
				createAUIGrid90(columns90);
				createAUIGrid101(columns101);
				createAUIGrid105(columns105);
				AUIGrid.resize(myGridID300);
				AUIGrid.resize(myGridID90);
				AUIGrid.resize(myGridID101);
				AUIGrid.resize(myGridID101);
			});

			window.addEventListener("resize", function() {
				AUIGrid.resize(myGridID300);
				AUIGrid.resize(myGridID90);
				AUIGrid.resize(myGridID101);
				AUIGrid.resize(myGridID105);
			});
		</script>
	</form>
</body>
</html>