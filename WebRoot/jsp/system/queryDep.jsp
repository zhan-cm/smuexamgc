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
</style>
<div id="dlg-toolbar" >
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr><td style="text-align: center; vertical-align: middle;">单位：${uname}</td></tr>
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>			
			<a href="javascript:void(0);" onclick="addDep()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增机构</a>			
			<a href="javascript:void(0);" onclick="getDelDept()" id="getDelDept" class="easyui-linkbutton" data-options="iconCls:'icon-book',plain:true">被删除的机构</a>
			<a href="javascript:void(0);" onclick="getDept()" id="getDept" class="easyui-linkbutton" data-options="iconCls:'icon-book',plain:true">启用的机构</a>
			&nbsp;
		</td>
	</tr>
</table>
<input type="hidden" id="uid" value="${uid}"/>
<input type="hidden" id="uname" value="${uname}"/>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var uid = $('#uid').val();
var uname = $('#uname').val();
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	
	getDept();
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function getDept(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getDepList',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		queryParams: {
			uid:uid
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'NAME',title:'单位名称',width:20,align:'center',sortable:true},
			  {field:'CONTACT',title:'联系人',width:20,align:'center',sortable:true},
			  {field:'TEL',title:'联系电话',width:20,align:'center',sortable:true},
			  {field:'CODE',title:'编码',width:20,align:'center',sortable:true},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="javascript:void(0);" onclick="editDep(\''+ row.ID +'\',\''+ row.NAME +'\',\''+ row.CONTACT +'\',\''+ row.TEL +'\',\''+ row.CODE +'\')" class="editDep"></a>';
	        	  var s2 = '<a class="delDep" onclick="delDep(\''+ row.ID +'\')"></a>';
	        	  return s1 + s2;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editDep').linkbutton({text:'编辑',plain:true});
	        $('.delDep').linkbutton({text:'删除',plain:true});
	    }
	});
	
	$("#getDelDept").show();
	$("#getDept").hide();
}

function getDelDept(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getDepList?del=1',
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		queryParams: {
			uid:uid
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'NAME',title:'单位名称',width:20,align:'center',sortable:true},
			  {field:'CONTACT',title:'联系人',width:20,align:'center',sortable:true},
			  {field:'TEL',title:'联系电话',width:20,align:'center',sortable:true},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="javascript:void(0);" onclick="recDept(\''+ row.ID +'\')" class="recDept"></a>';
	        	  return s1;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.recDept').linkbutton({text:'恢复',plain:true});
	    }
	});
	
	$("#getDept").show();
	$("#getDelDept").hide();
}

function recDept(id){
	$.messager.confirm('恢复部门','是否确认恢复部门？',function(r){
		if(r){
			$.ajax({
				url:"${pageContext.request.contextPath}/system/recDep",
				async:false,
				type: "POST",
				data: {"id": id},
				success:function(data){
					toastr.success("已恢复部门");
					$('#datalist').datagrid('reload');
				}
			})
		}
	});
}

var depname = '';
function editDep(id, dname, contact, tel,code){
	$("input[name=dname]").val(null);
	depname = dname;
	let safeContract = contact === null ||contact === 'null' || contact === undefined ? '' : contact;
	let safeTel = tel === null ||tel === 'null' || tel === undefined ? '' : tel;
	let safeCode = code === null || code === undefined ? 0 : code;
	var winStr = '<form id="editDForm" method="post"><table width="100%">'
		+ '<tr><td align="right">一级单位名称：</td>'
		+ '<td align="left"><input type="text" style="width:220px;" value="' + uname + '" disabled="disabled"/></td></tr>'
		+ '<tr><td align="right">二级单位名称：</td>'
		+ '<td align="left"><input type="text" name="dname" style="width:220px;" value="' + dname + '"/></td></tr>'
			+ '<tr><td align="right">二级单位编码（数字）：</td>'
			+ '<td align="left"><input type="text" name="code" style="width:220px;" value="' + safeCode + '"/></td></tr>'
		+ '<tr><td align="right">二级单位联系人：</td>'
		+ '<td align="left"><input type="text" name="contact" style="width:220px;" value="' + safeContract + '"/></td></tr>'
		+ '<tr><td align="right">联系方式：</td>'
		+ '<td align="left"><input type="text" name="tel" style="width:220px;" value="' + safeTel + '"/></td></tr>'
		+ '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<input type="hidden" name="id" value="' + id + '"/>'
		+ '<input type="hidden" name="uid" value="' +uid+ '"/>'
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="updateDForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:220,
		modal:true,
		title:"编辑机构",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function updateDForm(){
	$('#editDForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/updateDep',
	    success:function(data){
	    	if(data == 0){
	    		toastr.warning("更新失败，请查看部门名称是否有重复或是在被删除机构里");
	    	}else if(data == -1){
	    		toastr.warning("更新失败，机构名不能为空");
	    	}else{
	    		$('#win').window('close');
	        	$('#datalist').datagrid('reload');
	        	toastr.success("更新部门成功");
	    	}
	    }
	});
}

function addDep(){
	$("input[name=dname]").val(null);
	var winStr = '<form id="DForm" method="post"><table width="100%">'
		+ '<tr><td align="right">一级单位名称：</td>'
		+ '<td align="left"><input type="text" style="width:220px;" value="' + uname + '" disabled="disabled"/></td></tr>'
		+ '<tr><td align="right">二级单位名称：</td>'
		+ '<td align="left"><input type="text" name="dname" style="width:220px;"/></td></tr>'
			+ '<tr><td align="right">二级单位编码：</td>'
			+ '<td align="left"><input type="text" name="code" style="width:220px;" value="0"/></td></tr>'
		+ '<tr><td align="right">二级单位联系人：</td>'
		+ '<td align="left"><input type="text" name="contact" style="width:220px;"/></td></tr>'
		+ '<tr><td align="right">联系方式：</td>'
		+ '<td align="left"><input type="text" name="tel" style="width:220px;"/></td></tr>'
		+ '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<input type="hidden" name="uid" value="' + uid + '"/>'
		+ '<input type="hidden" name="uname" value="' + uname + '"/>'
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitDForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:220,
		modal:true,
		title:"新增机构",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function submitDForm(){
	var code = $('input[name="code"]').val();
	if (isNaN(parseFloat(code)) ||!isFinite(code)) {
		toastr.error('编码必须为数字');
		return false;
	}
	$('#DForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/addDep',
	    success:function(data){
	    	if(data == 0){
	    		toastr.warning("新增失败，请查看部门名称是否有重复或是在被删除机构里");
	    	}else if(data == -1){
	    		toastr.warning("新增失败，机构名不能为空");
	    	}else{
	    		$('#win').window('close');
	        	$('#datalist').datagrid('reload');
	        	toastr.success("新增部门成功");
	    	}
	    }
	});
}

// function valDep(){
// 	var res = true;
// 	var val = $.trim($("input[name=dname]").val());
// 	if(val==null||val==''){
// 		toastr.warning('单位名称为空，请重新添加');
// 		res = false;
// 	}else{
// 		$.ajax({
// 	        url: "${pageContext.request.contextPath}/system/checkRepeatDep",
// 	        async: false,
// 	        type: "POST",
// 	        traditional: true,
// 	        data: { "dname":val, "uid":uid},
// 	        success: function (data) {
// 	        	if(data > 0){
// 	        		toastr.warning('单位名称重复，请重新添加');
// 	        		res = false;
// 	        	}
// 	        }
// 		});
// 	}		
// 	return res;
// }

function delDep(val){
	$.messager.confirm('删除部门','是否确认删除部门？',function(r){
		if(r){
			$.ajax({
				url: "${pageContext.request.contextPath}/system/delDep",
				async: false,
				type: "POST",
				data: {"id": val},
				success: function (data){
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