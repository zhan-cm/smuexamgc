<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.config.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
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
table{
    border-collapse: collapse;
    border: none;
}
.hr-tr{
    border-bottom: solid #EEF4FF 3px;
}
.ai-generate-btn {
	display: inline-block;
	padding: 11px 20px;
	font-size: 14px;
	color: #fff;
	background-color: #007BFF;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	text-align: center;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	transition: background-color 0.3s ease;
}

.ai-generate-btn:hover {
	background-color: #0056b3;
}

#loadingMask {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5); /* 半透明背景 */
	z-index: 1000; /* 确保遮罩层位于最前 */
	display: flex;
	justify-content: center;
	align-items: center;
}

#loadingMessage {
	background-color: #fff;
	padding: 20px;
	border-radius: 5px;
	font-size: 16px;
	color: #333;
}

.spinner {
	background-color: #fff;
	border: 4px solid rgba(0, 0, 0, 0.1); /* 边框 */
	border-left-color: #333; /* 旋转的部分 */
	border-radius: 50%;
	width: 25px;
	height: 25px;
	margin-right: 15px;
	animation: spin 1s linear infinite;
}
.dialog-item{
	display: flex;
	flex-direction: row;
	justify-content: center;
	margin-top: 10px;
	width: 100%;
}

.dialog-item .form-control-item{
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: flex-start;
	margin-left: 10px;
	width: 60%;
}

.form-control-item textarea{
	width: 100%;
	font-size: 20px;
	font-family: "Times New Roman", Times, serif;
}

.t2s-swal-custom{
	max-height: 500px;
	overflow-y: auto;
	width: 1000px;
	border-top: 10px solid white;
}

/* 定义旋转动画 */
@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}
</style>
	<div class="title"><span>${courseInfo.name_c}</span></div>
	<div style="display: flex; justify-content: center;align-items: center;">
		<c:if test="${applicationScope.AI_En_TTS.YL_1 eq 1}">
			<button style="margin-left: 5px; margin-right: 5px" type="button" class="ai-generate-btn" onclick="openTTSFrame()">使用文字生成音频功能（适合英语听力题）</button>
		</c:if>
	</div>
	<form id="questionForm" method="post" action="${pageContext.request.contextPath}/question/updateQuestion">
		<table style="margin-top:20px;width: 100%;" id="tab1">
			<tr class="hr-tr">
				<td align='left'>
					课程参数选项：
				</td>
				 
				<td align='left' >
					题型：
				</td>
				<td align='left'>
				    <c:choose>
					    <c:when test="${! empty MainQuestion}">
						    <select id="questionTypeMain" name="questionTypeMain" style="width:100px;">
								<option value="${MainQuestion.qtid}">${MainQuestion.qtname}</option>
							</select>
						</c:when>
					    <c:otherwise>
					    	<select id="questionType" name="questionType"  style="width:100px;">
					    		<option selected="selected" value="${question.qtid}">${question.qtname}</option>
							</select>
					    </c:otherwise>
				    </c:choose>				
				</td> 
				<td align='left' >
					题源：
				</td>
				<td align='left'>
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
				</td> 
				<td align='left' >
				</td>
				<td align='left' >
				</td> 
				<td align='left' >
				</td>
				<td align='left' >
				</td> 
				<td align='left' >
				</td> 
				<td align='left' >
				</td> 
				<td align='left' >
				</td> 
			</tr>
			    	<c:forEach var="arrangement" items="${courseInfo.arrangementList}"  varStatus="status" begin="0">
			    		<c:set var="flag" value="N"></c:set>
			    		<c:set var="index" value="-1"></c:set>
			    		<c:if test="${!status.last}"><tr></c:if>  
			    		<c:if test="${status.last}"><tr class="hr-tr"></c:if> 
			    			<td align='right'>    			
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
							<td align='left'>
								适应层次：
							</td>
							<td align='left'>
								<select id="arrangement${status.index}" name="arrangement${status.index}" style="width:100px;">
									<option value="${arrangement.AID}">${arrangement.ANAME}</option>
								</select>
							</td>
							<td align='left' >
								认知分类：
							</td>
							<td align='left'>
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
							<td align='left' >
								 难度：
							</td>
							<td align='left'>								
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
							<td align='left' >
								知识点分布：
							</td>
							<td align='left'>								
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
							<td align='left' >
								应答时间：
							</td>
							<td align='left'>
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
			    	
			   <%--  </c:otherwise>
		    </c:choose>	 --%>
			
		</table>		
		<c:choose>
	    	<c:when test="${! empty MainQuestion}">
				<table width="100%">
					<tr class="hr-tr">
						<td align='left' style="margin-top:20px;">选中主题词：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
				<table width="100%"  style="margin-top:20px;">
					<tr>
						<td align='left'>选择主题词:</td>
						<td align='center'>一级主题词</td>
						<td align='center'>二级主题词</td>
						<td align='center'>三级主题词</td>
					</tr>
					<tr>
						<td align='left'></td>
						<td align='center'>
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
									<%-- <option value="${theme.ID}">${theme.NAME}</option> --%>
								</c:forEach>
							</select>
						</td>
						<td align='center'>
							<select id="theme2List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList" >
							</select>
							<input type="hidden" id="t2val" value="${question.t2id}"/>
						</td>
						<td align='center'>
							<select id="theme3List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList" >
							</select>
							<input type="hidden" id="t3val" value="${question.t3id}"/>
						</td>
					</tr>
					<tr >
						<td align='left' height='40'>选中主题词：</td>
						<td align='center'>
							<input type="text" name="firstThemeText" style="width:280px;" value="${question.t1name}"/>
							<input type="hidden" name="firstTheme" style="width:280px;" value="${question.t1id}"/>
						</td>
						<td align='center'>
							<input type="text" name="secondThemeText" style="width:280px;" value="${question.t2name}"/>
							<input type="hidden" name="secondTheme" style="width:280px;" value="${question.t2id}"/>
						</td>
						<td align='center'>
							<input type="text" name="thirdThemeText" style="width:280px;" value="${question.t3name}"/>
							<input type="hidden" name="thirdTheme" style="width:280px;" value="${question.t3id}"/>
						</td>
					</tr>
				</table>
			</c:otherwise>
		</c:choose>
		<c:if test="${! empty MainQuestion}">
			<table width="100%"  style="margin-top:20px;background:#EEF4FF;">	
				<tr>
					<td align='left' style="width:10%;">题干:</td>
					<td align='left' style="width:90%;">
						<div id="mainCon">${MainQuestion.content}</div>
						<input type="hidden" id="mainQid" value="${MainQuestion.qid}"/>
					</td>
				</tr>
			</table>    
		</c:if>
		<table width="100%"  style="margin-top:20px">	
			<tr>
				<c:if test="${isMain==0&&iscon==0}">
					<td align='left' style="width:10%;">题目编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<c:if test="${isMain==0&&iscon==1}">
					<td align='left' style="width:10%;">分支题目编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<c:if test="${isMain==1}">
					<td align='left' style="width:10%;">共用题干编辑：
					<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
					</td>
				</c:if>
				<td align='left' style="width:90%;">
					<script id="qcontent" name="qcontent" type="text/plain" style="width:100%;height:300px;">${question.content}</script>
					<input type="hidden" id="qQid" value="${question.qid}"/>
				</td>
			</tr>
			<tr>
				<td align='left' style="width:10%;"></td>
				<td align='left' style="width:90%;color:red;">
					为保证视频播放效果，如需上传视频，请您选择“*.mp4”格式视频文件上传。
				</td>
			</tr>
		</table>
		<table width="100%"  style="margin-top:20px">	
			<tr>
				<td align='left' style="width:10%;">附件:</td>
				<td align='left' style="width:30%;"> 		
					<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="upload()">上传附件</a>		
				</td>
				<td align='left' style="width:70%;" id="fileList">	
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
			<table width="100%"  id="answerTable" style="margin-top:20px">	
				<tr>
					<td align='left' style="width:10%;">
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
					<td align='left' id="answerArea" style="width:100%;">				
					
					</td>
				</tr>
				<tr id="fill_tr" style="display:none;">
					<td align='left' style="width:10%;"></td>
					<td align='left' style="width:100%;">
						<div id="optionFill" contenteditable="plaintext-only" style="width:100%;min-height:200px;border:1px solid #CCCCCC;padding: 8px;margin-bottom:10px;" tabindex="2" onfocus="clearDiv()" onblur="fillDiv()">[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color="#D3D3D3">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font></div>
						<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="autoFill()">自动识别填充试题</a>
					</td>
				</tr>
			</table>
			<table width="100%"  id="explainTable" style="margin-top:20px">		
				<tr>
					<td align='left' style="width:10%;margin-top:80px;">
						<c:if test="${isMain==0&&iscon==0}">
							答案解释：
						</c:if>
						<c:if test="${isMain==0&&iscon==1}">
							分支答案解释：
						</c:if>	
					</td>
					<td align='left' style="width:90%;">
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
		<input type="hidden" id="pageSize" name="pageSize" value="${pageSize}"/>
		<input type="hidden" id="pageNumber" name="pageNumber" value="${pageNumber}"/>
		<input type="hidden" id="filepath" name="filepath" value="${question.filepath}" />
		<input type="hidden" id="copy" name="copy" value="${copy}" />
	</form>	


<div style="width: 100%; height: 40px; text-align: center;">
	<c:forEach var="res" items="${lastQuestion}" varStatus="status">
		<c:if test="${not empty res.QID}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-book_previous'" href="javascript:void(0);" onclick="gotoEditQuestion('${res.QID}','${res.MQID}','${c_id}','${res.ISMAIN}','${res.ISCON}','${eid}','${pageNumber}','${pageNumber}')">上一题</a>
		</c:if>
	</c:forEach>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="updateQuestion()">更新</a>&nbsp;
	<c:forEach var="res" items="${nextQuestion}" varStatus="status">
		<c:if test="${not empty res.QID}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-book_next'" href="javascript:void(0);" onclick="gotoEditQuestion('${res.QID}','${res.MQID}','${c_id}','${res.ISMAIN}','${res.ISCON}','${eid}','${pageNumber}','${pageNumber}')">下一题</a>
		</c:if>
	</c:forEach>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
<div id="uploadFileDIV"></div>
<div id="loadingMask" style="display:none;">
	<div class="spinner"></div> <!-- 旋转图标 -->
	<span id="loadingMessage">正在加载，请稍候...</span>
</div>
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
var copy=$("#copy").val();

Function.prototype.heredoc = function(){
    // 利用 function 的注释来存储字符串，而且无需转义。
    var _str = this.toString(),
        s_pos = _str.indexOf("/*")+2,
        e_pos = _str.lastIndexOf("*/");
    return (s_pos<0 || e_pos<0) ? "" : _str.substring(s_pos, e_pos);
}
function fn(){
	/*${question.content}*/
}

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

$(document).ready(function() {
	content = UE.getEditor('qcontent');
	
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
	/*option.ready(function(){
        option.execCommand('fontfamily','Times New Roman, 宋体');
        option.execCommand('fontsize', '16px');
    });
    if(!(copy=="Y")){
		content.ready(function(){
	        content.execCommand('fontfamily','Times New Roman, 宋体');
	        content.execCommand('fontsize', '16px');
	    });
		option.ready(function(){
	        option.execCommand('fontfamily','Times New Roman, 宋体');
	        option.execCommand('fontsize', '16px');
	    });
	}  */  
	
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

	getSameAtidQuestionType();
	
	$('#optionWin').window({
		minimizable:false,
		maximizable:false,
		resizable:false,
		closed:true,
		onOpen:function(){
			//$(".panel").css("z-index","999");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		},
		onMove:function(left,top){
			//$(".panel").css("z-index","999");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		},
		onResize:function(width,height){
			//$(".panel").css("z-index","999");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		}
		
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

function defaultAnswerArea(atid){
	var answerAreaStr;
	$('#answerArea').html(null);
	if(atid<4||atid==8||atid==9){
		$("#button_div").css("display","block");
		answerAreaStr = '<div class="checkblock" name="answerDiv">';
		var aids = (($('#aids').val()).substring(0,($('#aids').val()).length-1)).split("¿");
		var acontents = (($('#acontents').val()).substring(0,($('#acontents').val()).length-1)).split("¿");
		var ascores = (($('#ascores').val()).substring(0,($('#ascores').val()).length-1)).split("¿");
		//var rs = [];
		for(var i=0;i<aids.length;i++){
			var aid = aids[i];
			var acontent = acontents[i];
			var ascore = ascores[i];
			if(atid==0 || atid==2 || atid==8){
				answerAreaStr += '<input type="radio" name="answerId" ovalue="'+aid+'" value="'+i+'"/>'
				+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>';
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
			}else{
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
		/*for(var m=0;m<rs.length;m++){
			alert($("div[name=answer"+rs[m]+"]").html());
			$("div[name=answer"+rs[m]+"]").html($("div[name=answer"+rs[m]+"]").html());
		}*/
		
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
		var acontent = $("#rightAnswer").val();
		answerAreaStr = '<div id="answerCon"><script id="qanswer" name="answerCon" type="text/plain" style="width:100%;height:220px;" /></div>';
		$(answerAreaStr).appendTo('#answerArea');
		$("#qanswer").val(acontent);
		UE.delEditor('qanswer');
		answer = UE.getEditor('qanswer',{wordCount:true,maximumWords:4000});
		
		$("#fill_tr").hide();
	}
	
}

function addAnswer(){
	if(AnswerType==0||AnswerType==2||AnswerType==8){
		var i=$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]").length;
		if(i>19){
			toastr.error('选项最多20个');
			return;
		}
		var str='<input type="radio" name="answerId" value="'+i+'"/>'
			+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>';
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
	}else if(AnswerType==1||AnswerType==3||AnswerType==9){
		var i=$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]").length;
		if(i>19){
			toastr.error('选项最多20个');
			return;
		}
		var str='<input type="checkbox" name="answerId" value="'+i+'"/>'
			+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>';
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
	$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]:last").remove();
	$("#answerArea").find("div[name=answerDiv]").find("div[name=answer"+i+"]").remove();
	$("#answerArea").find("div[name=answerDiv]").find("img:last").remove();
	if(xxdf==1){
		$("#answerArea").find("div[name=answerDiv]").find("span:last").remove();
	}
	$("#answerArea").find("div[name=answerDiv]").find("br:last").remove();
}

function getCorrect(){
	var resStr = "";
	$('input[name=answerId]:checked').each(function(){
		resStr += $(this).val() + ",";
	});
	resStr = resStr.substring(0, resStr.length-1);
	return resStr;
}

function updateQuestion(){
	$(".option").each(function(){
		var prex=$(this).attr("name");
		$("#"+prex).val($(this).html());
	});
	if(content.getContent()==""||content.getContent()==null){
		toastr.warning('请编辑题目');
		return;
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
				return;
			}
			$("#correct").val(getCorrect());
		}else if(parseInt(AnswerType)==4){
			if(!$('input[name=answerCon]').is(':checked')){
				toastr.warning('请勾选正确答案');
				return;
			}
		}else{
			if(answer.getContent()==""||answer.getContent()==null){
				toastr.warning('请编辑答案');
				return;
			}
		}			
	}
	
	if(!$('input[name=firstTheme]').val()){
		toastr.warning('请选中主题词');
		return;
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
				return;
			}
			answertime += t+",";
		}
	});
	if(!continueDo){
		return;
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
			return;
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
				return;
			}
		}
	}
	var isChange=true;
	if(copy=="Y"){
		var copy_content=fn.heredoc();
		var new_content=content.getContent();

		if(copy_content.indexOf("<p")==0){
			var first_index=copy_content.indexOf(">");
			copy_content=copy_content.substring(first_index+1,copy_content.length-4);
		}
		if(new_content.indexOf("<p")==0){
			var first_index=new_content.indexOf(">");
			new_content=new_content.substring(first_index+1,new_content.length-4);
		}
		if(copy_content==new_content){
			isChange=false;
		}
	}

	if(!isChange){
		$.messager.confirm("提示",'系统检测到复制的试题内容没有任何改变，为减少试题库重复试题，请确认是否提交，继续请点击确定，需要检查请点击取消',function(r){
			if (!r){
				return;
			}else{
				var contentStr=content.getContent();
				var objE = document.createElement("div");
				$(objE).html(contentStr);
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
				if(oldStr.length!=$(objE).html().length){
					$.messager.confirm("提示",'系统检测到试题内容有空的换行，已替换，继续请点击确定，需要检查请点击取消',function(r){
						if (!r){
							return;
						}else{
							$('#questionForm').submit();
						}
					});
				}else{
					$('#questionForm').submit();
				}
			}
		});
	}else{
		var contentStr=content.getContent();
		var objE = document.createElement("div");
		$(objE).html(contentStr);
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
		if(oldStr.length!=$(objE).html().length){
			$.messager.confirm("提示",'系统检测到试题内容有空的换行，已替换，继续请点击确定，需要检查请点击取消',function(r){
				if (!r){
					return;
				}else{
					$('#questionForm').submit();
				}
			});
		}else{
			$('#questionForm').submit();
		}
	}
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

function back(){
	var eid = $('#eid').val();
	//console.log(cids);
	//console.log($("#cid").val());
	//console.log(eid);
	if(eid==''){
		//console.log(0);
		var url = "${pageContext.request.contextPath}/question/QuestionList?c_id="+$("#cid").val()+"&pageNumber="+$("#pageNumber").val()+"&pageSize="+$("#pageSize").val();
	}else{
		//console.log(1);
		if(isB!=''){
			var url = "${pageContext.request.contextPath}/paper/editBpaper?c_id="+cids+"&ei_id="+eid+"";
		}else{
			var url = "${pageContext.request.contextPath}/paper/editApaper?c_id="+cids+"&ei_id="+eid+"";
		}
	}
	//console.log(url);
	window.location.href = url; 
}

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
	
}

function gotoEditQuestion(qid,mqid,cid,ismain,qtiscon,eid,pageNumber,pageSize){
	if(mqid==''){
		mqid='';
	}
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
	var url = "${pageContext.request.contextPath}/question/editQuestion?q_id="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&eid="+eid+"&c_ids="+cids+"&pageNumber="+pageNumber+"&pagesize="+pageSize+"&isB="+isB+param;
	//console.log(url);
	window.location.href = url;
}

</script>
<script language="javascript" type="text/javascript">
function upload(){
	var winStr = '<form id="uploadFileForm" method="post" enctype="multipart/form-data">'
			+ '<table width="100%"><tr><td>'
			+ '<input id="fileToUpload" type="file" name="fileToUpload" onchange="fileSelected()" value="" multiple="multiple"/>'
			//+ '<input id="uploadFile" type="button" value="上传" onclick="uploadFile()"/>'
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
	if(qtid=="155"){
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

function fillOptionMethod(cont){
	const option_length=$("#answerArea").find(".option").length;
	const fill_length=cont.length;//有多少个选项
	if(option_length>fill_length){
		for(let i=option_length-fill_length;i>0;i--){
			removeAnswer();
		}
	}else{
		for(let i=0;i<fill_length-option_length;i++){
			addAnswer();
		}
	}
	$("#answerArea").find(".option").each(function(index){
		$(this).html(cont[index]);
	});
}

function selectCheckboxes(letters) {
	// 取消之前所有的选中状态
	$('input[name="answerId"]').prop('checked', false);
	for (let i = 0; i < letters.length; i++) {
		// 找到对应的value
		let valueToSelect = letters[i].toUpperCase().charCodeAt(0) - 'A'.charCodeAt(0);
		// 选中对应value的checkbox
		$('input[name="answerId"][value="' + valueToSelect + '"]').prop('checked', true);
	}
}

function openTTSFrame() {
	Swal.fire({
		title: '英语文本生成语音（适用于听力题）',
		html: `
      <div class="form-group" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
    	<label style="width: 30%; text-align: right; padding-right: 10px;">速度</label>
    	<div style="width: 70%; display: flex; align-items: center;">
        	<input type="range" id="slider1" min="10" max="100" step="10" value="50" style="width: 80%; margin-right: 10px;">
        	<span id="slider1Value" style="width: 20%; text-align: left;">50</span>
    	</div>
	  </div>

	  <div class="form-group" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
    	<label style="width: 30%; text-align: right; padding-right: 10px;">音调</label>
    	<div style="width: 70%; display: flex; align-items: center;">
        	<input type="range" id="slider2" min="10" max="100" step="10" value="50" style="width: 80%; margin-right: 10px;">
        	<span id="slider2Value" style="width: 20%; text-align: left;">50</span>
    	</div>
	  </div>

	  <div class="form-group" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
   		<label style="width: 30%; text-align: right; padding-right: 10px;">对话停顿时长（单位：秒）</label>
    	<div style="width: 70%; display: flex; align-items: center;">
        	<input type="range" id="slider3" min="0.1" max="3.0" step="0.1" value="1.0" style="width: 80%; margin-right: 10px;">
        	<span id="slider3Value" style="width: 20%; text-align: left;">1.0</span>
    	</div>
	  </div>
	  <hr/>

      <div id="dialogContainer">
        <div class="dialog-item" >
          <label>对话1配置</label>
			<div class="form-control-item">
          	  <select class="form-control" id="voiceSelect0">
            	<option value="CATHERINE">女声1</option>
            	<option value="RYAN">男声1</option>
          	  </select>
              <textarea class="form-control" id="dialogText0" rows="1" placeholder="请输入对话" oninput="autoResize('dialogText0')" style="resize:none;overflow-y:hidden;min-height:auto;margin-top: 5px"></textarea>
			</div>
        </div>
      </div>
      <button id="addDialogBtn" type="button" class="btn btn-primary" style="margin-top:10px">增加对话</button>
      <button id="removeDialogBtn" type="button" class="btn btn-danger" style="margin-top:10px" disabled>减少对话</button>
    `,
		customClass:{
			popup: 't2s-swal-custom'

		},
		showCancelButton: true,
		confirmButtonText: '开始生成',
		cancelButtonText: '取消',
		didOpen: () => {
			let dialogCount = 1; // 当前对话数
			const maxDialogs = 12; // 最大对话数

			for(let i=1;i<=3;i++){ // 实时更新slider的值，共有3个
				$('#slider'+i).on('input', function() {
					$('#slider'+i+'Value').text($(this).val());
				});
			}

			// 增加对话
			$('#addDialogBtn').click(function() {
				if (dialogCount < maxDialogs) {
					const newDialog = `
            <div class="dialog-item">
              <label for="voiceSelect\${dialogCount}">对话\${dialogCount+1}配置</label>
              <div class="form-control-item">
                <select class="form-control" id="voiceSelect\${dialogCount}">
                  <option value="CATHERINE">女声1</option>
            	  <option value="RYAN">男声1</option>
                </select>
                <textarea class="form-control" id="dialogText\${dialogCount}" rows="1" placeholder="请输入对话" oninput="autoResize('dialogText\${dialogCount}')" style="resize:none;overflow-y:hidden;min-height:auto;margin-top: 5px"></textarea>
              </div>
            </div>`;
					$('#dialogContainer').append(newDialog);
					<%--autoResizeTextarea(document.getElementById(`dialogText${dialogCount}`)); // 新增的textarea也绑定自动调整--%>
					dialogCount++;
					$('#removeDialogBtn').prop('disabled', false);
					if (dialogCount >= maxDialogs) {
						$('#addDialogBtn').prop('disabled', true);
					}
				}
			});

			// 减少对话
			$('#removeDialogBtn').click(function() {
				if (dialogCount > 1) {
					$('#dialogContainer .dialog-item').last().remove();
					dialogCount--;
					$('#addDialogBtn').prop('disabled', false);
					if (dialogCount === 1) {
						$('#removeDialogBtn').prop('disabled', true);
					}
				}
			});
		},
		preConfirm: () => {
			const speed = $('#slider1').val();
			const pitch = $('#slider2').val();
			const pause = $('#slider3').val();

			const voiceRoleParam = [];
			let allTextsValid = true;

			// 遍历所有对话项
			$('.dialog-item').each(function(index) {
				const vcn = $(this).find(`select`).val();
				const text = $(this).find(`textarea`).val().trim();

				if (!text) {
					allTextsValid = false;
					toastr.warning(`所有角色对话均不能为空`);
					return false; // 跳出循环
				}

				// 正则表达式，用于匹配中文字符及中文标点符号
				const chinesePattern = /[\u4e00-\u9fa5\u3000-\u303f\uff00-\uffef]/;

				// 检查是否包含中文或中文标点符号
				if (chinesePattern.test(text)) {
					allTextsValid = false;
					toastr.warning(`对话不可以包含中文字符或中文标点符号，请检查第\${index + 1}条对话`);
					return false;
				}

				// 将文本转换为 Base64 编码
				const textBase64 = btoa(encodeURIComponent(text));
				// 检查 Base64 编码是否超过 7900 字节
				if (textBase64.length > 7900) {
					allTextsValid = false;
					toastr.warning(`第\${index + 1}条对话的内容过长`);
					return false; // 跳出循环
				}

				voiceRoleParam.push({ text, vcn });
			});

			// 如果存在空文本，返回 false 阻止 Swal 关闭
			if (!allTextsValid) {
				return false; // 阻止关闭
			}

			// 返回用户选择的值
			return { speed, pitch, pause, voiceRoleParam: voiceRoleParam };
		}
	}).then((result) => {
		let transData = {speed:result.value.speed, pitch:result.value.pitch, pause:result.value.pause*1000, voiceRoleParam:result.value.voiceRoleParam};
		if (result.isConfirmed) {
			$('#loadingMessage').text("语音生成中，请稍等..."); // 设置提示文字
			$('#loadingMask').show(); // 显示遮罩层
			$.ajax({
				url: "${pageContext.request.contextPath}/intelliQuestion/EnglishTextToSound",
				type: "POST",
				data: JSON.stringify(transData),
				contentType : "application/json; charset=utf-8",
				xhrFields: {
					responseType: 'blob'  // 重要：指定响应类型为Blob用于下载
				},
				success: function (blob) {
					const url = window.URL.createObjectURL(blob);
					const a = document.createElement('a');
					a.href = url;
					a.download = "generatedSound.mp3";  // 根据需要修改文件名
					document.body.appendChild(a);
					a.click();
					window.URL.revokeObjectURL(url);
					a.remove();
					Swal.fire('生成成功！', '生成语音文件已准备好，下载将自动开始。确认该生成语音满意后，可在题目附件中选择上传。', 'success');
				},
				error: function (xhr, status, error) {
					if (xhr.status === 403) {
						Swal.fire('错误', '未授权的访问或功能已关闭。', 'error');
					} else {
						Swal.fire('错误', '生成语音失败，请稍后重试。', 'error');
					}
				},
				complete: function(){
					$('#loadingMask').hide();
				}
			});
		}
	});
}

function autoResize(tagId){
	let textarea = document.getElementById(tagId);
	textarea.style.minHeight='auto';
	if(textarea.scrollHeight < 80){
		textarea.style.minHeight = textarea.scrollHeight + 'px';
	}else{
		textarea.style.minHeight = '80px';
		textarea.style.overflowY = 'auto';
	}
}
</script>