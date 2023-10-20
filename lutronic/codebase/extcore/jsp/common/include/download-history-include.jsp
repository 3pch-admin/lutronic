<%@page import="com.e3ps.download.service.DownloadHistoryHelper"%>
<%@page import="com.e3ps.common.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%
String oid = request.getParameter("oid");
%>
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				다운로드 이력
			</div>
		</td>
	</tr>
</table>
<div id="grid51" style="height: 250px; border-top: 1px solid #3180c3; margin: 5px;"></div>
<script type="text/javascript">
	let myGridID51;
	const columns51 = [ {
		dataField : "info",
		headerText : "모듈정보",
		dataType : "string",
		style : "aui-left",
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "name",
		headerText : "파일명",
		dataType : "string",
		width : 300,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "userName",
		headerText : "이름",
		dataType : "string",
		width : 150,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "id",
		headerText : "아이디",
		dataType : "string",
		width : 150,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "duty",
		headerText : "직급",
		dataType : "string",
		width : 150,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "department_name",
		headerText : "부서",
		dataType : "string",
		width : 150,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "count",
		headerText : "다운로드횟수",
		dataType : "numeric",
		width : 100,
		postfix : "회",
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "createdDate",
		headerText : "다운로드시간",
		dataType : "string",
		width : 110,
		filter : {
			showIcon : true,
			inline : true
		},
	} ]

	function createAUIGrid51(columnLayout) {
		const props = {
			headerHeight : 30,
			fillColumnSizeMode : true,
			showRowNumColumn : true,
			rowNumHeaderText : "번호",
			showAutoNoDataMessage : false,
			enableSorting : false,
			selectionMode : "multipleCells",
			enableFilter : true,
			autoGridHeight : true
		}
		myGridID51 = AUIGrid.create("#grid51", columnLayout, props);
		AUIGrid.setGridData(myGridID51,
<%=DownloadHistoryHelper.manager.dLogger(oid)%>
	);
	}
</script>