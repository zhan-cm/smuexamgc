<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.qnum, .qtnum, .qtamount, .qtscore, .qtallscore, .qtscoreCount{
	width:34px;
	/* border:1px solid #ccc; */
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	text-align: center;
}
.cancelLimit{
	color:white !important;
	border-color:white !important;
	background:grey !important;
}
.th2limit{
	background: #eaf2ff;
	color: #000000;
	border: 1px solid #b7d2ff;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	padding:3px 5px;
	text-decoration:none; 
}
.th3limit{
	background: #CCFFCC;
	color: #000000;
	border: 1px solid #b7d2ff;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	padding:3px 5px;
	text-decoration:none;
}
.qamount{
	margin-left: 8px;
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
.title{
	font-weight: bolder; 
	text-align: center;
	margin-top:10px;
}
table{
	margin-top:5px;
}
.even-tr{
	background: #F4F3EE;
}
.bottom-tr{
	border-bottom: solid #98C3F0 3px;
}
</style>

<!-- <input type="button" onclick="window.location.reload()"/> -->

<%-- <form id="structureForm" method="post" action="${pageContext.request.contextPath}/paper/structure"> --%>
<form id="structureForm" method="post" action="${pageContext.request.contextPath}/paper/multiCourseStructure">	
	
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>
	<input type="hidden" name="c_id" id="c_id"  value="${c_id}"/>
	<input type="hidden" name="questionNum" id="questionNum"/>
	<input type="hidden" name="difficultyNum" id="difficultyNum">
	<input type="hidden" name="qtscore" id="qtscore"/>
	<!-- <input type="hidden" name="question_use_time" id="question_use_time"  value="${question_use_time}"/>
	<input type="hidden" name="question_used_day" id="question_used_day"  value="${question_used_day}"/>
	<input type="hidden" name="limit4Isreview" id="limit4Isreview"  value="${limit4Isreview}"/> -->
	<input type="hidden" name="buildWay" id="buildWay" value="${buildWay}"/>
	<div class="tipsBlock"></div>
	
<!-- 	<h1 style="color:red;text-align:center;width:100%;font-size:18px;">距离重新登录时间还有<span id="time" style="font-size:18px;"></span>，请在重新登录前保存要添加的题目</h1> -->
	
	<p>不选用
		<input type='text' class="queLimit" id='forbidDay' name='forbidDay' style='width:80px' value="${forbidDay}"/>天之内考过的试题，不选用使用过<input type='text' class="queLimit" id='forbidNum' name='forbidNum' style='width:80px' value="${forbidNum}"/>次及以上的试题，
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
		</c:choose>		
		试题&nbsp;
		<input type='button' value='确定' onclick='questionFilter()'/>
	</p>
	<div id="datalist"></div>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
	<c:if test="${mobile == 1 }">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="${pageContext.request.contextPath}/evaluation/cancelCommonPaper?eid=${ei_id}">取消组卷</a>
	</c:if>
	<c:if test="${mobile != 1 }">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="${pageContext.request.contextPath}/paper/cancelMultiPaper?eid=${ei_id}">取消组卷</a>
	</c:if>

	<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="window.history.go(-1);return false;">返回</a>  -->
	<%-- <a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="${pageContext.request.contextPath}/paper/cancelStructure?cid=${c_id}&eid=${ei_id}&way=0" >返回</a>  --%>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
    var question_used_day=$("#forbidDay").val();
    var question_use_time=$("#forbidNum").val();

    /*------------------------------------*/
    /*
     * 1、初始加载，  cookierback() set back  questionNum null  or value
     * 2、提交下一步，cookier() 保存questionNum set questionNum 清空back
     * 3、返回时加载 loader()
     */
    var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
    var questionNum = '';

    var back = sessionStorage.getItem(title+'-back')=='null'?'':sessionStorage.getItem(title+'-back');

    //加载初始数据前
    function cookierback(){
        if(back=='1'){//赋分页面点击返回
            questionNum = sessionStorage.getItem(title+'-questionNum')=='null'?'':sessionStorage.getItem(title+'-questionNum');
        }else{
            sessionStorage.setItem(title+'-questionNum',null);
        }
    }

    //提交下一步，保存题目数
    function cookier(){
        var questionNum = getQuestionNum();
        sessionStorage.setItem(title+'-questionNum',questionNum);
        sessionStorage.setItem(title+"-back",null);
    }

	////返回，数据渲染
    function loader(cids){
        if(back=='1'){
            var cid = cids.split(",");
            for (var n=0;n<cid.length;n++){
                var themeData;
                $.ajax({
                    url: "${pageContext.request.contextPath}/paper/getAllTheme_cid",
                    async: false,
                    type: "POST",
                    data: {"cid": cid[n]},
                    success: function (data) {
                        themeData=data;
                    }
                });
                var table = $("#cid_"+cid[n]+"");
                table.find(".qtnum").val("");
                table.find(".qnum").val("");
                closeAllTh2limit(table);
                var pid = '';
                title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
                var data = JSON.parse(sessionStorage.getItem(title+'-questionNum'));
                for(var i=0;i<data.length;i++){
                    var tlevel = parseInt(data[i].thlevel);//第几级主题词 thlevel
                    var questionCount=parseInt(data[i].qnum);
                    //如果是二级主题词,给二级主题词绑定pid,限定二级主题词；若是一级主题词pid=-1
                    if(tlevel==2){
                        if(pid != data[i].qthid_parent){
                            pid = data[i].qthid_parent;
                            if($("#th_"+pid+"").text()=='限定二级'){
                            	th2limit($("#th_"+pid+""),cid[n]);
                            }                            
                        }
                    }else if(tlevel==3){
                        pid = data[i].qthid_parent;
                        for(var j=0;j<themeData.length;j++){
                            if(pid==themeData[j].ID){
                                ppid=themeData[j].PID;
                                if($("#th_"+ppid+"").text()=='限定二级'){
                                	th2limit($("#th_"+ppid+""),cid[n]);
                                }                                
                                break;
                            }
                        }
                        if($("#th_"+pid+"").text()=='限定三级'){
                        	th3limit($("#th_"+pid+""),cid[n]);
                        }                        
                    }
                    //.qtr= tr
                    var qblock = table.find(".qtr").has($("#tr_"+data[i].qthid+"")).find('.qblock');
                    $(qblock).each(function(){
                        var qtid = $(this).find(".qtid").val();
                        var qnum = $(this).find(".qnum");
                        var qamount = $(this).find(".qamount").text();
                        if(data[i].qtid==qtid){//questionType
                            if(qamount < questionCount){
                                qnum.val(qamount);
                            }else{
                                qnum.val(questionCount);
                            }
                        }
                    });
                }
                var count = 0;
                $.each(table.find(".qtr"),function(i,item){
                    var thCount = 0;
                    var qblock = $(item).find(".qblock");
                    $(qblock).each(function(){
                        if($(this).find(".qnum").val()!=""){
                            var qtid = $(this).find(".qtid").val();
                            var num = Number($(this).find(".qnum").val());
                            var qtCount = $("#qtCount_"+qtid+"");
                            var qtnum = Number(qtCount.val()) + num;
                            qtCount.val(qtnum);
                            thCount += num;
                        }
                    })
                    $(item).find(".themeCount").text(thCount);
                    count += thCount;
                });
                table.find('.qtamount').val(count);

                var qtScore = 0;
                $.each(table.find(".qtscoreblock"),function(i,item){
                    qtScore += Number($(item).find(".qtscore").val()) * Number($($(".qtnum")[i]).val());
                });
                table.find(".qtscoreCount").val(qtScore);
            }
			}
    }
    /*------------------------------------*/

$(document).ready(function(){
	var cid = $("#c_id").val();
    cookierback();
	initTable(cid,$("#datalist"));
    if(back == '1'){
        //渲染数据
        loader(cid);
    }
    // 	$(".qtnum").each(function(){
// 		var table_elt=$(this).parent().parent().parent();
// 	     var td_index=$(this).parent().index();
// 	     var tr_index=$(this).parent().parent().index();

// 	     var qnum=0;
// 	     for(var i=0;i<tr_index;i++){
// 	     	var n=table_elt.find("tr").eq(i).find("td").eq(td_index).find(".qnum").val();
// 	     	if(n!=""&&typeof(n)!="undefined"){
// 	     		qnum+=parseInt(n);
// 	     	}
// 	     }
// 	     $(this).val(qnum);
// 	});

// 	$('.qtamount').each(function(){
// 		var table_elt=$(this).parent().parent();
// 		var qtotal = 0;
// 		table_elt.find(".qtnum").each(function(i,item){
// 			if($(item).val()){
// 				qtotal += parseInt($(item).val());
// 			}
// 		});
// 		$(this).val(qtotal);
// 	});
});

function initTable(cid,elt){
	var cid = cid.split(",");
	for(var i=0;i<cid.length;i++){
		var win = '';
		var data = getTableData(cid[i]);
		win += '<div class="title">'+data.cname+'</div>';
		win += '<p>双向细目表模板：<select id="template_'+cid[i]+'" onchange="changeCheckList('+cid[i]+')" style="width:200px;height:23px;margin-bottom:8px;">'
		win += '<option>请选择模板</option></select></p>';
		win += "<table id='cid_"+cid[i]+"' name='"+cid[i]+"'></table>";
		win += "<div id='diff_"+cid[i]+"' class='difficultyList'></div>"
		$(elt).append(win);
		getTemplate(cid[i]);
		updateTable(data);
	}
	
}


function questionFilter(){
	var cids = $("#c_id").val().split(",");
	for(var i=0;i<cids.length;i++){
		updateTable(getTableData(cids[i],i+1,cids.length));
	}
}

function updateTable(data){
	var cid = data.cid;
	var elt = '#cid_'+cid;
	var elt2 = '#diff_'+cid;
	$(elt).html(null);
	$(elt2).html(null);
	var thList = data.themeList;
	var qtList = data.questionTypeList;
	var res = data.distributionStatistics;
	var diffList = data.difficultyDistribution;
	var win = '';
	win += "<tr style='height:36px'><td class='title'>主题词\题型</td>";
	for(var k=0;k<qtList.length;k++){
		win += "<td class='title'>"+qtList[k].QTNAME+"<br>("+qtList[k].QCOUNT+"题)</td>";
	}
	win += "<td style='text-align:center'>合计</td></tr>";
	for(var j=0;j<thList.length;j++){
		if(j%2==0){
			win += '<tr class="qtr even-tr">';
		}else{
			win += '<tr class="qtr">';
		}
		win += '<td class="thtd"><a class="th2limit" id="th_'+thList[j].ID+'" href="javascript:void(0);" onclick="th2limit(this,'+cid+')">限定二级</a>';
		win += '<span class="th_name">'+thList[j].NAME+'</span>'
		win += '<input type="hidden" class="th1id" id="tr_'+thList[j].ID+'" value="'+thList[j].ID+'"/>';
		win += '<input type="hidden" class="cid" value="'+cid+'"/>'
		win += '</td>'
		for(var k=0;k<qtList.length;k++){
			var num = 0;
			for(var l=0;l<res.length;l++){
				if(res[l].QTID==qtList[k].QTID && res[l].THID==thList[j].ID){
					num = res[l].NUM;
					break;
				}
			}
			win += '<td class="qblock">'
			win += '<input type="hidden" class="cid" value = "'+cid+'"/>'
			win += '<input type="hidden" class="qthid" value="'+thList[j].ID+'"/>'
			win += '<input type="hidden" class="qthid_parent" value="-1"/>'
			win += '<input type="hidden" class="qtid" value="'+qtList[k].QTID+'"/>'
			win += '<input type="hidden" class="iscon" value="'+qtList[k].ISCON+'"/>'
			win += '<input type="hidden" class="thlevel" value="1"/>'
			if(num==0){
				win += '<input type="text" class="qnum" disabled="disabled"/>'
			}else{
				win += '<input type="text" class="qnum"/>'
			}
			win += '<span class="qamount">'+num+'</span>'
			win += '</td>'
		}
		win += '<td class="themeCount" style="text-align: center"></td></tr>'
	}
	win += '<tr id="qnBlock"><td>题目数量合计</td>';
	for(var k=0;k<qtList.length;k++){
		win += '<td class="qtnumblock"><input type="text" class="qtnum" id="qtCount_'+qtList[k].QTID+'" value="0" disabled="disabled"/>&nbsp;&nbsp;&nbsp;题</td>'
	}
	win += '<td><input type="text" class="qtamount" disabled="disabled"/>&nbsp;&nbsp;&nbsp;题</td>'
	win += '</tr>'
	win += "<tr id='qnBlock'><td>每题分值</td>"
	for(var k=0;k<qtList.length;k++){
		win += "<td class='qtscoreblock'>";
			win += "<input type='text' class='qtscore' value='0'/>&nbsp;&nbsp;&nbsp;分"
			win += "<input type='hidden' class='qtid' value = '"+qtList[k].QTID+"_"+qtList[k].ATID+"_"+qtList[k].ISCON+"'/>"
		win += "</td>";
	}
	win +='<td><input type="text" class="qtscoreCount" disabled="disabled"/>&nbsp;&nbsp;&nbsp;分</td></tr>'
	$(elt).append(win);
	diffFilter(data.difficultyDistribution,elt2,cid);
	$.each($(elt).find(".qblock"),function(i,item){
		$(item).on('input',".qnum",function(){
			qnumfun(item,this);
		});
	});
	
	$.each($(elt).find(".qtscoreblock"),function(i,item){
		$(item).find(".qtscore").on('input',function(){
			getTotalScore();
		});
	});
}

function diffFilter(data,elt,cid){
	var win = '';
	var d1 = 0;
	var d2 = 0;
	var d3 = 0;
	for(var j=0;j<data.length;j++){
		if(data[j].DID==1){
			d1 = data[j].NUM;
		}else if(data[j].DID==2){
			d2 = data[j].NUM;
		}else if(data[j].DID==3){
			d3 = data[j].NUM;
		}
	}
	
	var dtotal = d1 + d2 + d3;
	win += '<p>难度分布简单:<input name="sdiff" class="sdiff" disabled="disabled" type="text" value="'+(d1*100/dtotal).toFixed(0)+'"/>%,';
	win += '中等:<input name="mdiff" class="mdiff" type="text" disabled="disabled" value="'+(d2*100/dtotal).toFixed(0)+'"/>%,';
	win += '较难:<input name="ddiff" class="ddiff" type="text" disabled="disabled" value="'+(d3*100/dtotal).toFixed(0)+'"/>%</p>';
	win += '<input type="hidden" class="cid" value="'+cid+'"/>';
	win += '<p>当前题库共有满足条件的试题'+dtotal+'道，其中简单题'+d1+'道,占'+(d1*100/dtotal).toFixed(0)+'%;中等题'+d2+'道,占'+(d2*100/dtotal).toFixed(2)+'%;较难题'+d3+'道,占'+(d3*100/dtotal).toFixed(2)+'%</p>';
	$(elt).append(win);
}

function getTableData(cid,way,len){
	var rs = '';
	var forbidDay = typeof($("#forbidDay").val())!="undefined" ? $("#forbidDay").val() : "";
	var forbidNum = typeof($("#forbidNum").val())!="undefined" ? $("#forbidNum").val() : "";
	var isVerified = typeof($("#isVerified").val()) != "undefined" ? $("#isVerified").val() : 0;
	$.ajax({
		url:"${pageContext.request.contextPath}/paper/getStructureMes",
		async:false,
		type:"POST",
		data:{"cid":cid,"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
		success:function(data){
			if (data != null && data != ""){
                rs = data;
                if (way!=undefined&&len!=undefined&&way==(len)){
                    toastr.success('查询成功！');
                }
			} else {
                toastr.error('查询失败！请联系管理员');
			    return false;
			}
		}
	});
	return rs;
}

function getTemplate(cid){
	$.ajax({
		url: "${pageContext.request.contextPath}/paper/getTemplateByCid",
		async: false,
		type: "POST",
		data: {"cid":cid},
		success: function(data){
			for(var i=0;i<data.length;i++){
				$('#template_'+cid+'').append('<option value="'+data[i]+'">'+data[i]+'</option>');
			}
		}
	})
}

// var time = 1800;//设定倒计时半小时
// setTime();

var tds = $('#main').find('tr:first').find('td');
$(tds).css('border-top','none');
var headtds = $('#head').find('tr').find('td');
for(var i=0; i<tds.length; i++){
	$(headtds[i]).width($(tds[i]).width()+1)
}

// $.each($(".qblock"),function(i,item){
// 	$(item).find(".qnum").blur(function(){
// 		qnumfun(item,this);
// 	});
// });

// $.each($(".qtscoreblock"),function(i,item){
// 	$(item).find(".qtscore").blur(function(){
// 		getTotalScore($(item).attr("name"));
// 	});
// });

function th2limit(elt,cid){
    var tableElt=$('#cid_'+cid);
	if(tableElt.find(elt).text()=='限定二级'){
		var thtd = tableElt.find(".thtd").has(elt);
		var thid_parent=thtd.find(".th1id").val();
		var tr = tableElt.find("tr").has(thtd);
		tr.find('.qnum').each(function(i,item){
			var qnum = Number($(item).val());
			var qtnum = $($(tableElt.find(".qtnum"))[i]);
			qtnum.val(Number(qtnum.val()) - qnum);
		});
		var forbidDay = typeof($("#forbidDay").val())!="undefined" ? $("#forbidDay").val() : "";
		var forbidNum = typeof($("#forbidNum").val())!="undefined" ? $("#forbidNum").val() : "";
		var isVerified = typeof($("#isVerified").val()) != "undefined" ? $("#isVerified").val() : 0;
        tableElt.find('.qtr').has(elt).find('.themeCount').text('');
		$.ajax({
	       url: "${pageContext.request.contextPath}/paper/getQuestionTypeInfo",
	       async: false, 
	       type: "POST",
	       data: {"t2t3":"2","c_id": cid, "th_id": thid_parent,"eid":$("#ei_id").val(),"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
	       success: function (data) {
	    	   qtInfo = data.qtInfo;
	    	   //themeList = data.themeList;
	    	   var r;
	    	   if(qtInfo.length > 0){
    			   for(var i=0;i<qtInfo.length;i++){
		    		   thid = qtInfo[i].THID;
		    		   thname = qtInfo[i].THNAME;		    		   	    		   
		    		   tr.find('.qnum').val(null);
		    		   r = tr.clone();
		    		   r.data("thid", thid_parent);
                       var aHtml='<a class="th3limit" id="th_'+thid+'" href="javascript:void(0);" onclick="th3limit(this,'+cid+')">限定三级</a>';
                       r.find(".th2limit").replaceWith(aHtml);
		    		   r.find(".qnum").attr({disabled:'disabled', vlaue:null});
		    		   r.find(".thlevel").val("2");
		    		   r.find(".qamount").text(0);
		    		   r.find(".th_name").text(thname);
					   r.find(".th1id").attr("id","tr_"+thid+"");
                       r.find(".th1id").val(thid);
					   r.removeClass("even-tr");
					   if(i==0){
					   		r.addClass("bottom-tr");
					   }
		    		   var qt=qtInfo[i].qt;
    				   for(var j=0;j<qt.length;j++){
    					   $.each(r.find(".qtid"),function(i,item){
	    					   if($(item).val() == qt[j].QTID){
	    						   var v = r.find(".qblock").has($(item));
	    			    		   v.find(".qnum").removeAttr("disabled");
	    			    		   v.find(".qamount").text(qt[j].NUM);
	    			    		   v.find(".qthid").val(qt[j].THID);
	    			    		   v.find(".qthid_parent").val(thid_parent);
	    					   }			    				  
		    			   });
		    		   }
		    		   $(tr).after(r); 
			    	   $.each(r.find(".qblock"),function(i,item){
						   $(item).find(".qnum").on('input',function(){
								qnumfun(item,this);
							});
						});
    			   }
    		   }
    		   tr.find('.qnum').attr('disabled','disabled');
               tableElt.find(elt).text('取消限定二级');
               tableElt.find(elt).addClass('cancelLimit');
    		   // tr.find(".th2limit").text('取消限定二级');
    		   // tr.find(".th2limit").addClass('cancelLimit');
//     		   getTotal();
//     		   getTotalScore();
// 			   $('#qnBlock').find('input[type="text"]').val(null);
// 			   $('#qcBlock').find('input[type="text"]').val(null);
			}
		});
	}else if(tableElt.find(elt).text()=='取消限定二级'){
		var thtd = tableElt.find(".thtd").has(elt);
		var tr = tableElt.find("tr").has(thtd);
		tr.find('.qnum').each(function(i,item){
			var qnum = Number($(item).val());
			var qtnum = $($(tableElt.find(".qtnum"))[i]);
			qtnum.val(Number(qtnum.val()) + qnum);
		});
		thid = thtd.find(".th1id").val();
		$.each(tableElt.find("tr"),function(i,item){
			if($(item).data("thid")==thid){
				$(item).remove();
			} 
		}); 
		var qblock = tr.find('.qblock');
		$.each(tr.find('.qblock'),function(i,item){
			if($(item).find('.qamount').text() > 0){
				$(item).find('.qnum').removeAttr('disabled');
			}
		});
		tr.find(".th2limit").removeClass('cancelLimit');
		$(elt).text('限定二级');
// 		getTotal();
// 		getTotalScore();
// 		$('#qnBlock').find('input[type="text"]').val(null);
// 		$('#qcBlock').find('input[type="text"]').val(null);
	}
}

    function th3limit(elt,cid){
        var tableElt=$('#cid_'+cid);
        if(tableElt.find(elt).text()=='限定三级'){
            var thtd = tableElt.find(".thtd").has(elt);
            var thid_parent=thtd.find(".th1id").val();
            var tr = tableElt.find("tr").has(thtd);//所有行
            tr.find('.qnum').each(function(i,item){
                var qnum = Number($(item).val());
                var qtnum = $($(".qtnum")[i]);
                qtnum.val(Number(qtnum.val()) - qnum);
            });

            var forbidDay = typeof($("#forbidDay").val())!="undefined" ? $("#forbidDay").val() : "";
            var forbidNum = typeof($("#forbidNum").val())!="undefined" ? $("#forbidNum").val() : "";
            var isVerified = typeof($("#isVerified").val()) != "undefined" ? $("#isVerified").val() : 0;
            tableElt.find('.qtr').has(elt).find('.themeCount').text('');
            $.ajax({
                url: "${pageContext.request.contextPath}/paper/getQuestionTypeInfo",
                async: false,
                type: "POST",
                data: {"t2t3":"3","c_id": cid, "th_id": thid_parent,"eid":$("#ei_id").val(),"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
                success: function (data) {
                    qtInfo = data.qtInfo;
                    var r;
                    var trA = tr.has("td:first").has("a");
                    var trA_Qtid = trA.find('.qtid');

                    if(qtInfo.length > 0){
                        for(var i=0;i<qtInfo.length;i++){
                            thid = qtInfo[i].THID;
                            thname = qtInfo[i].THNAME;
                            tr.find('.qnum').val(null);
                            r = tr.clone();
                            r.data("thid", thid_parent);
                            r.find(".th3limit").remove();
                            r.find(".qnum").attr({disabled:'disabled',value:null});
                            r.find(".thlevel").val("3");
                            r.find(".qamount").text(0);
                            r.find(".th_name").text(thname);
                            r.find(".th1id").attr("id","tr_"+thid+"");
                            r.removeClass("even-tr");
                            if(i==0){
                                r.addClass("bottom-tr");
                            }

                            var qt=qtInfo[i].qt;//二级的题型
                            for(var j=0;j<qt.length;j++){
                                $.each(r.find(".qtid"),function(i,item){
                                    if($(item).val() == qt[j].QTID){
                                        var v = r.find(".qblock").has($(item));
                                        v.find(".qnum").removeAttr("disabled");
                                        v.find(".qamount").text(qt[j].NUM);
                                        v.find(".qthid").val(qt[j].THID);
                                        v.find(".qthid_parent").val(thid_parent);
                                    }
                                });
                            }
                            $(tr).after(r);
                            $.each(r.find(".qblock"),function(i,item){
                                $(item).find(".qnum").on('input',function(){
                                    qnumfun(item,this);
                                });
                            });
                        }
                    }
                    tr.find('.qnum').attr('disabled','disabled');
                    tableElt.find(elt).text('取消限定三级');
                    tableElt.find(elt).addClass('cancelLimit');
                    // tr.find(".th3limit").text('取消限定三级');
                    // tr.find(".th3limit").addClass('cancelLimit');
// 			   $('#qnBlock').find('input[type="text"]').val(null);
// 			   $('#qcBlock').find('input[type="text"]').val(null);
                }
            });
        }else if(tableElt.find(elt).text()=='取消限定三级'){
            var thtd = tableElt.find(".thtd").has(elt);
            var tr = tableElt.find("tr").has(thtd);
            tr.find('.qnum').each(function(i,item){
                var qnum = Number($(item).val());
                var qtnum = $($(".qtnum")[i]);
                qtnum.val(Number(qtnum.val()) + qnum);
            });
            thid = thtd.find(".th1id").val();
            $.each($("tr"),function(i,item){
                if($(item).data("thid")==thid){
                    $(item).remove();
                }
            });
            var qblock = tr.find('.qblock');
            $.each(tr.find('.qblock'),function(i,item){
                if($(item).find('.qamount').text() > 0){
                    $(item).find('.qnum').removeAttr('disabled');
                }
            });
            tableElt.find(elt).removeClass('cancelLimit');
            tableElt.find(elt).text('限定三级');
// 		$('#qnBlock').find('input[type="text"]').val(null);
// 		$('#qcBlock').find('input[type="text"]').val(null);
        }
        getTotal();
        getTotalScore();
    }

function getTotalScore(){
	var table = $('table');
	$.each(table,function(i,item){
		var qtScore = 0;
		var cid = $(item).attr("name");
		var tb = $("#cid_"+cid+"");
		tb.find(".qtscoreblock").each(function(j,it){
			qtScore += Number($(it).find(".qtscore").val()) * Number($($(tb.find(".qtnum"))[j]).val());
		})
		tb.find(".qtscoreCount").val(qtScore);
	})
}
 
function getTotal(){
	var qtotal = 0;
	var table = $('table');
	$.each(table,function(i,it){
		var qtotal = 0;
		var cid = $(it).attr("name");
		var tb = $("#cid_"+cid+"");
		tb.find(".qtnum").each(function(i,item){
			qtotal += Number($(item).val());
		});
		tb.find('.qtamount').val(qtotal);
	});
}


function qnumfun(item,t){
	var cid = $("table").has(item).attr("name");
	var table = $("#cid_"+cid+"");
	a = $(item).find(".qamount").text();
	r = $(t).val();
	if(isNaN(r)){
		toastr.info('请输入数字');
		$(t).val(null);
		return;
	}else{
		if(r > parseInt(a)){
			toastr.info('输入题数不能大于原有题数');
			$(t).val(a);
		}
		var qnums = $('.qtr').has(t).find('.qnum');
		var qnumres = 0;
		for(var i=0; i<qnums.length; i++){
			var num = $(qnums[i]).val();
			if(num){
				qnumres += parseInt(num);
			}				
		}
		$('.qtr').has(t).find('.themeCount').text(qnumres);
		
		index = $(".qblock").has(t).index();
		str = "td:nth-child(" + (index+1) + ")";
		res = 0;
		for(var i=0;i<table.find("tr").find(str).length;i++){
			var o = $(table.find("tr").find(str)[i]);
			if(o.hasClass("qblock")){
				if(!isNaN(parseInt(o.find(".qnum").val())))
				res += parseInt(o.find(".qnum").val());
			}
		}
		str1 = ".qtnum:eq(" + (index-1) + ")";
		table.find(str1).val(res);
		getTotal();
		getTotalScore();			
	} 
} 

function getQuestionNum(){
	var postdata = new Array();
	var j=0;
	$.each($(".qblock"),function(i,item){
		 var v = $(item).find(".qamount").text();		 
		 if(v != 0){
			 if($(item).find(".qnum").val()!=null
					 && $(item).find(".qnum").val()!=undefined
					 && $(item).find(".qnum").val()!=""
					 && $(item).find(".qnum").val()!="undefined"
					 && $(item).find(".qnum").val()!=0
					 && $(item).find(".qnum").val()!="0"){
		         postdata[j] = { 
		        		 "qnum": $(item).find(".qnum").val(), 
		        		 "qthid": $(item).find(".qthid").val(),
		        		 "qthid_parent": $(item).find(".qthid_parent").val(),
		        		 "qtid": $(item).find(".qtid").val(), 
		        		 "thlevel": $(item).find(".thlevel").val(),
		        		 "iscon": $(item).find(".iscon").val(),
		        		 "cid":$(item).find(".cid").val(),
        		 };  
		         ++j;
			 }
		 }       
	});	
	var res = $.toJSON(postdata);
	return res;
}

function getQtScore(){
	var postdata = new Array();
	var j=0;
	$.each($(".qtscoreblock"),function(i,item){
		 postdata[j] = { 
       		 "qtscore": $(item).find(".qtscore").val(), 
       		 "qtid": $(item).find(".qtid").val()
     	};  
        ++j;
	});
	var res = $.toJSON(postdata);
	return res;	
}

function getdifficulty() {
	var postdata = new Array();
	var j=0;
	$.each($(".difficultyList"),function(i,item){
		postdata[j] = {
				"sdiff":$(item).find(".sdiff").val(), 
				"mdiff":$(item).find(".mdiff").val(),
				"ddiff":$(item).find(".ddiff").val(),
				"cid":$(item).find(".cid").val(),
		};
		++j;
	});   
	var res = $.toJSON(postdata);
	return res;
}

function submitForm(){
    cookier();
    sessionStorage.setItem(title+"-back",null);
    //$("#question_used_day").val($("#forbidDay").val());
    //$("#question_use_time").val($("#forbidNum").val());
	var questionNum = getQuestionNum();
	if(questionNum=='[]'){
		toastr.warning("您没有选择任何题目！");
		return false;
	}
	var qtscore = getQtScore();
	var diffcultyNum = getdifficulty();
	$("#questionNum").val(questionNum) ;
	$("#qtscore").val(qtscore);
	$("#difficultyNum").val(diffcultyNum) ;
	$('#structureForm').submit();
	/* location.href = "${pageContext.request.contextPath}/paper/structure?questionNum=" + questionNum
		+ "&ei_id=" + $("#ei_id").val()  
		+ "&c_id=" + $("#c_id").val();  */
}

function closeAllTh2limit(table){
	$.each(table.find(".qtr"),function(i,item){
		var th2limit = $(item).find(".th2limit");
		if($(th2limit).text()=='取消限定'){
			var thtd = $(".thtd").has($(th2limit));
			var tr = $("tr").has(thtd);
			tr.find('.qnum').each(function(i,item){
				var qnum = Number($(item).val());
				var qtnum = $($($('table').find(".qtnum"))[i]);
				qtnum.val(Number(qtnum.val()) + qnum);
			});
			thid = thtd.find(".th1id").val();
			$.each($("tr"),function(i,item){
				if($(item).data("thid")==thid){
					$(item).remove();
				} 
			}); 
			var qblock = tr.find('.qblock');
			$.each(tr.find('.qblock'),function(i,item){
				if($(item).find('.qamount').text() > 0){
					$(item).find('.qnum').removeAttr('disabled');
				}
			});
			tr.find(".th2limit").removeClass('cancelLimit');
			$(th2limit).text('限定二级');
		}
	});
}

function changeCheckList(cid){
	var table = $("#cid_"+cid+"");
	table.find(".qtnum").val("");
	table.find(".qnum").val("");
	closeAllTh2limit(table);
	var name = $("#template_"+cid+"").val();
// 	$("#forbidDay").val("");
// 	$("#forbidNum").val("");
// 	$('#isVerified').val(0);
	var pid = '';
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/getTemplateDetail',
		async: false,
		type: 'POST',
		data: {"cid":cid,"name":name},
		success: function(data){
			for(var i=0;i<data.length;i++){
				var tlevel = data[i].THLEVEL;
				if(tlevel==2){
					if(pid != data[i].PID){
						pid = data[i].PID;
						th2limit($("#th_"+pid+""),cid);
					}
				}
				var qblock = table.find(".qtr").has($("#tr_"+data[i].THID+"")).find('.qblock');
				$(qblock).each(function(){
					var qtid = $(this).find(".qtid").val();
					var qnum = $(this).find(".qnum");
					var qamount = $(this).find(".qamount").text();
					if(data[i].QTID==qtid){
						if(qamount < data[i].NUM){
							qnum.val(qamount);
						}else{
							qnum.val(data[i].NUM);
						}
					}
				})
			}
			var count = 0;
			$.each(table.find(".qtr"),function(i,item){
				var thCount = 0;
				var qblock = $(item).find(".qblock");
				$(qblock).each(function(j,it){
					if($(it).find(".qnum").val()!=""){
						var num = Number($(it).find(".qnum").val());
						var qtnum = $(table.find(".qtnum")[j]);
						qtnum.val(Number(qtnum.val()) + num);
						thCount += num;
					}
				})
				$(item).find(".themeCount").text(thCount);
 				count += thCount;
			});
 			table.find('.qtamount').val(count);
			
 			var qtScore = 0;
			$.each(table.find(".qtscoreblock"),function(i,item){
				qtScore += Number($(item).find(".qtscore").val()) * Number($($(table.find(".qtnum"))[i]).val());
			});
			table.find(".qtscoreCount").val(qtScore);
		}
	})
}


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

// function setTime(){
// 	var h = 0;
// 	var m = 0;
// 	var s = 0;
	
// 	if(time >= 3600){
// 		h = parseInt(time / 3600);
// 		m = parseInt((time % 3600) / 60);
// 		s = (time % 3600) % 60;
// 	}else if(time >= 60){
// 		m = parseInt(time / 60);
// 		s = time % 60;
// 	}else if(time<60 && time >= 0){
// 		s = time;
// 	}
	
// 	if (h > 0) {
// 		$('#time').html(h + '时' + m + '分' + s + '秒');
// 	} else if (m > 0) {
// 		$('#time').html(m + '分' + s + '秒');
// 	} else if (s > -1) {
// 		$('#time').html(s + '秒');
// 	}
	
// 	setTimeout(function(){
// 		setTime();
// 	},1000);
	
// 	time--;
// }
</script>

