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
  <title>学校试卷、微信登录方式选择参数</title>
</head>
<body>
<div>
  <table>
    <tr>
      <td colspan="3" style="text-align:center;font-size:18px;font-weight:bold;">学校试卷、微信登录方式选择参数</td>
    </tr>
    <tr>
      <td colspan="3" style="text-align:center;font-size:14px;font-weight:bold;">   </td>
    </tr>
    <tr>
      <td style="text-align:right;width:15%;">学校试卷参数</td>
      <td style="width: 70%"><input type="text" name="seePaper" id="seePaper" value="${applicationScope.seePaper}"/></td>
      <td style="width: 15%">（普通配置填normal）</td>
    </tr>
    <tr><td colspan="3" style="text-align:center;"><input type="button" value="更新" onclick="updateParam()"/>
      <input type="button" value="返回" onclick="window.location.href='${pageContext.request.contextPath}/system/params';"/></td></tr>
  </table>
</div>
</body>
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

  function updateParam(){
    let seePaper = isNonEmptyString($("#seePaper").val())?$("#seePaper").val().trim():"normal";

    $.messager.defaults = { ok: "继续", cancel: "取消" };
    $.messager.confirm({
      width: '400',
      title: '提示',
      msg: '是否更新?',
      fn: function (r) {
        if(r){
          $.ajax({
            url:"${pageContext.request.contextPath}/system/updatePaperAndWechatParam",
            async: false,
            type: "POST",
            data: {
              seePaper : seePaper
            },
            success: function(data){
              if(data.status === "success"){
                toastr.success("成功！");
              }else{
                toastr.warning(data.info);
              }
              setTimeout(function(){
                window.location.href = "${pageContext.request.contextPath}/system/toSetPaperAndWechatParam";
              },1200);
            }
          });
        }
      }
    });
  }
</script>
</html>
