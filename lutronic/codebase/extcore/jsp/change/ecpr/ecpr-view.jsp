<%@page import="com.e3ps.change.ecpr.dto.EcprDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="wt.org.WTUser"%>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
<%
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
EcprDTO dto = (EcprDTO) request.getAttribute("dto");
%>
<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				ECPR 상세보기
			</div>
		</td>
		<td class="right">
			<!-- 회수 권한 승인중 && 소유자 || 관리자 -->
			<%
			if(dto.isWithDraw()){
			%>
				<input type="button" value="결재회수" title="결재회수" class="" id="withDrawBtn">
			<%	
			}
			%>
			<input type="button" value="수정" title="수정" class="blue" id="updateBtn">
			<input type="button" value="삭제" title="삭제" class="red" id="deleteBtn">
			<input type="button" value="결재이력" title="결재이력" class="" id="approveBtn">
			<input type="button" value="다운로드이력" title="다운로드이력" class="" id="downloadBtn">
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
			<a href="#tabs-2">관련 객체</a>
		</li>
	</ul>
	<div id="tabs-1">
		<!-- 기본 정보 -->
		<table class="view-table">
			<colgroup>
				<col width="13%">
				<col width="37%">
				<col width="13%">
				<col width="37%">
			</colgroup>
			<tr>
				<th>ECPR 제목</th>
				<td colspan="3"><%=dto.getName()%></td>
			</tr>
			<tr>
				<th>ECPR 번호</th>
				<td><%=dto.getNumber()%></td>
				<th>상태</th>
				<td><%=dto.getState()%></td>
			</tr>
			<tr>
				<th>등록자</th>
				<td colspan="3"><%=dto.getCreator()%></td>
			</tr>
			<tr>
				<th>등록일</th>
				<td><%=dto.getCreatedDate()%></td>
				<th>수정일</th>
				<td><%=dto.getModifiedDate_text()%></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=dto.getWriter_name()%></td>
				<th>작성부서</th>
				<td><%=dto.getCreateDepart_name() == null ? "" : dto.getCreateDepart_name()%></td>
			</tr>
			<tr>
				<th>작성일</th>
				<td><%=dto.getWriteDate()%></td>
				<th>승인일</th>
				<td><%=dto.getApproveDate()%></td>
			</tr>
			<tr>
				<th>제안자</th>
				<td><%=dto.getProposer()%></td>
				<th>변경구분</th>
				<td><%=dto.getChangeCode()%></td>
			</tr>
			<tr>
				<th>제품명</th>
				<td colspan="3"><%=dto.getModel()%></td>
			</tr>
			<tr>
				<th>변경사유</th>
				<td colspan="3"><%=dto.getEoCommentA()%></td>
			</tr>
			<tr>
				<th>변경사항</th>
				<td colspan="3"><%=dto.getEoCommentB()%></td>
			</tr>
			<tr>
				<th>참고사항</th>
				<td colspan="3"><%=dto.getEoCommentC()%></td>
			</tr>
			<tr>
				<th>주 첨부파일</th>
				<td colspan="3">
					<jsp:include page="/extcore/jsp/common/primary-view.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid"/>
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="3">
					<jsp:include page="/extcore/jsp/common/secondary-view.jsp">
						<jsp:param value="<%= dto.getOid() %>" name="oid"/>
					</jsp:include>
				</td>
			</tr>
		</table>
	</div>
	<div id="tabs-2">
		<!-- 관련 객체 -->
		<jsp:include page="/extcore/jsp/change/cr/include/cr-reference-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
</div>
<script type="text/javascript">
	$("#updateBtn").click(function () {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/ecpr/update?oid=" + oid);
		document.location.href = url;
	})

	$("#deleteBtn").click(function () {
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/ecpr/delete?oid=" + oid);
		call(url, null, function(data) {
			alert(data.msg);
			if (data.result) {
				self.close();
			}
		}, "GET");
	})
	
	$("#approveBtn").click(function () {
		const oid = document.querySelector("#oid").value;
		const url = getCallUrl("/groupware/workHistory?oid=" + oid);
		popup(url, 830, 600);
	})
	
	$("#downloadBtn").click(function () {
		const oid = document.querySelector("#oid").value;
		const url = getCallUrl("/common/downloadHistory?oid=" + oid);
		popup(url, 830, 600);
	})
	
	//결재 회수
	$("#withDrawBtn").click(function() {
		const oid = $("#oid").val();
		const url = getCallUrl("/common/withDrawPopup?oid=" + oid);
		_popup(url, 1500, 550, "n");
	})
	
	document.addEventListener("DOMContentLoaded", function() {
		$("#tabs").tabs({
			active : 0,
			activate : function(event, ui) {
				var tabId = ui.newPanel.prop("id");
				switch (tabId) {
				case "tabs-2":
					const isCreated101 = AUIGrid.isCreated(myGridID101); // CR
					if (isCreated101) {
						AUIGrid.resize(myGridID101);
					} else {
						createAUIGrid101(columns101);
					}
					break;
				}
			}
		});
	});

	window.addEventListener("resize", function() {
		AUIGrid.resize(myGridID101);
	});
</script>