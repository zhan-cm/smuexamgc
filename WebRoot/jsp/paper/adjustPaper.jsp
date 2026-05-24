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
.time{
/* 	border-radius: 3px; */
	text-align: center;
	width:30px;
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
.title{
	height:36px; 
}
.title td{
	font-weight: bolder; 
}
.iInput{
    position: absolute;
    width: 38px;
    height: 13px;
    left: 1px;
    top: 2px;
    border-bottom: 0px;
    border-right: 0px;
    border-left: 0px;
    border-top: 0px;
}
.open-time{
    font-size: 22px;
    margin-left: 580px;
    color: #818181;
    vertical-align: middle;
}
</style>
<div>
<sapn style="font-size: 22px;">时间与分值设定</sapn>
<sapn class="open-time" style="font-weight: bolder;" id="show_time">总答题时间:<span id="time"></span></sapn>
</div>
<form id="adjustForm" method="post" action="${pageContext.request.contextPath}/paper/setQuestionType">
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>	
	<input type="hidden" name="c_id" id="c_id"  value="${c_id}"/>
	<input type="hidden" name="isB" id="isB"  value="${isB}"/>
	<input type="hidden" name="isC" id="isC"  value="${isC}"/>
	<input type="hidden" name="assembly" id="assembly" value="y"/>
	<input type="hidden" name="mode" id="mode" value="${mode}"/>
	<table width="100%" id="main">
		<tr class="title">			
			<td width="15%">题型</td>
			<td width="20%">试题数</td>
			<td width="20%">每题分数</td>
			<td width="30%">答题时间<span style="color:red;margin-left: 10px">（不赋值将使用题目默认答题时间）</span></td>
			<td width="15%">题型顺序</td>
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
					<select id="qttimeSelect" class="adjustText qttimeSelect" style="width:120px; height:24px;" onchange="changeQTTime(this,${qt.index},${questionType.QTIME})">
						<c:choose>
						    <c:when test="${questionType.ANSWERTIME eq -1}">
							    <option selected="selected" value="-1">默认值</option>
							    <option value="0">自定义</option>						   
							</c:when>
							<c:otherwise>
								<option value="-1">默认值</option>
								<option selected="selected" value="0">自定义</option>							
							</c:otherwise>
						</c:choose>
						 
					</select>
					<div style="display:inline-block" class="qttime_input">
						<input type="hidden" class="time_init" value="${questionType.ANSWERTIME}"/>
						<input type="hidden" id="input_count${qt.index }" value="${questionType.QUESTIONCOUNT}"/>
						<input type="hidden" id="list_size" value="${fn:length(exampaperQuestionTypeList)}"/>
						<div style="position:relative;display: inline-block;">
				              <select style="width:60px;"
				                      onchange="document.getElementById('input_hour${qt.index }').value=this.value;getTime(${fn:length(exampaperQuestionTypeList)})">
				                <option value="0" selected="selected">0</option>
				                <option value="1">1</option>
				                <option value="2">2</option>
				              </select>时
				              <input id="input_hour${qt.index }" name="input" class="iInput hour">
				        </div>
				        <div style="position:relative;display: inline-block;">
				              <select style="width:60px;"
				                      onchange="document.getElementById('input_minute${qt.index }').value=this.value;getTime(${fn:length(exampaperQuestionTypeList)})">
				                <option value="0" selected="selected">0</option>
				                <option value="5">5</option>
				                <option value="10">10</option>
				                <option value="15">15</option>
				                <option value="20">20</option>
				                <option value="25">25</option>
				                <option value="30">30</option>
				                <option value="35">35</option>
				                <option value="40">40</option>
				                <option value="45">45</option>
				                <option value="50">50</option>
				              </select>分
				              <input id="input_minute${qt.index }" name="input" class="iInput min">
				        </div>
				        <div style="position:relative;display: inline-block;">
				              <select style="width:60px;"
				                      onchange="document.getElementById('input_second${qt.index }').value=this.value;getTime(${fn:length(exampaperQuestionTypeList)})">
				                <option value="0">0</option>
				                <option value="5">5</option>
				                <option value="10">10</option>
				                <option value="15">15</option>
				                <option value="20">20</option>
				                <option value="25">25</option>
				                <option value="30">30</option>
				                <option value="35">35</option>
				                <option value="40">40</option>
				                <option value="45" selected="selected">45</option>
				                <option value="50">50</option>
				              </select>秒
				              <input id="input_second${qt.index }" name="input" class="iInput second" value="${questionType.QTIME}">
				        </div>
					</div>
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
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
	<!--<a id="order" class="easyui-linkbutton" data-options="iconCls:'icon-text_list_numbers'" href="javascript:void(0);">排序</a>&nbsp;-->
	<c:if test="${mode==0||mode==3}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back();">回到上一步</a>
	</c:if>
</div>

<script type="text/javascript">
var indicator = $('<div class="indicator">>></div>').appendTo('body');	
$(document).ready(function() {
	var qamount = 0;
	$.each($('.qtcount'),function(i,item){
		qamount += parseInt($(item).val());
	});
	$('.qamount').text(qamount);
	getSamount();

	$(".qttime_input").hide();
	$.each($(".qttime_input"),function(i,item){
		var init_time = $(item).find(".time_init").val();
		if(init_time!=""){
			if(init_time > -1){
				var sec = parseInt(init_time);
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
				$(item).find(".second").val(sec);
				if(min > 0) $(item).find(".min").val(min);
				if(hour > 0) $(item).find(".hour").val(hour);
				$(item).show();
			}
		}
		
	});

	//init 默认时间
	var size =Number($("#list_size").val());
	getTime(size);
	
});

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

function changeQTTime(elt,_next,_time){
	var e = $("td").has(elt);
	var s = e.find("#qttimeSelect").val();
	if(s==-1){
	 	e.find(".qttime_input").hide(); 
	 	//刷新
	 	$("#input_hour"+_next).val(0);
	    $("#input_minute"+_next).val(0);
	    $("#input_second"+_next).val(_time);   
		
	}else{
		e.find(".qttime_input").show();
		//刷新
	 	$("#input_hour"+_next).val(0);
	    $("#input_minute"+_next).val(0);
	    $("#input_second"+_next).val(0); 
		
	}
	var size =Number($("#list_size").val());
	getTime(size);
}

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
			var qtname = $(item).find(".qtname").text();
			var qtcount = $(item).find(".qtcount").val();
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
				}
				postdata[j] = { 
						"qtid": $(item).find(".qtid").val(), 
						"qtscore": $(item).find(".qtscore").val(), 
						"qttime": qttime, 
						"qtindex": i,
						"xxdf":xxdf
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
		$('#res').val(res);
        sessionStorage.setItem(title+'-back',null);
        sessionStorage.setItem(title+'-questionNum',null);
		$('#adjustForm').submit();
	}	
}

var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题

function back(){
    if($("#mode").val()==0||$("#mode").val()==3){//0结构化  3多课程
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

    $("input[name='input']").bind('input propertychange',function () {
    	var size =Number($("#list_size").val());
    	getTime(size);
	});

	
function getTime(_size){
	   var size =Number(_size);
	   var hour = 0;
       var minute = 0;
       var second =0;
    
	 for(var i=0;i<size;i++){
        hour += (Number($("#input_hour"+i).val()) * Number($("#input_count"+i).val()));
        minute += (Number($("#input_minute"+i).val()) * Number($("#input_count"+i).val()));
        second +=  (Number($("#input_second"+i).val()) * Number($("#input_count"+i).val()));       
		}
	 var ss = (hour*3600) + (minute*60)+second;
	 var mm = s_to_hs(ss);
	 $("#time").text(mm);
	 
}


function s_to_hs(s){
    //计算分钟
    //算法：将秒数除以60，然后下舍入，既得到分钟数
    var h;
    h  =   Math.floor(s/60);
    //计算秒
    //算法：取得秒%60的余数，既得到秒数
    s  =   s%60;
    //将变量转换为字符串
    h    +=    '';
    s    +=    '';
    //如果只有一位数，前面增加一个0
    h  =   (h.length==1)?'0'+h:h;
    s  =   (s.length==1)?'0'+s:s;
    return h+'分'+s+'秒';
}

</script>

