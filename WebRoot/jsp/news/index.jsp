<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/images/svg/loadEatBeans.css">
<style>
	.table th, .table td {  
		vertical-align: middle!important;  
		font-size:14px;
	}  
	.title_h4{
		background-color:#DCEBFE;
		color:black;
	}
	@keyframes bounce {
		0% {
			transform: translate3d(0, 0, 0);
			text-shadow: rgba(255, 255, 255, 0.4) 0 0 0.05em;
		}
		100% {
			transform: translate3d(0, -0.5em, 0);
			text-shadow: rgba(255, 255, 255, 0.4) 0 1em 0.35em;
		}
	}

	.modal-content-data {
		background: rgba(26, 26, 26, 0.96);
		color: #f0f0f0;
		border: 1px solid #00ffff;
		box-shadow: 0 0 15px #00ffff;
		position: relative;
	}
	.modal-header-data {
		border-bottom: 1px solid #00ffff;
	}
	.modal-footer-data {
		border-top: 1px solid #00ffff;
	}
	.custom-title {
		font-size: 1.5rem;
		font-weight: bold;
		color: #00ffff;
	}
	.data-section {
		margin-bottom: 1rem;
	}
	.data-section h5 {
		color: #00ffff;
		border-bottom: 1px solid #00ffff;
		padding-bottom: 0.5rem;
	}
	.data-list li {
		margin-bottom: 0.25rem;
	}
	.last-refresh-container {
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
		bottom: 1rem;
		font-size: 0.9rem;
		color: #cccccc;
	}
	.news-link {
        color: inherit !important; /* 继承父元素颜色 */
        text-decoration: none !important; /* 可选：去除下划线 */
    }
</style>
<div class="container-fluid">
		<div class="row-fluid" style="margin-top:10px;">
			<div class="col-xs-12 text-center  title_h4">
				<h4>题库网考系统数据概览</h4>
			</div>
		</div>
	<div class="row-fluid">
		<table class="table table-bordered table-hover">
			<thead style="width: 100%">
				<th style="width: 100%; text-align: center;">
					<button class="btn btn-primary" id="questionBankDataBtn" type="button" onclick="showQuestionBank()">点击展示</button>
				</th>
			</thead>
		</table>
	</div>
		<div class="row-fluid" style="margin-top:10px;">
			<div class="col-xs-12 text-center  title_h4">
				<h4>最新公告</h4>
			</div>
		</div>
	<div class="row-fluid">
		<table id="newsTable" class="table table-bordered table-hover">
			<thead>
			<tr>
				<th>资讯标题</th>
				<th>发布人</th>
				<th>发布时间</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach var="news" items="${newsList}">
				<tr>
					<td><a href="${pageContext.request.contextPath}/news/getNews?id=${news.ID}" class="news-link">${news.TITLE}</a></td>
					<td>${news.FBR}</td>
					<td>${news.ADDTIME}</td>
					<td>
						<a href="${pageContext.request.contextPath}/news/getNews?id=${news.ID}">
							详细信息
						</a>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="row-fluid">
		<div class="col-xs-12 text-center title_h4">
			<button class="btn btn-info" id="relatedPapersBtn" type="button">
				与我直接相关待处理的试卷
				<span id="paperCountBadge" class="badge" style="background-color: red; display: none;">0</span>
			</button>
		</div>

		<div id="paperListContainer" style="display:none;">
			<div class="row-fluid">
				<table class="table table-bordered text-center table-hover" id="paperListTable">
					<thead>
					<tr>
						<th class="text-center">编号</th>
						<th class="text-center col-xs-2">考试科目</th>
						<th class="text-center col-xs-1">年级</th>
						<th class="text-center col-xs-1">考试专业</th>
						<th class="text-center">考试日期</th>
						<th class="text-center">组卷人</th>
						<th class="text-center" colspan="2">A卷考务信息</th>
						<th class="text-center" colspan="5">A卷</th>
						<th class="text-center" colspan="5">B卷</th>
						<th class="text-center">试卷状态</th>
					</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
			<div class="pagination" id="paperPagination">

			</div>
		</div>
	</div>

</div>
	<div class="modal fade" id="Errorinfo" tabindex="-1" role="dialog"
		aria-labelledby="TipsLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" style="position: absolute" id="TipsLabel">提示</h4>
				</div>
				<div class="modal-body" id="msg">
					
				</div>
				<div class="modal-footer">
					<div class="btn btn-primary" data-dismiss="modal">确定</div>
				</div>
			</div>
		</div>
	</div>
<div class="modal fade" id="timeError_modal" tabindex="-1" role="dialog"
	 aria-labelledby="TipsLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" style="position: absolute" id="Tips">答题时间提示</h4>
			</div>
			<div class="modal-body" id="msg1">

			</div>
			<div class="modal-footer">
				<div class="btn btn-dark" data-dismiss="modal">取消</div>
				<div class="btn btn-primary" data-dismiss="modal">确定</div>
			</div>
		</div>
	</div>
</div>
	<div class="modal fade" id="delApaper_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" style="position: absolute" >注意</h4>
	            </div>
	            <div class="modal-body">			            
            		您将删除A卷，如果存在B卷，B卷将被彻底删除，继续操作请点击确定！
	            </div>
	            <div class="modal-footer">
	                <div class="btn btn-dark" data-dismiss="modal">取消</div>
	                <div class="btn btn-primary" onclick="deletePaperA_sure()">确定</div>
	            </div>
	        </div>
	    </div>
	</div>
	<div class="modal fade" id="delBpaper_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" style="position: absolute" >注意</h4>
	            </div>
	            <div class="modal-body">			            
            		您将彻底删除B卷，A卷将会保留，此操作不可恢复，继续操作请点击确定！
	            </div>
	            <div class="modal-footer">
	                <div class="btn btn-dark" data-dismiss="modal">取消</div>
	                <div class="btn btn-primary" onclick="deletePaperB_sure()">确定</div>
	            </div>
	        </div>
	    </div>
	</div>

<div class="modal fade" id="dataModal" tabindex="-1" role="dialog" aria-labelledby="dataModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-scrollable modal-lg" role="document">
		<div class="modal-content modal-content-data">
			<div class="modal-header modal-header-data" style="align-items: flex-end">
				<h5 class="modal-title custom-title" id="dataModalLabel">题库总体数据概览</h5>
				<span style="font-size: 14px;color: #cccccc;margin-left: 10px;">(提示：该数据每整点15分会自动更新，您也可以点击右下角按钮手动更新)</span>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:#fff;">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="data-section">
					<h5>基本统计</h5>
					<ul class="data-list list-unstyled">
						<li><strong>课程试题总和:</strong> <span id="QUESTIONTOTAL"></span></li>
						<li><strong>过去7天创建的试卷:</strong> <span id="LAST7EXAM"></span></li>
						<li><strong>过去30天更新试题数量:</strong> <span id="LAST30UPDATETIME"></span></li>
						<li><strong>过去30天新增的试题:</strong> <span id="LAST30ADDTIME"></span></li>
						<li><strong>过去30天更新题目的人员数:</strong> <span id="LAST30UPDATOR"></span></li>
						<li><strong>过去30天审核题目的人员数:</strong> <span id="LAST30VERIFIER"></span></li>
						<li><strong>在线人数:</strong> <span id="onlineCount"></span></li>
						<li><strong>系统总登录人次:</strong> <span id="LOGINTOTAL"></span></li>
					</ul>
				</div>

				<div class="data-section">
					<h5>题目类型统计</h5>
					<table class="table table-dark table-bordered table-sm">
						<thead>
						<tr>
							<th>题型名</th>
							<th>试题数量</th>
						</tr>
						</thead>
						<tbody id="examAnswerTypeTableBody">
						<!-- 动态插入 -->
						</tbody>
					</table>
				</div>
			</div>
			<div class="modal-footer modal-footer-data">
				<div class="last-refresh-container">
					<span>最后更新时间: <span id="lastRefresh"></span></span>
				</div>
				<div class="load20" style="margin-top:0px; margin-right: 40px;display: none">
					<div></div><div></div><div></div><div></div><div></div>
				</div>
				<button id="refreshDataBtn" type="button" class="btn btn-info" onclick="refreshData()">更新</button>
			</div>
		</div>
	</div>
</div>
<script src="${pageContext.request.contextPath}/styles/js/jquery-3.6.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/bootstrap/v4.6.2/js/bootstrap.min.js"></script>
<script type="text/javascript">

$(function(){
	localStorage.preUrl = "${pageContext.request.contextPath}/news/newsList";
	var $rows = $('#newsTable tbody tr');
	if ($rows.length > 5) {
		// 隐藏第 6 行及以后的所有行
		$rows.slice(5).hide();

		// 动态插入“展开更多”按钮
		var $btn = $('<a href="#" id="toggleNews">展开更多公告</a>');
		$('#newsTable').after($btn);

		$btn.on('click', function(e){
			e.preventDefault();
			if ($(this).text() === '展开更多公告') {
				$rows.show();
				$(this).text('收起更多公告');
			} else {
				$rows.slice(5).hide();
				$(this).text('展开更多公告');
			}
		});
	}
	$.ajax({
		url: "${pageContext.request.contextPath}/news/getPendingPaperCount",
		type: "POST",
		success: function(count) {
			if(count > 0) {
				$("#paperCountBadge").text(count).show();
			}
		}
	});

	// 点击“相关试卷”按钮
	$("#relatedPapersBtn").click(function() {
		$("#paperListContainer").toggle();
		var isOpen = $("#paperListContainer").is(":visible");
		localStorage.setItem("openIndexPaper", isOpen ? "1" : "0");
		if (isOpen) fetchPaperList(1);
	});

	if (localStorage.getItem("openIndexPaper") === "1") {
		$("#paperListContainer").show();
		fetchPaperList(1);
	} else {
		$("#paperListContainer").hide();
	}
});

function fetchPaperList(page) {
	$.ajax({
		url: "${pageContext.request.contextPath}/news/getPaperListData",
		type: "POST",
		data: { page: page, rows: 20 },
		success: function(data) {
			// 清空现有表格内容
			$("#paperListTable tbody").empty();

			data.rows.forEach(function(paper) {
				var row = "<tr>";
				row += "<td>" + paper.eid + "</td>"; // 编号
				row += "<td>" + paper.ename + "</td>"; // 考试科目
				row += "<td>" + paper.grade + "</td>"; // 年级
				row += "<td>" + paper.special + "</td>"; // 考试专业
				row += "<td>" + paper.exam_date + "</td>"; // 考试日期
				row += "<td>" + paper.tname + "</td>"; // 组卷人
				row += "<td><a href='javascript:void(0);' onclick='inViewExamInfo(\"" + paper.cid + "\", \"" + paper.eid + "\", \"" + paper.ename + "\", \"" + paper.state + "\")'>查看</a></td>";
				if(paper.state == 8 || paper.state == 6){
					row += "<td>编辑</td>";
				}else{
					row += "<td><a href='javascript:void(0);' onclick='inEditExamInfo(\"" + paper.cid + "\", \"" + paper.eid + "\", \"" + paper.ename + "\", \"" + paper.state + "\")'>编辑</a></td>";
				}
				row += "<td>" + paper.asum + "题</td>"; // A卷题目数
				if(paper.state == 8 || paper.state == 6){
					row += "<td>编辑</td>";
				}else{
					row += "<td><a href='javascript:void(0);' onclick='editPaperA(\"" + paper.cid + "\", \"" + paper.eid + "\", \"" + paper.state + "\")'>编辑</a></td>";
				}

				row += "<td>" + paper.a_snum + "考生</td>"; // A卷考生数
				row += "<td><a href='javascript:void(0);' onclick='testPaper(\"" + paper.eid + "\")'>测试</a></td>";
				let delBtn = "<td> </td>";
				if(paper.state==0 || paper.state==1){
					delBtn = "<td><a href='javascript:void(0);' onclick='deletePaperA(\"" + paper.eid + "\", this)'>删除</a></td>";
				}
				row += delBtn;

				// 如果B卷存在
				if (paper.bid != null) {
					row += "<td>B卷" + paper.bnum + "题</td>"; // B卷题目数
					if(paper.state == 8 || paper.state == 6){
						row += "<td>编辑</td>";
					}else{
						row += "<td><a href='javascript:void(0);' onclick='editPaperB(\"" + paper.cid + "\", \"" + paper.bid + "\", \"" + paper.state + "\")'>编辑</a></td>";
					}
					row += "<td>" + paper.b_snum + "考生</td>"; // B卷考生数
					row += "<td><a href='javascript:void(0);' onclick='testPaper(\"" + paper.bid + "\")'>测试</a></td>";
					let delBtnB = "<td> </td>";
					if(paper.state==0 || paper.state==1){
						delBtnB = "<td><a href='javascript:void(0);' onclick='deletePaperB(\"" + paper.bid + "\", this)'>删除</a></td>";
					}
					row += delBtnB;
				} else if(paper.state_desc === '未审核'){
                  	row += "<td colspan='5'><a href='javascript:void(0);' onclick='generateBpaper(\"" + paper.eid + "\", \"" + paper.cid + "\")'>生成B卷</a></td>";
                } else {
					row += "<td colspan='5'>生成B卷（仅限未审核状态）</td>";
				}

				// 试卷状态
				row += "<td>" + (paper.state_desc === '审核不通过' ? "<font color='red'><strong>" + paper.state_desc + "</strong></font>" : paper.state_desc) + "</td>";

				row += "</tr>";
				$("#paperListTable tbody").append(row);
			});

			setupPagination(
					data.total,       // 总条数
					page,             // 当前页
					fetchPaperList,   // 点击分页时重新拉哪个方法
					"#paperPagination", // 渲染到哪个容器
					20                // 每页 20 条
			);
		}
	});
}

function setupPagination(totalCount, currentPage, fetchFn, containerSel, pageSize = 20) {
	var totalPages = Math.ceil(totalCount / pageSize);
	var $box = $(containerSel).empty();

	// 上一页
	if (currentPage > 1) {
		$("<a href='javascript:void(0)'>上一页</a>")
				.click(function(e){
					e.preventDefault();
					fetchFn(currentPage - 1);
				})
				.appendTo($box)
				.after(" ");
	}

	// 下一页
	if (currentPage < totalPages) {
		$("<a href='javascript:void(0)'>下一页</a>")
				.click(function(e){
					e.preventDefault();
					fetchFn(currentPage + 1);
				})
				.appendTo($box);
	}
}

function formatBytes(bytes) {
	if (bytes === null || typeof(bytes) === "undefined") return "";
	var b = parseFloat(bytes);
	if (isNaN(b)) return "";

	var kb = 1024;
	var mb = kb * 1024;
	var gb = mb * 1024;
	var tb = gb * 1024;

	if (b >= tb) return (Math.round((b / tb) * 100) / 100) + " TB";
	if (b >= gb) return (Math.round((b / gb) * 100) / 100) + " GB";
	if (b >= mb) return (Math.round((b / mb) * 100) / 100) + " MB";
	if (b >= kb) return (Math.round((b / kb) * 100) / 100) + " KB";
	return b + " B";
}

function escapeHtml(str) {
	if (str === null || typeof(str) === "undefined") return "";
	return String(str)
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#39;");
}

var currentData = null; // 用于存储当前数据
function inViewExamInfo(cid,eid,ename,state){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	}
	var url = ""
	if(state==3 || state==4 || state==5 || state==6 || state==8){
		url = "${pageContext.request.contextPath}/paper/viewExamInfo?cid=" + cid + "&eid=" + eid + "&action=verified";
	}else{
		url = "${pageContext.request.contextPath}/paper/viewExamInfo?cid=" + cid + "&eid=" + eid;
	}
	
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: "查看《"+ename+"》考务信息",
		content: content,
		closable: true 
	});	
}

function inEditExamInfo(cid,eid,ename,state){
	if(typeof(mqid) == "undefined"){
		mqid = "";
	}
	var url = "";
	if(state==3 || state==4 || state==5 || state==6 || state==8){
		url = "${pageContext.request.contextPath}/paper/inEditExamInfo?cid=" + cid + "&eid=" + eid + "&action=verified";
	}else{
		url = "${pageContext.request.contextPath}/paper/inEditExamInfo?cid=" + cid + "&eid=" + eid;
	}
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: "编辑《"+ename+"》考务信息",
		content: content,
		closable: true 
	});	
}

function editPaperA(cid,eid,state){
	localStorage.preUrl = "${pageContext.request.contextPath}/news/newsList";
	//状态为-1、0、1、2、7的试卷可以再编辑	
	if(state==-1||state==0||state==1||state==2||state==7){
		window.location.href="${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid;
	}else{		
		window.location.href="${pageContext.request.contextPath}/paper/editApaper?c_id=" + cid + "&ei_id=" + eid+ "&readonly=1";
	}	
}

function testPaper(eid){
	$.ajax({
		url: '${pageContext.request.contextPath}/paper/getPaperNoScore',
		async: false,
		type: "POST",
		data: {"eid":eid},
		success:function(data){
			if(data==0){
				window.open("${pageContext.request.contextPath}/paper/testPaper?eid="+eid,'fullscreen=1'); 
			}else{
				$("#msg").html(data);
				$('#Errorinfo').modal({
					keyboard : true
				});
			}
		}
	})
}

var $elt;
var _eid;
function deletePaperA(eid,elt){
	$elt=$(elt);
	_eid=eid;
	$('#delApaper_modal').modal({
		keyboard : true
	});
}

function deletePaperA_sure(){
	$("#delApaper_modal").modal("hide");
	$.ajax({
        url: "${pageContext.request.contextPath}/verify/deletePaper",
        async: true,//改为同步方式
        type: "POST",
        traditional: true,
        data: { "eid":_eid },
        success: function (data) {
        	$elt.parent().parent().remove();
        }
	});	
}

function deletePaperB(eid,elt){
	$elt=$(elt);
	_eid=eid;
	$('#delBpaper_modal').modal({
		keyboard : true
	});
}

function deletePaperB_sure(){
	$("#delBpaper_modal").modal("hide");
	$.ajax({
        url: "${pageContext.request.contextPath}/verify/deletePaper",
        async: true,//改为同步方式
        type: "POST",
        traditional: true,
        data: { "eid":_eid },
        success: function (data) {
        	window.location.reload();
        }
	});	
}

function editPaperB(cid,bid,state){
	localStorage.preUrl = "${pageContext.request.contextPath}/news/newsList";
	//状态为-1、0、1、2、7的试卷可以再编辑	
	if(state==-1||state==0||state==1||state==2||state==7){
		window.location.href="${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid;
	}else{		
		window.location.href="${pageContext.request.contextPath}/paper/editBpaper?c_id=" + cid + "&ei_id=" + bid+ "&readonly=1";
	}
}

function generateBpaper(eid,cid){
	window.location.href = "${pageContext.request.contextPath}/paper/generateBpaper?aid=" + eid + "&cid=" + cid;
}

function generateBpaper(eid,cid){
	$.ajax({
          url: '${pageContext.request.contextPath}/verify/checkGenerateBpaperPermission',
          async: false, 
          type: "POST",
          data: {"eid":eid},
          success: function (data) {
          	if(data==1){
          		window.location.href = "${pageContext.request.contextPath}/paper/generateBpaper?aid=" + eid + "&cid=" + cid;
          	}else if(data==2){
          		$("#msg").html("无相关权限!");
				$('#Errorinfo').modal({
					keyboard : true
				});
          	}else{
          		$("#msg").html("登录超时，请重新登录!");
				$('#Errorinfo').modal({
					keyboard : true
				});
          	} 	        		
   		}
   	});
}


function appoint(cid,eid,ename,type){
	var params = {};
	params["eid"] = eid;
	$.ajax({
		  contentType: "application/json; charset=utf-8",
          url: '${pageContext.request.contextPath}/verify/checkPaperPermission2',
          async: false, 
          type: "POST",
          data: JSON.stringify(params),
          success: function (data) {
          	if(data==1){
          		var url = "${pageContext.request.contextPath}/verify/appoint?cid=" + cid + "&eid=" + eid+"&type="+type;
          		var content = '<iframe style="width:100%;height:100%;border:0;overflow:auto;" src="'+url+'"></iframe>';
          		window.parent.$('#nav_tab').tabs('add',{
          			title: "《"+ename+"》试卷权限设置",
          			content: content,
          			closable: true
          		});
          	}else if(data==2){
          		$("#msg").html("无相关权限!");
				$('#Errorinfo').modal({
					keyboard : true
				});
          	}else{
          		$("#msg").html("登录超时，请重新登录!");
				$('#Errorinfo').modal({
					keyboard : true
				});
          	} 	        		
   		}
   	});
}

function submitForVer(eid,bid,cid){
	if (bid===null || typeof(bid) === "undefined" || bid === "undefined" || bid==="null") {
		bid = "";
	}
	$.ajax({
          url: '${pageContext.request.contextPath}/verify/checkAutoTest',
          async: false, 
          type: "POST",
          data: {"eid":eid,"bid":bid},
          success: function (data) {
          	if(data==1){
          		window.location.href = "${pageContext.request.contextPath}/verify/submitForVer?eid=" + eid + "&cid=" + cid;
          	}else{
				if(data.indexOf('timeErrorB')>-1){
					$("#msg1").html("B卷有作答时间少于30s（包含）的试题，请确认作答时间设置是否合理，题号为"+data.substring(9)+",如需修改可取消提交审核。");
					$('#timeError_modal').modal({
						keyboard : true
					});
				}else if(data.indexOf('timeErrorC')>-1){
					$("#msg1").html("C卷有作答时间少于30s（包含）的试题，请确认作答时间设置是否合理，题号为"+data.substring(9)+",如需修改可取消提交审核。");
					$('#timeError_modal').modal({
						keyboard : true
					});
				}else if(data.indexOf('timeError')>-1){
					$("#msg1").html("A卷有作答时间少于30s（包含）的试题，请确认作答时间设置是否合理，题号为"+data.substring(9)+",如需修改可取消提交审核。");
					$('#timeError_modal').modal({
						keyboard : true
					});
				}else{
					$("#msg").html(data);
					$('#Errorinfo').modal({
						keyboard : true
					});
				}
          	}	        		
   		}
   	});
}

function toFirstVerify(eid,bid,cpid,cid){
	if (bid===null || typeof(bid) === "undefined" || bid === "undefined" || bid==="null") {
		bid = "";
	}

	if (typeof(cpid) == "undefined") { 
		cpid = "";
	}
	$.ajax({
		url: "${pageContext.request.contextPath}/verify/haveRight",
		async: false,
		type: "POST",
		data: { 'eid':eid, 'permission':'paper:firstVerify'},
		success: function (data) {
			if(parseInt(data) === 1){
				$.ajax({
					url : "${pageContext.request.contextPath}/verify/checkAutoTest",
					async : false,
					type : "POST",
					data: {"eid":eid,"bid":bid,"cpid":cpid},
					success: function(data){
						if(data==1){
							window.location.href="${pageContext.request.contextPath}/verify/firstVerify?eid="+eid+"&cid="+cid;
						}else{
							$("#msg").html(data);
							$('#Errorinfo').modal({
								keyboard : true
							});
						}
					}
				});
			}else{
				$("#msg").html("没有初审权限，无法进入！");
				$('#Errorinfo').modal({
					keyboard : true
				});
			}
		}
	});
}

function toLastVerify(eid,cid){
	$.ajax({
		url: "${pageContext.request.contextPath}/verify/haveRight",
		async: false,
		type: "POST",
		data: { 'eid':eid, 'permission':'paper:lastVerify'},
		success: function (data) {
			if(parseInt(data) === 1){
				window.location.href="${pageContext.request.contextPath}/verify/lastVerify?eid="+eid+"&cid="+cid;
			}else{
				$("#msg").html("没有终审权限，无法进入！");
				$('#Errorinfo').modal({
					keyboard : true
				});
			}
		}
	});
}

function verifyAgain(eid,bid,cid){
	if (typeof(bid) == "undefined") { 
		bid = "";
	}
	$.ajax({
		url : "${pageContext.request.contextPath}/paper/getPaperNoScore",
		async : false,
		type : "POST",
		data: {"eid":eid,"bid":bid},
		success: function(data){
			if(data==0){
				window.location.href="${pageContext.request.contextPath}/verify/reVerify?eid="+eid+"&cid="+cid;
			}else{
				$("#msg").html(data);
				$('#Errorinfo').modal({
					keyboard : true
				});
			}
		}
	})
}


function intoMonitor(eid){
	window.location.href = "${pageContext.request.contextPath}/monitor/intoMonitor?eid=" + eid+ "&type=index";	
}

function correctPaper(cid,eid,ename){
	var url = "${pageContext.request.contextPath}/result/correctPaper?cid=" + cid + "&eid=" + eid + "&ename=" + ename+"&rstate=0";
	var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
	window.parent.$('#nav_tab').tabs('add',{
		title: "《"+ename+"》改卷",
		content: content,
		closable: true 
	});
	//window.location.href = "${pageContext.request.contextPath}/result/correctPaper?cid=" + cid + "&eid=" + eid + "&ename=" + ename;
}

function refresh(f){
	var page=1;
	if(f=="prev"){
		page=parseInt($("#page").val())-1;
		if(page<=0){
			page=1;
		}
	}
	if(f=="next"){
		page=parseInt($("#page").val())+1;
	}
	window.location.href = "${pageContext.request.contextPath}/news/newsList?page="+page+"&rows="+$("#rows").val();
}

function refreshData() {
	$("#refreshDataBtn").attr("disabled",true);
	$("#refreshDataBtn").text("计算中");
	$(".load20").css('display','block');
	$.ajax({
		url : "${pageContext.request.contextPath}/news/refreshQuestionBankData",
		type : "POST",
		success: function(newData){
			$("#refreshDataBtn").attr("disabled",false);
			$("#refreshDataBtn").text("更新");
			$(".load20").css('display','none');
			currentData = newData;
			populateData(newData);
		}
	});
}

function showQuestionBank(){
	$.ajax({
		url : "${pageContext.request.contextPath}/news/getQuestionBankData",
		async : false,
		type : "POST",
		success: function(data){
			currentData = data;
			populateData(data);
			$('#dataModal').modal('show');
		}
	});
}

function populateData(data) {
	$('#LAST7EXAM').text(data.LAST7EXAM);
	$('#onlineCount').text(data.onlineCount);
	$('#QUESTIONTOTAL').text(data.QUESTIONTOTAL);
	$('#LAST30UPDATETIME').text(data.LAST30UPDATETIME);
	$('#LAST30ADDTIME').text(data.LAST30ADDTIME);
	$('#LAST30UPDATOR').text(data.LAST30UPDATOR);
	$('#LAST30VERIFIER').text(data.LAST30VERIFIER);
	$('#LOGINTOTAL').text(data.LOGINTOTAL);

	$('#lastRefresh').text(formatTimestamp(data.lastRefresh));

	var examTableBody = $('#examAnswerTypeTableBody');
	examTableBody.empty();
	if(data.examAnswerTypeTotal && data.examAnswerTypeTotal.length > 0) {
		data.examAnswerTypeTotal.forEach(function(item) {
			var row = '<tr><td>' + item.NAME + '</td><td>' + item.QCOUNT + '</td></tr>';
			examTableBody.append(row);
		});
	}
}

function formatTimestamp(ts) {
	var d = new Date(ts);
	return d.getFullYear() + '-' +
			(d.getMonth()+1).toString().padStart(2,'0') + '-' +
			d.getDate().toString().padStart(2,'0') + ' ' +
			d.getHours().toString().padStart(2,'0') + ':' +
			d.getMinutes().toString().padStart(2,'0') + ':' +
			d.getSeconds().toString().padStart(2,'0');
}

</script>	

