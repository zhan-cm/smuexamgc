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
    <title>AI接口V2相关配置</title>
</head>
<body>
<div>
    <table>
        <tr>
            <td colspan="3" style="text-align:center;font-size:18px;font-weight:bold;">AI接口V2相关配置</td>
        </tr>
        <tr>
            <td colspan="3" style="text-align:center;font-size:14px;font-weight:bold;">
                提示：为了安全，以下数据都会用加密的方式存储，并且不提供对外直接解密输出的接口，因此即便已保存也不会显示</td>
        </tr>
        <tr>
            <td style="text-align:right;width:15%;">系统开关</td>
            <td colspan="2" style="width: 70%">
                <select id="AI_V2_switch" name="AI_V2_switch">
                    <c:choose>
                        <c:when test="${applicationScope.AI_V2_switch==1}">
                            <option value="0">关</option>
                            <option value="1" selected="selected">开（存在合法参数才生效）</option>
                        </c:when>
                        <c:otherwise>
                            <option value="0" selected="selected">关</option>
                            <option value="1">开（存在合法参数才生效）</option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </td>
        </tr>
        <tr>
            <td style="text-align:right;width:15%;">AI试卷试题内容分析开关</td>
            <td colspan="2" style="width: 70%">
                <select id="AI_exampaper_test_switch" name="AI_exampaper_test_switch">
                    <c:choose>
                        <c:when test="${applicationScope.AI_V2_switch==1 and applicationScope.AI_exampaper_test_switch==1}">
                            <option value="0">关</option>
                            <option value="1" selected="selected">开（存在合法参数才生效）</option>
                        </c:when>
                        <c:otherwise>
                            <option value="0" selected="selected">关</option>
                            <option value="1">开（存在合法参数才生效）</option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </td>
        </tr>
        <tr>
            <td style="text-align:right;width:15%;">APIKey</td>
            <td style="width: 70%"><input type="text" name="APIKey" id="APIKey" value=""/>（不更新就无需填）</td>
            <td style="width: 15%"><button type="button" onclick="clearAISecretData(2)">置空该数据</button></td>
        </tr>
        <tr><td colspan="3" style="text-align:center;"><input type="button" value="更新" onclick="updateAISecret()"/>
            <input type="button" value="返回" onclick="window.location.href='${pageContext.request.contextPath}/system/params';"/></td></tr>
    </table>
</div>
</body>
<script type="text/javascript">
    function clearAISecretData(clearParam){
        $.ajax({
            url:"${pageContext.request.contextPath}/system/clearAISecretData",
            async: false,
            type: "POST",
            data: {AIkeyName : "AI_V2_switch" ,clearParam : clearParam},
            success: function(data){
                if(data.status === "success"){
                    toastr.success(data.info);
                }else{
                    toastr.warning(data.info);
                }
                setTimeout(function(){
                    window.location.href = "${pageContext.request.contextPath}/system/toSetAISecret";
                },1200);
            }
        });
    }

    function isNonEmptyString(str) {
        if (str === null || str === undefined) {
            return false;
        }
        if (typeof str !== 'string') {
            return false;
        }
        return str.trim() !== '';
    }

    function updateAISecret(){
        let APIKey = isNonEmptyString($("#APIKey").val())?$("#APIKey").val().trim():"";
        $.messager.defaults = { ok: "继续", cancel: "取消" };
        $.messager.confirm({
            width: '400',
            title: '提示',
            msg: '更新相关配置可能会导致同时正在使用调用AI相关功能的用户短暂的操作失败，是否继续?',
            fn: function (r) {
                $.ajax({
                    url:"${pageContext.request.contextPath}/system/updateAISecretV2Data",
                    async: false,
                    type: "POST",
                    data: {APIKey : APIKey,
                        AI_V2_switch : $("#AI_V2_switch").val(),
                        AI_exampaper_test_switch:$("#AI_exampaper_test_switch").val()
                    },
                    success: function(data){
                        if(data.status === "success"){
                            toastr.success(data.info);
                        }else{
                            toastr.warning(data.info);
                        }
                        setTimeout(function(){
                            window.location.href = "${pageContext.request.contextPath}/system/toSetAISecretV2";
                        },1200);
                    }
                });
            }
        });
    }
</script>
</html>
