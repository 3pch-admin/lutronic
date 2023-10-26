<%@page import="net.sf.json.JSONArray"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%
String oid = (String) request.getAttribute("oid");
JSONArray list = (JSONArray) request.getAttribute("list");
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
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

		<table class="search-table">
			<colgroup>
				<col width="174">
				<col width="*">
				<col width="174">
				<col width="*">
			</colgroup>
			<tr>
				<th>부서 및 사원 관리</th>
				<td class="indent5" colspan="3">
					<input type="hidden" name="oid" id="oid" value="<%=oid%>">
					<span id="locationName">루트로닉</span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300">
				</td>
				<th>아이디</th>
				<td class="indent5">
					<input type="text" name="userId" id="userId" class="width-300">
				</td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('organization-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('organization-list');">
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select>
					<%
					if (isAdmin) {
					%>
					<input type="button" value="저장" title="저장" class="red" onclick="save();">
					<%
					}
					%>
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
					<jsp:include page="/extcore/jsp/workprocess/department-tree.jsp">
						<jsp:param value="698" name="height" />
					</jsp:include>
				</td>
				<td valign="top">&nbsp;</td>
				<td valign="top">
					<div id="grid_wrap" style="height: 665px; border-top: 1px solid #3180c3;"></div>
					<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
					<%@include file="/extcore/jsp/common/aui-context.jsp"%>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			let myGridID;
			const list = <%=list%>;
			const duty = [ "사장", "부사장" ];
			const auths = [ {
				key : "나의업무",
				value : "나의업무"
			}, {
				key : "문서관리",
				value : "문서관리"
			}, {
				key : "품목관리",
				value : "품목관리"
			}, {
				key : "도면관리",
				value : "도면관리"
			}, {
				key : "설계변경",
				value : "설계변경"
			}, {
				key : "RoHS",
				value : "RoHS"
			}, {
				key : "금형관리",
				value : "금형관리"
			}, {
				key : "기타문서관리",
				value : "기타문서관리"
			} ];
			function _layout() {
				return [ {
					dataField : "id",
					headerText : "아이디",
					dataType : "string",
					width : 150,
					editable : false,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/org/userInfoView?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "name",
					headerText : "이름",
					dataType : "string",
					width : 120,
					editable : false,
					filter : {
						showIcon : true,
						inline : true
					},
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/org/userInfoView?oid=" + oid);
							popup(url, 1600, 800);
						}
					},
				}, {
					dataField : "auth",
					headerText : "메뉴권한",
					dataType : "string",
					style : "aui-left",
					renderer : {
						type : "IconRenderer",
						iconWidth : 16,
						iconHeight : 16,
						iconPosition : "aisleRight",
						iconTableRef : {
							"default" : "/Windchill/extcore/component/AUIGrid/images/list-icon.png"
						},
						onClick : function(event) {
							AUIGrid.openInputer(event.pid);
						}
					},
					editRenderer : {
						type : "DropDownListRenderer",
						showEditorBtn : false,
						showEditorBtnOver : false,
						multipleMode : true,
						showCheckAll : true,
						list : auths,
						keyField : "key",
						valueField : "value",
					},
					labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
						let retStr = "";
						for (let i = 0, len = auths.length; i < len; i++) {
							if (auths[i]["key"] == value) {
								retStr = auths[i]["value"];
								break;
							}
						}
						return retStr == "" ? value : retStr;
					},
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "department_name",
					headerText : "부서",
					dataType : "string",
					width : 150,
					renderer : {
						type : "IconRenderer",
						iconWidth : 16,
						iconHeight : 16,
						iconPosition : "aisleRight",
						iconTableRef : {
							"default" : "/Windchill/extcore/component/AUIGrid/images/list-icon.png"
						},
						onClick : function(event) {
							AUIGrid.openInputer(event.pid);
						}
					},
					editRenderer : {
						type : "DropDownListRenderer",
						showEditorBtn : false,
						showEditorBtnOver : false,
						multipleMode : false,
						showCheckAll : false,
						list : list,
						keyField : "oid",
						valueField : "name",
					},
					labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
						let retStr = "";
						for (let i = 0, len = list.length; i < len; i++) {
							if (list[i]["oid"] == value) {
								retStr = list[i]["name"];
								break;
							}
						}
						return retStr == "" ? value : retStr;
					},
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "duty",
					headerText : "직위",
					dataType : "string",
					width : 130,
					renderer : {
						type : "IconRenderer",
						iconWidth : 16,
						iconHeight : 16,
						iconPosition : "aisleRight",
						iconTableRef : {
							"default" : "/Windchill/extcore/component/AUIGrid/images/list-icon.png"
						},
						onClick : function(event) {
							AUIGrid.openInputer(event.pid);
						}
					},
					editRenderer : {
						type : "DropDownListRenderer",
						showEditorBtn : false,
						showEditorBtnOver : false,
						multipleMode : false,
						showCheckAll : false,
						list : duty,
					},
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "email",
					headerText : "이메일",
					dataType : "string",
					width : 250,
					style : "aui-left",
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
					showAutoNoDataMessage : true,
					selectionMode : "multipleCells",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : false,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
					editable : true
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
				$("input[name=sessionid").val(0);
				let params = new Object();
				const url = getCallUrl("/org/organization");
				const field = [ "_psize", "name", "userId", "oid" ];
				params = toField(params, field);
				AUIGrid.showAjaxLoader(myGridID);
				parent.openLayer();
				call(url, params, function(data) {
					AUIGrid.removeAjaxLoader(myGridID);
					if (data.result) {
						// 페이징처리..
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

			function save() {
				const editRows = AUIGrid.getEditedRowItems(myGridID);
				if (editRows.length === 0) {
					alert("변경 사항이 없습니다.");
					return false;
				}
				const url = getCallUrl("/org/save");
				const params = {
					editRows : editRows
				}
				if (!confirm("저장 하시겠습니까?")) {
					return false;
				}

				parent.openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						document.location.reload();
					}
					parent.closeLayer();
				})
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("name");
				const columns = loadColumnLayout("organization-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
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
		</script>
	</form>
</body>
</html>