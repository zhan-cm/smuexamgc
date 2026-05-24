<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<style>
	:root {
		--page-bg: #f5f7fb;
		--card-bg: #ffffff;
		--border-color: #d9e1ec;
		--text-main: #24324a;
		--text-sub: #5b677a;
		--primary: #4b74e6;
		--primary-light: #eef3ff;
		--success-bg: #edf8f1;
		--success-border: #bfe3c8;
		--success-text: #1d6b3a;
		--info-bg: #eef5ff;
		--info-border: #c8dbff;
		--info-text: #2356a8;
		--error-bg: #fff1f0;
		--error-border: #f3c3bf;
		--error-text: #b42318;
		--table-head: #f4f7fc;
		--table-summary: #eef2f7;
		--table-final: #f9f4e8;
		--shadow: 0 6px 18px rgba(28, 44, 77, 0.08);
	}

	* {
		box-sizing: border-box;
	}

	body {
		margin: 0;
		padding: 24px 0;
		background: var(--page-bg);
		color: var(--text-main);
		font-size: 14px;
		line-height: 1.6;
	}

	.page-shell {
		width: min(1400px, 92%);
		margin: 0 auto;
	}

	.page-card {
		background: var(--card-bg);
		border: 1px solid var(--border-color);
		border-radius: 14px;
		box-shadow: var(--shadow);
		overflow: hidden;
	}

	.page-header {
		padding: 28px 32px 18px;
		border-bottom: 1px solid #edf1f6;
		background: linear-gradient(180deg, #ffffff 0%, #fafcff 100%);
	}

	.page-title {
		margin: 0;
		font-size: 26px;
		font-weight: 700;
		text-align: center;
		color: #1f2f4a;
		letter-spacing: 0.5px;
	}

	.page-meta {
		margin-top: 14px;
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 24px;
		font-size: 15px;
		color: var(--text-sub);
	}

	.page-meta strong {
		color: var(--text-main);
		font-weight: 600;
		margin-right: 6px;
	}

	.page-meta .meta-value {
		color: #1b2a45;
		font-weight: 600;
		text-decoration: underline;
	}

	.toolbar {
		padding: 20px 32px;
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 16px;
		border-bottom: 1px solid #edf1f6;
		background: #fbfcfe;
	}

	.toolbar-left {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 12px;
		color: var(--text-main);
	}

	.toolbar-label {
		font-weight: 600;
		color: var(--text-main);
	}

	.toolbar-separator {
		color: var(--text-sub);
	}

	.toolbar-right {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
	}

	.status-region {
		padding: 18px 32px 0;
	}

	.message-box {
		display: none;
		padding: 14px 16px;
		border-radius: 10px;
		border: 1px solid transparent;
		font-size: 14px;
		line-height: 1.6;
	}

	.message-box.info {
		display: block;
		background: var(--info-bg);
		border-color: var(--info-border);
		color: var(--info-text);
	}

	.message-box.success {
		display: block;
		background: var(--success-bg);
		border-color: var(--success-border);
		color: var(--success-text);
	}

	.message-box.error {
		display: block;
		background: var(--error-bg);
		border-color: var(--error-border);
		color: var(--error-text);
	}

	.table-section {
		padding: 20px 32px 10px;
	}

	.loading-box {
		display: none;
		min-height: 180px;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		gap: 12px;
		color: var(--text-sub);
		border: 1px dashed #d6deeb;
		border-radius: 12px;
		background: #fcfdff;
	}

	.loading-spinner {
		width: 38px;
		height: 38px;
		border: 4px solid #dbe5f5;
		border-top-color: var(--primary);
		border-radius: 50%;
		animation: spin 0.85s linear infinite;
	}

	.loading-text {
		font-size: 15px;
		font-weight: 600;
		color: #4a5b78;
	}

	.loading-subtext {
		font-size: 13px;
		color: #7a889d;
	}

	@keyframes spin {
		to {
			transform: rotate(360deg);
		}
	}

	.table-wrapper {
		width: 100%;
		overflow-x: auto;
		border: 1px solid var(--border-color);
		border-radius: 12px;
		background: #fff;
	}

	.workload-table {
		width: 100%;
		min-width: 920px;
		border-collapse: collapse;
		table-layout: fixed;
	}

	.workload-table th,
	.workload-table td {
		border: 1px solid var(--border-color);
		padding: 12px 10px;
		text-align: center;
		vertical-align: middle;
		word-break: break-word;
	}

	.workload-table thead th {
		background: var(--table-head);
		color: #1f2f4a;
		font-size: 15px;
		font-weight: 700;
	}

	.workload-table tbody td {
		font-size: 14px;
		color: #2d3b54;
	}

	.workload-table tbody tr:hover td {
		background: #fafcff;
	}

	.work-type-cell {
		background: #f8fbff;
		font-weight: 700;
		color: #20407f;
		width: 110px;
	}

	.summary-row td {
		background: var(--table-summary);
		font-weight: 700;
	}

	.final-ratio-row td {
		background: var(--table-final);
		font-weight: 700;
		color: #5f4300;
	}

	.final-ratio-label {
		text-align: left !important;
		padding-left: 18px !important;
	}

	.unknown-user {
		color: #c52828;
		font-weight: 700;
	}

	.empty-cell {
		color: #7b8799;
	}

	.rate-note {
		display: block;
		margin-top: 4px;
		font-size: 12px;
		font-weight: 400;
		color: #5f6f88;
	}

	.page-note {
		margin: 18px 32px 0;
		padding: 12px 14px;
		border-left: 4px solid #f0c36d;
		background: #fffaf0;
		color: #6b5a2a;
		border-radius: 8px;
		font-size: 13px;
	}

	.page-footer {
		padding: 20px 32px 28px;
		text-align: center;
	}

	@media (max-width: 768px) {
		.page-shell {
			width: 96%;
		}

		.page-header,
		.toolbar,
		.status-region,
		.table-section,
		.page-footer {
			padding-left: 16px;
			padding-right: 16px;
		}

		.page-note {
			margin-left: 16px;
			margin-right: 16px;
		}

		.page-title {
			font-size: 22px;
		}

		.page-meta {
			gap: 10px 18px;
			flex-direction: column;
			align-items: center;
		}
	}
</style>

<input type="hidden" id="c_id" name="c_id" value="${c_id}" />

<main class="page-shell">
	<section class="page-card">
		<header class="page-header">
			<h1 class="page-title">《${cname}》试题工作量统计</h1>
			<div class="page-meta">
				<div>
					<strong>课程名称:</strong>
					<span class="meta-value">《${cname}》</span>
				</div>
				<div>
					<strong>建设负责人:</strong>
					<span class="meta-value">${name}</span>
				</div>
			</div>
		</header>

		<section class="toolbar" aria-label="查询条件">
			<div class="toolbar-left">
				<span class="toolbar-label">查找从</span>
				<input
						id="bdate"
						class="easyui-datebox"
						type="text"
						style="width:160px"
						data-options="editable:false,prompt:'开始日期'"
				/>
				<span class="toolbar-separator">到</span>
				<input
						id="edate"
						class="easyui-datebox"
						type="text"
						style="width:160px"
						data-options="editable:false,prompt:'结束日期'"
				/>
				<span class="toolbar-label">的统计</span>
			</div>

			<div class="toolbar-right">
				<a
						id="btnSearch"
						href="javascript:void(0)"
						class="easyui-linkbutton"
						onclick="searchByDate()"
						data-options="iconCls:'icon-search'"
				>
					查询
				</a>
				<a
						id="btnReset"
						href="javascript:void(0)"
						class="easyui-linkbutton"
						onclick="resetSearch()"
						data-options="iconCls:'icon-page_cancel',plain:true"
				>
					取消查询
				</a>
			</div>
		</section>

		<section class="status-region" aria-live="polite">
			<div id="messageBox" class="message-box"></div>
		</section>

		<section class="table-section">
			<div id="loadingBox" class="loading-box">
				<span class="loading-spinner" aria-hidden="true"></span>
				<div class="loading-text">统计加载中...</div>
				<div class="loading-subtext">正在获取试题工作量数据，请稍候</div>
			</div>

			<div class="table-wrapper" id="tableWrapper">
				<table id="datalist" class="workload-table"></table>
			</div>
		</section>

		<p class="page-note">
			* 备注：如果按主题词和题型分类的题目总数和题库中的题目总数不一致，说明题库中有些题主题词为空或者题型设置有误。
		</p>

		<footer class="page-footer">
			<a
					class="easyui-linkbutton"
					data-options="iconCls:'icon-delete'"
					href="javascript:void(0);"
					onclick="cancelEasyUiFrame(0)"
			>
				关闭
			</a>
		</footer>
	</section>
</main>

<script type="text/javascript">
	var cid = $("#c_id").val();
	var contextPath = "${pageContext.request.contextPath}";

	$(function () {
		loadWorkLoad("", "");
	});

	function searchByDate() {
		var bdate = $("#bdate").datebox("getValue");
		var edate = $("#edate").datebox("getValue");

		clearMessage();

		if ((bdate && !edate) || (!bdate && edate)) {
			showMessage("error", "开始时间和结束时间需要同时选择。");
			return;
		}

		if (bdate && edate) {
			var btime = new Date(bdate.replace(/-/g, "/"));
			var etime = new Date(edate.replace(/-/g, "/"));
			if (etime < btime) {
				showMessage("error", "开始时间不能大于结束时间。");
				return;
			}
		}

		loadWorkLoad(bdate, edate);
	}

	function resetSearch() {
		$("#bdate").datebox("clear");
		$("#edate").datebox("clear");
		clearMessage();
		loadWorkLoad("", "");
	}

	function loadWorkLoad(beginDate, endDate) {
		setLoading(true);
		clearMessage();
		$("#datalist").empty();

		$.ajax({
			url: contextPath + "/question/getWorkLoad",
			data: {
				cid: cid,
				beginDate: beginDate,
				endDate: endDate
			},
			type: "post",
			dataType: "json",
			async: true
		}).done(function (data) {
			if (!data) {
				renderEmptyTable("当前用户无权限查看该课程统计，或服务未返回数据。");
				showMessage("error", "当前用户无权限查看该课程统计，或服务未返回数据。");
				return;
			}

			renderWorkLoadTable(data, beginDate, endDate);
		}).fail(function (xhr, textStatus) {
			var message = buildAjaxErrorMessage(xhr, textStatus);
			renderEmptyTable("数据加载失败，请稍后重试。");
			showMessage("error", message);
		}).always(function () {
			setLoading(false);
		});
	}

	function renderWorkLoadTable(rs, beginDate, endDate) {
		var questionType = Array.isArray(rs.questionType) ? rs.questionType : [];
		var createWork = Array.isArray(rs.createWork) ? rs.createWork : [];
		var updateWork = Array.isArray(rs.updateWork) ? rs.updateWork : [];
		var verifyWork = Array.isArray(rs.verifyWork) ? rs.verifyWork : [];
		var lastVerifyWork = Array.isArray(rs.lastVerifyWork) ? rs.lastVerifyWork : [];
		var create_updateWork = Array.isArray(rs.create_updateWork) ? rs.create_updateWork : [];
		var count = toNumber(rs.count);

		if (questionType.length === 0) {
			renderEmptyTable("当前课程暂无可展示的题型统计数据。");
			var noDataText1 = buildRangeText(beginDate, endDate, true);
			showMessage("info", noDataText1 + "当前课程暂无可展示的题型统计数据。");
			return;
		}

		var hasCreate = sumWorkCount(createWork) > 0;
		var hasUpdate = sumWorkCount(updateWork) > 0;
		var hasVerify = sumWorkCount(verifyWork) > 0;
		var hasLastVerify = sumWorkCount(lastVerifyWork) > 0;

		if (!hasCreate && !hasUpdate && !hasVerify && !hasLastVerify) {
			renderEmptyTable("当前查询条件下暂无工作量统计数据。");
			var noDataText2 = buildRangeText(beginDate, endDate, true);
			showMessage("info", noDataText2 + "当前查询条件下暂无工作量统计数据。");
			return;
		}

		var html = "";
		html += "<thead>";
		html += "  <tr>";
		html += "      <th rowspan='2' style='width:10%'>工作类型</th>";
		html += "      <th rowspan='2' style='width:12%'>用户实名</th>";
		html += "      <th colspan='" + questionType.length + "'>题型题量</th>";
		html += "      <th rowspan='2' style='width:12%'>总计</th>";
		html += "  </tr>";
		html += "  <tr>";

		for (var i = 0; i < questionType.length; i++) {
			html += "<th>" + escapeHtml(getQtName(questionType[i])) + "</th>";
		}

		html += "  </tr>";
		html += "</thead>";

		html += "<tbody>";
		html += buildWorkRows(createWork, questionType, "createWork", count);
		html += buildWorkRows(updateWork, questionType, "updateWork", count);
		html += buildWorkRows(verifyWork, questionType, "verifyWork", count);
		html += buildWorkRows(lastVerifyWork, questionType, "lastVerifyWork", count);

		// 只有新增或更新任一有数据时，才显示最后这行占比
		if (hasCreate || hasUpdate) {
			html += buildFinalRatioRow(questionType, create_updateWork, count);
		}

		html += "</tbody>";

		$("#datalist").html(html);

		var summaryText = buildRangeText(beginDate, endDate, false) + "统计已完成。";
		showMessage("success", summaryText);
	}

	function buildWorkRows(work, qt, workType, count) {
		var safeWork = Array.isArray(work) ? work : [];
		var totalWorkCount = sumWorkCount(safeWork);

		// 当前维度总量为 0，整个维度不显示
		if (totalWorkCount === 0) {
			return "";
		}

		var qtsum = [];
		var html = "";
		var i, j, k;

		for (i = 0; i < qt.length; i++) {
			qtsum.push(0);
		}

		var rowSpan = safeWork.length + 1;

		for (i = 0; i < safeWork.length; i++) {
			var row = safeWork[i] || {};
			var sum = 0;
			var qtcount = Array.isArray(row.qtcount) ? row.qtcount : [];

			html += "<tr>";

			if (i === 0) {
				html += "<td rowspan='" + rowSpan + "' class='work-type-cell'>" + getWorkTypeLabel(workType) + "</td>";
			}

			if (row.name == null || row.name === "" || row.name === "noResult") {
				html += "<td><span class='unknown-user'>未知用户</span></td>";
			} else {
				html += "<td>" + escapeHtml(row.name) + "</td>";
			}

			for (j = 0; j < qt.length; j++) {
				var val = 0;
				var currentQtName = getQtName(qt[j]);

				for (k = 0; k < qtcount.length; k++) {
					if (currentQtName === getQtCountName(qtcount[k])) {
						val = toNumber(qtcount[k].qcount);
						break;
					}
				}

				qtsum[j] += val;
				sum += val;
				html += "<td>" + val + "</td>";
			}

			html += "<td>" + sum + "</td>";
			html += "</tr>";
		}

		var total = 0;
		for (i = 0; i < qtsum.length; i++) {
			total += qtsum[i];
		}

		html += "<tr class='summary-row'>";
		html += "<td>合计</td>";
		for (i = 0; i < qtsum.length; i++) {
			html += "<td>" + qtsum[i] + "</td>";
		}

		if (workType === "updateWork") {
			var rate = count > 0 ? total / count : 0;
			html += "<td>" + total + "（" + formatPercent(rate) + "）<span class='rate-note'>括号内为试题更新率</span></td>";
		} else {
			html += "<td>" + total + "</td>";
		}
		html += "</tr>";
		return html;
	}

	function buildFinalRatioRow(qt, create_updateWork, count) {
		var createTotal = sumWorkCount(create_updateWork);
		var ratio = count > 0 ? createTotal / count : 0;
		var colspan = qt.length + 2;

		var html = "";
		html += "<tr class='final-ratio-row'>";
		html += "<td colspan='" + colspan + "' class='final-ratio-label'>试题新增、更新合计占比</td>";
		html += "<td>" + formatPercent(ratio) + "</td>";
		html += "</tr>";

		return html;
	}

	function sumWorkCount(work) {
		var total = 0;
		var safeWork = Array.isArray(work) ? work : [];

		for (var i = 0; i < safeWork.length; i++) {
			var qtcount = Array.isArray(safeWork[i].qtcount) ? safeWork[i].qtcount : [];
			for (var j = 0; j < qtcount.length; j++) {
				total += toNumber(qtcount[j].qcount);
			}
		}

		return total;
	}

	function renderEmptyTable(message) {
		var html = "";
		html += "<thead>";
		html += "  <tr><th>提示</th></tr>";
		html += "</thead>";
		html += "<tbody>";
		html += "  <tr><td class='empty-cell'>" + escapeHtml(message) + "</td></tr>";
		html += "</tbody>";
		$("#datalist").html(html);
	}

	function setLoading(loading) {
		if (loading) {
			$("#loadingBox").css("display", "flex");
			$("#tableWrapper").hide();
			toggleQueryButtons(true);
		} else {
			$("#loadingBox").hide();
			$("#tableWrapper").show();
			toggleQueryButtons(false);
		}
	}

	function toggleQueryButtons(disabled) {
		var method = disabled ? "disable" : "enable";
		try {
			$("#btnSearch").linkbutton(method);
			$("#btnReset").linkbutton(method);
		} catch (e) {
			// easyui 未初始化时忽略，不影响页面使用
		}
	}

	function showMessage(type, text) {
		var $box = $("#messageBox");
		$box.removeClass("info success error").addClass("message-box " + type).html(escapeHtml(text)).show();
	}

	function clearMessage() {
		$("#messageBox").removeClass("info success error").removeAttr("style").html("");
	}

	function buildAjaxErrorMessage(xhr, textStatus) {
		if (xhr.status === 0) {
			return "接口请求失败，当前无法连接到服务端，请检查服务是否启动或网络是否可用。";
		}
		if (xhr.status === 404) {
			return "接口地址不存在（404），请报告系统管理员。";
		}
		if (xhr.status === 500) {
			return "服务端处理失败（500），请报告系统管理员。";
		}
		if (xhr.status) {
			return "数据加载失败，HTTP 状态码：" + xhr.status + "。";
		}
		return "数据加载失败，原因：" + textStatus + "。";
	}

	function buildRangeText(beginDate, endDate, noDataOnly) {
		if (beginDate && endDate) {
			return "已按时间范围 " + beginDate + " 至 " + endDate + " ";
		}
		return noDataOnly ? "" : "已按全部数据范围 ";
	}

	function getWorkTypeLabel(workType) {
		switch (workType) {
			case "createWork":
				return "新增";
			case "updateWork":
				return "更新";
			case "verifyWork":
				return "审核";
			case "lastVerifyWork":
				return "终审";
			default:
				return "未知";
		}
	}

	function getQtName(item) {
		if (!item) {
			return "";
		}
		return item.QTNAME || item.qtname || "";
	}

	function getQtCountName(item) {
		if (!item) {
			return "";
		}
		return item.qtname || item.QTNAME || "";
	}

	function toNumber(value) {
		var num = Number(value);
		return isNaN(num) ? 0 : num;
	}

	function formatPercent(value) {
		var percent = value * 100;
		return (Math.round(percent * 100) / 100).toFixed(2) + "%";
	}

	function escapeHtml(str) {
		if (str == null) {
			return "";
		}
		return String(str)
				.replace(/&/g, "&amp;")
				.replace(/</g, "&lt;")
				.replace(/>/g, "&gt;")
				.replace(/"/g, "&quot;")
				.replace(/'/g, "&#39;");
	}
</script>