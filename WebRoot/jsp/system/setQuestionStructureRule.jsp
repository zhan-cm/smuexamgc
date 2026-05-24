<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<style>
  .setting-table {
    width: 100%;
    border-collapse: collapse;
    border-spacing: 0;
  }

  .setting-table tr {
    line-height: 20px;
  }

  .setting-table td,
  .setting-table th {
    padding: 8px 6px;
    font-size: 12px;
    line-height: 1.5;
    border-top: 1px solid #ddd;
    vertical-align: middle;
  }

  .setting-table .table-title {
    text-align: center;
    font-size: 16px;
    font-weight: bold;
    padding: 12px 6px;
  }

  .setting-table .label-cell {
    width: 42%;
    text-align: right;
    white-space: nowrap;
  }

  .setting-table .value-cell {
    width: 58%;
  }

  .form-control {
    border: 1px solid #ddd;
    background: #FBFBFB;
    outline: 0;
    -webkit-box-shadow: inset 0 1px 6px #ECF3F5;
    box-shadow: inset 0 1px 6px #ECF3F5;
    font: 12px/25px Arial, Helvetica, sans-serif;
    border-radius: 4px;
    padding: 2px 6px;
    margin: 2px 0;
  }

  .form-control.input-short {
    width: 80px;
    text-align: center;
  }

  .form-control.select-medium {
    width: 200px;
  }

  .tip-text {
    margin-top: 4px;
    color: #666;
    font-size: 12px;
  }

  .action-cell {
    text-align: center;
    padding: 14px 6px;
  }

  .action-btn {
    min-width: 68px;
    padding: 4px 12px;
    cursor: pointer;
  }
</style>

<div>
  <form id="ruleForm" method="post" action="">
    <table class="setting-table">
      <tr>
        <td colspan="2" class="table-title">组卷限制设置</td>
      </tr>

      <tr>
        <td class="label-cell">未审核试题能否用于组卷：</td>
        <td class="value-cell">
          <select id="limit4Isreview" name="limit4Isreview" class="form-control select-medium">
            <option value="0" <c:if test="${applicationScope.limit4Isreview ne 1 && applicationScope.limit4Isreview ne '1'}">selected="selected"</c:if>>能</option>
            <option value="1" <c:if test="${applicationScope.limit4Isreview eq 1 || applicationScope.limit4Isreview eq '1'}">selected="selected"</c:if>>不能</option>
          </select>
        </td>
      </tr>

      <tr>
        <td class="label-cell">不选用：</td>
        <td class="value-cell">
          <input type="text"
                 id="usedDay"
                 name="usedDay"
                 value="${applicationScope.question_used_day}"
                 maxlength="6"
                 class="form-control input-short" />
          天内使用过的试题
          <div class="tip-text">输入 0 表示不限制天数；该条件与“使用次数限制”同时生效。</div>
        </td>
      </tr>

      <tr>
        <td class="label-cell">不选用：</td>
        <td class="value-cell">
          <input type="text"
                 id="useTime"
                 name="useTime"
                 value="${applicationScope.question_use_time}"
                 maxlength="6"
                 class="form-control input-short" />
          次及以上的试题
          <div class="tip-text">输入 0 表示不限制次数；该条件与“使用天数限制”同时生效。</div>
        </td>
      </tr>

      <tr>
        <td colspan="2" class="action-cell">
          <input type="button" id="saveBtn" class="action-btn" value="更新" />
          &nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" class="action-btn" value="返回" onclick="window.location.href = '${pageContext.request.contextPath}/system/params';" />
        </td>
      </tr>
    </table>
  </form>
</div>

<script type="text/javascript">
  (function ($) {
    function isNonNegativeInteger(value) {
      return /^(0|[1-9]\d*)$/.test($.trim(value));
    }

    function validateForm() {
      var usedDay = $.trim($("#usedDay").val());
      var useTime = $.trim($("#useTime").val());
      var limit4Isreview = $("#limit4Isreview").val();

      if (!isNonNegativeInteger(usedDay)) {
        toastr.warning("试题使用天数必须是大于等于0的整数");
        $("#usedDay").focus();
        return false;
      }

      if (!isNonNegativeInteger(useTime)) {
        toastr.warning("试题使用次数必须是大于等于0的整数");
        $("#useTime").focus();
        return false;
      }

      if (limit4Isreview !== "0" && limit4Isreview !== "1") {
        toastr.warning("请选择是否允许未审核试题用于组卷");
        $("#limit4Isreview").focus();
        return false;
      }

      return true;
    }

    function submitForm() {
      if (!validateForm()) {
        return;
      }

      $.ajax({
        url: "${pageContext.request.contextPath}/system/saveQuestionStructureRule",
        type: "POST",
        dataType: "text",
        data: {
          usedDay: $.trim($("#usedDay").val()),
          useTime: $.trim($("#useTime").val()),
          limit4Isreview: $("#limit4Isreview").val()
        },
        success: function (data) {
          if (data === "success") {
            toastr.success("修改成功！");
          } else if (data === "invalid") {
            toastr.warning("提交参数不合法，请检查后重试");
          } else {
            toastr.error("修改失败！");
          }
        },
        error: function () {
          toastr.error("请求失败，请稍后重试");
        }
      });
    }

    $("#saveBtn").on("click", submitForm);

    $("#usedDay, #useTime").on("keyup", function () {
      this.value = this.value.replace(/[^\d]/g, "");
    });
  })(jQuery);
</script>