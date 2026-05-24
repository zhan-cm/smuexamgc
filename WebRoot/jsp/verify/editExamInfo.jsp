<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
<style>
	select,input,textarea{
		border:1px solid #95B8E7;
	}
	#selectObject{
		width:500px;
		height:180px;
		overflow-y:scroll;
		border:1px solid #95B8E7;
		margin-bottom: 5px;
	}
	#selectBox{
		width:500px;
		float: left;
	}
	#selectOption{
		display:none;
	}
	.testObj{
		height:auto;
	}
	.elegant-aero {
		margin-left: auto;
		margin-right: auto;
		max-width: auto;
		padding: 20px 20px 20px 20px;
		font: Arial, Helvetica, sans-serif;
		color: #666;
		border-radius: 8px;
	}
	.elegant-aero h1 {
		font: 24px "Trebuchet MS", Arial, Helvetica, sans-serif;
		padding: 10px 10px 10px 20px;
		display: block;
		border-bottom: 1px solid #B8DDFF;
		margin: -20px -20px 15px;
		border-top-left-radius:8px;
		border-top-right-radius:8px;
		text-align:center;
	}
	/*.elegant-aero h1>span {
        display: block;
        font-size: 11px;
    }*/
	.elegant-aero label>span {
		float: left;
		margin-top: 10px;
		color: #5E5E5E;
	}
	.elegant-aero label {
		display: block;
		margin: 0px 0px 3px;
		clear:both
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
	.elegant-aero input[type="text"], .elegant-aero input[type="password"], .elegant-aero input[type="email"],
	.elegant-aero textarea, .elegant-aero select {
		width: 60%;
		padding: 0px 0px 0px 5px;
		box-shadow: inset 0px 1px 6px #ECF3F5;
		height: 30px;
		line-height: 20px;
		margin: 2px 6px 14px 0px;
		border-radius: 4px;
	}
	/*.elegant-aero .combo-text{
        border: none !important;
        margin: 0px !important;
    }
    .elegant-aero .combo{
        padding-right: 0 !important;
    }
    .elegant-aero .combo-text span{
        padding-right: 0 !important;
    }
    .elegant-aero .missionnum[disabled="disabled"]{
        background: #ddd;
        border: 1px solid #aaa;
    }*/
	.elegant-aero textarea {
		padding: 5px 0px 0px 5px;
		width: 60%;
		border-radius: 4px;
	}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/autoTextarea.js"></script>
<form id="examInfoForm"  class="elegant-aero" method="post" >
	<input type="hidden" name="c_id" id="c_id" value="${examInfo.CID}"/>
	<input type="hidden" name="ei_id" id="ei_id" value="${examInfo.ID}"/>
	<input type="hidden" name="state" id="state" value="${examInfo.STATE}"/>
	<input type="hidden" name="action" id="action" value="${action}"/>
	<input type="hidden" name="c_name" value="${c_name}"/>
	<%-- <input type="hidden" name="code"  value="${code}"/> --%>
	<input type="hidden" name="way"  value="${way}"/>
	<input type="hidden" name="bid"  value="${bid}"/>
	<input type="hidden" id="proportion" value="${examInfo.PROPORTION}"/>
	<input type="hidden" name="ObjectList" id="ObjectList" />
	<h1>试卷审核、编辑考务信息</h1>
	<label>
		<span>考试科目 :</span>
		<div class="spanText">${examInfo.CNAME}</div>
	</label>
	<label>
		<span>试卷名称 :</span>
		<input type="text" name="ename" value="${examInfo.ENAME}"/>
	</label>
	<label>
		<span>课程代码 :</span>
		<input type="text" name="code" value="${examInfo.CODE}"/>
	</label>
	<label>
		<span>学年 :</span>
		<div>
			<select id="schoolYear" name="schoolYear" style="width:170px">
				<c:forEach var="sy" items="${applicationScope.schoolYear}">
					<c:choose>
						<c:when test="${examInfo.SCHOOLYEAR == sy.ID}">
							<option selected="selected" value="${sy.ID}">${sy.NAME}</option>
						</c:when>
						<c:otherwise>
							<option value="${sy.ID}">${sy.NAME}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
			&nbsp;&nbsp;
			<span style="font-weight:bold">学期 :</span>
			&nbsp;&nbsp;
			<select id="term" name="term" style="width:170px">
				<c:forEach var="t" items="${applicationScope.term}">
					<c:choose>
						<c:when test="${examInfo.TERM == t.ID}">
							<option selected="selected" value="${t.ID}">${t.NAME}</option>
						</c:when>
						<c:otherwise>
							<option value="${t.ID}">${t.NAME}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
		</div>
	</label>
	<label>
		<span>考试类型 :</span>
		<div>
			<select id="examType" name="examType" style="width:170px">
				<c:forEach var="et" items="${examTypeList}">
					<c:choose>
						<c:when test="${examInfo.TYPE == et.ETID}">
							<option selected="selected" value="${et.ETID}">${et.ETNAME}</option>
						</c:when>
						<c:otherwise>
							<option value="${et.ETID}">${et.ETNAME}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
			&nbsp;&nbsp;
			<span style="font-weight:bold">开闭卷设置 :</span>
			&nbsp;&nbsp;
			<select id="examWay" name="examWay" style="width:170px">
				<c:forEach var="ew" items="${applicationScope.examWay}">
					<c:choose>
						<c:when test="${examInfo.TESTWAY == ew.ID}">
							<option selected="selected" value="${ew.ID}">${ew.NAME}</option>
						</c:when>
						<c:otherwise>
							<option value="${ew.ID}">${ew.NAME}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>
		</div>
	</label>
	<label>
		<span>考试人数 :</span>
		<div>
			<input type="text" class="easyui-numberspinner" name="total" value="${examInfo.TOTAL}" style="width:170px;"/>
			&nbsp;&nbsp;
			<span style="font-weight:bold">印刷份数 :</span>
			&nbsp;&nbsp;
			<input type="text" class="easyui-numberspinner" name="pcount" value="${examInfo.PRINTCOUNT}" style="width:170px;"/>
		</div>
	</label>
	<label>
		<span>学时数 :</span>
		<input type="text" name="period" id="period" value="${examInfo.PERIOD}" style="width:170px;"/>
	</label>
	<label>
		<span>总评占比 :</span>
		<div class="spanText">本份试卷成绩在课程总评成绩占的比例：<input id="percent" type="text" name="percent" style="margin:0px;border:none"/></div>
	</label>
	<label>
		<span>考试对象 :</span>
		<div id="selectOption">
			<input id="testYear" type="text" name="testYear" style="width:180px;"/>
			<input id="testSpec" type="text" name="testSpec" style="width:500px;"/>
			<a href="javascript:void(0);" class="easyui-linkbutton selectObj" data-options="iconCls:'icon-save'">确定</a>
		</div>
		<div id="selectBox">
			<div id="selectObject">
				<c:forEach var="eo" items="${examObject}">
					<label class="testObj">
						<input type="checkbox" checked="checked"
							   name="testObj" value="${eo.GID},${eo.SID}">${eo.GNAME} ${eo.SNAME}
						<c:if test="${not empty eo.UNAME}">（${eo.UNAME}）</c:if>
					</label>
				</c:forEach>
			</div>
			<a href="javascript:void(0);" class="easyui-linkbutton reSelectObj" data-options="iconCls:'icon-reload'">重新选择</a>
		</div>
	</label>
	<input id="bt" type="hidden" name="bt"/>
	<input id="et" type="hidden" name="et"/>

	<label>
		<span>考试开始日期 :</span>
		<div>
			<input id="bdate" type="text" style="width:180px"/>
			&nbsp;&nbsp;
			<!-- <input id="btime" type="text" style="width:180px"/> -->
			<select id="bhour" style="width:80px;">
				<c:forEach begin="0" end="23" var="i">
					<c:if test="${i < 10}">
						<c:set var="i" value="0${i }"></c:set>
						<option value="${i}">${i}</option>
					</c:if>
					<c:if test="${i >= 10}">
						<option value="${i}">${i}</option>
					</c:if>
				</c:forEach>
			</select>
			<strong>:</strong>
			<select id="bmin" style="width:80px;">
				<c:forEach begin="0" end="55" var="i" step="5">
					<c:if test="${i < 10}">
						<c:set var="i" value="0${i }"></c:set>
						<option value="${i}">${i}</option>
					</c:if>
					<c:if test="${i >= 10}">
						<option value="${i}">${i}</option>
					</c:if>
				</c:forEach>
			</select>
		</div>
	</label>
	<label>
		<span>考试截止日期 :</span>
		<div>
			<input id="edate" type="text" style="width:180px"/>
			&nbsp;&nbsp;
			<!-- <input id="etime" type="text" style="width:180px"/> -->
			<select id="ehour" style="width:80px;">
				<c:forEach begin="0" end="23" var="i">
					<c:if test="${i < 10}">
						<c:set var="i" value="0${i }"></c:set>
						<option value="${i}">${i}</option>
					</c:if>
					<c:if test="${i >= 10}">
						<option value="${i}">${i}</option>
					</c:if>
				</c:forEach>
			</select>
			<strong>:</strong>
			<select id="emin" style="width:80px;">
				<c:forEach begin="0" end="55" var="i" step="5">
					<c:if test="${i < 10}">
						<c:set var="i" value="0${i }"></c:set>
						<option value="${i}">${i}</option>
					</c:if>
					<c:if test="${i >= 10}">
						<option value="${i}">${i}</option>
					</c:if>
				</c:forEach>
			</select>
		</div>
	</label>

	<input id="getBeginDate" type="hidden" value="${examInfo.BEGINDATE}"/>
	<input id="getEndDate" type="hidden" value="${examInfo.ENDDATE}"/>

	<label>
		<span>考试用时 :</span>
		<select id="time" name="time">
			<c:forEach var="st" items="${applicationScope.systemTime2}" begin="18">
				<c:choose>
					<c:when test="${examInfo.TIME == st.ID}">
						<option selected="selected" value="${st.ID}">${st.NAME }</option>
					</c:when>
					<c:otherwise>
						<option value="${st.ID}">${st.NAME }</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>开考前允许登录时间 :</span>
		<div>
			<input type="hidden" id="lockBefore" value="${examInfo.LOCKBEFORE}">
			<select id="loginBefore" name="loginBefore" style="width:170px;">
				<option value="0">0 秒</option>
				<option value="300">5分钟</option>
				<option value="600">10分钟</option>
				<option value="900">15分钟</option>
				<option value="1200">20分钟</option>
				<option value="1800">30分钟</option>
				<option value="3600">1小时</option>
			</select>
			&nbsp;&nbsp;
			<span style="font-weight:bold">开考后禁止登录时间 :</span>
			&nbsp;&nbsp;
			<input type="hidden" id="lockAfter" value="${examInfo.LOCKAFTER}">
			<select id="loginAfter" name="loginAfter" style="width:170px;">
				<option value="-1">无限制</option>
				<option value="0">0 秒</option>
				<option value="300">5分钟</option>
				<option value="600">10分钟</option>
				<option value="900">15分钟</option>
				<option value="1200">20分钟</option>
				<option value="1800">30分钟</option>
				<option value="3600">1小时</option>
			</select>
			&nbsp;&nbsp;
			<span style="font-weight:bold">开考后禁止交卷时间 :</span>
			&nbsp;&nbsp;
			<input type="hidden" id="handIn_limit" value="${examInfo.HANDINTIMELIMIT}">
			<select id="handInTimeLimit" name="handInTimeLimit" style="width:170px;">
				<option value="-1">无限制</option>
				<option value="0">0 秒</option>
				<option value="300">5分钟</option>
				<option value="600">10分钟</option>
				<option value="900">15分钟</option>
				<option value="1200">20分钟</option>
				<option value="1800">30分钟</option>
				<option value="3600">1小时</option>
			</select>
		</div>
	</label>
	<label>
		<span>成绩查询设置 :</span>
		<select id="queryScore" name="queryScore">
			<c:forEach var="qs" items="${applicationScope.queryScore}">
				<c:choose>
					<c:when test="${examInfo.SCHECKWAY == qs.ID}">
						<option selected="selected" value="${qs.ID}">${qs.NAME}</option>
					</c:when>
					<c:otherwise>
						<option value="${qs.ID}">${qs.NAME}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>答卷查看设置 :</span>
		<select id="queryPaper" name="queryPaper">
			<c:forEach var="qp" items="${applicationScope.queryPaper}">
				<c:choose>
					<c:when test="${examInfo.GETANSWER == qp.ID}">
						<option selected="selected" value="${qp.ID}">${qp.NAME}</option>
					</c:when>
					<c:otherwise>
						<option value="${qp.ID}">${qp.NAME}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>考试方式设置 :</span>
		<select id="testMode" name="testMode">
			<c:forEach var="tm" items="${applicationScope.testMode}">
				<c:choose>
					<c:when test="${examInfo.TESTTIMESET == tm.ID}">
						<option selected="selected" value="${tm.ID}">${tm.NAME}</option>
					</c:when>
					<c:otherwise>
						<option value="${tm.ID}">${tm.NAME}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>试题选项随机设置 :</span>
		<select id="randomAnswer" name="randomAnswer">
			<option <c:if test="${examInfo.RANDOMANSWER == 0}">selected="selected"</c:if> value="0">不随机</option>
			<option <c:if test="${examInfo.RANDOMANSWER == 1}">selected="selected"</c:if> value="1">随机</option>
		</select>
	</label>
	<c:if test="${editor_switch==1 }">
		<label>
			<span>是否启用编辑器答题 :</span>
			<select id="editorSwitch" name="editorSwitch">
				<option <c:if test="${examInfo.EDITOR_SWITCH == 0}">selected="selected"</c:if> value="0">禁用（主观题只能输入普通文本，不能键入公式、表格、上标下标）</option>
				<option <c:if test="${examInfo.EDITOR_SWITCH == 1}">selected="selected"</c:if> value="1">启用（主观题可插入表格、公式【目前公式输入后只支持删除再输入，不支持重新编辑已输入的公式】、上下标）</option>
			</select>
		</label>
	</c:if>
	<c:if test="${random_switch==1 }">
		<label>
			<span>是否采用千人千题考试模式 :</span>
			<select id="randomSwitch" name="randomSwitch">
				<option <c:if test="${examInfo.RANDOM == 0}">selected="selected"</c:if> value="0">禁用</option>
				<option <c:if test="${examInfo.RANDOM == 1}">selected="selected"</c:if> value="1">启用</option>
			</select>
		</label>
	</c:if>
	<label>
		<span>答题顺序设置 :</span>
		<select id="answerSequence" name="answerSequence" >
			<c:forEach var="as" items="${applicationScope.answerSequence}">
				<c:choose>
					<c:when test="${examInfo.ANSWERSEQUENCE == as.ID}">
						<option selected="selected" value="${as.ID}">${as.NAME}</option>
					</c:when>
					<c:otherwise>
						<option value="${as.ID}">${as.NAME}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>改卷方式设置 :</span>
		<select id="correctPaper" name="correctPaper">
			<c:forEach var="cp" items="${applicationScope.correctPaper}">
				<c:choose>
					<c:when test="${examInfo.CORRECTWAY == cp.ID}">
						<option selected="selected" value="${cp.ID}">${cp.NAME}</option>
					</c:when>
					<c:otherwise>
						<option value="${cp.ID}">${cp.NAME}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>学号身份限定 :</span>
		<div>
			<select onchange="show(this)" id="sidVer" class="sidVer" name="sidVer" style="width:200px;">
				<c:choose>
					<c:when test="${examInfo.SIDVERIFY eq 0}">
						<c:if test="${applicationScope.faceRecognize eq 'on'}">
							<option value="2">考生必须验证人脸才可考试</option>
						</c:if>
						<option value="1">考生必须验证学号方可考试</option>
						<option selected="selected" value="0">考生无须验证学号便可考试</option>
					</c:when>
					<c:when test="${examInfo.SIDVERIFY eq 1}">
						<c:if test="${applicationScope.faceRecognize eq 'on'}">
							<option value="2">考生必须验证人脸才可考试</option>
						</c:if>
						<option selected="selected" value="1">考生必须验证学号方可考试</option>
						<option value="0">考生无须验证学号便可考试</option>
					</c:when>
					<c:when test="${examInfo.SIDVERIFY eq 2}">
						<c:if test="${applicationScope.faceRecognize eq 'on'}">
							<option selected="selected" value="2">考生必须验证人脸才可考试</option>
							<option value="1">考生必须验证学号方可考试</option>
							<option value="0">考生无须验证学号便可考试</option>
						</c:if>
						<c:if test="${applicationScope.faceRecognize eq 'off'}">
							<option selected="selected" value="1">考生必须验证学号方可考试</option>
							<option value="0">考生无须验证学号便可考试</option>
						</c:if>
					</c:when>
					<c:otherwise>

					</c:otherwise>
				</c:choose>
			</select>
			<c:if test="${applicationScope.faceRecognize eq 'on'}">
				&nbsp;&nbsp;
				<span style="font-weight:bold">考试过程中验证人脸次数 :</span>
				&nbsp;&nbsp;
				<input type="number" style="width:50px;height: 30px;" id="facetime" name="facetime" value="${examInfo.FACETIME}">
				&nbsp;&nbsp;
				<span style="font-weight:bold">验证人脸失败后的处理 :</span>
				&nbsp;&nbsp;
				<input type="hidden" id="facefail" value="${examInfo.FACEFAIL}">
				<select id="face_fail" name="face_fail" style="width:250px;">
					<option value="0">考生继续考试</option>
					<option value="1">考生退出考试，自行重新登录</option>
					<option value="2">考生退出考试，由老师操作才可再次登录</option>
				</select>
			</c:if>
		</div>
	</label>
	<label>
		<span>通用号 :</span>
		<input type="text" class="missionnum"  name="missionnum" style="width:90px;" value="${examInfo.MISSIONNUM}"/>
		当个别学生不能正确输入考试任务号或学号，单独告诉学生输入此号
	</label>
	<!-- 		<label>  -->
	<!-- 			<span>试题天数筛选 :</span>  -->
	<!-- 			不选用&nbsp; -->
	<!-- 			<select name="forbidDay" style="width:80px;"> -->
	<%-- 				<c:forEach var="forbidDay" items="${applicationScope.forbidDay}"> --%>
	<%-- 					<c:choose> --%>
	<%-- 					    <c:when test="${examInfo.FORBIDBEFORE == forbidDay.ID}"> --%>
	<%-- 							<option selected="selected" value="${forbidDay.ID}">${forbidDay.NAME}</option> --%>
	<%-- 						</c:when> --%>
	<%-- 					    <c:otherwise> --%>
	<%-- 							<option value="${forbidDay.ID}">${forbidDay.NAME}</option> --%>
	<%-- 						</c:otherwise> --%>
	<%-- 					</c:choose>		 --%>
	<%-- 				</c:forEach> --%>
	<!-- 			</select>&nbsp;之内考过的试题 -->
	<!-- 		</label>  -->
	<!-- 		<label>  -->
	<!-- 			<span>试题次数筛选 :</span>  -->
	<!-- 			<div> -->
	<%-- 				不选用已使用过&nbsp;<input name="forbidNum" type="text" style="width:90px" value="${examInfo.FORBIDNUM}"/>&nbsp;次及以上的试题 --%>
	<!-- 			</div> -->
	<!-- 		</label> -->
	<!-- 		<label>  -->
	<!-- 			<span>试题状态筛选 :</span>  -->
	<!-- 			<select name="isVerified"> -->
	<%-- 				<c:choose> --%>
	<%-- 				    <c:when test="${examInfo.ISVERIFIED == 0}"> --%>
	<!-- 						<option selected="selected" value="0">试题不限已审核</option> -->
	<!-- 						<option value="1">限制为已经通过审核的试题</option> -->
	<%-- 					</c:when> --%>
	<%-- 				    <c:when test="${examInfo.ISVERIFIED == 1}"> --%>
	<!-- 						<option value="0">试题不限已审核</option> -->
	<!-- 						<option selected="selected" value="1">限制为已经通过审核的试题</option> -->
	<%-- 					</c:when> --%>
	<%-- 				    <c:otherwise> --%>

	<%-- 					</c:otherwise> --%>
	<%-- 				</c:choose> --%>
	<!-- 			</select> -->
	<!-- 		</label> -->
	<label>
		<span>是否允许移动端考试：</span>
		<div class="spanText">
			<c:choose>
				<c:when test="${examInfo.MOBILE == 0}">
					<input name="mobile" type="radio" value="0" checked/>禁止
					<input name="mobile" type="radio" value="2" />允许
				</c:when>
				<c:otherwise>
					<input name="mobile" type="radio" value="0">禁止
					<input name="mobile" type="radio" value="2" checked/>允许
				</c:otherwise>
			</c:choose>
		</div>
		<span>考试切屏次数限制：</span>
		<select id="switchOutLimitSelect" name="switchOutLimitSelect" style="width:200px;">
			<option value="-1"
					<c:if test="${examInfo.SWITCH_OUT_LIMIT == -1}">selected="selected"</c:if>
			>无限制</option>

			<c:forEach var="i" begin="1" end="10">
				<option value="${i}"
						<c:if test="${examInfo.SWITCH_OUT_LIMIT == i}">selected="selected"</c:if>
				>${i}次退出考试</option>
			</c:forEach>
		</select>
	</label>
	<label>
		<span>组卷负责人 :</span>
		<div class="spanText">${examInfo.TEACHERNAME}</div>
	</label>
	<label>
		<span>联系电话 :</span>
		<input id="tel" type="text" name="tel" value="${examInfo.TEL}" class="easyui-validatebox" />
	</label>
	<label>
		<span>监考老师 :</span>
		<div>
			<input id="invigilator" type="text" name="invigilator" value="${examInfo.INVIGILATORIDS}" style="width:170px"/>
			&nbsp;&nbsp;
			<span style="font-weight:bold">巡考老师 :</span>
			&nbsp;&nbsp;
			<input id="patrol" type="text" name="patrol" value="${examInfo.PATROLIDS}" style="width:170px"/>
			&nbsp;&nbsp;
			<span style="font-weight:bold">任课老师 :</span>
			&nbsp;&nbsp;
			<input id="courseTeacher" type="text" name="courseTeacher" value="${examInfo.COURSETEACHER}" style="width:170px"/>
		</div>
	</label>
	<label>
		<span>考试地点 :</span>
		<input id="venues" type="text" name="venues" value="${examInfo.VENUES}"/>
	</label>
	<label>
		<span>考试须知 :</span>
		<textarea cols="70" name="remark2s">${examInfo.REMARK2S}</textarea>
	</label>
	<label>
		<span>英文考试须知 :</span>
		<textarea  cols="70" name="e_remark2s">${examInfo.E_REMARK2S}</textarea>
	</label>
	<label>
		<span>备注说明 :</span>
		<textarea  cols="70" name="remark2t">${examInfo.REMARK2T}</textarea>
	</label>
	<!--
		<label> 
			<span>是否联考卷：</span> 
			<div class="spanText">
				<c:choose>
					<c:when test="${examInfo.ISUNION==0 }">
						<input name="isUnion" type="radio" value="0" checked/>非联考卷
						<input name="isUnion" type="radio" value="1" />联考卷
					</c:when>
					<c:when test="${examInfo.ISUNION==1 }">
						<input name="isUnion" type="radio" value="0" />非联考卷
						<input name="isUnion" type="radio" value="1" checked/>联考卷
					</c:when>
					<c:when test="${examInfo.ISUNION==2 }">
						<input name="isUnion" type="radio" value="0" />非联考卷
						<input name="isUnion" type="radio" value="1" />联考卷
					</c:when>
				</c:choose>
			</div>
		</label> -->
	<label>
		<span>试卷生成时间 :</span>
		<div class="spanText">${examInfo.CREATETIME}</div>
	</label>
	<c:if test="${examInfo.STATE == 1 || examInfo.STATE == 2}">
		<label>
			<span>试卷预览 :</span>
			<div style="float:left; width:75%; text-align:left;">
				<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="seePaper(${examInfo.ID},'A')">查看A卷</a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-view'" onclick="seePaperWithAnswer(${examInfo.ID},'A')">查看A卷答案</a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-chart_bar'" href="javascript:void(0);" onclick="forecastPaper(${examInfo.ID},'A')">A卷预测</a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-book'" href="javascript:void(0);" onclick="checkList(${examInfo.ID},'A')">A卷双向细目表</a>&nbsp;&nbsp;
				<a class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);" onclick="teacherAnswerList(${examInfo.ID},'A')">A卷已作答记录</a>&nbsp;
			</div>
		</label>
		<c:if test="${not empty examInfo.BID}">
			<label>
				<span></span>
				<div style="text-align:left">
					<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="seePaper(${examInfo.BID},'B')" >查看B卷</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-view'" onclick="seePaperWithAnswer(${examInfo.BID},'B')" >查看B卷答案</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-chart_bar'" href="javascript:void(0);" onclick="forecastPaper(${examInfo.BID},'B')">B卷预测</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-book'" href="javascript:void(0);" onclick="checkList(${examInfo.BID},'B')">B卷双向细目表</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);" onclick="teacherAnswerList(${examInfo.BID},'B')">B卷已作答记录</a>&nbsp;
					<c:if test="${applicationScope.AI_exampaper_test_switch==1}">
						<a class="easyui-linkbutton" data-options="iconCls:'icon-copy'" href="javascript:void(0);" onclick="getAIPaperTest(${examInfo.BID})">B卷AI试题内容分析</a>&nbsp;
					</c:if>
				</div>
			</label>
		</c:if>
		<c:if test="${not empty examInfo.CPID}">
			<label>
				<span></span>
				<div style="text-align:left">
					<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="seePaper(${examInfo.CPID},'C')" >查看C卷</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-view'" onclick="seePaperWithAnswer(${examInfo.CPID},'C')" >查看C卷答案</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-chart_bar'" href="javascript:void(0);" onclick="forecastPaper(${examInfo.CPID},'C')">C卷预测</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-book'" href="javascript:void(0);" onclick="checkList(${examInfo.CPID},'C')">C卷双向细目表</a>&nbsp;&nbsp;
					<a class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);" onclick="teacherAnswerList(${examInfo.CPID},'C')">C卷已作答记录</a>&nbsp;
					<c:if test="${applicationScope.AI_exampaper_test_switch==1}">
						<a class="easyui-linkbutton" data-options="iconCls:'icon-copy'" href="javascript:void(0);" onclick="getAIPaperTest(${examInfo.CPID})">C卷AI试题内容分析</a>&nbsp;
					</c:if>
				</div>
			</label>
		</c:if>
	</c:if>
	<c:if test="${openFindRepeatSystem eq 1}">
		<label>
			<span>提交审核查重记录 :</span>
			<div style="float:left; width:75%; text-align:left;">
				<span id="firstSubmit_repeat_pdf" style="display:inline-block; margin:0 8px 8px 0;"></span>
				<span id="firstVerify_repeat_pdf" style="display:inline-block; margin:0 8px 8px 0;"></span>
			</div>
		</label>
	</c:if>

	<c:choose>
		<c:when test="${examInfo.STATE == 1 }">
			<label>
				<span>初级审核意见 :</span>
				<textarea rows="2" cols="70" name="firstverifyopinion"></textarea>
			</label>
			<label>
				<span>回退试卷状态 :</span>
				<input type="radio" name="return_state" value="0"/>尚未提交审核
				<input type="radio" name="return_state" value="2"/>审核未被通过
			</label>
		</c:when>
		<c:when test="${examInfo.STATE == 2 }">
			<label>
				<span>初级审核意见 :</span>
				<div class="spanText">${examInfo.FIRSTVERIFYOPINION}</div>
			</label>
			<label> <span>初审人:</span>
				<div class="spanText">${examInfo.FIRSTVERIFYTEACHER}</div>
			</label>
			<label>
				<span>初级审核时间 :</span>
				<div class="spanText">${examInfo.FIRSTVERIFY}</div>
			</label>
			<label>
				<span>终极审核意见 :</span>
				<textarea rows="2" cols="70" name="lastverifyopinion"></textarea>
			</label>
			<c:if test="${examInfo.ISUNION==0 }">
				<label>
					<span>选用试卷 :</span>
					<input type="radio" name="chosen" checked="checked" value="${examInfo.ID}"/>A卷
					<c:if test="${not empty examInfo.BID}">
						<input type="radio" name="chosen" value="${examInfo.BID}"/>B卷
					</c:if>
					<c:if test="${not empty examInfo.CPID}">
						<input type="radio" name="chosen" value="${examInfo.CPID}"/>C卷
					</c:if>
				</label>
			</c:if>
			<label>
				<span>回退试卷状态 :</span>
				<input type="radio" name="return_state" value="0"/>尚未提交审核
				<input type="radio" name="return_state" value="1"/>等待初极审核
				<input type="radio" name="return_state" value="2"/>审核未被通过
			</label>
		</c:when>
	</c:choose>
</form>
<div style="clear:both;"></div>
<div style="width: 100%; height: 40px; text-align: center;">
	<c:choose>
		<c:when test="${examInfo.STATE == 0 || examInfo.STATE == 3 || examInfo.STATE == 7}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="updateExamInfo()">提交审核</a>&nbsp;
		</c:when>
		<c:when test="${examInfo.STATE == 1 || examInfo.STATE == 2}">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="updateExamInfo()">通过审核</a>&nbsp;
			<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="fail()">不通过审核</a>&nbsp;

			<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);" >作答记录</a>&nbsp; -->

		</c:when>
		<c:otherwise>

		</c:otherwise>
	</c:choose>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="window.history.go(-1);return false;">返回</a>
</div>
<div id="tipsWin"></div>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script type="text/javascript">
	toastr.options = {
		showDuration: "550"
	}

	var ei_id = $('#ei_id').val();
	var beforeFaceTime = $("#facetime").val();
	function forecastPaper(eid,aorb) {
		var cid = $("#c_id").val();
		var url = "${pageContext.request.contextPath}/paper/forecastPaper?c_id=" + cid + "&ei_id=" + eid + "&verify=1";
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';

		if(aorb=='A'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'A卷预测分析',
				content: content,
				closable: true
			});
		}else if(aorb=='B'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'B卷预测分析',
				content: content,
				closable: true
			});
		}else{
			window.parent.$('#nav_tab').tabs('add',{
				title: 'C卷预测分析',
				content: content,
				closable: true
			});
		}
	}

	function checkList(eid,aorb) {
		var cid = $("#c_id").val();
		var url = "${pageContext.request.contextPath}/paper/checkList?c_id=" + cid + "&ei_id=" + eid + "&verify=" + 1;
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
		if(aorb=='A'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'A卷双向细目表',
				content: content,
				closable: true
			});
		}else if(aorb=='B'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'B卷双向细目表',
				content: content,
				closable: true
			});
		}else{
			window.parent.$('#nav_tab').tabs('add',{
				title: 'C卷双向细目表',
				content: content,
				closable: true
			});
		}

	}

	function getAIPaperTest(eid) {
		// 先查询状态
		$.get('${pageContext.request.contextPath}/intelliPaper/getTestPaperDocxByAIInfo', { eid })
				.done(function (info) {
					showAIPaperDialog(eid, info);
				})
				.fail(function (xhr) {
					if (xhr.status === 401) {
						Swal.fire('未授权', '请重新登录或检查权限', 'error');
					} else if (xhr.status === 404) {
						// 文件不存在 & 未在生成
						showAIPaperDialog(eid, { exists: false, running: false });
					} else {
						Swal.fire('获取状态失败', xhr.responseText || '未知错误', 'error');
					}
				});
	}

	function showAIPaperDialog(eid, info) {
		if (info.running) {
			Swal.fire({
				title: '报告生成中…',
				html: 'AI 正在分析试卷，请稍后刷新或等待自动完成。',
				icon: 'info',
				showConfirmButton: false,
				timer: 3000
			});
			return;
		}

		// 构造弹窗内容
		let html = '';
		if (info.exists) {
			const dateStr = new Date(info.lastModified).toLocaleString();
			html += `<p>已生成报告，最后更新时间：<b>\${dateStr}</b></p>`;
		} else {
			html += '<p><b>当前无 AI 试卷分析报告（生成一份报告大致需要5分钟）</b></p>';
		}

		// 弹窗
		Swal.fire({
			title: 'AI 试卷分析',
			html: html,
			icon: info.exists ? 'success' : 'warning',
			showCancelButton: true,
			confirmButtonText: info.exists ? '重新生成' : '生成',
			cancelButtonText: info.exists ? '下载' : '关闭'
		}).then((result) => {
			if (result.isConfirmed) {
				// ★ 重新生成（或生成）
				$.post('${pageContext.request.contextPath}/intelliPaper/testPaperByAI', { eid })
						.done(function (msg) {
							Swal.fire('已提交', msg === 'running' ? '已有任务正在执行' : '任务已开始，请稍后刷新', 'success');
						})
						.fail(function () {
							Swal.fire('提交失败', '无法启动 AI 任务', 'error');
						});
			} else if (result.dismiss === Swal.DismissReason.cancel && info.exists) {
				// ★ 下载
				window.location.href = '${pageContext.request.contextPath}/intelliPaper/downloadTestPaperDocxByAI?eid=' + encodeURIComponent(eid);
			}
		});
	}


	$(document).ready(function(){

		$.each($("textarea"), function(i, n){
			autoTextarea($(n)[0],10);
		});
		$('#percent').numberspinner({
			min: 0,
			max: 100,
			width: 88
		});

		$('#percent').numberspinner('setValue', $('#proportion').val());
		$('.missionnum').on('input', function () {
			const $t = $(this);
			const before = $t.val();// 原始值
			let after = before.replace(/[^\d]/g, '')  // 去非数字
					.replace(/^0+/, '');    // 去前导 0

			const changed = after !== before;
			if (changed) {
				$t.val(after);
				if (after !== '') {
					if (!$t.data('warnLock')) {
						toastr.warning('通用号必须是合法正整数');
						$t.data('warnLock', true);
						const timer = setTimeout(() => $t.removeData('warnLock'), 1200);
						$t.data('warnTimer', timer);
					}
				}
			}
		});

		if($("#lockBefore").val()!=null&&$("#lockBefore").val()!=''){
			$("#loginBefore").val($("#lockBefore").val());
		}else{
			$("#loginBefore").val('0');
		}

		if($("#sidVer").val() != "2"){
			$("#facetime").val("0");
			$("#facetime").attr("disabled","disabled").css("background-color","#EEEEEE");
			$("#face_fail").val("0");
			$("#face_fail").attr("disabled","disabled").css("background-color","#EEEEEE");

		}else{
			$("#facetime").val($("#facetime").val());
			$("#face_fail").val($("#facefail").val());
		}
		$(document).on('click', '.radio-proxy', function (e) {
			e.preventDefault();
			e.stopPropagation();
			pickByNameValue($(this).data('name'), $(this).data('value'));
		});

		if($("#lockAfter").val()!=null&&$("#lockAfter").val()!=''){
			$("#loginAfter").val($("#lockAfter").val());
		}else{
			$("#loginAfter").val('-1');
		}

		$("#handInTimeLimit").val('-1');
		if($("#handIn_limit").val()!=null&&$("#handIn_limit").val()!=''&&$("#handIn_limit").val()!='null'){
			$("#handInTimeLimit").val($("#handIn_limit").val());
		}else{
			$("#handInTimeLimit").val('-1');
		}

		$('#bdate').datebox({
			editable: false,
			value : new Date(Date.parse($('#getBeginDate').val())).format('yyyy-MM-dd')
		});
		$('#edate').datebox({
			editable: false,
			value : new Date(Date.parse($('#getEndDate').val())).format('yyyy-MM-dd')
		});

		var time1 = new Date(Date.parse($('#getBeginDate').val())).format('hh:mm');
		var btime = time1.split(":")
		$("#bhour").val(btime[0]);
		$("#bmin").val(btime[1]);

		var time2 = new Date(Date.parse($('#getEndDate').val())).format('hh:mm');
		var etime = time2.split(":")
		$("#ehour").val(etime[0]);
		$("#emin").val(etime[1]);
		/* 	$('#btime').timespinner({
                editable: false,
                value: new Date(Date.parse($('#getBeginDate').val())).format('hh:mm')
            });
            $('#etime').timespinner({
                editable: false,
                value: new Date(Date.parse($('#getEndDate').val())).format('hh:mm')
            }) */

		$('#testYear').combogrid({
			url: '${pageContext.request.contextPath}/paper/getGrade4ExamInfo',
			idField: 'ID',
			textField: 'NAME',
			multiple: true,
			editable: false,
			columns: [[
				{field:'ID',checkbox:true},
				{field:'NAME',title:'年级',width:130,sortable:true}
			]]
		});


		let allSpecs = [];
		$.getJSON(
				'${pageContext.request.contextPath}/course/getCourseSpecialtyList',
				{ c_id: $("#c_id").val() },
				function (resp) {
					allSpecs = resp.rows || resp;

					$('#testSpec').combogrid({
						data: allSpecs,
						mode: 'local',
						editable: false, // 禁止直接输入，避免拼音残留问题
						multiple: true,
						idField: 'ID',
						textField: 'NAME',
						panelWidth: 600,
						panelHeight: 400,
						prompt: '请选择专业',
						columns: [[
							{ field: 'ID', checkbox: true },
							{
								field: 'NAME',
								title: '专业',
								width: 500,
								formatter: (value, row) => {
									const uname = row.UNAME ? `（\${row.UNAME}）` : '';
									return `<span>\${value}</span><span style="color:red;font-size:11px;">\${uname}</span>`;
								}
							}
						]],
						onShowPanel() {
							createCustomFilterInput($(this));
						},
						onHidePanel() {
							removeCustomFilterInput($(this));
						}
					});

					// 创建并插入搜索框
					function createCustomFilterInput($combogrid) {
						const panel = $combogrid.combogrid('panel');

						// 防止重复创建
						if (panel.find('.custom-filter').length) return;

						const inputHtml = `
                <div class="custom-filter" style="padding:5px;">
                    <input type="text" style="width:98%;padding:3px;" placeholder="输入关键词实时过滤..." />
                </div>`;

						panel.prepend(inputHtml);

						const $filterInput = panel.find('.custom-filter input');
						$filterInput.focus();

						let inIME = false;
						$filterInput.on('compositionstart', () => inIME = true);
						$filterInput.on('compositionend', function() {
							inIME = false;
							filterData($combogrid, $(this).val());
						});
						$filterInput.on('input', function() {
							if (!inIME) {
								filterData($combogrid, $(this).val());
							}
						});
					}

					// 移除搜索框并重置数据
					function removeCustomFilterInput($combogrid) {
						const panel = $combogrid.combogrid('panel');
						panel.find('.custom-filter').remove();
						// 重置数据
						$combogrid.combogrid('grid').datagrid('loadData', allSpecs);
					}

					// 执行本地过滤
					function filterData($combogrid, keyword) {
						const grid = $combogrid.combogrid('grid');
						if (!keyword) {
							grid.datagrid('loadData', allSpecs);
							return;
						}
						const filtered = allSpecs.filter(row =>
								row.NAME.toLowerCase().includes(keyword.toLowerCase())
						);
						grid.datagrid('loadData', filtered);
					}
				}
		);

		loadRepeatPdfBtn($('#ei_id').val(), "firstSubmit", "firstSubmit_repeat_pdf", "初次提交查重记录");
		loadRepeatPdfBtn($('#ei_id').val(), "firstVerify", "firstVerify_repeat_pdf", "初审提交查重记录");
	});

	function pickByNameValue(name, value) {
		var $el = $('input[type=radio][name="' + name + '"][value="' + value + '"]');
		if ($el.length && !$el.is(':disabled')) {
			$el.prop('checked', true).trigger('change');
		}
	}
	function lockRadioGroup(name, locked) {
		$('input[type=radio][name="' + name + '"]').prop('disabled', !!locked);
	}

	$('.reSelectObj').click(function(){
		$('#selectOption').slideDown();
		$('#selectBox').slideUp();
		$('#selectObject').html(null);
	});

	$('.selectObj').click(function(){
		var testYear = $('#testYear').combogrid('grid').datagrid('getSelections');
		var testSpec = $('#testSpec').combogrid('grid').datagrid('getSelections');

		if(testYear == '' || testYear == null){
			toastr.warning('考试年级不能为空');
			return;
		}
		if(testSpec == '' || testSpec == null){
			toastr.warning('考试专业不能为空');
			return;
		}
		if(testYear && testSpec){
			$('#selectObject').html(null);
			for(var i=0; i<testYear.length; i++){
				var ty = testYear[i];
				for(var j=0; j<testSpec.length;j++){
					var ts = testSpec[j];
					let uname = '';
					if(ts.UNAME){
						uname = '（'+ts.UNAME+'）';
					}
					var str = '<label class="testObj"><input type="checkbox" checked="checked" name="testObj" value="'
							+ ty.ID + ',' + ts.ID + '"/>'
							+ ty.NAME + ' ' + ts.NAME + uname + '</label>';
					var testObj = $(str);
					testObj.appendTo('#selectObject');
				}
			}
			$('#selectBox').slideDown();
			$('#selectOption').slideUp();
			toastr.info('无需考试的对象可以去掉勾选');
		}
	});


	function updateExamInfo(){
		/* var invigilator = $('#invigilator').val();
        if(invigilator == '' || invigilator == null){
            toastr.warning("请输入监考老师！");
            $('#invigilator').focus();
            return;
        } */

		//终审监考老师必填
		var state = $('#state').val();
		//if(state == '2' || state == 2){
		var invigilator = $('#invigilator').val();
		if(invigilator === null || typeof(invigilator) == "undefined" ||invigilator.trim() === ''){
			toastr.warning("请输入监考老师！");
			$('#invigilator').focus();
			return;
		}
		//}


		var bdate = $('#bdate').datebox('getValue');
		var edate = $('#edate').datebox('getValue');
		/* 	var btime = $('#btime').timespinner('getValue');
        var etime = $('#etime').timespinner('getValue'); */

		var btime = $("#bhour").val() + ":" + $("#bmin").val();
		var etime = $("#ehour").val() + ":" + $("#emin").val();

		$("#bt").val(bdate + " " + btime);
		$("#et").val(edate + " " + etime);

		var tel = $('#tel').val();
		/*
        if($('#selectObject').html() == '' || $('#selectObject').html()==null){
            toastr.warning('考试对象不能为空');
            return;
        }*/
		$input=$('input[name=testObj]');
		if($input.val()==''||$input.val()==null){
			toastr.warning('考试对象不能为空');
			return;
		}
		if(!bdate|| bdate==null){
			toastr.warning('考试开始日期不能为空');
			return;
		}
		if(!edate|| edate==null){
			toastr.warning('考试截止日期不能为空');
			return;
		}

		if(edate < bdate){
			toastr.warning('考试截止日期不能早于考试开始日期');
			return false;
		}

		var time1 = btime.split(":");
		var time2 = etime.split(":");

		if(time2[0] < time1[0]){
			toastr.warning('考试截止时间不能早于考试开始时间');
			return false;
		}
		let pattern = /^(0|[1-9][0-9]*)$/;
	   	if($("#facetime").val()==null || $("#facetime").val().trim()=="" || !pattern.test($("#facetime").val())){
			$("#facetime").val("0");
		}
		if(time1[0] == time2[0]){
			if(time1[1] >= time2[1]){
				toastr.warning('考试截止时间不能早于或等于考试开始时间');
				return false;
			}
		}
		var mobile=$("input[name='mobile']:checked").val();
		if(mobile==2){//允许移动考试
			var testMode=$("#testMode").val();
			if(!(testMode=='5'||testMode=='1'||testMode=='0')){
				toastr.warning('允许移动端考试的情况下，考试方式只能设置为“限定总的答题时间,每道小题不限定时间，考生不可回看试题”或“限定总的答题时间，考生可回看试题”');
				return;
			}
			var sidverify=$("#sidVer").val();
			if(sidverify==2){
				toastr.warning('允许移动端考试的情况下，考试登录过程不支持验证人脸');
				return;
			}
		}

		let $p = $("#period");
		let v = $p.val().replace(/\s+/g, ""); // 去掉所有空白(含首尾/中间/换行/tab)
		$p.val(v); // 回写输入框
		if (v !== "" && !/^(?:[1-9]\d*(?:\.\d+)?|0\.\d+)$/.test(v)) {
			toastr.warning('学时数必须为正数！');
			return;
		}



		//if(!(/^0\d{2,3}-?\d{7,8}$/.test(tel)) && !(/^1[34578]\d{9}$/.test(tel))){
		/*if($("#state").val()!=2){
            if(!(/^1[34578]\d{9}$/.test($("#tel").val()))){
                toastr.error('请填写正确的手机号码');
                $("#tel").focus();
                return;
            }
        }*/

		var long1=(parseInt(time2[0])-parseInt(time1[0]))*60*60+(parseInt(time2[1])-parseInt(time1[1]))*60;
		var next=false;
		$.ajax({
			url : "${pageContext.request.contextPath}/common/getSystemTimeByID",
			async : false,
			type : "POST",
			data: {id:$("#time").val()},
			success: function(data){
				if(data){
					if(parseInt(data)<=long1){
						next=true;
					}
				}
			}
		});
		if(next==false){
			toastr.warning('考试开始以及截止时间间隔必须大于或等于考试用时！');
			return;
		}
		toUpdateExamInfo();
	}

	function toUpdateExamInfo(){
		$.ajax({
			url : "${pageContext.request.contextPath}/paper/updateExamInfo",
			async : false,
			type : "POST",
			data: $('#examInfoForm').serialize(),
			success: function(data){
				if(data=="success"){
					toastr.success('操作成功');
					var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
					if(title == '网站首页'){
						window.location.href = "${pageContext.request.contextPath}/news/newsList?page=1&rows=20";
					}else{
						window.history.go(-1);
					}

				}else if(data!=null && data.indexOf("error") > -1){
					let info = "试卷请求查重失败！";
					if(data==="error_A_repeat"){
						info = "A卷存在超过10%分值的试题在本学期已被使用，需修改或删除该部分试题再提交审核！";
					}else if(data==="error_B_repeat"){
						info = "B卷存在超过10%分值的试题在本学期已被使用，需修改或删除该部分试题再提交审核！";
					}else if(data==="error_AB_repeat"){
						info = "A、B卷之间存在超过10%分值的试题重复！";
					}
					let tipstr = '<div style="margin: 5px 5px;border-bottom: 1px dashed grey">'+info+'</div>'
							+ '<div style="margin: 5px 5px;">试卷将自动退回到“<span style="font-weight: bold;">尚未提交审核的考试计划、试卷</span>”</div>'
							+ '<div style="width: 100%; text-align:center; margin-top:10px">'
							+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="confirmUpdateNow()">'
							+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
							+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#tipsWin\').window(\'close\')">'
							+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div>';
					const obj = $(tipstr);
					$('#tipsWin').html(null);
					obj.appendTo('#tipsWin');
					$('#tipsWin').window({
						width:390,
						height:150,
						modal:true,
						title:"提示",
						collapsible:false,
						minimizable:false,
						maximizable:false,
						onOpen: function() {
							const windowTop = ($(window).height()+$(window).scrollTop() - $(this).height()) / 2;
							const windowLeft = ($(window).width() - $(this).width()) / 2;
							$(this).window('move', { top: windowTop, left: windowLeft });
						}
					});
				}else{
					toastr.error('操作失败');
				}
			}
		})
	}

	function confirmUpdateNow(){
		$.ajax({
			url: "${pageContext.request.contextPath}/paper/updateExamInfoState",
			async: false,
			type: "POST",
			data: $('#examInfoForm').serialize(),
			success: function (data) {
				if(data==1){
					toastr.success('操作成功！');
					window.location.href = "${pageContext.request.contextPath}/verify/paperList";
				}else {
					toastr.error('操作失败！');
				}
			}
		});
	}

	function fail(){
		var bdate = $('#bdate').datebox('getValue');
		var edate = $('#edate').datebox('getValue');
		var btime = $("#bhour").val() + ":" + $("#bmin").val();
		var etime = $("#ehour").val() + ":" + $("#emin").val();

		$("#bt").val(bdate + " " + btime);
		$("#et").val(edate + " " + etime);

		var tel = $('#tel').val();

		if($('#selectObject').html() == '' || $('#selectObject').html()==null){
			toastr.warning('考试对象不能为空');
			return;
		}
		if(!bdate|| bdate==null){
			toastr.warning('考试开始日期不能为空');
			return;
		}
		if(!edate|| edate==null){
			toastr.warning('考试截止日期不能为空');
			return;
		}

		if(edate < bdate){
			toastr.warning('考试截止日期不能早于考试开始日期');
			return false;
		}
		var time1 = btime.split(":");
		var time2 = etime.split(":");

		if(time2[0] < time1[0]){
			toastr.warning('考试截止时间不能早于考试开始时间');
			return false;
		}
		if(time1[0] == time2[0]){
			if(time1[1] >= time2[1]){
				toastr.warning('考试截止时间不能早于或等于考试开始时间');
				return false;
			}
		}
		let $p = $("#period");
		let v = $p.val().replace(/\s+/g, ""); // 去掉所有空白(含首尾/中间/换行/tab)
		$p.val(v); // 回写输入框
		if (v !== "" && !/^(?:[1-9]\d*(?:\.\d+)?|0\.\d+)$/.test(v)) {
			toastr.warning('学时数必须为正数！');
			return;
		}
		var return_state = $("input[name='return_state']:checked").val();
		if(return_state==null){
			toastr.warning('必须得勾选退回的试卷状态! ');
			return;
		}

		//if(!(/^0\d{2,3}-?\d{7,8}$/.test(tel)) && !(/^1[34578]\d{9}$/.test(tel))){
		/*if($("#state").val()!=2){
            if(!(/^1[34578]\d{9}$/.test($("#tel").val()))){
                toastr.error('请填写正确的手机号码');
                $("#tel").focus();
                return;
            }
        } */

		$('#action').val("fail");
		/*$('#examInfoForm').form('submit', {
            url:'${pageContext.request.contextPath}/paper/updateExamInfo',
	    onSubmit: function(){
	    },
	    success:function(data){
	    	if(data=="success"){
				toastr.success('操作成功');
				var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题  	
				if(title == '网站首页'){
					window.location.href = "${pageContext.request.contextPath}/news/newsList";
				}else{
					window.history.go(-1);
				}
				
			}else{
				toastr.error('操作失败');
			}
	    }
	});*/
		//$('#examInfoForm').submit();
		toUpdateExamInfo();
	}

	function seePaper(eid,aorb){
		var cid = $("#c_id").val();
		var url = '${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + eid;
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';

		if(aorb=='A'){
			window.parent.$('#nav_tab').tabs('add',{
				title: '预览A卷',
				content: content,
				closable: true
			});
		}else if(aorb=='B'){
			window.parent.$('#nav_tab').tabs('add',{
				title: '预览B卷',
				content: content,
				closable: true
			});
		}else{
			window.parent.$('#nav_tab').tabs('add',{
				title: '预览C卷',
				content: content,
				closable: true
			});
		}
	}

	function teacherAnswerList(eid,aorb){
		var cid = $("#c_id").val();
		var url = '${pageContext.request.contextPath}/teacherTest/inTeacherAnswerList?eid='+eid;
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';

		if(aorb=='A'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'A卷已作答记录',
				content: content,
				closable: true
			});
		}else if(aorb=='B'){
			window.parent.$('#nav_tab').tabs('add',{
				title: 'B卷已作答记录',
				content: content,
				closable: true
			});
		}else{
			window.parent.$('#nav_tab').tabs('add',{
				title: 'C卷已作答记录',
				content: content,
				closable: true
			});
		}
	}

	function seePaperWithAnswer(eid,aorb) {
		var cid = $("#c_id").val();
		var url = '${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + eid +'&aFlag=1';
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';

		if(aorb=='A'){
			window.parent.$('#nav_tab').tabs('add',{
				title: '查看A卷答案',
				content: content,
				closable: true
			});
		}else if(aorb=='B'){
			window.parent.$('#nav_tab').tabs('add',{
				title: '查看B卷答案',
				content: content,
				closable: true
			});
		}else{
			window.parent.$('#nav_tab').tabs('add',{
				title: '查看C卷答案',
				content: content,
				closable: true
			});
		}
	}

	function show(obj){
		if(obj.options[obj.selectedIndex].value != "2"){
			$("#facetime").val("0");
			$("#facetime").attr("disabled","disabled").css("background-color","#EEEEEE");
			$("#face_fail").val("0");
			$("#face_fail").attr("disabled","disabled").css("background-color","#EEEEEE");
		}else{
			$("#facetime").removeAttr("disabled").css("background-color","#FFFFFF");
			$("#facetime").val($("#facetime").val());
			$("#face_fail").removeAttr("disabled").css("background-color","#FFFFFF");
			$("#face_fail").val($("#facefail").val());
		}
	}

	function loadRepeatPdfBtn(eid, type, targetId, btnText){
		$.ajax({
			url: "${pageContext.request.contextPath}/paper/checkPaperRepeatPdf",
			type: "POST",
			data: {
				eid: eid,
				type: type
			},
			success: function(data){
				if(data === "success"){
					let html = '<a href="javascript:void(0);" class="easyui-linkbutton" ' +
							'data-options="iconCls:\'icon-save\'" ' +
							'onclick="downloadRepeatPdf(\'' + eid + '\',\'' + type + '\')">' + btnText + '</a>&nbsp;&nbsp;';
					$("#" + targetId).html(html);
					$.parser.parse("#" + targetId);
				}else if(data === "not_found"){
					$("#" + targetId).html("");
				}else if(data === "busy"){
					$("#" + targetId).html('<span style="color:#999;">查重PDF正在生成中</span>&nbsp;&nbsp;');
				}else{
					$("#" + targetId).html('<span style="color:#999;">查重PDF状态获取失败</span>&nbsp;&nbsp;');
				}
			},
			error: function(){
				$("#" + targetId).html('<span style="color:#999;">查重PDF状态获取失败</span>&nbsp;&nbsp;');
			}
		});
	}

	function downloadRepeatPdf(eid, type){
		window.location.href = "${pageContext.request.contextPath}/paper/downloadPaperRepeatPdf?eid="
				+ encodeURIComponent(eid)
				+ "&type="
				+ encodeURIComponent(type);
	}
</script>	

