<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">
<%-- <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css"> --%>

<div id="dlg-toolbar" style="height:auto">
	<table>
		<tr>
			<td>
				<c:if test="${addteacher eq '1'}">
				<a href="javascript:void(0);" onclick="window.location.href='${pageContext.request.contextPath}/users/users'" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
				</c:if>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="submitForm()">保存</a>
				<a onclick="reloaddatalist('fromUser')" class="easyui-linkbutton from fromUser" data-options="iconCls:'icon-add',plain:true,disabled:true">编辑用户课程权限</a>
				<a onclick="reloaddatalist('fromUnit')" class="easyui-linkbutton from fromUnit" data-options="iconCls:'icon-add',plain:true">从本学院添加课程权限</a>
				<a onclick="reloaddatalist('fromOtherUnit')" class="easyui-linkbutton from fromOtherUnit" data-options="iconCls:'icon-add',plain:true">跨学院添加课程权限</a>
				<input class="easyui-searchbox" id="searchFilter" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"></input>
			</td>
		</tr>
		<tr>
			<td>
				<span>用户名：&nbsp;${users.username}&nbsp;&nbsp;&nbsp;</span>
				<span>用户实名：&nbsp;${users.realname}&nbsp;&nbsp;&nbsp;</span>
				<span>所属教学单位：&nbsp;${users.unit}&nbsp;&nbsp;&nbsp;</span>
				<span>所属科室：&nbsp;${users.dep}&nbsp;&nbsp;&nbsp;</span>
				<span>角色：&nbsp;${users.role_cname}&nbsp;&nbsp;&nbsp;</span>
				<input type="hidden" id="rid" value="${users.roleID}"/>
				<input type="hidden" id="uid" value="${users.id}"/>
				<input type="hidden" id="username" value="${users.username}"/>
				<input type="hidden" id="add" value="${add}"/>
				<input type="hidden" id="type" value="fromUser"/>
			</td>
		</tr>
	</table>
<!-- 	<div style="margin-top:-2px;margin-bottom:20px"> -->
<!-- 		<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a> -->
<!-- 		<!-- <a href="${pageContext.request.contextPath}/users/users" class="easyui-linkbutton"  -->
<!-- 		data-options="iconCls:'icon-back',plain:true">返回教师列表</a> --> 
<!-- 		<a href="javascript:void(0)" class="easyui-linkbutton"  -->
<!-- 		data-options="iconCls:'icon-save',plain:true" onclick="submitForm()">保存</a> -->
<!-- 		<a onclick="reloaddatalist('fromUser')" class="easyui-linkbutton from fromUser" -->
<!-- 		data-options="iconCls:'icon-add',plain:true,disabled:true">编辑用户课程权限</a> -->
<!-- 		<a onclick="reloaddatalist('fromUnit')" class="easyui-linkbutton from fromUnit"  -->
<!-- 		data-options="iconCls:'icon-add',plain:true">从本学院添加课程权限</a> -->
<!-- 		<a onclick="reloaddatalist('fromOtherUnit')" class="easyui-linkbutton from fromOtherUnit"  -->
<!-- 		data-options="iconCls:'icon-add',plain:true">跨学院添加课程权限</a> -->
<!-- 	</div> -->
<!-- 	<div> -->
<%-- 		<span>用户名：&nbsp;${users.username}&nbsp;&nbsp;&nbsp;</span> --%>
<%-- 		<span>用户实名：&nbsp;${users.realname}&nbsp;&nbsp;&nbsp;</span> --%>
<%-- 		<span>所属教学单位：&nbsp;${users.unit}&nbsp;&nbsp;&nbsp;</span> --%>
<%-- 		<span>所属科室：&nbsp;${users.dep}&nbsp;&nbsp;&nbsp;</span> --%>
<%-- 		<span>角色：&nbsp;${users.role_cname}&nbsp;&nbsp;&nbsp;</span> --%>
<%-- 		<input type="hidden" id="rid" value="${users.roleID}"/> --%>
<%-- 		<input type="hidden" id="uid" value="${users.id}"/> --%>
<%-- 		<input type="hidden" id="username" value="${users.username}"/> --%>
<%-- 		<input type="hidden" id="add" value="${add}"/> --%>
<!-- 		<input type="hidden" id="type" value="fromUser"/> -->
<!-- 	</div> -->
	
<%-- <form id="perForm" method="post" action="${pageContext.request.contextPath}/users/addPermission"> --%>
<!-- 	<table style="width:1400px;display:none;" class="table table-striped table-hover table-bordered" align="center"> -->
<!-- 		<tr> -->
<!-- 			<td><input class="selectAll" type="checkbox"/></td> -->
<!-- 			<td style="width:50px;text-align:center;vertical-align:middle;">编号</td> -->
<!-- 			<td style="width:240px;text-align:center;vertical-align:middle;">课程名</td> -->
<!-- 			<td style="width:140px;text-align:center;vertical-align:middle;">院系单位</td> -->
<!-- 			<td style="width:140px;text-align:center;vertical-align:middle;">院系部门</td> -->
<!-- 			<td style="width:1300px;text-align:center;vertical-align:middle;">权限</td> -->
<!-- 		</tr> -->
<%-- 		<c:forEach var="course" items="${courseList}" varStatus="c"> --%>
<!-- 			<tr class="coursePer"> -->
<%-- 				<td style="width:50px;text-align:center;vertical-align:middle;"><input class="cid" type="checkbox" name="cid" value="${course.CID}" checked="checked"/></td> --%>
<%-- 				<td style="width:50px;text-align:center;vertical-align:middle;">${c.index + 1}</td> --%>
<%-- 				<td style="width:50px;text-align:center;vertical-align:middle;">${course.CNAME}</td> --%>
<%-- 				<td style="width:50px;text-align:center;vertical-align:middle;">${course.UNAME}</td> --%>
<%-- 				<td style="width:50px;text-align:center;vertical-align:middle;">${course.DNAME}</td> --%>
<!-- 				<td> -->
<%-- 					课程<c:forEach var="cper" items="${applicationScope.coursePermissions}"> --%>
<%-- 						<c:choose> --%>
<%-- 						    <c:when test="${cper.ID == 11}"> --%>
<%-- 						    	<label><input class="per cview" type="checkbox" name="cper" value="${cper.ID}"/>${cper.NAME}</label> --%>
<%-- 						    </c:when> --%>
<%-- 						    <c:otherwise> --%>
<%-- 						    	<label><input class="per" type="checkbox" name="cper" value="${cper.ID}"/>${cper.NAME}</label> --%>
<%-- 						    </c:otherwise> --%>
<%-- 					    </c:choose> --%>
<%-- 					</c:forEach></br> --%>
<%-- 					试题<c:forEach var="qper" items="${applicationScope.questionPermissions}">						 --%>
<%-- 						<c:choose> --%>
<%-- 						    <c:when test="${qper.ID == 21}"> --%>
<%-- 						    	<label><input class="per qview" type="checkbox" name="qper" value="${qper.ID}"/>${qper.NAME}</label> --%>
<%-- 						    </c:when> --%>
<%-- 						    <c:otherwise> --%>
<%-- 						    	<label><input class="per" type="checkbox" name="qper" value="${qper.ID}"/>${qper.NAME}</label> --%>
<%-- 						    </c:otherwise> --%>
<%-- 					    </c:choose> --%>
<%-- 					</c:forEach></br> --%>
<%-- 					试卷<c:forEach var="pper" items="${applicationScope.paperPermissions}"> --%>
<%-- 						<c:choose> --%>
<%-- 						    <c:when test="${pper.ID == 31}"> --%>
<%-- 								<label><input class="per pview" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label> --%>
<%-- 						    </c:when> --%>
<%-- 						    <c:otherwise> --%>
<%-- 								<label><input class="per" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label> --%>
<%-- 						    </c:otherwise> --%>
<%-- 					    </c:choose> --%>
<%-- 					</c:forEach> --%>
<!-- 				</td> -->
<!-- 			</tr> -->
<%-- 		</c:forEach> --%>
<!-- 	</table> -->
<!-- </form> -->
</div>
<div id="perlist" style="display:none;">
	课程<c:forEach var="cper" items="${applicationScope.coursePermissions}">
		<c:choose>
		    <c:when test="${cper.ID == 11}">
		    	<label><input class="per cview" type="checkbox" name="cper" value="${cper.ID}"/>${cper.NAME}</label>
		    </c:when>
		    <c:otherwise>
		    	<label><input class="per" type="checkbox" name="cper" value="${cper.ID}"/>${cper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach></br>
	试题<c:forEach var="qper" items="${applicationScope.questionPermissions}">						
		<c:choose>
		    <c:when test="${qper.ID == 21}">
		    	<label><input class="per qview" type="checkbox" name="qper" value="${qper.ID}"/>${qper.NAME}</label>
		    </c:when>
		    <c:otherwise>
		    	<label><input class="per" type="checkbox" name="qper" value="${qper.ID}"/>${qper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach></br>
	试卷<c:forEach var="pper" items="${applicationScope.paperPermissions}">
		<c:choose>
		    <c:when test="${pper.ID == 31}">
				<label><input class="per pview" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label>
		    </c:when>
		    <c:otherwise>
				<label><input class="per" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label>
		    </c:otherwise>
	    </c:choose>
	</c:forEach>
</div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script> --%>
<script type="text/javascript">
$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();
	var add = $("#add").val();
	if(add!=''){
		toastr.success('权限更新成功，重新登录后生效！');
	}
});


$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		nowrap:true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/users/editUserPermissionLoad',
		pagination: true,
		rownumbers: false,
		pageSize: 30,
		pageList:[10,20,30,50,70,100,150],
		fitColumns: true,
		queryParams: {
			tid : $("#uid").val(),
			type : $("#type").val()
		},
		toolbar:'#dlg-toolbar',
		columns:[[
				{field:'CID',width:5,align:'center',title: `<input type="checkbox" id="selectAllCheckbox" onclick="toggleAllCheckboxes(this)">`,
					formatter:function(value,row,index){
					var checkbox = null;
					if($("#type").val()=='fromUser'){
						checkbox = "<input type='checkbox' name='cid' id='cid"+row.CID+"' value='"+row.CID+"' checked='checked'/>";
					}else{
						checkbox = "<input type='checkbox' name='cid' id='cid"+row.CID+"' value='"+row.CID+"'/>";
					}
					return checkbox;
				}},
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'num',title:'编号',width:10,align:'center',formatter:function(value,row,index){
					var options = $("#datalist").datagrid('getPager').data("pagination").options; 
					var currentPage = options.pageNumber;
					if(currentPage==0){
				     	currentPage=1;
				     }
					var pageSize = options.pageSize;
					return (pageSize * (currentPage -1))+(index+1);
	          }},
	          {field:'cname',title:'课程名',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.CNAME;
	          }},
	          {field:'uname',title:'院系单位',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.UNAME;
	          }},
	          {field:'dname',title:'院系部门',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.DNAME;
	          }},
	          {field:'permission',title:'权限',width:130,align:'left',formatter:function(value,row,index){
	          	  var perlist = '<div class="coursePer"><input type="hidden" name="cid2" value="'+row.CID+'"/>'+$("#perlist").html()+'</div>';	
	          	  return perlist;
	          }},
	    ]],
	    onLoadSuccess:function(data){ 
            loadRole();
	    }
	});
});

function toggleAllCheckboxes(myself) {
	const $myself = $(myself);
	$.each($('.coursePer'), function (i, item) {
		var coursePer = $(item);
		var cid2 = coursePer.find('input[name="cid2"]');
		var cid = $("#cid" + cid2.val());
		if (!$myself.prop('checked') && cid.prop('checked')) {
			cid.prop('checked', false);
		} else if($myself.prop('checked') && !cid.prop('checked')){
			cid.prop('checked', true);
		}
		rolefunction(cid, coursePer);
	});
}


function reloaddatalist(type){
	$(".from").linkbutton("enable");
	$("."+type).linkbutton("disable");
	$("#type").val(type);
	$('#datalist').datagrid({
		queryParams: {
			tid : $("#uid").val(),
			type : $("#type").val()
		}
	});
}
function doSearch(value,name){
	var type=$("#type").val();
	$('#datalist').datagrid({
		queryParams: {
			tid : $("#uid").val(),
			type : type,
			cname:value
		}
	});
}

/*
$('.selectAll').click(function(){
	if($(this).attr('checked')){
		$.each($('.coursePer'),function(i,item){
			var coursePer = $(item);
			var cid = coursePer.find('.cid');
			cid.attr('checked','checked');
			rolefunction(cid, coursePer);
		});
	}else{
		$.each($('.coursePer'),function(i,item){
			var coursePer = $(item);
			var cid = coursePer.find('.cid');
			cid.removeAttr('checked');
			rolefunction(cid, coursePer);
		});
	}
});
*/

function loadRole(){
$.each($('.coursePer'),function(i,item){
	var coursePer = $(item);
	var cid2 = coursePer.find('input[name="cid2"]');
	var cid = $("#cid"+cid2.val());
	var uid = $("#uid").val();
	var sumP=[];
	
	if($("#type").val()=='fromUser'){
		$.ajax({
	        url: "${pageContext.request.contextPath}/permission/getPermissionsByRIDAndCID",
	        async: false,//改为同步方式
	        type: "POST",
	        data: {"cid":cid2.val(),"uid":uid},
	        success: function (data) {
	        	cid.data('pers', data);
	        	sumP=rolefunction(cid, coursePer);
	 		}
	 	});
	}else{
		$.ajax({
	        url: "${pageContext.request.contextPath}/permission/getPermissionsByRID",
	        async: false,//改为同步方式
	        type: "POST",
	        data: {rid:$('#rid').val()},
	        success: function (data) {
	        	cid.data('pers',data);
	        	sumP=rolefunction(cid, coursePer);
	 		}
	 	});	
	}
	cid.click(function(){
		sumP=rolefunction($(this), coursePer);		
	});
	/*
	$.each(coursePer.find('.per'),function(i,item){
		carr = new Array('10','12','13','21');
		qarr = new Array('20','22','23','24','25','26','27','28','29','210');
		parr = new Array('33','34','35','36','37');

		c_all=new Array('10','11','12','13');
		q_all = new Array('20','21','22','23','24','25','26','27','28','29','210');
		p_all = new Array('33','34','35','36','37');
		
		$(item).click(function(){
			var val = $(item).val();
			if($(item).attr('checked')){
				sumP.push(val);
				perLock(coursePer,carr,qarr,parr,sumP);
			}else{
				for(var i=0;i<=sumP.length;i++){
					if(val==sumP[i]){
						sumP.splice(i,1);
					}
				}
				if(findRepeat(sumP, carr) == 0){
					coursePer.find('.cview').removeAttr('disabled'); 
				}
				if(findRepeat(sumP, qarr) == 0){
					coursePer.find('.qview').removeAttr('disabled');
				}
				if(findRepeat(sumP, parr) == 0){
					coursePer.find('.pview').removeAttr('disabled'); 
				}
			}
		});
	});*/
});
}

function rolefunction(cid, coursePer){
	var roleData = cid.data('pers');	
	carr = new Array('10','12','13','21');
	qarr = new Array('20','22','23','24','25','26','27','28','29','210');
	parr = new Array('33','34','35','36','37');
	sumP=[];
	if(cid.prop('checked')){
		coursePer.find('.per').removeAttr('disabled');
		if(roleData != null){
			coursePer.find('.per').removeAttr('checked');
			for(var i=0; i<roleData.length; i++){
				var rid = roleData[i].id;
				$.each(coursePer.find('.per'),function(i,item){
					//console.log($(item).val() + '=======' + rid);
					val = $(item).val();
					if(val == rid){
						$(item).attr('checked','checked'); 
						sumP.push(val);
					}
				});
        	}
		}
	}else{
		coursePer.find('.per').prop('checked', false);
		coursePer.find('.per').removeAttr("disabled");
	}
	//perLock(coursePer,carr,qarr,parr,sumP);
	return sumP;
}

function submitForm(){
	
	var params = {};
	var data = [];
	$.each($('.coursePer'),function(i,cour){
		var cid = $(cour).find('input[name="cid2"]').val();
		var per = [];
		var p = {};			

		
　           $.each($(cour).find('.per'),function(i,item){
　        	     //if($('#cid'+_cid).prop('checked')){	    	      
		       		if($(item).prop('checked')){
		    	   		per.push($(item).val());					
					}
　        	     //}
        	})      
		p["cid"] = cid;  
		p["cper"] = per; 
		data.push(p);
	});
	params["data"] = data;
	params["uid"] = $('#uid').val();
	params["rid"] = $('#rid').val(); 
	params["username"] = $('#username').val(); 
	$.ajax({
		contentType: "application/json; charset=utf-8",
        url: "${pageContext.request.contextPath}/users/addPermission",
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
    		window.location.href="${pageContext.request.contextPath}/users/editUserPermission?id="+$('#uid').val()+"&addteacher=${addteacher}";
    		toastr.success('权限更新成功，重新登录后生效！');
 		}
 	});	
}

function perLock(coursePer,carr,qarr,parr,sumP){
	if(findRepeat(sumP, carr) > 0){
		coursePer.find('.cview').attr('checked','checked'); 
		coursePer.find('.cview').attr('disabled','disabled'); 
		if($.inArray('11', sumP) == -1){
			sumP.push('11');
		}
	}
	if(findRepeat(sumP, qarr) > 0){
		coursePer.find('.qview').attr('checked','checked'); 
		coursePer.find('.qview').attr('disabled','disabled'); 
		coursePer.find('.cview').attr('checked','checked'); 
		coursePer.find('.cview').attr('disabled','disabled');
		if($.inArray('11', sumP) == -1){
			sumP.push('11');
		}
		if($.inArray('21', sumP) == -1){
			sumP.push('21');
		}
	}
	if(findRepeat(sumP, parr) > 0){
		coursePer.find('.pview').attr('checked','checked');
		coursePer.find('.pview').attr('disabled','disabled'); 
		if($.inArray('31', sumP) == -1){
			sumP.push('31');
		}
	}
}

function findRepeat(a,b){
	var r=0;
	for(var i=0;i<a.length;i++){
		for(var j=0;j<b.length;j++){
			if(a[i]==b[j]){
				r++;
			}
		}
	}
	return r;
}

</script>	