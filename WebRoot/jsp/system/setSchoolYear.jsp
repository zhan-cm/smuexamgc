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
<input id="hidCurrentSY" type="hidden" value="${currentSY.NAME}"/>
<div>
    <form id="AForm" method="post" action="">
        <table>
            <tr>
                <td colspan="2" style="text-align:center;font-size:16px;font-weight:bold;">新增学年设置</td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;font-size:16px;">学年格式为:20XX-20XX，当前显示为目前最大学年值</td>
            </tr>
            <tr>
                <td style="text-align:right;width:45%;">新增:</td>
                <td width="55%">
                    <input id="SchoolYear"  style="text-align:center;">学年
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;"><input type="button" value="添加" onclick="submitAForm()"/>&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="返回" onclick="javascript:history.go(-1);"/></td>
            </tr>
        </table>
    </form>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        var syVal = $("#hidCurrentSY").val().split("学年");
        $("#SchoolYear").val(syVal[0]);
    });
    function submitAForm(){
        //获取学年值
        var SchoolYearVal = $("#SchoolYear").val();
        var schoolyear = SchoolYearVal;
        //判断是否是数字串,定义验证表达式
        var reg=/^[0-9]{4}$/;
        var arrSY = SchoolYearVal.split("-");

        //学年维护
        var flag = "false";
        for (var i=0;i<arrSY.length;i++){
            if (arrSY[i].length!=4){
                flag = "false";
                break;
            } else {
                flag = reg.test(arrSY[i]);
            }
        }

        //年级维护
        var gradeVal = arrSY[0];
        var GradeYear = gradeVal;
        if (gradeVal.length!=4){
            flag = "false";
        } else {
            flag = reg.test(gradeVal);
        }

        if (flag=="false"){
            toastr.error('新增失败！请更正学年信息格式！');
        } else {
            $('#AForm').form('submit', {
                url:'${pageContext.request.contextPath}/system/addSchoolYear?SchoolYear='+schoolyear+'&GradeYear=' +GradeYear,
                success:function(data){
                    if(data=="success"){
                        toastr.success('新增学年成功！并已成功新增年级信息');
                    }else{
                        toastr.error('新增学年失败！新增的学年信息或已存在系统当中');
                    }
                }
            });
        }



    }
</script>