<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>

<style>
	.datagrid-wrap.change:after {
		content: attr(data-content);
	}

	#dlg-toolbar table {
		width: 100%;
		border-collapse: collapse;
	}

	#dlg-toolbar td {
		padding: 2px 0;
	}

	#dlg-toolbar .filter-select {
		width: 190px;
	}

	#dlg-toolbar .select2-container {
		width: 190px !important;
		vertical-align: middle;
	}

	#dlg-toolbar .select2-container--default .select2-selection--single {
		height: 30px;
		border: 1px solid #95B8E7;
		border-radius: 3px;
	}

	#dlg-toolbar .select2-container--default .select2-selection--single .select2-selection__rendered {
		line-height: 28px;
		padding-left: 8px;
	}

	#dlg-toolbar .select2-container--default .select2-selection--single .select2-selection__arrow {
		height: 28px;
	}

	#printTable {
		display: none;
		border-collapse: collapse;
	}

	#printTable th,
	#printTable td {
		border: 1px solid #000;
		padding: 2px;
	}
</style>

<div id="dlg-toolbar" style="height:auto;">
	<table>
		<tr style="vertical-align:middle;">
			<td>
				<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/course/inCourse'">刷新</a>
				<c:if test="${addCoursePermission==1 }">
					<a href="javascript:void(0);" onclick="gotoAddCourse();" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增课程</a>
				</c:if>
				<shiro:hasRole name="administrator">
					<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true" onclick="delSelect();">删除所选课程</a>
				</shiro:hasRole>

				<select id="unitFilter" name="unitFilter" class="filter-select" style="width:190px;"></select>
				<select id="departmentFilter" name="departmentFilter" class="filter-select" style="width:190px;"></select>
				<select id="arrangeFilter" name="arrangeFilter" class="filter-select" style="width:190px;"></select>

				<span style="margin-top:5px!important;">
                    <input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;" />
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/course/inCourse'">取消查询</a>
                </span>
				<a class="easyui-linkbutton" href="javascript:void(0);" onclick="printPage();">打印页面</a>
				<shiro:hasRole name="administrator">
					<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-package_in',plain:true" onclick="importCourse();">从excel导入课程</a>
				</shiro:hasRole>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="exportAll();">导出所有课程到excel</a>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				查找从&nbsp;<input id="bdate" type="text" style="width:160px;" />&nbsp;到&nbsp;<input id="edate" type="text" style="width:160px;" />&nbsp;新建的课程
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="searchByDate();" data-options="iconCls:'icon-search'">查询</a>
			</td>
		</tr>
	</table>
	<input type="hidden" id="cCount" value="${cCount}" />
	<input type="hidden" id="qCount" value="${qCount}" />
</div>

<table id="datalist"></table>

<table id="printTable">
	<thead>
	<tr>
		<th>序号</th>
		<th>课程名称</th>
		<th>授课单位</th>
		<th>所属科室</th>
		<th>最大学时</th>
		<th>试卷数</th>
		<th>试题数</th>
	</tr>
	</thead>
	<tbody id="printTableBody"></tbody>
</table>

<div id="importCourse"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.cookie.js"></script>
<script type="text/javascript">
	const contextPath = '${pageContext.request.contextPath}';
	const storageNullValue = 'null';

	let title = '';
	let fin = 1;
	let arrangeid = '';
	let unitid = '';
	let depid = '';
	let cname = '';

	let page = 1;
	let rows = 100;
	let sort = '';
	let order = '';

	let back = '';
	let courseTotal = 0;
	let suppressFilterEvents = false;
	let departmentRequestToken = 0;

	function cookierback() {
		back = '${back}';
		title = parent.$('#nav_tab').tabs('getSelected').panel('options').title;
		if (back === '1') {
			arrangeid = sessionStorage.getItem(title + '-arrangeid') === storageNullValue ? '' : sessionStorage.getItem(title + '-arrangeid');
			unitid = sessionStorage.getItem(title + '-unitid') === storageNullValue ? '' : sessionStorage.getItem(title + '-unitid');
			depid = sessionStorage.getItem(title + '-depid') === storageNullValue ? '' : sessionStorage.getItem(title + '-depid');
			cname = sessionStorage.getItem(title + '-cname') === storageNullValue ? '' : sessionStorage.getItem(title + '-cname');
			page = sessionStorage.getItem(title + '-page') === storageNullValue ? 1 : parseInt(sessionStorage.getItem(title + '-page'), 10);
			rows = sessionStorage.getItem(title + '-rows') === storageNullValue ? 80 : parseInt(sessionStorage.getItem(title + '-rows'), 10);
			sort = sessionStorage.getItem(title + '-sort') === storageNullValue ? '' : sessionStorage.getItem(title + '-sort');
			order = sessionStorage.getItem(title + '-order') === storageNullValue ? '' : sessionStorage.getItem(title + '-order');
		} else {
			sessionStorage.setItem(title + '-arrangeid', null);
			sessionStorage.setItem(title + '-unitid', null);
			sessionStorage.setItem(title + '-depid', null);
			sessionStorage.setItem(title + '-cname', null);
			sessionStorage.setItem(title + '-sort', null);
			sessionStorage.setItem(title + '-order', null);
			sessionStorage.setItem(title + '-page', null);
			sessionStorage.setItem(title + '-rows', null);
		}
	}

	function cookier() {
		sessionStorage.setItem(title + '-arrangeid', arrangeid);
		sessionStorage.setItem(title + '-unitid', unitid);
		sessionStorage.setItem(title + '-depid', depid);
		sessionStorage.setItem(title + '-cname', cname);
		sessionStorage.setItem(title + '-sort', sort);
		sessionStorage.setItem(title + '-order', order);
		sessionStorage.setItem(title + '-page', page);
		sessionStorage.setItem(title + '-rows', rows);
	}

	function loader() {
		if ('${back}' === '1') {
			$('#cname').searchbox('setValue', cname);
		}
	}

	function getFilterValue(selector) {
		const value = $(selector).val();
		return value == null ? '' : String(value);
	}

	function filterloader() {
		unitid = getFilterValue('#unitFilter');
		depid = getFilterValue('#departmentFilter');
		arrangeid = getFilterValue('#arrangeFilter');
		cname = $('#cname').searchbox('getValue');

		$('#datalist').datagrid('load', {
			unitid: unitid,
			depid: depid,
			arrangeid: arrangeid,
			cname: cname
		});
		cookier();
	}

	function normalizeOptionList(data) {
		if ($.isArray(data)) {
			return data;
		}
		if (data && $.isArray(data.rows)) {
			return data.rows;
		}
		if (data && $.isArray(data.data)) {
			return data.data;
		}
		return [];
	}

	function escapeHtml(value) {
		return String(value == null ? '' : value)
				.replace(/&/g, '&amp;')
				.replace(/</g, '&lt;')
				.replace(/>/g, '&gt;')
				.replace(/"/g, '&quot;')
				.replace(/'/g, '&#39;');
	}

	function renderSelect2($select, list, selectedValue, placeholder, changeHandler) {
		const options = normalizeOptionList(list);
		const html = ['<option value=""></option>'];

		for (let i = 0; i < options.length; i += 1) {
			const item = options[i];
			html.push('<option value="' + escapeHtml(item.ID) + '">' + escapeHtml(item.NAME) + '</option>');
		}

		suppressFilterEvents = true;

		if ($select.hasClass('select2-hidden-accessible')) {
			$select.off('.filterSelect2');
			$select.select2('destroy');
		}

		$select.html(html.join(''));
		$select.select2({
			width: 'style',
			placeholder: placeholder,
			allowClear: true,
			minimumResultsForSearch: 0
		});

		$select.val(selectedValue ? String(selectedValue) : '').trigger('change.select2');

		$select.on('change.filterSelect2', function () {
			if (suppressFilterEvents) {
				return;
			}
			changeHandler();
		});

		suppressFilterEvents = false;
	}

	function loadUnitOptions(selectedValue) {
		return $.ajax({
			url: contextPath + '/common/getUnit',
			type: 'GET',
			dataType: 'json'
		}).done(function (data) {
			renderSelect2($('#unitFilter'), data, selectedValue, '授课单位', function () {
				const selectedUnitId = getFilterValue('#unitFilter');
				depid = '';
				loadDepartmentOptions(selectedUnitId, '').always(function () {
					filterloader();
				});
			});
		}).fail(function () {
			toastr.error('加载授课单位失败');
		});
	}

	function loadDepartmentOptions(selectedUnitId, selectedDepartmentId) {
		const requestToken = departmentRequestToken + 1;
		departmentRequestToken = requestToken;

		return $.ajax({
			url: contextPath + '/common/getDepartment',
			type: 'GET',
			dataType: 'json',
			data: {
				unitid: selectedUnitId || ''
			}
		}).done(function (data) {
			if (requestToken !== departmentRequestToken) {
				return;
			}
			renderSelect2($('#departmentFilter'), data, selectedDepartmentId, '所属科室', function () {
				filterloader();
			});
		}).fail(function () {
			toastr.error('加载所属科室失败');
		});
	}

	function loadArrangeOptions(selectedValue) {
		return $.ajax({
			url: contextPath + '/common/getArrangement',
			type: 'GET',
			dataType: 'json'
		}).done(function (data) {
			renderSelect2($('#arrangeFilter'), data, selectedValue, '适应层次', function () {
				filterloader();
			});
		}).fail(function () {
			toastr.error('加载适应层次失败');
		});
	}

	function initFilterSelects() {
		return $.when(
				loadUnitOptions(unitid),
				loadDepartmentOptions(unitid, depid),
				loadArrangeOptions(arrangeid)
		).always(function () {
			loader();
		});
	}

	$(document).ready(function () {
		$.parser.parse($('#datalist'));
		cookierback();

		$('#datalist').datagrid({
			fit: true,
			fitColumns: true,
			striped: true,
			singleSelect: false,
			url: contextPath + '/course/getCourseList',
			pagination: true,
			rownumbers: false,
			pageNumber: page,
			queryParams: {
				unitid: unitid,
				depid: depid,
				arrangeid: arrangeid,
				cname: cname
			},
			pageSize: rows,
			pageList: [20, 40, 60, 80, 100, 120, 140, 160, 180, 200],
			sortName: sort,
			sortOrder: order,
			toolbar: '#dlg-toolbar',
			columns: [[
				{field: 'CID', checkbox: true},
				{
					field: 'index',
					title: '序号',
					width: 10,
					align: 'center',
					formatter: function (val, row, index) {
						const options = $('#datalist').datagrid('getPager').data('pagination').options;
						let currentPage = options.pageNumber;
						if (currentPage === 0) {
							currentPage = 1;
						}
						const currentPageSize = options.pageSize;
						return (currentPageSize * (currentPage - 1)) + (index + 1);
					}
				},
				{
					field: 'NAME_C',
					title: '课程中文名',
					width: 80,
					align: 'left',
					sortable: true,
					formatter: function (value, row) {
						return '<div onclick="viewCourse(' + row.CID + ')" style="cursor:pointer">' + row.NAME_C + '</div>';
					}
				},
				{field: 'UNAME', title: '授课单位', width: 50, align: 'left', sortable: true},
				{field: 'DNAME', title: '所属科室', width: 40, align: 'left', sortable: true},
				{field: 'PERIOD', title: '最大学时', width: 20, align: 'left', sortable: true},
				{field: 'PCOUNT', title: '试卷数', width: 30, align: 'left', sortable: true},
				{field: 'QCOUNT', title: '试题数', width: 30, align: 'left', sortable: true},
				{
					field: 'opration',
					title: '操作',
					width: 120,
					align: 'center',
					formatter: function (value, row) {
						const s0 = '<a href="javascript:void(0);" onclick="viewCourse(\'' + row.CID + '\')" class="editcls0"></a>';
						const s1 = '<a href="javascript:void(0);" onclick="gotoEditCourse(\'' + row.CID + '\')" class="editcls1"></a>';
						const s2 = '<a href="' + contextPath + '/question/QuestionList?c_id=' + row.CID + '" class="editcls2"></a>';
						const s3 = '<a href="javascript:void(0);" onclick="inCoursePermission(\'' + row.CID + '\',\'' + row.NAME_C + '\');" class="editcls3"></a>';
						const s4 = '<a href="javascript:void(0);" class="editcls4" onclick="delCourse(' + row.CID + ')"></a>';
						const permissions = row.permissions;

						if (permissions[0] === '*:*') {
							return s0 + s1 + s2 + s3 + s4;
						}

						let str = s0;
						for (let i = 0; i < permissions.length; i += 1) {
							if (permissions[i] === 'course:update') {
								str += s1;
								continue;
							}
							if (permissions[i] === 'question:view') {
								str += s2;
								continue;
							}
							if (permissions[i] === 'course:permission') {
								str += s3;
								continue;
							}
							if (permissions[i] === 'course:del') {
								str += s4;
								continue;
							}
						}
						return s0 + s1 + s2 + s3 + s4;
					}
				}
			]],
			onCheck: function () {
				courseTotal = 0;
				const selected = $('#datalist').datagrid('getChecked');
				for (let i = 0; i < selected.length; i += 1) {
					courseTotal += selected[i].QCOUNT;
				}
				$('.datagrid-pager table').next().html(selected.length + '门课程，' + courseTotal + '道试题');
			},
			onUncheck: function (rowIndex, rowData) {
				courseTotal = courseTotal - rowData.QCOUNT;
				const selected = $('#datalist').datagrid('getChecked');
				if (selected.length === 0) {
					$('.datagrid-pager table').next().html($('#cCount').val() + '门课程，' + $('#qCount').val() + '道试题');
				} else {
					$('.datagrid-pager table').next().html(selected.length + '门课程，' + courseTotal + '道试题');
				}
			},
			onCheckAll: function (checkedRows) {
				let currentCount = 0;
				for (let i = 0; i < checkedRows.length; i += 1) {
					currentCount += checkedRows[i].QCOUNT;
				}
				courseTotal = currentCount;
				$('.datagrid-pager table').next().html(checkedRows.length + '门课程，' + courseTotal + '道试题');
			},
			onUncheckAll: function (uncheckedRows) {
				let currentCount = 0;
				for (let i = 0; i < uncheckedRows.length; i += 1) {
					currentCount += uncheckedRows[i].QCOUNT;
				}
				courseTotal = currentCount;
				$('.datagrid-pager table').next().html($('#cCount').val() + '门课程，' + courseTotal + '道试题');
			},
			onLoadSuccess: function () {
				$('.editcls0').linkbutton({text: '课程详情', plain: true});
				$('.editcls1').linkbutton({text: '课程设置', plain: true});
				$('.editcls2').linkbutton({text: '编辑试题', plain: true});
				$('.editcls3').linkbutton({text: '课程权限', plain: true});
				$('.editcls4').linkbutton({text: '删除课程', plain: true});
				getCourse_QuestionCount(unitid, depid, arrangeid, cname);
				initPrintArea();

				if (page !== $('#datalist').datagrid('getPager').data('pagination').options.pageNumber) {
					page = $('#datalist').datagrid('getPager').data('pagination').options.pageNumber;
					cookier();
				}
				if (fin === 1) {
					const str = '<div style="float:left;margin: 0 6px;height: 30px;line-height: 30px;">' + $('#cCount').val() + '门课程，' + $('#qCount').val() + '道试题</div>';
					$('.pagination-info').before(str);
					fin = 0;
				}
			},
			onSortColumn: function (sorts, orders) {
				sort = sorts;
				order = orders;
				cookier();
			}
		});

		$('#bdate').datebox();
		$('#edate').datebox();

		const pagerButtons = [];
		const pager = $('#datalist').datagrid('getPager');
		$(pager).pagination({
			buttons: pagerButtons,
			onChangePageSize: function (pageSize) {
				rows = pageSize;
				cookier();
			}
		});

		initFilterSelects();
	});

	function getCourse_QuestionCount(currentUnitId, currentDepId, currentArrangeId, currentCname, beginDate, endDate) {
		$.ajax({
			url: contextPath + '/course/getCourse_QuestionCount',
			async: true,
			type: 'POST',
			traditional: true,
			data: {
				unitid: currentUnitId,
				depid: getFilterValue('#departmentFilter') || currentDepId || '',
				arrangeid: currentArrangeId,
				cname: currentCname,
				beginDate: beginDate || $('#bdate').datebox('getValue'),
				endDate: endDate || $('#edate').datebox('getValue')
			},
			success: function (data) {
				let cCount = 0;
				let qCount = 0;

				if (typeof data.cCount !== 'undefined') {
					cCount = data.cCount;
				}
				$('#cCount').val(cCount);

				if (typeof data.qCount !== 'undefined') {
					qCount = data.qCount;
				}
				$('#qCount').val(qCount);

				$('.datagrid-wrap').addClass('change').attr('data-content', cCount + '门课程，' + qCount + '道试题');
				$('.datagrid-pager table').next().html(cCount + '门课程，' + qCount + '道试题');
			}
		});
	}

	function initPrintArea() {
		$('#printTableBody').empty();
		$('#printTable').css('display', 'block');
		const datagridRows = $('#datalist').datagrid('getRows');

		for (let i = 0; i < datagridRows.length; i += 1) {
			let res = '<tr>';
			res += '<td>' + (i + 1) + '</td>';
			res += '<td>' + datagridRows[i].NAME_C + '</td>';
			res += '<td>' + datagridRows[i].UNAME + '</td>';
			if (typeof datagridRows[i].DNAME === 'undefined' || datagridRows[i].DNAME === 'null' || datagridRows[i].DNAME == null) {
				res += '<td></td>';
			} else {
				res += '<td>' + datagridRows[i].DNAME + '</td>';
			}
			res += '<td>' + datagridRows[i].PERIOD + '</td>';
			res += '<td>' + datagridRows[i].PCOUNT + '</td>';
			res += '<td>' + datagridRows[i].QCOUNT + '</td>';
			res += '</tr>';
			$('#printTableBody').append(res);
		}
	}

	function delSelect() {
		const res = [];
		const selectedRows = $('#datalist').datagrid('getSelections');
		for (let i = 0; i < selectedRows.length; i += 1) {
			res.push(selectedRows[i].CID);
		}
		$.messager.confirm('提示', '是否要删除所选课程 ?', function (r) {
			if (r) {
				$.ajax({
					url: contextPath + '/course/delSelect',
					async: true,
					type: 'POST',
					traditional: true,
					data: {cids: res},
					success: function (data) {
						if (data) {
							toastr.warning(data);
						} else {
							$('#datalist').datagrid('reload');
						}
					}
				});
			}
		});
	}

	function delCourse(cid) {
		const params = {};
		params.cid = cid + '';
		params.permission = 'course:del';
		$.ajax({
			contentType: 'application/json; charset=utf-8',
			url: contextPath + '/course/checkCoursePermission',
			async: false,
			type: 'POST',
			data: JSON.stringify(params),
			success: function (data) {
				if (data === 1) {
					$.messager.confirm('提示', '是否要删除所选课程 ?', function (r) {
						if (r) {
							$.ajax({
								url: contextPath + '/course/delCourse',
								async: false,
								type: 'POST',
								data: {c_id: cid + ''},
								success: function (deleteResult) {
									if (deleteResult) {
										toastr.warning(deleteResult);
									} else {
										$('#datalist').datagrid('reload');
									}
								}
							});
						}
					});
				} else if (data === 0) {
					toastr.warning('无相关权限');
				} else {
					toastr.error('登录超时，请重新登录！');
				}
			}
		});
	}

	function gotoAddCourse() {
		$.ajax({
			url: contextPath + '/course/checkAddCoursePermission',
			async: false,
			type: 'POST',
			data: {},
			success: function (data) {
				if (data === 1) {
					window.location.href = contextPath + '/course/toAddCourse';
				} else if (data === 0) {
					toastr.warning('无相关权限');
				} else {
					toastr.error('登录超时，请重新登录！');
				}
			}
		});
	}

	function viewCourse(cid) {
		openIframeDialog({
			url: contextPath + '/course/viewCourse?c_id=' + cid,
			fit: true,
			title: '查看课程'
		}, 0);
	}

	function gotoEditCourse(cid) {
		const params = {};
		params.cid = cid;
		params.permission = 'course:update';
		$.ajax({
			contentType: 'application/json; charset=utf-8',
			url: contextPath + '/course/checkCoursePermission',
			async: false,
			type: 'POST',
			data: JSON.stringify(params),
			success: function (data) {
				if (data === 1) {
					openIframeDialog({
						url: contextPath + '/course/editCourse?c_id=' + cid,
						fit: true,
						title: '课程设置'
					}, 1);
				} else if (data === 0) {
					toastr.warning('无相关权限');
				} else {
					toastr.error('登录超时，请重新登录！');
				}
			}
		});
	}

	function gotoPaperAnalysis(cid, name_c) {
		const url = contextPath + '/course/gotoPaperAnalysis?cid=' + cid;
		const content = '<iframe frameborder="no" width="100%" height="100%" src="' + url + '" scrolling="auto" style="overflow:auto"></iframe>';
		window.parent.$('#nav_tab').tabs('add', {
			title: '《' + name_c + '》纵向试卷分析',
			content: content,
			closable: true
		});
	}

	function inCoursePermission(cid, name_c) {
		const params = {};
		params.cid = cid;
		params.permission = 'course:permission';
		$.ajax({
			contentType: 'application/json; charset=utf-8',
			url: contextPath + '/course/checkCoursePermission',
			async: false,
			type: 'POST',
			data: JSON.stringify(params),
			success: function (data) {
				if (data === 1) {
					openIframeDialog({
						url: contextPath + '/course/inCoursePermission?c_id=' + cid + '&cname=' + name_c,
						fit: true,
						title: '课程权限'
					}, 0);
				} else if (data === 0) {
					toastr.warning('无相关权限');
				} else {
					toastr.error('登录超时，请重新登录！');
				}
			}
		});
	}

	function printPage() {
		$('#printTable').jqprint();
	}

	function exportAll() {
		const keyword = $('#cname').searchbox('getValue');
		const currentUnitId = getFilterValue('#unitFilter');
		const currentArrangeId = getFilterValue('#arrangeFilter');
		const currentDepId = getFilterValue('#departmentFilter');
		window.location.href = contextPath + '/course/exportAll?unitid=' + currentUnitId + '&depid=' + currentDepId + '&arrangeid=' + currentArrangeId + '&cname=' + encodeURIComponent(keyword);
	}

	function exportAllQ(cid) {
		const params = {};
		params.cid = cid + '';
		params.permission = 'question:export';
		$.ajax({
			contentType: 'application/json; charset=utf-8',
			url: contextPath + '/question/checkQuestionPermission',
			async: false,
			type: 'POST',
			data: JSON.stringify(params),
			success: function (data) {
				if (data === 1) {
					window.location.href = contextPath + '/question/exportAll?cid=' + cid;
				} else if (data === 0) {
					toastr.warning('无相关权限');
				} else {
					toastr.error('登录超时，请重新登录！');
				}
			}
		});
	}

	function doSearch(value, name) {
		cname = value;
		unitid = getFilterValue('#unitFilter');
		depid = getFilterValue('#departmentFilter');
		arrangeid = getFilterValue('#arrangeFilter');
		cookier();
		$('#datalist').datagrid('load', {
			unitid: unitid,
			depid: depid,
			arrangeid: arrangeid,
			cname: value
		});
	}

	function importCourse() {
		const winStr = [
			'<form id="uploadForm" method="post" enctype="multipart/form-data" action="', contextPath, '/course/importCourse">',
			'<table style="width:100%;margin-top:5px;">',
			'<tr><td colspan="2" style="text-align:center;color:red;">导入课程（只接受excel格式）</td></tr>',
			'<tr><td>选择文件：</td><td><input id="uploadFile" type="file" name="uploadFile" value="" /></td></tr>',
			'<tr><td></td><td><input type="button" id="importFile" name="importFile" value="上传" /></td></tr>',
			'<tr><td>下载模板：</td><td><a href="', contextPath, '/course/importCourseTemplate">链接</a></td></tr>',
			'</table></form>'
		].join('');

		const obj = $(winStr);
		$('#importCourse').html(null);
		obj.appendTo('#importCourse');
		$('#importCourse').window({
			width: 510,
			height: 200,
			modal: true,
			title: '导入课程',
			collapsible: false,
			minimizable: false,
			maximizable: false
		});

		$('#importFile').click(function () {
			const fileName = $('#uploadFile').val();
			if (fileName === '') {
				toastr.warning('请选择附件');
				return;
			}
			const fileType = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
			if (fileType === 'xls' || fileType === 'xlsx') {
				$('#importCourse').window('close');
				ajaxLoading();
				const formData = new FormData();
				formData.append('uploadFile', $('#uploadFile')[0].files[0]);
				$.ajax({
					url: contextPath + '/course/importCourse',
					type: 'POST',
					secureuri: false,
					data: formData,
					processData: false,
					contentType: false,
					success: function (data) {
						if (data === '0') {
							toastr.success('导入成功！');
							window.location.href = contextPath + '/course/inCourse';
						} else if (data === '-1') {
							toastr.error('课程名称、所属学院以及学时数不能为空！');
						} else {
							toastr.error(data);
						}
						ajaxLoadEnd();
					}
				});
			} else {
				toastr.warning('上传文件格式错误！');
			}
		});
	}

	function searchByDate() {
		const beginDate = $('#bdate').datebox('getValue');
		const endDate = $('#edate').datebox('getValue');
		const r1 = beginDate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
		const r2 = endDate.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
		if (r1 == null || r2 == null) {
			toastr.warning('请正确输入日期');
			return;
		}

		const beginTime = new Date(beginDate);
		const endTime = new Date(endDate);
		if (Number.isNaN(beginTime.getTime()) || Number.isNaN(endTime.getTime())) {
			toastr.warning('请输入合法的时间参数');
			return;
		}
		if (endTime < beginTime) {
			toastr.warning('开始时间不能大于结束时间');
			return;
		}

		const pager = $('#datalist').datagrid('getPager');
		$('#datalist').datagrid('reload', {
			beginDate: beginDate,
			endDate: endDate,
			page: $(pager).pagination('options').pageNumber,
			rows: $(pager).pagination('options').pageSize
		});
	}
</script>
