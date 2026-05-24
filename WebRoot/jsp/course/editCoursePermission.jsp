<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<style>
.datagrid-wrap.change:after {
    content: attr(data-content);
}
</style>

<div id="dlg-toolbar" style="height:auto;">
	<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr style="vertical-align:middle;">
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/course/toEditCoursePermission'">刷新</a>
<%--			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />--%>
			<input id="departmentFilter" type="text" name="departmentFilter" style="width:190px;" />
			<input id="arrangeFilter" type="text" name="arrangeFilter" style="width:190px"/>
			<span style="margin-top:5px!important;">
				<input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/course/toEditCoursePermission'">取消查询</a>
			</span>
			<span style="font-size:14px;">查找从&nbsp;<input id="bdate" type="text" style="width:160px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px"/>&nbsp;新建的课程 <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchByDate()" data-options="iconCls:'icon-search'">查询</a></span>
		</td>
	</tr>
</table>
	<input type="hidden" id="errorInfo" value="${errorInfo}"/>
	<input type="hidden" id="unitid" value="${unitid}"/>

</div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.cookie.js"></script> 
<script type="text/javascript">
var arrangeid = '';
var unitid='';
var depid='';
var cname='';

var page= 1;
var rows=100;
var sort='';
var order='';

$(document).ready(function(){
	$('#datalist').datagrid({
        fit:true,
		fitColumns:true,		
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getCourseList4Teachingoffice',
		pagination: true,
		rownumbers: false,
		pageNumber: page,
		queryParams:{
			unitid:unitid,
			depid:depid,
			arrangeid:arrangeid,
			cname:cname,
		},
		pageSize: rows,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		sortName:sort,
		sortOrder:order,
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'CID',checkbox:true},
			  {field:'index',title:'序号',width:10, align: 'center',formatter:function(val,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
			     return (pageSize * (currentPage -1))+(index+1);
			    }},
		      {field:'NAME_C',title:'课程中文名',width:60,align:'left',sortable:true,formatter:function(value,row,index){
		    	  var s = '<div onclick="viewCourse('+row.CID+')" style="cursor:pointer">'+row.NAME_C+'</div>';
		    	  return s;
	          }},
	          {field:'UNAME',title:'授课单位',width:30,align:'left',sortable:true},
	          {field:'DNAME',title:'所属科室',width:30,align:'left',sortable:true},
	          {field:'PERIOD',title:'最大学时',width:20,align:'left',sortable:true},
	          {field:'PCOUNT',title:'试卷数',width:20,align:'left',sortable:true},
	          {field:'QCOUNT',title:'试题数',width:20,align:'left',sortable:true},
	          {field:'opration',title:'操作',width:100,align:'center',formatter:function(value,row,index){
	        	  var s0 = '<a href="javascript:void(0)" onclick="viewCourse(\''+row.CID+'\')" class="editcls0"></a>'
	        	  var s1 = '<a href="javascript:void(0)" onclick="gotoEditCourse(\''+row.CID+'\')" class="editcls1"></a>';
	        	  var s2 = '<a href="javascript:void(0)" onclick="inCoursePermission_teachingoffice(\''+row.CID+'\',\''+row.NAME_C+'\');" class="editcls3"></a>';
                      return s0 + s1 + s2 ;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editcls0').linkbutton({text:'课程详情',plain:true});
	    	$('.editcls1').linkbutton({text:'课程设置',plain:true});
	        $('.editcls3').linkbutton({text:'课程权限',plain:true});
	    }
	});
	 

	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	$(p).pagination({
		onChangePageSize:function(pageSize){
			rows = pageSize;
		}
	});
	
	<%--$('#unitFilter').combogrid({--%>
	<%--    url: '${pageContext.request.contextPath}/common/getUnit',--%>
	<%--    idField: 'ID',--%>
	<%--    textField: 'NAME',--%>
	<%--    editable: false,--%>
	<%--    columns: [[--%>
	<%--		{field:'NAME',title:'授课单位',width:169,sortable:true}--%>
	<%--    ]],--%>
	<%--    onSelect:function(data){--%>
	<%--    	let unitidChosen = '';--%>
	<%--    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){--%>
	<%--    		unitidChosen = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;--%>
	<%--    	}--%>
	<%--    	if(unitidChosen.ID!=unitid){--%>
	<%--			filterloader();--%>
	<%--		}--%>
	<%--	},--%>
	<%--	onChange:function(newValue, oldValue){--%>
	<%--		var newParams = {--%>
	<%--    		unitid: newValue--%>
    <%--        };--%>
	<%--    	$('#departmentFilter').combogrid('grid').datagrid('options').queryParams = newParams;--%>
	<%--    	$('#departmentFilter').combogrid('grid').datagrid('reload');--%>
	<%--    	$('#departmentFilter').combogrid('setValue', null);--%>
	<%--	},--%>
	<%--	onLoadSuccess:function(){--%>
	<%--        $("#unitFilter").combogrid('setValue', '授课单位');--%>
	<%--    }--%>
	<%--});--%>

	$('#departmentFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getDepartment',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
		queryParams: {'unitid':unitid},
	    columns: [[
			{field:'NAME',title:'所属科室',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	// let unitid = "";
	    	// if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    	// 	unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	// }
	    	let depid = "";
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#datalist').datagrid('load',{
	    		depid:depid,
	    		unitid:unitid
			});
	    },
		onLoadSuccess:function(){
	        $("#departmentFilter").combogrid('setValue', '所属科室');
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
	    		arrangeidChosen = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
			if(arrangeidChosen!=arrangeid){
				filterloader();
			}
		},
		onLoadSuccess:function(){
			$('#arrangeFilter').combogrid('setValue','适应层次');
		}
	});
	
});

function filterloader(){
	// var dg_unitid = $('#unitFilter').combogrid('grid');
	var dg_depid = $('#departmentFilter').combogrid('grid');
	var dg_arrangeid = $('#arrangeFilter').combogrid('grid');
	// unitid = (dg_unitid.datagrid('getSelected')==null)?'':dg_unitid.datagrid('getSelected').ID;
	depid = (dg_depid.datagrid('getSelected')==null)?'':dg_depid.datagrid('getSelected').ID;
	arrangeid = (dg_arrangeid.datagrid('getSelected')==null)?'':dg_arrangeid.datagrid('getSelected').ID;
	cname = $('#cname').searchbox('getValue');
	$('#datalist').datagrid('load',{
		unitid: unitid,
		depid:depid,
		arrangeid:arrangeid,
		cname:cname
	});
}

function viewCourse(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/viewCourse?c_id=" + cid,
		fit:true,
		title:'查看课程'
	},0);
}

function gotoEditCourse(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/editCourse?c_id=" + cid,
		fit:true,
		title:'课程设置'
	},1);
}

function inCoursePermission_teachingoffice(cid,name_c){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/inCoursePermission_teachingoffice?c_id=" + cid + "&cname="+ name_c,
		fit:true,
		title:'课程权限'
	},0);
}

function doSearch(value,name){
	cname=value;
	// if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	// 	unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	// }
	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
		arrangeid = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	$('#datalist').datagrid('load',{
		unitid: unitid,
		depid: depid,
		arrangeid: arrangeid,
		cname: value
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
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
	});
}
</script>	

