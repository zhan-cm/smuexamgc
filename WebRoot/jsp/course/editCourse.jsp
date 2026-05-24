<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="../commons/taglibs.jsp" %>
<%@ include file="../commons/styles.txt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/toastr.min.css">

<style>
	tr {
		line-height: 20px;
	}

	td {
		font-size: 12px;
	}

	.courseTable {
		border-spacing: 0;
		border-collapse: collapse;
		border-radius: 8px;
		width: 100%;
	}

	.courseTable td,
	th {
		padding: 5px;
		line-height: 1.2;
		vertical-align: middle;
		border-bottom: 1px solid #ddd;
		border-radius: 8px;
	}

	.courseTable input[type="checkbox"],
	.courseTable input[type="radio"] {
		margin-right: 3px;
		margin-bottom: 7px;
		vertical-align: middle;
	}

	.courseTable input[type="text"],
	.courseTable input[type="password"],
	.courseTable input[type="email"],
	.courseTable textarea,
	.courseTable select {
		border: 1px solid #ddd;
		background: #FBFBFB;
		width: 200px;
		outline: 0;
		-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
		box-shadow: inset 0px 1px 6px #ECF3F5;
		font: 200 12px/25px Arial, Helvetica, sans-serif;
		margin: 2px;
		border-radius: 4px;
		padding: 2px 4px;
	}

	.checkblock {
		border: 1px solid #ddd;
		height: 108px;
		width: 220px;
		border-radius: 4px;
		padding: 2px 4px;
		-webkit-box-shadow: inset 0px 1px 6px #ECF3F5;
		box-shadow: inset 0px 1px 6px #ECF3F5;
		overflow-y: scroll;
	}

	.theme_table {
		text-align: center;
	}

	.theme_table input[name="theme"] {
		width: 400px;
	}

	.themeDiv {
		height: 300px;
		overflow: auto
	}

	.themeDiv .list-group-item {
		font-size: 13px;
		padding-top: calc(0.5rem + 1px);
		padding-bottom: calc(0.5rem + 1px);
	}

	.courseTable .specialtySearchInput {
		width: 88px!important;
	}

	.courseTable .specialtySearchCurrent {
		background-color: #fff3cd;
	}
</style>
<div>
	<form id="editCourseForm" method="post">
		<input type="hidden" name="c_id" id="c_id" value="${c_id}" />
		<c:forEach var="course" items="${courseInfo}">
			<input type="hidden" name="name_c" id="name_c" value="${course.name_c}" />
			<table class="courseTable">
				<tr>
					<td class="text-end" style="width:185px;">*课程中文名：</td>
					<td class="text-start"><input type="text" name="name_c1" value="${course.name_c}" /></td>
					<td class="text-end">课程英文名：</td>
					<td class="text-start"><input type="text" name="name_e" value="${course.name_e}" /></td>
					<td class="text-end">课程简称：</td>
					<td class="text-start"><input type="text" name="shortname" value="${course.shortname}" />
					</td>
				</tr>
				<tr>
					<td class="text-end" style="width:185px;">课程代码：</td>
					<td class="text-start"><input type="text" name="code" value="${course.code}" /></td>
					<td class="text-end">授课单位：</td>
					<td class="text-start">
						<shiro:hasAnyRoles name="administrator, dean">
							<select id="unit" name="unitId" style="padding:5px 0;">
								<c:forEach var="unit" items="${unitList}">
									<c:choose>
										<c:when test="${unit.ID == course.unitid}">
											<option value="${unit.ID}" selected="selected">${unit.NAME}
											</option>
										</c:when>
										<c:otherwise>
											<option value="${unit.ID}">${unit.NAME}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</shiro:hasAnyRoles>
						<shiro:hasAnyRoles name="teacher, secretary, director, teachingoffice">
							${course.unitname}
							<input type="hidden" name="unitId"
								   value="${course.unitid}" />
						</shiro:hasAnyRoles>
					</td>
					<td class="text-end">所属科室：</td>
					<td class="text-start">
						<shiro:hasAnyRoles name="administrator, dean">
							<select id="dept" name="deptId" style="padding:5px 0;">

							</select>
							<input type="hidden" id="deptId" value="${course.deptid}" />
						</shiro:hasAnyRoles>
						<shiro:hasAnyRoles name="teacher, secretary, director, teachingoffice">

							${course.deptname}
							<input type="hidden" name="deptId" value="${course.deptid}" />
						</shiro:hasAnyRoles>
					</td>
				</tr>
				<tr>
					<td class="text-end" style="width:185px;">联系人：</td>
					<td class="text-start"><input type="text" name="contact" value="${course.contact}" /></td>
					<td class="text-end">联系电话：</td>
					<td class="text-start"><input type="text" name="tel" value="${course.tel}"
												  class="easyui-validatebox" /></td>
					<td class="text-end">最大学时数：</td>
					<td class="text-start"><input type="text" name="period" value="${course.period}"
												  class="easyui-validatebox" /></td>
				</tr>
				<tr>
					<td class="text-end">是否开放：</td>
					<c:choose>
						<c:when test="${course.open == 0}">
							<td class="text-start"><label><input type="radio" name="open" value="1" />开放给该课程适用专业考生自由练习</label></td>
							<td class="text-start"><label><input type="radio" name="open" value="0" checked="checked" />不开放给考生自由练习</label></td>
						</c:when>
						<c:otherwise>
							<td class="text-start"><label><input type="radio" name="open" value="1" checked="checked" />开放给该课程适用专业考生自由练习</label></td>
							<td class="text-start"><label><input type="radio" name="open" value="0" />不开放给考生自由练习</label></td>
						</c:otherwise>
					</c:choose>
					<td colspan="3"></td>
				</tr>
			</table>
		</c:forEach>
		<table class="courseTable">
			<tr>
				<td class="text-end" style="width:100px;">
					<label><input type="checkbox" id="selectArrangement"
								  class="checkAll" />&nbsp;*适应层次：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addArrangement()">新增</a><br><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="arrangementList">
						<c:forEach var="arrangement" items="${courseInfo[0].arrangementList}">
							<c:choose>
								<c:when test="${empty arrangement.use}">
									<c:choose>
										<c:when test="${arrangement.ID==4}">
											<label><input type="checkbox" name="arrangement"
														  value="${arrangement.ID}" checked="checked"
														  onclick="return false" />${arrangement.NAME}</label><br>
										</c:when>
										<c:otherwise>
											<label><input type="checkbox" checked="checked"
														  name="arrangement"
														  value="${arrangement.ID}" /><span>${arrangement.NAME}</span></label><br>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="arrangement"
												  value="${arrangement.ID}" /><span>${arrangement.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*包含题型：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addQuestionType()">新增</a><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   onclick="explainQuestionType()">题型说明</a><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="QTList">
						<c:forEach var="questionType" items="${courseInfo[0].questionTypeList}">
							<c:choose>
								<c:when test="${empty questionType.use}">
									<label><input type="checkbox" checked="checked" name="questionType"
												  value="${questionType.ID}" /><span>
											${questionType.NAME}
									</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="questionType"
												  value="${questionType.ID}" /><span>
											${questionType.NAME}
									</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;考试类别：</label><br><br>

				</td>
				<td class="text-start">
					<div class="checkblock" id="examTypeList">
						<c:forEach var="examType" items="${courseInfo[0].examTypeList}">
							<c:choose>
								<c:when test="${empty examType.use}">
									<label><input type="checkbox" checked="checked" name="examType"
												  value="${examType.ID}" /><span>${examType.NAME}</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="examType"
												  value="${examType.ID}" /><span>${examType.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*适用专业：</label><br><br>
					<input type="text" id="specialtyKeyword" class="specialtySearchInput" placeholder="输入搜索专业" />
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="searchSpecialty('prev')">↑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="searchSpecialty('next')">↓</a>
				</td>
				<td class="text-start">
					<div class="checkblock" id="specialtyList">
						<c:forEach var="specialty" items="${courseInfo[0].specialtyList}">
							<c:choose>
								<c:when test="${empty specialty.use}">
									<label><input type="checkbox" checked="checked" name="specialty"
												  value="${specialty.ID}" /><span>${specialty.NAME}</span>
										<span style="font-size: 11px;color: red;">（${specialty.UNAME}）</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="specialty"
												  value="${specialty.ID}" /><span>${specialty.NAME}</span>
										<span style="font-size: 11px;color: red;">（${specialty.UNAME}）</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
			</tr>
			<tr>
				<td class="text-end" style="width:100px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*难度：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addDifficulty()">新增</a><br><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="difficultyList">
						<c:forEach var="difficulty" items="${courseInfo[0].difficultyList}">
							<c:choose>
								<c:when test="${empty difficulty.use}">
									<label><input type="checkbox" checked="checked" name="difficulty"
												  value="${difficulty.ID}" /><span>${difficulty.NAME}</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="difficulty"
												  value="${difficulty.ID}" /><span>${difficulty.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*知识点类别：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addKnowledge()">新增</a><br><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="knowledgeList">
						<c:forEach var="knowledge" items="${courseInfo[0].knowledgeList}">
							<c:choose>
								<c:when test="${empty knowledge.use}">
									<label><input type="checkbox" checked="checked" name="knowledge"
												  value="${knowledge.ID}" /><span>${knowledge.NAME}</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="knowledge"
												  value="${knowledge.ID}" /><span>${knowledge.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*认知类别：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addCognition()">新增</a><br><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="cognitionList">
						<c:forEach var="cognition" items="${courseInfo[0].cognitionList}">
							<c:choose>
								<c:when test="${empty cognition.use}">
									<label><input type="checkbox" checked="checked" name="cognition"
												  value="${cognition.ID}" /><span>${cognition.NAME}</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="cognition"
												  value="${cognition.ID}" /><span>${cognition.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
				<td class="text-end" style="width:120px;">
					<label><input type="checkbox" class="checkAll" />&nbsp;*题源：</label><br><br>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   data-options="iconCls:'icon-add'" onclick="addSource()">新增</a><br><br>
				</td>
				<td class="text-start">
					<div class="checkblock" id="sourceList">
						<c:forEach var="source" items="${courseInfo[0].sourceList}">
							<c:choose>
								<c:when test="${empty source.use}">
									<label><input type="checkbox" checked="checked" name="source"
												  value="${source.ID}" /><span>${source.NAME}</span></label><br>
								</c:when>
								<c:otherwise>
									<label><input type="checkbox" name="source"
												  value="${source.ID}" /><span>${source.NAME}</span></label><br>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</td>
			</tr>
		</table>
		<table class="courseTable" style="margin-bottom:30px;">
			<tr>
				<td class="text-center">* 一级主题词</td>
				<td class="text-center">二级主题词</td>
				<td class="text-center">三级主题词</td>
			</tr>
			<tr class="align-top">
				<td class="border-start col-4">
					<div class="list-group themeDiv" id="theme0List">
						<c:forEach var="theme" items="${courseInfo[0].themeList}" varStatus="status">
							<a href="javascript:void(0)"
							   class="sortableOpt list-group-item list-group-item-action theme1"
							   data-id="${theme.ID}" id="${theme.ID}"><input type="hidden"
																			 value="${theme.TORDER}" />${theme.NAME}</a>
						</c:forEach>
					</div>
				</td>
				<td class="border-start col-4">
					<div class="list-group themeDiv" id="theme0List2">
					</div>
				</td>
				<td class="border-start border-end col-4">
					<div class="list-group themeDiv" id="theme0List3">
					</div>
				</td>
			</tr>
			<tr>
				<td class="text-center">
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addTheme(1)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   onclick="editTheme(1)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="delTheme(1)">删除</a>
				</td>
				<td style="text-align: center;">
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addTheme(2)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   onclick="editTheme(2)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="delTheme(2)">删除</a>
				</td>
				<td style="text-align: center;">
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="addTheme(3)">增加</a>
					<a class="easyui-linkbutton" href="javascript:void(0);"
					   onclick="editTheme(3)">编辑</a>
					<a class="easyui-linkbutton" href="javascript:void(0);" onclick="delTheme(3)">删除</a>
				</td>
			</tr>
		</table>
	</form>
</div>
<div style="width: 100%; height: 40px; text-align: center;">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0);"
	   onclick="updateCourse()">保存</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0);"
	   onclick="importTheme()">导入主题词</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-pencil'"
	   href="${pageContext.request.contextPath}/course/exportTheme?cid=${c_id}">导出主题词</a>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-delete'" href="javascript:void(0);"
	   onclick="deleteAllTheme()">删除所有主题词</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);"
	   onclick="cancelEasyUiFrame(0)">返回课程列表</a>
</div>

<div id="win"></div>
<div id="importTheme"></div>
<div id="addTheme">

</div>
<script src="${pageContext.request.contextPath}/styles/js/Sortable/1.15.0/Sortable.min.js"></script>
<script src="${pageContext.request.contextPath}/styles/bootstrap/v5.3.0/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	const c_id = $("#c_id").val();

	$(document).ready(function () {
		const uId = $("#unit").val();
		if (uId) {
			getDept(uId);
		}

		initPracticeJxbEntry();
		$('#unit').select2();
		$('#dept').select2();
		const themeList = document.getElementById("theme0List");
		const themeList2 = document.getElementById("theme0List2");
		const themeList3 = document.getElementById("theme0List3");

		const theme1sortable = new Sortable(themeList, {
			handle: ".sortableOpt",
			animation: 150,
			group: {
				name: "theme1",
				pull: "clone"
			},
			direction: "vertical",
			dataIdAttr: "data-id",
			store: {
				get: function () {
				},
				set: function (theme1sortable) {
					const order = theme1sortable.toArray();
					sessionStorage.setItem("theme1order", order);
					const data = { data: order, cid: c_id, level: 1 };
					$.ajax({
						contentType: "application/json; charset=utf-8",
						url: "${pageContext.request.contextPath}/course/setThemeOrder",
						async: false,
						type: "POST",
						data: JSON.stringify(data),
						success: function () {
							toastr.success("主题词排序成功！");
						}
					});
				}
			},
			onStart: function (evt) {
				evt.oldIndex;
				console.log(evt.oldIndex);
			},
			onEnd: function () {
			}
		});

		const theme2sortable = new Sortable(themeList2, {
			handle: ".sortableOpt",
			animation: 150,
			group: {
				name: "theme2",
				pull: "clone"
			},
			direction: "vertical",
			dataIdAttr: "data-id",
			store: {
				get: function () {
				},
				set: function (theme2sortable) {
					const order = theme2sortable.toArray();
					sessionStorage.setItem("theme2order", order);
					const data = { data: order, cid: c_id, level: 2 };
					$.ajax({
						contentType: "application/json; charset=utf-8",
						url: "${pageContext.request.contextPath}/course/setThemeOrder",
						async: false,
						type: "POST",
						data: JSON.stringify(data),
						success: function () {
							toastr.success("主题词排序成功！");
						}
					});
				}
			},
			onStart: function (evt) {
				evt.oldIndex;
				console.log(evt.oldIndex);
			},
			onEnd: function () {
			}
		});

		const theme3sortable = new Sortable(themeList3, {
			handle: ".sortableOpt",
			animation: 150,
			group: {
				name: "theme3",
				pull: "clone"
			},
			direction: "vertical",
			dataIdAttr: "data-id",
			store: {
				get: function () {
				},
				set: function (theme3sortable) {
					const order = theme3sortable.toArray();
					sessionStorage.setItem("theme3order", order);
					const data = { data: order, cid: c_id, level: 3 };
					$.ajax({
						contentType: "application/json; charset=utf-8",
						url: "${pageContext.request.contextPath}/course/setThemeOrder",
						async: false,
						type: "POST",
						data: JSON.stringify(data),
						success: function () {
							toastr.success("主题词排序成功！");
						}
					});
				}
			},
			onStart: function (evt) {
				evt.oldIndex;
				console.log(evt.oldIndex);
			},
			onEnd: function () {
			}
		});

		bindThemeClick();
		bindSpecialtySearch();
	});

	function themeClick(id) {
		const getClickItem = $("#" + id);
		getClickItem.addClass("active").siblings().removeClass("active");
		const themeId = getClickItem.parent().attr("id");
		if (themeId == "theme0List2") {
			$("#theme0List3").empty();
			const themeId = getClickItem.attr("id");
			const themeVal = getClickItem.children("input").val();
			getThemeList(3, themeId);
		} else if (themeId == "theme0List3") {
		}
	}

	function back() {
		const parent = $("#ifmdlg");
		$(parent).dialog("close");
	}

	function addQuestionType() {
		let winStr = '<form id="QTForm" method="post"><table style="width: 100%;"><tr><td style="text-align: right;">题目类型：</td>'
				+ '<td style="text-align: left;"><input type="text" name="qt_name" style="width:220px;" class="easyui-validatebox" data-options="required:true"/></td>'
				+ '<tr><td style="text-align: right;">英文类型：</td><td style="text-align: left;"><input type="text" name="e_qt_name" style="width:220px;" class="easyui-validatebox" data-options="required:true"/></td>'
				+ '</tr><tr><td style="text-align: right;">是否串题：</td><td style="text-align: left;"><select style="width:220px;" name="qt_iscon" id="qt_iscon">'
				+ '<option value="0">非串题</option><option value="1">串题</option></select>'
				+ '</tr><tr><td style="text-align: right;">选项得分设置：</td><td style="text-align: left;"><select style="width:220px;" name="qt_xxdf" id="qt_xxdf">'
				+ '<option value="0">无特殊设置</option><option value="2">多选题少选得一半分，错选漏选不得分</option></select>'
				+ '</tr><tr><td style="text-align: right;">多媒体播放设定：</td><td style="text-align: left;"><select style="width:220px;" name="qt_mediaSet" id="qt_mediaSet">'
				+ '<option value="0">无特殊设置</option><option value="1">不可重播、加速、拖动</option></select>'
				+ '</td></tr><tr><td style="text-align: right;">按答案分类：</td><td style="text-align: left;">'
				+ '<select style="width:220px;" name="qt_answertypeid" id="qt_answertypeid">';

		const atlist = getAnswerType();
		for (let i = 0; i < atlist.length; i++) {
			winStr += '<option value="' + atlist[i].ID + '">' + atlist[i].NAME + '</option>';
		}

		winStr += '</select></td></tr>'
				+ '<tr><td style="text-align: right;">题目说明：</td><td style="text-align: left;">'
				+ '<textarea name="qt_desc" style="width:220px;height:100px;"></textarea></td></tr>'
				+ '<tr><td style="text-align: right;">英文说明：</td><td style="text-align: left;">'
				+ '<textarea name="e_qt_desc" style="width:220px;height:100px;"></textarea></td></tr></table>'
				+ '<div style="width: 100%; text-align: center; margin-top: 10px;">'
				+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="submitQTForm()">'
				+ '<span class="l-btn-left"><span class="l-btn-text">确认</span></span></a> '
				+ '<a class="easyui-linkbutton l-btn" href="javascript:void(0);" onclick="$(\'#win\').window(\'close\')">'
				+ '<span class="l-btn-left"><span class="l-btn-text">取消</span></span></a></div></form>';

		const obj = $(winStr);
		$("#win").html("");
		obj.appendTo("#win");
		$("#win").window({
			width: 440,
			height: 460,
			modal: true,
			title: "添加题型",
			collapsible: false,
			minimizable: false,
			maximizable: false
		});
	}

	function valQT() {
		let res = true;
		$.each($("#QTList").find("label"), function (i, item) {
			const val = $.trim($("input[name=qt_name]").val());
			if (val == $(item).text()) {
				toastr.warning("题型重复，请重新添加");
				res = false;
				return false;
			} else if (val == null || val == "") {
				toastr.warning("题型为空，请重新添加");
				res = false;
				return false;
			}
		});
		return res;
	}

	$("#theme1List").change(function () {
		$("#theme3List").empty();
		const options = $("#theme1List option:selected");
		getThemeList(2, options[0].value);
		const theme2val = $("#theme2List").find("option:first").val();
		if (!theme2val != null && theme2val != undefined) {
			getThemeList(3, theme2val);
		}
	});

	$("#theme2List").change(function () {
		const options = $("#theme2List option:selected");
		getThemeList(3, options[0].value);
	});

	$("#unit").change(function () {
		const uId = $(this).val();
		getDept(uId);
	});

	function initPracticeJxbEntry() {
		const $row = $("#practiceJxbActionRow");
		if ($row.length === 0) {
			return;
		}
		$("input[name='open']").on("change", togglePracticeJxbEntry);
		togglePracticeJxbEntry();
	}

	function togglePracticeJxbEntry() {
		const $row = $("#practiceJxbActionRow");
		if ($row.length === 0) {
			return;
		}
		const openVal = $("input[name='open']:checked").val();
		if (openVal === "1") {
			$row.show();
		} else {
			$row.hide();
		}
	}
	function getDept(u_id) {
		$.ajax({
			url: "${pageContext.request.contextPath}/course/getDeptList",
			async: false,
			type: "POST",
			data: { u_id: u_id },
			success: function (data) {
				$("#dept").html("");
				const deptId = $("#deptId").val();
				let str = "";
				$.each(eval(data), function (i, item) {
					if (item.ID == deptId) {
						str += '<option selected="selected" value="' + item.ID + '">' + item.NAME + '</option>';
					} else {
						str += '<option value="' + item.ID + '">' + item.NAME + '</option>';
					}
				});
				$("#dept").append(str);
			}
		});
	}

	$(".checkAll").click(function () {
		const index = $(".checkAll").index(this);
		const checkAim = ".checkblock:eq(" + index + ")";
		if ($(this).is(":checked")) {
			$(checkAim).find("input").prop("checked", true);
		} else {
			$(checkAim).find("input").prop("checked", false);
		}
	});

	function addTheme(level) {
		sessionStorage.theme_level = level;
		let thParent = "-1";
		const levelInt = parseInt(level, 10);
		let th = "";
		if (levelInt > 1) {
			switch (levelInt) {
				case 2:
					th = "#theme0List";
					break;
				case 3:
					th = "#theme0List2";
					break;
				default:
					break;
			}
			thParent = $(th).children("a.active").attr("id");
			if (thParent == null || thParent == undefined || thParent == "") {
				$.messager.alert(" ", "上级主题词不能为空，请在上级选择一个主题词", "info");
				return;
			}
		}
		sessionStorage.thParent = thParent;

		let winStr = '<form id="themeForm" method="post" action="">'
				+ '<table class="courseTable theme_table">'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="text" name="theme"/></td></tr>'
				+ '<tr><td><input type="button" id="toAddTheme" value="新增主题词"/></td></tr></table></form>';

		const obj = $(winStr);
		$("#addTheme").html("");
		obj.appendTo("#addTheme");
		$("#addTheme").window({
			width: 500,
			height: 800,
			modal: true,
			title: "新增主题词",
			collapsible: false,
			minimizable: false,
			maximizable: false
		});
		$("#toAddTheme").click(function () {
			let resStr = "";
			$("input[name='theme']").each(function () {
				if ($(this).val().trim() != "") {
					resStr += $(this).val().trim() + ",";
				}
			});
			resStr = resStr.substring(0, resStr.length - 1);
			if (resStr == "") {
				toastr.warning("请输入至少一个主题词！");
				return;
			}
			$.ajax({
				url: "${pageContext.request.contextPath}/course/addTheme",
				async: false,
				type: "POST",
				data: { th_name: resStr, th_level: sessionStorage.theme_level, th_pid: sessionStorage.thParent, c_id: c_id, flag: "edit" },
				success: function (data) {
					if (data == -1) {
						toastr.error("添加失败");
					} else if (data == 0) {
						toastr.warning("新增的主题词重复，导入0个主题词");
					} else {
						toastr.success("已新增" + data + "个主题词");
					}
					$("input[name='theme']").val("");
					$("#addTheme").window("close");
					getThemeList(sessionStorage.theme_level, sessionStorage.thParent);
				}
			});
		});
	}

	function delTheme(level) {
		let th = "#theme0List";
		if (level > 1) {
			th = th + level;
		}

		let delVal = "";
		let thText = "";
		$(th).find("a").each(function () {
			if ($(this).hasClass("active")) {
				delVal = $(this).attr("id");
				thText = $(this).text();
			}
		});

		if (delVal === "") {
			toastr.warning("请选中要删除的主题词");
			return;
		}

		checkThemeHasQuestion(delVal, level).done(function (data) {
			if (data) {
				$.messager.alert(" ", "该主题词或其子主题词已被课程或者试卷使用，不可删除", "info");
				return;
			}

			$.messager.confirm("提示", "是否要删除所选主题词 " + thText + " ?", function (r) {
				if (r) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/delTheme",
						type: "POST",
						data: {
							c_id: c_id,
							th_id: delVal,
							thText: thText,
							flag: "edit"
						},
						success: function (data) {
							if (data > 0) {
								toastr.success("所删除的主题词共 " + data + " 条!");
							}
							getThemeList(level, getThemeParent(level));
							if (level === 1) {
								getThemeList(level + 1, getThemeParent(level));
								getThemeList(level + 2, getThemeParent(level));
							}
							if (level === 2) {
								getThemeList(level + 1, getThemeParent(level));
							}
						}
					});
				}
			});
		});
	}

	function checkThemeHasQuestion(thid, level) {
		return $.ajax({
			url: "${pageContext.request.contextPath}/course/checkThemeHasQuestion",
			type: "POST",
			data: { cid: c_id, thid: thid, tlevel: level }
		});
	}

	function bindThemeClick() {
		$("#theme0List a").off("click").click(function () {
			$(this).addClass("active").siblings().removeClass("active");
			$("#theme0List2").empty();
			$("#theme0List3").empty();
			const themeId = $(this).attr("id");
			getThemeList(2, themeId);
			const theme2id = $("#theme0List2").find("a").attr("id");
			if (theme2id != null && theme2id != undefined && theme2id !== "") {
				getThemeList(3, theme2id);
			}
		});
	}

	const specialtySearchState = {
		keyword: "",
		matches: [],
		currentIndex: -1
	};

	function bindSpecialtySearch() {
		$("#specialtyKeyword").off("input").on("input", function () {
			resetSpecialtySearch();
		});
		$("#specialtyKeyword").off("keydown").on("keydown", function (e) {
			if (e.key === "Enter") {
				e.preventDefault();
				searchSpecialty("next");
			}
		});
	}

	function resetSpecialtySearch() {
		specialtySearchState.keyword = "";
		specialtySearchState.matches = [];
		specialtySearchState.currentIndex = -1;
		$("#specialtyList label").removeClass("specialtySearchCurrent");
	}

	function buildSpecialtyMatches(keyword) {
		const normalizedKeyword = keyword.replace(/\s+/g, "").toLowerCase();
		return $("#specialtyList label").filter(function () {
			const text = $(this).text().replace(/\s+/g, "").toLowerCase();
			return text.indexOf(normalizedKeyword) > -1;
		}).toArray();
	}

	function focusSpecialtyMatch(target) {
		const $target = $(target);
		const $container = $("#specialtyList");
		$("#specialtyList label").removeClass("specialtySearchCurrent");
		$target.addClass("specialtySearchCurrent");
		const scrollTop = $container.scrollTop() + $target.position().top - ($container.innerHeight() / 2) + ($target.outerHeight() / 2);
		$container.stop(true).animate({ scrollTop: Math.max(0, scrollTop) }, 150);
	}

	function searchSpecialty(direction) {
		const keyword = $.trim($("#specialtyKeyword").val());
		if (keyword === "") {
			toastr.warning("请输入专业关键字");
			return;
		}

		if (specialtySearchState.keyword !== keyword) {
			specialtySearchState.keyword = keyword;
			specialtySearchState.matches = buildSpecialtyMatches(keyword);
			specialtySearchState.currentIndex = -1;
		}

		if (specialtySearchState.matches.length === 0) {
			resetSpecialtySearch();
			$("#specialtyKeyword").val(keyword);
			toastr.warning("未找到匹配的专业");
			return;
		}

		if (direction === "prev") {
			if (specialtySearchState.currentIndex === -1) {
				specialtySearchState.currentIndex = specialtySearchState.matches.length - 1;
			} else if (specialtySearchState.currentIndex === 0) {
				toastr.warning("已经是第一个匹配项");
				return;
			} else {
				specialtySearchState.currentIndex -= 1;
			}
		} else {
			if (specialtySearchState.currentIndex >= specialtySearchState.matches.length - 1) {
				if (specialtySearchState.currentIndex === specialtySearchState.matches.length - 1) {
					toastr.warning("已经是最后一个匹配项");
					return;
				}
				specialtySearchState.currentIndex = 0;
			} else {
				specialtySearchState.currentIndex += 1;
			}
		}

		focusSpecialtyMatch(specialtySearchState.matches[specialtySearchState.currentIndex]);
	}

	function editTheme(level) {
		let th = "#theme0List";
		if (level > 1) {
			th = th + level;
		}

		let updateVal = "";
		let thText = "";
		$(th).find("a").each(function () {
			if ($(this).hasClass("active")) {
				updateVal = $(this).attr("id");
				thText = $(this).text();
			}
		});

		if (updateVal == "") {
			toastr.warning("请选中要编辑的主题词");
			return;
		}
		$.messager.prompt("修改主题词", '主题词 “' + thText + '” 修改为:', function (r) {
			r = r.trim();
			if (updateVal == null || updateVal == undefined || r == "") {
				toastr.warning("编辑的主题词不能为空");
				return;
			}
			if (!valTheme(level, r)) {
				return;
			}
			if (r) {
				$.ajax({
					url: "${pageContext.request.contextPath}/course/updateTheme",
					async: false,
					type: "POST",
					data: { th_name: r, th_id: updateVal },
					success: function () {
						getThemeList(level, getThemeParent(level));
					}
				});
			}
		});
	}

	function getThemeParent(level) {
		let th = "#theme0List";
		if (level == 3) {
			th = th + "2";
		}
		let thParent = -1;
		if (level > 1) {
			$(th).find("a").each(function () {
				if ($(this).hasClass("active")) {
					thParent = $(this).attr("id");
				}
			});
		}
		return thParent;
	}

	function getThemeList(th_level, th_pid) {
		$.ajax({
			url: "${pageContext.request.contextPath}/course/getThemeList",
			async: false,
			type: "POST",
			data: { th_level: th_level, th_pid: th_pid, c_id: c_id },
			success: function (data) {
				let thStr = "";
				if (th_level == 1) {
					thStr = "#theme0List";
				} else {
					thStr = "#theme0List" + th_level;
				}

				$(thStr).html(" ");
				let str = "";
				$.each(eval(data), function (i, item) {
					if (i == 0) {
						str += '<a href="javascript:themeClick(' + item.ID + ')" class="sortableOpt list-group-item list-group-item-action theme1 active" data-id="' + item.ID + '" id="' + item.ID + '"><input type="hidden" value="' + i + '">' + item.NAME + '</a>';
						i++;
					} else {
						str += '<a href="javascript:themeClick(' + item.ID + ')" class="sortableOpt list-group-item list-group-item-action theme1" data-id="' + item.ID + '" id="' + item.ID + '"><input type="hidden" value="' + i + '">' + item.NAME + '</a>';
						i++;
					}
				});
				$(thStr).append(str);
				bindThemeClick();
			}
		});
	}

	function updateCourse() {
		$("#editCourseForm").form("submit", {
			url: "${pageContext.request.contextPath}/course/updateCourse",
			onSubmit: function () {
				if ($("input[name='arrangement']:checked").length == 0) {
					toastr.warning("适应层次不能为空，请勾选！");
					return false;
				}
				if ($("input[name='questionType']:checked").length == 0) {
					toastr.warning("题型不能为空，请勾选！");
					return false;
				}
				if ($("input[name='examType']:checked").length == 0) {
					toastr.warning("考试类别不能为空，请勾选！");
					return false;
				}
				if ($("input[name='specialty']:checked").length == 0) {
					toastr.warning("适用专业不能为空，请勾选！");
					return false;
				}
				if ($("input[name='difficulty']:checked").length == 0) {
					toastr.warning("难度不能为空，请勾选！");
					return false;
				}
				if ($("input[name='knowledge']:checked").length == 0) {
					toastr.warning("知识点分布不能为空，请勾选！");
					return false;
				}
				if ($("input[name='cognition']:checked").length == 0) {
					toastr.warning("认知类别不能为空，请勾选！");
					return false;
				}
				if ($("input[name='source']:checked").length == 0) {
					toastr.warning("题源不能为空，请勾选！");
					return false;
				}
				const $p = $("input[name='period']");
				const v = $p.val().replace(/\s+/g, "");
				$p.val(v);
				if (v !== "" && !/^(?:[1-9]\d*(?:\.\d+)?|0\.\d+)$/.test(v)) {
					toastr.warning("学时数必须为正数，请修改！");
					return false;
				}
				return $("#editCourseForm").form("validate");
			},
			success: function (data) {
				if (data == -1) {
					toastr.warning("课程已经存在，请联系管理员获取课程权限或者修改课程名称。");
					return;
				} else if (data == -2) {
					toastr.warning("课程名参数不能为空，请勾选");
					return;
				} else if (data == 0) {
					toastr.warning("更新失败");
					return;
				} else {
					$.messager.alert("提示", "修改成功！", "修改成功");
					parent.location.reload();
				}
			}
		});
	}

	function getAnswerType() {
		let list = "";
		$.ajax({
			url: "${pageContext.request.contextPath}/course/getAnswerType",
			type: "POST",
			async: false,
			success: function (data) {
				list = data;
			}
		});
		return list;
	}

	function importTheme() {
		const winStr = '<form id="uploadForm" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/course/importTheme?cid=' + $("#c_id").val() + '">'
				+ '<table style="width: 100%; margin-top: 5px;">'
				+ '<tr><td colspan="2" class="text-center" style="color:red;">导入主题词（只接受excel格式）</td></tr>'
				+ '<tr><td>选择文件：</td><td><input type="file" id="uploadFile" name="uploadFile" placeholder=""/></td></tr>'
				+ '<tr><td></td><td><input type="button" id="importFile" name="importFile" value="上传"/></td></tr>'
				+ '<tr><td>下载模板：</td><td><a href="${pageContext.request.contextPath}/course/importThemeMonel">链接</a></td></tr>'
				+ '</table></form>';

		const obj = $(winStr);
		$("#importTheme").html("");
		obj.appendTo("#importTheme");
		$("#importTheme").window({
			width: 440,
			height: 168,
			modal: true,
			title: "导入主题词",
			collapsible: false,
			minimizable: false,
			maximizable: false
		});
		$("#importFile").click(function () {
			const fileName = $("#uploadFile").val();
			if (fileName == "") {
				toastr.warning("请选择附件");
				return;
			}
			if (fileName) {
				const fileType = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length).toLowerCase();
				if (fileType == "xls" || fileType == "xlsx") {
					ajaxUpload(fileName);
				} else {
					toastr.warning("文件格式错误，请选择xls文件进行上传！");
				}
			}
			return false;
		});
	}

	function ajaxUpload(fileName) {
		$("#importTheme").window("close");
		ajaxLoading();
		const formData = new FormData();
		formData.append("file", $("#uploadFile")[0].files[0]);
		formData.append("name", fileName);
		$.ajax({
			url: "${pageContext.request.contextPath}/course/importTheme?cid=" + c_id,
			type: "POST",
			secureuri: false,
			data: formData,
			processData: false,
			contentType: false,
			success: function (data) {
				ajaxLoadEnd();
				if (data.nums == "-2") {
					toastr.error("导入出错，部分主题词未导入，数据异常！");
				} else if (data.nums == "-1") {
					toastr.warning("部分主题词未导入，表格中第" + data.errorRow + "行，有后一级主题词时前一级不能为空！");
				} else {
					toastr.success("共导入" + data.nums + "条主题词");
				}
				getThemeList(1, -1);
			}
		});
	}

	function ajaxLoading() {
		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(document).height() }).appendTo("body");
		$("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候...").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(document).height() - 45) / 2 });
	}

	function ajaxLoadEnd() {
		$("div[class='datagrid-mask']").remove();
		$("div[class='datagrid-mask-msg']").remove();
	}

	function addArrangement() {
		$.messager.prompt("新增适应层次", "", function (r) {
			if (r) {
				const arrangementList = $("#arrangementList").find("label");
				let update = true;
				for (let i = 0; i < arrangementList.length; i++) {
					const val = $(arrangementList[i]).text();
					if (r.replace(/(^\s*)|(\s*$)/g, "") == val) {
						toastr.warning("参数重复，请重新输入！");
						update = false;
						break;
					}
				}
				if (update) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/addArrangement",
						async: false,
						type: "POST",
						data: { arrangement: r },
						success: function (data) {
							const obj = $('<label><input type="checkbox" checked="checked" name="arrangement" value="' + data + '"/>' + r + '</label><br>');
							obj.appendTo("#arrangementList");
						}
					});
				}
			}
		});
	}

	function addDifficulty() {
		$.messager.prompt("新增难度", "", function (r) {
			if (r) {
				const difficultyList = $("#difficultyList").find("label");
				let update = true;
				for (let i = 0; i < difficultyList.length; i++) {
					const val = $(difficultyList[i]).text();
					if (r.replace(/(^\s*)|(\s*$)/g, "") == val) {
						toastr.warning("参数重复，请重新输入！");
						update = false;
						break;
					}
				}
				if (update) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/addDifficulty",
						async: false,
						type: "POST",
						data: { difficulty: r },
						success: function (data) {
							const obj = $('<label><input type="checkbox" checked="checked" name="difficulty" value="' + data + '"/>' + r + '</label><br>');
							obj.appendTo("#difficultyList");
						}
					});
				}
			}
		});
	}

	function addKnowledge() {
		$.messager.prompt("新增知识点", "", function (r) {
			if (r) {
				const knowledgeList = $("#knowledgeList").find("label");
				let update = true;
				for (let i = 0; i < knowledgeList.length; i++) {
					const val = $(knowledgeList[i]).text();
					if (r.replace(/(^\s*)|(\s*$)/g, "") == val) {
						toastr.warning("参数重复，请重新输入！");
						update = false;
						break;
					}
				}
				if (update) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/addKnowledge",
						async: false,
						type: "POST",
						data: { knowledge: r },
						success: function (data) {
							const obj = $('<label><input type="checkbox" checked="checked" name="knowledge" value="' + data + '"/>' + r + '</label><br>');
							obj.appendTo("#knowledgeList");
						}
					});
				}
			}
		});
	}

	function addCognition() {
		$.messager.prompt("新增认知", "", function (r) {
			if (r) {
				const cognitionList = $("#cognitionList").find("label");
				let update = true;
				for (let i = 0; i < cognitionList.length; i++) {
					const val = $(cognitionList[i]).text();
					if (r.replace(/(^\s*)|(\s*$)/g, "") == val) {
						toastr.warning("参数重复，请重新输入！");
						update = false;
						break;
					}
				}
				if (update) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/addCognition",
						async: false,
						type: "POST",
						data: { cognition: r },
						success: function (data) {
							const obj = $('<label><input type="checkbox" checked="checked" name="cognition" value="' + data + '"/>' + r + '</label><br>');
							obj.appendTo("#cognitionList");
						}
					});
				}
			}
		});
	}

	function addSource() {
		$.messager.prompt("新增题源", "", function (r) {
			if (r) {
				const sourceList = $("#sourceList").find("label");
				let update = true;
				for (let i = 0; i < sourceList.length; i++) {
					const val = $(sourceList[i]).text();
					if (r.replace(/(^\s*)|(\s*$)/g, "") == val) {
						toastr.warning("参数重复，请重新输入！");
						update = false;
						break;
					}
				}
				if (update) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/addSource",
						async: false,
						type: "POST",
						data: { source: r },
						success: function (data) {
							const obj = $('<label><input type="checkbox" checked="checked" name="source" value="' + data + '"/>' + r + '</label><br>');
							obj.appendTo("#sourceList");
						}
					});
				}
			}
		});
	}

	function submitQTForm() {
		const qtname = $("input[name=qt_name]").val();
		$("#QTForm").form("submit", {
			url: "${pageContext.request.contextPath}/course/addQuestionType",
			onSubmit: function () {
				return valQT();
			},
			success: function (data) {
				if (data == "-1") {
					toastr.warning("已有一个'" + qtname + "'同名的题型在系统中,操作失败！");
					return;
				}
				const obj = $('<label><input type="checkbox" checked="checked" name="questionType" value="' + data + '"/>' + qtname + '</label><br>');
				obj.appendTo("#QTList");
				$("#win").window("close");
			}
		});
	}

	function valTheme(level, val) {
		let res = true;
		const thStr = "#theme" + level + "List";
		$.each($(thStr).find("option"), function (i, item) {
			if (val == $(item).text()) {
				toastr.warning("主题词重复，请重新操作");
				res = false;
				return false;
			} else if (val == null || val == "") {
				toastr.warning("主题词为空，请重新添加");
				res = false;
				return false;
			}
		});
		return res;
	}

	function explainQuestionType() {
		let checkID = "";
		$("input[name='questionType']:checked").each(function () {
			if (checkID == "") {
				checkID = $(this).val();
			} else {
				checkID += "," + $(this).val();
			}
		});
		openIframeDialog({
			url: "${pageContext.request.contextPath}/course/explainQuestionType?cid=" + $("#c_id").val(),
			fit: true,
			title: "修改题型"
		}, 0);
	}

	function deleteAllTheme() {
		checkThemeHasQuestion("-1", 1).done(function (data) {
			if (data) {
				$.messager.alert(" ", "有主题词已被课程或者试卷使用，不可删除", "info");
				return;
			}

			$.messager.confirm("清空主题词", "是否删除所有主题词？", function (r) {
				if (r) {
					$.ajax({
						url: "${pageContext.request.contextPath}/course/delAllTheme",
						type: "POST",
						data: { cid: c_id },
						success: function () {
							$("#theme0List").html("");
							$("#theme0List2").html("");
							$("#theme0List3").html("");
							toastr.success("删除成功！");
						}
					});
				}
			});
		});
	}

	const sa = $("#selectArrangement");
	sa.click(function () {
		if (sa.attr("checked") === undefined) {
			const a = $("input[name='arrangement']");
			a.not("input:checked").each(function () {
				if ($(this).val() == "4") {
					$(this).attr("checked", true);
				}
			});
		}
	});

	function importThemeMonel() {
		window.location.href = "${pageContext.request.contextPath}/course/importThemeMonel";
	}

</script>