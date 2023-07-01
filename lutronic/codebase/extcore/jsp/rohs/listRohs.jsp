<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<script type="text/javascript">
<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
	/* var now = new Date();	// 현재 날짜 및 시간
	var year = now.getFullYear();	// 연도
	var yearDate = year + "-01-01";
	
	$('#predate').val(yearDate); */
	lfn_DhtmlxGridInit();
	gfn_InitCalendar("predate", "predateBtn");
	gfn_InitCalendar("postdate", "postdateBtn");
	gfn_InitCalendar("predate_modify", "predate_modifyBtn");
	gfn_InitCalendar("postdate_modify", "postdate_modifyBtn");
	lfn_getStateList();
	
	numberCodeList('manufacture', '');

	numberCodeList('model', '');
	numberCodeList('deptcode', '');
	numberCodeList('preseration', '');
	documentType('GENERAL', '');
	
	lfn_Search();
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
	var data = common_numberCodeList(id.toUpperCase(), '',false);
	
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
			,col02 : '${f:getMessage('물질')}${f:getMessage('번호')}'
			,col03 : '${f:getMessage('협력업체')}'
			,col04 : '${f:getMessage('물질명')}'
			,col05 : '${f:getMessage('Rev.')}'
			,col06 : '${f:getMessage('상태')}'
			,col07 : '${f:getMessage('등록자')}'
			,col08 : '${f:getMessage('등록일')}'
			,col09 : '${f:getMessage('수정일')}'
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

	var sWidth = "";
	sWidth += "6";
	sWidth += ",13";
	sWidth += ",10";
	sWidth += ",25";
	sWidth += ",6";
	sWidth += ",10";
	sWidth += ",10";
	sWidth += ",10";
	sWidth += ",10";
	
	var sColAlign = "";
	sColAlign += "center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",left";
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
		}else if(rowId == 2 ){
			sortValue = "manufacture";
			header = COLNAMEARR.col03;
		}else if(rowId == 3 ){
			sortValue = "master>name";
			header = COLNAMEARR.col04;
		}else if(rowId == 6 ) {
			sortValue = "iterationInfo.creator.key.id";
			header = COLNAMEARR.col07;
		}else if(rowId == 7) {
			sortValue = "thePersistInfo.createStamp";
			header = COLNAMEARR.col08;
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
			documentListGrid.setColLabel(2, COLNAMEARR.col03);
			documentListGrid.setColLabel(6, COLNAMEARR.col07);
			documentListGrid.setColLabel(7, COLNAMEARR.col08);
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
		resetSearch();
	})
	<%----------------------------------------------------------
	*                      초기화 버튼 클릭시
	----------------------------------------------------------%>
	$("#btnReset").click(function() {
		$("#creator").val("");
		$("#fid").val("");
		$("#location").val("/Default/RoHS");
		$("#locationName").html("/Default/RoHS");
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
	lfn_DhtmlxGridInit();
	$("#sortValue").val("");
	$("#sortCheck").val("");
	$("#sessionId").val("");
	$("#page").val(1);
	lfn_Search();
}

<%----------------------------------------------------------
*                      데이터 검색 AJAX
----------------------------------------------------------%>
function  lfn_Search(){
	var form = $("form[name=documentForm]").serialize();
	var url	= getURLString("rohs", "listRohsAction", "do");
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
			
			var vArr = new Array();
			vArr[0] = data.rows    ;
			vArr[1] = data.formPage   ;
			vArr[2] = data.totalCount ;
			vArr[3] = data.totalPage  ;
			vArr[4] = data.currentPage;
			vArr[5] = data.startPage  ;
			vArr[6] = data.endPage    ;
			vArr[7] = data.sessionId  ;
			
			documentListGrid.clearAll();
			documentListGrid.loadXMLString(data.xmlString);
			
			$("#xmlString").val(data.xmlString);
			
			gfn_SetPaging(vArr,"pagingBox");
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
	documentListGrid.clearAll();
	documentListGrid.loadXMLString($("#xmlString").val());
}

function onExcelDown() {
	$("#documentForm").attr("method", "post");
	$("#documentForm").attr("action", getURLString("excelDown", "rohsExcelDown", "do")).submit();
}
</script>

<body>

<form name="documentForm" id="documentForm" >

<!--  Paging 처리를 위한 Hidden 변수 -->
<input type="hidden" name="page"         id="page"          value="1"/>						<!-- page No -->
<input type="hidden" name="formPage"     id="formPage"      value="10"/>					<!-- 한 화면에 나타나는 페이지수 -->
<input type="hidden" name="rows"     	 id="rows"    		value="10"/>					<!-- 한 화면에 나타나는 데이터 수 -->
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
<input type="hidden" name="location" id="location" value="/Default/ROHS">
<input type="hidden" name="searchType" id="searchType" value="document">

<table border="0" height="100%"  cellspacing="0" cellpadding="0" width="100%" style="table-layout:auto">
		<tr>
			<td align="left" valign=top height=42>
				<table cellspacing="0" cellpadding="0" border=0 width=100% height=29 class="Subinfo_img_bg">
					<tr>
						<td></td>
						<td>
							<img src='/Windchill/jsp/portal/images/base_design/Sub_Right_ico.gif' width='10' height='9' />
							RoHS
							${f:getMessage('관리')}
							>
							${f:getMessage('물질')}
							${f:getMessage('검색')}
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
					<td class="tdblueM">${f:getMessage('물질명')}</td>
					<td class="tdwhiteL" >
						<input name="rohsName" class="txt_field" size="30" style="width:90%" value=""/>
					</td>
					<td class="tdblueM">${f:getMessage('물질번호')}</td>
					<td class="tdwhiteL">
						<input name="rohsNumber" class="txt_field" size="30" style="width:90%" value=""/>
					</td>
					
				</tr>
				<tr bgcolor="ffffff" height="35">
					
					<td class="tdblueM">${f:getMessage('협력업체')}</td>
					<td class="tdwhiteL">
						<select id='manufacture' name='manufacture' style="width: 95%"> 
						</select>
					</td>
					<td class="tdblueM">${f:getMessage('설명')}</td>
					<td class="tdwhiteL">
						<input name="description" class="txt_field" size="30" style="width:90%" value=""/>
						
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
						<input name="predate_modify" id="predate_modify" class="txt_field" size="12"  maxlength=15 readonly  value=""/>
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
					
					<td class="tdwhiteL">
					
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
					
					<td class="tdblueM">
						${f:getMessage('상태')}
					</td>
					
					<td class="tdwhiteL" >
	                    <select name="state" id="state">
	                    </select>
                    </td>
				</tr>
			</table>
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
		                  <a href="javascript:onExcelDown();">
						  	<img src="/Windchill/jsp/portal/images/icon/fileicon/xls.gif" alt="${f:getMessage('엑셀다운')}" border="0" align="absmiddle">
					      </a>
				      </td>
	              </tr>
	          </table>
		</td>
	</tr>
	
	<tr>
		<td>
			<div id="listGridBox" style="width:100%;" ></div>
		</td>
	</tr>
	
	<tr>
		<td>
			<div id="pagingBox"></div>
		</td>
	</tr>
	
</table>

</form>

</body>
</html>