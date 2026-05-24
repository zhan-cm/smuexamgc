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
.wrap{white-space:normal;}
</style>
<form id="adjustForm" method="post" action="">	
	<input type="hidden" name="ei_id" id="ei_id"  value="${ei_id}"/>	
	<input type="hidden" name="mqid" id="mqid"  value="${mqid}"/>
	<table width="100%" id="main">
		<tr class="title">
			<td width="90%">试题内容</td>
			<td width="10%">调整顺序</td>
		</tr>
		<c:forEach var="question" items="${exampaperQuestionList}" varStatus="qt">			
			<tr class="qtrow">	
				<td>
					<div class="wrap">${question.content}</div>
					<input type="hidden" class="adjustText qid" value="${question.qid}"/>
				</td>
				<td>
					<span onclick="up(this);"  style="cursor: pointer;" title="上移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180466.gif"/></span>&nbsp;&nbsp;&nbsp;&nbsp;
	       			<span onclick="down(this);"  style="cursor: pointer;" title="下移" aria-hidden="true"><img style="height:15px;" src="${pageContext.request.contextPath}/styles/images/1180465.gif"/></span>				
				</td>
			</tr>
		</c:forEach>
	</table>
</form>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"  href="javascript:void(0);" onclick="cancel()">关闭</a> 	
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
function up(elt){
	var objParentTR = $(elt).parent().parent();
	var rows = objParentTR.prevAll().length + 1;		
	if(rows > 2) {		
		var qid=objParentTR.find(".qid").val();
		var prevTR = objParentTR.prev();
		$.ajax({
            url: "${pageContext.request.contextPath}/paper/setBranchOrder_up",
            async: true,//改为同步方式
            type: "POST",
            traditional: true,
            data: { "ei_id":$("#ei_id").val(),"qid": qid,"mqid":$("#mqid").val()},
            success: function (data) {
            	if(data=="success"){		          				    
				    prevTR.insertAfter(objParentTR);
				    toastr.success("已调整");		   
	          	}else{
	          		toastr.error(data);
	          	}	
            }
    	});
	}else{
    	toastr.warning("已经是第一行");
    }    
}

function down(elt){
	var objParentTR = $(elt).parent().parent();
	var objParentTable=$(elt).parent().parent().parent();
	
	var rows = objParentTR.prevAll().length + 1;	
    
    if(rows<objParentTable.find("tr").length) {		
		var qid=objParentTR.find(".qid").val();
		var nextTR = objParentTR.next();
		$.ajax({
            url: "${pageContext.request.contextPath}/paper/setBranchOrder_down",
            async: true,//改为同步方式
            type: "POST",
            traditional: true,
            data: { "ei_id":$("#ei_id").val(),"qid": qid,"mqid":$("#mqid").val()},
            success: function (data) {
            	if(data=="success"){		          				    
				    nextTR.insertBefore(objParentTR);	   
				    toastr.success("已调整");
	          	}else{
	          		toastr.error(data);
	          	}	
            }
    	});	    
    }else{
    	toastr.warning("已经是最后一行");
    }
}

function cancel(){
	var ifmdlg = window.parent.document.getElementById("ifmdlg");
	$(ifmdlg).parent().next().next().remove();
	$(ifmdlg).parent().next().remove();
	$(ifmdlg).parent().remove();
}
</script>

