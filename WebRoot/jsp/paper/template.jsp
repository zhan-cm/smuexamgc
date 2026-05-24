<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
</style>
<div id="dlg-toolbar" style="height:26px;">
<input type="hidden" id="ei_id" name="ei_id" value="${ei_id}"/>
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true" onclick=""> </a>
			 
		</td>
		<!-- <td style="text-align:right;">
			<input class="easyui-searchbox" data-options="prompt:'请输入查询内容',menu:'#mm',searcher:doSearch" style="width:250px"></input>
			<div id="mm" style="width:120px">
				<div data-options="name:'xsbh'">课程编码</div>
				<div data-options="name:'xsbh'">课程中文名</div>
				<div data-options="name:'xsbh'">课程英文名</div>
				<div data-options="name:'xsbh'">课程简称</div>
			</div>
		</td> -->
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
var ei_id = $("#ei_id").val();
var c_id = $("#c_id").val();
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getExampaperQuestionList?ei_id=' + ei_id,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList:[10,10*2,10*3],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'QID',checkbox:true},
			  {field:'QTNAME',title:'题型',width:40,align:'left',sortable:true},
		      {field:'CONTENT',title:'题目',width:120,align:'left',formatter:function(value,row,index){
		    	  var s = '<div class="qcontent">' + row.CONTENT + '</div>'
	        	  var a = '<a href="javascript:void(0)" class="viewQuestion" onclick="viewQuestion('+ row.QID + ',' + row.VERSION + ')"></a>';
	        	  return s + a;
	          }},
	          {field:'SONAME',title:'题源',width:40,align:'left',sortable:true},
	          {field:'CONAME',title:'认知分类',width:40,align:'left',sortable:true},
	          {field:'DNAME',title:'难度',width:40,align:'left',sortable:true},
	          {field:'KNAME',title:'知识点分布',width:40,align:'left',sortable:true},
	          {field:'ANSWERTIME',title:'应答时间',width:40,align:'left',sortable:true},
		      {field:'T1NAME',title:'主题词',width:70,align:'left',formatter:function(value,row,index){
		    	  var s = row.T1NAME;
		    	  if(row.T2NAME){
		    		  s += ' / ' + row.T2NAME;
		    	  }
		    	  if(row.T3NAME){
		    		  s += ' / ' + row.T3NAME;
		    	  }
		    	   return s;
	          }},
	          {field:'REALDIFFICULTY',title:'实测难度',width:20,align:'left',sortable:true},
	          {field:'DISTINCTION',title:'区分度',width:20,align:'left',sortable:true},
	          {field:'STANDARDDEVIATION',title:'标准差',width:20,align:'left',sortable:true},
	          {field:'NUM',title:'已考次数',width:20,align:'left',sortable:true},
	          //{field:'STATE',title:'状态',width:40,align:'left',sortable:true},
	          {field:'STATE',title:'状态',width:40,align:'left',formatter:function(value,row,index){
	        	  if(row.STATE==0){
	        		  return '未审核';
	        	  }else if(row.STATE==1){
	        		  return '已审核';
	        	  }
	          }},
	          {field:'opration',title:'操作',width:70,align:'center',formatter:function(value,row,index){
	        	  var s1 = '<a href="javascript:void(0)" class="editcls1" onclick="edit('+ row.QID + ',' + row.VERSION + ')"></a>';
	        	  var s2 = '<a href="javascript:void(0)" class="editcls2" onclick="verify('+ row.QID + ',' + row.VERSION + ',' + row.STATE + ')"></a>';
	        	  var s3 = '<a href="javascript:void(0)" class="editcls3" onclick="del('+ row.QID + ',' + row.VERSION + ',' + row.STATE + ')"></a>';
	        	  return s1 + s2 + s3;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewQuestion').linkbutton({text:'详细',iconCls:'icon-add',plain:true});
	    	$('.editcls1').linkbutton({text:'编辑',plain:true});
	        $('.editcls2').linkbutton({text:'审核',plain:true});
	        $('.editcls3').linkbutton({text:'删除',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});


function edit(qid, version){	
	var url = 'question/editQuestion?q_id='+qid+'&version='+version+'&c_id='+cid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '试题更新',
		content: content,
		closable: true 
	});
}



</script>	

