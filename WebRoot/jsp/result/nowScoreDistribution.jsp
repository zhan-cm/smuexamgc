<%@ page pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/echarts5.3.0.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/export/tableExport.js"></script>
<head>
    <link href="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">
</head>
<style>
    table {
        border-spacing: 0;
        border-collapse: collapse;
        border-radius: 3px;
    }
    td, th {
        padding: 5px;
        line-height: 1.2;
        vertical-align: center;
        border: 1px solid #ddd;
        text-align: center
    }
    h2,h3{
        text-align:center;
    }

    /* 只针对多选的场景下调样式 */
    .select2-container--default .select2-selection--multiple .select2-selection__rendered {
        max-height: 32px;    /* 你可以根据需要调整 */
        overflow-y: auto;
    }
</style>
<h2>${organizationinfo.PARAM }-${ei.ENAME }&nbsp;&nbsp;当前成绩分布</h2>
<div style="text-align: center;margin-bottom: 5px;"><span style="">${selectParam}</span></div>
<input type="hidden" id="selectedGrade" value="${selectedGrade}"/>
<input type="hidden" id="selectedSp" value="${selectedSp}"/>
<input type="hidden" id="selectedClass" value="${selectedClass}"/>
<div style="height:auto;margin-bottom:20px;text-align:center;">
    <a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" target="_self" onclick="cancelEasyUiFrame(0)">返回</a>
    <button class="btn btn-primary" onclick="reloadThisPage()">刷新</button>

    <select name="grade" id="grade" multiple></select>
    <select name="specialty" id="specialty" multiple></select>
    <select name="klass" id="klass" multiple></select>
    <a class="easyui-linkbutton" href="javascript:void(0);" target="_self" onclick="studentFilter()">查询</a>
    <br>
    &nbsp;&nbsp;&nbsp;&nbsp;考试日期：${ksrq }
    &nbsp;&nbsp;&nbsp;&nbsp;组卷人：${ei.TEACHERNAME }
</div>
<div id="content">

    <table style="width: 100%;" id="examTable">
        <tr>
            <th colspan="17">
                <span style="font-weight: bold;font-size: 20px;margin-right: 20px;">总体试卷情况</span>
            </th>
        </tr>
        <tr>
            <c:set var="etime" />
            <c:if test="${(ei.EXAMTIME%60) > 0}">
                <c:set var="etime" value="${(ei.EXAMTIME%60)}秒" />
            </c:if>
            <c:if test="${(ei.EXAMTIME%3600)/60 > 0}">
                <fmt:parseNumber var="min" integerOnly="true" value="${(ei.EXAMTIME%3600)/60}" />
                <c:set var="etime" value="${min}分  ${etime}" />
            </c:if>
            <c:if test="${(ei.EXAMTIME-1800)/3600 > 0}">
                <fmt:parseNumber var="hour" integerOnly="true" value="${(ei.EXAMTIME-1800)/3600}" />
                <c:set var="etime" value="${hour}小时  ${etime}" />
            </c:if>
            <td id="rlwsTimeAndScore" colspan="17">考试时长：${etime}， 试卷总分：${ei.SCORE}</td>
        </tr>
        <tr>
            <th>考试人数</th>
            <th>最高分</th>
            <th>中位数</th>
            <th>最低分</th>
            <th>平均分</th>
            <th>全距 </th>
            <th>及格率</th>
            <th>优秀率</th>
            <th>标准差</th>
        </tr>

        <tr>
            <td>${rl.COUNT}</td>
            <td>${rl.MAXSCORE}</td>
            <td>${rl.MIDSCORE}</td>
            <td>${rl.MINSCORE}</td>
            <td>${rl.AVGSCORE}</td>
            <td>${rl.RANGESCORE}</td>
            <td>${rl.PASS}</td>
            <td>${rl.GOOD}</td>
            <td>${rl.STDDEVSCORE}</td>
        </tr>
    </table>

    <%-- 学生成绩分布统计（每行一个分布） --%>
    <table style="width: 100%;" id="scoreDistTable">
        <tr>
            <th colspan="3" style="font-weight: bold;font-size: 20px;">学生成绩分布统计</th>
        </tr>
        <tr>
            <th>分数段</th>
            <th>人数</th>
            <th>比例</th>
        </tr>

        <%-- 计算格式（沿用你原来的逻辑） --%>
        <c:choose>
            <c:when test="${fn:indexOf(ei.SCORE*0.7, '.') == -1
           or (fn:indexOf(ei.SCORE*0.7, '.99') != -1
               and fn:indexOf(ei.SCORE,'.')==-1)}">
                <c:set var="pattern" value="0"/>
                <c:set var="delta"   value="1"/>
            </c:when>
            <c:when test="${(fn:indexOf(ei.SCORE*0.7, '.') >= 3
             and fn:indexOf(ei.SCORE*0.7, '.99') == -1)
            or (fn:indexOf(ei.SCORE*0.7, '.') > -1
                and fn:indexOf(ei.SCORE,'.')==-1)}">
                <c:set var="pattern" value="0.0"/>
                <c:set var="delta"   value="0.1"/>
            </c:when>
            <c:otherwise>
                <c:set var="pattern" value="0.00"/>
                <c:set var="delta"   value="0.01"/>
            </c:otherwise>
        </c:choose>

        <c:set var="totalCount" value="${empty sl.COUNT ? 0 : sl.COUNT}" />

        <%-- PER0 --%>
        <tr>
            <td>0 - <fmt:formatNumber value="${ei.SCORE * 0.1 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER0 ? 0 : sl.PER0}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <%--BigDecimal的除法，小数会被忽略，要*1w倍再除回来--%>
                        <fmt:formatNumber value="${((empty sl.PER0 ? 0 : sl.PER0) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER1 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.1}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.2 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER1 ? 0 : sl.PER1}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <%--BigDecimal的除法，小数会被忽略，要*1w倍再除回来--%>
                        <fmt:formatNumber value="${((empty sl.PER1 ? 0 : sl.PER1) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER2 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.2}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.3 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER2 ? 0 : sl.PER2}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER2 ? 0 : sl.PER2) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER3 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.3}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.4 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER3 ? 0 : sl.PER3}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER3 ? 0 : sl.PER3) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER4 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.4}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.5 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER4 ? 0 : sl.PER4}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER4 ? 0 : sl.PER4) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER5 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.5}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.6 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER5 ? 0 : sl.PER5}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER5 ? 0 : sl.PER5) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER6 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.6}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.7 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER6 ? 0 : sl.PER6}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER6 ? 0 : sl.PER6) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER7 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.7}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.8 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER7 ? 0 : sl.PER7}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER7 ? 0 : sl.PER7) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER8 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.8}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.9 - delta}" pattern="${pattern}"/></td>
            <td>${empty sl.PER8 ? 0 : sl.PER8}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER8 ? 0 : sl.PER8) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>

        <%-- PER9 --%>
        <tr>
            <td><fmt:formatNumber value="${ei.SCORE * 0.9}" pattern="${pattern}"/> 以上</td>
            <td>${empty sl.PER9 ? 0 : sl.PER9}</td>
            <td>
                <c:choose>
                    <c:when test="${totalCount > 0}">
                        <fmt:formatNumber value="${((empty sl.PER9 ? 0 : sl.PER9) * 10000 / totalCount) * 0.01}" pattern="0.00"/>%
                    </c:when>
                    <c:otherwise>0.00%</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    <div id="scoreBar" style="width: 100%; height: 380px; margin-top: 12px;"></div>
</div>

<div style="width: 100%; height: 40px; text-align: center;">
    <a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" href="javascript:void(0)" onclick="reloadThisPage()">刷新</a>
    <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" href="javascript:void(0);" target="_self" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
<input type="hidden" id="eid" name="eid" value="${ei.ID}"/>
<input type="hidden" id="score" name="score" value="${ei.SCORE}"/>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        var gList = <%= request.getAttribute("gList") %>;
        var spList = <%= request.getAttribute("spList") %>;
        var cList  = <%= request.getAttribute("cList") %>;

        var specialties = (spList || []).map(s => ({
            id: s.ID || s.id,
            name: s.NAME || s.name,
            classList: (s.classes || []).map(c => {
                if (typeof c === 'string') return { name: c };
                return { name: c.name };
            })
        }));

        var classes = (cList || []).map(c => {
            if (typeof c === 'string') return { name: c };
            return { name: c.name};
        });


        // 初始化“专业”下拉
        $('#specialty').select2({
            placeholder: "选择专业",
            allowClear: true,
            multiple: true,          // 关键：允许多选
            width: '300px',
            closeOnSelect: false     // 常用于多选时不自动收起
        });

        // 初始化“班级”下拉
        $('#klass').select2({
            placeholder: "选择班级",
            allowClear: true,
            multiple: true,          // 如果班级也需要多选，则保留；否则去掉
            width: '300px',
            closeOnSelect: false
        });

        $('#grade').select2({
            placeholder: "选择年级",
            allowClear: true,
            multiple: true,
            width: '205px',
            closeOnSelect: false
        });
        var grades = (gList || []).map(function(g){
            return {
                id:   g.id   || g.ID,
                name: g.name || g.NAME,
                specialties: g.specialties || g.SPECIALTIES || [],
                classes:     g.classes     || g.CLASSES     || []
            };
        });

        grades.forEach(function(g){
            $('#grade').append(new Option(g.name || g.id, g.id));
        });

        // 追加所有专业选项
        specialties.forEach(s => {
            $('#specialty').append(new Option(s.name, s.id));
        });

        /**
         * 根据所选专业（可能是多个），来刷新“班级”下拉框。
         *
         * @param {Array} selectedSpecialtyIds - 选中的专业 ID 数组
         */
        function populateClassSelect(selectedSpecialtyIds) {
            $('#klass').empty();
            if (!selectedSpecialtyIds || selectedSpecialtyIds.length === 0) {
                classes.forEach(c => {
                    $('#klass').append(new Option(c.name, c.name));
                });
            } else {
                const nameSet = new Set();
                selectedSpecialtyIds.forEach(id => {
                    const sp = specialties.find(s => String(s.id) === String(id));
                    if (sp && sp.classList) {
                        sp.classList.forEach(cls => {
                            const nm = (typeof cls === 'string') ? cls : (cls.name || cls.NAME);
                            if (nm) nameSet.add(nm);
                        });
                    }
                });
                nameSet.forEach(nm => {
                    $('#klass').append(new Option(nm, nm));
                });
            }

            $('#klass').val(null).trigger('change.select2');
        }

        // A) 选了“年级”（可能多选）后，按所选年级聚合出“可选专业”列表
        function populateSpecialtyByGrades(selectedGradeIds) {
            $('#specialty').empty();
            if (!selectedGradeIds || selectedGradeIds.length === 0) {
                // 年级未选：回到“全部专业”
                specialties.forEach(function(s){ $('#specialty').append(new Option(s.name, s.id)); });
                $('#specialty').val(null).trigger('change.select2');
                return;
            }
            // 取所选年级下所有专业的并集（按 id 去重）
            var specMap = {};
            selectedGradeIds.forEach(function(gid){
                var g = grades.find(function(x){ return String(x.id) === String(gid); });
                if (!g) return;
                (g.specialties || []).forEach(function(sp){
                    var sid = sp.id || sp.ID;
                    var sname = sp.name || sp.NAME;
                    if (sid != null && specMap[sid] == null) specMap[sid] = sname;
                });
            });
            Object.keys(specMap).forEach(function(sid){
                $('#specialty').append(new Option(specMap[sid], sid));
            });
            $('#specialty').val(null).trigger('change.select2');
        }

// B) 年级 + 专业（均可多选）=> 班级是【所选年级】下【所选专业】的班级并集
        function populateClassByGradesAndSpecs(gradeIds, specIds) {
            $('#klass').empty();
            var clsSet = new Set();
            (gradeIds || []).forEach(function(gid){
                var g = grades.find(function(x){ return String(x.id) === String(gid); });
                if (!g) return;
                (g.specialties || []).forEach(function(sp){
                    var sid = sp.id || sp.ID;
                    if (specIds && specIds.length > 0 && !specIds.includes(String(sid))) return;
                    (sp.classes || []).forEach(function(c){
                        var name = typeof c === 'string' ? c : (c.name || c.NAME);
                        if (name) clsSet.add(name);
                    });
                });
            });
            // 渲染
            Array.from(clsSet).forEach(function(nm){
                $('#klass').append(new Option(nm, nm));
            });
            $('#klass').val(null).trigger('change.select2');
        }

        // 初始化班级列表（默认走一次）
        populateClassSelect(null);

        // 年级 change：选了年级 => 先按年级过滤专业；班级禁用，待选专业后再放开
        $('#grade').on('change', function(){
            var selectedGrades = $(this).val() || [];
            if (selectedGrades.length === 0) {
                populateSpecialtyByGrades([]);
                populateClassSelect(null);
                $('#klass').prop('disabled', false).data('locked', false).trigger('change.select2');
            } else {
                // 年级已选：按年级缩小专业；班级禁用并清空，等待选择专业
                populateSpecialtyByGrades(selectedGrades);
                $('#klass').prop('disabled', true);
                $('#klass').empty().append(new Option("请先选择专业", "")).val(null).trigger('change.select2');
            }
        });

        // 监听“专业”下拉框变化事件
        $('#specialty').on('change', function(){
            var selectedSpecs  = $(this).val() || [];

            // 若“先选班级导致的锁定”存在，则不响应（第 5.3 步会设置）
            if ($('#klass').data('locked') === true) return;

            var selectedGrades = $('#grade').val() || [];
            // “未选年级”分支：锁定年级，按“专业（全局）”填充班级
            if (selectedGrades.length === 0) {
                if (selectedSpecs.length > 0) {
                    $('#grade').prop('disabled', true);
                    populateClassSelect(selectedSpecs);             // 你原函数：按专业并集 → 班级并集
                    $('#klass').prop('disabled', false).trigger('change.select2');
                } else {
                    // 专业清空 => 解锁年级，班级回到全部
                    $('#grade').prop('disabled', false);
                    populateClassSelect(null);
                    $('#klass').prop('disabled', false);
                }
            } else {
                // “已选年级”分支：需要“年级 + 专业”共同决定班级
                if (selectedSpecs.length > 0) {
                    populateClassByGradesAndSpecs(selectedGrades, selectedSpecs);
                    $('#klass').prop('disabled', false);
                } else {
                    // 年级有、专业空 => 班级禁用，提示先选专业
                    $('#klass').prop('disabled', true);
                    $('#klass').empty().append(new Option("请先选择专业", "")).val(null).trigger('change.select2');
                }
            }
        });

        $('#klass').on('select2:opening', function(e){
            var gids = $('#grade').val() || [];
            var sids = $('#specialty').val() || [];
            var gradeChosen = (gids.length > 0);
            var specEmpty   = (sids.length === 0);
            if (gradeChosen && specEmpty) {
                e.preventDefault();
                if (window.toastr && toastr.warning) toastr.warning('请先选择专业');
            }
        });

        // 专业被“全清”的兜底处理：解锁年级、恢复全部班级、解除班级锁定
        function onSpecialtyCleared() {
            $('#grade').prop('disabled', false).val([]).trigger('change.select2');
            $('#klass').prop('disabled', false).data('locked', false);
            populateClassSelect(null);
        }

// 1) 明确监听 select2:clear（点击右侧灰色“×”）
        $('#specialty').on('select2:clear', function(){
            onSpecialtyCleared();
        });

// 2) 监听逐个移除的场景：当移除后已无任何选中项时，同样执行清空逻辑
        $('#specialty').on('select2:unselect', function(){
            var vals = $('#specialty').val() || [];
            if (vals.length === 0 || (vals.length === 1 && vals[0] === "")) {
                onSpecialtyCleared();
            }
        });

        $('#grade').on('select2:clear', function(){
            populateSpecialtyByGrades([]);              // 回到全部专业
            $('#specialty').val([]).trigger('change.select2'); // 同步清空选中
            $('#klass').prop('disabled', false).data('locked', false);
            populateClassSelect(null);                   // 回到全部班级
        });

        // 班级 change：若在“年级、专业均未选”的情况下先选了班级 => 锁定年级与专业
        $('#klass').on('change', function(){
            var selectedClasses = $(this).val() || [];

            if (selectedClasses.length > 0) {
                // 仅当“年级未选 且 专业未选”时触发锁定
                var gradeEmpty = !($('#grade').val() && $('#grade').val().length > 0);
                var specEmpty  = !($('#specialty').val() && $('#specialty').val().length > 0);
                if (gradeEmpty && specEmpty) {
                    $('#grade').val(null).trigger('change.select2').prop('disabled', true);
                    $('#specialty').val(null).trigger('change.select2').prop('disabled', true);
                    $('#klass').data('locked', true);
                }
            } else {
                // 清空班级 => 解锁
                $('#grade').prop('disabled', false);
                $('#specialty').prop('disabled', false);
                $('#klass').data('locked', false);
            }
        });


        const labels = [
            '0 - <fmt:formatNumber value="${ei.SCORE * 0.1 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.1}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.2 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.2}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.3 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.3}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.4 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.4}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.5 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.5}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.6 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.6}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.7 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.7}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.8 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.8}" pattern="${pattern}"/> - <fmt:formatNumber value="${ei.SCORE * 0.9 - delta}" pattern="${pattern}"/>',
            '<fmt:formatNumber value="${ei.SCORE * 0.9}" pattern="${pattern}"/>以上'
        ];

        const counts = [
            ${empty sl.PER0 ? 0 : sl.PER0},
            ${empty sl.PER1 ? 0 : sl.PER1},
            ${empty sl.PER2 ? 0 : sl.PER2},
            ${empty sl.PER3 ? 0 : sl.PER3},
            ${empty sl.PER4 ? 0 : sl.PER4},
            ${empty sl.PER5 ? 0 : sl.PER5},
            ${empty sl.PER6 ? 0 : sl.PER6},
            ${empty sl.PER7 ? 0 : sl.PER7},
            ${empty sl.PER8 ? 0 : sl.PER8},
            ${empty sl.PER9 ? 0 : sl.PER9}
        ];

        const dom = document.getElementById('scoreBar');
        if (!dom) return;

        const chart = echarts.init(dom);
        const option = {
            title: { text: '', left: 'center' },
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '3%', right: '3%', bottom: '10%', containLabel: true },
            xAxis: {
                type: 'category',
                data: labels,
                axisLabel: { interval: 0, rotate: 25 }
            },
            yAxis: { type: 'value', name: '人数' },
            series: [{
                name: '人数',
                type: 'bar',
                data: counts,
                label: { show: true, position: 'top' }
            }]
        };
        chart.setOption(option);

        window.addEventListener('resize', function () {
            chart.resize();
        });
    });


    function studentFilter(){
        var url = '${pageContext.request.contextPath}/result/nowScoreDistribution?eid=' + $("#eid").val();
        if($("#specialty").val()!=""){
            url+='&spArray='+$("#specialty").val();
        }
        if($("#klass").val()!=="" && $("#klass").val()!==undefined){
            url+='&cArray='+encodeURIComponent($("#klass").val());
        }
        if ($("#grade").val() != "") {
            url += '&gradeArray=' + $("#grade").val();
        }
        location.href=url;
    }

    function reloadThisPage(){
        window.location.href = '${pageContext.request.contextPath}/result/nowScoreDistribution?eid=' + $("#eid").val();
    }
</script>