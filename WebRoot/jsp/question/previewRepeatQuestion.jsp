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
</style>
	<div class="title"><span>${c_name}</span></div>
	<form id="questionForm" method="post" action="${pageContext.request.contextPath}/question/inAddQuestion">
		<table width="100%" class="courseTable">
			<tr>
				<td align='right' >
					题　型：
				</td>
				<td align='left'>
					${mainQuestion.qtname}
				</td> 
				<td align='right' >
					题　源：
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
						适应层次：
					</td>
					<td align='left'>
						${arrangement.ANAME}
					</td> 
					<td align='right' >
						认知分类：
					</td>
					<td align='left'>
						${mainQuestion.cognitionList[status.index].CNAME}
					</td> 
					<td align='right' >
						 难　度：
					</td>
					<td align='left'>
						${mainQuestion.difficultyList[status.index].DNAME}
					</td> 
					<td align='right' >
						知识点分布：
					</td>
					<td align='left'>
						${mainQuestion.knowledgeList[status.index].KNAME}
					</td> 	
					<td align='right' >
						应答时间：
					</td>
					<td align='left'>
						${mainQuestion.answertimeList[status.index]}秒
					</td>
				</tr>
			</c:forEach>
			
		</table>
		<table class="courseTable" width="100%" >
			<tr>
				<td align='right' style="width:10%;">主题词：</td>
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
			<tr>
				<c:choose>
					<c:when test="${mainQuestion.ismain eq 1}">
						<td align='right' style="width:10%;">题干：</td>
						<td style="width:90%;">
							${mainQuestion.content}
							<input type="hidden" id="mainQid" value="${mainQuestion.qid}"/>							
						</td>
					</c:when>
					<c:otherwise>
						<td align='right' style="width:10%;">题目：</td>
						<td style="width:90%;" id="mainQuestion">
							${mainQuestion.content}
							<div>
								<c:forEach var="answer" items="${mainQuestion.answerList }" varStatus="status">								
									${answer.ACONTENT }<br/>
								</c:forEach>
							</div>
							
							<input type="hidden" id="mainQid" value="${mainQuestion.qid}"/>						
						</td>
					</c:otherwise>
				</c:choose>
			</tr>
		</table>
		<c:forEach var="question" items="${questionList}" varStatus="q">			
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;">题目分支${q.index+1}：</td>
					<td style="width:90%;" name="branchQuestion">
					${question.content}
					<div>
						<c:forEach var="answer" items="${question.answerList }" varStatus="status">								
							${answer.ACONTENT }<br/>
						</c:forEach>
					</div>
					
					</td>
				</tr>
				<tr>
					<td align='right' style="width:10%;">答案：</td>
					<td style="width:90%;">
						${question.answer}
				    </td>
				</tr>
				<tr>
					<td align='right' style="width:10%;">答案解释：</td>
					<td style="width:90%;">
						${question.exp}
					</td>
				</tr>
				<tr>
					<td align='right' style="width:10%;"></td>
					<td style="width:90%;">
						<a href="javascript:void(0)" class="easyui-linkbutton editQuestion" data-options="iconCls:'icon-edit',plain:true" onclick="editQuestion(${question.qid},0)">编辑分支</a>
						 &nbsp;<a href="javascript:void(0)" data-options="iconCls:'icon-cancel',plain:true" class="easyui-linkbutton" onclick="del(${question.qid},'0','1',${c_id})">删除分支</a>
					</td>
				</tr>
			</table>	
		</c:forEach>
		<c:if test="${isMain eq 0 && iscon eq 0}">
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;">答案：</td>
					<td style="width:90%;">
						${mainQuestion.answer}
					</td>
				</tr>
			</table>
			<table class="courseTable" width="100%" >
				<tr>
					<td align='right' style="width:10%;">答案解释：</td>
					<td style="width:90%;">
						${mainQuestion.exp}
					</td>
				</tr>
			</table>
		</c:if>
    	<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
		<input type="hidden" name="mqid" value="${mqid}"/> 
		<input type="hidden" id="isMain" name="isMain" value="${isMain}"/>
		<input type="hidden" name="iscon" value="${iscon}"/>
		<input type="hidden" id="q_id" name="q_id"/>
	</form>


<div style="width: 100%; height: 40px; text-align: center;">
	<c:choose>
		<c:when test="${mainQuestion.ismain eq 1}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},${mainQuestion.ismain})">编辑题干</a>&nbsp;
			<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="del(${mainQuestion.qid},${mainQuestion.ismain},'1',${c_id})">删除题干</a>&nbsp;
		</c:when>
		<c:otherwise>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="editQuestion(${mainQuestion.qid},0)">编辑题目</a>&nbsp;
		</c:otherwise>
	</c:choose>
	<c:set var="fun" value="新增试题" />
    <c:if test="${iscon == 1}">
    	<c:set var="fun" value="新增串题分支" />
    </c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0);" onclick="addQuestion()"><c:out value="${fun}"/></a>&nbsp;
	<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back()">返回列表</a> -->
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>

<script type="text/javascript">
$(document).ready(function() {
	
});
function addQuestion(){
	$('#questionForm').submit();
}
function editQuestion(qid,isMain){
	$('#q_id').val(qid);
	$('#isMain').val(isMain);
	$('#questionForm').attr('action','${pageContext.request.contextPath}/question/editQuestion');
	$('#questionForm').submit();
}

function del(qid, isMain,iscon,cid){
	$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/question/delQuestion",
	            async: false,//改为同步方式
	            type: "POST",
	            data: { "q_id":qid,  "isMain": isMain,"iscon":iscon,"cid":cid},
	            success: function (data) {
	            	//alert(data);
	            	if(isMain=="1"){
	            		window.history.go(-1);return false;;
	            	}
	            	window.location.reload();
	     		}
	     	});	
	    }
	});  
}
</script>