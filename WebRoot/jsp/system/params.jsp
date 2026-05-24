<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>

</style>
<h2>系统参数设置</h2>
<a href="${pageContext.request.contextPath}/system/setQuestionType" class="easyui-linkbutton" data-options="plain:true">系统题型设置</a>	
<a href="${pageContext.request.contextPath}/system/setUnit" class="easyui-linkbutton" data-options="plain:true">教学单位设置</a>	
<a href="${pageContext.request.contextPath}/system/setSpecialty" class="easyui-linkbutton" data-options="plain:true">学生专业设置</a>
<a href="${pageContext.request.contextPath}/system/setOrganizationName" class="easyui-linkbutton" data-options="plain:true">学校名称设置</a>
<a href="${pageContext.request.contextPath}/system/setDefaultExamInfo" class="easyui-linkbutton" data-options="plain:true">默认考务信息设置</a>
<a href="${pageContext.request.contextPath}/system/setTeacherPermission" class="easyui-linkbutton" data-options="plain:true">教师默认权限设置</a>
<a href="${pageContext.request.contextPath}/system/setMenuPermission" class="easyui-linkbutton" data-options="plain:true">角色可显示菜单设置</a>
<a href="${pageContext.request.contextPath}/system/setQuestionStructureRule" class="easyui-linkbutton" data-options="plain:true">组卷使用次数、时间、审核限制设置</a>
<a href="${pageContext.request.contextPath}/system/setSchoolYear" class="easyui-linkbutton" data-options="plain:true">学年(年级)设置</a>
<a href="${pageContext.request.contextPath}/system/setLastverify" class="easyui-linkbutton" data-options="plain:true">默认审核试卷账号设置</a>
<a href="${pageContext.request.contextPath}/system/setPicMarkSwitch" class="easyui-linkbutton" data-options="plain:true">图片批注改卷设置</a>
<br><br>
<h2>系统开关设置</h2>
<a href="${pageContext.request.contextPath}/system/setCommonSwitch" class="easyui-linkbutton" data-options="plain:true">系统各类通用开关</a>
<h2>接口相关配置设置（初始系统必重配）</h2>
<a href="${pageContext.request.contextPath}/system/toSetPaperAndWechatParam" class="easyui-linkbutton" data-options="plain:true">学校试卷方式选择参数</a>
<a href="${pageContext.request.contextPath}/system/toSetAISecretV2" class="easyui-linkbutton" data-options="plain:true">AI出题接口相关配置</a>
<a href="${pageContext.request.contextPath}/system/toSetTTSAISecret" class="easyui-linkbutton" data-options="plain:true">TTS接口相关配置</a>
<div id="dd">
</div>
<script type="text/javascript">
</script>	