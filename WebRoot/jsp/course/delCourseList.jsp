<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>


<div id="dlg-toolbar" style="height:auto;">
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr style="vertical-align:middle;">
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<!--<shiro:hasRole name="administrator">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect()">彻底删除所选课程</a>
			</shiro:hasRole>-->
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="arrangeFilter" type="text" name="arrangeFilter" style="width:190px"/>
			<span style="margin-top:5px!important;">
				<input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"></input>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			</span>
		</td>
	</tr>
</table>
	<input type="hidden" id="errorInfo" value="${errorInfo}"/>
</div>
<table id="datalist"></table>
<table id="printTable" style="display:none;" border="1" cellpadding="2" cellspacing="0">
	<tr>
		<td>序号</td>
		<td>课程中文名</td>
		<td>授课单位</td>
		<td>所属科室</td>
		<td>试卷数</td>
		<td>试题数</td>
		<td>最大课时</td>
	</tr>
	<tbody id="printTableBody">
		
	</tbody>
</table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.PrintArea.js"></script> 
<script type="text/javascript">
var arrangeid = '';
var unitid='';
var cname='';
$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();
	
	if(errorInfo){
		toastr.warning(errorInfo);
	}
	$.parser.parse($("#datalist"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		fitColumns:true,		
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getDelCourseList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		//queryParams:queryParams,
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
		      {field:'NAME_C',title:'课程中文名',width:80,align:'left',formatter:function(value,row,index){
		    	  var s = '<div onclick="viewCourse('+row.CID+')">'+row.NAME_C+'</div>';
		    	  return s;
	          }},
		      //{field:'NAME_E',title:'课程英文名',width:60,align:'left',sortable:true},
	          //{field:'SHORTNAME',title:'课程简称',width:40,align:'left',sortable:true},
	          {field:'UNAME',title:'授课单位',width:50,align:'left',sortable:false},
	          {field:'DNAME',title:'所属科室',width:40,align:'left',sortable:false},
	          //{field:'CONTACT',title:'联系人',width:40,align:'left',sortable:false},
	          //{field:'TEL',title:'联系电话',width:40,align:'left',sortable:true},
	          {field:'PAPERCOUNT',title:'试卷数',width:20,align:'left',sortable:false},
	          {field:'QCOUNT',title:'试题数',width:20,align:'left',sortable:false},
	          {field:'PERIOD',title:'最大课时',width:20,align:'left',sortable:true},
	          {field:'opration',title:'操作',width:90,align:'center',formatter:function(value,row,index){
	        	  //var s1 = '<a href="javascript:void(0)" onclick="viewCourse(\''+row.CID+'\')" class="editcls0"></a>'
	        	  var s1 = '<a href="javascript:void(0)" class="editcls1" onclick="recoverCourse('+ row.CID + ')"></a>';
	        	  var s2 = '<a href="javascript:void(0)" class="editcls2" onclick="delCourseAll('+ row.CID + ')"></a>';
	        	  var s3 = '<a href="javascript:void(0)" class="editcls3" onclick="delCourseNotPaper('+ row.CID + ')"></a>';
	        	  return s1+s2+s3;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editcls1').linkbutton({text:'恢复课程',plain:true});
	    	$('.editcls2').linkbutton({text:'删除课程所有信息',plain:true});
	    	$('.editcls3').linkbutton({text:'删除除试卷以外所有课程信息',plain:true});
	        
	    }
	});
	 
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$('#arrangeFilter').combogrid({
		url: '${pageContext.request.contextPath}/common/getArrangement',
		idField: 'ID',
		textField: 'NAME',
		editable: false,
		columns:[[
			{field:'NAME',title:'适应层次',width:169,sortable:true}
		]],
		onSelect: function(data){
			var unitid = '';
			if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
				unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
			}
			$('#datalist').datagrid('load',{
				unitid: unitid,
				arrangeid:$('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID,
				cname:cname
			});
		},
		onLoadSuccess:function(){
			$('#arrangeFilter').combogrid('setValue','适应层次');
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
	    	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		arrangeid = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	unitid=$('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	$('#datalist').datagrid('load',{
	    		unitid:unitid,
				arrangeid: arrangeid,
				cname:cname
			});
	    },
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '授课单位');	        
	    }
	});	
	
});



function delSelect(){
	var res = [];
	var rows = $('#datalist').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		res.push(rows[i].CID);
	}
	$.messager.confirm("提示",'是否要删除所选课程 ?',function(r){ 
	    if (r){
			$.ajax({
		        url: "${pageContext.request.contextPath}/course/delSelect",
		        async: true, 
		        type: "POST",
		        traditional: true,
		        data: { "cids":res },
		        success: function (data) {
		        	if(data){
		        		toastr.warning(data);
		        	}else{
		        		$('#datalist').datagrid('reload');
		        	}	
		        }
			});	
	    }
	});
}

function doSearch(value,name){
	cname=value;
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
		arrangeid = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	$('#datalist').datagrid('load',{
		unitid: unitid,
		arrangeid: arrangeid,
		cname: value
	});
}

function recoverCourse(cid){
	$.messager.confirm("提示",'是否要恢复所选课程 ?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/course/recoverCourse",
	            async: false, 
	            type: "POST",
	            data: { "c_id":cid+"" },
	            success: function (data) {
	            	if(data){
	            		toastr.warning(data);
	            	}else{
	            		$('#datalist').datagrid('reload');
	            	}
	     		}
	     	});
	    }
	});	
}

function delCourseAll(cid){
	$.messager.confirm("提示",'彻底删除课程，包括：课程、课程参数、主题词、题型、所有试题，教师权限信息修正、试卷、学生作答记录，该操作不可逆，请确认是否彻底删除?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/course/delCourseAll",
	            async: false, 
	            type: "POST",
	            data: { "cid":cid+"" },
	            success: function (data) {
	            	if(data){
	            		toastr.warning(data);
	            	}else{
	            		$('#datalist').datagrid('reload');
	            	}
	     		}
	     	});	
	    }
	});	
}

function delCourseNotPaper(cid){
	$.messager.confirm("提示",'彻底删除课程，包括：课程、课程参数、主题词、题型、所有试题，教师权限信息修正，不包括试卷、学生作答记录，该操作不可逆，请确认是否彻底删除?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/course/delCourseNotPaper",
	            async: false, 
	            type: "POST",
	            data: { "cid":cid+"" },
	            success: function (data) {
	            	if(data){
	            		toastr.warning(data);
	            	}else{
	            		$('#datalist').datagrid('reload');
	            	}
	     		}
	     	});	
	    }
	});	
}

function gotoPreviewCourse(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/previewCourse?c_id=" + cid,
		fit:true,
		title:'查看课程'
	},0);
}

function viewCourse(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/course/viewCourse?c_id=" + cid,
		fit:true,
		title:'查看课程'
	},0);
}

</script>	

