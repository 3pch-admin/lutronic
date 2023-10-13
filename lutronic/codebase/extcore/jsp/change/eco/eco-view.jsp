<%@page import="java.util.Map"%>
<%@page import="com.e3ps.change.eco.dto.EcoDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
EcoDTO dto = (EcoDTO) request.getAttribute("dto");
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
%>



<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				ECO 상세보기
			</div>
		</td>
		<td class="right">
			<input type="button" value="결재회수" title="결재회수">
			<input type="button" value="수정" title="수정" class="blue" onclick="update('modify');">
			<input type="button" value="삭제" title="삭제" class="red" onclick="_delete();">
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
			<a href="#tabs-2">설변 활동</a>
		</li>
		<li>
			<a href="#tabs-3">설변 품목</a>
		</li>
		<li>
			<a href="#tabs-4">이력 관리</a>
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
				<th class="lb">구분</th>
				<td class="indent5"><%=dto.getState()%></td>
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
				<th class="lb">계변경 부품 내역파일</th>
				<td class="indent5" colspan="3">
					<%
					Map<String, Object> contentMap = dto.getContentMap();
					if (contentMap != null) {
					%>
					<div>
						<a href="<%=contentMap.get("url")%>">
							<span style="position: relative; bottom: 2px;"><%=contentMap.get("name")%></span>
							<img src="<%=contentMap.get("fileIcon")%>" style="position: relative; top: 1px;">
						</a>
					</div>
					<%
					} else {
					%>
					<font color="red">
						<b>등록된 계변경 부품 내역파일이 없습니다.</b>
					</font>
					<%
					}
					%>
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
	</div>
</div>
<script type="text/javascript">
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
				case "tabs-2":
					break;
				case "tabs-3":
					break;
				}
			}
		});

		autoHeight();
	});
</script>