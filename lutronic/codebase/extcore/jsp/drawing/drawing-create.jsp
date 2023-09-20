<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// boolean isAdmin = (boolean) request.getAttribute("isAdmin");
// WTUser sessionUser = (WTUser) request.getAttribute("sessionUser");
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
	<form id="form">
		<input type="hidden" name="lifecycle"	id="lifecycle" 	value="LC_PART" />
		<input type="hidden" name="fid" 		id="fid"		value="" />
		<input type="hidden" name="location" 	id="location"	value="/Default/PART_Drawing" />

		<table class="search-table">
			<colgroup>
				<col width="180">
				<col width="*">
				<col width="180">
				<col width="*">
			</colgroup>
			<tr>
				<th>도면분류 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="3">
					<span id="locationName">
               			/Default/PART_Drawing
               		</span>
				</td>
			</tr>
			<tr>
				<th>도번 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="number" id="number" class="width-500">
				</td>
				<th>도면명 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-500">
				</td>
			</tr>
			<tr>
				<th>도면설명</th>
				<td class="indent5"  colspan="3">
					<input type="text" name="description" id="description" class="width-800">
				</td>
			</tr>
			<tr>
				<th class="req lb">주 첨부파일</th>
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
		</table>
		
		<br>
		<jsp:include page="/extcore/jsp/change/include_selectPart.jsp">
			<jsp:param value="" name="oid" />
			<jsp:param value="create" name="mode" />
		</jsp:include>
		
		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" class="blue" id="createBtn">
					<input type="button" value="초기화" title="초기화" id="resetBtn">
					<input type="button" value="목록" title="목록" id="listBtn">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			$("#createBtn").click(function() {
				if ($("#location").val() == "") {
					alert("도면분류를 선택하세요.");
					return;
				}
				if($("#number").val() == "") {
					alert("도번을 입력하세요.')}");
					return;
				}
				
				if($("#name").val() == "") {
					alert("도면명 입력하세요.')}");
					return;
				}
				
				if (!confirm("등록 하시겠습니까?")) {
					return;
				}
				
				var params = _data($("#form"));
				var url = getCallUrl("/drawing/create");
				call(url, params, function(data) {
					if(data.result){
						alert(data.msg);
						opener.loadGridData();
						self.close();
					}else{
						alert(data.msg);
					}
				});
			})
			
			document.addEventListener("DOMContentLoaded", function() {
				createAUIGrid2(columnsPart);
				AUIGrid.resize(partGridID);
				selectbox("state");
				selectbox("type");
				selectbox("depart");
			});

			function exportExcel() {
// 				const exceptColumnFields = [ "primary" ];
// 				const sessionName = document.getElementById("sessionName").value;
// 				exportToExcel("문서 리스트", "문서", "문서 리스트", exceptColumnFields, sessionName);
			}

			document.addEventListener("keydown", function(event) {
				const keyCode = event.keyCode || event.which;
				if (keyCode === 13) {
					loadGridData();
				}
			})

			document.addEventListener("click", function(event) {
				hideContextMenu();
			})

			window.addEventListener("resize", function() {
				AUIGrid.resize(partGridID);
			});
		</script>
	</form>
</body>
</html>