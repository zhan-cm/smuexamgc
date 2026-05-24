<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
tr{
	line-height: 20px;
}
</style>
<div id="dlg-toolbar" style="height:auto">
<input type="hidden" id="cid" value="${cid}"/>
<input type="hidden" id="eid" value="${eid}"/>
<table cellpadding="0" cellspacing="0" style="width:100%">
	<tr>
		<td style="padding-left:2px">
			<a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a>
			<select id="stateList" name="stateList" class="slimit" onchange="paperFilter()">
				<option value="0">不限试卷状态</option>
				<option value="1">未送审或尚未通过教务处审核的试卷</option>        
		        <option value="2">已通过审核待考或已考未收卷的试卷</option>        
		        <option value="3">考试结束正在改卷或改卷完毕的试卷</option>
		        <option value="-2">已通过审核但未被采用的试卷</option>
			</select>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addQuestionFromPaper();">下一步：合并试题</a>
		</td>
	</tr>
</table>
</div>
<table id="datalist"></table>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/toastr.min.js"></script>
<script type="text/javascript">
var cid = $('#cid').val();
var eid = $('#eid').val();
$(document).ready(function(){
	$('#datalist').datagrid({
		fit:true,
		striped: true,
		singleSelect: false,
		url:'${pageContext.request.contextPath}/paper/getPaperList?state=0&state=1&state=2&state=3&state=5&state=6&state=7&state=8&state=-2',
		pagination: true,
		rownumbers: false,
		pageSize: 100,
		pageList:[20,20*2,20*3,20*4,100,20*6,20*8,20*10,300,400,500,1000],
		fitColumns: true,
		queryParams: {
			//state: [0, 1, 2, 3, 5, 6, 7, 8],
			//试卷状态（-1：被删除，0：尚未提交，1：尚未初审，2：尚未终审，3：尚未考试，4：考试开始，未结束，5：考试结束，未收卷；6：已改出成绩归档，7：审核未通过，8：考试结束，已收卷）
			cid: cid
		},
		toolbar:'#dlg-toolbar',
		//sortName: 'QID',
		columns:[[
			  {field:'ID',checkbox:true}, 
			  {field:'num',title:'试卷编号',width:15,align:'left',formatter:function(value,row,index){
	          	  return row.ID;
	          },sortable:true},
			  {field:'ENAME',title:'科目',width:60,align:'left',sortable:true},
	          {field:'SUBJECTSUM',title:'题目数',width:40,align:'left',sortable:true},
	          {field:'begindate',title:'考试开始时间',width:40,align:'left',formatter:function(value,row,index){
	        	  //var date = new Date(row.begindate).format("yyyy-MM-dd hh:mm");
	        	  var date = new Date(row.BEGINDATE).format("yyyy-MM-dd hh:mm:ss");
	        	  return date;
	          }},
	          {field:'enddate',title:'考试结束时间',width:40,align:'left',formatter:function(value,row,index){
	        	  var date = new Date(row.ENDDATE).format("yyyy-MM-dd hh:mm");
	        	  return date;
	          }},
	          {field:'TEACHERNAME',title:'组卷人',width:40,align:'left',sortable:true},
	          {field:'EI',title:'考务信息',width:40,align:'left',formatter:function(value,row,index){

				  var s1 =  '<a href="javascript:void(0)" onclick="toViewExamInfo(\''+row.CID+'\',\''+row.ID+'\')" class="viewExamInfo"></a>'
	        	  //var s2 = '<a href="${pageContext.request.contextPath}/paper/inEditExamInfo?cid=' + row.cid + '&eid=' + row.eid + '" class="editExamInfo"></a>';
	        	  return s1;
	          }},
	          {field:'PAPER',title:'A、B卷',width:60,align:'left',formatter:function(value,row,index){
	        	  if(row.AORB == 0){
	        		  return 'A卷 ';
	        	  }else if(row.AORB == 1){
	        		  return 'B卷 ';
	        	  }else{
	        		  return 'C卷 ';
	        	  }
	          }},
	          /* {field:'state',title:'状态',width:40,align:'center',formatter:function(value,row,index){
	        	  var s = '通过审核待考';
	        	  return s;	
	          }}, */
	    ]],
	    onLoadSuccess:function(data){
	    	$('.viewExamInfo').linkbutton({text:'查看',plain:true});
	    }
	});
	
	var buttons =[];
	
	var p = $('#datalist').datagrid('getPager');
	$(p).pagination({buttons: buttons});
	
	
});

function paperFilter(){
	var val = $('#stateList').val();
	var state = '';
	if(val == 0){
		state = '?state=0&state=1&state=2&state=3&state=5&state=6&state=7&state=8&state=-2';//[0, 1, 2, 3, 5, 6, 7, 8];
	}else if(val == 1){
		state = '?state=0&state=1&state=2&state=7';//[0, 1, 2, 7];
	}else if(val == 2){
		state = '?state=3&state=5';//[3, 5];
	}else if(val == 3){
		state = '?state=6&state=8';//[6, 8];
	}else if(val == -2){
		state = '?state=-2';//[6, 8];
	}
	var p = $('#datalist').datagrid('getPager');
 	$('#datalist').datagrid({
 		url:'${pageContext.request.contextPath}/paper/getPaperList' + state,
 	 	load: {
 	 		cid : cid,
 	    	page : $(p).pagination('options').pageNumber,
 	    	rows : $(p).pagination('options').pageSize
 	 	}
 	});
};

function addQuestionFromPaper(){
	var res = [];
	var cids = cid.split(",");
	var rows = $('#datalist').datagrid('getSelections');
	if(rows.length > 0){
		for(var i=0; i<rows.length; i++){
			var temp = (rows[i].CID).split(",");
			for(var j=0; j<temp.length; j++){
				if($.inArray(temp[j], cids)==-1){
					cids.push(temp[j]);
				}
			}
			res.push(rows[i].ID);
		}
		window.location.href = '${pageContext.request.contextPath}/paper/QuestionFromPaper?cid=' + uniqueArray(cids) + '&eid=' + eid + '&eids=' + uniqueArray(res) + '&state=' +1;
	}else{
		toastr.warning('请勾选需要合并的试卷');
		return false;
	}	
}

function uniqueArray(a){
    temp = new Array();
    for(var i = 0; i < a.length; i ++){
        if(!contains(temp, a[i])){
            temp.length+=1;
            temp[temp.length-1] = a[i];
        }
    }
    return temp;
}

function contains(a, e){
    for(j=0;j<a.length;j++)if(a[j]==e)return true;
    return false;
}

function toViewExamInfo(cid,eid){
	openIframeDialog({
		url:"${pageContext.request.contextPath}/paper/viewExamInfo?cid="+cid+"&eid=" + eid,
		fit:true,
		title:'查看考务'
	},0);
}
</script>	