<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
</style>
<div id="dlg-toolbar" style="height:26px;">
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.location.href='${pageContext.request.contextPath}/system/params';" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0);" onclick="addSpecialty()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增专业</a>
			<a href="javascript:void(0);" onclick="getDelSpecialty()" class="easyui-linkbutton" id="delSpecialty" data-options="iconCls:'icon-book',plain:true">已删除的专业</a>
			<a href="javascript:void(0)" onclick="getSpecialty()" class="easyui-linkbutton" id="getSpecialty" data-options="iconCls:'icon-book',plain:true">启用的专业</a>
			<a href="javascript:void(0)" onclick="updateStudentSpecialtyInSelf()" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_switch',plain:true">同步学生specialty字段</a>
			请输入查询专业或单位：<input type="text" id="searchBox" style="width:150px"/>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="doSearch()">查询</a>
		</td>		
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
$(document).ready(function(){
	getSpecialty();
});

function getSpecialty(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getSpecialtyList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[10,10*2,10*3,10*5,10*10,10*20],
		fitColumns: true,
		queryParams: {
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'t.name',title:'专业',width:20,align:'center',sortable:true,formatter:function(value,row,index){
				  if(row.SNAME != 'null'){
					  return row.SNAME;
				  }
			  }},
			  {field:'u.name',title:'所属学院',width:20,align:'center',sortable:true,formatter:function(value,row,index){
				  return row.UNAME;
			  }},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
				  var s1 = '<a href="javascript:void(0);" onclick="editSpecialty(\''+ row.ID +'\',\''+ row.SNAME +'\',\''+ row.UNAME +'\',\''+row.UNITID+'\')" class="editSpecialty"></a>';
	        	  var s2 = '<a class="delSpecialty" onclick="delSpecialty(\''+row.ID+'\')"></a>';
	        	  return s1 + s2;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editSpecialty').linkbutton({text:'编辑',plain:true});
	        $('.delSpecialty').linkbutton({text:'删除',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	$("#getSpecialty").hide();
	$("#delSpecialty").show();
}

function getDelSpecialty(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getSpecialtyList?del=1',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[10,10*2,10*3,10*5,10*10,10*20],
		fitColumns: true,
		toolbar:'#dlg-toolbar',
		columns:[[
			{field:'t.name',title:'专业',width:20,align:'center',sortable:true,formatter:function(value,row,index){
				  if(row.SNAME != 'null'){
					  return row.SNAME;
				  }
			  }},
			  {field:'u.name',title:'所属学院',width:20,align:'center',sortable:true,formatter:function(value,row,index){
				  return row.UNAME;
			  }},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="javascript:void(0);" onclick="recSpecialty(\''+ row.ID +'\')" class="recovery"></a>';
// 	        	  var s2 = '<a class="delSpecialty" onclick="delSpecialty(\''+row.ID+'\')"></a>';
	        	  return s1;
	          }}
		]],
		onLoadSuccess:function(data){
			$('.recovery').linkbutton({text:'恢复',plain:true});
// 		    $('.delSpecialty').linkbutton({text:'删除',plain:true});
		}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	$("#getSpecialty").show();
	$("#delSpecialty").hide();
}

var specialtyname = '';
function editSpecialty(id, sname, uname, uid){	
	var rs = '';
	$.ajax({
		url:'${pageContext.request.contextPath}/system/getAllUnit',
		async: false,
        type: "POST",
        success:function(data){
        	rs = data;
        }
	});
	$("input[name=sname]").val(null);	
	specialtyname = sname;
	var winStr = '<form id="editSForm" method="post"><table width="100%">';
		winStr += '<tr><td align="right">专业所属学院：</td>'
		winStr += '<td align="left">'
		winStr += '<select style="width:220px;" name="uid">'
		for(var i=0;i<rs.length;i++){
			if(uid == rs[i].ID){
				winStr += '<option value="'+rs[i].ID+'" selected="selected">'+rs[i].NAME+'</option>'
			}else{
				winStr += '<option value="'+rs[i].ID+'">'+rs[i].NAME+'</option>'
			}
			
		}
		winStr += '</select>'
// 		winStr += '<input type="text"  value="' + uname + '" style="width:220px;"  disabled="disabled"/>'
		winStr += '</td></tr>'
		winStr += '<tr><td align="right">开设专业：</td>'
		winStr += '<td align="left"><input type="text" name="sname" value="' + sname + '" style="width:220px;"/></td></tr>'
		winStr += '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		winStr += '<input type="hidden" name="id" value="' + id + '"/>'
// 		winStr += '<input type="hidden" name="uid" value="'+uid+'"/>'
		winStr += '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="updateSForm()">'
		winStr += '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		winStr += '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		winStr += '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:160,
		modal:true,
		title:"编辑专业",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function updateSForm(){
	$('#editSForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/updateSpecialty',
// 	    onSubmit: function(){	 
// 	    	var val = $.trim($("input[name=sname]").val());
// 	    	if(specialtyname != val){
// 	    		return valSpecialty();
// 	    	}	
// 	    },
	    success:function(data){
	    	if(data == 1){
	    		$('#win').window('close');
	        	$('#datalist').datagrid('reload');
	        	toastr.success('修改成功');
	    	}else if(data==2){
	    		toastr.warning('您输入的专业不可为空');
	    	}else{
	    		toastr.warning('您输入的专业重复，您可以在已删除专业处恢复该专业或者重新输入其他专业名称');
	    	}
	    }
	});
}

function doSearch(){ 
	$('#datalist').datagrid('load',{
		name: $('#searchBox').val()
	});
}

function addSpecialty(){	
	$("input[name=sname]").val(null);
	var unitList = '';	
	$.ajax({
        url: "${pageContext.request.contextPath}/system/getAllUnit",
        async: false,
        type: "POST",
        traditional: true,
        data: { },
        success: function (data) {
        	for(var i=0; i<data.length; i++){
        		unitList += "<option value='" + data[i].ID+ "'>" + data[i].NAME+ "</option>";
        	}
        }
	});
	var winStr = '<form id="SForm" method="post"><table width="100%">'
		+ '<tr><td align="right">专业所属学院：</td>'
		+ '<td align="left"><select style="width:220px;" name="uid">' + unitList + '</select></td></tr>'
		+ '<tr><td align="right">开设专业：</td>'
		+ '<td align="left"><input type="text" name="sname" style="width:220px;"/></td></tr>'
		+ '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitSForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:160,
		modal:true,
		title:"新增专业",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function submitSForm(){
	$('#SForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/addSpecialty',
// 	    onSubmit: function(){	    	
// 	    	return valSpecialty();
// 	    },
	    success:function(data){
	    	if(data==1){
	    		$('#win').window('close');
        		$('#datalist').datagrid('reload');
        		toastr.success('添加成功');
	    	}else if(data==2){
	    		toastr.warning('您输入的专业不可为空');
	    	}else{
	    		toastr.warning('您输入的专业重复，您可以在已删除专业处恢复该专业或者重新输入其他专业名称');
	    	}
	    }
	});
}

// function valSpecialty(){
// 	var res = true;
// 	var val = $.trim($("input[name=sname]").val());
// 	if(val==null||val==''){
// 		toastr.warning('专业名称为空，请重新添加');
// 		res = false;
// 	}else{
// 		$.ajax({
// 	        url: "${pageContext.request.contextPath}/system/checkRepeatSpecialty",
// 	        async: false,
// 	        type: "POST",
// 	        traditional: true,
// 	        data: { "sname": val },
// 	        success: function (data) {
// 	        	if(data == "-1"){
// 	        		toastr.warning('专业名称重复，请重新添加');
// 	        		res = false;
// 	        	}
// 	        }
// 		});
// 	}		
// 	return res;
// }

function updateStudentSpecialtyInSelf(){
	$.messager.confirm('更新学生表specialty字段', '将会把专业表的名称更新至学生表（匹配不上specialtyid的数据将会不更新）', function(r){
		if(r){
			$.ajax({
				url: "${pageContext.request.contextPath}/system/updateStudentSpecialtyInSelf",
				async: false,
				type: "POST",
				success: function(data){
					if(data>0){
						toastr.success("已成功更新");
						$("#datalist").datagrid('reload');
					}
				}
			})
		}
	});
}

function recSpecialty(id){
	$.messager.confirm('恢复专业', '您确定把此专业恢复吗？', function(r){
		if(r){
			$.ajax({
				url: "${pageContext.request.contextPath}/system/recSpecialty",
				async: false,
				type: "POST",
				data: {"id":id},
				success: function(data){
					if(data==1){
						toastr.success("已成功恢复");
						$("#datalist").datagrid('reload');
					}
				}
			})
		}
	});
}

function delSpecialty(val){
// 	var rs = '';
// 	$.ajax({
// 		url: "${pageContext.request.contextPath}/system/findCidsBySpecialty",
// 		async: false,
// 		type: "POST",
// 		data: {"id":val},
// 		success:function(data){
// 			rs = data;
// 		}
// 	});
// 	var cname = '';
// 	for(var i=0;i<rs.length;i++){
// 		cname +='<a style="color:red">'+ rs[i].NAME + '</a><br/>';
// 	}
	$.messager.confirm('删除专业', '您确认删除此专业吗？稍后可以在已删除专业找到。', function(r){
		if (r){
			$.ajax({
				url: "${pageContext.request.contextPath}/system/delSpecialty",
				async: false,
				type: "POST",
				data: {"id": val},
				success: function(data){
					if(data == 1){
						toastr.success('删除成功');
						$("#datalist").datagrid('reload');
					}else{
						toastr.warning('删除失败');
					}
				}
			});
		}
	});
	
}
</script>	