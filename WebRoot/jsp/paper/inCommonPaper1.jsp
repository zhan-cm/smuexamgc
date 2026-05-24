<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<div id="dlg-toolbar" style="height:auto">
<table style="border:none; width: 100%; border-collapse: collapse; border-spacing: 0;">
	<tr>
		<td>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="window.location.reload();">刷新</a>
			<select id="unitFilter" name="unitFilter" style="width:240px;"></select>
			<span style="margin-top:100px!important;">
				<input class="easyui-searchbox" data-options="prompt:'请输入查询课程',searcher:doSearch" style="width:150px;" />
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
			</span>	
		</td>
	</tr>		
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript">
$(document).ready(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/paper/inCommonPaper1";
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getCourseList4Paper',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,20*2,20*3,20*4,20*5,20*6,20*7,20*8,20*9,20*10],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		columns:[[
			  //{field:'CID',checkbox:true},
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
	          {field:'opration',title:'操作',width:120,align:'center',formatter:function(value,row,index){
	        	  //var s1 = '<a href="javascript:void(0)" class="editcls1" onclick="editExamInfo(' + row.QCOUNT + ', ' + row.CID + ', 0)"></a>';
	        	  var s2 = '<a href="javascript:void(0)" class="editcls2" onclick="editExamInfo(' + row.QCOUNT + ', ' + row.CID + ', 1)"></a>';
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/editExamInfo?c_id=' + row.CID + '&way=1" class="editcls2"></a>';
	        	  return s2;
	          }}
	    ]],
	    onLoadSuccess:function(data){
	    	//$('.editcls1').linkbutton({text:'结构化组卷',plain:true});
	        $('.editcls2').linkbutton({text:'手工组卷',plain:true});
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

function editExamInfo(qcount, cid, way){
	if(parseInt(qcount) > 0){
		var params = {};
		params["cid"] = cid+"";
		params["permission"] = "paper:add"; 
		$.ajax({
			  contentType: "application/json; charset=utf-8",
	          url: '${pageContext.request.contextPath}/course/checkCoursePermission',
	          async: false, 
	          type: "POST",
	          data: JSON.stringify(params),
	          success: function (data) {
	          	if(data==1){
					window.location.href = '${pageContext.request.contextPath}/paper/editExamInfo?c_id=' + cid + '&way=' + way;
	          	}else if(data==0){
	          		toastr.warning("无相关权限");
	          	}else{
	          		toastr.error("登录超时，请重新登录！");
	          	} 	        		
	   		}
	   	});
		
	}else{
		toastr.warning('试题数为0，请添加试题后进行组卷');
	}
}


function doSearch(value,name){
	var unitid = $('#unitFilter').val() || '';
	$('#datalist').datagrid('load',{
		unitid: unitid,
		cname: value
	});
}
</script>	

