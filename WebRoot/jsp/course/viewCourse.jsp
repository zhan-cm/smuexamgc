<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<link href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/login.css">
<style>
body{
	background:#FFF;
}
</style>
<input type="hidden" id="cname" value="${res.name_c}"/>
<div id="print">
<div style="text-align:center;">
	<h4>浏览《${res.name_c}》课程信息</h4>
</div>
<table class="table table-bordered" border="1">
	<c:set var="mp" value=","/>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">课程名称：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.name_c}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">课程名简称：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.shortname}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">课程英文名称：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.name_e}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">课程代码：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.code}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">授课单位：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.uname}&nbsp;&nbsp;${res.deptname}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">适用专业：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="specialty" value=""/>
			<c:forEach var="sp" items="${res.specialtyList}">
				<c:set var="specialty" value="${specialty}${sp}${mp}"/>
			</c:forEach>
			<c:out value="${specialty}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">适用层次：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="arrangement" value=""/>
			<c:forEach var="arr" items="${res.arrangementList}">
				<c:set var="arrangement" value="${arrangement}${arr.ANAME}${mp}"/>
			</c:forEach>
			<c:out value="${arrangement}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">最高学时：</th>
		<td class="col-sm-10 col-md-11" colspan="3">${res.period}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">包含题型：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="questionType" value=""/>
			<c:forEach var="qt" items="${res.questionTypeList}">
				<c:set var="questionType" value="${questionType}${qt.QTNAME}${mp}"/>
			</c:forEach>
			<c:out value="${questionType}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">考试类别：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="examType" value=""/>
			<c:forEach var="et" items="${res.examTypeList}">
				<c:set var="examType" value="${examType}${et.ETNAME}${mp}"/>
			</c:forEach>
			<c:out value="${examType}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">难度类别：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="difficulty" value=""/>
			<c:forEach var="diff" items="${res.difficultyList}">
				<c:set var="difficulty" value="${difficulty}${diff.DNAME}${mp}"/>
			</c:forEach>
			<c:out value="${difficulty}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">知识点分布：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="knowledge" value=""/>
			<c:forEach var="kl" items="${res.knowledgeList}">
				<c:set var="knowledge" value="${knowledge}${kl.KNAME}${mp}"/>
			</c:forEach>
			<c:out value="${knowledge}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">认知类别：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="cognition" value=""/>
			<c:forEach var="co" items="${res.cognitionList}">
				<c:set var="cognition" value="${cognition}${co.CONAME}${mp}"/>
			</c:forEach>
			<c:out value="${cognition}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">题源类别：</th>
		<td class="col-sm-10 col-md-11" colspan="3">
			<c:set var="source" value=""/>
			<c:forEach var="so" items="${res.sourceList}">
				<c:set var="source" value="${source}${so.SONAME}${mp}"/>
			</c:forEach>
			<c:out value="${source}"/>
		</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">联系人：</th>
		<td class="col-sm-4 col-md-5">${res.contact}</td>
		<th class="col-sm-2 col-md-1" style="text-align:right;">联系电话：</th>
		<td class="col-sm-4 col-md-5">${res.tel}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">创建人：</th>
		<td class="col-sm-4 col-md-5">${res.creator}</td>
		<th class="col-sm-2 col-md-1" style="text-align:right;">创建时间：</th>
		<td class="col-sm-4 col-md-5">${res.creattime}</td>
	</tr>
	<tr>
		<th class="col-sm-2 col-md-1" style="text-align:right;">最近更新人：</th>
		<td class="col-sm-4 col-md-5">${res.updator}</td>
		<th class="col-sm-2 col-md-1" style="text-align:right;">最近更新时间：</th>
		<td class="col-sm-4 col-md-5">${res.updatime}</td>
	</tr>
</table>
</div>
<div style="text-align:center;">
	<input type="button" value="保存为word" class="btn btn-default btn-sm" onclick="saveAsWord()">
	<input type="button" value="关闭" class="btn btn-default btn-sm" onclick="cancel()">
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
function saveAsWord() {
	var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;}";
	s += "th {width:30%} div {text-align:center;}";
	
	var name = $("#cname").val()+"课程信息"+new Date().format('yyyy-MM-dd');
	$("#print").wordExport(name,s);
}

function cancel(){
	var ifmdlg = window.parent.document.getElementById("ifmdlg");
	$(ifmdlg).parent().next().next().remove();
	$(ifmdlg).parent().next().remove();
	$(ifmdlg).parent().remove();
}
</script>