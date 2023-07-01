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
*                      페이지 이동
----------------------------------------------------------%>
function gotoMenu(a){
	var url = getURLString("development", a, "do");
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
								<td>
									<img src="/Windchill/jsp/portal/img/ars_bt_01.gif" width="11" height="11">
									<span id ="menuTitle">
										${f:getMessage('개발업무')}
										${f:getMessage('관리')}
									</span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="left" valign="top" width=100% style="padding-right:2;padding-left:2">
						<table border="0" cellpadding="0" cellspacing="0" width="100%" class="menu A:link">
							
							<tr id="menu1" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listDevelopment')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('개발업무')}
									${f:getMessage('검색')}
								</td>
							</tr>

							<tr id="menu2" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('createDevelopment')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('개발업무')}
									${f:getMessage('등록')}
								</td>
							</tr>
							
							<tr id="menu3" height="20" style="padding-left:10;" bgcolor="white" >
								<td width="180" class=menu_1  STYLE="cursor:pointer" onclick="javascript:gotoMenu('listMyDevelopment')">
									<img  src="/Windchill/jsp/portal/images/icon/arrow_02.gif" border="0" hspace="5">
									${f:getMessage('나의')}
									${f:getMessage('개발업무')}
								</td>
							</tr>
							
							<tr>
								<td><hr></td>
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