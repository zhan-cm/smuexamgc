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
	width:100px;
	max-width: 280px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
</style>
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="cid" name="cid" value="${cid }">
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td style="padding-left:2px">	
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">更新</a>	
			<select id="unitList" name="unitList" class="plimit" onchange="paperFilter(), changeUnit()">
				<option value="">不限教学单位</option>
				<c:forEach var="unit" items="${applicationScope.unitList}">
					<option value="${unit.ID}">${unit.NAME}</option>
				</c:forEach>
			</select>
			<select id="courseList" name="courseList" class="plimit" onchange="paperFilter()">
				<option value="">不限课程</option>
				<c:forEach var="course" items="${courseList}">
					<option value="${course.CID}">${course.CNAME}</option>
				</c:forEach>
			</select>
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
			</select>
				<a class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true" href="${pageContext.request.contextPath}/course/ndfx?cid=${cid}">年度分析报告</a>	  	
		</td>		
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: true,
		url:'${pageContext.request.contextPath}/course/getDetailList',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		queryParams: {
			cid: $("#cid").val()
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'ID',title:'试卷编号',width:20,align:'left'},
			  {field:'ENAME',title:'科目',width:40,align:'left'},
	          {field:'PAPER',title:'AB卷',width:20,align:'left',formatter:function(value,row,index){
	        	  if(row.AORB == 0){
	        		  return 'A卷 ';
	        	  }else if(row.AORB == 1){
	        		  return 'B卷 ';
	        	  }
	          }},
	          {field:'SCOUNT',title:'考试人数',width:20,align:'left'},
	          {field:'TEACHERNAME',title:'主考人',width:20,align:'left'},
	          {field:'begindate',title:'考试开始时间',width:30,align:'left',formatter:function(value,row,index){
	        	  var date = new Date(row.BEGINDATE).format("yyyy-MM-dd");
	        	  return date;
	          }},
	          {field:'TIME',title:'考试时长',width:30,align:'left'},
	          {field:'usertime',title:'应答时长',width:30,align:'left'},
	          {field:'SCORE',title:'满分',width:20,align:'left'},
	          {field:'MAXSCORE',title:'最高分',width:20,align:'left'},
	          {field:'MINSCORE',title:'最低分',width:20,align:'left'},
	          {field:'AVERAGESCORE',title:'平均分',width:20,align:'left'},
	          {field:'RANGE',title:'全距',width:20,align:'left'},
	          {field:'PASS',title:'及格率',width:20,align:'left',formatter:function(value,row,index){
	        	  return row.PASS+"%";
	          },sortable:true},
	          {field:'OS',title:'优秀率',width:20,align:'left',formatter:function(value,row,index){
	        	  return row.OS+"%";
	          },sortable:true},
	          {field:'STDDEVSCORE',title:'标准差',width:20,align:'left'},
	          {field:'ND',title:'难度',width:20,align:'left'},
	          {field:'XD',title:'信度',width:20,align:'left'},
			{field:'XIAODU',title:'效度',width:20,align:'left'},
	          {field:'QFD',title:'区分度',width:20,align:'left'},
			{field:'SKEWNESS',title:'偏态量',width:20,align:'left'},
	          {field:'SUBJECTSUM',title:'试题数量',width:20,align:'left'},
	          {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="${pageContext.request.contextPath}/result/analysisStudentPaper?cid=' + row.CID + '&eid=' + row.ID + '" class="analysis"></a>';
	        	  return s1;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	        $('.analysis').linkbutton({text:'分析',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function getBNum(eid){
	var num = 0;
	$.ajax({
        url: "${pageContext.request.contextPath}/verify/getBNum",
        async: false,
        type: "POST",
        traditional: true,
        data: { "eid":eid },
        success: function (data) {
        	if(data){
            	num = data;
        	}
        }
	});
	return num;
}

function getPaperStudentCount(eid){
	var res = 0;
	$.ajax({
        url: "${pageContext.request.contextPath}/monitor/getPaperStudentCount",
        async: false,
        type: "POST",
        data: { 'eid':eid },
        success: function (data) {
		    res = data;
		    return res;
 		}
 	});
	return res;
}

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	limitDay : $('#limitDayList').val(),
    	state : '8',
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

function changeUnit(){
	if($('#unitList').val()){
		$.ajax({
	        url: "${pageContext.request.contextPath}/result/getCourseListByUnid",
	        async: false, 
	        type: "POST",
	        data: {"uid": $('#unitList').val()}, 
	        success: function (data) {
	        	$('#courseList').html(null);
	        	var str = '<option value="">不限课程</option>';
				$.each(eval(data), function(i,item){
					str += '<option value="' + item.CID + '">' + item.CNAME + '</option>'
				});
				$('#courseList').append(str);
	 		}
	 	});	
	}
}
</script>	