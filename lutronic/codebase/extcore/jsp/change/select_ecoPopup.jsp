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
		<input type="hidden" name="sessionid" id="sessionid"> <input type="hidden" name="lastNum" id="lastNum"> <input type="hidden" name="curPage" id="curPage"> <input type="hidden" name="oid" id="oid">

		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="*">
				<col width="130">
				<col width="*">
			</colgroup>
			<tr>
				<th>ECO 제목</th>
				<td class="indent5"><input type="text" name="name" id="name" class="width-200"></td>
				<th>ECO 번호</th>
				<td class="indent5"><input type="text" name="number" id="number" class="width-200"></td>
			</tr>
			<tr>
				<th>등록자</th>
				<td class="indent5"><input type="text" name="creator" id="creator" data-multi="false" class="width-200"> <input type="hidden" name="creatorOid" id="creatorOid"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')"></td>
				<th>상태</th>
				<td class="indent5"><select name="state" id="state" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
				</select></td>
			</tr>
			<tr>
				<th>등록일</th>
				<td class="indent5"><input type="text" name="createdFrom" id="createdFrom" class="width-100"> ~ <input type="text" name="createdTo" id="createdTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
					onclick="clearFromTo('createdFrom', 'createdTo')"></td>
				<th>승인일</th>
				<td class="indent5"><input type="text" name="createdFrom" id="modifiedFrom" class="width-100"> ~ <input type="text" name="createdTo" id="modifiedTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
					onclick="clearFromTo('createdFrom', 'createdTo')"></td>
			</tr>
			<tr>
				<th>인허가변경</th>
				<td>&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="licensing" value="NONE" checked="checked">
						<div class="state p-success">
							<label> <b>선택안됨</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="licensing" value="0">
						<div class="state p-success">
							<label> <b>불필요</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="licensing" value="1">
						<div class="state p-success">
							<label> <b>필요</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="licensing" value="">
						<div class="state p-success">
							<label> <b>전체</b>
							</label>
						</div>
					</div>
				</td>
				<th>위험통제</th>
				<td>&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="riskType" value="true" checked="NONE">
						<div class="state p-success">
							<label> <b>선택안됨</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="riskType" value="0">
						<div class="state p-success">
							<label> <b>불필요</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="riskType" value="1">
						<div class="state p-success">
							<label> <b>필요</b>
							</label>
						</div>
					</div> &nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="riskType" value="">
						<div class="state p-success">
							<label> <b>전체</b>
							</label>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th class="req lb">제품명</th>
				<td colspan="3">
					<input type="button" value="추가" title="추가" class="blue"  id="addNumberCode" name="addNumberCode" >
					<input type="button" value="삭제" title="삭제" class="red"   id="delNumberCode" name="delNumberCode"  >
				</td>
			</tr>
			<tr>
				<th class="req lb">완제품 품목</th>
				<td colspan="3">
					<jsp:include page="/extcore/jsp/change/include_ecrCompletePart.jsp">
						<jsp:param value="" name="oid" />
						<jsp:param value="create" name="mode" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select>
					<input type="button" value="검색" title="검색" id="searchBtn" onclick="loadGridData();">
					<input type="button" value="초기화" title="초기화" id="btnReset">
					<input type="button" value="추가" title="추가" class="blue" onclick="addBtn();">
					<input type="button" value="닫기" title="닫기" class="gray" onclick="javascript:self.close();">
					<a href="javascript:onExcelDown();">
						<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					</a>	
				</td>
			</tr>
		</table>

		<div id="grid_wrap" style="height: 645px; border-top: 1px solid #3180c3;"></div> <%@include file="/extcore/jsp/common/aui-context.jsp"%>

		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "eoNumber",
					headerText : "ECO번호",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/changeECO/view?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "eoName",
					headerText : "ECO제목",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/changeECO/view?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "licensing",
					headerText : "인허가변경",
					dataType : "string",
					width : 120,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "riskType",
					headerText : "위험 통제",
					dataType : "string",
					width : 350,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 250,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "creator",
					headerText : "등록자",
					dataType : "string",
					width : 350,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "state",
					headerText : "승인일",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "createDate",
					headerText : "등록일",
					dataType : "string",
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
					fillColumnSizeMode: true,
					showRowNumColumn : true,
					showRowCheckColumn : true,
					rowNumHeaderText : "번호",
					showAutoNoDataMessage : true,
					selectionMode : "multipleCells",
					enableMovingColumn : true,
					enableFilter : false,
					showInlineFilter : false,
					useContextMenu : true,
					enableRightDownFocus : true,
					rowCheckToRadio : true,
					fillColumnSizeMode: true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
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
				const url = getCallUrl("/changeECO/list");
// 				const field = ["_psize","oid","name","number","eoType","predate","postdate","creator","state", "licensing", "model", "sortCheck", "sortValue", "riskType", "preApproveDate", "postApproveDate"];
				/* const latest = !!document.querySelector("input[name=latest]:checked").value;
				params = toField(params, field);
				params.latest = latest; */
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
					parent.closeLayer();
				});
			}

			document.querySelector("#addNumberCode").addEventListener("click", () => {
				const url = getCallUrl("/common/popup_numberCodes?codeType=MODEL&disable=true");
				popup(url, 1500, 700);
			});
			
			document.querySelector("#delNumberCode").addEventListener("click", () => {
				
			});
	
			document.addEventListener("DOMContentLoaded", function() {
				const columns = loadColumnLayout("document-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				createAUIGrid2(columnsPart);
				AUIGrid.resize(myGridID);
				selectbox("state");
				finderUser("creator");
				twindate("created");
				twindate("modified");
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
			
			function addBtn(){
				const items = AUIGrid.getCheckedRowItemsAll(myGridID);
				if (items.length == 0) {
					alert("추가할 부품을 선택하세요.");
					return false;
				}
				opener.append(items);
				self.close();
			}
		</script>
	</form>
</body>
</html>