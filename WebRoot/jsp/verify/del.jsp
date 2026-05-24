<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.messager-body{
	max-height: 500px;
	overflow-y: auto;
}
tr{
	line-height: 20px;
}
.qcontent{
	height: 40px;
	overflow:hidden;
}
.plimit{
	padding:2px .8px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	min-width: 100px;
	max-width: 280px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
.select2-container .select2-selection--single .select2-selection__rendered{
	font-size:12px;
}
a{text-decoration:none;color:black;}
a:hover { color:blue; }
.wrap{white-space:normal;}
</style>
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<shiro:hasRole name="expert">
	<input type="hidden" id="role" name="role" value="7"/>
</shiro:hasRole>
<table height="35px" width="100%">
	<tr>
		<th style="text-align:center;font-size:20px;">暂时删除的考试计划、试卷</th>
	</tr>
</table>
<table cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			
			<select id="unitList" name="unitList" class="plimit" onchange="paperFilter()">
				<option value="">不限教学单位</option>
				<c:forEach var="unit" items="${applicationScope.unitList}">
					<option value="${unit.ID}">${unit.NAME}</option>
				</c:forEach>
			</select>
			<select id="courseList" name="courseList" class="plimit" onchange="paperFilter()">
				<option value="">不限课程</option>
				<c:forEach var="course" items="${courseList}">
					<option value="${course.CID}">${course.CNAME}</option>
				</c:forEach>
			</select>
			<select id="gradeList" name="gradeList" class="plimit" onchange="paperFilter()">
				<option value="">不限年级</option>
				<c:forEach var="grade" items="${applicationScope.grade}">
					<option value="${grade.ID}">${grade.NAME}</option>
				</c:forEach>
			</select>
			<select id="specialtyList" name="specialtyList" class="plimit" onchange="paperFilter()">
				<option value="">不限专业</option>
				<c:forEach var="specialty" items="${applicationScope.specialtyList}">
					<option value="${specialty.ID}">${specialty.NAME}</option>
				</c:forEach>
			</select>
			</td>
			<td>
				<input id="searchByNum" data-options="prompt:'按试卷编号或试卷名称查询'" />
				<input id="searchByTeacher" data-options="prompt:'按组卷人实名或用户名查询'" />
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			</td>
	</tr>
	<tr><td><a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="deleteSelectPaper()">删除所选试卷</a></td></tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
var role=-1;
if(typeof($("#role").val())!="undefined"){
	role=$("#role").val();
}
$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/verify/del";
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
    var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
    reIE.test(userAgent);
    var fIEVersion = parseFloat(RegExp["$1"]);
    if(fIEVersion <= 8) {
    	
    }else{
    	$('#courseList').select2();
    	$('#unitList').select2();
    	$('#gradeList').select2();
    	$('#specialtyList').select2();
    }
	
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/verify/getPaperList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		queryParams: {
			state: -1
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'eid',checkbox:true},//var date = new Date(val)
			  {field:'num',title:'试卷编号',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.eid;
	          },sortable:true},
			  {field:'ename',title:'试卷名称',width:60,align:'left',formatter:function(value,row,index){
	          	  var s = '<div class="wrap">'+row.ename+'</div>';
		    	  return s;
	          },sortable:true}, 
	          {field:'code',title:'课程代码',width:30,align:'left'},
	          {field:'cname',title:'课程名称',width:30,align:'left'},
	          {field:'GNAME',title:'年级',width:30,align:'left',formatter:function(value,row,index){
        		  var gname=row.GNAME;
	          	  if(gname.length>20){
	          	  	var s = '<div class="wrap">'+gname.substring(0,20)+'...</div>';
		    	  	return s; 
	          	  }else{
	          	  	var s = '<div class="wrap">'+row.GNAME+'</div>';
	    	  	  	return s;
	          	  }
	          }},
	          {field:'SNAME',title:'专业',width:40,align:'left',formatter:function(value,row,index){
	        	  var sname=row.SNAME;
	          	  if(sname.length>20){
	          	  	var s = '<div class="wrap">'+sname.substring(0,20)+'...</div>';
		    	  	return s; 
	          	  }else{
	          	  	var s = '<div class="wrap">'+row.SNAME+'</div>';
		    	  	return s; 
	          	  }    	  
	          }},
            {field:'examDate',title:'考试日期',width:30,align:'center'},
            {field:'examTime',title:'考试时间',width:30,align:'center'},
	          // {field:'begindate',title:'考试日期',width:30,align:'center',formatter:function(value,row,index){
	        	//   var rs = '';
	        	//   var bdate = new Date(row.begindate).format("yyyy-MM-dd");
	        	//   var edate = new Date(row.enddate).format("yyyy-MM-dd");
	        	//   if (bdate == edate){
	        	// 	  rs = bdate;
	        	//   }else{
	        	// 	  rs = bdate + '<br/>--' + edate;
	        	//   }
	        	//   return rs;
	          // }},
	          // {field:'enddate',title:'考试时间',width:30,align:'center',formatter:function(value,row,index){
	        	//   var rs = '';
	        	//   var btime = new Date(row.begindate).format("hh:mm");
	        	//   var etime = new Date(row.enddate).format("hh:mm");
	        	//   rs = btime + '--' + etime;
	        	//   return rs;
	          // }},
	          {field:'tname',title:'组卷人',width:25,align:'left',sortable:true,formatter:function(value,row,index){
				  var tname = row.tname + "( "+row.USERNAME+" )";
				  return tname;
			  }},
	          {field:'EI',title:'考务信息',width:30,align:'left',formatter:function(value,row,index){
	        	  //var s1 = '<a href="${pageContext.request.contextPath}/verify/viewExamInfo?c_id=' + row.cid + '&ei_id=' + row.eid +'" class="viewExamInfo"></a>';
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/inEditExamInfo?cid=' + row.cid + '&eid=' + row.eid + '" class="editExamInfo"></a>';
	        	  var s1 = "<a href=\"javascript:void(0);\" class=\"viewExamInfo\" onclick=\"inViewExamInfo('"+row.cid+"','"+row.eid+"','"+row.ename+"')\"></a>";
	        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editExamInfo\" onclick=\"inEditExamInfo('"+row.cid+"','"+row.eid+"','"+row.ename+"')\"></a>";
				  if(role==7){
					  return '<div class="wrap">'+s1+'</div>';
				  }else{
					  return '<div class="wrap">'+s1 + s2+'</div>';
				  }
	          }},
	          {field:'PAPER',title:'试卷',width:50,align:'left',formatter:function(value,row,index){
	        	  var s1 = '';
	        	  if(row.aorb == 0){
	        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">A卷"+row.asum + '题'+"</a>&nbsp;&nbsp;";
	        		  //s1 = 'A卷 ' + row.asum + '题&nbsp;&nbsp;';
	        	  }else if(row.aorb == 1){
	        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">B卷"+row.asum + '题'+"</a>&nbsp;&nbsp;";
	        		  //s1 = 'B卷 ' + row.asum + '题&nbsp;&nbsp;';
	        	  }
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/editApaper?c_id=' + row.cid + '&ei_id=' + row.eid +'" class="editPaperA""></a>';
	        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editPaperA\" onclick=\"editPaperA('"+row.cid+"','"+row.eid+"')\"></a>";	        	  
	        	  //var s3 = getPaperStudentCount(row.bid) + '考生';
	        	  var s3 = row.scount + '考生';
				  if(role==7){
					  return '<div class="wrap">'+s1+s3+'</div>';
				  }else{
                      return '<div class="wrap">'+s1 + s3 + s2+'</div>';
				  }

	        	  
	          }},
	          {field:'opration',title:'操作',width:50,align:'center',formatter:function(value,row,index){
				  if(role==7){
					  $('#datalist').datagrid('hideColumn', 'opration');
				  }else{
					  $('#datalist').datagrid('showColumn', 'opration');
				  }
				  var s1 = '';
				  if(row.aorb == 0){
				   	 s1 = '<a href="javascript:void(0)" class="cancelDel" onclick="cancelDel(' + row.eid + ',' + row.aorb +  ',' + row.bid + ')"></a>';
				  }
	        	  var s2 = '<a href="javascript:void(0)" class="completeDel" onclick="completeDel(' + row.eid + ')"></a>';
	        	  return '<div class="wrap">'+s1+s2+'</div>';
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewExamInfo').linkbutton({text:'查看',plain:true});
	    	$('.editExamInfo').linkbutton({text:'编辑',plain:true});
	        $('.editPaperA').linkbutton({text:'编辑',plain:true});
	        $('.testPaperA').linkbutton({text:'测试',plain:true});
	        $('.deletePaperA').linkbutton({text:'删除',plain:true});
	        $('.editPaperB').linkbutton({text:'编辑',plain:true});
	        $('.testPaperB').linkbutton({text:'测试',plain:true});
	        $('.deletePaperB').linkbutton({text:'删除',plain:true});
	        $('.cancelDel').linkbutton({text:'取消删除',plain:true});
	        $('.completeDel').linkbutton({text:'彻底删除',plain:true}); 
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	
});

function cancelDel(eid, aorb, bid){
	var params = {};
	params["eid"] = eid;
	params["permission"] = "paper:del"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$.ajax({
			        url: "${pageContext.request.contextPath}/verify/cancelDel",
			        async: true,//改为同步方式
			        type: "POST",
			        traditional: true,
			        data: { "eid":eid, "aorb":aorb, "bid":bid},
			        success: function (data) {
			    		$('#datalist').datagrid('reload');
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

function completeDel(eid){
	var params = {};
	params["eid"] = eid;
	params["permission"] = "paper:del"; 
	$.messager.confirm('彻底删除试卷', '您是否要彻底删除此试卷？', function(r){
		if (r){
			$.ajax({
				  contentType: "application/json; charset=utf-8",
		          url: '${pageContext.request.contextPath}/verify/checkPaperPermission',
		          async: false, 
		          type: "POST",
		          data: JSON.stringify(params),
		          success: function (data) {
		          	if(data==1){
		          		$.ajax({
					        url: "${pageContext.request.contextPath}/verify/completeDel",
					        async: true,//改为同步方式
					        type: "POST",
					        traditional: true,
					        data: { "eid":eid},
					        success: function (data) {
					    		$('#datalist').datagrid('reload');
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
	});
}

$('#searchByNum').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	num : value,
	    	teacher : $('#searchByTeacher').searchbox('getValue'),
	    	state : '-1'
		})
	}
	
})


$('#searchByTeacher').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	num : $('#searchByNum').searchbox('getValue'),
	    	teacher : value,
	    	state : '-1'
		})
	}
	
})


function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	state : '-1',
    	num : $('#searchByNum').searchbox('getValue'),
    	teacher : $('#searchByNum').searchbox('getValue'),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

function getPaperStudentCount(eid){
	var res = 0;
	$.ajax({
        url: "${pageContext.request.contextPath}/monitor/getPaperStudentCount",
        async: false,
        type: "POST",
        data: { 'eid':eid },
        success: function (data) {
		    res = data;
		    return res;
 		}
 	});
	return res;
}

function deleteSelectPaper(){
	var str="";
	var rows = $('#datalist').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		str+="<br/>"+rows[i].eid+":"+rows[i].ename;
	}
	$.messager.confirm('删除试卷', '您确定要彻底删除试卷'+str+'？', function(r){
		if (r){
			var eid = $('input[name="eid"]:checked');
			if(eid.length > 0){
				var par = [];
				var data = {};
				$(eid).each(function(){
					var p = {"eid":$(this).val()};
					par.push(p);
				})
				data = {"data":par}
				$.ajax({
					contentType: "application/json; charset=utf-8",
					url: "${pageContext.request.contextPath}/verify/completeDelSelect",
					async: false,
					type: "POST",
					data: JSON.stringify(data),
					success: function (rs){
						$('#datalist').datagrid('reload');
						toastr.success("删除成功！");
					}
				})
			}else{
				toastr.warning("你还没有选中试卷");
			}
		}
	});	
}

function inViewExamInfo(cid,eid,ename){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/viewExamInfo?cid=" + cid + "&eid=" + eid,
		fit:true,
		title:"《"+ename+"》考务信息"
	},0);
}

function inEditExamInfo(cid,eid,ename){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/inEditExamInfo?cid=" + cid + "&eid=" + eid,
		fit:true,
		title:"《"+ename+"》考务信息"
	},0);
}

function editPaperA(cid,eid){
	var params = {};
	params["eid"] = eid;
	params["permission"] = "paper:update"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		if(typeof(mqid) == "undefined"){
					mqid = "";
				}
          		/*
				var url = "${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid;
				var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
				window.parent.$('#nav_tab').tabs('add',{
					title: '编辑A卷试题',
					content: content,
					closable: true 
				});*/
          		window.location.href="${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
	
}

function seePaper(eid){
	/*
	openIframeDialog({
		url:'${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + eid,
		fit:true,
		title:'预览试卷'
	},0);*/
	var url = '${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + eid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '预览试卷',
		content: content,
		closable: true 
	}); 
}
</script>	