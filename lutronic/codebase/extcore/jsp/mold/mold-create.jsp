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
	<form>
		<input type="hidden" name="sessionid" id="sessionid">
		<input type="hidden" name="lastNum" id="lastNum">
		<input type="hidden" name="curPage" id="curPage">
		<input type="hidden" name="oid" id="oid">

		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>결재방식 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="3">
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="lifecycle" value="true" checked="checked">
						<div class="state p-success">
							<label>
								<b>기본결재</b>
							</label>
						</div>
					</div>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="lifecycle" value="">
						<div class="state p-success">
							<label>
								<b>일괄결재</b>
							</label>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>문서명 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="3">
					<input type="text" name="docName" id="docName" class="width-500">
				</td>
			</tr>
			<tr>
				<th>Manufacturer</th>
				<td class="indent5">
					<select name="manufacture" id="manufacture" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
					</select>
				</td>
				<th>금형타입 <span style="color:red;">*</span></th>
				<td class="indent5">
					<select name="moldtype" id="moldtype" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>업체자제금형번호</th>
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
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
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
				<th>주 첨부파일 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="3">
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td class="indent5" colspan="3">
				</td>
			</tr>
		</table>
		<br>
		
		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>관련 품목</th>
				<td class="indent5" colspan="3">
					<input type="text" name="description" id="description" class="width-300">
				</td>
			</tr>
		</table>
		<br>
		
		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>관련 문서</th>
				<td class="indent5" colspan="3">
					<input type="text" name="description" id="description" class="width-300">
				</td>
			</tr>
		</table>
		
		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" onclick="loadGridData();">
					<input type="button" value="초기화" title="초기화" onclick="loadGridData();">
					<input type="button" value="목록" title="목록" onclick="loadGridData();">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "name",
					headerText : "금형번호",
					dataType : "string",
					width : 295,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "number",
					headerText : "금형명",
					dataType : "string",
					width : 450,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "description",
					headerText : "Rev.",
					dataType : "string",
					width : 170,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "location",
					headerText : "상태",
					dataType : "string",
					width : 170,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "등록자",
					dataType : "string",
					width : 170,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "version",
					headerText : "등록일",
					dataType : "string",
					width : 170,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "creator",
					headerText : "수정일",
					dataType : "string",
					width : 170,
					filter : {
						showIcon : true,
						inline : true
					},
				} ]
			}

			function createAUIGrid(columnLayout) {
				const props = {
					headerHeight : 30,
					showRowNumColumn : true,
					rowNumHeaderText : "번호",
					showAutoNoDataMessage : false,
					selectionMode : "multipleCells",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : true,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
				};
				myGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
				// 				loadGridData();
				AUIGrid.bind(myGridID, "contextMenu", auiContextMenuHandler);
				AUIGrid.bind(myGridID, "vScrollChange", function(event) {
					hideContextMenu();
					vScrollChangeHandler(event);
				});
				AUIGrid.bind(myGridID, "hScrollChange", function(event) {
					hideContextMenu();
				});
			}

			function loadGridData() {
				// 				let params = new Object();
				// 				const url = getCallUrl("/doc/list");
				// 				const field = ["_psize","oid","name","number","description","state","creatorOid","createdFrom","createdTo"];
				// 				const latest = !!document.querySelector("input[name=latest]:checked").value;
				// 				params = toField(params, field);
				// 				params.latest = latest;
				// 				AUIGrid.showAjaxLoader(myGridID);
				// 				parent.openLayer();
				// 				call(url, params, function(data) {
				// 					AUIGrid.removeAjaxLoader(myGridID);
				// 					AUIGrid.setGridData(myGridID, data.list);
				// 					document.getElementById("sessionid").value = data.sessionid;
				// 					document.getElementById("curPage").value = data.curPage;document.getElementById("lastNum").value = data.list.length;
				// 					parent.closeLayer();
				// 				});
			}

			document.addEventListener("DOMContentLoaded", function() {
				const columns = loadColumnLayout("document-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				selectbox("manufacture");
				selectbox("moldtype");
				selectbox("deptcode");
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
				AUIGrid.resize(myGridID);
			});
		</script>
	</form>
</body>
</html>