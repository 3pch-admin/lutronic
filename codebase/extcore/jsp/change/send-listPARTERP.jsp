<%@page import="wt.session.SessionHelper"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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
						PART 전송현황
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
			</colgroup>
			<tr>
				<th>인터페이스 번호</th>
				<td class="indent5"><input type="text" name="zifno" id="zifno" class="width-200"></td>
				<th>자재 번호</th>
				<td class="indent5"><input type="text" name="matnr" id="matnr" class="width-200"></td>
			</tr>
			<tr>
				<th>자재명</th>
				<td class="indent5"><input type="text" name="maktx" id="maktx" class="width-200"></td>
				<th>변경 번호</th>
				<td class="indent5"><input type="text" name="aennr" id="aennr" class="width-200"></td>
			</tr>
			<tr>
				<th>인터페이스상태</th>
				<td>&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="zifsta" value=""  checked>
						<div class="state p-success">
							<label> <b>ALL</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="zifsta" value="S">
						<div class="state p-success">
							<label> <b>성공</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="zifsta" value="F">
						<div class="state p-success">
							<label> <b>실패</b>
							</label>
						</div>
					</div>
				</td>
				<th>전송일</th>
				<td class="indent5"><input type="text" name="createdFrom" id="createdFrom" class="width-100"> ~ <input type="text" name="createdTo" id="createdTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
					onclick="clearFromTo('createdFrom', 'createdTo')"></td>
			</tr>
			<tr>
				<th>적용 상태</th>
				<td>&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="returnZifsta" value=""  checked>
						<div class="state p-success">
							<label> <b>ALL</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="returnZifsta" value="S">
						<div class="state p-success">
							<label> <b>성공</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="returnZifsta" value="F">
						<div class="state p-success">
							<label> <b>실패</b>
							</label>
						</div>
					</div>
				</td>
				<th>ERP 적용 체크</th>
				<td class="indent5"><input type="text" name="zifnoFrom" id="zifnoFrom" class="width-100"> ~ <input type="text" name="zifnoTo" id="zifnoTo" class="width-100"></td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();"> 
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('send-listPARTERP');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('send-listPARTERP');"> 
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select> 
					<input type="button"   value="ERP 적용 현황체크" title="ERP 적용 현황체크" onclick="loadGridData();">
					<input type="button" value="검색" title="검색" onclick="loadGridData();">
				</td>
			</tr>
		</table>

		<div id="grid_wrap" style="height: 540px; border-top: 1px solid #3180c3;"></div> <%@include file="/extcore/jsp/common/aui-context.jsp"%>

		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "zifno",
					headerText : "I/F 번호",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "matnr",
					headerText : "자재번호",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "maktx",
					headerText : "자재명",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "단위",
					dataType : "string",
					width : 350,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "creator",
					headerText : "자재그룹",
					dataType : "string",
					width : 250,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "approveDate",
					headerText : "순중량",
					dataType : "string",
					width : 350,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "중량단위 (g)",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "재질",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "사양",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "후처리",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "프로젝트",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "제작방법",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "부서",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "부품분류",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "대분류",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "중분류",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "변경번호",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "REV",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "결과",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "전송일",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "적용 상태",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "적용 결과",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				} ]
			}

			function createAUIGrid(columnLayout) {
				const props = {
					headerHeight : 30,
					fillColumnSizeMode : true,
					fillColumnSizeMode: true,
					showRowNumColumn : true,
					rowNumHeaderText : "번호",
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
				const columns = loadColumnLayout("send-listPARTERP");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				selectbox("state");
				finderUser("creator");
				twindate("created");
				twindate("modified");
				selectbox("_psize");
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
			    const sessionName = document.getElementById("sessionName").value;
			    exportToExcel("PART 전송 현황 리스트", "PART 전송 현황", "PART 전송 현황 리스트", [], sessionName);
			}
		</script>
	</form>
</body>
</html>