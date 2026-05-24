<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<!DOCTYPE html>
<html>
<head>
	<meta name="save" content="history">
	<meta name="renderer" content="webkit">
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>rules</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bs/css/style.exam.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">	
	
	<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
</head>
<style>
body{
	background-color:#FCFCFC;
}

.titleInfo {
	margin-right: 10px;
	color: #fff;
	margin-top: 10px;
}

.titleInfo span {
	margin: 0 8px;
}

.modal-footer .btn{
	margin-left: 10px;
	margin-right: 10px;
}
.titleLeft{
	color: #fff;
	margin-top: 10px;
	margin-left: 40px;
}
.titleP{
	font-size:15px;
	padding-bottom:1px;
}

input[type=checkbox] {
	-ms-transform: scale(1.5); /* IE */
	-moz-transform: scale(1.5); /* FireFox */
	-webkit-transform: scale(1.5); /* Safari and Chrome */
	-o-transform: scale(1.5); /* Opera */
}
</style>
<body>
	<header style="height:80px">
		<div class="row">
			<div class="col-md-7 col-sm-7">
				<div class="titleLeft">
					<p class="titleP"><span style="font-weight:bold"><spring:message code="exam_subject"></spring:message>：</span>《${sessionScope.ename}》
					<p class="titleP"><span style="font-weight:bold"><spring:message code="student_major"></spring:message>/<spring:message code="student_grade"></spring:message>：</span>${sessionScope.student.specialty}&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:bold">${sessionScope.student.grade_name}</span></p> 
				</div>
			</div>
			
			<div class="col-md-4 col-sm-4 text-right">
				<div class="titleInfo">
					<p class="titleP"><span style="font-weight:bold"><spring:message code="student_name"></spring:message>: </span>${sessionScope.student.name}</p>
					<p class="titleP"><span style="font-weight:bold"><spring:message code="student_num"></spring:message>: </span>${sessionScope.student.num}</p>
				</div>
			</div>
			<div class="col-md-1 col-sm-1 text-left">
				<div class="titlePic">
					<img src="/student/${sessionScope.student.num}.jpg" onerror="this.src='${pageContext.request.contextPath}/styles/images/defaultphoto.png'" alt="考生照片" class="img-thumbnail" style="height:77px;">
				</div>
			</div>
		</div>
	</header>
	<div class="main" id="agree_div">
		<div class="main-box">
			<div class="main-title">
				<span><spring:message code="agreement"></spring:message></span>
			</div>
			<form id="login_form" class="form-horizontal" role="form" action="" method="post">
				<div class="form-group">
					<c:if test="${lan == 'en_US' }">
						<pre style="font-size:14px; white-space: pre-wrap">${fn:trim(e_remark2s)}</pre>
					</c:if>
					<c:if test="${lan != 'en_US' }">
						<pre style="font-size:14px; white-space: pre-wrap">${fn:trim(remark2s)}</pre>
					</c:if>
				</div>
				<div class="form-group">
					<div class="col-sm-12">
						<div class="checkbox">
							<label style="font-weight: bold;color: red;">
								<input id="agree" type="checkbox"/>
								<spring:message code="agree"></spring:message>
							</label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col-md-12 text-center">
						<div class="btn btn-primary" id="submit_btn"><spring:message code="begin_exam"></spring:message></div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<input type="hidden" id="test_mode" value="${test_mode }"/>
	<input type="hidden" id="lan" value="${sessionScope.lan}">
	<input type="hidden" id="sid" value="${sessionScope.student.id}"/>
	
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	var lan = 0;
	$(document).ready(function() {
		if($("#lan").val() === "en_US"){
			lan = 1;
		}
	});

    $('#exit').click(function(event) {
        CefSharp.BindObjectAsync("googlebrower");
        googlebrower.closeWindow();
    });

	var __submitting = false;
	var __submitBtnOriginalHtml = null;
	var __submitRestoreTimer = null;
	var __submitLoadingText = 'loading...';
	function setSubmitBtnLoading() {
		var $btn = $("#submit_btn");
		if (__submitBtnOriginalHtml == null) {
			__submitBtnOriginalHtml = $btn.html();
		}
		$btn
				.addClass("disabled")
				.attr("aria-disabled", "true")
				.css({
					"background-color": "#cccccc",
					"cursor": "not-allowed",
					"pointer-events": "none"
				})
				.html(__submitLoadingText);
	}

	function restoreSubmitBtn() {
		var $btn = $("#submit_btn");
		$btn
				.removeClass("disabled")
				.removeAttr("aria-disabled")
				.css({
					"background-color": "",
					"cursor": "",
					"pointer-events": ""
				});

		if (__submitBtnOriginalHtml != null) {
			$btn.html(__submitBtnOriginalHtml);
		}
	}

	function delayedReplaceToTest() {
		var test_mode = $("#test_mode").val();
		var targetUrl = "${pageContext.request.contextPath}/exam/to_test?mode=" + test_mode;
		var delay = 20 + Math.floor(Math.random() * 1981);
		clearTimeout(__submitRestoreTimer);
		__submitRestoreTimer = setTimeout(function () {
			__submitting = false;
			restoreSubmitBtn();
			toastr.error("error");
		}, delay + 10000);
		setTimeout(function () {
			window.location.replace(targetUrl);
		}, delay);
	}

	$('#submit_btn').click(function(event){
		if (__submitting) return;
		if($('#agree').is(':checked')){
			__submitting = true;
			setSubmitBtnLoading();
			$.ajax({
				url : "${pageContext.request.contextPath}/exam/checkBeginExam",
				type:"POST",
				data : {},
				dataType: "json",
				success : function(data) {
					if(data == 1){
						delayedReplaceToTest();
					}else{
						clearTimeout(__submitRestoreTimer);
						__submitting = false;
						restoreSubmitBtn();
						if(lan == 1){
							toastr.warning("The exam has not yet started. Please wait patiently!");
						}else{
							toastr.warning("考试尚未开始，请耐心等候！");
						}
					}
				},
				error: function () {
					clearTimeout(__submitRestoreTimer);
					__submitting = false;
					restoreSubmitBtn();
					if(lan == 1){
						toastr.error("Network error, please try again!");
					}else{
						toastr.error("网络异常，请重试！");
					}
				}
			});

		}else{
			if(lan == 1){
				toastr.warning("Please obey the rules！");
			}else{
				toastr.warning("请遵守考场纪律！");
			}
			event.preventDefault();
		}
	});


	window.addEventListener("keydown", function (e) {
		const key = e.key;
		const isCtrl = e.ctrlKey;
		const isAlt = e.altKey;
		const isMeta = e.metaKey;

		const isF4 = key === "F4";
		const isF5 = key === "F5";
		const isF11 = key === "F11";
		const isF12 = key === "F12";
		const isF6 = key === "F6";
		const isTab = key === "Tab";

		const isCtrlS = (key === "s" || key === "S") && isCtrl;
		const isCtrlW = (key === "w" || key === "W") && isCtrl;
		const isCtrlC = (key === "c" || key === "C") && isCtrl;
		const isCtrlV = (key === "v" || key === "V") && isCtrl;

		const isCtrlR = (key === "r" || key === "R") && isCtrl;
		const isCtrlL = (key === "l" || key === "L") && isCtrl;

		const isAltD = (key === "d" || key === "D") && isAlt;
		const isAltE = (key === "e" || key === "E") && isAlt;

		const isAltDirection = isAlt && (key === "ArrowLeft" || key === "ArrowRight");

		const isCmdR = (key === "r" || key === "R") && isMeta;
		const isCmdL = (key === "l" || key === "L") && isMeta;

		const isCmdLeftBracket = key === "[" && isMeta;
		const isCmdRightBracket = key === "]" && isMeta;
		const isCmdArrowLeft = key === "ArrowLeft" && isMeta;
		const isCmdArrowRight = key === "ArrowRight" && isMeta;

		const shouldBlock =
				isTab ||
				[isF4, isF5, isF6, isF11, isF12].includes(true) ||
				[isCtrlS, isCtrlW, isCtrlC, isCtrlV, isCtrlR, isCtrlL].includes(true) ||
				(isAltDirection || isAltD || isAltE) ||
				(isCmdR || isCmdL || isCmdLeftBracket || isCmdRightBracket || isCmdArrowLeft || isCmdArrowRight);

		if (shouldBlock) {
			e.preventDefault();
			e.stopPropagation();
			return false;
		}
	}, true);

window.oncontextmenu = function(event) {  // 禁止右键
	event.preventDefault();  // 阻止默认行为
}

window.addEventListener('pageshow', function (e) {
	__submitting = false;
	clearTimeout(__submitRestoreTimer);
	restoreSubmitBtn();
});

window.addEventListener('pagehide', function () {
	clearTimeout(__submitRestoreTimer);
});
</script>
</html>