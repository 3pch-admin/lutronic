<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<script type="text/javascript">
<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
});

<%----------------------------------------------------------
*                      그리드 초기 설정
----------------------------------------------------------%>
function lfn_DhtmlxGridInit() {
	
	var COLNAMEARR = {
			 col01 : 'NO'
			,col02 : '${f:getMessage('Level')}'
			,col03 : '${f:getMessage('부품 코드')}'
			,col04 : '${f:getMessage('부품 명')}'
			//,col04 : '${f:getMessage('등록자')}'
			//,col05 : '${f:getMessage('등록일')}'
			,col06 : '${f:getMessage('상태')}'
			,col07 : 'RoHs${f:getMessage('상태')}'
			,col08 : '${f:getMessage('물질명')}'
			,col09 : '${f:getMessage('물질상태')}'
			,col10 : '${f:getMessage('파일명')}'
			,col11 : '${f:getMessage('파일구분')}'
	}
	
	var sHeader = "";
	sHeader +=       COLNAMEARR.col01;
	sHeader += "," + COLNAMEARR.col02;
	sHeader += "," + COLNAMEARR.col03;
	sHeader += "," + COLNAMEARR.col04;
	//sHeader += "," + COLNAMEARR.col05;
	sHeader += "," + COLNAMEARR.col06;
	sHeader += "," + COLNAMEARR.col07;
	sHeader += "," + COLNAMEARR.col08;
	sHeader += "," + COLNAMEARR.col09;
	sHeader += "," + COLNAMEARR.col10;
	sHeader += "," + COLNAMEARR.col11;
	
	var sHeaderAlign = new Array();
	sHeaderAlign[0]  = "text-align:center;";
	sHeaderAlign[1]  = "text-align:center;";
	sHeaderAlign[2]  = "text-align:center;";
	sHeaderAlign[3]  = "text-align:center;";
	//sHeaderAlign[4]  = "text-align:center;";
	sHeaderAlign[5]  = "text-align:center;";
	sHeaderAlign[6]  = "text-align:center;";
	sHeaderAlign[7]  = "text-align:center;";
	sHeaderAlign[8]  = "text-align:center;";
	sHeaderAlign[9]  = "text-align:center;";
	sHeaderAlign[10]  = "text-align:center;";

	var sWidth = "";
	sWidth += "3";
	sWidth += ",3";
	sWidth += ",10";
	sWidth += ",25";
	//sWidth += ",10";
	sWidth += ",5";
	sWidth += ",5"; //ROHS 상태
	sWidth += ",15";
	sWidth += ",5";
	sWidth += ",20";
	sWidth += ",9";
	
	var sColAlign = "";
	sColAlign += "center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",left";
	//sColAlign += ",center";
	//sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center"; //ROHS 상태
	sColAlign += ",left";
	sColAlign += ",left";
	sColAlign += ",center";
	sColAlign += ",center";
	
	var sColType = "";
	sColType += "ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	//sColType += ",ro";
	//sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro"; //ROHS 상태
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";
	sColType += ",ro";

	var sColSorting = "";
	sColSorting += "na";
	sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";
	//sColSorting += ",na";
	//sColSorting += ",na";
	sColSorting += ",na";
	sColSorting += ",na";//ROHS 상태
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
		/*
		var sortValue = "";
		var header = "";
		
		if(rowId == 1) {
			sortValue = "master>number";
			header = COLNAMEARR.col02;
		}else if(rowId == 2 ){
			sortValue = "master>name";
			header = COLNAMEARR.col03;
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
		*/
	});
	
	documentListGrid.init();
}

$(function(){
	<%----------------------------------------------------------
	*                      검색 버튼 클릭시
	----------------------------------------------------------%>
	$("#searchBtn").click(function (){
		
		if($('#partOid').val() == "") {
			alert("${f:getMessage('부품')}${f:getMessage('을(를) 선택하세요.')}");
			return;
		}
		
		lfn_DhtmlxGridInit();
		$("#sortValue").val("");
		$("#sortCheck").val("");
		$("#sessionId").val("");
		$("#page").val(1);
		lfn_Search();
	}),
	<%----------------------------------------------------------
	*                      초기화 버튼 클릭시
	----------------------------------------------------------%>
	$("#btnReset").click(function() {
	})
	$('#searchPart').click(function() {
		var url = getURLString("part", "selectPartPopup", "do") + "?mode=single";
		openOtherName(url,"window","1180","600","status=no,scrollbars=yes,resizable=yes");
	})
})

<%----------------------------------------------------------
*                      선택 품목 데이터 추가
----------------------------------------------------------%>
function addPart(obj,isHref) {
	$('#partName').val(obj[0][1]);
	$('#partOid').val(obj[0][0]);
}

<%----------------------------------------------------------
*                      데이터 검색 AJAX
----------------------------------------------------------%>
function  lfn_Search(){
	/*
	var url	= getURLString("rohs", "listRoHSPartAction", "do") + "?partOid="+$('#partOid').val();
	documentListGrid.clearAndLoad(url, null, "json");
	*/
	var form = $("form[name=listRoHSPart]").serialize();
	var url	= getURLString("rohs", "listRoHSPartAction", "do");
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
			documentListGrid.clearAll();
			documentListGrid.loadXMLString(data.xmlString);
			
			$("#xmlString").val(data.xmlString);
			
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
*                      그리드 다시 그리기
----------------------------------------------------------%>
function redrawGrid(){
	lfn_Search();
}

function onExcelDown() {
	$("#documentForm").attr("method", "post");
	$("#documentForm").attr("action", getURLString("excelDown", "documentExcelDown", "do")).submit();
}

</script>

<body>

<form name="listRoHSPart" id="listRoHSPart" >

<!-- 서브 메뉴 닫을때 dhtmlx를 다시 그리기 위한 변수 -->
<input type="hidden" name="xmlString" id="xmlString" value="" />

<!-- 폴더 선택시 검색 function을 호출하기 위한 변수 -->
<input type="hidden" name="search" id="search" value="true" />

<!-- 정렬을 사용할때 사용하는 변수 -->
<input type="hidden" name="sortValue" id="sortValue" />
<input type="hidden" name="sortCheck" id="sortCheck" />

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
							${f:getMessage('부품현황')} 
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
				
					<td class="tdblueM">
						${f:getMessage('부품')}
					</td>
					<td class="tdwhiteL">
						<input type='hidden' name='partOid' id='partOid' />
						<input type='text' name='partName' id='partName' readonly="readonly" />
						
						<img src="/Windchill/jsp/portal/images/s_search.gif" border=0 id='searchPart' style="cursor: pointer;">
			           	
			           	<a href="JavaScript:clearText('partOid');clearText('partName')">
							<img src="/Windchill/jsp/portal/images/x.gif" border=0>
						</a>
						
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
	                 	 	<span></span>
	                 	 	${f:getMessage('초기화')}
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
	
</table>

</form>

</body>
</html>