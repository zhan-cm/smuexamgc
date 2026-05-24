<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
/*.datagrid-wrap{
	padding-bottom: 20px !important;
}
.datagrid-wrap:after{	
	display: block;
	content: "${cCount}门课程，${qCount}道试题";
	text-align: center;
	font-size: 14px;
}*/
</style>
<div id="dlg-toolbar" style="height:auto;">	
<table cellpadding="0" cellspacing="0"  style="width:100%">
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/indelQuestion'">刷新</a>
			<input id="unitFilter" type="text" name="unitFilter" style="width:190px;" />
			<input id="arrangeFilter" type="text" name="arrangeFilter" style="width:190px;"/>
			<span style="margin-top:5px!important;">
				<input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"></input>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/ineditQuestion'">取消查询</a>
			</span>
			<td>
			
		</td>
		</td>
	</tr>	
	<input type="hidden" id="errorInfo" value="${errorInfo}"/>
	<input type="hidden" id="cCount" value="${cCount}"/>
	<input type="hidden" id="qCount" value="${qCount}"/>
</table>
</div>
<table id="datalist"></table>
<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.cookie.js"></script> 
<script type="text/javascript">
var title='';
var fin=1;
var arrangeid = '';
var unitid='';
var cname='';

var page= 1;
var rows=100;
var sort='';
var order='';

var back='';

var courseTotal = 0;//试题数

function cookierback(){ //加载初始数据前
	back = '${back}';
	title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
	if(back=='1'){
		arrangeid = sessionStorage.getItem(title+'-arrangeid')=='null'?'':sessionStorage.getItem(title+'-arrangeid'); //cookie空值返回null字符串
		unitid = sessionStorage.getItem(title+'-unitid')=='null'?'':sessionStorage.getItem(title+'-unitid');
		cname = sessionStorage.getItem(title+'-cname')=='null'?'':sessionStorage.getItem(title+'-cname');		
		page = sessionStorage.getItem(title+'-page')=='null'?1:parseInt(sessionStorage.getItem(title+'-page'));
		rows = sessionStorage.getItem(title+'-rows')=='null'?80:parseInt(sessionStorage.getItem(title+'-rows'));
		sort = sessionStorage.getItem(title+'-sort')=='null'?'':sessionStorage.getItem(title+'-sort');
		order = sessionStorage.getItem(title+'-order')=='null'?'':sessionStorage.getItem(title+'-order');			
	}else{
		sessionStorage.setItem(title+'-arrangeid',null);
		sessionStorage.setItem(title+'-unitid',null);
		sessionStorage.setItem(title+'-cname',null);
		sessionStorage.setItem(title+'-sort',null);
		sessionStorage.setItem(title+'-order',null);
		sessionStorage.setItem(title+'-page',null);
		sessionStorage.setItem(title+'-rows',null);
	}
}

function cookier(){ //更改筛选条件后
	sessionStorage.setItem(title+'-arrangeid',arrangeid);
	sessionStorage.setItem(title+'-unitid',unitid);
	sessionStorage.setItem(title+'-cname',cname);
	sessionStorage.setItem(title+'-sort',sort);
	sessionStorage.setItem(title+'-order',order);
	sessionStorage.setItem(title+'-page',page);
	sessionStorage.setItem(title+'-rows',rows);
}

function loader(){
	if('${back}'=='1'){
		$('#arrangeFilter').combogrid('grid').datagrid('selectRecord',arrangeid);
		$('#unitFilter').combogrid('grid').datagrid('selectRecord',unitid);
		$('#cname').searchbox('setValue',cname);
	}	
}

function filterloader(){	
	var dg_unitid = $('#unitFilter').combogrid('grid');
	var dg_arrangeid = $('#arrangeFilter').combogrid('grid');
	unitid = (dg_unitid.datagrid('getSelected')==null)?'':dg_unitid.datagrid('getSelected').ID;
	arrangeid = (dg_arrangeid.datagrid('getSelected')==null)?'':dg_arrangeid.datagrid('getSelected').ID;
	cname = $('#cname').searchbox('getValue');	
	$('#datalist').datagrid('load',{				
		unitid: unitid,
		arrangeid:arrangeid,
		cname:cname
	});
	cookier();
}

$(document).ready(function(){
	var errorInfo = $("#errorInfo").val();	
	if(errorInfo){
		toastr.warning(errorInfo);
	}
	cookierback();
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getDelQueCourseList?owner=question',
		pagination: true,
		rownumbers: false,
		pageSize: rows,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		pageNumber: page,
		queryParams:{
			unitid:unitid,
			arrangeid:arrangeid,
			cname:cname,
		},
		sortName:sort,
		sortOrder:order,
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'c_code',
		columns:[[
			  {field:'CID',checkbox:true},
			  {field:'index',title:'序号',width:10, align: 'center',formatter:function(val,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
			     return (pageSize * (currentPage -1))+(index+1);
			  }},
			  {field:'CODE',title:'课程编码',width:40,align:'left',sortable:true},
		      {field:'NAME_C',title:'课程中文名',width:40,align:'left',sortable:true},
	          {field:'UNAME',title:'授课单位',width:40,align:'left'},
	          {field:'QCOUNT',title:'试题数',width:40,align:'left'},
	          {field:'opration',title:'操作',width:120,align:'center',formatter:function(value,row,index){
	        	  var s1 = "<a href=\"javascript:void(0);\" class=\"editcls1\" onclick=\"checkQuestionPermission('"+row.CID+"','question:view','${pageContext.request.contextPath}/question/DelQuestionList?c_id=" + row.CID + "')\"></a>";
	        	  var s4 = "<a href=\"javascript:void(0);\" class=\"editcls4\" onclick=\"checkQuestionPermission('"+row.CID+"','question:verify','${pageContext.request.contextPath}/question/QuestionList4Verify?c_id=" + row.CID + "')\"></a>";
	        	  var s6 = '<a href="javascript:void(0)" class="editcls6" onclick="delAll('+ row.CID+ ')"></a>';

	        	  var s2 = '<a href="javascript:void(0)" onclick="distributionStatistics('+row.CID+')" class="editcls2"></a>';
	        	  var s3 = '<a href="javascript:void(0)" class="editcls3" onclick="workLoad('+ row.CID +')"></a>';
	        	  var s7 = '<a href="javascript:void(0)" class="editcls7" onclick="exportAll('+ row.CID +')"></a>';
	        	  //var s4 = '<a href="${pageContext.request.contextPath}/question/QuestionList?c_id=' + row.CID + '" class="editcls4"></a>';
	        	  var s5 = '<a href="javascript:void(0)" class="editcls5" onclick="replaceQuestionType(\''+ row.CID + '\',\'' + row.NAME_C +'\')"></a>';
	        	  //var s6 = '';
	        	  <%--<shiro:hasRole name="administrator"> s6 = '<a href="javascript:void(0)" class="editcls6" onclick="delAll('+ row.CID+ ')"></a>';</shiro:hasRole>--%>
	        	  return s1 + s2 + s3 + s4 + s5 + s6 +s7;
	        	  //return s1 + s2 + s3 + s4 + s6;
	          }}
	    ]],
	    onCheck:function(rowIndex,rowData){
	    	courseTotal = 0;
	        //获取所选中行
	        var selected = $('#datalist').datagrid('getChecked'); 
	        for(var i = 0;i < selected.length; i++){
	        	 courseTotal += selected[i].QCOUNT;
	        }
	      //总课程数、总试题数赋值
		    $(".datagrid-pager table").next().html(selected.length+"门课程，"+courseTotal+"道试题"); 
	    },
	    onUncheck:function(rowIndex,rowData){
		    //取消选中
	    	courseTotal = courseTotal-rowData.QCOUNT;
	    	var selected = $('#datalist').datagrid('getChecked'); 
	    	if(selected.length == 0){
	    		$(".datagrid-pager table").next().html($("#cCount").val()+"门课程，"+$("#qCount").val()+"道试题");
	    	}else{
	    		$(".datagrid-pager table").next().html(selected.length+"门课程，"+courseTotal+"道试题"); 
	    	}
		},
		onCheckAll:function(rows){
		    //全选中  datagrid-header-check
		    var currentCount = 0
		    for(var item in rows){
		    	currentCount += rows[item].QCOUNT;
		    }
		    courseTotal = currentCount;
	    	$(".datagrid-pager table").next().html(rows.length+"门课程，"+courseTotal+"道试题"); 
		},
		onUncheckAll:function(rows){
		    //反选	
		    var currentCount = 0
		    for(var item in rows){
		    	currentCount += rows[item].QCOUNT;
		    }
		    courseTotal = currentCount;
	    	$(".datagrid-pager table").next().html($("#cCount").val()+"门课程，"+courseTotal+"道试题"); 
		   // $(".datagrid-pager table").next().html(data.cCount+"门课程，"+data.qCount+"道试题");
		},
	    onLoadSuccess:function(data){
	    	$('.editcls1').linkbutton({text:'编辑试题',plain:true});
	        /*$('.editcls2').linkbutton({text:'分布统计',plain:true});
	        $('.editcls3').linkbutton({text:'工作量',plain:true});
	        $('.editcls4').linkbutton({text:'审核试题',plain:true});
	        $('.editcls5').linkbutton({text:'题型替换',plain:true});
	        $('.editcls6').linkbutton({text:'删除所有试题',plain:true});
	        $('.editcls7').linkbutton({text:'导出试题库到excel',plain:true});*/
	        getCourse_QuestionCount(unitid,arrangeid,cname);
	        if(page!=$('#datalist').datagrid('getPager').data('pagination').options.pageNumber){
	        	page = $('#datalist').datagrid('getPager').data('pagination').options.pageNumber;
	        	cookier();
	        }
	        if(fin==1){
	        	var str="<div style='float:left;margin: 0 6px;height: 30px;line-height: 30px;'>"+$("#cCount").val()+"门课程，"+$("#qCount").val()+"道试题</div>";
		        $(".pagination-info").before(str);
		        fin=0;
	        }
	    },
		 onSortColumn:function(sorts,orders){
				sort = sorts;
				order = orders;
				cookier();
			}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	$(p).pagination({
		onChangePageSize:function(pageSize){
			rows = pageSize;
			cookier();
		}
	});
	
	$('#arrangeFilter').combogrid({
		url: '${pageContext.request.contextPath}/common/getArrangement',
		idField: 'ID',
		textField: 'NAME',
		editable: false,
		columns:[[
			{field:'NAME',title:'适应层次',width:169,sortable:true}
		]],
		onSelect:function(data){
			let arrangeidChosen = '';
	    	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		arrangeidChosen = $('#unitFilter').combogrid('grid').datagrid('getSelected');
	    	}
			if(arrangeidChosen!=arrangeid){
				filterloader();
			}
		},
		onLoadSuccess:function(){
			$('#arrangeFilter').combogrid('setValue','适应层次');
			loader();
		}
	});
	
	$('#unitFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getUnit',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'授课单位',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	let unitidChosen = '';
	    	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
	    		unitidChosen = $('#unitFilter').combogrid('grid').datagrid('getSelected');
	    	}
			if(unitidChosen!=unitid){
				filterloader();
			}
		},
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '授课单位');
	        loader();
	    }
	});
});

function doSearch(value,name){//通用查询框	
	cname = value;
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if($('#arrangeFilter').combogrid('grid').datagrid('getSelected')!=null){
		arrangeid = $('#arrangeFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	cookier();
	$('#datalist').datagrid('load',{
		unitid: unitid,
		arrangeid: arrangeid,
		cname: value
	});
}

function getCourse_QuestionCount(unitid,arrangeid,cname){
	$(".datagrid-wrap").addClass('change').attr('data-content', "0门课程，0道试题");
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getCourse_QuestionCount",
        async: true, 
        type: "POST",
        traditional: true,
        data: {"unitid":unitid,"arrangeid":arrangeid,"cname":cname,"state":2},
        success: function (data) {
        	var cCount = 0;
        	var qCount = 0;
        	if(typeof(data.cCount) != 'undefined'){
        		cCount = data.cCount;
        	}else{
        		cCount = 0;
        	}
        	$("#cCount").val(cCount);
        	if(typeof(data.qCount) != 'undefined'){
        		qCount = data.qCount;
        	}else{
        		qCount = 0;
        	}
        	$("#qCount").val(qCount);
        	$(".datagrid-wrap").addClass('change').attr('data-content', cCount+"门课程，"+qCount+"道试题");
        	$(".datagrid-pager table").next().html(cCount+"门课程，"+qCount+"道试题");
        }
	});	
}

function replaceQuestionType(cid,cname){
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getQTlist_haveQuestion",
        async: false,//改为同步方式
        type: "POST",
        data: { "cid":cid },
        success: function (data) {
    		var str = '';
    		var str1= '';
    		for(var i=0; i<data.questionTypeList_HQ.length; i++){
    			str += '<option value="' + data.questionTypeList_HQ[i].QTID+ '">' + data.questionTypeList_HQ[i].QTNAME + '</option>';
    		}
    		for(var i=0; i<data.questionTypeList.length; i++){
    			str1 += '<option value="' + data.questionTypeList[i].QTID+ '">' + data.questionTypeList[i].QTNAME + '</option>';
    		}
    		
    		var winStr = '<form id="QTForm" method="post"><table width="100%">'
    		    + '<tr><td align="right">原题型：</td><td align="left"><select onchange="showTips('+cid+')" style="width:220px;" id="original" name="original">'
    			+ str
    			+ '</select></td></tr><tr><td align="right">替换为：</td><td align="left">'
    			+ '<select onchange="showTips('+cid+')" style="width:220px;" name="new" id="new">'
    			+ str1
    			+ '<option selected="selected" hidden disabled value="-999">选择一个要替换的题型</option>'
    			+ '</select></td></tr><tr><td colspan=2 id=tips align=center style="text-align:center;font-size:7px;color:blue">请选择同样类型的题型进行替换</td></tr></table>'
    			+ '<input id="cid" name="cid" value="' + cid + '" type="hidden"/>'
    			+ '<div style="width: 100%; text-align:center; margin-top:10px">'
    			+ '<input type="button" class="l-btn-left" id="sure" value="确定" onclick="submitQTForm()"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
    			+ '<input type="button" class="l-btn-left" value="取消" onclick="$(\'#win\').window(\'close\')"/></div></form>';
    			var obj = $(winStr);
    			$('#win').html(null);
    			obj.appendTo('#win');
    		$('#win').window({
    			width:350,
    			height:160,
    			modal:true,
    			title:"课程："+cname+" 题型替换",
    			collapsible:false,
    			minimizable:false,
    			maximizable:false,
    			//content:winStr
    		}); 
 		}
 	});	
	document.getElementById("sure").disabled=true;
}

function showTips(cid){
	
	if(document.getElementById("new").value=="-999"){
		document.getElementById("tips").innerText="请选择同样类型的题型进行替换";
  		document.getElementById("tips").style.color="blue";
  		document.getElementById("sure").disabled=true;
	}else if(document.getElementById("new").value == document.getElementById("original").value){
		document.getElementById("tips").innerText="不可以替换成同样的题型";
  		document.getElementById("tips").style.color="orange";
  		document.getElementById("sure").disabled=true;
	}else{
		$.ajax({
	          url: '${pageContext.request.contextPath}/course/isSameQT',
	          async: false, 
	          type: "POST",
	          data: {"new":document.getElementById("new").value,"original":document.getElementById("original").value,"cid":cid},
	          success: function (data) {
	          	if(data==1){
	          		document.getElementById("tips").innerText="点击确定进行替换";
	          		document.getElementById("tips").style.color="green";
	          		document.getElementById("sure").disabled=false;
	          	}else{
	          		document.getElementById("tips").innerText="两种题型类型不一致，无法替换";
	          		document.getElementById("tips").style.color="red";
	          		document.getElementById("sure").disabled=true;
	          	}
			  }
		});
	}
}

function submitQTForm(){
	$.messager.defaults = { ok: "确定", cancel: "取消" };
	$.messager.confirm({
		    width: '380',
		    title: '提示',
		    msg: '注意：题型替换操作无法撤回，是否继续?',
		    fn: function (r) {
		         if (r){
		        	 $('#QTForm').form('submit', {
		        		    url:'${pageContext.request.contextPath}/course/replaceQT',
		        		    success:function(data){
		        	    		if(data>0){
		        	    			$('#win').window('close');
		        	    			toastr.success("题型替换成功！");
		        	    		}else{
		        	    			toastr.warning("题型替换失败！");
		        	    		}
		        		    }
		        		});
			    }
		    }
		});
}

function delAll(cid){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:patchDel"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
				$.messager.confirm("提示",'是否要删除所有试题 ?',function(r){ 
				    if (r){
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/question/delAll",
				            async: false, 
				            type: "POST",
				            data: { "cid":cid },
				            success: function (data) {
				            	$('#datalist').datagrid('reload');
				     		}
				     	});	
				    }
				});	
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
	
}

function workLoad(cid){
	var url = '${pageContext.request.contextPath}/question/inWorkLoad?c_id='+ cid;
	openIframeDialog({
		title: '工作量统计',
		url: url,
		fit: true 
	});
}

function checkQuestionPermission(cid,permission,url){
	var params = {};
	params["cid"] = cid;
	params["permission"] = permission; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		window.location.href = url;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
}

function distributionStatistics(cid){
	toastr.warning("获取分布数据需要一点时间，请耐心等待");
	//window.location.href = "${pageContext.request.contextPath}/question/distributionStatistics?c_id=" + cid;
	var url = "${pageContext.request.contextPath}/question/distributionStatistics?c_id=" + cid;
	openIframeDialog({
		title: '分布统计',
		url: url,
		fit: true 
	});
}

function exportAll(cid){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:export"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var url = "${pageContext.request.contextPath}/question/exportAll?cid="+cid;
				window.location.href = url;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
	
	//${pageContext.request.contextPath}/question/exportAll?cid=${cid}
}
</script>	

