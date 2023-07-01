<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<script type="text/javascript">
<%----------------------------------------------------------
*                      AUI 그리드 
----------------------------------------------------------%>
var myGridID;

var defaultGridHeight = 61;
var rowHeight = 26;
var headerHeight = 24;
var footerHeight = 30;

var columnLayout = [ 
                	
 	{
         dataField : "number",
         headerText : '${f:getMessage('문서번호')}',
         style: "AUI_center",
         width: "15%"
 	},
 	{
        dataField : "interNumber",
        headerText : '${f:getMessage('내부문서번호')}',
        style: "AUI_left",
        width: "10%"
	},
 	{
        dataField : "model",
        headerText : '${f:getMessage('프로젝트코드')}',
        style: "AUI_center",
        width: "10%"
	},
 	{
         dataField : "name",
         headerText : '${f:getMessage('문서명')}',
         style: "AUI_left",
         width: "*",
         
         renderer : { // HTML 템플릿 렌더러 사용
 			type : "TemplateRenderer"
 		},
 		labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
 			var temp = "<a href=javascript:openDistributeView('" + item.oid + "') style='line-height:26px;'>" + value + "</a>"
 			return temp; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
 		}
 		
 	}, 
 	{
         dataField : "location",
         headerText : '${f:getMessage('품번분류')}',
         style: "AUI_left",
         width: "20%"
 	}, 
 	{
         dataField : "rev",
         headerText : 'Rev.',
         width: "5%"
 	},
 	{
         dataField : "state",
         headerText : '${f:getMessage('상태')}',
         width: "6%"
 	},
 	{
         dataField : "creator",
         headerText : '${f:getMessage('등록자')}',
         width: "6%"
 	},
 	{
         dataField : "createDate",
         headerText : '${f:getMessage('등록일')}',
         width: "7%"
 	},
 	{
         dataField : "modifyDate",
         headerText : '${f:getMessage('수정일')}',
         width: "7%"
 	},
  ];

<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
	
	//Aui 그리드 설정
	var auiGridProps = {
		selectionMode : "multipleCells",
		showRowNumColumn : true,
		softRemoveRowMode : false,
		processValidData : true,
		headerHeight : headerHeight,
		rowHeight : rowHeight,
		height : 400,
		
		
	};
	
	// 실제로 #grid_wrap 에 그리드 생성
	myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);
	
	
	//lfn_DhtmlxGridInit();
	gfn_InitCalendar("predate", "predateBtn");
	gfn_InitCalendar("postdate", "postdateBtn");
	gfn_InitCalendar("predate_modify", "predate_modifyBtn");
	gfn_InitCalendar("postdate_modify", "postdate_modifyBtn");
	lfn_getStateList();
	
	numberCodeList('model', '');
	numberCodeList('deptcode', '');
	numberCodeList('preseration', '');
	documentType('GENERAL', '');
	
	//lfn_Search();
	getGridData(1, 14);
});

<%----------------------------------------------------------
*                      DocumentType 리스트 가져오기
----------------------------------------------------------%>
window.documentType = function(documentType, searchType) {
	var data = common_documentType(documentType, '');
	
	addSelectList('documentType', eval(data.responseText));
}

<%----------------------------------------------------------
*                      NumberCode 리스트 가져오기
----------------------------------------------------------%>
window.numberCodeList = function(id) {
	var data = common_numberCodeList(id.toUpperCase(), '', true);
	
	addSelectList(id, eval(data.responseText));
}

<%----------------------------------------------------------
*                      selectBodx에 옵션 추가
----------------------------------------------------------%>
window.addSelectList = function(id,data){
	$("#"+ id + " option").remove();
	$("#"+ id).append("<option value='' title='' > ${f:getMessage('선택')} </option>");
	if(data.length > 0) {
		for(var i=0; i<data.length; i++) {
			var html = "<option value='" + data[i].code + "'>";
			
			if(id != 'documentType') {
				html += " [" + data[i].code + "] ";
			} 
			html += data[i].name + "</option>";
			
			$("#"+ id).append(html);
		}
	}
}

<%----------------------------------------------------------
*                      그리드 초기 설정
----------------------------------------------------------%>
function lfn_DhtmlxGridInit() {
	
	var COLNAMEARR = {
			 col01 : '${f:getMessage('번호')}'
			,col02 : '${f:getMessage('문서번호')}'
			,col03 : '${f:getMessage('내부 문서번호')}'
			,col04 : '${f:getMessage('프로젝트코드')}'
			,col05 : '${f:getMessage('문서명')}'
			,col06 : '${f:getMessage('문서분류')}'
			,col07 : '${f:getMessage('Rev.')}'
			,col08 : '${f:getMessage('상태')}'
			,col09 : '${f:getMessage('작성자')}'
			,col10 : '${f:getMessage('등록자')}'
			,col11 : '${f:getMessage('등록일')}'
			,col12 : '${f:getMessage('수정일')}'
	}
	
	var sHeader = "";
	sHeader +=       COLNAMEARR.col01;
	sHeader += "," + COLNAMEARR.col02;
	sHeader += "," + COLNAMEARR.col03;
	sHeader += "," + COLNAMEARR.col04;
	sHeader += "," + COLNAMEARR.col05;
	sHeader += "," + COLNAMEARR.col06;
	sHeader += "," + COLNAMEARR.col07;
	sHeader += "," + COLNAMEARR.col08;
	sHeader += "," + COLNAMEARR.col09;
	sHeader += "," + COLNAMEARR.col10;
	sHeader += "," + COLNAMEARR.col11;
	sHeader += "," + COLNAMEARR.col12;
	
	var sHeaderAlign = new Array();
	sHeaderAlign[0]  = "text-align:center;";
	sHeaderAlign[1]  = "text-align:center;";
	sHeaderAlign[2]  = "text-align:center;";
	sHeaderAlign[3]  = "text-align:center;";
	sHeaderAlign[4]  = "text-align:center;";
	sHeaderAlign[5]  = "text-align:center;";
	sHeaderAlign[6]  = "text-align:center;";
	sHeaderAlign[7]  = "text-align:center;";
	sHeaderAlign[8]  = "text-align:center;";
	sHeaderAlign[9]  = "text-align:center;";
	sHeaderAlign[10]  = "text-align:center;";
	sHeaderAlign[11]  = "text-align:center;";

	var sWidth = "";
	sWidth += "3";
	sWidth += ",10";
	sWidth += ",8";
	sWidth += ",8";
	sWidth += ",19";
	sWidth += ",10";
	sWidth += ",4";
	sWidth += ",4";
	sWidth += ",10";
	sWidth += ",8";
	sWidth += ",8";
	sWidth += ",8";
	
	var sColAlign = "";
	sColAlign += "center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",left";
	sColAlign += ",left";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	
	var sColType = "";
	sColType += "ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";

	var sColSorting = "";
	sColSorting += "na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	
	documentListGrid = new dhtmlXGridObject('listGridBox');
	documentListGrid.setImagePath("/Windchill/jsp/js/dhtmlx/imgs/");
	documentListGrid.setHeader(sHeader,null,sHeaderAlign);
	documentListGrid.enableAutoHeight(true);
	documentListGrid.setInitWidthsP(sWidth);
	documentListGrid.setColAlign(sColAlign);
	documentListGrid.setColTypes(sColType);
	documentListGrid.setColSorting(sColSorting);
	
	/*grid text copy option*/
    documentListGrid.enableBlockSelection();
    documentListGrid.forceLabelSelection(true);
    documentListGrid.attachEvent("onKeyPress",function onKeyPressed(code,ctrl,shift){
        if(code==67&&ctrl){
            if(!documentListGrid._selectionArea) return alert("return");
            documentListGrid.setCSVDelimiter("\t");
            documentListGrid.copyBlockToClipboard();
	    }
	    return;
	});
    /*grid text copy option*/

	
	documentListGrid.attachEvent("onHeaderClick",function(rowId,cellIndex){
		
		var sortValue = "";
		var header = "";
		
		if(rowId == 1) {
			sortValue = "master>number";
			header = COLNAMEARR.col02;
		}else if(rowId == 4 ){
			sortValue = "master>name";
			header = COLNAMEARR.col05;
		}else if(rowId == 9 ) {
			sortValue = "iterationInfo.creator.key.id";
			header = COLNAMEARR.col10;
		}else if(rowId == 10) {
			sortValue = "thePersistInfo.createStamp";
			header = COLNAMEARR.col11;
		}
		
		
		if(sortValue != "") {
			if($("#sortValue").val() != sortValue) {
				$("#sortCheck").val("");
			}
			
			if("true" == $("#sortCheck").val()) {
				$("#sortCheck").val("false");
				header += " ▼";
			} else {
				$("#sortCheck").val("true");
				header += " ▲";
			}

			documentListGrid.setColLabel(1, COLNAMEARR.col02);
			documentListGrid.setColLabel(4, COLNAMEARR.col05);
			documentListGrid.setColLabel(9, COLNAMEARR.col10);
			documentListGrid.setColLabel(10, COLNAMEARR.col11);
			documentListGrid.setColLabel(rowId, header);
			
			$("#sortValue").val(sortValue);
			$("#sessionId").val("");
			$("#page").val(1);
			lfn_Search();
		}
	});
	
	documentListGrid.init();
}

$(function(){
	<%----------------------------------------------------------
	*                      검색 버튼 클릭시
	----------------------------------------------------------%>
	$("#searchBtn").click(function (){
		/*
		lfn_DhtmlxGridInit();
		$("#sortValue").val("");
		$("#sortCheck").val("");
		$("#sessionId").val("");
		$("#page").val(1);
		lfn_Search();
		*/
		resetSearch();
	})
	<%----------------------------------------------------------
	*                      초기화 버튼 클릭시
	----------------------------------------------------------%>
	$("#btnReset").click(function() {
		$("#fid").val("");
		$("#location").val("/Default/Document");
		$("#locationName").html("/Default/Document");
	})
	<%----------------------------------------------------------
	*                      상세검색 검색 버튼
	----------------------------------------------------------%>
	$("#detailBtn").click(function () {
		if($('#SearchDetailProject').css('display') == 'none'){ 
			$("#detailText").html("${f:getMessage('상세검색')} -");
		   	$('#SearchDetailProject').show(); 
		} else { 
			$("#detailText").html("${f:getMessage('상세검색')} +");
		   	$('#SearchDetailProject').hide(); 
		}
	})
	$(document).keypress(function(event) {
		 if(event.which == 13 && $( '#userNameSearch' ).is( ':hidden' )) {
			 resetSearch();
		 }
	})
})

window.resetSearch = function() {
	//lfn_DhtmlxGridInit();
	$("#sortValue").val("");
	$("#sortCheck").val("");
	$("#sessionId").val("");
	$("#page").val(1);
	//lfn_Search();
	getGridData(1, 14);
}
var sortValue = "";
var sortCheck = true;
function createPagingNavigator(goPage, totalPage) {
	var pageButtonCount = 10;		// 페이지 네비게이션에서 보여줄 페이지의 수
	
	var retStr = "";
	var prevPage = parseInt((goPage - 1)/pageButtonCount) * pageButtonCount;
	var nextPage = ((parseInt((goPage - 1)/pageButtonCount)) * pageButtonCount) + pageButtonCount + 1;

	prevPage = Math.max(0, prevPage);
	nextPage = Math.min(nextPage, totalPage);
	
	// 처음
	retStr += "<a href='javascript:moveToPage(1)'><span class='aui-grid-paging-number aui-grid-paging-first'>first</span></a>";

	// 이전
	retStr += "<a href='javascript:moveToPage(" + Math.max(1, prevPage) + ")'><span class='aui-grid-paging-number aui-grid-paging-prev'>prev</span></a>";

	for (var i=(prevPage+1), len=(pageButtonCount+prevPage); i<=len; i++) {
		if (goPage == i) {
			retStr += "<span class='aui-grid-paging-number aui-grid-paging-number-selected'>" + i + "</span>";
		} else {
			retStr += "<a href='javascript:moveToPage(" + i + ")'><span class='aui-grid-paging-number'>";
			retStr += i;
			retStr += "</span></a>";
		}
		
		if (i >= totalPage) {
			break;
		}

	}

	// 다음
	retStr += "<a href='javascript:moveToPage(" + nextPage + ")'><span class='aui-grid-paging-number aui-grid-paging-next'>next</span></a>";

	// 마지막
	retStr += "<a href='javascript:moveToPage(" + totalPage + ")'><span class='aui-grid-paging-number aui-grid-paging-last'>last</span></a>";

	document.getElementById("grid_paging").innerHTML = retStr;
}

function moveToPage(goPage) {
	
	var rowCount = $("#rows").val();
	
	// rowCount 만큼 데이터 요청
	$("#page").val(goPage);
	
	getGridData(goPage, rowCount, sortValue);
}

function getGridData(goPage, rowCount, sortValue){
	
	var form = $("form[name=documentForm]").serialize();
	var url	= getURLString("distribute", "listPagingDocumentAction", "do");
	$.ajax({
		type:"POST",
		url: url,
		data:form,
		dataType:"json",
		async: true,
		cache: false,

		error:function(data){
			var msg = "${f:getMessage('데이터 검색오류')}";
			alert(msg);
		},

		success:function(data){
			// 그리드 데이터
			var gridData = data.list;
			
			// 그리드에 데이터 세팅
			AUIGrid.setGridData(myGridID, gridData);
			
			AUIGrid.setAllCheckedRows(myGridID, false);
			
			var totalPage = data.totalPage;
			var startPage = data.startPage;
			var endPage = data.endPage;
			var listCount = data.listCount;
			var totalCount = data.totalCount;
			var currentPage = data.currentPage;
			var param = data.param;
			var rowCount = data.rowCount;
			$("#sessionId").val(data.sessionId);
			$("#page").val(currentPage);
			
			createPagingNavigator(currentPage, totalPage);
			
		}
		,beforeSend: function() {
			gfn_StartShowProcessing();
        }
		,complete: function() {
			gfn_EndShowProcessing();
        }
	});
}

<%----------------------------------------------------------
*                      데이터 검색 AJAX
----------------------------------------------------------%>
function  lfn_Search(){
	var form = $("form[name=documentForm]").serialize();
	var url	= getURLString("distribute", "listDocumentAction", "do");
	/*
	alert($("#location").val());
	if(true){
		return;
	}*/
	$.ajax({
		type:"POST",
		url: url,
		data:form,
		dataType:"json",
		async: true,
		cache: false,

		error:function(data){
			var msg = "${f:getMessage('데이터 검색오류')}";
			alert(msg);
		},

		success:function(data){
			// 그리드 데이터
			var gridData = data;
			
			// 그리드에 데이터 세팅
			AUIGrid.setGridData(myGridID, gridData);
			
		}
		,beforeSend: function() {
			gfn_StartShowProcessing();
        }
		,complete: function() {
			gfn_EndShowProcessing();
        }
	});
}

<%----------------------------------------------------------
*                      Lifecycle 상태 가져오기
----------------------------------------------------------%>
function lfn_getStateList() {
	var form = $("form[name=documentForm]").serialize();
	var url	= getURLString("WFItem", "lifecycleList", "do");
	$.ajax({
		type:"POST",
		url: url,
		data:form,
		dataType:"json",
		async: false,
		cache: false,

		error:function(data){
			var msg = "${f:getMessage('상태 리스트 검색오류')}";
			alert(msg);
		},

		success:function(data){
			
			$("#state").find("option").remove();
			$("#state").append("<option value=''>${f:getMessage('선택')}</option>");
			if(data.length > 0) {
				for(var i=0; i<data.length; i++) {
					$("#state").append("<option value='" + data[i].value + "'>" + data[i].name + "</option>");
				}
			}
			
		}
	});
}

<%----------------------------------------------------------
*                      유저 데이터 설정
----------------------------------------------------------%>
function addUser(obj) {
	$("#creator").val(obj[0][0]);
	$("#creatorName").val(obj[0][1]);
}

<%----------------------------------------------------------
*                      그리드 다시 그리기
----------------------------------------------------------%>
function redrawGrid(){
	AUIGrid.resize(myGridID);
}

function onExcelDown() {
	$("#documentForm").attr("method", "post");
	$("#documentForm").attr("action", getURLString("excelDown", "documentExcelDown", "do")).submit();
}
</script>

<body>

<form name="documentForm" id="documentForm" >

<!--  Paging 처리를 위한 Hidden 변수 -->
<input type="hidden" name="page"         id="page"          value="1"/>						<!-- page No -->
<input type="hidden" name="formPage"     id="formPage"      value="10"/>					<!-- 한 화면에 나타나는 페이지수 -->
<input type="hidden" name="rows"     	 id="rows"    		value="14"/>					<!-- 한 화면에 나타나는 데이터 수 -->
<input type="hidden" name="sessionId"    id="sessionId"     value=""/>

<!-- 서브 메뉴 닫을때 dhtmlx를 다시 그리기 위한 변수 -->
<input type="hidden" name="xmlString" id="xmlString" value="" />

<!-- 폴더 선택시 검색 function을 호출하기 위한 변수 -->
<input type="hidden" name="search" id="search" value="true" />

<!-- 정렬을 사용할때 사용하는 변수 -->
<input type="hidden" name="sortValue" id="sortValue" />
<input type="hidden" name="sortCheck" id="sortCheck" />

<input type="hidden" name="lifecycle" id="lifecycle" value="LC_Default">
<input type="hidden" name="fid" id="fid" value="">
<input type="hidden" name="location" id="location" value="/Default/Document">
<input type="hidden" name="searchType" id="searchType" value="document">

<input name="islastversion" type="hidden"  value="true" />
<input name="state" type="hidden"  value="APPROVED" />

<table border="0" height="100%"  cellspacing="0" cellpadding="0" width="100%" style="table-layout:auto">
		<tr>
			<td align="left" valign=top height=42>
				<table cellspacing="1" cellpadding="0" border=0 width=100% height=29 class="Subinfo_img_bg">
					<tr>
						<td></td>
						<td>
							<img src='/Windchill/jsp/portal/images/base_design/Sub_Right_ico.gif' width='10' height='9' />
							&nbsp;
							${f:getMessage('문서')} ${f:getMessage('관리')} > ${f:getMessage('문서')} ${f:getMessage('검색')}
						</td>
					</tr>
				</table>
			</td>
		</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="3" > <!--//여백 테이블-->
	<tr align="center">
		<td>
			<table width="100%" border="0" cellpadding="1" cellspacing="0" class="tablehead" align="center">
				<tr><td height=1 width=100%></td></tr>
			</table>
						
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" style="border-left-width: 1px;border-left-style: solid;border-left-color: #e6e6e6;">
				<colgroup>
					<col width='10%'>
					<col width='40%'>
					<col width='10%'>
					<col width='40%'>
				</colgroup>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">${f:getMessage('문서분류')}</td>
					<td class="tdwhiteL" colspan="3">
					
						<b>
							<span id="locationName">
								/Default/Document
							</span>
						</b>
					
					</td>
					<!--  
					<td class="tdblueM">${f:getMessage('Rev.')}</td>
					<td class="tdwhiteL">
						<input name="islastversion" id="islastversion" type="radio" class="Checkbox" value="true" checked>${f:getMessage('최신Rev.')}
						<input name="islastversion" id="islastversion" type="radio" class="Checkbox" value="false" >${f:getMessage('모든Rev.')}
					</td>
					-->
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">${f:getMessage('문서')}${f:getMessage('번호')}</td>
					<td class="tdwhiteL">
						<input name="docNumber" id="docNumber" class="txt_field" size="30" style="width:90%" value=""/>
					</td>
					<td class="tdblueM">${f:getMessage('문서명')}</td>
					<td class="tdwhiteL">
						<input name="docName" id="docName" class="txt_field" size="30" style="width:90%" value=""/>
					</td>
				</tr>
			
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('등록일')}
					</td>
					
					<td class="tdwhiteL">
						<input name="predate" id="predate" class="txt_field" size="12"  maxlength=15 readonly value=""/>
						<a href="javascript:void(0);"><img src="/Windchill/jsp/portal/images/calendar_icon.gif" border=0 name="predateBtn" id="predateBtn" ></a>
						<a href="JavaScript:clearText('predate')"><img src="/Windchill/jsp/portal/images/x.gif" border=0></a>
						~
						<input name="postdate" id="postdate" class="txt_field" size="12"  maxlength=15 readonly value=""/>
						<a href="javascript:void(0);"><img src="/Windchill/jsp/portal/images/calendar_icon.gif" border=0 name="postdateBtn" id="postdateBtn" ></a>
						<a href="JavaScript:clearText('postdate')"><img src="/Windchill/jsp/portal/images/x.gif" border=0></a>
					</td>
					
					<td class="tdblueM">
						${f:getMessage('수정일')}
					</td>
					
					<td class="tdwhiteL">
						<input name="predate_modify" id="predate_modify" class="txt_field" size="12"  maxlength=15 readonly  value='${predate_modify}'/>
						<a href="javascript:void(0);"><img src="/Windchill/jsp/portal/images/calendar_icon.gif" border=0 name="predate_modifyBtn" id="predate_modifyBtn" ></a>
						<a href="JavaScript:clearText('predate_modify')"><img src="/Windchill/jsp/portal/images/x.gif" border=0></a>
						~
						<input name="postdate_modify" id="postdate_modify" class="txt_field" size="12"  maxlength=15 readonly  value=""/>
						<a href="javascript:void(0);"><img src="/Windchill/jsp/portal/images/calendar_icon.gif" border=0 name="postdate_modifyBtn" id="postdate_modifyBtn" ></a>
						<a href="JavaScript:clearText('postdate_modify')"><img src="/Windchill/jsp/portal/images/x.gif" border=0></a>
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('등록자')}
					</td>
					
					<td class="tdwhiteL" colspan="3">
					
						<%-- 
						<input TYPE="hidden" name="creator" id="creator" value="">
						<input type="text" name="creatorName" id="creatorName" value="" class="txt_field" readonly>

						<a href="JavaScript:searchUser('documentForm','single','creator','creatorName','people')">
							<img src="/Windchill/jsp/portal/images/s_search.gif" border=0>
						</a>
						
						<a href="JavaScript:clearText('creator');clearText('creatorName')">
							<img src="/Windchill/jsp/portal/images/x.gif" border=0>
						</a>
						--%>
						
						<jsp:include page="/eSolution/common/userSearchForm.do">
							<jsp:param value="single" name="searchMode"/>
							<jsp:param value="creator" name="hiddenParam"/>
							<jsp:param value="creatorName" name="textParam"/>
							<jsp:param value="people" name="userType"/>
							<jsp:param value="" name="returnFunction"/>
						</jsp:include>
						
					</td>
					<!--  
					<td class="tdblueM">
						${f:getMessage('상태')}
					</td>
					
					<td class="tdwhiteL" >
	                    <select name="state" id="state">
	                    </select>
                    </td>
                    -->
				</tr>
				
			</table>
			
			<div id="SearchDetailProject" style="display: none;" >
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" style="border-left-width: 1px;border-left-style: solid;border-left-color: #e6e6e6;">
					<colgroup>
						<col width='10%'>
						<col width='40%'>
						<col width='10%'>
						<col width='40%'>
					</colgroup>
					
					<tr bgcolor="ffffff" height="35">
					
						<td class="tdblueM">
							${f:getMessage('문서유형')}
						</td>
						
						<td class="tdwhiteL" >
							<select id='documentType' name='documentType' style="width: 95%">
							</select>
						</td>
						
						<td class="tdblueM">
						${f:getMessage('보존기간')}
						</td>
						
						<td class="tdwhiteL">
							<select id='preseration' name='preseration' style="width: 95%">
							</select>
						</td>
						
					</tr>
					
					<tr bgcolor="ffffff" height="35">
						<td class="tdblueM">
							${f:getMessage('프로젝트코드')}
						</td>
						
						<td class="tdwhiteL" >
							<select id='model' name='model' style="width: 95%">
							</select>
						</td>
						
						<td class="tdblueM">
							${f:getMessage('부서')}
						</td>
						
						<td class="tdwhiteL">
							<select id='deptcode' name='deptcode' style="width: 95%">
							</select>
						</td>
					</tr>
					
					<tr bgcolor="ffffff" height="35">
						<td class="tdblueM">
							${f:getMessage('내부 문서번호')}
						</td>
						
						<td class="tdwhiteL">
							<input name="interalnumber" id="interalnumber" class="txt_field" size="85" style="width:90%" maxlength="80" />
						</td>
						
						<td class="tdblueM">
							${f:getMessage('작성자')}
						</td>
						
						<td class="tdwhiteL">
							<input name="writer" id="writer" class="txt_field" size="85" style="width:90%" maxlength="80" />
						</td>
					</tr>
					
					<tr bgcolor="ffffff" height="35">
						<td class="tdblueM">
							${f:getMessage('내용')}
						</td>
						
						<td class="tdwhiteL" colspan="4">
							<textarea name="description" id="description" cols="10" rows="5" class="fm_area" style="width:90%" onchange="textAreaLengthCheckName('description', '4000', '${f:getMessage('문서')}${f:getMessage('설명')}')"></textarea>
						</td>
					</tr>
					
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="4" align="right">
	              <tr>
	                  <td>
	                  	<button type="button" name="" value="" class="btnSearch" title="검색" id="searchBtn" name="searchBtn">
		                  	<span></span>
		                  	${f:getMessage('검색')}
	                  	</button>   
	                  </td>
	                  
	                  <td>
	                 	 <button title="Reset" class="btnCustom" type="reset" id="btnReset">
	                 	 	<span></span>${f:getMessage('초기화')}
	                 	 </button>
	                  </td>
	                  
	                  <td>
	                  	<button type="button" name="" value="" class="btnCustom" title="${f:getMessage('상세검색')}" id="detailBtn" name="detailBtn">
		                  	<span></span>
		                  	<font id="detailText" >${f:getMessage('상세검색')} + </font>
	                  	</button>   
	                  </td>
	                  
	                  <td>
		                  <a href="#">
						  	<img src="/Windchill/jsp/portal/images/icon/fileicon/xls.gif" alt="${f:getMessage('엑셀다운')}" border="0" align="absmiddle" onclick="exportAUIExcel('Document')">
					      </a>
				      </td>
	              </tr>
	          </table>
		</td>
	</tr>
	
	<tr>
		<td>
			<div id="grid_wrap" style="width: 100%; height:400px; margin-top: 10px; border-top: 3px solid #244b9c;">
			</div>
			<div id="grid_paging"
				class="aui-grid-paging-panel my-grid-paging-panel"></div>
		</td>
  	</tr>
	
</table>

</form>

</body>
</html>