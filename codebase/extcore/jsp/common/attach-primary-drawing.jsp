<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String oid = (String) request.getParameter("oid");
String method = (String) request.getAttribute("method");
String mode = request.getParameter("mode");
%>
<div class="AXUpload5" id="primary_layer"></div>
<script type="text/javascript">
var imgurl;
var sendName;
const primary = new AXUpload5();
function load() {
	primary.setConfig({
		isSingleUpload : true,
		targetID : "primary_layer",
		uploadFileName : "primary",
		buttonTxt : "파일 선택",
		uploadMaxFileSize : (1024 * 1024 * 1024),
		uploadUrl : getCallUrl("/content/upload"),
		uploadPars : {
			roleType : "primary"
		},
		uploadMaxFileCount : 100,
		deleteUrl : getCallUrl("/content/delete"),
		fileKeys : {
			name : "name",
			type : "type",
			saveName : "saveName",
			fileSize : "fileSize",
			uploadedPath : "uploadedPath",
			roleType : "roleType",
			cacheId : "cacheId",
		},
		onUpload : function() {
			const form = document.querySelector("form");
			const primaryTag = document.createElement("input");
			primaryTag.type = "hidden";
			primaryTag.name = "primary";
			primaryTag.value = this.cacheId+"/"+this.name;
			primaryTag.id = this._id_;
			form.appendChild(primaryTag);
		},
		onDelete : function() {
			const key = this.file._id_;
			const el = document.getElementById(key);
			el.parentNode.removeChild(el);
			
			const primary = document.getElementsByName("primary");
				const tag = primary[0];
				if(tag.id === key){
					tag.parentNode.removeChild(tag);
				}
		}
	})
	<% if("modify".equals(mode)){ %>
	new AXReq("/Windchill/plm/content/list", {
		pars : "oid=<%=oid%>&roleType=primary",
		onsucc : function(res) {
			if (!res.e) {
				const form = document.querySelector("form");
				const data = res.primaryFile;
				const len = data.length;
				for (let i = 0; i < len; i++) {
					const primaryTag = document.createElement("input");
					primaryTag.type = "hidden";
					primaryTag.id = data[i].tagId;
					primaryTag.name = "primary";
					primaryTag.value = data[i].cacheId;
					form.appendChild(primaryTag);
				}
				primary.setUploadedList(data);
			}
		}
	});
	<% } %>
}
	
load();

//첨부파일 업로드 시
function fileUpload() {
	var file = [];
	for (var i = 0; i < primary.uploadedList.length; i++) {
		file[i] = primary.uploadedList[i].cacheId;
	}
	return file;
}
</script>