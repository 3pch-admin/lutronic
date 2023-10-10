<%@page import="com.e3ps.common.code.NumberCode"%>
<%@page import="java.util.ArrayList"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> sectionList = (ArrayList<NumberCode>) request.getAttribute("sectionList");
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
int parentRowIndex = request.getAttribute("parentRowIndex") != null ? (int) request.getAttribute("parentRowIndex") : -1;
%>
<input type="hidden" name="sessionid" id="sessionid"> 
<input type="hidden" name="lastNum" id="lastNum"> 
<input type="hidden" name="curPage" id="curPage">

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
		<th>ECPR 번호</th>
		<td class="indent5"><input type="text" name="number" id="number" class="width-300"></td>
		<th>ECPR 제목</th>
		<td class="indent5"><input type="text" name="name" id="name" class="width-300"></td>
		<th>상태</th>
		<td class="indent5">
			<select name="state" id="state" class="width-200" >
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
		<td class="indent5"><input type="text" name="creator" id="creator" data-multi="false" class="width-200"> <input type="hidden" name="creatorOid" id="creatorOid"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')"></td>
		<th>등록일</th>
		<td class="indent5"><input type="text" name="createdFrom" id="createdFrom" class="width-100"> ~ <input type="text" name="createdTo" id="createdTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
			onclick="clearFromTo('createdFrom', 'createdTo')"></td>
		<th>승인일</th>
		<td class="indent5"><input type="text" name="approveFrom" id="approveFrom" class="width-100"> ~ <input type="text" name="approveTo" id="approveTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
			onclick="clearFromTo('approveFrom', 'approveTo')"></td>
	</tr>
	<tr>
		<th>작성자</th>
		<td class="indent5">
			<input type="text" name="writer" id="writer" data-multi="false" class="width-200">
			<input type="hidden" name="writerOid" id="writerOid"> 
			<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')">
		</td>
		<th>작성부서</th>
		<td class="indent5">
			<input type="text" name="createDepart" id="createDepart" data-multi="false" class="width-200">
		</td>
		<th>작성일</th>
		<td class="indent5"><input type="text" name="writedFrom" id="writedFrom" class="width-100"> ~ <input type="text" name="writedTo" id="writedTo" class="width-100"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제"
			onclick="clearFromTo('writedFrom', 'writedTo')"></td>
		
	</tr>
	<tr>
		<th>제안자</th>
		<td class="indent5">
			<input type="text" name="proposer" id="proposer" data-multi="false" class="width-200">
			<input type="hidden" name="proposerOid" id="proposerOid"> 
			<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')">
		</td>
		<th>변경구분</th>
		<td class="indent5">
			<select name="changeSection" id="changeSection" class="width-200">
				<option value="">선택</option>
				<%
				for (NumberCode section : sectionList) {
				%>
				<option value="<%=section.getCode() %>"><%=section.getName()%></option>
				<%
				}
				%>
			</select>
		</td>
		<th class="req lb">프로젝트 코드</th>
		<td class="indent5" >
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
</table>

<table class="button-table">
	<tr>
		<td class="left">
			<input type="button" value="추가" title="추가"  onclick="add();">
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
			<input type="button" value="초기화" title="초기화" onclick="resetColumnLayout('document-list');">
		</td>
	</tr>
</table>

<div id="grid_wrap" style="height: 645px; border-top: 1px solid #3180c3;"></div> <%@include file="/extcore/jsp/common/aui-context.jsp"%>
<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
<script type="text/javascript">
let myGridID;
const columns = [ {
	dataField : "eoNumber",
	headerText : "ECPR 번호",
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
			const url = getCallUrl("/changeECR/view?oid=" + oid);
			popup(url, 1600, 800);
		}
	},
}, {
	dataField : "eoName",
	headerText : "ECPR 제목",
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
			const url = getCallUrl("/changeECR/view?oid=" + oid);
			popup(url, 1600, 800);
		}
	},
}, {
	dataField : "changeSection",
	headerText : "변경구분",
	dataType : "string",
	width : 120,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "createDepart",
	headerText : "작성부서",
	dataType : "string",
	width : 250,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "writer",
	headerText : "작성자",
	dataType : "string",
	width : 180,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "createDate",
	headerText : "작성일",
	dataType : "string",
	width : 180,
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
	dataField : "writer",
	headerText : "등록자",
	dataType : "string",
	width : 180,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "createDate",
	headerText : "등록일",
	dataType : "string",
	width : 180,
	filter : {
		showIcon : true,
		inline : true
	},
} ]

function createAUIGrid(columnLayout) {
	const props = {
		headerHeight : 30,
		showRowNumColumn : true,
		fillColumnSizeMode: true,
		rowNumHeaderText : "번호",
		showAutoNoDataMessage : true,
		selectionMode : "multipleCells",
		enableMovingColumn : true,
		showInlineFilter : false,
		useContextMenu : true,
		enableRightDownFocus : true,
		filterLayerWidth : 320,
		filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
		enableFilter : true
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
	const url = getCallUrl("/changeECR/list");
	const field = ["_psize","name","number", "createdFrom", "createdTo", "creator", "state", "writedFrom", "writedTo", "approveFrom", "approveTo", "createDepart", "writer", "proposer", "model", "changeSection"];
	params = toField(params, field);
	AUIGrid.showAjaxLoader(myGridID);
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
	});
}

document.addEventListener("DOMContentLoaded", function() {
	const contenxtHeader = genColumnHtml(columns);
	$("#h_item_ul").append(contenxtHeader);
	$("#headerMenu").menu({
		select : headerMenuSelectHandler
	});
	createAUIGrid(columns);
	AUIGrid.resize(myGridID);
	selectbox("state");
	finderUser("creator");
	finderUser("writer");
	finderUser("proposer");
	twindate("created");
	twindate("approve");
	twindate("writed");
	selectbox("_psize");
	selectbox("changeSection");
	selectbox("model");
});

function exportExcel() {
	// 				const exceptColumnFields = [ "primary" ];
	// 				const sessionName = document.getElementById("sessionName").value;
	// 				exportToExcel("문서 리스트", "문서", "문서 리스트", exceptColumnFields, sessionName);
}

document.querySelector("#addNumberCode").addEventListener("click", () => {
	const url = getCallUrl("/common/popup_numberCodes?codeType=MODEL&disable=true");
	popup(url, 1500, 700);
});

document.querySelector("#delNumberCode").addEventListener("click", () => {
	
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

// 추가 버튼
function add(){
	const items = AUIGrid.getCheckedRowItemsAll(myGridID);
	if (items.length == 0) {
	    alert("첨부할 EO를 선택하세요.");
	    return false;
	}
       
	let ecprOids = [];
	let ecprNumber = [];
	for(let i = 0; i < items.length; i++){
		ecprOids.push(items[i].oid);
		ecprNumber.push(items[i].number);
	}
	var parentRow = <%= parentRowIndex %>;
	if(parentRow<0){
		opener.setAppendECPR(items);
	}else{
		opener.setECPR(ecprOids, ecprNumber, <%= parentRowIndex %>);
	}
	
	self.close();
}
</script>