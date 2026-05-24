<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="./commons/taglibs.jsp"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<!DOCTYPE html>
<html>
<head>
	<meta name="save" content="history">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
	
	<title>rules</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bs/css/style.exam.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">
	
	<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
</head>
<style>
.QTcon {
	color: red;
}
.answerarea {
	margin-bottom: 50px;
}
.titleInfo {
	float:right;
	color: #fff;
	margin-top: 25px;
}
.titleInfo span {
	margin: 0 8px;
}
.isY,.isN{
	margin-left: 4px;
	margin-right: 4px;
}
.modal-backdrop.in{
	filter:alpha(opacity=0);
	opacity:0;
}
.modal{
	overflow-y:hidden !important;
}
.modal-dialog{	
	top: 30%;
}
.modal-footer .btn{
	margin-left: 10px;
	margin-right: 10px;
}
.titleLeft{
	float: left;
	color: #fff;
	margin-top: 25px;
	margin-left: 40px;
}
.titleP{
	font-size:15px;
	padding-bottom:1px;
}
.fontSize{
	font-size:21px;
}

/* 修改提示框大小 */
#toast-container{
	margin: 20px;
	padding: 20px;
	font-size: 20px;
}
.bigTitle{
	font-size:23px;
	padding-bottom:1px;
}
</style>
<body style="background:#DDEBF6;">
	<header style="height:80px">
<!-- 		<div class="title"> -->
		<div class="row">
			<div class="col-md-9 col-sm-9">
				<div class="titleLeft">
					<p class="bigTitle"><span style="font-weight:bold"><spring:message code="simulationExam_subject"></spring:message></span>
				</div>
			</div>
			<div class="col-md-2 col-sm-2">
				<div class="titleInfo">
					<input type="button" value="<spring:message code="exit"></spring:message>" class="btn btn-danger" onclick="exit()"/>
				</div>
			</div>
		</div>
		
	</header>
	<input type="hidden" id="lan" value="${sessionScope.lan}">
	
	<div class="container-fluid" id="div_testMode_0">		
<!-- 		<div style="height: 30px; position: fixed; top: 0px; width: 100%; background-color: #76B7F6; z-index: 100;padding:5px 15px;"> -->
<%-- 			<c:if test="${lan == 'en_US' }"> --%>
<%-- 				${organizationinfo_en.PARAM } Online Examination System --%>
<%-- 			</c:if> --%>
<%-- 			<c:if test="${lan != 'en_US' }"> --%>
<%-- 				${organizationinfo.PARAM }网络题库与考试评价系统 --%>
<%-- 			</c:if> --%>
<!-- 		</div> -->
		<div class="row-fluid">
			<div style="padding: 15px">
				<div>
					<form method="post" class="form-horizontal" id="submitFrom_0" role="form" action="">
						<div class="form-group">
<!-- 							<div class="col-sm-12 qcontentDiv mq fontSize">						 -->
<!-- 								<pre></pre> -->
<!-- 							</div> -->
							<div class="col-sm-12 qcontentDiv qq fontSize">						
								<pre></pre>
							</div>
						</div>
						<div class="qanswerDiv fontSize">
						
						</div>
						<div id="tipsbtn_next" class="btn btn-primary"  onclick="next()"><spring:message code="next"></spring:message></div>
						<div id="tipsbtn_0" class="btn btn-primary"  onclick="submitAnswer()" style="display:none"><spring:message code="submit_answer"></spring:message></div>
						<span id="rtn_mes"></span>
					</form>
				</div>	
			</div>
		</div>		
	</div>
	
	<div class="modal bs-example-modal-lg text-center" style="width: auto;height: 100%;" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" >
          <div class="modal-dialog modal-lg" style="width: auto;height: 100%;padding-bottom: 0px;padding-top: 0px;top:0px;">
            <div class="modal-content" style="width: auto;height: 100%;overflow: scroll;display: inline-block;">
            <div class="modal-header">
        		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      		</div>
      		<div id='imgDiv' style="width: auto;"></div>
            </div>
          </div>
    </div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.fullscreen-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	var sl = "";
	var lan = 0;
	var autoSave = 0;
	var startTime = "";
	var test_mode = "";
	var question_num = 0;
	var questions = function (){
		var questionList = [];
		var question1 = new Object();
		var question2 = new Object();
		var question3 = new Object();
		if(lan == 1){
			question1.content = 'Please check if the video is playing properly.';
			question2.content = 'Please check if the headphones can hear the sound.';
			question3.content = 'Please test whether the input method and the submission of subjective questions are regular.';
		}else{
			question1.content = '请测试视频是否正常播放';
			question2.content = '请测试耳机是否有声音';
			question3.content = '请测试输入法是否正常以及主观题能否正常提交';
		}
		question1.num = 0;
		question1.filepath = '/kaoyi_upload/StudentSimulationTest/Video.mp4';
		question1.atid = -1;
		question2.num = 1;
		question2.filepath = '/kaoyi_upload/StudentSimulationTest/Music.mp3';
		question2.atid = -1;
		question3.num = 2;
		question3.atid = 6;
		questionList.push(question1);
		questionList.push(question2);
		questionList.push(question3);
		return questionList;
	}();
	//var timeout = false;
	$(document).ready(function() {
		var f = $("#lan").val();
		if(f != null && f == "en_US"){
			lan = 1;
		}
		var imgdata = localStorage.getItem("imgdata");
		if(imgdata != null && typeof(imgdata) != "undefined"){
			$("#imgId").attr("src",imgdata);
		}
		toastr.options = {
			"closeButton" : true, //是否显示关闭按钮
			"debug" : false, //是否使用debug模式
			"positionClass" : "toast-top-right",//弹出窗的位置
			"showDuration" : "100",//显示的动画时间
			"hideDuration" : "100",//消失的动画时间
			"timeOut" : "3000", //展现时间
			"extendedTimeOut" : "500",//加长展示时间
			"showEasing" : "swing",//显示时的动画缓冲方式
			"hideEasing" : "linear",//消失时的动画缓冲方式
			"showMethod" : "fadeIn",//显示时的动画方式
			"hideMethod" : "fadeOut" //消失时的动画方式
		//"positionClass": "toast-top-full-width",
		};
		initData($("#div_testMode_0"),questions[question_num],0);
	});


	var chnNumChar = [ "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" ];
	var chnUnitSection = [ "", "万", "亿", "万亿", "亿亿" ];
	var chnUnitChar = [ "", "十", "百", "千" ];

	function SectionToChinese(section) {
		var strIns = '', chnStr = '';
		var unitPos = 0;
		var zero = true;
		while (section > 0) {
			var v = section % 10;
			if (v === 0) {
				if (!zero) {
					zero = true;
					chnStr = chnNumChar[v] + chnStr;
				}
			} else {
				zero = false;
				strIns = chnNumChar[v];
				strIns += chnUnitChar[unitPos];
				chnStr = strIns + chnStr;
			}
			unitPos++;
			section = Math.floor(section / 10);
		}
		return chnStr;
	}
	
	function NumberToChinese(num) {
		var unitPos = 0;
		var strIns = '', chnStr = '';
		var needZero = false;

		if (num === 0) {
			return chnNumChar[0];
		}

		while (num > 0) {
			var section = num % 10000;
			if (needZero) {
				chnStr = chnNumChar[0] + chnStr;
			}
			strIns = SectionToChinese(section);
			strIns += (section !== 0) ? chnUnitSection[unitPos]
					: chnUnitSection[0];
			chnStr = strIns + chnStr;
			needZero = (section < 1000) && (section > 0);
			num = Math.floor(num / 10000);
			unitPos++;
		}

		return chnStr;
	}
	
	function showimage(source){
        $("#imgModal").find("#imgDiv").html("<image style='width:auto;height:auto;' src='"+source+"' class='carousel-inner img-responsive img-rounded' />");
        $("#imgModal").modal();
    }
	
	function initData(elt,data,type) {
		console.log(data);
		question_num = data.num;
		videoplay = true;
		
		$(elt).find(".qq").html("<pre class=\"fontSize\">"+data.content+"</pre>");
		//附件		
		if (typeof(data.filepath)!='undefined' && data.filepath!=null) {
			var fp = "";
			var filepath = data.filepath;
			var suffix = filepath.split(".");
			if(suffix[1]=='mp4'){
				fp += '<video class="fujian" controls="controls" preload="none" width="420" height="280" src="'+filepath+'">'
					+ '<source src="'+filepath+'" type="video/mp4"/>'
					+ '</video>';
			}
			if(suffix[1]=='mp3'){
				fp += '<audio src="'+filepath+'" controls="controls">'
					+ '</audio>';
			}
			if(suffix[1]=='jpg'||suffix[1]=='jpeg'||suffix[1]=='png'||suffix[1]=='gif'||suffix[1]=='bmp'){
				fp += '<img onclick="showimage(\'' + filepath + '\')" src="'+filepath+'" height="100px" />';
			}
			$(elt).find(".qq").html($(elt).find(".qq").html()+fp);
		}
		var atid_0 = parseInt(data.atid);
 		if(atid_0 == 6){
			var answerHTML = "<div class=\"form-group\">"
				+ "<div class=\"col-sm-12\" id=\"ass\">"
				+ "<textarea rows=\"12\" cols=\"15\" class=\"form-control anstext\" name=\"input_answer\">"
				+ "</textarea>" + "</div>" + "</div>";
			$(elt).find(".qanswerDiv").html(answerHTML);
		} 
 		question_num++;
		
/* 		$.each($('.aindex'), function(i, item) {
			var s = $(item).html();
			$(item).html(String.fromCharCode(parseInt(s) + 65));
		}); */
		
	}
	
	function exit(){
		window.location.href="${pageContext.request.contextPath}/exam/testList"
	}
	

$('#submit_btn').click(function(event){
	$(document).fullScreen(true);
});

function next(){
	if(question_num==questions.length-1){
		$('#tipsbtn_next').hide();
		$('#tipsbtn_0').show();
	}
	initData($("#div_testMode_0"),questions[question_num],0);
}


$(document).bind('keydown', function (e) {
    var key = e.which;
    //$('#aaa').val(e);
    
	var ev = e || window.event;//获取event对象   
    var obj = ev.target || ev.srcElement;//获取事件源   
    var t = obj.type || obj.getAttribute('type');//获取事件源类型  
    
    if(key == 8 && t!="textarea"){
    	e.preventDefault();
    }
    
/*     if (key == 8) {  // <--
    	e.preventDefault();
    }  */
    if (key == 9) { //tab 
    	e.preventDefault();
    }
    if (key == 115) { //f4
    	e.preventDefault();
    }
    if (key == 116) { //f5
    	e.preventDefault();
    }
    if (key == 122) { //f11
    	e.preventDefault();
    }
    if (key == 123) { //f12
    	e.preventDefault();
    }
    if(key == 83 && e.ctrlKey){ //ctrl + s
		e.preventDefault();
	}
    if(key == 87 && e.ctrlKey){ //ctrl + w
		e.preventDefault();
	}
    if(key == 67 && e.ctrlKey){ //ctrl + c
		e.preventDefault();
	}
    if(key == 86 && e.ctrlKey){ //ctrl + v
		e.preventDefault();
	}
    if(window.event.altKey){
    	event.returnValue=false; 
    }
	if ((window.event.altKey)&& ((window.event.keyCode==37)||(window.event.keyCode==39))) {  ////屏蔽 Alt+ 方向键 ← 屏蔽 Alt+ 方向键 →
		event.returnValue=false; 
	} 
	//alt + f4 屏蔽
	if((window.event.altKey)&& (window.event.keyCode==115)){
		 window.showModelessDialog("about:blank","","dialogWidth:0px;dialogheight:0px");
	     return false; 
	}
});

document.oncontextmenu = function(){  //禁止右键
    event.returnValue = false;
} 


function addByValue(arr,val){
	var flag = true;//flag为真，数组没有重复值
	for(var i=0;i<arr.length;i++){
		if(arr[i]==val){
			flag = false;
		}
	}
	if(flag){
		arr.push(val);
	}
}

function removeByValue(arr,val){
	for(var i=0; i<arr.length; i++){
		if(arr[i] == val){
			arr.splice(i, 1);
			break;
		}
	}
}

//暂存答案
function saveAnswer(item) {
	var params = {};
	params["qid"] = $("#qid").val();
	params["qtype"] = $("#qtype").val();
	params["atid"] = $("#atid").val();
	params["qtiscon"] = $("#qtiscon").val();
	params["ismain"] = $("#ismain").val();
	params["mqid"] = $("#mqid").val();
	params["version"] = $("#version").val();
	params["  "] = $("#ans").val();
	var submitTime = new Date().getTime();
	params["answertime"] = Math.round( (submitTime - startTime) / 1000);
	params["order"] = $("#order").val();
	$.each($('.answerarea'), function(i, item) {
		var id = $(item).find('.questionID').val();//主观题
		var str = 'textarea[name=' + id + '_answer]';
		var res = $(str);
		params[id + "_answer"] = change(res.val());
	});
	$.ajax({
		url : "${pageContext.request.contextPath}/exam/saveAnswer",
		async : false,
		type : "POST",
		traditional : true,
		contentType : "application/json; charset=utf-8",
		data : JSON.stringify(params),
		success : function(data,status,xhr) {
			var sessionstatus=xhr.getResponseHeader("session-status");
			if(sessionstatus=='timeout'){
				toastr.error("您的登录信息失效，3秒后跳转回考试列表。"); 
				setTimeout(function(){//两秒后跳转
					window.location.href = "${pageContext.request.contextPath}/exam/testList";
				},3000);						
			}
			if(data == "success"){
				if(lan == 1){
					toastr.success("save Successfully!");
				}else{
					toastr.success("暂存成功!");
				}
				timer1(60);
			}else{
				if(lan == 1){
					toastr.error("Save failed!");
				}else{
					toastr.error("暂存失败!");
				}
				timer1(60);
			}
		}
	});
}

function fullScreen() {
	var el = document.documentElement
	    , rfs = // for newer Webkit and Firefox
	           el.requestFullScreen
	        || el.webkitRequestFullScreen
	        || el.mozRequestFullScreen
	        || el.msRequestFullscreen
	;
	if(typeof rfs!="undefined" && rfs){
	  rfs.call(el);
	} else if(typeof window.ActiveXObject!="undefined"){
	  // for Internet Explorer
	  var wscript = new ActiveXObject("WScript.Shell");
	  if (wscript!=null) {
	     wscript.SendKeys("{F11}");
	  }
	}
}

function submitAnswer(){
	var val = $('.anstext').val();
	$.ajax({
		url: "${pageContext.request.contextPath}/exam/testSubmit",
		async : false,
		type : "POST",
		data : {"content":val},
		success : function(data){
			if(data!=null){
				$("#rtn_mes").text(data);
			}
		}		
	})
}

function change(str) {
	 if (str != ""){
		 str= str.replace(/'/g,"’");
		 str= str.replace(/;/g, "；");
		 str= str.replace(/!!-*!!/g,"-*-");
		 str=  str.replace(/\"/g,"”");
		 str=  str.replace(/{/g,"｛");
		 str=  str.replace(/}/g,"｝");
		 str=  str.replace(/\[/g,"【");
		 str=  str.replace(/]/g,"】");
		 str=  str.replace(/\\/g,"＼");
		 str = str.replace(/\*/g, "＊");
		 str = str.replace(/\#/g, "＃");
		 str = str.replace(/\|\|/g, "| |");
	 }
	 return str;
}
</script>
</html>