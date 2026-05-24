<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">	
	
<div id="dlg-toolbar" style="height:auto;">
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<input type="hidden" id="errorInfo" value="${sessionScope.errorInfo}"/>
			<a href="${pageContext.request.contextPath}/users/toAddUser" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" >新增教师</a>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="roleFilter" type="text" name="roleFilter" style="width:190px;" />
			<input id="departmentFilter" type="text" name="departmentFilter" style="width:190px;" />
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="importTeachers(1)">导入教师列表</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="importTeachers(2)">更新教师列表</a>
		</td>
		<td style="padding-right:6px; padding-top:3px; font-size:15px;" align="left">
			<input class="easyui-searchbox" id="searchFilter" data-options="prompt:'请使用用户名或实名查询',searcher:doSearch" style="width:150px;"></input>
		</td>
	</tr>
</table>
</div>
<input type="hidden" id="msg" value="${msg}"/>
<div id="importTeachers"></div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/users/getUserList',
		pagination: true,
		rownumbers: false,
		pageSize: 50,
		pageList:[10,10*2,10*3,10*5,10*10,10*20],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'C_ID',
		columns:[[
			  {field:'id',checkbox:true},
			  //{field:'id',title:'用户ID',width:40,align:'left',sortable:true},
		      {field:'username',title:'用户名',width:40,align:'left',sortable:true},
	          {field:'realname',title:'实名',width:20,align:'left',sortable:true},
	          {field:'role_cname',title:'用户角色',width:20,align:'left',sortable:true},
	          {field:'idcard',title:'身份证号',width:40,align:'left',sortable:true,formatter:function(value,row,index){
					if(row.idcard != null&&row.idcard != 'null'&&row.idcard!=''){
					    var idcard=row.idcard;
					    if(idcard.length>6){
					    	//只保留前4位和后3位
                            idcardTemp=idcard.substring(4,15);
                            idcard =idcard.replace(idcardTemp, '***********')
						}
						return idcard;
					}
				}},
	          {field:'unit',title:'所属学院',width:20,align:'left',sortable:true},
	          {field:'dep',title:'所属科室',width:20,align:'left',sortable:true},
	          {field:'loginTime',title:'最后登录时间',width:30,align:'left',formatter:function(value,row,index){
	        	  if(row.loginTime==null){
	        		  return "此用户尚未登录本系统";
	        	  }else{
	        		  return new Date(row.loginTime).format("yyyy-MM-dd hh:mm:ss");
	        	  }
	          }},
			   {field:'email',title:'邮箱',width:30,align:'center',formatter:function(value,row,index){
			       var s ="";
			       if(row.email==""||row.email==null){
			           s="无";
				   }else{
			           s=row.email;
				   }
				   return s;
				   }},
	          {field:'locked',title:'状态',width:20,align:'left',formatter:function(value,row,index){
	        	  //console.log(row);
	        	  var s = '';
	        	  if(row.state == true){
	        		  s = '正常';
	        	  }else if(row.state == false){
	        		  s = '已关闭'
	        	  }
	        	  return s;
	          }},
	          {field:'opration',title:'操作',width:100,align:'center',formatter:function(value,row,index){
	          	var s1 = "";
	          	var s2 = "";
	          	var s3 = "";
	          	var s4 = "";
	          	var s5 = "";
	          	var s6 = "";
	          	var s7 = "";
	          	var s8 = "";
	          	if(row.roleID!="1"){
	          	    if(row.state == false){
                        s1 = '<a href="javascript:void(0);" class="editUser" style="color: lightgrey"></a>';
					}else{
                        s1 = '<a href="javascript:void(0);" class="editUser" onclick="editUser(\''+row.id+'\')"></a>';
					}
		        	 s2 = '<a href="javascript:void(0);" onclick="editUserPermission(\''+row.id+'\')" class="editUserPermission"></a>';
		        	 s3 = '<a href="javascript:void(0);" onclick="addPerFromUnit(\''+row.id+'\')" class="addUserPermission"></a>';
		        	 s4 = '';
		        	 <shiro:hasRole name="administrator">s4 = '<a href="javascript:void(0);" class="delUser" onclick="delUser(\''+row.id+'\')"></a>';</shiro:hasRole>

		        	 <shiro:hasAnyRoles name="administrator,dean,teachingoffice">
						if(row.state == '1'){
							s5 = "<a href=\"javascript:void(0);\"  style=\" text-decoration: none;\" class=\"alterUserState\" onclick=\"alterUserState('"+row.id+"','"+row.state+"','"+row.username+"')\">关闭</a>";
						}else{
							s5 = "<a href=\"javascript:void(0);\"  style=\" text-decoration: none;\" class=\"alterUserState_hf\" onclick=\"alterUserState('"+row.id+"','"+row.state+"','"+row.username+"')\">恢复正常</a>";
						}
					</shiro:hasAnyRoles>
		        	 <shiro:hasAnyRoles name="administrator,dean,teachingoffice,secretary">s7 = '<a href="javascript:void(0)" class="resetPassword" onclick="resetPassword(\''+ row.id +'\')"></a>';</shiro:hasAnyRoles>
		        	 <shiro:hasAnyRoles name="administrator,dean,teachingoffice">s8 = '<a href="javascript:void(0)" class="unlockEmail" onclick="unlockEmail(\''+ row.id +'\')"></a>';</shiro:hasAnyRoles>
		        	 return s1 + s2 + s3 + s4 + s5 + s7+s8;
	          	}else{
                    s6 = '';
                    <shiro:hasAnyRoles name="administrator,dean">s6 = '<a href="javascript:void(0)" class="noaction" onclick="resetPassword(\''+ row.id +'\')"></a>';</shiro:hasAnyRoles>
	          		return s6;
	          	}
	        	 
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editUser').linkbutton({text:'编辑用户',plain:true});
	        $('.editUserPermission').linkbutton({text:'课程权限',plain:true});
	        $('.addUserPermission').linkbutton({text:'课程新增',plain:true});
			$('.alterUserState').linkbutton({text:'关闭',plain:true});
			$('.alterUserState_hf').linkbutton({text:'恢复',plain:true});   
	        $('.resetPassword').linkbutton({text:'重置密码',plain:true});
	        $('.unlockEmail').linkbutton({text:'解锁邮箱',plain:true});
	        $('.noaction').linkbutton({text:'重置管理员密码',plain:true});
	        $('.delUser').linkbutton({text:'删除',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	var unitid = null;  	
	$('#roleFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getRole',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属角色',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	var unitid = null;
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	var depid = null;
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	var roleid = null;
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	
	    	$('#datalist').datagrid('load',{	    		
	    		unitid:unitid,
	    		depid:depid,
	    		roleid:roleid
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
	    	var roleid = null;
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	    	
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}else{
	    		unitid = null;
		    	}
	    	var depid1 = null;  	
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid1 = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#departmentFilter').combogrid({
			    url: '${pageContext.request.contextPath}/common/getDepartment?unitid='+unitid,
			    idField: 'ID',
			    textField: 'NAME',
			    editable: false,
			    columns: [[
					{field:'NAME',title:'所属科室',width:169}
			    ]],
			    onSelect:function(data){
			    	var roleid = "";
			    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
			    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
			    	}
			    	var unitid = "";
			    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
			    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
			    	}
			    	var depid1 = null;  	
			    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
			    		depid1 = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
			    	}
			    	$('#datalist').datagrid('load',{
			    		depid:depid1,
			    		roleid:roleid,
			    		unitid:unitid
					});
			    },
				onLoadSuccess:function(){
			        $("#departmentFilter").combogrid('setValue', '所属科室');
			    }
			});
	    	$('#datalist').datagrid('load',{
	    		unitid:unitid,
	    		roleid:roleid,
	    		depid:depid1
			});
	    },
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '所属学院');
	    }
		
	});
	
	$('#departmentFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getDepartment?unitid='+unitid,
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'所属科室',width:169}
	    ]],
	    onSelect:function(data){
	    	var roleid = null;
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	var unitid = null;
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	var depid = null;
	    	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}	    	
	    	$('#datalist').datagrid('load',{
	    		depid:depid,
	    		roleid:roleid,
	    		unitid:unitid
			});
	    },
		onLoadSuccess:function(){
	        $("#departmentFilter").combogrid('setValue', '所属科室');
	    }
	});
	
	var msg = $("#msg").val();
	if(msg!=''){
		toastr.warning(msg);
	}
});

function alterUserState(id,state,username){

	if(state ==1){
		$.messager.confirm('警告', '是否锁定该账户?', function(r){
			if (r){
				$.ajax({
					url: "${pageContext.request.contextPath}/users/alterUserState",
					async: false,
					type: "POST",
					data:{"id":id,"state":0,"username":username},
					success: function (data) {
						if(data=='1'){
							toastr.success("关闭成功！");
						}else{
							toastr.error("关闭失败！");
						}
					}
				});
			}
		});
	}else{
		$.messager.confirm('警告', '是否恢复正常该账户?', function(r){
			if (r){
				$.ajax({
					url: "${pageContext.request.contextPath}/users/alterUserState",
					async: false,
					type: "POST",
					data:{"id":id,"state":1,"username":username},
					success: function (data) {
						if(data=='1'){
							toastr.success("开启成功！");
						}else{
							toastr.error("开启失败！");
						}
					}
				});
			}
		});
	}

}


function doSearch(value,name){
	var unitid='';
	var depid='';
	var roleid='';
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#departmentFilter').combogrid('grid').datagrid('getSelected')!=null){
		depid = $('#departmentFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	$('#datalist').datagrid('load',{
		search:'0',
		uname:value,
		unitid:unitid,
		depid:depid,
		roleid:roleid
	});
}

function resetPassword(uid){
	$.messager.confirm('重置密码', '您是否要重置该用户的密码?', function(r){
		if (r){
			$.ajax({
				url:"${pageContext.request.contextPath}/users/resetPassword",
				async:false,
				type:'POST',
				data:{"uid":uid},
				success:function(data){
					if(data.type=='fail'){
						toastr.warning("您没有权限！");
					}else{
						$.messager.alert('重置密码','<a style="font-size:13px;">请您注意：您重新设置了用户</a><a style="font-size:18px;color:red;">&nbsp;'+data.rname+'&nbsp;</a><a style="font-size:13px;">的密码操作。新密码为：</a><a style="font-size:18px;color:red;">&nbsp;'+data.password+'</a>');
					}
				}
			})
		}
	});
	
}

function unlockEmail(uid){
	$.messager.confirm('重置密码', '您确定要解锁该用户的邮箱吗?', function(r){
		if (r){
			$.ajax({
				url:"${pageContext.request.contextPath}/users/unlockEmail",
				async:false,
				type:'POST',
				data:{"uid":uid},
				success:function(data){
					if(data.type=='fail'){
						toastr.warning("您没有权限！");
					}else{
						$.messager.alert('解锁邮箱','<a style="font-size:13px;">请您注意：您解锁了用户</a><a style="font-size:18px;color:red;">&nbsp;'+data.rname+'&nbsp;</a><a style="font-size:13px;">的邮箱。</a>');
					}
				}
			})
		}
	});
}

function delUser(uid){
	$.messager.confirm("提示",'是否要删除所选用户 ?',function(r){ 
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/users/delUser",
	            async: false, 
	            type: "POST",
	            data: { "uid":uid },
	            success: function (data) {
	            	if(data=="1"){
	            		$('#datalist').datagrid('reload');	            		
	            	}else if(data=='-1'){
	            		toastr.warning("无权限");
	            	}	        		
	     		}
	     	});	
	    }
	});
}

function importTeachers(state){
	var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/users/importTeachers?state=' + state  + '">'
		+ '<table width="75%" align="center" style="margin-top:5px;">'
		+ '<tr><td colspan="2" align="center" style="color:red">导入教师（只接受excel格式）</td></tr>'
		+ '<tr><td>选择文件：</td><td><input id="uploadFile" type="file" name="uploadFile" value=""/></td></tr>'
		+ '<tr><td></td><td><input type="button" id="importFile" name="importFile" value="上传"/></td>'
		+ '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/users/importTeachersMonel">链接</a></td></tr>';
		+ '</table></form>';
		
	var obj = $(winStr);
	$('#importTeachers').html(null);
	obj.appendTo('#importTeachers');
	$('#importTeachers').window({
		width:440,
		height:168,
		modal:true,
		title:"导入教师",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
	var form = $('#importFile').click(function(){
		var fileName = $('#uploadFile').val();
		if(fileName==''){
			toastr.warning("请选择附件");
			return;
		}
		if(fileName){
			var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
			if(fileType == 'xls'){
				var formData = new FormData();
				var name = $("#upfile").val();
				formData.append("uploadFile",$("#uploadFile")[0].files[0]);
				formData.append("name",fileName);
				$.ajax({
					url: '${pageContext.request.contextPath}/users/importTeachers?state=' + state,
					type: 'POST',
					secureuri: false,
					data: formData,
					processData:false,
					contentType:false,
					success:function(data){
						$('#datalist').datagrid('reload');
						$('#importTeachers').window('close');
						toastr.warning(data);
					}
				})
			}
		}
	});
}

function editUser(id){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/users/editUser?id=" + id,
		fit:true,
		title:'编辑用户'
	},1);
}

function editUserPermission(id){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/users/editUserPermission?id=" + id,
		fit:true,
		title:'编辑用户课程权限'
	},0);
}

function addPerFromUnit(id){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/users/addPerFromUnit?id=" + id,
		fit:true,
		title:'新增课程'
	},0);
}
</script>	

