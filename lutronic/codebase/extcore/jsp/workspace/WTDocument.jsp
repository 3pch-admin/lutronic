<%@page import="wt.iba.definition.litedefinition.IBAUtility"%>
<%@page import="com.e3ps.common.comments.beans.CommentsDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.e3ps.doc.dto.DocumentDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String tapOid = request.getParameter("tapOid");
DocumentDTO dto = new DocumentDTO(tapOid);

ArrayList<CommentsDTO> list = dto.getComments();
%>
<style type="text/css">
iframe {
	margin-top: 3px;
}
</style>
<script type="text/javascript" src="/Windchill/extcore/smarteditor2/js/HuskyEZCreator.js"></script>

<input type="hidden" name="tapOid" id="tapOid" value="<%=dto.getOid()%>">

	<!-- 기본 정보 -->
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
			<th class="lb">문서번호</th>
			<td class="indent5"><%=dto.getNumber()%></td>
			<th>문서분류</th>
			<td class="indent5"><%=dto.getLocation()%></td>
			<th>상태</th>
			<td class="indent5"><%=dto.getState()%></td>
		</tr>
		<tr>
			<th class="lb">REV</th>
			<td class="indent5">
				<%=dto.getVersion()%>.<%=dto.getIteration()%>
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
			<td class="indent5"><%=dto.getCreatedDate()%></td>
			<th>수정일</th>
			<td class="indent5"><%=dto.getModifiedDate()%></td>
			<th>문서유형</th>
			<td class="indent5"><%=dto.getDocumentType_name()%></td>
		</tr>
		<tr>
			<th class="lb">결재방식</th>
			<td class="indent5"><%=dto.getApprovaltype_name()%></td>
			<th>내부문서번호</th>
			<td class="indent5"><%=dto.getInteralnumber()%></td>
			<th>프로젝트 코드</th>
			<td class="indent5"><%=dto.getModel_name()%></td>
		</tr>
		<tr>
			<th class="lb">작성자</th>
			<td class="indent5"><%=dto.getWriter()%></td>
			<th>보존기간</th>
			<td class="indent5"><%=dto.getPreseration_name()%></td>
			<th>부서</th>
			<td class="indent5"><%=dto.getDeptcode_name()%></td>
		</tr>
		<tr>
			<th class="lb">내용</th>
			<td colspan="5" class="indent5">
				<textarea name="content" id="content" rows="30"><%=dto.getContent() != null ? dto.getContent() : ""%></textarea>
			</td>
		</tr>
		<tr>
			<th class="lb">설명</th>
			<td colspan="5" class="indent5">
				<textarea rows="5" readonly="readonly" id="description" rows="5"><%=dto.getDescription() != null ? dto.getDescription() : ""%></textarea>
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
			<th class="lb">
				첨부파일
				<!-- 					<input type="button" value="일괄 다운" title="일괄 다운" onclick=""> -->
			</th>
			<td class="indent5" colspan="5">
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
				<th class="lb" style="background-color: rgb(193, 235, 255); width: 100px">
					<%=cm.getCreator()%>
					<br>
					<%=cm.getCreatedDate()%>
				</th>
				<td class="indent5">
					<textarea rows="5" readonly="readonly" style="resize: none;"><%=cm.getComment()%></textarea>
				</td>
				<td class="center" style="width: 80px">
					<input type="button" value="답글" title="답글" class="blue mb5" data-bs-toggle="modal" data-bs-target="#reply" onclick="sendReply('<%=cm.getOid()%>', '<%=cm.getDepth()%>');">
					<input type="button" value="수정" title="수정" class="mb5" data-bs-toggle="modal" data-bs-target="#modify" onclick="sendUpdate('<%=cm.getOid()%>', '<%=cm.getComment()%>');">
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
				<th class="lb" style="background-color: rgb(193, 235, 255); border-top: 2px solid #86bff9; width: 100px">
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
				<col width="100">
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





<script type="text/javascript">
	const tapOid = document.getElementById("oid").value;
	// 에디터 로드가 느려서 처리..
	const oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
		oAppRef : oEditors,
		elPlaceHolder : "content", //textarea ID 입력
		sSkinURI : "/Windchill/extcore/smarteditor2/SmartEditor2Skin.html", //martEditor2Skin.html 경로 입력
		fCreator : "createSEditor2",
		htParams : {
			bUseToolbar : false,
			bUseVerticalResizer : false,
			bUseModeChanger : false
		},
		fOnAppLoad : function() {
			oEditors.getById["content"].exec("DISABLE_WYSIWYG");
			oEditors.getById["content"].exec("DISABLE_ALL_UI");
		},
	});

	// 최신버전으로 페이지 이동
	function latest() {
		const url = getCallUrl("/doc/latest?oid=" + tapOid);
		document.location.href = url;
	}


</script>