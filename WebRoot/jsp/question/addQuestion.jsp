<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.config.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
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
	<div class="title"><span>《${courseInfo.name_c}》试题录入</span></div>
	<div style="display: flex; justify-content: center;align-items: center;">
		<c:if test="${applicationScope.AI_En_TTS.YL_1 eq 1}">
			<button style="margin-left: 5px; margin-right: 5px" type="button" class="ai-generate-btn" onclick="openTTSFrame()">使用文字生成音频功能（适合英语听力题）</button>
		</c:if>
	</div>
	<c:set var="xxdf" value=""></c:set>
	<form id="questionForm" method="post" action="${pageContext.request.contextPath}/question/addQuestion">
		<table>
			<tr class="hr-tr">
				<td align='left'>
					课程参数选项：
				</td>
				 
				<td align='left' >
					题型：
				</td>
				<td align='left'>
					<c:choose>
					    <c:when test="${! empty mainQuestion}">
					    	<c:set var="xxdf" value="${mainQuestion.xxdf}"></c:set>
						    <select id="questionType" name="questionType" style="width:100px;" readonly="readonly">
								<option value="${mainQuestion.qtid}" selected="selected">${mainQuestion.qtname}</option>
							</select>
						</c:when>
					    <c:otherwise>
					    	<select id="questionType" name="questionType" style="width:100px;">
								<c:forEach var="questionType" items="${courseInfo.questionTypeList}" varStatus="t">
									<c:if test="${t.index==0 }">
										<c:set var="xxdf" value="${questionType.XXDF}"></c:set>
									</c:if>
									<c:if test="${sessionScope.lastAddParam.qtid == questionType.QTID}">
										<c:set var="xxdf" value="${questionType.XXDF}"></c:set>
										<option value="${questionType.QTID}" selected="selected">${questionType.QTNAME}</option>
									</c:if>
									<c:if test="${empty sessionScope.lastAddParam || sessionScope.lastAddParam.qtid != questionType.QTID}">
										<option value="${questionType.QTID}" >${questionType.QTNAME}</option>
									</c:if>
								</c:forEach>
							</select>
					    </c:otherwise>
				    </c:choose>					
				</td> 
				<td align='left' >
					题源：
				</td>
				<td align='left'>					
			    	<select name="source"  style="width:100px;">
						<c:forEach var="source" items="${courseInfo.sourceList}">
							<c:if test="${sessionScope.lastAddParam.sourceid == source.SOID}"><option value="${source.SOID}" selected="selected">${source.SONAME}</option></c:if>
							<c:if test="${empty sessionScope.lastAddParam || sessionScope.lastAddParam.sourceid != source.SOID}"><option value="${source.SOID}" >${source.SONAME}</option></c:if>
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
			</tr>
			    	<c:forEach var="arrangement" items="${courseInfo.arrangementList}"  varStatus="status" begin="0">
			    		<c:choose>
			    			<c:when test="${status.last}">
			    				<tr class="hr-tr">
			    			</c:when>
			    			<c:otherwise>
			    				<tr>
			    			</c:otherwise>
			    		</c:choose> 
			    			<td align='right'>
			    			<c:choose>			    				
			    				<c:when test='${arrangement.AID==4}'>
			    					<input type="checkbox" name="cb" value="${status.index}"  onclick="return false;" checked="checked"/>
			    				</c:when>
			    				<c:otherwise>
			    					<input type="checkbox" name="cb" value="${status.index}" checked="checked"/>
			    				</c:otherwise>
			    			</c:choose>
							</td>
							<td align='left' >
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
										<c:choose>
											<c:when test="${empty sessionScope.lastAddParam}">
												<c:forEach var="cognition" items="${courseInfo.cognitionList}">
													<option value="${cognition.COID}">${cognition.CONAME}</option>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:forEach var="cognition" items="${courseInfo.cognitionList}">
													<c:choose>
														<c:when test="${sessionScope.lastAddParam.cognitionid == cognition.COID}">
															<option value="${cognition.COID}" selected="selected">${cognition.CONAME}</option>
														</c:when>
														<c:otherwise>
															<option value="${cognition.COID}">${cognition.CONAME}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</c:otherwise>
										</c:choose>
								</select>
							</td> 
							<td align='left' >
								 难度：
							</td>
							<td align='left'>
								<select id="difficulty${status.index}" name="difficulty${status.index}"  style="width:100px;">
								<c:choose>	
									<c:when test='${empty sessionScope.lastAddParam}'>
										<c:forEach var="difficulty" items="${courseInfo.difficultyList}">
											<c:if test="${difficulty.DID ==2}"><option value="${difficulty.DID}" selected="selected">${difficulty.DNAME}</option></c:if>
											<c:if test="${difficulty.DID !=2}"><option value="${difficulty.DID}" >${difficulty.DNAME}</option></c:if>
										</c:forEach>
									</c:when>
									<c:when test='${arrangement.AID==4 && !(empty sessionScope.lastAddParam)}'>
										<c:forEach var="difficulty" items="${courseInfo.difficultyList}">
											<c:if test="${sessionScope.lastAddParam.difficultyid_b == difficulty.DID}"><option value="${difficulty.DID}" selected="selected">${difficulty.DNAME}</option></c:if>
											<c:if test="${empty sessionScope.lastAddParam || sessionScope.lastAddParam.difficultyid_b != difficulty.DID}"><option value="${difficulty.DID}" >${difficulty.DNAME}</option></c:if>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<c:forEach var="difficulty" items="${courseInfo.difficultyList}">
											<c:if test="${sessionScope.lastAddParam.difficultyid == difficulty.DID}"><option value="${difficulty.DID}" selected="selected">${difficulty.DNAME}</option></c:if>
											<c:if test="${empty sessionScope.lastAddParam || sessionScope.lastAddParam.difficultyid != difficulty.DID}"><option value="${difficulty.DID}" >${difficulty.DNAME}</option></c:if>
										</c:forEach>
									</c:otherwise>
								</c:choose>
								</select>				
							</td> 
							<td align='left' >
								知识点分布：
							</td>
							<td align='left'>
								<select id="knowledge${status.index}" name="knowledge${status.index}"  style="width:100px;" >
									<c:choose>
										<c:when test="${empty sessionScope.lastAddParam}">
											<c:forEach var="knowledge" items="${courseInfo.knowledgeList}">
												<option value="${knowledge.KID}">${knowledge.KNAME}</option>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<c:forEach var="knowledge" items="${courseInfo.knowledgeList}">
												<c:choose>
													<c:when test="${sessionScope.lastAddParam.knowledgeid == knowledge.KID}">
														<option value="${knowledge.KID}" selected="selected">${knowledge.KNAME}</option>
													</c:when>
													<c:otherwise>
														<option value="${knowledge.KID}">${knowledge.KNAME}</option>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</c:otherwise>
									</c:choose>
									
								</select>
							</td> 	
							<td align='left' >
								应答时间：
							</td>
							<td align='left'>
								<div style="position:relative;display: inline-block;">
						              <select style="width:65px;" name="hour_s"
						                      onchange="changeTime(this.options[this.options.selectedIndex].value,${status.index},'hour');">
						                <option value="-1" selected>自定义</option>
						                <option value="0">0</option>
						                <option value="1">1</option>
						                <option value="2">2</option>
						              </select>时
						              <input id="input_hour${status.index}" name="input" class="iInput hour">
						        </div>
						        <div style="position:relative;display: inline-block;">
						              <select style="width:65px;" name="minute_s"
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
						              <select style="width:65px;" name="second_s"
						                      onchange="changeTime(this.options[this.options.selectedIndex].value,${status.index},'second');">
						                <option value="-1" selected>自定义</option>
						                <option value="5">5</option>
						                <option value="10">10</option>
						                <option value="15">15</option>
						                <option value="20">20</option>
						                <option value="25">25</option>
						                <option value="30">30</option>
						                <option value="35">35</option>
						                <option value="40">40</option>
						                <option value="45" selected="selected">45</option>
						                <option value="50">50</option>
						              </select>秒
						              <input id="input_second${status.index}" name="input" class="iInput second" value="45">
						        </div>
							</td>				
						</tr>
					</c:forEach>
			
		</table>
		<c:choose>
	    	<c:when test="${! empty mainQuestion}">
				<table width="100%">
					<!-- <tr class="hr-tr">
						<td align='left' height='40'>选中主题词：</td>
						<td align='center'>
							<input type="text" name="firstThemeText" style="width:280px;" value="${mainQuestion.t1name}" readonly="readonly"/>
							<input type="hidden" name="firstTheme" style="width:280px;" value="${mainQuestion.t1id}"/>
						</td>
						<td align='center'>
							<input type="text" name="secondThemeText" style="width:280px;" value="${mainQuestion.t2name}" readonly="readonly"/>
							<input type="hidden" name="secondTheme" style="width:280px;" value="${mainQuestion.t2id}"/>
						</td>
						<td align='center'>
							<input type="text" name="thirdThemeText" style="width:280px;" value="${mainQuestion.t3name}" readonly="readonly"/>
							<input type="hidden" name="thirdTheme" style="width:280px;" value="${mainQuestion.t3id}"/>
						</td>
					</tr> -->
					<tr class="hr-tr">
						<td align='left' style="margin-top:20px;">选中主题词：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<c:set var="v_seq_char" value="/" />
							<c:set var="a_seq" value="${mainQuestion.t1name}${v_seq_char }${mainQuestion.t2name }${v_seq_char }${mainQuestion.t3name}" />
							${a_seq }
							<input type="hidden" name="firstTheme" style="width:280px;" value="${mainQuestion.t1id}"/>
							<input type="hidden" name="secondTheme" style="width:280px;" value="${mainQuestion.t2id}"/>						
							<input type="hidden" name="thirdTheme" style="width:280px;" value="${mainQuestion.t3id}"/>
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
									<option value="${theme.ID}">${theme.NAME}</option>
								</c:forEach>
							</select>
						</td>
						<td align='center'>
							<select id="theme2List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList"  >
							</select>
						</td>
						<td align='center'>
							<select id="theme3List" size="7" style='width:280px;height:150px;overflow-y: scroll;' class="easyui-validatebox themeList" >
							</select>
						</td>
					</tr>
					<tr>
						<td align='left' height='40'>选中主题词：</td>
						<td align='center'>
							<input type="text" name="firstThemeText" style="width:280px;"/>
							<input type="hidden" name="firstTheme" style="width:280px;"/>
						</td>
						<td align='center'>
							<input type="text" name="secondThemeText" style="width:280px;"/>
							<input type="hidden" name="secondTheme" style="width:280px;"/>
						</td>
						<td align='center'>
							<input type="text" name="thirdThemeText" style="width:280px;"/>
							<input type="hidden" name="thirdTheme" style="width:280px;"/>
						</td>
					</tr>
				</table>
			</c:otherwise>
		</c:choose>
		<c:if test="${! empty mainQuestion}">
			<table width="100%" style="margin-top:10px;background:#EEF4FF;">	
				<tr>
					<td align='left' style="width:10%;">题干:</td>
					<td align='left' style="width:90%;">
						<div id="con">${mainQuestion.content }</div>
						<%-- <div id="con" style="margin-left:60px;width: 1280px;">${question.CONTENT}</div> --%>						
   						<input type="hidden" id="qid" value="${mainQuestion.QID}"/>			
					</td>
				</tr>
			</table>    
		</c:if>
		
		<table width="100%"  style="margin-top:20px">	
			<tr>
				<td align='left' style="width:10%;">题目编辑:
				<br><span style="color:red;">注意：网页复制的内容，先复制内容至记事本，再复制到题目编辑框内</span>
				</td>
				<td align='left' style="width:90%;">
					<script id="qcontent" name="qcontent" type="text/plain" style="width:100%;height:300px;"></script> 
				</td>
			</tr>
			<tr>
				<td align='left' style="width:10%;"></td>
				<td align='left' style="width:90%;color:red;">
					为保证视频播放效果，如需上传视频，请选择MPEG 4视频格式
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
				
				</td>
			</tr>
		</table>
		<table width="100%" id="uploadInfo">
			<tr>
				<td align='left' style="width:10%;"></td>
				<td align='left' style="width:30%;" id="fileName"></td>
				<td align='left' style="width:30%;" id="fileSize"></td>
				<td align='left' style="width:30%;" id="fileType"></td>
			</tr>
		</table>	
		<table width="100%"  style="margin-top:20px;" id="answerTable">	
			<tr>
				<td align='left' style="width:10%;">
					答案编辑:<br/>
					<div id="button_div" style="display:none;">
						<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addAnswer()"></a>
						<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-remove'" onclick="removeAnswer()"></a>
					</div>					
				</td>					
				<td align='left' id="answerArea" style="width:100%;">
					
				</td>
			</tr>
			<tr id="fill_tr" style="display:none;">
				<td align='left' style="width:10%;"></td>
				<td align='left' style="width:100%;">
					<!-- <textarea rows="6" cols="200" id="optionFill"></textarea> -->
					<div id="optionFill" contenteditable="plaintext-only" style="width:100%;min-height:200px;border:1px solid #CCCCCC;padding: 8px;margin-bottom:10px;" tabindex="2" onfocus="clearDiv()" onblur="fillDiv()">[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color="#D3D3D3">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font></div>
					<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="autoFill()">自动识别填充试题</a>
				</td>
			</tr>
		</table>
		<table width="100%"  style="margin-top:20px" id="explainTable">		
			<tr>
				<td align='left' style="width:10%;margin-top:80px;">答案解释:</td>
				<td align='left' style="width:90%;">
					<!-- <textarea id="qexplain" name="qexplain" style="width:100%;height:220px;"></textarea> -->
					<script id="qexplain" name="qexplain" type="text/plain" style="width:100%;height:220px;"></script>
				</td>
			</tr>
		</table>
    	<input id="AnswerType" type="hidden" name="AnswerType" />
    	<input id="correct" type="hidden" name="correct" />
    	<input type="hidden" id="cid" name="cid" value="${c_id}"/>
    	<input type="hidden" name="cname" value="${courseInfo.name_c}"/>
		<input type="hidden" id="mqid" name="mqid" value="${mqid}"/>
		<c:choose>
			<c:when test="${! empty mainQuestion}">
				<input type="hidden" id="isMain" name="isMain" value="${mainQuestion.ismain}"/>
				<input type="hidden" id="atid" name="atid" value="${mainQuestion.atid}"/>
			</c:when>
			<c:otherwise>
				<input type="hidden" id="isMain" name="isMain" value="0"/>
			</c:otherwise>
		</c:choose>
		<input type="hidden" id="arrangement" name="arrangement"/>
		<input type="hidden" id="cognition" name="cognition"/>
		<input type="hidden" id="difficulty" name="difficulty"/>
		<input type="hidden" id="knowledge" name="knowledge"/>
		<input type="hidden" id="answertime" name="answertime"/>
		<input type="hidden" id="cognition_b" name="cognition_b"/>
		<input type="hidden" id="difficulty_b" name="difficulty_b"/>
		<input type="hidden" id="knowledge_b" name="knowledge_b"/>
		<input type="hidden" id="answertime_b" name="answertime_b"/>
		<input type="hidden" id="pageSize" name="pageSize" value="${pageSize}"/>
		<input type="hidden" id="pageNumber" name="pageNumber" value="${pageNumber}"/>
		<input type="hidden" id="filepath" name="filepath" value="" />
		<input type="hidden" id="xxdf" name="xxdf" value="${xxdf }"/>
		<c:choose>
		    <c:when test="${! empty mainQuestion}">
			    <input type="hidden" id="iscon" name="iscon" value="1"/>
			</c:when>
		    <c:otherwise>
		    	<input type="hidden" id="iscon" name="iscon" value="0"/>
		    </c:otherwise>
	    </c:choose>		
	</form>
<div id="uploadFileDIV"></div>
<div id="optionWin" class="easyui-window" title="在线编辑器" style="width:800px;" >
	<script id="optionEditor" name="optionEditor" type="text/plain" style="width:100%;height:300px;">-</script>
    <a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="saveOption()">保存</a>
</div>

<div id="loadingMask" style="display:none;">
	<div class="spinner"></div> <!-- 旋转图标 -->
	<span id="loadingMessage">正在加载，请稍候...</span>
</div>

<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addQuestion()">保存</a>&nbsp;&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'"  href="javascript:void(0);" onclick="back()">返回列表</a>&nbsp;&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>

<script type="text/javascript">
var AnswerType;
var content;
var explain;
var answer;
var option;
var iscon = $("#iscon").val();
var xxdf = $("#xxdf").val();
var mqid = $("#mqid").val();
var div_id="";
$(document).ready(function() {
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
	content = UE.getEditor('qcontent');
    content.ready(function(){
        content.execCommand('fontfamily','Times New Roman, 宋体'); //字体
        //content.execCommand('lineheight', 2); //行间距
        content.execCommand('fontsize', '16px'); //字号
    });

	explain = UE.getEditor('qexplain',{wordCount:true,maximumWords:4000});
    explain.ready(function(){
        explain.execCommand('fontfamily','Times New Roman, 宋体');
        explain.execCommand('fontsize', '16px');
    });
	/*option = UE.getEditor('optionEditor');
	option = UE.getEditor('optionEditor',{   
	   enterTag : 'br'
	});*/
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
	
	$.parser.parse($("#courseForm"));//重新渲染
	AnswerType = getAnswerType($('#questionType').val());
	changeAnswerType(AnswerType);
	
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
	$('#optionWin').window({
		minimizable:false,
		maximizable:false,
		resizable:false,
		closed:true,
		onOpen:function(){
			//$(".panel").css("z-index","999");
			//$(".window-shadow").css("z-index","998");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		},
		onMove:function(left,top){
			//$(".panel").css("z-index","999");
			//$(".window-shadow").css("z-index","998");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		},
		onResize:function(width,height){
			//$(".panel").css("z-index","999");
			//$(".window-shadow").css("z-index","998");
			$(".window-shadow").remove();
			$(".window-mask").remove();
		}
		
	});
    //$('#optionWin').window('close');
    
	var hour_s = sessionStorage.getItem('hour_s');
	var minute_s = sessionStorage.getItem('minute_s');
	var second_s = sessionStorage.getItem('second_s');
   
	if(hour_s>0){
		$("select[name='hour_s'] option[value='"+hour_s+"']").prop("selected",true);
		$(".hour").val(hour_s);
	}
	if(minute_s>0){
		$("select[name='minute_s'] option[value='"+minute_s+"']").prop("selected",true);
		$(".minute").val(minute_s);
	}
	if(second_s>0){
		$("select[name='second_s'] option[value='"+second_s+"']").prop("selected",true);
		$(".second").val(second_s);
	}
});


$('#questionType').change(function(){	
	AnswerType = getAnswerType($(this).val());//得到答案类型AnswerType、是否串题iscon
	changeAnswerType(AnswerType);
	
});

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

function getAnswerType(qt_id){
	var res;
	if($("#isMain").val()==1 && typeof($("#atid").val())!="undefined"){
		res = $("#atid").val();
	}else{
		$.ajax({
	        url: "${pageContext.request.contextPath}/common/getAnswerType",
	        async: false, 
	        type: "POST",
	        data: {'qtid': qt_id,'cid':$("#cid").val()}, 
	        success: function (data) {
	        	res = data.ATID;
	        	iscon = data.ISCON;
	        	xxdf=data.XXDF;
	        	$("#xxdf").val(data.XXDF);
	 		}
	 	});	
	}
	/*if(res >= 0 && res <= 4){
		var r = $(".timeList").find("option[value='2']");
		$(r).attr("selected",true);
	}
	if(res > 4){
		var r = $(".timeList").find("option[value='10']");
		$(r).attr("selected",true);
	}*/
	
	return res;
}


function changeAnswerType(atid){
	$("#AnswerType").val(atid);
	if(iscon == 1 && mqid == ''){  //串题&主题干
		$("#answerTable").hide(); 
		$("#explainTable").hide();  
		$("#isMain").val(1);
		$("#iscon").val(iscon);
	}else{ //非串题||串题&非主题干
		$("#answerTable").show(); 
		$("#explainTable").show();  
		$("#isMain").val(0);
		$("#iscon").val(iscon);
		var answerAreaStr;
		$('#answerArea').html(null);
		var qtid=$("#questionType").val();
		
		if(atid==0 || atid==2 || atid==8){  //单选题、多项备选答案单选题
			$("#button_div").css("display","block");
			var num = 5;
			if(atid==2){
				num = 20;
			}
			if(atid==8){
				num=10;
			}
			answerAreaStr = '<div class="checkblock" name="answerDiv">';
			for(var i=0;i<num;i++){
				if(qtid==155){//B1
					answerAreaStr += '<input type="radio" name="answerId" value="'+i+'"/>'
					+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'
					+'<div class="option"  style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'">'+String.fromCharCode(i+ 65)+'</div>'
					+'<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/><br/>';
				}else{
					answerAreaStr += '<input type="radio" name="answerId" value="'+i+'"/>'
						+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'+'<span>'+String.fromCharCode(i+ 65)+'</span>';
					if(xxdf==1){
						answerAreaStr+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
					}else{
						answerAreaStr+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
					}
					answerAreaStr+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>';
					if(xxdf==1){
						answerAreaStr+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score"/>分</span>';
					}
					answerAreaStr+='<br/>';
				}
			}
			answerAreaStr += '</div>';
			//answerFunStr = getFunStr('addAnswer(' + a_id + ')', '添加答案') + getFunStr('delAnswer(' + a_id + ')', '删除答案');
			$(answerAreaStr).appendTo('#answerArea');
			//$(answerFunStr).appendTo('#answerFun');
			$("#fill_tr").show();		
		}else if(atid==1 || atid==3 ||atid==9){  //多选题、多项备选答案多选题
			$("#button_div").css("display","block");
			var num = 5;
			if(atid==3){
				num = 20;
			}
			if(atid==9){
				num=10;
			}
			answerAreaStr = '<div class="checkblock" name="answerDiv">';
			for(var i=0;i<num;i++){
				answerAreaStr += '<input type="checkbox" name="answerId" value="'+i+'"/>'
				+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>';
				if(xxdf==1){
					answerAreaStr+='<div class="option" style="display:inline-block;width:90%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
				}else{
					answerAreaStr+='<div class="option" style="display:inline-block;width:95%;border-bottom:1px solid #E0E0E0;" contenteditable="true" name="answer'+i+'"></div>';
				}
				answerAreaStr+='<img src="${pageContext.request.contextPath}/styles/images/optionIcon.png" onclick="optionWinopen(\'answer'+i+'\');" style="height:15px;"/>';
				
				if(xxdf==1){
					answerAreaStr+='<span><input type="text" style="width:5%;margin-left:10px;" id="score'+i+'" name="score'+i+'" attr="score"/>分</span>';
				}
				answerAreaStr+='<br/>';
			}
			answerAreaStr += '</div>';
			//answerFunStr = getFunStr('addAnswer(' + a_id + ')', '添加答案') + getFunStr('delAnswer(' + a_id + ')', '删除答案');
			$(answerAreaStr).appendTo('#answerArea');
			//$(answerFunStr).appendTo('#answerFun');	
			$("#fill_tr").show();	
		}else if(atid==4){	//判断题
			$("#button_div").css("display","none");
			answerAreaStr = '<div id="answerCon"><label style="line-height: 100px;"><input type="radio" value="true" name="answerCon"/>&nbsp;对</label>'
				+'<label style="line-height: 100px; margin-left: 50px"><input type="radio" value="false" name="answerCon"/>&nbsp;错</label></div>';
			$(answerAreaStr).appendTo('#answerArea');
			$("#fill_tr").hide();
		}else{		
			$("#button_div").css("display","none");
			answerAreaStr = '<div id="answerCon"><script id="qanswer" name="answerCon" type="text/plain" style="width:100%;height:220px;" /></div>';
			//answerAreaStr = '<div id="answerCon"><textarea id="qanswer" name="answerCon" style="width:100%;height:220px;"></textarea></div>';
			//answerFunStr = getFunStr('resetAnswer()', '重置答案');
			$(answerAreaStr).appendTo('#answerArea');
			//$(answerFunStr).appendTo('#answerFun');	
			UE.delEditor('qanswer');
			answer = UE.getEditor('qanswer',{wordCount:true,maximumWords:4000});
			$("#fill_tr").hide();
		}
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
			+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'+'<span>'+String.fromCharCode(i+ 65)+'</span>';
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
				+'<input type="hidden" id="answer'+i+'" name="answer'+i+'" attr="answer"/>'+'<span>'+String.fromCharCode(i+ 65)+'</span>';
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
	$("#answerArea").find("div[name=answerDiv]").find("input[name=answerId]:last").remove();
	$("#answerArea").find("div[name=answerDiv]").find("input[name=answer"+i+"]").remove();
	$("#answerArea").find("div[name=answerDiv]").find("div[name=answer"+i+"]").remove();
	$("#answerArea").find("div[name=answerDiv]").find("img:last").remove();
    $("#answerArea").find("div[name=answerDiv]").find("span:last").remove();

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

function addQuestion(){
	$(".option").each(function(){
		var prex=$(this).attr("name");
		$("#"+prex).val($(this).html());
	});
	
	if(content.getContent()==""||content.getContent()==null){
		toastr.warning('请编辑题目');
		return;
	}

	var isMain = $("#isMain").val();
	if(isMain==0){
		if(parseInt(AnswerType)<8){
			if(parseInt(AnswerType)<4){
				var isNull = false;	
				$.each($('input[attr=answer]'),function(i,item){
					if($(item).val()==''){
						isNull = true;
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
				$("#correct").val(getCorrect());
			}else{
				if(answer.getContent()==""||answer.getContent()==null){
					toastr.warning('请编辑答案');
					return;
				}
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
	$("input[name=cb]:checked").each(function(){
		var i = $(this).val();
		var prex1 = "arrangement"+i;
		var prex2 = "cognition"+i;
		var prex3 = "difficulty"+i;
		var prex4 = "knowledge"+i;
		//var prex5 = "answertime"+i;
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
				return;
			}
			answertime += t+",";
		}
		
		
	}); 
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
	if(xxdf==1&&isMain==0){
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
	
	sessionStorage.setItem("hour_s",$("#input_hour0").val());
	sessionStorage.setItem("minute_s",$("#input_minute0").val());
	sessionStorage.setItem("second_s",$("#input_second0").val());

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
	parent.location.reload();
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
	var fileToUpload = $("#fileToUpload").get(0).files[0];
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
       		$("#upload_tip").html("<span style='color:blue;'>上传失败："+JSON.stringify(data)+"</span>");
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
	var qcontent=str[0];//题目内容
	content.setContent(qcontent);
	var ocontent=str[1].trim();//选项内容all

    var answerSplit = "[A-Ta-t]+\\.";//备选答案分隔符
    var answerSplitDot = "[A-Ta-t]+\\、";//备选答案分隔符

    var re =/[A-Ta-t]\、/;//匹配A、B、C、等选项
    var reDot =/[A-Ta-t]\./;


    //匹配选项，如果匹配得上，去除数组第一个元素，因为是空的
    var repl = ocontent.replace(/<[^>]+>/g,"");//去除文字内的html标签
	if(re.test(repl)){
        var contemp = repl.split(re);
        var cont = contemp.slice(0);
        cont.shift();
	}else if(reDot.test(repl)){
        var contemp = repl.split(reDot);
        var cont = contemp.slice(0);
        cont.shift();
	}else {
        var cont=repl.split("\n");//分割选项
	}

	fillOptionMethod(cont);
	$("#optionFill").html("[智能填写] 试题内容与选项之间使用“#”号隔开，不同选项之间使用换行进行区分，示例如下：<br><font color=\"#D3D3D3\">肾小球性蛋白尿的起因主要是：<br>#<br>肾小球基底膜异常<br>肾小球毛细血管压的改变<br>肾小管的重吸收异常<br>胶体渗透压的变化<br>以上都不是</font>");
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

			// 定义中文标点和英文标点的映射关系
			const punctuationMap = {
				'，': ',',
				'。': '.',
				'！': '!',
				'？': '?',
				'；': ';',
				'：': ':',
				'“': '"',
				'”': '"',
				'‘': "'",
				'’': "'",
				'（': '(',
				'）': ')',
				'【': '[',
				'】': ']',
				'《': '<',
				'》': '>',
				'、': '/',
				'——': '-'
			};

			// 遍历所有对话项
			$('.dialog-item').each(function(index) {
				const vcn = $(this).find(`select`).val();
				let text = $(this).find(`textarea`).val().trim();

				if (!text) {
					allTextsValid = false;
					toastr.warning(`所有角色对话均不能为空`);
					return false; // 跳出循环
				}

				// 正则表达式，用于匹配中文字符
				const chineseCharacterPattern = /[\u4e00-\u9fa5]/;

				// 检查是否包含中文字符
				if (chineseCharacterPattern.test(text)) {
					allTextsValid = false;
					toastr.warning(`对话不可以包含中文字符，请检查第${index + 1}条对话`);
					return false;
				}

				// 替换中文标点符号为英文标点符号
				text = text.replace(/[\u3000-\u303f\uff00-\uffef]/g, match => punctuationMap[match] || match);

				// 将文本转换为 Base64 编码
				const textBase64 = btoa(encodeURIComponent(text));
				// 检查 Base64 编码是否超过 7900 字节
				if (textBase64.length > 7900) {
					allTextsValid = false;
					toastr.warning(`第${index + 1}条对话的内容过长`);
					return false; // 跳出循环
				}

				// 更新 textarea 的值为转换后的文本
				$(this).find(`textarea`).val(text);

				voiceRoleParam.push({ text, vcn });
			});

			// 如果存在空文本或其他验证失败，返回 false 阻止 Swal 关闭
			if (!allTextsValid) {
				return false; // 阻止关闭
			}

			// 返回用户选择的值
			return { speed, pitch, pause, voiceRoleParam: voiceRoleParam };
		}
	}).then((result) => {
		if (result.isConfirmed) {
			let transData = {speed:result.value.speed, pitch:result.value.pitch, pause:result.value.pause*1000, voiceRoleParam:result.value.voiceRoleParam};
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