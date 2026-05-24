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
	border-bottom: 1px solid #ddd; 
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
.theme_table{
	text-align:center;
}
.theme_table input[name="theme"]{
	width:400px;
}
</style>
	<form id="courseForm" method="post">
		<input type="hidden" name="c_id" id="c_id" value="${c_id}"/>
		<input type="hidden" name="sxb_switch" id="sxb_switch" value="${sxb_switch}"/>
		<table class="courseTable">
			<tr>
				<td align='right' style="width:185px;">* 课程中文名：</td>
				<td align='left'><input type="text" name="name_c" class="easyui-validatebox" data-options="required:true"/></td> 
			    <td align='right'>课程英文名：</td>
			    <td align='left'><input type="text" name="name_e"/></td>
				<td align='right'>课程简称：</td>
			    <td align='left'><input type="text" name="shortname"/></td>
			</tr>
			<tr>
				<td align='right' style="width:185px;">课程代码：</td>
				<td align='left'><input type="text" name="code"/></td> 
			    <td align='right'>授课单位：</td>
			    <td align='left'>
				    <shiro:hasAnyRoles name="administrator, dean">
					    <select id="unit" name="unitId" style="padding:5px 0;">
					    	<c:forEach var="unit" items="${unitList}">
					    		<c:choose>
								    <c:when test="${unit.ID == unitid}">
								    	<option value="${unit.ID}" selected="selected">${unit.NAME}</option>					   
								    </c:when>
								    <c:otherwise>
								    	<option value="${unit.ID}" >${unit.NAME}</option>
								    </c:otherwise>
							    </c:choose>
					    	</c:forEach>  
					    </select>
				    </shiro:hasAnyRoles>
				    <shiro:hasAnyRoles name="teacher, secretary, director,teachingoffice">
				    	${sessionScope.userInfo.unit}
				    	<input id="unit" type="hidden" name="unitId" value="${sessionScope.userInfo.unitID}"/>
				    </shiro:hasAnyRoles>
			    </td>
				<td align='right'>所属科室：</td>
			    <td align='left'>
				    <shiro:hasAnyRoles name="administrator, dean, teachingoffice">
					    <select id="dept" name="deptId" style="padding:5px 0;">
				    	
				    	</select>
				    	<input type="hidden" id="deptId" value="${course.deptid}"/>
				    </shiro:hasAnyRoles>
				    <shiro:hasAnyRoles name="teacher, secretary, director">
				    	${sessionScope.userInfo.dep}
				    	<input type="hidden" name="deptId" value="${sessionScope.userInfo.depID}"/>
				    </shiro:hasAnyRoles>
			    </td>
			</tr>
			<tr>
				<td align='right' style="width:185px;">联系人：</td>
				<td align='left'><input type="text" name="contact" value="${contact}"/></td> 
			    <td align='right'>联系电话：</td>
			    <td align='left'><input type="text"  class="easyui-validatebox" name="tel" value="${tel}"/></td>
				<td align='right'>最大学时数：</td>
			    <td align='left'><input type="text" name="period"  class="easyui-validatebox" /></td>
			</tr>
			<tr>
				<td align="right">是否开放：</td>
				<td align="left"><input type="radio" name="open" value="1"/>开放给该课程适用专业考生自由练习</td>
				<td align="left"><input type="radio" name="open" value="0" checked="checked"/>不开放给考生自由练习</td>
				<td colspan="3"></td>
			</tr>
		</table>
		<table class="courseTable">
			<tr>
				<td align='right' style="width:100px;">
					<label><input type="checkbox" id="selectArrangement" class="checkAll"/>&nbsp;* 适应层次：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addArrangement()"></a></br></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="arrangementList">
						<c:forEach var="arrangement" items="${arrangementList}">
							<c:choose>
								<c:when test="${arrangement.ID==4}">
									<label><input type="checkbox" name="arrangement" value="${arrangement.ID}" checked="checked" onclick="return false"/>${arrangement.NAME}</label></br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="arrangement" value="${arrangement.ID}"/>${arrangement.NAME}</label></br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;*包含题型：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addQuestionType()"></a></br></br>
					<button type="button" onclick="explainQuestionType()">题型说明</button></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="QTList">
						<c:forEach var="questionType" items="${questionTypeList}">
							<label><input type="checkbox" name="questionType" value="${questionType.ID}"  checked="checked"/>
							${questionType.NAME}				
							</label><br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;考试类别：<label></br></br>
					<!-- <a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addExamType()"></a></br></br> -->
				</td>
				<td align='left'>
					<div class="checkblock" id="examTypeList">
						<c:forEach var="examType" items="${examTypeList}">
							<label><input type="checkbox" name="examType" value="${examType.ID}"  checked="checked"/>${examType.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;* 适用专业：<label>
				</td>
				<td align='left'>
					<div class="checkblock">
						<c:forEach var="specialty" items="${specialtyList}">
							<label><input type="checkbox" name="specialty" value="${specialty.ID}" checked="checked"/><span>${specialty.NAME}</span>
								<span style="font-size: 11px;color: red;">（${specialty.UNAME}）</span></label></br>
						</c:forEach>
					</div>
				</td> 
			</tr>
			<tr>
				<td align='right' style="width:100px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;* 难度：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addDifficulty()"></a></br></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="difficultyList">
						<c:forEach var="difficulty" items="${difficultyList}">
							<label><input type="checkbox" name="difficulty" value="${difficulty.ID}"  checked="checked"/>${difficulty.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;* 知识点类别：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addKnowledge()"></a></br></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="knowledgeList">
						<c:forEach var="knowledge" items="${knowledgeList}">
							<label><input type="checkbox" name="knowledge" value="${knowledge.ID}"  checked="checked"/>${knowledge.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;* 认知类别：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addCognition()"></a></br></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="cognitionList">
						<c:forEach var="cognition" items="${cognitionList}">
							<label><input type="checkbox" name="cognition" value="${cognition.ID}"  checked="checked"/>${cognition.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
				<td align='right' style="width:120px;">
					<label><input type="checkbox" class="checkAll" checked="checked"/>&nbsp;* 题源：</label></br></br>
					<a class="easyui-linkbutton" href="javascript:void(0);" data-options="iconCls:'icon-add'" onclick="addSource()"></a></br></br>
				</td>
				<td align='left'>
					<div class="checkblock" id="sourceList">
						<c:forEach var="source" items="${sourceList}">
							<label><input type="checkbox" name="source" value="${source.ID}"  checked="checked"/>${source.NAME}</label></br>
						</c:forEach>
					</div>
				</td> 
			</tr>
		</table>
		<table class="courseTable" style="margin-bottom:30px;">
			<tr>
				<td align='center'>*一级主题词</td>
				<td align='center'>二级主题词</td>
				<td align='center'>三级主题词</td>
			</tr>
			<tr>
				<td align='center'>
					<select id="theme1List" size="7" style='width:280px;height:234px;overflow-y: scroll;'  class="easyui-validatebox themeList" data-options="required:true">
					</select>
				</td>
				<td align='center'>
					<select id="theme2List" size="7" style='width:280px;height:234px;overflow-y: scroll;' class="easyui-validatebox themeList"  >
					</select>
				</td>
				<td align='center'>
					<select id="theme3List" size="7" style='width:280px;height:234px;overflow-y: scroll;' class="easyui-validatebox themeList" >
					</select>
				</td>
			</tr>
			<tr>
				<td style="text-align: center;">
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="addTheme(1)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="editTheme(1)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="delTheme(1)">删除</a>
				</td>
				<td style="text-align: center;">
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="addTheme(2)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="editTheme(2)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="delTheme(2)">删除</a>
				</td>
				<td style="text-align: center;">
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="addTheme(3)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="editTheme(3)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"  onclick="delTheme(3)">删除</a>
				</td>
			</tr>
		</table>
	</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addCourse()">保存</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0);" onclick="importTheme()">导入主题词</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-pencil'" href="${pageContext.request.contextPath}/course/exportTheme?cid=${c_id}">导出主题词</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-delete'" href="javascript:void(0);" onclick="deleteAllTheme()">删除所有主题词</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="backFromList()">返回课程列表</a>
</div>
<div id="win"></div>
<div id="importTheme"></div>
<div id="addTheme" >
	
</div>
<script type="text/javascript">

const c_id = $("#c_id").val();
$(document).ready(function() {
	const u_id = $('#unit').val();
	if(u_id){
		getDept(u_id);
	}
	$('#unit').select2();
	$('#dept').select2();
});

function backFromList() {
	var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题  	
	if(title == '课程列表'){
		url = "${pageContext.request.contextPath}/course/inCourse?back=1";
		window.location.href = url;
	}else if(title == '新增课程'){
		url = "${pageContext.request.contextPath}/course/inCourse";
		window.location.href = url;
	}else{
		history.back();
	}
}

$('#theme1List').change(function(){
	$('#theme3List').empty();
	getThemeList(2, $(this).val());
	theme2val = $("#theme2List").find("option:first").val();
	if(theme2val!=null&&theme2val!=undefined){
		getThemeList(3, theme2val);
	}
});

$('#theme2List').change(function(){
	getThemeList(3, $(this).val());
});


$('#unit').change(function(){
	var u_id = $(this).val();
	getDept(u_id);
});

function getDept(u_id){
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getDeptList",
        async: false, 
        type: "POST",
        data: { "u_id": u_id },
        success: function (data) {
        	$("#dept").html(null);
        	var str;
			$.each(eval(data),function(i,item){
				str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
			});
			$("#dept").append(str);
 		}
 	});	
}


$('.checkAll').click(function(){
	var index = $('.checkAll').index(this);
	var checkAim = '.checkblock:eq(' + index + ')';
	if($(this).is(':checked')){ 
		$(checkAim).find('input').prop("checked",true);
	}else{ 
		$(checkAim).find('input').prop("checked",false);
	}   
	
});

function addTheme(level){
	sessionStorage.theme_level = level;
	var thParent = "-1";
	if(parseInt(level)>1){			
		var th = '#theme' + (level-1) + 'List';
		thParent = $(th).val();
		if(thParent==null||thParent==undefined||thParent==""){
			$.messager.alert(' ','上级主题词不能为空，请在上级选择一个主题词','info');
			return;
		}
	}
	sessionStorage.thParent = thParent;
	
	var winStr = '<form id="themeForm" method="post" action="">'
		+'<table class="courseTable theme_table">'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="text" name="theme"/></td></tr>'
		+'<tr><td><input type="button" id="toAddTheme" value="新增主题词"/></td></tr></table></form>';
	
	var obj = $(winStr);
	$('#addTheme').html(null);
	obj.appendTo('#addTheme');
	$('#addTheme').window({
		width:500,
		height:800,
		modal:true,
		title:"新增主题词",
		collapsible:false,
		minimizable:false,
		maximizable:false,
	});
	$('#toAddTheme').click(function(){
		var resStr = "";
		$("input[name='theme']").each(function(){
			if($(this).val().trim()!=""){				
				resStr += $(this).val().trim() + ",";				
			}
		}); 
		resStr = resStr.substring(0, resStr.length-1);
		if(resStr==""){
			toastr.warning('请输入至少一个主题词！');
			return;
		}
		$.ajax({
            url: "${pageContext.request.contextPath}/course/addTheme",
            async: false,
            type: "POST",
            data: { "th_name":resStr, "th_level":sessionStorage.theme_level, "th_pid": sessionStorage.thParent, "c_id": c_id,"flag":"add"},
            success: function (data) {
            	if(data==-1){
            		toastr.error("添加失败");
            	}else if(data==0){
            		toastr.warning("新增的主题词重复，导入0个主题词");
            	}else{
            		toastr.success("已新增"+data+"个主题词");   
            	}
        		$("input[name='theme']").val("");
        		$('#addTheme').window('close');
        		getThemeList(sessionStorage.theme_level, sessionStorage.thParent); 	    		
     		}
     	});	
	})
}

function delTheme(level){
	var th = '#theme' + level + 'List';
	var val = $(th).find("option:selected").text();
	if(val==null||val==''){
		$.messager.alert(' ','请选中要删除的主题词','info');
		return;
	}
	thText = '"' + $(th).find("option:selected").text() + '"';
	$.messager.confirm("提示",'是否要删除所选主题词 ' + thText + ' ?',function(r){
    	delStr = '.themeList:eq('+(level-1)+')';
		delVal = $(delStr).val();
		if(delVal==null||delVal==undefined){
			$.messager.alert(' ','删除的主题词不能为空','info');
			return;
		}
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/course/delTheme",
	            async: false, 
	            type: "POST",
	            data: { "th_id": delVal,"thText":thText,"flag":"add" },
	            success: function (data) {
	            	if(data > 0){
	            		toastr.info('所删除的主题词共 ' + data + ' 条!');	
	            	}
	            	getThemeList(level, getThemeParent(level));
	            	if(level==1){
	            		getThemeList((level+1), getThemeParent(level));
	            		getThemeList((level+2), getThemeParent(level));
	            	}
	            	if(level==2){
	            		getThemeList((level+1), getThemeParent(level));
	            	}
	     		}
	     	});	
	    }
	});
}

function editTheme(level){
	var th = '#theme' + level + 'List';
	var val = $(th).find("option:selected").text();
	if(val==null||val==''){
		$.messager.alert(' ','请选中要编辑的主题词','info');
		return;
	}
	thText = '"' + $(th).find("option:selected").text() + '"';
	$.messager.prompt('修改主题词', '主题词 ' + thText +' 修改为:', function(r){
		updateStr = '.themeList:eq('+(level-1)+')';
		updateVal = $(updateStr).val();
		r=r.trim();
		if(updateVal==null||updateVal==undefined||r==''){
			$.messager.alert(' ','编辑的主题词不能为空','info');
			return;
		}
		if(!valTheme(level, r)){
			return;
		}
		if (r){
			$.ajax({
	            url: "${pageContext.request.contextPath}/course/updateTheme",
	            async: false, 
	            type: "POST",
	            data: { "th_name":r,  "th_id": updateVal},
	            success: function (data) {
    	    		getThemeList(level, getThemeParent(level)); 
	     		}
	     	});	
		}
	});
}

function getThemeParent(level){
	var thParent =  -1;
	if(level > 1){
		var th = '#theme' + (level-1) + 'List';
		thParent = $(th).val();
	}
	return thParent;
}

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

function addCourse(){	
	$('#courseForm').form('submit', {
	    url:'${pageContext.request.contextPath}/course/addCourse',
	    onSubmit: function(){
	    	if($("input[name='arrangement']:checked").length==0){
	    		toastr.warning('适应层次不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='questionType']:checked").length==0){
	    		toastr.warning('题型不能为空，请勾选！');
	    		return false;
	    	}	    	
	    	if($("input[name='examType']:checked").length==0){
	    		toastr.warning('考试类别不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='specialty']:checked").length==0){
	    		toastr.warning('适用专业不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='difficulty']:checked").length==0){
	    		toastr.warning('难度不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='knowledge']:checked").length==0){
	    		toastr.warning('知识点分布不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='cognition']:checked").length==0){
	    		toastr.warning('认知类别不能为空，请勾选！');
	    		return false;
	    	}
	    	if($("input[name='source']:checked").length==0){
	    		toastr.warning('题源不能为空，请勾选！');
	    		return false;
	    	}
			let $p = $("input[name='period']");
			let v = $p.val().replace(/\s+/g, ""); // 去掉所有空白(含首尾/中间/换行/tab)
			$p.val(v); // 回写输入框
			if (v !== "" && !/^(?:[1-9]\d*(?:\.\d+)?|0\.\d+)$/.test(v)) {
				toastr.warning('学时数必须为正数，请修改！');
				return false;
			}

			return $("#courseForm").form('validate');
	    },
	    success:function(data){
	    	if(data == -1){
	    		$.messager.alert(' ','课程已经存在，请联系管理员获取课程权限或者修改课程名称。','info');
	    		return;
	    	}else if(data == -2){
	    		$.messager.alert(' ','课程参数不能为空，请勾选','info');
	    		return;
	    	}else if(data==-3){
	    		$.messager.alert(' ','必填项不能为空。','info');
	    		return;
	    	}else if(data==1){
	    		$.messager.defaults = { ok: "继续添加", cancel: "返回列表" };
	    		$.messager.confirm({
				    width: '380',
				    title: '提示',
				    msg: '新增课程成功',
				    fn: function (r) {
				           if (r){
			    		    	window.location.reload();
			    		    }else{
			    		    	backFromList();
			    		    }
				    }
				});
	    		$('.panel-tool-close').hide();
	    	}else{
	    		$.messager.alert(' ','操作失败！','info');
	    		return;
	    	}
	    }
	}); 
}

/*  function addExamType(){
	$.messager.prompt('新增考试类别', '', function(r){
		if(r){
			var examTypeList = $("#examTypeList").find('label');
			var update = true;
			for(var i=0; i<examTypeList.length; i++){
				var val = $(examTypeList[i]).text();
				if(r.trim() == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addExamType",
		            async: false, 
		            type: "POST",
		            data: { "examType":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="examType" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#examTypeList');
		     		}
		     	});		
			}
		}
	});
} */ 
function getAnswerType(){
	var list ='';
	$.ajax({
		url:'${pageContext.request.contextPath}/course/getAnswerType',
		type:'POST',
		async:false, 
		success: function(data){
			list = data;
		}
	});
	return list;
}

function addQuestionType(){
	var winStr = '<form id="QTForm" method="post"><table style="width: 100%;"><tr><td style="text-align: right">题目类型：</td>'
			+ '<td style="text-align: left"><input type="text" name="qt_name" style="width:220px;" class="easyui-validatebox" data-options="required:true"/></td>'
			+ '<tr><td style="text-align: right">英文类型：</td><td style="text-align: left"><input type="text" name="e_qt_name" style="width:220px;" class="easyui-validatebox" data-options="required:true"/></td>'
			+ '</tr><tr><td style="text-align: right">是否串题：</td><td style="text-align: left""><select style="width:220px;" name="qt_iscon" id="qt_iscon">'
			+ '<option value="0">非串题</option><option value="1">串题</option></select>'
			+ '</tr><tr><td style="text-align: right">选项得分设置：</td><td style="text-align: left"><select style="width:220px;" name="qt_xxdf" id="qt_xxdf">'
			+ '<option value="0">无特殊设置</option><option value="2">多选题少选得一半分，错选漏选不得分</option></select>'
			+ '</tr><tr><td style="text-align: right">多媒体播放设定：</td><td style="text-align: left"><select style="width:220px;" name="qt_mediaSet" id="qt_mediaSet">'
			+ '<option value="0">无特殊设置</option><option value="1">不可重播、加速、拖动</option></select>'
			+ '</td></tr><tr><td style="text-align: right">按答案分类：</td><td style="text-align: left">'
			+ '<select style="width:220px;" name="qt_answertypeid" id="qt_answertypeid">';
	var atlist = getAnswerType();
	for(var i=0;i<atlist.length;i++){
		winStr += '<option value='+atlist[i].ID+'>'+atlist[i].NAME+'</option>';
	}
	+ '</select></td></tr>';
	if($("#sxb_switch").val()=='1'){
		winStr += '<tr><td style="text-align: right">是否允许手写板作答：</td><td style="text-align: left">'
				+ '<select style="width:220px;" name="qt_sxb"><option value="0">否</option><option value="1">是</option>'
				+ '</select></td></tr>';
	}

	winStr += '<tr><td style="text-align: right">题目说明：</td><td style="text-align: left">'
			+ '<textarea name="qt_desc" style="width:220px;height:100px;" ></textarea></td></tr>'
			+ '<tr><td style="text-align: right">英文说明：</td><td style="text-align: left">'
			+'<textarea name="e_qt_desc" style="width:220px;height:100px;" ></textarea></td></tr></table>'
			+ '<div style="width: 100%; text-align:center; margin-top:10px">'
			+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitQTForm()">'
			+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
			+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
			+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';

	var obj = $(winStr);
	$('#win').html(null);
	obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:300,
		modal:true,
		title:"添加题型",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function importTheme(){
	var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/course/importTheme?cid=' + $("#c_id").val() + '">'
		+ '<table width="75%" align="center" style="margin-top:5px;">'
		+ '<tr><td colspan="2" align="center" style="color:red">导入主题词（只接受excel格式）</td></tr>'
		+ '<tr><td>选择文件：</td><td><input type="file" id="uploadFile" name="uploadFile" placeholder=""/></td></tr>'
		+ '<tr><td></td><td><input type="button" id="importFile" name="importFile" value="上传"/></td></tr>'
		+ '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/course/importThemeMonel">链接</a></td></tr>'
		+ '</table></form>';
		
		var obj = $(winStr);
		$('#importTheme').html(null);
		obj.appendTo('#importTheme');
	$('#importTheme').window({
		width:440,
		height:168,
		modal:true,
		title:"导入主题词",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
	var form = $('#importFile').click(function(){
		//alert('aaa');
		var fileName = $('#uploadFile').val();
		if(fileName==''){
			toastr.warning("请选择附件");
			return;
		}
		if(fileName){
			var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
			//console.log(fileType);
			if(fileType == 'xls'|| fileType == 'xlsx'){
				var formData = new FormData();
				var name = $("#upfile").val();
				formData.append("file",$("#uploadFile")[0].files[0]);
				formData.append("name",fileName);
				$.ajax({
					url: '${pageContext.request.contextPath}/course/importTheme?cid=' + c_id ,
					type: 'POST',
					secureuri: false,
					data:formData,
					processData:false,
					contentType:false,
					success:function(data){
						if(data.nums=="-2"){
							toastr.error('导入出错，部分主题词未导入，数据异常！');
						}else if(data.nums=="-1"){
							toastr.warning('部分主题词未导入，表格中第'+data.errorRow+'行，有后一级主题词时前一级不能为空！');
						}else{
							toastr.success('共导入'+data.nums+'条主题词');
						}
						getThemeList(1,-1);
						$('#importTheme').window('close');
					}
				});
			}else{
				toastr.warning('文件格式错误，请选择xls文件进行上传！');
			}
			//
		}
		return false;
	});
}

function addArrangement(){
	$.messager.prompt('新增适应层次', '', function(r){
		if(r){
			var arrangementList = $("#arrangementList").find('label');
			var update = true;
			for(var i=0; i<arrangementList.length; i++){
				var val = $(arrangementList[i]).text();
				if(r.trim() == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addArrangement",
		            async: false, 
		            type: "POST",
		            data: { "arrangement":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="arrangement" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#arrangementList');	            	
		     		}
		     	});	
			}
		}
	});
}


function addDifficulty(){
	$.messager.prompt('新增难度', '', function(r){
		if(r){
			var difficultyList = $("#difficultyList").find('label');
			var update = true;
			for(var i=0; i<difficultyList.length; i++){
				var val = $(difficultyList[i]).text();
				if(r.replace(/(^\s*)|(\s*$)/g,"") == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addDifficulty",
		            async: false, 
		            type: "POST",
		            data: { "difficulty":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="difficulty" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#difficultyList');
		     		}
		     	});			
			}
		}
	});
}

function addKnowledge(){
	$.messager.prompt('新增知识点', '', function(r){
		if(r){
			var knowledgeList = $("#knowledgeList").find('label');
			var update = true;
			for(var i=0; i<knowledgeList.length; i++){
				var val = $(knowledgeList[i]).text();
				if(r.trim() == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addKnowledge",
		            async: false, 
		            type: "POST",
		            data: { "knowledge":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="knowledge" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#knowledgeList');
		     		}
		     	});			
			}
		}
	});
}

function addCognition(){
	$.messager.prompt('新增认知', '', function(r){
		if(r){
			var cognitionList = $("#cognitionList").find('label');
			var update = true;
			for(var i=0; i<cognitionList.length; i++){
				var val = $(cognitionList[i]).text();
				if(r.trim() == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addCognition",
		            async: false, 
		            type: "POST",
		            data: { "cognition":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="cognition" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#cognitionList');
		     		}
		     	});			
			}
		}
	});
}


function addSource(){
	$.messager.prompt('新增题源', '', function(r){
		if(r){
			var sourceList = $("#sourceList").find('label');
			var update = true;
			for(var i=0; i<sourceList.length; i++){
				var val = $(sourceList[i]).text();
				if(r.trim() == val){
					toastr.warning('参数重复，请重新输入！');
					update = false;
					break;
				}
			}
			if(update){
				$.ajax({
		            url: "${pageContext.request.contextPath}/course/addSource",
		            async: false, 
		            type: "POST",
		            data: { "source":r,},
		            success: function (data) {
		            	var obj = $('<label><input type="checkbox" checked="checked" name="source" value="' + data + '"/>' + r + '</label></br>');
	    	    		obj.appendTo('#sourceList');
		     		}
		     	});			
			}
		}
	});
}

//修改提交问题类型方法
function submitQTForm(){
	var qtname = $("#qt_name").val();
	$('#QTForm').form('submit', {
	    url:'${pageContext.request.contextPath}/course/addQuestionType',
	    onSubmit: function(){
	    	return valQT();	    	
	    },
	    success:function(data){
	    	if(data=='-1'){
	    		toastr.warning("已有一个'"+qtname+"'同名的题型在系统中,操作失败！");
	    		return;
	    	}
    		var obj = $('<label><input type="checkbox" checked="checked" name="questionType" value="' + data + '"/>' + qtname + '</label></br>');
    		obj.appendTo('#QTList');
    		$('#win').window('close');
	    }
	});
}

function valQT(){
	var res = true;
	if (parseInt($("#qt_iscon").val(), 10) === 1 && parseInt($("#qt_answertypeid").val(), 10) === 13) {
		toastr.warning('编程题不可是串题！');
		return false;
	}
	$.each($("#QTList").find('label'),function(i,item){
		var val = $.trim($("input[name=qt_name]").val());
		if(val==$(item).text()){
	    	$.messager.alert(' ','题型重复，请重新添加','info');
	    	res = false;
	    	return false;
		}else if(val==null||val==''){
	    	$.messager.alert(' ','题型为空，请重新添加','info');
	    	res = false;
	    	return false;
		}
	}); 
	return res;
}


//验证主题词
function valTheme(level, val){
	var res = true;
	var thStr = '#theme' +  level + 'List';
	$.each($(thStr).find('option'),function(i,item){
		if(val==$(item).text()){
	    	$.messager.alert(' ','主题词重复，请重新操作','info');
	    	res = false;
	    	return false;
		}else if(val==null||val==''){
	    	$.messager.alert(' ','主题词为空，请重新添加','info');
	    	res = false;
	    	return false;
		}
	}); 
	return res;
}

function explainQuestionType(){
	var checkID = '';
	$("input[name='questionType']:checked").each(function(i){
		if(checkID==''){
			checkID = $(this).val();
		}else{
			checkID += ',' + $(this).val();
		}
	})
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/explainQuestionType",
		fit:true,
		title:'修改题型'
	},0);
}

function deleteAllTheme(){
	$.messager.confirm('清空主题词','是否删除所有主题词？',function(r){
	    if (r){
	    	$.ajax({
	    		url:'${pageContext.request.contextPath}/course/delAllThemeForNewCourse',
	    		type:'POST',
	    		data:{"cid":c_id},
	    		success:function(data){
	    			$('#theme' +  1 + 'List').html(null);
	    			$('#theme' +  2 + 'List').html(null);
	    			$('#theme' +  3 + 'List').html(null);
	    		}
	    	});
	    }
	});
}

var sa = $('#selectArrangement');
sa.click(function(){
	if(sa.attr("checked")===undefined){
		var a = $("input[name='arrangement']");
		a.not("input:checked").each(function(){
			if($(this).val()=='4'){
				$(this).attr("checked",true);
			}
		});
	}
});
</script>