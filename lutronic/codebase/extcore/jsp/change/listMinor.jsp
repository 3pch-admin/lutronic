<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>

<script type="text/javascript">
<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function () {
	lfn_DhtmlxGridInit();
	lfn_getStateList('LC_ECO');
	numberCodeList('CHANGETYPE');
	gfn_InitCalendar("predate", "predateBtn");
	gfn_InitCalendar("postdate", "postdateBtn");
	lfn_Search();
})

$(function(){
	<%----------------------------------------------------------
	*                      검색 버튼 클릭시
	----------------------------------------------------------%>
	$("#searchBtn").click(function (){
		lfn_DhtmlxGridInit();
		$("#sortValue").val("");
		$("#sortCheck").val("");
		$("#sessionId").val("");
		$("#page").val(1);
		lfn_Search();
	}),
	<%----------------------------------------------------------
	*                      초기화 버튼
	----------------------------------------------------------%>
	$("#btnReset").click(function() {
		$("#creator").val("");
	})
})
<%----------------------------------------------------------
*                      NumberCode 리스트 가져오기
----------------------------------------------------------%>
function numberCodeList(type) {
	var form = $("form[name=changeRequestForm]").serialize();
	var url	= getURLString("common", "numberCodeList", "do") + "?type="+type;
	$.ajax({
		type:"POST",
		url: url,
		data:form,
		dataType:"json",
		async: false,
		cache: false,
		error:function(data){
			var msg = type + " ${f:getMessage('코드 목록 오류')}";
			alert(msg);
		},

		success:function(data){
			addSelectList(type,data);
		}
	});
}

<%----------------------------------------------------------
*                      selectBodx에 옵션 추가
----------------------------------------------------------%>
function addSelectList(type,data){
	var id = "";
	if (type == "CHANGETYPE"){
		id = "purpose"
	}
	for(var i=0; i<data.length; i++) {
		$("#"+ id).append("<input type='checkbox' name='"+id+"' id='"+id+"' value='" + data[i].code + "'>"+ data[i].name);
	}
}
<%----------------------------------------------------------
*                      데이터 검색
----------------------------------------------------------%>
function  lfn_Search(){
	var form = $("form[name=changeRequestForm]").serialize();
	var url	= getURLString("changeECO", "listECOAction", "do");
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
function lfn_getStateList(lifecycle) {
	var form = $("form[name=changeRequestForm]").serialize();
	var url	= getURLString("WFItem", "lifecycleList", "do") + "?lifecycle="+lifecycle;
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
*                      그리드 초기 설정
----------------------------------------------------------%>
function lfn_DhtmlxGridInit() {
	var COLNAMEARR = {
			 col01 : '${f:getMessage("번호")}'
			,col02 : 'ECO'+'${f:getMessage("품번미변경")}' +' ${f:getMessage("번호")}'
			,col03 : 'ECO'+'${f:getMessage("품번미변경")}' +' ${f:getMessage("제목")}'
			,col04 : 'CHANGETYPE'
			,col05 : '${f:getMessage("상태")}'
			,col06 : '${f:getMessage("등록자")}'
			,col07 : '${f:getMessage("등록일")}'
	}
	
	var sHeader = "";
	sHeader +=       COLNAMEARR.col01;
	sHeader += "," + COLNAMEARR.col02;
	sHeader += "," + COLNAMEARR.col03;
	sHeader += "," + COLNAMEARR.col04;
	sHeader += "," + COLNAMEARR.col05;
	sHeader += "," + COLNAMEARR.col06;
	sHeader += "," + COLNAMEARR.col07;
	
	var sHeaderAlign = new Array();
	sHeaderAlign[0]  = "text-align:center;";
	sHeaderAlign[1]  = "text-align:center;";
	sHeaderAlign[2]  = "text-align:center;";
	sHeaderAlign[3]  = "text-align:center;";
	sHeaderAlign[4]  = "text-align:center;";
	sHeaderAlign[5]  = "text-align:center;";
	sHeaderAlign[6]  = "text-align:center;";

	var sWidth = "";
	sWidth += "3";
	sWidth += ",20";
	sWidth += ",32";
	sWidth += ",15";
	sWidth += ",10";
	sWidth += ",10";
	sWidth += ",10";
	
	var sColAlign = "";
	sColAlign += "center";
	sColAlign += ",center";
	sColAlign += ",left";
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

	var sColSorting = "";
	sColSorting += "na";
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
	
	documentListGrid.attachEvent("onHeaderClick",function(rowId,cellIndex){
		
		var sortValue = "";
		var header = "";
		
		if(rowId == 1) {
			sortValue = "eoNumber";
			header = COLNAMEARR.col02;
		}else if(rowId == 2 ){
			sortValue = "eoName";
			header = COLNAMEARR.col03;
		}else if(rowId == 5 ) {
			sortValue = "creator.key.id";
			header = COLNAMEARR.col06;
		}else if(rowId == 6) {
			sortValue = "thePersistInfo.createStamp";
			header = COLNAMEARR.col07;
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
			documentListGrid.setColLabel(5, COLNAMEARR.col06);
			documentListGrid.setColLabel(6, COLNAMEARR.col07);
			documentListGrid.setColLabel(rowId, header);
			
			$("#sortValue").val(sortValue);
			$("#sessionId").val("");
			$("#page").val(1);
			lfn_Search();
		}
	});
	
	documentListGrid.init();
}

<%----------------------------------------------------------
*                      그리드 다시 그리기
----------------------------------------------------------%>
function redrawGrid(){
	documentListGrid.clearAll();
	documentListGrid.loadXMLString($("#xmlString").val());
}

function onExcelDown() {
	$("#changeRequestForm").attr("method", "post");
	$("#changeRequestForm").attr("action", getURLString("excelDown", "MCOExcelDown", "do")).submit();
}

</script>
<body>
<form name="changeRequestForm" id="changeRequestForm" method=post style="padding:0px;margin:0px">
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

<input type="hidden" name="lifecycle" id="lifecycle" value="LC_ECO">

<input type="hidden" name="eoType" id="eoType" value="MCO">


	<table border="0" height="100%"  cellspacing="0" cellpadding="0" width="100%" style="table-layout:auto">
			<tr>
				<td align="left" valign=top height=42>
					<table cellspacing="0" cellpadding="0" border=0 width=100% height=29 class="Subinfo_img_bg">
						<tr>
							<td></td>
							<td>
								&nbsp;
								<img src='/Windchill/jsp/portal/images/base_design/Sub_Right_ico.gif' width='10' height='9' />
								&nbsp; ECO ${f:getMessage("관리")} > ECO (${f:getMessage("품번미변경")}) ${f:getMessage("검색")}
							</td>
						</tr>
					</table>
				</td>
			</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="3" >
		<tr  align=center>
			<td valign="top" style="padding:0px 0px 0px 0px">
	
				<table width="100%" border="0" cellpadding="1" cellspacing="0" class="tablehead" align=center>
					<tr><td height=1 width=100%></td></tr>
				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align=center>
				<col width='10%'><col width='40%'><col width='10%'><col width='40%'>
					<tr>
						<td class="tdblueM">ECO (${f:getMessage("품번미변경")}) ${f:getMessage("제목")}</td>
						<td class="tdwhiteL">
							<input name="name" class="txt_field" size="30" style="width:90%" value=""/>
						</td>
						<td class="tdblueM">ECO (${f:getMessage("품번미변경")})${f:getMessage("번호")}</td>
						<td class="tdwhiteL">
							<input name="number" class="txt_field" size="30" style="width:90%" value=""/>
						</td>
					</tr>
					<tr>
						<td class="tdblueM">${f:getMessage("등록자")}</td>
		                <td class="tdwhiteL">
		                   	<input type="hidden" id="creator" name="creator" value="" />
							<input type="text" class="txt_field" id="creatorName" name="creatorName" size="30" style="width:30%" value="" readOnly/>
							
							<a href="JavaScript:searchUser('changeRequestForm','single','creator','creatorName','people')">
								<img src="/Windchill/jsp/portal/images/s_search.gif" border="0" />
							</a>
							
							<a href="JavaScript:clearText('creator');clearText('creatorName');">
								<img src="/Windchill/jsp/portal/images/x.gif" border="0" />
							</a>
						</td>
						<td class="tdblueM">ECN ${f:getMessage("담당자")}</td>
		                <td class="tdwhiteL">
		                   	<input type="hidden" id="worker" name="worker" value="" />
							<input type="text" class="txt_field" id="tempworker" name="tempworker" size="30" style="width:30%" value="" readOnly/>
							
							<a href="JavaScript:searchUser('changeRequestForm','single','worker','tempworker','people')">
								<img src="/Windchill/jsp/portal/images/s_search.gif" border="0" />
							</a>
							
							<a href="JavaScript:clearText('worker');clearText('tempworker');">
								<img src="/Windchill/jsp/portal/images/x.gif" border="0" />
							</a>
						</td>
					</tr>
					<tr>
						<td class="tdblueM">
							${f:getMessage("등록일자")}
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
	                    	${f:getMessage("상태")}
	                    </td>
	                    <td class="tdwhiteL" >
		                    <select name="state" id="state">
	 							<option value=''>${f:getMessage("선택")}</option>
							</select>
	                    </td>
					</tr>
					<tr bgcolor="ffffff" height=35>
					<td class="tdblueM">${f:getMessage("변경유형")}</td>
					<td class="tdwhiteL" colspan="3">
					    <div style="width:99%;overflow-x:hidden;overflow-y:auto;border:1px;border-style:solid;border-color:#5F9EA0;padding:0px;margin:1px 1px 5px;">
							<table width="100%" cellspacing="0" cellpadding="1" border="0" id="ecrTable" align="center">
								<tbody>
									<tr>
									<td class="tdwhiteL">
										<div id='purpose'></div>	
									</td>
									</tr>
	                   	 		</tbody>
	                   		 </table>
                   		 </div>
					</td>
				</tr>
				</table>
			</td>
		</tr>
		<tr height=35>
		<td align="right">
			<table border="0" cellpadding="0" cellspacing="4" align="right">
                <tr>
				    <td>
	                  	<button type="button" class="btnSearch" title="${f:getMessage('검색')}" id="searchBtn" name="searchBtn">
		                  	<span></span>
		                  	${f:getMessage("검색")}
	                  	</button>   
	                  </td>
	                  
	                  <td>
	                 	 <button title="Reset" class="btnCustom" type="reset" id="btnReset">${f:getMessage("초기화")}</button>
	                  </td>
	                  <td>
		                  <a href="javascript:onExcelDown();">
						  	<img src="/Windchill/jsp/portal/images/icon/fileicon/xls.gif" alt="${f:getMessage('엑셀다운')}" border="0" align="middle">
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
			<table width="100%" border="0" cellpadding="2" cellspacing="1" align="center" align="center">
				<tr height="35">
					<td>
						<div id="pagingBox"></div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
</form>
</body>
</html>