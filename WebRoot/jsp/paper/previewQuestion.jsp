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
.courseTable {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 8px;
	width:100%;
}
.courseTable td, th {
	padding: 5px;
	line-height: 1.8;
	vertical-align: center;
	border-top: 1px solid #ddd; 
	border-radius: 8px;
}

.courseTable input[type="text"], .courseTable input[type="password"], .courseTable input[type="email"],
.courseTable textarea, .courseTable select {
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
.checkblock{
	border:1px solid #CCC;
	height:308px;
	width:1000px;
	overflow-y: scroll;
	margin-left:80px;
}
#answerCon{
	margin-left:80px;
}
.checkblock [type="text"]{
	width: 940px;
	font-size: 20px;
	border: none;
	border-bottom: 1px solid #777;
	margin-top:5px;
	
}
.title{
	/*background-color:#E0ECFF;*/
	padding:6px 0;
	text-align:center;
}
.title span {
	font-size: 18px;
}
.con{
	/* margin-left:60px; */
	width: 1280px;
}
.centerTD{
	text-align: center;
}
.tname{
	margin-right: 15px;
}
.wenzi{
	border-radius:0.5em;
	padding:0 0 0 10px;
	background:#EEF4FF;
}
.mainQuestion-tr{
	background:#EEF4FF;
}
</style>
<div id="pq">
	<div class="title"><span>${c_name}</span>
</div>
	<form id="questionForm" method="post" action="">
		<table width="100%" class="courseTable">
			<tr>
				<td align='right' >
					<span class="wenzi">题　型：</span>
				</td>
				<td align='left'>
					${mainQuestion.qtname}
				</td> 
				<td align='right' >
					<span class="wenzi">题　源：</span>
				</td>
				<td align='left'>
					${mainQuestion.soname}
				</td> 
				<td align='right' >
				</td>
				<td align='left'>
				</td> 
				<td align='right' >
				</td>
				<td align='left'>
				</td> 			
			</tr>
			<c:forEach var="arrangement" items="${mainQuestion.arragementList}" varStatus="status" begin="0">
				<tr>
					<td align='right' >
						<span class="wenzi">适应层次：</span>
					</td>
					<td align='left'>
						${arrangement.ANAME}
					</td> 
					<td align='right' >
						<span class="wenzi">认知分类：</span>
					</td>
					<td align='left'>
						${mainQuestion.cognitionList[status.index].CNAME}
					</td> 
					<td align='right' >
						 <span class="wenzi">难　度：</span>
					</td>
					<td align='left'>
						${mainQuestion.difficultyList[status.index].DNAME}
					</td> 
					<td align='right' >
						<span class="wenzi">知识点分布：</span>
					</td>
					<td align='left'>
						${mainQuestion.knowledgeList[status.index].KNAME}
					</td> 	
					<td align='right' >
						<span class="wenzi">应答时间：</span>
					</td>
					<td align='left'>
						<span name="time">${mainQuestion.answertimeList[status.index]}秒</span>
					</td>
				</tr>
			</c:forEach>
			
		</table>
		<table class="courseTable" width="100%" >
			<tr>
				<td align='right' style="width:10%;"><span class="wenzi">主题词：</span></td>
				<td style="width:90%;">
					<span class="tname">${mainQuestion.t1name}</span>
					<c:if test="${not empty mainQuestion.t2name}">
						<span class="tname">/</span>
						<span class="tname">${mainQuestion.t2name}</span>
					</c:if>
					<c:if test="${not empty mainQuestion.t3name}">						
						<span class="tname">/</span>
						<span class="tname">${mainQuestion.t3name}</span>
					</c:if>					
				</td>
			</tr>
		</table>
		<table class="courseTable" width="100%" >			
			<c:choose>
				<c:when test="${mainQuestion.ismain eq 1}">
					<tr>
						<td align='right' style="width:10%;"><span class="wenzi">题干：</span></td>
						<td style="width:90%;">
							${mainQuestion.content}
							<input type="hidden" id="mainQid" value="${mainQuestion.qid}"/>						
							<input type="hidden" id="mianVersion" value="${mainQuestion.version}"/>					
						</td>
					</tr>
					<tr>
						<td align='right' style="width:10%;"><span class="wenzi">附件：</span></td>
						<td style="width:90%;">
							<c:set var="fileurls" value="${fn:split(mainQuestion.filepath, ',')}" />
							<c:forEach items="${fileurls}" var="filepath">
								<c:choose>
									<c:when test="${fn:contains(filepath,'mp4')==true}">
										<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
									        <source src="${filepath}" type="video/mp4"/>
									    </video>
									</c:when>
									<c:when test="${fn:contains(filepath,'mp3')==true}">
										<audio src="${filepath}" controls="controls">
										Your browser does not support the audio element.
										</audio>
									</c:when>
									<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
										<img src="${filepath}" height="100px" class="zoomify" onclick="showimage(this)"/>
									</c:when>
								</c:choose>	
							</c:forEach>									
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td align='right' style="width:10%;"><span class="wenzi">题目：</span></td>
						<td style="width:90%;" id="mainQuestion">
							${mainQuestion.content}
							<div>
								<c:forEach var="answer" items="${mainQuestion.answerList }" varStatus="status">								
									${answer.ACONTENT }<c:if test="${xxdf==1}">&nbsp;&nbsp;(${answer.SCORE }分)</c:if><br/>
								</c:forEach>
							</div>
							
							<input type="hidden" id="mainQid" value="${mainQuestion.qid}"/>
						</td>
					</tr>
					<tr>
						<td align='right' style="width:10%;"><span class="wenzi">附件：</span></td>
						<td style="width:90%;">
							<c:set var="fileurls" value="${fn:split(mainQuestion.filepath, ',')}" />
							<c:forEach items="${fileurls}" var="filepath">
								<c:choose>
									<c:when test="${fn:contains(filepath,'mp4')==true}">
										<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
									        <source src="${filepath}" type="video/mp4"/>
									    </video>
									</c:when>
									<c:when test="${fn:contains(filepath,'mp3')==true}">
										<audio src="${filepath}" controls="controls">
										Your browser does not support the audio element.
										</audio>
									</c:when>
									<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
										<img src="${filepath}" height="100px" class="zoomify" onclick="showimage(this)"/>
									</c:when>
								</c:choose>	
							</c:forEach>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			
		</table>
		<c:forEach var="question" items="${questionList}" varStatus="q">			
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">题目分支${q.index+1}：</span></td>
					<td style="width:90%;" name="branchQuestion">
					${question.content}
					<div>
						<c:forEach var="answer" items="${question.answerList }" varStatus="status">								
							${answer.ACONTENT }<c:if test="${xxdf==1}">&nbsp;&nbsp;(${answer.SCORE }分)</c:if><br/>
						</c:forEach>
					</div>					
					</td>
				</tr>
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">附件：</span></td>
					<td style="width:90%;">
						<c:set var="fileurls" value="${fn:split(question.filepath, ',')}" />
						<c:forEach items="${fileurls}" var="filepath">
							<c:choose>
								<c:when test="${fn:contains(filepath,'mp4')==true}">
									<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
								        <source src="${filepath}" type="video/mp4"/>
								    </video>
								</c:when>
								<c:when test="${fn:contains(filepath,'mp3')==true}">
									<audio src="${filepath}" controls="controls">
									Your browser does not support the audio element.
									</audio>
								</c:when>
								<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
									<img src="${filepath}" height="100px" class="zoomify" onclick="showimage(this)"/>
								</c:when>
							</c:choose>	
						</c:forEach>
					</td>
				</tr>
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">答案：</span></td>
					<td style="width:90%;">
						${question.answer}
				    </td>
				</tr>
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">答案解释：</span></td>
					<td style="width:90%;">
						${question.exp}
					</td>
				</tr>
				<tr>
					<td align='right' style="width:10%;"></td>
					<td style="width:90%;">
						<a href="javascript:void(0)" class="easyui-linkbutton editQuestion" data-options="iconCls:'icon-edit',plain:true" onclick="editQuestion(${question.qid},0)">编辑分支</a>
						 &nbsp;<a href="javascript:void(0)" data-options="iconCls:'icon-cancel',plain:true" class="easyui-linkbutton" onclick="del(${question.qid})">删除分支</a>
					</td>
				</tr>
			</table>	
		</c:forEach>
		<c:if test="${isMain eq 0 && iscon eq 0}">
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">答案：</span></td>
					<td style="width:90%;">
						${mainQuestion.answer}
					</td>
				</tr>
			</table>
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;"><span class="wenzi">答案解释：</span></td>
					<td style="width:90%;">
						${mainQuestion.exp}
					</td>
				</tr>
			</table>
		</c:if>
		<table class="courseTable" width="100%">
			<tr>
				<td align="right" style="width:10%;">
					<span class="wenzi">编辑信息：</span>
				</td>
				<td style="width:90%">
					<c:if test="${not empty mainQuestion.creator}">
						创建人：${mainQuestion.creator}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.creator and not empty mainQuestion.creatorname}">
						创建人：${mainQuestion.creatorname}&nbsp;&nbsp;
					</c:if>
					<%-- <c:if test="${not empty mainQuestion.createtime}">
						创建时间：${mainQuestion.createtime}&nbsp;&nbsp;
					</c:if> --%>
					<c:if test="${not empty mainQuestion.verify}">
						审核人：${mainQuestion.verify}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.verify and not empty mainQuestion.verifyname}">
						审核人：${mainQuestion.verifyname}&nbsp;&nbsp;
					</c:if>
					<%-- <c:if test="${not empty mainQuestion.verifytime}">
						审核时间：${mainQuestion.verifytime}&nbsp;&nbsp;
					</c:if> --%>
					<c:if test="${not empty mainQuestion.updator}">
						更新人：${mainQuestion.updator}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.updator and not empty mainQuestion.updatorname}">
						更新人：${mainQuestion.updatorname}&nbsp;&nbsp;
					</c:if>
					<%-- <c:if test="${not empty mainQuestion.updatetime}">
						更新时间：${mainQuestion.updatetime}&nbsp;&nbsp;
					</c:if> --%>
				</td>
			</tr>
		</table>
    	<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
    	<input type="hidden" id="c_ids" name="c_ids" value="${c_ids}"/>
    	<input type="hidden" name="c_name" value="${c_name}"/>
		<input type="hidden" name="mqid" value="${mqid}"/> 
		<input type="hidden" id="isMain" name="isMain" value="${isMain}"/>
		<input type="hidden" name="iscon" value="${iscon}"/>
		<input type="hidden" id="q_id" name="q_id"/>
		<input type="hidden" id="eid" name="eid" value="${eid}"/>
		
	</form>


<div style="width: 100%; height: 40px; text-align: center;">
	<c:if test="${lastQuestion!=null}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-book_previous'" href="javascript:void(0);" onclick="getQuestionDetail('${lastQuestion.QID}','${lastQuestion.MQID}','${lastQuestion.CID}','${lastQuestion.ISMAIN}','${lastQuestion.ISCON}','${eid}','${edit}','${lastQuestion.ATID}')">上一题</a>
	</c:if>
	<c:if test="${empty edit or edit eq ''}">
		<c:choose>
			<c:when test="${mainQuestion.ismain eq 1}">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},${mainQuestion.ismain})">编辑题干</a>&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="del(${mainQuestion.qid})">删除题干</a>&nbsp;
			</c:when>
			<c:otherwise>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},0)">编辑题目</a>&nbsp;
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:if test="${nextQuestion!=null}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-book_next'" href="javascript:void(0);" onclick="getQuestionDetail('${nextQuestion.QID}','${nextQuestion.MQID}','${nextQuestion.CID}','${nextQuestion.ISMAIN}','${nextQuestion.ISCON}','${eid}','${edit}','${nextQuestion.ATID}')">下一题</a>
	</c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
</div>
<div id="imgModal"></div>
<script type="text/javascript">
var cids = $('#c_ids').val();
$(document).ready(function() {
	$("span[name='time']").each(function(){
		var time=parseInt($(this).html().substring(0,$(this).html().length-1));
		var hour = Math.floor(time/3600); 
		var minute=Math.floor((time-hour*3600)/60);
		if(minute<10){
			minute='0'+minute;
		}
	    var second = time - hour*3600 - minute*60;
	    
	    $(this).html(hour + "时" + minute + "分" + second+"秒");
	})
});

function editQuestion(qid,isMain){
	$('#q_id').val(qid);
	$('#isMain').val(isMain);
	$('#questionForm').attr('action','${pageContext.request.contextPath}/paper/editQuestion');
	$('#questionForm').submit();
	
}

function del(qid){
	$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/paper/delQuestion",
	            async: false,//改为同步方式
	            type: "POST",
	            data: { "q_id":qid,  "mqid": $("#mqid").val(),"ei_id":$("#eid").val()},
	            success: function (data) {
	            	if(isMain=="1"){
	            		window.history.go(-1);return false;
	            	}
	            	window.location.reload();
	     		}
	     	});	
	    }
	});
}

function getQuestionDetail(qid,mqid,cid,ismain,qtiscon,eid,edit,atid){
	var url = "${pageContext.request.contextPath}/paper/previewQuestion?qid="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&eid="+eid+"&c_ids="+cids+"&edit="+edit+"&atid="+atid;
	window.location.href = url;
}

function showimage(image){
	var source = $(image).attr("src");
    $('#imgModal').css("overflow","auto");
	var url = "<image style='width:auto;height:auto;' src='"+source+"' class='carousel-inner img-responsive img-rounded' />";
    $('#imgModal').dialog({
        title: '图片预览',
        width: 600,
        height: 500,
        closed: true,
        resizable: true,
        modal: true,
        content:url
    });
    $("#imgModal").dialog("open");
}
</script>