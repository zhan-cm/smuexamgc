<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>

<style>
	.page-wrap{
		padding: 10px;
	}
	.page-tip{
		margin-bottom: 10px;
		padding: 10px 12px;
		background: #fff8e1;
		border: 1px solid #f0d58c;
		border-radius: 4px;
		color: #8a6d3b;
		line-height: 22px;
	}
	.order-table{
		width: 100%;
		border-collapse: collapse;
		border-spacing: 0;
		table-layout: fixed;
		background: #fff;
	}
	.order-table th,
	.order-table td{
		padding: 8px 10px;
		border: 1px solid #ddd;
		line-height: 1.5;
		vertical-align: middle;
		word-break: break-all;
	}
	.order-table th{
		background: #f5f5f5;
		font-weight: bold;
	}
	.order-table tr:hover{
		background: #fafafa;
	}
	.question-content{
		white-space: normal;
		line-height: 22px;
	}
	.op-cell{
		text-align: center;
		white-space: nowrap;
	}
	.op-btn{
		display: inline-block;
		padding: 2px 10px;
		margin: 0 4px;
		border: 1px solid #d9d9d9;
		border-radius: 3px;
		background: #fff;
		color: #333;
		text-decoration: none;
		cursor: pointer;
	}
	.op-btn:hover{
		background: #f3f3f3;
	}
	.op-disabled{
		pointer-events: none;
		opacity: 0.5;
	}
	.branch-link{
		display: inline-block;
		margin-right: 8px;
		color: #1677ff;
		text-decoration: none;
	}
	.branch-link:hover{
		text-decoration: underline;
	}
	.bottom-bar{
		padding-top: 12px;
		text-align: center;
	}
</style>

<div class="page-wrap">
	<div class="page-tip">
		<c:choose>
			<c:when test="${mode eq 'branch'}">
				只能在当前串题内部调整分支顺序
			</c:when>
			<c:otherwise>
				只能在同一题型内调整试题顺序，不能跨题型调整；同一题型下，不能跨课程调整
			</c:otherwise>
		</c:choose>
	</div>

	<form id="adjustForm" method="post" action="">
		<input type="hidden" name="ei_id" id="ei_id" value="${ei_id}"/>
		<input type="hidden" name="c_id" id="c_id" value="${c_id}"/>
		<input type="hidden" name="mqid" id="mqid" value="${mqid}"/>
		<input type="hidden" name="mode" id="mode" value="${mode}"/>

		<table class="order-table" id="mainTable">
			<c:choose>
				<c:when test="${mode eq 'branch'}">
					<tr>
						<th width="90%">试题内容</th>
						<th width="10%">调整顺序</th>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th width="20%">所属课程</th>
						<th width="12%">题型</th>
						<th width="58%">试题内容</th>
						<th width="10%">调整顺序</th>
					</tr>
				</c:otherwise>
			</c:choose>

			<c:forEach var="question" items="${exampaperQuestionList}">
				<tr class="qtrow"
					data-qid="${question.qid}"
					data-ismain="${question.ismain}"
					data-qtid="${question.qtid}"
					data-cid="${question.cid}">

					<c:if test="${mode ne 'branch'}">
						<td>${question.cname}</td>
						<td>${question.qtname}</td>
					</c:if>

					<td>
						<div class="question-content">
							<c:if test="${mode ne 'branch' and question.iscon == 1}">
								<a href="javascript:void(0);" class="branch-link" onclick="openBranchDialog('${question.qid}')">【调整分支顺序】</a>
							</c:if>
								${question.content}
						</div>
					</td>

					<td class="op-cell">
						<a href="javascript:void(0);" class="op-btn" onclick="moveOrder(this,'up')">上移</a>
						<a href="javascript:void(0);" class="op-btn" onclick="moveOrder(this,'down')">下移</a>
					</td>
				</tr>
			</c:forEach>
		</table>
	</form>

	<div class="bottom-bar">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
	</div>
</div>

<script type="text/javascript">
	var moving = false;

	function lockPage(flag){
		moving = flag;
		if(flag){
			$("#mainTable .op-btn").addClass("op-disabled");
		}else{
			$("#mainTable .op-btn").removeClass("op-disabled");
		}
	}

	function moveOrder(elt, direction){
		if(moving){
			toastr.warning("上一个操作还没完成，请稍后再点");
			return;
		}

		var mode = $("#mode").val();
		var $tr = $(elt).closest("tr");
		var $targetTr = direction == "up" ? $tr.prev() : $tr.next();

		if($targetTr.length == 0){
			if(mode == "branch"){
				toastr.warning(direction == "up" ? "已经是第一个分支" : "已经是最后一个分支");
			}else{
				toastr.warning(direction == "up" ? "已经是第一行" : "已经是最后一行");
			}
			return;
		}

		if(mode == "question"){
			var qtid = String($tr.data("qtid"));
			var cid = String($tr.data("cid"));
			var targetQtid = String($targetTr.data("qtid"));
			var targetCid = String($targetTr.data("cid"));

			if(qtid != targetQtid){
				toastr.warning("不能跨题型调整试题顺序！");
				return;
			}
			if(cid != targetCid){
				toastr.warning("同一个题型下，不能跨课程调整试题顺序！");
				return;
			}
		}

		lockPage(true);

		$.ajax({
			url: "${pageContext.request.contextPath}/paper/movePaperQuestionOrder",
			type: "POST",
			dataType: "text",
			data: {
				ei_id: $("#ei_id").val(),
				qid: $tr.data("qid"),
				ismain: $tr.data("ismain"),
				mqid: $("#mqid").val(),
				mode: mode,
				direction: direction
			},
			success: function(data){
				if(data == "success"){
					if(direction == "up"){
						$targetTr.before($tr);
					}else{
						$targetTr.after($tr);
					}
					toastr.success("已调整");
				}else{
					toastr.error(data);
				}
			},
			error: function(){
				toastr.error("请求失败");
			},
			complete: function(){
				lockPage(false);
			}
		});
	}

	function openBranchDialog(mqid){
		openIframeDialog({
			url: "${pageContext.request.contextPath}/paper/adjustQuestionOrder?mode=branch&mqid=" + mqid + "&ei_id=" + $("#ei_id").val(),
			fit: true,
			title: "调整串题分支顺序"
		}, 1);
	}
</script>