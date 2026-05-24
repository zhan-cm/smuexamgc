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

  table select {
    border: 1px solid #ddd;
    background: #FBFBFB;
    width:200px;
    outline: 0;
    -webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
    box-shadow: inset 0px 1px 6px #ECF3F5;
    font: 200 12px/25px Arial, Helvetica, sans-serif;
    margin: 2px;
    border-radius: 4px;
    padding:2px 4px;
  }
</style>
<div>
  <table>
    <tr>
      <td colspan="2" style="text-align:center;font-size:16px;font-weight:bold;">图片批注改分设置</td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">允许图片批注改卷：</td>
      <td style="width: 60%">
        <select id="allowPicMark" style="width: 28%" name="allowPicMark" onchange="allowPicMarkChange()">
          <c:choose>
            <c:when test="${applicationScope.allowPicMark==1}">
              <option value="0">不允许</option>
              <option value="1" selected="selected">允许</option>
            </c:when>
            <c:otherwise>
              <option value="0" selected="selected">不允许</option>
              <option value="1">允许</option>
            </c:otherwise>
          </c:choose>
        </select>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">图片批注改分是否允许手动批改：</td>
      <td style="width: 60%">
        <c:choose>
          <c:when test="${applicationScope.allowPicMark==1}">
            <select style="width: 28%" id="picMarkManualSwitch" name="picMarkManualSwitch">
              <c:choose>
                <c:when test="${applicationScope.picMarkManualSwitch==1}">
                  <option value="0">不允许</option>
                  <option value="1" selected="selected">允许</option>
                </c:when>
                <c:otherwise>
                  <option value="0" selected="selected">不允许</option>
                  <option value="1">允许</option>
                </c:otherwise>
              </c:choose>
            </select>
          </c:when>
          <c:otherwise>
            <select style="width: 28%" id="picMarkManualSwitch" name="picMarkManualSwitch" disabled>
              <option value="0" selected="selected">不允许</option>
              <option value="1">允许</option>
            </select>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">图片批注改分是否允许AI批改：</td>
      <td style="width: 60%">
        <c:choose>
          <c:when test="${applicationScope.allowPicMark==1 }">
            <select style="width: 28%" id="picMarkAISwitch" name="picMarkAISwitch" onchange="picMarkAISwitchChange()">
              <c:choose>
                <c:when test="${applicationScope.picMarkAISwitch==1}">
                  <option value="0">不允许</option>
                  <option value="1" selected="selected">允许</option>
                </c:when>
                <c:otherwise>
                  <option value="0" selected="selected">不允许</option>
                  <option value="1">允许</option>
                </c:otherwise>
              </c:choose>
            </select>
          </c:when>
          <c:otherwise>
            <select style="width: 28%" id="picMarkAISwitch" name="picMarkAISwitch" onchange="picMarkAISwitchChange()" disabled>
              <option value="0" selected="selected">不允许</option>
              <option value="1">允许</option>
            </select>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">AI批改图片保留日期：</td>
      <td style="width: 60%">
          <c:choose>
            <c:when test="${applicationScope.picMarkAISwitch==1 and applicationScope.allowPicMark==1}">
              <input style="width: 28%" id="picMarkAISaveDays" value="${applicationScope.picMarkAISaveDays}"/>
            </c:when>
            <c:otherwise>
              <input style="width: 28%;" id="picMarkAISaveDays" value="${applicationScope.picMarkAISaveDays}" disabled/>
            </c:otherwise>
          </c:choose>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">图片批改的服务器存储目录（负载均衡时只管中心服务器，目录层级尽量浅）：</td>
      <td style="width: 60%">
        <c:choose>
          <c:when test="${applicationScope.allowPicMark==1}">
            <input style="width: 28%" id="picMarkSavePath" value="${applicationScope.picMarkSavePath}"/>
          </c:when>
          <c:otherwise>
            <input style="width: 28%;" id="picMarkSavePath" value="${applicationScope.picMarkSavePath}" disabled/>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td style="text-align:right;width:40%;">图片批改的中心服务器地址（单体项目直填http://localhost:端口/项目名）：</td>
      <td style="width: 60%">
        <c:choose>
          <c:when test="${applicationScope.allowPicMark==1}">
            <input style="width: 28%" id="picMarkRemotePath" value="${applicationScope.picMarkRemotePath}"/>
          </c:when>
          <c:otherwise>
            <input style="width: 28%;" id="picMarkRemotePath" value="${applicationScope.picMarkRemotePath}" disabled/>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
    <tr>
      <td colspan="2" style="text-align:center;"><input type="button" value="更新" onclick="updateParam()"/>
        &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="返回" onclick="window.location.href='${pageContext.request.contextPath}/system/params';"/></td>
    </tr>
  </table>
</div>
<script type="text/javascript">
  function updateParam(){
    let picMarkAISaveDays = "${applicationScope.picMarkAISaveDays}";
    if($("#picMarkAISaveDays").val()){
      picMarkAISaveDays = $("#picMarkAISaveDays").val().trim();
    }
    $.ajax({
      url:"${pageContext.request.contextPath}/system/updatePicMarkSwitch",
      async: false,
      type: "POST",
      data: {
        picMarkManualSwitch : $("#picMarkManualSwitch").val(),
        allowPicMark : $("#allowPicMark").val(),
        picMarkAISwitch: $("#picMarkAISwitch").val(),
        picMarkAISaveDays: picMarkAISaveDays,
        picMarkSavePath: $("#picMarkSavePath").val(),
        picMarkRemotePath: $("#picMarkRemotePath").val(),
      },
      success: function(data){
        if(data === "success"){
          toastr.success("成功！");
        }else{
          toastr.warning("失败！");
        }
      }
    });
  }

  function allowPicMarkChange(){
    if($("#allowPicMark").val()==="0"){
      $("#picMarkManualSwitch").val("0").prop("disabled", true);
      $("#picMarkAISwitch").val("0").prop("disabled", true);
      $("#picMarkAISaveDays").val("${applicationScope.picMarkAISaveDays}").prop('disabled', true);
      $("#picMarkSavePath").val("${applicationScope.picMarkSavePath}").prop('disabled', true);
      $("#picMarkRemotePath").val("${applicationScope.picMarkRemotePath}").prop('disabled', true);
    }else{
      $("#picMarkManualSwitch").val("0").prop("disabled", false);
      $("#picMarkAISwitch").val("0").prop("disabled", false);
      $("#picMarkSavePath").val("${applicationScope.picMarkSavePath}").prop('disabled', false);
      $("#picMarkRemotePath").val("${applicationScope.picMarkRemotePath}").prop('disabled', false);
    }
  }

  function picMarkAISwitchChange(){
    if($("#picMarkAISwitch").val()==="0"){
      $("#picMarkAISaveDays").val("${applicationScope.picMarkAISaveDays}").prop('disabled', true);
    }else{
      $("#picMarkAISaveDays").prop('disabled', false);
    }
  }
</script>