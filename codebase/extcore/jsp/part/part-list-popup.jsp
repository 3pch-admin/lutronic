<%@page import="com.e3ps.part.service.PartHelper"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="wt.org.WTUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="com.e3ps.drawing.service.DrawingHelper"%>
<%@page import="com.e3ps.common.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> matList = (ArrayList<NumberCode>) request.getAttribute("matList");
ArrayList<NumberCode> productmethodList = (ArrayList<NumberCode>) request.getAttribute("productmethodList");
ArrayList<NumberCode> manufactureList = (ArrayList<NumberCode>) request.getAttribute("manufactureList");
ArrayList<NumberCode> finishList = (ArrayList<NumberCode>) request.getAttribute("finishList");
List<Map<String, String>> lifecycleList = (List<Map<String, String>>) request.getAttribute("lifecycleList");
String method = (String) request.getAttribute("method");
boolean multi = (boolean) request.getAttribute("multi");
String rowId = request.getParameter("rowId") == null ? "" : request.getParameter("rowId").toString();
boolean limit = request.getParameter("limit") == null ? false : Boolean.parseBoolean(request.getParameter("limit"));
boolean complete = (boolean) request.getAttribute("complete");
%>
<style type="text/css">
.preOrder {
	/* 	background-color: rgb(200, 255, 203) !important; */
	
}

.checkout {
	background-color: rgb(254, 192, 209) !important;
}
</style>

<input type="hidden" name="sessionid" id="sessionid">
<input type="hidden" name="curPage" id="curPage">
<input type="hidden" name="oid" id="oid">

<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				관련 품목
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
		<th>품목분류</th>
		<td class="indent5">
			<input type="hidden" name="oid" id="oid">
			<input type="hidden" name="location" id="location" value="<%=PartHelper.PART_ROOT%>">
			<span id="locationText"><%=PartHelper.PART_ROOT%></span>
		</td>
		<th>등록자</th>
		<td class="indent5">
			<input type="text" name="creator" id="creator" data-multi="false" class="width-300">
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
		<th>품목번호</th>
		<td class="indent5">
			<input type="text" name="partNumber" id="partNumber" class="width-300">
		</td>
		<th>품목명</th>
		<td class="indent5">
			<input type="text" name="partName" id="partName" class="width-300">
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
				<input type="radio" name="latest" value="">
				<div class="state p-success">
					<label>
						<b>모든REV</b>
					</label>
				</div>
			</div>
		</td>
	</tr>
	<tr class="hidden">
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
		<th>사양</th>
		<td class="indent5">
			<input type="text" name="specification" id="specification" class="width-300">
		</td>
	</tr>
	<tr class="hidden">
		<th>단위</th>
		<td class="indent5">
			<select name="unit" id="unit" class="width-200">
				<option value="">선택</option>
				<option value="INWORK">작업 중</option>
				<option value="UNDERAPPROVAL">승인 중</option>
				<option value="APPROVED">승인됨</option>
				<option value="RETURN">반려됨</option>
			</select>
		</td>
		<th>무게</th>
		<td class="indent5">
			<input type="text" name="weight" id="weight" class="width-300">
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
		<th>OEM Info.</th>
		<td class="indent5">
			<input type="text" name="remarks" id="remarks" class="width-300">
		</td>
	</tr>
	<tr class="hidden">
		<th>ECO No.</th>
		<td class="indent5">
			<input type="text" name="ecoNo" id="ecoNo" class="width-300">
		</td>
		<th>Eo No.</th>
		<td class="indent5">
			<input type="text" name="eoNo" id="eoNo" class="width-300">
		</td>
		<th>선구매</th>
		<td>
			&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="preOrder" value="yes">
				<div class="state p-success">
					<label>
						<b>예</b>
					</label>
				</div>
			</div>
			&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="preOrder" value="no">
				<div class="state p-success">
					<label>
						<b>아니오</b>
					</label>
				</div>
			</div>
			&nbsp;
			<div class="pretty p-switch">
				<input type="radio" name="preOrder" value="all" checked="checked">
				<div class="state p-success">
					<label>
						<b>전체</b>
					</label>
				</div>
			</div>
		</td>
	</tr>
</table>

<table class="button-table">
	<tr>
		<td class="left">
			<input type="button" value="▼펼치기" title="▼펼치기" class="red" onclick="spread(this);">
			<input type="button" value="추가" title="추가" onclick="<%=method%>();">
		</td>
		<td class="right">
			<select name="_psize" id="_psize">
				<option value="10">10</option>
				<option value="30">30</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select>
			<input type="button" value="검색" title="검색" onclick="loadGridData()">
			<input type="button" value="닫기" title="닫기" class="gray" onclick="self.close();">
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
				<jsp:param value="<%=PartHelper.PART_ROOT%>" name="location" />
				<jsp:param value="product" name="container" />
				<jsp:param value="list" name="mode" />
				<jsp:param value="483" name="height" />
			</jsp:include>
		</td>
		<td valign="top">&nbsp;</td>
		<td valign="top">
			<div id="grid_wrap" style="height: 450px; border-top: 1px solid #3180c3;"></div>
			<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
			<%@include file="/extcore/jsp/common/aui-context.jsp"%>
		</td>
	</tr>
</table>

<script type="text/javascript">
let myGridID;
const columns = [ {
	dataField : "_3d",
	headerText : "3D",
	dataType : "string",
	width : 40,
	renderer : {
		type : "ImageRenderer",
		altField : null,
		imgHeight : 16,
		onClick : function(event) {
		}
	},
}, {
	dataField : "_2d",
	headerText : "2D",
	dataType : "string",
	width : 40,
	renderer : {
		type : "ImageRenderer",
		altField : null,
		imgHeight : 16,
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
	dataField : "number",
	headerText : "품목번호",
	dataType : "string",
	width : 180,
}, {
	dataField : "name",
	headerText : "품목명",
	dataType : "string",
	style : "aui-left",
	width : 380,
}, {
	dataField : "location",
	headerText : "품목분류",
	dataType : "string",
	width : 250,
	style : "aui-left"
}, {
	dataField : "version",
	headerText : "REV",
	dataType : "string",
	width : 80,
	renderer : {
		type : "TemplateRenderer"
	},
}, {
	dataField : "remarks",
	headerText : "OEM Info.",
	dataType : "string",
	width : 100,
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
	width : 140,
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
		showInlineFilter : false,
		useContextMenu : true,
		enableRowCheckShiftKey : true,
		<%if (!multi) {%>
		rowCheckToRadio : true,
		<%}%>
		enableRightDownFocus : true,
		filterLayerWidth : 320,
		filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
		<%if (complete) {%>
		rowCheckDisabledFunction: function (rowIndex, isChecked, item) {
			if (item.state !== "작업 중") {
				return false; // false 반환하면 disabled 처리됨
			}
			
			if(item.number.charAt(0) !== "1") {
				return false; // false 반환하면 disabled 처리됨
			}
			
			return true;
		}
		<%}%>
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
	AUIGrid.bind(myGridID, "cellClick", auiCellClick);
}

function auiCellClick(event) {
	const item = event.item;
	const rowIdField = AUIGrid.getProp(event.pid, "rowIdField"); // rowIdField 얻기
	const rowId = item[rowIdField];
	let complete = false;
	<%if (complete) {%>
	if (item.state !== "작업 중") {
		complete = true;
	}
	
	if(item.number.charAt(0) !== "1") {
		complete = true;
	}
	<%}%>
	
	
	<%if (!multi) {%>
	// 이미 체크 선택되었는지 검사
	if(!complete) {
		if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
			// 엑스트라 체크박스 체크해제 추가
			AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
		} else {
			// 엑스트라 체크박스 체크 추가
			AUIGrid.setCheckedRowsByIds(event.pid, rowId);
		}
	}
	<%} else {%>
	if(!complete) {
		if (AUIGrid.isCheckedRowById(event.pid, item._$uid)) {
			AUIGrid.addUncheckedRowsByIds(event.pid,item._$uid);
		} else {
			AUIGrid.addCheckedRowsByIds(event.pid, item._$uid);
		}
	}
	<%}%>
}

function loadGridData(movePage) {
	if (movePage === undefined) {
		document.getElementById("sessionid").value = 0;
	}
	let params = new Object();
	const url = getCallUrl("/part/list");
	const field = [ "location", "partNumber", "partName", "createdFrom", "createdTo", "modifiedFrom", "modifiedTo", "creator", "state", "model", "productmethod", "deptcode", "unit", "weight", "mat", "finish", "remarks",
		"ecoNo", "eoNo" ,"creatorOid","specification"];
	const  latest = document.querySelector("input[name=latest]:checked").value;
	params = toField(params, field);
	params.latest = JSON.parse(latest);
	AUIGrid.showAjaxLoader(myGridID);
	openLayer();
	call(url, params, function(data) {
		AUIGrid.removeAjaxLoader(myGridID);
		if (data.result) {
			totalPage = Math.ceil(data.total / data.pageSize);
			createPagingNavigator(data.curPage, data.sessionid);
			AUIGrid.setGridData(myGridID, data.list);
		} else {
			alert(data.msg);
		}
		closeLayer();
	});
}

function <%=method%>() {
	const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
	if (checkedItems.length === 0) {
		alert("추가할  품목을 선택하세요.");
		return false;
	}
	
	opener.<%=method%>(checkedItems, function(res, close, msg) {
		trigger(close, msg);
	})
}

document.addEventListener("DOMContentLoaded", function() {
	toFocus("partNumber");
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

function spread(target) {
	const e = document.querySelectorAll('.hidden');
	// 버근가..
	for (let i = 0; i < e.length; i++) {
		const el = e[i];
		const style = window.getComputedStyle(el);
		const display = style.getPropertyValue("display");
		if (display === "none") {
			el.style.display = "table-row";
			target.value = "▲접기";
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
			target.value = "▼펼치기";
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