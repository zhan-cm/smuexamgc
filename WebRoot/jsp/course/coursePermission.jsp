<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<style>
label{
	font-weight:bold;
}
</style>

<div id="dlg-toolbar" style="height:auto;">
	<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<th style="text-align:center;font-size: 20px;margin: 5px;">《${cname}》权限设置</th>
	</tr>
</table>
<table>
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="save()">保存</a>
			<input type="hidden" id="errorInfo" value="${sessionScope.errorInfo}"/>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="roleFilter" type="text" name="roleFilter" style="width:190px;" />
			<input id="departmentFilter" type="text" name="departmentFilter" style="width:190px;" />
			<a href='${pageContext.request.contextPath}/course/inAddCoursePermission?cid=${cid}&cname=${cname}' class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增教师权限到本课程</a>
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
<table id="datalist"></table>
<script type="text/javascript">
var cid = "${cid}";
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
	});
	return rs;
}
function getAllPermissionsToView(){
	var rs = '';
	$.ajax({
		url: "${pageContext.request.contextPath}/common/getAllPermissionToView",
		async: false,
		type: "POST",
		data: {"cid": cid},
		success: function(data){
			rs = data;
		}
	});
	return rs;
}
var myPer = getPermissions();
var allPer = getAllPermissionsToView();
var cp = allPer.cp;
var pp = allPer.pp;
var qp = allPer.qp;
let cpHasAll = true;
let ppHasAll = true;
let qpHasAll = true;
for(let i=0;i<cp.length;i++){
	for(let j=0;j<myPer.cp.length;j++){
		if(myPer.cp[j].ID === cp[i].ID){
			cp[i].inThisTeacher = true;
			break;
		}
	}
	if(!cp[i].inThisTeacher){
		cpHasAll = false;
	}
}
for(let i=0;i<pp.length;i++){
	for(let j=0;j<myPer.pp.length;j++){
		if(myPer.pp[j].ID === pp[i].ID){
			pp[i].inThisTeacher = true;
			break;
		}
	}
	if(!pp[i].inThisTeacher){
		ppHasAll = false;
	}
}
for(let i=0;i<qp.length;i++){
	for(let j=0;j<myPer.qp.length;j++){
		if(myPer.qp[j].ID === qp[i].ID){
			qp[i].inThisTeacher = true;
			break;
		}
	}
	if(!qp[i].inThisTeacher){
		qpHasAll = false;
	}
}
$(document).ready(function(){
	$("#datalist").datagrid({
		fit: true,
		striped: true,
		singleSelect: false,
		checkOnSelect:false,
		selectOnCheck: true,
		url:"${pageContext.request.contextPath}/course/getTeacherInCourse?cid="+cid,
		pagination: true,
		rownumbers: false,
		pageSize: 50,
		pageList:[50,100,200],
		fitColumns: true,
		toolbar: '#dlg-toolbar',
		columns:[[
			{field:'allPer',checkbox:true},
			{field:'index',title:'序号',width:10, align: 'center',formatter:function(val,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
			     return (pageSize * (currentPage -1))+(index+1);
			    }},
			{field:'USERNAME',title:'用户名',width:40,align:'left'},
			{field:'NAME',title:'实名',width:40,align:'left'},
			{field:'RNAME',title:'角色',width:40,align:'left'},
			{field:'UNIT',title:'所属学院',width:80,align:'left'},
			{field:'DEPT',title:'所属科室',width:60,align:'left'},
			{field:'per',title:'权限',width:220,align:'left',formatter:function(value,row,index){
				var tper = row.per;
				var s0 = '<div class="perList">';
				var s1 = '课程';
				if(cpHasAll){
					s1 += '<label><input type="checkbox" onclick="checkAll(\'cper\',this)"/>全选课程权限</label>';
				}
				var s2 = '试卷'
				var s3 = '试题';
				if(qpHasAll){
					s3 += '<label><input type="checkbox" onclick="checkAll(\'qper\',this)"/>全选试题权限</label>';
				}
				var s4 = '<input type="hidden" class="uid" value="'+row.TID+'"/>'
                    s4 += '<input type="hidden" class="username" value="'+row.USERNAME+'"/>'
					s4 += '<input type="hidden" class="name" value="'+row.NAME+'"/>'
				s4 += '<input type="hidden" class="rid" value="'+row.RID+'"/>'
				for(let i=0;i<cp.length;i++){
					let b = false;
					for(var j=0;j<tper.length;j++){
						if(tper[j]==cp[i].ID){
							b = true;
							break;
						}
					}
					let disabledAttr = cp[i].inThisTeacher?" ":" disabled ";
					if(b){
						if(cp[i].ID==11){
							s1 += '<label><input class="per cview" type="checkbox" name="cper" value="'+cp[i].ID+'" checked="checked"'+disabledAttr+'/>'+cp[i].NAME+'</label>';
						}else{
							s1 += '<label><input class="per" type="checkbox" name="cper" value="'+cp[i].ID+'" checked="checked"'+disabledAttr+'/>'+cp[i].NAME+'</label>';
						}
					}else{
						if(cp[i].ID==11){
							s1 += '<label><input class="per cview" type="checkbox" name="cper" value="'+cp[i].ID+'"'+disabledAttr+'/>'+cp[i].NAME+'</label>';
						}else{
							s1 += '<label><input class="per" type="checkbox" name="cper" value="'+cp[i].ID+'"'+disabledAttr+'/>'+cp[i].NAME+'</label>';
						}
					}
				}
				s1 += '</br>'
				for(var i=0;i<pp.length;i++){
					var b = false;
					for(var j=0;j<tper.length;j++){
						if(tper[j]==pp[i].ID){
							b = true;
							break;
						}
					}
					let disabledAttr = pp[i].inThisTeacher?" ":" disabled ";
					if(b){
						if(pp[i].ID==31){
							s2 += '<label><input class="per pview" type="checkbox" name="pper" value="'+pp[i].ID+'" checked="checked"'+disabledAttr+'/>'+pp[i].NAME+'</label>';
						}else{
							s2 += '<label><input class="per" type="checkbox" name="pper" value="'+pp[i].ID+'" checked="checked"'+disabledAttr+'/>'+pp[i].NAME+'</label>';
						}
					}else{
						if(pp[i].ID==31){
							s2 += '<label><input class="per pview" type="checkbox" name="pper" value="'+pp[i].ID+'"'+disabledAttr+'/>'+pp[i].NAME+'</label>';
						}else{
							s2 += '<label><input class="per" type="checkbox" name="pper" value="'+pp[i].ID+'"'+disabledAttr+'/>'+pp[i].NAME+'</label>';
						}
					}
				}
				s2 += '</br>'
				for(var i=0;i<qp.length;i++){
					var b = false;
					for(var j=0;j<tper.length;j++){
						if(tper[j]==qp[i].ID){
							b = true;
							break;
						}
					}
					let disabledAttr = qp[i].inThisTeacher?" ":" disabled ";
					if(b){
						if(qp[i].ID==21){
							s3 += '<label><input class="per qview" type="checkbox" name="qper" value="'+qp[i].ID+'" checked="checked"'+disabledAttr+'/>'+qp[i].NAME+'</label>';
						}else{
							s3 += '<label><input class="per" type="checkbox" name="qper" value="'+qp[i].ID+'" checked="checked"'+disabledAttr+'/>'+qp[i].NAME+'</label>';
						}
					}else{
						if(qp[i].ID==21){
							s3 += '<label><input class="per qview" type="checkbox" name="qper" value="'+qp[i].ID+'"'+disabledAttr+'/>'+qp[i].NAME+'</label>';
						}else{
							s3 += '<label><input class="per" type="checkbox" name="qper" value="'+qp[i].ID+'"'+disabledAttr+'/>'+qp[i].NAME+'</label>';
						}
					}
					if(i==5){
						s3 += '</br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
					}
				}
				s3 += '</br>'
				return s0 + s1 + s3 + s4 + s2+ '</div>';
			}},
		]],
		onCheck: function(index, row) {
			// index 对应行号，row 是这行的数据
			handleSingleCheck(index, row, true);
		},

		// 单行取消选中
		onUncheck: function(index, row) {
			handleSingleCheck(index, row, false);
		},

		// 全部行被选中（点击左上角 checkbox）
		onCheckAll: function(rows) {
			rows.forEach(function(row, idx){
				handleSingleCheck(idx, row, true);
			});
		},

		// 全部行取消选中
		onUncheckAll: function(rows) {
			rows.forEach(function(row, idx){
				handleSingleCheck(idx, row, false);
			});
		}
	})
	
	$('#departmentFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getDepartment',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属科室',width:169}
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
	    		uname: $("#searchName").val(),
	    		unitid:unitid,
	    		roleid:roleid,
	    		depid:depid
			});
	    },
		onLoadSuccess:function(){
	        $("#departmentFilter").combogrid('setValue', '所属科室');
	    }
	});
	
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
	    		uname: $("#searchName").val(),
	    		unitid:unitid,
	    		roleid:roleid,
	    		depid:depid
			});
	    },
		onLoadSuccess:function(){
	        $("#roleFilter").combogrid('setValue', '所属角色');
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
	    		uname: $("#searchName").val(),
	    		unitid:unitid,
	    		roleid:roleid,
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
	
	
});

function handleSingleCheck(index, row, isChecked) {
	// row.TID / row.USERNAME / row.NAME / row.RID 都在 row 里
	// 根据 isChecked 去处理每行的权限复选框状态
	var perListElt = $(".perList").eq(index);
	if (isChecked) {
		// 选中时要恢复默认权限
		var defPer = getPermissionsByRID(row.RID);
		perListElt.find(".per").each(function(){
			var pid = $(this).val();
			if (defPer.some(p=>p.id==pid)) {
				$(this).prop("checked", true);
			}
		});
	} else {
		// 取消时全都去掉勾
		perListElt.find(".per").prop("checked", false);
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
		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	$('#datalist').datagrid('load',{
		uname: $("#searchName").val(),
		unitid:unitid,
		roleid:roleid,
		depid:depid
	});
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

function save(){
	var params = {};
	var data = [];
	$.each($(".perList"),function(i,item){
		var p = {};
		var per = [];
		$.each($(item).find(".per"),function(i,it){
			if($(it).attr('checked')){
				per.push($(it).val());
			}
		})
		p["uid"] = $(item).find(".uid").val();
		p["username"] = $(item).find(".username").val();
		p["name"] = $(item).find(".name").val();
		p["cper"] = per;
		data.push(p);
	});
	params["cid"] = cid;
	params["data"] = data;
	
	$.ajax({
		contentType: "application/json; charset=utf-8",
		url: "${pageContext.request.contextPath}/course/updateCourseTeacherPermission",
		async: false,
		type: "POST",
		data: JSON.stringify(params),
		success: function(data){
			$('#datalist').datagrid('reload');
			toastr.success('权限更新成功，重新登录后生效！');
		}
	})
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

function checkAll(name,alt){
	var $div=$(alt).parent().parent();
	var ischecked=0;
	if($(alt).attr("checked")){ 
		ischecked=1;
	}
	$div.find("input[name="+name+"]").each(function(index){
		if(ischecked==1){
			$(this).attr("checked","checked");
		}else{
			if($(this).val()!="11"){
				$(this).removeAttr("checked");
			}
			
		}
	});
}
</script>