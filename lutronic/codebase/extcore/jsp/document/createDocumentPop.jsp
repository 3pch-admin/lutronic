<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="f"	uri="/WEB-INF/functions.tld"			%>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"			%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>

<script type="text/javascript">
$(document).ready(function() {
	numberCodeList('model', '');
	numberCodeList('deptcode', '');
	numberCodeList('preseration', '');
	documentType('GENERAL');
})

<%----------------------------------------------------------
*                      DocumentType 리스트 가져오기
----------------------------------------------------------%>
window.documentType = function(documentType) {
	var data = common_documentType('GENERAL');
	
	addSelectList('documentType', eval(data.responseText));
}

<%----------------------------------------------------------
*                      NumberCode 리스트 가져오기
----------------------------------------------------------%>
window.numberCodeList = function(id, parentCode1) {
	var type = id.toUpperCase();
	var data = common_numberCodeList(type, parentCode1, false);
	
	addSelectList(id, eval(data.responseText));
}

<%----------------------------------------------------------
*                      selectBodx에 옵션 추가
----------------------------------------------------------%>
window.addSelectList = function(id,data){
	$("#"+ id + " option").remove();
	$("#"+ id).append("<option value='' title='' > ${f:getMessage('선택')} </option>");
	if(data.length > 0) {
		for(var i=0; i<data.length; i++) {
			var html = "<option value='" + data[i].code + "'>";
			
			if(id != 'documentType') {
				html += " [" + data[i].code + "] ";
			} 
			html += data[i].name + "</option>";
			
			$("#"+ id).append(html);
		}
	}
}

$(function() {
	$("#createBtn").click(function() {
		if($.trim($("input[name='location']").val()) == '/Default/Document') {
			alert("${f:getMessage('문서분류')}${f:getMessage('을(를) 선택하세요.')}");
			return;
		}
		
		if($.trim($("#documentName").val()) == '') {
			alert("${f:getMessage('문서종류')}${f:getMessage('을(를) 입력하세요.')}");
			$("#documentName").focus();
			return;
		}
		if($("#documentType").val() == '') {
			alert("${f:getMessage('문서분류')}${f:getMessage('을(를) 선택하세요.')}");
			$("#documentType").focus();
			return;
		}
		
		if($("#preseration").val() == '') {
			alert("${f:getMessage('보존기간')}${f:getMessage('을(를) 선택하세요.')}");
			$("#preseration").focus();
			return;
		}
		
		if($.trim($("#PRIMARY").val()) == "" ) {
			alert("${f:getMessage('주 첨부파일')}${f:getMessage('을(를) 선택하세요.')}");
			return;
		}
		
		if(confirm("${f:getMessage('등록하시겠습니까?')}")){
			var form = $("form[name=createDocumentPop]").serialize();
			var url	= getURLString('doc', 'createDocumentAction', "do");
			$.ajax({
				type:"POST",
				url: url,
				data:form,
				dataType:"json",
				async: true,
				cache: false,
				error:function(data){
					var msg = "${f:getMessage('오류가 발생하였습니다.')}";
					alert(msg + "\n" + data.message);
				}
				,beforeSend: function() {
					gfn_StartShowProcessing();
		        }
				,complete: function() {
					gfn_EndShowProcessing();
		        }
				,success: function(data) {
					if(data.result) {
						alert("${f:getMessage('등록 성공하였습니다.')}");
						var type = $('#type').val();
						if(type == 'ecaAction') {
							$(opener.location).attr('href', 'javascript:docLinkReload()');
						}else if(type == 'active'){
							$(opener.location).attr('href', 'javascript:activeReload()');
						}
						window.close();
					}else {
						alert("${f:getMessage('등록 실패하였습니다.')}" + "\n" + data.message);
					}
				}
			});
		}
	})
	
	$("input[name=documentName]").keyup(function (event) {
		var charCode = (event.which) ? event.which : event.keyCode;
		if((charCode == 38 || charCode == 40) ) {
			if(!$( "#"+this.id+"Search" ).is( ":hidden" )){
				var isAdd = false;
				if(charCode == 38){
					isAdd = true;
				}
				moveDocumentNameFocus(this.id, isAdd);
			}
		} else if(charCode == 13 || charCode == 27){
			$("#" + this.id + "Search").hide();
		} else {
			autoSearchDocumentName(this.id, this.value);
		}
		
	})
	
	$("input[name=documentName]").focusout(function () {
		$("#" + this.id + "Search").hide();
	})
})

<%----------------------------------------------------------
*                      ↑,↓ 입력시
----------------------------------------------------------%>
window.moveDocumentNameFocus = function(id,isAdd) {
	var removeCount = 0;
	var addCount = 0;
	var l = $("#" + id + "UL li").length;
	for(var i=0; i<l; i++){
		var cls = $("#" + id + "UL li").eq(i).attr('class');
		if(cls == 'hover') {
			$("#" + id + "UL li").eq(i).removeClass("hover");
			removeCount = i;
			if(isAdd){
				addCount = (i-1);
			}else if(!isAdd) {
				addCount = (i+1);
			}
			break;
		}
	}
	if(addCount == l) {
		addCount = 0;
	}
	$("#" + id + "UL li").eq(addCount).addClass("hover");
	$("#" + id).val($("#" + id + "UL li").eq(addCount).text());
}

<%----------------------------------------------------------
*                      품목명 입력시 이름 검색
----------------------------------------------------------%>
window.autoSearchDocumentName = function(id, value) {
	if($.trim(value) == "") {
		addSearchList(id, '', true);
	} else {
		var codeType = id.toUpperCase();
		var data = common_autoSearchName(codeType, value);
		addSearchList(id, eval(data.responseText), false);
	}
}

<%----------------------------------------------------------
*                      품목명 입력시 데이터 리스트 보여주기
----------------------------------------------------------%>
window.addSearchList = function(id, data, isRemove) {
	$("#" + id + "UL li").remove();
	if(isRemove) {
		$("#" + this.id + "Search").hide();
	}else {
		if(data.length > 0) {
			$("#" + id + "Search").show();
			for(var i=0; i<data.length; i++) {
				$("#" + id + "UL").append("<li title='" + id + "' class=''>" + data[i].name);
			}
		}else {
			$("#" + id + "Search").hide();
		}
	}
}

<%----------------------------------------------------------
*                      품목명 데이터 마우스 올렸을때
----------------------------------------------------------%>
$(document).on("mouseover", 'div > ul > li', function() {
	var partName = $(this).attr("title");
	$(this).addClass("hover");
	$("#" + partName).val($(this).text());
})

<%----------------------------------------------------------
*                      품목명 데이터 마우스 뺄때
----------------------------------------------------------%>
$(document).on("mouseout", 'div > ul > li', function() {
	$(this).removeClass("hover");
})
</script>

<style>
.hover{ 
 	  cursor: default;
      background:#dedede;
}
</style>


<body>

<form name="createDocumentPop" id="createDocumentPop" method="post">

<input type="hidden" name="type" id="type" value="<c:out value="${type }"/>">
<input type="hidden" name="parentOid"  id="parentOid"  value="<c:out value="${parentOid }"/>">

<table width="100%" border="0" cellpadding="0" cellspacing="3" >
	
	<tr bgcolor="ffffff" height="5">
		<td colspan="3">&nbsp;</td>
	</tr>
	
	<tr>
		<td align="left" width="88%">
			<img src="/Windchill/jsp/portal/images/icon/dot_icon03.gif">&nbsp;<b>${f:getMessage('산출물')} ${f:getMessage('문서')} ${f:getMessage('등록')}</b>
		</td>
		
		<td align="right" width="6%">
			<button type="button" class="btnCRUD" id="createBtn">
				<span></span>
				${f:getMessage('등록')}
			</button>
		</td>
		
		<td align="right" width="6%">
			<button type="button" class="btnClose" onclick="self.close();">
				<span></span>
				${f:getMessage('닫기')}
			</button>
		</td>
	</tr>
	
	<tr>
        <td colspan="3">
			<table width="100%" border="0" cellpadding="1" cellspacing="0" class="tablehead" align="center">
			    <tr>
			        <td height="1" width="100%"></td>
			    </tr>
			</table>	
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" style="border-left-width: 1px;border-left-style: solid;border-left-color: #e6e6e6;">
			
				<colgroup>
					<col width="150">
					<col width="350">
					<col width="150">
					<col width="350">
				</colgroup>
				
				<tr bgcolor="ffffff" height="35">
				
					<td class="tdblueM">
						${f:getMessage('문서분류')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL">
						<jsp:include page="/eSolution/folder/include_FolderSelect.do">
							<jsp:param value="/Default/Document" name="root"/>
							<jsp:param value="${oLocation }" name="folder"/>
						</jsp:include>
					</td>
				
					<td class="tdblueM">
						${f:getMessage('결재방식')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL">
						<input type="radio" name="lifecycle" id="lifecycle" value="LC_Default" checked="checked">
							<span></span>
							${f:getMessage('기본결재')}
						<input type="radio" name="lifecycle" id="lifecycle" value="LC_Default_NonWF">
							<span></span>
							${f:getMessage('일괄결재')}
					</td>
				</tr>
			
				<tr bgcolor="ffffff" height="5">
					<td class="tdblueM">
						${f:getMessage('문서종류')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL">
						<input name="documentName" id="documentName" class="txt_field" size="85" style="width:90%" maxlength="80"/>
						
						<div id="documentNameSearch" style="display: none; border: 1px solid black ; position: absolute; background-color: white; z-index: 1;">
							<ul id="documentNameUL" style="list-style-type: none; padding-left: 5px; text-align: left; ">
							</ul>
						</div>
					</td>
					
					<td class="tdblueM">
						${f:getMessage('문서명')}
					</td>
					
					<td class="tdwhiteL">
						<input name="docName" id="docName" class="txt_field" size="85" style="width:90%" maxlength="80"/>
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('문서분류')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL">
						<select id='documentType' name='documentType' style="width: 95%">
						</select>
					</td>
					
					<td class="tdblueM">
						${f:getMessage('보존기간')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL">
						<select id='preseration' name='preseration' style="width: 95%">
						</select>
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('프로젝트코드')}
					</td>
					
					<td class="tdwhiteL">
						<select id='model' name='model' style="width: 95%">
						</select>
					</td>
					
					<td class="tdblueM">
						${f:getMessage('부서')}
					</td>
					
					<td class="tdwhiteL">
						<select id='deptcode' name='deptcode' style="width: 95%">
						</select>
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('내부 문서번호')}
					</td>
					
					<td class="tdwhiteL">
						<input name="interalnumber" id="interalnumber" class="txt_field" size="85" style="width:90%" maxlength="80" />
					</td>
					
					<td class="tdblueM">
						${f:getMessage('작성자')}
					</td>
					
					<td class="tdwhiteL">
						<input name="writer" id="writer" class="txt_field" size="85" style="width:90%" maxlength="80" />
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('문서')}${f:getMessage('설명')}
					</td>
					
					<td class="tdwhiteL" colspan="3">
						<textarea name="description" id="description" cols="10" rows="5" class="fm_area" style="width:90%" onchange="textAreaLengthCheckName('description', '4000', '${f:getMessage('문서')}${f:getMessage('설명')}')"></textarea>
					</td>
				</tr>
				
				<tr bgcolor="ffffff" height="35">
					<td class="tdblueM">
						${f:getMessage('주 첨부파일')}
						<span class="style1">*</span>
					</td>
					
					<td class="tdwhiteL" colspan="3">
						<jsp:include page="/eSolution/content/includeAttachFiles.do" flush="true">
							<jsp:param name="formId" value="createDocumentPop"/>
							<jsp:param name="command" value="insert"/>
							<jsp:param name="type" value="PRIMARY"/>
							<jsp:param name="btnId" value="createBtn" />
						</jsp:include>
					</td>
				</tr>
				
				<tr bgcolor="ffffff">
					<td class="tdblueM">
						${f:getMessage('첨부파일')}
					</td>
					
					<td class="tdwhiteL" colspan="3">
						<jsp:include page="/eSolution/content/includeAttachFiles.do" flush="true">
							<jsp:param name="formId" value="createDocumentPop"/>
							<jsp:param name="command" value="insert"/>
							<jsp:param name="btnId" value="createBtn" />
							<jsp:param name="type" value="SECONDARY"/>
						</jsp:include>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>

</body>
</html>