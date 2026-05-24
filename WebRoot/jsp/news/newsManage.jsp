<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
 <style>
    .news-link {
        color: inherit !important; /* 继承父元素颜色 */
        text-decoration: none !important; /* 可选：去除下划线 */
    }
 </style>
<div id="dlg-toolbar" style="height:auto;">
<table>
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<c:if test="${isOperationTeaching ne 1}">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="toAddNew()">新增公告</a>
			</c:if>
		</td>		
	</tr>
</table>
</div>
<input type="hidden" id="msg" value="${msg}"/>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/news/getNewsList',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3,20*2,20*3,20*4,20*5,200],
		fitColumns: true,
		queryParams: {
			type: ${isOperationTeaching eq 1}?1:"",
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'ID',checkbox:true},//var date = new Date(val)
			  {field:'TITLE',title:'标题',width:80,align:'left',sortable:true,formatter:function(value,row,index){
                   return '<a href="javascript:void(0)" class="news-link" onclick="viewNews(\''+row.ID+'\')">'+value+'</a>';
              }},
			  {field:'FBR',title:'发布人',width:30,align:'left',sortable:true},
			  {field:'ADDTIME',title:'发布时间',width:30,align:'left',sortable:true},
			  {field:'TYPE',title:'公告类型',width:20,align:'left',formatter:function(value,row,index){
              					return row.TYPE=="1"?"操作指南":"公告";
              				}},
			  {field:'OPERATION',title:'操作',width:30,align:'left',formatter:function(value,row,index){
			  	  var s1 = '<a href="javascript:void(0);" class="viewNews" onclick="viewNews(\''+row.ID+'\')"></a>';
	        	  var s2 = '<a href="javascript:void(0);" class="editNews" onclick="editNews(\''+row.ID+'\')"></a>';
	        	  var s3 = '<a href="javascript:void(0);" class="delNews" onclick="delNews(\''+row.ID+'\')"></a>';
				  if(${isOperationTeaching eq 1}){
					  s2 = '';
					  s3 = '';
				  }
        		  return s1 + s2 + s3;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewNews').linkbutton({text:'详情',plain:true});
	    	$('.editNews').linkbutton({text:'编辑',plain:true});
	    	$('.delNews').linkbutton({text:'删除',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons})
	
});

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}


function delNews(id){
	$.messager.confirm('删除公告','系统公告删除将无法恢复，确定删除当前公告内容？',function(r){
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/news/delNew",
	            async: false, 
	            type: "POST",
	            data: { "id":id+"" },
	            success: function (data) {
	             	if(data=='1'){
	             		$('#datalist').datagrid('reload');           		
	             	}else{
	             		toastr.warning(data);
	             	}
	     		}
	     	});	
	    }
	});
}


function editNews(id){
	var url = '${pageContext.request.contextPath}/news/inEditNew?id='+id;
	openIframeDialog({
		url:url,
		fit:true,
		title:'编辑公告'
	},1);
}

function toAddNew(){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/news/inAddNew",
		fit:true,
		title:'新增公告'
	},1);
}

function viewNews(id){
	var url = '${pageContext.request.contextPath}/news/getNews?id='+id;
	/*var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '查看成绩',
		content: content,
		closable: true 
	});*/
	openIframeDialog({
		url:url,
		fit:true,
		title:'查看详情'
	},0);
}
</script>