<%@page import="com.e3ps.mold.dto.MoldDTO"%>
<%@page import="com.e3ps.rohs.dto.RohsData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="wt.org.WTUser"%>
<%
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
MoldDTO dto = (MoldDTO) request.getAttribute("dto");
%>
<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				금형 상세보기
			</div>
		</td>
		<td class="right">
			<%
			if (dto.getState().equals("APPROVED") || isAdmin) {
			%>
			<input type="button" value="개정" title="개정" onclick="revise();">
			<%
			}
			%>
			<%
			if (dto.isModify() || isAdmin) {
			%>
			<input type="button" value="수정" title="수정" class="blue" onclick="update();">
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
			<a href="#tabs-2">관련 객체</a>
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
				<col width="350">
				<col width="130">
				<col width="350">
				<col width="130">
				<col width="350">
			</colgroup>
			<tr>
				<th class="lb">금형번호</th>
				<td class="indent5"><%=dto.getNumber()%></td>
				<th>금형분류</th>
				<td class="indent5"><%=dto.getLocation()%></td>
				<th>상태</th>
				<td class="indent5"><%=dto.getStateDisplay()%></td>
			</tr>
			<tr>
				<th class="lb">REV</th>
				<td class="indent5">
					<%=dto.getVersion()%>
					<%
					if (!dto.isLatest()) {
					%>
					&nbsp;
					<b>
						<a href="javascript:latest();">(최신버전으로)</a>
					</b>
					<%
					}
					%>
				</td>
				<th>등록자</th>
				<td class="indent5"><%=dto.getCreator()%></td>
				<th>수정자</th>
				<td class="indent5"><%=dto.getModifier()%></td>
			</tr>
			<tr>
				<th class="lb">등록일</th>
				<td class="indent5"><%=dto.getCreateDate()%></td>
				<th>수정일</th>
				<td class="indent5"><%=dto.getModifyDate()%></td>
				<th>문서유형</th>
				<td class="indent5"><%=dto.getDocumentTypeDisplay()%></td>
			</tr>
			<tr>
				<th class="lb">결재방식</th>
				<td class="indent5" colspan="5"><%=dto.getApprovaltype_name()%></td>
			</tr>
			<tr>
				<th class="lb">설명</th>
				<td colspan="5" class="indent5">
					<textarea rows="5" readonly="readonly" id="description" rows="5"><%=dto.getDescription() == null ? "" : dto.getDescription()%></textarea>
				</td>
			</tr>
			<tr>
				<th class="lb">주 첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/primary-view.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="5">
					<jsp:include page="/extcore/jsp/common/secondary-view.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<!-- 속성 -->
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						금형 속성
					</div>
				</td>
			</tr>
		</table>
		<table class="view-table">
			<colgroup>
				<col width="130">
				<col width="450">
				<col width="130">
				<col width="450">
				<col width="130">
				<col width="450">
			</colgroup>
			<tr>
				<th class="lb">Manufacturer</th>
				<td class="indent5"><%=dto.getManufacture_name()%></td>
				<th>금형타입</th>
				<td class="indent5"><%=dto.getMoldtype_name()%></td>
				<th>내부 문서번호</th>
				<td class="indent5"><%=dto.getInteralnumber()%></td>
			</tr>
			<tr>
				<th class="lb">부서</th>
				<td class="indent5"><%=dto.getDeptcode_name()%></td>
				<th>업체 금형번호</th>
				<td class="indent5"><%=dto.getMoldnumber()%></td>
				<th>금형개발비</th>
				<td class="indent5"><%=dto.getMoldcost()%></td>
			</tr>
		</table>
	</div>
	<div id="tabs-2">
		<!-- 관련 객체 -->
		<jsp:include page="/extcore/jsp/mold/include/mold-reference-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
	<div id="tabs-3">
		<!-- 이력관리 -->
		<jsp:include page="/extcore/jsp/mold/include/mold-record-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
</div>

<script type="text/javascript">
	//수정
	function update() {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/mold/update?oid=" + oid);
		document.location.href = url;
	}

	//삭제
	function _delete() {
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/mold/delete");
		const params = {
			oid : oid
		}
		openLayer();
		call(url, params, function(data) {
			alert(data.msg);
			if (data.result) {
				opener.loadGridData();
				self.close();
			} else {
				closeLayer();
			}
		});
	}

	//개정
	function revise() {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/mold/revise?oid=" + oid);
		document.location.href = url;
	}

	// 최신버전으로 페이지 이동
	function latest() {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/mold/latest?oid=" + oid);
		_popup(url, 1600, 550, "n");
	}

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
					const isCreated2 = AUIGrid.isCreated(myGridID91); // 품목
					if (isCreated2) {
						AUIGrid.resize(myGridID91);
					} else {
						createAUIGrid91(columns91);
					}
					const isCreated3 = AUIGrid.isCreated(myGridID90); // 문서
					if (isCreated3) {
						AUIGrid.resize(myGridID90);
					} else {
						createAUIGrid90(columns90);
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
					const isCreated10000 = AUIGrid.isCreated(myGridID10000); // 결재이력
					if (isCreated10000) {
						AUIGrid.resize(myGridID10000);
					} else {
						createAUIGrid10000(columns10000);
					}
					break;
				}
			}
		});
	});

	window.addEventListener("resize", function() {
		AUIGrid.resize(myGridID91);
		AUIGrid.resize(myGridID90);
		AUIGrid.resize(myGridID50);
		AUIGrid.resize(myGridID51);
		AUIGrid.resize(myGridID10000);
	});
</script>
