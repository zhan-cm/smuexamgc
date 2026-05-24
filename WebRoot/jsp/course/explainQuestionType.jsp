<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
	tr{
		line-height: 20px;
	}
	.qcontent{
		height: 40px;
		overflow:hidden;
	}
	.qdesc{
		border:1px solid #ccc;
		width:100%;
		white-space:normal;
	}
</style>
<div id="dlg-toolbar" style="height:26px;">
	<input type="hidden" id="cid" name="cid" value="${cid}"/>
	<table cellpadding="0" cellspacing="0" style="width:100%">
		<a href="javascript:void(0);" onclick="cancelEasyUiFrame(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
		<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" href="javascript:void(0);" onclick="updateQuestionType()">保存</a>
		<span id="tips" style="color:red; float:right;"></span>
	</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
	$(function () {
		var atlist;
		$.ajax({
			url:'${pageContext.request.contextPath}/course/getAnswerType',
			type:'POST',
			async:false,
			success: function(data){
				atlist = data;
			}
		});
		$("#datalist").datagrid({
			fit:true,
			striped: true,
			singleSelect: false,
			url:'${pageContext.request.contextPath}/course/getExplainQuestionType?cid='+$("#cid").val(),
			pagination:true,
			rownumbers: false,
			pageSize: 100,
			pageList:[20,40,60,80,100,120,140,160,180,200],
			fitColumns: true,
			toolbar: '#dlg-toolbar',
			pagination: true,
			columns:[[
				{field:'ID',title:'主键',hidden:true,formatter:function(value,row,index){
						return '<input type="hidden" name="ids" value="'+row.ID+'">';
					}},
				{field:'NAME',title:'题型名',width:25,align:'left',formatter:function(value,row,index){
						return '<input type="text" class="qdesc" id="qtname_'+row.ID+'"contenteditable="plaintext-only" value="'+row.NAME+'"/>';
					},sortable:true},
				{field:'E_QTNAME',title:'英文题型名',width:45,align:'left',formatter:function(value,row,index){
						var e_qtname = row.E_QTNAME;
						if(typeof(e_qtname) === "undefined"||e_qtname==="undefined"||e_qtname===null||e_qtname==="null"){
							e_qtname = "";
						}
						return '<input type="text" class="qdesc" id="e_qtname_'+row.ID+'"contenteditable="plaintext-only" value="'+e_qtname+'"/>';
					},sortable:true},
				{field:'ISCON',title:'是否串题',width:25,align:'left',formatter:function(value,row,index){
						var qcount=row.qcount;
						var iscon;
						if(qcount==0){
							iscon = '<select id="is_con_'+row.ID+'" class="easyui-combobox" name="is_con" style="width:100%">';
							var con_name = new Array("串题","非串题");
							var con_id = new Array(1,0);
							for(var i=0;i<con_name.length;i++){
								if(con_id[i]==row.ISCON){
									iscon += '<option value='+con_id[i]+' selected="selected">'+con_name[i]+'</option>';
								}else{
									iscon += '<option value='+con_id[i]+'>'+con_name[i]+'</option>';
								}
							}
							iscon += '</select>';
						}else{
							iscon = '<select id="is_con_'+row.ID+'" class="easyui-combobox" name="is_con" style="width:100%" disabled="disabled">';
							if(row.ISCON==1){
								iscon += '<option value="1" selected="selected">串题</option>';
							}else{
								iscon += '<option value="0" selected="selected">非串题</option>';
							}
							iscon += '</select>';
						}

						return iscon;
					}},
				{field:'ATNAME',title:'答案分类',width:25,align:'left',formatter:function(value,row,index){
						var atname = '<select id="at_name_'+row.ID+'" class="easyui-combobox" name="at_name" style="width:100%">'
						if(row.ANSWERTYPEID<5){
							for(var j=0;j<atlist.length;j++){
								if(atlist[j].ID<5){
									if(row.ANSWERTYPEID==atlist[j].ID){
										atname += '<option value='+atlist[j].ID+' selected="selected">'+atlist[j].NAME+'</option>';
									}else{
										atname += '<option value='+atlist[j].ID+'>'+atlist[j].NAME+'</option>';
									}
								}
							}
						}else if(row.ANSWERTYPEID>=5&&row.ANSWERTYPEID<=7){
							for(var j=0;j<atlist.length;j++){
								if(atlist[j].ID==5||atlist[j].ID==6||atlist[j].ID==7){
									if(row.ANSWERTYPEID==atlist[j].ID){
										atname += '<option value='+atlist[j].ID+' selected="selected">'+atlist[j].NAME+'</option>';
									}else{
										atname += '<option value='+atlist[j].ID+'>'+atlist[j].NAME+'</option>';
									}
								}
							}
						}else{
							for(var j=0;j<atlist.length;j++){
								if(atlist[j].ID>7){
									if(row.ANSWERTYPEID==atlist[j].ID){
										atname += '<option value='+atlist[j].ID+' selected="selected">'+atlist[j].NAME+'</option>';
									}else{
										atname += '<option value='+atlist[j].ID+'>'+atlist[j].NAME+'</option>';
									}
								}
							}
						}

						atname += '</select>';
						return atname;
					}},
				{field:'QDESC',title:'题型说明',width:110,align:'left',formatter:function(value,row,index){
						var qdesc=row.QDESC;
						if(typeof(qdesc)=='undefined'||qdesc==='undefined'||qdesc==null||qdesc==='null'){
							qdesc="";
						}
						return '<textarea class="qdesc" id="qdesc_'+row.ID+'"contenteditable="plaintext-only">'+qdesc+'</textarea>';
					}},
				{field:'E_QTDESC',title:'英文说明',width:110,align:'left',formatter:function(value,row,index){
						var e_qtdesc=row.E_QTDESC;
						if(typeof(e_qtdesc)=='undefined'||e_qtdesc==='undefined'||e_qtdesc==null||e_qtdesc==='null'){
							e_qtdesc="";
						}
						return '<textarea class="qdesc" id="e_qtdesc_'+row.ID+'"contenteditable="plaintext-only">'+e_qtdesc+'</textarea>';
					}},
				{field:'XXDF',title:'选项得分设置',width:75,align:'left',formatter:function(value,row,index){
					let rtn = '<select id="xxdf_'+row.ID+'" class="easyui-combobox" name="xxdf" style="width:100%">';
					const selectOptions = new Array({name:"无", xxdf:"0"},{name:'多选题少选得一半分，错选漏选不得分', xxdf:"2"});
					for(let i=0;i< selectOptions.length ; i++){
						let selected = row.XXDF==selectOptions[i].xxdf?'selected="selected"':'';
						rtn += '<option value="'+selectOptions[i].xxdf+'" '+selected+' >'+selectOptions[i].name+'</option>';
					}
					rtn += '</select>';
					return rtn;
				}},
				{field:'SXB',title:'允许手写板',width:30,align:'left', hidden: ${sxb_switch eq 0}, formatter:function(value,row,index){
					let sxb = '<select id="sxb_'+row.ID+'" class="easyui-combobox" name="sxb" style="width:100%">';
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
				{field:'mediaset',title:'多媒体播放设定',width:50,align:'left', formatter:function(value,row,index){
					let rtn = '<select id="mediaSet_'+row.ID+'" class="easyui-combobox" name="mediaSet" style="width:100%">';
					const selectOptions = new Array({name:"正常", mediaSet:"0"},{name:'不可重播、加速、拖动', mediaSet:"1"});
					for(let i=0;i< selectOptions.length ; i++){
						let selected = row.MEDIASET==selectOptions[i].mediaSet?'selected="selected"':'';
						rtn += '<option value="'+selectOptions[i].mediaSet+'" '+selected+' >'+selectOptions[i].name+'</option>';
					}
					rtn += '</select>';
					return rtn;
				}},
			]]
		});

		/* var pager = $("#datalist").datagrid("getPager");
        pager.pagination({
            total:dList.length,
            onSelectPage:function (pageNo, pageSize) {
                var start = (pageNo - 1) * pageSize;
                var end = start + pageSize;
                $("#datalist").datagrid("loadData", dList.slice(start, end));
                pager.pagination('refresh', {
                    total:dList.length,
                    pageNumber:pageNo
                });
            }
        });  */
	});

	function refresh(){
		$('#datalist').datagrid('reload');
	}

	function safeVal(id) {
		const $el = $('#' + id);
		return $el.length ? String($el.val() ?? '') : '';
	}

	// 把空串统一替换为 NBSP（\u00A0）；避免 split 丢尾
	function fillEmpty(arr) {
		return arr.map(v => (v === '' ? '\u00A0' : v));
	}

	function updateQuestionType(){
		const rows = $("#datalist").datagrid("getRows");
		// —— 收集 —— //
		const ids      = rows.map(r => r.ID);
		const atids    = rows.map(r => safeVal("at_name_"+r.ID));
		const iscons   = rows.map(r => safeVal("is_con_"+r.ID));
		const qtnames  = rows.map(r => safeVal("qtname_"+r.ID));
		const e_qtnames= rows.map(r => safeVal("e_qtname_"+r.ID));
		const sxbs     = rows.map(r => safeVal("sxb_"+r.ID));
		const xxdfs    = rows.map(r => safeVal("xxdf_"+r.ID));
		const mediasets= rows.map(r => safeVal("mediaSet_"+r.ID));

		const descs    = rows.map(r => safeVal("qdesc_"+r.ID));
		const e_qtdescs= rows.map(r => safeVal("e_qtdesc_"+r.ID));

		const qtnamesCsv   = fillEmpty(qtnames).join(',');
		const e_qtnamesCsv = fillEmpty(e_qtnames).join(',');
		const descsCsv     = fillEmpty(descs).join('!@#');
		const e_qtdescsCsv = fillEmpty(e_qtdescs).join('!@#');

		const idsCsv    = ids.join(',');
		const atidsCsv  = atids.join(',');
		const isconsCsv = iscons.join(',');
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
			url: '${pageContext.request.contextPath}/course/updateQuestionType',
			type: 'POST',
			data: {
				ids: idsCsv,
				iscon: isconsCsv,
				atid: atidsCsv,
				desc: descsCsv,
				e_qtdesc: e_qtdescsCsv,
				qtname: qtnamesCsv,
				e_qtname: e_qtnamesCsv,
				sxb: sxbsCsv,
				xxdf: xxdfsCsv,
				mediaSet: mediaSetsCsv
			},
			success: function (data) {
				if (data == "-1") {
					$("#tips").text("操作失败，题型名重复或为空！");
				} else if (data == "1") {
					$("#tips").text("操作成功，需要保存试题修改后才能修改成功！");
				}
			}
		});
	}

</script>	

