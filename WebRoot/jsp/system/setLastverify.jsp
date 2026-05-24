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

table select {
	border: 1px solid #ddd;
	background: #FBFBFB;
	width:200px;
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
				<td colspan="2" style="text-align:center;font-size:16px;font-weight:bold;">默认审核试卷账号设置</td>
			</tr>
			<tr>
				<td style="text-align:right;width:50%;">教务人员用户名：</td>
				<td style="width: 50%">
					<input type="text" name="username" id="username" value="${lastverify}" />
				</td>
			</tr>
			<tr>
				<td style="text-align:right;width:50%;">教务人员用户名2：</td>
				<td style="width: 50%">
					<input type="text" name="username2" id="username2" value="${lastverify2}" />
				</td>
			</tr>
			<tr>
				<td style="text-align:right;width:50%;">教务人员用户名3：</td>
				<td style="width: 50%">
					<input type="text" name="username3" id="username3" value="${lastverify3}" />
				</td>
			</tr>
			<tr>
				<td style="text-align:right;width:50%;">教务人员用户名4：</td>
				<td style="width: 50%">
					<input type="text" name="username4" id="username4" value="${lastverify4}" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center;"><input type="button" value="更新" onclick="submitAForm()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="返回" onclick="javascript:history.go(-1);"/></td>
			</tr>
		</table>
	</form>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
function submitAForm(){
	$('#AForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/updateLastverify',
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