<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.window, .window .window-body {
	overflow: hidden;
}

.checkblock {
	border: 1px solid #CCC;
	height: 154px;
	width: 220px;
	overflow-y: scroll;
}

select, input, textarea {
	border: 1px solid #95B8E7;
}

.elegant-aero {
	margin-left: auto;
	margin-right: auto;
	max-width: auto;
	/*background: #DCEBFE;*/
	padding: 20px 20px 20px 20px;
	font: Arial, Helvetica, sans-serif;
	color: #666;
	border-radius: 8px;
}

.elegant-aero h1 {
	font: 24px "Trebuchet MS", Arial, Helvetica, sans-serif;
	padding: 10px 10px 10px 20px;
	display: block;
	/*background: #C0E1FF;*/
	border-bottom: 1px solid #B8DDFF;
	margin: -20px -20px 15px;
	border-top-left-radius: 8px;
	border-top-right-radius: 8px;
	text-align: center;
}

.elegant-aero h1>span {
	display: block;
	font-size: 11px;
}

.elegant-aero label {
	display: block;
	margin: 0px 0px 3px;
	clear: both
}

#eoSpan {
	width: 80%;
	text-align: left;
	padding-right: 15px;
	margin-top: 10px;
	font-weight: normal;
}

.elegant-aero label>span {
	float: left;
	width: 20%;
	text-align: right;
	padding-right: 15px;
	margin-top: 10px;
	font-weight: bold;
}

.elegant-aero label>.spanText {
	margin: 10px 0 8px;
	float: left;
}

.elegant-aero input[type="text"], .elegant-aero input[type="password"],
	.elegant-aero input[type="email"], .elegant-aero textarea,
	.elegant-aero select {
	/*color: #888;
        width: 70%;
        padding: 0px 0px 0px 5px;
        height: 30px;
        border-radius: 4px;
        font: Arial, Helvetica, sans-serif;
        background: #FBFBFB;*/
	border: 1px solid;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	line-height: 20px;
	margin: 2px 6px 14px 0px;
}

.elegant-aero textarea {
	padding: 5px 0px 0px 5px;
	width: 70%;
	border-radius: 4px;
}

.elegant-aero select {
	/* appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none; */
	text-indent: 0.01px;
	text-overflow: '';
	width: 70%;
	border-radius: 4px;
}

.elegant-aero .button {
	padding: 10px 30px 10px 30px;
	background: #66C1E4;
	border: none;
	color: #FFF;
	box-shadow: 1px 1px 1px #4C6E91;
	-webkit-box-shadow: 1px 1px 1px #4C6E91;
	-moz-box-shadow: 1px 1px 1px #4C6E91;
	text-shadow: 1px 1px 1px #5079A3;
}

.elegant-aero .button:hover {
	background: #3EB1DD;
}

.elegant-aero .missionnum[disabled="disabled"] {
	background: #ddd;
	border: 1px solid #aaa;
}

td {
	border: 1px solid black;
	text-align: center;
}
</style>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/styles/js/autoTextarea.js"></script>
<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" style="" onclick="window.location.reload();">取消</a>
-->
<form id="examInfoForm" class="elegant-aero" method="post">
	<input type="hidden" name="c_id" id="c_id" value="${examInfo.CID}" /> <input
		type="hidden" name="state" id="state" value="${examInfo.STATE}" /> <input
		type="hidden" name="ei_id" id="ei_id" value="${examInfo.ID}" /> <input
		type="hidden" name="url" id="url" value="${url}" /> <input
		type="hidden" name="ename" id="ename" value="${examInfo.ENAME}" />
	<c:set var="syName" value=""></c:set>
	<c:set var="termName" value=""></c:set>
	<c:forEach var="sy" items="${applicationScope.schoolYear}">
		<c:if test="${examInfo.SCHOOLYEAR == sy.ID}">
			<c:set var="syName" value="${sy.NAME}"></c:set>
		</c:if>
	</c:forEach>
	<c:forEach var="t" items="${applicationScope.term}">
		<c:if test="${examInfo.TERM == t.ID}">
			<c:set var="termName" value="${t.NAME}"></c:set>
		</c:if>
	</c:forEach>

	<h1>《${examInfo.ENAME}》考务信息</h1>
	<label> <span>试卷编号 :</span>
		<div class="spanText">${examInfo.ID}&nbsp;&nbsp;&nbsp;&nbsp;(本考试课程在教务系统中的代码)</div>
	</label> <label> <span>考试科目 :</span>
		<div class="spanText">
			<c:out value="${syName }" />
			<c:out value="${termName }" />
			《${examInfo.CNAME}》
		</div>
	</label> <label> <span>来源课程、序号:</span>
		<div class="spanText">${name_c}&nbsp;&nbsp;&nbsp;&nbsp;${c_id}</div>
	</label> <label> <span>课程代码 :</span>
		<div class="spanText">${examInfo.CODE}</div>
	</label>
	<!--
<label>
<span>考试名称 :</span>
<div class="spanText">${examInfo.ENAME}</div>
</label>
<label>
<span>学年 :</span>
<c:forEach var="sy" items="${applicationScope.schoolYear}">
    <c:if test="${examInfo.SCHOOLYEAR == sy.ID}">
        <div class="spanText">${sy.NAME}</div>
        <c:set var="syName" value="${sy.NAME}"></c:set>
    </c:if>
</c:forEach>
</label>
<label>
<span>学期 :</span>
<c:forEach var="t" items="${applicationScope.term}">
    <c:if test="${examInfo.TERM == t.ID}">
        <div class="spanText">${t.NAME}</div>
        <c:set var="termName" value="${t.NAME}"></c:set>
    </c:if>
</c:forEach>
</label> -->
	<label> <span>考试类型 :</span> <c:forEach var="et"
			items="${examTypeList}">
			<c:if test="${examInfo.TYPE == et.ETID}">
				<div class="spanText" style="width: 130px;">${et.ETNAME}</div>
				<c:set var="etName" value="${et.ETNAME}"></c:set>
			</c:if>
		</c:forEach> <span style="width: 130px;">开闭卷设置 :</span> <c:forEach var="ew"
			items="${applicationScope.examWay}">
			<c:if test="${examInfo.TESTWAY == ew.ID}">
				<div class="spanText" style="width: 130px;">${ew.NAME}</div>
				<c:set var="examWay" value="${ew.NAME}"></c:set>
			</c:if>
		</c:forEach> <span style="width: 130px;">学时数 :</span>
		<div class="spanText" style="width: 80px;">${examInfo.PERIOD}&nbsp;</div>
	</label> <label> <span>总评占比 :</span>
		<div class="spanText">本份试卷成绩在课程总评成绩占的比例：${examInfo.PROPORTION} %</div>
	</label> <label> <span>考试对象 :</span> <span id="eoSpan"> <c:forEach
				var="eo" items="${examObject}">
                ${eo.GNAME} ${eo.SNAME}&nbsp;&nbsp;&nbsp;
            </c:forEach>
	</span>
	</label> <label> <span>考试人数 :</span>
		<div class="spanText" style="width: 80px;">${examInfo.TOTAL}</div> <span
		style="width: 130px;">印刷份数 :</span>
		<div class="spanText" style="width: 80px;">${examInfo.PRINTCOUNT}</div>
	</label> <label> <span>学号身份限定 :</span>
		<div class="spanText">
			<c:choose>
				<c:when test="${examInfo.SIDVERIFY eq 0}">
					<div class="spanText">考生无须验证学号便可考试</div>
				</c:when>
				<c:when test="${examInfo.SIDVERIFY eq 1}">
					<div class="spanText">考生必须验证学号方可考试</div>
				</c:when>
				<c:when test="${examInfo.SIDVERIFY eq 2}">
					<div class="spanText">考生必须验证人脸才可考试</div>
				</c:when>
			</c:choose>
		</div> <c:if test="${examInfo.SIDVERIFY eq 2}">
	    &nbsp;&nbsp;&nbsp;&nbsp;
	    <span style="width: 210px;">考试过程中验证人脸次数 :</span>
			<div class="spanText">${examInfo.FACETIME}次</div>
	    &nbsp;&nbsp;&nbsp;&nbsp;
	    <span style="width: 210px;">验证人脸失败后的处理 :</span>
			<c:choose>
				<c:when test="${examInfo.FACEFAIL eq 0}">
					<div class="spanText">考生继续考试</div>
				</c:when>
				<c:when test="${examInfo.FACEFAIL eq 1}">
					<div class="spanText">考生退出考试，自行重新登录</div>
				</c:when>
				<c:when test="${examInfo.FACEFAIL eq 2}">
					<div class="spanText">考生退出考试，由老师操作才可再次登录</div>
				</c:when>
			</c:choose>
		</c:if>
		</div>
	</label>
	<c:choose>
		<c:when test="${action!=null and action=='verified'}">
			<label> <span>考试密码 :</span>
				<div class="spanText">首次登录密码：${examInfo.FIRSTPSW}，二次登录密码：${examInfo.SECONDPSW}（<span style="color: red;">二次密码请勿公布，如有需要，请手动为考生输入</span>）</div>
			</label>
			<label> <span>通用任务号：</span>
				<div class="spanText">${examInfo.MISSIONNUM}</div>
			</label>
		</c:when>
		<c:otherwise>
			<label> <span>通用号:</span>
				<div class="spanText">${examInfo.MISSIONNUM}&nbsp;&nbsp;&nbsp;&nbsp;
					（当个别学生不能正确输入考试任务号或学号，单独告诉学生输入此号 ）</div>
			</label>
		</c:otherwise>
	</c:choose>
	<!--
<label>
<span>通用号:</span>
<div class="spanText">${examInfo.MISSIONNUM}&nbsp;&nbsp;&nbsp;&nbsp; （当个别学生不能正确输入考试任务号或学号，单独告诉学生输入此号 ）</div>
</label>  -->
	<label> <span>考试时间 :</span>
		<div class="spanText">${examInfo.BEGINDATE}&nbsp;&nbsp;~&nbsp;&nbsp;${examInfo.ENDDATE}</div>
		<%-- <input class="easyui-datetimebox" name="bt" data-options="editable:false,howSeconds:false"
        value="${examInfo.BEGINDATE}" style="width:180px"> --%>
	</label> <label> <span>考试用时 :</span> <c:set var="etime" /> <c:forEach
			var="st" items="${applicationScope.systemTime2}" begin="4">
			<c:if test="${examInfo.TIME == st.ID}">
				<div class="spanText">${st.NAME }</div>
				<c:set var="etime" value="${st.NAME }" />
			</c:if>
		</c:forEach>
	</label> <label> <span>开考前允许登录时间 :</span>
		<div class="spanText">${examInfo.LOCKBEFORE/60}分钟</div> <c:set
			var="btime" value="${examInfo.LOCKBEFORE/60}分钟" /> <span
		style="width: 180px;">开考后禁止登录时间 :</span> <c:set var="atime" /> <c:choose>
			<c:when test="${examInfo.LOCKAFTER == -1}">
				<div class="spanText">无限制</div>
				<c:set var="atime" value="无限制" />
			</c:when>
			<c:otherwise>
				<div class="spanText">${examInfo.LOCKAFTER/60}分钟</div>
				<c:set var="atime" value="${examInfo.LOCKAFTER/60}分钟" />
			</c:otherwise>
		</c:choose> <span style="width: 180px;">开考后禁止交卷时间 :</span> <c:set
			var="handintime" /> <c:choose>
			<c:when test="${examInfo.HANDINTIMELIMIT == -1}">
				<div class="spanText">无限制</div>
				<c:set var="handintime" value="无限制" />
			</c:when>
			<c:otherwise>
				<div class="spanText">${examInfo.HANDINTIMELIMIT/60}分钟</div>
				<c:set var="handintime" value="${examInfo.HANDINTIMELIMIT/60}分钟" />
			</c:otherwise>
		</c:choose>
	</label> <label> <span>成绩查询设置 :</span> <c:forEach var="qs"
			items="${applicationScope.queryScore}">
			<c:if test="${examInfo.SCHECKWAY == qs.ID}">
				<div class="spanText">${qs.NAME}</div>
				<c:set var="scheckway" value="${qs.NAME}"></c:set>
			</c:if>
		</c:forEach>
	</label> <label> <span>答卷查看设置 :</span> <c:forEach var="qp"
			items="${applicationScope.queryPaper}">
			<c:if test="${examInfo.GETANSWER == qp.ID}">
				<div class="spanText">${qp.NAME}</div>
				<c:set var="getanswer" value="${qp.NAME}"></c:set>
			</c:if>
		</c:forEach>
	</label> <label> <span>考试方式设置 :</span> <c:forEach var="tm"
			items="${applicationScope.testMode}">
			<c:if test="${examInfo.TESTTIMESET == tm.ID}">
				<div class="spanText">${tm.NAME}</div>
				<c:set var="testMode" value="${tm.NAME}"></c:set>
			</c:if>
		</c:forEach>
	</label> <label> <span>试题选项随机设置 :</span> <c:if
			test="${examInfo.RANDOMANSWER == 0}">
			<div class="spanText">不随机</div>
			<c:set var="randomAnswer" value="不随机"></c:set>
		</c:if> <c:if test="${examInfo.RANDOMANSWER == 1}">
			<div class="spanText">随机</div>
			<c:set var="randomAnswer" value="随机"></c:set>
		</c:if>
	</label> <label> <span>答题顺序设置 :</span> <c:forEach var="as"
			items="${applicationScope.answerSequence}">
			<c:if test="${examInfo.ANSWERSEQUENCE == as.ID}">
				<div class="spanText">${as.NAME}</div>
				<c:set var="answerSequence" value="${as.NAME}"></c:set>
			</c:if>
		</c:forEach>
	</label> <label> <span>改卷方式设置 :</span> <c:forEach var="cp"
			items="${applicationScope.correctPaper}">
			<c:if test="${examInfo.CORRECTWAY == cp.ID}">
				<div class="spanText">${cp.NAME}</div>
				<c:set var="correctPaper" value="${cp.NAME}"></c:set>
			</c:if>
		</c:forEach>
	</label>

	<%-- <label>
    <span>组卷限定：</span>
    <div class="spanText">不选用&nbsp;
    <c:forEach var="forbidDay" items="${applicationScope.forbidDay}">
        <c:if test="${examInfo.FORBIDBEFORE == forbidDay.ID}">
             ${forbidDay.NAME}
        </c:if>
    </c:forEach>
    &nbsp;之内考过&nbsp;${examInfo.FORBIDNUM}&nbsp;
    次及以上的试题</div>
</label> --%>
	<!--
<label>
<span>试题天数筛选 :</span>
<div class="spanText">不选用&nbsp;
<c:forEach var="forbidDay" items="${applicationScope.forbidDay}">
    <c:if test="${examInfo.FORBIDBEFORE == forbidDay.ID}">
        ${forbidDay.NAME}
    </c:if>
</c:forEach>
&nbsp;之内考过的试题</div>
</label>
<label>
<span>试题次数筛选 :</span>
<div class="spanText">不选用已使用过&nbsp;${examInfo.FORBIDNUM}&nbsp;次及以上的试题</div>
</label>
<label>
<span>试题状态筛选 :</span>
<c:choose>
    <c:when test="${examInfo.ISVERIFIED eq 0}">
        <div class="spanText">试题不限已审核</div>
    </c:when>
    <c:when test="${examInfo.ISVERIFIED eq 1}">
        <div class="spanText">限制为已经通过审核的试题</div>
    </c:when>
</c:choose>
</label>
-->
	<c:if test="${editor_switch==1 }">
		<label> <span>是否启用编辑器答题 :</span> <c:if
				test="${examInfo.EDITOR_SWITCH == 0}">
				<div class="spanText">禁用（主观题只能输入普通文本，不能键入公式、表格、上标下标）</div>
				<c:set var="editorSwitch" value="禁用"></c:set>
			</c:if> <c:if test="${examInfo.EDITOR_SWITCH == 1}">
				<div class="spanText">启用（主观题可插入表格、公式【目前公式输入后只支持删除再输入，不支持重新编辑已输入的公式】、上下标）</div>
				<c:set var="editorSwitch" value="启用"></c:set>
			</c:if>
		</label>
	</c:if>
	<c:if test="${random_switch==1 }">
		<label> <span>是否采用千人千题考试模式 :</span> <c:if
				test="${examInfo.RANDOM == 0}">
				<div class="spanText">禁用</div>
				<c:set var="randomSwitch" value="禁用"></c:set>
			</c:if> <c:if test="${examInfo.RANDOM == 1}">
				<div class="spanText">启用</div>
				<c:set var="randomSwitch" value="启用"></c:set>
			</c:if>
		</label>
	</c:if>
	<label> <span>是否允许移动端考试：</span> <c:if
			test="${examInfo.MOBILE == 0}">
			<div class="spanText">禁用</div>
			<c:set var="mobileSwitch" value="禁用"></c:set>
		</c:if> <c:if test="${examInfo.MOBILE == 2}">
			<div class="spanText">启用</div>
			<c:set var="mobileSwitch" value="启用"></c:set>
		</c:if>
		<span>考试切屏次数限制：</span>
		<div class="spanText">
			<c:if test="${examInfo.SWITCH_OUT_LIMIT eq -1}">无限制</c:if>
			<c:if test="${examInfo.SWITCH_OUT_LIMIT != -1}">${examInfo.SWITCH_OUT_LIMIT}次</c:if>
		</div>

	</label>  <label> <span>组卷负责人 :</span>
		<div class="spanText">${examInfo.TEACHERNAME}&nbsp;&nbsp;&nbsp;&nbsp;联系电话
			:${examInfo.TEL}</div> 
	</label> 
	<label> <span>监考老师 :</span>
		<div class="spanText">${examInfo.INVIGILATORIDS}</div> 
		<span>巡考老师:</span>
		<div class="spanText">${examInfo.PATROLIDS}</div>
		<span>任课老师:</span>
		<div class="spanText">${examInfo.COURSETEACHER}</div>
	</label> <label> <span>考试地点 :</span>
		<div class="spanText">${examInfo.VENUES}</div>
	</label> <label> <span>备注说明 :</span>
		<div class="spanText" style="width: 70%">${examInfo.REMARK2T}</div> <%-- <textarea rows="7" cols="70" name="remark2t" disabled="disabled">${examInfo.REMARK2T}</textarea> --%>
	</label>
	<c:if test="${union_switch==1 }">
		<label> <span>是否联考卷 :</span>
			<div class="spanText" style="width: 70%">
				<c:choose>
					<c:when test="${examInfo.ISUNION==0}">
                    非联考卷
                </c:when>
					<c:when test="${examInfo.ISUNION==1 or examInfo.ISUNION==2}">
                    联考卷
                </c:when>
					<c:when test="${examInfo.ISUNION==3}">
                    联考测试卷
                </c:when>
				</c:choose>
			</div>
		</label>
	</c:if>
	<label> <span>考试须知 :</span> <textarea id="remark2s" cols="70"
			name="remark2s" disabled="disabled"
			style="background: transparent; border-style: none;">${examInfo.REMARK2S}</textarea>
	</label> <label> <span>英文考试须知 :</span> <textarea id="e_remark2s"
			cols="70" name="e_remark2s" disabled="disabled"
			style="background: transparent; border-style: none;">${examInfo.E_REMARK2S}</textarea>
	</label> <label> <span>试卷生成时间：</span>
		<div class="spanText">${examInfo.CREATETIME}</div>
	</label>
	<c:if test="${examInfo.STATE == 2}">
		<label> <span>初级审核意见 :</span>
			<div class="spanText" style="width: 70%">${examInfo.FIRSTVERIFYOPINION}</div>
			<!-- <textarea rows="4" cols="70" name="remark2t" disabled="disabled">${examInfo.FIRSTVERIFYOPINION}</textarea> -->
		</label>
		<label> <span>初审人:</span>
			<div class="spanText">${examInfo.FIRSTVERIFYTEACHER}</div>
		</label>
		<label> <span>初审时间：</span>
			<div class="spanText">${examInfo.FIRSTVERIFY}</div>
		</label>
	</c:if>
	<c:if test="${examInfo.STATE >= 3}">
		<label> <span>初级审核意见 :</span>
			<div class="spanText" style="width: 70%">${examInfo.FIRSTVERIFYOPINION}</div>
			<!-- <textarea rows="4" cols="70" name="remark2t" disabled="disabled">${examInfo.FIRSTVERIFYOPINION}</textarea> -->
		</label>
		<label> <span>审核人:</span>
			<div class="spanText">${examInfo.FIRSTVERIFYTEACHER}</div>
		</label>
		<label> <span>初审时间：</span>
			<div class="spanText">${examInfo.FIRSTVERIFY}</div>
		</label>
		<label> <span>终极审核意见 :</span>
			<div class="spanText" style="width: 70%">${examInfo.LASTVERIFYOPINION}</div>
			<!-- <textarea rows="4" cols="70" name="remark2t" disabled="disabled">${examInfo.LASTVERIFYOPINION}</textarea> -->
		</label>
		<label> <span>审核人:</span>
			<div class="spanText">${examInfo.LASTVERIFYTEACHER}</div>
		</label>
		<label> <span>终审时间：</span>
			<div class="spanText">${examInfo.LASTVERIFY}</div>
		</label>
	</c:if>
</form>

<div id="win" class="easyui-window" title="考务信息"
	data-options="iconCls:'icon-save',modal:true" align="center">
	<div id="word">
		<table id="view">
			<tr>
				<td colspan="5" align="center">${examInfo.ENAME}考务信息</td>
			</tr>
			<tr>
				<td align="left" width="19%">试卷编号：</td>
				<td colspan="3">${examInfo.ID}</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试科目:</td>
				<td colspan="3"><c:out value="${syName}" />
					<c:out value="${termName}" />${examInfo.CNAME}</td>
			</tr>
			<tr>
				<td align="left" width="19%">来源课程：</td>
				<td colspan="3">${examInfo.CNAME}</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试类型：</td>
				<td width="31%"><c:out value="${etName}" /></td>
				<td align="left" width="19%">开闭卷设置：</td>
				<td width="31%"><c:out value="${examWay }" /></td>
			</tr>

			<tr>
				<td align="left" width="19%">课程学时数：</td>
				<td colspan="3">${examInfo.PERIOD}</td>
			</tr>
			<tr>
				<td align="left" width="19%">总评占比：</td>
				<td colspan="3">${examInfo.PROPORTION}%</td>
			</tr>
			<tr>
				<td align="left" width="19%">组卷限定：</td>
				<td colspan="3">不选用已使用过${examInfo.FORBIDNUM}次及以上的试题</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试对象：</td>
				<td colspan="3"><c:forEach var="eo" items="${examObject}">
                        ${eo.GNAME} ${eo.SNAME}&nbsp;&nbsp;&nbsp;
                    </c:forEach></td>
			</tr>
			<tr>
				<td align="left" width="19%">考试人数：</td>
				<td colspan="3">${examInfo.TOTAL}</td>
			</tr>
			<tr>
				<td align="left" width="19%">试卷份数：</td>
				<td colspan="3">${examInfo.PRINTCOUNT}</td>
			</tr>
			<tr>
				<td align="left" width="19%">学号身份限定：</td>
				<td colspan="3"><c:choose>
						<c:when test="${examInfo.SIDVERIFY eq 0}">
                            考生无须验证学号便可考试
                        </c:when>
						<c:when test="${examInfo.SIDVERIFY eq 1}">
                            考生必须验证学号方可考试
                        </c:when>
						<c:when test="${examInfo.SIDVERIFY eq 2}">
                            考生必须验证人脸才可考试
                        </c:when>
					</c:choose></td>
			</tr>
			<tr>
				<td align="left" width="19%">考试密码：</td>
				<td colspan="3">首次登录密码：${examInfo.FIRSTPSW}，二次登录密码：${examInfo.SECONDPSW}
					<c:if test="${action!=null and action=='verified'}">
					（<span style="color: red;">二次密码请勿公布，如有需要，请手动为考生输入</span>）
					</c:if>，通用任务号：${examInfo.MISSIONNUM}</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试时间：</td>
				<td colspan="3">${examInfo.BEGINDATE}--${examInfo.ENDDATE}</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试用时：</td>
				<td colspan="3"><c:out value="${etime}" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">禁止登录设置1：</td>
				<td colspan="3">考试开始前&nbsp;<c:out value="${btime}" />&nbsp;禁止考生登录考试。
				</td>
			</tr>
			<tr>
				<td align="left" width="19%">禁止登录设置2：</td>
				<td colspan="3">考试开始后&nbsp;<c:out value="${atime}" />&nbsp;禁止考生登录考试。
				</td>
			</tr>
			<tr>
				<td align="left" width="19%">禁止交卷设置：</td>
				<td colspan="3">考试开始后&nbsp;<c:out value="${handintime}" />&nbsp;内禁止考生交卷。
				</td>
			</tr>
			<tr>
				<td align="left" width="19%">成绩查询设置：</td>
				<td colspan="3"><c:out value="${scheckway }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">答卷查看设置：</td>
				<td colspan="3"><c:out value="${getanswer }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">考试方式设置：</td>
				<td colspan="3"><c:out value="${testMode }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">试题选项随机设置：</td>
				<td colspan="3"><c:out value="${randomAnswer }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">答题顺序设置：</td>
				<td colspan="3"><c:out value="${answerSequence }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">改卷方式设置：</td>
				<td colspan="3"><c:out value="${correctPaper }" /></td>
			</tr>
			<c:if test="${editor_switch==1 }">
				<tr>
					<td align="left" width="19%">是否启用编辑器答题 ：</td>
					<td colspan="3"><c:out value="${editorSwitch }" /></td>
				</tr>
			</c:if>
			<c:if test="${random_switch==1 }">
				<tr>
					<td align="left" width="19%">是否采用千人千题考试模式 ：</td>
					<td colspan="3"><c:out value="${randomSwitch }" /></td>
				</tr>
			</c:if>
			<tr>
				<td align="left" width="19%">是否允许移动端考试 ：</td>
				<td colspan="3"><c:out value="${mobileSwitch }" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">考试地点：</td>
				<td colspan="3">${examInfo.VENUES}</td>
			</tr>
			<tr>
				<td align="left" width="19%">组卷负责人：</td>
				<td colspan="3">${examInfo.TEACHERNAME}</td>
			</tr>
			<tr>
				<td align="left" width="19%">联系电话：</td>
				<td colspan="3">${examInfo.TEL}</td>
			</tr>
			<tr>
				<td align="left" width="19%">任课老师：</td>
				<td colspan="3">${examInfo.COURSETEACHER}</td>
			</tr>
			<tr>
				<td align="left" width="19%">监考老师：</td>
				<td width="31%"><c:out value="${examInfo.INVIGILATORIDS}" /></td>
				<td align="left" width="19%">巡考老师：</td>
				<td width="31%"><c:out value="${examInfo.PATROLIDS}" /></td>
			</tr>
			<tr>
				<td align="left" width="19%">考试备注：</td>
				<td colspan="3">${examInfo.REMARK2T}</td>
			</tr>
			<tr>
				<td align="left" width="19%">考试须知：</td>
				<td colspan="3"><textarea id="remark2s4print" cols="70"
						name="remark2s" disabled="disabled"
						style="background: transparent; border-style: none;">${examInfo.REMARK2S}</textarea></td>
			</tr>
			<tr>
				<td align="left" width="19%">英文考试须知：</td>
				<td colspan="3"><textarea id="e_remark2s4print" cols="70"
						name="e_remark2s" disabled="disabled"
						style="background: transparent; border-style: none;">${examInfo.E_REMARK2S}</textarea></td>
			</tr>
			<tr>
				<td align="left" width="19%">试卷生成时间</td>
				<td colspan="3">${examInfo.CREATETIME}</td>
			</tr>
			<c:if test="${examInfo.STATE == 2}">
				<tr>
					<td style="width: 19%; text-align: center">初级审核意见：</td>
					<td colspan="3">
							${examInfo.FIRSTVERIFYOPINION}
						&nbsp;&nbsp;&nbsp;&nbsp;初审人:${examInfo.FIRSTVERIFYTEACHER}
						&nbsp;&nbsp;&nbsp;&nbsp;初审时间:${examInfo.FIRSTVERIFY}
					</td>
				</tr>
			</c:if>

			<c:if test="${examInfo.STATE >= 3}">
				<tr>
					<td style="width: 19%; text-align: center">初级审核意见：</td>
					<td colspan="3">
							${examInfo.FIRSTVERIFYOPINION}
						&nbsp;&nbsp;&nbsp;&nbsp;审核人:${examInfo.FIRSTVERIFYTEACHER}
						&nbsp;&nbsp;&nbsp;&nbsp;初审时间:${examInfo.FIRSTVERIFY}
					</td>
				</tr>
				<tr>
					<td style="width: 19%; text-align: center">终极审核意见：</td>
					<td colspan="3">
							${examInfo.LASTVERIFYOPINION}
						&nbsp;&nbsp;&nbsp;&nbsp;审核人:${examInfo.LASTVERIFYTEACHER}
						&nbsp;&nbsp;&nbsp;&nbsp;终审时间:${examInfo.LASTVERIFY}
					</td>
				</tr>
			</c:if>

		</table>
	</div>
	<a class="easyui-linkbutton" href="javascript:void(0);" target="_self"
		onclick="print()">打印</a>
</div>
<div style="clear: both"></div>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-print'"
		href="javascript:void(0);" target="_self" onclick="winopen()">打印</a> <a
		class="easyui-linkbutton" href="javascript:void(0);" target="_self"
		onclick="saveAsWord()">保存为word</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
<div id="uploadWin"></div>
<div id="resultWin"></div>
<script type="text/javascript">
    $(document).ready(function(){
        $('#win').window('close');

        $.each($("textarea"), function(i, n){
            autoTextarea($(n)[0],10);
        });
        $("#remark2s4print").css("height",$("#remark2s").css("height"));
    });

    function uploadInfo(cname){
        cid = $('#c_id').val();
        state = $('#state').val();
        if(cname==null || cname=="null" || cname==""){
            cname=null;
        }

        if(state == 6){
			ajaxLoading();
            $.ajax({
                url:"${pageContext.request.contextPath}/result/getCourseList_DL",
                type:"POST",
                data:{"cid":cid,"cname":cname},
                success:function(courseList){
					ajaxLoadEnd();
                    var s = '';
                    for(let i=0;i<courseList.length;i++){
                        s+='<option value="'+courseList[i].XKKH +',' +courseList[i].XQ+',' +courseList[i].XN+'">'+courseList[i].KCMC+'   (课号：'+courseList[i].XKKH+')  (专业：'+ courseList[i].ZYMC +')</option>';
                    }
                    var winStr = '<table style="border-style:none" align="center" width="90%">'
                        + '<tr><td align="center" style="border-style:none;font-size:16px;text-align:center;">该试卷搜索到的课程如下，请根据选课课号进行数据同步：</td></tr>'
                        + '<tr><td align="center" style="border-style:none;font-size:16px;color:orange;text-align:center;">如无搜到课程，请输入课程名称进行重新搜索课程：'
                        + '<input id="courseName"><button onclick="searchCourse()">搜索</button><button id="btn1" onclick="cancelSearch()">取消搜索</button></td></tr>'
                        + '<tr><td align="center" style="border-style:none;text-align:center;">'
                        + '<select style="width:710px;text-align:center;text-align-last:center;font-size:16px;" name="uploadInfo" id="uploadInfo">'
                        + s
                        + '</select></td></tr></table>'
                        + '<div style="width: 100%; text-align:center; margin-top:10px">'
                        + '<br><br><br><br><br><br>'
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitCSForm()">'
                        + '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#uploadWin\').window(\'close\')">'
                        + '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div>';

                    var obj = $(winStr);
                    $('#uploadWin').html(null);
                    obj.appendTo('#uploadWin');
                    $('#uploadWin').window({
                        width:730,
                        height:365,
                        top:window.outerHeight+300,
                        left:window.innerWidth*0.27,
                        modal:true,
                        title:"同步试卷到教务系统",
                        collapsible:false,
                        minimizable:false,
                        maximizable:false,
                        shadow:false
                    });

					$('#uploadInfo').select2({
						dropdownParent:$('#uploadInfo').parent()
					});
                    if(cname==null){
                        $("#btn1").attr('disabled',true);
                    }else{
                        $("#btn1").attr('disabled',false);
                    }
                },error: function(data){
                    toastr.error("连接至教务系统服务器失败！");
					ajaxLoadEnd();
                    return;
                }
            });
        }else{
            toastr.warning("只有已经改卷归档的试卷才可以同步至教务系统");
            return;
        }
    }

    function searchCourse(){
        $('#uploadWin').window('close');
        var courseName = $("#courseName").val().trim();
        uploadInfo(courseName);
    }

    function cancelSearch(){
        $('#uploadWin').window('close');
        uploadInfo(null);
    }

    function submitCSForm(){
        ajaxLoading();
        if($("#uploadInfo").val()==null){
            toastr.warning("请选中一个课程！");
            ajaxLoadEnd();
            return;
        }
        $.ajax({
            url:"${pageContext.request.contextPath}/result/uploadScore_DL",
            type:"POST",
            data:{"eid":$('#ei_id').val(),"uploadInfo":$("#uploadInfo").val(),"cid":$('#c_id').val()},
            success:function(data){
                ajaxLoadEnd();
                $('#uploadWin').window('close');
                if(data.length==0){
                    toastr.success("数据同步成功！");
                    return;
                }else if(data[0].noScore=="noScore"){
                    toastr.warning("该试卷没有任何学生成绩！");
                    return;
                }else{
                    toastr.success("数据同步完成！");
                    var notExist=[];
                    var exist=[];
                    var winStr ='';
                    for(var i=0;i<data.length;i++){
                        if(data[i].situation=="notExist"){
                            notExist.push(data[i]);
                        }else{
                            exist.push(data[i]);
                        }
                    }

                    if(notExist.length>0){
                        for(let i=0;i<notExist.length;i++){
                            if(i==0){
                                winStr+='<div><table width="80%" align="center" cellspacing="0"><tr><td colspan="3" style="border:0;">&nbsp;</td></tr>';
                                winStr+='<tr><td align="center" style="font-size:15px;text-align:center;" colspan="3">不在学生选课表中因此无法同步的学生名单为：</td></tr>';
                                winStr+='<tr><td>学号</td><td>姓名</td><td>成绩</td></tr>';
                            }
                            winStr+='<tr><td>'+notExist[i].NUM+'</td><td>'+notExist[i].NAME+'</td><td>'+notExist[i].SCORE+'</td></tr>';
                        }
                        winStr += '<tr><td colspan="3" style="border:0">&nbsp;</td></tr></table></div>';
                    }

                    if(exist.length>0){
                        for(let i=0;i<exist.length;i++){
                            if(i==0){
                                winStr+='<div><table width="80%" align="center" cellspacing="0"><tr><td colspan="3" style="border:0;">&nbsp;</td></tr>';
                                winStr+='<tr><td align="center" style="font-size:15px;text-align:center;" colspan="3">已经被同步过因此无法再次同步的学生名单为：</td></tr>';
                                winStr+='<tr><td>学号</td><td>姓名</td><td>成绩</td></tr>';
                            }
                            winStr+='<tr><td>'+exist[i].NUM+'</td><td>'+exist[i].NAME+'</td><td>'+exist[i].SCORE+'</td></tr>';
                        }
                        winStr += '<tr><td colspan="3" style="border:0">&nbsp;</td></tr></table></div>';
                    }

                    var s = '\'table{width:50%;cellspacing:0} td{border: 1px solid black;text-align:center;}\'';
                    var name = '\'考生成绩同步至教务系统结果\'';

                    winStr+='<div style="width: 100%; text-align:center; margin-top:10px">'
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#resultWin\').wordExport('+name+','+s+')">'
                        + '<span class="l-btn-left"><span class="l-btn-text">保存同步结果为word</span></span></a> '
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#resultWin\').window(\'close\')">'
                        + '<span class="l-btn-left"><span class="l-btn-text">关闭</span></span></a></div>';

                    var obj = $(winStr);
                    $('#resultWin').html(null);
                    obj.appendTo('#resultWin');
                    $('#resultWin').window({
                        width:480,
                        //height:215,
                        top:window.outerHeight+320,
                        left:window.innerWidth*0.35,
                        modal:true,
                        title:"未能成功同步的学生数据",
                        collapsible:false,
                        minimizable:false,
                        maximizable:false,
                        shadow:false
                    });
                    return;
                }
            },error:function(xhr){
                $('#uploadWin').window('close');
                ajaxLoadEnd();
                toastr.error("数据同步错误！");
            }
        });
    }

    function ajaxLoading() {
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(document).height() }).appendTo("body");
        $("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候...").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(document).height() - 45) / 2 });
    }

    function ajaxLoadEnd() {
        $("div[class='datagrid-mask']").remove();
        $("div[class='datagrid-mask-msg']").remove();
    }

    function winopen() {
        $('#win').window('open');  // open a window
    }

    function print(){
        $("#view").jqprint();
    }

    function saveAsWord() {
        var s = "table{border-collapse: collapse;} table,th,td{border: 1px solid black;border-width:0px 1px 1px 0px;}";
        var name = $("#ename").val()+"考务信息"+new Date().format('yyyy-MM-dd');
        $("#word").wordExport(name,s);
    }

    function searchCourse(){
        $('#uploadWin').window('close');
        var courseName = $("#courseName").val().trim();
        uploadInfo(courseName);
    }

    function cancelSearch(){
        $('#uploadWin').window('close');
        uploadInfo(null);
    }

    function submitCSForm(){
        ajaxLoading();
        if($("#uploadInfo").val()==null){
            toastr.warning("请选中一个课程！");
            ajaxLoadEnd();
            return;
        }
        $.ajax({
            url:"${pageContext.request.contextPath}/result/uploadScore_DL",
            async:false,
            type:"POST",
            data:{"eid":$('#ei_id').val(),"uploadInfo":$("#uploadInfo").val(),"cid":$('#c_id').val()},
            success:function(data){
                ajaxLoadEnd();
                $('#uploadWin').window('close');
                if(data.length==0){
                    toastr.success("数据同步成功！");
                    return;
                }else if(data[0].noScore=="noScore"){
                    toastr.warning("该试卷没有任何学生成绩！");
                    return;
                }else{
                    toastr.success("数据同步完成！");
                    var notExist=[];
                    var exist=[];
                    var winStr ='';
                    for(var i=0;i<data.length;i++){
                        if(data[i].situation=="notExist"){
                            notExist.push(data[i]);
                        }else{
                            exist.push(data[i]);
                        }
                    }

                    if(notExist.length>0){
                        for(var i=0;i<notExist.length;i++){
                            if(i==0){
                                winStr+='<div><table width="80%" align="center" cellspacing="0"><tr><td colspan="3" style="border:0;">&nbsp;</td></tr>';
                                winStr+='<tr><td align="center" style="font-size:15px;text-align:center;" colspan="3">不在学生选课表中因此无法同步的学生名单为：</td></tr>';
                                winStr+='<tr><td>学号</td><td>姓名</td><td>成绩</td></tr>';
                            }
                            winStr+='<tr><td>'+notExist[i].NUM+'</td><td>'+notExist[i].NAME+'</td><td>'+notExist[i].SCORE+'</td></tr>';
                        }
                        winStr += '<tr><td colspan="3" style="border:0">&nbsp;</td></tr></table></div>';
                    }

                    if(exist.length>0){
                        for(var i=0;i<exist.length;i++){
                            if(i==0){
                                winStr+='<div><table width="80%" align="center" cellspacing="0"><tr><td colspan="3" style="border:0;">&nbsp;</td></tr>';
                                winStr+='<tr><td align="center" style="font-size:15px;text-align:center;" colspan="3">已经被同步过因此无法再次同步的学生名单为：</td></tr>';
                                winStr+='<tr><td>学号</td><td>姓名</td><td>成绩</td></tr>';
                            }
                            winStr+='<tr><td>'+exist[i].NUM+'</td><td>'+exist[i].NAME+'</td><td>'+exist[i].SCORE+'</td></tr>';
                        }
                        winStr += '<tr><td colspan="3" style="border:0">&nbsp;</td></tr></table></div>';
                    }

                    var s = '\'table{width:50%;cellspacing:0} td{border: 1px solid black;text-align:center;}\'';
                    var name = '\'考生成绩同步至教务系统结果\'';

                    winStr+='<div style="width: 100%; text-align:center; margin-top:10px">'
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#resultWin\').wordExport('+name+','+s+')">'
                        + '<span class="l-btn-left"><span class="l-btn-text">保存同步结果为word</span></span></a> '
                        + '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#resultWin\').window(\'close\')">'
                        + '<span class="l-btn-left"><span class="l-btn-text">关闭</span></span></a></div>';

                    var obj = $(winStr);
                    $('#resultWin').html(null);
                    obj.appendTo('#resultWin');
                    $('#resultWin').window({
                        width:480,
                        //height:215,
                        top:window.outerHeight+320,
                        left:window.innerWidth*0.35,
                        modal:true,
                        title:"未能成功同步的学生数据",
                        collapsible:false,
                        minimizable:false,
                        maximizable:false,
                        shadow:false
                    });
                    return;
                }
            },error:function(xhr){
                $('#uploadWin').window('close');
                ajaxLoadEnd();
                toastr.error("数据同步错误！");
            }
        });
    }

    function ajaxLoading() {
        $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(document).height() }).appendTo("body");
        $("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候...").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(document).height() - 45) / 2 });
    }

    function ajaxLoadEnd() {
        $("div[class='datagrid-mask']").remove();
        $("div[class='datagrid-mask-msg']").remove();
    }
</script>

