<%@page import="java.util.Map"%>
<%@page import="wt.session.SessionHelper"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="wt.doc.DocumentType"%>
<%@page import="wt.org.WTUser"%>
<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> preserationList = (ArrayList<NumberCode>) request.getAttribute("preserationList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
ArrayList<Map<String, String>> classTypes1 = (ArrayList<Map<String, String>>) request.getAttribute("classTypes1");
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
		<input type="hidden" name="state" id="state" value="APPROVED">
		<input type="hidden" name="sessionName" id="sessionName" value="<%=user.getFullName()%>">

		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						문서 검색
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
				<th>문서 분류</th>
				<td class="indent5">
					<input type="hidden" name="location" id="location" value="<%=DocumentHelper.DOCUMENT_ROOT%>">
					<span id="locationText"><%=DocumentHelper.DOCUMENT_ROOT%></span>
				</td>
				<th>내부 문서번호</th>
				<td class="indent5">
					<input type="text" name="interalnumber" id="interalnumber" class="width-300">
				</td>
				<th>문서명</th>
				<td class="indent5">
					<input type="text" name="name" id="name" class="width-300">
				</td>
			</tr>
			<tr>
				<th class="lb req">대분류</th>
				<td class="indent5">
					<select name="classType1" id="classType1" class="width-200" onchange="first(this);">
						<option value="">선택</option>
						<%
						for (Map<String, String> map : classTypes1) {
							String value = map.get("value");
							String name = map.get("name");
							String clazz = map.get("clazz");
						%>
						<option value="<%=value%>" data-clazz="<%=clazz%>"><%=name%></option>
						<%
						}
						%>
					</select>
				</td>
				<th>중분류</th>
				<td class="indent5">
					<select name="classType2" id="classType2" class="width-300" onchange="second(this);">
						<option value="">선택</option>
					</select>
				</td>
				<th>소분류</th>
				<td class="indent5">
					<select name="classType3" id="classType3" class="width-300">
						<option value="">선택</option>
					</select>
				</td>
			</tr>
			<tr>
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
				<th>부서</th>
				<td class="indent5" colspan="3">
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
			<tr>
				<th>작성자</th>
				<td class="indent5">
					<input type="text" name="writer" id="writer" data-multi="false" class="width-200">
					<input type="hidden" name="writerOid" id="writerOid">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('writer')">
				</td>
				<th>수정일</th>
				<td class="indent5">
					<input type="text" name="modifiedFrom" id="modifiedFrom" class="width-100">
					~
					<input type="text" name="modifiedTo" id="modifiedTo" class="width-100">
					<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearFromTo('modifiedFrom', 'modifiedTo')">
				</td>
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
			</tr>
			<tr>
				<th>보존기간</th>
				<td class="indent5" colspan="5">
					<select name="preseration" id="preseration" class="width-200">
						<option value="">선택</option>
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
		</table>
		<table class="button-table">
			<tr>
				<td class="left">
					<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();">
					<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('distribute-document-list');">
					<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('distribute-document-list');">
				</td>
				<td class="right">
					<select name="_psize" id="_psize">
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="100">100</option>
						<option value="200">200</option>
						<option value="300">300</option>
					</select>
					<input type="button" value="검색" title="검색" onclick="loadGridData();">
<!-- 					<input type="button" value="일괄 다운로드" title="일괄 다운로드" onclick="download();"> -->
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
						<jsp:param value="<%=DocumentHelper.DOCUMENT_ROOT%>" name="location" />
						<jsp:param value="product" name="container" />
						<jsp:param value="list" name="mode" />
						<jsp:param value="535" name="height" />
						<jsp:param value="doc" name="type" />
					</jsp:include>
				</td>
				<td valign="top">&nbsp;</td>
				<td valign="top">
					<div id="grid_wrap" style="height: 530px; border-top: 1px solid #3180c3;"></div>
					<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
					<%@include file="/extcore/jsp/common/aui-context.jsp"%>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			let myGridID;
			function _layout() {
				return [ {
					dataField : "name",
					headerText : "문서명",
					dataType : "string",
					style : "aui-left",
					width : 350,
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/distribute/documentView?oid=" + oid);
							_popup(url, "", "", "f");
						}
					},
				}, {
					dataField : "interalnumber",
					headerText : "내부 문서번호",
					dataType : "string",
					width : 180,
					renderer : {
						type : "LinkRenderer",
						baseUrl : "javascript",
						jsCallback : function(rowIndex, columnIndex, value, item) {
							const oid = item.oid;
							const url = getCallUrl("/distribute/documentView?oid=" + oid);
							_popup(url, "", "", "f");
						}
					},
				}, {
					dataField : "model",
					headerText : "프로젝트 코드",
					dataType : "string",
					width : 120,
				}, {
					dataField : "location",
					headerText : "문서분류",
					dataType : "string",
					style : "aui-left",
					width : 250,
				}, {
					dataField : "classType1_name",
					headerText : "대분류",
					dataType : "string",
					width : 100,
				}, {
					dataField : "classType2_name",
					headerText : "중분류",
					dataType : "string",
					width : 200,
				}, {
					dataField : "classType3_name",
					headerText : "소분류",
					dataType : "string",
					width : 100,
				}, {
					dataField : "version",
					headerText : "REV",
					dataType : "string",
					width : 80,
					renderer : {
						type : "TemplateRenderer"
					},
				}, {
					dataField : "state",
					headerText : "상태",
					dataType : "string",
					width : 80,
				}, {
					dataField : "writer",
					headerText : "작성자",
					dataType : "string",
					width : 100,
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
				}, {
					dataField : "primary",
					headerText : "주 첨부파일",
					dataType : "string",
					width : 80,
					renderer : {
						type : "TemplateRenderer"
					},
				}, {
					dataField : "secondary",
					headerText : "첨부파일",
					dataType : "string",
					width : 100,
					renderer : {
						type : "TemplateRenderer"
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
					hoverMode : "singleRow",
					enableMovingColumn : true,
					enableFilter : true,
					showInlineFilter : true,
					useContextMenu : true,
					enableRightDownFocus : true,
					filterLayerWidth : 320,
					filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
					enableRowCheckShiftKey : true,
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
			
			function auiContextMenuHandler(event) {
				const menu = [ {
					label : "문서 정보보기",
					callback : auiContextHandler
				}, {
					label : "_$line" // label 에 _$line 을 설정하면 라인을 긋는 아이템으로 인식합니다.
				}, {
					label : "버전이력보기",
					callback : auiContextHandler
				}, {
					label : "결재이력보기",
					callback : auiContextHandler
				}, {
					label : "_$line" // label 에 _$line 을 설정하면 라인을 긋는 아이템으로 인식합니다.
				}, {
					label : "결재회수(결재선유지)",
					callback : auiContextHandler
				}, {
					label : "결재회수(결재선초기화)",
					callback : auiContextHandler
				}, {
					label : "인쇄하기",
					callback : auiContextHandler
				} ];
				return menu;
			}
			
			function auiContextHandler(event) {
				const item = event.item;
				const oid = item.oid;
				const state = item.state;
				let permission = isPermission(oid);
				if (!permission) {
					authMsg();
					return false;
				}

				let url;
				const download = document.getElementById("download");
				switch (event.contextIndex) {
				case 0:
					url = getCallUrl("/doc/view?oid=" + oid);
					_popup(url, "", "", "f");
					break;
				case 1:
					break;
				// 				case 2:
				// 					url = getCallUrl("/doc/asdf?oid=" + oid);
				// 					download.src = url;
				// 					break;
				// 				case 3:
				// 					url = getCallUrl("/doc/asdf?oid=" + oid);
				// 					download.src = url;
				// 					break;
				case 2:
					url = getCallUrl("/doc/iteration?oid=" + oid + "&popup=true");
					_popup(url, 1600, 600, "n");
					break;
				case 3:
					url = getCallUrl("/workspace/history?oid=" + oid + "&popup=true");
					_popup(url, 1200, 400, "n");
					break;
				case 5:
					if ("승인중" !== state) {
						alert("승인중 상태의 문서만 결재회수가 가능합니다.");
						return false;
					}

					if (!confirm("기존 지정한 결재선 유지한 상태로 결재회수를 합니다.\n진행하시겠습니까?")) {
						return false;
					}
					url = getCallUrl("/workspace/withdraw?oid=" + oid + "&remove=false");
					parent.openLayer();
					call(url, null, function(data) {
						alert(data.msg);
						if (data.result) {
							document.location.href = getCallUrl("/workData/list");
						} else {
							parent.closeLayer();
						}
					}, "GET");
					break;
				case 6:
					if ("승인중" !== state) {
						alert("승인중 상태의 문서만 결재회수가 가능합니다.");
						return false;
					}
					if (!confirm("결재선을 초기화 상태로 결재회수를 합니다.\n진행하시겠습니까?")) {
						return false;
					}
					url = getCallUrl("/workspace/withdraw?oid=" + oid + "&remove=true");
					parent.openLayer();
					call(url, null, function(data) {
						alert(data.msg);
						if (data.result) {
							document.location.href = getCallUrl("/workData/list");
						} else {
							parent.closeLayer();
						}
					}, "GET");
					break;
				}
			}

			function loadGridData(movePage) {
				if (movePage === undefined) {
					document.getElementById("sessionid").value = 0;
				}
				
				let params = new Object();
				const url = getCallUrl("/doc/list");
				const field = [ "location", "classType1", "classType2", "classType3", "name", "number", "state", "creatorOid", "createdFrom", "createdTo", "modifiedFrom", "modifiedTo", "preseration", "model", "deptcode", "interalnumber", "writerOid", "description" ];
				document.getElementById("sessionid").value = 0;
				params = toField(params, field);
				params.latest = false;
				AUIGrid.showAjaxLoader(myGridID);
				parent.openLayer();
				logger(params);
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
			
			function first(obj) {
				const classType1 = obj.value;
				if (classType1 !== "") {
					loadClassType2(classType1);
				}
			}
			
			function loadClassType2(classType1) {
				const url = getCallUrl("/class/classType2?classType1=" + classType1);
				call(url, null, function(data) {
					const classType2 = data.classType2;
					if (data.result) {
						document.querySelector("#classType2 option").remove();
						document.querySelector("#classType2").innerHTML = "<option value=\"\">선택</option>";
						for (let i = 0; i < classType2.length; i++) {
							const value = classType2[i].value;
							const clazz = classType2[i].clazz;
							const tag = "<option data-clazz=\"" + clazz + "\" value=\"" + value + "\">" + classType2[i].name + "</option>";
							document.querySelector("#classType2").innerHTML += tag;
						}
					}
				}, "GET", false);
				selectbox("classType2");
			}

			function second(obj) {
				const classType1 = document.getElementById("classType1").value;
				const classType2 = obj.value;
				if (classType2 !== "") {
					loadClassType3(classType1, classType2);
				}
			}

			// 소분류 세팅
			function loadClassType3(classType1, classType2) {
				const url = getCallUrl("/class/classType3?classType1=" + classType1 + "&classType2=" + classType2);
				call(url, null, function(data) {
					const classType3 = data.classType3;
					if (data.result) {
						document.querySelector("#classType3 option").remove();
						document.querySelector("#classType3").innerHTML = "<option value=\"\">선택</option>";
						for (let i = 0; i < classType3.length; i++) {
							const value = classType3[i].value;
							const clazz = classType3[i].clazz;
							const tag = "<option data-clazz=\"" + clazz + "\" value=\"" + value + "\">" + classType3[i].name + "</option>";
							document.querySelector("#classType3").innerHTML += tag;
						}
					}
				}, "GET", false);
				selectbox("classType3");
			}

			document.addEventListener("DOMContentLoaded", function() {
				toFocus("interalnumber");
				const columns = loadColumnLayout("distribute-document-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				_createAUIGrid(_columns);
				AUIGrid.resize(_myGridID);
				finderUser("creator");
				twindate("created");
				twindate("modified");
				selectbox("_psize");
				selectbox("preseration");
				selectbox("model");
				selectbox("deptcode");
				finderUser("writer");
				selectbox("classType1");
				selectbox("classType2");
				selectbox("classType3");
			});

			function exportExcel() {
				const exceptColumnFields = [ "primary","secondary" ];
				const sessionName = document.getElementById("sessionName").value;
				exportToExcel("문서 리스트", "문서", "문서 리스트", exceptColumnFields, sessionName);
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
			
			//일괄 다운로드
// 			function download() {
// 				const items = AUIGrid.getCheckedRowItemsAll(myGridID);
// 				if (items.length == 0) {
// 					alert("다운로드할 문서를 선택하세요.");
// 					return false;
// 				}
// 				let oids = [];
// 				items.forEach((item)=>{
// 				    oids.push(item.oid)
// 				});
// 				document.location.href = "/Windchill/plm/content/downloadZIP?oids=" + oids;
// 			}
		</script>
	</form>
</body>
</html>