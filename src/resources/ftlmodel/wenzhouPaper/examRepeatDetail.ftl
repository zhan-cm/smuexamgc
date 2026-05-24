<#ftl output_format="HTML" auto_esc=true>
<#--
    repeatDetail 当前期望类型：Map<String, List<DuplicatePairDTO>>
    默认沿用旧模板的三个 key：aDetail、bDetail、abDetail。
    如果后端 Map 的 key 已改名，只需要调整下面三个 assign。
-->
<#assign repeatDetailMap = repeatDetail!{} />
<#assign aDetail = (repeatDetailMap.aDetail)![] />
<#assign bDetail = (repeatDetailMap.bDetail)![] />
<#assign abDetail = (repeatDetailMap.abDetail)![] />

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"/>
    <title>${ename}查重详情</title>

    <#if baseUrl?? && baseUrl?has_content>
        <base href="${baseUrl}/">
    </#if>

    <style>
        html, body {
            margin: 0;
            padding: 0;
            background: #ffffff;
            color: #222222;
            font-family: "Microsoft YaHei", "PingFang SC", "SimSun", Arial, sans-serif;
            font-size: 12px;
            line-height: 1.6;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        * {
            box-sizing: border-box;
        }

        .doc-wrap {
            width: 100%;
        }

        .title-table,
        .meta-table,
        .section-table,
        .item-table,
        .pair-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .title-table {
            margin-bottom: 10px;
            border: 1px solid #cfd8e3;
        }

        .title-cell {
            padding: 12px 14px 8px 14px;
            background: #f4f7fb;
        }

        .page-title {
            margin: 0 0 6px 0;
            font-size: 22px;
            font-weight: 700;
            color: #1f2a37;
        }

        .page-subtitle {
            margin: 0;
            font-size: 12px;
            color: #5f6b7a;
            line-height: 1.7;
        }

        .meta-table {
            margin-bottom: 14px;
            border: 1px solid #cfd8e3;
        }

        .meta-table td {
            border: 1px solid #cfd8e3;
            padding: 8px 10px;
            vertical-align: middle;
            word-break: break-word;
        }

        .meta-label {
            width: 90px;
            background: #f8fafc;
            color: #4b5563;
            font-weight: 700;
            text-align: center;
        }

        .meta-value {
            background: #ffffff;
        }

        .section-table {
            margin-top: 12px;
            margin-bottom: 10px;
            border: 1px solid #cfd8e3;
        }

        .section-table td {
            border: 1px solid #cfd8e3;
            padding: 8px 10px;
            vertical-align: middle;
        }

        .section-title {
            background: #eef3f8;
            font-size: 17px;
            font-weight: 700;
            color: #1f2937;
        }

        .section-count {
            width: 100px;
            text-align: center;
            background: #f8fafc;
            color: #1d4ed8;
            font-weight: 700;
        }

        .item-table {
            margin-bottom: 10px;
            border: 1px solid #d6dde6;
            page-break-inside: avoid;
            break-inside: avoid;
        }

        .item-title-row td {
            border: 1px solid #d6dde6;
            padding: 8px 10px;
            background: #f7f9fc;
            font-size: 14px;
            font-weight: 700;
            color: #1f2937;
        }

        .score-badge {
            display: inline-block;
            margin-left: 10px;
            padding: 1px 8px;
            border: 1px solid #cfd8e3;
            background: #ffffff;
            color: #4b5563;
            font-size: 12px;
            font-weight: 400;
            line-height: 1.6;
            vertical-align: middle;
        }

        .pair-table {
            border-top: none;
            table-layout: fixed !important;
        }

        /* 用 colgroup + td class 双保险，尽量压住 Aspose 的自动列宽 */
        .pair-table col.col-origin {
            width: 50%;
        }

        .pair-table col.col-duplicate {
            width: 50%;
        }

        .pair-table td {
            border: 1px solid #d6dde6;
            padding: 10px;
            vertical-align: top;
            word-break: break-word;
        }

        .pair-td-origin {
            width: 50%;
        }

        .pair-td-duplicate {
            width: 50%;
        }

        .cell-head {
            margin-bottom: 8px;
        }

        .cell-tag {
            display: inline-block;
            padding: 2px 8px;
            border: 1px solid #cfd8e3;
            background: #f8fafc;
            font-size: 11px;
            font-weight: 700;
            line-height: 1.5;
        }

        .tag-origin {
            color: #1d4ed8;
            background: #eef4ff;
            border-color: #c8d9ff;
        }

        .tag-duplicate {
            color: #b45309;
            background: #fff6eb;
            border-color: #f6d3ab;
        }

        .q-meta-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            margin-bottom: 8px;
        }

        .q-meta-table td {
            border: 1px solid #e5e7eb;
            padding: 4px 6px;
            font-size: 11px;
            color: #4b5563;
            background: #fafbfc;
            word-break: break-word;
        }

        .q-meta-label {
            width: 45px;
            text-align: center;
            font-weight: 700;
            color: #6b7280;
        }

        /* 只保留一个纯内容承载区，不再人为包一层框。 */
        .content-outer {
            border: none;
            background: transparent;
            padding: 0;
            min-height: 0;
            word-break: break-word;
            white-space: pre-line;
            overflow: visible;
        }

        .empty-box {
            border: 1px dashed #d1d5db;
            background: #fafafa;
            color: #9ca3af;
            min-height: 120px;
            padding: 46px 10px;
            text-align: center;
            line-height: 1.7;
        }

        .no-data-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            margin-top: 10px;
        }

        .no-data-table td {
            border: 1px solid #d6dde6;
            background: #fafbfc;
            color: #6b7280;
            text-align: center;
            padding: 26px 12px;
            font-size: 13px;
        }

        /* 富文本兜底：只控版式，不再给内部 table / td / th 强行加边框 */
        .content-rich,
        .content-rich * {
            max-width: 100% !important;
            box-sizing: border-box !important;
            font-family: "Microsoft YaHei", "PingFang SC", "SimSun", Arial, sans-serif !important;
            font-size: 15px !important;
        }

        .content-rich p,
        .content-rich div,
        .content-rich li,
        .content-rich span,
        .content-rich font {
            line-height: 1.7 !important;
            font-size: 15px !important;
            word-break: break-word !important;
        }

        .content-rich p,
        .content-rich div,
        .content-rich li {
            margin-top: 0 !important;
            margin-bottom: 6px !important;
        }

        .content-rich *:not(table):not(thead):not(tbody):not(tfoot):not(tr):not(td):not(th):not(colgroup):not(col):not(caption) {
            outline: none !important;
            box-shadow: none !important;
        }

        .content-rich div,
        .content-rich p,
        .content-rich section,
        .content-rich article,
        .content-rich aside,
        .content-rich header,
        .content-rich footer,
        .content-rich figure,
        .content-rich figcaption,
        .content-rich blockquote,
        .content-rich ul,
        .content-rich ol,
        .content-rich li,
        .content-rich dl,
        .content-rich dt,
        .content-rich dd {
            border: none !important;
            background: transparent !important;
        }

        .content-rich table {
            max-width: 100% !important;
            border-collapse: collapse;
            table-layout: auto;
            margin: 4px 0 !important;
        }

        .content-rich td,
        .content-rich th {
            word-break: break-word !important;
            vertical-align: top !important;
        }

        .content-rich img {
            max-width: 100% !important;
            height: auto !important;
        }
    </style>
</head>
<body>

<#macro renderCell tagClass tagText tdClass q={} emptyText=''>
    <td class="${tdClass}">
        <div class="cell-head">
            <span class="cell-tag ${tagClass}">${tagText}</span>
        </div>

        <#if q?has_content>
            <table class="q-meta-table">
                <tr>
                    <td class="q-meta-label">eid</td>
                    <td>${(q.eid)!''}</td>
                </tr>
                <tr>
                    <td class="q-meta-label">qid</td>
                    <td>${(q.qid)!''}</td>
                </tr>
            </table>

            <div class="content-outer">
                <div class="content-rich">
                    ${((q.contentRaw)!'')?no_esc}
                </div>
            </div>
        <#else>
            <div class="empty-box">${emptyText}</div>
        </#if>
    </td>
</#macro>

<#macro renderScore item>
    <#if item.score??>
        <span class="score-badge">相似度得分：${item.score?string("0.####")}</span>
    </#if>
</#macro>

<#macro renderSection sectionTitle items itemTitlePrefix>
    <#if items?has_content>
        <table class="section-table">
            <tr>
                <td class="section-title">${sectionTitle}</td>
                <td class="section-count">共 ${items?size} 条</td>
            </tr>
        </table>

        <#list items as item>
            <table class="item-table">
                <tr class="item-title-row">
                    <td>
                        ${itemTitlePrefix} #${item_index + 1}
                        <@renderScore item=item />
                    </td>
                </tr>
                <tr>
                    <td style="padding:0;border:none;">
                        <table class="pair-table">
                            <colgroup>
                                <col class="col-origin" style="width:50%;" width="50%"/>
                                <col class="col-duplicate" style="width:50%;" width="50%"/>
                            </colgroup>
                            <tr>
                                <@renderCell
                                tagClass="tag-origin"
                                tagText="原题"
                                tdClass="pair-td-origin"
                                q=(item.origin)!{}
                                emptyText="无原题"
                                />
                                <@renderCell
                                tagClass="tag-duplicate"
                                tagText="三年内重复题 Top1"
                                tdClass="pair-td-duplicate"
                                q=(item.duplicate)!{}
                                emptyText="无对应三年内重复题"
                                />
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </#list>
    </#if>
</#macro>

<div class="doc-wrap">

    <table class="title-table">
        <tr>
            <td class="title-cell">
                <div class="page-title">${ename}查重详情</div>
                <div class="page-subtitle">
                    本页展示试卷题目三年窗口内查重明细，包括 A 卷题目、B 卷题目，以及 A/B 卷之间的重复题目详情；每条记录展示原题及三年内相似度最高的重复题 Top1。
                </div>
            </td>
        </tr>
    </table>

    <table class="meta-table">
        <tr>
            <td class="meta-label">审核人</td>
            <td class="meta-value">${checkTeacher!''}</td>
            <td class="meta-label">审核时间</td>
            <td class="meta-value">${checkTimeStr!''}</td>
        </tr>
    </table>

    <#if !aDetail?has_content && !bDetail?has_content && !abDetail?has_content>
        <table class="no-data-table">
            <tr>
                <td>暂无三年内查重详情数据。</td>
            </tr>
        </table>
    </#if>

    <@renderSection sectionTitle="A 卷题目" items=aDetail itemTitlePrefix="A卷三年内重复率高试题" />
    <@renderSection sectionTitle="B 卷题目" items=bDetail itemTitlePrefix="B卷三年内重复率高试题" />
    <@renderSection sectionTitle="A / B 卷重复题目" items=abDetail itemTitlePrefix="A/B卷互相查重重复率高" />

</div>
</body>
</html>