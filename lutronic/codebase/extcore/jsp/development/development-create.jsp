<%@page import="com.e3ps.doc.service.DocumentHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- AUIGrid -->
<%-- <%@include file="/extcore/jsp/common/aui/auigrid.jsp"%> --%>
<%-- <input type="hidden" name="location" id="location" value="<%=DocumentHelper.DOCUMENT_ROOT %>"> --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<%@include file="/extcore/jsp/common/css.jsp"%>
<%@include file="/extcore/jsp/common/script.jsp"%>
<%@include file="/extcore/jsp/common/auigrid.jsp"%>
<script type="text/javascript" src="/Windchill/extcore/js/auigrid.js"></script>
</head>
<body>
	<table class="button-table">
		<tr>
			<td class="left">
				<div class="header">
					<img src="/Windchill/extcore/images/header.png">개발업무 등록
				</div>
			</td>
		</tr>
	</table>
	<table class="create-table">
		<colgroup>
			<col width="150">
			<col width="*">
			<col width="150">
			<col width="*">
		</colgroup>
		<tr>
			<th class="req lb">프로젝트 코드</th>
			<td class="indent5"><select name="model" id="model" class="width-200">
						<option value="">선택</option>
						<option value="INWORK">작업 중</option>
						<option value="UNDERAPPROVAL">승인 중</option>
						<option value="APPROVED">승인됨</option>
						<option value="RETURN">반려됨</option>
				</select></td>
			<th class="req lb">프로젝트명</th>
			<td class="indent5"><input type="text" name="name" id="name" class="width-200"></td>
		</tr>
		<tr>
			<th class="req lb">예상 시작일</th>
			<td class="indent5">
				<input type="text" name="developmentStart" id="developmentStart" class="width-100"><img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제">
			</td>
			<th class="req lb">예상 종료일</th>
			<td class="indent5">
				<input type="text" name="developmentEnd" id="developmentEnd" class="width-100"><img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제">
			</td>
		</tr>
		<tr>
			<th class="req lb">관리자</th>
			<td class="indent5"><input type="text" name="creator" id="creator" data-multi="false" class="width-200"> <input type="hidden" name="creatorOid" id="creatorOid"> <img src="/Windchill/extcore/images/delete.png" class="delete" title="삭제" onclick="clearUser('creator')"></td>
		</tr>
		<tr>
			<th class="lb">설명</th>
			<td colspan="3" class="indent5"><textarea name="description" id="description" rows="6"></textarea></td>
		</tr>
	</table>
	<table class="button-table">
		<tr>
			<td class="right"><input type="button" value="등록" title="등록" onclick="create('false');"> <input type="button" value="초기화" title="초기화" class="blue" onclick="create('true')"> <input type="button" value="목록" title="목록" class="red" onclick="self.close();"></td>
		</tr>
	</table>
	<script type="text/javascript">
		function folder() {
			const location = decodeURIComponent("/Default/문서");
			const url = getCallUrl("/folder?location=" + location + "&container=product&method=setNumber&multi=false");
			popup(url, 500, 600);
		}

		function setNumber(item) {
			const url = getCallUrl("/doc/setNumber");
			const params = new Object();
			params.loc = item.location;
			call(url, params, function(data) {
				document.getElementById("loc").innerHTML = item.location;
				document.getElementById("location").value = item.location;
				document.getElementById("number").value = data.number;
			})
		}

		function create(isSelf) {
			const name = document.getElementById("name");
			const number = document.getElementById("number").value;
			const description = document.getElementById("description").value;
			const location = document.getElementById("location").value;
			const addRows7 = AUIGrid.getAddedRowItems(myGridID7);
			const addRows8 = AUIGrid.getAddedRowItems(myGridID8);
			const addRows11 = AUIGrid.getAddedRowItems(myGridID11);
			const primarys = toArray("primarys");

			if (location === "/Default/문서") {
				alert("문서 저장위치를 선택하세요.");
				folder();
				return false;
			}

			if (isNull(name.value)) {
				alert("문서제목을 입력하세요.");
				name.focus();
				return false;
			}

			// 		if(addRows11.length === 0) {
			// 			alert("도번을 추가하세요.");
			// 			insert11();
			// 			return false;
			// 		}

			if (primarys.length === 0) {
				alert("첨부파일을 선택하세요.");
				return false;
			}

			if (!confirm("등록 하시겠습니까?")) {
				return false;
			}

			const params = new Object();
			const url = getCallUrl("/doc/create");
			params.name = name.value;
			params.number = number;
			params.self = JSON.parse(isSelf);
			params.description = description;
			params.location = location;
			params.addRows7 = addRows7;
			params.addRows11 = addRows11;
			params.primarys = primarys;
			toRegister(params, addRows8);
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
		};

		// jquery 삭제를 해가는 쪽으로 한다..
		document.addEventListener("DOMContentLoaded", function() {
			finderUser("creator");
			date("developmentStart");
			date("developmentEnd");
			// DOM이 로드된 후 실행할 코드 작성
			createAUIGrid7(columns7);
			createAUIGrid11(columns11);
			createAUIGrid8(columns8);
			AUIGrid.resize(myGridID7);
			AUIGrid.resize(myGridID11);
			AUIGrid.resize(myGridID8);
			document.getElementById("name").focus();
		});

		window.addEventListener("resize", function() {
			AUIGrid.resize(myGridID7);
			AUIGrid.resize(myGridID11);
			AUIGrid.resize(myGridID8);
		});
	</script>
</body>
</html>