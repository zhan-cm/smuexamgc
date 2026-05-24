<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.adjustText{
	width:44px;
	/* border:1px solid #ccc; */
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	text-align: center;
}
.timeType{
	/* width:33px; */
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	text-align: center;
}
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 3px;
}
td, th {
	padding: 5px;
	line-height: 1.2;
	vertical-align: center;
	/* border-top: 1px solid #ddd; */
	border: 1px solid #ddd;
}
.drag-item{
	list-style-type:none;
	display:block;
	padding:5px;
	border:1px solid #ccc;
	margin:2px;
	width:300px;
	background:#fafafa;
	color:#444;
}
.indicator{
	position:absolute;
	font-size:9px;
	width:10px;
	height:10px;
	display:none;
	color:red;
}
.tips{
	color:red;
	display:none;
}
#unorder{
	display:none;
}
.title{
	height:36px; 
}
.title td{
	font-weight: bolder; 
}
</style>
<!--  <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" style="" onclick="window.location.reload();">取消</a>  -->
<h1 style="font-size: 22px;">时间与分值设定</h1>
<form id="adjustForm" method="post" action="${pageContext.request.contextPath}/paper/setQuestionType">	
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>	
	<input type="hidden" name="c_id" id="c_id"  value="${c_id}"/>
	<input type="hidden" name="isB" id="isB"  value="${isB}"/>
	<table width="100%" id="main">
		<tr class="title">
			<td width="25%">题型</td>
			<td width="25%">试题数</td>
			<td width="25%">每题分数</td>
			<td width="25%">答题时间<span style="color:red;margin-left: 10px">（不赋值将使用题目默认答题时间）</span></td>
		</tr>
		<c:forEach var="questionType" items="${exampaperQuestionTypeList}" varStatus="qt">			
			<tr class="qtrow">
				<td>
					<c:if test="${questionType.ISCON == 0}">
						<span class="qtname">${questionType.QTNAME}</span>
					</c:if>
					<c:if test="${questionType.ISCON == 1}">
						<span class="qtname">*${questionType.QTNAME}</span>
					</c:if>
					<input type="hidden" class="adjustText qtid" value="${questionType.QTID}"/>
				</td>
				<td><input type="text" class="adjustText qtcount" value="${questionType.QUESTIONCOUNT}" disabled="disabled"/></td>
				<td><input type="text" class="adjustText qtscore" value="${questionType.SCORE}"/></td>
				<td>
					<select id="qttime" name="qttime" class="adjustText qttime" style="width:120px;">
						<c:choose>
						    <c:when test="${questionType.ANSWERTIME eq -1}">
							    <option selected="selected" value="-1">默认值</option>
							</c:when>
							<c:otherwise>
								<option value="-1">默认值</option>
							</c:otherwise>
						</c:choose>
						<c:forEach var="st" items="${applicationScope.systemTime2}" >
						    <c:choose>
							    <c:when test="${st.ID == questionType.ANSWERTIME}">
								    <option selected="selected" value="${st.ID}">${st.NAME }</option>
								</c:when>
							    <c:otherwise>
								    <option value="${st.ID}">${st.NAME }</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</td>
			</tr>
		</c:forEach>
		<tr >
			<td width="25%">合计</td>
			<td width="25%" class="qamount"></td>
			<td width="25%" class="samount"></td>
			<td width="25%"></td>
		</tr>
		<input type="hidden" name="res" id="res"/>
	</table>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
	<a id="order" class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);">排序</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:window.history.go(-1);">回到上一步</a> 
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var indicator = $('<div class="indicator">>></div>').appendTo('body');	
$(document).ready(function() {
	var qamount = 0;
	$.each($('.qtcount'),function(i,item){
		qamount += parseInt($(item).val());
	});
	$('.qamount').text(qamount);
	getSamount();
	//var indicator = $('<div class="indicator">>></div>').appendTo('body');	

});
$('#order').click(function(){
	var text = $('#order').text();
	if(text=="排序"){
		toastr.info('点击题型拖拽可以改变题型顺序！');
		$('.qtscore').attr('disabled','disabled');
		$('.qttime').attr('disabled','disabled');
		$('.qtrow').draggable({
			disabled:false,
			revert:true,
			deltaX:0,
			deltaY:0
		}).droppable({
			onDragOver:function(e,source){
				indicator.css({
					display:'block',
					left:$(this).offset().left-10,
					top:$(this).offset().top+$(this).outerHeight()-5
				});
			},
			onDragLeave:function(e,source){
				indicator.hide();
			},
			onDrop:function(e,source){
				$(source).insertAfter(this);
				indicator.hide();
			}
		});
		$('#order').linkbutton({text:"保存排序"});
	}else if(text=="保存排序"){
		$('.qtscore').removeAttr('disabled');
		$('.qttime').removeAttr('disabled');
		$('.qtrow').draggable({
			disabled:true
		});
		$('#order').linkbutton({text:"排序"});
	}		
});


$(".qtscore").blur(function(){
	r = $(this).val();
	if(isNaN(r)){
		toastr.info('请输入数字');
		$(this).val(null);
		return;
	}
	
	getSamount();
});

function getSamount(){
	var samount = 0;
	$.each($('.qtrow'),function(i,item){
		var qtcount = parseInt($(item).find('.qtcount').val());
		var qtscore = parseFloat($(item).find('.qtscore').val());
		res = qtcount*qtscore;
		if(!isNaN(res)){
			samount += res;
		}
	});
	$('.samount').text(samount);
}

	
function submitForm(){
	var postdata = new Array();
	var j=0;
	var isNull;
	var qtarr = new Array();
	$.each($(".qtrow"),function(i,item){		
		if($(item).find(".qtcount").val()!= 0){
			var qtname = $(item).find(".qtname").text();
			var qtcount = $(item).find(".qtcount").val();
			var qtscore = $(item).find(".qtscore").val();
			var qttime = $(item).find(".qttime").val();
			var timeType = $(item).find(".timeType").val();
			if(qtscore==null||qtscore==""){
				isNull = 'false';
				qtarr.push(qtname);
			}else{ 
				if(timeType==2){
					qttime = qttime*60;
				}else if(timeType==3){
					qttime = qttime*60*60;
				}
				postdata[j] = { 
						"qtid": $(item).find(".qtid").val(), 
						"qtscore": $(item).find(".qtscore").val(), 
						"qttime": qttime, 
						"qtindex": i
				};  
			    ++j;
			} 			
		}
		
	});
	var res = $.toJSON(postdata);
	if(res==null||res.length==0||isNull == 'false'){
		for(var i=0; i<qtarr.length; i++){
			toastr.warning(' ','题型 ' + qtarr[i] + ' 分数赋值不能为空','info');
		}		
		return;
	}else{
		$('#res').val(res);
		$('#adjustForm').submit();
	}	
}

</script>

