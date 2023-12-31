<%@page import="wt.part.QuantityUnit"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.e3ps.common.util.CommonUtil"%>
<%@page import="wt.session.SessionHelper"%>
<%@page import="wt.org.WTUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="com.e3ps.drawing.service.DrawingHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> matList = (ArrayList<NumberCode>) request.getAttribute("matList");
ArrayList<NumberCode> productmethodList = (ArrayList<NumberCode>) request.getAttribute("productmethodList");
ArrayList<NumberCode> manufactureList = (ArrayList<NumberCode>) request.getAttribute("manufactureList");
ArrayList<NumberCode> finishList = (ArrayList<NumberCode>) request.getAttribute("finishList");
List<Map<String, String>> cadTypeList = (List<Map<String, String>>) request.getAttribute("cadTypeList");
List<Map<String, String>> lifecycleList = (List<Map<String, String>>) request.getAttribute("lifecycleList");
WTUser user = (WTUser) request.getAttribute("sessionUser");
String oid = user.getPersistInfo().getObjectIdentifier().getStringValue();
String userName = user.getFullName();
QuantityUnit[] unitList = (QuantityUnit[]) request.getAttribute("unitList");
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
						도면 검색
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
				<th>도면분류</th>
				<td class="indent5">
					<input type="hidden" name="oid" id="oid">
					<input type="hidden" name="location" id="location" value="<%=DrawingHelper.PART_ROOT%>">
					<span id="locationText"><%=DrawingHelper.PART_ROOT%></span>
				</td>
				<th>등록자</th>
				<td class="indent5">
					<input type="text" name="creator" id="creator" value="<%//=userName%>" data-multi="false" class="width-200">
					<input type="hidden" name="creatorOid" id="creatorOid" value="<%//=oid%>">
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
				<th>도면번호</th>
				<td class="indent5">
					<input type="text" name="number" id="number" class="width-300">
				</td>
				<th>도면명</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300">
				</td>
				<th>수정일</th>
				<td class="indent5">
					<input type="text" name="modifiedFrom" id="modifiedFrom" class="width-100">
					~
					<input type="text" name="modifiedTo" id="modifiedTo" class="width-100">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearFromTo('modifiedFrom', 'modifiedTo')">
				</td>
			</tr>
			<tr>
				<th>프로젝트코드</th>
				<td class="indent5">
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
				<th>CAD 타입</th>
				<td class="indent5">
					<select name="cadType" id="cadType" class="width-200">
						<option value="">선택</option>
						<%
						for (Map<String, String> cadType : cadTypeList) {
						%>
						<option value="<%=cadType.get("code")%>"><%=cadType.get("name")%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>REV</th>
				<td>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="latest" value="true" checked="checked">
						<div class="state p-success">
							<label>
								<b>최신REV</b>
							</label>
						</div>
					</div>
					&nbsp;
					<div class="pretty p-switch">
						<input type="radio" name="latest" value="false">
						<div class="state p-success">
							<label>
								<b>모든REV</b>
							</label>
						</div>
					</div>
				</td>
			</tr>
			<tr class="hidden">
				<th>상태</th>
				<td class="indent5">
					<select name="state" id="state" class="width-200">
						<option value="">선택</option>
						<%
						for (Map<String, String> lifecycle : lifecycleList) {
							if (!lifecycle.get("code").equals("TEMPRARY")) {
						%>
						<option value="<%=lifecycle.get("code")%>"><%=lifecycle.get("name")%></option>
						<%
						}
						}
						%>
					</select>
				</td>
				<th>제작방법</th>
				<td class="indent5">
					<select name="productmethod" id="productmethod" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode productmethod : productmethodList) {
						%>
						<option value="<%=productmethod.getCode()%>"><%=productmethod.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>부서</th>
				<td class="indent5">
					<select name="deptcode" id="deptcode" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode deptcode : deptcodeList) {
						%>
						<option value="<%=deptcode.getCode()%>"><%=deptcode.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr class="hidden">
				<th>단위</th>
				<td class="indent5">
					<select name="unit" id="unit" class="width-200">
						<option value="">선택</option>
						<%
						for (QuantityUnit unit : unitList) {
						%>
						<option value="<%=unit.toString()%>"><%=unit.getDisplay()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>무게</th>
				<td class="indent5">
					<input type="text" name="weight1" id="weight1" class="width-100">
					~
					<input type="text" name="weight2" id="weight2" class="width-100">
				</td>
				<th>Manufacturer</th>
				<td class="indent5">
					<select name="manufacture" id="manufacture" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode manufacture : manufactureList) {
						%>
						<option value="<%=manufacture.getCode()%>"><%=manufacture.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
			</tr>
			<tr class="hidden">
				<th>재질</th>
				<td class="indent5">
					<select name="mat" id="mat" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode mat : matList) {
						%>
						<option value="<%=mat.getCode()%>"><%=mat.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>후처리</th>
				<td class="indent5">
					<select name="finish" id="finish" class="width-200">
						<option value="">선택</option>
						<%
						for (NumberCode finish : finishList) {
						%>
						<option value="<%=finish.getCode()%>"><%=finish.getName()%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>사양</th>
				<td class="indent5">
					<input type="text" name="specification" id="specification" class="width-300">
				</td>
			</tr>
			<tr class="hidden">
				<th>비고</th>
				<td class="indent5" colspan="5">
					<input type="text" name="remarks" id="remarks" class="width-300">
				</td>
			</tr>
		</table>
		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('drawing-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('drawing-list');">
					<input type="button" value="일괄다운" title="일괄다운" class="blue" onclick="batch();">
					<input type="button" value="선택" title="선택" class="red" onclick="_select();">
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="10">10</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
					</select>
					<input type="button" value="펼치기" title="펼치기" class="red" onclick="spread(this);">
					<input type="button" value="검색" title="검색" onclick="loadGridData();">
				</td>
			</tr>
		</table>
		<table>
			<colgroup>
				<col width="230">
				<col width="10">
				<col width="*">
			</colgroup>
			<tr>
				<td valign="top">
					<jsp:include page="/extcore/jsp/common/folder-include.jsp">
						<jsp:param value="<%=DrawingHelper.PART_ROOT%>" name="location" />
						<jsp:param value="product" name="container" />
						<jsp:param value="list" name="mode" />
						<jsp:param value="623" name="height" />
					</jsp:include>
				</td>
				<td valign="top">&nbsp;</td>
				<td valign="top">
					<div id="grid_wrap" style="height: 595px; border-top: 1px solid #3180c3;"></div>
					<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
					<%@include file="/extcore/jsp/common/aui-context.jsp"%>
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "_3d",
					headerText : "3D",
					dataType : "string",
					width : 60,
					renderer : {
						type : "ImageRenderer",
						altField : null,
						onClick : function(event) {
						}
					},
				}, {
					dataField : "_2d",
					headerText : "2D",
					dataType : "string",
					width : 60,
					renderer : {
						type : "ImageRenderer",
						altField : null,
						onClick : function(event) {
						}
					},
				}, {
					dataField : "icon",
					headerText : "",
					dataType : "string",
					width : 40,
					renderer : {
						type : "ImageRenderer",
						altField : null,
						imgHeight : 16,
					},
				}, {
					dataField : "cadType",
					headerText : "CAD타입",
					dataType : "string",
					width : 120,
				}, {
					dataField : "number",
					headerText : "도면번호",
					dataType : "string",
					width : 200,
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.epm_oid;
							const url = getCallUrl("/drawing/view?oid=" + oid);
							_popup(url, 1600, 800, "n");
						}
					},
				}, {
					dataField : "name",
					headerText : "도면명",
					dataType : "string",
					width : 250,
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.epm_oid;
							const url = getCallUrl("/drawing/view?oid=" + oid);
							_popup(url, 1600, 800, "n");
						}
					},
				}, {
					dataField : "location",
					headerText : "도면분류",
					dataType : "string",
					width : 120,
				}, {
					dataField : "version",
					headerText : "REV",
					dataType : "string",
					width : 100,
					renderer : {
						type : "TemplateRenderer"
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 100,
					styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
						if (value === "승인됨") {
							return "approved";
						}
						return null;
					}
				}, {
					dataField : "creator",
					headerText : "등록자",
					dataType : "string",
					width : 100,
				}, {
					dataField : "createdDate",
					headerText : "등록일",
					dataType : "date",
					width : 100,
				}, {
					dataField : "modifiedDate",
					headerText : "수정일",
					dataType : "date",
					width : 100,
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
				}
				let params = new Object();
				const url = getCallUrl("/drawing/list");
				const field = [ "location", "cadDivision", "cadType", "number", "name", "createdFrom", "createdTo", "modifiedFrom", "modifiedTo", "creatorOid", "state", "model", "productmethod", "deptcode", "unit", "weight1", "weight2", "manufacture", "mat", "finish", "remarks", "specification" ];
				const latest = document.querySelector("input[name=latest]:checked").value;
				params = toField(params, field);
				params.latest = JSON.parse(latest);
				AUIGrid.showAjaxLoader(myGridID);
				parent.openLayer();
				call(url, params, function(data) {
					AUIGrid.removeAjaxLoader(myGridID);
					if (data.result) {
						totalPage = Math.ceil(data.total / data.pageSize);
						createPagingNavigator(data.curPage, data.sessionid);
						AUIGrid.setGridData(myGridID, data.list);
					} else {
						alert(data.msg);
					}
					parent.closeLayer();
				});
			}

			let p;
			function batch() {
				const url = getCallUrl("/drawing/download");
				p = _popup(url, 1000, 500, "n");
			}

			function _select() {
				const gridData = AUIGrid.getCheckedRowItems(myGridID);
				if (gridData.length === 0) {
					return false;
				}

				let checker = true;
				for (let i = 0; i < gridData.length; i++) {
					const cadTypeKey = gridData[i].item.cadTypeKey;
					if (cadTypeKey !== "CADDRAWING") {
						checker = false;
						break;
					}
				}

				if (checker) {
					if (p) {
						p.setData(gridData);
					} else {
						alert('팝업 창이 열려 있지 않습니다.');
					}
				} else {
					alert("2D도면만 추가가 가능합니다.");
				}
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("number");
				const columns = loadColumnLayout("drawing-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				_createAUIGrid(_columns);
				AUIGrid.resize(_myGridID);
				selectbox("state");
				selectbox("cadDivision");
				selectbox("cadType");
				selectbox("model");
				selectbox("productmethod");
				selectbox("deptcode");
				selectbox("manufacture");
				selectbox("unit");
				selectbox("mat");
				selectbox("finish");
				finderUser("creator");
				twindate("created");
				twindate("modified");
				selectbox("_psize");
			});

			function exportExcel() {
				const exceptColumnFields = [ "step", "dxf", "pdf", "thum" ];
				const sessionName = document.getElementById("sessionName").value;
				exportToExcel("도면 리스트", "도면", "도면 리스트", exceptColumnFields, sessionName);
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
				AUIGrid.resize(_myGridID);
			});

			function spread(target) {
				const e = document.querySelectorAll('.hidden');
				// 버근가..
				for (let i = 0; i < e.length; i++) {
					const el = e[i];
					const style = window.getComputedStyle(el);
					console.log(el);
					const display = style.getPropertyValue("display");
					if (display === "none") {
						el.style.display = "table-row";
						target.value = "접기";
						selectbox("state");
						selectbox("model");
						selectbox("productmethod");
						selectbox("deptcode");
						selectbox("unit");
						selectbox("mat");
						selectbox("finish");
						selectbox("manufacture");
						selectbox("_psize");
						finderUser("creator");
						twindate("created");
						twindate("modified");
					} else {
						el.style.display = "none";
						target.value = "펼치기";
						selectbox("state");
						selectbox("model");
						selectbox("productmethod");
						selectbox("deptcode");
						selectbox("unit");
						selectbox("mat");
						selectbox("finish");
						selectbox("manufacture");
						selectbox("_psize");
						finderUser("creator");
						twindate("created");
						twindate("modified");
					}
				}
			}
		</script>
	</form>
</body>
</html>