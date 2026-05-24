<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<style>
label{
	font-weight:bold;
}
</style>

<div id="dlg-toolbar" style="height:auto">
	<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="savePermissions()">保存</a>
			<a>课程：${cname} &nbsp;</a>
			<input type="hidden" id="errorInfo" value="${sessionScope.errorInfo}"/>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="roleFilter" type="text" name="roleFilter" style="width:190px;" />
			<input id="departmentFilter" type="text" name="departmentFilter" style="width:190px;" />
			<a href='${pageContext.request.contextPath}/course/inCoursePermission?c_id=${cid}&cname=${cname}' class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改本课程教师权限</a>
		</td>
		<td>
			<input id="searchName" type="text" name="searchName" placeholder="请输入用户名或实名"/>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchName()">搜索</a>
		</td>
	</tr>
</table>
</div>
<input type="hidden" id="userinfo" value="${userInfo}"/>
<input type="hidden" id="msg" value="${msg}"/>
<div id="importTeachers"></div>
<table id="datalist"></table>
<script type="text/javascript">
var cid = "${cid}";
var cname = "${cname}";
function getPermissions(){
	var rs = '';
	$.ajax({
		url: "${pageContext.request.contextPath}/common/getPermission",
		async: false,
		type: "POST",
		data: {"cid": cid},
		success: function(data){
			rs = data;
		}
	})
	return rs;
}
var per = getPermissions();
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		fitColumns:true,
		striped: true,
		singleSelect: false,
		checkOnSelect:false,
		selectOnCheck:true,
		url:'${pageContext.request.contextPath}/course/getTeacherAddPer?cid='+cid,
		pagination: true,
		rownumbers: false,
		pageNumber: 1,
		pageSize: 20,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		toolbar:'#dlg-toolbar',
		columns:[[
		      {field:'allPer',checkbox:true},
			  /*{field:'id',formatter:function(value,row,index){
				var rs = '<input type="checkbox" class="allPer" name="allPer"/>'
				return rs;
			  }},*/
			  //{field:'id',title:'用户ID',width:40,align:'left',sortable:true},
		      {field:'username',title:'用户名',width:40,align:'left',sortable:true},
	          {field:'realname',title:'实名',width:40,align:'left',sortable:true},
	          {field:'role_cname',title:'用户角色',width:40,align:'left',sortable:true},
	          {field:'unit',title:'所属学院',width:40,align:'left',sortable:true},
	          {field:'dep',title:'所属科室',width:40,align:'left',sortable:true},
	          {field:'permission',title:'权限',width:480,formatter:function(value,row,index){  
	        	  var cp = per.cp;
	        	  var qp = per.qp;
	        	  var pp = per.pp;
	        	  var s1 = '课程';
	        	  var s2 = '试题';
	        	  var s3 = '试卷';
	        	  
	        	  for(var i=0;i<cp.length;i++){
        			  if(cp[i].ID==11){
        				  s1 += '<label><input class="per cview" type="checkbox" name="cper" value="'+cp[i].ID+'"/>'+cp[i].NAME+'</label>';
        			  }else{
        				  s1 += '<label><input class="per" type="checkbox" name="cper" value="'+cp[i].ID+'"/>'+cp[i].NAME+'</label>';
        			  }
	        	  }
	        	  s1 += '<br/>';
	        	  
	        	  for(var i=0;i<qp.length;i++){
        			  if(qp[i].ID==21){
        				  s2 += '<label><input class="per qview" type="checkbox" name="qper" value="'+qp[i].ID+'"/>'+qp[i].NAME+'</label>';
        			  }else{
        				  s2 += '<label><input class="per" type="checkbox" name="qper" value="'+qp[i].ID+'"/>'+qp[i].NAME+'</label>';
        			  }
        			  if(i==5){
        				  s2 += '</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
        			  }
	        	  }
	        	  s2 += '<br/>';
	        	  
	        	  for(var i=0;i<pp.length;i++){
        			  if(pp[i].ID==31){
        				  s3 += '<label><input class="per pview" type="checkbox" name="pper" value="'+pp[i].ID+'"/>'+pp[i].NAME+'</label>';
        			  }else{
        				  s3 += '<label><input class="per" type="checkbox" name="pper" value="'+pp[i].ID+'"/>'+pp[i].NAME+'</label>';
        			  }
	        	  }
	        	  s3 += '<br/>';
	        	  var s4 = '<input type="hidden" class="uid" value="'+row.id+'"/>'
					  s4 += '<input type="hidden" class="rid" value="'+row.roleID+'"/>'
					  s4 += '<input type="hidden" class="username" value="'+row.username+'"/>'
					  s4 += '<input type="hidden" class="realname" value="'+row.realname+'"/>'
	        	  return '<div class="perList">' + s1 + s2 + s3 + s4 + '</div>';
	          }}
	    ]],
		// 单行勾选时
		onCheck: function(rowIndex, rowData) {
			applyDefaultPerms(rowIndex, rowData, true);
		},

		// 单行取消勾选时
		onUncheck: function(rowIndex, rowData) {
			applyDefaultPerms(rowIndex, rowData, false);
		},

		// 点击表头「全选」勾上时
		onCheckAll: function(rows) {
			rows.forEach(function(row, idx){
				applyDefaultPerms(idx, row, true);
			});
		},

		// 点击表头「全选」取消时
		onUncheckAll: function(rows) {
			rows.forEach(function(row, idx){
				applyDefaultPerms(idx, row, false);
			});
		}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$('#roleFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getRole',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属角色',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	let unitid = "";
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let roleid = "";
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let depid = "";
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#datalist').datagrid('load',{	    		
	    		unitid:unitid,
	    		roleid:roleid,
	    		uname:$("#searchName").val(),
	    		depid:depid
			});
	    },
		onLoadSuccess:function(){
	        $("#roleFilter").combogrid('setValue', '所属角色');
	    }
	});

	$('#departmentFilter').combogrid({
		
	    url: '${pageContext.request.contextPath}/common/getDepartment',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属科室',width:169}
	    ]],
	    onSelect:function(data){
	    	let roleid = "";
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let unitid = "";
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let depid = "";
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#datalist').datagrid('load',{
	    		depid:depid,
	    		uname:$("#searchName").val(),
	    		roleid:roleid,
	    		unitid:unitid
			});
	    },
		onLoadSuccess:function(){
	        $("#departmentFilter").combogrid('setValue', '所属科室');
	    }
	});
	
	$('#unitFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getUnit',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属学院',width:169}
	    ]],
	    onSelect:function(data){
	    	let unitid = "";
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let roleid = "";
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let depid = "";
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#datalist').datagrid('load',{
	    		unitid:unitid,
	    		roleid:roleid,
	    		uname:$("#searchName").val(),
	    		depid:depid
			});
	    },
		onChange:function(newValue, oldValue){
			var newParams = {
				unitid: newValue
			};
			$('#departmentFilter').combogrid('grid').datagrid('options').queryParams = newParams;
			$('#departmentFilter').combogrid('grid').datagrid('reload');
			$('#departmentFilter').combogrid('setValue', null);
		},
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '所属学院');
	    }
	});
	
	var msg = $("#msg").val();
	if(msg!=''){
		toastr.warning(msg);
	}	
	
});

function applyDefaultPerms(rowIndex, rowData, checked) {
	var perList = $(".perList").eq(rowIndex);
	if (checked) {
		// 如果被勾选，就按角色权限恢复默认勾
		var defPer = getPermissionsByRID(rowData.roleID);
		perList.find(".per").each(function(){
			var pid = $(this).val();
			if (defPer.some(p=>p.id==pid)) {
				$(this).prop("checked", true);
			}
		});
	} else {
		// 取消勾，全部清空
		perList.find(".per").prop("checked", false);
	}
}

function perLock(sumP,carr,qarr,parr,perElt){
	if(findRepeat(sumP, carr) > 0){
		perElt.find('.cview').attr('checked','checked'); 
		perElt.find('.cview').attr('disabled','disabled'); 
		if($.inArray('11', sumP) == -1){
			sumP.push('11');
		}
	}
	if(findRepeat(sumP, qarr) > 0){
		perElt.find('.qview').attr('checked','checked'); 
		perElt.find('.qview').attr('disabled','disabled'); 
		perElt.find('.cview').attr('checked','checked'); 
		perElt.find('.cview').attr('disabled','disabled'); 
		if($.inArray('11', sumP) == -1){
			sumP.push('11');
		}
		if($.inArray('21', sumP) == -1){
			sumP.push('21');
		}
	}
	if(findRepeat(sumP, parr) > 0){
		perElt.find('.pview').attr('checked','checked');
		perElt.find('.pview').attr('disabled','disabled'); 
		if($.inArray('31', sumP) == -1){
			sumP.push('31');
		}
	}
}

function findRepeat(a,b){
	var r=0;
	for(var i=0;i<a.length;i++){
		for(var j=0;j<b.length;j++){
			if(a[i]==b[j]){
				r++;
			}
		}
	}
	return r;
}

function getPermissionsByRID(rid){
	var rs = ''
	$.ajax({
		url: "${pageContext.request.contextPath}/permission/getPermissionsByRID",
		async: false,
		type:"POST",
		data: {"rid": rid},
		success:function(data){
			rs = data;
		}
	})	
	return rs;
}

function searchName(){
	var roleid = "";
	var unitid = "";
	var depid = "";
	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	$('#datalist').datagrid('load',{
		uname: $("#searchName").val(),
		unitid:unitid,
		roleid:roleid,
		depid:depid
	});
}

//查看教师是否有某个权限
// function checkTeacherPermissions(per,id){
// 	var flag = false;
// 	for(var i=0;i<per.length;i++){
// 		if(id==per[i].id){
// 			flag = true;
// 			break;
// 		}
// 	}
// 	return flag;
// }

function savePermissions(){
	var params = {};
	var data = [];
	$.each($('.perList'),function(i,item){
		var c = $(item);
		var uid = c.find('.uid');
		var per = [];
		var p = {};			
		$.each(c.find('.per'),function(i,item){
			if($(item).attr('checked')){
				per.push($(item).val());
			}
		})
		
		p["uid"] = uid.val();
		p["username"] = $(item).find(".username").val();
		p["tname"] = $(item).find(".realname").val();
		p["cper"] = per;
		data.push(p);
	});
	params["data"] = data;
	params["cid"] = cid;
// 	console.log(params);
	
	$.ajax({
		contentType: "application/json; charset=utf-8",
		url: "${pageContext.request.contextPath}/course/editCoursePermission",
		async: false,
		type: "POST",
		data: JSON.stringify(params),
		success: function (data){
			$('#datalist').datagrid('reload');
			toastr.success("添加成功");
		}
	})
}


// function clickPer(id){
// 	var cols = $('#cols'+id);
// 	$.each(cols.find('.per'),function(i,item){
// 		carr = new Array('12','13');
// 		qarr = new Array('23','24','26','28','29');
// 		parr = new Array('33','34','35','36','37');
// 		$(item).click(function(){
// 			var val = $(item).val();
// 			if($(item).attr('checked')){
// 				if($.inArray(val, carr) > -1){
// 					cols.find('.cview').attr('checked','checked'); 
// 					cols.find('.cview').attr('disabled','disabled'); 
// 				}
// 				if($.inArray(val, qarr) > -1){
// 					cols.find('.qview').attr('checked','checked'); 
// 					cols.find('.qview').attr('disabled','disabled'); 
// 				}
// 				if($.inArray(val, parr) > -1){
// 					cols.find('.pview').attr('checked','checked');
// 					cols.find('.pview').attr('disabled','disabled'); 
// 				}
// 			}else{
// 				if($.inArray(val, carr) > -1){
// 					cols.find('.cview').removeAttr('disabled'); 
// 				}
// 				if($.inArray(val, qarr) > -1){
// 					cols.find('.qview').removeAttr('disabled');
// 				}
// 				if($.inArray(val, parr) > -1){
// 					cols.find('.pview').removeAttr('disabled'); 
// 				}
// 			}
// 		});
// 	})
// }

</script>	

