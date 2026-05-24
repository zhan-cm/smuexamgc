<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<link href="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/css/bootstrap.min.css" rel="stylesheet">
<style>
	.analysis-container {
		background: #fff;
		padding: 20px;
		box-shadow: 0 2px 8px rgba(0,0,0,0.1);
		border-radius: 8px;
		margin: 20px auto;
		max-width: 900px;
	}

	.analysis-container h3,
	.analysis-container h4 {
		color: #2c3e50;
		margin: 0 0 10px;
		font-weight: 600;
	}
	.analysis-section {
		margin-bottom: 20px;
	}
	.analysis-section h4 {
		border-left: 4px solid #3498db;
		padding-left: 10px;
	}

	.table-block {
		background: #f8f9fa;
		padding: 15px;
		border-radius: 6px;
		border: 1px solid #eee;
		margin-bottom: 15px;
	}

	.highlight {
		color: red;
		font-weight: 500;
	}

	.btn-group-custom {
		text-align: center;
		margin-top: 15px;
	}
	.btn-group-custom .easyui-linkbutton {
		margin: 0 5px;
		min-width: 100px;
		display: inline-block;
	}
</style>
<input type="hidden" id="ename" value="${ename}" />
<div class="analysis-container" id="word">
	<div class="analysis-section text-center">
		<h3>${paperName}考前预测分析结果</h3>
	</div>

	<div class="analysis-section">
		<h4>难度分析</h4>
		<div class="table-block">
			<div>
				本试卷共有 <span class="highlight">${count}</span> 道试题，
				满分为 <span class="highlight">${total}</span> 分，
				预计平均分为 <span class="highlight">${average}</span> 分。
			</div>
			<table class="table table-bordered table-sm mt-2">
				<thead>
				<tr>
					<th>难度名称</th>
					<th>题目数量</th>
					<th>占试题总数</th>
					<th>对应分值</th>
					<th>占满分</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="res" items="${difficultyRes}">
					<tr>
						<td>${res.name}</td>
						<td>${res.num}</td>
						<td>${res.percent}</td>
						<td>${res.score}</td>
						<td>${res.fspercent}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<div class="analysis-section">
		<h4>广度分析</h4>
		<div class="table-block">
			试题覆盖一级主题词
			<span class="highlight">${t1percent}</span>，
			二级主题词
			<span class="highlight">${t2percent}</span>。
		</div>
	</div>

	<div class="analysis-section">
		<h4>答题时间分析</h4>
		<div class="table-block">
			完成本试卷的应答时间为
			<span class="highlight">${answerTime}</span>，
			占考试时间 ${totalTime} 的
			<span class="highlight">${occupiedTime}</span>。
		</div>
	</div>

	<div class="analysis-section">
		<h4>效度分析</h4>
		<div class="table-block">
			<table class="table table-bordered table-sm">
				<thead>
				<tr>
					<th>知识点</th>
					<th>题目数量</th>
					<th>占试题总数</th>
					<th>分值</th>
					<th>占满分</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="res" items="${knowledgeRes}">
					<tr>
						<td>${res.name}</td>
						<td>${res.num}</td>
						<td>${res.percent}</td>
						<td>${res.score}</td>
						<td>${res.fspercent}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<div class="analysis-section">
		<h4>认知分析</h4>
		<div class="table-block">
			<table class="table table-bordered table-sm">
				<thead>
				<tr>
					<th>认知层次</th>
					<th>题目数量</th>
					<th>占试题总数</th>
					<th>分值</th>
					<th>占满分</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="res" items="${cognitionRes}">
					<tr>
						<td>${res.name}</td>
						<td>${res.num}</td>
						<td>${res.percent}</td>
						<td>${res.score}</td>
						<td>${res.fspercent}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<div class="analysis-section">
		<h4>题型分析</h4>
		<div class="table-block">
			<table class="table table-bordered table-sm">
				<thead>
				<tr>
					<th>题型</th>
					<th>题目数量</th>
					<th>占试题总数</th>
					<th>分值</th>
					<th>占满分</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="res" items="${questionTypeRes}">
					<tr>
						<td>${res.name}</td>
						<td>${res.num}</td>
						<td>${res.percent}</td>
						<td>${res.score}</td>
						<td>${res.fspercent}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<div class="analysis-section">
		<h4>使用次数分析</h4>
		<div class="table-block">
			<table class="table table-bordered table-sm">
				<thead>
				<tr>
					<th>已使用次数</th>
					<th>题目数量</th>
					<th>占试题总数</th>
					<th>分值</th>
					<th>占满分</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach var="res" items="${usetimeTotal}">
					<tr>
						<td>${res.usetime}</td>
						<td>${res.num}</td>
						<td>${res.questionPer}</td>
						<td>${res.score}</td>
						<td>${res.scorePer}</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<c:if test="${verify == 1}">
				<!-- 如果需要在页面显示额外提示或内容 -->
			</c:if>
		</div>
	</div>
</div>

<div class="btn-group-custom">
	<c:if test="${state==6 }">
		<a class="easyui-linkbutton" href="javascript:void(0);" onclick="analysisPaper('${ei_id}')">考后成绩分析</a>
	</c:if>
	<a class="easyui-linkbutton" href="javascript:void(0);" onclick="saveAsWord();">保存为word</a>
	<a class="easyui-linkbutton" href="javascript:void(0);" onclick="printPage();">打印页面</a>
	<a class="easyui-linkbutton" href="javascript:void(0);" onclick="cancelEasyUiFrame(0);">关闭</a>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.PrintArea.js"></script>
<script type="text/javascript">
	function saveAsWord(){
		var name = "${paperName}考前预测分析结果";
		const $clone = $("#word").clone();

		// 添加专为Word优化的样式
		const wordStyles = `
        <style>
            /* 重置所有元素样式保证Word兼容性 */
            * {
                font-family: 微软雅黑, Arial, sans-serif !important;
                line-height: 1.5;
                box-sizing: border-box;
            }
            .analysis-container {
                width: 100% !important;
                margin: 0 auto !important;
            }
            .text-center {
                text-align: center !important;
            }
            .table-block {
                margin: 15px 0 !important;
                page-break-inside: avoid; /* 防止表格分页断裂 */
            }
            table {
                width: 100% !important;
                margin: 10px auto !important;
                border-collapse: collapse !important;
                table-layout: fixed;
            }
            th, td {
                padding: 8px 12px !important;
                border: 1px solid #ddd !important;
                text-align: center !important;
                word-wrap: break-word;
            }
            th {
                background-color: #f8f9fa !important;
                font-weight: bold !important;
            }
            .highlight {
                color: red !important;
                font-weight: bold !important;
            }
            h3, h4 {
                color: #2c3e50 !important;
                margin: 10px 0 !important;
            }
            h4 {
                border-left: 4px solid #3498db !important;
                padding-left: 10px !important;
            }
        </style>
    `;

		// 处理表格对齐问题
		$clone.find('table').each(function() {
			$(this).attr('align', 'center');
			$(this).css('width', '100%');
			$(this).find('th, td').css('text-align', 'center');
		});

		// 处理文本居中问题
		$clone.find('.text-center').css({
			'text-align': 'center',
			'margin': '20px 0'
		});

		$clone.prepend(wordStyles);
		$clone.wordExport(name);
	}

	function printPage(){
		$("#word").printArea();
	}

	function analysisPaper(eid){
		window.location.href="${pageContext.request.contextPath}/result/analysisPaper?eid="+eid;
	}
</script>