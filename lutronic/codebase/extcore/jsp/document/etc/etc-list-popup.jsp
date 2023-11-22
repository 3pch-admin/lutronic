<%@page import="wt.doc.DocumentType"%>
<%@page import="wt.org.WTUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.e3ps.common.code.NumberCode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
ArrayList<NumberCode> preserationList = (ArrayList<NumberCode>) request.getAttribute("preserationList");
ArrayList<NumberCode> deptcodeList = (ArrayList<NumberCode>) request.getAttribute("deptcodeList");
ArrayList<NumberCode> modelList = (ArrayList<NumberCode>) request.getAttribute("modelList");
DocumentType[] docTypeList = (DocumentType[]) request.getAttribute("docTypeList");
String location = (String) request.getAttribute("location");
String method = (String) request.getAttribute("method");
boolean multi = (boolean) request.getAttribute("multi");
%>
<input type="hidden" name="sessionid" id="sessionid">
<input type="hidden" name="curPage" id="curPage">

<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				관련 문서
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
			<input type="hidden" name="location" id="location" value="<%=location%>">
			<span id="locationText"><%=location%></span>
		</td>
		<th>문서 번호</th>
		<td class="indent5">
			<input type="text" name="number" id="number" class="width-300">
		</td>
		<th>문서명</th>
		<td class="indent5">
			<input type="text" name="name" id="name" class="width-300">
		</td>
	</tr>
	<tr>
		<th>문서유형</th>
		<td class="indent5">
			<select name="documentType" id="documentType" class="width-200">
				<option value="">선택</option>
				<%
				for (DocumentType docType : docTypeList) {
				%>
				<option value="<%=docType.toString()%>"><%=docType.getDisplay()%></option>
				<%
				}
				%>
			</select>
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
		<th>수정자</th>
		<td class="indent5">
			<input type="text" name="writer" id="writer" data-multi="false" class="width-200">
			<img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('writer')">
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
		<th>내부 문서번호</th>
		<td class="indent5">
			<input type="text" name="interalnumber" id="interalnumber" class="width-300">
		</td>
	</tr>
	<tr>
		<th>보존기간</th>
		<td class="indent5">
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
		<th>내용</th>
		<td class="indent5">
			<input type="text" name="description" id="description" class="width-300">
		</td>
	</tr>
</table>
<table class="button-table">
	<tr>
		<td class="left">
			<input type="button" value="추가" title="추가" onclick="<%=method%>();">
		</td>
		<td class="right">
			<select name="_psize" id="_psize">
				<option value="30">30</option>
				<option value="50">50</option>
				<option value="100">100</option>
				<option value="200">200</option>
				<option value="300">300</option>
			</select>
			<input type="button" value="검색" title="검색" class="blue" onclick="loadGridData();">
			<input type="button" value="닫기" title="닫기" class="gray" onclick="javascript:self.close();">
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
				<jsp:param value="<%=location%>" name="location" />
				<jsp:param value="product" name="container" />
				<jsp:param value="list" name="mode" />
				<jsp:param value="593" name="height" />
			</jsp:include>
		</td>
		<td valign="top">&nbsp;</td>
		<td valign="top">
			<div id="grid_wrap" style="height: 560px; border-top: 1px solid #3180c3;"></div>
			<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
			<%@include file="/extcore/jsp/common/aui-context.jsp"%>
		</td>
	</tr>
</table>
<script type="text/javascript">
let myGridID;
const columns = [ {
	dataField : "number",
	headerText : "문서번호",
	dataType : "string",
	width : 120,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "interalnumber",
	headerText : "내부 문서번호",
	dataType : "string",
	width : 120,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "model",
	headerText : "프로젝트 코드",
	dataType : "string",
	width : 120,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "name",
	headerText : "문서명",
	dataType : "string",
	style : "aui-left",
	width : 350,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "location",
	headerText : "문서분류",
	dataType : "string",
	width : 250,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "version",
	headerText : "REV",
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
	width : 100,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "writer",
	headerText : "작성자",
	dataType : "string",
	width : 100,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "creator",
	headerText : "등록자",
	dataType : "string",
	width : 80,
	filter : {
		showIcon : true,
		inline : true
	},
}, {
	dataField : "createdDate",
	headerText : "등록일",
	dataType : "date",
	width : 100,
	filter : {
		showIcon : true,
		inline : true,
	},
}, {
	dataField : "modifiedDate",
	headerText : "수정일",
	dataType : "date",
	width : 100,
	filter : {
		showIcon : true,
		inline : true,
	},
}, {
	dataField : "primary",
	headerText : "주 첨부파일",
	dataType : "string",
	width : 100,
	renderer : {
		type : "TemplateRenderer"
	},
	filter : {
		showIcon : false,
		inline : false
	},
}, {
	dataField : "secondary",
	headerText : "첨부파일",
	dataType : "string",
	width : 100,
	renderer : {
		type : "TemplateRenderer"
	},
	filter : {
		showIcon : false,
		inline : false
	},
} ]

function createAUIGrid(columnLayout) {
	const props = {
		headerHeight : 30,
		showRowNumColumn : true,
		showRowCheckColumn : true,
		<%if (!multi) {%>
		rowCheckToRadio : true,
		<%}%>
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
	const url = getCallUrl("/etc/list");
	const field = [ "location", "name", "number", "state", "creatorOid", "createdFrom", "createdTo", "modifiedFrom", "modifiedTo", "documentType", "preseration", "model", "deptcode", "interalnumber", "writer", "description" ];
	const latest = !!document.querySelector("input[name=latest]:checked").value;
	params = toField(params, field);
	params.latest = latest;
	AUIGrid.showAjaxLoader(myGridID);
	openLayer();
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
		closeLayer();
	});
}

document.addEventListener("DOMContentLoaded", function() {
	toFocus("number");
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
	finderUser("creator");
	twindate("created");
	twindate("modified");
	selectbox("_psize");
	selectbox("documentType");
	selectbox("preseration");
	selectbox("model");
	selectbox("deptcode");
	finderUser("writer");
});

function <%=method%>() {
		const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
		if (checkedItems.length === 0) {
			alert("추가할 행을 선택하세요.");
			return false;
		}
		
// 		const arr = new Array();
// 		checkedItems.forEach(function(item) {
// 			arr.push(item.item);
// 		})
		
		openLayer();
		opener.<%=method%>(checkedItems, function(res) {
		if(res) {
			setTimeout(function() {
				closeLayer();
			}, 500);
		}
	})
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
</script>