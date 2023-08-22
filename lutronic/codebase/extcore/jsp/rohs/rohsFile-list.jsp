<%@page import="wt.fc.PersistenceHelper"%>
<%@page import="wt.fc.QueryResult"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="wt.fc.PagingQueryResult"%>
<%@page import="com.e3ps.common.util.PageQueryUtils"%>
<%@page import="wt.util.WTAttributeNameIfc"%>
<%@page import="com.e3ps.common.util.QuerySpecUtils"%>
<%@page import="wt.doc.WTDocumentMaster"%>
<%@page import="com.e3ps.rohs.ROHSMaterial"%>
<%@page import="wt.query.QuerySpec"%>
<%@page import="com.e3ps.rohs.beans.RohsData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
WTUser sessionUser = (WTUser) request.getAttribute("sessionUser");
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
	<form name="listRoHSData" id="listRoHSData" >
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
				<th>파일구분</th>
				<td class="indent5">
					<select name="fileType" id="fileType" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
					</select>
				</td>
				<th>발행일자</th>
				<td class="indent5"><input type="text" name="publication_Start" id="publication_Start" class="width-100"> ~ 
					<input type="text" name="publication_End" id="publication_End" class="width-100"> 
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearFromTo('createdFrom', 'createdTo')">
				</td>
			</tr>
			<tr>
				<th>파일명</th>
				<td class="indent5" colspan="3"><input type="text" name="fileName" id="fileName" class="width-200"></td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();"> 
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('rohsFile-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('part-list');"> 
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select>
					<input type="button" value="검색" title="검색" id="searchBtn" >
					<input type="button" value="초기화" title="초기화" id="btnReset" >
				</td>
			</tr>
		</table>
		<div id="grid_wrap" style="height: 645px; border-top: 1px solid #3180c3;"></div>
		<%@include file="/extcore/jsp/common/aui-context.jsp"%>
		
		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "manufactureDisplay",
					headerText : "업체명",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
// 					renderer : {
// 						type : "LinkRenderer",
// 						baseUrl : "javascript",
// 						jsCallback : function(rowIndex, columnIndex, value, item) {
// 							const oid = item.oid;
// 							const url = getCallUrl("/rohs/view?oid=" + oid);
// 							popup(url, 1600, 800);
// 						}
// 					},
				}, {
					dataField : "name",
					headerText : "물질명",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "fileName",
					headerText : "파일명",
					dataType : "string",
					width : 350,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "publicationDate",
					headerText : "발행일자",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "등록일",
					dataType : "date",
					width : 180,
					filter : {
						showIcon : true,
						inline : true,
					},
				}, {
					dataField : "creator",
					headerText : "작성자",
					dataType : "date",
					width : 180,
					filter : {
						showIcon : true,
						inline : true,
					},
				} ]
			}

			function createAUIGrid(columnLayout) {
				const props = {
					headerHeight : 30,
					showRowNumColumn : true,
					fillColumnSizeMode: true,
					rowNumHeaderText : "번호",
					showAutoNoDataMessage : true,
					selectionMode : "multipleCells",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : false,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
					fillColumnSizeMode: true,
				};
				myGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
				loadGridData();
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
				let params = new Object();
				const url = getCallUrl("/rohs/listRohsFile");
// 				const field = ["_psize","oid","name","number","description","state","creatorOid","createdFrom","createdTo"];
// 				const latest = !!document.querySelector("input[name=latest]:checked").value;
// 				params = toField(params, field);
// 				params.latest = latest;
// 				const field = [ "_psize" ];
// 				params = toField(params, field);
				AUIGrid.showAjaxLoader(myGridID);
// 				parent.openLayer();
				call(url, params, function(data) {
					AUIGrid.removeAjaxLoader(myGridID);
					if (data.result) {
						document.getElementById("sessionid").value = data.sessionid;
						document.getElementById("curPage").value = data.curPage;
						document.getElementById("lastNum").value = data.list.length;
						AUIGrid.setGridData(myGridID, data.list);
					} else {
						alert(data.msg);
					}
// 					parent.closeLayer();
				});
			}

			document.addEventListener("DOMContentLoaded", function() {
				const columns = loadColumnLayout("rohsFile-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				selectbox("fileType");
				twindate("publication");
				selectbox("_psize");
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