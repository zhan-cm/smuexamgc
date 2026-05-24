<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../commons/taglibs.jsp"%>
<html>
<head>
    <title>2个试卷重复试题对比</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 90% !important; }
        .card { border-radius: 0.75rem; }
        .form-control, .form-check-input { border-radius: 0.5rem; }
        #queryBtn { width: 100px; }
        #refreshBtn, #backBtn { margin-left: 0.5rem; }
        #loadingOverlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.3);
            z-index: 1050;
            align-items: center;
            justify-content: center;
        }
        .toggle-btn {
            float: right;
            padding: 0;
            font-size: 0.9rem;
        }
        .collapse {
            transition: none !important;
        }
        @page { size: A4 portrait; margin: 12mm; }
        @media print {
            body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
            body * { visibility: hidden !important; }
            #printScope, #printScope * { visibility: visible !important; }
            #printScope { position: absolute; left: 0; top: 0; width: 100%; }
            /* 避免分页把列表项、卡片拆开 */
            .card, .list-group-item, .form-group { break-inside: avoid; page-break-inside: avoid; }
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">试卷重复试题对比</h5>
            <div>
                <button id="printBtn" class="btn btn-sm btn-outline-primary">打印PDF</button>
                <button id="refreshBtn" class="btn btn-sm btn-outline-secondary">刷新</button>
                <button id="backBtn" class="btn btn-sm btn-outline-secondary" onclick="cancelEasyUiFrame(0)">返回</button>
            </div>
        </div>
        <div class="card-body">
            <form id="compareForm" class="form-row align-items-end">
                <div class="form-group col-md-4">
                    <label for="eid1">试卷1编号</label>
                    <input type="text" class="form-control" id="eid1" placeholder="请输入第一个试卷编号">
                </div>
                <div class="form-group col-md-4">
                    <label for="eid2">试卷2编号</label>
                    <input type="text" class="form-control" id="eid2" placeholder="请输入第二个试卷编号">
                </div>
                <div class="form-group col-md-2">
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" id="answerMatch">
                        <label class="form-check-label" for="answerMatch">答案也要相同</label>
                    </div>
                </div>
                <div class="form-group col-md-2">
                    <button type="button" id="queryBtn" class="btn btn-primary btn-block">查询</button>
                </div>
            </form>
            <div id="noResultMsg" class="alert alert-warning text-center mt-3" style="display:none;">没有重复试题</div>
            <div id="countMsg" class="mt-2 font-weight-bold" style="display:none;"></div>
            <div id="summaryTable" class="mt-3"></div>
            <div id="resultArea" class="mt-4"></div>
            <div id="printScope" style="display:none;"></div>
        </div>
    </div>
</div>

<!-- Loading Overlay -->
<div id="loadingOverlay" class="d-none align-items-center justify-content-center">
    <div class="text-center">
        <div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>
        <div class="mt-2 text-white">正在查询中...</div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/styles/js/kaoyi_utils.js"></script>
<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/js/bootstrap.min.js"></script>
<script>
    function debounce(fn, delay) {
        var timer;
        return function() {
            var context = this, args = arguments;
            clearTimeout(timer);
            timer = setTimeout(function() { fn.apply(context, args); }, delay);
        };
    }

    function getRepeatDataList(eid1, eid2, answerMatch) {
        if (!eid1 || !eid2) {
            Swal.fire({ icon: 'warning', text: '请同时输入2个试卷编号框' });
            return;
        }
        if (eid1 && eid2 && eid1===eid2) {
            Swal.fire({ icon: 'warning', text: '无法对比两个相同的试卷' });
            return;
        }
        $('#noResultMsg, #countMsg').hide();
        $('#resultArea').empty();
        $('#loadingOverlay').removeClass('d-none').addClass('d-flex');
        $.ajax({
            url: '${pageContext.request.contextPath}/paper/findTwoPaperRepeatQuestions',
            type: 'POST',
            data: { eid1: eid1, eid2: eid2, answerMatch: answerMatch },
            success: function(data) {
                $('#loadingOverlay').removeClass('d-flex').addClass('d-none');
                console.log(data);
                if (!data || !data.repeatList || data.repeatList.length === 0) {
                    let errorMsg = "没有重复试题";
                    if(data && data.errorMsg){
                        errorMsg = data.errorMsg;
                    }
                    $('#noResultMsg').text(errorMsg);
                    $('#noResultMsg').show();
                } else {
                    $('#countMsg').html('共有 ' + data.repeatList.length +
                        ' 题重复，试卷（'+eid1+'）<span style="color: red">重复率为：'+ ((data.repeatList.length/data['all_1'])*100).toFixed(2) + '%</span>'
                    +'，试卷（'+eid2+'）<span style="color: red">重复率为：'+ ((data.repeatList.length/data['all_2'])*100).toFixed(2) + '%</span>').show();
                    renderSummary(data, eid1, eid2);
                    renderResults(data.repeatList);
                }
            },
            error: function(xhr, status, err) {
                $('#loadingOverlay').removeClass('d-flex').addClass('d-none');
                console.error('查询出错：', status, err);
            }
        });
    }

    function renderResults(data) {
        var subjIds = [5,6,7,10,11,12,13];
        var html = '';
        data.forEach(function(item, idx) {
            html += '<div class="row mb-4">';
            [1, 2].forEach(function(i) {
                html += '<div class="col-6 col-md-6">'
                    + '<div class="card h-100">'
                    + '<div class="card-body">'
                    + '<h6>'+'试卷'+item['fromEid'+i]+' 题目 ' + (idx+1) + '：</h6>'
                    + '<div>' + item['fromContent'+i] + '</div>'
                    + '<p class="mt-2 mb-1"><strong>题型：</strong>' + item.qtname + '</p>'
                    + '<p class="mb-1">'
                    + ' <strong>课程：</strong>' + item['fromCname'+i]
                    + ' | <strong>来源QID：</strong>' + item['fromQid'+i]
                    + ' | <strong>题序：</strong>' + item['fromTh'+i]
                    + ' | <strong>分数：</strong>' + item['fromScore'+i]
                    + '</p>';
                // 主题词
                var tnames = [];
                if (item['fromT1name'+i]) tnames.push(item['fromT1name'+i]);
                if (item['fromT2name'+i]) tnames.push(item['fromT2name'+i]);
                if (item['fromT3name'+i]) tnames.push(item['fromT3name'+i]);
                if (tnames.length) {
                    html += '<p class="mb-2 text-muted"><strong>主题词：</strong>' + tnames.join('/') + '</p>';
                }
                // 答案
                html += '<div class="mt-2"><strong>答案：</strong></div>'
                    + '<ul class="list-group list-group-flush">';
                if (subjIds.indexOf(parseInt(item.atid,10)) >= 0) {
                    var ans = item['fromAnswer'+i][0] && item['fromAnswer'+i][0].ACONTENT_6 ? item['fromAnswer'+i][0].ACONTENT_6 : '';
                    html += '<li class="list-group-item">' + ans + '</li>';
                } else if(parseInt(item.atid) === 4){
                    var ans = item['fromAnswer'+i][0].ACONTENT === 'false'?false:true;
                    html += '<li class="list-group-item '+(ans? 'list-group-item-success' : '')
                            +'">对'+ (ans? ' <span class="badge badge-light">正确</span>' : '')
                        + '</li>';
                    html += '<li class="list-group-item '+(!ans? 'list-group-item-success' : '')
                        +'">错'+ (!ans? ' <span class="badge badge-light">正确</span>' : '')
                        + '</li>';
                } else {
                    var correctIds = String(item['fromAnswerid'+i]).split(',');
                    item['fromAnswer'+i].forEach(function(opt) {
                        var isCorrect = correctIds.indexOf(opt.AID) >= 0;
                        html += '<li class="list-group-item ' + (isCorrect? 'list-group-item-success' : '') + '">'
                            + opt.ACONTENT
                            + (isCorrect? ' <span class="badge badge-light">正确</span>' : '')
                            + '</li>';
                    });
                }
                html += '</ul>'
                    + '</div></div></div>';
            });
            html += '</div>';
        });
        $('#resultArea').html(html);
    }

    function renderSummary(data, eid1, eid2) {
        // 1) 挑出所有 map 里的 key（去掉 repeatList）
        var keys = Object.keys(data).filter(function(k){
            return k !== 'repeatList';
        });
        // 2) 收集基名
        var baseTypes = {};
        keys.forEach(function(k){
            var base = k.replace(/(_1|_2)$/, '');
            baseTypes[base] = true;
        });
        var types = Object.keys(baseTypes);
        // 3) 拼表头
        var html = '<table class="table table-bordered text-center"><thead><tr>'
            +   '<th>题型</th><th>试卷' + eid1 + '（重复题数/总题数）</th><th>试卷' + eid2 + '（重复题数/总题数）</th>'
            + '</tr></thead><tbody>';
        // 4) 拼行
        types.forEach(function(type){
            var cntAll = data[type]         || 0;
            var cnt1   = data[type + '_1']  || 0;
            var cnt2   = data[type + '_2']  || 0;
            if (type === 'all') {
                html += '<tr class="summary-row" style="background:#f1f1f1;">'
                    +   '<td><strong>全部题型</strong></td>'
                    +   '<td>' + cntAll + ' 题 / ' + cnt1 + '题</td>'
                    +   '<td>' + cntAll + ' 题 / ' + cnt2 + '题'
                    +     '<button id="toggleBtn" class="btn btn-sm btn-link toggle-btn">展开</button>'
                    +   '</td>'
                    + '</tr>';
            } else {
                html += '<tr class="type-detail" style="display:none;">'
                    +   '<td>' + type + '</td>'
                    +   '<td>' + cntAll + ' 题 / ' + cnt1 + '题</td>'
                    +   '<td>' + cntAll + ' 题 / ' + cnt2 + '题</td>'
                    + '</tr>';
            }
        });
        html += '</tbody></table>';
        $('#summaryTable').html(html);

        // 5) 绑定按钮：用 show()/hide() 而非 collapse，消除动画卡顿
        var btn = $('#toggleBtn').data('expanded', false);
        btn.on('click', function(){
            var expanded = btn.data('expanded');
            if (!expanded) {
                $('.type-detail').show();
                btn.text('折叠');
            } else {
                $('.type-detail').hide();
                btn.text('展开');
            }
            btn.data('expanded', !expanded);
        });
    }

    $(function() {
        // 页面初始时禁用刷新按钮，3秒后启用
        var refreshBtn = $('#refreshBtn');
        refreshBtn.prop('disabled', true);
        setTimeout(function() { refreshBtn.prop('disabled', false); }, 2100);

        $('#queryBtn').click(function() {
            var btn = $(this);
            btn.prop('disabled', true);
            setTimeout(function() { btn.prop('disabled', false); }, 2100);
            var e1 = $('#eid1').val().trim();
            var e2 = $('#eid2').val().trim();
            var match = $('#answerMatch').is(':checked') ? 1 : 0;
            getRepeatDataList(e1, e2, match);
        });

        $('#refreshBtn').click(function() {
            var btn = $(this);
            btn.prop('disabled', true);
            setTimeout(function() { btn.prop('disabled', false); }, 2100);
            window.location.href = "${pageContext.request.contextPath}/paper/toPaperQuestionRepeatCompare?t="+new Date().getTime();
        });
        var initEids = '${eids}';
        if (initEids) {
            var parts = initEids.split(',');
            if (parts.length === 2) {
                $('#eid1').val(parts[0]);
                $('#eid2').val(parts[1]);
                $('#queryBtn').click();
            }
        }
    });

    function buildPrintScope() {
        const $wrap = $('<div class="p-4"></div>');
        $wrap.append($('#countMsg').clone().show());
        $wrap.append($('#summaryTable').clone());
        $wrap.append($('#resultArea').clone());
        return $wrap;
    }

    $('#printBtn').on('click', function() {
        const $scope = $('#printScope');
        $scope.empty().append(buildPrintScope()).show(); // 显示以便继承计算样式
        window.print();
        setTimeout(function(){ $scope.empty();$scope.hide(); }, 0);
    });
</script>
</body>
</html>