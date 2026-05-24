<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.elegant-aero {
	margin-left: auto;
	margin-right: auto;
	max-width: auto;
	padding: 20px 20px 20px 20px;
	font: 12px Arial, Helvetica, sans-serif;
	color: #666;
	border-radius: 8px;
}
.elegant-aero h1 {
	font: 24px "Trebuchet MS", Arial, Helvetica, sans-serif;
	padding: 10px 10px 10px 20px;
	display: block;
	border-bottom: 1px solid #B8DDFF;
	margin: -20px -20px 15px;
	border-top-left-radius:8px;
	border-top-right-radius:8px;
	text-align:center;
}
.elegant-aero h1>span {
	display: block;
	font-size: 11px;
}
.elegant-aero label>span {
	float: left;
	margin-top: 10px;
}
.elegant-aero label {
	display: block;
	margin: 0px 0px 3px;
}
.elegant-aero label>span {
	float: left;
	width: 20%;
	text-align: right;
	padding-right: 15px;
	margin-top: 10px;
	font-weight: bold;
}
.elegant-aero input[type="text"], .elegant-aero input[type="password"], .elegant-aero input[type="email"],
	.elegant-aero textarea, .elegant-aero select {
	color: #888;
	width: 70%;
	padding: 0px 0px 0px 5px;
	border: 1px solid #C5E2FF;
	background: #FBFBFB;
	outline: 0;
	-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	font: 200 12px/25px Arial, Helvetica, sans-serif;
	height: 30px;
	line-height: 15px;
	margin: 2px 6px 16px 0px;	
	border-radius: 4px;
}
.elegant-aero textarea {
	height: 100px;
	padding: 5px 0px 0px 5px;
	width: 70%;	
	border-radius: 4px;
}
.elegant-aero .unedit {
	background: none !important;
	border: none !important;
	color: #333 !important;
	outline:none !important;
	-webkit-box-shadow:none !important;
	box-shadow:none !important;
}
.elegant-aero select {
	appearance: none;
	-webkit-appearance: none;
	-moz-appearance: none;
	text-indent: 0.01px;
	text-overflow: '';
	width: 70%;
	border-radius: 4px;
}
.elegant-aero .button {
	padding: 10px 30px 10px 30px;
	background: #66C1E4;
	border: none;
	color: #FFF;
	box-shadow: 1px 1px 1px #4C6E91;
	-webkit-box-shadow: 1px 1px 1px #4C6E91;
	-moz-box-shadow: 1px 1px 1px #4C6E91;
	text-shadow: 1px 1px 1px #5079A3;
}
.elegant-aero .button:hover {
	background: #3EB1DD;
}
.elegant-aero .roleBlock{
	float:left;
	margin-bottom: 16px;
}
.elegant-aero .roleBlockClear{
	clear:both;
}
</style>
<form id="userForm" method="post" class="elegant-aero"
	action="${pageContext.request.contextPath}/users/updateUserPassword">
	<!-- <h1>编辑个人信息</h1> -->
	<div class="roleBlockClear"></div>	
	<label> 
		<span>用户名 :</span> 
		<input type="text" name="" class="unedit" disabled="disabled" value="${users.username}" />
	</label> 
	<label> 
		<span>用户实名 :</span> 
		<input type="text" name="realname" disabled="disabled" value="${users.realname}" autocomplete="new-password"/>
	</label> 
	<label> 
		<span>登录密码 :</span> 	
		<input type="password" name="password" value="" autocomplete="new-password"/>
	</label> 
	<label> 
		<span>确认密码 :</span> 
		<input type="password" name="confirmPass" value="" autocomplete="new-password"/>
	</label> 
	<input type="hidden" id="error" value="${updateError}"/>
	<input type="hidden" name="username" value="${users.username}"/>
	<input type="hidden" name="salt" value="${users.salt}"/>
	<input type="hidden" name="id" value="${users.id}"/>
</form>

<div style="text-align: center; padding: 5px">
	<a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-save'" onclick="submitForm()">保存</a> 
	<!-- <a href="${pageContext.request.contextPath}/users/users"
		class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a> -->
	<!-- <a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-reload'" onclick="window.location.reload();">刷新</a> -->
</div>


<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var info = $('#error').val();
		if(info=="更新成功"){
			toastr.success(info);
		}else if(info){
			toastr.warning(info);
		}
	});
	
	function submitForm() {
	    var username = $('input[name="username"]');
		var pass = $('input[name="password"]');
		var confirmPass = $('input[name="confirmPass"]').val();
		var tel = $('input[name="tel"]').val();
        if(${pass_switch==1}){
            var reg=new RegExp(/^(?=.*[A-Za-z])(?=.*\d)[^]{8,32}$/);
            if(!reg.test(pass.val())||(pass.val()).length<8){
                toastr.warning("密码必须包含字母、数字、特殊符号,且不少于8个字符！");
                return;
            }
            var reg2 = new RegExp("[`~!@#$%^&*()=|{}':;',\\[\\].<>《》/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？ ]")
            if(!reg2.test(pass.val())){
                toastr.warning("密码必须包含字母、数字、特殊符号,且不少于8个字符！");
                return;
            }
        }else{
            var reg=new RegExp(/^(?=.*[0-9].*)(?=.*[A-Za-z].*).{6,20}$/);
            if(!reg.test(pass.val())||(pass.val()).length<6){
                toastr.warning("密码必须包含字母、数字，且不少于6个字符。");
                return;
            }
        }

		var reg3 = new RegExp(username.val());
		if(reg3.test(pass.val())){
            toastr.warning("密码不可以包含用户名！");
            return;
		}
        if(pass.val()!=confirmPass){
			toastr.warning("确认密码必须与密码相同");
			return;
		}
		
		$('#userForm').submit();

	}


</script>