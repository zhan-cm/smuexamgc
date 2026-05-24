<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>

<style type="text/css">
	.table th, .table td {  
		vertical-align: middle!important;  
		font-size:14px;
	}  
	.title_h4{
		/*background-color:#DCEBFE;*/
		color:black;
		width:100%;
	}
	.wrap{white-space:normal;}
</style>
<input type="hidden" id="eid" name="eid" value="${eid }"/>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="text-center title_h4">
			<h4>《${ename}》问卷调查分析结果导出&nbsp;&nbsp;&nbsp;&nbsp;<button class="btn btn-primary" onclick="window.location.reload();">刷新</button></h4>
		</div>
	</div>
	
	<div class="row-fluid" id="inputContent">
		
	</div>
	<div style="text-align:center;">
		<button class="btn btn-primary" id="objButton" onclick="exportAnalysis(0)" style="display:none">导出客观题分析</button>&nbsp;&nbsp;&nbsp;&nbsp;
		<button class="btn btn-primary" id="subButton" onclick="exportAnalysis(1)" style="display:none">导出主观题分析</button>&nbsp;&nbsp;&nbsp;&nbsp;
		<button class="btn btn-danger" onclick="tabsClose();">返回</button>&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
</div>
<div id="exportResearchQuestionWin"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	createTable(0);
	createTable(1);
	$("input[name='selectAll']").click(function(){
		if($(this).is(":checked")){
			$("input[name='objective']").attr("checked",true);
		}else{
			$("input[name='objective']").attr("checked",false);
		}
		showButton();
	});
	
	$("input[name='objective']").click(function(){
		showButton();
	})
	
	$("input[name='subjective']").click(function(){
		showButton();
	})
});

function createTable(type){
	var eid = $('#eid').val();
	var data = getQuestionList(eid, type);
	var table = '<table class="table table-bordered text-center">'
		if(type==0){
			table += '<tr><th colspan="4" class="text-center">客观题</th></tr>'
			table += '<tr>'
			table += '<th class="text-center"><input type="checkbox" name="selectAll" id="selectAll" /></th>'
		}else{
			table += '<tr><th colspan="4" class="text-center">主观题</th></tr>'
			table += '<tr>'
			table += '<th class="text-center"></th>'
		}
		table += '<th class="text-center">题号</th>'
		table += '<th class="text-center">题目摘要</th>'
		table += '<th class="text-center">题型</th>'
		table += '</tr>'
		for(var i=0;i<data.length;i++){
			table += '<tr>'
			if(type==0){
				table += '<td class="text-center"><input type="checkbox" name="objective" value="'+data[i].qid+'" /></td>'
			}else{
				table += '<td class="text-center"><input type="radio" name="subjective" value="'+data[i].qid+'" /></td>'
			}
			table += '<td class="text-center">'+data[i].th+'</td>'
			table += '<td class="text-center">'+data[i].content+'</td>'
			table += '<td class="text-center">'+data[i].qtname+'</td>'
			table += '</tr>'
		}
		table += '</table>'
		$('#inputContent').append(table);
}

function getQuestionList(eid,type){
	var rs = ''
	$.ajax({
		url:"${pageContext.request.contextPath}/result/researchQuestionList",
		async:false,
		type:"POST",
		data:{"eid":eid,"type":type},
		success:function(data){
			rs = data;
		}
	})
	return rs;
}

function showButton(){
	var len = $('input[name="objective"]:checked').length;
	len==0 ? $('#objButton').hide() : $('#objButton').show()
			
	var len2 = $('input[name="subjective"]:checked').length;
	len2==0 ? $('#subButton').hide() : $('#subButton').show()
}

function exportAnalysis(type){
	var eid = $('#eid').val();
	var qids = '';
	if(type==0){
		$('input[name="objective"]:checked').each(function(i){
			qids += $(this).val() +',';
		});
		qids = qids.substring(0,qids.length-1);
	}else if(type==1){
		qids= $('input[name="subjective"]:checked').val();
	}
	if(qids==''){
		toastr.warning("请先选择题目");
	}else{
		window.location.href="${pageContext.request.contextPath}/result/exportResearchQuestion?qids="+qids+"&type="+type+"&eid="+eid
	}
}

function tabsClose(){
	var eid = $('#eid').val()
	var url = '${pageContext.request.contextPath}/result/qualityAnalysis?eid=' + eid + '&research=research';
	window.location.href = url;
} 

</script>	

