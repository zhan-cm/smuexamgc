<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<style>
table {
	border-spacing: 0;
	border-collapse: collapse;
	border-radius: 3px;
}
td, th {
	padding: 5px;
	line-height: 1.6;
	vertical-align: center;
	/* border-top: 1px solid #ddd; */
	border: 1px solid #ddd;
}
.title{
	font-size: 22px;
	text-align: center;
	margin: 15px 0 ;
}
.sInfo{
	margin: 10px auto;
	height: 30px;
	text-align: center;
}
.preblock{
	display: block;
    padding: 9.5px;
    margin: 18px 0 10px;
    /* font-size: 13px; */
    line-height: 1.428571429;
    color: #333;
    word-break: break-all;
    word-wrap: break-word;
    background-color: #f5f5f5;
    border: 1px solid #ccc;
    border-radius: 4px;
    white-space: pre-wrap;
}
.sanswer {
	color: red;
	display: inline;
}
.commentText{
	width: 95%;
	/* display: table-cell; */
	font-size: 14px;
	vertical-align: middle;
}
</style>
<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back();">返回</a>
<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back2List();">返回学生列表</a>
<div id="dlg-toolbar" style="height:26px;">
	<!-- <a href="javascript:void(0);" onclick="window.history.go(-1);return false;" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true">返回</a> -->
	<input type="hidden" id="eid" value="${eid}"/>
	<input type="hidden" id="sort" value="${sort}"/>
	<input type="hidden" id="order" value="${order}"/>
	<input type="hidden" id="specialty" value="${specialty}"/>
	<input type="hidden" id="grade" value="${grade}"/>
	<input type="hidden" id="klass" value="${klass}"/>
	<input type="hidden" id="addid" name="addid" value="${addid}"/>
	<input type="hidden" id="pgState" name="pgState" value="${pgState}"/>
	<input type="hidden" id="sid" value="${student.id}"/>
</div>
<h1 class="title">${examInfo.SCHOOLYEAR}-${examInfo.SCHOOLYEAR + 1}学年${examInfo.TERMNAME}</h1>
<h1 class="title">${examInfo.ENAME}</h1>
<div class="sInfo">
姓名： ${student.name}&nbsp;&nbsp;&nbsp;&nbsp;
学号： ${student.num}&nbsp;&nbsp;&nbsp;&nbsp;
专业： ${student.specialty_name}&nbsp;&nbsp;&nbsp;&nbsp;
年级： ${student.grade_name}
</div>
<table cellpadding="0" cellspacing="0" style="width:100%;">
	<tr>
		<td>考试时间	${examInfo.BEGINDATE}~${examInfo.ENDDATE}</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%;">
	<tr>
		<td style="width:50%;">学时数	${examInfo.PERIOD}</td>
		<td>负责人	${examInfo.TEACHERNAME}</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" style="width:100%;">
	<tr>
		<td>题号</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td>
				${t.index + 1}
			</td>
		</c:forEach>
		<td>合计</td>
	</tr>
	<tr>
		<td>题型</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td>
				${qt.QTNAME}
			</td>
		</c:forEach>
		<td></td>
	</tr>
	<tr>
		<td>满分</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td class="qtscore">
				<span class="qtpoint">${qt.score }</span>
			</td>
		</c:forEach>
		<td class="amount"></td>
	</tr>
	<tr>
		<td>得分</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td class="sqtscore">
				<span class="sqtpoint">${qt.sascore }</span>
			</td>
		</c:forEach>
		<td class="samount"></td>
	</tr>
	<tr>
		<td>评卷人</td>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<td>
				${qt.correct_teacher }
			</td>
		</c:forEach>
		<td>${reviewTeacher }</td>
	</tr>
</table>
	<c:set var="qindex" value="0"></c:set>
	<c:forEach var="qt" items="${questiontype}" varStatus="t">
		<table cellpadding="0" cellspacing="0" style="width:10%;margin-top: 28px;">
			<tr>
				<th><span class="qindex">${t.index + 1}</span>、得分</th>
			</tr>
			<tr>
				<th><span class="qtid_${qt.QTID}">${qt.sascore }</span></th>
			</tr>
		</table>
		<h1 style="margin:25px 0 8px; font-size: 14px;"><span class="">${t.index + 1}</span>,&nbsp;${qt.QTNAME}&nbsp;(${qt.QTDESC})</h1>
		<c:forEach var="item" items="${res}">
			<c:choose>				
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && (qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==8||qt.ATID==9)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<pre class="preblock">${branch.content}</pre>
								<c:choose>
								    <c:when test="${qt.ATID == 0||qt.ATID==2||qt.ATID==8}">
								    	<c:set var="rightAns"></c:set>
								    	<c:set var="stuAns"></c:set>
								    	<c:forEach var="ans" items="${branch.answer}" varStatus="a">
								    		<c:if test="${ans.aid==branch.answerid }">
								    			<c:set var="rightAns" value="${a.index}"></c:set>
								    		</c:if>
								    		<c:if test="${ans.aid==branch.said }">
								    			<c:set var="stuAns" value="${a.index}"></c:set>
								    		</c:if>
								    		<c:choose>
								    			<c:when test="${ans.acontent!=null and ans.acontent!='' }">
								    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent}</p>
								    			</c:when>
								    			<c:otherwise>
								    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent_6}</p>
								    			</c:otherwise>
								    		</c:choose>
											
										</c:forEach>
								    	<p>
								    		<div style="color:grey;">试题答案:&nbsp;<span class="ansIndex">${rightAns}</span></div>
											<span class="sanswer">学生答案:&nbsp;
												<c:choose>
													<c:when test="${empty stuAns}">
														<span class="sanswer">考生未作答</span>
													</c:when>
													<c:otherwise>
														<span class="ansIndex">${stuAns}</span>
													</c:otherwise>
												</c:choose>
											</span>
										</p>
										<p>
											学生得分:&nbsp;<span>${branch.averagescore}</span>
											<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
											此题满分:&nbsp;<span>${branch.score}</span>
										</p>
								    </c:when>
								    <c:when test="${qt.ATID == 1||qt.ATID==3||qt.ATID==9}">
								    	<c:set var="ansOrder"></c:set>
								    	<c:set var="contact" value=","></c:set>
								    	<c:forEach var="ans" items="${branch.answer}" varStatus="a">
								    		<c:set var="ansOrder" value="${ansOrder }${contact }${ans.aid }"></c:set>	
								    		<c:choose>
								    			<c:when test="${ans.acontent!=null and ans.acontent!='' }">
								    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent}</p>
								    			</c:when>
								    			<c:otherwise>
								    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent_6}</p>
								    			</c:otherwise>
								    		</c:choose>
										</c:forEach>
								    	<p>
											<div style="color:grey;">试题答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${branch.answerid}</span></div>
											<span class="sanswer">学生答案:&nbsp;
												<c:choose>
													<c:when test="${empty branch.said}">
														<span class="multiselect" ansOrder="${ansOrder }">考生未作答</span>
													</c:when>
													<c:otherwise>
														<span class="multiselect" ansOrder="${ansOrder }">${branch.said}</span>
													</c:otherwise>
												</c:choose>

											</span>
										</p>
										<p>
											学生得分:&nbsp;<span>${branch.averagescore}</span>
											<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
											此题满分:&nbsp;<span >${branch.score}</span>
										</p>
								    </c:when>
							    </c:choose>								
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>				
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && qt.ATID == 4}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<pre class="preblock"><p>${branch.content}</p></pre>
								<p>
									<c:set var="stuAns"/>
									<div style="color:grey;"><span>试题答案:&nbsp;${branch.answer[0].acontent}</span></div>
									<c:if test="${branch.answer[0].aid==branch.said }">
										<c:set var="stuAns" value="${branch.answer[0].acontent }"/>
									</c:if>
									<c:if test="${branch.answer[0].aid!=branch.said }">
										<c:choose>
											<c:when test="${branch.answer[0].acontent=='true' }">
												<c:set var="stuAns" value="false"/>
											</c:when>
											<c:otherwise>
												<c:set var="stuAns" value="true"/>
											</c:otherwise>
										</c:choose>
									</c:if>
									<span class="sanswer">学生答案:&nbsp;
										<c:choose>
											<c:when test="${empty stuAns}">
												<span >考生未作答</span>
											</c:when>
											<c:otherwise>
												<span >${stuAns}</span>
											</c:otherwise>
										</c:choose>
									</span>
								</p>
								<p>
									<span>学生得分:&nbsp;<span>${branch.averagescore}</span></span>
									<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
									<span>此题满分:&nbsp;${branch.score}</span>
								</p>
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>			
				<c:when test="${item.qtype == qt.QTID && item.ismain eq 1 && (qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11||qt.ATID==12)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<c:set var="mqid" value="${item.qid}"></c:set>
					<c:forEach var="branch" items="${res}">
						<c:choose>
							<c:when test="${branch.mqid == mqid}">
								<pre class="preblock">${branch.content}</pre>
								<div style="color:grey;"><span>试题答案:&nbsp;${branch.answer[0].acontent_6}</span></div>
								<div>学生答案:&nbsp;
									<c:choose>
										<c:when test="${qt.ATID==12}">
											<audio src='${branch.sacontent_6}' controls='controls'></audio>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${empty branch.sacontent_6}">
													<div class="sanswer">考生未作答</div>
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${allowPicMark_lock==1}">
															<c:choose>
																<c:when test="${qt.ATID==5||qt.ATID==6||qt.ATID==7}">
																	<div style="margin-top:10px;">
																		<img src="${branch.imageData}" alt="PNG Image"
																			 data-fallback="${fn:escapeXml(branch.sacontent_6)}"
																			 onerror="imageError(this)">
																	</div>
																</c:when>
																<c:otherwise>
																	<div class="sanswer">${branch.sacontent_6}</div>
																</c:otherwise>
															</c:choose>
														</c:when>
														<c:otherwise>
															<div class="sanswer">${branch.sacontent_6}</div>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</div>
								<p>学生得分:&nbsp;<input type="text" class="sscore" value="${branch.averagescore}"/></p>
								<input type="hidden" class="startScore" value="${branch.averagescore}"/>
								<%--<input type="hidden" class="qscore_${qt.QTID}" value="${branch.averagescore}"/>--%>
								<input type="hidden" class="qids" value="${branch.qid}"/>
								<p>此题满分:&nbsp;${branch.score}</p>
								<p>批注：<textarea rows="2" class="commentText comment">${branch.acomment}</textarea></p>
								<p>改卷历史：${branch.allUpdator}</p>
							</c:when>
						</c:choose>
					</c:forEach>
				</c:when>							
				
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && (qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==8||qt.ATID==9)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<c:choose>
					    <c:when test="${qt.ATID == 0||qt.ATID==2||qt.ATID==8}">
							<c:set var="rightAns"></c:set>
					    	<c:set var="stuAns"></c:set>
					    	<c:forEach var="ans" items="${item.answer}" varStatus="a">
					    		<c:if test="${ans.aid==item.answerid }">
					    			<c:set var="rightAns" value="${a.index}"></c:set>
					    		</c:if>
					    		<c:if test="${ans.aid==item.said }">
					    			<c:set var="stuAns" value="${a.index}"></c:set>
					    		</c:if>
					    		<c:choose>
					    			<c:when test="${ans.acontent!=null and ans.acontent!='' }">
					    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent}</p>
					    			</c:when>
					    			<c:otherwise>
					    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent_6}</p>
					    			</c:otherwise>
					    		</c:choose>
							</c:forEach>
							<p>
						    	<div style="color:grey;">试题答案:&nbsp;<span class="ansIndex">${rightAns}</span></div>
								<%--<input value="${stuAns}">--%><%--0--%>
								<span class="sanswer">学生答案:&nbsp;
									<c:choose>
										<c:when test="${qt.ATID==12}">
											<audio src='${stuAns}' controls='controls'></audio>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${empty stuAns}">
													<span class="sanswer">考生未作答</span>
												</c:when>
												<c:otherwise>
													<span class="ansIndex">${stuAns}</span>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</span>
							</p>
							<p>
								学生得分:&nbsp;<span>${item.averagescore}</span>
								<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
								此题满分:&nbsp;<span >${item.score}</span>
							</p>
					    </c:when>
					    <c:when test="${qt.ATID == 1||qt.ATID==3||qt.ATID==9}">
							<c:set var="ansOrder"></c:set>
					    	<c:forEach var="ans" items="${item.answer}" varStatus="a">
					    		<c:set var="ansOrder" value="${ansOrder },${ans.aid }"></c:set>	
					    		<c:choose>
					    			<c:when test="${ans.acontent!=null and ans.acontent!='' }">
					    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent}</p>
					    			</c:when>
					    			<c:otherwise>
					    				<p><span class="ansIndex">${a.index}</span>,&nbsp;${ans.acontent_6}</p>
					    			</c:otherwise>
					    		</c:choose>
							</c:forEach>
							<p>
								<div style="color:grey;">试题答案:&nbsp;<span class="multiselect" ansOrder="${ansOrder }">${item.answerid}</span></div>
								<span class="sanswer">学生答案:&nbsp;
									<c:choose>
										<c:when test="${empty item.said}">
											<span class="sanswer" ansOrder="${ansOrder }">考生未作答</span>
										</c:when>
										<c:otherwise>
											<span class="multiselect" ansOrder="${ansOrder }">${item.said}</span>
										</c:otherwise>
									</c:choose>
								</span>
							</p>
							<p>
								学生得分:&nbsp;<span>${item.averagescore}</span>
								<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
								此题满分:&nbsp;<span >${item.score}</span>
							</p>
					    </c:when>
				    </c:choose>					
				</c:when>							
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && qt.ATID == 4}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<p>
						<c:set var="stuAns"/>
						<div style="color:grey;"><span>试题答案:&nbsp;${item.answer[0].acontent}</span></div>
						<c:if test="${item.answer[0].aid==item.said }">
							<c:set var="stuAns" value="${item.answer[0].acontent }"/>
						</c:if>
						<c:if test="${item.answer[0].aid!=item.said }">
							<c:choose>
								<c:when test="${item.answer[0].acontent=='true' }">
									<c:set var="stuAns" value="false"/>
								</c:when>
								<c:otherwise>
									<c:set var="stuAns" value="true"/>
								</c:otherwise>
							</c:choose>
						</c:if>
						<span class="sanswer">学生答案:&nbsp;
							<c:choose>
								<c:when test="${empty stuAns}">
									<span class=""sanswer>考生未作答</span>
								</c:when>
								<c:otherwise>
									<span>${stuAns}</span>
								</c:otherwise>
							</c:choose>
						</span>
					</p>
					<p>
						<span>学生得分:&nbsp;<span>${item.averagescore}</span></span>
						<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
						<span>此题满分:&nbsp;${item.score}</span>		
					</p>
				</c:when>						
				<c:when test="${item.qtype == qt.QTID && qt.ISCON eq 0 && (qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11||qt.ATID==12)}">
					<c:set var="qindex" value="${qindex + 1}"></c:set>
					<pre class="preblock">${qindex},${item.content}</pre>
					<div style="color:grey;"><span>试题答案:&nbsp;${item.answer[0].acontent_6}</span></div>
					<div>学生答案:&nbsp;
						<c:choose>
							<c:when test="${qt.ATID==12}">
								<audio src='${item.sacontent_6}' controls='controls'></audio>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${empty item.sacontent_6}">
										<span class="sanswer">考生未作答</span>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${allowPicMark_lock==1}">
												<c:choose>
													<c:when test="${qt.ATID==5||qt.ATID==6||qt.ATID==7}">
														<div style="margin-top:10px;">
															<img src="${item.imageData}" alt="PNG Image"
																 data-fallback="${fn:escapeXml(item.sacontent_6)}"
																 onerror="imageError(this)">
														</div>
													</c:when>
													<c:otherwise>
														<div class="sanswer">${item.sacontent_6}</div>
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												<div class="sanswer">${item.sacontent_6}</div>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>


					</div>
					<p>学生得分:&nbsp;<input type="text" class="sscore" value="${item.averagescore}" onblur="checkDouble(this.value,${item.score},this);"/></p>
					<input type="hidden" class="startScore" value="${item.averagescore}"/>
					<%--<input type="hidden" class="qscore_${qt.QTID}" value="${item.averagescore}"/>--%>
					<input type="hidden" class="qids" value="${item.qid}"/>
					<p>此题满分:&nbsp;${item.score}</p>	
					<p>批注：<textarea rows="2" class="commentText comment">${item.acomment}</textarea></p>
					<p>改卷历史：${item.allUpdator}</p>				
				</c:when>		
			</c:choose>
		</c:forEach>
	</c:forEach>
<div style="width: 100%; height: 40px; text-align: center;">
	<c:if test="${not empty pre and pre != '0'}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0)" onclick="review(${examInfo.ID}, '${pre}','next')">审核到上一个学生</a>
	</c:if>
	<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="javascript:void(0);" onclick="review(${examInfo.ID}, '','this')">通过审核</a>&nbsp;
	<a class="easyui-linkbutton" data-options="iconCls:'icon-back'" href="javascript:void(0);" onclick="back();">返回</a>
	<c:if test="${not empty next and next != '0'}">
		<a class="easyui-linkbutton" data-options="iconCls:'icon-next'" href="javascript:void(0)" onclick="review(${examInfo.ID}, '${next}','next')">审核到下一个学生</a>
	</c:if>

</div>

<script type="text/javascript">
$(document).ready(function(){
	$.each($('.ansIndex'),function(i,item){
		var s = $(item).html();
        if(!(/.*[\u4e00-\u9fa5]+.*$/.test(s)))
        {
            $(item).html(String.fromCharCode(parseInt(s)+65));
        }
	});
	$.each($('.multiselect'),function(i,item){
		var ansOrder = $(item).attr("ansOrder").substring(1).split(",");
		var arr = $(item).html().split(',');
		var res = '';
		for(var i=0; i<arr.length; i++){
			for(var j=0;j<ansOrder.length;j++){
				if(parseInt(arr[i])==parseInt(ansOrder[j])){
					res += String.fromCharCode(j+65) + ', ';
				}
			}			
		}
		res = res.substring(0,res.length-1);
		$(item).html(res);
	});

/*
	$.each($('.qtid'),function(i,item){
		var id = $(item).val();
		var str = '.qscore_' + id;
		var num = 0;
		$.each($(str),function(i,item){
			if($(item).val())
			num = (parseFloat(num) + parseFloat($(item).val())).toFixed(1);
		});
		var str1 = '.qtid_' + id;		
		$(str1).text(num);
	});*/
	
	var qtscore = 0;
	$.each($('.qtscore'),function(i,item){
		if($(item).text())
		qtscore = (parseFloat(qtscore) + parseFloat($(item).text())).toFixed(1);
	});
	$('.amount').text(qtscore);

	
	var sqtscore = 0;
	$.each($('.sqtscore'),function(i,item){
		if($(item).text())
		sqtscore = (parseFloat(sqtscore) + parseFloat($(item).text())).toFixed(1);
	});
	$('.samount').text(sqtscore);

	$.each($('.qindex'),function(i,item){
		var qindex = $(item).text();
		if(qindex && !isNaN(qindex)){
			$(item).text(NumberToChinese(qindex));
		}
	});
});

function review(eid, sid,type){
	var specialty = $('#specialty').val();
	var sort = $('#sort').val();
	var order = $('#order').val();
	var grade = $('#grade').val();
	var klass = $('#klass').val();
	let addid = $('#addid').val();
	let pgState = $("#pgState").val();

	var params = {};
	var qids = $(".qids");
	var score = $(".sscore");
	var comment = $(".comment");
	params["eid"] = eid;
	params["sid"] = $('#sid').val();
	var arr = [];
	for(var i=0;i<qids.length;i++){
	    if(typeof score[i]=='undefined'){
	        alert("score"+i);
		}
        if(typeof $(".startScore")[i]=='undefined'){
            alert("startScore"+i);
        }
		if(score[i].value != $(".startScore")[i].value){
			var par = {};
			par["qid"] = qids[i].value;
			par["content"] = score[i].value;
			par["comment"] = comment[i].value;
			arr.push(par);
		}
	}
	params["arr"] = arr;
	$.ajax({
		contentType: "application/json; charset=utf-8",
		url: "${pageContext.request.contextPath}/result/updateStudentPaperScore",
		async: false,
		type: "POST",
		data: JSON.stringify(params),
		success: function(data){
			//do nothing
		}
	});
	$.ajax({
        url: "${pageContext.request.contextPath}/result/reviewThisPaper",
        async: false, 
        type: "POST",
        data: { "eid": eid, "sid": $('#sid').val() },
        success: function (data) {
        	if(data=='-1'){
        		toastr.error('请批改完试卷主观题再进行审核');	
        	}else{
        		if(type=="next"){
					window.location.href = '${pageContext.request.contextPath}/result/reviewPaper?eid=' + eid+'&sid='+sid+'&sort='+sort+'&order='+order+'&specialty='+specialty+'&grade='+grade+'&klass='+encodeURIComponent(klass)+'&addid='+addid+'&pgState='+pgState;
        		}else{
        			toastr.success('审核通过');
        		}
        			
        	}        	
 		}
 	});	
}

function checkDouble(input,max,win){
	var regex = /[^\-?\d.]/g;
	if(regex.test(input)){
		toastr.warning("不能输入中文");
		win.value = input.replace(regex,'');
	}
	if(parseFloat(input) > max){
		toastr.warning("输入的值不能大于题目分值");
		win.value = max;
	}
	if(parseFloat(input) < 0){
		toastr.warning("输入的值不能小于0");
		win.value = 0;
	}
}

function back(){
	window.history.go(-1);
}

function back2List(){
    window.location.href = "${pageContext.request.contextPath}/result/correctPaper?eid=" + $("#eid").val()+"&rstate=0";
}

function imageError(imgElement) {
	let fallbackText = $(imgElement).data('fallback');
	let decodedText = $('<div/>').html(fallbackText).text();
	$(imgElement).replaceWith('<div class="sanswer">' + decodedText + '</div>');
}
</script>	