<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<style>
.perDiv{
	/* text-align:left; */
	height:auto;
}
.datagrid-wrap{
	padding-bottom: 20px !important;
}
.datagrid-wrap:after{	
	display: block;
	content: "";
	text-align: center;
	font-size: 14px;
}

</style>	
<div id="dlg-toolbar" style="height:auto">
<table cellpadding="0" cellspacing="0" width="100%" style="margin-top:10px;margin-bottom:5px;">
	<tr>
		<th style="text-align:center;font-size: 20px;margin: 5px;">${title }<span style="color:red;font-size: 20px;">添加授权人</span></th>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="addAppointTeacher()">保存修改</a>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="roleFilter" type="text" name="roleFilter" style="width:190px;" />
			<input type="hidden" id="errorInfo" value="${sessionScope.errorInfo}"/>
			<input type="hidden" value="${cid}" id="cid"/>
			<input type="hidden" value="${eid}" id="eid"/>
			<input type="hidden" value="${mobile}" id="mobile"/>
			<input type="hidden" value="${type}" id="type"/>
		</td>
		<td>
			<input id="searchName" type="text" name="searchName" placeholder="请输入用户名或实名"/>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchName()">搜索</a>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
$(document).ready(function(){
	var cid = $('#cid').val();
	var eid = $('#eid').val();
		$('#datalist').datagrid({
			fit:true,
			striped: true,
			singleSelect: false,
			checkOnSelect:false,
			url:'${pageContext.request.contextPath}/verify/getAllAuthorizedTeacher?cid=' + cid + '&eid='+eid,
			pagination: true,
			rownumbers: false,
			pageNumber: 1,
			pageSize: 50,
			pageList:[50,100,200],
			fitColumns: true,
			toolbar:'#dlg-toolbar',
			columns:[[
				  {field:'uname',title:'用户名',width:40,align:'left',sortable:true},
				  {field:'tname',title:'用户实名',width:40,align:'left',sortable:true},
			      {field:'role',title:'系统角色',width:40,align:'left',sortable:true},
		          {field:'unit',title:'所属单位',width:40,align:'left',sortable:true},
		          {field:'viewPaper',title:'查看试卷、监考',width:40,align:'center',formatter:function(value,row,index){
		          	  var s='';
		          	  if($.inArray("31_checked", row.ownPers) > -1){
		          	      s = '<label><div class="perDiv"><input class="per view" checked="checked" type="checkbox" value="31"/>查看试卷、监考</div></label>';
		          	  }else if($.inArray("31_unchecked", row.ownPers) > -1){
		          	  	  s = '<label><div class="perDiv"><input class="per view" type="checkbox" value="31"/>查看试卷、监考</div></label>';
		          	  }
	        		  return s;
		          }},
				{field:'monitor',title:'仅监考',width:30,align:'center',formatter:function(value,row,index){
						var s='';
						if($.inArray("39_checked", row.ownPers) > -1){
							s = '<label><div class="perDiv"><input class="per view" checked="checked" type="checkbox" value="39"/>仅监考</div></label>';
						}else if($.inArray("39_unchecked", row.ownPers) > -1){
							s = '<label><div class="perDiv"><input class="per view" type="checkbox" value="39"/>仅监考</div></label>';
						}
						return s;
					}},
		          {field:'correctPaper',title:'批改试卷',width:40,align:'center',formatter:function(value,row,index){
	        		  var s='';
		          	  if($.inArray("37_checked", row.ownPers) > -1){
		          	      s = '<label><div class="perDiv"><input class="per correct" checked="checked" type="checkbox" value="37" onclick="perFun(this,' + index + ')"/>批改试卷</div></label>';
		          	  }else if($.inArray("37_unchecked", row.ownPers) > -1){
		          	  	  s = '<label><div class="perDiv"><input class="per correct" type="checkbox" value="37" onclick="perFun(this,' + index + ')"/>批改试卷</div></label>';
		          	  }
	        		  return s;
		          }},
		          {field:'updatePaper',title:'编辑试卷',width:40,align:'center',formatter:function(value,row,index){
	        		  var s='';
		          	  if($.inArray("33_checked", row.ownPers) > -1){
		          	      s = '<label><div class="perDiv"><input class="per update" checked="checked" type="checkbox" value="33" onclick="perFun(this,' + index + ')"/>编辑试卷</div></label>';
		          	  }else if($.inArray("33_unchecked", row.ownPers) > -1){
		          	  	  s = '<label><div class="perDiv"><input class="per update" type="checkbox" value="33" onclick="perFun(this,' + index + ')"/>编辑试卷</div></label>';
		          	  }
	        		  return s;
		          }},
		          {field:'delPaper',title:'删除试卷',width:40,align:'center',formatter:function(value,row,index){
	        		  var s='';
		          	  if($.inArray("34_checked", row.ownPers) > -1){
		          	      s = '<label><div class="perDiv"><input class="per del" checked="checked" type="checkbox" value="34" onclick="perFun(this,' + index + ')"/>删除试卷</div></label>';
		          	  }else if($.inArray("34_unchecked", row.ownPers) > -1){
		          	  	  s = '<label><div class="perDiv"><input class="per del" type="checkbox" value="34" onclick="perFun(this,' + index + ')"/>删除试卷</div></label>';
		          	  }
	        		  return s;
		          }}
		    ]],
		    onLoadSuccess:function(data){
		    	$('.editcls1').linkbutton({text:'编辑课程',plain:true});
		        $('.editcls2').linkbutton({text:'编辑试题',plain:true});
		        $('.editcls3').linkbutton({text:'删除课程',plain:true});
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
	    	$('#datalist').datagrid('load',{
	    		uname: $("#searchName").val(),
	    		unitid:unitid,
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
	    	let unitid = "";
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	let roleid = "";
	    	if($('#roleFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		roleid = $('#roleFilter').combogrid('grid').datagrid('getSelected').ID;
	    	}
	    	$('#datalist').datagrid('load',{
	    		uname: $("#searchName").val(),
	    		unitid:unitid,
	    		roleid:roleid
			});
	    },
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '所属学院');
	    }
	});
	
});

var parr = new Array('31','33','34','37','39');
function perFun(obj,index){
	var row = $($('.datagrid-row').get(index));
	var view = row.find('.view');
	var update = row.find(".update");
	var val = $(obj).val();	
	if($(obj).attr('checked')){
		if($.inArray(val, parr) > -1){
			view.attr('checked','checked'); 
			view.attr('disabled','disabled'); 
		}
	}else{
		view.removeAttr('disabled');
		update.removeAttr('disabled');
	}
}
 
function addAppointTeacher(){
	//debugger
	var params = {};
	params["eid"] = $('#eid').val();
	var teacherList = [];
	var rows = $('#datalist').datagrid('getRows');
	$.each($('.datagrid-row'),function(i,item){
		var teacherPer = {};
		var row = rows[i];
		if(row == undefined){
			return;
		}
		teacherPer["uid"] = row.tid;
		teacherPer["username"] = row.uname;
		teacherPer["realname"] = row.tname;
		
		var r = $(item);
		var per = r.find('.per');
		var perArr = [];
		$.each(per,function(i,item){
			if($(item).attr('checked')){				
			 	perArr.push($(item).val());
			}
		});
		teacherPer["perList"] = perArr;
		teacherList.push(teacherPer);
	});
	params["teacherList"] = teacherList;
	$.ajax({
		contentType: "application/json; charset=utf-8",
        url: "${pageContext.request.contextPath}/verify/addAuthorizedTeacher",
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
        	if(data=='1'){
        		toastr.success("添加成功！");
        	}
        	$('#datalist').datagrid('reload');
 		}
 	});	
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
	$('#datalist').datagrid('load',{
		uname: $("#searchName").val(),
		unitid:unitid,
		roleid:roleid
	});
}



</script>	

