<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
.qcontent{
	height: 40px;
	overflow:hidden;
}
.wrap-text {
	white-space: normal;
	word-wrap: break-word;
}
</style>
<div id="dlg-toolbar" style="height:auto">
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<select id="limit_time" name="limit_time" onchange="paperFilter()" class="easyui-combobox" style="width:100px;">
				<option value="">不限时间</option>
				<option value="1">1天以内</option>
				<option value="2">2天以内</option>
				<option value="3">3天以内</option>
				<option value="4">4天以内</option>
				<option value="5">5天以内</option>
				<option value="6">6天以内</option>
				<option value="7">7天以内</option>
				<option value="10">10天以内</option>
				<option value="15">15天以内</option>
				<option value="30">30天以内</option>
				<option value="60">60天以内</option>
				<option value="90">90天以内</option>
				<option value="180">180天以内</option>
				<option value="365">365天以内</option>
				<option value="730">730天以内</option>
			</select>
			<input class="easyui-searchbox" data-options="prompt:'根据用户名或内容查询',searcher:doSearch" id="search" style="width:200px;"/>
			<span style="color:red;">转移<input type="text" id="limit_time_export" name="limit_time_export" value="365"/>天以前的日志到excel文件<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-basket_put',plain:true" onclick="exportLogs();">转移到excel文件</a></span>
		</td>
		<td  colspan="2">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteByDate()">删除</a>从&nbsp;<input id="bdate" type="text" style="width:180px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:180px"/>&nbsp;的记录
		</td>
	</tr>	
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getLogsList',
		pagination: true,
		rownumbers: false,
		pageSize: 30,
		pageList:[10,20,30,40,50,60,70,80],
		fitColumns: true,
		queryParams: {
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'NAME',title:'用户名',width:20,align:'center',sortable:true},
			  {field:'IP',title:'ip地址',width:20,align:'center',sortable:true},
			{
				field: 'CONTENT',
				title: '操作内容',
				width: 100,
				align: 'center',
				sortable: true,
				formatter: function (value, row, index) {
					return '<div class="wrap-text">' + value + '</div>';
				}
			},
	    ]],
	    onLoadSuccess:function(data){
	    	
	    }
	});
	
	var buttons =[];
	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
	var search = $('#search').searchbox("getValue");
 	$('#datalist').datagrid('reload', {
 		limit_time : $('#limit_time').val(),
 		value : search,
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

function doSearch(value,name){ 
	$('#datalist').datagrid('load',{
		limit_time : $('#limit_time').val(),
		value: value
	});
}

function exportLogs(){
	$.messager.confirm("提示",'导出日志后，会将系统日志删除，您确定要导出吗？',function(r){
	    if (r){
	    	var url = "${pageContext.request.contextPath}/system/exportLogs?limit_time_export="+$("#limit_time_export").val();
	    	window.location.href=url;

	    }
	});
}
function deleteByDate(){
	var bdate = $('#bdate').datebox("getValue");
	var edate = $('#edate').datebox("getValue");
	var r1=bdate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	var r2=edate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	if(r1==null || r2==null){
		toastr.warning("请正确输入日期");
		return;
	}
	var btime = new Date(bdate);
	var etime = new Date(edate);
	if(etime=="Invalid Date" || btime=="Invalid Date"){
		toastr.warning("请输入合法的时间参数");
		return;
	}
	if(etime <= btime){
		toastr.warning("结束时间必须大于开始时间");
		return;
	}
  	$.messager.confirm("提示",'删除日志操作不可逆，确定删除？',function(r){ 
	if (r){
	    $.ajax({
			contentType: "application/json; charset=utf-8",
			url:'${pageContext.request.contextPath}/system/deleteByDate',
			success:success,
			error:error,
			headers: {'content-type': 'application/x-www-form-urlencoded'},
			data:{"bdate":bdate,"edate":edate},
			type:'POST',
			dataType:'text',
		});
	    function success(data){
	    	if(data>0){
	    		toastr.success("删除成功");
		    	$('#datalist').datagrid('reload');
	    	}else{
	    		toastr.warning('该时间段没有日志记录可以删除!');
	    	}
		}
		function error(){
			toastr.error('删除失败!');
		}
	   }
	});
}
</script>	