<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
/*.datagrid-wrap{
	padding-bottom: 20px !important;
}
.datagrid-wrap:after{	
	display: block;
	content: "${cCount}门课程，${qCount}道试题";
	text-align: center;
	font-size: 14px;
}*/
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">
<div id="dlg-toolbar" style="height:auto;">	
<table cellpadding="0" cellspacing="0"  style="width:100%">
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/inCountQuestion'">刷新</a>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="arrangeFilter" type="text" name="arrangeFilter" style="width:190px;"/>
			<span style="margin-top:5px!important;">
				<input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"></input>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/inCountQuestion'">取消查询</a>
			</span>

				查找从&nbsp;<input id="bdate" type="text" style="width:160px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px"/>&nbsp;录入的试题 <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchByDate()" data-options="iconCls:'icon-search'">查询</a>

		</td>

	</tr>
			
	<input type="hidden" id="errorInfo" value="${errorInfo}"/>
	<input type="hidden" id="cCount" value="${cCount}"/>
	<input type="hidden" id="qCount" value="${qCount}"/>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.cookie.js"></script> 
<script type="text/javascript">
var title='';
var fin=1;
var arrangeid = '';
var unitid='';
var cname='';

var page= 1;
var rows=100;
var sort='';
var order='';

var back='';

var courseTotal = 0;//试题数

function cookierback(){ //加载初始数据前
	back = '${back}';
	title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
	if(back=='1'){
		arrangeid = sessionStorage.getItem(title+'-arrangeid')=='null'?'':sessionStorage.getItem(title+'-arrangeid'); //cookie空值返回null字符串
		unitid = sessionStorage.getItem(title+'-unitid')=='null'?'':sessionStorage.getItem(title+'-unitid');
		cname = sessionStorage.getItem(title+'-cname')=='null'?'':sessionStorage.getItem(title+'-cname');		
		page = sessionStorage.getItem(title+'-page')=='null'?1:parseInt(sessionStorage.getItem(title+'-page'));
		rows = sessionStorage.getItem(title+'-rows')=='null'?80:parseInt(sessionStorage.getItem(title+'-rows'));
		sort = sessionStorage.getItem(title+'-sort')=='null'?'':sessionStorage.getItem(title+'-sort');
		order = sessionStorage.getItem(title+'-order')=='null'?'':sessionStorage.getItem(title+'-order');			
	}else{
		sessionStorage.setItem(title+'-arrangeid',null);
		sessionStorage.setItem(title+'-unitid',null);
		sessionStorage.setItem(title+'-cname',null);
		sessionStorage.setItem(title+'-sort',null);
		sessionStorage.setItem(title+'-order',null);
		sessionStorage.setItem(title+'-page',null);
		sessionStorage.setItem(title+'-rows',null);
	}
}

function cookier(){ //更改筛选条件后
	sessionStorage.setItem(title+'-arrangeid',arrangeid);
	sessionStorage.setItem(title+'-unitid',unitid);
	sessionStorage.setItem(title+'-cname',cname);
	sessionStorage.setItem(title+'-sort',sort);
	sessionStorage.setItem(title+'-order',order);
	sessionStorage.setItem(title+'-page',page);
	sessionStorage.setItem(title+'-rows',rows);
}

function loader(){
	if('${back}'=='1'){
		$('#arrangeFilter').combogrid('grid').datagrid('selectRecord',arrangeid);
		$('#unitFilter').combogrid('grid').datagrid('selectRecord',unitid);
		$('#cname').searchbox('setValue',cname);
	}	
}

function filterloader(){	
	var dg_unitid = $('#unitFilter').combogrid('grid');
	var dg_arrangeid = $('#arrangeFilter').combogrid('grid');
	unitid = (dg_unitid.datagrid('getSelected')==null)?'':dg_unitid.datagrid('getSelected').ID;
	arrangeid = (dg_arrangeid.datagrid('getSelected')==null)?'':dg_arrangeid.datagrid('getSelected').ID;
	cname = $('#cname').searchbox('getValue');	
	$('#datalist').datagrid('load',{				
		unitid: unitid,
		arrangeid:arrangeid,
		cname:cname
	});
	cookier();
}

$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();	
	if(errorInfo){
		toastr.warning(errorInfo);
	}
	cookierback();
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getQueCourseList?owner=question',
		pagination: true,
		rownumbers: false,
		pageSize: rows,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		pageNumber: page,
		queryParams:{
			unitid:unitid,
			arrangeid:arrangeid,
			cname:cname,
		},
		sortName:sort,
		sortOrder:order,
		fitColumns: true,
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'CID',checkbox:true},
			  {field:'index',title:'序号',width:20, align: 'center',formatter:function(val,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
			     return (pageSize * (currentPage -1))+(index+1);
			  }},
		      {field:'NAME_C',title:'课程中文名',width:50,align:'left',sortable:true},
	          {field:'UNAME',title:'授课单位',width:50,align:'left'},
	          {field:'QCOUNT',title:'试题数',width:50,align:'left'}/* ,
	          {field:'opration',title:'操作',width:80,align:'center',formatter:function(value,row,index){
	        	  var s1 = "<a href=\"javascript:void(0);\" class=\"editcls1\" onclick=\"checkQuestionPermission('"+row.CID+"','question:view','${pageContext.request.contextPath}/question/QuestionList?c_id=" + row.CID + "')\"></a>";
	        	  return s1;
	          }} */
	    ]],
	    onCheck:function(rowIndex,rowData){
	    	courseTotal = 0;
	        //获取所选中行
	        var selected = $('#datalist').datagrid('getChecked'); 
	        for(var i = 0;i < selected.length; i++){
	        	 courseTotal += selected[i].QCOUNT;
	        }
	      //总课程数、总试题数赋值
		    $(".datagrid-pager table").next().html(selected.length+"门课程，"+courseTotal+"道试题"); 
	    },
	    onUncheck:function(rowIndex,rowData){
		    //取消选中
	    	courseTotal = courseTotal-rowData.QCOUNT;
	    	var selected = $('#datalist').datagrid('getChecked'); 
	    	if(selected.length == 0){
	    		$(".datagrid-pager table").next().html($("#cCount").val()+"门课程，"+$("#qCount").val()+"道试题");
	    	}else{
	    		$(".datagrid-pager table").next().html(selected.length+"门课程，"+courseTotal+"道试题"); 
	    	}
		},
		onCheckAll:function(rows){
		    //全选中  datagrid-header-check
		    var currentCount = 0
		    for(var item in rows){
		    	currentCount += rows[item].QCOUNT;
		    }
		    courseTotal = currentCount;
	    	$(".datagrid-pager table").next().html(rows.length+"门课程，"+courseTotal+"道试题"); 
		},
		onUncheckAll:function(rows){
		    //反选	
		    var currentCount = 0
		    for(var item in rows){
		    	currentCount += rows[item].QCOUNT;
		    }
		    courseTotal = currentCount;
	    	$(".datagrid-pager table").next().html($("#cCount").val()+"门课程，"+courseTotal+"道试题"); 
		   // $(".datagrid-pager table").next().html(data.cCount+"门课程，"+data.qCount+"道试题");
		},
	    onLoadSuccess:function(data){
	    	$('.editcls1').linkbutton({text:'编辑试题',plain:true});
	        getCourse_QuestionCount(unitid,arrangeid,cname);
	        if(page!=$('#datalist').datagrid('getPager').data('pagination').options.pageNumber){
	        	page = $('#datalist').datagrid('getPager').data('pagination').options.pageNumber;
	        	cookier();
	        }
	        if(fin==1){
	        	var str="<div style='float:left;margin: 0 6px;height: 30px;line-height: 30px;'>"+$("#cCount").val()+"门课程，"+$("#qCount").val()+"道试题</div>";
		        $(".pagination-info").before(str);
		        fin=0;
	        }
	    },
		 onSortColumn:function(sorts,orders){
				sort = sorts;
				order = orders;
				cookier();
			}
	});
	
	var buttons =[];
	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	$(p).pagination({
		onChangePageSize:function(pageSize){
			rows = pageSize;
			cookier();
		}
	});
	
	$('#arrangeFilter').combogrid({
		url: '${pageContext.request.contextPath}/common/getArrangement',
		idField: 'ID',
		textField: 'NAME',
		editable: false,
		columns:[[
			{field:'NAME',title:'适应层次',width:169,sortable:true}
		]],
		onSelect:function(data){
			let arrangeidChosen = '';
	    	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		arrangeidChosen = $('#unitFilter').combogrid('grid').datagrid('getSelected');
	    	}
			if(arrangeidChosen!=arrangeid){
				filterloader();
			}
		},
		onLoadSuccess:function(){
			$('#arrangeFilter').combogrid('setValue','适应层次');
			loader();
		}
	});
	
	$('#unitFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getUnit',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'授课单位',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	let unitidChosen = '';
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitidChosen = $('#unitFilter').combogrid('grid').datagrid('getSelected');
	    	}
			if(unitidChosen!=unitid){
				filterloader();
			}
		},
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '授课单位');
	        loader();
	    }
	});
});

function doSearch(value,name){//通用查询框	
	cname = value;
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
		arrangeid = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	cookier();
	$('#datalist').datagrid('load',{
		unitid: unitid,
		arrangeid: arrangeid,
		cname: value
	});
}

function getCourse_QuestionCount(unitid,arrangeid,cname,bdate,edate){
	$(".datagrid-wrap").addClass('change').attr('data-content', "0门课程，0道试题");
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getCourse_QuestionCount",
        async: true, 
        type: "POST",
        traditional: true,
        data: {"unitid":unitid,"arrangeid":arrangeid,"cname":cname,"bdate":$('#bdate').datebox("getValue"),"edate":$('#edate').datebox("getValue")},
        success: function (data) {
        	var cCount = 0;
        	var qCount = 0;
        	if(typeof(data.cCount) != 'undefined'){
        		cCount = data.cCount;
        	}else{
        		cCount = 0;
        	}
        	$("#cCount").val(cCount);
        	if(typeof(data.qCount) != 'undefined'){
        		qCount = data.qCount;
        	}else{
        		qCount = 0;
        	}
        	$("#qCount").val(qCount);
        	$(".datagrid-wrap").addClass('change').attr('data-content', cCount+"门课程，"+qCount+"道试题");
        	$(".datagrid-pager table").next().html(cCount+"门课程，"+qCount+"道试题");
        }
	});	
}

function checkQuestionPermission(cid,permission,url){
	var params = {};
	params["cid"] = cid;
	params["permission"] = permission; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		window.location.href = url;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
}


function searchByDate(){
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
	if(etime < btime){
		toastr.warning("开始时间不能大于结束时间");
		return;
	}
	var p = $('#datalist').datagrid('getPager');
	$('#datalist').datagrid('reload',{
		bdate : $('#bdate').datebox("getValue"),
		edate : $('#edate').datebox("getValue"),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
	});
}
</script>	

