<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.elegant-aero {
	margin-left: auto;
	margin-right: auto;
	padding: 20px 20px 20px 20px;
	/*font: Arial, Helvetica, sans-serif;*/
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
	/*font: 200 12px/25px Arial, Helvetica, sans-serif;*/
	height: 30px;
	line-height: 20px;
	margin: 2px 6px 14px 0px;	
	border-radius: 4px;
}
select,input,textarea{
	border:1px solid #95B8E7;
}
.elegant-aero textarea {
	padding: 5px 0px 0px 5px;
	width: 60%;	
	border-radius: 4px;
}

#selectObject{
	width:500px;
	height:180px;
	overflow-y:scroll;
	border:1px solid #95B8E7;
	margin-bottom: 5px;
	float:left;
}
#selectBox{
	display:none;
	width:500px;
	float: left;
}
.testObj{
 	height:auto;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/autoTextarea.js"></script>
<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" style="" onclick="window.location.reload();">取消</a> 
 -->
<form id="examInfoForm" class="elegant-aero" method="post" action="">
 	<c:forEach var="ei" items="${examInfo}">
		<input type="hidden" id="exam_bhour" value="${ei.BHOUR}"/>
		<input type="hidden" id="exam_bmin" value="${ei.BMIN}"/>
		<input type="hidden" id="exam_ehour" value="${ei.EHOUR}"/>
		<input type="hidden" id="exam_emin" value="${ei.EMIN}"> 
		<input type="hidden" id="lock_before" value="${ei.LOCK_BEFORE}"/>
		<input type="hidden" id="lock_after" value="${ei.LOCK_AFTER}"/>
		<input type="hidden" id="handIn_limit" value="${ei.HANDINTIMELIMIT}"/>
		<input type="hidden" id="sidVerify" value="${ei.SIDVERIFY}"/>
		<!-- <input type="hidden" id="forbid_isverified" value="${ei.FORBID_ISVERIFIED}"/> -->
		<input type="hidden" id="proportion" value="${ei.PROPORTION}"/>

		<input type="hidden" name="c_id" id="c_id" value="${c_id}"/>
		<input type="hidden" name="c_name" value="${c_name}"/>
		<input type="hidden" id="way" name="way"  value="${way}"/>
		<input type="hidden" name="ObjectList" id="ObjectList" />
		<h1>试卷基本参数设定</h1>
		<label> 
			<span>考试科目 :</span> 
			<div class="spanText">${c_name}</div>			
			<!-- <input type="text" name="cname" value="${c_name}" readonly="readonly"/> -->
		</label> 
		<label>
			<span>试卷名称 :</span>
			<input type="text" name="ename" value="${ename}"/>
		</label>
		<label> 
			<span>课程代码 :</span> 
			<input type="text" name="code" value="${code}"/>
		</label>  		
		<label> 
			<span>学年 :</span> 
			<div>
				<select id="schoolYear" name="schoolYear" style="width:170px">
					<c:forEach var="sy" items="${applicationScope.schoolYear}">
						<c:choose>
							<c:when test="${ei.SCHOOLYEAR == sy.ID}">
								<option value="${sy.ID}" selected="selected">${sy.NAME}</option>
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
							<c:when test="${ei.TERM == t.ID}">
								<option value="${t.ID}" selected="selected">${t.NAME}</option>	
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
				<select id="examType" name="examType"  style="width:170px">		
					<c:forEach var="et" items="${examTypeList}">
						<c:choose>
							<c:when test="${ei.TYPE == et.ETID }">
								<option value="${et.ETID}" selected="selected">${et.ETNAME}</option>
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
							<c:when test="${ei.TESTWAY == ew.ID}">
								<option value="${ew.ID}" selected="selected">${ew.NAME}</option>	
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
				<input type="text" class="easyui-numberspinner"  name="total" style="width:170px;" value="${ei.TOTAL}"/>
				&nbsp;&nbsp;
				<span style="font-weight:bold">印刷份数 :</span> 
				&nbsp;&nbsp;
				<input type="text" class="easyui-numberspinner"  name="pcount" style="width:170px;" value="${ei.PRINTCOUNT}"/>
			</div>
		</label>
		<label> 
			<span>学时数 :</span> 
			<input type="text" id="period" name="period" value="${period}" style="width:170px;"/>
		</label>
		<label> 
			<span>总评占比 :</span> 
			<div class="spanText">本份试卷成绩在课程总评成绩占的比例：<input id="percent" type="text" name="percent" style="margin:0px;border:none"/></div>
		</label>
		<label> 
			<span>考试对象 :</span> 
			<div id="selectOption">
				<input id="testYear" type="text" name="testYear" style="width:180px"/>
				<input id="testSpec" type="text" name="testSpec" style="width:500px"/>
				<a href="javascript:void(0);" class="easyui-linkbutton selectObj" data-options="iconCls:'icon-save'">确定</a>
			</div>
			<div id="selectBox">
				<div id="selectObject"></div>
				<a href="javascript:void(0);" class="easyui-linkbutton reSelectObj" data-options="iconCls:'icon-reload'">重新选择</a>
			</div>
		</label>	
		<input id="bt" type="hidden" name="bt"/>	
		<input id="et" type="hidden" name="et"/>
		
		<label> 
			<span>考试开始时间 :</span> 
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
			<span>考试截止时间 :</span> 
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
			
		<label> 
			<span>考试用时 :</span> 
			<select id="time" name="time" style="margin-top:8px;">
				<c:forEach var="st" items="${applicationScope.systemTime2}" begin="18">
					<c:choose>
					    <c:when test="${st.ID == ei.TIME}">
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
						<c:when test="${ei.SCHECKWAY == qs.ID}">
							<option value="${qs.ID}" selected="selected">${qs.NAME}</option>
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
						<c:when test="${ei.GETANSWER == qp.ID}">
							<option value="${qp.ID}" selected="selected">${qp.NAME}</option>
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
						<c:when test="${tm.ID== ei.TESTTIMESET}">
							<option value="${tm.ID}" selected="selected">${tm.NAME}</option>
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
				<option <c:if test="${ei.RANDOMANSWER == 0}">selected="selected"</c:if> value="0">不随机</option>
				<option <c:if test="${ei.RANDOMANSWER == 1}">selected="selected"</c:if> value="1">随机</option>
			</select>
		</label>
		<c:if test="${editor_switch==1 }">
		<label>
			<span>是否启用编辑器答题 :</span>
			<select id="editorSwitch" name="editorSwitch">
				<option selected="selected" value="0">禁用（主观题只能输入普通文本，不能键入公式、表格、上标下标）</option>
				<option value="1">启用（主观题可插入表格、公式【目前公式输入后只支持删除再输入，不支持重新编辑已输入的公式】、上下标）</option>
			</select>
		</label>
		</c:if>
		<c:if test="${random_switch==1 }">
		<label>
			<span>是否采用千人千题考试模式 :</span>
			<select id="randomSwitch" name="randomSwitch">
				<option selected="selected" value="0">禁用</option>
				<option value="1">启用</option>
			</select>
		</label>
		</c:if>
		<label>
			<span>答题顺序设置 :</span>
			<select id="answerSequence" name="answerSequence">
				<c:forEach var="as" items="${applicationScope.answerSequence}">
					<c:choose>
						<c:when test="${ei.ANSWERSEQUENCE == as.ID}">
							<option value="${as.ID}" selected="selected">${as.NAME}</option>
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
						<c:when test="${ei.CORRECTWAY == cp.ID}">
							<option value="${cp.ID}" selected="selected">${cp.NAME}</option>
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
			<select id="sidVer" onchange="show(this)" class="sidVer" id="sidVer" name="sidVer" style="width:200px;">
				<c:if test="${applicationScope.faceRecognize eq 'on'}">
					<option value="2">考生必须验证人脸才可考试</option>
				</c:if>
				<option value="1" selected="selected">考生必须验证学号方可考试</option>
				<option value="0">考生无须验证学号便可考试</option>
			</select>
				<c:if test="${applicationScope.faceRecognize eq 'on'}">
					&nbsp;&nbsp;
					<span style="font-weight:bold">考试过程中验证人脸次数 :</span>
					&nbsp;&nbsp;
					<input type="number" style="width:50px;height: 30px;" id="facetime" name="facetime" value="${ei.FACETIME}">
					&nbsp;&nbsp;
					<span style="font-weight:bold">验证人脸失败后的处理 :</span>
					&nbsp;&nbsp;
					<input type="hidden" id="facefail" value="${ei.FACEFAIL}">
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
			<input type="text" style="width:90px" class="missionnum"  name="missionnum"/>当个别学生不能正确输入考试任务号或学号，单独告诉学生输入此号
		</label>
		<!--
		<label>
			<span>试题天数筛选 :</span>
			不选用&nbsp;
			<select name="forbidDay" style="width:80px;">
				<c:forEach var="forbidDay" items="${applicationScope.forbidDay}">
					<c:choose>
						<c:when test="${forbidDay.ID==ei.FORBID_BEFORE}">
							<option value="${forbidDay.ID}" selected="selected">${forbidDay.NAME}</option>
						</c:when>
						<c:otherwise>
							<option value="${forbidDay.ID}">${forbidDay.NAME}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select>&nbsp;之内考过的试题
		</label>
		<label>
			<span>试题次数筛选 :</span>
			<div>
				不选用已使用过&nbsp;<input name="forbidNum" type="text" style="width:90px" value="15"/>&nbsp;次及以上的试题
			</div>
		</label>
		<label>
			<span>试题状态筛选 :</span>
			<select id="isVerified" name="isVerified">
				<option value="0">试题不限已审核</option>
				<option value="1">限制为已经通过审核的试题</option>
			</select>
		</label>
		-->
		<label>
			<span>是否允许移动端考试：</span>
			<div class="spanText">
				<input name="mobile" type="radio" value="0" checked/>禁止
				<input name="mobile" type="radio" value="2" />允许
			</div>
			<span>考试切屏次数限制：</span>
			<select id="switchOutLimitSelect" name="switchOutLimitSelect" style="width:200px;">
				<option value="-1">无限制</option>
				<c:forEach var="i" begin="1" end="10">
					<option value="${i}">${i}次退出考试</option>
				</c:forEach>
			</select>
		</label>
		<label>
			<span>组卷负责人 :</span>
			<div class="spanText">${user.realname}</div>
		</label>
		<label>
			<span>联系电话 :</span>
			<input id="tel" type="text" name="tel" value="${user.tel}" class="easyui-validatebox"/>
		</label>
		<label>
			<span>考试地点 :</span>
			<input id="venues" type="text" name="venues" value="${ei.VENUES}"/>
		</label>
		<label>
			<span>考试须知 :</span>
			<textarea rows="7" cols="70" name="remark2s">${ei.REMARK2S}</textarea>
		</label>
		<label>
			<span>英文考试须知 :</span>
			<textarea rows="7" cols="70" name="e_remark2s">${ei.E_REMARK2S}</textarea>
		</label>
		<label>
			<span>备注说明 :</span>
			<textarea rows="7" cols="70" name="remark2t">${ei.REMARK2T}</textarea>
		</label>
		<c:if test="${union_switch == 1}">
		<label>
			<span>是否联考卷：</span>
			<div class="spanText">
				<input name="isUnion" type="radio" value="0" checked/>非联考卷
				<input name="isUnion" type="radio" value="1" />联考卷
			</div>
		</label>
		</c:if>
	</c:forEach>
</form>

<div style="clear:both;"></div>
<div style="height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addExamInfo()">保存</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="history.back();">返回</a>
</div>
<script type="text/javascript">
toastr.options = {
    showDuration: "550"
}
var cid = $("#c_id").val();
$(document).ready(function(){
	$.each($("textarea"), function(i, n){
        autoTextarea($(n)[0],10);
    });
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

	$('#bhour').val($('#exam_bhour').val());
	$('#bmin').val($('#exam_bmin').val());

	$('#ehour').val($('#exam_ehour').val());
	$('#emin').val($('#exam_emin').val());

	$('#sidVer').val($('#sidVerify').val());

	//$('#isVerified').val($('#forbid_isverified').val());

    $('#loginBefore').val($('#lock_before').val());
    $('#loginAfter').val($('#lock_after').val());

	$("#handInTimeLimit").val('-1');
	if($("#handIn_limit").val()!=null&&$("#handIn_limit").val()!=''&&$("#handIn_limit").val()!='null'){
		$("#handInTimeLimit").val($("#handIn_limit").val());
	}else{
		$("#handInTimeLimit").val('-1');
	}

/* 	defaultTerm();
	defaultSchoolYear(); */
/* 	$('#bt').datetimebox({
	    //value: '3/4/2010 2:3',
	    editable: false,
	    showSeconds: false
	});
	$('#et').datetimebox({
	    //value: '3/4/2010 2:3',
	    editable: false,
	    showSeconds: false
	}); */

	$('#bdate').datebox({
	    editable: false,
	    value : new Date().format('yyyy-MM-dd')
	});
	$('#edate').datebox({
	    editable: false,
	    value : new Date().format('yyyy-MM-dd')
	});

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
			{ c_id: cid },
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

	$('#percent').numberspinner({
	    min: 0,
	    max: 100,
	    width: 88
	});

	$('#percent').numberspinner('setValue', $('#proportion').val());
	$('.missionnum').val(RandomNum());
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


function addExamInfo(){

/* 	var bt = $('#bt').datetimebox('getValue');
	var et = $('#et').datetimebox('getValue'); */
	var bdate = $('#bdate').datebox('getValue');
	var edate = $('#edate').datebox('getValue');
/* 	var btime = $('#btime').timespinner('getValue');
	var etime = $('#etime').timespinner('getValue'); */

	var btime = $("#bhour").val() + ":" + $("#bmin").val();
	var etime = $("#ehour").val() + ":" + $("#emin").val();

	$("#bt").val(bdate + " " + btime);
	$("#et").val(edate + " " + etime);

	var testYear = $('#testYear').combogrid('grid').datagrid('getSelections');
	var testSpec = $('#testSpec').combogrid('grid').datagrid('getSelections');
	var tel = $('#tel').val();

	if(testYear == '' || testYear == null){
		toastr.warning('考试年级不能为空');
		return;
	}
	if(testSpec == '' || testSpec == null){
		toastr.warning('考试专业不能为空');
		return;
	}
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
	if(!btime|| btime==null){
		toastr.warning('考试开始时间不能为空');
		return;
	}
	if(!etime|| etime==null){
		toastr.warning('考试截止时间不能为空');
		return;
	}

	if(edate < bdate){
		toastr.warning('考试截止日期不能早于考试开始日期');
		return;
	}

	var time1 = btime.split(":");
	var time2 = etime.split(":");

	if(time2[0] < time1[0]){
		toastr.warning('考试截止时间不能早于考试开始时间');
		return;
	}
	if(time1[0] == time2[0]){
		if(time1[1] >= time2[1]){
			toastr.warning('考试截止时间不能早于或等于考试开始时间');
			return;
		}
	}

	//if(!(/^0\d{2,3}-?\d{7,8}$/.test(tel)) && !(/^1[34578]\d{9}$/.test(tel))){
	if(/[^\d]/.test(tel)){
		toastr.warning('请填写正确的电话号码');
		$("#tel").focus();
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
	var long1=(parseInt(time2[0])-parseInt(time1[0]))*60*60+(parseInt(time2[1])-parseInt(time1[1]))*60;
	var next=false;

	let $p = $("#period");
	let v = $p.val().replace(/\s+/g, ""); // 去掉所有空白(含首尾/中间/换行/tab)
	$p.val(v); // 回写输入框
	if (v !== "" && !/^(?:[1-9]\d*(?:\.\d+)?|0\.\d+)$/.test(v)) {
		toastr.warning('学时数必须为正数！');
		return;
	}
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

	var way = $("#way").val();
	ajaxLoading();

	if(way==0 || way==1 || way==4){  //普通-结构化组卷
		$('#examInfoForm').attr("action","${pageContext.request.contextPath}/paper/addExamInfo");
	}else if(way==2){ //合并组卷
		$('#examInfoForm').attr("action","${pageContext.request.contextPath}/paper/addExamInfo4CombinePaper");
	}else if(way==3){  //多课程组卷
		$('#examInfoForm').attr("action","${pageContext.request.contextPath}/paper/addExamInfo4MultiCourse");
	}
	$('#examInfoForm').submit();
}

function ajaxLoading() {
	 var id = "#examInfoForm";
	 var left = ($(window).outerWidth(true) - 190) / 2;
	 var top = ($(window).height() - 200);
	 var height = $(window).height() * 2;
	 $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo(id);
	 $("<div class=\"datagrid-mask-msg\"></div>").html("正在加载,请稍候...").appendTo(id).css({ display: "block", left: left, top: top });
}
function ajaxLoadEnd() {
	 $(".datagrid-mask").remove();
	 $(".datagrid-mask-msg").remove();
}

function getMonth(){
	var myDate = new Date();
	var month = myDate.getMonth();
	if(month>=8){
		return 1;//下半年
	}else{
		return 0;//上半年
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

function RandomNum(){
	var num = '';
	for(var i=0;i<5;i++){
		var n = Math.floor(Math.random()*10);
		if(n == 0 && i == 0){
			n++;
		}
		num+=n;
	}
	return num;
}

</script>	

