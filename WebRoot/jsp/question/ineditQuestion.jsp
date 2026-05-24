<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
<div id="dlg-toolbar" style="height:auto;">
	<table style="width:100%; border:none; border-collapse:collapse; border-spacing:0;">
		<tbody>
		<tr>
			<td>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/ineditQuestion'">刷新</a>
				<select id="unitFilter" name="unitFilter" style="width:190px;"></select>
				<select id="departmentFilter" name="departmentFilter" style="width:190px;"></select>
				<select id="arrangeFilter" name="arrangeFilter" style="width:190px;"></select>
				<span style="display:inline-block; margin-top:5px;">
                        <input class="easyui-searchbox" id="cname" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;" />
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.href='${pageContext.request.contextPath}/question/ineditQuestion'">取消查询</a>
                    </span>
			</td>
			<td style="text-align:right; white-space:nowrap;">
				<shiro:hasAnyRoles name="administrator, dean">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-transmit_go',plain:true" onclick="exportWorkLoad()">导出课程工作量</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-transmit_add',plain:true" onclick="exportWorkLoad(1)">导出所选课程工作量</a>
				</shiro:hasAnyRoles>
			</td>
		</tr>
		</tbody>
	</table>
	<input type="hidden" id="cCount" value="${cCount}" />
	<input type="hidden" id="qCount" value="${qCount}" />
</div>
<table id="datalist"></table>

<div id="win"></div>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/jquery.cookie.js"></script>
<script src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script type="text/javascript">
	let title = '';
	let fin = 1;
	let arrangeid = '';
	let unitid = '';
	let depid = '';
	let cname = '';

	let page = 1;
	let rows = 80;
	let sort = '';
	let order = '';

	let back = '';

	let courseTotal = 0; // 试题数
	let isFilterInitializing = false;

	function cookierback() { // 加载初始数据前
		back = '${back}';
		title = parent.$('#nav_tab').tabs('getSelected').panel('options').title;
		if (back === '1') {
			arrangeid = sessionStorage.getItem(title + '-arrangeid') === 'null' ? '' : sessionStorage.getItem(title + '-arrangeid');
			unitid = sessionStorage.getItem(title + '-unitid') === 'null' ? '' : sessionStorage.getItem(title + '-unitid');
			cname = sessionStorage.getItem(title + '-cname') === 'null' ? '' : sessionStorage.getItem(title + '-cname');
			page = sessionStorage.getItem(title + '-page') === 'null' ? 1 : parseInt(sessionStorage.getItem(title + '-page'), 10);
			rows = sessionStorage.getItem(title + '-rows') === 'null' ? 80 : parseInt(sessionStorage.getItem(title + '-rows'), 10);
			sort = sessionStorage.getItem(title + '-sort') === 'null' ? '' : sessionStorage.getItem(title + '-sort');
			order = sessionStorage.getItem(title + '-order') === 'null' ? '' : sessionStorage.getItem(title + '-order');
		} else {
			sessionStorage.setItem(title + '-arrangeid', null);
			sessionStorage.setItem(title + '-unitid', null);
			sessionStorage.setItem(title + '-cname', null);
			sessionStorage.setItem(title + '-sort', null);
			sessionStorage.setItem(title + '-order', null);
			sessionStorage.setItem(title + '-page', null);
			sessionStorage.setItem(title + '-rows', null);
		}
	}

	function cookier() { // 更改筛选条件后
		sessionStorage.setItem(title + '-arrangeid', arrangeid);
		sessionStorage.setItem(title + '-unitid', unitid);
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

	function normalizeSelect2Data(data) {
		return $.map(data || [], function(item) {
			return {
				id: String(item.ID),
				text: item.NAME,
				raw: item
			};
		});
	}

	function rebuildSelect2Options(selector, items, selectedId) {
		const $select = $(selector);
		const value = selectedId === null || selectedId === undefined ? '' : String(selectedId);

		$select.empty();
		$select.append(new Option('', '', false, false));

		$.each(items, function(index, item) {
			const option = new Option(item.text, item.id, false, false);
			$(option).data('raw', item.raw);
			$select.append(option);
		});

		$select.val(value).trigger('change.select2');
	}

	function getSelectedFilterRecord(selector) {
		const $selected = $(selector).find('option:selected');
		if ($selected.length === 0 || !$selected.val()) {
			return null;
		}
		return $selected.data('raw') || null;
	}

	function getFilterId(selector) {
		const selected = getSelectedFilterRecord(selector);
		return selected ? selected.ID : '';
	}

	function getFilterName(selector) {
		const selected = getSelectedFilterRecord(selector);
		return selected ? selected.NAME : '';
	}

	function filterloader() {
		unitid = getFilterId('#unitFilter');
		depid = getFilterId('#departmentFilter');
		arrangeid = getFilterId('#arrangeFilter');
		cname = $('#cname').searchbox('getValue');
		$('#datalist').datagrid('load', {
			unitid: unitid,
			depid: depid,
			arrangeid: arrangeid,
			cname: cname
		});
		cookier();
	}

	function loadArrangeOptions(selectedId) {
		return $.ajax({
			url: '${pageContext.request.contextPath}/common/getArrangement',
			type: 'GET',
			dataType: 'json'
		}).done(function(data) {
			const items = normalizeSelect2Data(data);
			isFilterInitializing = true;
			rebuildSelect2Options('#arrangeFilter', items, selectedId);
			isFilterInitializing = false;
		});
	}

	function loadUnitOptions(selectedId) {
		return $.ajax({
			url: '${pageContext.request.contextPath}/common/getUnit',
			type: 'GET',
			dataType: 'json'
		}).done(function(data) {
			const items = normalizeSelect2Data(data);
			isFilterInitializing = true;
			rebuildSelect2Options('#unitFilter', items, selectedId);
			isFilterInitializing = false;
		});
	}

	function loadDepartmentOptions(selectedUnitId, selectedDepartmentId) {
		return $.ajax({
			url: '${pageContext.request.contextPath}/common/getDepartment',
			type: 'GET',
			dataType: 'json',
			data: {
				unitid: selectedUnitId || ''
			}
		}).done(function(data) {
			const items = normalizeSelect2Data(data);
			isFilterInitializing = true;
			rebuildSelect2Options('#departmentFilter', items, selectedDepartmentId);
			isFilterInitializing = false;
		});
	}

	function initSelect2Filters() {
		$('#unitFilter').select2({
			width: '190px',
			placeholder: '授课单位',
			allowClear: true
		});

		$('#departmentFilter').select2({
			width: '190px',
			placeholder: '所属科室',
			allowClear: true
		});

		$('#arrangeFilter').select2({
			width: '190px',
			placeholder: '适应层次',
			allowClear: true
		});

		$('#arrangeFilter').on('change', function() {
			if (isFilterInitializing) {
				return;
			}
			const arrangeidChosen = getFilterId('#arrangeFilter');
			if (arrangeidChosen !== arrangeid) {
				filterloader();
			}
		});

		$('#unitFilter').on('change', function() {
			if (isFilterInitializing) {
				return;
			}
			const selectedUnitId = getFilterId('#unitFilter');
			const hasUnitChanged = selectedUnitId !== unitid;
			depid = '';
			loadDepartmentOptions(selectedUnitId, '').always(function() {
				if (hasUnitChanged) {
					filterloader();
				}
			});
		});

		$('#departmentFilter').on('change', function() {
			if (isFilterInitializing) {
				return;
			}
			let currentUnitId = '';
			if (getSelectedFilterRecord('#unitFilter') !== null) {
				currentUnitId = getSelectedFilterRecord('#unitFilter').ID;
			}
			let currentDepid = '';
			if (getSelectedFilterRecord('#departmentFilter') !== null) {
				currentDepid = getSelectedFilterRecord('#departmentFilter').ID;
			}
			$('#datalist').datagrid('load', {
				depid: currentDepid,
				unitid: currentUnitId
			});
		});
	}

	$(document).ready(function() {
		cookierback();
		initSelect2Filters();

		$.when(loadArrangeOptions(arrangeid), loadUnitOptions(unitid)).always(function() {
			loadDepartmentOptions(unitid, depid).always(function() {
				loader();
			});
		});

		$('#datalist').datagrid({
			fit: true,
			striped: true,
			singleSelect: false,
			url: '${pageContext.request.contextPath}/course/getCourseList?owner=question',
			pagination: true,
			rownumbers: false,
			pageSize: rows,
			pageList: [20, 40, 60, 80, 100, 120, 140, 160, 180, 200],
			pageNumber: page,
			queryParams: {
				unitid: unitid,
				depid: depid,
				arrangeid: arrangeid,
				cname: cname
			},
			sortName: sort,
			sortOrder: order,
			fitColumns: true,
			toolbar: '#dlg-toolbar',
			columns: [[
				{field: 'CID', checkbox: true},
				{field: 'index', title: '序号', width: 10, align: 'center', formatter: function(val, row, index) {
						const options = $('#datalist').datagrid('getPager').data('pagination').options;
						let currentPage = options.pageNumber;
						if (currentPage === 0) {
							currentPage = 1;
						}
						const pageSize = options.pageSize;
						return (pageSize * (currentPage - 1)) + (index + 1);
					}},
				{field: 'CODE', title: '课程编码', width: 40, align: 'left', sortable: true},
				{field: 'NAME_C', title: '课程中文名', width: 40, align: 'left', sortable: true},
				{field: 'UNAME', title: '授课单位', width: 40, align: 'left', sortable: true},
				{field: 'QCOUNT', title: '试题数', width: 40, align: 'left', sortable: true},
				{field: 'opration', title: '操作', width: 120, align: 'center', formatter: function(value, row, index) {
						const s1 = "<a href=\"javascript:void(0);\" class=\"editcls1\" onclick=\"checkQuestionPermission('" + row.CID + "','question:view','${pageContext.request.contextPath}/question/QuestionList?c_id=" + row.CID + "')\"></a>";
						const s4 = "<a href=\"javascript:void(0);\" class=\"editcls4\" onclick=\"checkQuestionVerifyPermission('" + row.CID + "','${pageContext.request.contextPath}/question/QuestionList4Verify?c_id=" + row.CID + "')\"></a>";
						const s6 = '<a href="javascript:void(0)" class="editcls6" onclick="delAll(' + row.CID + ')"></a>';
						const s2 = '<a href="javascript:void(0)" onclick="distributionStatistics(' + row.CID + ')" class="editcls2"></a>';
						const s3 = '<a href="javascript:void(0)" class="editcls3" onclick="workLoad(' + row.CID + ')"></a>';
						const s7 = '<a href="javascript:void(0)" class="editcls7" onclick="exportAll(' + row.CID + ')"></a>';
						const s5 = "<a href=\"javascript:void(0)\" class=\"editcls5\" onclick=\"replaceQuestionType('" + row.CID + "','" + row.NAME_C + "')\"></a>";
						return s1 + s2 + s3 + s4 + s5 + s6 + s7;
					}}
			]],
			onCheck: function(rowIndex, rowData) {
				courseTotal = 0;
				const selected = $('#datalist').datagrid('getChecked');
				for (let i = 0; i < selected.length; i++) {
					courseTotal += selected[i].QCOUNT;
				}
				$('.datagrid-pager table').next().html(selected.length + '门课程，' + courseTotal + '道试题');
			},
			onUncheck: function(rowIndex, rowData) {
				courseTotal = courseTotal - rowData.QCOUNT;
				const selected = $('#datalist').datagrid('getChecked');
				if (selected.length === 0) {
					$('.datagrid-pager table').next().html($('#cCount').val() + '门课程，' + $('#qCount').val() + '道试题');
				} else {
					$('.datagrid-pager table').next().html(selected.length + '门课程，' + courseTotal + '道试题');
				}
			},
			onCheckAll: function(checkedRows) {
				let currentCount = 0;
				for (const item in checkedRows) {
					currentCount += checkedRows[item].QCOUNT;
				}
				courseTotal = currentCount;
				$('.datagrid-pager table').next().html(checkedRows.length + '门课程，' + courseTotal + '道试题');
			},
			onUncheckAll: function(uncheckedRows) {
				let currentCount = 0;
				for (const item in uncheckedRows) {
					currentCount += uncheckedRows[item].QCOUNT;
				}
				courseTotal = currentCount;
				$('.datagrid-pager table').next().html($('#cCount').val() + '门课程，' + courseTotal + '道试题');
			},
			onLoadSuccess: function(data) {
				$('.editcls1').linkbutton({text: '编辑试题', plain: true});
				$('.editcls2').linkbutton({text: '分布统计', plain: true});
				$('.editcls3').linkbutton({text: '工作量', plain: true});
				$('.editcls4').linkbutton({text: '审核试题', plain: true});
				$('.editcls5').linkbutton({text: '题型替换', plain: true});
				$('.editcls6').linkbutton({text: '删除所有试题', plain: true});
				$('.editcls7').linkbutton({text: '导出试题库到excel', plain: true});
				getCourse_QuestionCount(unitid, arrangeid, cname);
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
			onSortColumn: function(sorts, orders) {
				sort = sorts;
				order = orders;
				cookier();
			}
		});

		const buttons = [];
		const p = $('#datalist').datagrid('getPager');
		$(p).pagination({buttons: buttons});
		$(p).pagination({
			onChangePageSize: function(pageSize) {
				rows = pageSize;
				cookier();
			}
		});
	});

	function doSearch(value, name) { // 通用查询框
		cname = value;
		unitid = getFilterId('#unitFilter');
		depid = getFilterId('#departmentFilter');
		arrangeid = getFilterId('#arrangeFilter');
		cookier();
		$('#datalist').datagrid('load', {
			unitid: unitid,
			depid: depid,
			arrangeid: arrangeid,
			cname: value
		});
	}

	function getCourse_QuestionCount(unitid, arrangeid, cname) {
		$(".datagrid-wrap").addClass('change').attr('data-content', "0门课程，0道试题");
		$.ajax({
			url: "${pageContext.request.contextPath}/course/getCourse_QuestionCount",
			async: true,
			type: "POST",
			traditional: true,
			data: {"unitid":unitid,"arrangeid":arrangeid,"cname":cname},
			success: function (data) {
				let cCount = 0;
				let qCount = 0;
				if(typeof(data.cCount) != 'undefined'){
					cCount = data.cCount;
				}else{
					cCount = 0;
				}
				$("#cCount").val(cCount);
				if(typeof(data.qCount) != 'undefined'){
					qCount = data.qCount;
				}else{
					qCount = 0;
				}
				$("#qCount").val(qCount);
				$(".datagrid-wrap").addClass('change').attr('data-content', cCount+"门课程，"+qCount+"道试题");
				$(".datagrid-pager table").next().html(cCount+"门课程，"+qCount+"道试题");
			}
		});
	}

	function replaceQuestionType(cid,cname){
		$.ajax({
			url: "${pageContext.request.contextPath}/course/getQTlist_haveQuestion",
			async: false,//改为同步方式
			type: "POST",
			data: { "cid":cid },
			success: function (data) {
				if(data.error=='notTheRole'){
					toastr.error("权限不足！");
				}else{
					let str = '';
					let str1= '';
					for(let i=0; i<data.questionTypeList_HQ.length; i++){
						str += '<option value="' + data.questionTypeList_HQ[i].QTID+ '">' + data.questionTypeList_HQ[i].QTNAME + '</option>';
					}
					for(let i=0; i<data.questionTypeList.length; i++){
						str1 += '<option value="' + data.questionTypeList[i].QTID+ '">' + data.questionTypeList[i].QTNAME + '</option>';
					}

					const winStr = '<form id="QTForm" method="post"><table style="width:100%;">'
							+ '<tr><td align="right">原题型：</td><td align="left"><select onchange="showTips('+cid+')" style="width:220px;" id="original" name="original">'
							+ str
							+ '</select></td></tr><tr><td align="right">替换为：</td><td align="left">'
							+ '<select onchange="showTips('+cid+')" style="width:220px;" name="new" id="new">'
							+ str1
							+ '<option selected="selected" hidden disabled value="-999">选择一个要替换的题型</option>'
							+ '</select></td></tr><tr><td colspan="2" id="tips" align="center" style="text-align:center;font-size:7px;color:blue">请选择同样类型的题型进行替换</td></tr></table>'
							+ '<input id="cid" name="cid" value="' + cid + '" type="hidden"/>'
							+ '<div style="width: 100%; text-align:center; margin-top:10px">'
							+ '<input type="button" class="l-btn-left" id="sure" value="确定" onclick="submitQTForm()"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
							+ '<input type="button" class="l-btn-left" value="取消" onclick="$(\'#win\').window(\'close\')"/></div></form>';
					const obj = $(winStr);
					$('#win').html('');
					obj.appendTo('#win');
					$('#win').window({
						width:350,
						height:160,
						modal:true,
						title:"课程："+cname+" 题型替换",
						collapsible:false,
						minimizable:false,
						maximizable:false,
						//content:winStr
					});
				}
			}
		});
		document.getElementById("sure").disabled=true;
	}

	function showTips(cid){

		if(document.getElementById("new").value=="-999"){
			document.getElementById("tips").innerText="请选择同样类型的题型进行替换";
			document.getElementById("tips").style.color="blue";
			document.getElementById("sure").disabled=true;
		}else if(document.getElementById("new").value == document.getElementById("original").value){
			document.getElementById("tips").innerText="不可以替换成同样的题型";
			document.getElementById("tips").style.color="orange";
			document.getElementById("sure").disabled=true;
		}else{
			$.ajax({
				url: '${pageContext.request.contextPath}/course/isSameQT',
				async: false,
				type: "POST",
				data: {"new":document.getElementById("new").value,"original":document.getElementById("original").value,"cid":cid},
				success: function (data) {
					if(data==1){
						document.getElementById("tips").innerText="点击确定进行替换";
						document.getElementById("tips").style.color="green";
						document.getElementById("sure").disabled=false;
					}else{
						document.getElementById("tips").innerText="两种题型类型不一致，无法替换";
						document.getElementById("tips").style.color="red";
						document.getElementById("sure").disabled=true;
					}
				}
			});
		}
	}

	function submitQTForm(){
		$.messager.defaults = { ok: "确定", cancel: "取消" };
		$.messager.confirm({
			width: '380',
			title: '提示',
			msg: '注意：题型替换操作无法撤回，是否继续?',
			fn: function (r) {
				if (r){
					$('#QTForm').form('submit', {
						url:'${pageContext.request.contextPath}/course/replaceQT',
						success:function(data){
							if(data>0){
								$('#win').window('close');
								toastr.success("题型替换成功！");
							}else{
								toastr.warning("题型替换失败！");
							}
						}
					});
				}
			}
		});
	}

	function delAll(cid){
		const params = {};
		params["cid"] = cid+"";
		params["permission"] = "question:delAll";
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					$.messager.confirm("提示",'是否要删除所有试题 ?',function(r){
						if (r){
							$.ajax({
								url: "${pageContext.request.contextPath}/question/delAll",
								async: false,
								type: "POST",
								data: { "cid":cid },
								success: function (data) {
									toastr.success("删除成功");
									$('#datalist').datagrid('reload');
								}
							});
						}
					});
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});

	}

	function workLoad(cid){
		const params = {};
		params["cid"] = cid;
		params["permission"] = "question:view";
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					openIframeDialog({
						title: '工作量统计',
						url: '${pageContext.request.contextPath}/question/inWorkLoad?c_id='+ cid,
						fit: true
					},0);
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});
	}

	function checkQuestionPermission(cid,permission,url){
		const params = {};
		params["cid"] = cid;
		params["permission"] = permission;
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					window.location.href = url;
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});
	}

	function checkQuestionVerifyPermission(cid,url){
		const params = {};
		params["cid"] = cid;
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionVerifyPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					window.location.href = url;
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});
	}

	function exportWorkLoad(isSelected){
		// -------- 0. 预处理：收集选择与筛选值（这部分保留你的原逻辑） --------
		let cidStr;
		if(isSelected===1){
			const rows = $('#datalist').datagrid('getSelections');
			if(!rows || rows.length===0){
				toastr.warning("请选中课程名单！");
				return;
			}
			if(rows.length>200){
				toastr.warning("最多选择200个课程！");
				return;
			}
			const list = [];
			for(let i=0; i<rows.length; i++){
				list.push(rows[i].CID);
			}
			cidStr = list.join(',');
		}
		const unitid = getFilterId('#unitFilter');
		const depid = getFilterId('#departmentFilter');
		const arrangeid = getFilterId('#arrangeFilter');

		const unitName = getFilterName('#unitFilter');
		const depName = getFilterName('#departmentFilter');
		const arrangeName = getFilterName('#arrangeFilter');

		// -------- 1. 基本配置 --------
		const BASE = '${pageContext.request.contextPath}';
		const URL_CHECK = BASE + '/question/checkTmpWorkloadExcelZip';
		const URL_EXPORT = BASE + '/question/exportWorkloadExcelZipAsync';
		const URL_DL_BASE = BASE + '/question/downloadWorkloadExcelZip?fileName=';

		// 轮询定时器（仅在进度存在时启用，每 5s 刷新）
		let wlTimer = null;
		function wlStartPolling(){
			wlStopPolling();
			wlTimer = setInterval(function(){
				if(!Swal.isVisible()){
					wlStopPolling();
					return;
				}
				wlRefreshStatus();
			}, 5000);
		}
		function wlStopPolling(){
			if(wlTimer){
				clearInterval(wlTimer);
				wlTimer = null;
			}
		}

		// -------- 2. 状态窗口：显示进度 + 历史文件 + 三个按钮 --------
		function wlBuildStatusHtml(res){
			let html = '';
			html += '<div id="wl-status-wrap">';

			// 进度条
			if(res && res.nowProgress && res.nowProgress.isRun === 1){
				let done = res.nowProgress.progressNum || 0;
				let total = res.nowProgress.total || 0;
				let percent = (total>0) ? Math.round(done/total*100) : 0;

				html += '<div class="wl-progress-block" style="margin-bottom:12px;">';
				html +=   '<div style="font-size:14px;margin-bottom:6px;">正在导出工作量…</div>';
				html +=   '<div class="progress-container" style="width:100%;height:10px;background:#eee;border-radius:4px;overflow:hidden;">';
				html +=     '<div id="wl-progress-bar" class="progress-bar" style="height:10px;width:'+percent+'%;"></div>';
				html +=   '</div>';
				html +=   '<div id="wl-progress-text" style="margin-top:6px;font-size:12px;color:#666;">'+done+'/'+total+'（'+percent+'%）</div>';
				html += '</div>';
			}else{
				html += '<div style="margin-bottom:12px;font-size:13px;color:#777;">当前没有进行中的导出任务。</div>';
			}

			// 历史文件列表
			let list = (res && res.historyFiles) ? res.historyFiles : [];
			html += '<div class="wl-history-block" style="text-align:left;">';
			html +=   '<div style="font-size:14px;margin:6px 0;">历史导出文件（今日）</div>';
			html +=   '<select id="wl-history-list" size="8" style="width:100%;max-height:220px;overflow:auto;">';
			if(list && list.length>0){
				for(let i=0;i<list.length;i++){
					let name = list[i] || '';
					html += '<option value="'+name+'">'+name+'</option>';
				}
			}else{
				html += '<option value="" disabled>暂无历史文件</option>';
			}
			html +=   '</select>';
			html +=   '<div style="margin-top:8px;font-size:12px;color:#999;">历史导出文件只保留一天。</div>';
			html += '</div>';

			html += '</div>';
			return html;
		}

		function wlOpenStatusModal(){
			$.post(URL_CHECK)
					.done(function(res){
						let running = !!(res && res.nowProgress && res.nowProgress.isRun===1);
						Swal.fire({
							title: '导出课程工作量 Excel 压缩包',
							html: '<div id="wl-status-box">'+ wlBuildStatusHtml(res) +'</div>',
							showDenyButton: true,     // 重新导出
							showCancelButton: true,   // 关闭
							confirmButtonText: '下载',
							denyButtonText: '新的导出',
							cancelButtonText: '关闭',
							allowOutsideClick: false,
							didOpen: function(){
								// 正在进行中 ⇒ 禁掉「重新导出」
								let denyBtn = Swal.getDenyButton();
								if(denyBtn){ denyBtn.disabled = running; }

								// 正在进行中 ⇒ 开始轮询；否则停止
								if(running){ wlStartPolling(); } else { wlStopPolling(); }
							},
							willClose: function(){
								wlStopPolling();
							}
						}).then(function(result){
							if(result.isConfirmed){
								let fn = $('#wl-history-list').val();
								if(!fn){
									toastr.warning('请先选择要下载的文件');
									wlOpenStatusModal();
									return;
								}
								wlDownload(fn);
							}else if(result.isDenied){
								wlOpenExportOptions();
							}
						});
					})
					.fail(function(){
						Swal.fire('出错啦','状态查询失败，请稍后重试','error');
					});
		}

		function wlRefreshStatus(){
			$.post(URL_CHECK)
					.done(function(res){
						// 重新渲染内部内容
						let box = $('#wl-status-box');
						if(box.length){
							box.html(wlBuildStatusHtml(res));
						}
						// 同步按钮状态与轮询
						let running = !!(res && res.nowProgress && res.nowProgress.isRun===1);
						let denyBtn = Swal.getDenyButton();
						if(denyBtn){ denyBtn.disabled = running; }
						if(running){ wlStartPolling(); } else { wlStopPolling(); }
					});
		}

		// -------- 3. 下载函数：从历史选择文件名直接调用下载接口 --------
		function wlDownload(fileName){
			// 弹出“准备下载”
			Swal.fire({
				title: '正在准备下载',
				html: '<div id="wl-dl-progress">请稍候…</div>',
				allowOutsideClick: false,
				allowEscapeKey: false,
				didOpen: function(){ Swal.showLoading(); }
			});

			$.ajax({
				url: URL_DL_BASE + encodeURIComponent(fileName),
				method: 'GET',
				xhrFields: { responseType: 'blob' },
				cache: false,
				xhr: function () {
					let xhr = $.ajaxSettings.xhr();
					if (xhr && xhr.addEventListener) {
						xhr.addEventListener('progress', function (e) {
							if (e.lengthComputable) {
								let percent = Math.floor((e.loaded / e.total) * 100);
								let el = document.getElementById('wl-dl-progress');
								if (el) el.textContent = '正在下载… ' + percent + '%';
							}
						});
					}
					return xhr;
				}
			}).done(function (data, textStatus, jqXHR) {
				// 文件名尝试从响应头解析
				let filename = fileName;
				let cd = jqXHR.getResponseHeader('Content-Disposition');
				if (cd) {
					let match = cd.match(/filename\*?=(?:UTF-8'')?("?)([^";]+)\1/i);
					if (match && match[2]) {
						try { filename = decodeURIComponent(match[2]); } catch (_){}
					}
				}
				let blob = new Blob([data], { type: 'application/zip' });
				let blobUrl = window.URL.createObjectURL(blob);
				let a = document.createElement('a');
				a.href = blobUrl;
				a.download = (filename && /\.zip$/i.test(filename)) ? filename : (filename + '.zip');
				document.body.appendChild(a);
				a.click();
				a.remove();
				window.URL.revokeObjectURL(blobUrl);
				Swal.close();
			}).fail(function (jqXHR) {
				Swal.close();
				let status = jqXHR.status;
				let msg = '下载失败，请稍后重试';
				if (status === 401 || status === 403) msg = '下载失败，没有权限。';
				else if (status === 404) msg = '未找到可下载的文件，请先生成压缩包后再试。';

				if (jqXHR.responseText && jqXHR.responseText.trim()) {
					msg = jqXHR.responseText.trim();
					toastr.error(msg);
				} else if (jqXHR.response && jqXHR.response instanceof Blob) {
					let reader = new FileReader();
					reader.onload = function () {
						let text = (reader.result || '').toString().trim();
						toastr.error(text || msg);
					};
					reader.onerror = function () { toastr.error(msg); };
					try { reader.readAsText(jqXHR.response, 'utf-8'); } catch (e) { toastr.error(msg); }
				} else {
					toastr.error(msg);
				}
				console.error('workload download error:', status);
			});
		}

		// -------- 4. 参数确认窗口：是否按筛选导出 + 可选起止日期 --------
		function wlOpenExportOptions(){
			// 展示用途：当前筛选名，空则显示“全部”
			let showUnit  = unitName  ? unitName  : '全部';
			let showDep   = depName   ? depName   : '全部';
			let showArr   = arrangeName ? arrangeName : '全部';

			let html = '';
			html += '<div style="text-align:left;">';

			html += '<div style="margin-bottom:8px;font-size:17px;">是否根据当前已筛选的 <b>授课单位、所属科室、适应层次</b> 导出？</div>';
			html += '<div style="margin:6px 0 10px 0;padding:8px;background:#f6f6f6;border-radius:6px;font-size:16px;line-height:1.6;">';
			html += '<div>授课单位：'+ showUnit +'</div>';
			html += '<div>所属科室：'+ showDep +'</div>';
			html += '<div>适应层次：'+ showArr +'</div>';
			html += '</div>';

			html += '<label style="display:inline-flex;align-items:center;margin-bottom:14px;">';
			html += '<input id="wl-use-filter" type="checkbox" checked="checked" style="margin-right:8px">';
			html += '<span style="font-size: 16px">使用以上筛选条件导出</span>';
			html += '</label>';

			html += '<label style="display:inline-flex;align-items:center;margin-bottom:14px;">';
			html += '<input id="only-total" type="checkbox" style="margin-right:8px">';
			html += '<span style="font-size: 16px">只导出汇总数据（只导出课程名、新增、更新）</span>';
			html += '</label>';

			html += '<div style="margin:8px 0;font-size:14px;">工作量起止日期</div>';
			html += '<div style="display:flex;gap:8px;align-items:center;margin-bottom:6px;">';
			html += '  <input id="wl-beginDate" type="date" class="swal2-input" style="width:46%;margin:0;font-size: 16px">';
			html += '  <span style="flex:0 0 auto;">—</span>';
			html += '  <input id="wl-endDate" type="date" class="swal2-input" style="width:46%;margin:0;font-size: 16px">';
			html += '</div>';
			html += '<div style="text-align:right;margin-top:4px;">';
			html += '  <button type="button" id="wl-clear-dates" class="swal2-styled" style="background:#e5e5e5;color:#333;">清空日期</button>';
			html += '</div>';

			// 若是按选中课程导出，给个提示
			if(isSelected===1){
				html += '<div style="margin-top:10px;font-size:12px;color:#999;">将按“所选课程”导出，筛选项仅用于展示。</div>';
			}
			html += '</div>';

			Swal.fire({
				title: '确认导出设置',
				html: html,
				showCancelButton: true,
				confirmButtonText: '开始导出',
				cancelButtonText: '取消',
				allowOutsideClick: false,
				didOpen: function(){
					$('#wl-clear-dates').on('click', function(){
						$('#wl-beginDate').val('');
						$('#wl-endDate').val('');
					});
				},
				preConfirm: function(){
					let b = $('#wl-beginDate').val();
					let e = $('#wl-endDate').val();
					if((b && !e) || (!b && e)){
						Swal.showValidationMessage('起止日期需同时选择或都不选');
						return false;
					}
					return {beginDate: b, endDate: e, useFilter: $('#wl-use-filter').is(':checked'), onlyTotal:$('#only-total').is(':checked')};
				}
			}).then(function(result){
				if(!result.isConfirmed){ return; }

				let val = result.value || {};
				let data = {
					cidStr: cidStr || '',
					unitid: unitid || '',
					depid: depid || '',
					arrangeid: arrangeid || ''
				};
				// 如果不使用筛选，则清空筛选 id
				if(!val.useFilter){
					data.unitid = '';
					data.depid = '';
					data.arrangeid = '';
				}
				if(val.onlyTotal){
					data.onlyTotal = "onlyTotal";
				}
				// 日期：两者都选才传；否则都不传
				if(val.beginDate && val.endDate && isValidISODateStr(val.beginDate) && isValidISODateStr(val.endDate)){
					data.beginDate = val.beginDate;
					data.endDate   = val.endDate;
				}

				// 提交异步导出
				$.ajax({
					url: URL_EXPORT,
					type: 'POST',
					data: data,
					cache: false
				}).done(function(resp){
					if(typeof resp === 'string' && resp.trim() === 'success'){
						Swal.fire({
							title: '已提交生成任务',
							text: '系统正在后台生成压缩包，可在状态窗口查看进度',
							icon: 'success',
							timer: 1500,
							showConfirmButton: false
						});
						// 回到状态窗口查看进度
						setTimeout(function(){ wlOpenStatusModal(); }, 1600);
					}else{
						// 可能返回“已有一个导出任务，请稍后”或“无权限”等
						let msg = (typeof resp === 'string' && resp.trim()) ? resp.trim() : '服务器返回异常，请稍后重试';
						Swal.fire('提示', msg, 'warning').then(function(){
							wlOpenStatusModal();
						});
					}
				}).fail(function(jqXHR){
					let status = jqXHR.status;
					let msg = (jqXHR.responseText && jqXHR.responseText.trim()) ? jqXHR.responseText.trim() : '请求失败' + (status ? '（'+status+'）' : '');
					Swal.fire('出错啦', msg, 'error');
				});
			});
		}

		// -------- 5. 入口：先打开状态窗口 --------
		wlOpenStatusModal();
	}

	function distributionStatistics(cid){
		const params = {};
		params["cid"] = cid;
		params["permission"] = "question:view";
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					toastr.warning("获取分布数据需要一点时间，请耐心等待");
					let url = "${pageContext.request.contextPath}/question/distributionStatistics?c_id=" + cid;
					openIframeDialog({
						title: '分布统计',
						url: url,
						fit: true
					},0);
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});

	}

	function exportAll(cid){
		const params = {};
		params["cid"] = cid+"";
		params["permission"] = "question:export";
		$.ajax({
			contentType: "application/json; charset=utf-8",
			url: '${pageContext.request.contextPath}/question/checkQuestionPermission',
			async: false,
			type: "POST",
			data: JSON.stringify(params),
			success: function (data) {
				if(data==1){
					let url = "${pageContext.request.contextPath}/question/exportAll?cid="+cid;
					window.location.href = url;
				}else if(data==0){
					toastr.warning("无相关权限");
				}else{
					toastr.error("登录超时，请重新登录！");
				}
			}
		});
	}
</script>