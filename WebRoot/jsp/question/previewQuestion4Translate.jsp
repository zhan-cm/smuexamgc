<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageCid" value="${empty cid ? param.cid : cid}" />
<c:set var="pageQid" value="${empty qid ? param.qid : qid}" />
<c:set var="pageMqid" value="${empty mqid ? param.mqid : mqid}" />
<c:set var="pageIsMain" value="${empty isMain ? param.ismain : isMain}" />
<c:set var="pageIsCon" value="${empty iscon ? param.iscon : iscon}" />

<link rel="stylesheet" href="<c:url value='/styles/bootstrap/v5.3.0/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/styles/css/sweetalert2.min.css'/>">

<style>
    body {
        background: #f5f7fb;
        color: #212529;
    }

    .page-shell {
        max-width: 1680px;
        margin: 0 auto;
        padding: 20px 16px 28px;
    }

    .workbench-row {
        --bs-gutter-x: 18px;
        --bs-gutter-y: 18px;
    }

    .question-panel {
        border: 1px solid #dfe7f3;
        border-radius: 16px;
        overflow: hidden;
        background: #ffffff;
        box-shadow: 0 8px 24px rgba(15, 35, 95, 0.06);
        height: 100%;
    }

    .question-panel-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        padding: 14px 18px;
        background: linear-gradient(180deg, #f8fbff 0%, #eef4ff 100%);
        border-bottom: 1px solid #dfe7f3;
    }

    .question-panel-title {
        margin: 0;
        font-size: 18px;
        font-weight: 700;
        color: #234a91;
    }

    .question-panel-subtitle {
        margin: 0;
        font-size: 12px;
        color: #6c757d;
    }

    .question-panel-tools {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
        justify-content: flex-end;
    }

    .ai-task-select {
        min-width: 180px;
    }

    .question-panel-body {
        padding: 18px;
        min-height: 760px;
    }

    .question-paper {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }

    .question-section {
        border: 1px solid #e9eef6;
        border-radius: 12px;
        overflow: hidden;
        background: #ffffff;
    }

    .question-section.section-highlight {
        border-color: #cdddff;
        background: #f7faff;
    }

    .section-title {
        padding: 10px 14px;
        font-size: 14px;
        font-weight: 700;
        color: #234a91;
        background: #f8fbff;
        border-bottom: 1px solid #e9eef6;
    }

    .question-row {
        display: flex;
        align-items: flex-start;
        gap: 12px;
        padding: 12px 14px;
        border-top: 1px solid #edf2f8;
    }

    .question-row:first-child {
        border-top: 0;
    }

    .question-label {
        width: 96px;
        flex: 0 0 96px;
        font-size: 13px;
        font-weight: 700;
        color: #305da8;
        line-height: 1.8;
    }

    .question-label-tag {
        display: inline-block;
        padding: 2px 10px;
        border-radius: 999px;
        background: #eef4ff;
    }

    .question-value {
        flex: 1;
        min-width: 0;
        font-size: 14px;
        line-height: 1.9;
        color: #212529;
        word-break: break-word;
    }

    .topic-tags {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 8px;
    }

    .topic-tag {
        display: inline-flex;
        align-items: center;
        min-height: 30px;
        padding: 0 12px;
        border-radius: 999px;
        background: #f2f6ff;
        border: 1px solid #d7e4ff;
        color: #355c9a;
        font-size: 13px;
    }

    .topic-separator {
        color: #8ea2c8;
        font-weight: 700;
    }

    .option-list {
        margin-top: 8px;
        padding: 10px 12px;
        border-radius: 10px;
        background: #f8fafc;
        border: 1px dashed #d7dee9;
    }

    .option-item {
        line-height: 1.9;
    }

    .branch-card {
        border: 1px solid #e4ebf5;
        border-radius: 12px;
        overflow: hidden;
        background: #ffffff;
    }

    .branch-title {
        padding: 10px 14px;
        background: #f8fbff;
        border-bottom: 1px solid #e4ebf5;
        font-size: 14px;
        font-weight: 700;
        color: #234a91;
    }

    .attachment-list {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 12px;
    }

    .attachment-item {
        border: 1px solid #e8edf6;
        border-radius: 12px;
        overflow: hidden;
        background: #f8fafc;
        padding: 10px;
    }

    .attachment-image {
        display: block;
        width: 100%;
        height: 140px;
        object-fit: cover;
        border-radius: 8px;
        cursor: pointer;
        background: #f1f3f5;
    }

    .attachment-audio {
        width: 100%;
        display: block;
    }

    .attachment-video-wrap {
        border-radius: 8px;
        overflow: hidden;
        background: #000;
    }

    .attachment-video {
        width: 100%;
        height: 100%;
        display: block;
        background: #000;
    }

    .empty-text {
        color: #98a2b3;
    }

    .question-divider {
        margin: 2px 0;
        border-top: 2px solid #dbe7ff;
        opacity: 1;
    }

    .toolbar-wrap {
        margin-top: 18px;
        padding: 14px 16px;
        border: 1px solid #dfe7f3;
        border-radius: 16px;
        background: #ffffff;
        box-shadow: 0 8px 24px rgba(15, 35, 95, 0.05);
    }

    .toolbar-row {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
    }

    .toolbar-group {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }

    .btn-toolbar-action {
        min-width: 132px;
    }

    .ai-empty-state,
    .ai-loading-state {
        min-height: 640px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        border: 1px dashed #d7e4ff;
        border-radius: 12px;
        background: #f9fbff;
        padding: 24px;
    }

    .ai-empty-inner,
    .ai-loading-inner {
        max-width: 420px;
    }

    .ai-empty-title,
    .ai-loading-title {
        margin-bottom: 8px;
        font-size: 18px;
        font-weight: 700;
        color: #234a91;
    }

    .ai-empty-desc,
    .ai-loading-desc {
        margin: 0;
        color: #6c757d;
        line-height: 1.8;
    }

    .preview-image-full {
        display: block;
        max-width: 100%;
        max-height: 72vh;
        margin: 0 auto;
        border-radius: 12px;
    }

    @media (max-width: 991.98px) {
        .question-panel-body {
            min-height: auto;
        }

        .ai-empty-state,
        .ai-loading-state {
            min-height: 320px;
        }

        .question-row {
            flex-direction: column;
            gap: 6px;
        }

        .question-label {
            width: auto;
            flex: none;
        }

        .toolbar-row {
            flex-direction: column;
            align-items: stretch;
        }

        .toolbar-group {
            width: 100%;
        }

        .toolbar-group .btn {
            flex: 1 1 auto;
        }

        .question-panel-header {
            flex-direction: column;
            align-items: stretch;
        }

        .question-panel-tools {
            justify-content: space-between;
        }

        .ai-task-select {
            width: 100%;
            min-width: 0;
        }
    }
</style>

<div class="page-shell"
     id="questionWorkbench"
     data-context-path="${ctx}"
     data-cid="${pageCid}"
     data-qid="${pageQid}"
     data-mqid="${pageMqid}"
     data-ismain="${pageIsMain}"
     data-iscon="${pageIsCon}">
    <form id="questionForm" method="post" action="">
        <input type="hidden" id="cid" value="${pageCid}" />
        <input type="hidden" id="qid" value="${pageQid}" />
        <input type="hidden" id="mqid" value="${pageMqid}" />
        <input type="hidden" id="isMain" value="${pageIsMain}" />
        <input type="hidden" id="isCon" value="${pageIsCon}" />

        <div class="row workbench-row">
            <!-- 左侧：原题 -->
            <div class="col-12 col-md-6">
                <div class="question-panel">
                    <div class="question-panel-header">
                        <div>
                            <h3 class="question-panel-title">原题内容</h3>
                            <p class="question-panel-subtitle">当前题目原始展示区域</p>
                        </div>
                        <span class="badge text-bg-primary">原题</span>
                    </div>

                    <div class="question-panel-body">
                        <div class="question-paper" id="originQuestionPaper">
                            <!-- 基本信息 -->
                            <div class="question-section">
                                <div class="question-row">
                                    <div class="question-label">
                                        <span class="question-label-tag">题型</span>
                                    </div>
                                    <div class="question-value">
                                        <c:out value="${mainQuestion.qtname}" default="-" />
                                    </div>
                                </div>

                                <div class="question-row">
                                    <div class="question-label">
                                        <span class="question-label-tag">主题词</span>
                                    </div>
                                    <div class="question-value">
                                        <div class="topic-tags">
                                            <c:if test="${not empty mainQuestion.t1name}">
                                                <span class="topic-tag">${mainQuestion.t1name}</span>
                                            </c:if>

                                            <c:if test="${not empty mainQuestion.t2name}">
                                                <span class="topic-separator">/</span>
                                                <span class="topic-tag">${mainQuestion.t2name}</span>
                                            </c:if>

                                            <c:if test="${not empty mainQuestion.t3name}">
                                                <span class="topic-separator">/</span>
                                                <span class="topic-tag">${mainQuestion.t3name}</span>
                                            </c:if>

                                            <c:if test="${empty mainQuestion.t1name and empty mainQuestion.t2name and empty mainQuestion.t3name}">
                                                <span class="empty-text">暂无主题词</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 主题干 / 主题目 -->
                            <c:choose>
                                <c:when test="${mainQuestion.ismain eq 1}">
                                    <div class="question-section section-highlight">
                                        <div class="section-title">主题干</div>

                                        <div class="question-row">
                                            <div class="question-label">
                                                <span class="question-label-tag">题干</span>
                                            </div>
                                            <div class="question-value">
                                                    ${mainQuestion.content}
                                            </div>
                                        </div>

                                        <div class="question-row">
                                            <div class="question-label">
                                                <span class="question-label-tag">附件</span>
                                            </div>
                                            <div class="question-value">
                                                <c:choose>
                                                    <c:when test="${not empty mainQuestion.filepath}">
                                                        <div class="attachment-list">
                                                            <c:set var="mainFileUrls" value="${fn:split(mainQuestion.filepath, ',')}" />
                                                            <c:forEach items="${mainFileUrls}" var="filepath">
                                                                <c:if test="${not empty filepath}">
                                                                    <c:set var="lowerPath" value="${fn:toLowerCase(filepath)}" />
                                                                    <div class="attachment-item">
                                                                        <c:choose>
                                                                            <c:when test="${fn:contains(lowerPath,'.mp4')}">
                                                                                <div class="ratio ratio-16x9 attachment-video-wrap">
                                                                                    <video class="attachment-video" controls preload="metadata">
                                                                                        <source src="${filepath}" type="video/mp4" />
                                                                                    </video>
                                                                                </div>
                                                                            </c:when>

                                                                            <c:when test="${fn:contains(lowerPath,'.mp3')}">
                                                                                <audio class="attachment-audio" src="${filepath}" controls>
                                                                                    Your browser does not support the audio element.
                                                                                </audio>
                                                                            </c:when>

                                                                            <c:when test="${fn:contains(lowerPath,'.jpg') or fn:contains(lowerPath,'.jpeg') or fn:contains(lowerPath,'.png') or fn:contains(lowerPath,'.gif') or fn:contains(lowerPath,'.bmp')}">
                                                                                <img
                                                                                        src="${filepath}"
                                                                                        alt="附件图片"
                                                                                        class="attachment-image js-preview-image"
                                                                                        data-preview-src="${filepath}"
                                                                                />
                                                                            </c:when>

                                                                            <c:otherwise>
                                                                                <div class="text-muted small">暂不支持该附件预览</div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="empty-text">暂无附件</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="question-section">
                                        <div class="section-title">主题目</div>

                                        <div class="question-row">
                                            <div class="question-label">
                                                <span class="question-label-tag">题目</span>
                                            </div>
                                            <div class="question-value" id="mainQuestion">
                                                    ${mainQuestion.content}

                                                <div class="option-list">
                                                    <c:forEach var="answer" items="${mainQuestion.answerList}">
                                                        <div class="option-item">
                                                                ${answer.ACONTENT}
                                                            <c:if test="${xxdf==1}">
                                                                &nbsp;&nbsp;(${answer.SCORE}分)
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="question-row">
                                            <div class="question-label">
                                                <span class="question-label-tag">附件</span>
                                            </div>
                                            <div class="question-value">
                                                <c:choose>
                                                    <c:when test="${not empty mainQuestion.filepath}">
                                                        <div class="attachment-list">
                                                            <c:set var="mainFileUrls2" value="${fn:split(mainQuestion.filepath, ',')}" />
                                                            <c:forEach items="${mainFileUrls2}" var="filepath">
                                                                <c:if test="${not empty filepath}">
                                                                    <c:set var="lowerPath" value="${fn:toLowerCase(filepath)}" />
                                                                    <div class="attachment-item">
                                                                        <c:choose>
                                                                            <c:when test="${fn:contains(lowerPath,'.mp4')}">
                                                                                <div class="ratio ratio-16x9 attachment-video-wrap">
                                                                                    <video class="attachment-video" controls preload="metadata">
                                                                                        <source src="${filepath}" type="video/mp4" />
                                                                                    </video>
                                                                                </div>
                                                                            </c:when>

                                                                            <c:when test="${fn:contains(lowerPath,'.mp3')}">
                                                                                <audio class="attachment-audio" src="${filepath}" controls>
                                                                                    Your browser does not support the audio element.
                                                                                </audio>
                                                                            </c:when>

                                                                            <c:when test="${fn:contains(lowerPath,'.jpg') or fn:contains(lowerPath,'.jpeg') or fn:contains(lowerPath,'.png') or fn:contains(lowerPath,'.gif') or fn:contains(lowerPath,'.bmp')}">
                                                                                <img
                                                                                        src="${filepath}"
                                                                                        alt="附件图片"
                                                                                        class="attachment-image js-preview-image"
                                                                                        data-preview-src="${filepath}"
                                                                                />
                                                                            </c:when>

                                                                            <c:otherwise>
                                                                                <div class="text-muted small">暂不支持该附件预览</div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="empty-text">暂无附件</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- 分支题 -->
                            <c:forEach var="question" items="${questionList}" varStatus="q">
                                <div class="branch-card">
                                    <div class="branch-title">题目分支 ${q.index + 1}</div>

                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">题目</span>
                                        </div>
                                        <div class="question-value">
                                                ${question.content}
                                            <div class="option-list">
                                                <c:forEach var="answer" items="${question.answerList}">
                                                    <div class="option-item">
                                                            ${answer.ACONTENT}
                                                        <c:if test="${xxdf==1}">
                                                            &nbsp;&nbsp;(${answer.SCORE}分)
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">附件</span>
                                        </div>
                                        <div class="question-value">
                                            <c:choose>
                                                <c:when test="${not empty question.filepath}">
                                                    <div class="attachment-list">
                                                        <c:set var="branchFileUrls" value="${fn:split(question.filepath, ',')}" />
                                                        <c:forEach items="${branchFileUrls}" var="filepath">
                                                            <c:if test="${not empty filepath}">
                                                                <c:set var="lowerPath" value="${fn:toLowerCase(filepath)}" />
                                                                <div class="attachment-item">
                                                                    <c:choose>
                                                                        <c:when test="${fn:contains(lowerPath,'.mp4')}">
                                                                            <div class="ratio ratio-16x9 attachment-video-wrap">
                                                                                <video class="attachment-video" controls preload="metadata">
                                                                                    <source src="${filepath}" type="video/mp4" />
                                                                                </video>
                                                                            </div>
                                                                        </c:when>

                                                                        <c:when test="${fn:contains(lowerPath,'.mp3')}">
                                                                            <audio class="attachment-audio" src="${filepath}" controls>
                                                                                Your browser does not support the audio element.
                                                                            </audio>
                                                                        </c:when>

                                                                        <c:when test="${fn:contains(lowerPath,'.jpg') or fn:contains(lowerPath,'.jpeg') or fn:contains(lowerPath,'.png') or fn:contains(lowerPath,'.gif') or fn:contains(lowerPath,'.bmp')}">
                                                                            <img
                                                                                    src="${filepath}"
                                                                                    alt="附件图片"
                                                                                    class="attachment-image js-preview-image"
                                                                                    data-preview-src="${filepath}"
                                                                            />
                                                                        </c:when>

                                                                        <c:otherwise>
                                                                            <div class="text-muted small">暂不支持该附件预览</div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-text">暂无附件</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">答案</span>
                                        </div>
                                        <div class="question-value">
                                            <c:choose>
                                                <c:when test="${not empty question.answer}">
                                                    ${question.answer}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-text">暂无答案</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">答案解释</span>
                                        </div>
                                        <div class="question-value">
                                            <c:choose>
                                                <c:when test="${not empty question.exp}">
                                                    ${question.exp}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-text">暂无答案解释</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${not q.last}">
                                    <hr class="question-divider" />
                                </c:if>
                            </c:forEach>

                            <!-- 普通题答案 -->
                            <c:if test="${isMain eq 0 && iscon eq 0}">
                                <div class="question-section">
                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">答案</span>
                                        </div>
                                        <div class="question-value">
                                            <c:choose>
                                                <c:when test="${not empty mainQuestion.answer}">
                                                    ${mainQuestion.answer}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-text">暂无答案</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="question-row">
                                        <div class="question-label">
                                            <span class="question-label-tag">答案解释</span>
                                        </div>
                                        <div class="question-value">
                                            <c:choose>
                                                <c:when test="${not empty mainQuestion.exp}">
                                                    ${mainQuestion.exp}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="empty-text">暂无答案解释</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 右侧：AI结果 -->
            <div class="col-12 col-md-6">
                <div class="question-panel">
                    <div class="question-panel-header">
                        <div>
                            <h3 class="question-panel-title" id="aiPanelTitle">翻译题目结果</h3>
                            <p class="question-panel-subtitle">右侧基于对象渲染翻译结果或类似题结果</p>
                        </div>

                        <div class="question-panel-tools">
                            <select class="form-select form-select-sm ai-task-select" id="aiTaskSelector">
                                <option value="TRANSLATE" selected="selected">翻译题目</option>
                                <option value="GENERATE_SIMILAR">生成类似题目</option>
                            </select>
                            <span class="badge text-bg-secondary" id="aiStatusBadge">未执行</span>
                        </div>
                    </div>

                    <div class="question-panel-body">
                        <div id="aiEmptyState" class="ai-empty-state">
                            <div class="ai-empty-inner">
                                <div class="ai-empty-title">等待 AI 操作</div>
                                <p class="ai-empty-desc">
                                    点击下方按钮后，右侧将根据返回对象自动渲染结果。<br/>
                                    支持“翻译题目”和“生成类似题目”两种操作。
                                </p>
                            </div>
                        </div>

                        <div id="aiLoadingState" class="ai-loading-state d-none">
                            <div class="ai-loading-inner">
                                <div class="spinner-border text-primary mb-3" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <div class="ai-loading-title" id="aiLoadingTitle">AI 正在处理中</div>
                                <p class="ai-loading-desc" id="aiLoadingDesc">系统每 5 秒自动刷新一次，直到结果完成。</p>
                            </div>
                        </div>

                        <div id="aiQuestionPaper" class="question-paper d-none"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 底部工具栏 -->
        <div class="toolbar-wrap">
            <div class="toolbar-row">
                <div class="toolbar-group">
                    <c:forEach var="res" items="${lastQuestion}">
                        <c:if test="${not empty res.QID}">
                            <button
                                    type="button"
                                    class="btn btn-outline-secondary js-nav-question"
                                    data-nav-url="${ctx}/intelliQuestion/editByAI?cid=${res.CID}&qid=${res.QID}&mqid=${res.MQID}&ismain=${res.ISMAIN}&iscon=${res.ISCON}">
                                上一题
                            </button>
                        </c:if>
                    </c:forEach>

                    <c:forEach var="res" items="${nextQuestion}">
                        <c:if test="${not empty res.QID}">
                            <button
                                    type="button"
                                    class="btn btn-outline-secondary js-nav-question"
                                    data-nav-url="${ctx}/intelliQuestion/editByAI?cid=${res.CID}&qid=${res.QID}&mqid=${res.MQID}&ismain=${res.ISMAIN}&iscon=${res.ISCON}">
                                下一题
                            </button>
                        </c:if>
                    </c:forEach>
                </div>

                <div class="toolbar-group">
                    <button type="button" class="btn btn-primary btn-toolbar-action" id="btnTranslateQuestion">
                        翻译题目
                    </button>
                    <button type="button" class="btn btn-warning btn-toolbar-action" id="btnGenerateSimilarQuestion">
                        生成类似题目
                    </button>
                    <button type="button" class="btn btn-success btn-toolbar-action" id="btnAcceptQuestionEdit" style="display:none;">
                        新增进正式题库
                    </button>
                </div>

                <div class="toolbar-group">
                    <button type="button" class="btn btn-outline-danger" id="btnClosePage">关闭</button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- 图片预览 Modal -->
<div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <h5 class="modal-title">图片预览</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <div class="modal-body text-center">
                <img id="imagePreviewElement" src="" alt="预览图片" class="preview-image-full" />
            </div>
        </div>
    </div>
</div>

<script src="<c:url value='/styles/js/kaoyi_utils.js'/>"></script>
<script src="<c:url value='/styles/js/jquery-3.6.0.js'/>"></script>
<script src="<c:url value='/styles/bootstrap/v5.3.0/js/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='/styles/js/sweetalert2.min.js'/>"></script>

<script type="text/javascript">
    (function (window, $) {
        'use strict';

        const POLL_INTERVAL = 5000;

        let pollTimer = null;
        let currentAction = 'TRANSLATE';

        const pageRoot = document.getElementById('questionWorkbench');
        const contextPath = pageRoot ? pageRoot.getAttribute('data-context-path') : '';

        const pageData = {
            cid: pageRoot ? (pageRoot.getAttribute('data-cid') || '') : '',
            qid: pageRoot ? (pageRoot.getAttribute('data-qid') || '') : '',
            mqid: pageRoot ? (pageRoot.getAttribute('data-mqid') || '') : '',
            isMain: pageRoot ? (pageRoot.getAttribute('data-ismain') || '') : '',
            isCon: pageRoot ? (pageRoot.getAttribute('data-iscon') || '') : ''
        };

        const aiPanelTitle = document.getElementById('aiPanelTitle');
        const aiStatusBadge = document.getElementById('aiStatusBadge');
        const aiEmptyState = document.getElementById('aiEmptyState');
        const aiLoadingState = document.getElementById('aiLoadingState');
        const aiQuestionPaper = document.getElementById('aiQuestionPaper');
        const aiLoadingTitle = document.getElementById('aiLoadingTitle');
        const aiLoadingDesc = document.getElementById('aiLoadingDesc');
        const aiTaskSelector = document.getElementById('aiTaskSelector');

        const btnTranslateQuestion = document.getElementById('btnTranslateQuestion');
        const btnGenerateSimilarQuestion = document.getElementById('btnGenerateSimilarQuestion');
        const btnAcceptQuestionEdit = document.getElementById('btnAcceptQuestionEdit');

        const imagePreviewModalElement = document.getElementById('imagePreviewModal');
        const imagePreviewElement = document.getElementById('imagePreviewElement');
        const imagePreviewModal = bootstrap.Modal.getOrCreateInstance(imagePreviewModalElement);

        const actionTextMap = {
            'TRANSLATE': '翻译题目',
            'GENERATE_SIMILAR': '生成类似题目',
            '翻译题目': '翻译题目',
            '出类似题目': '生成类似题目'
        };

        const actionButtonMap = {
            'TRANSLATE': btnTranslateQuestion,
            'GENERATE_SIMILAR': btnGenerateSimilarQuestion
        };

        function isBlank(value) {
            return value === null || value === undefined || String(value).trim() === '';
        }

        function escapeHtml(text) {
            if (text === null || text === undefined) {
                return '';
            }
            return String(text)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function normalizeActionText(action) {
            return actionTextMap[action] || 'AI 处理';
        }

        function normalizeStatus(status) {
            if (status === null || status === undefined) {
                return '';
            }

            const raw = String(status).trim();
            const upper = raw.toUpperCase();

            if (upper === 'RUNNING' || upper === 'BUSY' || raw === '运行中') {
                return 'RUNNING';
            }
            if (upper === 'FINISH' || raw === '已完成') {
                return 'FINISH';
            }
            if (upper === 'EMPTY' || raw === '空闲中') {
                return 'EMPTY';
            }
            return upper;
        }

        function parseInfoResponse(responseText) {
            const text = $.trim(responseText || '');
            if (isBlank(text) || text === 'null') {
                return null;
            }
            if (text === 'noRoot') {
                return 'noRoot';
            }
            if (text === 'busy') {
                return 'busy';
            }

            try {
                return JSON.parse(text);
            } catch (e) {
                return null;
            }
        }

        function buildRequestData(action) {
            return {
                cid: pageData.cid,
                qid: pageData.qid,
                mqid: pageData.mqid,
                isMain: pageData.isMain,
                iscon: pageData.isCon,
                requestAction: action
            };
        }

        function setAiStatus(text, badgeClassName) {
            aiStatusBadge.className = 'badge';
            aiStatusBadge.classList.add(badgeClassName);
            aiStatusBadge.textContent = text;
        }

        function stopPolling() {
            if (pollTimer) {
                window.clearTimeout(pollTimer);
                pollTimer = null;
            }
        }

        function schedulePolling(action) {
            stopPolling();
            pollTimer = window.setTimeout(function () {
                fetchQuestionEditInfo(action, true);
            }, POLL_INTERVAL);
        }

        function enableAllActionButtons() {
            btnTranslateQuestion.disabled = false;
            btnGenerateSimilarQuestion.disabled = false;
        }

        function disableActionButton(action) {
            enableAllActionButtons();
            if (actionButtonMap[action]) {
                actionButtonMap[action].disabled = true;
            }
        }

        function syncSelector(action) {
            if (aiTaskSelector && aiTaskSelector.value !== action) {
                aiTaskSelector.value = action;
            }
        }

        function showAiEmptyState(titleText, descText, actionType) {
            const action = actionType || currentAction;
            aiPanelTitle.textContent = normalizeActionText(action) + '结果';
            setAiStatus('未执行', 'text-bg-secondary');

            aiQuestionPaper.classList.add('d-none');
            aiQuestionPaper.innerHTML = '';

            aiLoadingState.classList.add('d-none');
            aiEmptyState.classList.remove('d-none');

            const emptyTitleElement = aiEmptyState.querySelector('.ai-empty-title');
            const emptyDescElement = aiEmptyState.querySelector('.ai-empty-desc');

            if (emptyTitleElement) {
                emptyTitleElement.textContent = titleText || '等待 AI 操作';
            }
            if (emptyDescElement) {
                emptyDescElement.innerHTML = descText || '点击下方按钮后，右侧将展示 AI 处理结果。';
            }
            if (btnAcceptQuestionEdit) {
                btnAcceptQuestionEdit.style.display = 'none';
            }
        }

        function showAiLoadingState(actionType, descText) {
            const action = actionType || currentAction;
            const actionText = normalizeActionText(action);

            aiPanelTitle.textContent = actionText + '结果';
            setAiStatus('执行中', 'text-bg-warning');

            aiEmptyState.classList.add('d-none');
            aiQuestionPaper.classList.add('d-none');
            aiQuestionPaper.innerHTML = '';

            aiLoadingTitle.textContent = actionText + '中...';
            aiLoadingDesc.textContent = descText || '系统每 5 秒自动刷新一次，直到结果完成。';
            aiLoadingState.classList.remove('d-none');
            if (btnAcceptQuestionEdit) {
                btnAcceptQuestionEdit.style.display = 'none';
            }
        }

        function showAiErrorState(titleText, descText, actionType) {
            const action = actionType || currentAction;

            aiPanelTitle.textContent = normalizeActionText(action) + '结果';
            setAiStatus('失败', 'text-bg-danger');

            aiQuestionPaper.classList.add('d-none');
            aiQuestionPaper.innerHTML = '';
            aiLoadingState.classList.add('d-none');
            aiEmptyState.classList.remove('d-none');

            const emptyTitleElement = aiEmptyState.querySelector('.ai-empty-title');
            const emptyDescElement = aiEmptyState.querySelector('.ai-empty-desc');

            if (emptyTitleElement) {
                emptyTitleElement.textContent = titleText || '处理失败';
            }
            if (emptyDescElement) {
                emptyDescElement.innerHTML = descText || '接口调用失败，请稍后重试。';
            }
            if (btnAcceptQuestionEdit) {
                btnAcceptQuestionEdit.style.display = 'none';
            }
        }

        function clearAiResultAfterAccept() {
            currentAction = null;

            aiQuestionPaper.innerHTML = '';
            aiQuestionPaper.classList.add('d-none');

            aiPanelTitle.textContent = 'AI 结果展示';
            setAiStatus('未执行', 'text-bg-secondary');

            aiLoadingState.classList.add('d-none');
            aiEmptyState.classList.remove('d-none');

            const emptyTitleElement = aiEmptyState.querySelector('.ai-empty-title');
            const emptyDescElement = aiEmptyState.querySelector('.ai-empty-desc');

            if (emptyTitleElement) {
                emptyTitleElement.textContent = '结果已清空';
            }
            if (emptyDescElement) {
                emptyDescElement.innerHTML = '该 AI 结果已新增进正式题库，对应缓存已删除。';
            }

            if (btnAcceptQuestionEdit) {
                btnAcceptQuestionEdit.style.display = 'none';
            }
        }

        function renderAiQuestion(htmlContent, actionType) {
            const action = actionType || currentAction;
            const actionText = normalizeActionText(action);

            aiPanelTitle.textContent = actionText + '结果';
            setAiStatus('已完成', 'text-bg-success');

            aiEmptyState.classList.add('d-none');
            aiLoadingState.classList.add('d-none');

            aiQuestionPaper.innerHTML = htmlContent;
            aiQuestionPaper.classList.remove('d-none');
            if (btnAcceptQuestionEdit) {
                btnAcceptQuestionEdit.style.display = '';
            }
        }

        function hasUsableMainQuestion(mainQuestion) {
            return !!(mainQuestion &&
                (mainQuestion.qtype || mainQuestion.content || (mainQuestion.questionList && mainQuestion.questionList.length)));
        }

        function hasUsableGeneratedQuestion(question) {
            return !!(question &&
                (question.qtype || question.content || question.answer || question.explain ||
                    (question.answerList && question.answerList.length)));
        }

        function renderQuestionEditInfo(info, actionType) {
            const action = actionType || currentAction;
            const mainQuestion = info ? info.mainGeneratedQuestion : null;
            const generatedQuestion = info ? info.generatedQuestion : null;
            let html = '';

            if (hasUsableMainQuestion(mainQuestion)) {
                html = renderMainGeneratedQuestion(mainQuestion);
            } else if (hasUsableGeneratedQuestion(generatedQuestion)) {
                html = renderGeneratedQuestion(generatedQuestion);
            } else {
                showAiEmptyState('暂无结果', 'AI 已完成处理，但未返回可展示的数据。', action);
                return;
            }

            renderAiQuestion(html, action);
        }

        function renderMainGeneratedQuestion(mainQuestion) {
            const html = [];

            html.push(renderAiBasicInfo(mainQuestion.qtype));

            html.push('<div class="question-section section-highlight">');
            html.push('<div class="section-title">主题干</div>');
            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">题干</span></div>');
            html.push('<div class="question-value">' + renderRichText(mainQuestion.content, '暂无题干') + '</div>');
            html.push('</div>');
            html.push(renderAttachmentRow([mainQuestion.content]));
            html.push('</div>');

            if (Array.isArray(mainQuestion.questionList) && mainQuestion.questionList.length > 0) {
                for (let i = 0; i < mainQuestion.questionList.length; i++) {
                    html.push(renderBranchQuestion(mainQuestion.questionList[i], i + 1, i === mainQuestion.questionList.length - 1));
                }
            } else {
                html.push('<div class="question-section">');
                html.push('<div class="question-row">');
                html.push('<div class="question-label"><span class="question-label-tag">子题</span></div>');
                html.push('<div class="question-value"><span class="empty-text">暂无子题</span></div>');
                html.push('</div>');
                html.push('</div>');
            }

            return html.join('');
        }

        function renderGeneratedQuestion(question) {
            const html = [];

            html.push(renderAiBasicInfo(question.qtype));

            html.push('<div class="question-section">');
            html.push('<div class="section-title">题目内容</div>');
            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">题目</span></div>');
            html.push('<div class="question-value">');
            html.push(renderRichText(question.content, '暂无题目内容'));
            html.push(renderOptionList(question.answerList));
            html.push('</div>');
            html.push('</div>');
            html.push(renderAttachmentRow(collectGeneratedQuestionFragments(question)));
            html.push('</div>');

            html.push('<div class="question-section">');
            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">答案</span></div>');
            html.push('<div class="question-value">' + renderRichText(question.answer, '暂无答案') + '</div>');
            html.push('</div>');
            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">答案解释</span></div>');
            html.push('<div class="question-value">' + renderRichText(question.explain, '暂无答案解释') + '</div>');
            html.push('</div>');
            html.push('</div>');

            return html.join('');
        }

        function renderBranchQuestion(question, index, isLast) {
            const html = [];

            html.push('<div class="branch-card">');
            html.push('<div class="branch-title">题目分支 ' + index + '</div>');

            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">题目</span></div>');
            html.push('<div class="question-value">');
            html.push(renderRichText(question.content, '暂无题目内容'));
            html.push(renderOptionList(question.answerList));
            html.push('</div>');
            html.push('</div>');

            html.push(renderAttachmentRow(collectGeneratedQuestionFragments(question)));

            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">答案</span></div>');
            html.push('<div class="question-value">' + renderRichText(question.answer, '暂无答案') + '</div>');
            html.push('</div>');

            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">答案解释</span></div>');
            html.push('<div class="question-value">' + renderRichText(question.explain, '暂无答案解释') + '</div>');
            html.push('</div>');

            html.push('</div>');

            if (!isLast) {
                html.push('<hr class="question-divider" />');
            }

            return html.join('');
        }

        function renderAiBasicInfo(qtype) {
            const html = [];
            html.push('<div class="question-section">');
            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">题型</span></div>');
            html.push('<div class="question-value">' + (isBlank(qtype) ? '<span class="empty-text">暂无题型</span>' : escapeHtml(qtype)) + '</div>');
            html.push('</div>');
            html.push('</div>');
            return html.join('');
        }

        function renderRichText(content, emptyText) {
            if (isBlank(content)) {
                return '<span class="empty-text">' + escapeHtml(emptyText || '暂无内容') + '</span>';
            }
            return String(content);
        }

        function collectGeneratedQuestionFragments(question) {
            const fragments = [];

            if (!question) {
                return fragments;
            }

            if (!isBlank(question.content)) {
                fragments.push(question.content);
            }
            if (!isBlank(question.answer)) {
                fragments.push(question.answer);
            }
            if (!isBlank(question.explain)) {
                fragments.push(question.explain);
            }

            if (Array.isArray(question.answerList)) {
                for (let i = 0; i < question.answerList.length; i++) {
                    const option = question.answerList[i];
                    if (option && typeof option === 'object') {
                        for (const key in option) {
                            if (Object.prototype.hasOwnProperty.call(option, key) && !isBlank(option[key])) {
                                fragments.push(option[key]);
                            }
                        }
                    }
                }
            }

            return fragments;
        }

        function renderOptionList(answerList) {
            if (!Array.isArray(answerList) || answerList.length === 0) {
                return '';
            }

            const html = [];
            html.push('<div class="option-list">');

            for (let i = 0; i < answerList.length; i++) {
                html.push(renderSingleOption(answerList[i]));
            }

            html.push('</div>');
            return html.join('');
        }

        function renderSingleOption(option) {
            if (!option || typeof option !== 'object') {
                return '<div class="option-item"><span class="empty-text">暂无选项内容</span></div>';
            }

            const label = getOptionLabel(option);
            const content = getOptionContent(option);

            const html = [];
            html.push('<div class="option-item">');

            if (!isBlank(label)) {
                html.push('<span class="me-1">' + escapeHtml(label) + '.</span>');
            }

            if (isBlank(content)) {
                html.push('<span class="empty-text">暂无选项内容</span>');
            } else {
                html.push(String(content));
            }

            html.push('</div>');
            return html.join('');
        }

        function getOptionLabel(option) {
            const labelKeys = ['label', 'option', 'key', 'code', 'name', 'letter', 'acode', 'sort', 'index'];
            const keys = Object.keys(option || {});

            for (let i = 0; i < labelKeys.length; i++) {
                for (let j = 0; j < keys.length; j++) {
                    if (String(keys[j]).toLowerCase() === labelKeys[i]) {
                        return option[keys[j]];
                    }
                }
            }

            return '';
        }

        function getOptionContent(option) {
            const contentKeys = ['content', 'text', 'value', 'acontent', 'answer', 'optioncontent', 'optiontext', 'desc'];
            const keys = Object.keys(option || {});

            for (let i = 0; i < contentKeys.length; i++) {
                for (let j = 0; j < keys.length; j++) {
                    if (String(keys[j]).toLowerCase() === contentKeys[i]) {
                        return option[keys[j]];
                    }
                }
            }

            if (keys.length === 1) {
                return option[keys[0]];
            }

            const label = getOptionLabel(option);
            const values = [];

            for (let j = 0; j < keys.length; j++) {
                const v = option[keys[j]];
                if (!isBlank(v) && String(v) !== String(label)) {
                    values.push(v);
                }
            }

            return values.join(' ');
        }

        function renderAttachmentRow(htmlFragments) {
            const mediaItems = collectMediaItems(htmlFragments);
            const html = [];

            html.push('<div class="question-row">');
            html.push('<div class="question-label"><span class="question-label-tag">附件</span></div>');
            html.push('<div class="question-value">');
            html.push(renderAttachmentList(mediaItems));
            html.push('</div>');
            html.push('</div>');

            return html.join('');
        }

        function collectMediaItems(htmlFragments) {
            const result = [];
            const seen = {};

            if (!Array.isArray(htmlFragments)) {
                return result;
            }

            for (let i = 0; i < htmlFragments.length; i++) {
                const fragment = htmlFragments[i];
                if (isBlank(fragment)) {
                    continue;
                }

                const items = extractMediaItemsFromHtml(fragment);
                for (let j = 0; j < items.length; j++) {
                    const item = items[j];
                    const key = item.type + '|' + (item.src || '') + '|' + (item.poster || '');
                    if (!seen[key]) {
                        seen[key] = true;
                        result.push(item);
                    }
                }
            }

            return result;
        }

        function extractMediaItemsFromHtml(html) {
            const result = [];
            if (isBlank(html)) {
                return result;
            }

            const wrapper = document.createElement('div');
            wrapper.innerHTML = String(html);

            const imageNodes = wrapper.querySelectorAll('img[src]');
            for (let i = 0; i < imageNodes.length; i++) {
                const imgSrc = imageNodes[i].getAttribute('src') || '';
                if (!isBlank(imgSrc)) {
                    result.push({
                        type: 'img',
                        src: imgSrc
                    });
                }
            }

            const audioNodes = wrapper.querySelectorAll('audio');
            for (let j = 0; j < audioNodes.length; j++) {
                let audioSrc = audioNodes[j].getAttribute('src') || '';
                if (isBlank(audioSrc)) {
                    const audioSource = audioNodes[j].querySelector('source[src]');
                    if (audioSource) {
                        audioSrc = audioSource.getAttribute('src') || '';
                    }
                }
                if (!isBlank(audioSrc)) {
                    result.push({
                        type: 'audio',
                        src: audioSrc
                    });
                }
            }

            const videoNodes = wrapper.querySelectorAll('video');
            for (let k = 0; k < videoNodes.length; k++) {
                let videoSrc = videoNodes[k].getAttribute('src') || '';
                if (isBlank(videoSrc)) {
                    const videoSource = videoNodes[k].querySelector('source[src]');
                    if (videoSource) {
                        videoSrc = videoSource.getAttribute('src') || '';
                    }
                }
                if (!isBlank(videoSrc)) {
                    result.push({
                        type: 'video',
                        src: videoSrc,
                        poster: videoNodes[k].getAttribute('poster') || ''
                    });
                }
            }

            return result;
        }

        function renderAttachmentList(mediaItems) {
            if (!Array.isArray(mediaItems) || mediaItems.length === 0) {
                return '<span class="empty-text">暂无附件</span>';
            }

            const html = [];
            html.push('<div class="attachment-list">');

            for (let i = 0; i < mediaItems.length; i++) {
                const item = mediaItems[i];
                html.push('<div class="attachment-item">');

                if (item.type === 'img') {
                    html.push('<img src="' + escapeHtml(item.src) + '" alt="附件图片" class="attachment-image js-preview-image" data-preview-src="' + escapeHtml(item.src) + '" />');
                } else if (item.type === 'audio') {
                    html.push('<audio class="attachment-audio" src="' + escapeHtml(item.src) + '" controls>Your browser does not support the audio element.</audio>');
                } else if (item.type === 'video') {
                    html.push('<div class="ratio ratio-16x9 attachment-video-wrap">');
                    html.push('<video class="attachment-video" controls preload="metadata"' + (isBlank(item.poster) ? '' : ' poster="' + escapeHtml(item.poster) + '"') + '>');
                    html.push('<source src="' + escapeHtml(item.src) + '" type="video/mp4" />');
                    html.push('</video>');
                    html.push('</div>');
                } else {
                    html.push('<div class="text-muted small">暂不支持该附件预览</div>');
                }

                html.push('</div>');
            }

            html.push('</div>');
            return html.join('');
        }

        function fetchQuestionEditInfo(action, fromPolling) {
            $.ajax({
                url: contextPath + '/intelliQuestion/getInfoFromEditByAI',
                type: 'POST',
                dataType: 'text',
                data: buildRequestData(action),
                success: function (responseText) {
                    if (action !== currentAction) {
                        return;
                    }

                    const result = parseInfoResponse(responseText);

                    if (result === 'noRoot') {
                        stopPolling();
                        enableAllActionButtons();
                        showAiErrorState('无权限', '您没有该题目的查看权限。', action);
                        return;
                    }

                    if (!result || $.isEmptyObject(result)) {
                        stopPolling();
                        enableAllActionButtons();
                        showAiEmptyState('暂无结果', '当前任务暂无执行记录。', action);
                        return;
                    }

                    const status = normalizeStatus(result.status);

                    if (status === 'RUNNING') {
                        disableActionButton(action);
                        showAiLoadingState(result.action || action, '系统每 5 秒自动刷新一次，直到结果完成。');
                        schedulePolling(action);
                        return;
                    }

                    if (status === 'FINISH') {
                        stopPolling();
                        enableAllActionButtons();
                        renderQuestionEditInfo(result, action);
                        return;
                    }

                    if (status === 'EMPTY') {
                        stopPolling();
                        enableAllActionButtons();
                        showAiEmptyState('暂无结果', '当前任务暂无执行记录。', action);
                        return;
                    }

                    stopPolling();
                    enableAllActionButtons();
                    showAiEmptyState('暂无结果', '当前任务暂无可展示数据。', action);
                },
                error: function () {
                    if (action !== currentAction) {
                        return;
                    }

                    if (fromPolling) {
                        schedulePolling(action);
                        return;
                    }

                    stopPolling();
                    enableAllActionButtons();
                    showAiErrorState('读取失败', '读取任务状态失败，请稍后重试。', action);
                }
            });
        }

        function submitAiAction(action) {
            currentAction = action;
            syncSelector(action);
            stopPolling();
            disableActionButton(action);
            showAiLoadingState(action, '系统每 5 秒自动刷新一次，直到结果完成。');

            $.ajax({
                url: contextPath + '/intelliQuestion/editQuestionByAI',
                type: 'POST',
                dataType: 'text',
                data: buildRequestData(action),
                success: function (responseText) {
                    const result = $.trim(responseText || '');

                    if (action !== currentAction) {
                        return;
                    }

                    if (result === 'noRoot') {
                        stopPolling();
                        enableAllActionButtons();
                        showAiErrorState('无权限', '您没有该题目的查看权限。', action);

                        Swal.fire({
                            icon: 'error',
                            title: '无权限',
                            text: '您没有该题目的查看权限。'
                        });
                        return;
                    }

                    if (result === 'busy') {
                        disableActionButton(action);
                        showAiLoadingState(action, '检测到该任务已在执行，系统每 5 秒自动刷新一次。');
                        schedulePolling(action);

                        Swal.fire({
                            icon: 'info',
                            title: '任务已在执行',
                            text: '检测到该类型任务已经在执行中，已为您同步任务状态。'
                        });
                        return;
                    }

                    if (result === 'success') {
                        disableActionButton(action);
                        showAiLoadingState(action, '系统每 5 秒自动刷新一次，直到结果完成。');
                        fetchQuestionEditInfo(action, false);
                        return;
                    }

                    stopPolling();
                    enableAllActionButtons();
                    showAiErrorState('处理失败', '接口返回异常：' + escapeHtml(result || '未知错误'), action);
                },
                error: function () {
                    if (action !== currentAction) {
                        return;
                    }

                    stopPolling();
                    enableAllActionButtons();
                    showAiErrorState('处理失败', '启动 AI 任务失败，请检查后端服务。', action);
                }
            });
        }

        function preCheckAndStartAction(action) {
            currentAction = action;
            syncSelector(action);

            stopPolling();
            enableAllActionButtons();
            showAiEmptyState('正在检查任务状态', '正在读取该任务的历史执行状态，请稍候。', action);

            $.ajax({
                url: contextPath + '/intelliQuestion/getInfoFromEditByAI',
                type: 'POST',
                dataType: 'text',
                data: buildRequestData(action),
                success: function (responseText) {
                    if (action !== currentAction) {
                        return;
                    }

                    const result = parseInfoResponse(responseText);

                    if (result === 'noRoot') {
                        stopPolling();
                        enableAllActionButtons();
                        showAiErrorState('无权限', '您没有该题目的查看权限。', action);

                        Swal.fire({
                            icon: 'error',
                            title: '无权限',
                            text: '您没有该题目的查看权限。'
                        });
                        return;
                    }

                    if (result && !$.isEmptyObject(result)) {
                        const status = normalizeStatus(result.status);

                        if (status === 'RUNNING') {
                            disableActionButton(action);
                            showAiLoadingState(action, '检测到该任务已在执行，系统每 5 秒自动刷新一次。');
                            schedulePolling(action);

                            Swal.fire({
                                icon: 'info',
                                title: '任务已在执行',
                                text: '该任务已在执行中，已为您同步当前执行状态。'
                            });
                            return;
                        }

                        if (status === 'FINISH') {
                            renderQuestionEditInfo(result, action);
                            enableAllActionButtons();

                            Swal.fire({
                                icon: 'question',
                                title: '已有历史结果',
                                text: '该任务已有运行结果，是否放弃当前结果并重新请求？',
                                showCancelButton: true,
                                confirmButtonText: '重新请求',
                                cancelButtonText: '保留当前结果',
                                reverseButtons: true
                            }).then(function (swalResult) {
                                if (action !== currentAction) {
                                    return;
                                }

                                if (swalResult.isConfirmed) {
                                    submitAiAction(action);
                                } else {
                                    enableAllActionButtons();
                                }
                            });
                            return;
                        }

                        if (status === 'EMPTY') {
                            submitAiAction(action);
                            return;
                        }
                    }

                    submitAiAction(action);
                },
                error: function () {
                    if (action !== currentAction) {
                        return;
                    }

                    submitAiAction(action);
                }
            });
        }

        function switchTaskView(action) {
            currentAction = action;
            syncSelector(action);

            stopPolling();
            enableAllActionButtons();
            showAiEmptyState('正在读取任务状态', '正在读取当前所选任务的执行状态，请稍候。', action);

            fetchQuestionEditInfo(action, false);
        }

        function bindNavigation() {
            $(document).on('click', '.js-nav-question', function () {
                const targetUrl = $(this).data('navUrl');
                if (targetUrl) {
                    window.location.href = targetUrl;
                }
            });
        }

        function bindImagePreview() {
            $(document).on('click', '.js-preview-image', function () {
                const imageSource = $(this).data('previewSrc');
                if (!imageSource) {
                    return;
                }

                imagePreviewElement.setAttribute('src', imageSource);
                imagePreviewModal.show();
            });

            imagePreviewModalElement.addEventListener('hidden.bs.modal', function () {
                imagePreviewElement.setAttribute('src', '');
            });
        }

        function bindAiButtons() {
            btnTranslateQuestion.addEventListener('click', function () {
                preCheckAndStartAction('TRANSLATE');
            });

            btnGenerateSimilarQuestion.addEventListener('click', function () {
                preCheckAndStartAction('GENERATE_SIMILAR');
            });

            btnAcceptQuestionEdit.addEventListener('click', function () {
                $.ajax({
                    url: contextPath + '/intelliQuestion/acceptQuestionEditFromAI',
                    type: 'POST',
                    dataType: 'text',
                    data: {
                        cid: pageData.cid,
                        qid: pageData.qid,
                        mqid: pageData.mqid,
                        isMain: pageData.isMain,
                        iscon: pageData.isCon,
                        requestAction: currentAction,
                        answertime: ''
                    },
                    success: function (responseText) {
                        const result = $.trim(responseText || '');
                        if (result === 'success') {
                            clearAiResultAfterAccept();
                            Swal.fire({
                                icon: 'success',
                                title: '操作成功',
                                text: '已新增进正式题库。'
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '操作失败',
                                text: '新增进正式题库失败。'
                            });
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: 'error',
                            title: '请求失败',
                            text: '调用新增正式题库接口失败，请稍后重试。'
                        });
                    }
                });
            });

            aiTaskSelector.addEventListener('change', function () {
                const selectedAction = this.value || 'TRANSLATE';
                switchTaskView(selectedAction);
            });
        }

        function bindCloseButton() {
            const btnClosePage = document.getElementById('btnClosePage');

            btnClosePage.addEventListener('click', function () {
                stopPolling();

                if (typeof window.cancelEasyUiFrame === 'function') {
                    window.cancelEasyUiFrame(0);
                    return;
                }

                if (window.history.length > 1) {
                    window.history.back();
                    return;
                }

                window.close();
            });
        }

        function init() {
            bindNavigation();
            bindImagePreview();
            bindAiButtons();
            bindCloseButton();

            currentAction = 'TRANSLATE';
            syncSelector(currentAction);
            switchTaskView(currentAction);
        }

        window.addEventListener('beforeunload', function () {
            stopPolling();
        });

        $(function () {
            init();
        });

    })(window, jQuery);
</script>