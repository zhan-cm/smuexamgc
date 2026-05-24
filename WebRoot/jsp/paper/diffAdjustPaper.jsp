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
.time{
/* 	border-radius: 3px; */
	text-align: center;
	width:30px;
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
<form id="adjustForm" method="post" action="${pageContext.request.contextPath}/paper/setDiffQuestionType">	
	<input type="hidden" name="ei_id" id="ei_id"  value="${eid}"/>
	<input type="hidden" name="c_id" id="c_id"  value="${cid}"/>
	<input type="hidden" name="assembly" id="assembly" value="y"/>
	<table width="100%" id="main">
		<tr class="title">	
			<td width="15%">题型</td>
			<td width="20%">试题数</td>
			<td width="20%">每题分数</td>
			<td width="30%">答题时间<span style="color:red;margin-left: 10px">（不赋值将使用题目默认答题时间）</span></td>
			<td width="15%">题型顺序</td>
		</tr>
		<c:forEach var="questionType" items="${qtList}" varStatus="qt">			
			<tr class="qtrow">
				<td>
					<c:if test="${questionType.ISCON == 0}">
						<span class="qtname">${questionType.QTNAME}</span>
					</c:if>
					<c:if test="${questionType.ISCON == 1}">
						<span class="qtname">*${questionType.QTNAME}</span>
					</c:if>
					<input type="hidden" class="qtname_in" value="${questionType.QTNAME}"/>
					<input type="hidden" class="e_qtname" value = "${questionType.E_QTNAME}"/>
					<input type="hidden" class="adjustText qtid" value="${questionType.QTID}"/>
					<input type="hidden" class="qtiscon" value="${questionType.ISCON}"/>
					<input type="hidden" class="atid" value="${questionType.ATID}"/>
					<input type="hidden" class="qtdesc" value="${questionType.QTDESC}"/>
					<input type="hidden" class="e_qtdesc" value="${questionType.E_QTDESC}"/>
					<input type="hidden" class="mediaset" value="${questionType.MEDIASET}"/>
				</td>
				<td>
					<input type="text" class="adjustText qtcount" value="${questionType.count}" disabled="disabled"/>
					<input type="hidden" class="qids" value="${questionType.qids}">
				</td>
				<td>
				<input type="hidden" class="adjustText xxdf" value="${questionType.XXDF}"/>
				<c:choose>
					<c:when test="${empty questionType.SCORE}">
						<c:choose>
							<c:when test="${questionType.XXDF==1 }">
								选项得分题，共0 分
								<!-- <input type="text" class="adjustText qtscore" value="0" readonly/> -->
							</c:when>
							<c:otherwise>
								<input type="text" class="adjustText qtscore" value="0" />
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${questionType.XXDF==1 }">
								选项得分题，共 ${questionType.SCORE} 分
								<input type="hidden" class="xxdf_score" value="${questionType.SCORE}" />
								<!-- <input type="text" class="adjustText qtscore" value="${questionType.SCORE}" readonly/> -->
							</c:when>
							<c:otherwise>
								<input type="text" class="adjustText qtscore" value="${questionType.SCORE}"/>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
				</td>

				<td>
					<select id="qttimeSelect" class="adjustText qttimeSelect" style="width:120px; height:24px;" onchange="changeQTTime(this)">
					    <option selected="selected" value="-1">默认值</option>
					    <option value="0">自定义</option>
					</select>
					<div style="display:inline-block" class="qttime_input">
						<input type="text" class="time hour" maxlength="2"/>&nbsp;:
						<input type="text" class="time min" maxlength="2"/>&nbsp;:
						<input type="text" class="time second" maxlength="2"/>
					</div>
<!-- 					<select id="qttime" name="qttime" class="adjustText qttime" style="width:120px;"> -->
<%-- 						<c:choose> --%>
<%-- 						    <c:when test="${questionType.ANSWERTIME eq -1}"> --%>
<!-- 							    <option selected="selected" value="-1">默认值</option> -->
<%-- 							</c:when> --%>
<%-- 							<c:otherwise> --%>
<!-- 								<option value="-1">默认值</option> -->
<%-- 							</c:otherwise> --%>
<%-- 						</c:choose> --%>
<%-- 						<c:forEach var="st" items="${applicationScope.systemTime2}" > --%>
<%-- 						    <c:choose> --%>
<%-- 							    <c:when test="${st.ID == questionType.ANSWERTIME}"> --%>
<%-- 								    <option selected="selected" value="${st.ID}">${st.NAME }</option> --%>
<%-- 								</c:when> --%>
<%-- 							    <c:otherwise> --%>
<%-- 								    <option value="${st.ID}">${st.NAME }</option> --%>
<%-- 								</c:otherwise> --%>
<%-- 							</c:choose> --%>
<%-- 						</c:forEach> --%>
<!-- 					</select> -->
				</td>
				<td>
					<span onclick="up(this);"  style="cursor: pointer;" title="上移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180466.gif"/></span>&nbsp;&nbsp;&nbsp;&nbsp;
	       			<span onclick="down(this);"  style="cursor: pointer;" title="下移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180465.gif"/></span>				
				</td>
			</tr>
		</c:forEach>
		<tr >
			<td width="15%">合计</td>
			<td width="20%" class="qamount"></td>
			<td width="20%" class="samount"></td>
			<td width="30%"></td>
			<td width="15%"></td>
		</tr>
	</table>
	<input type="hidden" name="res" id="res"/>
<%-- 	<input type="hidden" name="mqids" id="mqids" value="${mqids}"/> --%>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
	<!--<a id="order" class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);">排序</a>&nbsp;-->
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back();">回到上一步</a>
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

$(".qttime_input").hide();

$(".time").on('input',function(){
	var val = $(this).val().replace(/[^\d]/g,'');
	$(this).val(val);
})

$(".hour").on('input',function(){
	var val = $(this).val();
	if(val > 24){
		$(this).val(24);
	}
})

$(".min").on('input',function(){
	var val = $(this).val();
	if(val > 59){
		$(this).val(59);
	}
})

$(".second").on('input',function(){
	var val = $(this).val();
	if(val > 59){
		$(this).val(59);
	}
})

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
	if(r==""){
		toastr.error('每题分数不能留空');
		return;
	}
	if(isNaN(r)){
		toastr.error('请输入数字');
		$(this).val(null);
		return;
	}
	var reg = new RegExp(/^\d+(\.\d{1,4})?$/);
	if(reg.test(r)==false){
		toastr.error('只能输入小数点后4位');
		$(this).val(null);
		return;
	};
	
	getSamount();
});

function changeQTTime(elt){
	var e = $("td").has(elt);
	var s = e.find("#qttimeSelect").val();
	if(s==-1){
// 		e.find("#qttime").val(-1);
		e.find(".qttime_input").hide();
	}else{
		e.find(".qttime_input").show();
	}
}

function getSamount(){
	var samount = 0;
	$.each($('.qtrow'),function(i,item){
		var qtcount = parseInt($(item).find('.qtcount').val());
		var qtscore = 0;
		if($(item).find('.qtscore').length>0){
			qtscore=parseFloat($(item).find('.qtscore').val());
		}
		var xxdf_score=0;
		if($(item).find('.xxdf_score').length>0){
			xxdf_score=parseFloat($(item).find('.xxdf_score').val());
		}
		res = qtcount*qtscore+xxdf_score;
		if(!isNaN(res)){
			samount += res;
		}
	});
	var temp=samount.toString();
	if(temp.lastIndexOf(".") >-1){
		temp=temp.split(".");
		if(temp[1].length>2){
			samount=samount.toFixed(2);
		}
	}
	$('.samount').text(samount);
}

	
function submitForm(){
	var postdata = new Array();
	var j=0;
	var isNull;
	var qtarr = new Array();
	var b = true; //用于标识是否有题型分值设0
	$.each($(".qtrow"),function(i,item){		
		if($(item).find(".qtcount").val()!= 0){
			var qtname = $(item).find(".qtname_in").val();
			var e_qtname = $(item).find(".e_qtname").val();
			var qtcount = $(item).find(".qtcount").val();
			var qtiscon = $(item).find(".qtiscon").val();
			var atid = $(item).find(".atid").val();
			var qtdesc = $(item).find(".qtdesc").val();
			var e_qtdesc = $(item).find(".e_qtdesc").val();
			var qids = $(item).find(".qids").val().replace(/\[|]/g,'').split(",");
			var mediaset = $(item).find(".mediaset").val();
			var xxdf=$(item).find(".xxdf").val();
			var qtscore=0;
			if(xxdf==0){
				var qtscore = $(item).find(".qtscore").val();
				if(qtscore == '' || qtscore == 0){
					b = false;
				}
			}
			
			var qttime = 0;
			var qttime_select = $(item).find(".qttimeSelect").val();
			if(xxdf==0&&(qtscore==null||qtscore=="")){
				isNull = 'false';
				qtarr.push(qtname);
			}else{ 
				if(qttime_select==-1){
					qttime = -1;
				}else{
					var sec = $(item).find(".second").val();
					var min = $(item).find(".min").val();
					var hour = $(item).find(".hour").val();
					if(sec != ""){
						qttime += parseInt(sec);
					}
					if(min != ""){
						qttime += parseInt(min) * 60;
					}
					if(hour != ""){
						qttime += parseInt(hour) * 60 * 60;
					}
				}
				if(qttime==0){
					toastr.error("尚有题型未赋时，请先赋时，再继续下一步操作");
					return;
				}
				postdata[j] = { 
						"qtid": $(item).find(".qtid").val(), 
						"qtscore": $(item).find(".qtscore").val(), 
						"qttime": qttime, 
						"atid": atid,
						"qtdesc": qtdesc,
						"e_qtdesc":e_qtdesc,
						"qtname": qtname,
						"e_qtname":e_qtname,
						"qtindex": i,
						"qtiscon": qtiscon,
						"qids": qids,
						"xxdf":xxdf,
						"mediaset":mediaset
				};  
			    ++j;
			} 			
		}
		
	});
	if(b==false){
		toastr.error("尚有题型未赋分，请先赋分，再继续下一步操作");
		return;
	}
	var res = $.toJSON(postdata);
	if(res==null||res.length==0||isNull == 'false'){
		for(var i=0; i<qtarr.length; i++){
			toastr.warning(' ','题型 ' + qtarr[i] + ' 分数赋值不能为空','info');
		}		
		return;
	}else{
// 		var mqids = $('#mqids');
// 		var m = $.toJSON(mqids.val().replace(/\[|]/g,'').split(","));
// 		mqids.val(m);
        sessionStorage.setItem(title+'-back',null);
		sessionStorage.setItem(title+'-questionNum',null)
		$('#res').val(res);
		$('#adjustForm').submit();
	}	
}

var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题

function back(){
    $.ajax({
        url: '${pageContext.request.contextPath}/paper/adjustPaper_back',
        async: false,
        type: "POST",
        data: {"eid":$("#ei_id").val()},
        success: function (data) {
            title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
            sessionStorage.setItem(title+'-back','1');
            window.history.go(-1);
        }
    });
}

function up(elt){
	var objParentTR = $(elt).parent().parent();
    var prevTR = objParentTR.prev();
    
    var rows = objParentTR.prevAll().length + 1;
    if(rows > 2) {
        prevTR.insertAfter(objParentTR);
    }else{
    	toastr.warning("已经是第一行");
    }
}

function down(elt){
	var objParentTR = $(elt).parent().parent();
	var objParentTable=$(elt).parent().parent().parent();
	
	var rows = objParentTR.prevAll().length + 1;	
    
    if(rows<objParentTable.find("tr").length-1) {
    	var nextTR = objParentTR.next();
        nextTR.insertBefore(objParentTR);
    }else{
    	toastr.warning("已经是最后一行");
    }
}
</script>

