<%@page import="java.util.Map"%>
<%@page import="com.e3ps.change.eco.dto.EcoDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
EcoDTO dto = (EcoDTO) request.getAttribute("dto");
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
%>

<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				ECO 상세보기
			</div>
		</td>
		<td class="right">
			<%
			if (isAdmin || dto.isModify()) {
			%>
			<input type="button" value="수정" title="수정" class="blue" onclick="modify();">
			<input type="button" value="삭제" title="삭제" class="red" onclick="_delete();">
			<%
			}
			%>
			<input type="button" value="닫기" title="닫기" class="gray" onclick="self.close();">
		</td>
	</tr>
</table>

<div id="tabs">
	<ul>
		<li>
			<a href="#tabs-1">기본 정보</a>
		</li>
		<li>
			<a href="#tabs-2">산출물</a>
		</li>
		<li>
			<a href="#tabs-3">이력 관리</a>
		</li>
	</ul>
	<div id="tabs-1">
		<!-- 기본 정보 -->
		<table class="view-table">
			<colgroup>
				<col width="130">
				<col width="450">
				<col width="130">
				<col width="450">
			</colgroup>
			<tr>
				<th class="lb">ECO 제목</th>
				<td class="indent5"><%=dto.getName()%></td>
				<th>ECO 번호</th>
				<td class="indent5"><%=dto.getNumber()%></td>
			</tr>
			<tr>
				<th class="lb">상태</th>
				<td class="indent5"><%=dto.getState()%></td>
				<th>등록자</th>
				<td class="indent5"><%=dto.getCreator()%></td>
			</tr>
			<tr>
				<th class="lb">ECO 타입</th>
				<td class="indent5"><%=dto.getSendType()%></td>
				<th>등록일</th>
				<td class="indent5"><%=dto.getCreatedDate_txt()%></td>
			</tr>
			<tr>
				<th class="lb">인허가 변경</th>
				<td class="indent5"><%=dto.getLicensing_name()%></td>
				<th>위험통제</th>
				<td class="indent5"><%=dto.getRiskType_name()%></td>
			</tr>
			<tr>
				<th class="lb">수정일</th>
				<td class="indent5"><%=dto.getModifiedDate_text()%></td>
				<th>승인일</th>
				<td class="indent5"><%=dto.getApproveDate()%></td>
			</tr>
			<tr>
				<th class="lb">변경사항</th>
				<td colspan="3" class="indent5">
					<textarea rows="5" readonly="readonly" id="eoCommentA" rows="5"><%=dto.getEoCommentA()%></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">변경사유</th>
				<td colspan="3" class="indent5">
					<textarea rows="5" readonly="readonly" id="eoCommentB" rows="5"><%=dto.getEoCommentB()%></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">특기사항</th>
				<td colspan="3" class="indent5">
					<textarea rows="5" readonly="readonly" id="eoCommentC" rows="5"><%=dto.getEoCommentC()%></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">기타사항</th>
				<td colspan="3" class="indent5">
					<textarea rows="5" readonly="readonly" id="eoCommentD" rows="5"><%=dto.getEoCommentD()%></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/secondary-view.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>
		<jsp:include page="/extcore/jsp/change/activity/include/activity-view.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>

	<div id="tabs-2">
		<jsp:include page="/extcore/jsp/change/include/change-output.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
	<div id="tabs-3">
		<!-- 이력관리 -->
		<jsp:include page="/extcore/jsp/change/eco/include/eco-record-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
</div>

<script type="text/javascript">
	const oid = document.getElementById("oid").value;

	function autoHeight() {
		const eoCommentC = document.getElementById("eoCommentC");
		eoCommentC.style.height = "auto";
		eoCommentC.style.height = "500px";
		// 		const style = window.getComputedStyle(eoCommentC);
		// 		console.log(style);

	}

	document.addEventListener("DOMContentLoaded", function() {
		$("#tabs").tabs({
			active : 0,
			activate : function(event, ui) {
				var tabId = ui.newPanel.prop("id");
				switch (tabId) {
				case "tabs-1":
					break;
				case "tabs-3":
					const isCreated51 = AUIGrid.isCreated(myGridID51); // 다운로드이력
					if (isCreated51) {
						AUIGrid.resize(myGridID51);
					} else {
						createAUIGrid51(columns51);
					}
					const isCreated10000 = AUIGrid.isCreated(myGridID10000); // 결재이력
					if (isCreated10000) {
						AUIGrid.resize(myGridID10000);
					} else {
						createAUIGrid10000(columns10000);
					}
					const isCreated10001 = AUIGrid.isCreated(myGridID10001); // 외부 메일
					if (isCreated10001) {
						AUIGrid.resize(myGridID10001);
					} else {
						createAUIGrid10001(columns10001);
					}
					break;
				}
			}
		});

		// 		autoHeight();
		createAUIGrid700(columns700);
		AUIGrid.resize(myGridID700);
	});

	window.addEventListener("resize", function() {
		AUIGrid.resize(myGridID700);
	})

	function modify() {
		document.location.href = getCallUrl("/eco/modify?oid=" + oid);
	}

	function _delete() {

		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}

		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/eco/delete?oid=" + oid);
		openLayer();
		call(url, null, function(data) {
			alert(data.msg);
			if (data.result) {
				opener.loadGridData();
				self.close();
			} else {
				clsoeLayer();
			}
		}, "DELETE");
	}
</script>