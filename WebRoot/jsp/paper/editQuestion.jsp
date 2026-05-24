<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.config.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.all.min.js"></script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/lang/zh-cn/zh-cn.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/kityformula-plugin/addKityFormulaDialog.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/kityformula-plugin/defaultFilterFix.min.js"></script>
<style>
tr{
	line-height: 20px;
}
td{
	font-size: 12px;
}
.checkblock{
	border:1px solid #CCC;
	height:auto;
	width:100%;
	overflow-y: scroll;
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

.window{
	position: fixed !important;
	top:30% !important;
}
.window-shadow{
	position: fixed !important;
	top:30% !important;
}
.iInput{
    position: absolute;
    width: 45px;
    height: 16px;
    left: 1px;
    top: 2px;
    border-bottom: 0px;
    border-right: 0px;
    border-left: 0px;
    border-top: 0px;
}
.window{
	top:10%!important;
}
table{
    border-collapse: collapse;
    border: none;
}
.hr-tr{
    border-bottom: solid #EEF4FF 3px;
}
.window-mask,
.window-shadow {
	display: none !important;
}
</style>
	<div class="title"><span>${c_name}</span></div>
	<form id="questionForm" method="post" action="${pageContext.request.contextPath}/paper/updateQuestion">
		<table style="width:100%; margin-top:20px;">
			<tr class="hr-tr">
				<td style="text-align: left">
					课程参数选项：
				</td>

				<td style="text-align: left">
					题型：
				</td>
				<td style="text-align: left">
				    <c:choose>
					    <c:when test="${! empty MainQuestion}">
						    <select id="questionTypeMain" name="questionTypeMain" style="width:100px;">
								<option value="${MainQuestion.qtid}">${MainQuestion.qtname}</option>
							</select>
						</c:when>
					    <c:otherwise>
					    	<select id="questionType" name="questionType" style="width:100px;">
					    		<option selected="selected" value="${question.qtid}">${question.qtname}</option>
							</select>
					    </c:otherwise>
				    </c:choose>				
				</td>
				<td style="text-align: left">
					题源：
				</td>
				<td style="text-align: left">
				    <%-- <c:choose>
					    <c:when test="${! empty MainQuestion}">
						    <select name="source"  style="width:100px;" >
								<option value="${MainQuestion.soid}">${MainQuestion.soname}</option>
							</select>
						</c:when>
					    <c:otherwise> --%>
					    	<select name="source" style="width:100px;">					    		
								<c:forEach var="source" items="${courseInfo.sourceList}">
									<c:choose>
										
									    <c:when test="${question.soid == source.SOID}">
									    	<option selected="selected" value="${source.SOID}">${source.SONAME}</option>
									    </c:when>
									    <c:otherwise>
									    	<option value="${source.SOID}">${source.SONAME}</option>
									    </c:otherwise>
								    </c:choose>
								</c:forEach>
							</select>
					    <%-- </c:otherwise>
				    </c:choose>		 --%>		
				</td>
				<td style="text-align: left">
				</td>
				<td style="text-align: left">
				</td>
				<td style="text-align: left">
				</td>
				<td style="text-align: left">
				</td>
				<td style="text-align: left">
				</td>
				<td style="text-align: left">
				</td> 
			</tr>
			<c:forEach var="arrangement" items="${courseInfo.arrangementList}"  varStatus="status" begin="0">
				<c:set var="flag" value="N"></c:set>
				<c:set var="index" value="-1"></c:set>
			<c:if test="${!status.last}"><tr></c:if>
			<c:if test="${status.last}"><tr class="hr-tr"></c:if>
				<td style="text-align: right">
					<c:forEach var="qarrangement" items="${question.arrangementList }" varStatus="qstatus" begin="0">
						<c:if test="${qarrangement.AID==arrangement.AID }">
							<c:set var="flag" value="Y"></c:set>
							<c:set var="index" value="${qstatus.index }"></c:set>
						</c:if>
					</c:forEach>
					<c:choose>
						<c:when test='${arrangement.AID==4}'>
							<input type="checkbox" name="cb" value="${status.index}"  onclick="return false;" checked="checked"/>
						</c:when>
						<c:when test='${flag=="Y"}'>
							<input type="checkbox" name="cb" value="${status.index}"  checked="checked"/>
						</c:when>
						<c:otherwise>
							<input type="checkbox" name="cb" value="${status.index}"/>
						</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: left">
					适应层次：
				</td>
				<td style="text-align: left">
					<select id="arrangement${status.index}" name="arrangement${status.index}" style="width:100px;">
						<option value="${arrangement.AID}">${arrangement.ANAME}</option>
					</select>
				</td>
				<td style="text-align: left">
					认知分类：
				</td>
				<td style="text-align: left">
					<select id="cognition${status.index}" name="cognition${status.index}"  style="width:100px;">
						<c:forEach var="cognition" items="${courseInfo.cognitionList}">
							<c:choose>
								<c:when test="${cognition.COID == question.cognitionList[index].CID}">
									<option selected="selected" value="${cognition.COID}">${cognition.CONAME}</option>
								</c:when>
								<c:otherwise>
									<option value="${cognition.COID}">${cognition.CONAME}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</td>
				<td style="text-align: left">
					难度：
				</td>
				<td style="text-align: left">
					<select id="difficulty${status.index}" name="difficulty${status.index}"  style="width:100px;">
						<c:forEach var="difficulty" items="${courseInfo.difficultyList}">
							<c:choose>
								<c:when test="${difficulty.DID == question.difficultyList[index].DID}">
									<option selected="selected" value="${difficulty.DID}">${difficulty.DNAME}</option>
								</c:when>
								<c:otherwise>
									<option value="${difficulty.DID}">${difficulty.DNAME}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</td>
				<td style="text-align: left">
					知识点分布：
				</td>
				<td style="text-align: left">
					<select id="knowledge${status.index}" name="knowledge${status.index}"  style="width:100px;" >
						<c:forEach var="knowledge" items="${courseInfo.knowledgeList}">
							<c:choose>
								<c:when test="${knowledge.KID == question.knowledgeList[index].KID}">
									<option selected="selected" value="${knowledge.KID}">${knowledge.KNAME}</option>
								</c:when>
								<c:otherwise>
									<option value="${knowledge.KID}">${knowledge.KNAME}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</td>
				<td style="text-align: left">
					应答时间：
				</td>
				<td style="text-align: left">
					<input type="hidden" class="time_init" value="${question.answertimeList[index]}" index="${status.index}"/>
					<div style="position:relative;display: inline-block;">
						<select style="width:65px;"
								onchange="changeTime(this.options[this.options.selectedIndex].value,${status.index},'hour');">
							<option value="-1" selected>自定义</option>
							<option value="0">0</option>
							<option value="1">1</option>
							<option value="2">2</option>
						</select>时
						<input id="input_hour${status.index}" name="input" class="iInput hour">
					</div>
					<div style="position:relative;display: inline-block;">
						<select style="width:65px;"
								onchange="changeTime(this.options[this.options.selectedIndex].value,${status.index},'minute');">
							<option value="-1" selected>自定义</option>
							<option value="0">0</option>
							<option value="5">5</option>
							<option value="10">10</option>
							<option value="15">15</option>
							<option value="20">20</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="35">35</option>
							<option value="40">40</option>
							<option value="45">45</option>
							<option value="50">50</option>
						</select>分
						<input id="input_minute${status.index}" name="input" class="iInput minute">
					</div>
					<div style="position:relative;display: inline-block;">
						<select style="width:65px;"
								onchange="changeTime(this.options[this.options.selectedIndex].value,${status.index},'second');">
							<option value="-1" selected>自定义</option>
							<option value="0">0</option>
							<option value="5">5</option>
							<option value="10">10</option>
							<option value="15">15</option>
							<option value="20">20</option>
							<option value="25">25</option>
							<option value="30">30</option>
							<option value="35">35</option>
							<option value="40">40</option>
							<option value="45">45</option>
							<option value="50">50</option>
						</select>秒
						<input id="input_second${status.index}" name="input" class="iInput second">
					</div>
				</td>
				</tr>
			</c:forEach>
			
		</table>		
		<c:choose>
	    	<c:when test="${! empty MainQuestion}">
				<table style="width: 100%">
					<tr class="hr-tr">
						<td style="margin-top:20px;text-align: left">选中主题词：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<c:set var="v_seq_char" value="/" />
							<c:set var="a_seq" value="${MainQuestion.t1name}${v_seq_char }${MainQuestion.t2name }${v_seq_char }${MainQuestion.t3name}" />
							${a_seq }
							<input type="hidden" name="firstTheme" style="width:280px;" value="${MainQuestion.t1id}"/>
							<input type="hidden" name="secondTheme" style="width:280px;" value="${MainQuestion.t2id}"/>						
							<input type="hidden" name="thirdTheme" style="width:280px;" value="${MainQuestion.t3id}"/>
						</td>
					</tr>
				</table>	    
			</c:when>
			<c:otherwise>
				<table style="margin-top:20px;width: 100%">
					<tr>
						<td style="text-align: left">选择主题词:</td>
						<td style="text-align: center">一级主题词</td>
						<td style="text-align: center">二级主题词</td>
						<td style="text-align: center">三级主题词</td>
					</tr>
					<tr>
						<td style="text-align: left"></td>
						<td style="text-align: center">
							<select id="theme1List" size="7" style='width:280px;height:150px;overflow-y: scroll;'  class="easyui-validatebox themeList" data-options="required:true">
								<c:forEach var="theme" items="${courseInfo.themeList}">
									<c:choose>
									    <c:when test="${question.t1id == theme.ID}">
									    	<option selected="selected" value="${theme.ID}">${theme.NAME}</option>
									    </c:when>
									    <c:otherwise>
									    	<option value="${theme.ID}">${theme.NAME}</option>
									    </c:otherwise>
								    </c:choose>
								</c:forEach>
							</select>
						</td>
						<td style="text-align: center">
							<select id="theme2List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList" >
							</select>
							<input type="hidden" id="t2val" value="${question.t2id}"/>
						</td>
						<td style="text-align: center">
							<select id="theme3List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList" >
							</select>
							<input type="hidden" id="t3val" value="${question.t3id}"/>
						</td>
					</tr>
					<tr >
						<td style="text-align: left; height: 40px;">选中主题词：</td>
						<td style="text-align: center">
							<input type="text" name="firstThemeText" style="width:280px;" value="${question.t1name}"/>
							<input type="hidden" name="firstTheme" style="width:280px;" value="${question.t1id}"/>
						</td>
						<td style="text-align: center">
							<input type="text" name="secondThemeText" style="width:280px;" value="${question.t2name}"/>
							<input type="hidden" name="secondTheme" style="width:280px;" value="${question.t2id}"/>
						</td>
						<td style="text-align: center">
							<input type="text" name="thirdThemeText" style="width:280px;" value="${question.t3name}"/>
							<input type="hidden" name="thirdTheme" style="width:280px;" value="${question.t3id}"/>
						</td>
					</tr>
				</table>
			</c:otherwise>
		</c:choose>
		<c:if test="${! empty MainQuestion}">
			<table style="margin-top:20px;background:#EEF4FF;width: 100%">
				<tr>
					<td style="width:10%;text-align: left">题干:</td>
					<td style="width:90%;text-align: left">
						<%-- <div style="margin-left:60px;width: 1280px;">${MainQuestion.CONTENT}</div> --%>
						<div id="mainCon">${MainQuestion.content}</div>
						<input type="hidden" id="mainQid" value="${MainQuestion.qid}"/>						
   						<input type="hidden" id="mianVersion" value="${MainQuestion.version}"/>
					</td>
				</tr>
			</table>    
		</c:if>
		<table style="margin-top:20px; width: 100%">
			<tr>
				<c:if test="${isMain==0&&iscon==0}">
					<td style="width:10%; text-align: left">题目编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<c:if test="${isMain==0&&iscon==1}">
					<td style="width:10%; text-align: left">分支题目编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<c:if test="${isMain==1}">
					<td style="width:10%;; text-align: left">共用题干编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<td style="width:90%; text-align: left">
					<script id="qcontent" name="qcontent" type="text/plain" style="width:100%;height:300px;">${question.content}</script> <%-- ${question.CONTENT} --%>
					<input type="hidden" id="qQid" value="${question.qid}"/>
   					<input type="hidden" id="qVersion" value="${question.version}"/>
				</td>
			</tr>
			<tr>
				<td style="width:10%; text-align: left"></td>
				<td style="width:90%;color:red; text-align: left">
					为保证视频播放效果，如需上传视频，请您选择“*.mp4”格式视频文件上传。
				</td>
			</tr>
		</table>
		<table width="100%"  style="margin-top:20px">	
			<tr>
				<td style="width:10%; text-align: left">附件:</td>
				<td style="width:30%; text-align: left">
					<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="upload()">上传附件</a>		
				</td>
				<td style="width:70%; text-align: left" id="fileList">
					<c:if test="${ question.filepath!=null and question.filepath!=''}">						
						<c:set var="fileurls" value="${question.filepath}" />
						<c:if test="${fn:contains(question.filepath,',') }">
							<c:set var="fileurls" value="${fn:split(question.filepath, ',')}" />
						</c:if>
						<c:forEach items="${fileurls}" var="filepath">
							<input type="checkbox" name="fileUrl" value="${filepath }" checked="checked"/>${filepath }
						</c:forEach>						
					</c:if>					
				</td>
			</tr>
		</table>
		<c:if test="${isMain==0}">		
			<table id="answerTable" style="margin-top:20px;width: 100%">
				<tr>
					<td style="width:10%;; text-align: left">
						<c:if test="${isMain==0&&iscon==0}">
							答案编辑：
						</c:if>
						<c:if test="${isMain==0&&iscon==1}">
							分支答案编辑：
						</c:if>	
						<div id="button_div" style="display:none;">
							<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addAnswer()"></a>
							<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-remove'" onclick="removeAnswer()"></a>
						</div>
						<div style="margin-top:10px;">
							<a class="easyui-linkbutton" href="javascript:void(0);" onclick="separateOption()">选项分离</a>
						</div>
					</td>
					<td id="answerArea" style="width:100%;; text-align: left">
					
					</td>
				</tr>
				<tr id="fill_tr" style="display:none;">
					<td style="width:10%; text-align: left"></td>
					<td style="width:100%; text-align: left">
						<!-- <textarea rows="6" cols="200" id="optionFill">《选项通过换行区别》</textarea> -->
						<div id="optionFill" contenteditable="plaintext-only" style="width:100%;min-height:200px;border:1px solid #CCCCCC" tabindex="2" onfocus="clearDiv()" onblur="fillDiv()">[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color="#D3D3D3">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font></div>
						<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="autoFill()">自动识别填充试题</a>
					</td>
				</tr>
			</table>
			<table id="explainTable" style="margin-top:20px;width: 100%">
				<tr>
					<td style="width:10%;margin-top:80px; text-align: left">
						<c:if test="${isMain==0&&iscon==0}">
							答案解释：
						</c:if>
						<c:if test="${isMain==0&&iscon==1}">
							分支答案解释：
						</c:if>	
					</td>
					<td style="width:90%; text-align: left">
						<textarea id="qexplain" name="qexplain" style="width:100%;height:220px;">${question.exp}</textarea>
						<!-- <script id="qexplain" name="qexplain" type="text/plain" style="width:100%;height:220px;">${question.exp}</script>  -->
					</td>
				</tr>
			</table>
		</c:if>
		
    	<input id="AnswerType" type="hidden" name="AnswerType" value="${question.atid }"/>
    	<input id="correct" type="hidden" name="correct" />
    	<input type="hidden" id="cid" name="cid" value="${c_id}"/>
    	<input type="hidden" id="c_ids" name="c_ids" value="${c_ids}"/>
    	<input type="hidden" id="eid" name="eid" value="${eid}"/>
    	<input type="hidden" id="qid" name="qid" value="${qid}"/>
    	<input type="hidden" id="mqid" name="mqid" value="${mqid}"/>
    	<input type="hidden" id="iscon" name="iscon" value="${iscon}"/>
    	<input type="hidden" id="isMain" name="isMain" value="${isMain}"/>
		<input type="hidden" id="isB" name="isB" value="${isB}"/>
		<input type="hidden" id="xxdf" name="xxdf" value="${question.xxdf}"/>
		<input type="hidden" id="arrangement" name="arrangement"/>
		<input type="hidden" id="cognition" name="cognition"/>
		<input type="hidden" id="difficulty" name="difficulty"/>
		<input type="hidden" id="knowledge" name="knowledge"/>
		<input type="hidden" id="answertime" name="answertime"/>
		<input type="hidden" id="cognition_b" name="cognition_b"/>
		<input type="hidden" id="difficulty_b" name="difficulty_b"/>
		<input type="hidden" id="knowledge_b" name="knowledge_b"/>
		<input type="hidden" id="answertime_b" name="answertime_b"/>
		
		<c:set var="v_seq_char" value="¿" />
		<c:set var="a_seq" value="" />
		<c:set var="aids" value=""/>
		<c:set var="acontents" value=""/>
		<c:set var="ascores" value=""/>
		<c:forEach var="answerList" items="${question.answerList }">
			<c:set var="aids" value="${aids}${answerList.AID}${v_seq_char}"/>
			<c:set var="acontents" value="${acontents}${answerList.ACONTENT}${v_seq_char}"/>
			<c:set var="ascores" value="${ascores}${answerList.SCORE}${v_seq_char}"/>
			<c:set var="a_seq" value="${a_seq}${answerList}${v_seq_char }" />
		</c:forEach>
		<input type="hidden" id="acontents" name="acontents" value="${fn:escapeXml(acontents)}"/>
		<input type="hidden" id="ascores" name="ascores" value="${fn:escapeXml(ascores)}"/>
		<input type="hidden" id="aids" name="aids" value="${aids}"/>
		<input type="hidden" id="rightAnswer" name="rightAnswer" value="${fn:escapeXml(question.answerid) }"/>
		<input type="hidden" id="rightAnswerContent_6" name="rightAnswerContent_6" value="${fn:escapeXml(question.content_6)}"/>
		<input type="hidden" id="filepath" name="filepath" value="${question.filepath}" />
		<input type="hidden" id="isAddIntoCourse" name="isAddIntoCourse" value="0" />
		<input type="hidden" id="syncToQuestionBank" name="syncToQuestionBank" value="0" />
	</form>	


<div style="width: 100%; height: 40px; text-align: center;">
	<c:if test="${lastQuestion!=null}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-book_previous'" href="javascript:void(0);" onclick="gotoEditQuestion('${lastQuestion.QID}','${lastQuestion.MQID}','${c_id}','${lastQuestion.ISMAIN}','${lastQuestion.ISCON}','${eid}','${pageNumber}','${pageNumber}')">上一题</a>
	</c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="updateQuestion()">更新</a>&nbsp;
	<c:if test="${nextQuestion!=null}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-book_next'" href="javascript:void(0);" onclick="gotoEditQuestion('${nextQuestion.QID}','${nextQuestion.MQID}','${c_id}','${nextQuestion.ISMAIN}','${nextQuestion.ISCON}','${eid}','${pageNumber}','${pageNumber}')">下一题</a>
	</c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
<div id="uploadFileDIV"></div>
<div id="optionWin" class="easyui-window" title="在线编辑器" style="width:800px;" data-options="iconCls:'icon-save',modal:true" align="center">   
	<script id="optionEditor" name="optionEditor" type="text/plain" style="width:100%;height:400px;">-</script>
	<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="saveOption()">保存</a>
</div>
<script type="text/javascript">
var content;
var explain;
var answer;
var option;
var AnswerType=$("#AnswerType").val();
var iscon = $("#iscon").val();
var mqid = $("#mqid").val();
var isMain = $("#isMain").val();
var cids = $('#c_ids').val();
var isB = $("#isB").val();
var xxdf= $("#xxdf").val();

$(document).ready(function() {
	content = UE.getEditor('qcontent');
    content.ready(function(){
        content.execCommand('fontfamily','Times New Roman, 宋体');
        content.execCommand('fontsize', '16px');
    });
	if($('#qexplain').length >0){
		explain = UE.getEditor('qexplain',{wordCount:true,maximumWords:4000});
        explain.ready(function(){
            explain.execCommand('fontfamily','Times New Roman, 宋体');
            explain.execCommand('fontsize', '16px');
        });
	}	
	option = UE.getEditor('optionEditor', {
		toolbars: [['source', '|', 'undo', 'redo', '|',
                  'bold', 'italic', 'underline', 'fontborder', 'strikethrough', 'superscript', 'subscript', 'removeformat', 'formatmatch', 'pasteplain', '|',
                  'forecolor', 'backcolor', '|',
                  'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'kityformula']
		],
		enterTag : 'br'
	});
    option.ready(function(){
        option.execCommand('fontfamily','Times New Roman, 宋体');
        option.execCommand('fontsize', '16px');
    });
	//覆盖UEditor中获取路径的方法
	UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
	UE.Editor.prototype.getActionUrl = function(action) {
		if (action === 'uploadimage' || action === 'uploadvideo' || action === 'uploadfile') {
			return "${pageContext.request.contextPath}/upload/uploadFile"
					+ "?action=normal"
					+ "&cid=" + $("#cid").val();
		} else if (action === 'catchimage') {
			return "${pageContext.request.contextPath}/upload/uploadFile"
					+ "?action=catchimage"
					+ "&cid=" + $("#cid").val();
		}
		return this._bkGetActionUrl.call(this, action);
	}


	$('#optionWin').window({
		minimizable:false,
		maximizable:false,
		resizable:false,
		closed:true

	});
	
	if(iscon == 1 && isMain == 0){
		
	}else{
		getThemeList(2, $('#theme1List').val());
		getThemeList(3, $('#t2val').val());
		for(var i=0;i<$('#theme2List').find('option').length;i++){
			if($('#theme2List').find('option:eq(' + i + ')').val()==$('#t2val').val()){			
				$('#theme2List').find('option:eq(' + i + ')').attr("selected","selected");
			}
		}
		for(var i=0;i<$('#theme3List').find('option').length;i++){
			if($('#theme3List').find('option:eq(' + i + ')').val()==$('#t3val').val()){			
				$('#theme3List').find('option:eq(' + i + ')').attr("selected","selected");
			}
		}
	}
	
	defaultAnswerArea(AnswerType);
	
	$('#questionType').change(function(){
		var qtid = $('#questionType').val();
		var cid=$("#cid").val();
		$.ajax({
			url:'${pageContext.request.contextPath}/common/getAnswerType',
			async: false, 
			type: "POST",
			data: {"qtid": qtid,"cid":cid}, 
			success: function (data) {
				AnswerType=data.ATID;
				iscon = data.ISCON;
	        	xxdf=data.XXDF;
	        	$("#xxdf").val(data.XXDF);
				$("#AnswerType").val(data.ATID);
				defaultAnswerArea(data.ATID);
			}
		});
	});
	
	
	$.each($(".time_init"),function(i,item){
		var index=$(item).attr("index");
		if($(item).val()!=""){
			var sec = parseInt($(item).val());
			var min = 0;
			var hour = 0;
			if(sec >= 60){
				min = parseInt(sec / 60);
				sec = parseInt(sec % 60);
				if(min >= 60){
					hour = parseInt(min / 60);
					min = parseInt(min % 60);
				}
			}
			
			$("#input_second"+index).val(sec);		
			if(min > 0) $("#input_minute"+index).val(min);
			if(hour > 0) $("#input_hour"+index).val(hour);
		}
		
	})
	
	$(".hour").on('input',function(){
		var val = $(this).val();
		if(val > 24){
			$(this).val(24);
		}
	})
	
	$(".min").on('input',function(){
		var val = $(this).val();
		if(val > 59){
			$(this).val(59);
		}
	})
	
	$(".second").on('input',function(){
		var val = $(this).val();
		if(val > 59){
			$(this).val(59);
		}
	})
	
	
});

/*
function getSameAtidQuestionType(){
	var qid = $('#qid').val();
	var rs = '';
	$.ajax({
		url:"${pageContext.request.contextPath}/question/getSameAtidQuestionTypeByQid",
		async:false,
		type: "POST",
        data: {"qid":qid},
        success:function(data){
        	rs = data;
        }
	});
	var qtid = $('#questionType').val();
	for(var i=0;i<rs.length;i++){
		if(qtid != rs[i].QTID){
			var o = '<option value="'+rs[i].QTID+'">'+rs[i].QTNAME+'</option>'
			$('#questionType').append(o);
		}
	}
	
}*/
function changeTime(val,index,type){
	if(val==-1){
		if(type=='hour'){
			document.getElementById('input_hour'+index).select();
		}else if(type=='minute'){
			document.getElementById('input_minute'+index).select();
		}else if(type=='second'){
			document.getElementById('input_second'+index).select();
		}
		return;
	}else{
		if(type=='hour'){
			document.getElementById('input_hour'+index).value=val;
		}else if(type=='minute'){
			document.getElementById('input_minute'+index).value=val;
		}else if(type=='second'){
			document.getElementById('input_second'+index).value=val;
		}		
	}
}


function defaultAnswerArea(atid){
	var answerAreaStr;
	$('#answerArea').html(null);
	if(atid<4||atid==8||atid==9){//选择题
		$("#button_div").css("display","block");
		answerAreaStr = '<div class="checkblock" name="answerDiv">';	
		
		var aids = (($('#aids').val()).substring(0,($('#aids').val()).length-1)).split("¿");
		//var acontents = (($('#acontents').val()).substring(0,($('#acontents').val()).length-1)).replace(/"/g,"&quot;").split("¿");
		var acontents = (($('#acontents').val()).substring(0,($('#acontents').val()).length-1)).split("¿");
		var ascores = (($('#ascores').val()).substring(0,($('#ascores').val()).length-1)).split("¿");
		
		for(var i=0;i<aids.length;i++){
			var aid = aids[i];
			var acontent = acontents[i];
			var ascore = ascores[i];
			if(atid==0 || atid==2 || atid==8){//单选
				answerAreaStr += '<input type="radio" name="answerId" ovalue="'+aid+'" value="'+i+'"/>'
				+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'
				if(xxdf==1){
					answerAreaStr+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'">'+acontent+'</div>';
				}else{
					answerAreaStr+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'">'+acontent+'</div>';
				}
				answerAreaStr+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>';
				if(xxdf==1){
					answerAreaStr+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score" value="'+ascore+'"/>分</span>';
				}
				answerAreaStr+='<br/>';
			}else{//多选
				answerAreaStr += '<input type="checkbox" name="answerId" ovalue="'+aid+'" value="'+i+'"/>'
				+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'
				if(xxdf==1){
					answerAreaStr+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'">'+acontent+'</div>';
				}else{
					answerAreaStr+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'">'+acontent+'</div>';
				}
				answerAreaStr+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>';
				if(xxdf==1){
					answerAreaStr+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score" value="'+ascore+'"/>分</span>';
				}
				answerAreaStr+='<br/>';
			}
		}
		
		answerAreaStr += '</div>';
		$(answerAreaStr).appendTo('#answerArea');
		
		var rightAnswer = ($("#rightAnswer").val()).split(",");
		$('input[name=answerId]').each(function(){
			for(var key in rightAnswer){
				if($(this).attr("ovalue")==rightAnswer[key]){
					$(this).attr("checked","true");
					break;
				}
			}
		});
		$("#fill_tr").show();
	}else if(atid==4){	//判断题
		$("#button_div").css("display","none");
		var rightAnswer = $("#rightAnswer").val();
		if(rightAnswer=='true'){
			answerAreaStr = '<div id="answerCon"><label style="line-height: 100px;"><input type="radio" value="true" name="answerCon" checked="true"/>&nbsp;对</label>'
			+'<label style="line-height: 100px; margin-left: 50px"><input type="radio" value="false" name="answerCon"/>&nbsp;错</label></div>';
		}else{
			answerAreaStr = '<div id="answerCon"><label style="line-height: 100px;"><input type="radio" value="true" name="answerCon"/>&nbsp;对</label>'
			+'<label style="line-height: 100px; margin-left: 50px"><input type="radio" value="false" name="answerCon" checked="true"/>&nbsp;错</label></div>';
		}
		
		$(answerAreaStr).appendTo('#answerArea');
		$("#fill_tr").hide();
	}else{	
		$("#button_div").css("display","none");	
		//var acontent = $("#rightAnswer").val();//answerid
        var acontent =$("#rightAnswerContent_6").val();
		answerAreaStr = '<div id="answerCon"><script id="qanswer" ovalue="'+aid+'" name="answerCon" type="text/plain" style="width:100%;height:220px;" /></div>';
		$(answerAreaStr).appendTo('#answerArea');
		$("#qanswer").val(acontent);
		UE.delEditor('qanswer');
		answer = UE.getEditor('qanswer',{wordCount:true,maximumWords:4000});
		
		$("#fill_tr").hide();
	}
	
}

function getCorrect(){
	var resStr = "";
	$('input[name=answerId]:checked').each(function(){
		resStr += $(this).val() + ",";
	});
	resStr = resStr.substring(0, resStr.length-1);
	return resStr;
}

function checkQuestion(){
	$(".option").each(function(){
		var prex=$(this).attr("name");
		$("#"+prex).val($(this).html());
	});
	if(content.getContent()==""||content.getContent()==null){
		toastr.warning('请编辑题目');
		return false;
	}

	var isMain = $("#isMain").val();
	if(isMain==0){ //非主题干
		if(parseInt(AnswerType)<4){
			var isNull = false;
			$.each($('input[attr=answer]'),function(i,item){
				if($(item).val()==''){
					isNull = true;
				}else if($(item).val().indexOf('&nbsp;')!=-1 || $(item).val().indexOf('<br>')!=-1){
					if($(item).val().replace(/&nbsp;/g,'').replace(/<br>/g,'').trim()==''){
						isNull = true;
					}
				}
			});
			if(isNull){
				toastr.warning('答案选项不能为空');
				return false;
			};
			if(!$('input[name=answerId]').is(':checked')){
				toastr.warning('请勾选正确答案');
				return false;
			}
			$("#correct").val(getCorrect());
		}else if(parseInt(AnswerType)==4){
			if(!$('input[name=answerCon]').is(':checked')){
				toastr.warning('请勾选正确答案');
				return false;
			}
		}else{
			if(answer.getContent()==""||answer.getContent()==null){
				toastr.warning('请编辑答案');
				return false;
			}
		}
	}

	if(!$('input[name=firstTheme]').val()){
		toastr.warning('请选中主题词');
		return false;
	}

	var filepath = "";
	$.each($('input[name=fileUrl]:checkbox'),function(){
		if(this.checked){
			filepath += $(this).val()+",";
		}
	});
	if(filepath!=""){
		filepath=filepath.slice(0, filepath.length-1);
	}
	$("#filepath").val(filepath);

	//获取所有适应层次
	var arrangement = "";
	var cognition = "";
	var difficulty = "";
	var knowledge = "";
	var answertime = "";
	var index = -1;
	var continueDo=true;
	$("input[name=cb]:checked").each(function(){
		var i = $(this).val();
		var prex1 = "arrangement"+i;
		var prex2 = "cognition"+i;
		var prex3 = "difficulty"+i;
		var prex4 = "knowledge"+i;
		var prex_h="input_hour"+i;
		var prex_m="input_minute"+i;
		var prex_s="input_second"+i;

		if($("#"+prex1).val()=="4"){
			index = i;
		}else{
			arrangement += $("#"+prex1).val()+",";
			cognition += $("#"+prex2).val()+",";
			difficulty += $("#"+prex3).val()+",";
			knowledge += $("#"+prex4).val()+",";
			var t = 0;
			var hour=$("#"+prex_h).val();
			var min=$("#"+prex_m).val();
			var sec=$("#"+prex_s).val();
			if(hour != ""){
				t += parseInt(hour) * 60 * 60;
			}
			if(min != ""){
				t += parseInt(min) * 60;
			}
			if(sec != ""){
				t += parseInt(sec);
			}
			if(t==0){
				toastr.warning('请输入时间');
				continueDo=false;
				return false;
			}
			answertime += t+",";
		}
	});
	if(!continueDo){
		return false;
	}
	if(index>-1){
		arrangement += $("#arrangement"+index).val();
		cognition += $("#cognition"+index).val();
		difficulty += $("#difficulty"+index).val();
		knowledge += $("#knowledge"+index).val();
		$("#cognition_b").val($("#cognition"+index).val());
		$("#difficulty_b").val($("#difficulty"+index).val());
		$("#knowledge_b").val($("#knowledge"+index).val());
		var t = 0;
		var hour=$("#input_hour"+index).val();
		var min=$("#input_minute"+index).val();
		var sec=$("#input_second"+index).val();
		if(hour != ""){
			t += parseInt(hour) * 60 * 60;
		}
		if(min != ""){
			t += parseInt(min) * 60;
		}
		if(sec != ""){
			t += parseInt(sec);
		}
		if(t==0){
			toastr.warning('请输入时间');
			return false;
		}
		$("#answertime_b").val(t);
		answertime += t;
	}else{
		arrangement = arrangement.substring(0, arrangement.length-1);
		cognition = cognition.substring(0, cognition.length-1);
		difficulty = difficulty.substring(0, difficulty.length-1);
		knowledge = knowledge.substring(0, knowledge.length-1);
		answertime = answertime.substring(0, answertime.length-1);
	}

	$("#arrangement").val(arrangement);
	$("#cognition").val(cognition);
	$("#difficulty").val(difficulty);
	$("#knowledge").val(knowledge);
	$("#answertime").val(answertime);

	//如果选项得分，检查答案分值是否最高
	if(xxdf==1){
		var atid=$("#AnswerType").val();
		if(atid==0||atid==2){
			var check_index=$("input[name=answerId]:checked").val();
			var high_index=0;
			var score=0;
			$.each($('input[attr=score]'),function(i,item){
				if(parseInt($(this).val())>parseInt(score)){
					score=$(this).val();
					high_index=i;
				}
			});
			if(check_index!=high_index){
				toastr.warning('勾选答案项的分值应是最高分值，请设置好选项分值！');
				return false;
			}
		}
	}
}

function updateQuestion(){
	if(checkQuestion()===false){
		return false;
	}
    var contentStr=content.getContent();
    var objE = document.createElement("div");
    objE.innerHTML = contentStr;
    var oldStr=$(objE).html();
    $(objE).find("span").each(function(){
        var sss=$(this).html().trim().toLowerCase();
        if(sss=='<br>'||sss=='<br/>'){
            $(this).remove();
        }
    });
    $(objE).find("p").each(function(){
        if($(this).html()==''){
            $(this).remove();
        }
    });

    content.setContent($(objE).html());
	$("#isAddIntoCourse").val("0");

	var oldOk = $.messager.defaults.ok;
	var oldCancel = $.messager.defaults.cancel;
	$.messager.defaults.ok = "是";
	$.messager.defaults.cancel = "否";
	$.messager.confirm("同步确认",'是否同步更新试题库？',function(r){
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel;
		if(r){
			$("#syncToQuestionBank").val("1");
		}else{
			$("#syncToQuestionBank").val("0");
		}

		if(oldStr.length!=$(objE).html().length){
			$.messager.confirm("提示",'系统检测到试题内容有空的换行，已替换，继续请点击确定，需要检查请点击取消',function(r2){
				if (!r2){
					return;
				}else{
					$('#questionForm').submit();
				}
			});
		}else{
			$('#questionForm').submit();
		}
	});
}

function getThemeList(th_level, th_pid){
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getThemeList",
        async: false, 
        type: "POST",
        data: {"th_level": th_level, "th_pid": th_pid, "c_id": $("#cid").val()}, 
        success: function (data) {
        	var thStr = '#theme' +  th_level + 'List';
        	$(thStr).html(null);
        	var str;
			$.each(eval(data),function(i,item){
				str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
			});
			$(thStr).append(str);
 		}
 	});	
}


$('#theme1List').change(function(){
	$('input[name=firstThemeText]').val($(this).find("option:selected").text());
	$('input[name=firstTheme]').val($(this).val());
	getThemeList(2, $(this).val());
	getThemeList(3, $(this).val());
	$('input[name=secondThemeText]').val(null);
	$('input[name=secondTheme]').val(null);
	$('input[name=thirdThemeText]').val(null);
	$('input[name=thirdTheme]').val(null);
});

$('#theme2List').change(function(){
	$('input[name=secondThemeText]').val($(this).find("option:selected").text());
	$('input[name=secondTheme]').val($(this).val());
	getThemeList(3, $(this).val());
	$('input[name=thirdThemeText]').val(null);
	$('input[name=thirdTheme]').val(null);
});

$('#theme3List').change(function(){
	$('input[name=thirdThemeText]').val($(this).find("option:selected").text());
	$('input[name=thirdTheme]').val($(this).val());
});

function gotoEditQuestion(qid,mqid,cid,ismain,qtiscon,eid){
	if(mqid==''){
		mqid='';
	}
	var url = "${pageContext.request.contextPath}/paper/editQuestion?q_id="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&eid="+eid+"&c_ids="+cids+"&isB="+isB;
	
	window.location.href = url;
}

function addAnswer(){
	if(AnswerType==0||AnswerType==2||AnswerType==8){
		var i=$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]").length;
		if(i>19){
			toastr.error('选项最多20个');
			return;
		}
		var str='<input type="radio" name="answerId" value="'+i+'"/>'
			+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'+'<span>'+String.fromCharCode(i+ 65)+'</span>'
			if(xxdf==1){
				str+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
			}else{
				str+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
			}
			str+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>';
			if(xxdf==1){
				str+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score"/>分</span>';
			}
			str+='<br/>';
		$("#answerArea").find("div[name=answerDiv]").append(str);
	}else if(AnswerType==1||AnswerType==3||AnswerType==9){//多选
		var i=$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]").length;
		if(i>19){
			toastr.error('选项最多20个');
			return;
		}
		var str='<input type="checkbox" name="answerId" value="'+i+'"/>'+'<span>'+String.fromCharCode(i+ 65)+'</span>'
		+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'
		if(xxdf==1){
			str+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
		}else{
			str+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
		}
		str+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>'
		if(xxdf==1){
			str+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score"/>分</span>';
		}
		str+='<br/>';
		$("#answerArea").find("div[name=answerDiv]").append(str);
	}
}

function removeAnswer(){
	var i=$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]").length-1;
	if(i<2){
		toastr.error('选项至少保留2个');
		return;
	}
	$("#answerArea").find("div[name=answerDiv]").find("input[name=answer"+i+"]").remove();
    $("#answerArea").find("div[name=answerDiv]").find("span:last").remove();
	$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]:last").remove();
	$("#answerArea").find("div[name=answerDiv]").find("div[name=answer"+i+"]").remove();
	$("#answerArea").find("div[name=answerDiv]").find("img:last").remove();
	if(xxdf==1){
		$("#answerArea").find("div[name=answerDiv]").find("span:last").remove();
	}
	$("#answerArea").find("div[name=answerDiv]").find("br:last").remove();
}

function upload(){
	var winStr = '<form id="uploadFileForm" method="post" enctype="multipart/form-data">'
			+ '<table width="100%"><tr><td>'
			+ '<input id="fileToUpload" type="file" name="fileToUpload" onchange="fileSelected()" value="" multiple="multiple"/>'
			+ '<a id="uploadFile" style="display:none" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:\'icon-save\'" onclick="uploadFile()">上传</a>'
			+ '</td></tr>'
			+ '<tr><td id="upload_tip" style="color:red;">文件类型限制为：mp4,mp3,mov,flv,mpg,avi,jpg,jpeg,png,gif,bmp</td></tr>'
			+ '</table></form>';
			
		var obj = $(winStr);
		$('#uploadFileDIV').html(null);
		obj.appendTo('#uploadFileDIV');
		$('#uploadFileDIV').window({
			width:440,
			height:130,
			modal:true,
			title:"上传附件",
			collapsible:false,
			minimizable:false,
			maximizable:false
			//content:winStr
		});
	
}

function fileSelected() {
	$("#upload_tip").html("<span style='color:Red'>文件类型限制为：mp4,mp3,mov,flv,mpg,avi,jpg,jpeg,png,gif,bmp</span>");
	var file = $("#fileToUpload").get(0).files[0];         
	var fileName = file.name;
	var file_typename = (fileName.substring(fileName.lastIndexOf('.'), fileName.length)).toLowerCase();
	if (file_typename == '.mov' || file_typename == '.flv' || file_typename == '.mpg' || file_typename == '.mp4' || file_typename == '.avi' || file_typename == '.mp3'|| file_typename == '.jpg'|| file_typename == '.jpeg'|| file_typename == '.png'|| file_typename == '.gif'|| file_typename == '.bmp') {//这里限定上传文件文件类型
        if (file) {  
             $("#uploadFile").show();
             $("#upload_tip").html("<span style='color:Green'>文件类型限制为：mp4,mp3,mov,flv,mpg,avi,jpg,jpeg,png,gif,bmp,该文件类型正确</span>");
         }
     }else{  
         $("#uploadFile").hide();
         $("#upload_tip").html("<span style='color:Red'>错误提示:文件类型限制为：mp4,mp3,mov,flv,mpg,avi,jpg,jpeg,png,gif,bmp,请重新选择文件</span>");
      }
}
  
function uploadFile() {
	var fileToUpload = $("#fileToUpload").get(0).files[0],
    formData = new FormData(); 	    
    formData.append("fileToUpload", fileToUpload);
    formData.append("cid",$("#cid").val());
    
    if (/\.(jpg|jpeg|png|gif|bmp)$/.test(fileToUpload.name)) {
    	var size = fileToUpload.size;
    	var allowSize = 2*1024*1024;
    	if(size>allowSize){
    		alert("图片文件大小不能超过2MB");
    		return ;
    	}
    }
    $("#upload_tip").html("<span style='color:blue;'>正在上传，请稍后……</span>");
    var xhr = $.ajaxSettings.xhr(); 
    $.ajax({
       type: "POST",
       url: "${pageContext.request.contextPath}/question/addFile", // 后端服务器上传地址
       data: formData, // formData数据
       cache: false, // 是否缓存
       async: true, // 是否异步执行
       processData: false, // 是否处理发送的数据  (必须false才会避开jQuery对 formdata 的默认处理)
       contentType: false, // 是否设置Content-Type请求头
       dataType:"text",
       xhr: function() {
           if (xhr.upload) {
               return xhr;
           }
       },
       success: function(data) {
       		if(data=="error"){
       			$("#uploadFile").hide();       			
       			$("#upload_tip").html("<span style='color:blue;'>上传失败：系统错误，建议选择mp4或mp3格式的文件</span>");
       		}else{
       			var fileStr = '<input type="checkbox" name="fileUrl" value="'+data+'" checked="checked"/>'+data;
       			$("#fileList").append(fileStr);
	       		$("#uploadFile").hide();
	       		$("#upload_tip").html("<span style='color:blue;'>上传成功</span>");
       		}       		
       },
       error: function(data) {
       		$("#uploadFile").hide();
       		$("#upload_tip").html("<span style='color:blue;'>上传失败："+data+"</span>");
       }
   }); 
}

function optionWinopen(id) {
	div_id=id;
	option.setContent($("div[name="+div_id+"]").html());
	$('#optionWin').window('open');  // open a window
	$('#optionWin').window('window').css('z-index', 1001);
}
function saveOption(){
	$("div[name="+div_id+"]").html(option.getContent());
	option.setContent("");
	$('#optionWin').window('close'); 
}
function clearDiv(){
	var content=$("#optionFill").html().trim();
	if(content.indexOf("智能填写")>0){
		$("#optionFill").html("");
	}
}
function fillDiv(){
	var content=$("#optionFill").html().trim();
	if(content==''){
		$("#optionFill").html("[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color=\"#D3D3D3\">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font>");
	}
}
function autoFill(){
	var str=$("#optionFill").html().split("#");
	var qcontent=str[0];
	content.setContent(qcontent);
	var ocontent=str[1].trim();
	var cont=ocontent.split("\n");
	var option_length=$("#answerArea").find(".option").length;
	var fill_length=cont.length;
	if(option_length>fill_length){
		for(var i=option_length-fill_length;i>0;i--){
			removeAnswer();
		}
	}else{
		for(var i=0;i<fill_length-option_length;i++){
			addAnswer();
		}
	}
	$("#answerArea").find(".option").each(function(index){
		$(this).html(cont[index]);
	});
	$("#optionFill").html("[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color=\"#D3D3D3\">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font>");
}

function separateOption(){
	var qtid = $('#questionTypeMain').val();
	if(qtid=="155_0_1"){
		toastr.warning('B1型题不做选项分离。');
		return;
	}
	var details=content.getContent();
    var arr=new Array();
    if(details.indexOf(".mp4")>0){
        var vd=details.substring(0,details.indexOf(".mp4"));
        vd=vd.substring(vd.lastIndexOf("/kaoyi_upload"));
        arr.push(vd+".mp4");
    }
    if(details.indexOf(".mp3")>0){
        var vd=details.substring(0,details.indexOf(".mp3"));
        vd=vd.substring(vd.lastIndexOf("/kaoyi_upload"));
        arr.push(vd+".mp3");
    }
    var reg=/<(?!img|sub|sup|\/sub|\/sup).*?>/g;
	details=details.replace(reg,'');
	var fgf=".";
	if(details.indexOf("A． ")>0){
		fgf="． ";
	}else if(details.indexOf("A.")>0){
		fgf=".";
	}else if(details.indexOf("A、")>0){
		fgf="、";
	}else if(details.indexOf("A,")>0){
		fgf=",";
	}else if(details.indexOf("A ")>0){
		fgf=" ";
	}else if(details.indexOf("A，")>0){
		fgf="，";
	}else if(details.indexOf("A:")>0){
		fgf=":";
	}else if(details.indexOf("A：")>0){
		fgf="：";
	}else if(details.indexOf("A．")>0){
		fgf="．";
	}
	
	var detail_content=details.substring(0,details.indexOf("A"+fgf));
    for(var i = 0; i < arr.length; i++) {
        // if(arr[i].indexOf(".mp4")>-1){
        var str='<p><video class="edui-upload-video  vjs-default-skin  video-js" controls="" preload="none" width="420" height="280" src="'+arr[i]+'">';
        str+='<source src="'+arr[i]+'" type="video/mp4"/></video></p>';
        detail_content+=str;
        // }
    }
	content.setContent(detail_content);
	
	for(var i=0;i<20;i++){
		var letter=String.fromCharCode(65+i);
		var letter_next=String.fromCharCode(66+i);
		if(details.indexOf(letter_next+fgf)>0){
			var detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length+1),details.indexOf(letter_next+fgf));
			if(!($(".option").eq(i).length>0)){
				addAnswer();
			}
			$(".option").eq(i).html(detail_letter);
		}else{
			var detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length+1));
			if(!($(".option").eq(i).length>0)){
				addAnswer();
			}
			$(".option").eq(i).html(detail_letter);
			break;
		}
	}
}
</script>