<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
.plimit{
	padding:2px .8px;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	min-width: 100px;
	max-width: 280px;
	border-color: #95B8E7;
	margin:0 2.5px;
}
table td{
font-size:16px!important;
}
table input{
font-size:16px!important;
}

</style>
<input type="hidden" id="nowTime" name="nowTime" value="${nowTime}">
<div id="dlg-toolbar" style="height:auto">
<table cellpadding="0" cellspacing="0" >
	<tr>
		<th data-options="width:400" style="padding:0 6px">
			
			<select id="unitList" name="unitList" class="plimit" onchange="paperFilter()">
				<option value="">不限教学单位</option>
				<c:forEach var="unit" items="${applicationScope.unitList}">
					<option value="${unit.ID}">${unit.NAME}</option>
				</c:forEach>
			</select>
			<select id="courseList" name="courseList" class="plimit" onchange="paperFilter()">
				<option value="">不限科目</option>
				<c:forEach var="course" items="${courseList}">
					<option value="${course.CID}">${course.CNAME}</option>
				</c:forEach>
			</select>
			<select id="gradeList" name="gradeList" class="plimit" onchange="paperFilter()">
				<option value="">不限年级</option>
				<c:forEach var="grade" items="${applicationScope.grade}">
					<option value="${grade.ID}">${grade.NAME}</option>
				</c:forEach>
			</select>
			<select id="specialtyList" name="specialtyList" class="plimit" onchange="paperFilter()">
				<option value="">不限专业</option>
				<c:forEach var="specialty" items="${applicationScope.specialtyList}">
					<option value="${specialty.ID}">${specialty.NAME}</option>
				</c:forEach>
			</select>
			<select id="stateList" name="stateList" class="slimit" onchange="paperFilter()">
				<option value="0">不限试卷状态</option>
				<option value="1">未送审或尚未通过教务处审核的试卷</option>        
		        <option value="2">已通过审核待考或已考未收卷的试卷</option>        
		        <option value="3">考试结束正在改卷或改卷完毕的试卷</option>
		        <option value="-2">已通过审核但未被采用的试卷</option> 
			</select>
			
			</th>		
	</tr>
	<tr>
		<td>
			<!-- <a href="javascript:void(0);" class="easyui-linkbutton c1" data-options="iconCls:'icon-page_add',plain:true" data-reveal-id="myModal">下一步：编辑考务信息</a>-->
			<a href="javascript:void(0);" class="easyui-linkbutton c1" data-options="iconCls:'icon-page_add',plain:true" onclick="toSurePaper()">下一步：编辑考务信息</a>
			<a href="javascript:void(0)" class="big-link" onclick="toSurePaper()">点击查看已选试卷</a>
			<input id="searchByNum" style="width: 430px;" data-options="prompt:'输入试卷编号或名称，试卷编号可按逗号分隔批量查询'"/>
			<input id="searchByTeacher" style="width: 230px;" data-options="prompt:'按组卷人实名或用户名查询'" />
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-page_cancel',plain:true" onclick="window.location.reload();">取消查询</a>
		</td>	
			
	</tr>
</table>
</div>
<div id="toSurePaper" style="padding-left:10px;"></div>
<div id="myModal" style="display:none;">
	<table id="check_table" style="width:100%;">
	<tbody style="display:block;height:300px;width:480px;overflow-y:scroll;">
		<tr>
			<td width="5%">已选</td>
			<td width="15%">试卷编号</td>
			<td width="80%">试卷名称</td>
		</tr>
	</tbody>
	</table>
	<table style="margin-top:10px;">
		<tr>
			<td><input type="button" value="下一步：编辑考务信息" onclick="toCombinePaper();"/></td>
		</tr>
	</table>
</div>

<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){	
	localStorage.preUrl = "${pageContext.request.contextPath}/paper/inCombinePaper";
	var errorInfo = $("#errorInfo").val();	
	if(errorInfo){
		toastr.warning(errorInfo);
	}
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
    var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
    reIE.test(userAgent);
    var fIEVersion = parseFloat(RegExp["$1"]);
    if(fIEVersion <= 8) {
    	
    }else{
    	$('#courseList').select2();
    	$('#unitList').select2();
    	$('#gradeList').select2();
    	$('#specialtyList').select2();
    	$('#stateList').select2();
    }
	/*
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/course/getCourseList4Paper',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,20*2,20*3,20*4,100,20*6,20*8,20*10,300,400,500,1000],
		fitColumns: true,
		//queryParams:queryParams,
		toolbar:'#dlg-toolbar',
		columns:[[
			  {field:'CID',checkbox:true},
			  {field:'Num',title:'序号',width:10,align:'center',formatter:function(value,row,index){
					 var options = $("#datalist").datagrid('getPager').data("pagination").options; 
				     var currentPage = options.pageNumber;
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
	          {field:'PAPERCOUNT',title:'试卷数',width:30,align:'left',sortable:true},
	          {field:'QCOUNT',title:'试题数',width:30,align:'left',sortable:true}
	    ]]
	});*/
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getPaperList4combinePaper',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,20*2,20*3,20*4,100,20*6,20*8,20*10,300,400,500,1000],
		fitColumns: true,
		queryParams: {},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'ID',checkbox:true}, 
			  {field:'NUM',title:'试卷编号',width:20,align:'left',sortable:true,formatter:function(value,row,index){
				  return row.ID;
			  }},
			  {field:'ENAME',title:'试卷名称',width:40,align:'left',sortable:true},
	          {field:'SUBJECTSUM',title:'题目数',width:10,align:'left',sortable:true},
	          {field:'begindate',title:'考试日期',width:20,align:'center',sortable:true,formatter:function(value,row,index){
	        	  var rs = '';
	        	  var bdate = new Date(row.BEGINDATE).format("yyyy-MM-dd");
	        	  var edate = new Date(row.ENDDATE).format("yyyy-MM-dd");
	        	  if (bdate == edate){
	        		  rs = bdate;
	        	  }else{
	        		  rs = bdate + '--' + edate;
	        	  }
	        	  return rs;
	          }},
	          {field:'enddate',title:'考试时间',width:20,align:'center',formatter:function(value,row,index){
	        	  var rs = '';
	        	  var btime = new Date(row.BEGINDATE).format("hh:mm");
	        	  var etime = new Date(row.ENDDATE).format("hh:mm");
	        	  rs = btime + '--' + etime;
	        	  return rs;
	          }},
	          {field:'TEACHERNAME',title:'组卷人',width:20,align:'left',sortable:true},
	          {field:'TESTSTATE',title:'试卷状态',width:20,align:'center',sortable:true,formatter:function(value,row,index){
	        	  var ss=row.STATE;
	          	var s = '<div class="wrap">';
	          	switch(ss){
	          	case -2:
					s+= '通过终审，未启用';
					break;
				case -1:
					s+= '暂时删除不用';
					break;
				case 0:
					s+= '尚未提交审核';
					break;
				case 1:
					s+= '等待初审';
					break;
				case 2:
					s+= '等待终审';
					break;
				case 3:
					if($("#nowTime").val()<row.BEGINDATE){
						s+= '等待考试(通过终审，已采用)';
					}else if($("#nowTime").val()>row.BEGINDATE&&$("#nowTime").val()<row.ENDDATE){
						s+= '考试开始，未结束';
					}else if($("#nowTime").val()>row.ENDDATE){
						s+= '考试结束，未收卷';
					}else{
						s+= 'error';
					} 
					//s+= '等待考试(通过终审，已采用)';
					break;
				case 4:
					s+= '等待考试(通过终审，已采用)';//没有4这个状态，3不会变成4
					break;
				case 5:
					s+= '考试结束，未收卷';//5也不存在
					break;
				case 6:
					s+= '已改出成绩归档';
					break;
				case 7:
					s+= '审核未通过';
					break;
				case 8:
					s+= '考试结束，已收卷';
					break;
				default:
					s+='未知状态';
					break;
				}
	          	if(row.mobile==1){
	          		s+='[形成性评价]'
	          	}
		    	  s+='</div>';
		    	  return s;
	          }},
	          {field:'PAPER',title:'A、B卷',width:10,align:'left',formatter:function(value,row,index){
	        	  if(row.AORB == 0){
	        		  return 'A卷 ';
	        	  }else if(row.AORB == 1){
	        		  return 'B卷 ';
	        	  }else{
	        		  return 'C卷 ';
	        	  }
	          }},
	          {field:'EI',title:'考务信息',width:10,align:'left',formatter:function(value,row,index){
	        	  //var s1 = '<a href="${pageContext.request.contextPath}/verify/viewExamInfo?c_id=' + row.CID + '&ei_id=' + row.ID +'" class="viewExamInfo"></a>';
	        	  var s1 = "<a href=\"javascript:void(0);\" class=\"viewExamInfo\" onclick=\"inViewExamInfo('"+row.CID+"','"+row.ID+"','"+row.ENAME+"')\"></a>";
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/inEditExamInfo?cid=' + row.cid + '&eid=' + row.eid + '" class="editExamInfo"></a>';
	        	  return s1;
	          }},
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewExamInfo').linkbutton({text:'查看',plain:true});
	    },
     	onSelect: function(rowIndex, rowData){
     		var str = "<tr>"
     			+ "<td width=\"20%\"><input type=\"checkbox\" checked=\"checked\" name=\"eid\" value=\""+rowData.ID+"\"/></td>"
     			+ "<td width=\"20%\">"+rowData.ID+"</td>"
     			+ "<td width=\"60%\">"+rowData.ENAME+"</td></tr>";
     		$("#check_table").append(str);
     	},
     	onUncheck: function(rowIndex, rowData){
     		var eid = rowData.ID;
     		$('input[name="eid"]').each(function(){ 
     			if($(this).val()==eid){
     				$(this).parent().parent().remove();
     			}
     		}); 
     	},
     	onCheckAll:function(rows) {
     		var str="";
     		$.each(rows, function(index, item){
     			var rowData= rows[index];//获取到行内容
     			str += "<tr>"
         			+ "<td width=\"20%\"><input type=\"checkbox\" checked=\"checked\" name=\"eid\" value=\""+rowData.ID+"\"/></td>"
         			+ "<td width=\"20%\">"+rowData.ID+"</td>"
         			+ "<td width=\"60%\">"+rowData.ENAME+"</td></tr>";
     	    });
     		$("#check_table").append(str);
     	},
     	onUncheckAll:function(rows) {
     		$.each(rows, function(index, item){
     			var rowData= rows[index];//获取到行内容
     			var eid = rowData.ID;
         		$('input[name="eid"]').each(function(){ 
         			if($(this).val()==eid){
         				$(this).parent().parent().remove();
         			}
         		}); 
     	    });
     	}
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	$('#unitFilter').combogrid({
	    url: '${pageContext.request.contextPath}/common/getUnit',
	    idField: 'ID',
	    textField: 'NAME',
	    editable: false,
	    columns: [[
			{field:'NAME',title:'授课单位',width:169,sortable:true}
	    ]],
	    onSelect:function(data){
	    	$('#datalist').datagrid('load',{
	    		unitid:$('#unitFilter').combogrid('grid').datagrid('getSelected').ID,
			});
	    },
		onLoadSuccess:function(){
	        $("#unitFilter").combogrid('setValue', '授课单位');
	    }
	});
});

function toCombinePaper(){
	var eids= [];
	$("#toSurePaper").find("input[name=eid]").each(function(){
		if($(this).is(':checked')){
			eids.push($(this).val()); 
		}
	})
	
	
	if(eids.length>0){
		var url = "${pageContext.request.contextPath}/paper/editCombinePaperExamInfo?eids="+eids.join(',')+"&way=2";
		window.location.href = url;
	}else{
		toastr.warning("请选择至少一份试卷");
	}
}

function doSearch(value,name){ 
	var unitid = '';
	if($('#unitFilter').combogrid('grid').datagrid('getSelected')!=null){
		unitid = $('#unitFilter').combogrid('grid').datagrid('getSelected').ID;
	}
	if(name == 'accurate'){
		$('#datalist').datagrid('load',{
			unitid: unitid,
			cname: value
		});
	}else if(name == 'vague'){
		$('#datalist').datagrid('load',{
			condition: 'true',
			unitid: unitid,
			cname: value
		});
	}
}

function inViewExamInfo(cid,eid,ename){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/viewExamInfo?cid=" + cid + "&eid=" + eid,
		fit:true,
		title:"《"+ename+"》考务信息"
	},0);
}

function paperFilter(){
	var val = $('#stateList').val();	
	var state = '';	
	if(val == 0){//[0, 1, 2, 3, 5, 6, 7, 8];
		state="0, 1, 2, 3, 5, 6, 7, 8,-2";
	}else if(val == 1){//[0, 1, 2, 7];
		state="0, 1, 2, 7";
	}else if(val == 2){//[3, 5];
		state="3, 5";
	}else if(val == 3){//[6, 8];
		state="6, 8";
	}else if(val==-2){
		state="-2";
	}
	
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid('reload', {
 		unid : $('#unitList').val(), 
    	cid : $('#courseList').val(), 
    	gid : $('#gradeList').val(), 
    	sid : $('#specialtyList').val(),
    	num : $('#searchByNum').searchbox('getValue'),
    	teacher : $('#searchByTeacher').searchbox('getValue'),
    	state : state,
    	page : $(p).pagination('options').pageNumber,
    	rows : $(p).pagination('options').pageSize
 	});
}

function toCheckPaper(){
	$('#checkPaper').modal({
		keyboard : true
	});
}

function toSurePaper(){
	var winStr = $("#myModal").html();
				var obj = $(winStr);
				$('#toSurePaper').html(null);
				obj.appendTo('#toSurePaper');
				$('#toSurePaper').window({
					width:510,
					height:400,
					modal:true,
					title:"确认选中的试卷",
					collapsible:false,
					minimizable:false,
					maximizable:false
					//content:winStr
				});
}

$('#searchByNum').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	teacher : $('#searchByTeacher').searchbox('getValue'),
	    	num : value,
	    	mobile: '0'
		})
	}
	
})

$('#searchByTeacher').searchbox({
	searcher:function(value,name){
		$('#datalist').datagrid('load',{
			unid : $('#unitList').val(), 
	    	cid : $('#courseList').val(), 
	    	gid : $('#gradeList').val(), 
	    	sid : $('#specialtyList').val(),
	    	num : $('#searchByNum').searchbox('getValue'),
	    	teacher : value,
	    	mobile: '0'
		})
	}	
})
</script>	

