<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">
<style>
.qtInput{
	width:34px;
	/* border:1px solid #ccc; */
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	text-align: center;
}
.qtInput:focus{
	border-radius:5px;
	border:#87CEEB 2px solid;
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
	height:33px;
}
th{
	text-align:center;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<!-- <input type="button" onclick="window.location.reload()"/> -->
</br>
<form id="structureForm" method="post" action="${pageContext.request.contextPath}/paper/diffStructure">	
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>
	<input type="hidden" name="c_id" id="c_id"  value="${c_id}"/>
	<input type="hidden" name="questionNum" id="questionNum"/>
	<input type="hidden" name="qtscore" id="qtscore"/>
	<!-- <input type="hidden" name="forbidNum" id="question_use_time"  value="${forbidNum}"/>
	<input type="hidden" name="forbidDay" id="question_used_day"  value="${forbidDay}"/>
	<input type="hidden" name="isVerified" id="limit4Isreview"  value="${isVerified}"/> -->

	<h1 style="color:red;text-align:center;width:100%;font-size:18px;">距离重新登录时间还有<span id="time" style="font-size:18px;"></span>，请在重新登录前保存要添加的题目</h1>
<!-- 	双向细目表模板： -->
<!-- 	<select id="template" onchange="changeCheckList()" style="width:200px;height:23px;margin-bottom:8px;"> -->
<!-- 		<option>请选择模板</option> -->
<!-- 	</select> -->
	<div style="width:100%">
	限定：不选用&nbsp;
	<input title="0表示不做筛选；如果输入值大于系统设置参数，则默认按照系统参数查找题目。当前系统设置为：“不使用${forbidDay}天内考过的试题！”" class="easyui-tooltip" id="forbidDay" name="forbidDay" type="text" value="${forbidDay}" style="width:90px" />
	&nbsp;天之内考过的试题。&nbsp;&nbsp;不选用已使用过&nbsp;<input title="0表示不做筛选；如果输入值大于系统设置参数，则默认按照系统参数查找题目。当前系统设置为：“不选用使用过${forbidNum}次及以上的试题！”" class="easyui-tooltip" id="forbidNum"  name="forbidNum"  type="text" style="width:90px" value="${forbidNum}" />&nbsp;次及以上的试题
	选用
	<c:choose>
			<c:when test="${isVerified==1 }">
				<c:if test="${question_verify_switch==1 }">
					<select id='isVerified' name='isVerified'><option value='3'>已终审</option></select>
				</c:if>
				<c:if test="${question_verify_switch==0 }">
					<select id='isVerified' name='isVerified'><option value='1'>已审核</option></select>
				</c:if>
			</c:when>
			<c:otherwise>
				<select id='isVerified' name='isVerified'><option value='0' selected='selected'>全部</option>
					<c:if test="${question_verify_switch==1 }">
						<option value='1'>已初审</option>
						<option value='3'>已终审</option>
					</c:if>
					<c:if test="${question_verify_switch==0 }">
						<option value='1'>已审核</option>
					</c:if>
				</select>
			</c:otherwise>
		</c:choose>	试题&nbsp;
		<input type='button' value='确定' onclick='questionFilter()'/>
	</div>
	<br/>
	<table id="cid_${c_id}">
		<thead>
			<tr id="qtypeTR">
				<th>难度/题型</th>
				<c:forEach var="qt" items="${questionTypeList}">
					<th>${qt.QTNAME}<br>(${qt.QCOUNT}题)<input class="qtid" value="${qt.QTID}" type="hidden"/></th>
				</c:forEach>
				<th>合计</th>
			</tr>
		</thead>
		<tbody id="tbody">
			
		</tbody>
	</table>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<button class="btn btn-primary" onclick="submitForm()">保存</button>
	<button class="btn" onclick="cancel()">取消组卷</button>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var question_used_day=$("#forbidDay").val();
var question_use_time=$("#forbidNum").val();

var cid = $("#c_id").val();
var qtids = [];
$(".qtid").each(function(){
	qtids.push($(this).val());
});
$(document).ready(function(){
    cookierback();
	initData(0,0,0);
	
	$("#forbidDay").on('input',function(){
		var fd = $("#forbidDay");
		var forbidDay = fd.val().replace(/[^0-9]/g,'');
		fd.val(forbidDay);
		var fn = $("#forbidNum");
		var forbidNum = fn.val().replace(/[^0-9]/g,'');
		fn.val(forbidNum);
		var isVerified = $('#isVerified').val();
		initData(forbidDay,forbidNum,isVerified);
	})

	$("input[name='forbidNum']").on('input',function(){
		var fd = $("#forbidDay");
		var forbidDay = fd.val().replace(/[^0-9]/g,'');
		fd.val(forbidDay);
		var fn = $("#forbidNum");
		var forbidNum = fn.val().replace(/[^0-9]/g,'');
		fn.val(forbidNum);
		var isVerified = $('#isVerified').val();
		initData(forbidDay,forbidNum,isVerified);
	})
    loader(cid);

});

function questionFilter(){
	var forbidDay = $("#forbidDay").val()==undefined||$("#forbidDay").val()=="" ? question_used_day : $("#forbidDay").val();
    var forbidNum = $("#forbidNum").val()==undefined||$("#forbidNum").val()=="" ? question_use_time : $("#forbidNum").val();
    var isVerified = $("#isVerified").val();
    
    $.ajax({
		url:"${pageContext.request.contextPath}/paper/getAllQT4CourseQuestion",
		async:false,
		type:"POST",
		data:{"cid":cid,"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
		success:function(data){
			qtids = [];
			var str="<th>难度/题型</th>";
			for(var i=0;i<data.length;i++){
				qtids.push(data[i].QTID);
				str+="<th>"
				+data[i].QTNAME
				+"<br>("
				+data[i].QCOUNT+"题)<input class='qtid' value='"+data[i].QTID+"' type='hidden'/></th>";
			}
			str+="<th>合计</th>";
			$("#qtypeTR").html(str);
			initData(forbidDay,forbidNum,isVerified);
		}
	});
}

//获取输入的试题数
function getQuestionNumInfo(){
    var list = [];
    $('.qblock').each(function(i,item){
        var obj = new Object();
        obj.qtid = $(item).find(".q_qtid").val();
        var thid = $(item).find(".q_thid").val();
        if(typeof(thid)!='undefined'){
            obj.thid = thid;
        }
        var did = $(item).find(".q_did").val();
        if(typeof(did)!='undefined'){
            obj.did = did;
        }
        var num = $(item).find(".q_num").val();
        if(num != 0){
            obj.count = num;
            list.push(obj);
        }
    });
    return JSON.stringify(list);
}

function getThemeData(did,forbidDay,forbidNum,pid,tlevel){
	let rs = '';
	$.ajax({
		url:"${pageContext.request.contextPath}/paper/getThemeCountByCidAndDid",
		async:false,
		type:"POST",
		data:{"did":did,"cid":$('#c_id').val(),"forbidDay":forbidDay,"forbidNum":forbidNum,"pid":pid,"tlevel":tlevel},
		success:function(data){
			rs = data;
		}
	});
	return rs;
}

/*
 * 1、初始加载，  cookierback() set back  questionNum null  or value
 * 2、提交下一步，cookier() 保存questionNum set questionNum
 * 3、返回时加载 loader()
 */
var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
var questionNum = '';
var back = sessionStorage.getItem(title+'-back')=='null'?'':sessionStorage.getItem(title+'-back');

function cookierback(){ //加载初始数据前
    if(back=='1'){
        questionNum = sessionStorage.getItem(title+'-questionNum')=='null'?'':sessionStorage.getItem(title+'-questionNum'); //cookie空值返回null字符串
    }else{
        sessionStorage.setItem(title+'-questionNum',null);
    }
}

function cookier(){//提交时保存试题信息
    sessionStorage.setItem(title+'-questionNum',getQuestionNumInfo());
    sessionStorage.setItem(title+"-back",null);
}
function loader(cid){
    if(back=='1'){
		//获取table，清空table里面的值
		var table = $("#cid_"+cid+"");
		table.find(".qtcount").val("");
		table.find(".qtInput").val("");
		//关闭主题词列表并获取试题数目信息遍历渲染
		//关闭主题词
		title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
		var data = JSON.parse(sessionStorage.getItem(title+'-questionNum'));
		//遍历data
		for (var i = 0; i < data.length; i++) {
			var questionCount=parseInt(data[i].count);//输入的试题数
			//判断是否打开了主题词
			if(data[i].thid!=null){
				if($("#didBtn_"+data[i].did).hasClass("btn-primary")){
					$("#didBtn_"+data[i].did).trigger("click");
				}
            }
            //渲染
            var qblock = table.find(".dtr").find(".qblock");
            $(qblock).each(function() {
                var qnum = $(this).find(".q_num");//隐藏域的值
                var qdid = $(this).find(".q_did").val();//难度id
                var qtid = $(this).find(".q_qtid").val();//获取题型id
                var qtInput = $(this).find(".qtInput");//获取输入试题数input
                var qtSum =parseInt($(this).find(".qtSum").text());//获取题库题目数
				if(data[i].thid){
                    var qthid = $(this).find(".q_thid").val();
                    if(qtid == data[i].qtid&&qdid == data[i].did&&qthid == data[i].thid){
                        if(qtSum<questionCount){
                            qtInput.val(qtSum);
                            qnum.val(qtSum);
                        }else {
                            qtInput.val(questionCount);
                            qnum.val(questionCount);
                        }
                    }
				}else{
                    if(qtid == data[i].qtid&&qdid == data[i].did){
                        if(qtSum<questionCount){
                            qtInput.val(qtSum);
                            qnum.val(qtSum);
                        }else {
                            qtInput.val(questionCount);
                            qnum.val(questionCount);
                        }
                    }
				}
            });
		}
        //计算总数
        $.each(table.find(".dtr"),function(i,item) {
            //计算行
            var qblock = $(item).find(".qblock");
            for(var j = 0; j<qblock.length; j++){
                if($($(qblock)[j]).find(".qtInput").val()!=""){
                    var qtid = $($(qblock)[j]).find(".q_qtid").val();
                    var qtInput = $($(qblock)[j]).find(".qtInput").val();//输入的题目数
                    var qtCount = $(".qtcount_"+j);
                    var qtnum =  Number(qtCount.text()) + Number(qtInput);
                    qtCount.text(qtnum);
                }
            }
        });
		$(".qtInput").trigger("change");
    }
    sessionStorage.setItem(title+'-questionNum',null);
    sessionStorage.setItem(title+'-back',null);
}


function appendThemeButton(){//点击主题词显示主题词列表
    $(".thDiv").each(function(i,item){
        let clickNum = 0;
        $(this).find(".addThButton").on('click',function(event,isback){
            if(isback=='1'){//返回时加载的参数
                clickNum = 1;
            }else if(isback=='0'){
                clickNum = 0;
			}
            let did = $(item).find(".did").val();//难度id
            if(clickNum == 0){//未被点击
                clickNum = 1;
                $(this).removeClass("btn-primary");
                createThemeBlock(did,-1,1);
                getEachBlock();
            }else{
                clickNum = 0;
                $(this).addClass("btn-primary");
                cleanThemeBlock(did,-1);
            }
        });
    });
}

var btnColor = ["","#4ebe6bd1","#46a27a","#8f41b8"];
function createThemeBlock(did,pid,tlevel){
	($('#did_'+did+'').find(".qtInput")).each(function(){//$('#did_'+did+'')==tr
		$(this).val('');//清空数量
		$(this).attr("disabled",true);
	});
	($('#did_'+did+'').find(".q_num")).each(function(){
		$(this).val(0);
	});
	let forbidDay = $("#forbidDay").val();
	let forbidNum = $("#forbidNum").val();
	let tData = getThemeData(did,forbidDay,forbidNum,pid,tlevel);//根据难度获取主题词
	if(pid!=-1 && (tData==null || tData.length==[])){
		toastr.warning('没有下一级了！');
	}
	let thList = getThList(tData);
	let th = '';

	for(let i=0;i<thList.length;i++){
		let thid = thList[i].thid;
		let btnName = '一级';
		let space = '';
		if(thList[i].tlevel==2){
			btnName = '二级';
			space = '&nbsp;&nbsp;';
		}else if(thList[i].tlevel==3){
			btnName = '三级';
			space = '&nbsp;&nbsp;&nbsp;&nbsp;';
		}
		th += `<tr class="dtr did_\${did}_theme_\${pid}" id="did_\${did}_theme_\${thid}">`;
		th += `<td>\${space}<button class="theme-toggle" data-did='\${did}' data-tlevel='\${thList[i].tlevel}' `+
				`data-thid='\${thid}' style="background-color: \${btnColor[thList[i].tlevel]}; color:white;font-size: 13px;" `+
				`data-toggle-state='0' type='button'>\${btnName}</button><span>\${thList[i].thName}</span></td>`;
		for(let j=0;j<qtids.length;j++){
			let count = 0;
			for(let k=0;k<tData.length;k++){
				if(thid==tData[k].THID && qtids[j]==tData[k].QTID){
					count = parseInt(tData[k].COUNT);
				}
			}
			th += '<td class="qblock">';
			th += '<input type="text" class="qtInput"/>&nbsp;';
			th += '<a class="qtSum">'+count+'</a>';
			th += '<input type="hidden" class="q_qtid" value="'+qtids[j]+'"/>';
			th += '<input type="hidden" class="q_did" value="'+did+'"/>';
			th += '<input type="hidden" class="q_thid" value="'+thid+'"/>';
			th += '<input type="hidden" class="q_num" name="qInput_'+j+'" value="0"/>';
			th += '<input type="hidden" class="tlevel" value="'+thList[i].tlevel+'">'
			th += '</td>'
		}
		th += '<th><a class="dcount">0</a></th>';
		th += '</tr>'
	}
	if(pid==-1){
		$('#did_'+did+'').after(th);
	}else{
		($(`#did_\${did}_theme_\${pid}`).find(".qtInput")).each(function(){
			$(this).val('');//清空数量
			$(this).attr("disabled",true);
		});
		($(`#did_\${did}_theme_\${pid}`).find(".q_num")).each(function(){
			$(this).val(0);
		});
		$(`#did_\${did}_theme_\${pid}`).after(th);
	}
}

$(document).on('click', '.theme-toggle', function () {
	let button = $(this);
	let toggleState = parseInt(button.data('toggle-state'));
	let did = button.data('did');
	let thid = button.data('thid');
	let tlevel = button.data('tlevel');
	if(tlevel==3){
		toastr.warning("没有下一级了");
		return;
	}
	if (toggleState === 0) {
		createThemeBlock(did, thid, tlevel+1);
		button.data('toggle-state', 1); // 切换状态为 1
		button.css('background-color','grey');
		getEachBlock();
	} else {
		cleanThemeBlock(did, thid);
		button.data('toggle-state', 0); // 切换状态为 0
		button.css('background-color',btnColor[tlevel]);
	}
});

function getThList(data){
	let list = [];
	let thid = '';
	for(let i=0;i<data.length;i++){
		let obj = new Object();
		if(thid != data[i].THID){
			obj.thid = data[i].THID;
			obj.thName = data[i].NAME;
			obj.tlevel = data[i].TLEVEL;
			thid = data[i].THID;
			list.push(obj);
		}
	}
	return list;
}

function cleanThemeBlock(did,pid){
	if(pid==-1){
		($('#did_'+did+'').find(".qtInput")).each(function(){
			$(this).val('');
			$(this).attr("disabled",false);
		});
		($('#did_'+did+'').find(".q_num")).each(function(){
			$(this).val(0);
		});
	}else{
		($(`#did_\${did}_theme_\${pid}`).find(".qtInput")).each(function(){
			$(this).val('');
			$(this).attr("disabled",false);
		});
		($(`#did_\${did}_theme_\${pid}`).find(".q_num")).each(function(){
			$(this).val(0);
		});
	}
	$(`.did_\${did}_theme_\${pid}`).each(function() {
		let parentId = $(this).attr('id');
		if (parentId) {
			$(this).remove();
			$(`.\${parentId}`).remove();
		}
	});

}

function getEachBlock(){
	$.each($(".dtr"),function(i,item){//遍历每一行
		$(item).find(".qtInput").on('input propertychange change', function() {
			qtQuestionCount(item);
		});
	});
	
	$.each($(".qblock"),function(i,item){
		$(item).find(".qtInput").on('input propertychange change', function() {
			diffQuestionCount(item,$(this));
		});
	});
}

function qtQuestionCount(item){
	//每个难度统计题目数量
	var sum = 0;
	$.each(($(item).find(".qblock").find(".qtInput")),function(i,it){
		if($(it).val() != ''){
			sum += parseInt($(it).val());
		};
	})
	$(item).find(".dcount").text(sum);
	
	//每个题型统计题目数量
	for(var i=0;i<qtids.length;i++){
		var qtSum = 0;
		$.each($("input[name='qInput_"+i+"']"),function(i,item){
            var qtInputNum = $(item).val();
            if(qtInputNum==''){
                qtInputNum==0;
			}
			qtSum += parseInt(qtInputNum);
		})
		$(".qtcount_"+i+"").text(qtSum);
	}
	
	//已选择总的题目数量
	var count = 0;
	$.each($(".qtcount"),function(i,item){
		count += parseInt($(item).text());
	})
	$(".count").text(count);
}

//计算输入的试题数量
function diffQuestionCount(item,qInput){
	let qsum = parseInt($(item).find(".qtSum").text());//系统内试题数目
	let qIn = ($(qInput).val()).replace(/[^0-9]/g,'');//输入的试题数目
	if(parseInt(qIn) > qsum){
		toastr.info("输入题数不能大于原有题数");
		qIn = qsum;
	}
	if(qIn!=''){
        $(item).find(".q_num").val(qIn);
        qInput.val(qIn);
    }else{
        $(item).find(".q_num").val(0);
		qInput.val(0);
	}
}

var time = 1800;//设定倒计时半小时
setTime();

function submitForm(){
    cookier();//保存题目数

	//$("#forbidDayforbidDay").val($("#forbidDay").val());
    //$("#question_use_time").val($("#forbidNum").val());
	let list = [];
	$('.qblock').each(function(i,item){
		let obj = new Object();
		obj.qtid = $(item).find(".q_qtid").val();
		let thid = $(item).find(".q_thid").val();
		if(typeof(thid)!='undefined'){
			obj.thid = thid;
			obj.tlevel = $(item).find(".tlevel").val();
		}
		let did = $(item).find(".q_did").val();
		if(typeof(did)!='undefined'){
			obj.did = did;
		}
		let num = $(item).find(".q_num").val();
		if(num!=null && num!=undefined && num!='undefined' && num!= '0' && num != 0 && num!=''){
			obj.count = num;
			list.push(obj);
		}
	});
	if(list.length==0){
		toastr.warning("您没有选择任何题目！");
		return false;
	}
	toastr.warning("生成试卷的过程可能耗时比较久，请耐心等候！");
	$("#questionNum").val(JSON.stringify(list));
	$('#structureForm').submit();
}

function initData(forbidDay,forbidNum,isVerified){
	$.ajax({
		url:"${pageContext.request.contextPath}/paper/getDifficultQuestionCount",
		async:false,
		data: {"cid" : $('#c_id').val(), "forbidDay" : forbidDay , "forbidNum" : forbidNum, "isVerified" : isVerified},
		type:"POST",
		success: function (data){
			createTable(data);
		}
	});
}

//把数据整理然后加入到tbody里
function createTable(data){
	//获取表数据
	$('#tbody').html(null);
	var tDate = data;
	var dList = '';
	
	$.ajax({
		url:"${pageContext.request.contextPath}/course/getCourseDifficult",
		async:false,
		data: {"cid":$('#c_id').val()},
		type:"POST",
		success: function (data){
			dList = data;//难度&主题词
		}
	});
	
	for(var i=0; i<dList.length; i++){
		var did = dList[i].DID;
		var tr = '<tr id="did_'+did+'" class="dtr">';
			tr += '<td>';
			tr += '<div class="thDiv">'
			tr += '<input type="button" class="btn btn-primary btn-xs addThButton" id="'+'didBtn_'+did+'" value="主题词"/>&nbsp;'
			tr += '<input type="hidden" class="did" value="'+did+'"/>';
			tr += '<span>'+dList[i].DNAME+'</span></div>'
			tr += '</td>'
		//debugger;
			for(var j=0;j<qtids.length;j++){//遍历题型
				var qcount = 0;
				for(var k=0;k<tDate.length;k++){//遍历所有题型题目数
					if(tDate[k].DID==did && qtids[j]==tDate[k].QTID){//难度id相同，并且题型相同
						qcount = tDate[k].QCOUNT;
						break;
					}
				}
				tr += '<td class="qblock"><input type="text" class="qtInput"/>&nbsp;<a class="qtSum">'+qcount+'</a>';
				tr += '<input type="hidden" class="q_qtid" value="'+qtids[j]+'"/>'
				tr += '<input type="hidden" class="q_did" value="'+did+'"/>'
				tr += '<input type="hidden" class="q_num" name="qInput_'+j+'" value="0"/>'
				tr += '</td>';
			}
			tr += '<th><a class="dcount">0</a></th>';
			tr += '</tr>';
		$('#tbody').append(tr);
	}
	var trCount = '<tr id="qtcount">';//
	trCount += '<td></td>';
	for(var i=0;i<qtids.length;i++){
		trCount += '<th><a class="qtcount qtcount_'+i+'">0</a></th>'
	}
	trCount += '<th><a class="count">0</a></th>';//count最后合计
	trCount += '</tr>';
	$('#tbody').append(trCount);
	
	getEachBlock();
	appendThemeButton();
}

function cancel(){
	window.location.href="${pageContext.request.contextPath}/paper/cancelDifficultyPaper?eid=${ei_id}";
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



$('#forbidDay').tooltip({
    position: 'bottom',
    content: '<span style="color: rgb(255, 255, 255);">0表示不做筛选；如果输入值大于系统设置参数，则默认按照系统参数查找题目。当前系统设置为：“不使用'+question_used_day+'天内考过的试题！”</span>',
    onShow: function(){
        alert(1);
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
        alert(2);
        $(this).tooltip('tip').css({
            backgroundColor: '#666',
            borderColor: '#666',
        });
    }
});


</script>

