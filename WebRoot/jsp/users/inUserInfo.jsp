<%@ page pageEncoding="UTF-8"%>
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
	action="${pageContext.request.contextPath}/users/updateUserInfo">
	<!-- <h1>编辑个人信息</h1> -->
	<div class="roleBlock"></div>
	<label> 
		<span>所属教学单位 :</span> 
		<input type="text" id="unit" name="" class="unedit" disabled="disabled" value="${users.unit}"/>
		<input type="hidden" id="unitID" value="${users.unitID}"/>
	</label> 
	<div class="roleBlock"></div>	
	<label> 
		<span>所属科室 :</span> 
		<select id="dept" name="depID" >
		
		</select>
	</label> 
	<div class="roleBlock"></div>
	<label> 
		<span>角色 :</span> 
		<input type="text" name="" class="unedit" disabled="disabled" value="${users.role_cname}">
	</label>
	<div class="roleBlockClear"></div>	
	<label> 
		<span>用户名 :</span> 
		<input type="text" class="unedit" disabled="disabled" value="${users.username}"/>
	</label> 
	<label> 
		<span>用户实名 :</span> 
		<input type="text" name="realname" value="${users.realname}" style="width:60%"/>
	</label>
	<label> 
		<span>身份证号 :</span> 
		<input type="text" name="idcard" id="idcard" value="${users.idcard}" style="width:60%"/>
	</label>  
	<%-- <label> 
		<span>登录密码 :</span> 	
		<input type="password" name="password" value="${users.password}"/>
	</label> 
	<label> 
		<span>确认密码 :</span> 
		<input type="password" name="confirmPass" value="${users.password}"/>
	</label>  --%>
	<label> 
		<span>工作证号 :</span> 
		<c:choose>
			<c:when test="${users.roleID==1}">
				<input type="text" name="num"  value="${users.num}"  style="width:60%"/>
			</c:when>
			<c:otherwise>
				<input type="text" name="num" class="unedit" disabled="disabled" value="${users.num}"/>
			</c:otherwise>
		</c:choose>
		
	</label> 
	<label> 
		<span>email :</span> 
		<input type="text" name="email"  value="${users.email}" style="width:60%"/><a style="color:red" id="emailTips"></a>
	</label>
	<label>
		<span>联系电话 :</span>
		<input type="text" name="tel"  value="${users.tel}" style="width:60%"/><a style="color:red" id="telTips"></a>
	</label>
	<input type="hidden" id="error" value="${updateError}"/>
	<input type="hidden" name="username" value="${users.username}"/>
	<%-- <input type="hidden" name="salt" value="${users.salt}"/> --%>
	<input type="hidden" id="depid" value="${users.depID}"/>
	<input type="hidden" id="depname" value="${users.dep}"/>
	<input type="hidden" id="role" value="${users.roleID}"/>
</form>

<div style="text-align: center; padding: 5px">
	<a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-save'" onclick="submitForm()">保存</a> 
	<!-- <a href="${pageContext.request.contextPath}/users/users"
		class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a> -->
	<!-- <a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-reload'" onclick="window.location.reload();">刷新</a> -->
</div>

<script type="text/javascript">
	$(document).ready(function() {
		var info = $('#error').val();
		if(info=="更新成功"){
			toastr.success(info);
		}else if(info){
			toastr.warning(info);
		}
		
		var tel = $('input[name="tel"]').val();
		if(tel==''){
			$('#telTips').text("请完善手机号码");
		}
		var email = $('input[name="email"]').val();
		if(email==''){
			$('#emailTips').text("请完善电子邮箱");
		}
		
		var u_id = $('#unitID').val();
		getDept(u_id);
	});
	
	function getDept(u_id) {
		var role = $("#role").val();
		$.ajax({
			url : "${pageContext.request.contextPath}/course/getDeptList",
			async : false,
			type : "POST",
			data : {
				"u_id" : u_id
			},
			success : function(data) {
				$("#dept").html(null);
				var str;
				var depid=$("#depid").val();
				str += '<option value='+depid+'>'+$("#depname").val()+'</option>';
				for(var i=0;i<data.length;i++){
					if(depid!=data[i].ID){
						if(role <= 3 || role == 6){
							str += '<option value='+data[i].ID+'>'+data[i].NAME+'</option>';
						}
					}					
				}
				$("#dept").append(str);
			}
		});
	}
	
	function submitForm() {
		/* var pass = $('input[name="password"]');
		var confirmPass = $('input[name="confirmPass"]').val();
		if ((pass.val()).length<6){
			toastr.warning("密码长度不能小于6位"); 
			return;
		}
		var reg= new RegExp(/^[A-Za-z0-9\u4e00-\u9fa5]+$/);
		if(!reg.test(pass.val())){
			toastr.warning("密码必须包含字母和数字,不包含特殊字符");
			return;
		}
		if(pass.val()!=confirmPass){
			toastr.warning("确认密码必须与密码相同");
			return;
		} */
		var idcard = $('#idcard').val();
		var reg4= /(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
        if(idcard !=''){
        	if(!reg4.test(idcard)){
            	toastr.warning("请输入正确的身份证号！");
            	return;
            }
        }
		var tel = $('input[name="tel"]').val();
		if(tel!=''){
			var tel_reg1 = new RegExp(/^(13|15|18)\d{9}$/i);
			var tel_reg2 = new RegExp(/^0\d{2,3}-?\d{7,8}$/);
			if(!tel_reg1.test(tel) && !tel_reg2.test(tel)){
				toastr.warning("电话格式不正确！");
				return;
			}
		}
		
		$('#userForm').submit();
	}
</script>