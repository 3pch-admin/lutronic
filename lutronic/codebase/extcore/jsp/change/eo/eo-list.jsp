<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
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

		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						EOI 검색
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>EO 번호</th>
				<td class="indent5">
					<input type="text" name="number" id="number" class="width-300">
				</td>
				<th>EO 제목</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300">
				</td>
				<th>상태</th>
				<td class="indent5">
					<select name="state" id="state" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>구분</th>
				<td>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="eoType" value="" checked>
						<div class="state p-success">
							<label>
								<b>없음</b>
							</label>
						</div>
					</div>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="eoType" value="DEV">
						<div class="state p-success">
							<label>
								<b>개발</b>
							</label>
						</div>
					</div>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="eoType" value="PRODUCT">
						<div class="state p-success">
							<label>
								<b>양산</b>
							</label>
						</div>
					</div>
				</td>
				<th>등록자</th>
				<td class="indent5">
					<input type="text" name="creator" id="creator" data-multi="false" class="width-200">
					<input type="hidden" name="creatorOid" id="creatorOid">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')">
				</td>
				<th>등록일</th>
				<td class="indent5">
					<input type="text" name="createdFrom" id="createdFrom" class="width-100">
					~
					<input type="text" name="createdTo" id="createdTo" class="width-100">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearFromTo('createdFrom', 'createdTo')">
				</td>
			</tr>
			<tr>
				<th class="req lb">프로젝트 코드</th>
				<td class="indent5" colspan="3">
					<select name="model" id="model" class="width-200">
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
				<th>승인일</th>
				<td class="indent5">
					<input type="text" name="approveForm" id="approveFrom" class="width-100">
					~
					<input type="text" name="approveTo" id="approveTo" class="width-100">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearFromTo('createdFrom', 'createdTo')">
				</td>
			</tr>
			<tr>
				<th class="req lb">완제품 품목</th>
				<td colspan="5" class="indent5 pt5">
					<jsp:include page="/extcore/jsp/change/include/include-complete-part.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('eo-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('eo-list');">
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select>
					<input type="button" value="등록" title="등록" class="blue" onclick="create();">
					<input type="button" value="검색" title="검색" onclick="loadGridData();">
					<input type="button" value="초기화" title="초기화" onclick="resetColumnLayout('eo-list');">
				</td>
			</tr>
		</table>

		<div id="grid_wrap" style="height: 645px; border-top: 1px solid #3180c3;"></div>
		<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
		<%@include file="/extcore/jsp/common/aui-context.jsp"%>
		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "number",
					headerText : "EO 번호",
					dataType : "string",
					width : 150,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/eo/view?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "name",
					headerText : "EO 제목",
					dataType : "string",
					style : "aui-left",
					// 					width : 250,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/eo/view?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "eoType",
					headerText : "구분",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "creator",
					headerText : "등록자",
					dataType : "string",
					width : 250,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createdDate",
					headerText : "등록일",
					dataType : "date",
					width : 200,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "approveDate_txt",
					headerText : "승인일",
					dataType : "date",
					width : 200,
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
					showRowCheckColumn : true,
					rowNumHeaderText : "번호",
					showAutoNoDataMessage : false,
					selectionMode : "multipleCells",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : false,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
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

			function loadGridData() {
				let params = new Object();
				const url = getCallUrl("/eo/list");
				const field = [ "_psize", "name", "number", "eoType", "predate", "postdate", "creator", "state", "licensing", "model", "sortCheck", "sortValue", "riskType", "preApproveDate", "postApproveDate" ];
				const rows104 = AUIGrid.getGridDataWithState(myGridID104, "gridState");
				params.rows104 = rows104;
				params = toField(params, field);
				AUIGrid.showAjaxLoader(myGridID);
				parent.openLayer();
				call(url, params, function(data) {
					AUIGrid.removeAjaxLoader(myGridID);
					if (data.result) {
						totalPage = Math.ceil(data.total / data.pageSize);
						document.getElementById("sessionid").value = data.sessionid;
						createPagingNavigator(data.curPage);
						AUIGrid.setGridData(myGridID, data.list);
					} else {
						alert(data.msg);
					}
					parent.closeLayer();
				});
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("number");
				const columns = loadColumnLayout("eo-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				createAUIGrid104(columns104);
				AUIGrid.resize(myGridID);
				AUIGrid.resize(myGridID104);
				selectbox("state");
				finderUser("creator");
				twindate("created");
				twindate("approve");
				selectbox("_psize");
				selectbox("model");
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
				AUIGrid.resize(myGridID104);
			});

			// 등록
			function create() {
				location.href = getCallUrl("/eo/create");
			}
		</script>
	</form>
</body>
</html>