<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
	line-height: 1.2;
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
	border:1px solid #ddd;
	height:108px;
	width:220px;
	border-radius: 4px;
	padding:2px 4px;
	-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
	box-shadow: inset 0px 1px 6px #ECF3F5;
	overflow-y: scroll;
}
.hiddenVal{
	display:none;
}
</style>
<div style="float: center">
	<form id="editCourseForm" method="post">
		<input type="hidden" name="c_id" id="c_id" value="${c_id}"/>
		<input type="hidden" name="name_c" id="name_c" value="${course.name_c}"/>
		<table class="courseTable">
			<tr>
				<td align='left' style="padding-left:30px;">课程中文名：${course.name_c}</td>
			    <td align='left'>课程英文名：${course.name_e}</td>
				<td align='left'>课程简称：${course.shortname}</td>
			</tr>
			<tr>
				<td align='left' style="padding-left:30px;">课程代码：${course.code}</td>
			    <td align='left'>授课单位：${course.unitname}</td>
				<td align='left'>所属科室：${course.deptname}</td>
			</tr>
			<tr>
				<td align='left' style="padding-left:30px;">联系人：${course.contact}</td>
			    <td align='left'>联系电话：${course.tel}</td>
				<td align='left'>最大学时数：${course.period}</td>
			</tr>
		</table>
		<table class="courseTable">
			<tr>
				<td align='right' style="width:100px;">
					<label>适应层次：</label>
				</td>
				<td align='left'>
					<div class="checkblock">
						<c:forEach var="arrangement" items="${course.arrangementList}">
							<label>${arrangement.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>包含题型：</label>
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="explainQuestionType()">题型说明</a></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="QTList">
						<c:forEach var="questionType" items="${course.questionTypeList}">							
							<label><span>${questionType.NAME}</span></label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>考试类别：</label>
				</td>
				<td align='left'>
					<div class="checkblock" id="examTypeList">
						<c:forEach var="examType" items="${course.examTypeList}">
							<label><span>${examType.NAME}</span></label></br>				
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>适用专业：</label>
				</td>
				<td align='left'>
					<div class="checkblock">
						<c:forEach var="specialty" items="${course.specialtyList}">
							<c:if test="${specialty.NAME ne 'null'}">
								<label><span>${specialty.NAME}</span></label></br>
							</c:if>
						</c:forEach>
					</div>
				</td> 
			</tr>
			<tr>
				<td align='right' style="width:100px;">
					<label>难度：</label>
				</td>
				<td align='left'>
					<div class="checkblock" id="difficultyList">
						<c:forEach var="difficulty" items="${course.difficultyList}">
							<label><span>${difficulty.NAME}</span></label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>知识点分布：</label>
				</td>
				<td align='left'>
					<div class="checkblock" id="knowledgeList">
						<c:forEach var="knowledge" items="${course.knowledgeList}">							
							<label><span>${knowledge.NAME}</span></label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>认知类别：</label>
				</td>
				<td align='left'>
					<div class="checkblock" id="cognitionList">
						<c:forEach var="cognition" items="${course.cognitionList}">
							<label><span>${cognition.NAME}</span></label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label>题源：</label><
				</td>
				<td align='left'>
					<div class="checkblock" id="sourceList">
						<c:forEach var="source" items="${course.sourceList}">
							<label><span>${source.NAME}</span></label></br>
						</c:forEach>
					</div>
				</td> 
			</tr>
		</table>
		<table class="courseTable" style="margin-bottom:30px;">
			<tr>
				<td align='center'>一级主题词</td>
				<td align='center'>二级主题词</td>
				<td align='center'>三级主题词</td>
			</tr>
			<tr>
				<td align='center'>
					<select id="theme1List" size="7" style='width:280px; height:234px; overflow-y: scroll;'  class="easyui-validatebox themeList" data-options="required:true">
						<c:forEach var="theme" items="${course.themeList}">
							<option value="${theme.ID}">${theme.NAME}</option>
						</c:forEach>
					</select>
				</td>
				<td align='center'>
					<select id="theme2List" size="7" style='width:280px; height:234px; overflow-y: scroll;' class="easyui-validatebox themeList"  >
					</select>
				</td>
				<td align='center'>
					<select id="theme3List" size="7" style='width:280px; height:234px; overflow-y: scroll;' class="easyui-validatebox themeList" >
					</select>
				</td>
			</tr>			
		</table>
	</form>
</div>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="cancel()" >关闭</a>
</div>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var c_id = $("#c_id").val();

function back() {
	var parent = $("#ifmdlg");
	$(parent).dialog('close');
}


$('#theme1List').change(function(){
	$('#theme3List').empty();
	getThemeList(2, $(this).val());
	theme2val = $("#theme2List").find("option:first").val();
	if(!theme2val!=null&&theme2val!=undefined){
		getThemeList(3, theme2val);
	}
});

$('#theme2List').change(function(){
	getThemeList(3, $(this).val());
});


function getThemeList(th_level, th_pid){
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getThemeList",
        async: false, 
        type: "POST",
        data: {"th_level": th_level, "th_pid": th_pid, "c_id": c_id}, 
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

//题型说明
function explainQuestionType(){
	var checkID = '';
	$("input[name='questionType']:checked").each(function(i){
		if(checkID==''){
			checkID = $(this).val();
		}else{
			checkID += ',' + $(this).val();
		}
	})
	window.location.href='${pageContext.request.contextPath}/course/explainQuestionType';
}

function cancel(){
	//parent.location.reload();
	var ifmdlg = window.parent.document.getElementById("ifmdlg");
	$(ifmdlg).parent().next().next().remove();
	$(ifmdlg).parent().next().remove();
	$(ifmdlg).parent().remove();
}
</script>