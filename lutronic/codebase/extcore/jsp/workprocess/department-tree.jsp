<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String location = request.getParameter("location");
String container = request.getParameter("container");
String mode = request.getParameter("mode");
String height = request.getParameter("height");
%>
<!-- 폴더 그리드 리스트 -->
<div id="_grid_wrap" style="height: <%=height%>px; border-top: 1px solid #3180c3;"></div>
<script type="text/javascript">
	let _myGridID;
	const layout = [ {
		dataField : "name",
		headerText : "부서명",
		dataType : "string",
		filter : {
			showIcon : true,
			inline : true
		}
	} ]

	function _createAUIGrid(columnLayout) {
		const props = {
			rowIdField : "oid",
			headerHeight : 30,
			showRowNumColumn : true,
			rowNumHeaderText : "번호",
			selectionMode : "multipleCells",
			enableFilter : true,
			showInlineFilter : true,
			displayTreeOpen : true,
			forceTreeView : true
		}
		_myGridID = AUIGrid.create("#_grid_wrap", columnLayout, props);
		loadTree();
		// 		AUIGrid.bind(_myGridID, "selectionChange", auiGridSelectionChangeHandler);
		AUIGrid.bind(_myGridID, "cellDoubleClick", auiCellDoubleClick);
		AUIGrid.bind(_myGridID, "cellClick", auiCellClick);
		AUIGrid.bind(_myGridID, "ready", auiReadyHandler);
	}

	function auiReadyHandler() {
		AUIGrid.showItemsOnDepth(_myGridID, 2);
	}

	function auiCellClick(event) {
		const item = event.item;
		const oid = item.oid;
		const location = item.location;
		document.getElementById("oid").value = oid;
		document.getElementById("location").value = oid;
		document.getElementById("locationText").innerText = location;
	}

	let timerId = null;
	function auiCellDoubleClick(event) {
<%if ("list".equals(mode)) {%>
	// 500ms 보다 빠르게 그리드 선택자가 변경된다면 데이터 요청 안함
		if (timerId) {
			clearTimeout(timerId);
		}

		timerId = setTimeout(function() {
			const primeCell = event.item;
			const oid = primeCell.oid;
			const location = primeCell.location;
			document.getElementById("oid").value = oid;
			document.getElementById("location").value = oid;
			document.getElementById("locationText").innerText = location;
			loadGridData();
		}, 500);
<%}%>
	}

	function loadTree() {
		const url = getCallUrl("/department/tree");
		const params = new Object();
		call(url, params, function(data) {
			AUIGrid.setGridData(_myGridID, data.list);
		});
	}

	document.addEventListener("DOMContentLoaded", function() {
		_createAUIGrid(layout);
		AUIGrid.resize(_myGridID);
	});
</script>
