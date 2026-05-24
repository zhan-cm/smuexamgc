<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
.qcontent{
	height: 30px;
	width: 300px;
	margin-right:10px;
	overflow:hidden;
	float:left;
}
.qlimit{
	padding:2px .8px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	width:100px;
	border-color: #95B8E7;
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
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="cid" value="${cid}"/>
<input type="hidden" id="eid" value="${eid}"/>
<input type="hidden" id="state" value="${state}"/>
<input type="hidden" id="eids" value="${eids}"/>
<!-- <input type="hidden" name="forbidNum" id="question_use_time"  value="${applicationScope.question_use_time}"/>
<input type="hidden" name="forbidDay" id="question_used_day"  value="${applicationScope.question_used_day}"/> -->

<table style="width:100%;margin-top:10px;">
	<tr>
		<td><h1 style="color:red;text-align:center;width:100%;font-size:20px;">距离重新登录时间还有<span id="time" style="font-size:20px;"></span>，请在重新登录前保存要添加的题目</h1></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="cancel();" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">取消组卷</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="reload()">刷新</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addQuestionIntoPaper()">将选定的题目添加到试卷</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-book_add',plain:true" onclick="addAllQuestionIntoPaper()">合并所有试题</a>&nbsp;&nbsp;
			<a href="javascript:void(0);" onclick="adjustPaper('${cid}','${eid}')" class="easyui-linkbutton" data-options="iconCls:'icon-book_edit',plain:true" >下一步：按题型调整顺序分值时间</a>
			<c:choose>
				<c:when test="${empty courseList}">
					<a>${cname}</a>
				</c:when>
				<c:otherwise>
					<select id="courseList" name="courseList" class="qlimit" onchange="getCourseFilter()">
						<option value="">全部课程</option>
						<c:forEach var="course" items="${courseList}">
							<option value="${course.ID}">${course.NAME_C}</option>
						</c:forEach>
					</select>
				</c:otherwise>
			</c:choose>
			<%-- 
				<option value="">全部课程</option>
				<c:forEach var="course" items="${courseList}">
					
				</c:forEach>
			</select> --%>
			<select id="theme1List" name="theme1List" class="qlimit">
				<option value="">全部主题词一</option>
				<c:forEach var="theme" items="${courseInfo.theme1Filter}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach>
			</select>
			<select id="theme2List" name="theme2List" class="qlimit">
				<option value="">全部主题词二</option>
			</select>
			<select id="theme3List" name="theme3List" class="qlimit">
				<option value="">全部主题词三</option>
			</select>
			<select id="questionTypeList" name="questionTypeList" class="qlimit" onchange="questionFilter()">
				<option value="">全部题型</option>
				<c:forEach var="questionType" items="${courseInfo.questionTypeFilter}">
					<option value="${questionType.ID}">${questionType.NAME}</option>
				</c:forEach>
			</select>
			<select id="cognitionList" name="cognitionList" class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>					
				<c:forEach var="cognition" items="${courseInfo.cognitionFilter}">
					<option value="${cognition.ID}">${cognition.NAME}</option>
				</c:forEach>				
			</select>
			<select id="difficultyList" name="difficultyList" class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${courseInfo.difficultyFilter}">
					<option value="${difficulty.ID}">${difficulty.NAME}</option>
				</c:forEach>
			</select>
			<select id="knowledgeList" name="knowledgeList" class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${courseInfo.knowledgeFilter}">
					<option value="${knowledge.ID}">${knowledge.NAME}</option>
				</c:forEach>
			</select>
			<!-- 
			<select id="isVerified" name="isVerified"  class="qlimit" onchange="questionFilter()">
				<option value="">全部</option>
				<option value="0">未审核</option>
				<option value="1">已审核</option>
			</select> -->
			<!-- <select id="" name=""  style="width:100px;" class="">
				<option value=" "> </option>
			</select> -->
		</td>
	</tr>
	<tr>
		<td>
			不选用<input type='text' id='forbidDay' name='forbidDay'  value="${forbidDay}" style='width:50px'/>天之内考过的试题，不选用使用过<input type='text' id='forbidNum' name='forbidNum' value="${forbidNum}" style='width:50px'/>次及以上的试题，
			<c:choose>
				<c:when test="${isVerified==1 }">
				<c:if test="${question_verify_switch==1 }">
					<select id='isVerified' name='isVerified'  class="qlimit" onchange="questionFilter()"><option value='3'>已终审</option></select>
				</c:if>
				<c:if test="${question_verify_switch==0 }">
					<select id='isVerified' name='isVerified'  class="qlimit" onchange="questionFilter()"><option value='1'>已审核</option></select>
				</c:if>
				</c:when>
				<c:otherwise>
					<select id='isVerified' name='isVerified'  class="qlimit" onchange="questionFilter()">
						<option value='0' selected='selected'>全部</option>
						<c:if test="${question_verify_switch==1 }">
							<option value='1'>已初审</option>
							<option value='3'>已终审</option>
						</c:if>
						<c:if test="${question_verify_switch==0 }">
							<option value='1'>已审核</option>
						</c:if>
					</select>
				</c:otherwise>
			</c:choose>								
			
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="questionFilter()">确定</a>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var question_used_day=$("#forbidDay").val();
var question_use_time=$("#forbidNum").val();
$('#forbidDay').tooltip({
    position: 'bottom',
    content: '<span style="color: rgb(255, 255, 255);">0表示不做筛选；如果输入值大于系统设置参数，则默认按照系统参数查找题目。当前系统设置为：“不使用'+question_used_day+'天内考过的试题！”</span>',
    onShow: function(){
        $(this).tooltip('tip').css({
            backgroundColor: '#666',
            borderColor: '#666',
        });
    }
});
$('#forbidNum').tooltip({
    position: 'bottom',
    content: '<span style="color: rgb(255, 255, 255);">0表示不做筛选；如果输入值大于系统设置参数，则默认按照系统参数查找题目。当前系统设置为：“不选用使用过'+question_use_time+'次及以上的试题！”</span>',
    onShow: function(){
        $(this).tooltip('tip').css({
            backgroundColor: '#666',
            borderColor: '#666',
        });
    }
});

var time = 1800;//设定倒计时半小时
setTime();
var cid = $("#cid").val();
var eid = $("#eid").val();
var eids = $("#eids").val();
var state = $("#state").val();
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getQuestionFromPaper',
 		pagination: true,
		rownumbers: false, 
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		queryParams:{
			eid : eid,
			eids:eids
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'qid',checkbox:true},
			  {field:'qtname',title:'题型',width:40,align:'left',sortable:true,formatter:function(value,row,index){
				  if(row.iscon==1){
					  return row.qtname + "<br/>(串题题干)";
				  }else{
					  return row.qtname
				  }
			  }},
			  {field:'content',title:'题目',width:145,align:'left',formatter:function(value,row,index){
	    		  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail(\''+row.eid+'\',\''+ row.qid+'\',\''+ row.mqid+ '\',\'' + row.ismain +'\',\'' + row.iscon + '\',\'' + row.atid + '\',\'edit\')"><div class="wrap">'+row.content+'</div></a>';
		    	  return s;
	          }},
	          {field:'answer',title:'答案(串题显示分支)',width:120,align:'left',formatter:function(value,row,index){
	        	  if(row.iscon==1){
	        		  return printSubtopic(row.branch);
	        	  }else{
	        		  return printAnswer(row.answer,row.answerid);
	        	  }
	          }},
	          {field:'soname',title:'题源',width:40,align:'left',sortable:true},
	          {field:'coname',title:'认知分类',width:40,align:'left',sortable:true},
	          {field:'dname',title:'难度',width:40,align:'left',sortable:true},
	          {field:'kname',title:'知识点分布',width:40,align:'left',sortable:true},
	          {field:'time',title:'应答时间',width:40,align:'left',sortable:true},
		      {field:'t1name',title:'主题词',width:70,align:'left',formatter:function(value,row,index){
		    	  var s = row.t1name;
		    	  if(row.t2name){
		    		  s += ' / ' + row.t2name;
		    	  }
		    	  if(row.t3name){
		    		  s += ' / ' + row.t3name;
		    	  }
		    	   return s;
	          }},
	          {field:'realdifficulty',title:'实测难度',width:20,align:'left',sortable:true},
	          {field:'distinction',title:'区分度',width:20,align:'left',sortable:true},
	          {field:'standarddeviation',title:'标准差',width:20,align:'left',sortable:true},
	          {field:'zl',title:'质量判断',width:20,align:'left'},
	          {field:'num',title:'已考次数',width:20,align:'left',sortable:true},
	          //{field:'STATE',title:'状态',width:40,align:'left',sortable:true},
	          {field:'state',title:'状态',width:40,align:'left',formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1||row.state==3){
	        		  return '已审核';
	        	  }else if(row.state==2){
	        		  return '已删除';
	        	  }
	          }}
	    ]],
	     onLoadSuccess:function(data){
	    	$('.viewQuestion').linkbutton({text:'详细',iconCls:'icon-search',plain:true});
	    } 
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

//添加到试卷
function addQuestionIntoPaper(){
	
    $("#forbidDayforbidDay").val($("#forbidDay").val());
    $("#question_use_time").val($("#forbidNum").val());
	var res = [];
	var rows = $('#datalist').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		res.push(rows[i].qid+"#"+rows[i].eid+"#"+rows[i].qtid+"#"+rows[i].ismain);
	}

	function uniqueArray(a){
	    temp = new Array();
	    for(var i = 0; i < a.length; i ++){
	        if(!contains(temp, a[i])){
	            temp.length+=1;
	            temp[temp.length-1] = a[i];
	        }
	    }
	    return temp;
	}
	function contains(a, e){
	    for(j=0;j<a.length;j++)if(a[j]==e)return true;
	    return false;
	}

	if(uniqueArray(res).length===0){
		toastr.warning("至少选择一题！");
		return;
	}
	
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/addQuestion4CombinePaper",
        async: true,//改为同步方式
        type: "POST",
        traditional: true,
        data: { "qids": uniqueArray(res), "c_id" : cid, "ei_id" : eid , "forbidDay" : $("#forbidDay").val(), "isVerified" : $('#isVerified').val(), "forbidNum" : $("#forbidNum").val() },
        success: function (data) {
        	if(data==""||data==null){
        		toastr.error("添加失败！");
        		return;
        	}
        	//toastr.success("已添加"+data+"题，可继续加题！");
        	$.messager.defaults = { ok: "继续加题", cancel: "前往赋分操作" };
        	$.messager.confirm({
			    width: '380',
			    title: '提示',
			    msg: '已添加'+data+'题，请选择继续加题或下一步赋分操作。',
			    fn: function (r) {
			         if (r){
	    		    	$('#datalist').datagrid('reload');
	    		    }else{
	    		    	window.location.href = '${pageContext.request.contextPath}/paper/adjustPaper4combinePaper?c_id=' + cid + '&ei_id=' + eid;
	    		    }
			    }
			});      
			$("div.messager-button").find(".l-btn").each(function(index){
				$(this).css("width","150px");
			})   	
        }
	});  
}

function addAllQuestionIntoPaper(){
	toastr.warning("合并所有试题耗时比较长，请耐心等待！");
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/addAllQuestionIntoPaperFromPaper",
        async: true,//改为同步方式
        type: "POST",
        traditional: true,
        data: { "eids": eids, "cid" : cid, "eid" : eid, "forbidDay" : $("#forbidDay").val(), "isVerified" : $('#isVerified').val(), "forbidNum" : $("#forbidNum").val()},
        success: function (data) {
        	if(data==""||data==null){
        		toastr.error("添加失败！");
        		return;
        	}
        	window.location.href = '${pageContext.request.contextPath}/paper/adjustPaper4combinePaper?c_id=' + cid + '&ei_id=' + eid;
        }
	});  
}

function adjustPaper(cid,eid){
	window.location.href = '${pageContext.request.contextPath}/paper/adjustPaper4combinePaper?c_id=' + cid + '&ei_id=' + eid;
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
	var val = $('#courseList').val();
	if(val==''||typeof(val)=='undefined'){
		val = '';
	}
 	$('#datalist').datagrid('reload', {
 		cid : val,
 		eid : eid,
 		eids:eids,
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(), 
    	did : $('#difficultyList').val(), 
    	kid : $('#knowledgeList').val(),
    	isVerified : $('#isVerified').val(),
    	forbidNum : $("#forbidNum").val(),
    	forbidDay : $("#forbidDay").val()
 	});
    toastr.success('查询成功！');
 	/* if($('#theme2List').val()){
 		getThemeList(3, $('#theme2List').val());
 	}else{
 		if($('#theme1List').val()){
 	 		getThemeList(2, $('#theme1List').val());
 	 	}
 	} */
}

function getCourseFilter(){
	var id = $('#courseList').val();
	questionFilter();
	var rs = '';
	//cleanFilter();
	$.ajax({
		url: "${pageContext.request.contextPath}/paper/getPaperFilter",
		async: false,
		type: "POST",
		data: {"eid":eids, "cid": id},
		success:function(data){
			rs = data;
		}
	});
	var theme1 = $('#theme1List');
	var theme2 = $('#theme2List');
	var theme3 = $('#theme3List');
	var questionType = $('#questionTypeList');
	var cognition = $('#cognitionList');
	var difficulty = $('#difficultyList');
	var knowledge = $('#knowledgeList');
	theme1.empty();
	theme1.append('<option value="">全部主题词一</option>');
	theme2.empty();
	theme2.append('<option value="">全部主题词二</option>');
	theme3.empty();
	theme3.append('<option value="">全部主题词三</option>');
	questionType.empty();
	questionType.append('<option value="">全部题型</option>');
	cognition.empty();
	cognition.append('<option value="">全部认知</option>');
	difficulty.empty();
	difficulty.append('<option value="">全部难度</option>');
	knowledge.empty();
	knowledge.append('<option value="">全部知识点</option>');
	
	var qList = rs.questionTypeFilter;
	for(var i=0;i<qList.length;i++){
		questionType.append('<option value="'+qList[i].ID+'">'+qList[i].NAME+'</option>')
	}
	var t1 = rs.theme1Filter;
	for(var i=0;i<t1.length;i++){
		theme1.append('<option value="'+t1[i].ID+'">'+t1[i].NAME+'</option>');
	}
	var cList = rs.cognitionFilter;
	for(var i=0;i<cList.length;i++){
		cognition.append('<option value="'+cList[i].ID+'">'+cList[i].NAME+'</option>');
	}
	var dList = rs.difficultyFilter;
	for(var i=0;i<dList.length;i++){
		difficulty.append('<option value="'+dList[i].ID+'">'+dList[i].NAME+'</option>');
	}
	var kList = rs.knowledgeFilter;
	for(var i=0;i<kList.length;i++){
		knowledge.append('<option value="'+kList[i].ID+'">'+kList[i].NAME+'</option>');
	}
}

function getThemeList(th_level, th_pid){
	var cids = cid.split(",");
	var result = '';
	for(var i=0;i<cids.length;i++){
		$.ajax({
	        url: "${pageContext.request.contextPath}/course/getThemeList",
	        async: false, 
	        type: "POST",
	        data: {"th_level": th_level, "th_pid": th_pid, "c_id": cids[i]}, 
	        success: function (data) {
	        	if(JSON.stringify(data)!=='[]'){
	        		result = data;
	        	}
	 		}
	 	});
	}
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
	if(result!=''){
		$.each(eval(result),function(i,item){
			str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
		});
	}
	$(thStr).append(str);
}

function getQuestionDetail(eid_,qid,mqid,ismain,iscon,atid,edit){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	 }
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/previewQuestion?qid="+qid+"&mqid="+mqid+"&isMain="+ismain+"&iscon="+iscon +"&eid="+eid_+"&atid="+atid+"&edit="+edit,
		fit:true,
		title:'查看试题'
	},0);	
}

function cancel(){
	/* $.ajax({
        url: '${pageContext.request.contextPath}/paper/cancelCombinePaper',
        async: false, 
        type: "POST",
        data: {"eid":$("#eid").val()},
        success: function (data) {
        	window.location.href = "${pageContext.request.contextPath}/paper/inCombinePaper";
		}
	}); */
	window.location.href = "${pageContext.request.contextPath}/paper/inCombinePaper";
}

function openIframeDialog(options,reload){
	var defaults = {
//		id		:	'',
//		url	:	'',
//		width	:	600,
//		height	:	400,
		fit:true,
		title	:	'查看',
		modal:true,
		resizable:true,
		hrefMode:"iframe",
		onClose:function(){
			$(this).dialog("destroy");
			if(reload==1){
				$('#datalist').datagrid('reload');
			}
		}
	};

	options = $.extend(defaults, options);
	//先渲染dlg，再加载
	var $dlg = $('<div id="ifmdlg"><iframe style="width:100%;height:100%;border:0;overflow:auto;"></iframe></div>');
	var ret = $dlg.dialog(options);
	$dlg.find('iframe')[0].src=options.url;
	return ret;
}

function printSubtopic(data){
	var rs = '<span style="color:red;">'+data.length+"个分支"+'</span><br/>';
	for(var i=0;i<data.length;i++){
		if(data[i].content.length>10){
			rs += (i+1)+'.'+data[i].content.substring(0,10)+'...'+'</br>';
		}else{
			rs += (i+1)+'.'+data[i].content+'</br>';
		}	
		
	}
	return rs;
}

function printAnswer(rs,aid){
	var p = '';//选择题ABCDE
	var out = '';
	if(typeof(aid)=='undefined'){
		aid = '';
	}
	var aid = aid.split(",");
	for(var i=0;i<rs.length;i++){
		if(rs[i].ATID<4){
			p = String.fromCharCode(65+i);
			for(var j=0;j<aid.length;j++){
				if(rs[i].AID==aid[j]){
					out += '<a>'+ p + '.' + rs[i].ACONTENT + '</a><br/>';
				}
			}
			/* else{
				out += p + '.' + rs[i].ACONTENT + '<br/>';
			} */
		}else if(rs[i].ATID==4){
			if(rs[i].ACONTENT=='true'){
				out += '对';
			}else{
				out += '错';
			}
			//out += rs[i].ACONTENT;
		}else{
			if(typeof(rs[i].ACONTENT_6)=="undefined"){
				out += "";
			}else{
				out += rs[i].ACONTENT_6;
			}
		}
	}
	return out;
}

function setTime(){
	var h = 0;
	var m = 0;
	var s = 0;
	
	if(time >= 3600){
		h = parseInt(time / 3600);
		m = parseInt((time % 3600) / 60);
		s = (time % 3600) % 60;
	}else if(time >= 60){
		m = parseInt(time / 60);
		s = time % 60;
	}else if(time<60 && time >= -1){
		s = time;
	}
	
	if (h > 0) {
		$('#time').html(h + '时' + m + '分' + s + '秒');
	} else if (m > 0) {
		$('#time').html(m + '分' + s + '秒');
	} else if (s > -1) {
		$('#time').html(s + '秒');
	}
	
	setTimeout(function(){
		setTime();
	},1000);
	
	time--;
}

function reload(){
	$('#datalist').datagrid('reload');
}
</script>	

