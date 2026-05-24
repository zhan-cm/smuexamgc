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
<div id="dlg-toolbar" style="height:26px;">
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>			
			<a href="javascript:void(0);" onclick="addUnit()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增机构</a>			
			<a href="javascript:void(0);" onclick="getDelUnit()" class="easyui-linkbutton" id="del" data-options="iconCls:'icon-book',plain:true">已删除单位</a>
			<a href="javascript:void(0)" onclick="getUnit()" class="easyui-linkbutton" id="show" data-options="iconCls:'icon-book',plain:true">启用单位</a>
			请输入查询单位：<input type="text" id="searchBox" style="width:150px"/>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="doSearch()">查询</a>
		</td>		
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	getUnit();
});

function getUnit(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getUnitList',
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
			  {field:'NAME',title:'单位名称',width:20,align:'center',sortable:true},
			  {field:'CONTACT',title:'联系人',width:20,align:'center'},
			  {field:'TEL',title:'联系电话',width:20,align:'center'},
			  {field:'CODE',title:'编码',width:20,align:'center'},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a href="javascript:void(0);" onclick="editUnit(\''+ row.ID +'\',\''+ row.NAME +'\',\''+ row.CONTACT +'\',\''+ row.TEL +'\',\''+ row.CODE +'\')" class="editUnit"></a>';
	        	  var s2 = '<a class="delUnit" onclick="delUnit(\''+ row.ID +'\')"></a>';
	        	  return s1 + s2;
	          }},
			  {field:'dep',title:'二级单位',width:20,align:'center',formatter:function(value,row,index){	   
	        	  var s1 = '<a href="${pageContext.request.contextPath}/system/queryDep?uid=' + row.ID +  '&uname=' + row.NAME + '" class="queryDep"></a>';
	        	  return s1;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editUnit').linkbutton({text:'编辑',plain:true});
	        $('.delUnit').linkbutton({text:'删除',plain:true});
	        $('.queryDep').linkbutton({text:'查看、编辑下属机构',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$("#del").show();
	$("#show").hide();
}

function doSearch(){ 
	$('#datalist').datagrid('load',{
		name: $('#searchBox').val()
	});
}

var unitname = '';
function editUnit(id, name, contact, tel,code){
	$("input[name=uname]").val(null);
	unitname = name;
	let safeContract = contact === null ||contact === 'null' || contact === undefined ? '' : contact;
	let safeTel = tel === null ||tel === 'null' || tel === undefined ? '' : tel;
	let safeCode = code === null || code === undefined ? 0 : code;
	var winStr = '<form id="editUForm" method="post"><table width="100%">'
		+ '<tr><td align="right">教学单位名称：</td>'
		+ '<td align="left"><input type="text" name="uname" value="' + name + '" style="width:220px;"/></td></tr>'
			+ '<tr><td align="right">单位编码(数字)：</td>'
			+ '<td align="left"><input type="text" name="code" value="' + safeCode + '" style="width:220px;"/></td></tr>'
		+ '<tr><td align="right">单位联系人：</td>'
		+ '<td align="left"><input type="text" name="contact" value="' + safeContract + '" style="width:220px;"/></td></tr>'
		+ '<tr><td align="right">联系方式：</td>'
		+ '<td align="left"><input type="text" name="tel" value="' + safeTel + '" style="width:220px;"/></td></tr>'
		+ '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<input type="hidden" name="id" value="' + id + '"/>'
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="updateUForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
		
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:180,
		modal:true,
		title:"编辑机构",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function getDelUnit(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getUnitList?del=1',
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
			  {field:'NAME',title:'单位名称',width:20,align:'center',sortable:true},
			  {field:'CONTACT',title:'联系人',width:20,align:'center'},
			  {field:'TEL',title:'联系电话',width:20,align:'center'},
			  {field:'Opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){	        	
				  var s0 = '<a href="javascript:void(0);" onclick="deleteUnit(\''+row.ID+'\')" class="deleteUnit"></a>'
	        	  var s1 = '<a href="javascript:void(0);" onclick="recUnit(\''+ row.ID +'\')" class="recUnit"></a>';
	        	  return s1 + s0;
	          }},
			  {field:'dep',title:'二级单位',width:20,align:'center',formatter:function(value,row,index){	   
	        	  var s1 = '<a href="${pageContext.request.contextPath}/system/queryDep?uid=' + row.ID +  '&uname=' + row.NAME + '" class="queryDep"></a>';
	        	  return s1;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	        $('.recUnit').linkbutton({text:'恢复',plain:true});
	        $('.deleteUnit').linkbutton({text:'彻底删除',plain:true});
	        $('.queryDep').linkbutton({text:'查看、编辑下属机构',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$("#show").show();
	$("#del").hide();
}

function recUnit(id){
	$.ajax({
		url:'${pageContext.request.contextPath}/system/recUnit',
		async:false,
		type:"POST",
		data:{"id":id},
		success:function(data){
			$('#datalist').datagrid('reload');
			toastr.success("已成功恢复单位");
		}
	})
}

function deleteUnit(id){
	var rs = '';
	$.ajax({
		url:'${pageContext.request.contextPath}/system/getCourseAndTeacherByUnit',
		async:false,
		type:"POST",
		data:{"id":id},
		success:function(data){
			rs = data;
		}
	})
	var mes = '此项操作会彻底删除机构，您确认吗？';
	if(rs != ''){
		if(rs.cls.length > 0){
			mes = '彻底删除会使以下课程的机构为空：'
			for(var i=0;i<rs.cls.length;i++){
				var cname = rs.cls[i].NAME;
				mes += cname + ',';
			}
			mes.substring(0,mes.length-1);
			mes += '<br/><br/>'
		}
		if(rs.tls.length > 0){
			mes += '会使以下教师的机构为空：'
			for(var j=0;j<rs.tls.length;j++){
				var tname = rs.tls[j].NAME;
				mes += tname + ',';
			}
			mes.substring(0,mes.length-1);
			mes += '<br/><br/>'
		}
		if(rs.dls!=""){
			mes += '会一并删除以下部门:'
			mes += rs.dls;
		}
	}
	$.messager.confirm('彻底删除机构',mes,function(r){
		if(r){
			$.ajax({
				url:'${pageContext.request.contextPath}/system/deleteUnit',
				async:false,
				type:"POST",
				data:{"id":id},
				success:function(data){
					$('#datalist').datagrid('reload');
					toastr.success("已彻底删除该单位");
				}
			})
		}
	});
	
}

function updateUForm(){
	var uname = $("input[name='uname']").val().trim();
	if(uname==null||uname==""){
		toastr.error('教学单位名称不能为空');
		return false;
	}
	var code = $('input[name="code"]').val();
	if (isNaN(parseFloat(code)) ||!isFinite(code)) {
		toastr.error('编码必须为数字');
		return false;
	}
	$('#editUForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/updateUnit',
	    success:function(data){
	    	if(data=="1"){
	    		$('#win').window('close');
	        	$('#datalist').datagrid('reload');
	        	toastr.success('修改成功');
	    	}else{
	    		toastr.warning("单位名称重复");
	    	}
	    	
	    }
	});
}

function addUnit(){
	$("input[name=uname]").val(null);
	var winStr = '<form id="UForm" method="post"><table width="100%" style="margin-top:10px;">'
		+ '<tr><td align="right">教学单位名称：</td>'
		+ '<td align="left"><input type="text" name="uname" style="width:220px;"/></td></tr>'
			+ '<tr><td align="right">单位编码（数字）：</td>'
			+ '<td align="left"><input type="text" name="code" style="width:220px;" value="0"/></td></tr>'
// 		+ '<tr><td align="right">下级教学机构：</td>'
// 		+ '<td align="left"><input type="text" name="dname" style="width:220px;"/></td></tr>'
		+ '<tr><td align="right">单位联系人：</td>'
		+ '<td align="left"><input type="text" name="contact" style="width:220px;"/></td></tr>'
		+ '<tr><td align="right">联系方式：</td>'
		+ '<td align="left"><input type="text" name="tel" style="width:220px;"/></td></tr>'
		+ '</table><div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitUForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:210,
		modal:true,
		title:"新增机构",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function submitUForm(){
	var uname = $("input[name='uname']").val().trim();
	if(uname==null||uname==""){
		toastr.warning('教学单位名称不能为空');
		return;
	}
	var code = $('input[name="code"]').val();
	if (isNaN(parseFloat(code)) ||!isFinite(code)) {
		toastr.error('编码必须为数字');
		return false;
	}
// 	var dname = $("input[name='dname']").val();
// 	if(dname==null||dname==""){
// 		toastr.warning('下级机构名称不能为空');
// 		return;
// 	}
	$('#UForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/addUnit',
// 	    onSubmit: function(){	    	
// 	    	return valUnit();
// 	    },
	    success:function(data){
	    	if(data =="1"){
	    		$('#win').window('close');
        		$('#datalist').datagrid('reload');
        		toastr.success('添加成功');
	    	}else{
	    		toastr.warning("单位名称重复，请重新添加");
	    	}
	    }
	});
}

// function valUnit(){
// 	var res = true;
// 	var val = $.trim($("input[name=uname]").val());
// 	if(val==null||val==''){
// 		toastr.warning('单位名称为空，请重新添加');
// 		res = false;
// 	}else{
// 		$.ajax({
// 	        url: "${pageContext.request.contextPath}/system/checkRepeatUnit",
// 	        async: false,
// 	        type: "POST",
// 	        traditional: true,
// 	        data: { "uname": val},
// 	        success: function (data) {
// 	        	if(data =="-1"){
// 	        		toastr.warning('单位名称重复，请重新添加');
// 	        		res = false;
// 	        	}
// 	        }
// 		});
// 	}		
// 	return res;
// }

function delUnit(val){
	$.messager.confirm('删除机构','是否确认删除机构？',function(r){
	    if (r){
	    	$.ajax({
	    		url: "${pageContext.request.contextPath}/system/delUnit",
	    		async: false,
	    		type: "POST",
	    		traditional: true,
	    		data: {"uid": val},
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