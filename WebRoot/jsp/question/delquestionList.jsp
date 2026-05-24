<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
.qlimit{
	padding:2px .8px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	width:100px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
.previewQuestion{
	text-decoration:none;
	color:black;
}
.wrap{white-space:normal;}

.wrap img{
	height:100px;
}

.wrap video{
	width:220px!important;
	height:180px!important;
}
</style>
<div id="dlg-toolbar" >
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<table cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<th style="text-align:center">《${courseInfo[0].name_c }》暂时被删除试题列表</th>
	</tr>
</table>
<table cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<a href="javascript:void(0);" onclick="backFromList()" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect();">删除选中的试题</a>
			<a href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="recoverSelect();">恢复选中的试题</a>
			<input class="easyui-searchbox" data-options="prompt:'请输入查询内容',menu:'#mm',searcher:doSearch" style="width:326px;"></input>
			<div id="mm">
				<div data-options="name:'question'">题目查询</div>
				<div data-options="name:'teacher'">题目录入者查询</div>
			</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0">
	<tr>		
		<td>

		</td>
	</tr>
</table>
</div>
<input type="hidden" id="pageNumber" value="${pageNumber}"/>
<input type="hidden" id="pageSize" value="${pageSize}"/>
</div>
<div id="datalist"></div>
<script type="text/javascript">
var cid = $("#c_id").val();
$(document).ready(function(){
	var pageNumber = 1;
	var pageSize = 100;
	if($("#pageNumber").val()!=null && $("#pageNumber").val()!=""){
		pageNumber = $("#pageNumber").val();
	}
	if($("#pageSize").val()!=null && $("#pageSize").val()!=""){
		pageSize = $("#pageSize").val();
	}
	
	$.parser.parse($("#searchpage"));//重新渲染
	var url = '${pageContext.request.contextPath}/question/getDelQuestionList';

	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:url,
		pagination: true,
		rownumbers: false,
		pageSize: pageSize,
		pageNumber:pageNumber,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		queryParams: {
			c_id:cid
		},
		toolbar:'#dlg-toolbar',		
		columns:[[
			  {field:'qid',checkbox:true},
			   {field:'index',title:'序号',width:10, align: 'center',formatter:function(val,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
			     return (pageSize * (currentPage -1))+(index+1);
			    }},
			    {field:'content',title:'题目',width:90,align:'left',formatter:function(value,row,index){
		    	  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail('+row.qid+','+ row.mqid+',' + cid + ',' + row.ismain +',' + row.qtiscon + ')"><div class="wrap">'+row.content+'</div></a>';
		    	  return s;
	          },sortable:true},
	          {field:'answer',title:'答案',width:60,align:'left',formatter:function(value,row,index){
	          	    var ismain=row.ismain;
				  	if(ismain==1){
				  		return "串题题干<br/>（删除题干，整串删除）";
				  	}else{
				  		return printAnswer(row.answer,row.answerid);
				  	}	        	  	
	          }},
			  {field:'qtid',title:'题型',width:20,align:'left',sortable:true, formatter:function(value,row,index){
				  return row.qtname;
	          }},
	          {field:'t1name',title:'主题词',width:60,align:'left',formatter:function(value,row,index){
		    	  var s = row.t1name;
		    	  if(typeof(s)=='undefined'){
		    		  s='';
		    	  }
		    	  if(row.t2name){
		    		  s += ' / ' + row.t2name;
		    	  }
		    	  if(row.t3name){
		    		  s += ' / ' + row.t3name;
		    	  }
		    	  return s;
	          },sortable:true},	
	          {field:'coname',title:'认知分类',width:20,align:'left',sortable:true},	
	          {field:'dname',title:'难度',width:20,align:'left',sortable:true},
	          {field:'realdifficulty',title:'实测难度',width:20,align:'left',sortable:true,formatter:function(value,row,index){
	        	  var num = row.realdifficulty;
	        	  return num.toFixed(2);
	          }},
	          {field:'distinction',title:'区分度',width:20,align:'left',sortable:true,formatter:function(value,row,index){
	        	  var num = row.distinction;
	        	  return num.toFixed(2);
	          }},
	          {field:'time',title:'用时',width:20,align:'left',sortable:true,formatter:function(value,row,index){
	        	  return timeReversal(row.time);
	          }},
	          {field:'num',title:'已考次数',width:20,align:'left',sortable:true},
	          {field:'zl',title:'质量判断',width:20,align:'left',sortable:true},

	          {field:'opration',title:'操作',width:40,align:'center',formatter:function(value,row,index){
			     var options = $("#datalist").datagrid('getPager').data("pagination").options; 
			     var currentPage = options.pageNumber;
			     if(currentPage==0){
			     	currentPage=1;
			     }
			     var pageSize = options.pageSize;
	        	var s3 = '<a href="javascript:void(0)" class="editcls2 easyui-tooltip" title="恢复试题" onclick="recoverQuestion('+ row.qid + ',' + row.state + ',' + row.ismain  + ')"></a>';
	        	var s4 = '<a href="javascript:void(0)" class="editcls3 easyui-tooltip" title="删除试题" onclick="del('+ row.qid +',' + row.ismain +  ',' + row.qtiscon + ')"></a>';

				return '<div class="wrap">'  + s3+s4+'</div>';
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewQuestion').linkbutton({text:'',iconCls:'icon-search',plain:true});
	    	$('.editcls1').linkbutton({text:'',iconCls:'icon-edit',plain:true});
	        $('.editcls2').linkbutton({text:'',iconCls:'icon-ok',plain:true});
	        $('.editcls3').linkbutton({text:'',iconCls:'icon-no',plain:true});
	        $('.editcls4').linkbutton({text:'未审核',plain:true});
	    },
		onBeforeLoad:function(param){
			localStorage.setItem("questionListParam", JSON.stringify(param));
		}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function getQuestionDetail(qid,mqid,cid,ismain,qtiscon){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:view"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		if(typeof(mqid) == "undefined"){
					mqid = "";
				}
				let param = ''
				let paramObj = localStorage.getItem("questionListParam");
				if(paramObj){
					paramObj = JSON.parse(paramObj);
					for(const k in paramObj){
						if(k == 'c_id'){
							continue;
						}
						param = param + '&' + k+'=' + paramObj[k];
					}
				}
				openIframeDialog({
					url:"${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+param,
					fit:true,
					title:'查看试题'
				},1);
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
	
}

$('#theme1List').change(function(){
	getThemeList(2, $('#theme1List').val());
	var t3List = $('#theme3List');
	t3List.empty();
	t3List.append('<option value="">全部主题词三</option>');
	questionFilter();
})

$('#theme2List').change(function(){
	getThemeList(3, $('#theme2List').val());
	questionFilter();
})

$('#theme3List').change(function(){
	questionFilter();
})

function questionFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		c_id : cid,
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(), 
    	did : $('#difficultyList').val(), 
    	kid : $('#knowledgeList').val(),
    	isVerified : $('#isVerified').val(),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});	
}

function getThemeList(th_level, th_pid){
	$.ajax({
        url: "${pageContext.request.contextPath}/course/getThemeList",
        async: false, 
        type: "POST",
        data: {"th_level": th_level, "th_pid": th_pid, "c_id": cid}, 
        success: function (data) {
        	var thStr = '#theme' +  th_level + 'List';
        	$(thStr).html(null);
        	var str = '';
        	if(th_level == 1){
        		str += '<option value="">全部主题词一</option>'
        	}else if(th_level == 2){
        		str += '<option value="">全部主题词二</option>'       		
        	}else if(th_level == 3){
        		str += '<option value="">全部主题词三</option>'        		
        	}
			$.each(eval(data), function(i,item){
				str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
			});
			$(thStr).append(str);
 		}
 	});	
}

function doSearch(value,name){//通用查询框	
	if(name == 'question'){
		$('#datalist').datagrid('load',{
			c_id : cid,
			question: value,
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(), 
	    	qtid : $('#questionTypeList').val(),
	    	coid : $('#cognitionList').val(), 
	    	did : $('#difficultyList').val(), 
	    	kid : $('#knowledgeList').val(),
	    	isVerified : $('#isVerified').val()
		});
	}else if(name == 'teacher'){
		$('#datalist').datagrid('load',{
			c_id : cid,
			teacher: value,
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(), 
	    	qtid : $('#questionTypeList').val(),
	    	coid : $('#cognitionList').val(), 
	    	did : $('#difficultyList').val(), 
	    	kid : $('#knowledgeList').val(),
	    	isVerified : $('#isVerified').val()
		});
	}
}

function recoverQuestion(qid, ismain,iscon){
    var params = {};
    params["cid"] = cid;
    params["permission"] = "question:update";
    $.ajax({
        contentType: "application/json; charset=utf-8",
        url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
            if(data==1){
                $.messager.confirm("提示",'确定恢复当前试题 ?',function(r){
                    if (r){
                        $.ajax({
                            url: "${pageContext.request.contextPath}/question/recoverQuestion",
                            async: false,//改为同步方式
                            type: "POST",
                            data: { "q_id":qid ,"isMain":ismain,"iscon":iscon,"cid":$("#c_id").val()},
                            success: function (data) {
                                toastr.success("已成功恢复"+data+"题");
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

function del(qid, ismain,iscon){
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:del";
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$.messager.confirm("提示",'确定永久删除当前试题 ?',function(r){
			    if (r){
			    	$.ajax({
			            url: "${pageContext.request.contextPath}/question/delQuestionReal",
			            async: false,//改为同步方式
			            type: "POST",
			            data: { "q_id":qid ,"isMain":ismain,"iscon":iscon,"cid":$("#c_id").val()},
			            success: function (data) {
			            	toastr.success("已成功永久删除"+data+"题");
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

//恢复所选试题
function recoverSelect(){
    var params = {};
    params["cid"] = cid;
    params["permission"] = "question:update";
    $.ajax({
        contentType: "application/json; charset=utf-8",
        url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
            if(data==1){
                var rows = $('#datalist').datagrid('getSelections');
                if(rows.length > 0){
                    $.messager.confirm("提示",'是否要恢复所选试题 ?',function(r){
                        if(r){
                            var list = [];
                            for(var i=0;i<rows.length;i++){
                                var param = {};
                                param["qid"] = rows[i].qid;
                                param["ismain"] = rows[i].ismain;
                                param["iscon"] = rows[i].qtiscon;
                                param["cid"] = rows[i].cid;
                                list.push(param);
                            }
                            if(list.length > 0){
                                var data = {data:list,"cid":$("#c_id").val()};
                                $.ajax({
                                    contentType: "application/json; charset=utf-8",
                                    url: "${pageContext.request.contextPath}/question/recoverSelect",
                                    async: false,
                                    type: "POST",
                                    data: JSON.stringify(data),
                                    success: function(rs){
                                        $('.datagrid-header-check').find('checked',false);
                                        $('#datalist').datagrid('reload');
                                        toastr.success("恢复成功！试题恢复到未审核状态");
                                    }
                                })
                            }
                        }
                    });
                }else{
                    toastr.warning("你还没有选择题目！");
                }
            }else if(data==0){
                toastr.warning("无相关权限");
            }else{
                toastr.error("登录超时，请重新登录！");
            }
        }
    });
}

//真的删除了
function delSelect(){
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:del"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var rows = $('#datalist').datagrid('getSelections');
				if(rows.length > 0){
					$.messager.confirm("提示",'是否要永久删除所选试题 ?',function(r){
						if(r){
							var list = [];
							for(var i=0;i<rows.length;i++){
								var param = {};
								param["qid"] = rows[i].qid;
								param["ismain"] = rows[i].ismain;
								param["iscon"] = rows[i].qtiscon;
								param["cid"] = rows[i].cid;
								list.push(param);
							}
							if(list.length > 0){
								var data = {data:list,"cid":$("#c_id").val()};
								$.ajax({
									contentType: "application/json; charset=utf-8",
									url: "${pageContext.request.contextPath}/question/delSelectQuestionReal",
									async: false,
									type: "POST",
									data: JSON.stringify(data),
									success: function(rs){
										$('.datagrid-header-check').find('checked',false);
										$('#datalist').datagrid('reload');
										toastr.success("删除成功！");
									}
								})
							}
						}
					});
          	}else{
				toastr.warning("你还没有选择题目！");
			}        		
   		}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 
 	}
 });
 }

function timeReversal(t){
	var h=0;
	var m=0;
	var s=t;
	if(t>=3600){
		h=parseInt(t/3600);
		m=parseInt((s%3600)/60);
		s=parseInt((s%3600)%60);
	}else if(t>60){
		m=parseInt(t/60);
		s=parseInt(t%60);
	}
	if(h>0){
		return h + '时' + m + '分 ' + s + '秒'
	}else if(m>0){
		return m + '分 ' + s + '秒';
	}else{
		return s + '秒';
	}
}

function back() {
	url = "${pageContext.request.contextPath}/question/ineditQuestion";
	window.location.href = url;
}

function backFromList() {
        url = "${pageContext.request.contextPath}/question/indelQuestion?back=1";
        window.location.href = url;
}

function checkQuestionPermission(cid,permission,url){
	var params = {};
	params["eid"] = eid;
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

function printAnswer(rs,aid){
	var p = '';//选择题ABCDE
	var out = '<div class="wrap">';
	if(typeof(aid)=='undefined'||aid=='null'||aid==null){
		aid = '';
	}
	var aid = aid.split(",");
	for(var i=0;i<rs.length;i++){
		if(rs[i].ATID<4||rs[i].ATID==8||rs[i].ATID==9){
			p = String.fromCharCode(65+i);
			for(var j=0;j<aid.length;j++){
				if(rs[i].AID==aid[j]){
					out += '<a>'+ p + '.' + rs[i].CONTENT + '</a><br/>';
				}
			}
			
			/* else{
				out += p + '.' + rs[i].ACONTENT + '<br/>';
			} */
		}else if(rs[i].ATID==4){
			if(rs[i].CONTENT=='true'){
				out += '对';
			}else{
				out += '错';
			}
			//out += rs[i].ACONTENT;
		}else{
			if(typeof(rs[i].CONTENT_6)=="undefined"){
				out += "";
			}else{
				out += rs[i].CONTENT_6;
			}
		}
	}
	out+='</div>';
	return out;
}


</script>	

