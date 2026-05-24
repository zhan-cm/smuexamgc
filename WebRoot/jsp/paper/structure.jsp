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
		background:#008888 !important;
	}
	.cancelLimit_3{
		color:white !important;
		border-color:white !important;
		background:#668800 !important;
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
		font-size:12px;
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
		text-align: center
	}
	#head {
		position: fixed;
		display:block;
		top: 0px;
		z-index: 5;
		background: white;
	}
	#main {
		position: relative;
		z-index: 1;
		margin-top:18px;
		background: white;
	}
	.even-tr{
		background: #F4F3EE;
	}
	.bottom-tr{
		border-bottom: solid #98C3F0 3px;
	}
</style>
<%-- <form id="structureForm" method="post" action="${pageContext.request.contextPath}/paper/structure"> --%>
<form id="structureForm" method="post" action="${pageContext.request.contextPath}/paper/structure">
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>
	<input type="hidden" name="c_id" id="c_id"  value="${c_id}"/>
	<input type="hidden" name="questionNum" id="questionNum"/>
	<input type="hidden" name="qtscore" id="qtscore"/>
	<input type="hidden" name="buildWay" id="buildWay" value="${buildWay}"/>
	<!-- 	<input type="button" onclick="window.location.reload()"/> -->
	<div class="tipsBlock"></div>

	<h1 style="color:red;text-align:center;width:100%;font-size:18px;">距离重新登录时间还有<span id="time" style="font-size:18px;"></span>，请在重新登录前保存要添加的题目</h1>
	<!-- 	双向细目表模板： -->
	<!-- 	<select id="template" onchange="changeCheckList()" style="width:200px;height:23px;margin-bottom:8px;"> -->
	<!-- 		<option>请选择模板</option> -->
	<!-- 	</select> -->
	<p>不选用
		<input type='text' id='forbidDay' name='forbidDay' value="${forbidDay}"  style='width:80px'/>天之内考过的试题，不选用使用过<input type='text' id='forbidNum' name='forbidNum' value="${forbidNum}"  style='width:80px'/>次及以上的试题，
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
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="cancelCommonPaper(${ei_id})">取消组卷</a>
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
     * 2、提交下一步，cookier() 保存questionNum set questionNum
     * 3、返回时加载 loader()
     */
    var title=parent.$('#nav_tab').tabs('getSelected').panel('options').title;//获取当前选中tabs标题
    var questionNum = '';

    var back = sessionStorage.getItem(title+'-back')=='null'?'':sessionStorage.getItem(title+'-back');

    function cookierback(){ //加载初始数据前
        if(back=='1'){//赋分页面点击返回
            questionNum = sessionStorage.getItem(title+'-questionNum')=='null'?'':sessionStorage.getItem(title+'-questionNum'); //cookie空值返回null字符串
            sessionStorage.setItem(title+'-back',null);
            console.log(questionNum);
        }else{
            sessionStorage.setItem(title+'-questionNum',null);
        }
    }

    function cookier(){
        var questionNum = getQuestionNum();
        sessionStorage.setItem(title+'-questionNum',questionNum);
        sessionStorage.setItem(title+"-back",null);
    }

    function loader(cid){
		var themeData;
        $.ajax({
            url: "${pageContext.request.contextPath}/paper/getAllTheme_cid",
            async: false,
            type: "POST",
            data: {"cid": cid},
            success: function (data) {
				themeData=data;
            }
        });
        if(back=='1'){
            var table = $("#cid_"+cid+"");
            table.find(".qtnum").val("");
            table.find(".qnum").val("");
            closeAllTh2limit();

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
                        	th2limit($("#th_"+pid+""),cid);
                        }                        
                    }
                }else if(tlevel==3){
                    pid = data[i].qthid_parent;
                    for(var j=0;j<themeData.length;j++){
                        if(pid==themeData[j].ID){
                            ppid=themeData[j].PID;
                            if($("#th_"+ppid+"").text()=='限定二级'){
                            	th2limit($("#th_"+ppid+""),cid);
                            }                            
                            break;
                        }
                    }
                    if($("#th_"+pid+"").text()=='限定三级'){
                    	th3limit($("#th_"+pid+""),cid);
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
    /*------------------------------------*/

    $(document).ready(function(){
        cookierback();
        var cid = $("#c_id").val();
        var eid = $("#ei_id").val();
        var buildWay = $("#buildWay").val();
        
        initTable(cid,$("#datalist"));

        if(buildWay==1){//证明请求从“重新组卷”进来的，执行双向细目表模板
            autoChangeCheckList(cid,eid);
        }
        if(back == '1'){
            //渲染数据
            loader(cid);
        }
    });

    function questionFilter(){
        var cids = $("#c_id").val().split(",");
        for(var i=0;i<cids.length;i++){
            updateTable(getTableData(cids[i],1));
        }
    }

    function getTableData(cid,way){
        //way用来区分是从组卷进入页面调用还是点击查询调用,1:击查询调用
        var rs = '';
        var forbidDay = $("#forbidDay").val()==undefined||$("#forbidDay").val()=="" ? question_used_day : $("#forbidDay").val();
        var forbidNum = $("#forbidNum").val()==undefined||$("#forbidNum").val()=="" ? question_use_time : $("#forbidNum").val();
        var isVerified = $("#isVerified").val();

        $.ajax({
            url:"${pageContext.request.contextPath}/paper/getStructureMes",
            async:false,
            type:"POST",
            data:{"cid":cid,"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
            success:function(data){
                if (data!=null){
                    rs = data;
                    if (way == 1 ){
                        toastr.success('查询成功！');
                    }
                } else{
                    toastr.error('查询失败，请联系管理员！');
                }
            }
        });
        return rs;
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
                win += '<input type="hidden" class="qthid" value="'+thList[j].ID+'"/>'
                win += '<input type="hidden" class="qthid_parent" value="-1"/>'
                win += '<input type="hidden" class="qtid" value="'+qtList[k].QTID+'"/>'
                win += '<input type="hidden" class="iscon" value="'+qtList[k].ISCON+'"/>'
                win += '<input type="hidden" class="thlevel" value="1"/>'
                if(num==0){
                    win += '<input type="text" class="qnum" disabled="disabled"/>'
                }else{
                    win += '<input type="text" class="qnum" />'
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
        diffFilter(data.difficultyDistribution,elt2);
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

    function initTable(cid,elt){
        var cid = cid.split(",");
        for(var i=0;i<cid.length;i++){
            var win = '';
            var data = getTableData(cid[i]);
            win += '<p>双向细目表模板：<select id="template" onchange="changeCheckList('+cid+')" style="width:200px;height:23px;margin-bottom:8px;">'
            win += '<option>请选择模板</option></select></p>';
            win += "<table id='cid_"+cid[i]+"'></table>";
            win += "<div id='diff_"+cid[i]+"'></div>"
            $(elt).append(win);
            getTemplate(cid[i]);//获取双向细目表模板
            updateTable(data);
        }

    }

    function diffFilter(data,elt){
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
        win += '<p>难度分布简单:<input disabled="disabled" name="sdiff" type="text" value="'+(d1*100/dtotal).toFixed(0)+'"/>%,';
        win += '中等:<input name="mdiff" type="text" disabled="disabled" value="'+(d2*100/dtotal).toFixed(0)+'"/>%,';
        win += '较难:<input name="ddiff" type="text" disabled="disabled" value="'+(d3*100/dtotal).toFixed(0)+'"/>%</p>';
        win += '<p>当前题库共有满足条件的试题'+dtotal+'道，其中简单题'+d1+'道,占'+(d1*100/dtotal).toFixed(2)+'%;中等题'+d2+'道,占'+(d2*100/dtotal).toFixed(2)+'%;较难题'+d3+'道,占'+(d3*100/dtotal).toFixed(2)+'%</p>';
        $(elt).append(win);
    }

    function getTemplate(cid){
        $.ajax({
            url: "${pageContext.request.contextPath}/paper/getTemplateByCid",
            async: false,
            type: "POST",
            data: {"cid":cid},
            success: function(data){
                for(var i=0;i<data.length;i++){
                    $('#template').append('<option value="'+data[i]+'">'+data[i]+'</option>');
                }
            }
        })
    }

    var time = 1800;//设定倒计时半小时
    setTime();

    var tds = $('#main').find('tr:first').find('td');
    $(tds).css('border-top','none');
    var headtds = $('#head').find('tr').find('td');
    for(var i=0; i<tds.length; i++){
        $(headtds[i]).width($(tds[i]).width()+1)
    }

    function closeAllTh2limit(){
        $.each($(".qtr"),function(i,item){
            var th2limit = $(item).find(".th2limit");
            if($(th2limit).text()=='取消限定'){
                var thtd = $(".thtd").has(th2limit);
                var tr = $("tr").has(thtd);
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
                $('#qnBlock').find('input[type="text"]').val(null);
                $('#qcBlock').find('input[type="text"]').val(null);
            }
        });
    }

    function getTotal(){
        var qtotal = 0;
        $.each($(".qtnum"),function(i,item){
            if($(item).val()){
                qtotal += parseInt($(item).val());
            }
        });
        $('.qtamount').val(qtotal);
    }

    function getTotalScore(){
        var qtotal = 0;
        $.each($(".qtscoreblock"),function(i,item){
            var num = Number($(".qtnumblock").find(".qtnum").eq(i).val());
            var score = Number($(item).find(".qtscore").val());
            if (isNaN(num)||isNaN(score))  return;
            qtotal += num*score;
        });
        $('.qtscoreCount').val(qtotal);
    }

    function qnumfun(item,t){
    	var thlevel=$(item).find(".thlevel").val();
    	var qthid_l1;
    	var qtid=$(item).find(".qtid").val();
    	if(thlevel==2){
    		qthid_l1=$(item).find(".qthid_parent").val();
    	}
    	if(thlevel==3){
    		qthid_l1=$(item).find(".qthid1_parent").val();
    	}
    	var qthid=$(item).find(".qthid_parent").val();
    	
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
            var qth_res=0;
            for(var i=0;i<$("tr").find(str).length;i++){
                var o = $($("tr").find(str)[i]);
                if(o.find(".qthid_parent").val()==qthid){
                	if(!isNaN(parseInt(o.find(".qnum").val())))
                		qth_res += parseInt(o.find(".qnum").val());
                }
                if(o.hasClass("qblock")){
                    if(!isNaN(parseInt(o.find(".qnum").val()))&& !(o.find(".qnum").is(":disabled")))
                        res += parseInt(o.find(".qnum").val());
                }
            }
            str1 = ".qtnum:eq(" + (index-1) + ")";
            $(str1).val(res);
            getTotal();
            getTotalScore();
            qnumfun_l1(qthid_l1,index);
        }
    }
    
    function qnumfun_l1(qthid,index){
    	var qnum=0;
    	$("tr").find("td:eq("+index+")").find(".qthid_parent").each(function(index,item){
    		if($(this).val()==qthid){
    			if(!isNaN(parseInt($(this).parent().find(".qnum").val()))){
    				qnum+= parseInt($(this).parent().find(".qnum").val());
    			}
    		}
    	})
    	$("tr").find("td:eq("+index+")").find(".qthid1_parent").each(function(index,item){
    		if($(this).val()==qthid){
    			if(!isNaN(parseInt($(this).parent().find(".qnum").val()))){
    				qnum+= parseInt($(this).parent().find(".qnum").val());
    			}
    		}
    	})
    	$("tr").find("td:eq("+index+")").find(".qthid").each(function(){
    		if($(this).val()==qthid){
    			$(this).parent().find(".qnum").val(qnum);
    		}
    	})
    }

    function getQuestionNum(){
        var postdata = new Array();
        var j=0;
        $.each($(".qblock"),function(i,item){
            var v = $(item).find(".qamount").text();//系统内的题目数量
            if(v != 0){
				if($(item).find(".qnum").val()!=null
						&& $(item).find(".qnum").val()!=undefined
						&& $(item).find(".qnum").val()!=""
						&& $(item).find(".qnum").val()!="undefined"
						&& $(item).find(".qnum").val()!=0
						&& $(item).find(".qnum").val()!="0"
						&& !($(item).find(".qnum").is(":disabled"))){
                    postdata[j] = {
                        "qnum": $(item).find(".qnum").val(),//输入的题目数
                        "qthid": $(item).find(".qthid").val(),//主题词id
                        "qthid_parent": $(item).find(".qthid_parent").val(),//父主题词id
                        "qtid": $(item).find(".qtid").val(),//题型id
                        "thlevel": $(item).find(".thlevel").val(),//第几级主题词
                        "iscon": $(item).find(".iscon").val()//是否是串题
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

    function submitForm(){
        cookier();//保存题目数

        $("#forbidDayforbidDay").val($("#forbidDay").val());
        $("#question_use_time").val($("#forbidNum").val());
        var questionNum = getQuestionNum();
        if(questionNum=='[]'){
            toastr.warning("您没有选择任何题目！");
            return false;
        }
        toastr.warning("生成试卷的过程可能耗时比较久，请耐心等候！");
        var qtscore = getQtScore();
        $("#questionNum").val(questionNum) ;
        $("#qtscore").val(qtscore);
        $('#structureForm').submit();//并且删除重新组卷时保存的双向细目表模板

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

    function th2limit(elt,cid){//elt: thpid 一级主题词id
        if($(elt).text()=='限定二级'){
            var thtd = $(".thtd").has(elt);
            var thid_parent=thtd.find(".th1id").val();
            var tr = $("tr").has(thtd);
            tr.find('.qnum').each(function(i,item){
                var qnum = Number($(item).val());
                var qtnum = $($(".qtnum")[i]);
                qtnum.val(Number(qtnum.val()) - qnum);
            });
            tr.has(elt).find('.themeCount').text('');

            var forbidDay = typeof($("#forbidDay").val())!="undefined" ? $("#forbidDay").val() : "";
            var forbidNum = typeof($("#forbidNum").val())!="undefined" ? $("#forbidNum").val() : "";
            var isVerified = typeof($("#isVerified").val()) != "undefined" ? $("#isVerified").val() : 0;
            $.ajax({
                url: "${pageContext.request.contextPath}/paper/getQuestionTypeInfo",
                async: false,
                type: "POST",
                data: {"t2t3":"2","c_id": cid, "th_id": thid_parent,"eid":$("#ei_id").val(),"forbidDay":forbidDay,"forbidNum":forbidNum,"isVerified":isVerified},
                success: function (data) {
                    qtInfo = data.qtInfo;
                    var r;
                    var trA = tr.has("td:first").has("a");
                    var trA_Qtid = trA.find('.qtid');

                    if(qtInfo.length > 0){
                        for(var i=0;i<qtInfo.length;i++){
                            thid = qtInfo[i].THID;//二级的主题词id
                            thname = qtInfo[i].THNAME;//二级的主题词名称
                        	tr.find('.qnum').val(null);
                            r = tr.clone();
                            r.data("thid", thid_parent);
                            var aHtml='<a class="th3limit" id="th_'+thid+'" href="javascript:void(0);" onclick="th3limit(this,'+cid+')">限定三级</a>';
                            r.find(".th2limit").replaceWith(aHtml);
                            r.find(".qnum").attr({disabled:'disabled',value:null});
                            r.find(".thlevel").val("2");
                            r.find(".qamount").text(0);
                            r.find(".th_name").text(thname);
                            r.find(".th1id").attr("id","tr_"+thid+"");
                            r.find(".th1id").val(thid);
                            r.find(".qthid").val(thid);
                            r.find(".qthid_parent").val(thid_parent);
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
                    tr.find(".th2limit").text('取消限定二级');
                    tr.find(".th2limit").addClass('cancelLimit');
                }
            });
        }else if($(elt).text()=='取消限定二级'){
            var thtd = $(".thtd").has(elt);
            var tr = $("tr").has(thtd);
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
            tr.find(".th2limit").removeClass('cancelLimit');
            $(elt).text('限定二级');
        }
        getTotal();
        getTotalScore();
    }

    function th3limit(elt,cid){
        if($(elt).text()=='限定三级'){
            var thtd = $(".thtd").has(elt);
            var thid_parent=thtd.find(".th1id").val();
            var thid1_parent=thtd.next().find(".qthid_parent").val();
            
            var tr = $("tr").has(thtd);
            var last=false;
            if(tr.hasClass("bottom-tr")){
            	last=true;
            }
            tr.removeClass("bottom-tr");
            tr.find('.qnum').each(function(i,item){
                var qnum = Number($(item).val());
                var qtnum = $($(".qtnum")[i]);
                qtnum.val(Number(qtnum.val()) - qnum);
                
                $("tr").find(".qblock:eq("+i+")").each(function(){
                	if($(this).find(".qthid").val()==thid1_parent){
                		if(qnum>0){
                			var nn=Number($(this).find(".qnum").val()) - qnum;
                			if(nn<=0){
                				$(this).find(".qnum").val("");
                			}else{
                				$(this).find(".qnum").val(nn);
                			}
                			
                		}                        
                	}
                })
            });

            var forbidDay = typeof($("#forbidDay").val())!="undefined" ? $("#forbidDay").val() : "";
            var forbidNum = typeof($("#forbidNum").val())!="undefined" ? $("#forbidNum").val() : "";
            var isVerified = typeof($("#isVerified").val()) != "undefined" ? $("#isVerified").val() : 0;
            $('.qtr').has(elt).find('.themeCount').text('');
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
                            tr.find(".qnum").val(null);
                            var thid1_parent=tr.find(".qthid_parent").val();
                            r = tr.clone();
                            r.data("thid", thid_parent);
                            r.find(".th3limit").remove();
                            r.find(".qnum").attr({disabled:'disabled',value:null});
                            r.find(".thlevel").val("3");
                            r.find(".qamount").text(0);
                            r.find(".th_name").text(thname);
                            r.find(".qnum").val(null);
                            r.find(".th1id").attr("id","tr_"+thid+"");
                            r.find(".qthid").val(thid);
                            r.find(".qthid_parent").val(thid_parent);
                            r.find("td").append('<input type="hidden" class="qthid1_parent" value="'+thid1_parent+'">')
                            r.removeClass("even-tr");
                            if(i==0&&last){
                                r.addClass("bottom-tr");
                            }

                            var qt=qtInfo[i].qt;//二级的题型
                            for(var j=0;j<qt.length;j++){
                                $.each(r.find(".qtid"),function(i,item){
                                    if($(item).val() == qt[j].QTID){
                                        var v = r.find(".qblock").has($(item));
                                        v.find(".qnum").removeAttr("disabled");
                                        v.find(".qamount").text(qt[j].NUM);
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
                    tr.find(".th3limit").text('取消限定三级');
                    tr.find(".th3limit").addClass('cancelLimit_3');
                }
            });
        }else if($(elt).text()=='取消限定三级'){
            var thtd = $(".thtd").has(elt);
            var tr = $("tr").has(thtd);
            var last=false;
            
            var thid_parent=thtd.find(".th1id").val();
            tr.find('.qnum').each(function(i,item){
                var qnum = Number($(item).val());
                var qtnum = $($(".qtnum")[i]);
                qtnum.val(Number(qtnum.val()) + qnum);
                
                var nn=0;
                $("tr").find(".qblock:eq("+i+")").each(function(){
                	if($(this).find(".qthid_parent").val()==thid_parent){
                		if(Number($(this).find(".qnum").val())>0){
                			nn+=Number($(this).find(".qnum").val());
                		}
                		if($(this).parent().hasClass("bottom-tr")){
                			last=true;
                		}
                	}
                })
                if(nn>0){
                	$(item).val(nn);
                }
            });
            var thnum=0;
            tr.find('.qnum').each(function(){
            	thnum+=Number($(this).val());
            });
            if(thnum>0){
            	tr.find(".themeCount").text(thnum);
            }
           
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
            tr.find(".th3limit").removeClass('cancelLimit_3');
            if(last){
            	tr.addClass("bottom-tr");
            }            
            $(elt).text('限定三级');
        }
        getTotal();
        getTotalScore();
    }

    //选用模版后调用的方法，查询数据库得到模版渲染回页面
    function changeCheckList(cid){
        var table = $("#cid_"+cid+"");
        table.find(".qtnum").val("");
        table.find(".qnum").val("");
        closeAllTh2limit();
        var name = $("#template").val();
        var pid = '';
        $.ajax({
            url: '${pageContext.request.contextPath}/paper/getTemplateDetail',
            async: false,
            type: 'POST',
            data: {"cid":cid,"name":name},
            success: function(data){
                for(var i=0;i<data.length;i++){
                    var tlevel = data[i].THLEVEL;//第几级主题词
					//如果是二级主题词,给二级主题词绑定pid,限定二级主题词；若是一级主题词pid=-1
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
                        if(data[i].QTID==qtid){//questionType
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
        })
    }

    function autoChangeCheckList(cid,eid){
        var table = $("#cid_"+cid+"");
        table.find(".qtnum").val("");
        table.find(".qnum").val("");
        closeAllTh2limit();
        var name = eid;

        var pid = '';
        $.ajax({
            url: '${pageContext.request.contextPath}/paper/getTemplateDetail?',
            async: false,
            type: 'POST',
            data: {"cid":cid,"name":name},
            success: function(data){
                for(var i=0;i<data.length;i++){
                    var tlevel = data[i].THLEVEL;//第几级主题词
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

                //删除双向细目表
                $.ajax({
                    url: '${pageContext.request.contextPath}/paper/deleteTemplateDetail?',
                    async: false,
                    type: 'POST',
                    data: {"name":name},
                    success: function(data){
                        if(data==null){
                            toastr.warning("重新组卷失败，请联系管理员");
                        }
                    }
                })
            }
        });
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

    function cancelCommonPaper(eid){
        sessionStorage.setItem(title+'-questionNum',null);
        var url ="${pageContext.request.contextPath}/paper/cancelCommonPaper?eid="+eid;
        window.location.href = url;
    }

</script>

