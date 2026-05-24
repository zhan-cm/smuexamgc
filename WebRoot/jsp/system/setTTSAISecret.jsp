<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
  tr{
    line-height: 20px;
  }
  td{
    font-size: 12px;
  }
  table {
    border-spacing: 0;
    border-collapse: collapse;
    border-radius: 8px;
    width:100%;
  }
  table td, th {
    padding: 5px;
    line-height: 1.2;
    vertical-align: center;
    border-top: 1px solid #ddd;
    border-radius: 8px;
  }

  table input[type="text"] {
    border: 1px solid #ddd;
    background: #FBFBFB;
    width:400px;
    outline: 0;
    -webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
    box-shadow: inset 0px 1px 6px #ECF3F5;
    font: 200 12px/25px Arial, Helvetica, sans-serif;
    margin: 2px;
    border-radius: 4px;
    padding:2px 4px;
  }
</style>
<html>
<head>
  <title>AI改卷接口相关配置</title>
</head>
<body>
<div>
  <table>
    <tr>
      <td colspan="3" style="text-align:center;font-size:18px;font-weight:bold;">AI语音合成接口相关配置</td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">系统开关</td>
      <td style="width: 70%">
        <select id="AI_En_TTS_switch" name="AI_En_TTS_switch">
          <c:choose>
            <c:when test="${applicationScope.AI_En_TTS.YL_1 eq 1}">
              <option value="0">关</option>
              <option value="1" selected="selected">开</option>
            </c:when>
            <c:otherwise>
              <option value="0" selected="selected">关</option>
              <option value="1">开</option>
            </c:otherwise>
          </c:choose>
        </select>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">appId</td>
      <td style="width: 70%"><input type="text" name="param" id="appId" value="${applicationScope.AI_En_TTS.YL_2}"/></td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">apiSecret</td>
      <td style="width: 70%"><input type="text" name="param" id="apiSecret" value="${applicationScope.AI_En_TTS.YL_3}"/></td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">apiKey</td>
      <td style="width: 70%"><input type="text" name="param" id="apiKey" value="${applicationScope.AI_En_TTS.YL_4}"/></td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">临时文件路径</td>
      <td style="width: 70%"><input type="text" name="param" id="tempDir" value="${applicationScope.AI_En_TTS.YL_5}"/>最后要有斜杠/，示例：（D:/mp3Temp/）</td>
    </tr>
    <tr><td colspan="3" style="text-align:center;"><input type="button" value="更新" onclick="updateTTSParam()"/>
      <input type="button" value="返回" onclick="window.location.href='${pageContext.request.contextPath}/system/params';"/></td></tr>
  </table>
</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
  function isNonEmptyString(str) {
    if (str === null || str === undefined) {
      return false;
    }
    if (typeof str !== 'string') {
      return false;
    }
    return str.trim() !== '';
  }

  function updateTTSParam(){
    let apiKey = isNonEmptyString($("#apiKey").val())?$("#apiKey").val().trim():"";
    let apiSecret = isNonEmptyString($("#apiSecret").val())?$("#apiSecret").val().trim():"";
    let appId = isNonEmptyString($("#appId").val())?$("#appId").val().trim():"";
    let tempDir = isNonEmptyString($("#tempDir").val())?$("#tempDir").val().trim():"";
    if($("#AI_En_TTS_switch").val()==1 && (apiKey=="" || apiSecret=="" || appId=="" || tempDir=="")){
      toastr.warning("开启该功能时，其他参数均不能为空！");
      return;
    }
    $.messager.defaults = { ok: "继续", cancel: "取消" };
    $.messager.confirm({
      width: '400',
      title: '提示',
      msg: '更新相关配置可能会导致同时正在使用调用TTS相关功能的用户短暂的操作失败，是否继续?',
      fn: function (r) {
        $.ajax({
          url:"${pageContext.request.contextPath}/system/updateTTSParam",
          async: false,
          type: "POST",
          data: {apiKey: apiKey,apiSecret:apiSecret,appId:appId, AI_En_TTS_switch: $("#AI_En_TTS_switch").val(),tempDir:tempDir},
          success: function(data){
            if(data.status === "success"){
              toastr.success(data.info);
            }else{
              toastr.warning(data.info);
            }
            setTimeout(function(){
              window.location.href = "${pageContext.request.contextPath}/system/toSetTTSAISecret";
            },1400);
          }
        });
      }
    });
  }
</script>
</html>