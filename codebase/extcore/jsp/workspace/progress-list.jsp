<%@page import="wt.session.SessionHelper"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
WTUser user = (WTUser) SessionHelper.manager.getPrincipal();
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
		<input type="hidden" name="sessionid" id="sessionid">
		<input type="hidden" name="curPage" id="curPage">
		<input type="hidden" name="sessionName" id="sessionName" value="<%=user.getFullName()%>">

		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						진행함
					</div>
				</td>
			</tr>
		</table>
		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>결재 제목</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300">
				</td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('progress-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('progress-list');">
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="10">10</option>
						<option value="20" selected="selected">20</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
					</select>
					<input type="button" value="결재 초기화" title="결재 초기화" onclick="_reset();" class="blue">
					<input type="button" value="검색" title="검색" onclick="loadGridData();">
				</td>
			</tr>
		</table>
		<div id="grid_wrap" style="height: 640px; border-top: 1px solid #3180c3;"></div>
		<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
		<%@include file="/extcore/jsp/common/aui-context.jsp"%>
		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "rowNum",
					headerText : "번호",
					width : 40,
					dataType : "numeric",
					filter : {
						inline : false
					},
				}, {
					dataField : "persistType",
					headerText : "결재유형",
					dataType : "string",
					width : 120,
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/workspace/masterView?oid=" + oid + "&columnType=COLUMN_PROGRESS");
							_popup(url, 1500, 800, "n");
						}
					},
				}, {
					dataField : "name",
					headerText : "결재 제목",
					dataType : "string",
					style : "aui-left",
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/workspace/masterView?oid=" + oid + "&columnType=COLUMN_PROGRESS");
							_popup(url, 1500, 800, "n");
						}
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 100,
				}, {
					dataField : "point",
					headerText : "진행단계",
					dataType : "string",
					style : "right",
					renderer : {
						type : "TemplateRenderer"
					},
					filter : {
						inline : false
					},
				}, {
					dataField : "createdDate",
					headerText : "기안일",
					dataType : "date",
					formatString : "yyyy-mm-dd HH:MM:ss",
					width : 170,
				} ]
			}

			function createAUIGrid(columnLayout) {
				const props = {
					headerHeight : 30,
					showRowNumColumn : false,
					showRowCheckColumn : true,
					showAutoNoDataMessage : false,
					selectionMode : "multipleCells",
					hoverMode : "singleRow",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : true,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
					enableRowCheckShiftKey : true
				};
				myGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
				loadGridData();
				AUIGrid.bind(myGridID, "contextMenu", auiContextMenuHandler);
				AUIGrid.bind(myGridID, "vScrollChange", function(event) {
					hideContextMenu();
				});
				AUIGrid.bind(myGridID, "hScrollChange", function(event) {
					hideContextMenu();
				});
			}

			function loadGridData(movePage) {
				if (movePage === undefined) {
					document.getElementById("sessionid").value = 0;
					document.getElementById("curPage").value = 1;
				}
				let params = new Object();
				const url = getCallUrl("/workspace/progress");
				const field = [ "name" ];
				params = toField(params, field);
				AUIGrid.showAjaxLoader(myGridID);
				parent.openLayer();
				call(url, params, function(data) {
					console.log(data);
					AUIGrid.removeAjaxLoader(myGridID);
					if (data.result) {
						totalPage = Math.ceil(data.total / data.pageSize);
						createPagingNavigator(data.total, data.curPage, data.sessionid);
						AUIGrid.setGridData(myGridID, data.list);
					} else {
						alert(data.msg);
					}
					parent.closeLayer();
				});
			}

			function _reset() {
				const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
				if (checkedItems.length === 0) {
					alert("결재 초기화 하려는 결재를 선택하세요.");
					return false;
				}

				if (!confirm("선택한 결재들을 초기화 하시겠습니까?")) {
					return false;
				}

				const arr = new Array();
				for (let i = checkedItems.length - 1; i >= 0; i--) {
					const item = checkedItems[i].item;
					const oid = item.oid;
					arr.push(oid);
				}
				const url = getCallUrl("/workspace/_reset");
				const params = new Object();
				params.arr = arr;
				parent.openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						loadGridData();
					}
					parent.closeLayer();
				})
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("name");
				const columns = loadColumnLayout("progress-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				selectbox("_psize");
				$("#_psize").bindSelectSetValue("20");
			});

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

			function exportExcel() {
				const exceptColumnFields = [ "point" ];
				const sessionName = document.getElementById("sessionName").value;
				exportToExcel("진행함 리스트", "진행함", "진행함 리스트", exceptColumnFields, sessionName);
			}
		</script>
	</form>
</body>
</html>