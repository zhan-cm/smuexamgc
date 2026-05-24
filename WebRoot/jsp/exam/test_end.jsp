<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head> 

	<meta name="save" content="history">
	<meta name="renderer" content="webkit">
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<link rel="shortcut icon"
		href="${pageContext.request.contextPath}/favicon.ico" />
	<title>rules</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bs/css/style.reget_pass.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">
</head>
<body>
	<header><div class="title">在线考试系统</div></header>
	
	<div class="main">
		<div class="main-box">
			<div class="main-title">
				<h2>${errorMsg }</h2>
				<!-- <h2>您在测试过程中对试卷的内容进行了修改，本次模拟测试结果无效，请修改模拟测试时用户名重新测试。</h2> -->
			</div>
			<div class="ok" style="margin-top: 50px">
				<a id="out" style="margin-bottom: 10px" class="btn btn-block btn-danger">结束测试</a>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
<script type="text/javascript">
document.oncontextmenu = function(){  //禁止右键
    event.returnValue = false;
} 

$('#out').click(function(event) {	
	window.opener=null;
	window.open('','_self');
	window.close(); 
});

$(document).bind('keydown', function (e) {
    var key = e.which;
    //$('#aaa').val(e);
    
	var ev = e || window.event;//获取event对象   
    var obj = ev.target || ev.srcElement;//获取事件源   
    var t = obj.type || obj.getAttribute('type');//获取事件源类型  
    
    if(key == 8){
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
</script>
</html>