<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String location = (String) request.getAttribute("location");
String method = (String) request.getAttribute("method");
if (method == null) {
	method = "set";
}
%>
<input type="hidden" name="location" id="location" value="<%=location%>">
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png">
				폴더 선택
			</div>
		</td>
		<td class="right">
			<input type="button" value="선택" title="선택" class="blue" onclick="<%=method%>();">
			<input type="button" value="닫기" title="닫기" onclick="self.close();">
		</td>
	</tr>
</table>
<div id="grid_wrap" style="height: 510px; border-top: 1px solid #3180c3;"></div>
<script type="text/javascript">
	let myGridID;
	const columns = [ {
		dataField : "name",
		headerText : "폴더명",
		dataType : "string",
		filter : {
			showIcon : true,
			inline : true
		},
	} ]

	function createAUIGrid(columnLayout) {
		const props = {
			rowIdField : "oid",
			headerHeight : 30,
			showRowCheckColumn : true,
			rowCheckToRadio : true,
			showRowNumColumn : true,
			rowNumHeaderText : "번호",
			selectionMode : "multipleCells",
			treeLazyMode : true,
			hoverMode : "singleRow",
			enableFilter : true,
			displayTreeOpen : false,
			forceTreeView : true,
			showInlineFilter : true,
			filterLayerWidth : 320,
			filterItemMoreMessage : "필터링 검색이 너무 많습니다. 검색을 이용해주세요.",
			rowCheckDisabledFunction: function (rowIndex, isChecked, item) {
				const location = item.location;
				if(location.indexOf("03. 2023년(이전문서)") > -1) {
					return false; 
				}
				return true;
			},
		}
		myGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
		tree();
		AUIGrid.bind(myGridID, "cellDoubleClick", auiCellDoubleClick);
		AUIGrid.bind(myGridID, "cellClick", auiCellClick);
		AUIGrid.bind(myGridID, "treeLazyRequest", auiLazyLoadHandler);
	}
	
	function auiLazyLoadHandler(event) {
		logger(event);
		const item = event.item;
		const oid = item.oid;
		const params = {
			oid : oid,
		}
		const url = getCallUrl("/folder/lazyTree");
// 		parent.openLayer();
		call(url, params, function(data) {
			if (data.result) {
// 				parent.closeLayer();
				event.response(data.list);
			}
		})
	}

	function auiCellClick(event) {
		const item = event.item;
		const rowIdField = AUIGrid.getProp(event.pid, "rowIdField"); // rowIdField 얻기
		const rowId = item[rowIdField];

		const location = item.location;
		if(location.indexOf("03. 2023년(이전문서)") > -1) {
			return false; 
		}
		
		// 이미 체크 선택되었는지 검사
		if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
			// 엑스트라 체크박스 체크해제 추가
			AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
		} else {
			// 엑스트라 체크박스 체크 추가
			AUIGrid.setCheckedRowsByIds(event.pid, rowId);
		}

	}

	function auiCellDoubleClick(event) {

	}

	function rowsUpdate() {
		const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
		if (checkedItems.length === 0) {
			alert("폴더를 선택하세요.");
			return false;
		}
		const item = checkedItems[0].item;
		const oid = item.oid;
		const location = item.location;
		opener.rowsUpdate(oid, location);
		self.close();
	}

	function set() {
		const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
		if (checkedItems.length === 0) {
			alert("폴더를 선택하세요.");
			return false;
		}
		const item = checkedItems[0].item;
		const oid = item.oid;
		const location = item.location;

		if(location.indexOf("03. 2023년(이전문서)") > -1) {
			alert("등록 할 수 없는 폴더 입니다.");
			return false;
		}
		
		opener.document.getElementById("location").value = location;
		opener.document.getElementById("locationText").innerText = location;
		self.close();
	}

	document.addEventListener("DOMContentLoaded", function() {
		createAUIGrid(columns);
		AUIGrid.resize(myGridID);
	});

	function tree() {
		const location = decodeURIComponent(document.getElementById("location").value);
		const url = getCallUrl("/folder/tree");
		const params = {
			location : location
		}
		openLayer();
		call(url, params, function(data) {
			if (data.result) {
				AUIGrid.setGridData(myGridID, data.list);
				AUIGrid.showItemsOnDepth(myGridID, 2);
			} else {
				alert(data.msg);
			}
			closeLayer();
		});
	}
</script>