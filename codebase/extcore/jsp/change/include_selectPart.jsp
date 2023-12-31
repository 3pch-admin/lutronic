<%@page import="com.e3ps.part.service.PartHelper"%>
<%@page import="com.e3ps.rohs.service.RohsHelper"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="com.e3ps.part.dto.PartDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String oid = request.getParameter("oid");
String mode = request.getParameter("mode");
String moduleType="";
if(request.getParameter("moduleType")!=null){
	moduleType = request.getParameter("moduleType");
}
boolean isView = "view".equals(mode);
boolean isCreate = "create".equals(mode);
boolean isUpdate = "update".equals(mode);
boolean multi = false;
if(request.getParameter("multi")!=null){
	multi = request.getParameter("multi").equals("true") ? true : false;
}
List<PartDTO> partList = PartHelper.service.include_PartList(oid, moduleType);
boolean header = request.getParameter("header")==null ? true : Boolean.parseBoolean(request.getParameter("header"));
%>
<%if(header){%>
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png"> 
				<%if(moduleType.equals("eco") || moduleType.equals("doc") || moduleType.equals("drawing")){%>관련품목<%}else{%>설계변경 부품<%	}%>
			</div>
		</td>
	</tr>
</table>
<%} %>


<table class="create-table">
	<colgroup>
		<col width="150">
		<col width="*">
		<col width="150">
		<col width="*">
	</colgroup>
	<tr>
		<%if(header){%>
		<th class="lb">
			<%
			if(moduleType.equals("eco") || moduleType.equals("doc") || moduleType.equals("drawing")){
			%>
				관련품목
			<%	
			}else{
			%>
				설계변경 부품
			<%	
			}
			%>
			
		</th>
		<%} %>
		<td class="indent5 pt5" colspan="3">
			<%
			if (isCreate || isUpdate) {
			%>
				<input type="button" value="추가" title="추가" class="blue" onclick="insert9();">
				<input type="button" value="삭제" title="삭제" class="red" onclick="deleteRow9();">
			<%
			}
			%>
			<div id="grid_part" style="height: 30px; border-top: 1px solid #3180c3; margin: 5px;"></div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	let partGridID; 
	const columnsPart = [ {
		dataField : "number",
		headerText : "품목번호",
		dataType : "string",
		width : 180,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "name",
		headerText : "품목명",
		dataType : "string",
		style : "aui-left",
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "version",
		headerText : "REV",
		dataType : "string",
		width : 80,
		filter : {
			showIcon : true,
			inline : true
		},
	}, {
		dataField : "bom",
		headerText : "BOM",
		dataType : "string",
		width : 120,
		renderer : {
			type : "ButtonRenderer",
			labelText : "BOM",
			onclick : function(rowIndex, columnIndex, value, item) {
				const oid = item.oid;
				url = getCallUrl("/bom/view?oid=" + oid);
				_popup(url, 1600, 800, "n");
			}
		},		
	}, {
		dataField : "oid",
		visible : false
	} ]

	function createAUIGrid2(columnLayout) {
		const props = {
			headerHeight : 30,
			fillColumnSizeMode : false,
			showRowNumColumn : true,
			rowNumHeaderText : "번호",
			showAutoNoDataMessage : false,
			enableSorting : false,
			softRemoveRowMode : false,
			selectionMode : "multipleCells",
			hoverMode : "singleRow",
			<%if (isCreate || isUpdate) {%>
			showStateColumn : true,
			showRowCheckColumn : true,
			<%}%>
			<%if (!multi) {%>
			rowCheckToRadio : true,
			<%}%>
			enableFilter : true,
			autoGridHeight : true
		}
		partGridID = AUIGrid.create("#grid_part", columnLayout, props);
		<%if (isView || isUpdate) {%>
			let dataList = [];
			<% for(PartDTO part : partList) { %>
				var data = new Object();
				data.number = "<%= part.getNumber() %>"
				data.name = "<%= part.getName() %>"
				data.state = "<%= part.getState() %>"
				data.version = "<%= part.getVersion() %>"
				data.creator = "<%= part.getCreator() %>"
				data.modifyDate = "<%= part.getModifyDate() %>"
				data.oid = "<%= part.getOid() %>"
				dataList.push(data);
			<% } %>
			AUIGrid.setGridData(partGridID, dataList);
		<%}%>
	}

	function insert9() {
		var moduleType = "<%=moduleType%>";
		if(moduleType=="rohs"){
			var grid = AUIGrid.getGridData(partGridID);
			if(grid.length>0){
				alert("품목을 하나이상 추가할 수 없습니다.");
				return false;
			}
		}
			
		const url = getCallUrl("/part/popup?&multi=true&method=append");
		_popup(url, 1500, 700, "n");
	}
	
	function append(items, callBack){
		for(var i=0; i<items.length; i++){
			var data = new Object();
			data.oid = items[i].item.part_oid;
			data.name = items[i].item.name;
			data.number = items[i].item.number;
			data.version = items[i].item.version;
			AUIGrid.addRow(partGridID, data);
		}
		callBack(true);
	}

	function deleteRow9() {
		const checked = AUIGrid.getCheckedRowItems(partGridID);
		if (checked.length === 0) {
			alert("삭제할 행을 선택하세요.");
			return false;
		}

		for (let i = checked.length - 1; i >= 0; i--) {
			var rowIndex = checked[i].rowIndex;
			AUIGrid.removeRow(partGridID, rowIndex);
		}
	}
	
</script>