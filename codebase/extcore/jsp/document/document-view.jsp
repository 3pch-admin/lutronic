<%@page import="com.e3ps.common.util.StringUtil"%>
<%@page import="wt.content.ContentRoleType"%>
<%@page import="wt.content.ContentHelper"%>
<%@page import="wt.fc.QueryResult"%>
<%@page import="com.e3ps.common.util.CommonUtil"%>
<%@page import="wt.doc.WTDocument"%>
<%@page import="java.util.Map"%>
<%@page import="wt.iba.definition.litedefinition.IBAUtility"%>
<%@page import="com.e3ps.common.comments.beans.CommentsDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.e3ps.doc.dto.DocumentDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
boolean isAdmin = (boolean) request.getAttribute("isAdmin");
DocumentDTO dto = (DocumentDTO) request.getAttribute("dto");
ArrayList<CommentsDTO> list = dto.getComments();
WTDocument d = (WTDocument) CommonUtil.getObject(dto.getOid());
%>
<style type="text/css">
iframe {
	margin-top: 3px;
}
</style>
<script type="text/javascript" src="/Windchill/extcore/dext5editor/js/dext5editor.js"></script>

<input type="hidden" name="oid" id="oid" value="<%=dto.getOid()%>">

<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				문서 상세보기
			</div>
		</td>
		<td class="right">
			<input type="button" value="일괄다운로드" title="일괄다운로드" onclick="download();">
			<%
			if (dto.is_publish()) {
			%>
			<input type="button" value="재변환" title="재변환" class="gray" onclick="publish();">
			<%
			}
			%>
			<%
			if (dto.is_withdraw()) {
			%>
			<input type="button" value="회수(결재선 유지)" title="회수(결재선 유지)" class="gray" onclick="withdraw('false');">
			<input type="button" value="회수(결재선 삭제)" title="회수(결재선 삭제)" class="blue" onclick="withdraw('true');">
			<%
			}
			%>
			<%
			if (isAdmin && dto.isLatest()) {
			%>
			<select name="state" id="state" class="width-100" onchange="lcm(this);">
				<option value="">선택</option>
				<option value="LINE_REGISTER">결재선 지정</option>
				<option value="INWORK">작업 중</option>
				<option value="APPROVED">승인됨</option>
			</select>
			<%
			}
			%>
			<%
			if (dto.is_force()) {
			%>
			<input type="button" value="결재(강제)" title="결재(강제)" class="gray" onclick="forceWorkData();">
			<input type="button" value="관리자 권한 수정" title="관리자 권한 수정" class="red" onclick="force();">
			<%
			}
			%>
			<%
			if (dto.is_print()) {
			%>
			<input type="button" value="인쇄" title="인쇄" onclick="print();" class="gray">
			<%
			}
			%>
			<%
			if (dto.is_revise()) {
			%>
			<input type="button" value="개정" title="개정" onclick="update('revise');">
			<%
			}
			%>
			<%
			if (dto.is_modify()) {
			%>
			<input type="button" value="수정" title="수정" class="blue" onclick="update('modify');">
			<%
			}
			%>
			<%
			if (dto.is_delete()) {
			%>
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
				<col width="130">
				<col width="350">
			</colgroup>
			<tr>
				<th class="lb" colspan="8">
					<%=dto.getName()%>
				</th>
			</tr>
			<tr>
				<th class="lb">문서번호/구번호</th>
				<td class="indent5"><%=dto.getNumber()%>
					/
					<%=dto.getOldNumber() != null ? dto.getOldNumber() : ""%></td>
				<th>문서분류</th>
				<td class="indent5"><%=dto.getLocation()%></td>
				<th>상태</th>
				<td class="indent5"><%=dto.getState()%></td>
				<th>REV</th>
				<td class="indent5">
					<%
					if (dto.isLatest()) {
					%>
					<%=dto.getVersion()%>.<%=dto.getIteration()%>
					<%
					} else {
					%>
					<%=dto.getVersion()%>.<%=dto.getIteration()%><a href="javascript:latest();">
						<font color="red">
							<b>(최신버전으로)</b>
						</font>
					</a>
					<%
					}
					%>
				</td>
			</tr>
			<tr>
				<th class="lb">등록일</th>
				<td class="indent5"><%=dto.getCreatedDate()%></td>
				<th>수정일</th>
				<td class="indent5"><%=dto.getModifiedDate()%></td>
				<th>등록자</th>
				<td class="indent5"><%=dto.getCreator()%></td>
				<th>수정자</th>
				<td class="indent5"><%=dto.getModifier()%></td>
			</tr>
			<tr>
				<th class="lb">프로젝트 코드 [명]</th>
				<td class="indent5"><%=dto.getModel_code()%>
					[
					<font color="red">
						<b><%=dto.getModel_name()%></b>
					</font>
					]
				</td>
				<th>보존년한</th>
				<td class="indent5"><%=dto.getPreseration_name()%></td>
				<th>부서</th>
				<td class="indent5"><%=dto.getDeptcode_name()%></td>
				<th>작성자</th>
				<td class="indent5"><%=dto.getWriter()%></td>
			</tr>
			<%
			if (dto.is_product()) {
			%>
			<tr>
				<th class="lb">제품명</th>
				<td class="indent5" colspan="7"><%=dto.getProduct()%></td>
			</tr>
			<%
			}
			%>
			<%
			if (!dto.is_empty()) {
			%>
			<tr>
				<th class="lb">
					내용<%
				//=dto.getContent()
				%>
				</th>
				<td colspan="7" class="indent7 pb8">
					<textarea name="contents" id="contents" rows="7" style="display: none;"><%=dto.getContent() != null ? dto.getContent() : ""%></textarea>
					<script type="text/javascript">
						// 에디터를 view 모드로 설정합니다.
						DEXT5.config.Mode = "view";
						new Dext5editor("content");
						const content = document.getElementById("contents").value;
						DEXT5.setBodyValue(content, "content");
					</script>
				</td>
			</tr>
			<%
			}
			%>
			<tr>
				<th class="lb">설명</th>
				<td colspan="7" class="indent5">
					<div class="textarea-auto">
						<textarea rows="5" readonly="readonly" id="description" rows="5"><%=dto.getDescription() != null ? dto.getDescription() : ""%></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th class="lb">주 첨부파일</th>
				<td class="indent5" colspan="7">
					<jsp:include page="/extcore/jsp/common/primary-view.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
					</jsp:include>
				</td>
			</tr>
			<tr>
				<th class="lb">PDF</th>
				<td class="indent5" colspan="7">
					<%
					Map<String, Object> pdf = dto.getPdf();
					if (pdf != null) {
					%>
					<a href="<%=pdf.get("url")%>"><%=pdf.get("name")%>
						<img src="<%=pdf.get("fileIcon")%>">
					</a>
					<%
					} else {
					%>
					<b>
						<font color="red">등록된 PDF가 없습니다.</font>
					</b>
					<%
					}
					%>
				</td>
			</tr>
			<tr>
				<th class="lb">
					첨부파일
					<!-- 					<input type="button" value="일괄 다운" title="일괄 다운" onclick=""> -->
				</th>
				<td class="indent5" colspan="7">
					<jsp:include page="/extcore/jsp/common/secondary-view.jsp">
						<jsp:param value="<%=dto.getOid()%>" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>

		<div id="comments-layer">
			<table class="button-table">
				<tr>
					<td class="left">
						<div class="header">
							<img src="/Windchill/extcore/images/header.png">
							댓글
						</div>
					</td>
				</tr>
			</table>
			<%
			for (CommentsDTO cm : list) {
				int depth = cm.getDepth();
				ArrayList<CommentsDTO> reply = cm.getReply();
			%>
			<table class="view-table">
				<tr>
					<th class="lb" style="background-color: rgb(193, 235, 255); width: 133px">
						<%=cm.getCreator()%>
						<br>
						<%=cm.getCreatedDate()%>
					</th>
					<td class="indent5">
						<textarea rows="5" readonly="readonly" style="resize: none;"><%=cm.getComment()%></textarea>
					</td>
					<td class="center" style="width: 80px">
						<input type="button" value="답글" title="답글" class="blue mb5" data-bs-toggle="modal" data-bs-target="#reply" onclick="sendReply('<%=cm.getOid()%>', '<%=cm.getDepth()%>');">
						<input type="button" value="수정" title="수정" class="mb5" data-bs-toggle="modal" data-bs-target="#modify" onclick="sendUpdate('<%=cm.getOid()%>', '<%=cm.getDepth()%>');">
						<%
						if (isAdmin) {
						%>
						<input type="button" value="삭제" title="삭제" class="red" onclick="cmdel('<%=cm.getOid()%>');">
						<%
						}
						%>
					</td>
				</tr>
			</table>
			<br>
			<!-- 답글 -->
			<%
			for (CommentsDTO dd : reply) {
				int width = dd.getDepth() * 25;
			%>
			<table class="view-table" style="border-top: none;">
				<tr>
					<td style="width: <%=width%>px; border-bottom: none; border-left: none; text-align: left; text-align: right; font-size: 22px;">⤷&nbsp;</td>
					<th class="lb" style="background-color: rgb(193, 235, 255); border-top: 2px solid #86bff9; width: 133px">
						<%=dd.getCreator()%>
						<br>
						<%=dd.getCreatedDate()%>
					</th>
					<td class="indent5" style="border-top: 2px solid #86bff9;">
						<textarea rows="5" readonly="readonly" style="resize: none;"><%=dd.getComment()%></textarea>
					</td>
					<td class="center" style="border-top: 2px solid #86bff9; width: 80px">
						<input type="button" value="답글" title="답글" class="blue mb5" data-bs-toggle="modal" data-bs-target="#reply" onclick="sendReply('<%=dd.getOid()%>', '<%=dd.getDepth()%>');">
						<input type="button" value="수정" title="수정" class="mb5" data-bs-toggle="modal" data-bs-target="#modify" onclick="sendUpdate('<%=dd.getOid()%>', '<%//=dd.getComment()%>');">
						<%
						if (isAdmin) {
						%>
						<input type="button" value="삭제" title="삭제" class="red" onclick="cmdel('<%=dd.getOid()%>');">
						<%
						}
						%>
					</td>
				</tr>
			</table>
			<br>
			<%
			}
			%>
			<%
			}
			%>
			<table class="view-table">
				<colgroup>
					<col width="136">
					<col width="*">
				</colgroup>
				<tr>
					<th class="lb">댓글</th>
					<td class="indent5">
						<textarea rows="5" name="comments" id="comments" style="resize: none;"></textarea>
					</td>
				</tr>
			</table>
			<table class="button-table">
				<tr>
					<td class="right">
						<input type="button" value="댓글 등록" title="댓글 등록" class="blue" onclick="_write('0');">
					</td>
				</tr>
			</table>
		</div>
		<!-- 댓글 모달 -->
		<%@include file="/extcore/jsp/common/include/comments-include.jsp"%>
	</div>

	<div id="tabs-2">
		<!-- 관련 객체 -->
		<jsp:include page="/extcore/jsp/document/include/document-reference-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>
	<div id="tabs-3">
		<!-- 이력관리 -->
		<jsp:include page="/extcore/jsp/document/include/document-record-include.jsp">
			<jsp:param value="<%=dto.getOid()%>" name="oid" />
		</jsp:include>
	</div>

</div>



<script type="text/javascript">
	const oid = document.getElementById("oid").value;

	//내용인쇄
	function print() {
		const url = getCallUrl("/doc/print?oid=" + oid);
		const isPrint = savePrintHistory(oid);
		if (isPrint) {
			const p = _popup(url, "", "", "f");
		}
	}

	//수정 및 개정
	function update(mode) {
		const url = getCallUrl("/doc/update?oid=" + oid + "&mode=" + mode);
		document.location.href = url;
	}

	function forceWorkData() {
		if (!confirm("결재 진행을 하시겠습니까?")) {
			return false;
		}

		const url = getCallUrl("/doc/forceWorkData?oid=" + oid);
		openLayer();
		call(url, null, function(data) {
			alert(data.msg);
			if (data.result) {
				opener.document.location.href = getCallUrl("/workData/list");
			}
			closeLayer();
		}, "GET");
	}

	function force() {
		const url = getCallUrl("/doc/force?oid=" + oid);
		document.location.href = url;
	}

	//삭제
	function _delete() {
		if (!confirm("삭제 하시겠습니까?")) {
			return false;
		}
		const url = getCallUrl("/doc/delete?oid=" + oid);
		openLayer();
		call(url, null, function(data) {
			alert(data.msg);
			if (data.result) {
				opener.loadGridData();
				self.close();
			} else {
				closeLayer();
			}
		}, "DELETE");
	}

	// 최신버전으로 페이지 이동
	function latest() {
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/doc/latest?oid=" + oid);
		document.location.href = url;
	}

	function publish() {
		if (!confirm("재변환을 진행 하시겠습니까?")) {
			return false;
		}
		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/doc/publish?oid=" + oid);
		openLayer();
		call(url, null, function(data) {
			alert(data.msg);
			if (data.result) {
				document.location.reload();
			}
			closeLayer();
		}, "GET")
	}

	function download() {

		if (!confirm("일괄 다운로드 하시겠습니까?")) {
			return false;
		}

		const oid = document.getElementById("oid").value;
		const url = getCallUrl("/doc/download?oid=" + oid);
		openLayer();
		call(url, null, function(data) {
			if (data.result) {
				const n = data.name;
				document.location.href = '/Windchill/extcore/jsp/common/content/FileDownload2.jsp?fileName=' + n + '&originFileName=' + n;
			}
			closeLayer();
		}, "GET");
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
					const isCreated90 = AUIGrid.isCreated(myGridID90); // 문서
					if (isCreated90) {
						AUIGrid.resize(myGridID90);
					} else {
						createAUIGrid90(columns90);
					}
					const isCreated91 = AUIGrid.isCreated(myGridID91); // 품목
					if (isCreated91) {
						AUIGrid.resize(myGridID91);
					} else {
						createAUIGrid91(columns91);
					}
					const isCreated100 = AUIGrid.isCreated(myGridID100); // EO
					if (isCreated100) {
						AUIGrid.resize(myGridID100);
					} else {
						createAUIGrid100(columns100);
					}
					const isCreated105 = AUIGrid.isCreated(myGridID105); // ECO
					if (isCreated105) {
						AUIGrid.resize(myGridID105);
					} else {
						createAUIGrid105(columns105);
					}
					const isCreated101 = AUIGrid.isCreated(myGridID101); // CR
					if (isCreated101) {
						AUIGrid.resize(myGridID101);
					} else {
						createAUIGrid101(columns101);
					}
					const isCreatedEcpr = AUIGrid.isCreated(myGridID103); // ECPR
					if (isCreatedEcpr) {
						AUIGrid.resize(myGridID103);
					} else {
						createAUIGrid103(columns103);
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
					const isCreated10000 = AUIGrid.isCreated(myGridID10000); // 다운로드이력
					if (isCreated10000) {
						AUIGrid.resize(myGridID10000);
					} else {
						createAUIGrid10000(columns10000);
					}
					const isCreated10001 = AUIGrid.isCreated(myGridID10001); // 외부 유저 메일
					if (isCreated10001) {
						AUIGrid.resize(myGridID10001);
					} else {
						createAUIGrid10001(columns10001);
					}
					break;
				}
			}
		});
		selectbox("state");
		autoTextarea();
	});

	window.addEventListener("resize", function() {
		AUIGrid.resize(myGridID91);
		AUIGrid.resize(myGridID100);
		AUIGrid.resize(myGridID105);
		AUIGrid.resize(myGridID101);
		AUIGrid.resize(myGridID103);
		AUIGrid.resize(myGridID50);
		AUIGrid.resize(myGridID51);
		AUIGrid.resize(myGridID10000);
	});
</script>