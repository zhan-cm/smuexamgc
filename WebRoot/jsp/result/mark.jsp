<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
*{
	font-size:12px;
}
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 3px;
}
td, th {
	line-height: 1.6;
	vertical-align: center;
	/* border-top: 1px solid #ddd; */
	border: 1px solid #ddd;
}
.title{
	text-align: center;
	margin: 5px 0 ;
	font-size:16px;
}
.sInfo{
	height:30px;
	text-align: center;
}
.sInfo span{
	width:80px;
}
.qcontent{
	height: 30px;
	width: 300px;
	margin-right:10px;
	overflow:hidden;
	float:left;
}
.previewQuestion{
	text-decoration:none;
	color:black;
}
</style>
<div id="dlg-toolbar">
<h1 class="title">《${examInfo.ENAME}》
	<c:forEach var="et" items="${examTypeList}">
	    <c:if test="${examInfo.TYPE == et.ID}">
			${et.NAME}
		</c:if>				
	</c:forEach>
	<c:choose>
		<c:when test="${examInfo.AORB==0 }">
			(A卷)
		</c:when>
		<c:otherwise>
			(B卷)
		</c:otherwise>
	</c:choose>
	<font style="color:red;">主观题批改</font>
</h1>
<div class="sInfo">
	<c:if test="${correctway==0 }">
		<span>姓名:&nbsp;&nbsp;</span><u>${student.name}</u>&nbsp;&nbsp;&nbsp;&nbsp;
		<span>学号:&nbsp;&nbsp;</span><u>${student.num}</u>&nbsp;&nbsp;&nbsp;&nbsp;
		<span>专业:&nbsp;&nbsp;</span><u>${student.specialty_name}</u>&nbsp;&nbsp;&nbsp;&nbsp;
		<span>年级:&nbsp;&nbsp;</span><u>${student.grade_name}</u>
	</c:if>
</div>

<table cellpadding="0" cellspacing="0" style="width:100%;" id="hz_table">
	<tr>
		<td>题号</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td class="qindex">
				${t.index + 1}
			</td>
		</c:forEach>
		<td>合计</td>
	</tr>
	<tr>
		<td>题型</td>
		<c:forEach var="qt" items="${questiontype}">
			<td>
				${qt.QTNAME}
			</td>
		</c:forEach>
		<td></td>
	</tr>
	<tr>
		<td>满分</td>
		<c:forEach var="qt" items="${questiontype}">
			<td class="qtscore">
				<span class="qtpoint">${qt.score }</span>
			</td>
		</c:forEach>
		<td class="amount"></td>
	</tr>
	<tr>
		<td>得分</td>
		<c:forEach var="qt" items="${questiontype}">
			<td class="sqtscore">
				<span class="sqtpoint">${qt.sascore }</span>
			</td>
		</c:forEach>
		<td class="samount"></td>
	</tr>
	<tr>
		<td>评卷人</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td class="cteacher">
			${qt.correct_teacher }
			</td>
		</c:forEach>
		<td>${reviewTeacher }</td>
	</tr>
</table>
<div>
	<a href="javascript:void(0);" onclick="back();" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="window.location.reload();">刷新</a>
	<a href="javascript:void(0)" class="easyui-linkbutton correctSelect" data-options="iconCls:'icon-edit'">批改选中的试题</a>
</div>
<form id="correctForm" method="post" action="${pageContext.request.contextPath}/result/correctQuestion" style="display:none">
<input type="hidden" id="eid" name="eid" value="${eid}"/>		 
<input type="hidden" id="sid" name="sid" value="${sid}"/>
<input type="hidden" id="sids" name="sids" value="${sids}"/>
<input type="hidden" id="sort" name="sort" value="${sort}"/>
<input type="hidden" id="order"	name="order" value="${order}"/>
<input type="hidden" id="specialty" name="specialty" value="${specialty}"/>
<input type="hidden" id="grade" name="grade" value="${grade}"/>
<input type="hidden" id="klass" name="klass" value="${klass}"/>
<input type="hidden" id="addid" name="addid" value="${addid}"/>
<input type="hidden" id="pgState" name="pgState" value="${pgState}"/>
<input type="hidden" id="qids" name="qids"/>
<input type="hidden" id="isunion" name="isunion" value="${isunion }"/>
<input type="hidden" id="random" name="random" value="${random }"/>
</form>
</div>
<table id="datalist"></table>
<script type="text/javascript">
var eid = $('#eid').val();
var sid = $('#sid').val();
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/result/getSubjectiveQuestion',
		pagination: true,
		rownumbers: false,
		nowrap:false,
		pageSize: 100,
		pageList:[20,40,60,80,100,120,140,160,180,200],
		fitColumns: true,
		queryParams: {
			sid: sid,
			eid: eid,
			isunion:$("#isunion").val(),
			random:$("#random").val()
		},
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[		
			  {field:'qid', width:40,checkbox:true},
			  {field:'qtname',title:'题型',width:40,align:'center',sortable:true},
			  {field:'content',title:'题目内容',width:160,align:'left',sortable:false,formatter:function(value,row,index){
				  var s = '<a href="javascript:void(0);" class="previewQuestion" onclick="getQuestionDetail(\''+row.qid+'\',\''+ row.mqid+ '\',\'' + row.ismain +'\',\''  + row.iscon +'\',\'' + row.atid + '\')"><div class="qcontent" style="padding-bottom:100px;">';
		    	  s+= row.content;
		    	  s+='</div></a>';
		    	  return s;
	          }},
			  {field:'score',title:'满分',width:40,align:'center',sortable:true},
			  {field:'averagescore',title:'得分',width:40,align:'center',sortable:true},
			  {field:'correctteacher',title:'改卷老师',width:40,align:'center',sortable:false},
			  {field:'allUpdator',title:'改卷历史',width:40,align:'center'}
	    ]],
	    onLoadSuccess:function(data){
	    	$('.correctQuestion').linkbutton({text:'改卷',iconCls:'icon-edit',plain:true});
	    	$('.viewQuestion').linkbutton({text:'试题详情',iconCls:'icon-search',plain:true});	  
	    	//$('#datalist').datagrid('selectAll');
	    	
	    	if($("#random").val()=='1'){
	    		 $("input[type='checkbox']").each(function(index, el){
	    		 	$("#datalist").datagrid("selectRow", index);
			        el.disabled = true;
			    })
	    	}else{
	    		for(var i=0; i<data.rows.length; i++) {
					if(data.rows[i].averagescore==''||typeof(data.rows[i].averagescore)=='undefined'){
						$("#datalist").datagrid("selectRow", i);
					}	
				}
	    	}
			
	    },
	    onClickRow: function(rowIndex, rowData){
            if($("#random").val()=='1'){
            	$("input[type='checkbox']").each(function(index){
	               $("#datalist").datagrid("selectRow", index);
	            })
            }
        }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$.each($('.qindex'),function(i,item){
		var qindex = $(item).text();
		if(qindex && !isNaN(qindex)){
			$(item).text(NumberToChinese(qindex));
		}
	});
	hz_score();
});

function hz_score(){
	var qtscore = 0;
	$(".amount").parent().find(".qtpoint").each(function(i,item){
		if($(item).text()){
			qtscore = (parseFloat(qtscore) + parseFloat($(item).text())).toFixed(1);
		}			
	});
	$('.amount').text(qtscore);
	
	var sqtscore = 0;
	$(".samount").parent().find(".sqtscore").each(function(i,item){
		if($(item).text()){
			sqtscore = (parseFloat(sqtscore) + parseFloat($(item).text())).toFixed(1);
		}		
	});
	$('.samount').text(sqtscore);
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
				if(typeof(answerList[0].CONTENT)=='undefined'){
					str += '';
				}else{
					str += answerList[0].CONTENT;
				}
				
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

$('.correctSelect').click(function(){
	var res = [];
	var rows = $('#datalist').datagrid('getSelections');
	if(rows.length == 0){
		toastr.warning('请勾选需要批改的试题！');
		return false;
	}
	for(var i=0; i<rows.length; i++){
		if(rows[i].mqid){
			res.push(rows[i].mqid);
		}
		res.push(rows[i].qid);
	}
	$('#qids').val(uniqueArray(res));
	
	$('#correctForm').submit();
});

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

function back(){
	window.location.href = "${pageContext.request.contextPath}/result/correctPaper?eid=" + $("#eid").val()+"&rstate=0";
}

var chnNumChar = ["零","一","二","三","四","五","六","七","八","九"];
var chnUnitSection = ["","万","亿","万亿","亿亿"];
var chnUnitChar = ["","十","百","千"];

function SectionToChinese(section){
  var strIns = '';
  var chnStr = '';
  var unitPos = 0;
  var zero = true;
  while(section > 0){  	
	var v = section % 10;
	if(v === 0){
	  if(!zero){
	    zero = true;
	    chnStr = chnNumChar[v] + chnStr;
	  }
	}else{
	  zero = false;
	  strIns = chnNumChar[v];
	  strIns += chnUnitChar[unitPos];
	  chnStr = strIns + chnStr;
	}
	unitPos++;
	section = Math.floor(section / 10);
  }
  var c=chnStr.substring(0, 1);
  if(chnStr.length>1&&c=='一'){
  	chnStr=chnStr.substring(1, chnStr.length);
  }
  return chnStr;
}

function NumberToChinese(num){
  var unitPos = 0;
  var strIns = '';
  var chnStr = '';
  var needZero = false;

  if(num === 0){
    return chnNumChar[0];
  }

  while(num > 0){
    var section = num % 10000;
    if(needZero){
      chnStr = chnNumChar[0] + chnStr;
    }
    strIns = SectionToChinese(section);
    strIns += (section !== 0) ? chnUnitSection[unitPos] : chnUnitSection[0];
    chnStr = strIns + chnStr;
    needZero = (section < 1000) && (section > 0);
    num = Math.floor(num / 10000);
    unitPos++;
  }
  return chnStr;
}

function getQuestionDetail(qid,mqid,ismain,iscon,atid){
	if(typeof(mqid) === "undefined" || mqid === "null"){
		mqid = "";
	 }
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/previewQuestion?qid="+qid+"&mqid="+mqid+"&isMain="+ismain+"&iscon="+iscon +"&eid="+eid+"&edit=1&atid="+atid,
		fit:true,
		title:'查看试题'
	},0);
	
}
</script>	