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
	width:130px;
	border-color: #95B8E7;
	margin:0 2.2px;
}
.previewQuestion{
	text-decoration:none;
	color:black;
}
</style>
<div id="dlg-toolbar" >
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
	<tr>
		<td style="text-align: center">
			<h3 id="repeatTitle">《${courseInfo[0].name_c}》重复试题（仅查题目）</h3>
			<input type="hidden" id="cname" value="${courseInfo[0].name_c}" />
		</td>
	</tr>
	<tr style="text-align: left">
		<th>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="cancelEasyUiFrame(0);">关闭</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect();">删除选中的试题</a>
			<a id="selectSameBtn" href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="selectAllSameContentQuestion();">选中重复试题（仅查重题目）</a>
		</th>
	</tr>
</table>
<table style="border-collapse:collapse; padding:0; margin:0;">
	<tr>
		<td>
			<select id="sameType" name="sameType" class="qlimit" style="width: 180px;border-width: 1px;border-color: red;" onchange="questionFilter()">
				<option value="0">只查询题目重复的题*</option>
				<option value="1">查询题目答案都重复的题*</option>
			</select>
			<select id="theme1List" name="themeList" class="qlimit">
				<option value="">全部一级主题词</option>
				<c:forEach var="theme" items="${courseInfo[0].themeList}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach>
			</select>
			<select id="theme2List" name="theme2List" class="qlimit">
				<option value="">全部二级主题词</option>
			</select>
			<select id="theme3List" name="theme3List" class="qlimit">
				<option value="">全部三级主题词</option>
			</select>
			<select id="questionTypeList" name="questionTypeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部题型</option>
				<c:forEach var="questionType" items="${courseInfo[0].questionTypeList}">
					<option value="${questionType.QTID}">${questionType.QTNAME}</option>
				</c:forEach>
			</select>
			<select id="isVerified" name="isVerified"  class="qlimit" onchange="questionFilter()">
				<option value="">全部审核状态</option>
				<option value="0">未审核</option>
				<option value="1">已审核</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<input class="easyui-searchbox" data-options="prompt:'请输入查询内容',menu:'#mm',searcher:doSearch" style="width:326px;"/>
			<div id="mm">
				<div data-options="name:'question'">题目查询</div>
				<div data-options="name:'teacher'">题目录入者查询</div>
			</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="importQuestion"></div>
<script type="text/javascript">
var cid = $("#c_id").val();
$(document).ready(function(){
	var pageNumber = 1;
	var pageSize = 9999;
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/question/findRepeatQuestions',
		pagination: true,
		rownumbers: false,
		pageSize: pageSize,
		pageNumber:pageNumber,
		pageList:[9999],
		fitColumns: true,
		queryParams: {
			cid:cid
		},
		toolbar:'#dlg-toolbar',
		//remoteSort: false,
		//sortName: 'QID',
		
		columns:[[
			  {field:'qid',checkbox:true},
			  //{field:'QID',title:'ID',width:40,align:'left',sortable:true},
			  {field:'qtname',title:'题型',width:20,align:'left'},
		      {field:'content',title:'题目',width:80,align:'left',formatter:function(value,row,index){
		    	  let s = '<div class="qcontent" style="padding-bottom:100px;">';
		    	  s+= '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail('+row.qid+','+ row.mqid +',' + cid + ',' + row.ismain +',' + row.qtiscon + ')">'+row.content+'</a>';
		          s +='</div>';
		    	  return s;
	          }},
	          {field:'ANSWERCONTENT',title:'答案',width:80,align:'left',formatter:function(value,row,index){
	        	  return getAnswer(row.answerContent, row.trueAnswer, row.ismain);
	          }},
	          //{field:'soname',title:'题源',width:20,align:'left',sortable:true},
	          {field:'creator',title:'录入者',width:20,align:'left'},
	          {field:'answertime',title:'应答时间',width:20,align:'left',formatter:function(value,row,index){
	        	  return timeReversal(row.answertime);
	          }},
		      {field:'T1NAME',title:'主题词',width:70,align:'left',formatter:function(value,row,index){
		    	  var s = row.t1name;
		    	  if(row.t2name){
		    		  s += ' / ' + row.t2name;
		    	  }
		    	  if(row.t3name){
		    		  s += ' / ' + row.t3name;
		    	  }
		    	  return s;
	          }},
	          {field:'realdifficulty',title:'实测难度',width:20,align:'left'},
	          {field:'distinction',title:'区分度',width:20,align:'left'},
	          {field:'standardDeviation',title:'标准差',width:20,align:'left'},
	          {field:'num',title:'已考次数',width:20,align:'left'},
	          {field:'count',title:'应答人数',width:20,align:'left'},
	          //{field:'STATE',title:'状态',width:40,align:'left',sortable:true},
	          {field:'state',title:'状态',width:20,align:'left', formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1){
	        		  return '已审核';
	        	  }
	          }},
	          {field:'opration',title:'操作',width:40,align:'center',formatter:function(value,row,index){	          	
				 var s1 = '<a href="javascript:void(0);" class="viewQuestion easyui-tooltip" onclick="getQuestionDetail('+row.qid+','+ row.mqid+ ','  + cid + ',' + row.ismain +',' + row.qtiscon + ')" title="查看详情"></a>';
	        	 var s2 = '<a href="javascript:void(0);" class="editcls1 easyui-tooltip" onclick="gotoEditQuestion('+row.qid+','+ row.mqid+ ',' + cid + ',' + row.ismain +',' + row.qtiscon + ')" title="编辑试题"></a>';
				 var s4 = '<a href="javascript:void(0)" class="editcls3 easyui-tooltip" title="删除试题" onclick="del('+ row.qid +',' + row.ismain +  ',' + row.qtiscon + ')"></a>';
	        	 return s1 + s2 + s4;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewQuestion').linkbutton({text:'',iconCls:'icon-search',plain:true});
	    	$('.editcls1').linkbutton({text:'',iconCls:'icon-edit',plain:true});
	        $('.editcls2').linkbutton({text:'',iconCls:'icon-ok',plain:true});
	        $('.editcls3').linkbutton({text:'',iconCls:'icon-no',plain:true});
	        questionCount();
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	var err = '${err}';
	if(err!=""){
		toastr.warning(err);
	}
});

function uncheckAllCheckboxes() {
	const rows = $('#datalist').datagrid('getRows');
	rows.forEach((row, index) => {
		$('#datalist').datagrid('uncheckRow', index);
	});
}


function selectAllSameContentQuestion(){
	let tips = "该操作会勾选当前所有题目内容相同的数据（只保留1个不勾选的题目）以便删除，但答案相同的题请自行分辨。";
	if($('#sameType').val()==1){
		tips = "该操作会勾选当前所有题目+答案内容完全相同的数据（只保留1个不勾选的题目）以便删除。";
	}
	$.messager.defaults = { ok: "确认", cancel: "取消" };
	$.messager.confirm({
		width: '380',
		title: '勾选重复题目',
		msg: tips,
		fn: function (r) {
			if (r) {
				// 获取所有复选框行
				let checkboxes = $('#datalist').datagrid('getRows');
				// 记录已经处理过的 SAME_QUESTION_LABEL
				let processedLabels = new Set();
				// 遍历所有的行
				for (let i = 0; i < checkboxes.length; i++) {
					let row = checkboxes[i];
					let sameLabel = row.sameQuestionLabel;  // 获取当前题目的 SAME_QUESTION_LABEL
					// 如果该标签已经处理过，跳过该题
					if (processedLabels.has(sameLabel)) {
						continue;
					}
					// 将该标签加入已处理的集合
					processedLabels.add(sameLabel);

					// 标记当前组的所有题目
					let sameLabelRows = [];
					for (let j = 0; j < checkboxes.length; j++) {
						let otherRow = checkboxes[j];
						if (otherRow.sameQuestionLabel === sameLabel) {
							sameLabelRows.push(j);  // 将相同标签的行索引加入数组
						}
					}

					// 对于该组重复的题目，只取消勾选其中一个
					for (let k = 0; k < sameLabelRows.length; k++) {
						let index = sameLabelRows[k];
						if (k === 0) {
							// 只取消勾选第一个，其他的都勾选
							$('#datalist').datagrid('unselectRow', index);
						} else {
							// 勾选剩下的题目
							$('#datalist').datagrid('selectRow', index);
						}
					}
				}
			}
		}
	});
}

function getQuestionDetail(qid,mqid,cid,ismain,qtiscon){
	if(!mqid || typeof (mqid)===undefined ||mqid==="null"){
		mqid = '';
	}
	openIframeDialog({
		url:"${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon+"&pageNumber="+$('#datalist').datagrid('getPager').pagination('options').pageNumber+"&pagesize="+$('#datalist').datagrid('getPager').pagination('options').pageSize+"&repeat=1",
		fit:true,
		title:'查找重复试题'
	},0);
}

$('#theme1List').change(function(){
	getThemeList(2, $('#theme1List').val());
	var t3List = $('#theme3List');
	t3List.empty();
	t3List.append('<option value="">全部三级主题词</option>');
	questionFilter();
})

$('#theme2List').change(function(){
	getThemeList(3, $('#theme2List').val());
	questionFilter();
})

$('#theme3List').change(function(){
	questionFilter();
})

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
				openIframeDialog({
					url:"${pageContext.request.contextPath}/question/editQuestion?q_id="+qid+"&mqid="+mqid+"&c_id="+cid+"&isMain="+ismain+"&iscon="+qtiscon,
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

function questionFilter(){
	uncheckAllCheckboxes();
	if($('#sameType').val()==0){
		$('#selectSameBtn').find('.l-btn-text').text('选中重复试题（仅查重题目）');
		$('#repeatTitle').text('《'+$('#cname').val()+'》重复试题（仅查重题目）');
	}else{
		$('#selectSameBtn').find('.l-btn-text').text('选中重复试题（题目与答案同时相同）');
		$('#repeatTitle').text('《'+$('#cname').val()+'》重复试题（题目与答案同时相同）');
	}
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		cid : cid,
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	isVerified : $('#isVerified').val(),
		sameType : $('#sameType').val(),
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
        		str += '<option value="">全部一级主题词</option>'
        	}else if(th_level == 2){
        		str += '<option value="">全部二级主题词</option>'
        	}else if(th_level == 3){
        		str += '<option value="">全部三级主题词</option>'
        	}
			$.each(eval(data), function(i,item){
				str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
			});
			$(thStr).append(str);
 		}
 	});	
}

function viewQuestion(qid, mqid){
	if(mqid==null || mqid==undefined){
		mqid = null;
	}
	$.ajax({
        url: "${pageContext.request.contextPath}/question/getQuestionDetail",
        async: false,//改为同步方式
        type: "POST",
        data: { "q_id":qid, "mqid":mqid },
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
}

function doSearch(value,name){//通用查询框
	uncheckAllCheckboxes();
	if(name == 'question'){
		$('#datalist').datagrid('load',{
			cid : cid,
			question: value,
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(),
			sameType : $('#sameType').val(),
	    	qtid : $('#questionTypeList').val(),
	    	isVerified : $('#isVerified').val()
		});
	}else if(name == 'teacher'){
		$('#datalist').datagrid('load',{
			cid : cid,
			teacher: value,
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(),
			sameType : $('#sameType').val(),
	    	qtid : $('#questionTypeList').val(),
	    	isVerified : $('#isVerified').val()
		});
	}
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
          		$.messager.confirm({
					width: '380',
					title:"提示",
					msg:'是否要删除所选试题 ?',
					fn: function(r){
						if (r){
							$.ajax({
								url: "${pageContext.request.contextPath}/question/delQuestion",
								async: false,//改为同步方式
								type: "POST",
								data: { "q_id":qid ,"isMain":ismain,"iscon":iscon,"cid":cid},
								success: function (data) {
									toastr.success("删除成功");
									$('#datalist').datagrid('reload');
								}
							});
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

function delSelect(){
	let rows = $('#datalist').datagrid('getSelections');
	if(rows.length > 0){
		$.messager.confirm({
			width:'380',
			title:"提示",
			msg:'是否要删除所选试题 ?',
			fn:function(r){
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
					let data = {data:list,cid:cid};
					$.ajax({
						contentType: "application/json; charset=utf-8",
						url: "${pageContext.request.contextPath}/question/delSelectQuestion",
						async: false,
						type: "POST",
						data: JSON.stringify(data),
						success: function(rs){
							if(rs==="1"){
								$('.datagrid-header-check').find('checked',false);
								$('#datalist').datagrid('reload');
								toastr.success("删除成功！");
							}else if(rs==="0"){
								$('.datagrid-header-check').find('checked',false);
								toastr.warning("您没有批量删除试题的权限！");
							}else{
								$('.datagrid-header-check').find('checked',false);
								toastr.error("未知错误，删除失败！");
							}
						}
					})
				}
			}
		});
	}else{
		toastr.warning("你还没有选择题目！");
	}
}

function timeReversal(t){
	return t + '秒';
}

function getAnswer(acontent,trueAnswer,isMain){
	let rs;
	if(isMain==1){
		rs = "串题的子题答案请查看详情";
	}else if(!trueAnswer || typeof(trueAnswer)==="undefined" || trueAnswer.trim()==='' ){
		rs = "答案：" + acontent;
	}else {
		rs = acontent + "答案：" + trueAnswer;
	}
	return rs;
} 

function questionCount(){
	var count = $('#datalist').datagrid('getData');
	if(count.total==0){
		toastr.warning("没有重复试题");
	}
}

</script>	

