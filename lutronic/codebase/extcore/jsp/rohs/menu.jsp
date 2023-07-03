<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"			%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<html>

<script>
<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
	var menu = $("#menu").val();
	
	$("#"+menu).css('background', '#ECECEC');
});

<%----------------------------------------------------------
*                      폴더 선택시 데이터 설정
----------------------------------------------------------%>
function setLocationDocument(foid,loc,isLast){
	$("#locationName").html(loc);
	$("#location").val(loc);
	$("#fid").val(foid);
	$("#islastversion").val(isLast);
	if($("#search").val() == "true") {
		$("#sortValue").val("");
		$("#sortCheck").val("");
		$("#sessionId").val("");
		$("#page").val(1);
		lfn_Search();
	}
}

<%----------------------------------------------------------
*                      페이지 이동
----------------------------------------------------------%>
function gotoMenu(a){
	var url = getURLString("rohs", a, "do");
	document.location = url;
}
function gotoBatchMenu(a){
	var url = getURLString("asmApproval", a, "do") + "?searchType=ROHS";
	document.location = url;
}
</script>

<form name="menuForm" method="get">

<input type="hidden" name="menu" id="menu" value="<c:out value="${menu }" />">

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td align="center" valign="top">
			<table border="0" height="100%"  cellspacing="0" cellpadding="0" width="100%" style="table-layout:auto">
				<tr>
					<td align="left" valign=top height=42>
						<table cellspacing="0" cellpadding="0" border=0 width=100% height=29 class="Subinfo_img_bg">
							<tr>
								<td></td>
								<td>&nbsp;<img src="/Windchill/jsp/portal/img/ars_bt_01.gif" width="11" height="11">&nbsp;<span id ="menuTitle">RoHS${f:getMessage('관리')}</span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="left" valign="top" width=100% style="padding-right:2;padding-left:2">
						<table border="0" cellpadding="0" cellspacing="0" width="100%" class="menu A:link">
							
							<tr id="menu1" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listRohs')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('물질 검색')}
								</td>
							</tr>
							
							<tr id="menu2" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('createRohs')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('물질 등록')}
								</td>
							</tr>
							
							<tr id="menu4" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listRoHSData')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('파일 검색')}
								</td>
							</tr>
							
							<tr id="menu5" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listAUIRoHSPart')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('부품 현황')}
								</td>
							</tr>
							
							<tr id="menu6" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listRoHSProduct')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('제품 현황')}
								</td>
							</tr>
							
							<tr id="menu3" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoBatchMenu('createAsm')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('물질 일괄결재')}
								</td>
							</tr>
							
							<tr id="menu7" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('createPackageRoHS')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('물질 일괄등록')}
								</td>
							</tr>
							
							<tr id="menu8" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('createPackageRoHSLink')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('물질 일괄링크')}
								</td>
							</tr>
							
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

</html>