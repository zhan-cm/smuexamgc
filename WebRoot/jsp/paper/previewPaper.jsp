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
	margin:0 2.2px;
}
.buttons{
	color:black;
	text-decoration:none;
	width:35px;
	heigth:30px;
	margin:0 auto;
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
<div id="dlg-toolbar" style="height:auto;">
<input type="hidden" id="mobile" value="${mobile}"/>
<input type="hidden" id="ei_id" name="ei_id" value="${ei_id}"/>
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<input type="hidden" id="isB" name="isB" value="${isB }"/>
<input type="hidden" id="readonly" name="readonly" value="${readonly }"/>
<input type="hidden" id="restart" name="restart" value="${restart }"/>
<input type="hidden" id="firstVerify" name="firstVerify" value="${firstVerify}"/>
<input type="hidden" id="edit" value="${edit}">
<input type="hidden" id="multi" value="${multi}">
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0; margin: 5px;">
	<tr>
		<th style="text-align:center;font-size: 20px;margin: 5px;">试卷： ${ename} （
		<c:choose>
				<c:when test="${aorb==0 }">
					A
				</c:when>
				<c:when test="${aorb==1}">
					B
				</c:when>
			</c:choose>
		卷）（试卷编号：${ei_id}）</th>
	</tr>
</table>
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="back()" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" id="back-btn">返回</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="reloads()">刷新</a>
			<c:if test="${assembly=='y' && mobile != 1  && mobile!= 3}">
				<a href="javascript:void(0)" onclick="next()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">保存试卷</a>
			</c:if>
			<c:if test="${assembly=='y' && (mobile == 1 or mobile ==3)}">
				<a href="javascript:void(0)" onclick="nextmobile()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">保存试卷</a>
			</c:if>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_go',plain:true" onclick="exportPaperQuestion()">导出试题到excel</a>&nbsp;&nbsp;
			<c:if test="${isAdmin=='y'||readonly=='0' }">
				<a href="${pageContext.request.contextPath}/paper/addQuestionFromBase?c_id=${c_id}&ei_id=${ei_id}" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" >从题库加题</a>&nbsp;&nbsp;
				<a href="${pageContext.request.contextPath}/paper/addQuestionFromPaper?cid=${c_id}&eid=${ei_id}" class="easyui-linkbutton" data-options="iconCls:'icon-book_add',plain:true">从已有试卷加题</a>&nbsp;&nbsp;
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_go',plain:true" onclick="exportSelectQuestion()">导出所选试题到excel</a>&nbsp;&nbsp;
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-package_in',plain:true" onclick="importQuestionToPaper()">从excel导入试题</a>&nbsp;&nbsp;
				<a href="${pageContext.request.contextPath}/paper/addWj?c_id=${c_id}&ei_id=${ei_id}" class="easyui-linkbutton" data-options="iconCls:'icon-book_add',plain:true">添加问卷调查</a>&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="adjustPaper('${c_id}','1')" class="easyui-linkbutton" data-options="iconCls:'icon-book_edit',plain:true" >按题型调整顺序分值时间</a>&nbsp;&nbsp;
				<a href="javascript:void(0);" onclick="score('${c_id}')" class="easyui-linkbutton" data-options="iconCls:'icon-book_addresses_edit',plain:true" >逐题赋分赋时</a>&nbsp;&nbsp;
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-book_tabs',plain:true" onclick="toFindRepeatQuestions();">查找重复试题</a>
				<c:if test="${mobile != 1 }">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-arrow_undo',plain:true" onclick="rebuild('${c_id}')">重新组卷</a>&nbsp;&nbsp;
				</c:if>
			</c:if>
			<a href="javascript:void(0);" onclick="questionTypeExplain()" class="easyui-linkbutton" data-options="iconCls:'icon-book_open',plain:true" >题型说明</a>&nbsp;&nbsp;
			<a href="javascript:void(0);" onclick="checkList('${c_id}');" class="easyui-linkbutton" data-options="iconCls:'icon-asterisk_orange',plain:true" >双向细目表</a>&nbsp;&nbsp;
			<a href="javascript:void(0);" onclick="forecastPaper('${c_id}')" class="easyui-linkbutton" data-options="iconCls:'icon-asterisk_red',plain:true" >预测分析</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-asterisk_yellow',plain:true" onclick="seePaper()">预览试卷</a>&nbsp;&nbsp;

			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-bookmark',plain:true" onclick="viewExamInfo('${c_id}')">查看考务信息</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-bookmark_edit',plain:true" onclick="inEditExamInfo('${c_id}','${way}')">编辑考务信息</a>&nbsp;&nbsp;

			<c:if test="${mobile != 1 }">
			<c:choose>
				<c:when test="${aorb==0 && empty bid}">
					<c:if test="${isAdmin=='y'||readonly=='0' }">
						<a onclick="generateBpaper('${pageContext.request.contextPath}/paper/generateBpaper?aid=${ei_id}&cid=${c_id}')" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-bookmark_add',plain:true">生成B卷</a>&nbsp;&nbsp;
					</c:if>
				</c:when>
				<c:when test="${aorb==0 && not empty bid}">
					<a href="${pageContext.request.contextPath}/paper/editBpaper?c_id=${c_id}&ei_id=${bid}&readonly=${readonly}" class="easyui-linkbutton" data-options="iconCls:'icon-bookmark',plain:true">查看B卷</a>&nbsp;&nbsp;
				</c:when>
				<c:when test="${aorb==1 && not empty bid}">
					<a href="${pageContext.request.contextPath}/paper/editApaper?c_id=${c_id}&ei_id=${bid}&readonly=${readonly}" class="easyui-linkbutton" data-options="iconCls:'icon-book',plain:true">查看A卷</a>&nbsp;&nbsp;
				</c:when>
			</c:choose>
			</c:if>
			<a href="javascript:void(0)" onclick="appoint('${c_id}','${ename}')" class="easyui-linkbutton" data-options="iconCls:'icon-book_key',plain:true">试卷权限设定</a>
			<a href="javascript:void(0);" onclick="adjustQuestionOrder('${c_id}')" class="easyui-linkbutton" data-options="iconCls:'icon-book_edit',plain:true" >调整试题顺序</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-computer_edit',plain:true" onclick="testPaper()">模拟测试</a>
			<c:if test="${isAdmin=='y'||readonly=='0' }">
				<a href="javascript:void(0)" class= "easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect();">删除选中的试题</a>
			</c:if>
		</td>
	</tr>
</table>
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td>
			<c:choose>
				<c:when test="${multi==1 }">
					<select id="courseList" name="courseList" class="qlimit">
						<option value="">全部课程</option>
						<c:forEach var="course" items="${courseList}">
							<option value="${course.ID}">${course.CNAME}</option>
						</c:forEach>
					</select>
					<select id="theme1List" name="themeList" class="qlimit">
						<option value="">全部主题词一</option>
					</select>
				</c:when>
				<c:otherwise>
					<select id="theme1List" name="themeList" class="qlimit">
						<option value="">全部主题词一</option>
						<c:forEach var="theme" items="${themeList}">
							<option value="${theme.ID}">${theme.NAME}</option>
						</c:forEach>
					</select>
				</c:otherwise>
			</c:choose>

			<select id="theme2List" name="theme2List" class="qlimit">
				<option value="">全部主题词二</option>
			</select>
			<select id="theme3List" name="theme3List" class="qlimit">
				<option value="">全部主题词三</option>
			</select>
			<select id="questionTypeList" name="questionTypeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部题型</option>
				<c:forEach var="questionType" items="${questionTypeList}">
					<option value="${questionType.QTID}">${questionType.QTNAME}</option>
				</c:forEach>
			</select>
			<select id="cognitionList" name="cognitionList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>
				<c:forEach var="cognition" items="${cognitionList}">
					<option value="${cognition.COID}">${cognition.CONAME}</option>
				</c:forEach>
			</select>
			<select id="difficultyList" name="difficultyList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${difficultyList}">
					<option value="${difficulty.DID}">${difficulty.DNAME}</option>
				</c:forEach>
			</select>
			<select id="knowledgeList" name="knowledgeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${knowledgeList}">
					<option value="${knowledge.KID}">${knowledge.KNAME}</option>
				</c:forEach>
			</select>
			<span style="margin-top:5px!important;">
				<input class="easyui-searchbox" id="qcontent" data-options="prompt:'请输入题干内容',searcher:doSearch" style="width:150px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			</span>
		</td>
	</tr>
	<tr>
		<td>
			<c:if test="${openFindRepeatSystem eq 0}">
				<input class="easyui-numberbox" id="rangeMin"
					   data-options="min:0,precision:0,prompt:'已考次数最小值'"
					   style="width:120px;"/> -
				<input class="easyui-numberbox" id="rangeMax"
					   data-options="min:0,precision:0,prompt:'已考次数最大值'"
					   style="width:120px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton"
				   data-options="iconCls:'icon-search',plain:true"
				   onclick="doSearch()">查询</a>
			</c:if>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-book_open_mark',plain:true" onclick="searchIllegalQuestion()"><span id="illegalQuestionTips">显示存在重复选项的试题</span></a>
		</td>
	</tr>
</table>
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0; margin: 5px;">
	<tr>
		<td style="color:red;font-size:18px;">
		 	本试卷总分值：<span id="sum" style="font-size:18px">0</span>分，共<span id="total" style="font-size:18px">0</span>题，答题时间和：<span id="time" style="font-size:18px">0秒</span><span id="timesec" style="font-size:18px"></span><span id="alertspan" style="font-size:18px"></span>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="importDetail" style="display:none"></div>
<div id="importQuestionToPaper"></div>
<div id="exportPaperQuestion"></div>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script type="text/javascript">
var ei_id = $("#ei_id").val();
var c_id = $("#c_id").val();
var isB = $("#isB").val();
var edit = $('#edit').val();
var multi=$("#multi").val();
var cid_query="";
var totaltime = 0;
$(document).ready(function(){
	var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;
	if(title == '生成新的形成性评价'){
		$("#back-btn").css("display","none");
	}
	getTotalAndSum();
	getTotalTime();
	getExamModAndTime();
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getExampaperQuestionList?ei_id=' + ei_id + '&c_id=' + c_id,
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'qid',checkbox:true},
			  //{field:'orderNums',title:'序号',width:20,align:'center'},
			  {field:'th',title:'题号',width:20,align:'center',formatter:function(value,row,index){
			  	  var ismain=row.ismain;
			  	if(ismain==0){
			  		return row.th;
			  	}
			  }},
			  {field:'content',title:'题目',width:145,align:'left',formatter:function(value,row,index){
		    	  var content=row.content;
		    	  if(content==null){
		    	      content="";
				  }
			      var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail(\''+row.qid+'\',\''+ row.mqid+ '\',\'' + row.ismain +'\',\'' + row.iscon + '\',\'' + edit + '\',\'' + row.atid + '\')"><div class="wrap">'+content+'</div></a>';
		    	  return s;
	          }},
	          {field:'answer',title:'答案',width:120,align:'left',formatter:function(value,row,index){
	          	    var ismain=row.ismain;
				  	if(ismain==1){
				  		return "串题题干<br/>（删除题干，整串删除）";
				  	}else{
						if(row.atid == 13){
							var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail('+row.qid+','+ row.mqid+',' + row.ismain +',' + row.iscon +',' + edit + ',' + row.atid +')">' +
									'<div class="wrap">代码答案请点击查看</div></a>';
							return s;
						}
				  		return printAnswer(row.answer,row.answerid);
				  	}
	          }},
			  {field:'qtname',title:'题型',width:20,align:'left',sortable:false,formatter:function(value,row,index){
			  	var ismain=row.ismain;
			  	if(ismain==1){
			  		return row.qtname+"<br/>"+"（主题干）";
			  	}else{
			  		return row.qtname;
			  	}

			  }},
			  {field:'cname',title:'所属课程',width:25,align:'left',sortable:false},
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
	          {field:'dname',title:'难度',width:20,align:'left',sortable:false},
	          {field:'realdifficulty',title:'实测难度',width:25,align:'left',sortable:false,formatter:function(value,row,index){
	        	  var num = row.realdifficulty;
	        	  return num.toFixed(2);
	          }},
	          {field:'distinction',title:'区分度',width:20,align:'left',sortable:false,formatter:function(value,row,index){
	        	  var num = row.distinction;
	        	  return num.toFixed(2);
	          }},
	          {field:'num',hidden:${openFindRepeatSystem ne 0},title:'已考次数',width:25,align:'left',sortable:false},
			{field:'use_time', hidden:${openFindRepeatSystem eq 0}, title:'已考次数<br >(三年内)',width:25,align:'left',formatter:function(value,row,index){
				return '<a href="javascript:void(0)" onclick="getRepeatDetail('+ row.qid + ')">'+row.use_time+'</a>';
			}},
	          {field:'time',title:'用时',width:25,align:'left',formatter:function(value,row,index){
	        	  return row.time + "秒";
	          }},
	          {field:'SCORE',title:'分值',width:25,align:'left',sortable:false},
	          /*{field:'soname',title:'题源',width:20,align:'left',sortable:true},
	          {field:'coname',title:'认知分类',width:25,align:'left',sortable:false},
	          {field:'kname',title:'知识点分布',width:25,align:'left',sortable:false},
	          {field:'standardDeviation',title:'标准差',width:20,align:'left',sortable:false,formatter:function(value,row,index){
	        	  var num = row.standardDeviation;
	        	  return num.toFixed(2);
	          }},
	          {field:'state',title:'状态',width:30,align:'left',formatter:function(value,row,index){
	        	  if(row.state==0){
	        		  return '未审核';
	        	  }else if(row.state==1){
	        		  return '已审核';
	        	  }
	          }},*/
	          {field:'opration',title:'操作',width:50,align:'center',formatter:function(value,row,index){
	        	  var s1 = '<a href="javascript:void(0);" class="buttons" onclick="getQuestionDetail(\''+row.qid+'\',\''+ row.mqid+ '\',\'' + row.ismain +'\',\'' + row.iscon + '\',\'' + edit + '\',\'' + row.atid + '\')">查看</a>&nbsp;&nbsp;&nbsp;&nbsp;';
	        	  var s2 = '<a href="javascript:void(0);" class="buttons" onclick="gotoEditQuestion('+row.qid+','+ row.mqid+ ','  + row.ismain +',' + row.iscon + ')">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;';
	        	  /*if(edit==''){
	        		  s2 = '<a href="javascript:void(0);" class="buttons" onclick="gotoEditQuestion('+row.qid+','+ row.mqid+ ',' + row.version +',' + row.ismain +',' + row.iscon + ')">编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;';
	        	  }*/
	        	  var s3 = '';
	        	  if($("#readonly").val()=='0'||$("#readonly").val()==''||$("#readonly").val==null){
	        	  	s3 = '<a href="javascript:void(0)" class="buttons" onclick="del('+ row.qid + ',' + row.mqid + ')">删除</a>';
	        	  }
	        	  return s1 +s2 + s3 ;
	          }}
	    ]],
		onLoadSuccess:function(data){
			let p = $('#datalist').datagrid('getPager');
			let pageNum = $(p).pagination('options').pageNumber;
			let pageSize = $(p).pagination('options').pageSize;
			let showNowPageNum = Math.min(pageNum*pageSize, data.total);
			let paginationStr = "显示"+(1+(pageNum-1)*pageSize)+"到"+showNowPageNum+"，共"+
					data.total+"数据";
			if(parseInt(data.total) !== parseInt(data.excludeIsmainTotal)){
				paginationStr += "（去掉串题题干共"+data.excludeIsmainTotal+"题）";
			}
			$(".pagination-info").text(paginationStr);
		},
	});

	if(multi==0){
		$('#datalist').datagrid('hideColumn', 'cname');
	}
	var buttons =[];
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
});

function getTotalAndSum(){
	$.ajax({
		url:'${pageContext.request.contextPath}/paper/getTitleTotalAndSum',
		type:'POST',
		data:{"ei_id":ei_id},
		success:function(data){
			var sum = 0;
			if(data.sum!='null'){
				sum = data.sum;
			}
			$('#sum').html(sum);
			$('#total').html(data.total);
		}
	})
}

//获得所有试题总时长
function getTotalTime(){
	var eid = $('#ei_id').val();
	var rs = $('#time');
	$.ajax({
		url:"${pageContext.request.contextPath}/paper/getQuestionTotalTime",
		async:false,
		type:"POST",
		data: {"eid":eid },
		success: function(data){
			data = data.replace(/\[|]/g,'');
			if(data=='null'){
				data = 0;
			}
			data = parseInt(data);
			totaltime = data;
			var second = data;
			var min = 0;
			var hour = 0;
			if(second > 60){
				min = parseInt(second/60);
				second = parseInt(second%60);
				/* if(min > 60){
					hour = parseInt(min/60);
					min = parseInt(min%60);
				} */
			}
			var rt = '';
			/* if(hour > 0){
				rt += hour + "小时";
			} */
			if(min > 0){
				rt += min + "分";
			}
			rt += second + "秒";
			rs.html(rt);
		}
	})
}

function getExamModAndTime(){
	var eid = $('#ei_id').val();
	$.ajax({
		url:"${pageContext.request.contextPath}/paper/getExamModAndTime",
		async:false,
		type:"POST",
		data: {"eid":eid },
		success: function(data){
				var timesec = parseInt(data.timesec);
				var second = timesec;
				var min = 0;
				var hour = 0;
				if(second > 60){
					min = parseInt(second/60);
					second = parseInt(second%60);
				}
				var rt = '';

				if(min > 0){
					rt += min + "分";
				}
				rt += second + "秒";
				if(data.testtimeset=="0" || data.testtimeset=="3"){
					if(timesec<totaltime){
						$("#timesec").html("，考试用时："+rt);
						$("#alertspan").html("该考试方式下已超时，请注意调整");
					}else{
						$("#timesec").empty();
						$("#alertspan").empty();
					}
				}else{
					$("#timesec").empty();
					$("#alertspan").empty();
				}
		}
	});
}

function refresh(){
	$('#datalist').datagrid('reload');
}

function del(qid, mqid){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	}
	$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){
	    if (r){
	    	$.ajax({
	            url: "${pageContext.request.contextPath}/paper/delQuestion",
	            async: false,//改为同步方式
	            type: "POST",
	            data: { "q_id":qid, "ei_id":ei_id, "mqid": mqid},
	            success: function (data) {
	            	//alert(data);
	        		$('#datalist').datagrid('reload');
	        		getTotalAndSum();
	        		getTotalTime();
	        		getExamModAndTime();
	     		}
	     	});
	    }
	});
}

function delSelect(){
	var rows = $('#datalist').datagrid('getSelections');
	if(rows.length > 0){
		$.messager.confirm("提示",'是否要删除所选试题 ?',function(r){
			if(r){
				var list = [];
				for(var i=0;i<rows.length;i++){
					var param = {};
					param["eid"] = ei_id;
					param["qid"] = rows[i].qid;
					param["mqid"] = rows[i].mqid;
					list.push(param);
				}
				if(list.length > 0){
					var data = {data:list};
					$.ajax({
						contentType: "application/json; charset=utf-8",
						url: "${pageContext.request.contextPath}/paper/delSelectQuestion",
						async: false,
						type: "POST",
						data: JSON.stringify(data),
						success: function(rs){
							$('.datagrid-header-check').find('checked',false);
							$('#datalist').datagrid('reload');
							getTotalAndSum();
							getTotalTime();
							getExamModAndTime();
							toastr.success("删除成功！");
						}
					})
				}
			}
		});
	}else{
		toastr.warning("你还没有选择题目！");
	}
}

$('#courseList').change(function(){
	var result = '';
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/getThemeList",
        async: false,
        type: "POST",
        data: {"cid": $('#courseList').val(), "eid": ei_id},
        success: function (data) {
        	if(JSON.stringify(data)!=='[]'){
        		var thStr = '#theme1List';
				$(thStr).html(null);
				var str = '';
				str += '<option value="">全部主题词一</option>'
				if(data!=''){
					$.each(eval(data),function(i,item){
						str += '<option value="' + item.ID + '">' + item.NAME + '</option>'
					});
				}
				$(thStr).append(str);
        	}
 		}
 	});

	cid_query=$('#courseList').val();
	questionFilter();
})

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

function doSearch(value,name){
	let a  = $('#rangeMin').numberbox('getValue');
	let b  = $('#rangeMax').numberbox('getValue');
	a = (a === '' ? null : parseInt(a, 10));
	b = (b === '' ? null : parseInt(b, 10));
	if (a != null && a < 0) { $.messager.alert('提示','最小值必须是非负整数'); return; }
	if (b != null && b < 0) { $.messager.alert('提示','最大值必须是非负整数'); return; }
	if (a != null && b != null && a > b) { // 自动交换，省得用户重输
		let t = a; a = b; b = t;
	}
	$('#datalist').datagrid('load',{
		question: value,
		cid : cid_query,
 		ei_id : ei_id,
 		th1id : $('#theme1List').val(),
    	th2id : $('#theme2List').val(),
    	th3id : $('#theme3List').val(),
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(),
    	did : $('#difficultyList').val(),
    	kid : $('#knowledgeList').val(),
		testNumMin : a,
		testNumMax : b
	});
}

function questionFilter(){
	var p = $('#datalist').datagrid('getPager');
	//console.log($('#theme1List').val());
 	$('#datalist').datagrid('reload', {
 		cid : cid_query,
 		ei_id : ei_id,
 		th1id : $('#theme1List').val(),
    	th2id : $('#theme2List').val(),
    	th3id : $('#theme3List').val(),
    	qtid : $('#questionTypeList').val(),
    	coid : $('#cognitionList').val(),
    	did : $('#difficultyList').val(),
    	kid : $('#knowledgeList').val(),
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
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
			ei_id : ei_id,
			illegalAnswer : "illegalAnswer",
			page : $(p).pagination('options').pageNumber,
			rows : $(p).pagination('options').pageSize
		});
	}else {
		$("#illegalQuestionTips").text("显示存在重复选项的试题");
		$('#datalist').datagrid('reload', {
			ei_id : ei_id,
			page : $(p).pagination('options').pageNumber,
			rows : $(p).pagination('options').pageSize
		});
	}
}

function getThemeList(th_level, th_pid){
	var result = '';
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/getThemeList",
        async: false,
        type: "POST",
        data: {"th_level": th_level, "th_pid": th_pid,"eid":ei_id},
        success: function (data) {
        	if(JSON.stringify(data)!=='[]'){
        		result = data;
        	}
 		}
 	});
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

function score(){
	var url = '${pageContext.request.contextPath}/paper/score?c_id=' + c_id + '&ei_id=' + ei_id;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '逐题赋分',
		content: content,
		closable: true
	});
}

function seePaper(){
	/*
	openIframeDialog({
		url:'${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + $('#ei_id').val(),
		fit:true,
		title:'预览试卷'
	},0);*/
	var url = '${pageContext.request.contextPath}/viewPaper/seePaper?eid=' + $('#ei_id').val();
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '预览试卷',
		content: content,
		closable: true
	});
}


function rebuild(cid){
    save(cid,$('#ei_id').val());
	$.messager.confirm("提示",'重新组卷将删除此试卷原所有的试题和考生的作答记录，确定继续 ?',function(r){
	    if (r){
	    	//updateSelectTab();
	    	window.location.href='${pageContext.request.contextPath}/paper/rebuild?c_id=' + cid + '&ei_id=' + $('#ei_id').val() +'&buildWay=' +1;
	    }
	});
}

function save(cid){
    //var eid = $("#eid").val();
    //var cid = $("#cid").val();
    var name = $('#ei_id').val();//双向细目表模板名称
    $.ajax({
        url: "${pageContext.request.contextPath}/paper/saveCheckList",
        type: "POST",
        data: {"cid":cid,"name":name,"eid":$('#ei_id').val()},
        success: function(data){

            //$("#win").window('close');
            if(data > 0){
                toastr.success('正在重新组卷');
            }/*else if(data == 0){
                toastr.error('此试卷没有试题，无法保存双向细目表模板');
                $("#win").window('close');
            }else if(data == -1){
                toastr.warning("模板名称已存在");
            }else{
                toastr.error("保存失败");
                $("#win").window('close');
            }*/
        }
    })
}

/* function checkList(){
	var url = '${pageContext.request.contextPath}/paper/checkList?c_id=' + c_id + '&ei_id=' + ei_id;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '双向细目表',
		content: content,
		closable: true
	});
} */


function editExamInfo(){
	var url = '${pageContext.request.contextPath}/paper/inEditExamInfo?c_id=' + c_id + '&ei_id=' + ei_id;
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: '编辑考务信息',
		content: content,
		closable: true
	});
}

function getQuestionDetail(qid,mqid,ismain,iscon,edit,atid){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	 }
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/previewQuestion?qid="+qid+"&mqid="+mqid+"&isMain="+ismain+"&iscon="+iscon +"&eid="+ei_id+"&isB="+isB+"&edit="+edit+"&atid="+atid,
		fit:true,
		title:'查看试题'
	},0);

}

function gotoEditQuestion(qid,mqid,ismain,iscon){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	}
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/editQuestion?q_id="+qid+"&mqid="+mqid+"&c_ids="+c_id+"&isMain="+ismain+"&iscon="+iscon +"&eid="+ei_id+"&isB="+isB,
		fit:true,
		title:'编辑试题'
	},1);

}

function inEditExamInfo(cid,way){
	var mobile = $("#mobile").val();
	var url = '';
	//console.log(way);
	if(way=='monitor'){
		url = "${pageContext.request.contextPath}/verify/inEditExamInfo?cid=" + cid + "&eid=" + $('#ei_id').val();
	}else{
		url = "${pageContext.request.contextPath}/paper/inEditExamInfo?cid="+cid+"&eid="+$('#ei_id').val();
	}

	if(mobile == 1){
		url = "${pageContext.request.contextPath}/evaluationverify/inEditExamInfo?cid="+cid+"&eid="+$('#ei_id').val();
	}
	//console.log(url);
	/*
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title:'编辑考务信息',
		content: content,
		closable: true
	});*/
	openIframeDialog({
		url:url,
		fit:true,
		title:'编辑考务信息'
	},0);
}

function viewExamInfo(cid){
	var mobile = $("#mobile").val();
	var url = '';
	url = "${pageContext.request.contextPath}/paper/viewExamInfo?cid="+cid+"&eid="+$('#ei_id').val();
	if(mobile == 1){
		url = "${pageContext.request.contextPath}/evaluationverify/viewExamInfo?cid="+cid+"&eid="+$('#ei_id').val();
	}
	/*
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$("#nav_tab").tabs('add',{
		title:'查看考务信息',
		content: content,
		closable: true
	});*/
	openIframeDialog({
		url:url,
		fit:true,
		title:'查看考务信息'
	},0);
}

function checkList(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/checkList?c_id=" + cid + "&ei_id=" + $('#ei_id').val(),
		fit:true,
		title:'双向细目表'
	},0);
}

function testPaper(){
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/getPaperNoScore',
		async: false,
		type: "POST",
		data: {"eid":$('#ei_id').val()},
		success:function(data){
			if(data==0){
				window.open("${pageContext.request.contextPath}/paper/testPaper?eid="+$('#ei_id').val(),'fullscreen=1');
			}else{
				toastr.warning(data);
			}
		}
	})
}

function appoint(cid,ename){
	var params = {};
	params["eid"] = $('#ei_id').val();
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission2',
          async: false,
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          	/*
          		var url = "${pageContext.request.contextPath}/verify/appoint?cid=" + cid + "&eid=" + $('#ei_id').val()+ "&ename=" + ename+ "&tid=" + tid;
				var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
				window.parent.$('#nav_tab').tabs('add',{
					title: '试卷权限设置',
					content: content,
					closable: true
				});*/
				openIframeDialog({
					url:"${pageContext.request.contextPath}/verify/appoint?cid="+cid+"&mobile="+$("#mobile").val()+"&eid="+$('#ei_id').val()+"&ename="+ename,
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

function forecastPaper(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/forecastPaper?c_id="+cid+"&ei_id="+$('#ei_id').val(),
		fit:true,
		title:'预测分析'
	},0);
}

function score(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/score?c_id="+cid+"&ei_id="+$('#ei_id').val(),
		fit:true,
		title:'逐题赋分'
	},1);
}

function questionTypeExplain(){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/questionTypeExplain?eid="+$('#ei_id').val(),
		fit:true,
		title:'题型说明'
	},0);
}

function adjustPaper(cid,way){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/adjustPaper?c_id="+cid+"&ei_id="+$('#ei_id').val()+"&way="+way,
		fit:true,
		title:'按题型调整顺序分值时间'
	},1);
}

function adjustQuestionOrder(cid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/adjustQuestionOrder?c_id="+cid+"&ei_id="+$('#ei_id').val(),
		fit:true,
		title:'调整试题顺序'
	},1);
}

function generateBpaper(url){
	$.ajax({
          url: '${pageContext.request.contextPath}/verify/checkGenerateBpaperPermission',
          async: false,
          type: "POST",
          data: {"eid":$('#ei_id').val()},
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


function printAnswer(rs,aid){
	var p = '';//选择题ABCDE
	var out = '';
	if(aid==null||typeof(aid)=='undefined'||aid==''){
		aid = '';
		return aid;
	}
	var aid = aid.split(",");
	for(var i=0;i<rs.length;i++){
		if(rs[i].ATID<4||rs[i].ATID==8||rs[i].ATID==9){
			p = String.fromCharCode(65+i);
			for(var j=0;j<aid.length;j++){
				if(rs[i].AID==aid[j]){
					if(rs[i].ACONTENT!=null&&rs[i].ACONTENT!=''&&rs[i].ACONTENT!='null'&&typeof(rs[i].ACONTENT)!='undefined'){
						out += '<a>'+ p + '.' + rs[i].ACONTENT + '</a><br/>';
					}else{
						out += '<a>'+ p + '.' + rs[i].ACONTENT_6 + '</a><br/>';
					}
				}
			}
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
function exportSelectQuestion(){
	var cid="";

	if($("#courseList").val()!=null && $("#courseList").val()!="" && $("#courseList").val()!="null" && $("#courseList").val()!="undefined"){
		cid=$("#courseList").val();
	}

	var qids = [];
	if($("input[type='checkbox']").is(':checked')){
		 $('input[type="checkbox"]:checked').each(function(){
			 qids.push($(this).val());
		 })
	}
	if(qids.length > 0){
	var winStr = '<table width="75%" align="center" style="margin-top:5px;">'
			   + '<tr><td><input type="radio" name="gs" value="0" checked="checked"/>原格式导出（如果需要导入系统，建议使用原格式导出）</td></tr>'
			   + '<tr><td><input type="radio" name="gs" value="1"/>智能过滤格式</td></tr>'
			   + '<tr><td><input type="button" id="ensureExport" value="导出"/></td></tr>'
			   +'</table>';
			   var obj = $(winStr);
			   $('#exportPaperQuestion').html(null);
			   obj.appendTo('#exportPaperQuestion');
			   $('#exportPaperQuestion').window({
				   width:510,
				   height:200,
				   modal:true,
			       title:"请选择",
			       collapsible:false,
				   minimizable:false,
				   maximizable:false
				 });
				 $('#ensureExport').click(function(){
					 $('#exportPaperQuestion').window('close');
					 toastr.info("正在后台生成 Excel…");
					 const url = "${pageContext.request.contextPath}/paper/exportPaperQuestion?eid="+$('#ei_id').val()+ "&cid=" + cid +"&th1id="+$('#theme1List').val()+"&th1id="+$('#theme2List').val()+"&th3id="+$('#theme3List').val()+"&qtid="+$('#questionTypeList').val()+"&coid="+$('#cognitionList').val()+"&did="+$('#difficultyList').val()+"&kid="+$('#knowledgeList').val()+"&aorb=a"+"&gs="+$("input[name='gs']:checked").val()+"&qids="+qids;
					 $.ajax({
						 url: url,
						 method: 'GET',
						 xhrFields: {
							 responseType: 'blob'
						 },
						 success(data, status, xhr) {
							 const disposition = xhr.getResponseHeader('Content-Disposition');
							 let fileName = 'export.xlsx';
							 let m = disposition && /filename\*?=.*''(.+)$/.exec(disposition);
							 if (m && m[1]) {
								 fileName = decodeURIComponent(m[1]);
							 } else {
								 m = disposition && /filename="?([^"]+)"?/.exec(disposition);
								 if (m && m[1]) fileName = m[1];
							 }

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

}
function exportPaperQuestion(){
	var cid="";

	if($("#courseList").val()!=null && $("#courseList").val()!="" && $("#courseList").val()!="null" && $("#courseList").val()!="undefined"){
		cid=$("#courseList").val();
	}

	var winStr = '<table width="75%" align="center" style="margin-top:5px;">'
			   + '<tr><td><input type="radio" name="gs" value="0" checked="checked"/>原格式导出（如果需要导入系统，建议使用原格式导出）</td></tr>'
			   + '<tr><td><input type="radio" name="gs" value="1"/>智能过滤格式</td></tr>'
			   + '<tr><td><input type="button" id="ensureExport" value="导出"/></td></tr>'
			   +'</table>';
			   var obj = $(winStr);
			   $('#exportPaperQuestion').html(null);
			   obj.appendTo('#exportPaperQuestion');
			   $('#exportPaperQuestion').window({
				   width:510,
				   height:200,
				   modal:true,
			       title:"请选择",
			       collapsible:false,
				   minimizable:false,
				   maximizable:false
				 });

				 $('#ensureExport').click(function(){
					 $('#exportPaperQuestion').window('close');
					 toastr.info("正在后台生成 Excel…");
					 const url = "${pageContext.request.contextPath}/paper/exportPaperQuestion?eid="+$('#ei_id').val()+ "&cid=" + cid +"&th1id="+$('#theme1List').val()+"&th1id="+$('#theme2List').val()+"&th3id="+$('#theme3List').val()+"&qtid="+$('#questionTypeList').val()+"&coid="+$('#cognitionList').val()+"&did="+$('#difficultyList').val()+"&kid="+$('#knowledgeList').val()+"&aorb=a"+"&gs="+$("input[name='gs']:checked").val();
					 $.ajax({
						 url: url,
						 method: 'GET',
						 xhrFields: {
							 responseType: 'blob'
						 },
						 success(data, status, xhr) {
							 const disposition = xhr.getResponseHeader('Content-Disposition');
							 let fileName = 'export.xlsx';
							 let m = disposition && /filename\*?=.*''(.+)$/.exec(disposition);
							 if (m && m[1]) {
								 fileName = decodeURIComponent(m[1]);
							 } else {
								 m = disposition && /filename="?([^"]+)"?/.exec(disposition);
								 if (m && m[1]) fileName = m[1];
							 }

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
}

function importQuestionToPaper(){
	var winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/paper/importQuestionToPaper?eid=' + $('#ei_id').val()  + '&cid=' + $("#c_id").val()+'">'
			   + '<table width="100%" align="center" style="margin-top:5px;">'
			   + '<tr><td colspan="2" align="center" style="color:red">导入试题（只接受excel格式）</td></tr>'
			   + '<tr><td>选择文件：</td><td><input id="uploadFile" type="file" name="uploadFile" value="" accept=".xls,.xlsx"/></td></tr>'
			  /*  + '<tr><td>是否查重：</td><td><input type="radio" name="repeat" value="0" checked="checked"/>不查重<input type="radio" name="repeat" value="1"/>数据库+Excel表内查重<input type="radio" name="repeat" value="2"/>Excel表查重</td></tr>' */
			   + '<tr><td></td><td><input type="button" id="importFile" name="importFile" value="上传"/></td></tr>'
			   + '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/paper/importQuestionMonel?eid='+$('#ei_id').val()+'">链接</a>'
			   + '</td></tr></table></form>';
	var obj = $(winStr);
	$('#importQuestionToPaper').html(null);
	obj.appendTo('#importQuestionToPaper');
	$('#importQuestionToPaper').window({
		width:510,
		height:200,
		modal:true,
		title:"导入试题到试卷",
		collapsible:false,
		minimizable:false,
		maximizable:false
		//content:winStr
	});
	$('#importFile').click(function(){
		var fileName = $('#uploadFile').val();
		if(fileName==''){
			toastr.warning("请选择附件");
			return;
		}
		if(fileName){
			var fileType = (fileName.substring(fileName.lastIndexOf(".")+1,fileName.length)).toLowerCase();
			if(fileType == 'xls' || fileType == 'xlsx'){
			var choose = $("input[name='repeat']:checked").val();
			ajaxUpload(choose, fileName);
		}else{
			toastr.warning("上传文件格式错误！");
		}
		}
	});
}

function ajaxUpload(repeat, fileName){
	$('#importQuestionToPaper').window('close');
	ajaxLoading();
	var formData = new FormData();
	formData.append("uploadFile",$("#uploadFile")[0].files[0]);
	formData.append("name",fileName);
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/importQuestionToPaper?eid=' + $('#ei_id').val()+ '&cid=' + $("#c_id").val(),
		type: 'POST',
		secureuri: false,
		data: formData,
		processData:false,
		contentType:false,
		success:function(data){
			if(data.code != 0){
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
			}else{
				ajaxLoadEnd();
				$('#datalist').datagrid('reload');
				openIframeDialog({
					url:'${pageContext.request.contextPath}/paper/adjustPaper?c_id=' + $("#c_id").val() + '&ei_id=' + $('#ei_id').val() +"&way=1",
					fit:true,
					title:'调整分值'
				},1);
			}
		}
	});
}

function back(){
	var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
	if(title == '网站首页'){
		window.location.href = "${pageContext.request.contextPath}/news/newsList?page="+1+"&rows="+20;
	}else if(title == '尚未提交审核的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/paperList";
	}else if(title == '等待初级审核的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/waitFirstVerify";
	}else if(title == '等待终极审核的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/waitLastVerify";
	}else if(title == '通过审核待考的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/verified";
	}else if(title == '已考尚未收卷的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/unSubmit";
	}else if(title == '暂时删除不用的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/del";
	}else if(title == '审核未被通过的试卷'){
		window.location.href = "${pageContext.request.contextPath}/verify/unVerify";
	}else if(title.indexOf('查询所有试卷')>-1){
		window.location.href = "${pageContext.request.contextPath}/result/SearchAllPaper";
	}else if(title == '未发布的形成性评价'){
		window.location.href = "${pageContext.request.contextPath}/evaluationverify/unreleased";
	}else if(title == '已发布的形成性评价'){
		window.location.href = "${pageContext.request.contextPath}/evaluationverify/released";
	}else if(title == '已结束的形成性评价'){
		window.location.href = "${pageContext.request.contextPath}/evaluationverify/finished";
	}else{
		window.location.href = localStorage.preUrl;
	}
}

function next(){
	var tab=window.parent.$('#nav_tab').tabs('getSelected');//获取当前选中tabs
	var tab_index = window.parent.$('#nav_tab').tabs('getTabIndex',tab);
	var titles = window.parent.$('#nav_tab').find('.tabs-header:first').find('.tabs-title');
    titles.eq(tab_index).text('尚未提交审核的试卷');
	window.location.href = "${pageContext.request.contextPath}/verify/paperList";
}

function nextmobile(){
	var tab=window.parent.$('#nav_tab').tabs('getSelected');//获取当前选中tabs
	var tab_index = window.parent.$('#nav_tab').tabs('getTabIndex',tab);
	var titles = window.parent.$('#nav_tab').find('.tabs-header:first').find('.tabs-title');
    titles.eq(tab_index).text('未发布的形成性评价');
	window.location.href = "${pageContext.request.contextPath}/evaluationverify/unreleased";
}

function reloads(){
	getTotalAndSum();
	getTotalTime();
	getExamModAndTime();
	$('#datalist').datagrid("reload");
}

function getRepeatDetail(qid) {
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/getRepeatDetail',
		type: "POST",
		data: {
			"eid": $('#ei_id').val(),
			"qid": qid,
			"fromPaper": 1
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

function toFindRepeatQuestions(){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/toFindRepeatQuestions?eid="+$('#ei_id').val(),
		fit:true,
		title:'查找重复试题'
	},0);
}
</script>

