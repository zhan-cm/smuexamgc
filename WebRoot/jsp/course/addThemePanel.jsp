<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<div style='padding: 5px;' id='editpage'>
	<form id='themeForm'>
		<table  width="100%" style="margin:;" border="0" align="center">
			<tr>
				<td algin="center">
				${requestScope.th_pid}主题词<input name="theme" type="text" class="easyui-validatebox" data-options="required:true">${requestScope.th_level}
				</td>
			</tr>
		</table>
		<input name="pid" type="hidden" value="${requestScope.th_pid}">
		<input name="level" type="hidden" value="${requestScope.th_level}">
		<input name="cid" type="hidden" value="1001170">
		<div style="width: 100%; height: 40px; text-align: center;">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="submitAddTheme()">保存</a>
			<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" >取消</a> 
		</div>
	</form>
</div>
<script type="text/javascript">
	var action;
	$(document).ready(function() {
		$.parser.parse($("#dlg"));//重新渲染
	});
	
	
function submitAddTheme(){
	$('#themeForm').form('submit', {
	    url:'addTheme',
	    onSubmit: function(){
	    	return $("#themeForm").form('validate');
	    	
	    },
	    success:function(data){
	    }
	});
}	
	
</script>

