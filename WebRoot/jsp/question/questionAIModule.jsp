<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<html>
<head>
    <title>${cname} 试题管理 AI模块</title>
    <style>
        .qlimit{
            padding:2px .8px;
            -moz-border-radius: 3px;
            -webkit-border-radius: 3px;
            border-radius: 3px;
            width:105px;
            border-color: #95B8E7;
            margin:0 2.2px;
        }
        tr{
            line-height: 20px;
        }
        #question-table{
            width: 100%;
            vertical-align: middle;
            text-align: center;
            border-spacing: 10px;
        }

        #question-table th{
            border-bottom: 1px solid black;
            padding-bottom: 5px;
        }
        #question-table td{
            white-space: nowrap;
        }
        #question-table td:first-child{
            text-align: left;
        }

        .question-type-select{
            font-size: 16px;
        }
        .theme-select, .theme-select2, .theme-select3{
            max-width: 350px;
            font-size: 16px;
        }
        .select-num{
            font-size: 17px;
            width: 70px;
        }
        .btn-icon{
            width: 25px;
            height: 25px;
            margin: 2px 10px;
        }
        .add-row, .remove-row{
            background-color: white;
            border: none;
        }
        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #1c7430;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            animation: spin 1s linear infinite, fade 1s ease-out infinite;
            display: inline-block;
            margin: 0px 3px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes fade {
            0% {
                box-shadow: 0 0 8px green;
            }
            100% {
                box-shadow: 0 0 20px rgba(0, 255, 0, 0);
            }
        }

        .dropzone-container {
            border: 2px dashed #ccc;
            border-radius: 8px;
            padding: 20px;
            margin: 10px 0;
        }

        .dz-message {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin: 2em 0;
        }

        .dropzone .dz-preview .dz-remove {
            color: #ff4444;
            font-size: 14px;
        }

        .dropzone .dz-preview:hover .dz-remove {
            text-decoration: underline;
        }

        .dz-progress {
            display: none !important;
        }

        .stats-cell {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0;
            margin: 0;
            width: 100%;
        }

        #stats-container {
            display: flex;
            align-items: center;
        }

        .spinner {
            width: 24px;
            height: 24px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;  /* 文本间距 */
        }

        #loading-text {
            font-size: 14px;
            color: #333;
            white-space: nowrap;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to   { transform: rotate(360deg); }
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/sweetalert2.min.css">
    <link href="${pageContext.request.contextPath}/styles/dropzone/5.9.3/dropzone.min.css" rel="stylesheet" />
</head>
<body>
<div id="dlg-toolbar" >
<input id="cid" value="${cid}" type="hidden"/>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
    <tr>
        <th style="text-align:center"><h3>《${cname}》试题管理 AI模块</h3></th>
    </tr>
    <tr id="taskTips" style="display: none;">
        <td style="text-align:center">
            <span style="color: #1c7430;font-size: 14px;">已有AI任务运行中</span>
            <div class="spinner"></div>
            <span style="color: #0a6bce;font-size: 13px;">（注：一个课程同时只能有一个AI任务）</span>
        </td>
    </tr>
</table>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
    <tr>
        <td>
            <a href="javascript:void(0);" onclick="cancelEasyUiFrame(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
            <a href="javascript:void(0);" onclick="createQuestionWindow()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">AI生成试题</a>
            <%--<a href="javascript:void(0);" onclick="createRandomQuestionWindow()" class="easyui-linkbutton" data-options="iconCls:'icon-book_add',plain:true">AI随机大批量生成试题</a>--%>
            <a href="javascript:void(0);" onclick="createImportWindow()" class="easyui-linkbutton" data-options="iconCls:'icon-package_in',plain:true">AI导入word试题（实验版）</a>
        </td>
    </tr>
    <tr>
    <tr>
        <td class="stats-cell">
            <!-- 左侧按钮组 -->
            <div class="left-buttons">
                <a href="javascript:void(0);" onclick="selectQidsToUse()"
                   class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true">
                    选用选定试题
                </a>
                <a href="javascript:void(0);" onclick="deleteSelected()"
                   class="easyui-linkbutton" data-options="iconCls:'icon-delete',plain:true">
                    删除选定试题
                </a>
            </div>

            <!-- 右侧：统计框 -->
            <div id="stats-container">
                <div class="spinner"></div>
                <span id="loading-text">统计数据加载中.</span>
            </div>
        </td>
    </tr>

    </tr>
</table>
<table style="border-collapse:collapse; padding:0; margin:0;width: 100%">
    <tr>
        <td>
            <select id="theme1List" name="themeList" class="qlimit" onchange="selectFilter()">
                <option value="">加载中...</option>
            </select>
            <select id="theme2List" name="theme2List" class="qlimit" style="display: none" onchange="selectFilter()">
                <option value="">加载中...</option>
            </select>
            <select id="theme3List" name="theme3List" class="qlimit" style="display: none" onchange="selectFilter()">
                <option value="">加载中...</option>
            </select>
            <select id="questionTypeList" name="questionTypeList" class="qlimit" onchange="selectFilter()">
                <option value="">加载中...</option>
            </select>
            <select id="sourceList" name="sourceList" class="qlimit" onchange="selectFilter()">
                <option value="">全部来源</option>
                <option value="0">智能AI生成</option>
                <option value="1">智能word导入</option>
            </select>
            <select id="stateList" name="stateList" class="qlimit" onchange="selectFilter()">
                <option value="">不限采用</option>
                <option value="0">未采用</option>
                <option value="1">已采用</option>
            </select>
            <input class="easyui-searchbox" data-options="prompt:'请输入查询内容',menu:'#mm',searcher:doSearch" style="width:326px;"/>
            <div id="mm">
                <div data-options="name:'question'">题目查询</div>
                <div data-options="name:'teacher'">题目录入者查询</div>
            </div>
            <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
        </td>
    </tr>
</table>
</div>
<div id="datalist"></div>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/js/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/styles/dropzone/5.9.3/dropzone.min.js"></script>
<script type="text/javascript">
    var cid = $("#cid").val();
    var pageNumber = 1;
    var pageSize = 100;
    var themeTree = [];
    var questionType = [];
    var refreshInterval = null;

    $(document).ready(function(){
        getAIQuestionUsedStatus();
        getCourseQuestionAIModuleInfo();
        getIsLoadingQuestion();
        $('#datalist').datagrid({
            fit:false,
            striped: true,
            singleSelect: false,
            url:'${pageContext.request.contextPath}/intelliQuestion/getGeneratedQuestionByCid',
            pagination: true,
            rownumbers: true,
            width:'100%',
            pageSize: pageSize,
            pageNumber:pageNumber,
            pageList:[100,200,300,500],
            fitColumns: true,
            queryParams: {
                cid:cid
            },
            toolbar:'#dlg-toolbar',

            columns:[[
                {field:'qid',checkbox:true},
                {field:'qtname',title:'题型',width:15,align:'left',formatter:function(value,row,index){
                    return row.qtname;
                }},
                {field:'themename',title:'主题词',width:25,align:'left',formatter:function(value,row,index){
                    let themename = row.t1name;
                    if(row.t2name){
                        themename += '/'+row.t2name;
                        if(row.t3name){
                            themename += '/'+row.t3name;
                        }
                    }
                    return '<div style="white-space: pre-wrap;">'+themename+'</div>';
                }},
                {field:'content',title:'题目',width:95,align:'left',formatter:function(value,row,index){
                    let answer = '';
                    if(row.atid==5 || row.atid==6 ||row.atid==7 ||row.atid==11 ||row.atid==12 ||row.atid==13){
                        answer = '答案：'+row.answer[0].CONTENT_6;
                    }else if(row.atid==4){
                        answer = '选项：\nA.对 \nB.错 \n\n答案：\n';
                        let answerContent = row.answer[0].CONTENT;
                        if(answerContent==="true"){
                            answerContent = "对";
                        }else if(answerContent==="false"){
                            answerContent = "错";
                        }
                        answer += answerContent==="对"?"A":"B";
                    }else{
                        answer = '选项：\n';
                        for(let i=0;i<row.answer.length;i++){
                            let answerContent = row.answer[i].CONTENT;
                            answer += String.fromCharCode(65 + i) +'. '+answerContent+'\n';
                        }
                        answer += '\n答案：\n';
                        for(let i=0;i<row.answer.length;i++){
                            let ansArray = row.answerid.split(",");
                            for(let j=0;j<ansArray.length;j++){
                                if(ansArray[j] == row.answer[i].AID){
                                    answer += String.fromCharCode(65 + i);
                                }
                            }
                        }

                    }
                    if(row.ismain===1){
                        return '<div style="white-space: pre-wrap">'+row.content+'</div><br>' + '<div style="white-space: pre-wrap;color: #0a76e5">（串题题干无答案）</div>';
                    }
                    return '<div style="white-space: pre-wrap">'+row.content+'</div><br>' + '<div style="white-space: pre-wrap;color: #0a76e5">'+answer+'</div>';
                }},
                {field:'answerExplain',title:'答案解释',width:55,align:'left',formatter:function(value,row,index){
                    if(!row.answerexplain){
                        return '';
                    }
                    return '<div style="white-space: pre-wrap">'+row.answerexplain+'</div>';
                }},
                {field:'creatorname',title:'创建人',width:15,align:'center',formatter:function(value,row,index){
                        return '<div>'+row.creatorname+'</div>';
                    }},
                {field:'addtime',title:'创建时间',width:15,align:'center',formatter:function(value,row,index){
                    let showtime = formatDate(row.addtime).split(" ");
                    return '<div>'+showtime[0]+'</div><div>'+showtime[1]+'</div>';
                }},
                {field:'source',title:'创建方式',width:15,align:'center',formatter:function(value,row,index){
                    let source = row.source==0?"智能AI生成":"智能word导入";
                    let state = row.state==0?"<span>（未采用）</span>":"<span style='color: red'>（已采用）</span>";
                    return '<div>'+source+'</div><div>'+state+'</div>';
                }},
                {field:'opration',title:'操作',width:20,align:'center',formatter:function(value,row,index){
                        let s1 = `<a href="javascript:void(0)" class="editcls1 easyui-tooltip" title="选用试题"
                            onclick="selectQidToUse(\${row.qid},\${row.state},'\${row.answerid}','\${row.mqid}',\${row.ismain})"></a>`;
                        let s2 = `<a href="javascript:void(0)" class="editcls2 easyui-tooltip" title="删除试题" onclick="deleteQid(\${row.qid},\${row.ismain})"></a>`;
                    return s1+s2;
                }}
            ]],
            onLoadSuccess:function(data){
                $('.editcls1').linkbutton({text:'',iconCls:'icon-ok',plain:true});
                $('.editcls2').linkbutton({text:'',iconCls:'icon-no',plain:true});
            }
        });

    });

    function getCourseQuestionAIModuleInfo(){
        $.ajax({
            url: "${pageContext.request.contextPath}/course/getCourseQuestionAIModuleInfo",
            async: true,
            type: "POST",
            data: {cid:cid},
            success: function(rs){
                themeTree = rs.themeTree;
                populateSelect($("#theme1List"), themeTree, "全部主题词一");
                $("#theme1List").change(function () {
                    const selectedId = $(this).val();
                    if (selectedId === "") {
                        // 选择"全部主题词"，隐藏下一级
                        resetSelect($("#theme2List"), "全部主题词二");
                        resetSelect($("#theme3List"), "全部主题词三");
                    } else {
                        const childThemes = findChildren(selectedId);
                        populateSelect($("#theme2List"), childThemes, "全部主题词二");
                        resetSelect($("#theme3List"), "全部主题词三");
                    }
                });
                $("#theme2List").change(function () {
                    const selectedId = $(this).val();
                    if (selectedId === "") {
                        resetSelect($("#theme3List"), "全部主题词三");
                    } else {
                        const childThemes = findChildren(selectedId);
                        populateSelect($("#theme3List"), childThemes, "全部主题词三");
                    }
                });

                questionType = rs.courseQuestionType.filter(
                    item =>
                        item.ATID !== '12'
                        && !item.QTNAME.includes("视频")
                        && !item.QTNAME.includes("口语")
                        && !item.QTNAME.includes("读图")
                        && !item.QTNAME.includes("填图")
                        && !item.QTNAME.includes("听力")
                        && !item.QTNAME.includes("V型题")
                );
                $("#questionTypeList").empty();
                $("#questionTypeList").append(`<option value="">全部题型</option>`);
                if (questionType.length > 0) {
                    questionType.forEach((qt) => {
                        $("#questionTypeList").append(`<option value="\${qt.QTID}">\${qt.QTNAME}</option>`);
                    });
                    $("#questionTypeList").show(); // 显示下拉菜单
                } else {
                    $("#questionTypeList").hide(); // 如果没有子节点，隐藏下拉菜单
                }
            }
        });
    }

    function findChildren(parentId) {
        const findNodes = (nodes) => {
            let result = [];
            for (let node of nodes) {
                if (node.id == parentId) {
                    result = node.childList || [];
                }
                if (node.childList && Array.isArray(node.childList)) {
                    result = result.concat(findNodes(node.childList));
                }
            }
            return result;
        };
        const children = findNodes(themeTree);
        return children;
    }


    function populateSelect($select, themes, defaultOption) {
        $select.empty();
        $select.append(`<option value="">\${defaultOption}</option>`);
        if (themes.length > 0) {
            themes.forEach((theme) => {
                $select.append(`<option value="\${theme.id}">\${theme.name}</option>`);
            });
            $select.show();
        } else {
            $select.hide();
        }
    }

    function resetSelect($select, defaultOption) {
        $select.empty();
        $select.append(`<option value="">\${defaultOption}</option>`);
        $select.hide();
    }

    function createQuestionWindow() {
        if (themeTree.length === 0 || questionType.length === 0) {
            toastr.warning("主题词或题型参数尚未被加载");
            return;
        }
        const theme1List = themeTree;
        const questionTypeList = questionType;

        let tableHtml = `
    <table class="table table-striped table-bordered" id="question-table">
        <thead>
            <tr>
                <th>选择主题词</th>
                <th>选择题型</th>
                <th><div>题目数量</div><div style="font-size:12px;color:blue">（串题指主题干数量）</div></th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <tr class="question-row" data-index="0">
                <td>
                    <select class="theme-select form-control" data-index="0">
                        <option value="">选择主题词一</option>
                    </select>
                    <select class="theme-select2 form-control" data-index="0" style="display:none">
                        <option value="">选择主题词二</option>
                    </select>
                    <select class="theme-select3 form-control" data-index="0" style="display:none">
                        <option value="">选择主题词三</option>
                    </select>
                </td>
                <td>
                    <select class="question-type-select form-control" data-index="0">
                        <option value="">选择题型</option>
                    </select>
                </td>
                <td>
                    <input type="number" class="form-control select-num" data-index="0" min="0" step="1" value="0" />
                </td>
                <td>
                    <button class="add-row" data-index="0">
                        <img class="btn-icon" src="${pageContext.request.contextPath}/styles/images/svg/add-blue-circle.svg">
                    </button>
                    <button class="remove-row" data-index="0">
                        <img class="btn-icon" src="${pageContext.request.contextPath}/styles/images/svg/remove-blue-circle.svg">
                    </button>
                </td>
            </tr>
        </tbody>
        <tfoot>
            <tr><td colspan="4" style="border-top: 1px solid;padding-top:10px"><span style="font-weight:bold;margin-right:8px">题量总数</span><input type="text" class="form-control" id="total-count" disabled /></td></tr>
        </tfoot>
    </table>`;

        Swal.fire({
            title: '选择生成试题的参数',
            html: tableHtml,
            showCancelButton: true,
            confirmButtonText: '开始生成',
            cancelButtonText: '取消',
            width: '90%',
            didOpen: () => {
                $('.theme-select').each(function() {
                    fillSelect($(this), theme1List, "选择主题词一", "theme");
                });
                $('.question-type-select').each(function() {
                    fillSelect($(this), questionTypeList, "选择题型", "qt");
                });
                bindSelect();
                bindRemoveButton();
                bindAddButton();
                updateTotalCount();
                $("input[type='number']").off("input").on("input", updateTotalCount);
            },
            preConfirm: () => {
                let data = [];
                let generateQuestionTotalNumber = 0;
                let isValid = true;
                $(".question-row").each(function() {
                    const theme1Id = $(this).find(".theme-select").val();
                    const theme1Name = theme1Id?$(this).find(".theme-select option:selected").text():"";
                    const theme2Id = $(this).find(".theme-select2").val();
                    const theme2Name = theme2Id?$(this).find(".theme-select2 option:selected").text():"";
                    const theme3Id = $(this).find(".theme-select3").val();
                    const theme3Name = theme3Id?$(this).find(".theme-select3 option:selected").text():"";
                    let qtid = $(this).find(".question-type-select").val();
                    const qtName = $(this).find(".question-type-select option:selected").text();
                    const questionCount = parseInt($(this).find("input[type='number']").val()?$(this).find("input[type='number']").val():"0");
                    generateQuestionTotalNumber += questionCount;
                    if (theme1Id === "" || qtid === "" || questionCount < 1) {
                        toastr.warning("每行必须选择一个题型、主题词，且输入值大于0");
                        isValid = false;
                        return false;
                    }
                    let qinfo = qtid.split('#');
                    qtid = qinfo[0];
                    let atid = qinfo[1];
                    let iscon = qinfo[2];
                    data.push({
                        theme1Id,
                        theme1Name,
                        theme2Id,
                        theme2Name,
                        theme3Id,
                        theme3Name,
                        qtid,
                        atid,
                        iscon,
                        qtName,
                        questionCount
                    });
                });
                if (!isValid) {
                    return false;
                }
                if(generateQuestionTotalNumber>30){
                    toastr.warning("一次性最多生成30题！");
                    return false;
                }
                return data;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                let transferData = {cid:cid,cname:'${cname}',data:result.value};
                $.ajax({
                    url: "${pageContext.request.contextPath}/intelliQuestion/generateQuestionBatch",
                    type: "POST",
                    data: JSON.stringify(transferData),
                    contentType : "application/json; charset=utf-8",
                    success: function (res) {
                        Swal.fire('任务提交成功！', '请等待。', 'success');
                        if(refreshInterval===null){
                            refreshInterval = setInterval(function() {
                                getIsLoadingQuestion();
                                $('#datalist').datagrid('reload');
                            }, 19000); // 19秒更新一次
                            $('#taskTips').show();
                        }
                    },
                    error: function (xhr, status, error) {
                        if (xhr.status === 403) {
                            Swal.fire('错误', '未授权的访问或功能已关闭。', 'error');
                        } else {
                            Swal.fire('错误', '提交请求失败', 'error');
                        }
                    }
                });
            }
        });

        function bindAddButton(){
            $(".add-row").off('click').click(function() {
                const index = $(this).data('index');
                const table = $('#question-table tbody');
                if($('.question-row').length >= 10){
                    toastr.warning("最多只能添加10行");
                    return;
                }
                const newRow = `
                        <tr class="question-row" data-index="\${index + 1}">
                            <td>
                                <select class="theme-select form-control" data-index="\${index + 1}">
                                    <option value="">选择主题词一</option>
                                </select>
                                <select class="theme-select2 form-control" data-index="\${index + 1}" style="display:none">
                                    <option value="">选择主题词二</option>
                                </select>
                                <select class="theme-select3 form-control" data-index="\${index + 1}" style="display:none">
                                    <option value="">选择主题词三</option>
                                </select>
                            </td>
                            <td>
                                <select class="question-type-select form-control" data-index="\${index + 1}">
                                    <option value="">选择题型</option>
                                </select>
                            </td>
                            <td>
                                <input type="number" class="form-control select-num" data-index="\${index + 1}" min="0" step="1" value="0" />
                            </td>
                            <td>
                                <button class="add-row" data-index="\${index + 1}">
                                    <img class="btn-icon" src="${pageContext.request.contextPath}/styles/images/svg/add-blue-circle.svg">
                                </button>
                                <button class="remove-row" data-index="\${index + 1}">
                                    <img class="btn-icon" src="${pageContext.request.contextPath}/styles/images/svg/remove-blue-circle.svg">
                                </button>
                            </td>
                        </tr>
                    `;
                table.append(newRow);

                fillSelect($(`.theme-select[data-index="\${index + 1}"]`), theme1List, "选择主题词一", "theme");
                fillSelect($(`.question-type-select[data-index="\${index + 1}"]`), questionTypeList, "选择题型", "qt");
                bindSelect();
                bindAddButton();
                bindRemoveButton();
                updateTotalCount();
                $("input[type='number']").off('input').on("input", updateTotalCount);
            });
        }

        function bindSelect(){
            $(".theme-select").off('change').change(function() {
                const selectedId = $(this).val();
                const index = $(this).data('index');
                if (selectedId === "") {
                    clearSelect($(`.theme-select2[data-index="\${index}"]`), "选择主题词二");
                    clearSelect($(`.theme-select3[data-index="\${index}"]`), "选择主题词三");
                } else {
                    const childThemes = findChildren(selectedId);
                    if(childThemes.length>0){
                        fillSelect($(`.theme-select2[data-index="\${index}"]`), childThemes, "选择主题词二", "theme");
                        clearSelect($(`.theme-select3[data-index="\${index}"]`), "选择主题词三");
                    }else{
                        clearSelect($(`.theme-select2[data-index="\${index}"]`), "选择主题词二");
                    }
                }
            });
            $(".theme-select2").off('change').change(function() {
                const selectedId = $(this).val();
                const index = $(this).data('index');
                if (selectedId === "") {
                    clearSelect($(`.theme-select3[data-index="\${index}"]`), "选择主题词三");
                } else {
                    const childThemes = findChildren(selectedId);
                    if(childThemes.length>0){
                        fillSelect($(`.theme-select3[data-index="\${index}"]`), childThemes, "选择主题词三", "theme");
                    }else{
                        clearSelect($(`.theme-select3[data-index="\${index}"]`), "选择主题词三");
                    }
                }
            });
        }

        function bindRemoveButton(){
            $(".remove-row").off('click').click(function() {
                if ($('.question-row').length <= 1) {
                    toastr.warning("至少保留一行");
                    return;
                }
                const index = $(this).data('index');
                $(this).closest('tr').remove();
                updateRowIndexes();
                updateTotalCount();
                $("input[type='number']").off('input').on("input", updateTotalCount);
            });
        }

        function updateRowIndexes() {
            $('#question-table .question-row').each(function(index) {
                $(this).attr('data-index', index);
                $(this).find('.theme-select').attr('data-index', index);
                $(this).find('.question-type-select').attr('data-index', index);
                $(this).find('input').attr('data-index', index);
                $(this).find('.add-row').attr('data-index', index);
                $(this).find('.remove-row').attr('data-index', index);
            });
        }

        function fillSelect(selectElement, data, defaultText, type) {
            selectElement.empty();
            selectElement.show();
            selectElement.append(`<option value="">\${defaultText}</option>`);

            data.forEach(item => {
                if (type === "theme") {
                    selectElement.append(`<option value="\${item.id}">\${item.name}</option>`);
                } else {
                    selectElement.append(`<option value="\${item.QTID}#\${item.ATID}#\${item.ISCON}">\${item.QTNAME}</option>`);
                }
            });
        }

        function clearSelect(selectElement, defaultText) {
            selectElement.empty();
            selectElement.append(`<option value="">\${defaultText}</option>`);
            selectElement.trigger('change');
            selectElement.hide();
        }

        function updateTotalCount() {
            let total = 0;
            $("input[type='number']").each(function() {
                total += parseInt($(this).val()) || 0;
            });
            $("#total-count").val(total);
        }
    }

    function createRandomQuestionWindow () {
        const questionTypeList = questionType;
        const tipText = '该功能用于一次性往课程里批量生成大量题目，将会对选择的题型在所有主题词随机选择并平均分配数量生成题目，适用于新课程录入题目';

        /* ---------- 1. HTML ---------- */
        let html =
            '<p style="text-align:left;margin:0 0 10px 0;line-height:1.5;">' + tipText + '</p>' +
            '<div id="qtContainer" ' +
            'style="display:grid;grid-template-columns:repeat(2,1fr);' +
            'column-gap:24px;row-gap:10px;justify-items:stretch;' +
            'max-height:320px;overflow-y:auto;' +
            'background:#fafafa;border:1px solid #ccc;border-radius:6px;' +
            'box-shadow:0 2px 6px rgba(0,0,0,.12);padding:10px 12px;position:relative;"></div>' +
            '<p style="text-align:right;margin:12px 0 0 0;font-weight:bold;">' +
            '总题数：<span id="totalCount">0</span>' +
            '</p>';

        Swal.fire({
            title: '设置各题型生成数量',
            html: html,
            width: '70%',
            showCancelButton: true,
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            focusConfirm: false,

            didOpen: function () {
                const $container = $('#qtContainer');

                /* ---------- 2. 题型行 ---------- */
                $.each(questionTypeList, function (_, qt) {
                    const row =
                        '<div class="qtItem" style="display:flex;align-items:center;' +
                        'justify-content:space-between;' +
                        'width:100%;padding:4px 0;">' +
                        '<span style="flex:1 1 auto;text-align:left;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' +
                        qt.QTNAME +
                        '</span>' +
                        '<input type="number" class="qtCount" min="0" max="10000" step="1" value="0" ' +
                        'data-atid="' + qt.ATID + '" ' +
                        'data-qtid="' + qt.QTID + '" ' +
                        'data-qtname="' + qt.QTNAME.replace(/"/g,'&quot;') + '" ' +
                        'data-iscon="' + qt.ISCON + '" ' +
                        'style="flex:0 0 90px;text-align:center;padding:4px;border:1px solid #ccc;border-radius:4px;"/>' +
                        '</div>';
                    $container.append(row);
                    const divider = '<div style="position:absolute;top:8px;bottom:8px;' +
                        'left:50%;width:1px;background:#e0e0e0;"></div>';
                    $container.append(divider);
                });

                /* ---------- 3. 输入校验 & 总数 ---------- */
                $container.on('input', '.qtCount', function () {
                    let v = this.value.replace(/\D/g, '');
                    if (v === '') v = 0;
                    v = Math.min(10000, parseInt(v, 10));
                    this.value = v;

                    let sum = 0;
                    $('.qtCount').each(function () {
                        sum += parseInt(this.value || 0, 10);
                    });
                    $('#totalCount').text(sum);
                });
            },

            /* ---------- 4. 组装数据 ---------- */
            preConfirm: function () {
                const payload = [];
                let sum = 0;
                $('.qtCount').each(function () {
                    const count = parseInt(this.value || 0, 10);
                    if (count > 0) {
                        payload.push({
                            atid: $(this).data('atid'),
                            qtid: $(this).data('qtid'),
                            qtName: $(this).data('qtname'),
                            iscon: $(this).data('iscon'),
                            qtCount: count
                        });
                    }
                    sum+=count;
                });
                if (payload.length === 0) {
                    Swal.showValidationMessage('请至少为一个题型填写 > 0 的数量！');
                    return false;
                }
                if(sum>30000){
                    Swal.showValidationMessage('一次性最多生成30000题！');
                    return false;
                }
                return payload;
            }
        }).then(function (result) {
            if (!result.isConfirmed) return;
            $.ajax({
                url: "${pageContext.request.contextPath}/intelliQuestion/generateAllCourseThemeRandomBatch",
                type: 'POST',
                contentType: 'application/json;charset=UTF-8',
                data: JSON.stringify({
                    qtInfoList: result.value,
                    cid: cid,
                    cname: '${cname}'
                }),
                success: function (res) {
                    if (res.state !== 'SUCCESS' && res.status !== 'SUCCESS') {
                        toastr.error(res.message || '任务提交失败'); return;
                    }
                    Swal.fire('任务提交成功！','请等待。','success');
                    if (refreshInterval === null) {
                        refreshInterval = setInterval(function () {
                            getIsLoadingQuestion();
                            $('#datalist').datagrid('reload');
                        }, 19000);
                        $('#taskTips').show();
                    }
                },
                error: function (xhr) {
                    xhr.status === 403
                        ? Swal.fire('错误','未授权的访问或功能已关闭。','error')
                        : Swal.fire('错误','提交请求失败','error');
                }
            });
        });
    }


    function createImportWindow() {
        let myDropzone = null;
        Swal.fire({
            title: '选择Word文件导入',
            html: `
            <div class="dropzone-container">
                <div id="customDropzone" class="dropzone"></div>
                <div class="dz-message">拖拽文件到这里或点击选择（最多10个，单个不超过10MB，仅支持docx类型）</div>
                <div style="text-align: left;color: #666;font-size: 14px;">
                    提示：该上传功能利用了Erine-X1.1大模型的语义理解功能进行题目识别<span style="color: red">(暂不支持串题)</span>。
                    但大模型有遗忘等缺点，尤其在内容过长时容易出现。因此虽然实际文档内容上限支持40000字，但若一次性导入过多内容，推荐导入方式为：在每15题结束处换行
                    并加入 #### 这样4个井号进行分割，<span style="color: blue">（最谨慎的实践为每道题都用 #### 进行分割）</span>
                    ，后台将会根据该符号分割后分别提交Erine-X1.1识别以提高识别的准确性。
                </div>
            </div>
        `,
            showCancelButton: true,
            confirmButtonText: '上传',
            cancelButtonText: '取消',
            width: '860px',
            didOpen: () => {
                myDropzone = new Dropzone("#customDropzone", {
                    url: '#', // 不需要真实URL，因为手动处理上传
                    autoProcessQueue: false,
                    maxFiles: 10,
                    parallelUploads: 10,
                    acceptedFiles: ".docx",
                    addRemoveLinks: true,
                    dictDefaultMessage: "",
                    dictRemoveFile: "移除",
                    dictInvalidFileType: "仅支持.docx格式文件!",
                    dictFileTooBig: "文件过大（最大10MB）",
                    dictMaxFilesExceeded: "超过最大文件数量!",
                    init: function() {
                        this.on("addedfile", function(file) {
                            Swal.resetValidationMessage();
                            if (!file.name.match(/\.(docx)$/i)) {
                                this.removeFile(file);
                                Swal.fire({
                                    icon: 'error',
                                    title: '文件类型错误',
                                    text: '仅支持.docx格式文件'
                                });
                            }
                            if (file.size > 10 * 1024 * 1024) {
                                this.removeFile(file);
                                Swal.fire({
                                    icon: 'error',
                                    title: '文件过大',
                                    text: '文件大小不能超过10MB'
                                });
                            }
                        });
                    }
                });
            },
            preConfirm: () => {
                return new Promise((resolve) => {
                    if (!myDropzone || myDropzone.files.length === 0) {
                        Swal.showValidationMessage('请至少上传一个文件');
                        return resolve(false);
                    }

                    const invalidFiles = myDropzone.files.filter(file =>
                        !file.name.match(/\.(docx)$/i) || file.size > 10 * 1024 * 1024
                    );

                    if (invalidFiles.length > 0) {
                        Swal.showValidationMessage('存在无效文件，请检查后重新上传');
                        return resolve(false);
                    }

                    const formData = new FormData();
                    formData.append("cid", cid);
                    myDropzone.files.forEach((file, index) => {
                        formData.append("uploadFiles", file);
                    });

                    $.ajax({
                        url: '${pageContext.request.contextPath}/intelliQuestion/importWordQuestionByAI',
                        type: 'POST',
                        data: formData,
                        contentType: false,
                        processData: false,
                        success: function(response) {
                            if(response.state!=="SUCCESS" && response.status!=="SUCCESS"){
                                Swal.fire({
                                    icon: 'error',
                                    title: '上传失败',
                                    text: response.message || '该功能出现异常，请稍后再试'
                                });
                                resolve(false);
                            }else{
                                if(refreshInterval===null){
                                    refreshInterval = setInterval(function() {
                                        getIsLoadingQuestion();
                                        $('#datalist').datagrid('reload');
                                    }, 19000); // 19秒更新一次
                                    $('#taskTips').show();
                                }
                                Swal.fire({
                                    icon: 'success',
                                    title: '上传成功',
                                    text: '已成功上传' + myDropzone.files.length + '个文件。Erine-X1.1模型由于思维链输出运行缓慢，AI任务将在后台运行，您可以稍后再回来该页面。'
                                });
                                resolve(true);
                            }
                        },
                        error: function(xhr) {
                            Swal.fire({
                                icon: 'error',
                                title: '上传失败',
                                text: xhr.responseJSON?.message || '请检查文件后重试'
                            });
                            resolve(false);
                        }
                    });
                });
            },
            didDestroy: () => {
                if (myDropzone) {
                    myDropzone.destroy();
                    myDropzone = null;
                }
            }
        });
    }

    function getAIQuestionUsedStatus(){
        let dotCount = 1;
        let dotInterval = setInterval(function() {
            dotCount = dotCount % 3 + 1;
            $('#loading-text').text('统计数据加载中' + '.'.repeat(dotCount));
        }, 500);
        $.ajax({
            url: '${pageContext.request.contextPath}/intelliQuestion/getAIQuestionUsedStatus',
            type: 'POST',
            data: { cid: cid },
            dataType: 'json',
            success: function(data) {
                clearInterval(dotInterval);

                // 拿到后端返回的三个值
                var totalAi     = data.TOTAL_AI     || 0;
                var totalRefs   = data.TOTAL_REFS   || 0;
                var totalState1 = data.TOTAL_STATE1 || 0;

                // 计算百分比，保留两位小数
                var pctRefs   = totalAi > 0 ? (totalRefs   / totalAi * 100).toFixed(2) + '%' : '0%';
                var pctState1 = totalAi > 0 ? (totalState1 / totalAi * 100).toFixed(2) + '%' : '0%';

                // 拼接显示内容
                var html = ''
                    + '<span>AI题目总数：'     + totalAi     + '</span>'
                    + '<span style="margin-left:12px">'
                    +   '被应用的试题：'         + totalRefs   + '（' + pctRefs   + '）'
                    + '</span>'
                    + '<span style="margin-left:12px">'
                    +   '审核通过的试题：'      + totalState1 + '（' + pctState1 + '）'
                    + '</span>';

                // 渲染到页面
                $('#stats-container').html(html);
            },
            error: function() {
                clearInterval(dotInterval);
                $('#stats-container').html('<span style="color:red;">加载失败</span>');
            }
        });
    }

    function getIsLoadingQuestion(){
        $.ajax({
            url: "${pageContext.request.contextPath}/intelliQuestion/checkIsGenerating",
            async: true,
            type: "POST",
            data: {cid:cid},
            success: function(rs){
                if(rs !== null && rs !== "" && typeof(rs)!="undefined"){
                    if(rs===true && refreshInterval===null){
                        refreshInterval = setInterval(function() {
                            getIsLoadingQuestion();
                            $('#datalist').datagrid('reload');
                        }, 13000); // 13秒更新一次
                        $('#taskTips').show();
                    }else if(rs===false && refreshInterval!==null){
                        clearInterval(refreshInterval);
                        refreshInterval = null;
                        $('#taskTips').hide();
                    }
                }
            }
        });
    }

    function selectFilter(){
        let selectT1ID = $('#theme1List').val();
        let selectT2ID = $('#theme2List').val();
        let selectT3ID = $('#theme3List').val();
        if(selectT1ID===""){
            selectT2ID = "";
        }
        if(selectT2ID===""){
            selectT3ID = "";
        }
        $('#datalist').datagrid('load',{
            cid : cid,
            theme1id : selectT1ID,
            theme2id : selectT2ID,
            theme3id : selectT3ID,
            qtid: $("#questionTypeList").val(),
            source : $('#sourceList').val(),
            state : $('#stateList').val(),
        });
    }

    function doSearch(value,name){//通用查询框
        if(name == 'question'){
            $('#datalist').datagrid('load',{
                cid : cid,
                question: value,
                theme1id : $('#theme1List').val(),
                theme2id : $('#theme2List').val(),
                theme3id : $('#theme3List').val(),
                qtid: $("#questionTypeList").val(),
                source : $('#sourceList').val(),
                state : $('#stateList').val(),
            });
        }else if(name == 'teacher'){
            $('#datalist').datagrid('load',{
                cid : cid,
                teacher: value,
                theme1id : $('#theme1List').val(),
                theme2id : $('#theme2List').val(),
                theme3id : $('#theme3List').val(),
                qtid: $("#questionTypeList").val(),
                source : $('#sourceList').val(),
                state : $('#stateList').val(),
            });
        }
    }

    function formatDate(timestamp) {
        let myDate = new Date(timestamp);//获取系统当前时间
        let year = myDate.getFullYear(); //获取完整的年份
        let month = myDate.getMonth() + 1; //获取当前月份(0-11,0代表1月)
        let day = myDate.getDate(); //获取当前日(1-31)
        let hour = myDate.getHours(); //获取当前小时数(0-23)
        let min = myDate.getMinutes(); //获取当前分钟数(0-59)
        let snd = myDate.getSeconds(); //获取当前秒数(0-59)

        return year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + snd;
    }

    function deleteQid(qid,ismain){
        let tipText = '删除该试题操作不可逆，是否继续？';
        if(ismain===1){
            tipText = '删除串题主题干将会将其子题一并删除。'+tipText;
        }
        Swal.fire({
            title: '提示',
            text: tipText,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '确定',
            cancelButtonText: '取消'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/intelliQuestion/delQuestionByQid",
                    async: true,
                    type: "POST",
                    data: {qid: qid, ismain:ismain},
                    success: function(rs) {
                        $('#datalist').datagrid('reload');
                        toastr.success("删除成功！");
                    }
                });
            }
        });
    }

    function selectQidToUse(qid,state,answerid,mqid,ismain){
        if(mqid!==null && mqid!=='undefined' && mqid!==undefined && mqid!=='null'){
            qid = mqid;
            ismain = 1;
            answerid="";
        }
        if(ismain===1){
            answerid="";
        }
        if(state===1 || ismain===1){
            let tipText = '';
            if(ismain===1){
                tipText = '该试题为串题，其相关题目将会被全部加入正式库。';
            }
            if(state===1){
                tipText += '该试题曾经已被选用过，是否再次新增至正式题库？';
            }
            Swal.fire({
                title: '提示',
                text: tipText,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '确定',
                cancelButtonText: '取消'
            }).then((result) => {
                if (result.isConfirmed) {
                    ajaxSelectQidToUse(qid, answerid,ismain);
                }
            });
        }else{
            ajaxSelectQidToUse(qid, answerid,ismain);
        }

        function ajaxSelectQidToUse(qid, answerid,ismain){
            $.ajax({
                url: "${pageContext.request.contextPath}/intelliQuestion/selectQidToUse",
                async: true,
                type: "POST",
                data: {qid:qid,cid:cid,answerid:answerid,ismain:ismain},
                success: function(rs){
                    if(rs>0){
                        $('#datalist').datagrid('reload');
                        toastr.success("选用成功！");
                    }else {
                        toastr.error("操作失败！");
                    }
                }
            });
        }
    }

    function selectQidsToUse(){
        let rows = $('#datalist').datagrid('getSelections');
        let list = [];
        let hasBeenUsed = false;
        let hasCon = false;
        out:
        for (let i = 0; i < rows.length; i++) {
            for(let j=0;j<list.length;j++){
                if(list[j].qid === rows[i].qid || list[j].qid === rows[i].mqid){
                    continue out;
                }
            }
            if(rows[i].iscon===1){
                hasCon = true;
                if(rows[i].ismain===0){
                    list.push({
                        qid:rows[i].mqid,
                        cid:cid,
                        iscon: 1,
                        ismain: 1
                    });
                }else{
                    list.push({
                        qid:rows[i].qid,
                        cid:cid,
                        iscon: 1,
                        ismain: 1
                    });
                }
                continue;
            }
            list.push({
                qid:rows[i].qid,
                cid:cid,
                answerid:rows[i].answerid
            });
            if(rows[i].state==1){
                hasBeenUsed = true;
            }
        }
        if(list.length===0){
            toastr.warning("你还没有选择题目！");
            return;
        }
        if(hasBeenUsed || hasCon){
            let tipText = '';
            if(hasCon){
                tipText = '选中的试题中包含串题，串题其子题将会被全部加入正式库。';
            }
            if(hasBeenUsed){
                tipText += '选中的试题中有部分试题曾经已被选用过，是否再次新增至正式题库？';
            }
            Swal.fire({
                title: '提示',
                text: tipText,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '确定',
                cancelButtonText: '取消'
            }).then((result) => {
                if (result.isConfirmed) {
                    ajaxSelectQidsToUse(list);
                }
            });
        }else{
            ajaxSelectQidsToUse(list);
        }

        function ajaxSelectQidsToUse(list){
            $.ajax({
                url: "${pageContext.request.contextPath}/intelliQuestion/selectQidsToUse",
                async: true,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(list),
                success: function(rs){
                    if(rs>0){
                        $('#datalist').datagrid('reload');
                        toastr.success("选用成功！");
                    }else {
                        toastr.error("操作失败！");
                    }
                }
            });
        }
    }

    function deleteSelected(){
        let rows = $('#datalist').datagrid('getSelections');
        let list = [];
        for (let i = 0; i < rows.length; i++) {
            list.push({
                qid:rows[i].qid,
                ismain:rows[i].ismain
            });
        }
        if (list.length === 0) {
            toastr.warning("你还没有选择题目！");
            return;
        }
        Swal.fire({
            title: '提示',
            text: '该操作不可逆，是否要删除所选试题？',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '确定',
            cancelButtonText: '取消'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    contentType: "application/json; charset=utf-8",
                    url: "${pageContext.request.contextPath}/intelliQuestion/delSelectQuestion",
                    async: true,
                    type: "POST",
                    data: JSON.stringify(list),
                    success: function(rs) {
                        $('.datagrid-header-check').find('checked', false);
                        $('#datalist').datagrid('reload');
                        toastr.success("删除成功！");
                    }
                });
            }
        });
    }
</script>
</body>
</html>
