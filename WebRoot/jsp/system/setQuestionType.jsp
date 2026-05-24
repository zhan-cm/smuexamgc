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
.qdesc{
	border:1px solid #ccc;
	white-space:normal; 
}
</style>
<div id="dlg-toolbar" style="margin-top:5px;">
	<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.location.href='${pageContext.request.contextPath}/system/params'" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0);" onclick="addQuestionType()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增题型</a>
			<%-- <a href="${pageContext.request.contextPath}/system/" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_refresh',plain:true">重置</a> --%>			
		</td>		
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript">
var atlist;
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$.ajax({
		url:'${pageContext.request.contextPath}/course/getAnswerType',
		type:'POST',
		async:false,
		success: function(data){
			atlist = data;
		}
	});
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/system/getDefaultQuestionTypeList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[100],
		fitColumns: true,
		queryParams: {
		},
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'NAME',title:'题型名',width:15,align:'center',formatter:function(value,row,index){
	        	  return '<div class="qdesc" id="qtname_'+row.ID+'" contenteditable="plaintext-only">'+row.NAME+'</div>'
	       	  }},
	       	  {field:'E_QTNAME',title:'英文题型名',width:20,align:'center',formatter:function(value,row,index){
	       		  var e_qtname = row.E_QTNAME;
	       		  if(e_qtname==null||typeof(e_qtname) == "undefined"||e_qtname== "undefined"||e_qtname== "null"){
	       			 e_qtname = "";
	       		  }
	        	  return '<div class="qdesc" id="e_qtname_'+row.ID+'" contenteditable="plaintext-only">'+e_qtname+'</div>'
	       	  }},
	       	  {field:'ISCON',title:'是否串题',width:15,align:'left',formatter:function(value,row,index){
		    	  var con_name = new Array("串题","非串题");
		    	  var con_id = new Array(1,0);
		    	  var iscon = '<select id="is_con_'+row.ID+'" class="easyui-combobox" name="is_con" style="width:100%">';
		    	  for(var i=0;i<con_name.length;i++){		    		  
		    		  if(con_id[i]==row.ISCON){
		    			  iscon += '<option value='+con_id[i]+' selected="selected">'+con_name[i]+'</option>';
		    		  }else{
		    			  iscon += '<option value='+con_id[i]+'>'+con_name[i]+'</option>';
		    		  }
		    	  }
		    	  iscon += '</select>';
		    	  return iscon;
	        	}},
	        {field:'ATNAME',title:'答案类型',width:20,align:'left',formatter:function(value,row,index){
	        	  var atname = '<select id="at_name_'+row.ID+'" class="easyui-combobox" name="at_name" style="width:100%">'
   	        	  for(var j=0;j<atlist.length;j++){
   	        		  if(row.ANSWERTYPEID==atlist[j].ID){
   	        			  atname += '<option value='+atlist[j].ID+' selected="selected">'+atlist[j].NAME+'</option>';
   	        		  }else{
   	        			  atname += '<option value='+atlist[j].ID+'>'+atlist[j].NAME+'</option>';
   	        		  }
   	        	  }
   	        	  atname += '</select>';
	        	  return atname;
	          }},
			{field:'XXDF',title:'选项得分设置',width:30,align:'left',formatter:function(value,row,index){
				let rtn = '<select id="xxdf_'+row.ID+'" class="easyui-combobox" name="xxdf" style="width:100%">';
				const selectOptions = new Array({name:"无", xxdf:"0"},{name:'多选题少选半分，错选多选0分', xxdf:"2"});
				for(let i=0;i< selectOptions.length ; i++){
					let selected = row.XXDF==selectOptions[i].xxdf?'selected="selected"':'';
					rtn += '<option value="'+selectOptions[i].xxdf+'" '+selected+' >'+selectOptions[i].name+'</option>';
				}
				rtn += '</select>';
				return rtn;
			}},
			{field:'mediaset',title:'多媒体播放设定',width:25,align:'left', formatter:function(value,row,index){
				let mediaSet = '<select id="mediaSet_'+row.ID+'" class="easyui-combobox" name="mediaSet" style="width:100%">';
				let con_name = new Array("不可重播、加速、拖动","正常");
				let con_id = new Array(1,0);
				for(let i=0;i<con_name.length;i++){
					if(con_id[i]==row.MEDIASET){
						mediaSet += '<option value='+con_id[i]+' selected="selected">'+con_name[i]+'</option>';
					}else{
						mediaSet += '<option value='+con_id[i]+'>'+con_name[i]+'</option>';
					}
				}
				mediaSet += '</select>';
				return mediaSet;
			}},
	          {field:'QDESC',title:'题型说明',width:75,align:'center',formatter:function(value,row,index){
	          		var desc=row.QDESC;
	          		if(typeof(desc) == "undefined"||desc== "undefined"||desc== "null"){
	          			desc="";
	          		}
	        	  return '<div class="qdesc" id="qdesc_'+row.ID+'" contenteditable="plaintext-only">'+desc+'</div>'
	       	  }},
	       	{field:'E_QTDESC',title:'英文说明',width:75,align:'center',formatter:function(value,row,index){
          		var desc=row.E_QTDESC;
          		if(desc==null||typeof(desc) == "undefined"||desc == "undefined"||desc== "null"){
          			desc="";
          		}
        	  return '<div class="qdesc" id="e_qtdesc_'+row.ID+'" contenteditable="plaintext-only">'+desc+'</div>'
       	  	}},
	          {field:'Opration',title:'操作',width:40,align:'center',formatter:function(value,row,index){	        	  
	        	  var s1 = '<a class="editQuestionType" onclick="editQuestionTypeView('+index+')"></a>';
	        	  var s2 = '<a class="delQuestionType" onclick="delQuestionType(\''+ row.ID +'\')"></a>&nbsp;&nbsp;&nbsp;&nbsp;';
	        	  var s3='<span onclick="moveQuestionType(\''+ row.ID +'\',\'up\');"  style="cursor: pointer;" title="上移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180466.gif"/></span>&nbsp;&nbsp;&nbsp;&nbsp;';
	        	  var s4='<span onclick="moveQuestionType(\''+ row.ID +'\',\'down\');"  style="cursor: pointer;" title="下移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180465.gif"/></span>';
	        	  return s1+s2+s3+s4;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.editQuestionType').linkbutton({text:'修改题型信息',plain:true});
	        $('.delQuestionType').linkbutton({text:'删除',plain:true});

	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function addQuestionType(){
	let winStr = '<form id="QTForm" method="post"><table width="100%"><tr><td align="right">题型名称：</td>'
		+ '<td align="left"><input type="text" name="qt_name" style="width:220px;" data-options="required:true"/></td>'
		+ '</tr><tr><td align="right">英文名称：</td>'
		+ '<td align="left"><input type="text" name="e_qt_name" style="width:220px;" data-options="required:true"/></td>'
		+ '</tr><tr><td align="right">是否串题：</td><td align="left"><select style="width:220px;" name="qt_iscon" id="qt_iscon">'
		+ '<option value="0">非串题</option><option value="1">串题</option></select></td></tr>'
		+ '<tr><td align="right">是否选项得分：</td><td align="left"><select style="width:220px;" name="qt_xxdf" id="qt_xxdf">'
		+ '<option value="0">无特殊设置</option><option value="2">多选题少选得一半分，错选漏选不得分</option></select></td></tr>'
		+ '<tr><td align="right">多媒体播放设定：</td><td align="left"><select style="width:220px;" name="qt_mediaSet" id="qt_mediaSet">'
		+ '<option value="0">无特殊设置</option><option value="1">不可重播、加速、拖动</option></select></td></tr>'
		+ '<tr><td align="right">按答案分类：</td><td align="left">'
		+ '<select style="width:220px;" name="qt_answertypeid" id="qt_answertypeid">';
		for(let i=0;i<atlist.length;i++){
			winStr += '<option value='+atlist[i].ID+'>'+atlist[i].NAME+'</option>';
		}
		winStr += '</select></td></tr><tr><td align="right">题目说明：</td><td align="left">'
		+ '<textarea name="qt_desc" style="width:220px;height:100px;" ></textarea></td></tr>'
		+ '<tr><td align="right">英文说明：</td><td align="left">'
		+ '<textarea name="e_qt_desc" style="width:220px;height:100px;" ></textarea></td></tr></table>'
		+ '<div style="width: 100%; text-align:center; margin-top:10px">' 
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitQTForm()">'
		+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
		+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
		+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';
	 
		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo('#win');
	$('#win').window({
		width:440,
		height:450,
		modal:true,
		title:"添加题型",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		//content:winStr
	});
}

function submitQTForm(){
	$('#QTForm').form('submit', {
	    url:'${pageContext.request.contextPath}/system/addQuestionType',
	    onSubmit: function(){	    	
	    	return valQT();
	    },
	    success:function(data){
	    	if(data == "1"){
	    		$('#win').window('close');
        		$('#datalist').datagrid('reload');
        		toastr.success('添加成功');
	    	}
	    }
	});
}

function valQT(){
	if (parseInt($("#qt_iscon").val(), 10) === 1 && parseInt($("#qt_answertypeid").val(), 10) === 13) {
		toastr.warning('编程题不可是串题！');
		return false;
	}
	var res = true;
	var val = $.trim($("input[name=qt_name]").val());

	if(val==null||val==''){
		toastr.warning('题型为空，请重新添加');
		res = false;
	}else{
		$.ajax({
	        url: "${pageContext.request.contextPath}/system/checkRepeatQuestionType",
	        async: false,
	        type: "POST",
	        traditional: true,
	        data: { "qtname": val},
	        success: function (data) {
	        	if(data == "-1"){
	        		toastr.warning('题型重复，请重新添加');
	        		res = false;
	        	}
	        }
		});
	}		
	return res;
}

function delQuestionType(val){
	$.messager.confirm('删除题型','删除系统默认题型是不可逆的操作，您确认继续删除此题型吗?',function(r){
	    if (r){
	    	$.ajax({
	    		url: "${pageContext.request.contextPath}/system/delQuestionType",
	    		async: false,
	    		type: "POST",
	    		data: {"id": val},
	    		success: function(data){
	    			if(data == 1){
	    				$("#datalist").datagrid('reload');
	    				toastr.success('删除成功');
	    			}else{
	    				toastr.warning('删除失败');
	    			}
	    		}
	    	});
	    }
	});
}

function moveQuestionType(id, direction){
	$.ajax({
		url: "${pageContext.request.contextPath}/system/moveQuestionType",
		async: false,
		type: "POST",
		data: {
			id: id,
			direction: direction
		},
		success: function(data){
			if(data <= 0){
				toastr.error('排序失败');
			}else{
				$("#datalist").datagrid('reload');
				toastr.success('排序成功');
			}
		}
	});
}

function editQuestionTypeView(index){
	let currentRow = $('#datalist').datagrid('getData').rows[index];
	let id = currentRow.ID;
	let qtdesc = $("#qdesc_"+id).html();
	let e_qtdesc = $("#e_qtdesc_"+id).html();
	let qtname=$("#qtname_"+id).text().replace(/^\s+|\s+$/g,"");
	let e_qtname=$("#e_qtname_"+id).text();
	let iscon=$("#is_con_"+id).val();
	let atid=$("#at_name_"+id).val();
	let xxdf=$("#xxdf_"+id).val();
	let mediaSet=$("#mediaSet_"+id).val();
	if (parseInt(iscon, 10) === 1 && parseInt(atid, 10) === 13) {
		toastr.warning('编程题不可是串题！');
		return false;
	}

	let str="";

	let patternban = /[\u4e00-\u9fa5]/;
	if(patternban.test(e_qtname)==true){
		toastr.error('英文名禁止中文!');
		return false;
	}
	if(patternban.test(e_qtdesc)==true){
		toastr.error('英文说明禁止中文!');
		return false;
	}
	if(iscon!=currentRow.ISCON||atid!=currentRow.ANSWERTYPEID||xxdf!=currentRow.XXDF||mediaSet!=currentRow.MEDIASET){
		str+="系统检测到“"+currentRow.NAME+"”题型";
		if(iscon!=currentRow.ISCON){
			let iscon_before="";
			if(currentRow.ISCON=='1'){
				iscon_before="串题";
			}else{
				iscon_before="非串题";
			}
			let iscon_after="";
			if(iscon=='1'){
				iscon_after="串题";
			}else{
				iscon_after="非串题";
			}
			str+="，由“"+iscon_before+"”转换为“"+iscon_after+"”";
		}
		if(xxdf!=currentRow.XXDF){
			let xxdf_before="";
			if(currentRow.XXDF=='2'){
				xxdf_before="多选题少选漏选得半分";
			}else{
				xxdf_before="无特殊设置";
			}
			let xxdf_after="";
			if(xxdf=='2'){
				xxdf_after="多选题少选漏选得半分";
			}else{
				xxdf_after="无特殊设置";
			}
			str+="，由“"+xxdf_before+"”转换为“"+xxdf_after+"”";
		}
		if(mediaSet!=currentRow.MEDIASET){
			let mediaSet_before="";
			if(currentRow.MEDIASET=='1'){
				mediaSet_before="不可重播、加速、拖动";
			}else{
				mediaSet_before="无特殊设置";
			}
			let mediaSet_after="";
			if(mediaSet=='1'){
				mediaSet_after="不可重播、加速、拖动";
			}else{
				mediaSet_after="无特殊设置";
			}
			str+="，由“"+mediaSet_before+"”转换为“"+mediaSet_after+"”";
		}
		if(atid!=currentRow.ANSWERTYPEID){
			let answerType=JSON.parse(sessionStorage.getItem('answerType'));
			let atid_before="";
			let atid_after="";
			for(let i=0;i<answerType.length;i++){
				if(currentRow.ANSWERTYPEID==answerType[i].ID){
					atid_before=answerType[i].NAME;
				}
				if(atid==answerType[i].ID){
					atid_after=answerType[i].NAME;
				}
			}
			str+="，答案类型由“"+atid_before+"”转换为“"+atid_after+"”";
		}
		str+=",请确认是否继续修改该题型？";
		
	}else{
		str+="修改题型要慎重，您确认要修改此题型吗?";
	}
	
	$.messager.confirm('警告',str,function(r){
		if(r){
			$.ajax({
				url:'${pageContext.request.contextPath}/system/updateQuestionType',
				type:'POST',
				async:false,
				data: {"id":id,"qtdesc":qtdesc,"e_qtdesc":e_qtdesc,"qtname":qtname,"e_qtname":e_qtname,"iscon":iscon,"atid":atid,"xxdf":xxdf,"mediaSet":mediaSet},
				success: function(data){
					if(data==1){
						$("#datalist").datagrid('reload');
						toastr.success('修改成功');
					}
					else{
						toastr.warning('修改失败，题型名重复或为空，或无权限修改');
					}
				}
			})
		}
	});
}

</script>	