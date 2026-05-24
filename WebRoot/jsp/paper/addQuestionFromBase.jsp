<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
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
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>
<input type="hidden" name="aorb" id="aorb"  value="${aorb}"/>
<input type="hidden" name="bid" id="bid"  value="${bid}"/>

	<table style="width:100%;margin-top:10px;">
	<tr>
		<td><h1 style="color:red;text-align:center;width:100%;font-size:16px;">距离重新登录时间还有<span id="time" style="font-size:20px;"></span>，请在重新登录前保存要添加的题目</h1></td>
	</tr>
</table>
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="back()" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addQuestionIntoPaper()">添加到试卷</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="adjustPaper()">下一步：按题型调整分值时间</a>
			<select id="courseList" name="courseList" class="qlimit">
				<option value="${c_id}">全部课程</option>
				<c:forEach var="course" items="${courseList}">
					<option value="${course.id}">${course.name_c}</option>
				</c:forEach>
			</select>
			<select id="exampaperList" name="exampaperList" class="qlimit" onchange="questionFilter()">
			        <option value="">全部题目</option>
				    <option value="Select">已选中题目</option>			
					<option value="not_Select">未选中题目</option>			
			</select>
			<select id="theme1List" name="themeList" class="qlimit">
				<option value="">全部主题词一</option>
				<c:forEach var="theme" items="${courseInfo.themeList}">
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
				<c:forEach var="questionType" items="${courseInfo.questionTypeList}">
					<option value="${questionType.QTID}">${questionType.QTNAME}</option>
				</c:forEach>
			</select>
			<select id="cognitionList" name="cognitionList" class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>					
				<c:forEach var="cognition" items="${courseInfo.cognitionList}">
					<option value="${cognition.COID}">${cognition.CONAME}</option>
				</c:forEach>				
			</select>
			<select id="difficultyList" name="difficultyList" class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${courseInfo.difficultyList}">
					<option value="${difficulty.DID}">${difficulty.DNAME}</option>
				</c:forEach>
			</select>
			<select id="knowledgeList" name="knowledgeList" class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${courseInfo.knowledgeList}">
					<option value="${knowledge.KID}">${knowledge.KNAME}</option>
				</c:forEach>
			</select>								
		     </td>		   	
	</tr>
	<tr>
		<td>
			不选用<input type='text' id='forbidDay' name='forbidDay' value="${applicationScope.question_used_day}" style='width:50px'/>天之内考过的试题，不选用使用过<input type='text' id='forbidNum' name='forbidNum' value="${applicationScope.question_use_time}" style='width:50px'/>次及以上的试题，
			<select id="isVerified" name="isVerified"  class="qlimit" onchange="questionFilter()">
				<option value="0">全部</option>
				<option value="1">已审核</option>
				<option value="3">已终审</option>
			</select>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="questionFilter()">确定</a>
		查找从&nbsp;<input id="bdate" type="text" style="width:160px"/>&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px"/>&nbsp;的试题 <a href="javascript:void(0)" class="easyui-linkbutton" onclick="searchByDate()" data-options="iconCls:'icon-search'">查询</a>					
		</td>		  	
	</tr>
	<tr>
	  <td>
			<input id="real_name" data-options="prompt:'按录入者查询'" />
			<input id="qcontent_name"  data-options="prompt:'按试卷题干查询'" />
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>	
	 </td>	
	</tr>
</table>
</div>
<table id="datalist"></table>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script type="text/javascript">
var time = 1800;//设定倒计时半小时
var question_used_day=$("#forbidDay").val();
var question_use_time=$("#forbidNum").val();
setTime();
var cid = $("#c_id").val();
var ei_id = $("#ei_id").val();
var aorb=$("#aorb").val();
toastr.info("提示：从题库加题，试卷需要重新提交审核");
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getQuestionList',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		queryParams: {
			c_id: cid,
			ei_id: ei_id,
			bid:$("#bid").val()
		},
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
        checkOnSelect: true,
		columns:[[
			{field:'qid',checkbox:true},
			/*{field:'qid',checkbox:true,formatter:function(value,row,index){
				  if(row.existA !=undefined){
                      if(row.select=='1'&&row.existA=='1'){//在A卷且在B卷
                          var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer"  onclick="this.checked=!this.checked" name="qid" />';
                          return rs +"<br/><span style='color: red'>在A卷且在B卷</span>"+"<br/><span style='color: red'>不可选</span>";

                      }else if (row.select=='2'&&row.existA=='1'){//在A卷 不在B卷
                          var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          return rs+"<br/><span style='color: red'>在A卷</span>";

                      }else if (row.select=='1'&&row.existA=='2'){//不在A卷 在B卷
                          var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          return rs+"<br/><span style='color: red'>在B卷<br/>不可选</span>";

                      }else{
                          var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          return rs;
                      }
				  }else {
                      if(row.select=='1'){
                          var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer"  onclick="this.checked=!this.checked" name="qid" />';
                          return rs +"<br/><span style='color: red'>已在A卷</span>";
                      }else{
                          var rs = '<input type="checkbox" value="'+row.qid+row.ismain+'" class="allPer" name="qid" />'
                          return rs;
                      }
				  }
			  }},*/
			  {field:'qtname',title:'题型',width:40,align:'left',sortable:true,formatter:function(value,row,index){
				  var rs;
				  if(row.iscon==1){
					  rs=row.qtname + "<br/>(串题题干)";
				  }else{
					  rs=row.qtname;
				  }
				  if(aorb==0){
					  if(row.existA=='1'&&row.existB=='1'){//在A卷且在B卷
                          //rs+ = '<br/><input type="checkbox" value="'+row.qid+'" class="allPer"  onclick="this.checked=!this.checked" name="qid" />';
                          rs +="<br/><span style='color: red'>在A卷且在B卷</span>";

                      }else if (row.existA=='2'&&row.existB=='1'){//不在A卷 在B卷
                          //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          rs+="<br/><span style='color: red'>在B卷</span>";
                      }else if (row.existA=='1'){//在A卷
                          //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          rs+="<br/><span style='color: red'>在A卷</span>";
                      }
				  }else if(aorb==1){
					  if(row.existA=='1'&&row.existB=='1'){//在B卷且在A卷
                          //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer"  onclick="this.checked=!this.checked" name="qid" />';
                          rs +="<br/><span style='color: red'>在B卷且在A卷</span>";

                      }else if (row.existA=='2'&&row.existB=='1'){//在B卷 不在A卷
                          //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          rs+="<br/><span style='color: red'>在A卷</span>";

                      }else if (row.existA=='1'){//在A卷
                          //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
                          rs+="<br/><span style='color: red'>在B卷</span>";

                      }
				  }else {
					  if(row.existA=='1'&&row.existB=='1'&&row.existC=='1'){//在B卷且在A卷
						  //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer"  onclick="this.checked=!this.checked" name="qid" />';
						  rs +="<br/><span style='color: red'>存在在A/B/C卷</span>";

					  }else if (row.existA=='2'&&row.existB=='1'&&row.existC=='2'){//在B卷 不在A卷
						  //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
						  rs+="<br/><span style='color: red'>在A卷</span>";
					  }else if (row.existC=='1'){//在A卷
						  //var rs = '<input type="checkbox" value="'+row.qid+'" class="allPer" name="qid" />'
						  rs+="<br/><span style='color: red'>在C卷</span>";

					  }else if(row.existA=='2'&&row.existB=='2'&&row.existC=='1'){
						  rs+="<br/><span style='color: red'>在B卷</span>";
					  }
					  }
				  return rs;
				  
			  }},
		      {field:'content',title:'题目',width:120,align:'left',formatter:function(value,row,index){
		    	  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail(\''+row.qid+'\',\''+ row.mqid+ '\',\'' + row.ismain +'\',\'' + row.atid +'\',\'' + row.iscon + '\')"><div class="wrap">'+row.content+'</div></a>';
		    	  return s;
	          }},
	          {field:'answer',title:'答案(串题显示分支数目)',width:85,align:'left',formatter:function(value,row,index){
	        	  if(row.iscon==1){
	        		  //return printSubtopic(row.branch);
	        		  return row.branch.length+"个分支";
	        	  }else{
	        		  return printAnswer(row.answer,row.answerid);
	        	  }
	          }},
	          {field:'soname',title:'题源',width:20,align:'left',sortable:true},
	          {field:'coname',title:'认知分类',width:30,align:'left',sortable:true},
	          {field:'dname',title:'难度',width:20,align:'left',sortable:true},
	          {field:'kname',title:'知识点分布',width:35,align:'left',sortable:true},
	          {field:'answertime',title:'应答时间',width:30,align:'left',sortable:true},
		      {field:'t1name',title:'主题词',width:60,align:'left',formatter:function(value,row,index){
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
	          {field:'num',hidden:${openFindRepeatSystem ne 0},title:'已考次数',width:20,align:'left',sortable:true},
			  {field:'use_time',hidden:${openFindRepeatSystem eq 0},title:'已考次数<br >(三年内)',width:20,align:'left',formatter:function(value,row,index){
				  let useTimeNum = 0;
				  let prefix = '';
				  if(row.iscon==1){
					  prefix = '所有子题：</br>';
					  let branchCount = 0;
					  if(row.branch && row.branch.length){
						  for(let i=0;i<row.branch.length;i++){
							  branchCount += row.branch[i].use_time || 0;
						  }
					  }
					  useTimeNum = branchCount ;
				  }else{
					  useTimeNum = row.use_time || 0;
				  }
				  return prefix + '<a href="javascript:void(0)" onclick="getRepeatDetail('+ row.qid + ')">'+useTimeNum+'</a>';
			  }},
	          {field:'real_name',title:'录入者',width:20,align:'left'},
	          {field:'addtime',title:'录入时间',width:50,align:'center',sortable:true,formatter:function(value,row,index){
	        	  if(row.addtime==""||row.addtime==null){
	        	  	return "";
	        	  }else{
	        	  	 var dd = new Date(row.addtime).format('yyyy-MM-dd');
		        	 var ss = new Date(row.addtime).format('hh:mm:ss');
		        	 return dd + '<br/>' + ss;
	        	  }
	          }},
	          {field:'state',title:'状态',width:15,align:'center',formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1||row.state==3){
	        		  return '已审核';
	        	  }else if(row.state==-1){
	        		  return '不通过';
	        	  }
	          }}
	    ]],
	     onLoadSuccess:function(data){
	    	 for (var i = 0; i < data.rows.length; i++) {
                 if (data.rows[i].existA == "1") {
                	 $("input[type='checkbox']")[i+1].disabled=true;
                 }
             }
	    	 $(".datagrid-header-check").html("<input type='checkbox' id='selectAll'/>");
        	 $("#selectAll").change(function(){
        		 var status=$(this).is(":checked");
        		 $("input:checkbox[name=qid]").each(function(rowIndex,el){
        			 if(!$(this).is(":disabled")){
        				 if(status){
        					 $("#datalist").datagrid("selectRow",rowIndex);
        				 }else{
        					 $("#datalist").datagrid("unselectRow",rowIndex);
        				 }
        			 }else{
        				 $("#datalist").datagrid("unselectRow",rowIndex);
        			 }
        		 });
        		 if(status){
        			 $("#selectAll").prop("checked", true);
        		 }else{
        			 $("#selectAll").prop("checked", false);
        		 }
        	 });
	    	$('.viewQuestion').linkbutton({text:'详细',iconCls:'icon-search',plain:true});
	    	  var ds = data.rows;
              $.each(ds, function (i, v) {
                  if (v.select=='1') {                                 
                      $("input[type='checkbox']")[i].disabled = true;
                  } else {
                      $('#datalist').datagrid('uncheckRow', i);
                  }
              });
	    } ,
	    onSelect:function(rowIndex,rowData){
	    	if (rowData.existA == "1") {
	    		$("input:checkbox[name=qid]").eq(rowIndex).prop("checked", false);
	    		var status=$("#selectAll").is(":checked");
	    		if(status){
       			 $("#selectAll").prop("checked", true);
	       		 }else{
	       			 $("#selectAll").prop("checked", false);
	       		 }
            }
	    },
	    /*onClickRow : function(rowIndex, rowData) {
            //根据select值 单击单选行不可用
            if (rowData.existA == "1") {
                $(this).datagrid('unselectRow', rowIndex);
            }
            //以下为解决checkbox和选择行之间的bug代码
            var rows = $("#datalist").datagrid('getSelections');
            var tag = true;
            // 判断是否刚刚选中
            for(var i = 0;i<rows.length;i++){
                // 所有选中行中存在刚刚点击的行 则选中
                if($('#datalist').datagrid('getRowIndex', rows[i])==rowIndex){
                    $("input[type='checkbox']")[rowIndex].checked = true;
                    //选中此行
                    $('#datalist').datagrid('selectRow',rowIndex);
                    tag = false;
                    break;
                }
            }
            // 判断是否刚刚取消
            if(tag){
                $('#datalist').datagrid('unselectRow',rowIndex);
                $("input[type='checkbox']")[rowIndex].checked = false;
            }
        },  */
        onDblClickRow : function(rowIndex, rowData) {  
            //根据select值 双击单选行不可用
            if (rowData.existA == "1") {  
            	  $(this).datagrid('unselectRow', rowIndex);
            }
        }
	});
	
	var buttons =[];
	var bdate = $('#bdate').datebox();
	var edate = $('#edate').datebox();
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

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
		c_id : $('#courseList').val(),
		ei_id : $("#ei_id").val(),
		type : $('#exampaperList').val(),	
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(), 
    	did : $('#difficultyList').val(), 
    	kid : $('#knowledgeList').val(),
    	forbidNum : $("#forbidNum").val(),
    	forbidDay : $("#forbidDay").val(),
    	isVerified : $('#isVerified').val(), 
    	beginDate : $('#bdate').datebox("getValue"),
    	endDate : $('#edate').datebox("getValue"),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
	});
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

//添加到试卷
function addQuestionIntoPaper(){
	var res = [];
	var rows = $('#datalist').datagrid('getSelections');
    for(var i=0; i<rows.length; i++){
    	if(rows[i].existA!='1'){
    		res.push(rows[i].qid+'_'+rows[i].ismain);
    	}        
    }
    if(res.length>0){
    	$.ajax({
            url: "${pageContext.request.contextPath}/paper/addQuestionIntoPaper",
            async: true,//改为同步方式
            type: "POST",
            traditional: true,
            data: { "qids": uniqueArray(res), "c_id" : cid, "ei_id" : ei_id},
            beforeSend: function () {
                load();
            },
            success: function (data) {
            	if(data==""||data==null){
            		toastr.error("添加失败！");
                    disLoad();
            		return;
            	}
            	$.messager.defaults = { ok: "继续加题", cancel: "调整试卷分值与时间" };
            	$.messager.confirm({
    		    width: '380',
    		    title: '提示',
    		    msg: '已添加'+data+'题，请选择继续加题或调整试卷分值与时间。<br><font style="color:red;">如无需继续加题，请务必调整试卷分值与时间。</font>',
    		    fn: function (r) {
    		         if (r){
                         disLoad();
        		    	$('#datalist').datagrid('reload');

        		    }else{
        		    	adjustPaper();
        		    	//window.location.href = '${pageContext.request.contextPath}/paper/editApaper?c_id=' + cid + '&ei_id=' + ei_id;
        		    }
    		    }
    		});
    		$('.panel-tool-close').hide();
    			$("div.messager-button").find(".l-btn").each(function(index){
    				$(this).css("width","150px");
    			})
            }
    	});
    }else{
    	toastr.error("未选择任何试题！");
    }
}

//弹出加载层
function load() {
    $("<div class=\"datagrid-mask\"></div>").css({
        display: "block",
        width: "100%",
        height: $(window).height()
    }).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html("加题中，请稍候。。。").appendTo("body").css({
        display: "block",
        left: ($(document.body).outerWidth(true) - 190) / 2,
        top: ($(window).height() - 45) / 2,
        height: 50
    });
}
//取消加载层
function disLoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}

<%--function viewQuestion(qid, version, mqid){--%>
	<%--if(mqid==null || mqid==undefined){--%>
		<%--mqid = null;--%>
	<%--}--%>
	<%--$.ajax({--%>
        <%--url: "${pageContext.request.contextPath}/question/getQuestionDetail",--%>
        <%--async: false,//改为同步方式--%>
        <%--type: "POST",--%>
        <%--data: { "q_id":qid, "mqid":mqid },--%>
        <%--success: function (data) {--%>
        	<%--var str = '';--%>
			<%--answerList = data[0].answerList;--%>
			<%--if(answerList.length > 1){--%>
				<%--var index = 0;--%>
				<%--for(var i=0;i<answerList.length;i++){--%>
					<%--if(i==0){--%>
						<%--str += String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>';--%>
						<%--index = answerList[i].AID;--%>
					<%--}else{--%>
						<%--if(answerList[i].AID>index){--%>
							<%--str += String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>';--%>
						<%--}else{--%>
							<%--str = String.fromCharCode(i+65) + '，' + answerList[i].CONTENT + '</br>' + str;--%>
						<%--}--%>
						<%--index = answerList[i].AID;--%>
					<%--}--%>
				<%--}--%>
			<%--}else if(answerList.length == 1 && answerList[0] != null){--%>
				<%--str += answerList[0].CONTENT;--%>
			<%--}--%>
			<%--var res = data[0].content.content + '</br>' +  str;--%>
			<%--if(mqid!=null && mqid!=undefined){--%>
				<%--res = '<pre>' + data[1].content.content + '</pre>' + res;--%>
			<%--}--%>
			<%--$.messager.alert('试题详细',  res,'');--%>
			<%--return;--%>
 		<%--}--%>
 	<%--});	--%>
<%--}--%>

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
 		type : $('#exampaperList').val(),
 		ei_id : ei_id,
 		bid:$("#bid").val(),
 		th1id : $('#theme1List').val(), 
    	th2id : $('#theme2List').val(), 
    	th3id : $('#theme3List').val(), 
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(), 
    	did : $('#difficultyList').val(), 
    	kid : $('#knowledgeList').val(),
    	forbidNum : $("#forbidNum").val(),
    	forbidDay : $("#forbidDay").val(),
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
	var c = $('#courseList').val();
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

<%--function getQuestionCon(qid, version){--%>
	<%--var res = '';--%>
	<%--$.ajax({--%>
        <%--url: "${pageContext.request.contextPath}/question/getQuestionCon",--%>
        <%--async: false,//改为同步方式--%>
        <%--type: "POST",--%>
        <%--data: { "q_id":qid, "version":version},--%>
        <%--success: function (data) {--%>
    		<%--res = data.content;--%>
 		<%--}--%>
 	<%--});	--%>
	<%--return res;--%>
<%--}--%>

function getQuestionDetail(qid,mqid,ismain,atid,iscon){
  if(typeof(mqid) == "undefined"){
    mqid = "";
   }
   openIframeDialog({
      url:"${pageContext.request.contextPath}/question/previewQuestion?qid="+qid+"&mqid="+mqid+"&isMain="+ismain+"&iscon="+iscon +"&atid="+atid +"&eid="+ei_id,
      fit:true,
      title:'查看试题'
    },0);
}

function getRepeatDetail(qid) {
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/getRepeatDetail',
		type: "POST",
		data: {
			"eid": $('#ei_id').val(),
			"qid": qid,
			"fromPaper": 0
		},
		success: function (data) {
			let html = '';
			if (!data || data.length === 0) {
				html = '<div style="padding:20px;text-align:center;color:#666;">暂无重复题详情</div>';
			} else {
				html += '<div style="max-height:70vh;overflow-y:auto;text-align:left;padding-right:6px;">';
				for (let i = 0; i < data.length; i++) {
					const item = data[i];
					const origin = item.origin || {};
					const duplicate = item.duplicate || {};
					html += '<div style="border:1px solid #ddd;border-radius:6px;margin-bottom:14px;padding:12px;background:#fff;">';
					html += '<div style="font-weight:bold;margin-bottom:10px;color:#333;">最相似重复题</div>';
					html += '<div style="display:flex;gap:12px;align-items:stretch;">';
					html += '<div style="flex:1;border:1px solid #eee;border-radius:6px;padding:10px;background:#fafafa;">';
					html += '<div style="font-weight:bold;color:#1f6feb;margin-bottom:4px;">源题</div>';
					html += '<div style="font-size:12px;color:#666;margin-bottom:8px;">';
					html += 'eid：' + origin.eid + '　qid：' + origin.qid;
					html += '</div>';
					html += '<div style="font-size:16px;line-height:1.6;white-space: pre-wrap;">';
					html += origin.contentRaw || '';
					html += '</div>';
					html += '</div>';
					html += '<div style="flex:1;border:1px solid #eee;border-radius:6px;padding:10px;background:#fafafa;">';
					html += '<div style="font-weight:bold;color:#d97706;margin-bottom:4px;">重复题</div>';
					html += '<div style="font-size:12px;color:#666;margin-bottom:8px;">';
					html += 'eid：' + duplicate.eid + '　qid：' + duplicate.qid;
					html += '</div>';
					html += '<div style="font-size:16px;line-height:1.6;white-space: pre-wrap;">';
					html += duplicate.contentRaw || '';
					html += '</div>';
					html += '</div>';

					html += '</div>';
					html += '</div>';
				}
				html += '</div>';
			}
			Swal.fire({
				title: '重复题详情',
				html: html,
				width: 1100,
				confirmButtonText: '关闭'
			});
		}
	});
}

function printAnswer(rs,aid){
	var p = '';//选择题ABCDE
	var out = '';
	var aid;
	if(typeof(aid)=='undefined'||aid==null){
		aid = '';
	}else{
		aid = aid.split(",");
	}
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

function reload(){
	$('#datalist').datagrid('reload');
}

function adjustPaper(){
	window.location.href = '${pageContext.request.contextPath}/paper/adjustPaper?c_id=' + cid + '&ei_id=' + ei_id;
}

function back(){
    $.ajax({
        url: "${pageContext.request.contextPath}/paper/checkScore",
        async: false,
        type: "POST",
        data: { "eid":ei_id},
        success: function (data) {
            if(data=="false"){
                toastr.error("系统检测到试卷还有试题未赋分！");
            }else{
                window.history.go(-1);
            }
        }
    });
    return false;
}


$('#qcontent_name').searchbox({
	searcher:function(value,name){		
		$('#datalist').datagrid('load',{
			c_id: cid,
			ei_id: ei_id,			
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(), 
	    	qtid : $('#questionTypeList').val(),
	    	coid : $('#cognitionList').val(), 
	    	did : $('#difficultyList').val(), 
	    	kid : $('#knowledgeList').val(),
	    	isVerified : $('#isVerified').val(),
	    	real_name : $('#real_name').searchbox('getValue'),
	    	question: value,
	    	state : '0',
	    	mobile: '0'
		})
	}	
})

$('#real_name').searchbox({
	searcher:function(value,name){		
		$('#datalist').datagrid('load',{
			c_id: cid,
			ei_id: ei_id,			
	 		th1id : $('#theme1List').val(), 
	    	th2id : $('#theme2List').val(), 
	    	th3id : $('#theme3List').val(), 
	    	qtid : $('#questionTypeList').val(),
	    	coid : $('#cognitionList').val(), 
	    	did : $('#difficultyList').val(), 
	    	kid : $('#knowledgeList').val(),
	    	isVerified : $('#isVerified').val(),
	    	question : $('#qcontent_name').searchbox('getValue'),
	    	real_name: value,
	    	state : '0',
	    	mobile: '0'
		})
	}	
})

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

</script>	

