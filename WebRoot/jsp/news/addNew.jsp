<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.config.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/ueditor1_4_3_3/lang/zh-cn/zh-cn.min.js"></script>
<style>
tr{
	line-height: 20px;
}
td{
	font-size: 12px;
}
.checkblock{
	border:1px solid #CCC;
	height:auto;
	width:100%;
	overflow-y: scroll;
}
.checkblock [type="text"]{
	width: 940px;
	font-size: 20px;
	border: none;
	border-bottom: 1px solid #777;
	margin-top:5px;
}
.title{
	/*background-color:#E0ECFF;*/
	padding:6px 0;
	text-align:center;
}
.title span {
	font-size: 18px;
}
.window{
	position: fixed !important;
	top:30% !important;
}
.window-shadow{
	position: fixed !important;
	top:30% !important;
}
</style>
	<form id="newsForm" method="post" action="${pageContext.request.contextPath}/news/addNew">		
		<table style="margin-top:20px; width: 100%">
			<tr>
				<td style="width:10%; text-align:left;">公告类型：</td>
				<td style="width:90%; text-align:left;">
					<div class="radio-group">
						<input type="radio" id="type0" name="type" value="0" checked="checked" />
						<label for="type0">通知</label>

						<input type="radio" id="type1" name="type" value="1" />
						<label for="type1">操作指南</label>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width:10%;text-align: left;">标题:</td>
				<td style="width:90%;text-align: left;">
					<input id="title" name="title" style="width:100%;" value=""/>
				</td>
			</tr>
			<tr>
				<td style="width:10%;text-align: left;">内容:</td>
				<td style="width:90%;text-align: left;">
					<script id="content" name="content" type="text/plain" style="width:100%;height:300px;"></script> 
				</td>
			</tr>
		</table>
	</form>

<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);" onclick="addNew()">保存</a>&nbsp;
</div>

<script type="text/javascript">
var content;
$(document).ready(function() {
	content = UE.getEditor('content');
	//覆盖UEditor中获取路径的方法
	UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
	UE.Editor.prototype.getActionUrl = function(action) {
		if (action === 'uploadimage' || action === 'uploadvideo' || action === 'uploadfile') {
			return "${pageContext.request.contextPath}/upload/uploadFile"
					+ "?action=normal"
					+ "&cid=gonggao";
		} else if (action === 'catchimage') {
			return "${pageContext.request.contextPath}/upload/uploadFile"
					+ "?action=catchimage"
					+ "&cid=gonggao";
		}
		return this._bkGetActionUrl.call(this, action);
	}
});
	
function addNew(){
	if($("#title").val()==""||$("#title").val()==null){
		toastr.warning('请编辑公告标题');
		return;
	}	
	if(content.getContent()==""||content.getContent()==null){
		toastr.warning('请编辑公告内容');
		return;
	}	
	$('#newsForm').submit();
}
</script>