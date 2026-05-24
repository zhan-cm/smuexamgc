<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<style>
.qcontent{
	line-height: 1;
	margin: 5px;
	overflow: hidden;
	text-align: justify;
}
.qtname{
	text-align: center;
}
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 3px;
}
td, th {
	padding: 5px;
	line-height: 1;
	vertical-align: center;
	/* border-top: 1px solid #ddd; */
	border: 1px solid #ddd;
}
#addWin{
	text-align: center;
}
#search_name{
	margin: 10px 5px 10px 0;
	font-size: 16px;
	padding: 0;
	line-height: 28px;
}
#addWin a{
	margin: 0 5px;
}
</style>

<div style="width: 100%; height: 40px; text-align: left;line-height: 40px">
	<span style="font-size: 22px;font-weight: bold;display: inline-block;">改卷任务分配</span>
	<!--按班级分配批改任务，不要删 -->
	<span style="display: inline-block; margin-left: 10px">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addTeacher()">添加阅卷人</a>&nbsp;
		<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">返回</a>&nbsp;
	</span>
		<%-- <a class="easyui-linkbutton" data-options="iconCls:'icon-group'" href="${pageContext.request.contextPath}/verify/appoint?cid=${cid}&eid=${eid}&ename=${ename}">权限设置</a>&nbsp; --%>
</div>
<form id="perForm" method="post" >
	<table cellpadding="0" cellspacing="0" style="width:100%;margin-top: 20px;" id="maintable">
		<tr class="pg_tr">
			<td width="100px" align="center">题型</td>
			<td align="center">题目</td>
			<c:forEach var="pr" items="${paperRight}" varStatus="p">
				<td width="100px">
					<label>
						<input class="tid" type="checkbox" value="${pr.TID}" onclick="change(this)"/>${pr.NAME}(${pr.USERNAME})
					</label>
				</td>
			</c:forEach>
		</tr>
		<c:forEach var="sq" items="${subjectiveQuestion}" varStatus="s">
			<tr class="pg_tr">
				<td><div class="qtname">${sq.qtname}</div></td>
				<td>
					<div class="qcontent">${sq.content}</div>
					<input type="hidden" name="qid" value="${sq.qid}"/>
				</td>
				<c:forEach var="pr" items="${paperRight}" varStatus="p">
					<td>
						<label>
							<input class="${pr.TID} correctBox" type="checkbox" name="correctPer" value="${sq.qid},${pr.TID}"/>批改权限
						</label>
					</td>
				</c:forEach>
			</tr>
		</c:forEach>
		<tr class="pg_tr">
			<td></td>
			<td>
				<label>
					<input class="selectAll" type="checkbox"/>改卷审核
				</label>
			</td>
			<c:forEach var="pr" items="${paperRight}" varStatus="p">
				<td>
					<label>
						<input class="reviewBox" type="checkbox" name="reviewPer" value="${pr.TID}"/>审核权限
					</label>
				</td>
			</c:forEach>
		</tr>
		<!-- <tr>
			<td>按班级分配（如不选，默认能批改所有学生的试卷）</td>
			<td>
			</td>
			<c:forEach var="pr" items="${paperRight}" varStatus="p">
				<td>
					<label>
						<c:forEach var="cla" items="${classList}" varStatus="k">
							<input class="${pr.TID} correctCla" type="checkbox" name="correctCla" value="${cla.CLA},${pr.TID}"/>${cla.CLA}
						</c:forEach>
					</label>
				</td>
			</c:forEach>
		</tr> -->
	</table>
	<input type="hidden" value="${cid}" name="cid" id="cid"/>
	<input type="hidden" value="${eid}" name="eid" id="eid"/>
	<input type="hidden" value="${ename}" name="ename" id="ename"/>
	<input type="hidden" value="${url}" name="url"/>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<!--按班级分配批改任务，不要删 -->
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addTeacher()">添加阅卷人</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitForm()">保存</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">返回</a>&nbsp;
	<%-- <a class="easyui-linkbutton" data-options="iconCls:'icon-group'" href="${pageContext.request.contextPath}/verify/appoint?cid=${cid}&eid=${eid}&ename=${ename}">权限设置</a>&nbsp; --%>
 </div>
 <div id="addWin" class="easyui-window" title="添加阅卷人" style="width: 80%; overflow-y: auto; max-height: 100%;">
 	<input type="text" placeholder="输入用户名或实名模糊查询" name="search_name" id="search_name"/>
	<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="findTeacher()">查找</a>
	<a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="sureAddTeacher()">添加阅卷人</a>
</div>

<script type="text/javascript">
$(document).ready(function(){
	$('#addWin').window('close');
	var cid = $('#cid').val();
	var eid = $('#eid').val();
	$.ajax({
        url: "${pageContext.request.contextPath}/verify/getReviewPers",
        async: false,//改为同步方式
        type: "POST",
        data: { "eid": eid},
        success: function (data) {  
        	var correctPers = data.correctPers;
        	var reviewPers = data.reviewPers;
        	if(correctPers){
        		$.each($('.correctBox'),function(i,item){
    				var val = $(item).val();
    				for(var i=0; i<correctPers.length; i++){
    					if(correctPers[i].RES==val){
    						$(item).attr('checked','checked');
    					}
    				}
    			});
        	}        	
        	if(reviewPers){
        		$.each($('.reviewBox'),function(i,item){
    				var val = $(item).val();
    				for(var i=0; i<reviewPers.length; i++){
    					if(reviewPers[i].TID==val){
    						$(item).attr('checked','checked');
    					}
    				}
    			});
        	}        	
 		}
 	});
 	/*按班级分配批改任务，不要删	*/
 	$.ajax({
        url: "${pageContext.request.contextPath}/verify/getTeacherClass",
        async: false,//改为同步方式
        type: "POST",
        data: { "eid": eid},
        success: function (data) {
        	$.each($('.correctCla'),function(i,item){
   				var val = $(item).val();
   				for(var i=0; i<data.length; i++){
   					if((data[i].CLASS+","+data[i].TID)==val){
   						$(item).attr('checked','checked');
   					}
   				}
   			});     	
 		}
 	});
});
function submitForm(){
	$('#perForm').form('submit', {
	    url:'${pageContext.request.contextPath}/verify/addPermission',
	    onSubmit: function(){
	    },
	    success:function(data){
	    	toastr.success("分配成功！");
	    }
	});
}

$('.tid').click(function(){
	var tid = '.' + $(this).val();
	if($(this).attr('checked')){
		$(tid).attr('checked','checked');
	}else{
		$(tid).removeAttr('checked');
	}
}); 

function addTeacher(){
	$('#addWin').find("table").remove();
	$('#addWin').find("#noRecord").remove();
	$('#search_name').bind('keypress',function(event){
         if(event.keyCode == 13){  
             findTeacher();  
         } 
     });
	$('#addWin').window({top:"0px"});
	 $("html,body").animate({scrollTop: "0px"}, 500);
}

function findTeacher(){
	$('#addWin').find("table").remove();
	$('#addWin').find("#noRecord").remove();
	if($("#search_name").val()!=""){
		$.ajax({
	        url: "${pageContext.request.contextPath}/users/getUsersByName",
	        async: false,//改为同步方式
	        type: "POST",
	        data: { "name": $("#search_name").val()},
	        success: function (data) {
	        	if(data!=null&&data!=""&&data.length>0){
	        		var strHtml="<table cellpadding=\"0\" cellspacing=\"0\" style=\"width:100%;margin-top: 10px;\">";
	        		for(var i=0;i<data.length;i++){
	        			strHtml+="<tr>"
	        				+"<td><input type=\"checkbox\" name=\"tname\" value=\""+data[i].ID+"\"/></td>"
	        				+"<td>"+data[i].NAME+"</td>"
	        				+"<td>"+data[i].REAL_NAME+"</td>"
	        				+"<td>"+data[i].DNAME+"</td>";
	        			if(typeof data[i].ENUM=='undefined'){
	        				strHtml+="<td></td>";
	        			}else{
	        				strHtml+="<td>"+data[i].ENUM+"</td>";
	        			}
	        				strHtml+="</tr>";
	        		}
	        		
	        		strHtml+="</table>";
	        		$('#addWin').append(strHtml);
	        		$("input[name='tname']").eq(0).attr("checked","checked");
	        	}else{
        			$('#addWin').append("<div id='noRecord'>根据您输入的内容系统中未找到相关用户，请检查您输入的内容。</div>");
        		}  
	        	  	
	 		}
	 	});	
	}else{
		toastr.warn('请输入用户实名');
	}
}

function sureAddTeacher(){
	//var radio=$("input[name='tname']:checked");
	$("input[name='tname']:checked").each(function(){ 
		var radio=$(this);
    	var tid=$(this).val();
		if(typeof tid=='undefined'){
			return;
		}
		var tname=radio.parent().parent().find("td").eq(2).html();
		var tuser=radio.parent().parent().find("td").eq(1).html();
		tname=tname+"("+tuser+")";
		if($("#maintable").find(".pg_tr").first().find("td").length>2){//起码有一个人批改
			$("#maintable").find(".pg_tr").each(function(index){
				if(index==0){
					$(this).append("<td><label><input class=\"tid\" type=\"checkbox\" value=\""+tid+"\" onclick=\"change(this)\"/>"+tname+"</label></td>");
				}else if(index==$("#maintable").find(".pg_tr").length-1){
                    $(this).append('<td><label><input class="reviewBox" type="checkbox" name="reviewPer" value="'+tid+'"/>审核权限</label></td>');
                }else{
					var str=$(this).find("td").last().find("input[name='correctPer']").val();
					console.log($(this).html());
					var qid=str.split(",")[0];
					$(this).append('<td><label><input class="'+tid+' correctBox" type="checkbox" name="correctPer" value="'+qid+','+tid+'"/>批改权限</label></td>');
				}
			});
			$('.tid').click(function(){
				var tid = '.' + $(this).val();
				if($(this).attr('checked')){
					$(tid).attr('checked','checked');
				}else{
					$(tid).removeAttr('checked');
				}
			}); 
		}else{
			$("#maintable").find(".pg_tr").each(function(index){
				if(index==0){
					$(this).append("<td><label><input class=\"tid\" type=\"checkbox\" value=\""+tid+"\" onclick=\"change(this)\"/>"+tname+"</label></td>");
				}else if(index==$("#maintable").find("tr").length-1){
					$(this).append('<td><label><input class="reviewBox" type="checkbox" name="reviewPer" value="'+tid+'"/>审核权限</label></td>');
				}else{
					var qid=$(this).find("td").eq(1).find("input[name='qid']").val();
					$(this).append('<td><label><input class="'+tid+' correctBox" type="checkbox" name="correctPer" value="'+qid+','+tid+'"/>批改权限</label></td>');
				}
			});
			$('.tid').click(function(){
				var tid = '.' + $(this).val();
				if($(this).attr('checked')){
					$(tid).attr('checked','checked');
				}else{
					$(tid).removeAttr('checked');
				}
			}); 
		}
    });
}

function change(elt){
    var tid=$(elt).val();
    if($(elt).is(":checked")){
        $("."+tid).prop('checked',true);
	}else{
        $("."+tid).prop('checked',false);
	}
}
</script>	

