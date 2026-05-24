<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 3px;
}
td, th {
	/* border: 1px solid #aaa;
	border-radius: 3px; */
	
	padding: 5px;
	line-height: 1.2;
	vertical-align: center;
	/* border-top: 1px solid #ddd; */
	border: 1px solid #ddd;
}
.distributionSituation{
	margin: 5px 0;
	font-size: 14px;
}
.keyword{
	color: red;
}
.title{
	font-weight: bolder; 
	text-align: center
}
</style>
<table width="100%" style="text-align:center">
	<tr>
		<td>《${cname}》试题分布统计</td>
	</tr>
</table>
<input type="hidden" id="cid" value="${cid}"/>
<table width="100%" id="main">
	<tr>
		<td>主题词\题型</td>
		<c:forEach var="questionType" items="${questionTypeList}">
			<%-- <td style="text-align: center" class="title">${questionType.QTNAME}</td> --%>
			<td class="title">
				<c:if test="${questionType.ISCON == 0}">     							
					${questionType.QTNAME}	
				</c:if>
				<c:if test="${questionType.ISCON == 1}">   							
					<span>*${questionType.QTNAME}</span>
				</c:if> 
			</td>
		</c:forEach>
		<td class="title" style="text-align: center">合计</td>
	</tr>
	
	
	<c:forEach var="theme" items="${themeList}">
		<tr>
			<td>${theme.NAME}</td><!-- 主题词 -->
			<c:set var="themeCount" value="0" /> 
			<c:forEach var="qt" items="${questionTypeList}"><!-- 当前主题词的题型列表 qt表示单条主题词信息 -->
				<c:set var="dscount" value="0" /> 
				<c:forEach var="ds" items="${distributionStatistics}"><!-- 分布式统计  -->
					<c:if test="${ds.THID == theme.ID && ds.QTID == qt.QTID}">
						<c:set var="dsTHID" value="${theme.ID}" /><!-- 主题ID -->
						<c:set var="dsQTID" value="${qt.QTID}" /><!-- 题型id  -->
						<c:set var="dscount" value="${ds.NUM}" />    
						<c:set var="themeCount" value="${themeCount + ds.NUM}" />  
					</c:if> 
				</c:forEach>
				<td style="text-align: center" onclick="getdsCountByID('${dsTHID}','${dsQTID}','${dscount}')"><c:out value="${dscount}"/></td> 
			</c:forEach>
			<td style="text-align: center"><c:out value="${themeCount}"/></td>
		</tr> 
	</c:forEach>
	
	<tr>
		<td>合计</td>
		<c:set var="total" value="0" /> 
		<c:forEach var="qt" items="${questionTypeList}">
			<c:set var="questionTypeCount" value="0" /> 
			<c:forEach var="ds" items="${distributionStatistics}">
				<c:if test="${ds.QTID == qt.QTID}">      
					<c:set var="questionTypeCount" value="${questionTypeCount + ds.NUM}" />  
				</c:if> 
			</c:forEach>
			<c:set var="total" value="${total + questionTypeCount}" />  
			<td style="text-align: center"><c:out value="${questionTypeCount}"/></td>
		</c:forEach>
		<td style="text-align: center"><c:out value="${total}"/></td>
	</tr>
</table>

<div style="width: 100%; height: 40px; text-align: center;">
	<div class="distributionSituation">难度分布：共<i class="keyword">${count}</i>道， 其中<c:forEach var="res" items="${difficultyRes}">${res.name}题<i class="keyword">${res.num}</i>道，占<i class="keyword">${res.percent}</i>；&nbsp;&nbsp;&nbsp;</c:forEach></div>
	<div class="distributionSituation">认知分布：共<i class="keyword">${count}</i>道， 其中<c:forEach var="res" items="${cognitionRes}">${res.name}题<i class="keyword">${res.num}</i>道，占<i class="keyword">${res.percent}</i>；&nbsp;&nbsp;&nbsp;</c:forEach></div>
	<div class="distributionSituation">知识点分布：共<i class="keyword">${count}</i>道， 其中<c:forEach var="res" items="${knowledgeRes}">${res.name}题<i class="keyword">${res.num}</i>道，占<i class="keyword">${res.percent}</i>；&nbsp;&nbsp;&nbsp;</c:forEach></div>
	<a id="workLoad_id" href="javascript:void(0)" onclick="workLoad()" class="easyui-linkbutton">工作量</a>
	<a class="easyui-linkbutton"  href="javascript:void(0)" onclick="cancelEasyUiFrame(0)">关闭</a>
	<div class="distributionSituation">*备注：如果按主题词和题型分类的题目总数和题库中的题目总数不一致，说明题库中有些题主题词为空或者题型设置有误</div>
	 
</div>
<script type="text/javascript">
	var questionTypeList = '${questionTypeList}';
	var themeList = '${themeList}';
	var distributionStatistics = '${distributionStatistics}';
	$(document).ready(function() {
		//initData1();
		//initData2();
		if("${role}"=="student"){
			$("#workLoad_id").remove();
		}
	});

	function getdsCountByID(dsTHID,dsQTID,dscount){
		cid = ${cid};
		if(dscount!=0){
			window.location.href='${pageContext.request.contextPath}/studentEnd/QuestionList?c_id='+ cid+'&isNewPaper='+1+'&dsTHID='+dsTHID+'&dsQTID='+dsQTID;
		}else{
			toastr.warning("当前点击的题目数是0，无法查看题目!");
		}
	}
	
	function initData1(){
		var str;
		<c:forEach var="theme" items="${themeList}">
			str += '<tr><td>${theme.NAME}</td>';
			var total_x = 0;
			<c:forEach var="qt" items="${questionTypeList}">
				var res = false;
				var num = 0;
				<c:forEach var="ds" items="${distributionStatistics}">
					if('${ds.THID}' == '${theme.ID}'&&'${ds.QTID}' == '${qt.QTID}'){
						res = true;
						num = '${ds.NUM}';
					}
				</c:forEach>
				if(res){
					str += '<td>' + num + '</td>';
					total_x += parseInt(num);
					//console.log(num + ' ' + total_x);
				}else{
					str += '<td>' + num + '</td>';
				}
				
			</c:forEach>
			str += '<td>' + total_x + '</td></tr>';
		</c:forEach>
		//console.log(str);
		$(str).appendTo('#main');
	}
	
	function initData2(){
		var total = 0;
		var str = '<tr><td>合计</td>';
		<c:forEach var="qt" items="${questionTypeList}">
			var total_y = 0;
			<c:forEach var="theme" items="${themeList}">
				<c:forEach var="ds" items="${distributionStatistics}">
				if('${ds.THID}' == '${theme.ID}'&&'${ds.QTID}' == '${qt.QTID}'){
					total_y += parseInt('${ds.NUM}');
				}
				</c:forEach>
			</c:forEach>
			total += total_y;
			str += '<td>' + total_y + '</td>';
		</c:forEach>
		//console.log(str);
		str += '<td>' + total + '</td></tr>';
		$(str).appendTo('#main');
	}
	
	function workLoad(){
		cid = ${cid};
		var url = '${pageContext.request.contextPath}/question/inWorkLoad?c_id='+ cid;
		openIframeDialog({
			title: '工作量统计',
			url: url,
			fit: true 
		});
	}
</script>

