<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
*{
	font-size:12pt;
}
ol{
	-webkit-padding-start: 4px;	
	margin:0 20px;
}
.head_div{
	text-align:center;	
	font-weight:bold;
}
.title{
	font-size: 24px;	
	margin:10px 0;
}
.sInfo{
	margin: 20px auto;
	text-align: center;
}

.sInfo span{
	width:80px;
}
.preblock{
	display: block;
    padding: 9.5px;
    margin: 18px 0 10px;
    /* font-size: 13px; */
    line-height: 1.428571429;
    color: #333;
    word-break: break-all;
    word-wrap: break-word;
    background-color: #f5f5f5;
    border: 1px solid #ccc;
    border-radius: 4px;
    white-space: pre-wrap;
}
.sanswer{
	color:red;
}
.answer_zg p{
	display:inline;
}
.answer_div{
	margin-top:20px;
}
</style>
<div id="dlg-toolbar" style="height:26px;">
	<!-- <a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a> -->
	<input type="hidden" id="eid" value="${eid}"/>		 	
	<input type="hidden" id="ename" value="${examInfo.ENAME}"/>		
	<input type="hidden" id="sname" value="${student.name}"/>		
</div>
<div style="text-align: center;">
	<%--<input type="button" value="保存为word" onclick="saveAsWord()">--%>
	<input type="button" value="返回" onclick="back()">
</div>
<div id="paper">
<div class="head_div">
	<div class="title">
		${organizationinfo.PARAM}${examInfo.SCHOOLYEAR}-${examInfo.SCHOOLYEAR + 1}学年 ${examInfo.TERMNAME}
	</div>
	<div class="eobject">
		${examObject}《${examInfo.ENAME}》
		<c:forEach var="et" items="${examTypeList}">
		    <c:if test="${examInfo.TYPE == et.ID}">
				${et.NAME}
			</c:if>				
		</c:forEach>
		<c:choose>
			<c:when test="${examInfo.AORB==0 }">
				(A卷)
			</c:when>
			<c:otherwise>
				(B卷)
			</c:otherwise>
		</c:choose>
	</div>
</div>
<div class="sInfo">
<span>姓名:</span><span style="text-decoration:underline;">${student.name}&nbsp;</span>
<span>学号:</span><span style="text-decoration:underline;">${student.num}&nbsp;</span>
<span>专业:</span><span style="text-decoration:underline;">${student.specialty_name}&nbsp;</span>
<span>年级:</span><span style="text-decoration:underline;">${student.grade_name}</span>
</div>
<h1 style="margin:30px; font-size: 18px; text-align: center;">学生答卷，当前总得分：<span style="color:red"><span class="amount">${averagescore}</span>分</span></h1>
	<c:set var="qindex" value="0"></c:set>
	<c:forEach var="qt" items="${sqt}" varStatus="t">
		<h1 style="margin:25px 0 8px; font-size: 14px;"><span class="qindex">${t.index + 1}</span>、&nbsp;${qt.QTNAME}&nbsp;(${qt.QTDESC})</h1>
		<c:forEach var="item" items="${res}">
			<c:choose>				
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && (qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==10||qt.ATID==11)}">
					<c:if test="${fn:startsWith(item.content,'<p>') == true}"><pre class="preblock">${fn:substring(item.content, 0, 3) } ${fn:substring(item.content,3, fn:length(item.content)) }</pre></c:if>
					<c:if test="${fn:startsWith(item.content,'<p>') == false}"><pre class="preblock">${item.content}</pre></c:if>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<c:set var="qindex" value="${qindex + 1}"></c:set>
								<!-- <pre class="preblock">${qindex}.${branch.content}</pre> -->
								<span class="qcontent">${qindex}.${branch.content}</span>
								<c:choose>
								    <c:when test="${qt.ATID == 0|| qt.ATID==2||qt.ATID==8}">								    	
								    	<ol Type="A">			
								    		<c:set var="rightAns"></c:set>
											<c:set var="stuAns"></c:set>								
									    	<c:forEach var="ans" items="${branch.answer}" varStatus="a">
									    		<c:if test="${ans.aid==branch.answerid }">
									    			<c:set var="rightAns" value="${a.index}"></c:set>
									    		</c:if>
									    		<c:if test="${ans.aid==branch.said }">
									    			<c:set var="stuAns" value="${a.index}"></c:set>
									    		</c:if>
												<li><span class="acontent">${ans.acontent}</span></li>
											</c:forEach>
										</ol>
								    	<div class="answer_div">
								    		试题答案:&nbsp;<span class="ansIndex">${rightAns}</span>
								    		<c:choose>
								    			<c:when test="${rightAns eq stuAns}">
								    				<span>学生答案:&nbsp;<span class="ansIndex">${stuAns}</span></span>
								    			</c:when>
								    			<c:otherwise>
								    				<span class="sanswer">学生答案:&nbsp;<span class="ansIndex">${stuAns}</span></span>
								    			</c:otherwise>
								    		</c:choose>
											<br/>
											得分:&nbsp;${branch.averagescore}分（此题满分:&nbsp;<span>${branch.score}分）
										</div>										
								    </c:when>
								    <c:when test="${qt.ATID == 1|| qt.ATID==3||qt.ATID==9}">
										<ol Type="A">
											<c:set var="ansOrder"></c:set>
											<c:set var="contact" value=","></c:set>
											<c:forEach var="ans" items="${branch.answer}" varStatus="a">
									    		<c:set var="ansOrder" value="${ansOrder }${contact }${ans.aid }"></c:set>								    		
												<li><span class="acontent">${ans.acontent}</span></li>
											</c:forEach>
										</ol>
								    	<div class="answer_div">
											试题答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${branch.answerid}</span>
											<c:choose>
												<c:when test="${branch.answerid eq branch.said}">
													<span>学生答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${branch.said}</span></span>
												</c:when>
												<c:otherwise>
													<span>学生答案:&nbsp;<span class="multiselect sanswer" ansOrder="${ansOrder }">${branch.said}</span></span>
												</c:otherwise>
											</c:choose>
											<br/>
											得分:&nbsp;${branch.averagescore}分（此题满分:&nbsp;<span>${branch.score}分）
										</div>										
								    </c:when>
							    </c:choose>								
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>				
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && qt.ATID == 4}">
					<c:if test="${fn:startsWith(item.content,'<p>') == true}"><pre class="preblock">${fn:substring(item.content, 0, 3) } ${fn:substring(item.content,3, fn:length(item.content)) }</pre></c:if>
					<c:if test="${fn:startsWith(item.content,'<p>') == false}"><pre class="preblock">${item.content}</pre></c:if>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<c:set var="qindex" value="${qindex + 1}"></c:set>
								<div class="qcontent">${qindex}.${branch.content}</div>
								<!-- <pre class="preblock"><p>${branch.content}</p></pre> -->
								<div class="answer_div">
									<span>试题答案:&nbsp;${branch.answer[0].acontent}</span>
									<c:choose>
										<c:when test="${branch.answer[0].acontent eq branch.sacontent}">
											<span>学生答案:&nbsp;${branch.sacontent}</span>
										</c:when>
										<c:otherwise>
											<span class="sanswer">学生答案:&nbsp;${branch.sacontent}</span>
										</c:otherwise>
									</c:choose>
									<br/>
									得分:&nbsp;${branch.averagescore}分（此题满分:&nbsp;<span>${branch.score}分）
								</div>
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>			
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && (qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11)}">
					<c:if test="${fn:startsWith(item.content,'<p>') == true}"><pre class="preblock">${fn:substring(item.content, 0, 3) } ${fn:substring(item.content,3, fn:length(item.content)) }</pre></c:if>
					<c:if test="${fn:startsWith(item.content,'<p>') == false}"><pre class="preblock">${item.content}</pre></c:if>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<c:set var="qindex" value="${qindex + 1}"></c:set>
								<div class="qcontent">${qindex}.${branch.content}</div>								
								<!-- <p>${branch.content}</p> -->
								<!-- <span>试题答案:&nbsp;
								<c:choose>
									<c:when test="${branch.answer[0].acontent_6=='undefined'}">
									</c:when>
									<c:otherwise>
										${branch.answer[0].acontent_6}
									</c:otherwise>
								</c:choose>
								</span>-->
								<div class="answer_div">
								试题答案:&nbsp;
								<span class="answer_zg">
									<c:choose>
										<c:when test="${branch.answer[0].acontent_6=='undefined'}">
										</c:when>
										<c:otherwise>
											${branch.answer[0].acontent_6}
										</c:otherwise>
									</c:choose>
								</span><br/>
								<span class="sanswer">学生答案:&nbsp;${branch.sacontent_6}</span>
								<br/>
								得分:&nbsp;${branch.averagescore}分（此题满分:&nbsp;<span>${branch.score}分）
								</div>
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>							
				
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && (qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==8||qt.ATID==9)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<!-- <pre class="preblock">${qindex}.${item.content}</pre> -->
					<div class="qcontent">${qindex}.${item.content}</div>
					<c:choose>
					    <c:when test="${qt.ATID == 0|| qt.ATID==2||qt.ATID==8}">
					    	<ol Type="A">
							<c:set var="rightAns"></c:set>
					    	<c:forEach var="ans" items="${item.answer}" varStatus="a">
					    		<c:if test="${ans.aid==item.answerid }">
					    			<c:set var="rightAns" value="${a.index}"></c:set>
					    		</c:if>					    		
					    		<c:if test="${ans.aid==item.said }">
					    			<c:set var="stuAns" value="${a.index}"></c:set>
					    		</c:if>
								<li><span class="acontent">${ans.acontent}</span></li>
							</c:forEach>
							</ol>
							<!-- 
					    	<c:set var="rightAns"></c:set>
					    	<c:set var="stuAns"></c:set>
					    	<c:forEach var="ans" items="${item.answer}" varStatus="a">
					    		<c:if test="${ans.aid==item.answerid }">
					    			<c:set var="rightAns" value="${a.index}"></c:set>
					    		</c:if>
					    		<c:if test="${ans.aid==item.said }">
					    			<c:set var="stuAns" value="${a.index}"></c:set>
					    		</c:if>
								<p><span class="ansIndex">${a.index}</span>.&nbsp;${ans.acontent}</p>
							</c:forEach> -->
							<div class="answer_div">
								试题答案:&nbsp;<span class="ansIndex">${rightAns}</span>
						    	<c:choose>
						    		<c:when test="${rightAns eq stuAns}">
						    			<span>学生答案:&nbsp;<span class="ansIndex">${stuAns}</span></span>
						    		</c:when>
						    		<c:otherwise>
						    			<span class="sanswer">学生答案:&nbsp;<span class="ansIndex">${stuAns}</span></span>
						    		</c:otherwise>
						    	</c:choose>
						    	<br/>
						    	得分:&nbsp;${item.averagescore}分（此题满分:&nbsp;<span>${item.score}分）
							</div>
					    </c:when>
					    <c:when test="${qt.ATID == 1|| qt.ATID==3||qt.ATID==9}">
					    	<ol Type="A">
						    	<c:forEach var="ans" items="${item.answer}" varStatus="a">							    		
									<li><span class="acontent">${ans.acontent}</span></li>
								</c:forEach>
							</ol>	
							<!-- 
					    	<c:set var="ansOrder"></c:set>
					    	<c:forEach var="ans" items="${item.answer}" varStatus="a">
					    		<c:set var="ansOrder" value="${ansOrder },${ans.aid }"></c:set>								    		
								<p><span class="ansIndex">${a.index}</span>.&nbsp;${ans.acontent}</p>
							</c:forEach> -->
							<div class="answer_div">
								试题答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${item.answerid}</span>
								<c:choose>
									<c:when test="${item.answerid eq item.said}">
										<span>学生答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${item.said}</span></span>
									</c:when>
									<c:otherwise>
										<span class="sanswer">学生答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${item.said}</span></span>
									</c:otherwise>
								</c:choose>
								<br/>
								得分:&nbsp;${item.averagescore}分（此题满分:&nbsp;<span>${item.score}分）
							</div>
					    </c:when>
				    </c:choose>					
				</c:when>							
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && qt.ATID == 4}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<div class="qcontent">${qindex}.${item.content}</div>
					<!--<c:if test="${fn:startsWith(item.content,'<p>') == true}"><pre class="preblock">${fn:substring(item.content, 0, 3) } ${qindex}.${fn:substring(item.content,3, fn:length(item.content)) }</pre></c:if>
					<c:if test="${fn:startsWith(item.content,'<p>') == false}"><pre class="preblock">${qindex}.${item.content}</pre></c:if>
					-->
					<div class="answer_div">
						<span>试题答案:&nbsp;${item.answer[0].acontent}</span>
						<c:choose>
							<c:when test="${item.answer[0].acontent eq item.sacontent}">
								<span><span>学生答案:&nbsp;${item.sacontent}</span></span>
							</c:when>
							<c:otherwise>
								<span class="sanswer"><span>学生答案:&nbsp;${item.sacontent}</span></span>
							</c:otherwise>
						</c:choose>
						<br/>
						得分:&nbsp;${item.averagescore}分（此题满分:&nbsp;<span>${item.score}分）
					</div>
				</c:when>						
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && (qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<div class="qcontent">${qindex}.${item.content}</div>
					<!--<c:if test="${fn:startsWith(item.content,'<p>') == true}"><pre class="preblock">${fn:substring(item.content, 0, 3) } ${qindex}.${fn:substring(item.content,3, fn:length(item.content)) }</pre></c:if>
					<c:if test="${fn:startsWith(item.content,'<p>') == false}"><pre class="preblock">${qindex}.${item.content}</pre></c:if>
					-->
					<div class="answer_div">
						试题答案:&nbsp;
						<span class="answer_zg">
							<c:choose>
								<c:when test="${item.answer[0].acontent_6=='undefined'}">
								</c:when>
								<c:otherwise>
									${item.answer[0].acontent_6}
								</c:otherwise>
							</c:choose>
						</span><br/>
						<span class="sanswer">学生答案:&nbsp;${item.sacontent_6}</span>
						<br/>
						得分:&nbsp;${item.averagescore}分（此题满分:&nbsp;<span>${item.score}分）
						</div>
				</c:when>		
			</c:choose>
		</c:forEach>
	</c:forEach>
<!-- 
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="window.history.go(-1);return false;">返回</a> 
</div> -->
</div>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/html2canvas/watermark.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$.each($('.ansIndex'),function(i,item){
		var s = $(item).html();
		$(item).html(String.fromCharCode(parseInt(s)+65));
	});
	$.each($('.multiselect'),function(i,item){
		var ansOrder = $(item).attr("ansOrder").substring(1).split(",");
		var arr = $(item).html().split(',');
		var res = '';
		for(var i=0; i<arr.length; i++){
			for(var j=0;j<ansOrder.length;j++){
				if(parseInt(arr[i])==parseInt(ansOrder[j])){
					res += String.fromCharCode(j+65) + ', ';
				}
			}			
		}
		res = res.substring(0,res.length-1);
		$(item).html(res);
	});

	$.get('${pageContext.request.contextPath}/viewPaper/getWaterMarkInfo')
			.done(function (info) {
				if(info===null || info===""){
					window.location.href="${pageContext.request.contextPath}/slogin";
				}else{
					initWaterMark(info);
				}
			})
			.fail(function (xhr) {
				window.location.href="${pageContext.request.contextPath}/slogin";
			});
	// 右键菜单
	document.addEventListener('contextmenu', (e) => {
		e.preventDefault();
	}, true);

	// 开始选择
	document.addEventListener('selectstart', (e) => {
		e.preventDefault();
	}, true);

	// 拖拽
	document.addEventListener('dragstart', (e) => {
		e.preventDefault();
	}, true);

	// 快捷键：Ctrl/Cmd + C / X / S / P / U（复制、剪切、保存、打印、查看源代码）
	document.addEventListener('keydown', (e) => {
		const k = e.key.toLowerCase();
		if ((e.ctrlKey || e.metaKey) && ['c','x','s','p','u','a'].includes(k)) {
			e.preventDefault();
		}
		// F12（开发者工具）理论上也可拦，但并不可靠
		if (e.key === 'F12') {  e.preventDefault();  }
	}, true);

	// 复制事件：直接阻止（或见“复制留痕”小节）
	document.addEventListener('copy', (e) => {
		e.preventDefault();
	}, true);

	// 防止通过双击选中后鼠标抬起复制
	document.addEventListener('mouseup', () => {
		const sel = window.getSelection?.();
		if (sel && sel.removeAllRanges) sel.removeAllRanges();
	}, true);

	/*
	var num = 0;
	$.each($('.qscore'),function(i,item){
		if($(item).text())
		num = (parseFloat(num) + parseFloat($(item).text())).toFixed(1);
		//num = Math.formatFloat(num + parseFloat($(item).text()), 1);
	});
	$('.amount').text(num);*/
	
	$.each($('.qindex'),function(i,item){
		var qindex = $(item).text();
		if(qindex && !isNaN(qindex)){
			$(item).text(NumberToChinese(qindex));
		}
	});
	
	$("ol").each(function(){
		var flag=0;
		$(this).find(".acontent").each(function(index,item){	
			var val=$(item).html();
			if(val.length==1){
				val=val.charCodeAt();
				if(val==(65+index)){
					flag=flag+1;
				}				
			}
		});
		if(flag==$(this).find(".acontent").length){
			$(this).empty();
		}
	});
	
	$(".qcontent").each(function(){
		var content=$(this).html();
		
		var index=content.indexOf(".");
		var xh=content.substring(0,index);		
		var con=content.substring(index+1);		
		var p=con.substring(0,3);
		
		if(p=='<p>'){
			content=con.substring(0,3)+xh+"."+con.substring(3);
		}else{
			content="<p>"+content+"</p>";
		}
		$(this).html(content);
	});
});

Math.formatFloat = function(f, digit) { 
    var m = Math.pow(10, digit); 
    return parseInt(f * m, 10)/m; 
}

function initWaterMark(text){
	watermark.init({
		watermark_txt: text,
		watermark_angle: 30,
		watermark_alpha: 0.13,
		watermark_fontsize: '23px',
		watermark_color: '#000',

		watermark_x: 20,
		watermark_y: 20,
		watermark_width: 250,
		watermark_height: 140,
		watermark_x_space: 120,
		watermark_y_space: 100,

		// 只覆盖试卷容器（建议给容器加 position:relative;）
		watermark_parent_node: 'paper',
		monitor: true
	});
}

function saveAsWord() {
	var name = "《"+$("#ename").val()+"》"+$("#sname").val()+"的答卷";
	var s = "*{font-size:12pt;} ol{-webkit-padding-start: 4px;margin:0 40px;} .head_div{text-align:center;font-weight:bold;} .title{font-size: 24px;margin:10px 0;}";
	s+=".sInfo{margin: 20px auto;text-align: center;} .sInfo span{width:80px;} ";
	s+=".preblock{display: block;padding: 9.5px;margin: 18px 0 10px;line-height: 1.428571429;color: #333;word-break: break-all;word-wrap: break-word;background-color: #f5f5f5;white-space: pre-wrap;}";
	s+=".sanswer{ color:red;} .answer_zg p{display:inline;} .answer_div{margin-top:20px;}";
	$("#paper").wordExport(name,s);
}

function back() {
	window.history.back(-1);
}


</script>	