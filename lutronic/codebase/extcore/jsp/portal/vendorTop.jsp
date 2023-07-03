<%@page import="java.util.Date"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.e3ps.common.service.CommonHelper"%>
<%@page import="wt.fc.QueryResult"%>
<%@page import="wt.fc.PersistenceHelper"%>
<%@page import="wt.query.OrderBy"%>
<%@page import="wt.query.ClassAttribute"%>
<%@page import="wt.query.SearchCondition"%>
<%@page import="wt.org.WTUser"%>
<%@page import="wt.session.SessionHelper"%>
<%@page import="com.e3ps.common.history.LoginHistory"%>
<%@page import="wt.query.QuerySpec"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"			%>
<jsp:useBean id="toDay" class="java.util.Date" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html>
<LINK rel="stylesheet" type="text/css" href="/Windchill/extcore/jsp/css/e3ps.css">
<LINK rel="stylesheet" type="text/css" href="/Windchill/jsp/css/default.css">
<style>
#module_menu {background-color:#444444;width:100%;background-color:#444444;height:50px;}
#module_menu ul { list-style:none; margin:0; padding:0;}
#module_menu li{background-color:#444444; color:#FFFFFF; margin:0 0 0 0; cursor:pointer; padding:0 20px 0 20px;border:0; float:left;font-family:맑은 고딕;font-weight:bold;font-size:14px;vertical-align:middle;height:50px;line-height:50px;}
</style>
<script>
<%
HttpSession session2 = request.getSession();
long createTimeL = session2.getCreationTime();
try{
	QuerySpec qs = new QuerySpec();
	
	int idx = qs.appendClassList(LoginHistory.class, true);
	WTUser ssuser = (WTUser) SessionHelper.manager.getPrincipal();
	String userName = "";

	if(null!=ssuser){
		userName = ssuser.getName();
		//if(userName.equals("Administrator")) userName = "wcadmin";
	}
	
	if(userName != null && userName.trim().length() > 0) {
		if(qs.getConditionCount() > 0)
			qs.appendAnd();
		qs.appendWhere(new SearchCondition(LoginHistory.class, "id", SearchCondition.LIKE, "%" + userName + "%"), new int[] { idx });
	}
	 qs.appendOrderBy(new OrderBy(new ClassAttribute(LoginHistory.class,"thePersistInfo.createStamp"), true), new int[] { idx }); 
	QueryResult qr = PersistenceHelper.manager.find(qs);
	System.out.println(qs);
	System.out.println(qr.size());
	
	if(qr.size() < 1){
		System.out.println("신규이력생성");
		CommonHelper.service.createLoginHistoty();
	}else{
		Object[] objs = (Object[])qr.nextElement();
		LoginHistory loginHistory= (LoginHistory)objs[0];
		Timestamp data = loginHistory.getPersistInfo().getCreateStamp();
		Date createDate = new Date(createTimeL);
		Timestamp ts=new Timestamp(createDate.getTime());
		long diff = ts.getTime() - data.getTime();
		long sec = diff / 1000;
		long min = sec / 60;
		
		if(min<0) min=min*-1;
		if(min>60){
			System.out.println("기존생성");
			CommonHelper.service.createLoginHistoty();
		}
		System.out.println(data+"\t"+createDate+"\tsec ::: "+sec+"\tmin ::: "+min);
	}
}catch(Exception e){
	e.printStackTrace();
}

%>


<%----------------------------------------------------------
*                      페이지 초기 설정
----------------------------------------------------------%>
$(document).ready(function(){
	var module = "${module}";
/*	
	if($("#module").val() == module) {
		$("#"+module).attr('src', "/Windchill/jsp/portal/images/img_menu/" + module + "_1.gif");
	}
*/

	$("#module_menu li").click(function(){
		var title = $(this).attr("title");
		var url = $(this).attr("value");
		goMenu(url,title);
	});
	
	$("#module_menu li").mouseover(function(){
		
		var title = $(this).attr("title");
		
		if(module != title){
			$(this).css("background-color","#317AB2");
			$(this).css("line-height","55px");
		}
	});
	$("#module_menu li").mouseout(function(){
		
		var title = $(this).attr("title");
		
		if(module != title){
			$(this).css("background-color","#444444");
			$(this).css("line-height","50px");
		}
	});
	
	$("#module_menu li[title='" + module + "']").css("background-color","#317AB2");
	$("#module_menu li[title='" + module + "']").css("line-height","55px");
	
	
	<%----------------------------------------------------------
	*                      접속자 이름 설정
	----------------------------------------------------------%>
	window.getUserData = function(){
		var form = $("form[name=portal]").serialize();
		var url	= getURLString("user", "getUserData", "do");
		$.ajax({
			type:"POST",
			url: url,
			data:form,
			dataType:"json",
			async: false,
			cache: false,

			error:function(data){
				var msg = "${f:getMessage('유저 정보 오류')}";
				alert(msg);
			},

			success:function(data){
				$("#userFullName").html(data.name);
			}
		});
	}
	
	<%----------------------------------------------------------
	*                      메뉴 이동
	----------------------------------------------------------%>
	window.goMenu = function (url, module) {
		$("#module").val(module);
		document.location = url;
	}
	
	<%----------------------------------------------------------
	*                      오늘 날짜 설정
	----------------------------------------------------------%>
	window.setToDay = function () {
		
		var toDay = new Date("${toDay}");
		
	 	var locale = "${f:getLocaleString()}";
	 	locale = locale.replace(/_/g,"-");
	 	
	 	var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
	 	options.timeZone = 'UTC';
	 	options.timeZoneName = 'short';
		//alert(locale);
	 	//$("#toDay").html(toDay.toLocaleDateString(locale, options));
	 	if(locale =="ko-KR"){
	 		$("#toDay").html(toDay.toLocaleDateString(locale, options));
	 	}else{
	 		$("#toDay").html(toDay.toDateString());
	 	}
		
	}
	
	<%----------------------------------------------------------
	*                      관리자 정보 설정
	----------------------------------------------------------%>
	window.isAdminTop = function () {
		var url	= getURLString("common", "isAdmin", "do");
		$.ajax({
			type:"POST",
			url: url,
			dataType:"json",
			async: false,
			cache: false,

			error:function(data){
				var msg = "${f:getMessage('검색오류')}";
				alert(msg);
			},

			success:function(data){
				if(data) {
					$("#adminBtn").css('display', '');
				}else {
					$("#adminBtn").css('display', 'none');
				}
			}
		});
	}

	//setAllUserName();
	getUserData();
	setToDay();
	isAdminTop();
	
	$("#adminBtn").click(function(){
		window.open( getURLString("admin", "admin_mainCompany", "do"));
	});
	$("#helpBtn").click(function(){
		var url = getURLString("help", "index", "do");
	    window.open(url,"window","500","300","status=no,scrollbars=no,resizable=yes");
	});
	$("#logoutBtn").click(function() {
		if(window.confirm("LOGOUT ${f:getMessage('하시겠습니까?')}")){
			document.execCommand('ClearAuthenticationCache');
			parent.location.href="/Windchill/login/index.html";
			alert("LOGOUT ${f:getMessage('되었습니다.')}");
		}
	});
});

function setAllUserName() {
	var form = $("form[name=portal]").serialize();
	var url	= getURLString("user", "setAllUserName", "do");
	$.ajax({
		type:"POST",
		url: url,
		data:form,
		dataType:"json",
		async: false,
		cache: false,

		error:function(data){
			var msg = "${f:getMessage('유저 이름 설정 오류')}";
			alert(msg);
		},

		success:function(data){
		}
	});
}

</script>
<form name="portal" id="portal">
<input type="hidden" name="module" id="module" value="<c:out value="${module }"/>">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="100" colspan="3">
	 		<table style="padding:0 0 0 0;margin:0 0 0 0;width:100%;height:85px;vertical-align:top;border-collapse:collapse;" cellspacing="0" cellpadding="0">
	  			<tr>
      			<!-- Home -->
					<td align=center valign=top>
		
						<table  border="0" width=100% cellspacing="0" cellpadding="0" align=center>
							<tr> 
								<td colspan="6" align="right" width=100% style="padding-right:10px;padding-left:15px;" onMouseOver=""  height=76>
									<table border=0 width=100% cellpadding=0 cellspacing=0>
										<tr> 
											<td width=5%>
												<a href="/Windchill/eSolution/groupware/main.do" target="_top">
													<img src="/Windchill/jsp/portal/images/img_menu/topMenu_left.gif"  border="0">
												</a>
											<BR>
											</td>
									
											<td align=right width=80%>
												<B>
													<span id="userFullName"></span>
												</B> ${f:getMessage("님께서 접속하셨습니다.")}
												
												<font color=#757575>
													<span id="toDay"></span>
												</font>
												<BR><BR>
												<button type="button" name="" value="" class="btnCustom" title="관리자" id="adminBtn">
													${f:getMessage("관리자")}
							                  	</button>
							                  	<button type="button" name="" value="" class="btnCustom" title="LOGOUT" id="logoutBtn">
													LOGOUT
							                  	</button>
											</td>
										</tr>
									</table>
								</td>
							</tr>
				        	<tr>
								<td style="padding-left:15px;background-color:#444444">
									<div id="module_menu">
										<ul>
											
											<li title="distribute" value="/Windchill/eSolution/distribute/listDistribute.do" >
												${f:getMessage("배포관리")}
											</li>
											
										</ul>
									</div>
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