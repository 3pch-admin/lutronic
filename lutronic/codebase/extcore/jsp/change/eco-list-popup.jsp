<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
int parentRowIndex = request.getAttribute("parentRowIndex") != null ? (int) request.getAttribute("parentRowIndex") : -1;
%>
<input type="hidden" name="sessionid" id="sessionid"> <input type="hidden" name="lastNum" id="lastNum"> <input type="hidden" name="curPage" id="curPage">

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
		<th>ECO 번호</th>
		<td class="indent5"><input type="text" name="eoNumber" id="eoNumber" class="width-300"></td>
		<th>ECO 제목</th>
		<td class="indent5"><input type="text" name="eoName" id="eoName" class="width-300"></td>
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
		<th>등록자</th>
		<td class="indent5"><input type="text" name="creator" id="creator" data-multi="false" class="width-300"> <input type="hidden" name="creatorOid" id="creatorOid"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')"></td>
	<th>등록일</th>
	<td class="indent5"><input type="text" name="createdFrom" id="createdFrom" class="width-100"> ~ <input type="text" name="createdTo" id="createdTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
		onclick="clearFromTo('createdFrom', 'createdTo')"></td>
	<th>승인일</th>
	<td class="indent5"><input type="text" name="createdFrom" id="modifiedFrom" class="width-100"> ~ <input type="text" name="createdTo" id="modifiedTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
		onclick="clearFromTo('createdFrom', 'createdTo')"></td>
	</tr>
	<tr>
		<th class="req lb">프로젝트 코드</th>
		<td>
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
		<th>인허가변경</th>
		<td> &nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="licensing" value="" checked="checked">
				<div class="state p-success">
					<label> <b>전체</b>
					</label>
				</div>
			</div>&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="licensing"  id="licensing" value="NONE" >
				<div class="state p-success">
					<label> <b>N/A</b>
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
			</div>
		</td>
		<th>위험통제</th>
		<td> &nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="riskType" value="" checked="checked">>
				<div class="state p-success">
					<label> <b>전체</b>
					</label>
				</div>
			</div>&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="riskType"  id="riskType" value="NONE" >
				<div class="state p-success">
					<label> <b>N/A</b>
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
			</div>
		</td>
	</tr>
	<tr>
		<th class="req lb">완제품 품목</th>
		<td colspan="5">
			<jsp:include page="/extcore/jsp/change/include_ecrCompletePart.jsp">
				<jsp:param value="" name="oid" />
				<jsp:param value="create" name="mode" />
			</jsp:include>
		</td>
	</tr>
</table>

<table class="button-table">
	<tr>
		<td class="left">
			<img src="/Windchill/extcore/images/fileicon/file_excel.gif" title="엑셀 다운로드" onclick="exportExcel();"> 
		<img src="/Windchill/extcore/images/save.gif" title="테이블 저장" onclick="saveColumnLayout('eco-list');">
		<img src="/Windchill/extcore/images/redo.gif" title="테이블 초기화" onclick="resetColumnLayout('part-list');"> 
		<input type="button" value="추가" title="추가" class="blue" onclick="add();">
	</td>
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
		</td>
	</tr>
</table>

<div id="grid_wrap" style="height: 645px; border-top: 1px solid #3180c3;"></div> <%@include file="/extcore/jsp/common/aui-context.jsp"%>
<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
<script type="text/javascript">
			let myEcoGridID;
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
					dataField : "createDate",
					headerText : "승인일",
					dataType : "string",
					width : 100,
					filter : {
						showIcon : true,
						inline : true
					},
				}, {
					dataField : "modifyDate",
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
				myEcoGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
				loadGridData();
				AUIGrid.bind(myEcoGridID, "contextMenu", auiContextMenuHandler);
				AUIGrid.bind(myEcoGridID, "vScrollChange", function(event) {
					hideContextMenu();
				});
				AUIGrid.bind(myEcoGridID, "hScrollChange", function(event) {
					hideContextMenu();
				});
			}

			function loadGridData() {
				let params = new Object();
				const url = getCallUrl("/changeECO/list");
				const field = ["_psize", "name","number","eoType","predate","postdate","creator","state", "licensing", "model", "sortCheck", "sortValue", "riskType", "preApproveDate", "postApproveDate"];
				params = toField(params, field);
				AUIGrid.showAjaxLoader(myEcoGridID);
				call(url, params, function(data) {
					AUIGrid.removeAjaxLoader(myEcoGridID);
					if (data.result) {
						totalPage = Math.ceil(data.total / data.pageSize);
						document.getElementById("sessionid").value = data.sessionid;
						createPagingNavigator(data.curPage);
						AUIGrid.setGridData(myEcoGridID, data.list);
					} else {
						alert(data.msg);
					}
				});
			}

// 			document.querySelector("#addNumberCode").addEventListener("click", () => {
// 				const url = getCallUrl("/common/popup_numberCodes?codeType=MODEL&disable=true");
// 				popup(url, 1500, 700);
// 			});
			
// 			document.querySelector("#delNumberCode").addEventListener("click", () => {
				
// 			});
	
			document.addEventListener("DOMContentLoaded", function() {
				const columns = loadColumnLayout("eco-list");
				const contenxtHeader = genColumnHtml(columns);
				$("#h_item_ul").append(contenxtHeader);
				$("#headerMenu").menu({
					select : headerMenuSelectHandler
				});
				createAUIGrid(columns);
				createAUIGrid2(columnsPart);
				AUIGrid.resize(myEcoGridID);
				selectbox("state");
				finderUser("creator");
				twindate("created");
				twindate("modified");
				selectbox("_psize");
				selectbox("model");
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
				AUIGrid.resize(myEcoGridID);
			});
			
			function add(){
		        const items = AUIGrid.getCheckedRowItemsAll(myEcoGridID);
		        if (items.length == 0) {
		            alert("첨부할 ECO를 선택하세요.");
		            return false;
		        }
		        
		        let ecoOids = [];
				let ecoNumber = [];
				for(let i = 0; i < items.length; i++){
					ecoOids.push(items[i].oid);
					ecoNumber.push(items[i].eoNumber);
				}
				var parentRow = <%= parentRowIndex %>;
				if(parentRow<0){
					opener.setAppendECO(items);
				}else{
					opener.setECO(ecoOids, ecoNumber, <%= parentRowIndex %>);
				}
				
	        	self.close();
		    }
		</script>