<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<style>
    body{
        font-size: 12px;
    }
    .config-wrap{
        width: 100%;
        margin: 0 auto;
    }
    .config-title{
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        margin: 10px 0 15px 0;
    }
    .config-toolbar{
        margin-bottom: 12px;
        padding: 10px 12px;
        background: #f7f7f7;
        border: 1px solid #e5e5e5;
        border-radius: 6px;
    }
    .config-toolbar .count{
        color: #d9534f;
        font-weight: bold;
        padding: 0 4px;
    }
    .config-toolbar .tip{
        color: #666;
        margin-left: 10px;
    }
    table {
        width: 100%;
        border-spacing: 0;
        border-collapse: collapse;
        border: 1px solid #ddd;
    }
    table th, table td {
        padding: 8px 10px;
        line-height: 1.5;
        border: 1px solid #ddd;
        vertical-align: middle;
    }
    table th {
        background: #f5f5f5;
        font-weight: bold;
    }
    table select {
        min-width: 260px;
        height: 32px;
        border: 1px solid #ccc;
        background: #fff;
        border-radius: 4px;
        padding: 0 6px;
        outline: 0;
    }
    .row-changed{
        background: #fff8e1;
    }
    .status-normal{
        color: #999;
    }
    .status-changed{
        color: #d9534f;
        font-weight: bold;
    }
    .current-text{
        color: #333;
    }
    .btn-area{
        text-align: center;
        margin-top: 18px;
    }
    .btn-area input{
        min-width: 120px;
        height: 34px;
        margin: 0 8px;
        border: 1px solid #ccc;
        background: #f8f8f8;
        border-radius: 4px;
        cursor: pointer;
    }
    .btn-area input:hover{
        background: #efefef;
    }
    .btn-area input[disabled]{
        cursor: not-allowed;
        opacity: 0.6;
    }
</style>

<div class="config-wrap">
    <div class="config-title">考试相关开关统一配置</div>

    <div class="config-toolbar">
        当前已变更 <span id="changedCount" class="count">0</span> 项
        <span class="tip">“只更新已变更”只会提交标记为已变更的项；“全部更新”会提交当前页全部项。</span>
    </div>

    <form id="switchForm">
        <table>
            <thead>
            <tr>
                <th style="width:60px;">序号</th>
                <th style="width:220px;">参数名称</th>
                <th style="width:320px;">配置值</th>
                <th>当前选择说明</th>
                <th style="width:220px;">状态</th>
            </tr>
            </thead>
            <tbody>

            <tr class="switch-row" data-name="beginexam_switch">
                <td style="text-align:center;">5</td>
                <td>开始答题限制</td>
                <td>
                    <select class="switch-select"
                            name="beginexam_switch"
                            data-original="${applicationScope.beginexam_switch}"
                            data-title="开始答题限制"
                            data-off-text="登录即可答题"
                            data-on-text="考试开始后才能答题">
                        <option value="0" <c:if test="${applicationScope.beginexam_switch eq '0'}">selected="selected"</c:if>>登录即可答题</option>
                        <option value="1" <c:if test="${applicationScope.beginexam_switch eq '1'}">selected="selected"</c:if>>考试开始后才能答题</option>
                    </select>
                </td>
                <td>
                        <span class="current-text">
                            <c:choose>
                                <c:when test="${applicationScope.beginexam_switch eq '1'}">考试开始后才能答题</c:when>
                                <c:otherwise>登录即可答题</c:otherwise>
                            </c:choose>
                        </span>
                </td>
                <td><span class="change-tip status-normal">未变更</span></td>
            </tr>

            <tr class="switch-row" data-name="paperdate_switch">
                <td style="text-align:center;">8</td>
                <td>超2月未封存试卷能否组卷</td>
                <td>
                    <select class="switch-select"
                            name="paperdate_switch"
                            data-original="${applicationScope.paperdate_switch}"
                            data-title="超2月未封存试卷能否组卷"
                            data-off-text="不能"
                            data-on-text="能">
                        <option value="0" <c:if test="${applicationScope.paperdate_switch eq '0'}">selected="selected"</c:if>>能</option>
                        <option value="1" <c:if test="${applicationScope.paperdate_switch eq '1'}">selected="selected"</c:if>>不能</option>
                    </select>
                </td>
                <td>
                        <span class="current-text">
                            <c:choose>
                                <c:when test="${applicationScope.paperdate_switch eq '1'}">不能</c:when>
                                <c:otherwise>能</c:otherwise>
                            </c:choose>
                        </span>
                </td>
                <td><span class="change-tip status-normal">未变更</span></td>
            </tr>

            <tr class="switch-row" data-name="pass_switch">
                <td style="text-align:center;">10</td>
                <td>强密码开关</td>
                <td>
                    <select class="switch-select"
                            name="pass_switch"
                            data-original="${applicationScope.pass_switch}"
                            data-title="强密码开关"
                            data-off-text="关闭"
                            data-on-text="开启">
                        <option value="0" <c:if test="${applicationScope.pass_switch eq '0'}">selected="selected"</c:if>>关闭</option>
                        <option value="1" <c:if test="${applicationScope.pass_switch eq '1'}">selected="selected"</c:if>>开启</option>
                    </select>
                </td>
                <td>
                        <span class="current-text">
                            <c:choose>
                                <c:when test="${applicationScope.pass_switch eq '1'}">开启</c:when>
                                <c:otherwise>关闭</c:otherwise>
                            </c:choose>
                        </span>
                </td>
                <td><span class="change-tip status-normal">未变更</span></td>
            </tr>
            </tbody>
        </table>

        <div class="btn-area">
            <input type="button" id="btnUpdateChanged" value="只更新已变更" onclick="submitConfig('changed')"/>
            <input type="button" id="btnUpdateAll" value="全部更新" onclick="submitConfig('all')"/>
            <input type="button" value="返回" onclick="window.location.href='${pageContext.request.contextPath}/system/params';"/>
        </div>
    </form>
</div>

<script type="text/javascript">
    var contextPath = '${pageContext.request.contextPath}';

    $(function(){
        $('.switch-select').each(function(){
            refreshRowStatus($(this));
        });

        $('.switch-select').on('change', function(){
            refreshRowStatus($(this));
        });

        refreshChangedCount();
    });

    function refreshRowStatus($select){
        var originalVal = String($select.attr('data-original'));
        var currentVal = $select.val();

        var $row = $select.closest('.switch-row');
        var $tip = $row.find('.change-tip');
        var currentText = currentVal === '1' ? $select.attr('data-on-text') : $select.attr('data-off-text');

        $row.find('.current-text').text(currentText);

        if (currentVal !== originalVal) {
            $row.addClass('row-changed');
            $tip.removeClass('status-normal').addClass('status-changed').text('已变更，提交时会更新');
        } else {
            $row.removeClass('row-changed');
            $tip.removeClass('status-changed').addClass('status-normal').text('未变更');
        }

        refreshChangedCount();
    }

    function refreshChangedCount(){
        $('#changedCount').text($('.row-changed').length);
    }

    function buildPayload(mode){
        var payload = {};
        payload.updateMode = mode;

        if (mode === 'all') {
            $('.switch-select').each(function(){
                payload[this.name] = $(this).val();
            });
            return payload;
        }

        $('.switch-select').each(function(){
            var $this = $(this);
            var originalVal = String($this.attr('data-original'));
            var currentVal = $this.val();

            if (currentVal !== originalVal) {
                payload[this.name] = currentVal;
            }
        });

        var changedCount = 0;
        for (var k in payload) {
            if (k !== 'updateMode') {
                changedCount++;
            }
        }

        if (changedCount === 0) {
            toastr.info('当前没有变更项可提交');
            return null;
        }

        return payload;
    }

    function setBtnDisabled(disabled){
        $('#btnUpdateAll').prop('disabled', disabled);
        $('#btnUpdateChanged').prop('disabled', disabled);
    }

    function submitConfig(mode){
        var payload = buildPayload(mode);
        if (!payload) {
            return;
        }

        setBtnDisabled(true);

        $.ajax({
            url: contextPath + '/system/updateCommonSwitch',
            type: 'post',
            data: payload,
            dataType: 'json',
            success: function(res){
                if (res && res.success) {
                    if (mode === 'all') {
                        $('.switch-select').each(function(){
                            $(this).attr('data-original', $(this).val());
                            refreshRowStatus($(this));
                        });
                    } else {
                        if (res.updatedNames && res.updatedNames.length > 0) {
                            for (var i = 0; i < res.updatedNames.length; i++) {
                                var name = res.updatedNames[i];
                                var $select = $('.switch-select[name="' + name + '"]');
                                $select.attr('data-original', $select.val());
                                refreshRowStatus($select);
                            }
                        }
                    }

                    toastr.success((res.msg || '更新成功') + '，成功提交 ' + (res.count || 0) + ' 项');
                } else {
                    toastr.error((res && res.msg) ? res.msg : '更新失败');
                }
            },
            error: function(){
                toastr.error('请求失败');
            },
            complete: function(){
                setBtnDisabled(false);
            }
        });
    }
</script>