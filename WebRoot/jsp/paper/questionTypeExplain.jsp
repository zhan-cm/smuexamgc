<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
	tr{
		line-height: 20px;
	}
	.qdesc{
		border:1px solid #ccc;
		width:100%;
		white-space:normal;
		height: 23px;
		resize: none;
	}
</style>
<div id="dlg-toolbar" style="height:26px;">
	<input type="hidden" id="ei_id" name="ei_id" value="${ei_id}"/>
	<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
		<tr>
			<td style="padding-left:2px">
				<a href="javascript:void(0);" onclick="cancelEasyUiFrame(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveAndSubmit()">保存提交</a>
			</td>
		</tr>
	</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
	var ei_id = $("#ei_id").val();
	$(document).ready(function(){
		$.parser.parse($("#searchpage"));//重新渲染
		$('#datalist').datagrid({
			fit:true,
			striped: true,
			singleSelect: false,
			url:'${pageContext.request.contextPath}/paper/getQuestionTypeExplain?ei_id=' + ei_id,
			pagination: true,
			pageSize: 20,
			pageList:[10,10*2,10*3],
			fitColumns: true,
			//queryParams:queryParams,
			toolbar:'#dlg-toolbar',
			//sortName: 'QID',
			columns:[[
				//{field:'QTID',checkbox:true},
				{field:'QTNAME',title:'题型',width:40, align:'left', sortable:true},
				{field:'E_QTNAME',title:'英文题型',width:60, align:'left', sortable:true,formatter:function(value,row,index){
					let e_qtname = row.E_QTNAME;
					if(typeof e_qtname == "undefined"){
						e_qtname = "";
					}
					return '<textarea class="qdesc" id="e_qtname_'+row.QTID+'"contenteditable="plaintext-only">'+e_qtname+'</textarea>';
				},sortable:true},
				{field:'QTDESC',title:'题型说明',width:150,align:'left',formatter:function(value,row,index){
					let qdesc=row.QTDESC;
					if(typeof qdesc=='undefined'){
						qdesc="";
					}
					return '<textarea class="qdesc" id="qdesc_'+row.QTID+'"contenteditable="plaintext-only">'+qdesc+'</textarea>';
				}},
				{field:'E_QTDESC',title:'英文说明',width:150,align:'left',formatter:function(value,row,index){
					let e_qtdesc=row.E_QTDESC;
					if(typeof e_qtdesc=='undefined'){
						e_qtdesc="";
					}
					return '<textarea class="qdesc" id="e_qtdesc_'+row.QTID+'"contenteditable="plaintext-only">'+e_qtdesc+'</textarea>';
				}},
				{field:'SXB',title:'允许手写板',width:30,align:'left',hidden: ${sxb_switch eq 0}, formatter:function(value,row,index){
					let sxb = '<select id="sxb_'+row.QTID+'" class="easyui-combobox" name="sxb" style="width:100%">';
					let con_name = new Array("是","否");
					let con_id = new Array(1,0);
					for(let i=0;i<con_name.length;i++){
						if(con_id[i]==row.SXB){
							sxb += '<option value='+con_id[i]+' selected="selected">'+con_name[i]+'</option>';
						}else{
							sxb += '<option value='+con_id[i]+'>'+con_name[i]+'</option>';
						}
					}
					sxb += '</select>';
					return sxb;
				}},
				{field:'XXDF',title:'选项得分设置',width:75,align:'left',formatter:function(value,row,index){
					let rtn = '<select id="xxdf_'+row.QTID+'" class="easyui-combobox" name="xxdf" style="width:100%">';
					const selectOptions = new Array({name:"无", xxdf:"0"},{name:'多选题少选得一半分，错选漏选不得分', xxdf:"2"});
					for(let i=0;i< selectOptions.length ; i++){
						let selected = row.XXDF==selectOptions[i].xxdf?'selected="selected"':'';
						rtn += '<option value="'+selectOptions[i].xxdf+'" '+selected+' >'+selectOptions[i].name+'</option>';
					}
					rtn += '</select>';
					return rtn;
				}},
				{field:'mediaset',title:'多媒体播放设定',width:50,align:'left', formatter:function(value,row,index){
					let rtn = '<select id="mediaSet_'+row.QTID+'" class="easyui-combobox" name="mediaSet" style="width:100%">';
					const selectOptions = new Array({name:"正常", mediaSet:"0"},{name:'不可重播、加速、拖动', mediaSet:"1"});
					for(let i=0;i< selectOptions.length ; i++){
						let selected = row.MEDIASET==selectOptions[i].mediaSet?'selected="selected"':'';
						rtn += '<option value="'+selectOptions[i].mediaSet+'" '+selected+' >'+selectOptions[i].name+'</option>';
					}
					rtn += '</select>';
					return rtn;
				}},
			]],
			onLoadSuccess:function(data){

			}
		});

		var buttons =[];

		var p = $('#datalist').datagrid('getPager');
		$(p).pagination({buttons: buttons});
	});

	function safeVal(id) {
		const $el = $('#' + id);
		return $el.length ? String($el.val() ?? '') : '';
	}

	// 把空串统一替换为 NBSP（\u00A0）；避免 split 丢尾
	function fillEmpty(arr) {
		return arr.map(v => (v === '' ? '\u00A0' : v));
	}

	function saveAndSubmit(){
		const rows = $("#datalist").datagrid("getRows");
		// —— 收集 —— //
		const ids      = rows.map(r => r.QTID);
		const e_qtnames= rows.map(r => safeVal("e_qtname_"+r.QTID));
		const sxbs     = rows.map(r => safeVal("sxb_"+r.QTID));
		const xxdfs    = rows.map(r => safeVal("xxdf_"+r.QTID));
		const mediasets= rows.map(r => safeVal("mediaSet_"+r.QTID));

		const descs    = rows.map(r => safeVal("qdesc_"+r.QTID));
		const e_qtdescs= rows.map(r => safeVal("e_qtdesc_"+r.QTID));

		const e_qtnamesCsv = fillEmpty(e_qtnames).join(',');
		const descsCsv     = fillEmpty(descs).join('!@#');
		const e_qtdescsCsv = fillEmpty(e_qtdescs).join('!@#');

		const idsCsv    = ids.join(',');
		const sxbsCsv   = sxbs.join(',');
		const xxdfsCsv  = xxdfs.join(',');
		const mediaSetsCsv  = mediasets.join(',');

		const cnRe = /[\u4e00-\u9fa5]/;
		if (e_qtnames.some(v => cnRe.test(v))) {
			toastr.error('英文名禁止中文!');
			return false;
		}
		if (e_qtdescs.some(v => cnRe.test(v))) {
			toastr.error('英文说明禁止中文!');
			return false;
		}
		$.ajax({
			url: '${pageContext.request.contextPath}/paper/updateExamQuestionType',
			type: 'POST',
			data: {
				ids: idsCsv,
				desc: descsCsv,
				e_qtdesc: e_qtdescsCsv,
				e_qtname: e_qtnamesCsv,
				sxb: sxbsCsv,
				xxdf: xxdfsCsv,
				mediaSet: mediaSetsCsv,
				eid: $("#ei_id").val()
			},
			success:function(data){
				$("#datalist").datagrid("reload");
				toastr.success("题型修改成功！");
			}
		})
		//console.log(entities);
	}
</script>	

