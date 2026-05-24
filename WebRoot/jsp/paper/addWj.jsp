<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
.qcontent{
	height: 30px;
	width: 100%;
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
</style>
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>	
<table style="width:100%;margin-top:10px;">
	<tr>
		<td><h1 style="color:red;text-align:center;width:100%;font-size:20px;">距离重新登录时间还有<span id="time" style="font-size:20px;"></span>，请在重新登录前保存要添加的题目</h1></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addQuestionIntoPaper()">添加到试卷</a>
			<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="adjustPaper()">按题型调整分值时间</a> -->
			
			<select id="theme1List" name="themeList" class="qlimit">
				<option value="">全部主题词一</option>
				<c:forEach var="theme" items="${courseInfo[0].themeList}">
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
				<c:forEach var="questionType" items="${courseInfo[0].questionTypeList}">
					<option value="${questionType.QTID}">${questionType.QTNAME}</option>
				</c:forEach>
			</select>
			<select id="cognitionList" name="cognitionList" class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>					
				<c:forEach var="cognition" items="${courseInfo[0].cognitionList}">
					<option value="${cognition.COID}">${cognition.CONAME}</option>
				</c:forEach>				
			</select>
			<select id="difficultyList" name="difficultyList" class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${courseInfo[0].difficultyList}">
					<option value="${difficulty.DID}">${difficulty.DNAME}</option>
				</c:forEach>
			</select>
			<select id="knowledgeList" name="knowledgeList" class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${courseInfo[0].knowledgeList}">
					<option value="${knowledge.KID}">${knowledge.KNAME}</option>
				</c:forEach>
			</select>
			<select id="isVerified" name="isVerified"  class="qlimit" onchange="questionFilter()">
				<option value="">全部试题状态</option>
				<option value="0">未审核</option>
				<option value="1">已审核</option>
			</select>
		</td>
		
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var time = 1800;//设定倒计时半小时
setTime();
var cid = $("#c_id").val();
var ei_id = $("#ei_id").val();
toastr.info("提示：添加调查问卷，试卷需要重新提交审核");
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getWjQuestionList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		queryParams: {
			ei_id: ei_id
		},
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'qid',checkbox:true},
			  {field:'qtname',title:'题型',width:40,align:'left',sortable:true},
		      {field:'content',title:'题目',width:120,align:'left',formatter:function(value,row,index){
		    	  var s = '';
		    	  s+= '<div class="qcontent" style="padding-bottom:100px;" onclick="getQuestionDetail(\''+row.qid+'\',\''+ row.mqid+ '\',\'' + row.version +'\',\'' + row.ismain +'\',\'' + row.iscon + '\')">'+row.content+'</div>';
		    	  return s;
	          }},
	          {field:'answer',title:'答案',width:120,align:'left',formatter:function(value,row,index){
	        	  return printAnswer(row.answer,row.answerid);
	          }},
	          {field:'soname',title:'题源',width:40,align:'left',sortable:true},
	          {field:'coname',title:'认知分类',width:40,align:'left',sortable:true},
	          {field:'dname',title:'难度',width:40,align:'left',sortable:true},
	          {field:'kname',title:'知识点分布',width:40,align:'left',sortable:true},
	          {field:'answertime',title:'应答时间',width:40,align:'left',sortable:true},
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
	          {field:'num',title:'已考次数',width:20,align:'left',sortable:true},
	          //{field:'STATE',title:'状态',width:40,align:'left',sortable:true},
	          {field:'state',title:'状态',width:40,align:'left',formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1){
	        		  return '已审核';
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
	var res = [];
	var rows = $('#datalist').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		res.push(rows[i].qid+'_'+rows[i].ismain);
	/*
		if(rows[i].ISCON == 1){
			res.push(rows[i].MQID);
		}else{
			res.push(rows[i].QID);
		}*/
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
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/addQuestionIntoPaper",
        async: true,//改为同步方式
        type: "POST",
        traditional: true,
        data: { "qids": uniqueArray(res), "c_id" : cid, "ei_id" : ei_id},
        success: function (data) {
        	if(data==""||data==null){
        		toastr.error("添加失败！");
        		return;
        	}
        	$.messager.defaults = { ok: "继续加题", cancel: "调整试卷分值与时间" };
        	$.messager.confirm({
			    width: '380',
			    title: '提示',
			    msg: '已添加'+data+'题，请选择继续加题或调整试卷分值与时间。',
			    fn: function (r) {
			         if (r){
	    		    	$('#datalist').datagrid('reload');
	    		    }else{
	    		    	adjustPaper();
	    		    	//window.location.href = '${pageContext.request.contextPath}/paper/editApaper?c_id=' + cid + '&ei_id=' + ei_id;
	    		    }
			    }
			});
			$("div.messager-button").find(".l-btn").each(function(index){
				$(this).css("width","150px");
			})
        }
	}); 
}

function adjustPaper(){
	window.location.href = '${pageContext.request.contextPath}/paper/adjustPaper?c_id=' + cid + '&ei_id=' + ei_id;
}

function viewQuestion(qid, version, mqid){
	if(mqid==null || mqid==undefined){
		mqid = null;
	}
	$.ajax({
        url: "${pageContext.request.contextPath}/question/getQuestionDetail",
        async: false,//改为同步方式
        type: "POST",
        data: { "q_id":qid, "version":version, "mqid":mqid },
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
				res = '<pre>' + data[1].content.content + '</pre>' + res;
			}
			$.messager.alert('试题详细',  res,'');
			return;
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

$('#courseList').change(function(){
	getThemeList(1,-1);
	
	//清空主题词二
	var t2List = $('#theme2List');
	t2List.empty();
	t2List.append('<option value="">全部主题词二</option>');
	
	//清空主题词三
	var t3List = $('#theme3List');
	t3List.empty();
	t3List.append('<option value="">全部主题词三</option>');
	
	questionFilter();
})

function questionFilter(){
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		c_id : $('#courseList').val(),
 		ei_id : ei_id,
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
 	/* console.log($('#theme1List').change()) */
 	/* $('#theme1List').change(function(){
 		getThemeList(2, $('#theme1List').val());
 	}) */
 	/* if($('#theme2List').val()){
 		getThemeList(3, $('#theme2List').val());
 	}else{
 		if($('#theme1List').val()){
 	 		getThemeList(2, $('#theme1List').val());
 	 	}
 	} */
}

function getThemeList(th_level, th_pid){
	debugger;
	var c = $('#c_id').val();
	var cids = c.split(",");
	var result = [];
	for(var i=0;i<cids.length;i++){
		$.ajax({
	        url: "${pageContext.request.contextPath}/course/getThemeList",
	        async: false, 
	        type: "POST",
	        data: {"th_level": th_level, "th_pid": th_pid, "c_id": cids[i]}, 
	        success: function (data) {
	        	if(JSON.stringify(data)!=='[]'){
	        		for(var i=0;i<data.length;i++){
	        			result.push(data[i]);
	        		}
	        		//result = data;
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

function getQuestionCon(qid, version){
	var res = '';
	$.ajax({
        url: "${pageContext.request.contextPath}/question/getQuestionCon",
        async: false,//改为同步方式
        type: "POST",
        data: { "q_id":qid, "version":version},
        success: function (data) {
    		res = data.content;
 		}
 	});	
	return res;
}

function getQuestionDetail(qid,mqid,version,ismain,iscon){
  if(typeof(mqid) == "undefined"){
    mqid = "";
   }
   openIframeDialog({
      url:"${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&version="+version+"&c_ids="+c_id+"&isMain="+ismain+"&iscon="+iscon +"&eid="+ei_id,
      fit:true,
      title:'查看试题'
    },0);
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
	}else if(time<60 && time >= 0){
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
	var $dlg = $('<div id="ifmdlg"><iframe scrolling="auto" style="width:100%;height:100%;" frameborder="0"></iframe></div>');
	var ret = $dlg.dialog(options);
	$dlg.find('iframe')[0].src=options.url;
	return ret;
}
</script>	

