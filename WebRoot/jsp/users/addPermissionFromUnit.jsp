<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">	
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">

<div id="dlg-toolbar" style="height:26px;">
	<div class="col-lg-5 col-md-5 col-sm-5 col-xs-5" style="margin-top:-7px;margin-bottom:20px">
		<!-- <a href="${pageContext.request.contextPath}/users/users" class="easyui-linkbutton" 
		data-options="iconCls:'icon-back',plain:true">返回教师列表</a> -->
		<a href="javascript:void(0);" onclick="history.go(-1);" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-save',plain:true" onclick="submitForm()">保存</a>
		<a href="${pageContext.request.contextPath}/users/addPerFromOtherUnit?id=${users.id}" class="easyui-linkbutton" 
		data-options="iconCls:'icon-add',plain:true">跨学院添加课程权限</a>
		
	</div>
	<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
		<span>用户名：&nbsp;${users.username}&nbsp;&nbsp;&nbsp;</span>
		<span>用户实名：&nbsp;${users.realname}&nbsp;&nbsp;&nbsp;</span>
		<span>所属教学单位：&nbsp;${users.unit}&nbsp;&nbsp;&nbsp;</span>
		<span>所属科室：&nbsp;${users.dep}&nbsp;&nbsp;&nbsp;</span>
		<span>角色：&nbsp;${users.role_cname}&nbsp;&nbsp;&nbsp;</span>
		<input type="hidden" id="rid" value="${users.roleID}"/>
		<input type="hidden" id="uid" value="${users.id}"/>
		<input type="hidden" id="username" value="${users.username}"/>
	</div>
<form id="perForm" method="post" action="${pageContext.request.contextPath}/users/addPermission">
	<table style="width:1400px;" class="table table-striped table-hover table-bordered" align="center">
		<tr>
			<td><input class="selectAll" type="checkbox"/></td>
			<td style="width:50px;text-align:center;vertical-align:middle;">编号</td>
			<td style="width:240px;text-align:center;vertical-align:middle;">课程名</td>
			<td style="width:140px;text-align:center;vertical-align:middle;">院系单位</td>
			<td style="width:140px;text-align:center;vertical-align:middle;">院系部门</td>
			<td style="width:1300px;text-align:center;vertical-align:middle;">权限</td>
		</tr>
		<c:forEach var="course" items="${courseList}" varStatus="c">
			<tr class="coursePer">
				<td style="width:50px;text-align:center;vertical-align:middle;"><input class="cid" type="checkbox" name="cid" value="${course.CID}"/></td>
				<td style="width:50px;text-align:center;vertical-align:middle;">${c.index + 1}</td>
				<td style="width:50px;text-align:center;vertical-align:middle;">${course.CNAME}</td>
				<td style="width:50px;text-align:center;vertical-align:middle;">${course.UNAME}</td>
				<td style="width:50px;text-align:center;vertical-align:middle;">${course.DNAME}</td>
				<td>
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
					试卷<c:forEach var="pper" items="${paperPermissions}">
						<c:choose>
						    <c:when test="${pper.ID == 31}">
								<label><input class="per pview" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label>
						    </c:when>
						    <c:otherwise>
								<label><input class="per" type="checkbox" name="pper" value="${pper.ID}"/>${pper.NAME}</label>
						    </c:otherwise>
					    </c:choose>
					</c:forEach>
				</td>
			</tr>
		</c:forEach>
	</table>
</form>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
var roleData = null;
$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();
	
	$.ajax({
        url: "${pageContext.request.contextPath}/permission/getPermissionsByRID",
        async: false,//改为同步方式
        type: "POST",
        data: {rid:$('#rid').val()},
        success: function (data) {
        	roleData = data;        	
 		}
 	});		
});

$('.selectAll').click(function(){
	if($(this).attr('checked')){
		$.each($('.coursePer'),function(i,item){
			var coursePer = $(item);
			var cid = coursePer.find('.cid');
			cid.attr('checked','checked');
			sumP=rolefunction(cid, coursePer);
		});
	}else{
		$.each($('.coursePer'),function(i,item){
			var coursePer = $(item);
			var cid = coursePer.find('.cid');
			cid.removeAttr('checked');
			sumP=rolefunction(cid, coursePer);
		});
	}
});

$.each($('.coursePer'),function(i,item){
	var coursePer = $(item);
	var cid = coursePer.find('.cid');
	cid.click(function(){
		rolefunction($(this), coursePer);		
	});
	$.each(coursePer.find('.per'),function(i,item){
		//console.log($(item))
		carr = new Array('10','12','13','21');
		qarr = new Array('20','22','23','24','25','26','27','28','29','210');
		parr = new Array('33','34','35','36','37');
		coursePer.find('.per').attr('disabled','disabled'); 
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
	});
});

function rolefunction(cid, coursePer){
	carr = new Array('10','12','13','21');
	qarr = new Array('20','22','23','24','25','26','27','28','29','210');
	parr = new Array('33','34','35','36','37');
	sumP=[];
	if(cid.attr('checked')){
		//console.log('checked');
		coursePer.find('.per').removeAttr('disabled');
		if(roleData != null){
			coursePer.find('.per').removeAttr('checked');
			for(var i=0; i<roleData.length; i++){
				var rid = roleData[i].id;
				$.each(coursePer.find('.per'),function(i,item){
					//console.log($(item).val() + '=======' + rid);
					if($(item).val() == rid){
						$(item).attr('checked','checked'); 
						sumP.push($(item).val());
					}
				});
        	}
		}
	}else{
		coursePer.find('.per').removeAttr('checked');
		coursePer.find('.per').attr('disabled','disabled'); 
	}
	perLock(coursePer,carr,qarr,parr,sumP);
	return sumP;
}

function submitForm(){
	
	var params = {};
	var data = [];
	$.each($('.coursePer'),function(i,item){
		var c = $(item);
		var cid = c.find('.cid');
		var per = [];
		var p = {};			
		$.each(c.find('.per'),function(i,item){
			if($(item).attr('checked')){
				per.push($(item).val());
				//console.log($(item).val());
			}
		})
		p["cid"] = cid.val();  
		p["cper"] = per; 
		data.push(p);
		//console.log(cper);
		//data.push(cper);
	});
	params["data"] = data;
	params["uid"] = $('#uid').val();
	params["rid"] = $('#rid').val(); 
	params["username"] = $('#username').val(); 
	//console.log(JSON.stringify(params));
	//$('#perForm').submit();
	$.ajax({
		contentType: "application/json; charset=utf-8",
        url: "${pageContext.request.contextPath}/users/addPermission",
        async: false,//改为同步方式
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
        	//console.log(data);
    		//$('#datalist').datagrid('reload');
    		location.href="${pageContext.request.contextPath}/users/editUserPermission?id="+$("#uid").val()+"&add=1";
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

