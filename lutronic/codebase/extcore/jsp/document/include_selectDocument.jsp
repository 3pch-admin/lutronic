<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String oid = request.getParameter("oid");
String mode = request.getParameter("mode");
String title = request.getParameter("title");
String docOid = request.getParameter("paramName");
String searchType = request.getParameter("searchType");
String lifecycle = request.getParameter("lifecycle");
boolean isCreate = "create".equals(mode);
%>
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				<%=title%>
			</div>
		</td>
	</tr>
</table>
<table class="create-table">
	<colgroup>
		<col width="150">
		<col width="*">
	</colgroup>
	<tr>
		<th class="lb <%="관련 문서".equals(title) ? "req" : ""%>"><%=title%></th>
		<td>
			<div style="margin-top: 5px;">
				<input type="hidden" name="lifecycle" id="lifecycle" value="<%=lifecycle%>" />
				<input type="hidden" name="searchType" id="searchType" value="<%=searchType%>" />
				<input type="button" value="추가" title="추가" class="blue" onclick="append();">
				<input type="button" value="삭제" title="삭제" class="red" onclick="remove();">
			</div>
			<div id="grid90" style="height: 300px; border-top: 1px solid #3180c3; margin: 5px;"></div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	let myGridID90;
	const columns90 = [ {
		dataField : "number",
		headerText : "문서번호",
		dataType : "string",
		width : 180,
	}, {
		dataField : "name",
		headerText : "문서명",
		dataType : "string",
		style : "aui-left"
	}, {
		dataField : "version",
		headerText : "REV",
		dataType : "string",
		width : 180,
	}, {
		dataField : "oid",
		visible : false
	} ]

	function createAUIGrid90(columnLayout) {
		const props = {
			headerHeight : 30,
			showRowNumColumn : false,
			showAutoNoDataMessage : false,
			softRemoveRowMode : false,
			selectionMode : "multipleCells",
			showRowCheckColumn : true,
			showStateColumn : false,
		}
		myGridID90 = AUIGrid.create("#grid90", columnLayout, props);
	}

	function append() {
		const url = getCallUrl("/doc/append");
		_popup(url, 1500, 700);
	}

	function append(items) {
		var arr = [];
		var count = 0;
		var data = AUIGrid.getGridData(docGridID);
		for (var i = 0; i < items.length; i++) {
			var a = 0;
			if (data.length == 0) {
				arr[i] = items[i];
			} else {
				for (var j = 0; j < data.length; j++) {
					if (data[j].oid == items[i].oid) {
						a++;
					}
				}
			}
			if (a == 0) {
				arr[count] = items[i];
				count++;
			}
		}
		AUIGrid.addRow(docGridID, arr);
	}

	function deleteDoc() {
		const checked = AUIGrid.getCheckedRowItems(docGridID);
		if (checked.length === 0) {
			alert("삭제할 행을 선택하세요.");
			return false;
		}

		for (let i = checked.length - 1; i >= 0; i--) {
			const rowIndex = checked[i].rowIndex;
			AUIGrid.removeRow(docGridID, rowIndex);
		}
	}

	function insertGrid(items) {
		AUIGrid.setGridData(docGridID, items);
	}
</script>