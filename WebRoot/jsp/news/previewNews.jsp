<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<style>
	html, body {
		margin: 0;
		padding: 0;
		background: #f5f7fa;
		font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
		color: #333;
	}

	/* 页面整体 */
	.news-page {
		max-width: 1100px;
		margin: 0 auto;
		padding: 20px 24px 30px;
		box-sizing: border-box;
	}

	/* 顶部工具栏 */
	.news-toolbar {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 16px;
	}

	.news-toolbar-left {
		display: flex;
		align-items: center;
		gap: 10px;
	}

	.news-toolbar-right {
		color: #999;
		font-size: 12px;
	}

	/* 主体卡片 */
	.news-card {
		background: #fff;
		border: 1px solid #e8edf3;
		border-radius: 12px;
		box-shadow: 0 8px 24px rgba(31, 45, 61, 0.08);
		overflow: hidden;
	}

	/* 标题区域 */
	.news-header {
		padding: 30px 38px 22px;
		background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
		border-bottom: 1px solid #edf2f7;
		text-align: center;
	}

	.news-title {
		margin: 0;
		font-size: 28px;
		line-height: 1.45;
		font-weight: 700;
		color: #1f2d3d;
		word-break: break-word;
	}

	.news-meta {
		margin-top: 14px;
		font-size: 13px;
		color: #7f8c9a;
		line-height: 22px;
	}

	.news-meta .meta-item {
		display: inline-block;
		margin: 0 10px;
	}

	.news-meta .meta-label {
		color: #99a9bf;
	}

	/* 正文区域 */
	.news-body {
		padding: 32px 38px 40px;
		font-size: 15px;
		line-height: 1.95;
		color: #444;
		word-break: break-word;
		overflow-wrap: break-word;
		min-height: 260px;
	}

	/* 兼容富文本内容 */
	.news-body p {
		margin: 0 0 16px 0;
		text-indent: 0;
	}

	.news-body h1,
	.news-body h2,
	.news-body h3,
	.news-body h4,
	.news-body h5,
	.news-body h6 {
		margin: 22px 0 14px;
		color: #1f2d3d;
		font-weight: 700;
		line-height: 1.5;
	}

	.news-body h1 { font-size: 24px; }
	.news-body h2 { font-size: 22px; }
	.news-body h3 { font-size: 20px; }
	.news-body h4 { font-size: 18px; }

	.news-body ul,
	.news-body ol {
		margin: 10px 0 16px 26px;
		padding: 0;
	}

	.news-body li {
		margin-bottom: 8px;
	}

	.news-body a {
		color: #2f77eb;
		text-decoration: none;
	}

	.news-body a:hover {
		text-decoration: underline;
	}

	.news-body img {
		max-width: 100%;
		height: auto;
		border-radius: 8px;
		margin: 12px auto;
		display: block;
		box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
	}

	.news-body blockquote {
		margin: 16px 0;
		padding: 12px 16px;
		background: #f8fafc;
		border-left: 4px solid #91bdf5;
		color: #666;
	}

	.news-body table {
		width: 100% !important;
		border-collapse: collapse !important;
		table-layout: fixed;
		margin: 18px 0;
		background: #fff;
		color: #555;
		border-radius: 8px;
		overflow: hidden;
	}

	.news-body table th,
	.news-body table td {
		border: 1px solid #dbe5f0 !important;
		padding: 10px 12px;
		min-height: 42px;
		height: auto !important;
		vertical-align: top;
		word-break: break-word;
		line-height: 1.7;
	}

	.news-body table th {
		background: #f3f8fe;
		color: #34495e;
		font-weight: 700;
	}

	.news-body table tr:nth-child(even) {
		background: #f9fbfd;
	}

	.news-footer {
		text-align: center;
		padding: 18px 20px 24px;
		background: #fff;
		border-top: 1px solid #edf2f7;
	}

	.news-footer .easyui-linkbutton {
		min-width: 120px;
	}

	.news-empty {
		text-align: center;
		color: #999;
		padding: 40px 0;
		font-size: 14px;
	}

	@media screen and (max-width: 768px) {
		.news-page {
			padding: 12px;
		}

		.news-toolbar {
			flex-direction: column;
			align-items: flex-start;
			gap: 10px;
		}

		.news-header {
			padding: 22px 18px 18px;
		}

		.news-title {
			font-size: 22px;
		}

		.news-body {
			padding: 20px 18px 28px;
			font-size: 14px;
			line-height: 1.85;
		}

		.news-meta .meta-item {
			display: block;
			margin: 4px 0;
		}
	}
</style>

<div class="news-page">
	<!-- 顶部操作栏 -->
	<div id="dlg-toolbar" class="news-toolbar">
		<div class="news-toolbar-left">
			<a href="javascript:void(0);"
			   onclick="goBack();return false;"
			   class="easyui-linkbutton"
			   data-options="iconCls:'icon-back',plain:true">返回</a>
		</div>
		<div class="news-toolbar-right">
			新闻详情
		</div>
	</div>

	<!-- 主卡片 -->
	<div class="news-card">
		<!-- 标题区 -->
		<div class="news-header">
			<h1 class="news-title">${news.title}</h1>
			<div class="news-meta">
                <span class="meta-item">
                    <span class="meta-label">发布人：</span>${news.fbr}
                </span>
				<span class="meta-item">
                    <span class="meta-label">发布时间：</span>${news.addtime}
                </span>
			</div>
		</div>

		<!-- 正文区 -->
		<div class="news-body">
			<c:choose>
				<c:when test="${not empty news.content}">
					${news.content}
				</c:when>
				<c:otherwise>
					<div class="news-empty">暂无内容</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 底部操作区 -->
		<div class="news-footer">
			<a class="easyui-linkbutton"
			   data-options="iconCls:'icon-back'"
			   href="javascript:void(0);"
			   onclick="goBack()">关闭当前页</a>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(function () {
		$.parser.parse();

		// 统一处理正文中可能带固定宽度的表格
		$(".news-body table").each(function () {
			$(this).css({
				"width": "100%",
				"table-layout": "fixed"
			});
		});

		// 正文中的图片移除固定宽高，保证自适应
		$(".news-body img").each(function () {
			$(this).css({
				"max-width": "100%",
				"height": "auto"
			}).removeAttr("width").removeAttr("height");
		});
	});

	function goBack() {
		try {
			window.history.go(-1);
		} catch (e) {
			window.history.back();
		}
	}
</script>