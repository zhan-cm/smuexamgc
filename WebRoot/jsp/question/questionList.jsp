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
	width:105px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
.previewQuestion{
	text-decoration:none;
	color:black;
}
.wrap{white-space:normal;}

.wrap img{
	max-height:100px;
}

.wrap video{
	width:220px!important;
	height:180px!important;
}
</style>
<div id="dlg-toolbar" >
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<input type="hidden" id="cname" value="${courseInfo[0].name_c}"/>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<th style="text-align:center">《${courseInfo[0].name_c }》试题列表</th>
	</tr>
</table>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<td>
			<a href="javascript:void(0);" onclick="backFromList()" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" onclick="gotoAddQuestion();" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" >新增试题</a>				
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="verSelect();">审核通过所选试题</a>
			<a href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect();">删除选中的试题</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-book_tabs',plain:true" onclick="toFindRepeatQuestions('${c_id}');">查找重复试题</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-note_go',plain:true" onclick="exportSelect(${c_id});">导出所选试题到excel</a>	
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_go',plain:true" onclick="exportAll(${c_id});">导出所有试题到excel</a>		 
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_in',plain:true" onclick="importQuestion()">从excel导入试题</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_in',plain:true" onclick="importWord()">从word导入试题</a>
			<c:if test="${not empty AI_V2_switch}">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-tip',plain:true" onclick="intoQuestionAIModule()">AI试题操作</a>
			</c:if>
		</td>
	</tr>
</table>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>		
		<td>
			<select id="theme1List" name="themeList" class="qlimit">
				<option value="">全部主题词一</option>
				<c:forEach var="theme" items="${courseInfo[0].themeList}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach>
			</select>
			<select id="theme2List" name="theme2List" class="qlimit">
				<option value="">全部主题词二</option>
				<%-- <c:forEach var="theme" items="${courseInfo[0].theme2List}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach> --%>
			</select>
			<select id="theme3List" name="theme3List" class="qlimit">
				<option value="">全部主题词三</option>
				<%-- <c:forEach var="theme" items="${courseInfo[0].theme3List}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach> --%>
			</select>
			<select id="questionTypeList" name="questionTypeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部题型</option>
				<c:forEach var="questionType" items="${courseInfo[0].questionTypeList}">
					<option value="${questionType.QTID}">${questionType.QTNAME}</option>
				</c:forEach>
			</select>
			<select id="cognitionList" name="cognitionList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>					
				<c:forEach var="cognition" items="${courseInfo[0].cognitionList}">
					<option value="${cognition.COID}">${cognition.CONAME}</option>
				</c:forEach>				
			</select>
			<select id="difficultyList" name="difficultyList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${courseInfo[0].difficultyList}">
					<option value="${difficulty.DID}">${difficulty.DNAME}</option>
				</c:forEach>
			</select>
			<select id="knowledgeList" name="knowledgeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${courseInfo[0].knowledgeList}">
					<option value="${knowledge.KID}">${knowledge.KNAME}</option>
				</c:forEach>
			</select>
			<select id="isVerified" name="isVerified"  class="qlimit" onchange="questionFilter()">
				<option value="">全部审核状态</option>
				<option value="0">未审核</option>
				<option value="-1">审核不通过</option>
				<option value="1">审核通过</option>
			</select>
			
			<input id="mainQbox" class="easyui-searchbox" data-options="prompt:'请输入查询内容',menu:'#mm',searcher:doSearch" style="width:326px;"/>
			<div id="mm">
				<div data-options="name:'question'">题目查询</div>
				<div data-options="name:'teacher'">题目录入者查询</div>
				<div data-options="name:'answer'">答案查询</div>
			</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
		</td>
	</tr>
		<tr>
			<td  colspan="2">
				查找从&nbsp;<input id="bdate" type="text" style="width:160px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px"/>&nbsp;录入的试题 <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchByDate()" data-options="iconCls:'icon-search'">查询</a>
			</td>
		</tr>
	<tr>
		<td colspan="2">
			<input class="easyui-numberbox" id="rangeMin"
				   data-options="min:0,precision:0,prompt:'已考次数最小值'"
				   style="width:120px;"/> -
			<input class="easyui-numberbox" id="rangeMax"
				   data-options="min:0,precision:0,prompt:'已考次数最大值'"
				   style="width:120px;"/>
			<a href="javascript:void(0)" class="easyui-linkbutton"
			   data-options="iconCls:'icon-search',plain:true"
			   onclick="doSearch()">查询</a>

			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-book_open_mark',plain:true" onclick="searchIllegalQuestion()"><span id="illegalQuestionTips">显示存在重复选项的试题</span></a>
		</td>
	</tr>
</table>

<div id="verifyPage" style="display:none;">
	<div style="text-align:center;">是否让此试题通过审核入库 ？如果不通过，请给予修改意见<br>
		<input type="hidden" id="verify_id" value=""/>
		<input type="hidden" id="verify_ismain" value=""/>
		<textarea id="verify_suggestion" style="border-width:1px;border-radius:5px;width: 355px;height: 100px;padding: 10px;resize: none;" placeholder="审核意见"></textarea>
		<div style="margin-top:10px;">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="verify_yes()">通过</a>&nbsp;
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="verify_no()">不通过</a>&nbsp;
		</div>
	    
	</div>
</div>
</div>
<input type="hidden" id="pageNumber" value="${pageNumber}"/>
<input type="hidden" id="pageSize" value="${pageSize}"/>
</div>
<div id="datalist"></div>
<div id="importDetail" style="display:none"></div>
<div id="importQuestion"></div>
<div id="importQuestionCd"></div>
<div id="importQuestion2"></div>
<div id="exportQuestion"></div>
<script type="text/javascript">
var cid = $("#c_id").val();
//var permission_json=null;
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
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/question/getQuestionList',
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
		    	  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail('+row.qid+','+ row.mqid+',' + cid + ',' + row.ismain +',' + row.qtiscon +',' + row.atid + ')"><div class="wrap">'+row.content+'</div></a>';
		    	  return s;
	          },sortable:true},
	          {field:'answer',title:'答案',width:60,align:'left',formatter:function(value,row,index){
	          	    var ismain=row.ismain;
				  	if(ismain==1){
				  		return "串题题干<br/>（删除题干，整串删除）";
				  	}else{
						  if(row.atid == 13){
							  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail('+row.qid+','+ row.mqid+',' + cid + ',' + row.ismain +',' + row.qtiscon +',' + row.atid + ')">' +
									  '<div class="wrap">代码答案请点击查看</div></a>';
							  return s;
						  }
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
	          {field:'creator',title:'录入者',width:20,align:'left',sortable:true,formatter:function(value,row,index){
	        	  if(row.creator=='' || row.creator == null || row.creator=="undefined"){
	        		  return row.creatorname;
	        	  }else{
	        		  return row.creator;
	        	  }
	          }},
	          {field:'state',title:'审核状态',width:30,align:'center',sortable:true,formatter:function(value,row,index){
	        	  if(row.state == '1'||row.state == '3'){
	        		  return "通过（"+row.verify_teacher+"）";
	        	  }else if(row.state=='-1'){
	        		  return "不通过（"+row.verify_teacher+"）";
	        	  }else{
	        		  return "未审核";
	        	  }
	          }},
	          /*{field:'verify_teacher',title:'审核人',width:20,align:'center',sortable:true,formatter:function(value,row,index){
	        	  if(row.state == '1'){
	        		  if(row.verify_teacher=='' || row.verify_teacher == null || row.verify_teacher=="undefined"){
	        			  return "<a class='easyui-tooltip' onclick='verify("+ row.qid + "," + row.state + "," + row.ismain  + ")'>"+(typeof(row.verifyname)=="undefined"?"已审核":row.verifyname)+"</a>";
	        		  }else{
	        			  return "<a class='easyui-tooltip' onclick='verify("+ row.qid + "," + row.state + "," + row.ismain  + ")'>"+(typeof(row.verify_teacher)=="undefined"?"已审核":row.verify_teacher)+"</a>";
	        		  }
	        	  }else{
	        		  var rs = "<a class='editcls4 easyui-tooltip' onclick='verify("+ row.qid + "," + row.state + "," + row.ismain  + ")'>未审核</a>";
	        		  return rs;
	        	  }
	          }},*/
	          {field:'addtime',title:'添加时间',width:25,align:'center',sortable:true,formatter:function(value,row,index){
	        	  if(row.addtime==""||row.addtime==null){
	        	  	return "";
	        	  }else{
	        	  	 var dd = new Date(row.addtime).format('yyyy-MM-dd');
		        	 return dd;
	        	  }
	        	 
	          }},
	          /*
	          {field:'state',title:'状态',width:20,align:'left', sortable:true, formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1){
	        		  return '已审核';
	        	  }
	          }},*/
	          {field:'opration',title:'操作',width:40,align:'center',formatter:function(value,row,index){
				  let s1 = '<a href="javascript:void(0);" class="viewQuestion easyui-tooltip" onclick="getQuestionDetail('+row.qid+','+ row.mqid +',' + cid + ',' + row.ismain +',' + row.qtiscon + ',' + row.atid + ')" title="查看详情"></a>';
				  let s2 = '<a href="javascript:void(0);" class="editcls1 easyui-tooltip" onclick="gotoEditQuestion('+row.qid+','+ row.mqid+ ',' + cid + ',' + row.ismain +',' + row.qtiscon + ')" title="编辑试题"></a>';
				  let s3 = '<a href="javascript:void(0)" class="editcls2 easyui-tooltip" title="审核试题" onclick="verify('+ row.qid + ',' + row.state + ',' + row.ismain+ ',' + row.qtiscon  + ')"></a>';
				  let s4 = '<a href="javascript:void(0)" class="editcls3 easyui-tooltip" title="删除试题" onclick="del('+ row.qid +',' + row.ismain +  ',' + row.qtiscon + ')"></a>';
				  let s5 = '<a href="javascript:void(0)" class="editcls5 easyui-tooltip" title="AI操作" onclick="editByAI('+ row.qid + ',' + row.mqid + ',' + row.ismain+ ',' + row.qtiscon  + ')"></a>';
				  return '<div class="wrap">' +s1 + s2 + s3+s4+s5+'</div>';
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewQuestion').linkbutton({text:'',iconCls:'icon-search',plain:true});
	    	$('.editcls1').linkbutton({text:'',iconCls:'icon-edit',plain:true});
	        $('.editcls2').linkbutton({text:'',iconCls:'icon-ok',plain:true});
	        $('.editcls3').linkbutton({text:'',iconCls:'icon-no',plain:true});
	        $('.editcls4').linkbutton({text:'未审核',plain:true});
			$('.editcls5').linkbutton({text:'',iconCls:'icon-tip',plain:true});
	    },
		onBeforeLoad:function(param){
			localStorage.setItem("questionListParam", JSON.stringify(param));
		}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	var err = '${err}';
	if(err!=""){
		toastr.warning(err);
	}
	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
});

function getQuestionDetail(qid,mqid,cid,ismain,qtiscon,atid){
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
					url:"${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&atid="+atid+param,
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

function gotoEditQuestion(qid,mqid,cid,ismain,qtiscon){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:update"; 
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
					url:"${pageContext.request.contextPath}/question/editQuestion?q_id="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+param,
					fit:true,
					title:'修改试题'
				},1);
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
}

function gotoAddQuestion(){
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:add"; 
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
				/*
				var url = "${pageContext.request.contextPath}/question/inAddQuestion?c_id="+c_id+"&pageNumber="+$('#datalist').datagrid('getPager').pagination('options').pageNumber+"&pagesize="+$('#datalist').datagrid('getPager').pagination('options').pageSize;
				var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
				window.parent.$('#nav_tab').tabs('add',{
					title: '新增课程',
					content: content,
					closable: true 
				});*/
				openIframeDialog({
					url:"${pageContext.request.contextPath}/question/inAddQuestion?c_id="+cid,
					fit:true,
					title:'新增试题'
				},1);
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	}         		
   		}
   	});
	
}

function exportSelect(cid){	
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
          		var list = [];
				var rows = $('#datalist').datagrid('getSelections');
				for(var i=0; i<rows.length; i++){
					list.push(rows[i].qid);		
				}
				if(list.length > 0){
					var winStr = '<table width="75%" align="center" style="margin-top:5px;">'
					+ '<tr><td><input type="radio" name="gs" value="0" checked="checked"/>带样式导出（如您需要将试题继续到回到系统中，建议使用带格式导出方式）</td></tr>'
					+ '<tr><td><input type="radio" name="gs" value="1"/>纯文字内容导出</td></tr>'
					+ '<tr><td><input type="button" id="ensureExport" value="导出"/></td></tr>'
					+'</table>';
					var obj = $(winStr);
					$('#exportQuestion').html(null);
					obj.appendTo('#exportQuestion');
					$('#exportQuestion').window({
						width:510,
						height:200,
						modal:true,
						title:"请选择",
						collapsible:false,
						minimizable:false,
						maximizable:false
					});
					$('#ensureExport').click(function(){
						$('#exportQuestion').window('close');
						toastr.info("正在后台生成 Excel…");
						const url = '${pageContext.request.contextPath}/question/exportSelect?cid=' + cid + '&gs='+$("input[name='gs']:checked").val()+'&qids=' + list;
						$.ajax({
							url,
							method: 'GET',
							xhrFields: {
								responseType: 'blob'
							},
							success(data, status, xhr) {
								const disposition = xhr.getResponseHeader('Content-Disposition');
								const fileName = (disposition && /filename\*?=.*''(.+)$/.exec(disposition)?.[1])
										? decodeURIComponent(RegExp.$1)
										: 'export.xlsx';
								const blob = new Blob([data], { type: xhr.getResponseHeader('Content-Type') });
								const link = document.createElement('a');
								link.href = URL.createObjectURL(blob);
								link.download = fileName;
								document.body.appendChild(link);
								link.click();
								link.remove();
								URL.revokeObjectURL(link.href);
								toastr.success("Excel 已下载");
							},
							error(xhr) {
								if (xhr.status === 401) {
									toastr.error("您没有导出权限");      // 根据返回 401 弹不同提示
								} else {
									toastr.error("导出失败，请稍后重试");
								}
							}
						});
					});
					
				}else{
					toastr.warning("请选中任意试题");
				}
          		
          		
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
}

function exportAll(cid){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:export"; 
	var aaa="";
	var bbb="";
	if($("input[name=question]").val()!=null && $("input[name=question]").val()!="请输入查询内容"){
		aaa=$("input[name=question]").val();
	}
	if($("input[name=teacher]").val()!=null && $("input[name=teacher]").val()!="请输入查询内容"){
		bbb=$("input[name=teacher]").val();
	}
	
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var winStr = '<table width="75%" align="center" style="margin-top:5px;">'
					+ '<tr><td><input type="radio" name="gs" value="0" checked="checked"/>原格式导出（如果需要导入系统，建议使用原格式导出）</td></tr>'
					+ '<tr><td><input type="radio" name="gs" value="1"/>智能过滤格式</td></tr>'
					+ '<tr><td><input type="button" id="ensureExport" value="导出"/></td></tr>'
					+'</table>';
					var obj = $(winStr);
					$('#exportQuestion').html(null);
					obj.appendTo('#exportQuestion');
					$('#exportQuestion').window({
						width:510,
						height:200,
						modal:true,
						title:"请选择",
						collapsible:false,
						minimizable:false,
						maximizable:false
					});
					$('#ensureExport').click(function(){
						$('#exportQuestion').window('close');
						toastr.info("正在后台生成 Excel…");
						const url = "${pageContext.request.contextPath}/question/exportAll?cid="+cid+ '&gs='+$("input[name='gs']:checked").val()+"&th1id="+$('#theme1List').val()+"&th1id="+$('#theme2List').val()+"&th3id="+$('#theme3List').val()+"&qtid="+$('#questionTypeList').val()+"&coid="+$('#cognitionList').val()+"&did="+$('#difficultyList').val()+"&kid="+$('#knowledgeList').val()+"&isVerified="+$('#isVerified').val()+"&question="+aaa+"&teacher="+bbb;
						$.ajax({
							url,
							method: 'GET',
							xhrFields: {
								responseType: 'blob'
							},
							success(data, status, xhr) {
								const disposition = xhr.getResponseHeader('Content-Disposition');
								const fileName = (disposition && /filename\*?=.*''(.+)$/.exec(disposition)?.[1])
										? decodeURIComponent(RegExp.$1)
										: 'export.xlsx';
								const blob = new Blob([data], { type: xhr.getResponseHeader('Content-Type') });
								const link = document.createElement('a');
								link.href = URL.createObjectURL(blob);
								link.download = fileName;
								document.body.appendChild(link);
								link.click();
								link.remove();
								URL.revokeObjectURL(link.href);
								toastr.success("Excel 已下载");
							},
							error(xhr) {
								if (xhr.status === 401) {
									toastr.error("您没有导出权限");      // 根据返回 401 弹不同提示
								} else {
									toastr.error("导出失败，请稍后重试");
								}
							}
						});
					});
          		
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
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
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

function verSelect(){
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:verify"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var list = [];
				var rows = $('#datalist').datagrid('getSelections');
				if(rows.length>0){
					for(var i=0; i<rows.length; i++){
						var param = {};
						param["qid"] = rows[i].qid;
						param["mqid"] = rows[i].mqid;
						param["isMain"]=rows[i].ismain;
						list.push(param);		
					}
					var params = {};
					params["list"] = list;
					params["cid"] = cid;
					$.messager.confirm("提示",'是否让所选试题通过审核入库 ?',function(r){
					    if (r){	    	
					    	$.ajax({
					    		contentType: "application/json; charset=utf-8",
					            url: "${pageContext.request.contextPath}/question/verSelect",
					            async: true,//改为同步方式
					            type: "POST",
					            traditional: true,
					            data:JSON.stringify(params),
					            success: function (data) {
					            	toastr.success("审核成功");
				            		$('#datalist').datagrid('reload');        	
					            }
					    	});	
					    }
					});
				}else{
					toastr.warning("您没有选中试题！");
				}
				
          	}else if(data==0){
          		toastr.error("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！");
          	} 	        		
   		}
   	});
}

/*function viewQuestion(qid, mqid){
	if(mqid==null || mqid==undefined){
		mqid = null;
	}
	$.ajax({
        url: "${pageContext.request.contextPath}/question/getQuestionDetail",
        async: false,//改为同步方式
        type: "POST",
        data: {q_id":qid, "mqid":mqid },
        success: function (data) {
        	var str = '';
			answerList = data[0].answerList;
			if(answerList.length > 1){
				var index = 0;
				for(var i=0;i<answerList.length;i++){
					if(i==0){
						str += String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>';
						index = answerList[i].AID;
					}else{
						if(answerList[i].AID>index){
							str += String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>';
						}else{
							str = String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>' + str;
						}
						index = answerList[i].AID;
					}
				}
			}else if(answerList.length == 1 && answerList[0] != null){
				str += answerList[0].CONTENT;
			}
			var res = data[0].content.content + '</br>' +  str;
			if(mqid!=null && mqid!=undefined){
				res = data[1].content.content + '</br>' + res;
			}
			$.messager.alert('试题详细', '<pre>' + res + '</pre>', '');
			return;
 		}
 	});	
}*/

function doSearch(value,name){//通用查询框
	let a  = $('#rangeMin').numberbox('getValue');
	let b  = $('#rangeMax').numberbox('getValue');
	a = (a === '' ? null : parseInt(a, 10));
	b = (b === '' ? null : parseInt(b, 10));
	if (a != null && a < 0) { toastr.warning('提示','最小值必须是非负整数'); return; }
	if (b != null && b < 0) { toastr.warning('提示','最大值必须是非负整数'); return; }
	if (a != null && b != null && a > b) { // 自动交换，省得用户重输
		let t = a; a = b; b = t;
	}
	if (!name) {
		const sb = $('#mainQbox');
		if (sb.length) {
			name  = sb.searchbox('getName');   // 'question' 或 'teacher'
			value = sb.searchbox('getValue');  // 输入的关键字
		} else {
			name = ''; value = '';
		}
	}
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
	    	isVerified : $('#isVerified').val(),
			testNumMin : a,
			testNumMax : b
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
	    	isVerified : $('#isVerified').val(),
			testNumMin : a,
			testNumMax : b
		});
	}else if(name == 'answer'){
		$('#datalist').datagrid('load',{
			c_id : cid,
			answer: value,
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(), 
	    	qtid : $('#questionTypeList').val(),
	    	coid : $('#cognitionList').val(), 
	    	did : $('#difficultyList').val(), 
	    	kid : $('#knowledgeList').val(),
	    	isVerified : $('#isVerified').val(),
			testNumMin : a,
			testNumMax : b
		});
	}
}

var illegalAnswer;
function searchIllegalQuestion(){
	if(illegalAnswer){
		illegalAnswer = null;
	}else {
		illegalAnswer = "illegalAnswer";
	}
	var p = $('#datalist').datagrid('getPager');
	if(illegalAnswer){
		$("#illegalQuestionTips").text("取消显示存在重复选项的试题");
		$('#datalist').datagrid('reload', {
			c_id : cid,
			illegalAnswer : "illegalAnswer",
			page : $(p).pagination('options').pageNumber,
			rows : $(p).pagination('options').pageSize
		});
	}else {
		$("#illegalQuestionTips").text("显示存在重复选项的试题");
		$('#datalist').datagrid('reload', {
			c_id : cid,
			page : $(p).pagination('options').pageNumber,
			rows : $(p).pagination('options').pageSize
		});
	}
}

function verify(qid, state, ismain,iscon){
	if(iscon==1&&ismain==0){
		toastr.warning("串题不对单个分支审核，请审核主题干。");
		return;
	}
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:verify"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		$("#verify_id").val(qid);
          		$("#verify_ismain").val(ismain);
          		$(function(){
          			$('#verifyPage').dialog({
       					resizable: false,
       					width : 400,
       					height : 250,
       					cache : false,
       				   	modal : true,
   				    	title:"审核试题",
   				    	buttons: {
			        		cancle: function() {
			        			$(this).dialog('close');
			        		}
   						}
          			});
          		});
				/*$.messager.confirm("提示",'是否让此试题通过审核入库 ?',function(r){
				    if (r){	    	
				    	$.ajax({
				            url: "${pageContext.request.contextPath}/question/verifyQuestion",
				            async: false,//改为同步方式
				            type: "POST",
				            data: { "q_id":qid, "isMain":ismain, "cid": cid},
				            success: function (data) {
				            	if(data==0){
				            		toastr.success("审核成功");
				            		$('#datalist').datagrid('reload');
				            	}else{
				            		toastr.warning("审核失败");
				            	}	        	
				     		}
				     	});	
				    }else{
				    	return;
				    }
				});*/
          	}else if(data==0){
          		toastr.warning("无相关权限");
          	}else{
          		toastr.error("登录超时，请重新登录！"); 
          	} 	        		
   		}
   	});
}

function verify_yes(){
	$.ajax({
        url: "${pageContext.request.contextPath}/question/verifyQuestion",
        async: false,
        type: "POST",
        data: { "q_id":$("#verify_id").val(), "isMain":$("#verify_ismain").val(), "cid": cid,"state":1},
        success: function (data) {
        	if(data==0){
        		toastr.success("审核操作成功");
        		$('#datalist').datagrid('reload');
        	}else{
        		toastr.warning("审核操作失败");
        	}
 		}
 	});
	$("#verifyPage").dialog('close');
}
 
function verify_no(){
	$.ajax({
        url: "${pageContext.request.contextPath}/question/verifyQuestion",
        async: false,
        type: "POST",
        data: { "q_id":$("#verify_id").val(), "isMain":$("#verify_ismain").val(), "cid": cid,"state":-1,"verify_suggestion":$("#verify_suggestion").val()},
        success: function (data) {
        	if(data==0){
        		toastr.success("审核操作成功");
        		$('#datalist').datagrid('reload');
        	}else{
        		toastr.warning("审核操作失败");
        	}
 		}
 	});
	$("#verifyPage").dialog('close');
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
          		$.messager.confirm("提示",'确定删除当前试题 ?',function(r){ 
			    if (r){
			    	$.ajax({
			            url: "${pageContext.request.contextPath}/question/delQuestion",
			            async: false,//改为同步方式
			            type: "POST",
			            data: { "q_id":qid ,"isMain":ismain,"iscon":iscon,"cid":cid},
			            success: function (data) {
			            	toastr.success("已成功删除"+data+"题");
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

function importQuestion(){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:import"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/question/importQuestion?cid=' + $('#c_id').val()  + '">'
					+ '<table width="100%" align="center" style="margin-top:5px;">'
					+ '<tr><td colspan="2" align="center" style="color:red">导入试题（只接受excel格式）</td></tr>'
					+ '<tr><td>选择文件：</td><td><input id="uploadFile" type="file" name="uploadFile" value="" accept=".xls,.xlsx"/></td></tr>'
					+ '<tr><td>是否查重：</td><td><input type="radio" name="repeat" value="0" checked="checked"/>不查重<input type="radio" name="repeat" value="1"/>数据库+Excel表内查重<input type="radio" name="repeat" value="2"/>Excel表查重</td></tr>'
					+ '<tr><td></td><td><input type="button" id="importFile1" name="importFile1" value="上传"/></td></tr>'
					+ '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/question/importQuestionMonel?cid='+$('#c_id').val()+'">链接</a>'
					+ '</td></tr></table></form>';
					
				var obj = $(winStr);
				$('#importQuestion').html(null);
				obj.appendTo('#importQuestion');
				$('#importQuestion').window({
					width:510,
					height:200,
					modal:true,
					title:"导入试题",
					collapsible:false,
					minimizable:false,
					maximizable:false
					//content:winStr
				});
				$('#importFile1').click(function(){
					var fileName = $('#uploadFile').val();
					if(fileName==''){
						toastr.warning("请选择附件");
						return;
					}
					if(fileName){
						var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
						if(fileType == 'xls' || fileType == 'xlsx'){
							var choose = $("input[name='repeat']:checked").val();
							ajaxUpload(choose,fileName,false);
						}else{
							toastr.warning("上传文件格式错误！");
						}
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

function importWord(){
    var params = {};
    params["cid"] = cid+"";
    params["permission"] = "question:import";
    $.ajax({
        contentType: "application/json; charset=utf-8",
        url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
        async: false,
        type: "POST",
        data: JSON.stringify(params),
        success: function (data) {
            if(data==1){
                var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/question/checkWordFile?cid=' + $("#c_id").val()+'">'
                    + '<table width="100%" align="center" style="margin-top:5px;">'
                    + '<tr><td colspan="2" align="center" style="color:red">导入试题（只接受word文档中的docx格式）</td></tr>'
                    + '<tr><td>选择试题文件：</td><td><input id="uploadQuestionFile" type="file" name="uploadFile" value="" accept=".docx"/></td></tr>'
                    + '<input type="hidden" name="repeat" value="0"/>'
                    + '<tr><td></td><td><input type="button" id="importFile4" name="importFile4" value="上传"/></td></tr>'
                    + '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/question/importQuesFromWordTemp">链接</a>'
                    + '</td></tr></table></form>';
                var obj = $(winStr);
                $('#importQuestionCd').html(null);
                obj.appendTo('#importQuestionCd');
                $('#importQuestionCd').window({
                    width:510,
                    height:200,
                    modal:true,
                    title:"导入试题到课程",
                    collapsible:false,
                    minimizable:false,
                    maximizable:false
                });
                $('#importFile4').click(function(){
                    var qFileName = $('#uploadQuestionFile').val();		//上传文件名
                    if(qFileName==''){
                        toastr.warning("请选择试题附件");
                        return;
                    }

                    if(qFileName){
                        var qFileType = (qFileName.substring(qFileName.lastIndexOf(".")+1,qFileName.length)).toLowerCase();
                        var q = false;
                        if(qFileType == 'doc'||qFileType == 'docx'){
                            q=true;
                        }else{
                            toastr.warning("上传文件格式错误！");
                        }
                        if(q){
                            var choose = $("input[name='repeat']").val();
                            ajaxUploadFile_check(choose, qFileName,'${pageContext.request.contextPath}/question/checkWordFile?cid=' + $('#c_id').val());
                        }else{
                            toastr.warning("上传文件格式错误！");
                        }
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

function ajaxUpload(repeat, fileName,aFileName){
	$('#importQuestion').window('close');
	ajaxLoading();
	var formData = new FormData();
	var link = '${pageContext.request.contextPath}/question/importQuestion?cid=' + $('#c_id').val()+ '&repeat='+ repeat;
	if(aFileName){
		link='${pageContext.request.contextPath}/question/importWordToCourse?cid=' + $('#c_id').val()+ '&repeat='+ repeat;
		formData.append("uploadQuestionFile",$("#uploadQuestionFile")[0].files[0]);
		formData.append("uploadAnswerFile",$("#uploadAnswerFile")[0].files[0]);
	}else{
		formData.append("uploadFile",$("#uploadFile")[0].files[0]);
	}

	$.ajax({
		url: link,
		type: 'POST',
		secureuri: false,
		data: formData,
		processData:false,
		contentType:false,
		success:function(data){
			ajaxLoadEnd();
			$('#datalist').datagrid('reload');
			$.extend($.messager.defaults,{
				ok:"导出详细报告",
				cancel:"取消"
			});
			$.messager.confirm({
				width: '380',
				title: '提示',
				msg: data.message + '用时'+ data.times + '毫秒',
				fn: function (r) {
					if(r){
						$("#importDetail").html(data.message +"<br>用时：" +data.times + "毫秒");
						var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;}";
						s += "th {width:30%} div {text-align:center;}";
						var name = "导入报告"+new Date().format('yyyy-MM-dd');
						$("#importDetail").wordExport(name,s);
					}
				}
			});
			$.extend($.messager.defaults,{
				ok:"确认",
				cancel:"取消"
			});
		}
	});
}

function ajaxUploadFile_check(repeat, fileName,url){
    $('#importQuestionCd').window('close');
    ajaxLoading();
    var formData = new FormData();
    formData.append("uploadQuestionFile",$("#uploadQuestionFile")[0].files[0]);
    formData.append("name",fileName);
    $.ajax({
        url: url,
        type: 'POST',
        async: false, 
        data: formData,
        secureuri: false,
        processData:false,
        contentType:false,
        success:function(data){
            ajaxLoadEnd();
            if(data.code=='002'){
                $.messager.confirm("提示",data.message,function(r){
                    if(r){
                        $.ajax({
                            url: '${pageContext.request.contextPath}/question/importWord',
                            async: false,
                            type: "POST",
                            traditional: true,
                            data: {"cid":$('#c_id').val(),"repeat":$("input[name='repeat']").val()},
                            success: function (rs) {
                                $('#datalist').datagrid('reload');
                                $.extend($.messager.defaults,{
                                    ok:"导出详细报告",
                                    cancel:"取消"
                                });
                                $.messager.confirm({
                                    width: '380',
                                    title: '提示',
                                    msg: rs.message + '用时'+ rs.times + '毫秒',
                                    fn: function (r) {
                                        if(r){
                                            $("#importDetail").html(rs.message +"<br>用时：" +rs.times + "毫秒");
                                            var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;}";
                                            s += "th {width:30%} div {text-align:center;}";
                                            var name = "导入报告"+new Date().format('yyyy-MM-dd');
                                            $("#importDetail").wordExport(name,s);
                                        }
                                    }
                                });
                                $.extend($.messager.defaults,{
                                    ok:"确认",
                                    cancel:"取消"
                                });
                            }
                        });
                    }
                });
			}else{
				$.messager.alert({
			　　　　　　　　title:'出错了',
			　　　　　　　　msg:data.message,
			　　　　　　　　icon:'error'
			　　　　});
            }

        }
    });
}

function transferData(){
	var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/question/transferData?cid=' + $('#c_id').val()  + '">'
		+ '<table width="100%"><tr><td>'
		+ '<input id="uploadFile" type="file" name="uploadFile" value=""/>'
		+ '<input type="submit" value="上传"/>'
		+ '</td></tr></table></form>';

	var obj = $(winStr);
	$('#importQuestion').html(null);
	obj.appendTo('#importQuestion');
	$('#importQuestion').window({
		width:440,
		height:130,
		modal:true,
		title:"数据迁移",
		collapsible:false,
		minimizable:false,
		maximizable:false
		//content:winStr
	});
}

function delSelect(){
	var params = {};
	params["cid"] = cid;
	params["permission"] = "question:patchDel";
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
					$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){
						if(r){
							let list = [];
							for(let i=0;i<rows.length;i++){
								let param = {};
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
									url: "${pageContext.request.contextPath}/question/delSelectQuestion",
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
	var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题  	
	if(title == '课程列表' || title == '新增课程'){
		url = "${pageContext.request.contextPath}/course/inCourse?back=1";
		window.location.href = url;
	}else if(title == '编辑试题'){
		url = "${pageContext.request.contextPath}/question/ineditQuestion?back=1";
		window.location.href = url;
	}else{
		history.back();
	}
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

function toFindRepeatQuestions(cid){
	var url = '${pageContext.request.contextPath}/question/toFindRepeatQuestions?cid='+cid;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '查找重复试题',
		content: content,
		closable: true 
	});
	/*openIframeDialog({
		url:"${pageContext.request.contextPath}/question/toFindRepeatQuestions?cid="+cid,
		fit:true,
		title:'查找重复试题'
	},0);*/
}

function ajaxLoading() { 
	$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(document).height() }).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候...").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(document).height() - 45) / 2 });
}

function ajaxLoadEnd() {
    $("div[class='datagrid-mask']").remove();
    $("div[class='datagrid-mask-msg']").remove();
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
					if(rs[i].CONTENT!=null&&rs[i].CONTENT!=''&&rs[i].CONTENT!='null'&&typeof(rs[i].CONTENT)!='undefined'){
						out += '<a>'+ p + '.' + rs[i].CONTENT + '</a><br/>';
					}else{
						out += '<a>'+ p + '.' + rs[i].CONTENT_6 + '</a><br/>';
					}
					
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
/*
function importQuestion2(){
	var params = {};
	params["cid"] = cid+"";
	params["permission"] = "question:import"; 
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/question/importQuestion2?cid=' + $('#c_id').val()  + '">'
					+ '<table width="75%" align="center" style="margin-top:5px;">'
					+ '<tr><td colspan="2" align="center" style="color:red">导入试题（只接受excel格式）</td></tr>'
					+ '<tr><td>选择文件：</td><td><input id="uploadFile" type="file" name="uploadFile" value=""/></td></tr>'
					+ '<tr><td></td><td><input type="button" id="importFile9" name="importFile9" value="上传"/></td></tr>'
					+ '</td></tr></table></form>';
					
				var obj = $(winStr);
				$('#importQuestion2').html(null);
				obj.appendTo('#importQuestion2');
				$('#importQuestion2').window({
					width:510,
					height:182,
					modal:true,
					title:"导入试题",
					collapsible:false,
					minimizable:false,
					maximizable:false
				});
				$('#importFile9').click(function(){
					var fileName = $('#uploadFile').val();
					if(fileName==''){
						toastr.warning("请选择附件");
						return;
					}
					if(fileName){
						var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
						if(fileType == 'xls' || fileType == 'xlsx'){
							var choose = $("input[name='repeat']:checked").val();
							ajaxUpload2(choose, fileName);
						}else{
							toastr.warning("上传文件格式错误！");
						}
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

function ajaxUpload2(repeat, fileName){
	$('#importQuestion2').window('close');
	ajaxLoading();
	var formData = new FormData();
	formData.append("uploadFile",$("#uploadFile")[0].files[0]);
	formData.append("name",fileName);
	$.ajax({
		url: '${pageContext.request.contextPath}/question/importQuestion2?cid=' + $('#c_id').val()+ '&repeat='+ repeat,
		type: 'POST',
		secureuri: false,
		data: formData,
		processData:false,
		contentType:false,
		success:function(data){
			ajaxLoadEnd();
			$('#datalist').datagrid('reload');
			$.extend($.messager.defaults,{
				ok:"导出详细报告",
				cancel:"取消"
			});
			$.messager.confirm({
			    width: '380',
			    title: '提示',
			    msg: data.message + '用时'+ data.times + '毫秒',
			    fn: function (r) {
			        if(r){
						$("#importDetail").html(data.message +"<br>用时：" +data.times + "毫秒");
						var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;}";
						s += "th {width:30%} div {text-align:center;}";
						var name = "导入报告"+new Date().format('yyyy-MM-dd');
						$("#importDetail").wordExport(name,s);
					}
			    }
			}); 
			$.extend($.messager.defaults,{
				ok:"确认",
				cancel:"取消"
			});				
		}
	});
}
*/
function ajaxUploadFile(repeat, fileName,url){
    $('#importQuestionCd').window('close');
    ajaxLoading();
    var formData = new FormData();
    formData.append("uploadQuestionFile",$("#uploadQuestionFile")[0].files[0]);
    formData.append("name",fileName);
    $.ajax({
        url: url,
        type: 'POST',
        secureuri: false,
        data: formData,
        processData:false,
        contentType:false,
        success:function(data){
            ajaxLoadEnd();
            $('#datalist').datagrid('reload');
            $.extend($.messager.defaults,{
                ok:"导出详细报告",
                cancel:"取消"
            });
            $.messager.confirm({
                width: '380',
                title: '提示',
                msg: data.message + '用时'+ data.times + '毫秒',
                fn: function (r) {
                    if(r){
                        $("#importDetail").html(data.message +"<br>用时：" +data.times + "毫秒");
                        var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;}";
                        s += "th {width:30%} div {text-align:center;}";
                        var name = "导入报告"+new Date().format('yyyy-MM-dd');
                        $("#importDetail").wordExport(name,s);
                    }
                }
            });
            $.extend($.messager.defaults,{
                ok:"确认",
                cancel:"取消"
            });
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
		c_id : cid,
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(), 
    	did : $('#difficultyList').val(), 
    	kid : $('#knowledgeList').val(),
    	isVerified : $('#isVerified').val(),
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
	});
}

function intoQuestionAIModule(){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/intelliQuestion/intoQuestionAIModule?cid="+cid+'&cname='+$("#cname").val(),
		fit:true,
		title:$("#cname").val()+' 试题管理 AI模块'
	},1);
}

function editByAI(qid,mqid,ismain,iscon){
	if(mqid===null || mqid===undefined || typeof(mqid) == "undefined" || mqid==="null") mqid="";
	openIframeDialog({
		url:"${pageContext.request.contextPath}/intelliQuestion/editByAI?cid="+cid+'&qid='+qid+'&mqid='+mqid+'&isMain='+ismain+'&iscon='+iscon,
		fit:true,
		title:$("#cname").val()+' 试题编辑 AI模块'
	},1);
}
</script>