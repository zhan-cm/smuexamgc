<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">	
<style>
.elegant-aero {
	margin-left: auto;
	margin-right: auto;
	padding: 20px 20px 20px 20px;
	font: 12px Arial, Helvetica, sans-serif;
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
.elegant-aero h1>span {
	display: block;
	font-size: 11px;
}
.elegant-aero label>span {
	float: left;
	margin-top: 10px;
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
	color: #888;
	width: 60%;
	padding: 0px 0px 0px 5px;
	border: 1px solid #C5E2FF;
	background: #FFFFFF;
	outline: 0;
	-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	font: 200 12px/25px Arial, Helvetica, sans-serif;
	height: 30px;
	line-height: 15px;
	margin: 2px 6px 14px 0px;	
	border-radius: 4px;
}
.elegant-aero .combo-text{
	border: none !important;
	margin: 0px !important;
}
.elegant-aero .combo{
	padding-right: 0 !important;
}
.elegant-aero .combo-text span{
	padding-right: 0 !important;
}
.elegant-aero textarea {
	height: 120px;
	padding: 5px 0px 0px 5px;
	width: 60%;	
	border-radius: 4px;
}
.elegant-aero select {
	/* appearance: none;
	-webkit-appearance: none;
	-moz-appearance: none; */
	text-indent: 0.01px;
	text-overflow: '';
	width: 60%;
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
.elegant-aero .roleBlock{
	float:left;
	margin-bottom: 16px;
}
.elegant-aero .roleBlockClear{
	clear:both;
}
.checkblock{
	border:1px solid #CCC;
	height:154px;
	width:220px;
	overflow-y: scroll;
}
#sObjectList, #cObjectList{
	height:174px;
	width:476px; 
	border:1px solid rgb(169, 169, 169);
	background-color: #fff;
	overflow-y:scroll;
}
#specialty, #class{
	width:500px; 
	padding:10px;
	background:#fafafa;
}
.cselect{
	width:136px;
	margin-bottom:15px;
}
.selectTips{
	color:#777;
}
select{
	line-height: 22px;
	height: 22px;
	border-color: #95B8E7;
}
input[type="text"]{
	line-height: 22px;
	height: 22px;
	border-color: #95B8E7;
	border:1px solid #95B8E7;
}
textarea{
	border:1px solid #95B8E7;
}
#selectObject{
	width:198px;
	height:180px;
	overflow-y:scroll;
	border:1px solid #95B8E7;
	margin-bottom: 5px;
	float:left;
}
#selectBox{
	display:none;
	width:198px;
	float: left;
}
.testObj{
 	height:auto;
 	display:block;
 	font-size:14px;
}
.examth{
	height: 32px;
	font-size: 14px;
}
.elegant-aero .missionnum[disabled="disabled"]{
	background: #ddd;
	border: 1px solid #aaa;
}
</style>
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
		<input type="hidden" id="forbid_isverified" value="${ei.FORBID_ISVERIFIED}"/>
		<input type="hidden" id="proportion" value="${ei.PROPORTION}"/>
		<input type="hidden" id="update" value="${update}"/>
	
		<h1>考务信息默认参数设置</h1>	
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
					<c:forEach var="et" items="${applicationScope.examTypeList}">
						<c:choose>
							<c:when test="${ei.TYPE == et.ID}">
								<option value="${et.ID}" selected="selected">${et.NAME}</option>
							</c:when>
							<c:otherwise>
								<option value="${et.ID}">${et.NAME}</option>
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
				<input type="text" name="total" style="width:170px;" value="${ei.TOTAL}"/>
				&nbsp;&nbsp;
				<span style="font-weight:bold">印刷份数 :</span> 
				&nbsp;&nbsp;
				<input type="text" name="pcount" style="width:170px;" value="${ei.PRINTCOUNT}"/>
			</div>
		</label>
		<%-- <label> 
			<span>学时数 :</span> 
			<input type="text" name="period" value="${ei.PERIOD}" style="width:170px;" />
		</label> --%>
		<label> 
			<span>总评占比 :</span> 
			<div class="spanText">本份试卷成绩在课程总评成绩占的比例：<input id="percent" type="text" name="percent" style="margin:0px;border:none"/></div>
		</label>
		<label>
			<span>考试开始时间 :</span> 
			<div>
				&nbsp;&nbsp;
				<select id="bhour" name="bhour" style="width:80px;">
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
				<select id="bmin" name="bmin" style="width:80px;">
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
				&nbsp;&nbsp;
				<!-- <input id="etime" type="text" style="width:180px"/> -->
				<select id="ehour" name="ehour" style="width:80px;">
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
				<select id="emin" name="emin" style="width:80px;">
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
						    <option selected="selected" value="${st.ID}">${st.NAME}</option>
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
			<select class="sidVer" id="sidVer" name="sidVer">
				<option value="0">考生无须验证学号便可考试</option>
				<option value="1">考生必须验证学号方可考试</option>
			</select>
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
	</c:forEach>	
</form>


<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addExamInfo()">保存</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="history.back();">返回</a> 
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var cid = $("#c_id").val();
$(document).ready(function(){
	
	var mes = $("#update").val();
	if(mes != ""){
		toastr.success('修改考务信息模板成功！');
	}
	
	$('#percent').numberspinner({
	    min: 0,
	    max: 100,
	    width: 88
	});
	
	$('#percent').numberspinner('setValue', $('#proportion').val());
	
	$('#bhour').val($('#exam_bhour').val());
	$('#bmin').val($('#exam_bmin').val());
	
	$('#ehour').val($('#exam_ehour').val());
	$('#emin').val($('#exam_emin').val());
	
	$('#loginBefore').val($('#lock_before').val());
	$('#loginAfter').val($('#lock_after').val());
	
	$('#handInTimeLimit').val($('#handIn_limit').val());
	
	$('#sidVer').val($('#sidVerify').val());
	
	$('#isVerified').val($('#forbid_isverified').val());
	
});

$('.reSelectObj').click(function(){
	$('#selectOption').slideDown();
	$('#selectBox').slideUp();
	$('#selectObject').html(null);
});

function addExamInfo(){	

	var bhour = $("#bhour").val();
	var bmin =  $("#bmin").val();
	var ehour = $("#ehour").val();
	var emin = $("#emin").val();
	
/* 	var testYear = $('#testYear').combogrid('grid').datagrid('getSelections');
	var testSpec = $('#testSpec').combogrid('grid').datagrid('getSelections'); */
	
	if(!bhour || bhour==null||!bmin || bmin==null){
		toastr.warning('考试开始时间不能为空');
		return;
	}
	if(!ehour|| ehour==null||!emin || emin==null){
		toastr.warning('考试截止时间不能为空');
		return;
	} 
	
	if(bhour > ehour){
		toastr.warning('考试截止时间不能早于考试开始时间');
		return;
	}
	if(bhour == ehour){
		if(bmin >= emin){
			toastr.warning('考试截止时间不能早于或等于考试开始时间');
			return;
		}
	}
	
	var way = $("#way").val();
	ajaxLoading();
	
	$('#examInfoForm').attr("action","${pageContext.request.contextPath}/system/updateDefaultExamInfo");
	
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

</script>	

