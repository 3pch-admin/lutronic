<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
</head>
<body>
	<form>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png">
						금형 일괄 결재
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
				<th class="req lb">일괄결재 제목</th>
				<td class="indent5">
					<input type="text" name="appName" id="appName" class="width-400">
				</td>
			</tr>
			<tr>
				<th class="lb">일괄결재 설명</th>
				<td class="indent5">
					<div class="textarea-auto">
						<textarea name="description" id="description" rows="6"></textarea>
					</div>
				</td>
			</tr>
		</table>

		<table class="button-table">
			<tr>
				<td class="left">
					<input type="button" value="추가" title="추가" class="red" onclick="popup();">
					<input type="button" value="삭제" title="삭제" class="blue" onclick="deleteRow90();">
				</td>
			</tr>
		</table>

		<div id="grid_wrap" style="height: 30px; border-top: 1px solid #3180c3;"></div>

		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" class="blue" onclick="create();">
					<input type="button" value="뒤로" title="뒤로" class="gray" onclick="history.go(-1);">
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			let myGridID;
			const columns = [ {
				dataField : "number",
				headerText : "금형번호",
				dataType : "string",
				width : 200,
				renderer : {
					type : "LinkRenderer",
					baseUrl : "javascript",
					jsCallback : function(rowIndex, columnIndex, value, item) {
						const oid = item.oid;
						const url = getCallUrl("/mold/view?oid=" + oid);
						_popup(url, 1600, 800, "n");
					}
				},
			}, {
				dataField : "name",
				headerText : "금형명",
				dataType : "string",
				style : "aui-left",
				renderer : {
					type : "LinkRenderer",
					baseUrl : "javascript",
					jsCallback : function(rowIndex, columnIndex, value, item) {
						const oid = item.oid;
						const url = getCallUrl("/mold/view?oid=" + oid);
						_popup(url, 1600, 800, "n");
					}
				},
			}, {
				dataField : "version",
				headerText : "REV",
				dataType : "string",
				width : 80,
			}, {
				dataField : "stateDisplay",
				headerText : "상태",
				dataType : "string",
				width : 100,
			}, {
				dataField : "creator",
				headerText : "등록자",
				dataType : "string",
				width : 100,
			}, {
				dataField : "createDate",
				headerText : "등록일",
				dataType : "string",
				width : 100,
			}, {
				dataField : "modifyDate",
				headerText : "수정일",
				dataType : "string",
				width : 100,
			}, {
				dataField : "oid",
				dataType : "string",
				visible : false
			} ]

			function createAUIGrid(columnLayout) {
				const props = {
					headerHeight : 30,
					showStateColumn : true,
					showRowNumColumn : true,
					showRowCheckColumn : true,
					rowNumHeaderText : "번호",
					showAutoNoDataMessage : false,
					selectionMode : "multipleCells",
					hoverMode : "singleRow",
					enableMovingColumn : true,
					autoGridHeight : true
				};
				myGridID = AUIGrid.create("#grid_wrap", columnLayout, props);
			}
			// 등록
			function create() {
				const appName = document.getElementById("appName");
				const description = document.getElementById("description");
				const list = AUIGrid.getGridData(myGridID);

				if (appName.value === "") {
					alert("일괄결재 제목을 입력하세요.");
					appName.focus();
					return false;
				}

				if (list.length === 0) {
					alert("일괄결재 대상을 선택하세요.");
					return false;
				}

				if (!confirm("등록 하시겠습니까?")) {
					return false;
				}

				const params = {
					appName : appName.value,
					description : description.value,
					list : list,
					type : "MOLD"
				}
				const url = getCallUrl("/asm/register");
				parent.openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
						document.location.href = getCallUrl("/workData/list");
					} else {
						parent.closeLayer();
					}
				})
			}

			function popup() {
				const url = getCallUrl("/mold/popup?method=insert90&multi=true&state=BATCHAPPROVAL");
				_popup(url, 1400, 700, "n");
			}

			function deleteRow90() {
				const checkedItems = AUIGrid.getCheckedRowItems(myGridID);
				if (checkedItems.length === 0) {
					alert("삭제할 행을 선택하세요.");
					return false;
				}

				AUIGrid.removeCheckedRows(myGridID);
			}

			function insert90(arr, callBack) {
				let checker = true;
				let number;
				arr.forEach(function(dd) {
					const rowIndex = dd.rowIndex;
					const item = dd.item;
					const unique = AUIGrid.isUniqueValue(myGridID, "oid", item.oid);
					if (!unique) {
						number = item.number;
						checker = false;
						return true;
					}
				})

				if (!checker) {
					callBack(true, false, number + " 금형은 이미 추가 되어있습니다.");
				} else {
					arr.forEach(function(dd) {
						const rowIndex = dd.rowIndex;
						const item = dd.item;
						AUIGrid.addRow(myGridID, item, rowIndex);
					})
				}
			}

			// jquery 삭제를 해가는 쪽으로 한다..
			document.addEventListener("DOMContentLoaded", function() {
				toFocus("appName");
				createAUIGrid(columns);
				AUIGrid.resize(myGridID);
				autoTextarea();
			});

			window.addEventListener("resize", function() {
				AUIGrid.resize(myGridID);
			});
		</script>
	</form>
</body>
</html>