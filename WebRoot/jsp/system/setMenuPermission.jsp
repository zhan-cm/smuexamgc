<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/css/bootstrap.min.css">
<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
	.table th,
	.table td {
		vertical-align: middle !important;
		font-size: 14px;
	}

	body {
		padding: 0;
		margin: 0;
	}

	ul li {
		list-style: none;
		float: left;
		padding-left: 75px;
	}

	.page-toolbar {
		padding: 12px 16px;
	}

	.role-label {
		margin-right: 16px;
		white-space: nowrap;
	}

	.action-link {
		cursor: pointer;
		text-decoration: none;
	}

	.move-icon {
		height: 15px;
	}
</style>

<div class="page-toolbar">
	<button type="button" class="btn btn-primary btn-sm" onclick="saveAll()">保存全部修改</button>
	<button type="button" class="btn btn-secondary btn-sm ms-3" onclick="backTo()">返回</button>
	<button type="button" class="btn btn-outline-secondary btn-sm ms-3" onclick="window.location.reload()">刷新</button>
</div>

<div class="container-fluid">
	<div class="row">
		<div class="col-12">
			<table class="table table-bordered text-center align-middle">
				<tr>
					<th class="text-center col-1">菜单级别</th>
					<th class="text-center col-2">菜单名称</th>
					<th class="text-center col-1">父菜单</th>
					<th class="text-center col-1">全选</th>
					<th class="text-center col-5">角色</th>
					<th class="text-center col-1">操作</th>
					<th class="text-center col-2">调整顺序</th>
				</tr>
				<tr>
					<td>/</td>
					<td>全选</td>
					<td></td>
					<td>全选</td>
					<td class="text-start">
						<c:forEach var="role" items="${mlist[0].role}">
							<input type="checkbox" class="selectVertical" value="${role.ID}" id="selectVertical_${role.ID}">
							<label class="role-label" for="selectVertical_${role.ID}">${role.CNAME}</label>
						</c:forEach>
					</td>
					<td>/</td>
					<td>/</td>
				</tr>

				<c:forEach var="menu" items="${mlist}" varStatus="status">
					<tr>
						<td>
							<input type="hidden" class="mid" value="${menu.id}"/>
							<c:if test="${menu.mlevel==1}">
								一级菜单
							</c:if>
							<c:if test="${menu.mlevel==2}">
								二级菜单
							</c:if>
						</td>
						<td>${menu.name}</td>
						<td>${menu.pname}</td>
						<td>
							<input type="checkbox" name="selectAll"/>
						</td>
						<td class="text-start">
							<c:forEach var="role" items="${menu.role}">
								<c:choose>
									<c:when test="${role.exist==1}">
										<input
												type="checkbox"
												class="pid_${role.ID}_${menu.parentid}"
												name="role_${menu.id}"
												value="${role.ID},${menu.mlevel},${menu.parentid},${menu.id}"
												id="pidid_${role.ID}_${menu.parentid}_${menu.id}"
												checked="checked"
										/>
										<label class="role-label" for="pidid_${role.ID}_${menu.parentid}_${menu.id}">${role.CNAME}</label>
									</c:when>
									<c:otherwise>
										<input
												type="checkbox"
												class="pid_${role.ID}_${menu.parentid}"
												name="role_${menu.id}"
												value="${role.ID},${menu.mlevel},${menu.parentid},${menu.id}"
												id="pidid_${role.ID}_${menu.parentid}_${menu.id}"
										/>
										<label class="role-label" for="pidid_${role.ID}_${menu.parentid}_${menu.id}">${role.CNAME}</label>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</td>
						<td>
							<a href="javascript:void(0);" class="action-link" onclick="save('${menu.id}')">修改</a>
						</td>
						<td>
                            <span onclick="moveMenu(this,'up');" style="cursor: pointer;" title="上移" aria-hidden="true">
                                <img class="move-icon" src="${pageContext.request.contextPath}/styles/images/1180466.gif"/>
                            </span>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<span onclick="moveMenu(this,'down');" style="cursor: pointer;" title="下移" aria-hidden="true">
                                <img class="move-icon" src="${pageContext.request.contextPath}/styles/images/1180465.gif"/>
                            </span>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</div>

<div class="modal fade" id="info" tabindex="-1" aria-labelledby="TipsLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="TipsLabel">提示</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
			</div>
			<div class="modal-body" id="msg"></div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-bs-dismiss="modal">确定</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	function showInfoModal(message) {
		$("#msg").html(message);
		const modalElement = document.getElementById("info");
		const modalInstance = bootstrap.Modal.getOrCreateInstance(modalElement, {
			keyboard: true
		});
		modalInstance.show();
	}

	$(function () {
		$("input[name='selectAll']").on("click", function () {
			const flag = $(this).prop("checked");
			$(this).parent().next().find("input").each(function () {
				$(this).prop("checked", flag);
			});
		});

		$("input.selectVertical").on("click", function () {
			const roleId = $(this).val();
			$("input[class^='pid_" + roleId + "']").prop("checked", $(this).is(":checked"));
		});

		$("input[type='checkbox']").on("click", function () {
			const value = $(this).val();

			if (!value || value.indexOf(",") === -1) {
				return;
			}

			const data = value.split(",");
			const rid = data[0];
			const mlevel = data[1];
			const pid = data[2];
			const mid = data[3];

			if (mlevel == 1) {
				if (!$(this).prop("checked")) {
					$(".pid_" + rid + "_" + mid).prop("checked", false);
				}
			} else {
				if ($(this).prop("checked")) {
					$("input[name='role_" + pid + "'][class='pid_" + rid + "_0']").prop("checked", true);
				}
			}
		});
	});

	function save(mid) {
		const res = [];

		$("input[name='role_" + mid + "']:checked").each(function () {
			res.push($(this).val().split(",")[0]);
		});

		$.ajax({
			url: "${pageContext.request.contextPath}/system/saveMenuPermission",
			async: true,
			type: "POST",
			traditional: true,
			data: {
				"mid": mid,
				"rids": res
			},
			success: function (data) {
				if (data == "success") {
					showInfoModal("操作成功！");
				} else {
					showInfoModal(data);
				}
			}
		});
	}

	function saveAll() {
		const dataList = [];

		$("input[type='checkbox']").each(function () {
			const value = $(this).val();

			if ($(this).prop("checked")) {
				if (value && value.indexOf(",") != -1) {
					dataList.push(value);
				}
			}
		});

		if (dataList.length > 0) {
			$.ajax({
				url: "${pageContext.request.contextPath}/system/saveAllMenuPermission",
				async: true,
				type: "POST",
				traditional: true,
				data: {
					"dataList": dataList
				},
				success: function (data) {
					if (data == "success") {
						showInfoModal("操作成功！");
					} else {
						showInfoModal(data);
					}
				}
			});
		} else {
			showInfoModal("教师菜单设置不可为空！");
			return;
		}
	}

	function backTo() {
		window.location.href = "${pageContext.request.contextPath}/system/params";
	}

	function moveMenu(elt, direction) {
		const objParentTR = $(elt).closest("tr");
		const mid = objParentTR.find(".mid").val();

		if (direction === "up") {
			const prevTR = objParentTR.prev();

			if (prevTR.length === 0) {
				showInfoModal("已经是第一行");
				return;
			}

			$.ajax({
				url: "${pageContext.request.contextPath}/system/saveMenuOrder",
				async: true,
				type: "POST",
				traditional: true,
				data: {
					"mid": mid,
					"direction": "up"
				},
				success: function (data) {
					if (data == "success") {
						prevTR.insertAfter(objParentTR);
					} else {
						showInfoModal(data);
					}
				}
			});
			return;
		}

		if (direction === "down") {
			const nextTR = objParentTR.next();

			if (nextTR.length === 0) {
				showInfoModal("已经是最后一行");
				return;
			}

			$.ajax({
				url: "${pageContext.request.contextPath}/system/saveMenuOrder",
				async: true,
				type: "POST",
				traditional: true,
				data: {
					"mid": mid,
					"direction": "down"
				},
				success: function (data) {
					if (data == "success") {
						nextTR.insertBefore(objParentTR);
					} else {
						showInfoModal(data);
					}
				}
			});
		}
	}
</script>