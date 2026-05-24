<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
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
	margin:0 2.5px;
}
.select2-container .select2-selection--single .select2-selection__rendered{
	font-size:12px;
}
a{text-decoration:none;color:black;}
a:hover { color:blue; }
.wrap{white-space:normal;}
</style>
<div id="dlg-toolbar" style="height:auto;">
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<shiro:hasRole name="expert">
	<input type="hidden" id="role" name="role" value="7"/>
</shiro:hasRole>
<table height="35px" width="100%">
	<tr>
		<th style="text-align:center;font-size:20px;">试卷列表</th>
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
				<option value="">不限科目</option>
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
			<input id="searchByTeacher" data-options="prompt:'按组卷人实名或用户名称查询'" />
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="deleteSelectPaper()">删除所选试卷</a>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script type="text/javascript">
var role=-1;
if(typeof($("#role").val())!="undefined"){
    role=$("#role").val();
}
$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/verify/paperList";
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
			state: 0,
			mobile: 0
		},
		toolbar:'#dlg-toolbar',
		columns:[[
			  //{field:'EID',checkbox:true},//var date = new Date(val)
			  {field:'eid',checkbox:true},
			  {field:'num',title:'试卷编号',width:20,align:'left',formatter:function(value,row,index){
	          	  return row.eid;
	          },sortable:true},
			  {field:'ename',title:'试卷名称',width:80,align:'left',formatter:function(value,row,index){
	          	  var s = '<div class="wrap">'+row.ename+'</div>';
		    	  return s;
	          },sortable:true},
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
			  {field:'tname',title:'组卷人',width:25,align:'left',sortable:true,formatter:function(value,row,index){
				  var tname = row.tname + "( "+row.USERNAME+" )";
				  return tname;
			  }},
	          {field:'EI',title:'考务信息',width:25,align:'left',formatter:function(value,row,index){
				  let ename = row.ename?row.ename:"";
				  ename = ename.replace("\"", "\\\"");
	        	  let s1 = "<a href=\"javascript:void(0);\" class=\"viewExamInfo\" onclick=\"inViewExamInfo('"+row.cid+"','"+row.eid+"','"+ename+"')\"></a>";
				  let s2 = "<a href=\"javascript:void(0);\" class=\"editExamInfo\" onclick=\"inEditExamInfo('"+row.cid+"','"+row.eid+"','"+ename+"')\"></a>";
				  if(role==7){
					  return '<div class="wrap">'+s1+'</div>';
				  }else{
                      return '<div class="wrap">'+s1 + s2+'</div>';
                  }
	          }},
	          {field:'APAPER',title:'A卷',width:50,align:'left',formatter:function(value,row,index){
	          	  var s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.eid+"')\">"+row.asum + '题'+"</a>&nbsp;&nbsp;";	        	  
	        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editPaperA\" onclick=\"editPaperA('"+row.cid+"','"+row.eid+"')\"></a>";
	        	  var s3 = "";
	        	  var s4 = '<a href="javascript:void(0)" class="deletePaperA" onclick="deletePaperA(' + row.eid + ')"></a>';
	        	  var s5 = row.scount + '考生';
				  if(role==7){
					  return '<div class="wrap">'+s1+s5+s3+'</div>';
				  }else{
                      return '<div class="wrap">' + s1+s5 + s2 + s3 + s4+'</div>';
				  }

	          }},
	          {field:'BPAPER',title:'B卷',width:50,align:'left',formatter:function(value,row,index){
	          	  if(row.isunion==1 || row.isunion==2){
	          	  	  var s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.bid+"')\">联考测试卷</a>&nbsp;&nbsp;";
		        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editPaperB\" onclick=\"editPaperB('"+row.cid+"','"+row.bid+"')\"></a>";
	        	  	  var s3 = "";
	        	      var s4 = '<a href="javascript:void(0)" class="deletePaperB" onclick="deletePaperB(' + row.eid + ','+row.bid+')"></a>';
		        	  var s5 = row.bscount + '考生';
                      if(role==7){
                          return '<div class="wrap">'+s1+s5+s3+'</div>';
                      }else{
                          return '<div class="wrap">'+ s1+ s5 + s2 + s3  + s4+'</div>';
                      }
	          	  }else{
	          	  	if(!row.bid){
                        if(role==7){
                            return '<div class="wrap">无B卷</div>';
                        }else{
                            var s = "<a href=\"javascript:void(0);\" class=\"generateBpaper\" onclick=\"generateBpaper('"+row.eid+"','${pageContext.request.contextPath}/paper/generateBpaper?aid=" + row.eid + "&cid=" + row.cid+"')\"></a>";
                            return s;
                        }
		        	  }else{
		        		  //var bnum = getBNum(row.bid);
		        		  //var s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.bid+"')\">"+row.bsum + '题'+"</a>&nbsp;&nbsp;";
		        		  var s1 = "<a href=\"javascript:void(0);\" onclick=\"seePaper('"+row.bid+"')\">"+row.bsum + '题'+'(ID:'+ row.bid +')'+"</a>&nbsp;&nbsp;";
			        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/editBpaper?c_id=' + row.cid + '&ei_id=' + row.bid +'"  class="editPaperB"></a>';
			        	  var s2 = "<a href=\"javascript:void(0);\" class=\"editPaperB\" onclick=\"editPaperB('"+row.cid+"','"+row.bid+"')\"></a>";
		        	  	  var s3 = "";
			        	  var s4 = '<a href="javascript:void(0)" class="deletePaperB" onclick="deletePaperB(' + row.eid + ','+row.bid+')"></a>';
			        	  var s5 = row.bscount + '考生';
			        	  //<shiro:hasRole name="administrator">s4 = '<a href="javascript:void(0)" class="deletePaperB" onclick="deletePaperB(' + row.bid + ')"></a>';</shiro:hasRole>
							if(role==7){
								return '<div class="wrap">'+s1+s5+s3+'</div>';
							}else{
                                return '<div class="wrap">'+ s1+ s5 + s2 + s3  + s4+'</div>';
							}
		        	  }
	          	  }
	        	  
	          }},
			{field:'operation',title:'操作',width:30,align:'left',sortable:true,formatter:function(value,row,index){
					return '<a href="javascript:void(0)" class="AI_analysis" onclick="getAIPaperTest(' + row.eid +')"></a>';
				}},
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewExamInfo').linkbutton({text:'查看',plain:true});
	    	$('.editExamInfo').linkbutton({text:'编辑',plain:true});
	        $('.editPaperA').linkbutton({text:'编辑',plain:true});
	        $('.deletePaperA').linkbutton({text:'删除',plain:true});
	        $('.editPaperB').linkbutton({text:'编辑',plain:true});
			$('.AI_analysis').linkbutton({text:'智能评价',plain:true});
	        $('.deletePaperB').linkbutton({text:'删除',plain:true});	
	        $('.generateBpaper').linkbutton({text:'生成B卷',plain:true});
	        $('.appoint').linkbutton({text:'权限设置',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

$('#searchByNum').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	teacher : $('#searchByTeacher').searchbox('getValue'),
	    	num : value,
	    	state : '0',
	    	mobile: '0'
		})
	}
	
})

$('#searchByTeacher').searchbox({
	searcher:function(value,name){
		console.log($('#searchByTeacher').text()+" : "+$('#courseList').val());
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	num : $('#searchByNum').searchbox('getValue'),
	    	teacher : value,
	    	state : '0',
	    	mobile: '0'
		})
	}	
})

function doSearch(value,name){//通用查询框	
	if(name == 'accurate'){
		$('#datalist').datagrid('load',{
			cname: value
		});
	}else if(name == 'vague'){
		$('#datalist').datagrid('load',{
			condition: 'true',
			cname: value
		});
	}
}

function getBNum(eid){
	var num = 0;
	$.ajax({
        url: "${pageContext.request.contextPath}/verify/getBNum",
        async: false,
        type: "POST",
        traditional: true,
        data: { "eid":eid },
        success: function (data) {
        	if(data){
        		//console.log(data);
            	num = data;
        	}
        }
	});
	return num;
}


function deletePaperA(eid){
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
          		$.messager.confirm("提示",'您将删除A卷，如果存在B卷，B卷将被彻底删除，继续操作请点击确定！',function(r){
				    if (r){	    	
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/verify/deletePaper",
				            async: true,//改为同步方式
				            type: "POST",
				            traditional: true,
				            data: { "eid":eid },
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

function deletePaperB(aid,bid){
	var params = {};
	params["eid"] = aid;
	params["permission"] = "paper:del"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$.messager.confirm("提示",'您将彻底删除B卷，A卷将会保留，此操作不可恢复，继续操作请点击确定！',function(r){
				    if (r){	    	
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/verify/deletePaper",
				            async: true,//改为同步方式
				            type: "POST",
				            traditional: true,
				            data: { "eid":bid },
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

function paperFilter(){
	console.log($('#searchByTeacher').val()+" : "+$('#courseList').val());
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	num : $('#searchByNum').searchbox('getValue'),
    	teacher : $('#searchByTeacher').searchbox('getValue'),
    	state : '0',
    	mobile: 0,
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
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


function generateBpaper(eid,url){
	$.ajax({
          url: '${pageContext.request.contextPath}/verify/checkGenerateBpaperPermission',
          async: false, 
          type: "POST",
          data: {"eid":eid},
          success: function (data) {
          	if(data==1){
          		toastr.warning("生成B卷的耗时有点长，请耐心等待。");
          		window.location.href = url;
          	}else if(data==2){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
}

function checkAutoTest(eid,bid,cpid,permission,url){
	if(bid==="undefined" || bid==="null"){
		bid = '';
	}
	if(cpid==="undefined" || cpid==="null"){
		cpid = '';
	}
	if(${openFindRepeatSystem eq 1}){
		$.ajax({
			url:"${pageContext.request.contextPath}/verify/checkRepetitionRateQuestionExam",
			async: true,
			type: "POST",
			beforeSend: function() {
				ajaxLoading();
			},
			data: {"eid":eid,"bid":bid,"cpid":cpid},
			success: function(data){
				ajaxLoadEnd();
				if(data.tip=="error"){
					let tips = ''
							+ '<div style="color:#d9534f; font-size:14px; line-height:1.8; text-align:left;">'
							+ '  <div style="font-size:20px; font-weight:bold; margin-bottom:12px;">试卷文本相似查重</div>'
							+ '  <div style="border:1px solid #f0ad4e; background:#fcf8e3; padding:10px 12px; margin-bottom:12px;">'
							+ '    <div style="font-size:15px; font-weight:bold; margin-bottom:8px;">A卷重复试题分值占比</div>'
							+ '    <div style="margin-bottom:4px;">三年内重复试题分值占比：' + data.percentageA + '</div>'
							+ '  </div>';

					if (bid !== "null" && bid !== '') {
						tips += ''
								+ '<div style="border:1px solid #f0ad4e; background:#fcf8e3; padding:10px 12px; margin-bottom:12px;">'
								+ '  <div style="font-size:15px; font-weight:bold; margin-bottom:8px;">B卷重复试题分值占比</div>'
								+ '  <div style="margin-bottom:4px;">三年内重复试题分值占比：' + data.percentageB + '</div>'
								+ '</div>';
					}

					tips += ''
							+ '  <div style="font-size:15px; font-weight:bold; margin:12px 0; text-align:left;">'
							+ '    三年内重复试题分值占比不得超过20%'
							+ '  </div>'
							+ '  <div style="font-size:15px; font-weight:bold; margin:12px 0; text-align:left;">'
							+ '    请查看详情，确认题目查重详情是否真为重复。如只是字符文本相似，实际重复的题目未达限制标准，则可继续提交，如真重复请修改后再提交！'
							+ '  </div>'
							+ '  <div style="text-align:center; margin-top:10px;">'
							+ '    <button type="button" '
							+ '      onclick="toExamRepeatDetail(\'' + eid + '\')" '
							+ '      style="padding:6px 16px; border:1px solid #337ab7; background:#fff; color:#337ab7; border-radius:4px; cursor:pointer;">'
							+ '      重复详情'
							+ '    </button>'
							+ '  </div>'
							+ '</div>';

					$.messager.defaults.cancel = "返回修改";
					$.messager.defaults.ok = "继续提交";
					$.messager.confirm({
						width: '480',
						title: '重复率提示',
						msg: tips,
						fn: function (r) {
							if (r){
								doCheckAutoTestAndSubmit(eid,bid,cpid,permission,url);
							}
						}
					});
				}else if(data.tip=="repeaterror"){
					let tips = ''
							+ '<div style="color:#d9534f; font-size:14px; line-height:1.8; text-align:left;">'
							+ '  <div style="font-size:20px; font-weight:bold; margin-bottom:12px;">AB卷文本相似查重</div>'
							+ '  <div style="border:1px solid #f0ad4e; background:#fcf8e3; padding:10px 12px; margin-bottom:12px;">'
							+ '    <div style="font-size:15px; font-weight:bold; margin-bottom:8px;">AB卷重复试题占比</div>'
							+ '    <div style="margin-bottom:4px;">B卷与A卷重复试题有：' + data.countB + '道</div>'
							+ '    <div>B卷与A卷重复率分值占比：' + data.percentageAB + '</div>'
							+ '  </div>'
							+ '  <div style="font-size:15px; font-weight:bold; margin:12px 0; text-align:left;">'
							+ '    B卷存在试题与A卷重复，且分值所占比超过10%。'
							+ '  </div>'
							+ '  <div style="font-size:15px; font-weight:bold; margin:12px 0; text-align:left;">'
							+ '    请查看详情，确认题目查重详情是否真为重复。如只是字符文本相似，实际重复的题目未达限制标准，则可继续提交，如真重复请修改后再提交！'
							+ '  </div>'
							+ '  <div style="text-align:center; margin-top:10px;">'
							+ '    <button type="button" '
							+ '      onclick="toExamRepeatDetail(\'' + eid + '\')" '
							+ '      style="padding:6px 16px; border:1px solid #337ab7; background:#fff; color:#337ab7; border-radius:4px; cursor:pointer;">'
							+ '      重复详情'
							+ '    </button>'
							+ '  </div>'
							+ '</div>';

					$.messager.defaults.cancel = "返回修改";
					$.messager.defaults.ok = "继续提交";
					$.messager.confirm({
						width: '480',
						title: '重复试题提示',
						msg: tips,
						fn: function (r) {
							if (r){
								doCheckAutoTestAndSubmit(eid,bid,cpid,permission,url);
							}
						}
					});
				}else {
					doCheckAutoTestAndSubmit(eid,bid,cpid,permission,url);
				}
			},
			complete: function () {
				ajaxLoadEnd();
			}
		});
	}else{
		doCheckAutoTestAndSubmit(eid,bid,cpid,permission,url);
	}
}

function doCheckAutoTestAndSubmit(eid,bid,cpid,permission,url){
	$.ajax({
		url: '${pageContext.request.contextPath}/verify/checkAutoTest',
		async: false,
		type: "POST",
		data: {"eid":eid,"bid":bid,"cpid":cpid},
		success: function (data) {
			if(data==1){
				checkPaperPermission(eid,permission,url);
			}else{
				if(data.indexOf('timeErrorB')>-1){
					$.messager.confirm('答题时间提示', 'B卷有作答时间少于30s（包含）的试题，请确认作答时间设置是否合理，题号为“'+data.substring(10)+'”，如需修改可取消提交审核。', function(r){
						if (r){
							checkPaperPermission(eid,permission,url);
						}
					});
				}else if(data.indexOf('timeError')>-1){
					$.messager.confirm('答题时间提示', 'A卷有作答时间少于30s（包含）的试题，请确认作答时间设置是否合理，题号为“'+data.substring(9)+'”，如需修改可取消提交审核。', function(r){
						if (r){
							checkPaperPermission(eid,permission,url);
						}
					});
				}else{
					toastr.warning(data);
				}
			}
		}
	});
}

function toExamRepeatDetail(eid){
	openIframeDialog({
		url:'${pageContext.request.contextPath}/paper/toExamRepeatDetail?eid=' + eid,
		fit:true,
		title:'重复详情'
	},0);
}

function deleteSelectPaper(){
	var str="";
	var rows = $('#datalist').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		str+="<br/>"+rows[i].eid+":"+rows[i].ename;
	}
	$.messager.confirm('删除试卷', '您确定要删除试卷'+str+'？', function(r){
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
					url: "${pageContext.request.contextPath}/verify/deleteSelectPaper",
					async: false,
					type: "POST",
					data: JSON.stringify(data),
					success: function (rs){
						$('.datagrid-header-check').find('checked',false);
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
				window.location.href="${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
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
				});
				openIframeDialog({
					url:"${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid,
					fit:true,
					title:'编辑B卷试题'
				},0);*/
				window.location.href="${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 		
   		}
   	});
	
}

function editPaperC(cid,cpid){
	var params = {};
	params["eid"] = cpid;
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
				window.location.href="${pageContext.request.contextPath}/paper/editCpaper?c_id=" + cid + "&ei_id=" + cpid;
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 		
   		}
   	});
}

function appoint(cid,eid,ename,tid,type){
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
					url:"${pageContext.request.contextPath}/verify/appoint?cid=" + cid + "&eid=" + eid+ "&ename=" + ename+ "&tid=" + tid+ "&type=" + type,
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
	var url = '${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + eid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '预览试卷',
		content: content,
		closable: true 
	}); 
}

function getAIPaperTest(eid) {
	// 先查询状态
	$.get('${pageContext.request.contextPath}/intelliPaper/getTestPaperDocxByAIInfo', { eid })
			.done(function (info) {
				showAIPaperDialog(eid, info);
			})
			.fail(function (xhr) {
				if (xhr.status === 401) {
					Swal.fire('未授权', '请重新登录或检查权限', 'error');
				} else if (xhr.status === 404) {
					// 文件不存在 & 未在生成
					showAIPaperDialog(eid, { exists: false, running: false });
				} else {
					Swal.fire('获取状态失败', xhr.responseText || '未知错误', 'error');
				}
			});
}

function showAIPaperDialog(eid, info) {
	if (info.running) {
		Swal.fire({
			title: '报告生成中…',
			html: 'AI 正在分析试卷，请稍后刷新或等待自动完成。',
			icon: 'info',
			showConfirmButton: false,
			timer: 3000
		});
		return;
	}

	// 构造弹窗内容
	let html = '';
	if (info.exists) {
		const dateStr = new Date(info.lastModified).toLocaleString();
		html += `<p>已生成报告，最后更新时间：<b>\${dateStr}</b></p>`;
	} else {
		html += '<p><b>当前无 AI 试卷分析报告（生成一份报告大致需要5分钟）</b></p>';
	}

	// 弹窗
	Swal.fire({
		title: 'AI 试卷分析',
		html: html,
		icon: info.exists ? 'success' : 'warning',
		showCancelButton: true,
		confirmButtonText: info.exists ? '重新生成' : '生成',
		cancelButtonText: info.exists ? '下载' : '关闭'
	}).then((result) => {
		if (result.isConfirmed) {
			// ★ 重新生成（或生成）
			$.post('${pageContext.request.contextPath}/intelliPaper/testPaperByAI', { eid })
					.done(function (msg) {
						Swal.fire('已提交', msg === 'running' ? '已有任务正在执行' : '任务已开始，请稍后刷新', 'success');
					})
					.fail(function () {
						Swal.fire('提交失败', '无法启动 AI 任务', 'error');
					});
		} else if (result.dismiss === Swal.DismissReason.cancel && info.exists) {
			// ★ 下载
			window.location.href = '${pageContext.request.contextPath}/intelliPaper/downloadTestPaperDocxByAI?eid=' + encodeURIComponent(eid);
		}
	});
}
</script>	