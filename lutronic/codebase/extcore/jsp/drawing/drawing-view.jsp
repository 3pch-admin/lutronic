<%@page import="com.e3ps.drawing.beans.EpmData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="wt.org.WTUser"%>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
<%
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
// WTUser sessionUser = (WTUser) request.getAttribute("sessionUser");
EpmData dto = (EpmData) request.getAttribute("dto");
%>
<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				도면 상세보기
			</div>
		</td>
		<td class="right">
			<%
			if(dto.isNameSyschronization){
			%>
				<input type="button" value="Name 동기화" title="Name 동기화" class="" id="updateName">
			<%	
			}
			%>
			<%
			if(dto.isUpdate){
			%>
				<input type="button" value="수정" title="수정" class="blue" id="updateBtn">
				<input type="button" value="삭제" title="삭제" class="red" id="deleteBtn">
			<%	
			}
			%>
			<%
			if(dto.isLatest){
			%>
				<input type="button" value="최신버전" title="최신버전" class="" id="latestBtn">
			<%	
			}
			%>
<!-- 			<input type="button" value="버전이력" title="버전이력" class="" id="versionBtn"> -->
<!-- 			<input type="button" value="다운로드이력" title="다운로드이력" class="" id="downloadBtn"> -->
			<input type="button" value="결재이력" title="결재이력" class="" id="approveBtn">
			<input type="button" value="닫기" title="닫기" class="gray" id="closeBtn" onclick="self.close();">
		</td>
	</tr>
</table>

<div id="tabs">
	<ul>
		<li>
			<a href="#tabs-1">기본 정보</a>
		</li>
		<li>
			<a href="#tabs-2">참조</a>
		</li>
		<li>
			<a href="#tabs-3">이력 관리</a>
		</li>
		<li>
			<a href="#tabs-5">관련 개발업무</a>
		</li>
	</ul>
	<div id="tabs-1">
		<!-- 기본 정보 -->
		<table class="view-table">
			<colgroup>
				<col width="150">
				<col width="*">
				<col width="150">
				<col width="*">
			</colgroup>
			<tr>
				<th>도면번호</th>
				<td colspan="3"><%=dto.getNumber()%></td>
			</tr>
			<tr>
				<th>도면명</th>
				<td><%=dto.getName()%></td>
				<th>도면분류</th>
				<td><%=dto.getLocation()%></td>
			</tr>
			<tr>
				<th>상태</th>
				<td><%=dto.getState()%></td>
				<th>Rev.</th>
				<td></td>
			</tr>
			<tr>
				<th>등록자</th>
				<td><%=dto.getCreator()%></td>
				<th>수정자</th>
				<td><%=dto.getModifier()%></td>
			</tr>
			<tr>
				<th>등록일</th>
				<td><%=dto.getCreateDate()%></td>
				<th>수정일</th>
				<td><%=dto.getModifyDate()%></td>
			</tr>
			<tr>
				<th>도면구분</th>
				<td><%=dto.getCadType()%></td>
				<th>도면파일</th>
				<td><%=dto.getCadName()%></td>
			</tr>
			<tr>
				<th>주 부품</th>
				<td><%=dto.getpNum()%></td>
				<th>ApplicationType</th>
				<td><%=dto.getApplicationType()%></td>
			</tr>
			<tr>
				<th>dxf</th>
				<td colspan="3"></td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="3">
					<jsp:include page="/extcore/jsp/common/content/include_secondaryFileView.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid"/>
					</jsp:include>
				</td>
			</tr>
		</table>
	</div>
	<div id="tabs-2">
		<!-- 참조 -->
		<jsp:include page="/extcore/jsp/drawing/include_viewReference.jsp">
			<jsp:param value="<%=dto.getOid() %>" name="oid" />
			<jsp:param value="drawing"  name="moduleType"/>
		</jsp:include>
	</div>

	<div id="tabs-3">
		<!-- 이력관리 -->
		<jsp:include page="/extcore/jsp/drawing/drawing-record-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
	
	
	<div id="tabs-5">
		<!-- 관련 개발업무 -->
		<jsp:include page="/extcore/jsp/development/include_viewDevelopment.jsp">
			<jsp:param value="<%=dto.getOid() %>" name="oid" />
			<jsp:param value="drawing" name="moduleType"/>
		</jsp:include>
	</div>
</div>

<script type="text/javascript">
	//수정
	$("#updateBtn").click(function () {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/doc/update?oid=" + oid + "&mode=" + mode);
		openLayer();
		document.location.href = url;
	})
	
	//삭제
	$("#deleteBtn").click(function () {
	
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
	
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/drawing/delete");
		const params = new Object();
		params.oid = oid;
		call(url, params, function(data) {
			alert(data.msg);
			if (data.result) {
				if(parent.opener.$("#sessionId").val() == "undefined" || parent.opener.$("#sessionId").val() == null){
					parent.opener.location.reload();
				}else {
					parent.opener.$("#sessionId").val("");
					parent.opener.lfn_Search();
				}
				window.close();
			}
		});
	})
			
	//개정
	$("#reviseBtn").click(function () {
		var url	= getURLString("doc", "reviseDocumentPopup", "do") + "?oid="+$("#oid").val()+"&module=rohs";
		openOtherName(url,"reviseDocumentPopup","350","200","status=no,scrollbars=yes,resizable=yes");
	})
	
	//버전이력
	$("#versionBtn").click(function () {
		const oid = document.querySelector("#oid").value;
		const url = getCallUrl("/common/versionHistory?oid=" + oid + "&distribute=true");
		popup(url, 830, 600);
	})
	
	//다운로드 이력
	$("#downloadBtn").click(function () {
		const oid = document.querySelector("#oid").value;
		const url = getCallUrl("/common/downloadHistory?oid=" + oid);
		popup(url, 830, 600);
	})
	
	//결재 이력
	$("#approveBtn").click(function () {
		const oid = document.querySelector("#oid").value;
		const url = getCallUrl("/groupware/workHistory?oid=" + oid);
		popup(url, 830, 600);
	})
	
	//최신버전
	$("#lastestBtn").click(function() {
		var oid = this.value;
		openView(oid);
	})
	
	//copy
	$('#copyRohs').click(function() {
		var url = getURLString("rohs", "copyRohs", "do") + '?oid='+$('#oid').val();
		openOtherName(url,"copyRohs","830","300","status=no,scrollbars=yes,resizable=yes");
	})
	
	//결재 회수
	$("#withDrawBtn").click(function() {
		var url	= getURLString("common", "withDrawPopup", "do") + "?oid="+$("#oid").val();
		openOtherName(url,"withDrawBtn","400","220","status=no,scrollbars=yes,resizable=yes");
	})
	
	//일괄 다운로드
	$("#batchSecondaryDown").click(function() {
		var form = $("form[name=rohsViewForm]").serialize();
		var url	= getURLString("common", "batchSecondaryDown", "do");
		$.ajax({
			type:"POST",
			url: url,
			data:form,
			dataType:"json",
			async: true,
			cache: false,
			
			error:function(data){
				var msg = "데이터 검색오류";
				alert(msg);
			},
			
			success:function(data){
				console.log(data.message);
				if(data.result) {
					location.href = '/Windchill/jsp/common/content/FileDownload.jsp?fileName='+data.message+'&originFileName='+data.message;
				}else {
					alert(data.message);
				}
			}
			,beforeSend: function() {
				gfn_StartShowProcessing();
	        }
			,complete: function() {
				gfn_EndShowProcessing();
	        }
		});
		
	})
	
	document.addEventListener("DOMContentLoaded", function() {
		$("#tabs").tabs({
			active : 0,
			activate : function(event, ui) {
				var tabId = ui.newPanel.prop("id");
				switch (tabId) {
				case "tabs-2":
					const isCreated1 = AUIGrid.isCreated(refGridID);
					if (isCreated1) {
						AUIGrid.resize(refGridID);
					} else {
						createAUIGrid2(columnRef);
					}
					const isCreated2 = AUIGrid.isCreated(refbyGridID);
					if (isCreated2) {
						AUIGrid.resize(refbyGridID);
					} else {
						createAUIGrid3(columnRefby);
					}
					
					const isCreated3 = AUIGrid.isCreated(partGridID);
					if (isCreated3) {
						AUIGrid.resize(partGridID);
					} else {
						createAUIGrid1(columnPart);
					}
					break;
				case "tabs-3":
					
					const isCreated50 = AUIGrid.isCreated(myGridID50); // 버전이력
					if (isCreated50) {
						AUIGrid.resize(myGridID50);
					} else {
						createAUIGrid50(columns50);
					}
					const isCreated51 = AUIGrid.isCreated(myGridID51); // 다운로드이력
					if (isCreated51) {
						AUIGrid.resize(myGridID51);
					} else {
						createAUIGrid51(columns51);
					}
					
					break;
				case "tabs-5":
					const isCreated4 = AUIGrid.isCreated(devGridID);
					if (isCreated4) {
						AUIGrid.resize(devGridID);
					} else {
						createAUIGrid4(columnDev);
					}
					break;
				}
			}
		});
		createAUIGrid2(columnRef);
		AUIGrid.resize(refGridID);
		createAUIGrid3(columnRefby);
		AUIGrid.resize(refbyGridID);
		createAUIGrid1(columnPart);
		AUIGrid.resize(partGridID);
		createAUIGrid4(columnDev);
		AUIGrid.resize(devGridID);
	});

	window.addEventListener("resize", function() {
		AUIGrid.resize(refGridID);
		AUIGrid.resize(refbyGridID);
		AUIGrid.resize(partGridID);
		AUIGrid.resize(devGridID);
	});
</script>
