<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// boolean isAdmin = (boolean) request.getAttribute("isAdmin");
// WTUser sessionUser = (WTUser) request.getAttribute("sessionUser");
%>
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
	<form>
		<input type="hidden" name="sessionid" id="sessionid">
		<input type="hidden" name="lastNum" id="lastNum">
		<input type="hidden" name="curPage" id="curPage">
		<input type="hidden" name="oid" id="oid">
		
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 채번 정보
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="130">
				<col width="130">
				<col width="130">
				<col width="130">
				<col width="130">
				<col width="130">
			</colgroup>
			<tr>
				<th>품목분류 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="2">
					<span id="locationName">
						/Default/PART_Drawing
					</span>
				</td>
				<th rowspan="4">품목명 <span style="color:red;">*</span></th>
				<th>대제목</th>
				<td class="indent5">
					<input type="text" name="partName1" id="partName1" class="width-300">
				</td>
			</tr>
			<tr>
				<th>품목구분 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="2">
					<input type="text" name="partType1" id="partType1" class="width-500">
				</td>
				<th>중제목</th>
				<td class="indent5">
					<input type="text" name="partName2" id="partName2" class="width-300">
				</td>
			</tr>
			<tr>
				<th>대분류 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="2">
					<input type="text" name="partType2" id="partType2" class="width-500">
				</td>
				<th>소제목</th>
				<td class="indent5">
					<input type="text" name="partName3" id="partName3" class="width-300">
				</td>
			</tr>
			<tr>
				<th>중분류 <span style="color:red;">*</span></th>
				<td class="indent5" colspan="2">
					<input type="text" name="partType3" id="partType3" class="width-500">
				</td>
				<th>사용자 Key in</th>
				<td class="indent5">
					<input type="text" name="partName4" id="partName4" class="width-300">
				</td>
			</tr>
			<tr>
				<th>SEQ <br><span style="color:red;">(3자리)</span></th>
				<td class="indent5" colspan="5">
					<input type="text" name="seq" id="seq" class="width-200">
					<input type="button" id="seqList" class="btnSearch" value="SEQ 현황보기" title="SEQ 현황보기" onclick="loadGridData();">
				</td>
			</tr>
			<tr>
				<th>기타 <br><span style="color:red;">(2자리)</span></th>
				<td class="indent5" colspan="5">
					<input type="text" name="etc" id="etc" class="width-200">
				</td>
			</tr>
		</table>
		
		<br>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 품목 속성
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="174">
				<col width="*">
				<col width="174">
				<col width="*">
			</colgroup>
			<tr>
				<th>프로젝트코드 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="model" id="model" class="width-500">
				</td>
				<th>제작방법 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="productmethod" id="productmethod" class="width-500">
				</td>
			</tr>
			<tr>
				<th>부서 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="deptcode" id="deptcode" class="width-500">
				</td>
				<th>단위 <span style="color:red;">*</span></th>
				<td class="indent5">
					<input type="text" name="unit" id="unit" class="width-500">
				</td>
			</tr>
			<tr>
				<th>무게(g)</th>
				<td class="indent5">
					<input type="text" name="weight" id="weight" class="width-500">
				</td>
				<th>MANUFACTURER</th>
				<td class="indent5">
					<input type="text" name="manufacture" id="manufacture" class="width-500">
				</td>
			</tr>
			<tr>
				<th>재질</th>
				<td class="indent5">
					<input type="text" name="mat" id="mat" class="width-500">
				</td>
				<th>후처리</th>
				<td class="indent5">
					<input type="text" name="finish" id="finish" class="width-500">
				</td>
			</tr>
			<tr>
				<th>OEM Info.</th>
				<td class="indent5">
					<input type="text" name="remarks" id="remarks" class="width-500">
				</td>
				<th>사양</th>
				<td class="indent5">
					<input type="text" name="specification" id="specification" class="width-500">
				</td>
			</tr>
		</table>
		<br>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 주 도면&nbsp;&nbsp;
						<span class="red">(메카 : CAD파일), (광학/제어/파워/인증 : PDF파일)</span>
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="180">
				<col width="*">
				<col width="180">
				<col width="*">
			</colgroup>
			<tr>
				<th>주 도면</th>
				<td class="indent5" colspan="3">
				</td>
			</tr>
		</table>
		<br>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 첨부파일&nbsp;&nbsp;
						<span class="red">(제어/파워 : 배포파일)</span>
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="180">
				<col width="*">
				<col width="180">
				<col width="*">
			</colgroup>
			<tr>
				<th class="lb">첨부파일</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/common/attach-secondary.jsp">
						<jsp:param value="" name="oid" />
					</jsp:include>
				</td>
			</tr>
		</table>
		<br>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 관련 문서
					</div>
				</td>
			</tr>
		</table>
	
		<table class="search-table">
			<colgroup>
				<col width="180">
				<col width="*">
				<col width="180">
				<col width="*">
			</colgroup>
			<tr>
				<th>관련 문서</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/document/include_selectDocument.jsp">
						<jsp:param value="" name="oid" />
						<jsp:param value="create" name="mode" />
					</jsp:include>
				</td>
			</tr>
		</table>
		<br>
		<table class="button-table">
			<tr>
				<td class="left">
					<div class="header">
						<img src="/Windchill/extcore/images/header.png"> 관련 RoHS
					</div>
				</td>
			</tr>
		</table>
		
		<table class="search-table">
			<colgroup>
				<col width="180">
				<col width="*">
				<col width="180">
				<col width="*">
			</colgroup>
			<tr>
				<th>관련 RoHS</th>
				<td class="indent5" colspan="3">
					<jsp:include page="/extcore/jsp/rohs/include_selectRohs.jsp">
						<jsp:param value="" name="oid" />
						<jsp:param value="create" name="mode" />
					</jsp:include>
				</td>
			</tr>
		</table>
		
		<table class="button-table">
			<tr>
				<td class="center">
					<input type="button" value="등록" title="등록" id="createBtn" class="blue" onclick="create('false');" />
					<input type="button" value="초기화" title="초기화" id="resetBtn" />
					<input type="button" value="목록" title="목록" id="listBtn" />
				</td>
			</tr>
		</table>

		<script type="text/javascript">

			function create(isSelf) {
				const partName1 = document.getElementById("partName1").value;
				const partType1 = document.getElementById("partType1").value;
				const partName2 = document.getElementById("partName2").value;
				const partType2 = document.getElementById("partType2").value;
				const partName3 = document.getElementById("partName3").value;
				const partType3 = document.getElementById("partType3").value;
				const partName4 = document.getElementById("partName4").value;
				const seq = document.getElementById("seq").value;
				const etc = document.getElementById("etc").value;
				const model = document.getElementById("model").value;
				const productmethod = document.getElementById("productmethod").value;
				const deptcode = document.getElementById("deptcode").value;
				const weight = document.getElementById("weight").value;
				const manufacture = document.getElementById("manufacture").value;
				const mat = document.getElementById("mat").value;
				const finish = document.getElementById("finish").value;
				const remarks = document.getElementById("remarks").value;
				const specification = document.getElementById("specification").value;
				const unit = "ea";
//	 			const addRows7 = AUIGrid.getAddedRowItems(myGridID7);
//	 			const addRows8 = AUIGrid.getAddedRowItems(myGridID8);
//	 			const addRows11 = AUIGrid.getAddedRowItems(myGridID11);
				const primarys = toArray("primarys");

				if (!confirm("등록 하시겠습니까?")) {
					return false;
				}

				const params = new Object();
				const url = getCallUrl("/part/create");
				params.partName1 = partName1;
				params.partType1 = partType1;
				params.partName2 = partName2;
				params.partType2 = partType2;
				params.partName3 = partName3;
				params.partType3 = partType3;
				params.partName4 = partName4;
				params.seq = seq;
				params.etc = etc;
				params.model = model;
				params.productmethod = productmethod;
				params.deptcode = deptcode;
				params.weight = weight;
				params.manufacture = manufacture;
				params.mat = mat;
				params.finish = finish;
				params.remarks = remarks;
				params.specification = specification;
//	 			params.addRows7 = addRows7;
//	 			params.addRows11 = addRows11;
				params.primarys = primarys;
//	 			toRegister(params, addRows8);
//	 			openLayer();
				call(url, params, function(data) {
					alert(data.msg);
					if (data.result) {
//	 					opener.loadGridData();
//	 					self.close();
					} else {
//	 					closeLayer();
					}
				});
			};

			function exportExcel() {
// 				const exceptColumnFields = [ "primary" ];
// 				const sessionName = document.getElementById("sessionName").value;
// 				exportToExcel("문서 리스트", "문서", "문서 리스트", exceptColumnFields, sessionName);
			}

			document.addEventListener("keydown", function(event) {
				const keyCode = event.keyCode || event.which;
				if (keyCode === 13) {
// 					loadGridData();
				}
			})

			document.addEventListener("click", function(event) {
				hideContextMenu();
			})
			
			document.addEventListener("DOMContentLoaded", function() {
				createAUIGrid4(columnsDoc);
				AUIGrid.resize(docGridID);
				createAUIGrid6(columnsRohs);
				AUIGrid.resize(rohsGridID);
				document.getElementById("partName1").focus();
			});
			
			window.addEventListener("resize", function() {
				AUIGrid.resize(docGridID);
				AUIGrid.resize(rohsGridID);
			});
		</script>
	</form>
</body>
</html>