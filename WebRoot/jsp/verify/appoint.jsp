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
	content: "备注：1、超级管理员拥有对本试卷的所有权限。 2、组卷人拥有对本试卷审核之外的所有权限。  3、终审试卷权限绑定包含了查看试卷、编辑试卷权限。";
	text-align: center;
	font-size: 14px;
}

</style>	
<div id="dlg-toolbar" style="height:auto">
<table cellpadding="0" cellspacing="0" width="100%" style="margin-top:10px;margin-bottom:5px;">
	<tr>
		<th style="text-align:center;font-size: 20px;margin: 5px;">${title }<span style="color:red;font-size: 20px;">权限设置</span></th>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="cancelEasyUiFrame(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="${pageContext.request.contextPath}/verify/correctDistribution?cid=${cid}&eid=${eid}&ename=${ename}" class="easyui-linkbutton" data-options="iconCls:'icon-people',plain:true">改卷任务分配</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="addAppointTeacher()">保存修改</a>
			<a href="${pageContext.request.contextPath}/verify/authorizedTeacher?cid=${cid}&eid=${eid}&ename=${ename}" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加授权人</a>

			<input type="hidden" value="${cid}" id="cid"/>
			<input type="hidden" value="${eid}" id="eid"/>
			<input type="hidden" value="${mobile}" id="mobile"/>
			<input type="hidden" value="${type}" id="type"/>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
$(document).ready(function(){
	var cid = $('#cid').val();
	var eid = $('#eid').val();
	var type = $('#type').val();	
	var mobile = $('#mobile').val();
	let viewPaperTitle = "查看试卷、监考";
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/verify/getAppointTeacher?cid=' + cid + '&type=' + type+ '&eid='+eid,
		//pagination: true,
		rownumbers: false,
		//pageSize: 20,
		//pageList:[10,10*2,10*3],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'C_ID',
		columns:[[
			{field:'uname',title:'用户名',width:40,align:'left',sortable:true},
			{field:'tname',title:'用户实名',width:40,align:'left',sortable:true},
			{field:'role',title:'系统角色',width:40,align:'left',sortable:true},
			{field:'unit',title:'所属单位',width:40,align:'left',sortable:true},
			{field:'viewPaper',title:viewPaperTitle,width:40,align:'center',formatter:function(value,row,index){
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
				}return s;
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
			}},
			{field:'firVerPaper',title:'初审试卷',width:40,align:'center',hidden:mobile==1,formatter:function(value,row,index){
				var s='';
				if($.inArray("35_checked", row.ownPers) > -1){
					s = '<label><div class="perDiv"><input class="per firVer" checked="checked" type="checkbox" value="35" onclick="perFun(this,' + index + ')"/>初审试卷</div></label>';
				}else if($.inArray("35_unchecked", row.ownPers) > -1){
					s = '<label><div class="perDiv"><input class="per firVer" type="checkbox" value="35" onclick="perFun(this,' + index + ')"/>初审试卷</div></label>';
				}
				return s;
			}},
			{field:'lastVerPaper',title:'终审试卷',width:40,align:'center',hidden:mobile==1,formatter:function(value,row,index){
				var s='';
				if($.inArray("36_checked", row.ownPers) > -1){
					s = '<label><div class="perDiv"><input class="per lastVer" checked="checked" type="checkbox" value="36" onclick="perFun(this,' + index + ')"/>终审试卷</div></label>';
				}else if($.inArray("36_unchecked", row.ownPers) > -1){
					s = '<label><div class="perDiv"><input class="per lastVer" type="checkbox" value="36" onclick="perFun(this,' + index + ')"/>终审试卷</div></label>';
				}
				return s;
			}}
		]],
		onLoadSuccess:function(data){
			$('.editcls1').linkbutton({text:'编辑课程',plain:true});
			$('.editcls2').linkbutton({text:'编辑试题',plain:true});
			$('.editcls3').linkbutton({text:'删除课程',plain:true});
			initPermissions();
		}
	});

	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
});

var parr = new Array('33','34','35','36','37');
function initPermissions() {
	$('.datagrid-row').each(function (i, rowEl) {
		var $row    = $(rowEl);
		var $view   = $row.find('.view');
		var $update = $row.find('.update');
		var anyParrChecked = $row.find('.per').filter(function () {
			var v = String($(this).val());
			return parr.indexOf(v) > -1 && $(this).prop('checked');
		}).length > 0;

		if (anyParrChecked) {
			$view.prop('checked', true).prop('disabled', true);
		} else {
			$view.prop('disabled', false);
		}

		if ($update.prop('checked')) {
			$view.prop('checked', true);
		}
	});
}

function perFun(obj, index) {
	var $row    = $($('.datagrid-row').get(index));
	var $view   = $row.find('.view');
	var $update = $row.find('.update');
	var $obj    = $(obj);
	var val     = String($obj.val());
	var isChecked = $obj.prop('checked');

	function anyParrChecked() {
		return $row.find('.per').filter(function () {
			var v = String($(this).val());
			return parr.indexOf(v) > -1 && $(this).prop('checked');
		}).length > 0;
	}

	if (isChecked && parr.indexOf(val) > -1) {
		$view.prop('checked', true).prop('disabled', true);

	} else {
		if (!anyParrChecked()) {
			$view.prop('disabled', false);
		}
	}

	if ($update.prop('checked')) {
		$view.prop('checked', true);
	}
}

function $perInRow($row, v) {
	return $row.find('.per[value="' + String(v) + '"]');
}
function hasLastVer($row) {
	// 该行是否渲染了 “终审试卷(36)” 这一列（由你的formatter生成的 .per.lastVer）
	return $row.find('.per.lastVer').length > 0;
}

// 终审列存在模式：基础规则 + 根据 35/36 的状态决定是否锁定 31/39
function refreshLastVerState($row) {
	// 1) 33/34/37：不勾选+禁用
	['33','34','37'].forEach(function(v){
		$perInRow($row, v).prop('checked', false).prop('disabled', true);
	});

	// 2) 31/39 默认可编辑
	['31','39'].forEach(function(v){
		$perInRow($row, v).prop('disabled', false); // 不改其当前选中状态
	});
	// 若页面上单独还有一个 .view（与 31 含义相同），也保持可编辑
	$row.find('.view').prop('disabled', false);

	// 3) 35/36 可编辑
	['35','36'].forEach(function(v){
		$perInRow($row, v).prop('disabled', false);
	});

	// 4) 如果 35 或 36 任意一个被勾选，则强制勾选并锁定 31 与 39
	var trigOn = $perInRow($row, 35).prop('checked') || $perInRow($row, 36).prop('checked');
	if (trigOn) {
		// 锁定 31、39
		$perInRow($row, 31).prop('checked', true).prop('disabled', true);
		$perInRow($row, 39).prop('checked', true).prop('disabled', true);
		// 若存在 .view，顺带与 31 同步（避免两套UI不一致）
		$row.find('.view').prop('checked', true).prop('disabled', true);
	}
}

// 保留你原本的判断函数（用于非“终审列存在”场景）
function anyParrCheckedInRow($row) {
	return $row.find('.per').filter(function () {
		var v = String($(this).val());
		return parr.indexOf(v) > -1 && $(this).prop('checked');
	}).length > 0;
}
 
function addAppointTeacher(){
	//debugger
	var params = {};
	params["eid"] = $('#eid').val();
	var teacherList = [];
	var rows = $('#datalist').datagrid('getRows');

	$.each($('.datagrid-row'),function(i,item){
		var r = $(item);
		var per = r.find('.per');
		var perArr = [];
		$.each(per,function(i,item){
			if($(item).attr('checked')){				
			 	perArr.push($(item).val());
			}
		});
		var teacherPer = {};
		var row = rows[i];

		teacherPer["uid"] = row.tid;
		teacherPer["username"]=row.uname;
		teacherPer["tname"]=row.tname;
		teacherPer["perList"] = perArr;
		teacherList.push(teacherPer);

	});

	params["teacherList"] = teacherList;
	$.ajax({
		contentType: "application/json; charset=utf-8",
        url: "${pageContext.request.contextPath}/verify/addAppointTeacher",
        async: false,//改为同步方式
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
        	if(data=='1'){
        		toastr.success("添加成功！");
        	}else if(data=='0'){
        		toastr.error("权限不够！");
        	}
 		}
 	});	
}




</script>	

