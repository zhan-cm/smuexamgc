<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<div id="dlg-toolbar" style="height:auto">
	<table>
		<tr>
			<td>
				<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>	
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="submitForm()">保存</a>
				<!-- <a onclick="reloaddatalist('fromUser')" class="easyui-linkbutton from fromUser" data-options="iconCls:'icon-add',plain:true,disabled:true">编辑用户课程权限</a>
				<a onclick="reloaddatalist('fromUnit')" class="easyui-linkbutton from fromUnit" data-options="iconCls:'icon-add',plain:true">从本学院添加课程权限</a>
				<a onclick="reloaddatalist('fromOtherUnit')" class="easyui-linkbutton from fromOtherUnit" data-options="iconCls:'icon-add',plain:true">跨学院添加课程权限</a> -->
			</td>
		</tr>
	</table>
</div>
<div id="perlist" style="display:none;">
	课程<c:forEach var="cper" items="${applicationScope.coursePermissions}">
		<c:choose>
		    <c:when test="${cper.ID == 11}">
		    	<label><input class="per cview" type="checkbox" name="cper_${cper.ID}" value="${cper.ID}"/>${cper.NAME}</label>
		    </c:when>
		    <c:otherwise>
		    	<label><input class="per" type="checkbox" name="cper_${cper.ID}" value="${cper.ID}"/>${cper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach></br>
	试题<c:forEach var="qper" items="${applicationScope.questionPermissions}">						
		<c:choose>
		    <c:when test="${qper.ID == 21}">
		    	<label><input class="per qview" type="checkbox" name="qper_${qper.ID}" value="${qper.ID}"/>${qper.NAME}</label>
		    </c:when>
		    <c:otherwise>
		    	<label><input class="per" type="checkbox" name="qper_${qper.ID}" value="${qper.ID}"/>${qper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach></br>
	试卷<c:forEach var="pper" items="${applicationScope.paperPermissions}">
		<c:choose>
		    <c:when test="${pper.ID == 31}">
				<label><input class="per pview" type="checkbox" name="pper_${pper.ID}" value="${pper.ID}"/>${pper.NAME}</label>
		    </c:when>
		    <c:otherwise>
				<label><input class="per" type="checkbox" name="pper_${pper.ID}" value="${pper.ID}"/>${pper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach>
</div>
<table id="datalist"></table>
<script type="text/javascript">
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		nowrap:true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getTeacherPermission',
		pagination: true,
		rownumbers: false,
		pageSize: 30,
		pageList:[10,20,30,50,70,100,150],
		fitColumns: true,
		queryParams: {},
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'NAME',title:'角色名',width:20,align:'center',sortable:false},
	          {field:'permission',title:'权限',width:120,align:'left',formatter:function(value,row,index){
	              if(row.permission) sessionStorage.setItem(row.ID+'_pList',row.permission);
	          	  var perlist = '<div class="rolePer"><input type="hidden" name="rid" value="'+row.ID+'"/>'+$("#perlist").html()+'</div>';
	          	  return perlist;
	          }},
	    ]],
	    onLoadSuccess:function(data){ 
            loadRole();
	    }
	});
});

function loadRole(){
	$.each($('.rolePer'),function(i,item){
		var rid = $(item).find('input[name="rid"]').val();
		var pList=sessionStorage.getItem(rid+'_pList');
		var array=pList.split(";");
		for(var i=0;i<array.length;i++){
			$(item).find('input[name="'+array[i]+'"]').prop("checked","checked");
		}
		
	});
	$(".cview").prop("checked","checked");
	//$(".qview").prop("checked","checked");
	$(".cview").attr('disabled','disabled'); 
	//$(".qview").attr('disabled','disabled');
}

function submitForm(){
	var params = {};
	var data = [];
	$.each($('.rolePer'),function(i,item){
		var per = [];
		var p = {};			
		$.each($(item).find('.per'),function(i){
			if($(this).attr('checked')){
				per.push($(this).val());
			}
		})
		p["rid"] = $(item).find('input[name="rid"]').val();  
		p["per"] = per; 
		data.push(p);
	});
	params["data"] = data;
	$.ajax({
		contentType: "application/json; charset=utf-8",
        url: "${pageContext.request.contextPath}/system/updateTeacherPermission",
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
    		toastr.success('教师默认权限更新成功！');
 		}
 	});	
}

</script>	