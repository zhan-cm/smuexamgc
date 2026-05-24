<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">
<style>
	#word {
		font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
		"Helvetica Neue", Arial, "Noto Sans", "PingFang SC",
		"Hiragino Sans GB", "Microsoft YaHei", sans-serif;
	}

	.exam-wrapper {
		max-width: 1100px;
		margin: 2rem auto;
	}

	.exam-header-title {
		font-size: 1.75rem;
		font-weight: 600;
		color: #dc3545;
	}

	.exam-section-title {
		font-size: 1.25rem;
		font-weight: 600;
		color: #dc3545;
	}

	.summary-block {
		background-color: #ffffff;
		border-radius: 0.5rem;
		box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
		padding: 1.5rem;
		margin-bottom: 2rem;
	}

	.summary-block p {
		margin-bottom: 0.4rem;
	}

	.detail-card {
		box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
		margin-bottom: 2.5rem;
	}

	.detail-card .card-header {
		background: linear-gradient(90deg, #ffe6e9, #ffffff);
		color: #c82333;
		font-weight: 600;
	}

	.table-summary th,
	.table-summary td,
	.table-theme th,
	.table-theme td {
		text-align: center;
		vertical-align: middle;
		white-space: nowrap;
	}

	.even-tr {
		background-color: #f8f9fa;
	}

	.theme-btn {
		min-width: 120px;
	}

	.action-bar {
		margin: 1.5rem auto 0;
		text-align: center;
	}

	.action-bar .btn {
		margin: 0 0.25rem;
	}
</style>

<input type="hidden" value="${ename}" id="ename" />
<input type="hidden" value="${eid}" id="eid" />
<c:set var="cids" value="${fn:split(cids, ',')}" />

<!-- startprint -->
<div id="word" class="exam-wrapper">

	<!-- 页面标题 -->
	<div class="text-center mb-3">
		<div class="exam-header-title">
			《${ename}》试卷（
			<c:if test="${eInfo.AORB == 0}">A卷</c:if>
			<c:if test="${eInfo.AORB == 1}">B卷</c:if>
			）双向细目表
		</div>
	</div>

	<!-- 整张试卷合计信息 -->
	<div class="summary-block">
		<div class="exam-section-title text-center mb-3">整张试卷试题合计</div>

		<p class="text-center">
			<strong>难度分布：</strong>
			<c:forEach items="${examDiffAndScore}" var="c">
				<span class="me-3">
					${c.dname}题${c.count}道，占${c.percent}
				</span>
			</c:forEach>
		</p>

		<p class="text-center">
			<strong>分值分布：</strong>
			<c:forEach items="${examDiffAndScore}" var="c">
				<span class="me-3">
					${c.dname}题${c.score}分，占${c.spercent}
				</span>
			</c:forEach>
		</p>

		<p class="text-center mb-0">
			<c:choose>
				<c:when test="${empty eInfo.FORBIDBEFORE or eInfo.FORBIDBEFORE eq 0}">
					不限制试题的考过天数
				</c:when>
				<c:otherwise>
					不选用${eInfo.FORBIDBEFORE}天之内考过的试题
				</c:otherwise>
			</c:choose>
			<c:choose>
				<c:when test="${empty eInfo.FORBIDNUM or eInfo.FORBIDNUM eq 0}">
					，不限制试题的考过次数
				</c:when>
				<c:otherwise>
					，不选用使用过${eInfo.FORBIDNUM}次及以上的试题
				</c:otherwise>
			</c:choose>
			，选用
			<c:choose>
				<c:when test="${eInfo.ISVERIFIED == 1}">
					已审核
				</c:when>
				<c:otherwise>
					全部
				</c:otherwise>
			</c:choose>
			试题
		</p>
	</div>

	<!-- 整张试卷题型/分值表 -->
	<div class="card detail-card mb-4">
		<div class="card-header text-center">
			题目类型与分值汇总
		</div>
		<div class="card-body p-0">
			<div class="table-responsive">
				<table class="table table-bordered table-striped table-sm mb-0 table-summary">
					<thead class="table-light">
					<tr>
						<th scope="col">题目类型</th>
						<th scope="col">题目数量</th>
						<th scope="col">所占分值</th>
					</tr>
					</thead>
					<tbody>
					<c:set var="count" value="0" />
					<c:set var="sum" value="0" />
					<c:forEach items="${paperQtCountAndSum}" var="cs" varStatus="status">
						<c:set var="count" value="${count + cs.COUNT}" />
						<c:set var="sum" value="${sum + cs.SCORE}" />
						<tr class="<c:if test='${status.index % 2 == 0}'>even-tr</c:if>">
							<td>${cs.QTNAME}</td>
							<td>${cs.COUNT}</td>
							<td>${cs.SCORE}</td>
						</tr>
					</c:forEach>
					<tr class="table-secondary fw-bold">
						<td>合计</td>
						<td>
							<span class="text-danger">${count}</span>
						</td>
						<td>
							<span class="text-danger">${sum}</span>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<!-- 每个章节的双向细目表 -->
	<c:forEach items="${res}" var="res">
		<div class="card detail-card">
			<div class="card-header text-center">
				《${res.cname}》双向细目表
			</div>
			<div class="card-body">

				<p class="text-center mb-1">
					<strong>难度分布：</strong>
					<c:forEach items="${res.diffAndScore}" var="d">
						<span class="me-3">
							${d.dname}题${d.count}道，占${d.percent}
						</span>
					</c:forEach>
				</p>
				<p class="text-center mb-3">
					<strong>分值分布：</strong>
					<c:forEach items="${res.diffAndScore}" var="d">
						<span class="me-3">
							${d.dname}题${d.score}分，占${d.spercent}
						</span>
					</c:forEach>
				</p>

				<div class="table-responsive">
					<table class="table table-bordered table-hover table-sm mb-0 table-theme">
						<thead class="table-light">
						<tr>
							<th scope="col">主题词/题型</th>
							<c:forEach items="${res.getExamPaperQuestionType}" var="qt">
								<th scope="col">
										${qt.QTNAME}
									<input type="hidden" class="qtid" value="${qt.QTID}" />
								</th>
							</c:forEach>
							<th scope="col">合计</th>
						</tr>
						</thead>
						<tbody>
						<c:set var="count" value="0" />
						<c:set var="sum" value="0" />
						<c:forEach items="${res.themeList}" var="th" varStatus="status">
							<tr id="th_${th.ID}" class="<c:if test='${status.index % 2 == 0}'>even-tr</c:if>">
								<c:set value="0" var="thCount" />
								<c:set value="0" var="thScore" />

								<td>
									<button
											type="button"
											class="btn btn-sm btn-outline-primary theme-btn"
											data-thid="${th.ID}"
											data-thlevel="2"
											data-cid="${th.CID}"
											onclick="getNextTheme('${th.ID}',2,'${th.CID}');">
											${th.NAME}
									</button>
									<input type="hidden" value="${th.ID}" class="thid" />
								</td>

								<c:forEach items="${res.getExamPaperQuestionType}" var="qt">
									<c:set var="qtnum" value="0" />
									<c:set var="qtsum" value="0" />
									<c:forEach items="${res.checkList}" var="cl">
										<c:if test="${qt.QTID == cl.QTID && cl.THID == th.ID}">
											<c:set var="qtnum" value="${cl.QCOUNT}" />
											<c:set var="qtsum" value="${cl.SCORE}" />
										</c:if>
									</c:forEach>
									<td>${qtnum}题 / ${qtsum}分</td>
									<c:set var="thCount" value="${thCount + qtnum}" />
									<c:set var="thScore" value="${thScore + qtsum}" />
								</c:forEach>

								<c:set var="count" value="${count + thCount}" />
								<c:set var="sum" value="${sum + thScore}" />
								<td class="text-danger">
										${thCount}题 / ${thScore}分
								</td>
							</tr>
						</c:forEach>
						</tbody>
						<tfoot>
						<tr class="table-secondary fw-bold">
							<td>题目数量 / 分值合计</td>
							<c:forEach items="${res.getExamPaperQuestionType}" var="qt">
								<c:set value="0" var="qtnums" />
								<c:set value="0" var="qtsums" />
								<c:forEach items="${res.checkList}" var="cl">
									<c:if test="${qt.QTID == cl.QTID}">
										<c:set var="qtnums" value="${qtnums + cl.QCOUNT}" />
										<c:set var="qtsums" value="${qtsums + cl.SCORE}" />
									</c:if>
								</c:forEach>
								<td class="text-danger">
										${qtnums}题 / ${qtsums}分
								</td>
							</c:forEach>
							<td class="text-danger">
									${count}题 / ${sum}分
							</td>
						</tr>
						</tfoot>
					</table>
				</div>

			</div>
		</div>
	</c:forEach>

</div>

<!-- 底部操作按钮 -->
<div class="action-bar">
	<a id="expandBtn" class="btn btn-outline-info easyui-linkbutton" href="javascript:void(0);" onclick="expandAllThemes();">展开全部主题词</a>
	<a class="btn btn-outline-primary easyui-linkbutton" href="javascript:void(0);" onclick="saveAsWord();">导出双向细目表</a>
	<a class="btn btn-outline-secondary easyui-linkbutton" href="javascript:void(0);" onclick="print();">打印页面</a>
	<c:choose>
		<c:when test="${sign == 1}">
			<a class="btn btn-outline-dark easyui-linkbutton"
			   href="javascript:void(0);" onclick="next();">
				关闭
			</a>
		</c:when>
		<c:otherwise>
			<c:if test="${fn:length(cids) < 2}">
				<c:forEach items="${cids}" var="c">
					<a class="btn btn-outline-success easyui-linkbutton"
					   href="javascript:void(0);" onclick="saveCheckList(this);">
						保存双向细目表为模板
					</a>
					<input type="hidden" id="cid" value="${c}" />
				</c:forEach>
			</c:if>
			<a class="btn btn-outline-dark easyui-linkbutton"
			   href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">
				关闭
			</a>
		</c:otherwise>
	</c:choose>
</div>

<div id="win"></div>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.PrintArea.js"></script>
<script src="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>

<script type="text/javascript">
	var isAllExpand = false;
	function saveAsWord() {
		var name = $("#ename").val();

		// 1. 克隆一份 #word，不动页面原件
		var $clone = $("#word").clone();

		// 2. 在克隆上做列宽和主题词样式处理
		fixThemeTableWidthForClone($clone);
		styleThemeButtonsForClone($clone);

		// 3. 放到一个隐藏容器里，防止影响布局
		var $temp = $("<div style='display:none;'></div>").appendTo("body");
		$temp.append($clone);

		// 4. 导出专用 CSS
		var s =
				"@page{margin:1.5cm;}" +
				"body{margin:0;font-family:'Microsoft YaHei',Arial,sans-serif;font-size:9pt;}" +
				".exam-header-title{font-size:15pt;font-weight:bold;color:#c00000;text-align:center;margin-bottom:12pt;}" +
				".exam-section-title{font-size:12pt;font-weight:bold;color:#c00000;text-align:center;margin-bottom:6pt;}" +
				".summary-block{border:1px solid #ddd;padding:10pt;margin-bottom:12pt;}" +

				"table{border-collapse:collapse;width:100%;}" +
				"td,th{border:1px solid #ccc;padding:4pt;text-align:center;word-wrap:break-word;white-space:normal;}" +
				".even-tr{background-color:#f2f2f2;}" +
				".text-danger{color:#ff0000;}" +
				".table-theme{table-layout:fixed;width:100%;}";

		// 5. 对克隆调用 wordExport
		$clone.wordExport(name, s);

		// 6. 清理临时 DOM
		$temp.remove();
	}

	// 按列数平均分配宽度（只处理主题词表格，且只改克隆）
	function fixThemeTableWidthForClone($root) {
		$root.find(".table-theme").each(function () {
			var $table = $(this);
			var $firstRow = $table.find("tr:first");
			var $ths = $firstRow.find("th");

			var colCount = $ths.length;
			if (colCount === 0) return;

			var colWidth = (100 / colCount).toFixed(2) + "%";

			// 给这个克隆表格固定布局
			$table.css("table-layout", "fixed");

			// 所有单元格统一宽度（写到行内 style 里，Word 更听话）
			$table.find("th,td").each(function () {
				this.style.width = colWidth;
			});
		});
	}

	function styleThemeButtonsForClone($root) {
		$root.find(".theme-btn").each(function () {
			var $btn = $(this);
			var text = $.trim($btn.text());
			var color = "#000000"; // 默认黑色（防御一下）
			if ($btn.hasClass("btn-outline-primary")) {
				// 一级主题词
				color = "#0d6efd";
			} else if ($btn.hasClass("btn-outline-success")) {
				// 二级主题词
				color = "#198754";
			} else if ($btn.hasClass("btn-outline-danger")) {
				// 三级主题词
				color = "#dc3545";
			}

			// 只保留文字 + 颜色，不要任何边框、padding
			var $span = $("<span></span>")
					.text(text)
					.css({
						"color": color,
						"font-size": "9pt"
					});

			// 用 span 替换掉 button
			$btn.replaceWith($span);
		});
	}

	function print() {
		$("#word").printArea();
	}

	function saveCheckList(element) {
		// element 为触发按钮，兼容旧用法
		var $element = $(element || document.body);

		var winStr = '<div class="p-3">' +
				'<div class="mb-3 row align-items-center">' +
				'<label class="col-4 col-form-label text-end" style="font-size:13px;">模板名称：</label>' +
				'<div class="col-8">' +
				'<input type="text" name="mname" id="mname" class="form-control form-control-sm" />' +
				'</div>' +
				'</div>' +
				'<div class="text-center">' +
				'<a class="btn btn-sm btn-primary me-2" href="javascript:void(0);" onclick="save()">确认</a>' +
				'<a class="btn btn-sm btn-outline-secondary" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">取消</a>' +
				'</div>' +
				'</div>';

		var obj = $(winStr);
		$('#win').html(null);
		obj.appendTo("#win");

		$('#win').window({
			width: 360,
			height: 170,
			top: ($element.position().top + $element.height()) * 0.7,
			modal: true,
			title: "编辑模板名称"
		});
	}

	function getNextTheme(thid, thlevel, cid) {
		var exist = false;
		$(".pid").each(function () {
			if ($(this).val() == thid) {
				var $row = $("tr").has(this);
				if ($row.is(":hidden")) {
					$row.show();
				} else {
					$row.hide();
				}
				exist = true;
			}
		});
		if (exist) {
			return;
		}
		var data = getThemeData(thid, thlevel, cid);
		appendTheme(data, thid, thlevel, cid);
	}

	function getThemeData(thid, thlevel, cid) {
		var rs = "";
		var eid = $("#eid").val();
		$.ajax({
			url: "${pageContext.request.contextPath}/paper/getThQSumAndQCount",
			type: "POST",
			async: false,
			data: { "thid": thid, "eid": eid, "cid": cid, "thlevel": thlevel },
			success: function (data) {
				rs = data;
			}
		});
		return rs;
	}

	function appendTheme(data, thid, thlevel, cid) {
		if (!data || data.length === 0) {
			toastr.warning('已经没有下级主题词的试题了');
			return;
		}
		var win = '';
		for (var i = 0; i < data.length; i++) {
			var tlevel = parseInt(thlevel, 10) + 1;
			win += "<tr id='th_" + data[i].THID + "'>";
			win += "<td>";
			win += "<button type='button' class='btn btn-sm "
			if (thlevel == 2) {
				win += "btn-outline-success ";
			} else {
				win += "btn-outline-danger ";
			}
			win += "theme-btn' onclick='getNextTheme(" + data[i].THID + "," + tlevel + "," + cid + ");'>" + data[i].THNAME + "</button>";
			win += "<input type='hidden' class='pid' value='" + thid + "'/>";
			win += "<input type='hidden' class='thid' value='" + data[i].THID + "'/>";
			win += "</td>";

			var count = 0;
			var sum = 0;
			var total = data[i].TOTAL;

			var $table = $("#th_" + thid).closest("table");
			$table.find(".qtid").each(function () {
				var qtid = $(this).val();
				var c = 0;
				var s = 0;
				for (var j = 0; j < total.length; j++) {
					var q_qtid = total[j].QTID;
					if (q_qtid == qtid) {
						c = parseInt(total[j].COUNT, 10);
						s = parseFloat(total[j].SCORE);
						sum += s;
						count += c;
						break;
					}
				}
				win += "<td>" + c + "题 / " + s + "分</td>";
			});

			win += "<td class='text-danger'>" + count + "题 / " + sum + "分</td>";
			win += "</tr>";
		}
		$("#th_" + thid).after(win);
	}

	function save() {
		var eid = $("#eid").val();
		var cid = $("#cid").val();
		var name = $("#mname").val();//双向细目表模板名称

		$.ajax({
			url: "${pageContext.request.contextPath}/paper/saveCheckList",
			type: "POST",
			data: { "cid": cid, "name": name, "eid": eid },
			success: function (data) {
				if (data > 0) {
					toastr.success('已成功保存双向细目表模板');
					$("#win").window('close');
				} else if (data === 0) {
					toastr.error('此试卷没有试题，无法保存双向细目表模板');
					$("#win").window('close');
				} else if (data === -1) {
					toastr.warning("模板名称已存在");
				} else {
					toastr.error("保存失败");
					$("#win").window('close');
				}
			}
		});
	}

	function next() {
		window.location.href =
				"${pageContext.request.contextPath}/paper/editApaper?assembly=y&c_id="
				+ $("#cid").val() + "&ei_id=" + $("#eid").val();
	}

	function appendThemeQuiet(data, thid, thlevel, cid) {
		// 和 appendTheme 基本一样，只是没有 warning
		if (!data || data.length === 0) {
			return;
		}
		var win = '';
		for (var i = 0; i < data.length; i++) {
			var tlevel = parseInt(thlevel, 10) + 1;
			win += "<tr id='th_" + data[i].THID + "'>";
			win += "<td>";
			win += "<button type='button' class='btn btn-sm ";
			if (thlevel == 2) {
				win += "btn-outline-success ";
			} else {
				win += "btn-outline-danger ";
			}
			win += "theme-btn' onclick='getNextTheme(" + data[i].THID + "," + tlevel + "," + cid + ");'>" + data[i].THNAME + "</button>";
			win += "<input type='hidden' class='pid' value='" + thid + "'/>";
			win += "<input type='hidden' class='thid' value='" + data[i].THID + "'/>";
			win += "</td>";

			var count = 0;
			var sum = 0;
			var total = data[i].TOTAL;

			var $table = $("#th_" + thid).closest("table");
			$table.find(".qtid").each(function () {
				var qtid = $(this).val();
				var c = 0;
				var s = 0;
				for (var j = 0; j < total.length; j++) {
					var q_qtid = total[j].QTID;
					if (q_qtid == qtid) {
						c = parseInt(total[j].COUNT, 10);
						s = parseFloat(total[j].SCORE);
						sum += s;
						count += c;
						break;
					}
				}
				win += "<td>" + c + "题 / " + s + "分</td>";
			});

			win += "<td class='text-danger'>" + count + "题 / " + sum + "分</td>";
			win += "</tr>";
		}
		$("#th_" + thid).after(win);
	}

	// 递归展开某个主题（最多到三级 thlevel <= 3）
	function expandThemeRecursively(thid, thlevel, cid) {
		var hasChild = false;

		// 1. 如果已经有子节点，只需要把它们显示出来
		$(".pid").each(function () {
			if ($(this).val() == thid) {
				hasChild = true;
				$(this).closest("tr").show();
			}
		});

		// 2. 没有子节点，就去后端拉一次
		if (!hasChild) {
			var data = getThemeData(thid, thlevel, cid);
			if (data && data.length > 0) {
				appendThemeQuiet(data, thid, thlevel, cid);
				hasChild = true;
			}
		}

		// 3. 如果还有下一层，继续递归（你说最多三级）
		if (hasChild && thlevel < 3) {
			// 遍历直属子节点：紧跟在当前行后面，且 .pid == thid 的那些行
			var $row = $("#th_" + thid).next();
			while ($row.length) {
				var pid = $row.find(".pid").val();
				if (pid == thid) {
					var childId = $row.find(".thid").val();
					expandThemeRecursively(childId, thlevel + 1, cid);
					$row = $row.next();
				} else {
					// 遇到属于别的父节点的行，说明当前父节点的子区域结束
					break;
				}
			}
		}
	}

	function expandAllThemes() {
		if(isAllExpand){
			$(".pid").each(function () {
				$(this).closest("tr").hide();
			});
			$("#expandBtn").text("展开全部主题词");
		}else{
			// 所有一级主题词按钮：特点是所在行没有 .pid
			$(".theme-btn").each(function () {
				var $btn = $(this);
				var $row = $btn.closest("tr");

				// 排除已经是子主题的按钮
				if ($row.find(".pid").length === 0) {
					var thid = $btn.data("thid");
					var thlevel = parseInt($btn.data("thlevel"), 10) || 2; // 一级点开是 level2
					var cid = $btn.data("cid");

					expandThemeRecursively(thid, thlevel, cid);
				}
			});
			$("#expandBtn").text("收起全部主题词");
		}
		isAllExpand = !isAllExpand;
	}
</script>
