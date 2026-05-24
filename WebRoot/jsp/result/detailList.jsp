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
<table cellpadding="0" cellspacing="0">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>	
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">更新</a>	
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_go',plain:true" onclick="exportDetailList();">导出当前分析到excel</a>	
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
		</td>		
	</tr>
</table>
</div>
<input id="total" type="hidden" />
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: true,
		url:'${pageContext.request.contextPath}/result/getDetailList',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		queryParams: {
			state: 6
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'ID',title:'试卷编号',width:20,align:'left',sortable:true},
			  {field:'ENAME',title:'科目',width:40,align:'left',sortable:true},
			  /* {field:'GNAME',title:'年级',width:40,align:'left',formatter:function(value,row,index){
	        	  if(row.eo.length > 0){
	        		  var str = '';
	        		  for(var i=0; i<row.eo.length; i++){
	        			  str += row.eo[i].GNAME + ' / ';
	        		  }
	        		  if(str.length > 0){
	        			  str = str.substring(0, str.length-3);
	        		  }
	        		  return str;
	        	  }	        	  
	          }},
	          {field:'SNAME',title:'专业',width:40,align:'left',formatter:function(value,row,index){
	        	  if(row.eo.length > 0){
	        		  var str = '';
	        		  for(var i=0; i<row.eo.length; i++){
	        			  str += row.eo[i].SNAME + ' / ';
	        		  }
	        		  if(str.length > 0){
	        			  str = str.substring(0, str.length-3);
	        		  }
	        		  return str;
	        	  }	        	  
	          }}, */
	          {field:'PAPER',title:'AB卷',width:20,align:'left',formatter:function(value,row,index){
	        	  if(row.AORB == 0){
	        		  return 'A卷 ';
	        	  }else if(row.AORB == 1){
	        		  return 'B卷 ';
	        	  }
	          }},
	          {field:'SCOUNT',title:'考试人数',width:20,align:'left',sortable:true},			  
	          {field:'TEACHERNAME',title:'主考人',width:20,align:'left',sortable:true},			  
	          {field:'begindate',title:'考试开始时间',width:40,align:'left',formatter:function(value,row,index){
	        	  var date = new Date(row.BEGINDATE).format("yyyy-MM-dd hh:mm");
	        	  return date;
	          }},
	          {field:'TIME',title:'考试时长',width:30,align:'left',sortable:true},
	          {field:'usertime',title:'应答时长',width:30,align:'left',sortable:true},
	          {field:'SCORE',title:'满分',width:20,align:'left',sortable:true},
	          {field:'MAXSCORE',title:'最高分',width:20,align:'left',sortable:true},
	          {field:'MINSCORE',title:'最低分',width:20,align:'left',sortable:true},
	          {field:'AVERAGESCORE',title:'平均分',width:20,align:'left',sortable:true},
	          {field:'RANGE',title:'全距',width:20,align:'left',sortable:true},
	          {field:'PASS',title:'及格率',width:20,align:'left',formatter:function(value,row,index){
	        	  return row.PASS+"%";
	          },sortable:true},
	          {field:'OS',title:'优秀率',width:20,align:'left',formatter:function(value,row,index){
	        	  return row.OS+"%";
	          },sortable:true},
	          {field:'STDDEVSCORE',title:'标准差',width:20,align:'left',sortable:true},
	          {field:'ND',title:'难度',width:20,align:'left',sortable:true},
	          {field:'XD',title:'信度',width:20,align:'left',sortable:true},
	          {field:'QFD',title:'区分度',width:20,align:'left',sortable:true},
	          {field:'SUBJECTSUM',title:'试题数量',width:20,align:'left',sortable:true},
	          {field:'OBJECTIVE',title:'客观题数量',width:20,align:'left',sortable:true},
	          {field:'SUBJECTIVE',title:'主观题数量',width:20,align:'left',sortable:true},
	          {field:'STAGE',title:'学年学期',width:40,align:'left',formatter:function(value,row,index){
	        	  return row.SCHOOLYEAR + row.TERM;
	          }},
	          {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="${pageContext.request.contextPath}/result/analysisStudentPaper?cid=' + row.CID + '&eid=' + row.ID + '" class="analysis"></a>';
	        	  return s1;
	          }}
	    ]],
	    onLoadSuccess:function(data){
		    $("#total").val(data.total);
	        $('.analysis').linkbutton({text:'分析',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	limitDay : $('#limitDayList').val(),
    	state : '6',
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

function exportDetailList(){
	var p = $('#datalist').datagrid('getPager');
 	var unid=$('#unitList').val();
   	var cid=$('#courseList').val();
   	var gid=$('#gradeList').val(); 
   	var sid=$('#specialtyList').val();
   	var limitDay=$('#limitDayList').val();
   	var state='6';
   	var page=$(p).pagination('options').pageNumber;
   	var rows=$(p).pagination('options').pageSize;
   	var total = $("#total").val();
	window.location.href = "${pageContext.request.contextPath}/result/exportDetailList?cid="+cid+"&unid="+unid+"&gid="+gid+"&sid="+sid+"&limitDay="+limitDay+"&state="+state+"&page="+page+"&rows="+total;
}
</script>	