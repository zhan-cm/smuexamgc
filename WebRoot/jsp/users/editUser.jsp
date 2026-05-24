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
	width: 60%;
	padding: 0px 0px 0px 5px;
	border: 1px solid #C5E2FF;
	background: #FFFFFBF;
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
	width: 60%;	
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
	width: 60%;
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
	action="${pageContext.request.contextPath}/users/updateTeacher">
	<!-- <h1>编辑用户</h1> -->
	<label> 
		<span>所属教学单位 :</span> 
		<select id="unit" name="unitID">
			<c:forEach var="unit" items="${applicationScope.unitList}">
				<c:choose>
					<c:when test="${userInfo.role==1 or userInfo.role==2}">
						 <c:choose>
							<c:when test="${unit.ID == user.unitID}">
								<option value="${unit.ID}" selected="selected">${unit.NAME}</option>
							</c:when>
							<c:otherwise>
								<option value="${unit.ID}" >${unit.NAME}</option>
							</c:otherwise>
						</c:choose> 
					</c:when>
					<c:otherwise>
						<c:if test="${user.unitID == unit.ID}">
							<option value="${unit.ID}">${unit.NAME}</option>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label> 
	<label> 
		<span>所属科室 :</span> 
		<select id="dept" name="depID" >
			<%-- <option value="${user.depID}" selected="selected">${user.dep}</option> --%>
		</select>
	</label> 
	<label> 
		<span>角色 :</span> 
	</label>
	<div class="roleBlock">
		<c:forEach var="roles" items="${roleByUsers}">
			<c:choose>
				<c:when test="${roles.ID == user.roleID}">
					<label><input type="radio" name="roleID" value="${roles.ID}" checked="checked" />${roles.CNAME}</label>
				</c:when>
				<c:otherwise>
					<label><input type="radio" name="roleID" value="${roles.ID}" />${roles.CNAME}</label>
			    </c:otherwise>
			</c:choose>
		</c:forEach>
	</div>	
	<div class="roleBlockClear"></div>	
	<label> 
		<span>用户名 :</span> 
		<input type="text" name="" class="unedit" disabled="disabled" value="${user.username}"/>
	</label> 
	<label> 
		<span>用户实名 :</span> 
		<input type="text" name="realname" disabled="disabled" value="${user.realname}"/> 
	</label>
	<label> 
		<span>身份证号 :</span> 
		<input type="text" name="idcard" id="idcard" value="${user.idcard}"/> 
	</label>  
	<c:if test="${restriction==0}">
	<label> 
		<span>登录密码 :</span> 	
		<input type="password" id="password" name="password"  value="${user.password}" autocomplete="new-password" onchange="passChanged()"/>
	</label> 
	<label> 
		<span>确认密码 :</span> 
		<input type="password" id="confirmPass" name="confirmPass" value="${user.password}" autocomplete="new-password"/>
	</label> 
	</c:if>	
	<c:if test="${restriction!=0}">
	<label> 
		<input type="hidden" name="password"  value="${user.password}" autocomplete="new-password"/>
	</label> 
	<label> 
		<input type="hidden" name="confirmPass" value="${user.password}" autocomplete="new-password"/>
	</label> 
	</c:if>	
	<label> 
		<span>工作证号 :</span> 
		<input type="text" name="num"  value="${user.num}"/>
	</label> 
	<label> 
		<span>email :</span> 
		<input type="text" name="email"  id="email"  value="${user.email}"/>
	</label> 
	<label> 
		<span>联系电话 :</span> 
		<input type="text" name="tel" id="tel"  value="${user.tel}" class="easyui-validatebox"/>
	</label>
		<label>
			<span>权限 :</span>
			<c:choose>
				<c:when test="${coursemark == '1'}">
					<input type="checkbox" name="addcourse" value="on" checked="checked"/>添加课程
				</c:when>
				<c:otherwise>
					<input type="checkbox" name="addcourse" value="on"/>添加课程
				</c:otherwise>
			</c:choose>
		</label>

		<%-- 只有超级管理员才能看到"添加、编辑用户"权限选项 --%>
		<c:if test="${canAssignEditUser}">
			<label>
				<c:choose>
					<c:when test="${usermark == '1'}">
						<input type="checkbox" name="edituser" value="on" checked="checked"/>添加、编辑用户
					</c:when>
					<c:otherwise>
						<input type="checkbox" name="edituser" value="on"/>添加、编辑用户
					</c:otherwise>
				</c:choose>
			</label>
		</c:if>
	<input type="hidden" id="flag" value="${flag }" />
	<input type="hidden" id="message" value="${message }" />
	<input type="hidden" id="error" value="${updateError}"/>
	<input type="hidden" name="username" value="${user.username}"/>
	<input type="hidden" name="salt" value="${user.salt}"/>
	<input type="hidden" name="id" value="${user.id}"/>
	<input type="hidden" id="depid" value="${user.depID}"/>
	<input type="hidden" id="depname" value="${user.dep}"/>
	
</form>

<div style="text-align: center; padding: 5px">
	<a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-save'" onclick="submitForm()">保存</a> 
	<!-- <a href="${pageContext.request.contextPath}/users/users"
		class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a> -->
	<!-- <a href="javascript:void(0)" class="easyui-linkbutton" 
		data-options="iconCls:'icon-reload'" onclick="window.location.reload();">刷新</a> -->
</div>
<input type="hidden" id="role" value="${userInfo.role}"/>
<input type="hidden" id="dep" value="${userInfo.dep}"/>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
	var depid="";
	var pass_change = 0;
	$(document).ready(function() {
		let u_id = $('#unit').val();
		depid=$('#depid').val();
		getDept(u_id);
		$('#dept').val($('#depid').val());
		let flag = $("#flag").val();
		if(flag=="success"){
			var info = $('#message').val();
			if(info){
				toastr.success(info);
			}	
		}else{
			let info = $('#error').val();
			if(info){
				toastr.warning(info);
			}
		}
		
	});

	function passChanged(){
		pass_change = 1;
	}

	function submitForm() {
	    if(pass_change==1){
			let username = $('input[name="username"]');
			let pass = $('input[name="password"]');
			let confirmPass = $('input[name="confirmPass"]').val();
            if(${pass_switch==1}&&${restriction==0}){
				let reg=new RegExp(/^(?=.*[A-Za-z])(?=.*\d)[^]{8,32}$/);
                if(!reg.test(pass.val())||(pass.val()).length<8){
                    toastr.warning("密码必须包含字母、数字、特殊符号,且不少于8个字符！");
                    return;
                }
				let reg2 = new RegExp("[`~!@#$%^&*()=|{}':;',\\[\\].<>《》/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？ ]")
                if(!reg2.test(pass.val())){
                    toastr.warning("密码必须包含字母、数字、特殊符号,且不少于8个字符！");
                    return;
                }
            }else{
				let reg=new RegExp(/^(?=.*[0-9].*)(?=.*[A-Za-z].*).{6,20}$/);
                if(!reg.test(pass.val())||(pass.val()).length<6){
                    toastr.warning("密码必须包含字母、数字，且不少于6个字符。");
                    return;
                }
            }

			let reg3 = new RegExp(username.val());
            if(reg3.test(pass.val())){
                toastr.warning("密码不可以包含用户名！");
                return;
            }
            if(pass.val()!=confirmPass){
                toastr.warning("确认密码必须与密码相同");
                return;
            }
		}else{
            $("#password").val("");
			$("#confirmPass").val("");
        }
		let idcard = $('#idcard').val();
		let reg4= /(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
        if(idcard !=''){
        	if(!reg4.test(idcard)){
            	toastr.warning("请输入正确的身份证号！");
            	return;
            }
        }
        
        let email = $('#email').val();
        let emailReg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if(email != ''){
            if(!emailReg.test(email)){
                toastr.warning("请输入正确的邮箱地址！");
                return;
            }
        }
        
		let tel = $('#tel').val();
        if(tel!=''){
			tel = tel.trim()
					.replace(/[０-９]/g, c => String.fromCharCode(c.charCodeAt(0) - 0xFF10 + 48))
					.replace(/[—－﹣−]/g, '-')
					.replace(/\s+/g, '');
			const mobile   = /^1[3-9]\d{9}$/;                         // 手机
			const landline = /^0\d{2,3}-?\d{7,8}(?:-\d{1,6})?$/;      // 固话
			if (!(mobile.test(tel) || landline.test(tel))) {
				$('#tel').focus();
				toastr.warning('电话格式不正确！');
				return;
			}
        }
		
		$('#userForm').submit();

	}
	function clearForm() {
		$('#userForm').form('clear');
	}

	$('#unit').change(function() {
		let u_id = $(this).val();
		depid="";
		getDept(u_id);
	});

	function getDept(u_id) {
		let role = $("#role").val();
		$.ajax({
			url : "${pageContext.request.contextPath}/course/getDeptList",
			async : false,
			type : "POST",
			data : {
				"u_id" : u_id
			},
			success : function(data) {
				$("#dept").html(null);
				let str;
				
				if(depid!=""){
					str += '<option value='+depid+'>'+$("#depname").val()+'</option>';
				}				
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
</script>