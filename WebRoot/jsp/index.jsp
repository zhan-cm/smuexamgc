<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh" class="no-js">

<head>
	<meta name="renderer" content="webkit">
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>${organizationinfo.PARAM }网络题库与考试评价系统</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">

	<link href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/admin_login.css">

	<style type="text/css">
		.bottom_info_section_trans {
			margin-top: 0;
			padding: 2px 40px;
			background-color: transparent;
			text-align: center;
			font-size: 14px;
			color: #000000;
			line-height: 1.6;
			font-family: "Microsoft YaHei", Arial, sans-serif;
		}

		.bottom_info_section_trans .contact_details_info {
			margin-top: 9px;
		}

		.bottom_info_section_trans .contact_details_info span {
			display: inline-block;
			margin: 0 20px;
			font-weight: 500;
		}

		.bottom_info_section_trans .open_time_info {
			display: block;
			margin-top: 9px;
			font-weight: 500;
			font-size: 14px;
			color: #000000;
		}

		.form_group_captcha_cust {
			margin-bottom: 15px;
		}

		.captcha_wrapper_cust {
			display: inline-flex;
			width: 279px;
			align-items: center;
		}

		.captcha_input_cust {
			flex: 1;
			height: calc(1.5em + 0.75rem + 2px);
			padding: 0.375rem 0.75rem;
			font-size: 1rem;
			line-height: 1.5;
			border: 1px solid #ced4da;
			border-radius: 0.25rem;
		}

		.captcha_img_cust {
			margin-left: 8px;
			height: 38px;
			cursor: pointer;
		}

		.btn-label-right{
			font-weight:normal;
			font-size:14px;
			margin-right:150px;
			cursor:pointer;
		}

		.space_btn{
			margin-left:120px;
		}

		.space_btn input{
			width:380px;
		}

		textarea{
			border-radius: 5px;
			border-color: #9acfea;
			overflow:hidden;
			resize: none;
		}

		/*密码明文显示按钮*/
		.password_wrapper_cust{
			position: relative;
			display: inline-block;  /* 确保仍与 label 同行 */
			width: 279px;           /* 与原输入框一致 */
			vertical-align: middle;
		}

		.password_wrapper_cust #password{
			width: 279px;           /* 保持原宽度 */
			padding-right: 34px;    /* 给右侧按钮留空间，不影响整体宽度 */
		}

		.password_toggle_btn{
			position: absolute;
			right: 8px;
			top: 50%;
			transform: translateY(-50%);
			border: 0;
			background: transparent;
			padding: 0;
			line-height: 1;
			cursor: pointer;
			color: #666;
			outline: none;
		}

		.password_toggle_btn:focus{
			outline: none;
		}

		.password_toggle_btn .glyphicon{
			font-size: 16px;
		}

		.capslock_tip{
			display:none;
			position:absolute;
			left:0;
			top:100%;
			margin-top:4px;
			font-size:12px;
			color:#d9534f;
			background:#fff;
			border:1px solid #d9534f;
			border-radius:3px;
			padding:2px 6px;
			white-space:nowrap;
			z-index:20;
		}
		input[type="password"]::-ms-reveal,
		input[type="password"]::-ms-clear {
			display: none !important;
		}
	</style>
</head>

<body>
<input type="hidden" id="errCode" value="${errCode}"/>
<input type="hidden" id="name" value="${username}"/>

<div class="page-container">
	<div class="login_logo">
		<table style="width: 100%;">
			<tr>
				<td>
					<c:if test="${lan == 'en_US' }">
						<h1>${organizationinfo_en.PARAM } Online Examination System</h1>
					</c:if>
					<c:if test="${lan != 'en_US' }">
						<h1>${organizationinfo.PARAM }网络题库与考试评价系统</h1>
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					<h5>（此登录只限管理员和教师）</h5>
				</td>
			</tr>
		</table>
	</div>

	<div class="main_box">
		<div class="login_box">
			<div class="login_form">
				<form action="" id="login_form" method="post">
					<div class="form-group">
						<label for="username" class="t">账　号：</label>
						<input
								id="username"
								name="username"
								type="text"
								onclick="cancelBlodByName()"
								autocomplete="off"
								class="form-control in"
								style="width:279px"
								placeholder="请输入账号名"
						>
						<input id="username_aec" name="username_aec" type="hidden">
					</div>

					<div class="form-group">
						<label for="password" class="t">密　码：</label>

						<!-- 关键：用 wrapper 包一层，宽度仍是 279px，不破坏原有布局 -->
						<div class="password_wrapper_cust">
							<input
									id="password"
									name="password"
									type="password"
									onclick="cancelBlodByPass()"
									autocomplete="off"
									class="password form-control in"
									placeholder="请输入密码"
							>
							<!-- 右侧按钮：hover 显示、移出隐藏；也支持点击锁定 -->
							<button type="button"
									id="togglePassword"
									class="password_toggle_btn"
									tabindex="-1"
									aria-label="显示/隐藏密码"
									title="按住显示，点击可锁定显示">
								<span id="togglePasswordIcon">🔒</span>
							</button>
							<div id="capsLockTip" class="capslock_tip" aria-live="polite">当前键盘大写已开启</div>
						</div>
					</div>

					<div class="form-group form_group_captcha_cust">
						<label for="kaptcha" class="t">验证码：</label>
						<div class="captcha_wrapper_cust">
							<input
									id="kaptcha"
									name="kaptcha"
									type="text"
									class="form-control x164 in captcha_input_cust"
									placeholder="请输入验证码"
							>
							<img id="changeImg"
								 alt="点击更换"
								 title="点击更换"
								 src="${pageContext.request.contextPath}/VerifyCode"
								 class="j_captcha m captcha_img_cust">
						</div>
					</div>

					<div class="form-group space">
						<div class="space_btn">
							<input type="button" value="登  录" class="btn btn-primary btn-lg" id="submit_btn" >
						</div>
						<p id="errorInfo">${LoginFailureMessage}</p>
					</div>

					<div class="form-group text-right"></div>

					<div class="form-group text-right">
						<label class="btn-label-right" onclick="alert('待定');">忘记密码&nbsp;<img src="styles/images/wenhao.png" style="height:20px;"></label>
					</div>
				</form>
			</div>
		</div>

		<div class="bottom_info_section_trans">
			${organizationinfo.PARAM} -- 授权使用，仅限内部使用

			<div class="contact_details_info">
				联系人：${organizationinfo.YL_1}
				<span>联系电话：${organizationinfo.YL_2}</span>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="Operainfo" tabindex="-1" role="dialog"
	 aria-labelledby="TipsLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="TipsLabel">警告</h4>
			</div>
			<div class="modal-body" name="msg"></div>
		</div>
	</div>
</div>

<div class="modal fade" id="errorModal" tabindex="-1" role="dialog"
	 aria-labelledby="TipsLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			</div>

			<div class="modal-body" name="msg" align="center"></div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/aes/crypto-js.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/aes/aes.js"></script>

<script type="text/javascript">
	'use strict';

	(function () {
		const ctx = "${pageContext.request.contextPath}";

		// Enter 键触发登录（替代 body onkeydown + 全局 event/keyCode）
		document.addEventListener('keydown', function (e) {
			if (e.key === 'Enter') {
				const btn = document.getElementById('submit_btn');
				if (btn) btn.click();
			}
		});

		function refreshCaptcha() {
			const $img = $('#changeImg');
			$img.attr('src', ctx + '/VerifyCode?ts=' + Date.now());
		}

		// ===== 保留你原来的这两个函数（供 onclick 调用）=====
		window.cancelBlodByName = function () {
			$("#username").css("font-weight", "");
		};

		window.cancelBlodByPass = function () {
			$("#password").css("font-weight", "");
		};

		window.encrypt = function (pass) {
			const key = CryptoJS.enc.Utf8.parse("abcdefgabcdefg12");
			const srcs = CryptoJS.enc.Utf8.parse(pass);
			const encrypted = CryptoJS.AES.encrypt(srcs, key, { mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 });
			return encrypted.toString();
		};

		function initPasswordToggle() {
			const pwd = document.getElementById('password');
			const btn = document.getElementById('togglePassword');
			const icon = document.getElementById('togglePasswordIcon');
			const capsTip = document.getElementById('capsLockTip');
			if (!pwd || !btn || !icon) return;

			let locked = false;

			function setVisible(visible) {
				const hadFocus = (document.activeElement === pwd);
				pwd.type = visible ? 'text' : 'password';
				icon.textContent = visible ? '🔓' : '🔒';
				btn.setAttribute('aria-pressed', visible ? 'true' : 'false');
				if (hadFocus) pwd.focus();
			}

			function updateCapsLock(e){
				if (!capsTip) return;
				const on = !!(e && e.getModifierState && e.getModifierState('CapsLock'));
				capsTip.style.display = on ? 'inline-block' : 'none';
			}

			pwd.addEventListener('keydown', updateCapsLock);
			pwd.addEventListener('keyup', updateCapsLock);
			pwd.addEventListener('focus', function(){ if (capsTip) capsTip.style.display = 'none'; });
			pwd.addEventListener('blur', function(){ if (capsTip) capsTip.style.display = 'none'; });

			btn.addEventListener('mouseenter', function () {
				setVisible(true);
			});
			btn.addEventListener('mouseleave', function () {
				if (!locked) setVisible(false);
			});

			btn.addEventListener('click', function () {
				locked = !locked;
				setVisible(locked);
			});
		}

		$(document).ready(function () {
			// 防止 iframe 嵌套
			if (window.top !== window.self) window.top.location.href = window.location.href;

			const errCode = $("#errCode").val();
			if (errCode !== "") {
				if (errCode === "2") {
					$("#username").val(sessionStorage.getItem("username"));
					$("#password").val(sessionStorage.getItem("password"));
				}
			}

			// 验证码点击刷新（防缓存）
			$('#changeImg').on('click', function () {
				refreshCaptcha();
			});

			initPasswordToggle();

			if ($.fn.tooltip) {
				$('#togglePassword').tooltip({ container: 'body', trigger: 'hover' });
			}

			// 登录按钮事件（原逻辑保留，增强 JSON 解析健壮性）
			$('#submit_btn').on('click', function () {
				$.post(ctx + "/login", {
					"username_aec": encrypt($('#username').val()),
					"password": encrypt($('#password').val()),
					"kaptcha": $("#kaptcha").val()
				}, function (data) {
					let parsedData = data;
					// 兼容：服务端可能返回字符串
					if (typeof data === 'string') {
						try { parsedData = JSON.parse(data); } catch (e) { parsedData = {}; }
					}

					if (parsedData && parsedData.success === true) {
						window.location.href = ctx + "/default";
						return;
					}

					if (parsedData && parsedData.success === false) {
						if (parsedData.code === 'error_passweak_8' || parsedData.code === 'error_passweak_6' || parsedData.code === 'error_firstLogin') {
							window.location.href = ctx + "/resetPass?login=1&info=" + encodeURIComponent(parsedData.message);
							return;
						}
						if (parsedData.code === 'error_kaptcha') {
							$("#kaptcha").val('');
							// 失败时顺便刷新验证码，减少用户困惑（不影响逻辑）
							refreshCaptcha();
						}
						if (parsedData.code === 'error_passweak_8' || parsedData.code === 'error_passweak_6') {
							$("#password").val('');
						}

						$("#errorModal").find("div[name=msg]").html(parsedData.message || "登录失败");
						$('#errorModal').modal({ keyboard: true });
					}
				});
			});
		});
	})();
</script>
</body>
</html>