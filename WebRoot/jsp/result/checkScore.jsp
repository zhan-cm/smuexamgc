<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/echarts.common.min.js"></script>
<style>
tr{
	line-height: 20px;
}
</style>
<div id="dlg-toolbar" style="height:26px;">
 
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="backtoFinishPpaper()">返回</a>	
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>				
	   	 	<a class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true" href="${pageContext.request.contextPath}/result/ndfx?sid=${sid}">年度分析报告</a>	  	
		</td>		
	</tr>
</table>
<!-- model -->	
<input type="hidden" value="${sid}" id="sid"/>
<input type="hidden" id="sname" name="sname" value="${sname}">
<input type="hidden" id="snum" name="snum" value="${snum}">
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var sid = $('#sid').val();
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/result/getTestedPaper',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		queryParams: {
			sid: sid
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'EID',title:'试卷编号',width:40,align:'left',sortable:true},
			  {field:'ENAME',title:'试卷名称',width:40,align:'left',sortable:true},
			  {field:'NAME',title:'姓名',width:40,align:'left',sortable:true},
			  {field:'GRADE',title:'年级',width:40,align:'left',sortable:true},
			  {field:'BEGINDATE',title:'考试开始时间',width:40,align:'left',sortable:true,formatter:function(value,row,index){
	        	  var date = new Date(row.BEGINDATE).format("yyyy-MM-dd hh:mm");
	        	  return date;
	          }},
			  {field:'ENDDATE',title:'考试结束时间',width:40,align:'left',sortable:true,formatter:function(value,row,index){
	        	  var date = new Date(row.ENDDATE).format("yyyy-MM-dd hh:mm");
	        	  return date;
	          }},
			  {field:'ETYPE',title:'考试类型',width:40,align:'left',sortable:true},
			  {field:'COUNT',title:'成绩',width:40,align:'left',sortable:true},			  
	          {field:'ANALYSIS',title:'成绩分析',width:60,align:'left',formatter:function(value,row,index){
	        	  var s1 = '<a href="javascript:void(0);" class="analysis" onclick="analysis(\''+row.EID+'\',\''+sid+'\')"></a>';
	        	  return s1;
	          }},			        
	          {field:'OPERATION',title:'答卷查看',width:60,align:'left',formatter:function(value,row,index){
	        	  var s1 = '<a href="javascript:void(0);" class="viewStudentRes"  onclick="viewStudentPaper(\''+row.EID+'\',\''+sid+'\')"></a>';
	        	  var s2 = '<a href="javascript:void(0);" class="viewOriginalPaper" onclick="viewOriginalPaper(\''+row.EID+'\',\''+sid+'\');"></a>';
        		  return s1 + s2;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewStudentRes').linkbutton({text:'学生答卷',plain:true});
	    	$('.viewOriginalPaper').linkbutton({text:'原始试卷',plain:true});
	    	$('.analysis').linkbutton({text:'查看',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

 
$('#checkScore_Echar_view').linkbutton({
    onClick: function () {	 
  	  $('#checkScore_win').dialog({
            title: '成绩分析报告',
            width: 900,
            height: 500,
            top:120,
            closed: false,//显示对话框
            cache: false,
            modal: true
        });  		
  	    view();   	
   }
});

function  view(){	
	    var x =[];
	    var y =[];   
	$("input[name='l_ename']").each(function(){
	    x.push($(this).val());
	})
	 
	$('input[name="l_count"]').each(function(){   				
		y.push($(this).val());	   		 		 		
	}); 
	  // 基于准备好的dom，初始化echarts实例
      var myChart = echarts.init(document.getElementById('checkScore_main'));     
      // 指定图表的配置项和数据
      var option = {    
      	title: {
                  text: '课程成绩分析'
              },       
          color: ['#3398DB'],
          tooltip: {
              trigger: 'axis',
              axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                  type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
              }
          },
          grid: {
              left: '3%',
              right: '4%',
              bottom: '3%',
              containLabel: true
          },
          xAxis: [
              {
                  type: 'category',	                   
                  data: x,   
                  axisLabel: { interval:0,
                      rotate:40
                      },                 
                  axisTick: {
                      alignWithLabel: true
                  }
              }
          ],
          yAxis: [
              {
                  type: 'value'
              }
          ],
          series: [
              {
                  name: '成绩',
                  type: 'bar',
                  barWidth: '60%',
                  data: y
              }
          ]
      };     
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option);
   
	 }    

function analysis(eid,sid){
	var url = '${pageContext.request.contextPath}/result/analysis?eid=' + eid + '&sid=' + sid;
	var content = '<iframe style="width:100%;height:100%;border:0;overflow:auto;" src="'+url+'"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '成绩分析',
		content: content,
		closable: true
	});
}

function backtoFinishPpaper(){
	var sid=$("#sid").val();
	var sname=$("#sname").val();
	var snum=$("#snum").val();
	if(sname!=null&&sname!=""){
		window.location.href = '${pageContext.request.contextPath}/studentEnd/finishExamPaper?sid='+sid+ '&sname='+sname+'&snum='+snum;
	}else{
		cancelEasyUiFrame(0);
	}
}

function viewStudentPaper(eid,sid){
	var url = '${pageContext.request.contextPath}/result/viewStudentPaper?eid=' + eid+'&sid='+sid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '学生答卷',
		content: content,
		closable: true 
	});
}


function viewOriginalPaper(eid,sid){
	var url = '${pageContext.request.contextPath}/result/viewStudentRes?eid=' + eid + '&sid=' + sid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '原始试卷',
		content: content,
		closable: true 
	});
}
</script>	