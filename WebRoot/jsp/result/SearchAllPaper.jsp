<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<style>
tr{
	line-height: 20px;
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
<input type="hidden" id="nowTime" name="nowTime" value="${nowTime}">
<shiro:hasRole name="expert">
	<input type="hidden" id="role" name="role" value="7"/>
</shiro:hasRole>
<table style="height: 35px;width: 100%;">
	<tr>
		<th style="text-align:center;font-size:20px;">查询所有试卷</th>
	</tr>
</table>
	<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
		<tr>
		<td colspan=2>
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
			<select id="examType" name="examType"  class="plimit" onchange="paperFilter()">
				<option value="">不限考试类型</option>
				<c:forEach var="examType" items="${applicationScope.examTypeList}">
					<option value="${examType.ID}">${examType.NAME}</option>
				</c:forEach>
			</select>
			<select id="schoolYear" name="schoolYear" class="plimit" onchange="paperFilter()">
				<option value="">不限学年</option>
				<c:forEach var="sy" items="${applicationScope.schoolYear}">
					<option value="${sy.ID}">${sy.NAME}</option>
				</c:forEach>
			</select>
			<select id="termList" name="termList" class="plimit" onchange="paperFilter()">
				<option value="">不限学期</option>
				<c:forEach var="term" items="${applicationScope.term}">
					<option value="${term.ID}">${term.NAME}</option>
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
			<select id="teacherList" name="teachertList" class="plimit" onchange="paperFilter()">
				<option value="">不限组卷人</option>
				<c:forEach var="teacher" items="${teacherList}">
					<option value="${teacher.id}">${teacher.realname}</option>
				</c:forEach>
			</select>
			<select id="aorb" name="aorb" class="plimit" onchange="paperFilter()">
				<option value="">不限AB卷</option>
				<option value="0">A卷</option>
				<option value="1">B卷</option>
				<c:if test="${applicationScope.enable_c_switch==1}">
					<option value="2">C卷</option>
				</c:if>
			</select>
			
			<input id="searchByNum" style="width: 375px;" data-options="prompt:'输入试卷编号或名称，试卷编号可按逗号分隔批量查询'" />
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="exportPaperList();">导出试卷清单</a>
		</td>
		</tr>
		<tr>
			<td  colspan="2">
				查找从&nbsp;<input id="bdate" type="text" style="width:160px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px"/>&nbsp;的试卷 <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchByDate()" data-options="iconCls:'icon-search'">查询</a>
				<button class="entry-button" type="button" style="font-size: 14px;font-weight: bold;" onclick="toPaperQuestionRepeatCompare()">勾选2套试卷以比较重复试题</button>
			</td>
		</tr>
</table>
</div>
<table id="datalist"></table>
<shiro:hasAnyRoles name="administrator,dean">
</shiro:hasAnyRoles>

<script type="text/javascript">
var role=-1;
if(typeof($("#role").val())!="undefined"){
	role=$("#role").val();
}
$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/result/SearchAllPaper";
	$('#courseList').select2();
	$('#unitList').select2();
	$('#gradeList').select2();
	$('#specialtyList').select2();
	$('#teacherList').select2();
	$('#aorb').select2();
	$('#termList').select2();
	$('#examType').select2();
	$('#schoolYear').select2();
	
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/result/getAllResultPaper',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		queryParams:{
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'eid',checkbox:true},
			  {field:'num',title:'试卷编号',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.eid;
	          },sortable:true},
			  {field:'ename',title:'试卷名称',width:80,align:'left',formatter:function(value,row,index){
				  let ename = row.ename;
				  let rtn = '';
				  if(ename && ename.length>20){
					  rtn = '<div class="wrap">'+ename.substring(0,20)+'...</div>';
				  }else{
					  if(!ename){
						  ename='';
					  }
					  rtn = '<div class="wrap">'+ename+'</div>';
				  }
				  if(row.random == 1){
					  return rtn + "<div style='color: red'>（千人千题模式）</div>"
				  }
				  return rtn;
	          },sortable:true}, 
	          {field:'code',title:'课程代码',width:30,align:'left'},
	          {field:'cname',title:'课程名称',width:30,align:'left',formatter:function(value,row,index){
	          	  let cname = row.cname;
		          	if(cname && cname.length>15){
		          	  	return '<div class="wrap">'+cname.substring(0,15)+'...</div>';
		          	  }else{
						if(!cname){
							cname='';
						}
						return '<div class="wrap">'+cname+'</div>';
		          	  }
		          }},
			  {field:'GNAME',title:'年级',width:30,align:'left',formatter:function(value,row,index){
	        	  let gname=row.GNAME;
	          	  if(gname && gname.length>20){
					  return '<div class="wrap">'+gname.substring(0,20)+'...</div>';
	          	  }else{
					  if(!gname){
						  gname='';
					  }
					  return '<div class="wrap">'+gname+'</div>';
	          	  }
	          }},
	          {field:'SNAME',title:'专业',width:40,align:'left',formatter:function(value,row,index){
	        	  let sname=row.SNAME;
	          	  if(sname && sname.length>20){
	          	  	return '<div class="wrap">'+sname.substring(0,20)+'...</div>';
	          	  }else{
					  if(!sname){
						  sname='';
					  }
	          	  	return '<div class="wrap">'+sname+'</div>';
	          	  }
	          }},
            {field:'examDate',title:'考试日期',width:30,align:'center',formatter:function(value,row,index){
				let bd = new Date(row.begindate);
				let ed = new Date(row.enddate);
				let beginExamDate = bd.getFullYear() + "-"+ (bd.getMonth() + 1) + "-" + bd.getDate();
				let endExamDate = ed.getFullYear() + "-"+ (ed.getMonth() + 1) + "-" + ed.getDate();
				if(beginExamDate===endExamDate){
					return beginExamDate;
				}
				return beginExamDate + '<br>--' + endExamDate;
			}},
            {field:'examTime',title:'考试时间',width:30,align:'center',formatter:function(value,row,index){
				let bd = new Date(row.begindate);
				let ed = new Date(row.enddate);
				let beginExamTime = padZero(bd.getHours()) + ":"+ padZero(bd.getMinutes());
				let endExamTime = padZero(ed.getHours()) + ":"+ padZero(ed.getMinutes());
				return beginExamTime + '--' + endExamTime;
			}},
            {field:'tyname',title:'考试类型',width:30,align:'center'},
	          {field:'tname',title:'组卷人',width:25,align:'left',sortable:true,formatter:function(value,row,index){
				  let tname = row.tname + "( "+row.USERNAME+" )";
				  return tname;
			  }},
			  {field:'APAPER',title:'AB卷',width:60,align:'center',formatter:function(value,row,index){
	        	  let ss=row.state;
	        	  switch (ss){
	        	  	case -2:
					case -1:
						var s1 = '';
			        	  if(row.aorb == 0){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">A卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        		  //s1 = 'A卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else if(row.aorb == 1){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">B卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        		  //s1 = 'B卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else{
			        		  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">C卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        	  }
			        	  var s3 = '<a href="${pageContext.request.contextPath}/monitor/intoMonitor?eid=' + row.eid + '&justsearch=yes'+'&type=today" class="intoMonitor">'+row.STUEXAMCOUNT + '考生'+'</a>';
			        	  return '<div class="wrap">'+s1 + s3 +'</div>';
						break;
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
						var s1 = '';
						var s4='';
			        	  if(row.aorb == 0){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">A卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        	  	s4= "<a href=\"javascript:void(0);\" class=\"testPaperA\" onclick=\"testPaper('"+row.eid+"',"+row.asum+")\"></a>";
			        		  //s1 = 'A卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else if(row.aorb == 1){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">B卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        	  	s4= "<a href=\"javascript:void(0);\" class=\"testPaperB\" onclick=\"testPaper('"+row.eid+"',"+row.asum+")\"></a>";
			        		  //s1 = 'B卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else{
			        		  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">C卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
				        	  	s4= "<a href=\"javascript:void(0);\" class=\"testPaperB\" onclick=\"testPaper('"+row.eid+"',"+row.asum+")\"></a>";
			        	  }
			        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/editApaper?c_id=' + row.cid + '&ei_id=' + row.eid +'" class="editPaperA""></a>';
			        	  //var s2 = "<a href=\"javascript:void(0);\" class=\"editPaperA\" onclick=\"editPaperA('"+row.cid+"','"+row.eid+"')\"></a>";	可能用到
			        	  var s3 =  '<a href="${pageContext.request.contextPath}/monitor/intoMonitor?eid=' + row.eid + '&justsearch=yes'+'&type=today" class="intoMonitor">'+row.STUEXAMCOUNT + '考生'+'</a>';
			        	  return '<div class="wrap">'+s1 + s3 + s4 + '</div>';
						break;
				 	case 5:
					case 6:
					case 7:
					case 8:
						var s1 = '';
			        	  if(row.aorb == 0){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">A卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        		  //s1 = 'A卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else if(row.aorb == 1){
			        	  	  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">B卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        		  //s1 = 'B卷 ' + row.asum + '题&nbsp;&nbsp;';
			        	  }else{
			        		  s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">C卷 "+row.asum + '题'+"</a>&nbsp;&nbsp;";
			        	  }
						  let scountTmp = row.SCOUNT?row.SCOUNT:0;
			        	  var s3 = '<a href="${pageContext.request.contextPath}/result/analysisStudentPaper?cid=' + row.cid + '&justsearch=yes'+'&eid=' + row.eid + '" class="analysisStudentPaper">'+scountTmp+'考生'+'</a>';
			        	  var s4 = "<a href=\"javascript:void(0);\" class=\"checkList\" onclick=\"checkList('"+row.cid+"','"+row.eid+"')\"></a>";
			        	  return '<div class="wrap">'+s1 + s3 + s4 + '</div>';
						break;
					default:
					   var s1 = '未知状况'
		        	   return '<div class="wrap">'+s1+'</div>';
						break;
					}
	          }},
	          {field:'TESTSTATE',title:'试卷状态',width:55,align:'center',sortable:true,formatter:function(value,row,index){
	        	  var ss=row.state;
	          	var s = '<div class="wrap">';
	          	switch(ss){
	          	case -2:
					s+= '通过终审，未启用';
					break;
				case -1:
					s+= '暂时删除不用';
					break;
				case 0:
					s+= '尚未提交审核';
					break;
				case 1:
					s+= '等待初审';
					break;
				case 2:
					s+= '等待终审';
					break;
				case 3:
					if($("#nowTime").val()<row.begindate){
						s+= '等待考试(通过终审，已采用)';
					}else if($("#nowTime").val()>row.begindate&&$("#nowTime").val()<row.enddate){
						s+= '考试开始，未结束';
					}else if($("#nowTime").val()>row.enddate){
						s+= '考试结束，未收卷';
					}else{
						s+= 'error';
					} 
					//s+= '等待考试(通过终审，已采用)';
					break;
				case 4:
					s+= '等待考试(通过终审，已采用)';//没有4这个状态，3不会变成4
					break;
				case 5:
					s+= '考试结束，未收卷';//5也不存在
					break;
				case 6:
					s+= '已改出成绩归档';
					break;
				case 7:
					s+= '审核未通过';
					break;
				case 8:
					s+= '考试结束，已收卷';
					break;
				default:
					s+='未知状态';
					break;
				}
	          	if(row.mobile==1 || row.mobile==3){
	          		s+='[过程性评价]'
	          	}
		    	  s+='</div>';
		    	  return s;
	          }},          
	          //{field:'CONAME',title:'组卷人',width:40,align:'left',sortable:true},
	          {field:'EI',title:'考务信息',width:40,align:'center',formatter:function(value,row,index){
	        	  //var s1 = '<a href="${pageContext.request.contextPath}/verify/viewExamInfo?c_id=' + row.cid + '&ei_id=' + row.eid +'" class="viewExamInfo"></a>';
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/inEditExamInfo?cid=' + row.cid + '&eid=' + row.eid + '" class="editExamInfo"></a>';
	        	  //var s1 = "<a href=\"javascript:void(0);\" class=\"viewExamInfo\" onclick=\"checkPaperPermission('"+row.eid+"','paper:view','${pageContext.request.contextPath}/verify/viewExamInfo?c_id=" + row.cid + "&ei_id=" + row.eid+"')\"></a>";
	        	  //var s2 = "<a href=\"javascript:void(0);\" class=\"editExamInfo\" onclick=\"checkPaperPermission('"+row.eid+"','paper:update','${pageContext.request.contextPath}/paper/inEditExamInfo?cid=" + row.cid + "&eid=" + row.eid+"')\"></a>";
	        	  var s1 = "<a href=\"javascript:void(0);\" class=\"viewExamInfo\" onclick=\"inViewExamInfo('"+row.cid+"','"+row.eid+"','"+row.ename+"')\"></a>";
	        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editExamInfo\" onclick=\"inEditExamInfo('"+row.cid+"','"+row.eid+"','"+row.ename+"')\"></a>";
				  if(role==7){
					  return '<div class="wrap">'+s1+'</div>';
				  }else{
					  return '<div class="wrap">'+s1 + s2+'</div>';
				  }
	          }},
	          
	          {field:'BPAPER',title:'操作',width:60,align:'center',formatter:function(value,row,index){
				  var s='';
	        	  var s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">预览试卷 "+"</a>&nbsp;&nbsp;";
	        	  var s2='';
	        	  
	        	  if(row.state<5){
	        		  s2='<a href="${pageContext.request.contextPath}/monitor/intoMonitor?eid=' + row.eid + '&justsearch=yes'+'&type=today" class="intoMonitor">'+ '查看考生'+'</a>';
	        	  }else{
	        		  s2='<a href="${pageContext.request.contextPath}/result/analysisStudentPaper?cid=' + row.cid + '&rstate=1'+'&justsearch=yes'+'&eid=' + row.eid + '" class="analysisStudentPaper">'+'查看考生'+'</a>';
	        	  }
	        	  
	        	  if(!row.bid){
	        		  s = '';
	        	  }else{
	        		  s = "<a href=\"javascript:void(0);\" class=\"seeRelevantPaper\" onclick=\"seeRelevantPaper('"+row.bid+"','"+row.ename+"')\"></a>";
	        	  }
	        	  return '<div class="wrap">'+s1+s2+s+'</div>';
	          }},
	    ]],
	    onLoadSuccess:function(data){
	    	$('.checkList').linkbutton({text:'细目表',plain:true});
	    	$('.viewExamInfo').linkbutton({text:'查看',plain:true});
	    	$('.editExamInfo').linkbutton({text:'编辑',plain:true});
	        $('.editPaperA').linkbutton({text:'编辑',plain:true});
	        $('.testPaperA').linkbutton({text:'测试',plain:true});
	        $('.editPaperB').linkbutton({text:'编辑',plain:true});
	        $('.testPaperB').linkbutton({text:'测试',plain:true});
	        $('.appoint').linkbutton({text:'权限设置',plain:true});
	        $('.seeRelevantPaper').linkbutton({text:'查询相关卷',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
});


$('#searchByNum').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	aorb :$('#aorb').val(),
	    	term :$('#termList').val(),
	    	teacherid : $('#teacherList').val(),
	    	num : value,
	    	teacher : $("#searchByTeacher").val()
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
	    	term :$('#termList').val(),
	    	teacherid : $('#teacherList').val(),
	    	num : $("#searchByNum").val(),
	    	teacher : value
		})
	}
	
})

function seeRelevantPaper(value, name){
	$('#searchByNum').searchbox('setValue', null);
	$('#datalist').datagrid('load',{
		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	term :$('#termList').val(),
    	rnum : value,
    	teacher : $("searchByTeacher").val()
	})
}

function checkList(cid,eid){
	var url = "${pageContext.request.contextPath}/paper/checkList?c_id=" + cid + "&ei_id=" + eid;
	/*var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '双向细目表',
		content: content,
		closable: true 
	});*/
	openIframeDialog({
		url:url,
		fit:true,
		title:'双向细目表'
	},0);
}

function paperFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	teacherid : $('#teacherList').val(),
    	aorb:$('#aorb').val(),
    	term :$('#termList').val(),
        examType:$('#examType').val(),
		schoolYear:$('#schoolYear').val(),
    	num : $('#searchByNum').val(),
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
    	type : 'today',
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

/* function testPaperA(eid){
	$.ajax({
          url: '${pageContext.request.contextPath}/paper/testPaperA',
          async: false,
          type: "POST",
          data: {"eid":eid},
          success: function (data) {
          	//window.open("${pageContext.request.contextPath}/"+data+"?id="+eid,'','fullscreen=1'); 
          	window.open("${pageContext.request.contextPath}/"+data+"?id="+eid,'_blank');        		
   		}
   	});
}
 */
 
 function testPaper(eid,num){
		if(parseInt(num)==0){
			toastr.error("试卷试题数为0，请先增加试题，然后进行模拟测试");
			return;
		}
		window.open("${pageContext.request.contextPath}/paper/testPaper?eid="+eid,'fullscreen=1'); 
	}


function checkPaperPermission(eid,permission,url){
	var params = {};
	params["eid"] = eid;
	params["permission"] = permission; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission',
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

function inViewExamInfo(cid,eid,ename){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/viewExamInfo?cid=" + cid + "&eid=" + eid+"&action=lastVerify",
		fit:true,
		title:'《'+ename+'》考务信息'
	},0);
}

function inEditExamInfo(cid,eid,ename){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/inEditExamInfo?cid=" + cid + "&eid=" + eid,
		fit:true,
		title:'《'+ename+'》'
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
				window.location.href="${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid ;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
	
}

function searchByDate(){
	var bdate = $('#bdate').datebox("getValue");
	var edate = $('#edate').datebox("getValue");
	var r1=bdate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	var r2=edate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	if(r1==null || r2==null){
		toastr.warning("请正确输入日期");
		return;
	}
	var btime = new Date(bdate);
	var etime = new Date(edate);
	if(etime=="Invalid Date" || btime=="Invalid Date"){
		toastr.warning("请输入合法的时间参数");
		return;
	}
	if(etime < btime){
		toastr.warning("开始时间不能大于结束时间");
		return;
	}
	
	var p = $('#datalist').datagrid('getPager');
	$('#datalist').datagrid('reload',{
		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	num : $('#searchByNum').val(),
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
    	type : 'today',
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
	});
}

function editPaperB(cid,bid){
	var params = {};
	params["eid"] = bid;
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
				var url = "${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid;
				var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
				window.parent.$('#nav_tab').tabs('add',{
					title: '编辑B卷试题',
					content: content,
					closable: true 
				});*/
				window.location.href="${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid ;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	}         		
   		}
   	});
	
}

function appoint(cid,eid,ename,tid){
	var params = {};
	params["eid"] = eid;
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission2',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          	/*
          		var url = "${pageContext.request.contextPath}/verify/appoint?cid=" + cid + "&eid=" + eid+ "&ename=" + ename+ "&tid=" + tid;
				var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
				window.parent.$('#nav_tab').tabs('add',{
					title: '试卷权限设置',
					content: content,
					closable: true 
				});*/
				openIframeDialog({
					url:"${pageContext.request.contextPath}/verify/appoint?cid=" + cid + "&eid=" + eid+ "&ename=" + ename+ "&tid=" + tid,
					fit:true,
					title:'试卷权限设置'
				},0);
          	}else if(data==2){
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

function padZero(num) {
	return num < 10 ? '0' + num : num;
}

function toPaperQuestionRepeatCompare(){
	const eids = [];
	if($("input[type='checkbox']").is(':checked')){
		$('input[type="checkbox"]:checked').each(function(){
			if($(this).val()!=="on"){
				eids.push($(this).val());
			}
		})
	}
	if(eids.length!==2){
		toastr.warning("只能勾选2个试卷的编号以对比");
		return;
	}

	const params = eids.map(function(eid) {
		return 'eids=' + encodeURIComponent(eid);
	}).join('&');

	openIframeDialog({
		url: "${pageContext.request.contextPath}/paper/toPaperQuestionRepeatCompare?" + params,
		fit: true,
		title: '查看试卷重复试题'
	}, 0);
}

function exportPaperList(){
	let params = {
		unid: $('#unitList').val(),
		cid: $('#courseList').val(),
		gid: $('#gradeList').val(),
		sid: $('#specialtyList').val(),
		num: $('#searchByNum').searchbox('getValue').trim(),
		teacherid : $('#teacherList').val(),
		term :$('#termList').val(),
		examType:$('#examType').val(),
		schoolYear:$('#schoolYear').val(),
		beginDate : $('#bdate').datebox("getValue"),
		endDate : $('#edate').datebox("getValue"),
		aorb:$('#aorb').val()
	};

	$.ajax({
		url: '${pageContext.request.contextPath}/result/exportPaperList',
		method: 'GET',
		data: params,
		xhrFields: {
			responseType: 'blob'
		},
		beforeSend: function() {
			ajaxLoading();
		},
		success: function(data, status, xhr) {
			let filename = '所有试卷列表导出.xls';
			const blob = new Blob([data], { type: xhr.getResponseHeader('Content-Type') });
			if (window.navigator && window.navigator.msSaveOrOpenBlob) {
				// IE11+ 专用
				window.navigator.msSaveOrOpenBlob(blob, filename);
			} else {
				const link = document.createElement('a');
				link.href = window.URL.createObjectURL(blob);
				link.download = filename;
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
			}
		},
		error: function() {
			toastr.error('文件下载失败，请联系管理员。');
		},
		complete: function() {
			ajaxLoadEnd();
		}
	});
}
</script>