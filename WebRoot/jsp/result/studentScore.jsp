<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
.plimit{
	padding:2px .8px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	min-width:100px;
	max-width: 280px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
a{text-decoration:none;color:black;}
a:hover { color:blue; }
</style>
<div id="dlg-toolbar" style="height:auto">
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>	
			<select id="gradeList" name="gradeList" class="plimit" onchange="paperFilter()">
				<option value="">不限年级</option>
				<c:forEach var="grade" items="${applicationScope.grade}">
					<option value="${grade.ID}">${grade.NAME}</option>
				</c:forEach>
			</select>
			<select id="specialtyList" name="specialtyList" class="plimit" onchange="paperFilter()">
				<option value="">不限专业</option>
				<c:forEach var="specialty" items="${applicationScope.specialtyList}">
					<option value="${specialty.ID}">${specialty.NAME}</option>
				</c:forEach>
			</select>
			<input class="easyui-searchbox" data-options="prompt:'按考生姓名或学号查询',searcher:doSearchByName" style="width:300px;"></input>	
			<!-- 		
			<select id="limitDayList" name="limitDayList" class="plimit" onchange="paperFilter()">
				<option value="">不限考试日期</option>
				<option value="1">1天以内的考试</option>
				<option value="7">7天以内的考试</option>
				<option value="15">15天以内的考试</option>
				<option value="30">30天以内的考试</option>
				<option value="90">90天以内的考试</option>
				<option value="180">180天以内的考试</option>
				<option value="365">1年以内的考试</option>
				<option value="730">2年以内的考试</option>
				<option value="1825">5年以内的考试</option>
				<option value="3650">10年以内的考试</option>
			</select> -->	
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/result/studentScore";
	$.parser.parse($("#searchpage"));//重新渲染

	$('#gradeList').select2();
	$('#specialtyList').select2();
	
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/result/getStudentList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[10,10*2,10*3,10*5,10*10,10*20],
		fitColumns: true,
		queryParams: {
			//state: 6
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'ID',checkbox:true},//var date = new Date(val)
			  {field:'NUM',title:'学号',width:40,align:'left',sortable:true},
			  {field:'GRADE',title:'年级',width:40,align:'left',sortable:true},
			  {field:'NAME',title:'姓名',width:40,align:'left',sortable:true},
			  {field:'SPECIALTY',title:'专业、单位',width:40,align:'left',sortable:true},
			  {field:'CLASS',title:'班级',width:40,align:'left',sortable:true,formatter:function(value,row,index){
				  if(row.CLASS != 'null'){
					  return row.CLASS;
				  }
			  }},
			  {field:'TEL',title:'联系电话',width:40,align:'left',formatter:function(value,row,index){
				  if(row.TEL != 'null'){
					  return row.TEL;
				  }
			  }},
	          {field:'OPERATION',title:'操作',width:60,align:'left',formatter:function(value,row,index){
	        	  //var s1 = '<a href="${pageContext.request.contextPath}/result/checkScore?sid=' + row.ID + '" class="checkScore"></a>';
	        	  var s1 = '<a href="javascript:void(0);" class="checkScore" onclick="checkScore(\''+row.ID+'\')"></a>';
	        	  var s2 = '<a href="javascript:void(0);" class="editStudent" onclick="editStudent(\''+row.ID+'\')"></a>';
        		  return s1 + s2;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.checkScore').linkbutton({text:'查看成绩',plain:true});
	    	$('.editStudent').linkbutton({text:'编辑',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
    	grade : $('#gradeList').val(), 
    	specialtyid : $('#specialtyList').val(),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

function doSearchByName(value,name){ 
	$('#datalist').datagrid('load',{
		name: value
	});
}

function editStudent(sid){
	var url = '${pageContext.request.contextPath}/users/editStudent?sid='+sid;
	/*var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '编辑学生名单',
		content: content,
		closable: true 
	});*/
	openIframeDialog({
		url:url,
		fit:true,
		title:'编辑学生名单'
	},1);
}

function checkScore(sid){
	var url = '${pageContext.request.contextPath}/result/checkScore?sid='+sid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '查看成绩',
		content: content,
		closable: true 
	});
}
</script>	