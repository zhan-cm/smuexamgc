<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
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
.elegant-aero textarea {
	padding: 5px 0px 0px 5px;
	width: 60%;	
	border-radius: 4px;
}
</style>
<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" style="" onclick="window.location.reload();">取消</a> 
 --><form id="examInfoForm" class="elegant-aero" method="post">
 		<input type="hidden" name="monitor" id="monitor" value="${monitor}"/> <!-- 此参数用于判断是否从考试监考进入修改考务信息 -->
		<input type="hidden" name="c_id" id="c_id" value="${examInfo.CID}"/>
		<input type="hidden" name="ei_id" id="ei_id" value="${examInfo.ID}"/>
		<input type="hidden" name="url" id="url" value="${url}"/>
		<input type="hidden" name="state" id="state" value="${examInfo.STATE}"/>
		<h1>监考管理、编辑考务信息</h1>
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
			<span>初次登录密码 :</span> 
			<div>
				<input type="text" name="firstpsw" value="${examInfo.FIRSTPSW}" style="width:170px;"/>
				&nbsp;&nbsp;
				<span style="font-weight:bold">二次登录密码 :</span> 
				&nbsp;&nbsp;
				<input type="text" name="secondpsw" value="${examInfo.SECONDPSW}" style="width:170px;"/>
			</div>
		</label>	
		<label> 
			<span>学时数 :</span> 
			<input type="text" id="period" name="period" value="${examInfo.PERIOD}" readonly="readonly" style="width:170px;"/>
		</label>
		<label> 
			<span>总评占比 :</span> 
			<div class="spanText">
			本份试卷成绩在课程总评成绩占的比例：<input class="easyui-numberspinner" name="percent" style="width:88px;" value="${examInfo.PROPORTION}" data-options="min:0,max:100"/>
			</div>
		</label>
		<label> 
			<span>考试对象 :</span> 
			<div id="selectOption">
				<input id="testYear" type="text" name="testYear" style="width:180px"/>
				<input id="testSpec" type="text" name="testSpec" style="width:500px"/>
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
			<span>考试开始日期：</span>
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
			<span>考试截止日期：</span>
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
			<select id="time" name="time" style="margin-top:8px;">
				<c:forEach var="st" items="${applicationScope.systemTime2}">
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
			<c:choose>
				<c:when test="${examInfo.STATE==3}">
					<c:choose>
						<c:when test="${examInfo.RANDOM == 0}">
							<div class="spanText">禁用</div>
						</c:when>
						<c:otherwise>
							<div class="spanText">启用</div>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<select id="randomSwitch" name="randomSwitch">
						<option <c:if test="${examInfo.RANDOMSWITCH == 0}">selected="selected"</c:if> value="0">禁用</option>
						<option <c:if test="${examInfo.RANDOMSWITCH == 1}">selected="selected"</c:if> value="1">启用</option>
					</select>
				</c:otherwise>
			</c:choose>			
		</label> 
		</c:if>	
		<label> 
			<span>答题顺序设置 :</span> 					
			<select id="answerSequence" name="answerSequence">
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
				<select id="sidVer" class="sidVer" name="sidVer" style="width:200px;">
					<c:choose>
						<c:when test="${examInfo.SIDVERIFY eq 0}">
							<option value="1">考生必须验证学号方可考试</option>
							<option selected="selected" value="0">考生无须验证学号便可考试</option>
						</c:when>
						<c:when test="${examInfo.SIDVERIFY eq 1}">
							<option selected="selected" value="1">考生必须验证学号方可考试</option>
							<option value="0">考生无须验证学号便可考试</option>
						</c:when>
						<c:otherwise>

						</c:otherwise>
					</c:choose>
				</select>
			</div>
		</label>
		<label>
			<span>通用号 :</span> 	
			<input type="text" class="missionnum"  name="missionnum" style="width:90px;" value="${examInfo.MISSIONNUM}"/>
			当个别学生不能正确输入考试任务号或学号，单独告诉学生输入此号	
		</label> 
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
			<span>考试安全设置 :</span> 
			<select class="sidVer" name="security" multiple="multiple" style="height: 160px">
				<option <c:if test="${fn:contains(examInfo.ADDR,'-1')==true}">selected="selected"</c:if> value="-1">所有计算机均可登录考试</option>
				<option <c:if test="${fn:contains(examInfo.ADDR,'0')==true}">selected="selected"</c:if> value="0">限定所有考试机房内计算机才能登录考试</option>
				<c:set value="${ fn:split(examInfo.ADDR, ',') }" var="eaddrs" />
				<c:set value="0" var="flag"></c:set>
				<c:forEach var="addr" items="${applicationScope.addr4exam }">
					<c:forEach var="eaddr" items="${eaddrs }">
						<c:if test="${addr.ID == eaddr}"><c:set value="1" var="flag"></c:set></c:if>
					</c:forEach>
					<option <c:if test="${flag == 1}">selected="selected"</c:if> value="${addr.ID }">${addr.NAME }内计算机可登录考试</option>	
					<c:set value="0" var="flag"></c:set>
				</c:forEach>
			</select>
		</label>	  
		<label> 
			<span>监考老师 :</span> 
			<div>
				<input id="invigilator" type="text" name="invigilator" value="${examInfo.INVIGILATORIDS}" style="width:170px"/>
				&nbsp;&nbsp;
				<span>巡考老师 :</span> 
				&nbsp;&nbsp;
				<input id="patrol" type="text" name="patrol" value="${examInfo.PATROLIDS}" style="width:170px"/>
				&nbsp;&nbsp;
				<span>任课老师 :</span> 
				&nbsp;&nbsp;
				<input id="courseTeacher" type="text" name="courseTeacher" value="${examInfo.COURSETEACHER}" style="width:170px"/>
			</div>
		</label>
		<label> 
			<span>组卷负责人 :</span> 
			<div class="spanText">${examInfo.TEACHERNAME}</div>
		</label>
		<label> 
			<span>联系电话 :</span> 
			<input id="tel" type="text" name="tel"  value="${examInfo.TEL}" class="easyui-validatebox"/>
		</label>
		<label> 
			<span>考试地点 :</span> 
			<input id="venues" type="text" class="easyui-validatebox" name="venues" value="${examInfo.VENUES}"/>
		</label>
		<label> 
			<span>考试须知 :</span> 
			<textarea cols="70" name="remark2s">${examInfo.REMARK2S}</textarea>	
		</label>
		<label> 
			<span>英文考试须知 :</span> 
			<textarea cols="70" name="e_remark2s">${examInfo.E_REMARK2S}</textarea>	
		</label>
		<label> 
			<span>备注说明 :</span> 
			<textarea cols="70" name="remark2t">${examInfo.REMARK2T}</textarea>
		</label>
		<!-- 
		<label> 
			<span>是否联考卷：</span> 
			<div class="spanText">
				<c:choose>
					<c:when test="${examInfo.ISUNION==0 }">
						<input name="isUnion" type="radio" value="0" checked/>非联考卷
						<input name="isUnion" type="radio" value="1" />联考卷
						<input name="isUnion" type="radio" value="2" />联考测试卷
					</c:when>
					<c:when test="${examInfo.ISUNION==1 or examInfo.ISUNION==2}">
						<input name="isUnion" type="radio" value="0" />非联考卷
						<input name="isUnion" type="radio" value="1" checked/>联考卷
						<input name="isUnion" type="radio" value="2" />联考测试卷
					</c:when>
					<c:when test="${examInfo.ISUNION==3 }">
						<input name="isUnion" type="radio" value="0" />非联考卷
						<input name="isUnion" type="radio" value="1" />联考卷
						<input name="isUnion" type="radio" value="2" checked/>联考测试卷
					</c:when>
				</c:choose>
			</div>
		</label> -->
		<label> 
			<span>试卷生成时间 :</span> 
			<div class="spanText">${examInfo.CREATETIME}</div>
		</label> 
		<c:if test="${not empty examInfo.FIRSTVERIFYOPINION}">
			<label> 
			<span>初级审核意见 :</span> 
				<div class="spanText">${examInfo.FIRSTVERIFYOPINION}</div><!-- <textarea rows="7" cols="70" name="remark2t" disabled="disabled">${examInfo.FIRSTVERIFYOPINION}</textarea> -->
			</label>	
		</c:if>	
		<c:if test="${not empty examInfo.LASTVERIFYOPINION}">
			<label> 
			<span>终极审核意见 :</span> 
				<div class="spanText">${examInfo.LASTVERIFYOPINION}</div><!-- <textarea rows="7" cols="70" name="remark2t" disabled="disabled">${examInfo.LASTVERIFYOPINION}</textarea> -->
			</label>	
		</c:if>
</form>
<div style="clear:both"></div>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="updateExamInfo()">保存</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)" >关闭当前页</a>
</div>
<div id="selectObjectWin"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/autoTextarea.js"></script>
<script type="text/javascript">
toastr.options = {
	showDuration: "550"
}
var ei_id = $('#ei_id').val();
var beforeFaceTime = $("#facetime").val();
$(document).ready(function(){	
	$.each($("textarea"), function(i, n){
        autoTextarea($(n)[0],10);
    }); 
	if($("#lockBefore").val()!=null&&$("#lockBefore").val()!=''){
		$("#loginBefore").val($("#lockBefore").val());
	}else{
		$("#loginBefore").val('0');
	}
	
	if($("#loginAfter").val()!=null&&$("#loginAfter").val()!=''){
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
			{field:'NAME',title:'年级',width:150,sortable:true}
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
	
	/* $('#invigilator').combogrid({
	    url: '${pageContext.request.contextPath}/paper/getTeacherList',
	    idField: 'ID',
	    textField: 'NAME',
	    multiple: true,
	    editable: false,
	    columns: [[
			{field:'ID',checkbox:true},
			{field:'NAME',title:'教师',width:150,sortable:true}
	    ]],
	    onLoadSuccess: function(){
	    	var val = $('#invigilator').val().split(',');
	    	for(var i=0; i<val.length; i++){
		    	$('#invigilator').combogrid('grid').datagrid('selectRecord',val[i]);
	    	}
    	}
	    
	}); */
	
	/* $('#patrol').combogrid({
	    url: '${pageContext.request.contextPath}/paper/getTeacherList',
	    idField: 'ID',
	    textField: 'NAME',
	    multiple: true,
	    editable: false,
	    columns: [[
			{field:'ID',checkbox:true},
			{field:'NAME',title:'教师',width:150,sortable:true}
	    ]],
	    onLoadSuccess: function(){
	    	var val = $('#patrol').val().split(',');
	    	for(var i=0; i<val.length; i++){
		    	$('#patrol').combogrid('grid').datagrid('selectRecord',val[i]);
	    	}
    	}
	}); */
	
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

$('.reSelectObj').click(function(){
	$('#selectOption').slideDown();
	$('#selectBox').slideUp();
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
	var invigilator = $('#invigilator').val();
	if(invigilator === null || typeof(invigilator) == "undefined" ||invigilator.trim() === ''){
		toastr.warning("请输入监考老师！");
		$('#invigilator').focus();
		return;
	}

	var bdate = $('#bdate').datebox('getValue');
   	var edate = $('#edate').datebox('getValue');
   	
   	var btime = $("#bhour").val() + ":" + $("#bmin").val();
   	var etime = $("#ehour").val() + ":" + $("#emin").val();
   	
   	$("#bt").val(bdate + " " + btime);
   	$("#et").val(edate + " " + etime);
   	
   	var time1 = btime.split(":");
   	var time2 = etime.split(":");
   	
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
   	var mobile=$("input[name='mobile']:checked").val(); 
	if(mobile==2){
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
	
	let pattern = /^(0|[1-9][0-9]*)$/;
	if($("#facetime").val()==null || $("#facetime").val().trim()=="" || !pattern.test($("#facetime").val())){
		$("#facetime").val("0");
	}
	
	$.ajax({
		url : "${pageContext.request.contextPath}/paper/updateExamInfo",
		async : false,
		type : "POST",
		data: $('#examInfoForm').serialize(),
		success: function(data){
			if(data=="success"){
				toastr.success('操作成功');
			}else{
				toastr.error('操作失败');
			}
		}
	})
}
</script>	

