<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
#toSureCourse{
overflow-y: auto;
overflow-x: hidden;
}
</style>
<div id="dlg-toolbar" style="height:auto">
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td data-options="width:400" style="padding:0 4px">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<select id="unitFilter" name="unitFilter" style="width:240px;"></select>
			<span style="margin-top:100px!important;">
				<input class="easyui-searchbox" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			</span>	
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="toSureCourse();">开始组卷</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-asterisk_orange',plain:true" onclick="toSureCourse();">点击查看已选课程</a>
		</td>
		
	</tr>
</table>
</div>
<table id="datalist"></table>
<div id="toSureCourse" style="padding-left:10px;"></div>
<div id="myModal" style="display:none;">
	<table style="width:100%;height:300px;">
		<thead>
            <tr>
                <td width="30%" style="text-align:center;">已选</td>
                <td width="70%">课程名称</td>
            </tr>
        </thead>
        <tbody id="check_table" style="overflow-y: scroll;">
        
        </tbody>		
	</table>
	<div style="margin-top:20px;text-align: center;">
		<input type="button" value="开始组卷" onclick="toCreatePaper();"/>
	</div>
</div>
<script type="text/javascript">

$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/paper/inMultiPaper";
	
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getCourseList4Paper',
		pagination: true,
		rownumbers: false,
		pageSize: 200,
		pageList:[100,200,500,1000,2000],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'CID',checkbox:true},
			  {field:'Num',title:'序号',width:10,align:'center',formatter:function(value,row,index){
					 var options = $("#datalist").datagrid('getPager').data("pagination").options; 
				     var currentPage = options.pageNumber;
				     if(currentPage==0){
				     	currentPage=1;
				     }
				     var pageSize = options.pageSize;
				     return (pageSize * (currentPage -1))+(index+1);
			  }},
			  {field:'CODE',title:'课程编码',width:30,align:'left',sortable:true},
		      {field:'NAME_C',title:'课程中文名',width:60,align:'left',sortable:true},
	          //{field:'NAME_E',title:'课程英文名',width:40,align:'left',sortable:true},
	          //{field:'SHORTNAME',title:'课程简称',width:40,align:'left',sortable:true},
	          {field:'UNAME',title:'授课单位',width:60,align:'left',sortable:true},
	          {field:'DNAME',title:'所属科室',width:50,align:'left',sortable:true},
	          {field:'CONTACT',title:'联系人',width:40,align:'left',sortable:true},
	          {field:'TEL',title:'联系电话',width:60,align:'left',sortable:true},
	          {field:'PERIOD',title:'学时',width:20,align:'left',sortable:true},
	          {field:'PCOUNT',title:'试卷数',width:30,align:'left',sortable:true},
	          {field:'QCOUNT',title:'试题数',width:30,align:'left',sortable:true},
	          
	    ]],
	    onLoadSuccess:function(data){
	    	
	    },
        onSelect: function(rowIndex, rowData){
            var str = "<tr>"
                + "<td width=\"30%\" style=\"text-align:center;\"><input type=\"checkbox\" checked=\"checked\" name=\"cid\" value=\""+rowData.CID+"\" qcount=\""+rowData.QCOUNT+"\"/></td>"
                + "<td width=\"70%\">"+rowData.NAME_C+"</td></tr>";
            $("#check_table").append(str);
        },
        onUncheck: function(rowIndex, rowData){
            var cid = rowData.CID;
            $('input[name="cid"]').each(function(){
                if($(this).val()==cid){
                    $(this).parent().parent().remove();
                }
            });
        },
        onCheckAll:function(rowData){
        	var str='';
        	$.each(rowData,function(index,item){
        		str += "<tr>"
                    + "<td width=\"30%\"><input type=\"checkbox\" checked=\"checked\" name=\"cid\" value=\""+rowData[index].CID+"\" qcount=\""+rowData[index].QCOUNT+"\"/></td>"
                    + "<td width=\"70%\">"+rowData[index].NAME_C+"</td></tr>";
                
        	});
        	$("#check_table").append(str);
        },
        onUncheckAll:function(rowData){
        	$.each(rowData,function(index,item){
        		var cid = rowData[index].CID;
                $('input[name="cid"]').each(function(){
                    if($(this).val()==cid){
                        $(this).parent().parent().remove();
                    }
                });
        	});
        }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});

	$.ajax({
		url: '${pageContext.request.contextPath}/common/getUnit',
		type: 'get',
		dataType: 'json',
		success: function(data){
			var list = data.rows || data;
			var html = '<option value="">授课单位</option>';
			$.each(list, function(i, item){
				html += '<option value="' + item.ID + '">' + item.NAME + '</option>';
			});
			$('#unitFilter').html(html);

			$('#unitFilter').select2({
				width: '190px',
				placeholder: '授课单位',
				allowClear: true,
				language: 'zh-CN'
			});
		}
	});

	$('#unitFilter').on('change', function () {
		$('#datalist').datagrid('load', {
			unitid: $(this).val()
		});
	});
});


function doSearch(value,name){
	var unitid = $('#unitFilter').val() || '';
	$('#datalist').datagrid('load',{
		unitid: unitid,
		cname: value
	});
}

function toCreatePaper(){
	var cids = [];
    $("#toSureCourse").find("input[name=cid]").each(function(){
        if($(this).is(':checked')){
            var qcount=$(this).attr("qcount");
            if(qcount>0){
                cids.push($(this).val());
			}else{
                toastr.warning("试题数为0，请添加试题后进行组卷");
                return;
            }
        }
    })
	if(cids.length>0){
	    for(i=0;i<cids.length;i++){
            var params = {};
            params["cid"] = cids[i];
            params["permission"] = "paper:add";
            $.ajax({
                contentType: "application/json; charset=utf-8",
                url: '${pageContext.request.contextPath}/course/checkCoursePermission',
                async: false,
                type: "POST",
                data: JSON.stringify(params),
                success: function (data) {
                    if(data==0){
                        toastr.warning("无相关权限");
                        return;
                    }
                }
            });
		}
        window.location.href = "${pageContext.request.contextPath}/paper/editMultiCourseExamInfo?cids="+cids.join(',')+"&way=3";
	}else{
        toastr.warning("请选择至少一门课程");
    }
	//var rows = $('#datalist').datagrid('getSelections');
	
	<%--if (rows.length>0){--%>
		<%--for(var i=0; i<rows.length; i++){--%>
			<%--if(rows[i].QCOUNT>0){--%>
				<%--var params = {};--%>
				<%--params["cid"] = rows[i].CID+"";--%>
				<%--params["permission"] = "paper:add";--%>
				<%--$.ajax({--%>
					  <%--contentType: "application/json; charset=utf-8",--%>
			          <%--url: '${pageContext.request.contextPath}/course/checkCoursePermission',--%>
			          <%--async: false,--%>
			          <%--type: "POST",--%>
			          <%--data: JSON.stringify(params),--%>
			          <%--success: function (data) {--%>
			          	<%--if(data==1){--%>
							<%--cids.push(rows[i].CID);--%>
			          	<%--}else if(data==0){--%>
			          		<%--toastr.warning("无相关权限");--%>
			          	<%--}else{--%>
			          		<%--toastr.error("登录超时，请重新登录！");--%>
			          	<%--}--%>
			   		<%--}--%>
			   	<%--});--%>

			<%--}else{--%>
				<%--toastr.warning("试题数为0，请添加试题后进行组卷");--%>
				<%--return;--%>
			<%--}--%>
		<%--}--%>
		<%--window.location.href = "${pageContext.request.contextPath}/paper/editMultiCourseExamInfo?cids="+cids.join(',')+"&way=3";--%>
	<%--}else{--%>
		<%--toastr.warning("请选择至少一门课程");--%>
	<%--}--%>
}

function toSureCourse(){
    var winStr = $("#myModal").html();
    var obj = $(winStr);
    $('#toSureCourse').html(null);
    obj.appendTo('#toSureCourse');
    $('#toSureCourse').window({
        width:400,
        height:400,
        modal:true,
        title:"确认选中的课程",
        collapsible:false,
        minimizable:false,
        maximizable:false
        //content:winStr
    });
}
</script>	

