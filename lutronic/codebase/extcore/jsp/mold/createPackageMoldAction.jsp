<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>

<script>
<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
	lfn_DhtmlxGridInit();
})
<%----------------------------------------------------------
*                      그리드 초기 설정
----------------------------------------------------------%>
function lfn_DhtmlxGridInit(){
	var COLNAMEARR = {
			 col01 : 'NO'
			,col02 : '${f:getMessage('문서명')}'
			,col03 : '${f:getMessage('문서종류')}'
			,col04 : '${f:getMessage('문서코드')}'
			,col05 : '${f:getMessage('프로젝트명')}'
			,col06 : '${f:getMessage('프로젝트코드')}'
			,col07 : '${f:getMessage('내부 문서번호')}'
			,col08 : '${f:getMessage('부서명')}'
			,col09 : '${f:getMessage('부서 코드')}'
			,col10 : '${f:getMessage('보존기간')}'
			,col11 : '${f:getMessage('보존기간코드')}'
			,col12 : '${f:getMessage('문서분류')}'
			,col13 : '${f:getMessage('파일명')}'
			,col14 : '${f:getMessage('부품번호')}'
			,col15 : '${f:getMessage('성공여부')}'
			,col16 : '${f:getMessage('에러내용')}'
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
	sHeader += "," + COLNAMEARR.col13;
	sHeader += "," + COLNAMEARR.col14;
	sHeader += "," + COLNAMEARR.col15;
	sHeader += "," + COLNAMEARR.col16;
	
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
	sHeaderAlign[12]  = "text-align:center;";
	sHeaderAlign[13]  = "text-align:center;";
	sHeaderAlign[14]  = "text-align:center;";
	sHeaderAlign[15]  = "text-align:center;";

	var sWidth = "";
	sWidth += "2";
	sWidth += ",8";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",8";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",3";
	sWidth += ",3";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",5";
	sWidth += ",*";
	
	var sColAlign = "";
	sColAlign += "center";
	sColAlign += ",left";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",center";
	sColAlign += ",left";
	
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
	
	documentListGrid.init();
	
	documentListGrid.clearAll();
	var xml = "<c:out value='${xmlString }' escapeXml='false'/>";
	documentListGrid.loadXMLString(xml);
}

<%----------------------------------------------------------
*                      그리드 다시 그리기
----------------------------------------------------------%>
function redrawGrid(){
	documentListGrid.clearAll();
	documentListGrid.loadXMLString($("#xmlString").val());
}

</script>

<body>

<form name="createPackageDocumentAction" id="createPackageDocumentAction">

<!-- 서브 메뉴 닫을때 dhtmlx를 다시 그리기 위한 변수 -->
<input type="hidden" name="xmlString" id="xmlString" value="<c:out value='${xmlString }'/>" />

<!-- 폴더 선택시 검색 function을 호출하기 위한 변수 -->
<input type="hidden" name="search" id="search" value="true" />

<div id="listGridBox" style="width:100%;" ></div>

</form>

</body>
</html>