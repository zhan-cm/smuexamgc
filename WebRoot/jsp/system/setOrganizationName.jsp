<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
td{
	font-size: 12px;
}
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 8px;
	width:100%;
}
table td, th {
	padding: 5px;
	line-height: 1.2;
	vertical-align: center;
	border-top: 1px solid #ddd; 
	border-radius: 8px;
}

table input[type="text"] {
	border: 1px solid #ddd;
	background: #FBFBFB;
	width:400px;
	outline: 0;
	-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	font: 200 12px/25px Arial, Helvetica, sans-serif;
	margin: 2px;	
	border-radius: 4px;
	padding:2px 4px;
}
</style>
<div>
	<form id="AForm" method="post" action="">
		<table>
			<tr>
				<td colspan="2" style="text-align:center;font-size:16px;font-weight:bold;">学校名称参数设置</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">学校名称：</td>
				<td width="80%"><input type="text" name="param" id="param" value="${info.PARAM }"/>*必填（备注，学校名称会出现在系统标题栏等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">学校英文名称：</td>
				<td width="80%"><input type="text" name="param_en" id="param_en" value="${info_en.PARAM }"/>*必填（备注，英文名称会出现在考试端英文版标题栏等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">联系人：</td>
				<td width="80%"><input type="text" name="yl_1" value="${info.YL_1 }"/>（备注，会出现在系统登录页等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">联系电话：</td>
				<td width="80%"><input type="text" name="yl_2" value="${info.YL_2 }"/>（备注，会出现在系统登录页等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">联系email：</td>
				<td width="80%"><input type="text" name="yl_3" value="${info.YL_3 }"/>（备注，会出现在系统登录页等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td style="text-align:right;width:20%;">QQ群：</td>
				<td width="80%"><input type="text" name="yl_4" value="${info.YL_4 }"/>（备注，会出现在系统登录页等多处地方，请认真填写）</td>
			</tr>
			<tr>
				<td width="20%" style="text-align:right;width:20%;">系统安装时间：</td>
				<td width="80%"><input type="text" name="yl_5" value="${info.YL_5 }"/>（备注，此处请联系软件厂家人员填写，或空白）</td>
			</tr>
			<tr><td colspan="2" style="text-align:center;"><input type="button" value="更新" onclick="submitAForm()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="返回" onclick="javascript:history.go(-1);"/></td></tr>
		</table>
	</form>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
});

function submitAForm(){
	$('#AForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/updateOrganizationName',
	    onSubmit: function(){	    	
	    	if($("#param").val()==""){
	    		toastr.warning('学校名称不能为空！');
	    		return false;
	    	}
	    	if($("#param_en").val()==""){
	    		toastr.warning('学校英文名称不能为空！');
	    		return false;
	    	}
	    },
	    success:function(data){
	    	if(data=="success"){
	    		toastr.success('修改成功！');
	    	}else{
	    		toastr.error('修改失败！');
	    	}        	
	    }
	});
}
</script>	