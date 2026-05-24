<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/echarts.common.min.js"></script>
<input type="hidden" id="cid" value="${cid}"/>
<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
<table id="course_datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var cid = $('#cid').val();
$(document).ready(function(){
	$('#course_datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		pagination: true,
		rownumbers: false,
		url:'${pageContext.request.contextPath}/course/getCourseRecordList',
		queryParams: {
			cid:cid
		},
		toolbar:'#dlg-toolbar',
		columns:[[			
			  {field:'BEGINDATE',width:50,title:'年度',align:'center'},
			  {field:'icon',title:'平均分分析',width:1300,align:'center',formatter:function(value,row,index){
	          	  return "<div id='chart"+index+"' style='height:200px'></div>";				
	          }
	          }  
		 
	    ]],
	    onLoadSuccess:function(data){	  
	   	    	buildChartJS(data);
	   	    }
	   
	});
});

function buildChartJS(data){
	for(var i=0;i<data.rows.length;i++){
		 console.log(data);
		 var myChart = echarts.init(document.getElementById('chart'+i));			
		 // 指定图表的配置项和数据
	        var option = {	        	
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
	        		            data:data.rows[i].x,	        		                		           
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
	        		            name: '平均分',
	        		            type: 'bar',
	        		            barWidth: '60%',
	        		            data:  data.rows[i].y
	        		        }
	        		    ]
	        };
			myChart.setOption(option);
		}
	}

</script>