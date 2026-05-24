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
	margin:0 2.2px;
}
.time{
/* 	border-radius: 3px; */
	text-align: center;
	width:30px;
}
.adjustText{
	width:44px;
	/* border:1px solid #ccc; */
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	text-align: center;
}
.datagrid-td-rownumber{
	height: 31px;
}
.datagrid-cell
      {
          word-break:break-all
      }

</style>
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="ei_id" name="ei_id" value="${ei_id}"/>
<input type="hidden" id="c_id" name="c_id" value="${c_id}"/>
<table cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<th style="text-align:center;font-size:15px;">试卷： ${ename}</th>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">			 
			<%-- <a href="${pageContext.request.contextPath}/course/addCourse" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">增加课程</a> --%>
			 <!-- <a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a> -->
			 <!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a> -->			
			 <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="save()">保存修改</a>
				<c:if test="${sign==1}">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="next()">下一步</a>
				</c:if>
<!-- 		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0">
	<tr>		
		<td> -->
			<select id="theme1List" name="themeList" class="qlimit">
				<option value="">全部主题词一</option>
				<c:forEach var="theme" items="${themeList}">
					<option value="${theme.ID}">${theme.NAME}</option>
				</c:forEach>
			</select>
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
			<%-- <select id="cognitionList" name="cognitionList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部认知</option>					
				<c:forEach var="cognition" items="${cognitionList}">
					<option value="${cognition.COID}">${cognition.CONAME}</option>
				</c:forEach>				
			</select> --%>
			<select id="difficultyList" name="difficultyList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部难度</option>
				<c:forEach var="difficulty" items="${difficultyList}">
					<option value="${difficulty.DID}">${difficulty.DNAME}</option>
				</c:forEach>
			</select>
			<%-- <select id="knowledgeList" name="knowledgeList"  class="qlimit" onchange="questionFilter()">
				<option value="">全部知识点</option>
				<c:forEach var="knowledge" items="${knowledgeList}">
					<option value="${knowledge.KID}">${knowledge.KNAME}</option>
				</c:forEach>
			</select> --%>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
var ei_id = $("#ei_id").val();
var c_id = $("#c_id").val();
$(document).ready(function(){
	$.parser.parse($("#searchpage"));//重新渲染
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getExampaperQuestionList?ei_id=' + ei_id + '&c_id' + c_id,
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[10,20,40,60,80,100,200,300,400,500,1000],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  //{field:'QID',checkbox:true},
			  {field:'qtname',title:'题型',width:40,align:'left',sortable:true},
		      {field:'content',title:'题目',width:120,align:'left',formatter:function(value,row,index){
		    	  var s = '<div class="qcontent" style="padding-bottom:100px;white-space:pre-wrap;">';
		    	  s+= row.content;
		    	  if(row.ismain=="1"){
		    	      s+="(主题干)"
				  }
	    	  	  s+='</div>';
	        	  var a = '<a href="javascript:void(0)" class="viewQuestion" onclick="viewQuestion('+ row.qid + ',' + row.mqid + ',' + row.ismain + ',' + row.iscon + ',' + row.atid + ')"></a>';
	        	  return s + a;
	          }},
	          {field:'dname',title:'难度',width:40,align:'left',sortable:true},
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
		      {field:'SCORE',title:'分值',width:40,align:'center',formatter:function(value,row,index){
		    	  var score = row.SCORE;
		    	  if(typeof(score) == "undefined"||score==undefined){
		    		  score = 0;
		    	  }
                  var s='';
		    	  if(row.ismain=="1"){
                      s+='<span id="'+row.qid+'">'+score+'</span>';
				  }else{
                      s = '<span class="scoreSpan">';
		    	      if(row.iscon=="1"){
                          s+='<input type="text" class="adjustText qscore '+row.mqid+'" value="' + score + '" onchange="changeScore(\''+row.mqid+'\')"/>';
					  }else{
                          s+='<input type="text" class="adjustText qscore" value="' + score + '" />';
					  }
                      s+='<input type="hidden" class="qid" value="' + row.qid + '"/>'
                          + '<input type="hidden" class="qtid" value="' + row.QTID + '"/>'
                          + '</span>';
				  }
		    	  return s;
	          }},
	          {field:'TID',title:'时间',width:40,align:'center',formatter:function(value,row,index){
				var sec = parseInt(row.answertime);
				var min = 0;
				var hour = 0;
				if(sec >= 60){
					min = parseInt(sec / 60);
					sec = parseInt(sec % 60);
					if(min >= 60){
						hour = parseInt(min / 60);
						min = parseInt(min % 60);
					}
				}
				var rs="";
                      if(row.ismain=="1"){
                          rs+='<span id="'+row.qid+'_time">'+hour+":"+min+":"+sec+'</span>';
                      }else{
                          if(row.iscon=="1"){
                              rs += '<div style="display:inline-block" class="qttime">';
                              rs += '<input type="text" class="time hour '+row.mqid+'_hour" maxlength="2" value="'+hour+'" onchange="changeTime(\''+row.mqid+'\')"/>&nbsp;:';
                              rs += '<input type="text" class="time min '+row.mqid+'_min" maxlength="2" value="'+min+'" onchange="changeTime(\''+row.mqid+'\')"/>&nbsp;:';
                              rs += '<input type="text" class="time second '+row.mqid+'_second" maxlength="2" value="'+sec+'" onchange="changeTime(\''+row.mqid+'\')"/></div>';
                          }else{
                              rs += '<div style="display:inline-block" class="qttime">';
                              rs += '<input type="text" class="time hour" maxlength="2" value="'+hour+'"/>&nbsp;:';
                              rs += '<input type="text" class="time min" maxlength="2" value="'+min+'"/>&nbsp;:';
                              rs += '<input type="text" class="time second" maxlength="2" value="'+sec+'"/></div>';
                          }

					  }

				return rs;
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

function changeScore(mqid){
    var score=0;
	$("."+mqid).each(function(){
        score+=parseInt($(this).val());
	});
	$("#"+mqid).html(score);
}

function changeTime(mqid){
	var hour=0;
	var min=0;
	var sec=0;
	$("."+mqid+"_hour").each(function(){
		hour+=parseInt($(this).val());
	});
    $("."+mqid+"_min").each(function(){
        min+=parseInt($(this).val());
    });
    $("."+mqid+"_second").each(function(){
        sec+=parseInt($(this).val());
    });
    sec=sec+min*60+hour*60*60;

    min = parseInt(sec / 60);
    sec = parseInt(sec % 60);
    if(min >= 60){
        hour = parseInt(min / 60);
        min = parseInt(min % 60);
    }
    $("#"+mqid+"_time").html(hour+":"+min+":"+sec);
}

function viewQuestion(qid, mqid,ismain,iscon,atid){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	 }
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/previewQuestion?qid="+qid+"&mqid="+mqid+"&isMain="+ismain+"&iscon="+iscon +"&eid="+ei_id+"&atid="+atid,
		fit:true,
		title:'查看试题'
	},0);
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

function times(data){
	data = parseInt(data);
	var second = data;
	var min = 0;
	var hour = 0;
	if(second > 60){
		min = parseInt(second/60);
		second = parseInt(second%60);
		if(min > 60){
			hour = parseInt(min/60);
			min = parseInt(min%60);
		}
	}
	var rt = '';
	if(hour > 0){
		rt += hour + "小时";
	}
	if(min > 0){
		rt += min + "分";
	}
	rt += second + "秒";
	return rt;
}

function questionFilter(){
	var p = $('#datalist').datagrid('getPager');
	//console.log($('#cognitionList').val());
	//console.log($('#difficultyList').val());
	//console.log($('#knowledgeList').val());
 	$('#datalist').datagrid('reload', {
 		c_id : $('#c_id').val(),
 		ei_id : $('#ei_id').val(), 
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
/*  	if($('#theme2List').val()){
 		getThemeList(3, $('#theme2List').val());
 	}else{
 		if($('#theme1List').val()){
 	 		getThemeList(2, $('#theme1List').val());
 	 	}
 	} 	 */
}

function getThemeList(th_level, th_pid){
	var cids = c_id.split(",");
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

function getQuestionCon(qid, version){
	var res = '';
	$.ajax({
        url: "${pageContext.request.contextPath}/question/getQuestionCon",
        async: false,//改为同步方式
        type: "POST",
        data: { "q_id":qid, "version":version},
        success: function (data) {
        	//alert(data);
    		//console.log(data.content);
    		res = data.content;
 		}
 	});	
	return res;
}

function save(){
	var list = []; 
	var unfit = false;
	$.each($(".scoreSpan"),function(i,item){
		var param = {};
		var score = $(item).find('.adjustText').val();
		var qid = $(item).find('.qid').val();
		param["qid"] = qid;
		param["qtid"] = $(item).find('.qtid').val();
		param["score"] = score;
		var t = 0;
		var qtElt = $(".qttime")[i];
		var atElt = $(qtElt);
		if(atElt.find(".hour").val() != ""){
			t += parseInt(atElt.find(".hour").val()) * 60 * 60;
		}
		if(atElt.find(".min").val() != ""){
			t += parseInt(atElt.find(".min").val()) * 60;
		}
		if(atElt.find(".second").val() != ""){
			t += parseInt(atElt.find(".second").val());
		}
		param["time"] = t;
		//console.log(param);
		list.push(param);
		if(isNaN(score)){
			toastr.warning('第' + (i+1) + '题赋分请输入数字');
			unfit = true;
			return;
		}
	});
	if(unfit){
		return false;
	}
	var params = {};
	params["list"] = list;
	params["eid"] = ei_id;
	$.ajax({
        url: "${pageContext.request.contextPath}/paper/saveScore",
        async: true, 
        type: "POST",
        traditional: true,
        contentType: "application/json; charset=utf-8",
        data:JSON.stringify(params),
        success: function (data) {
        	toastr.success(''+data+'道试题成功赋分');
        	$('#datalist').datagrid('reload');
 		}
 	});
}

function next(){
	window.location.href="${pageContext.request.contextPath}/paper/checkList?sign=1&c_id=" + $("#c_id").val() + "&ei_id=" + $("#ei_id").val();
}

</script>	

