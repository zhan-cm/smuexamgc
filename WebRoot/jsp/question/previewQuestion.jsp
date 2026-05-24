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
.courseTable tr, th {
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
	<div class="title"><span>${c_name}</span></div>
	<form id="questionForm" method="post" action="${pageContext.request.contextPath}/question/inAddQuestion">
		<table width="100%" class="courseTable">
			<tr>
				<td align='right'>
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
				<td align='left'>
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
					<tr class="mainQuestion-tr">
						<td align='right' style="width:10%;"><span class="wenzi">题干：</span></td>
						<td style="width:90%;">
							${mainQuestion.content}
							<input type="hidden" id="mainQid" value="${mainQuestion.qid}"/>						
						</td>
					</tr>
					<tr  class="mainQuestion-tr">
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
										<img src="${filepath}" height="100px" onclick="showimage(this)"/>
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
										<img onclick="showimage(this)" src="${filepath}" height="100px" />
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
									<img src="${filepath}" height="100px" onclick="showimage(this)"/>
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
						 &nbsp;<a href="javascript:void(0)" data-options="iconCls:'icon-cancel',plain:true" class="easyui-linkbutton" onclick="del(${question.qid},'0','1',${c_id},this)">删除分支</a>
					</td>
				</tr>
			</table>
			<hr style="FILTER:alpha(opacity=100,finishopacity=0,style=3)" color="#BED5FF" SIZE="3">
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
						试题录入：${mainQuestion.creator}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.creator and not empty mainQuestion.creatorname}">
						试题录入：${mainQuestion.creatorname}&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty mainQuestion.createtime}">
						录入时间：${mainQuestion.createtime}&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty mainQuestion.verify}">
						审核人：${mainQuestion.verify}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.verify and not empty mainQuestion.verifyname}">
						试题审核：${mainQuestion.verifyname}&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty mainQuestion.verifytime}">
						审核时间：${mainQuestion.verifytime}&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty mainQuestion.updator}">
						最新编辑者：${mainQuestion.updator}&nbsp;&nbsp;
					</c:if>
					<c:if test="${empty mainQuestion.updator and not empty mainQuestion.updatorname}">
						最新编辑者：${mainQuestion.updatorname}&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty mainQuestion.updatetime}">
						最新编辑时间：${mainQuestion.updatetime}&nbsp;&nbsp;
					</c:if>
				</td>
			</tr>
		</table>
    	<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
		<input type="hidden" name="mqid" value="${mqid}"/> 
		<input type="hidden" id="isMain" name="isMain" value="${isMain}"/>
		<input type="hidden" name="iscon" value="${iscon}"/>
		<input type="hidden" id="q_id" name="q_id"/>
	</form>

<div style="width: 100%; height: 40px; text-align: center;">
	<c:forEach var="res" items="${lastQuestion}">
		<c:if test="${not empty res.QID}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-book_previous'" href="javascript:void(0);" onclick="getQuestionDetail('${res.QID}','${res.MQID}','${res.CID}','${res.ISMAIN}','${res.ISCON}','${edit}')">上一题</a>
		</c:if>
	</c:forEach>
	<c:if test="${empty edit or edit eq ''}">
		<c:choose>
			<c:when test="${mainQuestion.ismain eq 1}">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},${mainQuestion.ismain})">编辑题干</a>&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="del(${mainQuestion.qid},${mainQuestion.ismain},'1',${c_id},this)">删除题干</a>&nbsp;
			</c:when>
			<c:otherwise>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},0)">编辑题目</a>&nbsp;
			</c:otherwise>
		</c:choose>		
	</c:if>	
	<c:set var="fun" value="新增试题" />
    <c:if test="${iscon == 1}">
    	<c:set var="fun" value="新增串题分支" />   
    </c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0);" onclick="addQuestion()"><c:out value="${fun}"/></a>&nbsp;
	<c:if test="${mainQuestion.state==0 || empty mainQuestion.verify}">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-ok'"  href="javascript:void(0);" onclick="verify('${mainQuestion.qid}','${mainQuestion.ismain}')">审核入库</a>
		<a class="easyui-linkbutton" data-options="iconCls:'icon-bookmark_delete'"  href="javascript:void(0);" onclick="verify_no()">审核不通过</a>
	</c:if>	
	<a class="easyui-linkbutton" data-options="iconCls:'icon-database_copy'"  href="javascript:void(0);" onclick="copy('${mainQuestion.qid}')">复制试题</a> 
	<c:forEach var="res" items="${nextQuestion}" varStatus="status">
		<c:if test="${not empty res.QID}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-book_next'" href="javascript:void(0);" onclick="getQuestionDetail('${res.QID}','${res.MQID}','${res.CID}','${res.ISMAIN}','${res.ISCON}','${edit}')">下一题</a>
		</c:if>
	</c:forEach>
	
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
</div>

	<div id="imgModal">
    </div>
<script type="text/javascript">
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
function addQuestion(){
	var params = {};
	params["cid"] = $("#c_id").val();
	params["permission"] = "question:add"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$('#questionForm').submit();
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
	
}

function editQuestion(qid,isMain){
	var params = {};
	params["cid"] = $("#c_id").val();
	params["permission"] = "question:update"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$('#q_id').val(qid);
				$('#isMain').val(isMain);
				$('#questionForm').attr('action','${pageContext.request.contextPath}/question/editQuestion');
				$('#questionForm').submit();
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
	
}


function del(qid, isMain,iscon,cid,elt){
	var params = {};
	params["cid"] = $("#c_id").val();
	params["permission"] = "question:del"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){ 
				    if (r){
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/question/delQuestion",
				            async: false,//改为同步方式
				            type: "POST",
				            data: { "q_id":qid,  "isMain": isMain,"iscon":iscon,"cid":cid},
				            success: function (data) {
				            	if(isMain=="1"){
				            		//window.history.go(-1);return false;
				            		var ifmdlg = window.parent.document.getElementById("ifmdlg");
									$(ifmdlg).parent().next().next().remove();
									$(ifmdlg).parent().next().remove();
									$(ifmdlg).parent().remove();
				            	}else{
				            		//window.location.reload();
				            		$(elt).parent().parent().parent().remove();
				            	}
				            	
				     		}
				     	});	
				    }
				}); 
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});	 
}

function getQuestionDetail(qid,mqid,cid,ismain,qtiscon,edit){
	//console.log(cids);
	//console.log(eid);
	let param = ''
	let paramObj = localStorage.getItem("questionListParam");
	if(paramObj){
		paramObj = JSON.parse(paramObj);
		for(const k in paramObj){
			if(k == 'c_id'){
				continue;
			}
			param = param + '&' + k+'=' + paramObj[k];
		}
	}
	var url = "${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&edit="+edit+param;
	//console.log(url);
	window.location.href = url;
}

function showimage(image){
	var source = $(image).attr("src");
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
    $('#imgModal').css("overflow","auto");
}

function verify(qid, ismain){
	let params = {};
	params["cid"] = $("#c_id").val();
	params["permission"] = "question:verify"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
				$.messager.confirm("提示",'是否让此试题通过审核入库 ?',function(r){
				    if (r){	    	
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/question/verifyQuestion?state="+1,
				            async: false,//改为同步方式
				            type: "POST",
				            data: { "q_id":qid, "isMain":ismain, "cid": $("#c_id").val()},
				            success: function (data) {
				            	if(data==0){
				            		toastr.success("审核成功");
				            		//location.reload();
				            	}else{
				            		toastr.warning("审核失败");
				            		
				            	}	        	
				     		}
				     	});	
				    }else{
				    	return;
				    }
				});
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
	
}

function verify_no(){
	let params = {};
	params["cid"] = $("#c_id").val();
	params["permission"] = "question:verify";
	$.ajax({
		contentType: "application/json; charset=utf-8",
		url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
		async: false,
		type: "POST",
		data: JSON.stringify(params),
		success: function (data) {
			if(data==1){
				$.messager.confirm("提示",'是否让此试题不通过审核 ?',function(r){
					if (r){
						$.ajax({
							url: "${pageContext.request.contextPath}/question/verifyQuestion",
							async: false,//改为同步方式
							type: "POST",
							data: { "q_id":'${mainQuestion.qid}', "isMain":'${mainQuestion.ismain}', "cid": $("#c_id").val(), state:"-1",verify_suggestion:""},
							success: function (data) {
								if(data==0){
									toastr.success("操作成功");
								}else{
									toastr.warning("操作失败");

								}
							}
						});
					}else{
						return;
					}
				});
			}else if(data==0){
				toastr.warning("无相关权限");
			}else{
				toastr.error("登录超时，请重新登录！");
			}
		}
	});
}

function copy(qid){
	window.location.href = "${pageContext.request.contextPath}/question/copyQuestion?qid="+qid;
}
</script>