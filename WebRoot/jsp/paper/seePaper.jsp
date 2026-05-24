<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
	*{
		font-size:12pt;
	}
	table {
		border-spacing: 0;
		border-collapse: collapse;
		border-radius: 3px;
		border:1px solid #ddd;
	}
	td, th {
		padding: 5px;
		line-height: 1.6;
		vertical-align: center;
		/* border-top: 1px solid #ddd; */
		border: 1px solid #ddd;
	}

	#answerTable{
		table-layout:fixed;
		word-break:break-all;
	}

	.tdt{
		width: 10%;
	}
	.preblock{
		display: block;
		line-height: 1.428571429;
		color: #333;
		word-break: keep-all;
		word-wrap: break-word;
		background-color: #f5f5f5;
		border: 1px solid #ccc;
		border-radius: 4px;
		white-space: pre-wrap;
	}
	.morespace{
		padding-bottom:100px;
	}

	.sanswer{
		color:red;
	}

	ol{
		-webkit-padding-start: 4px;
		font-family: 宋体;
		font-size: 12pt !important;
		margin:0 40px;
	}

	.qcontent{
		font-family: 宋体;
		font-size: 12pt !important;
	}
	.qcontent_answer{
		font-family: 宋体;
		font-size: 12pt !important;
	}
	.qcontent_main{
		font-size: 12pt!important;
		display: block;
		line-height: 1.428571429;
		color: #333;
		word-break: keep-all;
		word-wrap: break-word;
		background-color: #f5f5f5;
		border: 1px solid #ccc;
		border-radius: 4px;
		white-space: pre-wrap;
	}
	.head_div{
		text-align:center;
		font-weight:bold;
	}
	.title{
		font-size: 16pt;
		margin:10px 0;
		font-family:SimHei;
	}

	.sInfo{
		margin: 20px auto;
		text-align: center;
	}

	.sInfo span{
		width:80px;
	}
	.answer_zg p{
		display:inline;
		color:red;
	}
	.exam_title{
		font-family:'Microsoft Yahei';
		font-weight:bold;
		font-size:22pt;
	}
	.eInfo{
		margin: 20px auto;

	}
	.eInfo_table{
		width:100%;
		border:0;
		font-family: SimSun;
		font-size:14pt;
		font-weight:bold;
	}
	.eInfo_table td{
		border:0;
		width:50%;
	}
	.eInfo_td_l{
		text-align:left;
	}
	.eInfo_td_r{
		text-align:right;
	}

	.etable{
		margin: 20px auto;
		width:100%;
		font-family: SimSun;
		font-size:14pt;
	}
	.eqtype{
		margin:25px 0 8px;
		font-weight:bold;
		font-family: SimSun;
		font-size:14pt;
	}
	.eqtype_desc{
		font-family: SimSun;
		font-size:10.5pt;
	}
	.econtent{
		font-family: SimSun;
		font-size:10.5pt;
		width:100%;
	}
	.eqtype_div{
		margin:20px auto;
	}
	.fl_table{
		width:100%;
		border:0;
		font-family: SimSun;
		font-size:10.5pt;
	}
	.fl_table td{
		border:0;
		width:50%;
	}
	.answer_table{
		margin:30px 0 30px;
		width:100%;
		border:0;
		font-size:14pt;
	}
	.answer_table .td1{
		text-align:left;
		width:10%;
	}
	.answer_table .td2{
		text-align:left;
		width:15%;
	}
	.answer_table .td3{
		border:0;
		width:80%;
	}
	.table-noborder{
		border-collapse:collapse;
		border:none;
	}
	.table-noborder td{
		border:0;
	}
	p{
		line-height:150%;
	}
</style>
<fmt:requestEncoding value="UTF-8"/>
<input type="hidden" id="ename" value="${examInfo.ENAME}">
<input type="hidden" id="type" value="${examInfo.AORB}">
<input type="hidden" id="code" value="${examInfo.CODE}">
<input type="hidden" id="eid" value="${examInfo.ID}" >
<div style="text-align: center;">
	<table id="optionTable" style="width: 100%;text-align: center;border: none;">
		<tr>
			<td style="border: none;">
				<input type="button"  value="显示答案的试卷" onclick="seePaperWithAnswer()"/>
				<input type="button"  value="不显示答案的试卷" onclick="seePaperNoAnswer()"/>
				<input type="button"  value="仅显示答案" onclick="seePaperOnlyAnswer()"/>
				<input type="button"  value="试题卷" onclick="seeExamPaper()"/>
				<input type="button"  value="答题卷" onclick="seeExamPaper_answer()"/>
				<input id="saveAsWord" type="button" value="保存为word" onclick="saveAsWord()"/>
				<input id="saveAsExcel" type="button" value="导出试题到excel" onclick="exportPaperQuestion()"/>
				<input id="hideSpList" type="Checkbox" onclick="spList()"/> 不显示专业
				<c:if test="${not empty otherSchool}">
					<input type="button"  value="切换学校定制预览" onclick="window.location.href='${pageContext.request.contextPath}/viewPaper/seePaper?eid=${examInfo.ID}'"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<td style="border: none;">
				<a href="javascript:void(0);" onclick="checkList()" class="easyui-linkbutton" data-options="iconCls:'icon-asterisk_orange',plain:true" >双向细目表</a>
				<span style="margin-right: 10px;font-size: 15px;color: #0a76e5">选中后，重新点击显示答卷或答题卷可生效：</span>
				<c:choose>
					<c:when test="${needRandomQuestionType eq 1}">
						<input id="needRandomQuestionType" type="Checkbox" checked="checked"/> 题型顺序随机
					</c:when>
					<c:otherwise>
						<input id="needRandomQuestionType" type="Checkbox"/> 题型顺序随机
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${needRandomQuestion eq 1}">
						<input id="needRandomQuestion" type="Checkbox" checked="checked"/> 题目顺序随机
					</c:when>
					<c:otherwise>
						<input id="needRandomQuestion" type="Checkbox"/> 题目顺序随机
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${needRandomAnswer eq 1}">
						<input id="needRandomAnswer" type="Checkbox" checked="checked"/> 选项顺序随机
					</c:when>
					<c:otherwise>
						<input id="needRandomAnswer" type="Checkbox"/> 选项顺序随机
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
</div>
<div id="paper">
	<div id="paperWithAnswer">
		<div class="head_div">
			<div class="title">
				<span class="schoolName">${organizationinfo.PARAM}</span>
			</div>
			<div class="eobject">
				${examInfo.SCHOOLYEAR}-${examInfo.SCHOOLYEAR + 1}学年 ${examInfo.TERMNAME}<br/>
				<span class="spList">${examObject}<br/></span>
				《${examInfo.ENAME}》
				<c:set var="examType" value=""></c:set>
				<c:forEach var="et" items="${examTypeList}">
					<c:if test="${examInfo.TYPE == et.ID}">
						${et.NAME}
						<c:set var="examType" value="${et.NAME}"></c:set>
					</c:if>
				</c:forEach>
				<c:choose>
					<c:when test="${examInfo.AORB==0 }">
						(A卷)
					</c:when>
					<c:when test="${examInfo.AORB==1 }">
						(B卷)
					</c:when>
					<c:otherwise>
						(C卷)
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="sInfo">
			<span>姓名:</span>_________
			<span>学号:</span>_________
			<span>专业:</span>_________
			<span>年级:</span>_________
		</div>
		<table style="width: 100%; border-collapse: collapse; border-spacing: 0;">
			<tr>
				<td>考试日期：${examdate}</td>
				<td>学时数：${examInfo.PERIOD}</td>
			</tr>
			<tr>
				<td>答卷时间：${examtime}</td>
				<td>负责人：${examInfo.TEACHERNAME}</td>
			</tr>
		</table>
		<table style="width: 100%; border-collapse: collapse; border-spacing: 0;">
			<tr>
				<td>题号</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qindex">
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
				<td>题量</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td>
							${qt.QCOUNT}
					</td>
				</c:forEach>
				<td></td>
			</tr>
			<tr class="score_tr">
				<td>满分</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qtscore">
							${qt.SCORE}
					</td>
				</c:forEach>
				<td class="amount">${qscore }</td>
			</tr>
			<tr>
				<td>得分</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="sqtscore">
					</td>
				</c:forEach>
				<td class="samount"></td>
			</tr>
			<tr>
				<td>评卷人</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="cteacher_${qt.QTID}">
					</td>
				</c:forEach>
				<td></td>
			</tr>
		</table>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<table style="width:15%;margin-top: 30px; border-collapse: collapse; border-spacing: 0;">
				<tr>
					<th style="text-align: left">得分：</th>
				</tr>
				<tr>
					<th><span class="qtid_${qt.QTID}">&nbsp;</span></th>
				</tr>
			</table>
			<span style="margin:25px 0 8px;font-weight:bold;"><span class="qindex">${t.index + 1}</span>、&nbsp;${qt.QTNAME}&nbsp;</span>(答题说明：${qt.QTDESC} 共有${qt.QCOUNT }题，${qt.qtScoreInfo}，合计${qt.SCORE }分。)
			<c:forEach var="item" items="${res}">
				<c:if test="${item.qtype == qt.QTID}">
					<c:choose>
						<c:when test="${item.ismain eq 1}">
							<div class="qcontent_main">${item.content}</div>
							<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
							<c:forEach items="${fileurls}" var="filepath">
								<c:choose>
									<c:when test="${fn:contains(filepath,'mp4')==true}">
										<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
											<source src="${filepath}" type="video/mp4"/>
										</video>
									</c:when>
									<c:when test="${fn:contains(filepath,'mp3')==true}">
										<audio src="${filepath}" controls>
											Your browser does not support the audio element.
										</audio>
									</c:when>
									<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
										<img src="${filepath}" style="max-width:280px;"/>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:set var="mqid" value="${item.qid}"></c:set>
							<c:forEach var="branch" items="${res}">
								<c:choose>
									<c:when test="${branch.mqid == mqid}">
										<div class="qcontent">${branch.th}.${branch.content}</div>
										<c:set var="fileurls" value="${fn:split(branch.filepath, ',')}" />
										<c:forEach items="${fileurls}" var="filepath">
											<c:choose>
												<c:when test="${fn:contains(filepath,'mp4')==true}">
													<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
														<source src="${filepath}" type="video/mp4"/>
													</video>
												</c:when>
												<c:when test="${fn:contains(filepath,'mp3')==true}">
													<audio src="${filepath}" controls>
														Your browser does not support the audio element.
													</audio>
												</c:when>
												<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
													<img src="${filepath}" style="max-width:280px;"/>
												</c:when>
											</c:choose>
										</c:forEach>
										<c:if test="${aFlag == 1}">
											<div class="qcontent_answer">${branch.rightAns}</div>
										</c:if>
										<c:if test="${qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11 }">
											<!-- <input type="hidden" class="ct_${qt.QTID}" value="${branch.correctteacher}"/> -->
											<br><br>
										</c:if>
									</c:when>
								</c:choose>
							</c:forEach>
						</c:when>
						<c:when test="${qt.ISCON eq 0}">
							<div class="qcontent">${item.th}.${item.content}</div>
							<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
							<c:forEach items="${fileurls}" var="filepath">
								<c:choose>
									<c:when test="${fn:contains(filepath,'mp4')==true}">
										<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
											<source src="${filepath}" type="video/mp4"/>
										</video>
									</c:when>
									<c:when test="${fn:contains(filepath,'mp3')==true}">
										<audio src="${filepath}" controls>
											Your browser does not support the audio element.
										</audio>
									</c:when>
									<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
										<img src="${filepath}" style="max-width:280px;"/>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:if test="${aFlag == 1}">
								<div class="qcontent_answer">${item.rightAns}</div>
							</c:if>
							<c:if test="${qt.QTID!='161_6_0'&&(qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11) }">
								<br><br>
							</c:if>
						</c:when>
					</c:choose>
				</c:if>
			</c:forEach>
		</c:forEach>
	</div>
	<div id="paperOnlyAnswer" style="display: none">
		<div class="head_div">
			<div class="title">
				<span class="schoolName">${organizationinfo.PARAM}</span>
			</div>
			<div class="eobject">
				${examInfo.SCHOOLYEAR}-${examInfo.SCHOOLYEAR + 1}学年 ${examInfo.TERMNAME}<br/>
				<span class="spList">${examObject}<br/></span>
				《${examInfo.ENAME}》
				<c:forEach var="et" items="${examTypeList}">
					<c:if test="${examInfo.TYPE == et.ID}">
						${et.NAME}
					</c:if>
				</c:forEach>
				<c:choose>
					<c:when test="${examInfo.AORB==0 }">
						(A卷)
					</c:when>
					<c:otherwise>
						(B卷)
					</c:otherwise>
				</c:choose>
				参考答案
			</div>
		</div>
		<table id="answerTable" style="width:100%;">
		</table>
	</div>
	<div id="exampaper" style="display: none">
		<div class="head_div">
			<div class="exam_title">
				<span class="schoolName exam_title">${organizationinfo.PARAM}</span>${examInfo.SCHOOLYEAR + 1}年${examInfo.TERMNAME}
				<br>
				<c:forEach var="et" items="${examTypeList}">
					<c:if test="${examInfo.TYPE == et.ID}">
						${et.NAME}
					</c:if>
				</c:forEach>
				试题卷
				<c:choose>
					<c:when test="${examInfo.AORB==0 }">
						(A卷)
					</c:when>
					<c:otherwise>
						(B卷)
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="eInfo">
			<table class="eInfo_table">
				<tr>
					<td class="eInfo_td_l">考试科目:<u>[${examInfo.CODE}]${examInfo.CNAME}</u></td>
					<td class="eInfo_td_r">考试类别:<u>${examType }</u></td>
				</tr>
				<tr>
					<td class="eInfo_td_l" id="major">适用专业:<u>${examObject}</u></td>
					<td class="eInfo_td_r"></td>
				</tr>
			</table>
		</div>
		<div style="clear:both;"></div>

		<table style="border-collapse: collapse; border-spacing: 0;" class="etable">
			<tr>
				<td>题号</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qindex">
							${t.index + 1}
					</td>
				</c:forEach>
				<td>总分</td>
			</tr>
			<tr>
				<td>分值</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qtscore">
							${qt.SCORE}
					</td>
				</c:forEach>
				<td class="amount">${qscore }</td>
			</tr>
		</table>
		<div>
			<c:forEach var="qt" items="${questiontype}" varStatus="t">
				<div class="eqtype_div"><span class="eqtype"><span class="qindex">${t.index + 1}</span>、&nbsp;${qt.QTNAME}&nbsp;</span><span class="eqtype_desc">(答题说明：${qt.QTDESC} 共有${qt.QCOUNT }题，${qt.qtScoreInfo}，合计${qt.SCORE }分。)</span></div>
				<div class="econtent">
					<c:forEach var="item" items="${res}" varStatus="j">
						<c:if test="${item.qtype == qt.QTID && item.ismain eq 1 }">
							<div class="qcontent_main">${item.content}</div>
							<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
							<c:forEach items="${fileurls}" var="filepath">
								<c:choose>
									<c:when test="${fn:contains(filepath,'mp4')==true}">
										<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
											<source src="${filepath}" type="video/mp4"/>
										</video>
									</c:when>
									<c:when test="${fn:contains(filepath,'mp3')==true}">
										<audio src="${filepath}" controls>
											Your browser does not support the audio element.
										</audio>
									</c:when>
									<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
										<img src="${filepath}" style="max-width:280px;"/>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:set var="mqid" value="${item.qid}"></c:set>
							<c:forEach var="branch" items="${res}">
								<c:if test="${branch.mqid==mqid }">
									<div class="qcontent">${branch.th}.${branch.content}</div>
									<c:set var="fileurls" value="${fn:split(branch.filepath, ',')}" />
									<c:forEach items="${fileurls}" var="filepath">
										<c:choose>
											<c:when test="${fn:contains(filepath,'mp4')==true}">
												<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
													<source src="${filepath}" type="video/mp4"/>
												</video>
											</c:when>
											<c:when test="${fn:contains(filepath,'mp3')==true}">
												<audio src="${filepath}" controls>
													Your browser does not support the audio element.
												</audio>
											</c:when>
											<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
												<img src="${filepath}" style="max-width:280px;"/>
											</c:when>
										</c:choose>
									</c:forEach>
								</c:if>
								<c:if test="${aFlag == 1}">
									<div class="qcontent_answer">${item.rightAns}</div>
								</c:if>
							</c:forEach>
						</c:if>
					</c:forEach>
					<c:if test="${qt.ISCON==0 && (qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==8||qt.ATID==9)}">
						<table class="fl_table">
							<c:set var="jo" value="0"></c:set>
							<c:forEach var="item" items="${res}" varStatus="j">
								<c:if test="${item.qtype == qt.QTID}">
									<c:if test="${jo%2==0 }">
										<tr><td valign="top">
										<div class="qcontent">${item.th}.${item.content}</div>
										<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
										<c:forEach items="${fileurls}" var="filepath">
											<c:choose>
												<c:when test="${fn:contains(filepath,'mp4')==true}">
													<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
														<source src="${filepath}" type="video/mp4"/>
													</video>
												</c:when>
												<c:when test="${fn:contains(filepath,'mp3')==true}">
													<audio src="${filepath}" controls>
														Your browser does not support the audio element.
													</audio>
												</c:when>
												<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
													<img src="${filepath}" style="max-width:280px;"/>
												</c:when>
											</c:choose>
										</c:forEach>
										<c:if test="${aFlag == 1}">
											<div class="qcontent_answer">${item.rightAns}</div>
										</c:if>
										</td>
									</c:if>
									<c:if test="${jo%2!=0 }">
										<td valign="top">
											<div class="qcontent">${item.th}.${item.content}</div>
											<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
											<c:forEach items="${fileurls}" var="filepath">
												<c:choose>
													<c:when test="${fn:contains(filepath,'mp4')==true}">
														<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
															<source src="${filepath}" type="video/mp4"/>
														</video>
													</c:when>
													<c:when test="${fn:contains(filepath,'mp3')==true}">
														<audio src="${filepath}" controls>
															Your browser does not support the audio element.
														</audio>
													</c:when>
													<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
														<img src="${filepath}" style="max-width:280px;"/>
													</c:when>
												</c:choose>
											</c:forEach>
											<c:if test="${aFlag == 1}">
												<div class="qcontent_answer">${item.rightAns}</div>
											</c:if>
										</td></tr>
									</c:if>
									<c:set var="jo" value="${jo+1 }"></c:set>
								</c:if>
							</c:forEach>
							<c:if test="${jo%2!=0 }">
								<td></td></tr>
							</c:if>
						</table>
					</c:if>
					<c:if test="${qt.ISCON==0 && (qt.ATID==4||qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11)}">
						<c:forEach var="item" items="${res}" varStatus="j">
							<c:if test="${item.qtype == qt.QTID}">
								<div class="qcontent">${item.th}.${item.content}</div>
								<c:set var="fileurls" value="${fn:split(item.filepath, ',')}" />
								<c:forEach items="${fileurls}" var="filepath">
									<c:choose>
										<c:when test="${fn:contains(filepath,'mp4')==true}">
											<video class="edui-upload-video  vjs-default-skin video-js" controls="" preload="none" width="420" height="280" src="${filepath}">
												<source src="${filepath}" type="video/mp4"/>
											</video>
										</c:when>
										<c:when test="${fn:contains(filepath,'mp3')==true}">
											<audio src="${filepath}" controls>
												Your browser does not support the audio element.
											</audio>
										</c:when>
										<c:when test="${fn:contains(filepath,'jpg')==true || fn:contains(filepath,'jpeg')==true || fn:contains(filepath,'png')==true || fn:contains(filepath,'gif')==true|| fn:contains(filepath,'bmp')==true}">
											<img src="${filepath}" style="max-width:280px;"/>
										</c:when>
									</c:choose>
								</c:forEach>
								<c:if test="${aFlag == 1}">
									<div class="qcontent_answer">${item.rightAns}</div>
								</c:if>
							</c:if>
						</c:forEach>
					</c:if>
				</div>
			</c:forEach>
		</div>
	</div>
	<div id="exampaper_answer" style="display: none">
		<div class="head_div">
			<div class="exam_title">
				<span class="schoolName exam_title">${organizationinfo.PARAM}</span>${examInfo.SCHOOLYEAR + 1}年${examInfo.TERMNAME}
				<br>
				<c:forEach var="et" items="${examTypeList}">
					<c:if test="${examInfo.TYPE == et.ID}">
						${et.NAME}
					</c:if>
				</c:forEach>
				答题卷
				<c:choose>
					<c:when test="${examInfo.AORB==0 }">
						(A卷)
					</c:when>
					<c:otherwise>
						(B卷)
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="eInfo">
			<table class="eInfo_table">
				<tr>
					<td class="eInfo_td_l">考试科目:<u>[${examInfo.CODE}]${examInfo.CNAME}</u></td>
					<td class="eInfo_td_r">考试类别:<u>${examType }</u></td>
				</tr>
				<tr>
					<td class="eInfo_td_l" id="major1">适用专业:<u>${examObject}</u></td>
					<td class="eInfo_td_r"></td>
				</tr>
			</table>
		</div>
		<div style="clear:both;"></div>

		<table style="border-collapse: collapse; border-spacing: 0;" class="etable">
			<tr>
				<td>题号</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qindex">
							${t.index + 1}
					</td>
				</c:forEach>
				<td>总分</td>
			</tr>
			<tr>
				<td>分值</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="qtscore">
							${qt.SCORE}
					</td>
				</c:forEach>
				<td class="amount">${qscore }</td>
			</tr>
			<tr>
				<td>得分</td>
				<c:forEach var="qt" items="${questiontype}" varStatus="t">
					<td class="sqtscore">
					</td>
				</c:forEach>
				<td class="samount"></td>
			</tr>
		</table>
		<c:forEach var="qt" items="${questiontype}" varStatus="t">
			<span width="10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<table class="answer_table">
				<tr>
					<td class="td1">得分</td>
					<td class="td2">阅卷人</td>
					<td rowspan="2" class="td3"><div class="eqtype_div"><span class="eqtype"><span class="qindex">${t.index + 1}</span>、&nbsp;${qt.QTNAME}&nbsp;</span><span class="eqtype_desc">(答题说明：${qt.QTDESC}&nbsp;共有${qt.QCOUNT }题，${qt.qtScoreInfo}，合计${qt.SCORE }分。)</span></div></td>
				</tr>
				<tr style="height:10px;">
					<td class="td1">&nbsp;&nbsp;&nbsp;&nbsp;<br/></td>
					<td class="td2">&nbsp;&nbsp;&nbsp;&nbsp;<br/></td>
				</tr>
				<!-- <tr>
			<td style="width:20%;border:0;text-aligh:left;">
			<table style="width:100%;">
				<tr>
					<td align="left">得分</td>
					<td align="left">阅卷人</td>
				</tr>
				<tr>
					<td><span>&nbsp;</span></td>
					<td><span>&nbsp;</span></td>
				</tr>
			</table>
			</td>
			<td style="width:80%;border:0;">
			<div class="eqtype_div"><span class="eqtype"><span class="qindex">${t.index + 1}</span>、&nbsp;${qt.QTNAME}&nbsp;</span><span class="eqtype_desc">(答题说明：${qt.QTDESC}。共有${qt.QCOUNT }题，${qt.qtScoreInfo}，合计${qt.SCORE }分。)</span></div>
			</td>
		</tr> -->
			</table>

			<c:if test="${qt.ATID==0||qt.ATID==1||qt.ATID==2||qt.ATID==3||qt.ATID==8||qt.ATID==9||qt.ATID==4 }">
				<span width="10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
				<c:forEach var="item" items="${qnumList}" >
					<c:if test="${item.QTID == qt.QTID}">
						<table style="width:100%;">
							<c:set var="th" value="${item.qindex }"></c:set>
							<c:set var="count" value="1"></c:set>
							<c:forEach var="row_item" begin="1" end="${item.row }">
								<tr>
									<td width="20%">题号</td>
									<c:forEach var="col_item" begin="0" end="7" varStatus="status">
										<c:choose>
											<c:when test="${count<=item.QNUM }">
												<td width="10%">${th }</td>
											</c:when>
											<c:otherwise>
												<td width="10%"></td>
											</c:otherwise>

										</c:choose>
										<c:set var="th" value="${th+1 }"></c:set>
										<c:set var="count" value="${count+1 }"></c:set>
									</c:forEach>
								</tr>
								<tr>
									<td width="20%">答案</td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
									<td width="10%"></td>
								</tr>
							</c:forEach>
						</table>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${qt.ATID==5||qt.ATID==6||qt.ATID==7||qt.ATID==10||qt.ATID==11}">
				<c:forEach var="item" items="${qnumList}" >
					<c:if test="${item.QTID == qt.QTID}">
						<c:set var="th" value="${item.qindex}"></c:set>
						<c:forEach var="qnum_item" begin="0" end="${item.QNUM-1 }" varStatus="status">
							${th+status.index }、
							<br/>
							<br/>
						</c:forEach>
					</c:if>
				</c:forEach>
			</c:if>
		</c:forEach>
	</div>
</div>
<div style="text-align:center;margin-top:5px;">
	<a id="closeTab" class="easyui-linkbutton"  href="javascript:void(0);" onclick="cancelEasyUiFrame(0)">关闭</a>
</div>
<div id="exportPaperQuestion"></div>
<!-- 取过审待考页面传过来的值 -->
<input type="hidden" value="${param.isFormVerified}" id="isFormVerified">
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/styles/html2canvas/dom-to-image-more.min.js"></script>
<script type="text/javascript">
	var eid = $("#eid").val();

	/**
	 * 拦截 jQuery.wordExport 的下载，把生成的 .doc(MHTML) 传后端换成 .docx（无水印）。
	 * 用法：await wordExportViaServerDOCX($region, name, cssText)
	 */
	async function wordExportViaServerDOCX($region, name, styles) {
		const origSaveAs = window.saveAs;
		try {
			// 1) 拦截 jQuery.wordExport 产物
			const { blob, filename } = await new Promise((resolve, reject) => {
				window.saveAs = function(interceptedBlob, interceptedName) {
					resolve({ blob: interceptedBlob, filename: interceptedName });
				};
				try {
					$region.wordExport(name, styles); // 触发插件，但不真正落地
				} catch (e) { reject(e); }
			});

			// 2) 组装 FormData，带上后端需要的字段
			const fd = new FormData();
			const fallbackName = (filename || (name + ".doc")); // jQuery.wordExport 通常给 .doc (MHTML)
			fd.append("file", blob, fallbackName);
			fd.append("filename", fallbackName);
			fd.append("eid", eid); // 确保全局/上下文里有 eid

			// 3) 请求后端转换为 .docx（无水印）
			const res = await fetch(`${pageContext.request.contextPath}/viewPaper/examPaperDocx`, {
				method: "POST",
				body: fd,
				credentials: "include",
				// headers: { "X-CSRF-TOKEN": "..." } // 如有 CSRF，请补齐
			});
			if (!res.ok) throw new Error("服务器转换失败：" + res.status);

			// 4) 收到 .docx 文件并触发浏览器下载
			const docxBlob = await res.blob();
			// 后端会用你传的 filename 生成 baseName.docx，这里也可用服务端 Content-Disposition 解析
			const outName = name + ".docx";
			const url = URL.createObjectURL(docxBlob);
			const a = document.createElement("a");
			a.href = url; a.download = outName;
			document.body.appendChild(a); a.click();
			setTimeout(() => { URL.revokeObjectURL(url); a.remove(); }, 1000);
		} finally {
			// 5) 无论成功失败都恢复 saveAs
			window.saveAs = origSaveAs;
		}
	}

	/** 一键导出 DOCX（无水印；会把 SVG 转 PNG） */
	async function exportPaperDOCX() {
		showGlobalMask();
		try {
			// ===== 复用你 saveAsWord 的样式串 =====
			var s = "*{font-size:12pt;} table{border-spacing:0;border-collapse:collapse;border-radius:3px;border:1px solid #ddd;} td, th {padding:5px;line-height:1.6;vertical-align:center;border:1px solid #ddd;}";
			s += "#answerTable{table-layout:fixed;word-break:break-all;} .tdt{width:10%;} .preblock{display:block;line-height:1.428571429;color:#333;word-break:break-all;word-wrap:break-word;background-color:#f5f5f5;border:1px solid #ccc;border-radius:4px;white-space:pre-wrap;}";
			s += ".morespace{padding-bottom:100px;} .sanswer{color:red;} ol{-webkit-padding-start:4px;font-family:宋体; font-size:12pt !important;margin:0 40px;}";
			s += ".qcontent{font-family:宋体;font-size:12pt !important;}.qcontent_answer{font-family:宋体;font-size:12pt !important;}.qcontent_main{font-size:12pt !important;display:block;line-height:1.428571429;color:#333;word-break:break-all;word-wrap:break-word;background-color:#f5f5f5;border:1px solid #ccc;border-radius:4px;white-space:pre-wrap;} .head_div{text-align:center;font-weight:bold;} .title{font-family:SimHei;display:block;font-size:16pt;margin:10px 0;}";
			s += ".sInfo{margin:20px auto;text-align:center;} .sInfo span{width:80px;}";
			s += ".exam_title{font-family:'Microsoft Yahei'; font-weight:bold;font-size:22pt;}";
			s += ".eInfo{margin:20px auto;font-family:SimSun;font-size:14pt;font-weight:bold;}";
			s += ".eInfo_table{width:100%;border:0;font-family:SimSun;font-size:14pt;font-weight:bold;}";
			s += ".eInfo_table td{border:0;}";
			s += ".eInfo_td_l{text-align:left;}";
			s += ".eInfo_td_r{text-align:right;}";
			s += ".etable{width:100%;font-family:SimSun;font-size:14pt;margin:20px auto;}";
			s += ".eqtype{margin:25px 0 8px;font-weight:bold;font-family:SimSun;font-size:14pt;}";
			s += ".eqtype_desc{font-family:SimSun;font-size:10.5pt;}";
			s += ".econtent{font-family:SimSun;font-size:10.5pt; width:100%;}";
			s += ".eqtype_div{margin:20px auto;}";
			s += ".fl_table{width:100%;border:0;font-family:SimSun;font-size:10.5pt;}";
			s += ".fl_table td{border:0;width:50%;}";
			s += ".answer_table{margin:30px 0 30px; width:100%; border:0;font-size:14pt;}";
			s += ".answer_table .td1{text-align:left;width:10%;}";
			s += ".answer_table .td2{text-align:left;width:15%;}";
			s += ".answer_table .td3{border:0;width:80%;} .table-noborder{border-collapse:collapse;border:none;} .table-noborder td{border:0;} p{line-height:150%;}";

			// ===== 自动判断导出区域 & 文件名 =====
			const typeVal = $("#type").val(), typeTxt = (typeVal == "0") ? "(A卷)" : "(B卷)";
			let $region, name;
			if (!$("#exampaper").is(':hidden')) {
				$region = $("#exampaper");
				await replaceSvgImgsWithPng_DTI($region);
				name = $("#code").val() + $("#ename").val() + "试题卷" + typeTxt;
			} else if (!$("#exampaper_answer").is(':hidden')) {
				$region = $("#exampaper_answer");
				await replaceSvgImgsWithPng_DTI($region);
				name = $("#code").val() + $("#ename").val() + "答题卷" + typeTxt;
			} else if ($("#paperWithAnswer").is(':hidden')) {
				$region = $("#paperOnlyAnswer");
				await replaceSvgImgsWithPng_DTI($region);
				name = $("#code").val() + $("#ename").val() + "参考答案" + typeTxt;
			} else {
				$region = $("#paperWithAnswer");
				await replaceSvgImgsWithPng_DTI($region);
				name = $("#code").val() + $("#ename").val() + typeTxt;
			}

			// ===== 上传并下载 DOCX（无水印） =====
			await wordExportViaServerDOCX($region, name, s);
		} catch (e) {
			console.error(e);
			toastr.error("导出失败：" + (e.message || e));
		} finally {
			hideGlobalMask();
		}
	}

	$(document).ready(function(){

		$.each($('.qindex'),function(i,item){
			var qindex = $(item).text();
			if(qindex && !isNaN(qindex)){
				$(item).text(NumberToChinese(qindex));
			}
		});

		$(".qcontent").each(function(){
			var content=$(this).html();

			var index=content.indexOf(".");
			var xh=content.substring(0,index);
			var con=content.substring(index+1);
			var p=con.substring(0,3);

			if(p=='<p>'){
				content=con.substring(0,3)+xh+"."+con.substring(3);
			}else{
				content="<p>"+content+"</p>";
			}
			$(this).html(content);
		});
		$(".qcontent_main").each(function(){
			var content=$(this).html();
			var p=content.substring(0,2);

			if(p!='<p'){
				content="<p>"+content+"</p>";
			}
			$(this).html(content);
			$(this).find("q").css("line-height","1.5em");
		});

		//过审纸考页面的导出
		var isFormVerified = $("#isFormVerified").val();
		if(isFormVerified==1){
			//判断是过审纸考页面过来的请求，执行导出。
			saveAsWord();
			//setTimeout(function(){ closeTab()}, 100);
			//$("#closeTab").click;
		}
	});

	/****************** SVG -> PNG（用 dom-to-image-more） ******************/
	const SVG_EXPORT_CONFIG = {
		DEFAULT_TARGET_HEIGHT: 32, // 没设置高度时按 32px 高
		SCALE: 2,                  // 高清输出比例：2 更清晰；想减小体积可改为 1
		BACKGROUND: '#ffffff'      // Word 里更稳：用白底
	};

	// 解析 viewBox="minx miny width height" -> {w, h}
	function parseViewBox(svgText) {
		const m = svgText.match(/viewBox\s*=\s*["']\s*([\d.+-eE]+)\s+([\d.+-eE]+)\s+([\d.+-eE]+)\s+([\d.+-eE]+)\s*["']/i);
		if (!m) return null;
		const w = parseFloat(m[3]), h = parseFloat(m[4]);
		return (w > 0 && h > 0) ? { w, h } : null;
	}

	// 提取像素值（'32px' / '32' / 32）
	function explicitPx(val) {
		if (val == null) return null;
		if (typeof val === 'number') return val;
		const s = String(val).trim().toLowerCase();
		if (!s) return null;
		if (s.endsWith('px')) return parseFloat(s);
		const n = parseFloat(s);
		return isNaN(n) ? null : n;
	}

	// 把 <img src="*.svg"> 转成 PNG dataURL（使用 dom-to-image-more）
	async function replaceSvgImgsWithPng_DTI($root) {
		if (!window.domtoimage) {
			console.error('dom-to-image-more 未加载');
			return;
		}

		// 找到区域内所有 svg 图片（排除已经是 dataURL 的）
		const imgs = $root.find('img').filter(function () {
			const src = (this.getAttribute('src') || '').toLowerCase();
			return src.endsWith('.svg') && !src.startsWith('data:');
		}).toArray();

		for (const img of imgs) {
			const src = img.getAttribute('src');
			try {
				// 1) 取 SVG 源文本（需同源或服务器允许 CORS）
				const res = await fetch(src, { credentials: 'include' });
				if (!res.ok) throw new Error('HTTP ' + res.status);
				const svgText = await res.text();

				// 2) 计算目标像素：按 <img> 的高度等比
				const vb = parseViewBox(svgText) || { w: 800, h: 600 };
				let targetH =
						explicitPx(img.style && img.style.height) ??
						explicitPx(img.getAttribute('height')) ??
						(() => {
							try {
								const v = explicitPx(getComputedStyle(img).height);
								return (v && v > 0) ? v : null;
							} catch { return null; }
						})() ??
						SVG_EXPORT_CONFIG.DEFAULT_TARGET_HEIGHT;

				let targetW = Math.max(1, Math.round(vb.w * (targetH / vb.h)));
				targetH = Math.max(1, Math.round(targetH));

				// 3) 构造一个离屏容器，内联 SVG，并设置实际渲染尺寸
				const holder = document.createElement('div');
				holder.style.position = 'fixed';
				holder.style.left = '-99999px';
				holder.style.top = '0';
				holder.style.width = targetW + 'px';
				holder.style.height = targetH + 'px';
				holder.style.background = SVG_EXPORT_CONFIG.BACKGROUND;

				// 把 viewBox 的 SVG 内联到容器里，并给它 width/height（像素）
				// 注意：尽量保留原有的 preserveAspectRatio
				const svgWithSize = svgText
						// 去掉可能存在的固定 width/height 单位（避免冲突）
						.replace(/\swidth\s*=\s*["'][^"']*["']/ig, '')
						.replace(/\sheight\s*=\s*["'][^"']*["']/ig, '')
						// 注入像素尺寸
						.replace('<svg', `<svg width="${targetW}px" height="${targetH}px"`);

				holder.innerHTML = svgWithSize;
				document.body.appendChild(holder);

				// 4) 用 dom-to-image 渲染容器为 PNG dataURL
				const dataUrl = await domtoimage.toPng(holder, {
					bgcolor: SVG_EXPORT_CONFIG.BACKGROUND,
					width: targetW,
					height: targetH,
					style: { transform: 'none' },
					quality: 1,
					cacheBust: true,
					// 放大 scale 提高清晰度（dom-to-image-more 支持）
					scale: SVG_EXPORT_CONFIG.SCALE
				});

				// 5) 替换原 <img> 的 src，并固定像素尺寸（Word 更稳定）
				img.src = dataUrl;
				img.style.width  = targetW + 'px';
				img.style.height = targetH + 'px';
				img.setAttribute('width',  String(targetW));
				img.setAttribute('height', String(targetH));

				// 6) 清理离屏容器
				document.body.removeChild(holder);
			} catch (e) {
				console.error('SVG 转 PNG 失败（dom-to-image）：', src, e);
				// 兜底：如你后端有同名 .png，可回退
				// img.src = src.replace(/\.svg$/i, '.png');
			}
		}
	}
	
	async function saveAsWord() {
		var s = "*{font-size:12pt;} table{border-spacing: 0;border-collapse: collapse;border-radius: 3px;border:1px solid #ddd;} td, th {padding: 5px;line-height: 1.6;vertical-align: center;border: 1px solid #ddd;}";
		s += "#answerTable{table-layout:fixed;word-break:break-all;} .tdt{width: 10%;} .preblock{display: block;line-height: 1.428571429;color: #333;word-break: break-all;word-wrap: break-word;background-color: #f5f5f5;border: 1px solid #ccc;border-radius: 4px;white-space: pre-wrap;}";
		s += ".morespace{padding-bottom:100px;} .sanswer{color:red;} ol{-webkit-padding-start: 4px;font-family: 宋体; font-size: 12pt !important;margin:0 40px;}";
		s += ".qcontent{font-family: 宋体;font-size: 12pt !important;}.qcontent_answer{font-family: 宋体;font-size: 12pt !important;}.qcontent_main{font-size:12pt !important;display: block;line-height: 1.428571429;color: #333;word-break: break-all;word-wrap: break-word;background-color: #f5f5f5;border: 1px solid #ccc;border-radius: 4px;white-space: pre-wrap;} .head_div{text-align:center;font-weight:bold;} .title{font-family:SimHei;display:block;font-size: 16pt;margin:10px 0;}";
		s += ".sInfo{margin: 20px auto;text-align: center;} .sInfo span{width:80px;}";
		s += ".exam_title{font-family:'Microsoft Yahei'; font-weight:bold;font-size:22pt;}";
		s += ".eInfo{margin: 20px auto;font-family: SimSun;font-size:14pt;font-weight:bold;}";
		s += ".eInfo_table{width:100%;border:0;font-family: SimSun;font-size:14pt;font-weight:bold;}";
		s += ".eInfo_table td{border:0;}";
		s += ".eInfo_td_l{text-align:left;}";
		s += ".eInfo_td_r{text-align:right;}";
		s += ".etable{width:100%;font-family: SimSun;font-size:14pt;margin: 20px auto;}";
		s += ".eqtype{margin:25px 0 8px;font-weight:bold;font-family: SimSun;font-size:14pt;}";
		s += ".eqtype_desc{font-family: SimSun;font-size:10.5pt;}";
		s += ".econtent{font-family: SimSun;font-size:10.5pt; width:100%;}";
		s += ".eqtype_div{margin:20px auto;}";
		s += ".fl_table{width:100%;border:0;font-family: SimSun;font-size:10.5pt;}";
		s += ".fl_table td{border:0;width:50%;}";
		s += ".answer_table{margin:30px 0 30px; width:100%; border:0;font-size:14pt;}";
		s += ".answer_table .td1{text-align:left;width:10%;}";
		s += ".answer_table .td2{text-align:left;width:15%;}";
		s += ".answer_table .td3{border:0;width:80%;} .table-noborder{border-collapse:collapse;border:none;} .table-noborder td{border:0;} p{line-height:150%;}";

		var typeVal = $("#type").val();
		var typeTxt = (typeVal == "0") ? "(A卷)" : "(B卷)";

		if (!$("#exampaper").is(':hidden')) {
			const $region = $("#exampaper");
			await replaceSvgImgsWithPng_DTI($region);
			const name = $("#code").val() + $("#ename").val() + "试题卷" + typeTxt;
			$region.wordExport(name, s);
			return;
		}
		if (!$("#exampaper_answer").is(':hidden')) {
			const $region = $("#exampaper_answer");
			await replaceSvgImgsWithPng_DTI($region);
			const name = $("#code").val() + $("#ename").val() + "答题卷" + typeTxt;
			$region.wordExport(name, s);
			return;
		}
		if ($("#paperWithAnswer").is(':hidden')) {
			const $region = $("#paperOnlyAnswer");
			await replaceSvgImgsWithPng_DTI($region);
			const name = $("#code").val() + $("#ename").val() + "参考答案" + typeTxt;
			$region.wordExport(name, s);
		} else {
			const $region = $("#paperWithAnswer");
			await replaceSvgImgsWithPng_DTI($region);
			const name = $("#code").val() + $("#ename").val() + typeTxt;
			$region.wordExport(name, s);
		}
	}

	function seePaperWithAnswer() {
		let needRandomQuestionType = $('#needRandomQuestionType').is(':checked') ? 1 : 0;
		let needRandomQuestion = $('#needRandomQuestion').is(':checked') ? 1 : 0;
		let needRandomAnswer = $('#needRandomAnswer').is(':checked') ? 1 : 0;
		window.location.href='${pageContext.request.contextPath}/viewPaper/seePaper_normal?eid=' + eid + '&aFlag=1'
		+ '&needRandomQuestionType='+needRandomQuestionType+'&needRandomQuestion='+needRandomQuestion
		+ '&needRandomAnswer='+needRandomAnswer;
	}

	function seePaperNoAnswer() {
		let needRandomQuestionType = $('#needRandomQuestionType').is(':checked') ? 1 : 0;
		let needRandomQuestion = $('#needRandomQuestion').is(':checked') ? 1 : 0;
		let needRandomAnswer = $('#needRandomAnswer').is(':checked') ? 1 : 0;
		window.location.href='${pageContext.request.contextPath}/viewPaper/seePaper_normal?eid=' + eid + '&aFlag=0'
				+ '&needRandomQuestionType='+needRandomQuestionType+'&needRandomQuestion='+needRandomQuestion
				+ '&needRandomAnswer='+needRandomAnswer;
	}

	function seePaperOnlyAnswer() {
		$("#answerTable").empty();
		$.post("${pageContext.request.contextPath}/paper/seePaperOnlyAnswer",{'eid':eid},function (data) {
			let res = data.res;
			let questiontype = data.questiontype;
			let count = 0;
			for(let i = 0; i < questiontype.length; i++){
				let column = new Array();
				let columnCount = 0;
				let typename = "<tr><td colspan='10'><span><strong>"+ NumberToChinese(i+1) + "、" + questiontype[i].QTNAME + "，共有"+questiontype[i].QCOUNT+"题，"+questiontype[i].qtScoreInfo+"，合计"+questiontype[i].SCORE+"分</strong></span></td></tr>";
				$("#answerTable").append(typename);
				for(let j = 0; j < res.length; j++){
					let ismain = res[j].ismain;
					if(res[j].qtype == questiontype[i].QTID && ismain == 1){
						for(let k = 0; k < res.length; k++){
							if(res[k].mqid == res[j].qid){
								if(questiontype[i].ATID == 0||questiontype[i].ATID == 2||questiontype[i].ATID==8){
									let answers = res[k].answer;
									for(let x = 0; x < answers.length; x++){
										if(answers[x].aid == res[k].answerid){
											count++;
											column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、" + String.fromCharCode(x+65) + "</td>";
											columnCount++;
										}
									}
								}
								if(questiontype[i].ATID == 1||questiontype[i].ATID == 3||questiontype[i].ATID==9){
									let answers = res[k].answer;
									let ansOrder = "";
									for(let x = 0; x < answers.length; x++){
										if(x == 0){
											ansOrder += answers[x].aid;
										}else{
											ansOrder = ansOrder + "," + answers[x].aid;
										}
									}
									count++;
									ansOrder = ansOrder.split(",");
									let arr = res[k].answerid.split(',');
									let r = '';
									for(let x=0; x<arr.length; x++){
										for(let y=0;y<ansOrder.length;y++){
											if(parseInt(arr[x])==parseInt(ansOrder[y])){
												r += String.fromCharCode(y+65) + '、';
											}
										}
									}
									if(r.length>0){
										r = r.slice(0, r.length - 1);
									}

									column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、<span>" + r + "</span></td>";
									columnCount++;
								}
								if(questiontype[i].ATID == 4){
									count++;
									let answer = res[j].answer[0].acontent == "true"?"√":"×";
									column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、<span>" + answer + "</span></td>";
									columnCount++;
								}
								if(questiontype[i].ATID == 5||questiontype[i].ATID == 6||questiontype[i].ATID==7||questiontype[i].ATID == 10||questiontype[i].ATID==11){
									count++;
									column[columnCount] = "<td colspan='10' class='tdy'>" + count + "、<span>" + res[k].answer[0].acontent_6 + "</span></td>";
									columnCount++;
								}
							}
						}
					}
					if(res[j].qtype == questiontype[i].QTID && questiontype[i].ISCON == 0 && (questiontype[i].ATID == 0||questiontype[i].ATID == 2||questiontype[i].ATID==8)){
						let answers = res[j].answer;
						for(let x = 0; x < answers.length; x++){
							if(answers[x].aid == res[j].answerid){
								count++;
								column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、" + String.fromCharCode(x+65) + "</td>";
								columnCount++;
							}
						}
					}
					if(res[j].qtype == questiontype[i].QTID && questiontype[i].ISCON == 0 && (questiontype[i].ATID == 1||questiontype[i].ATID == 3||questiontype[i].ATID==9)){
						count++;
						let answers = res[j].answer;
						let ansOrder = "";
						for(let x = 0; x < answers.length; x++){
							if(x == 0){
								ansOrder += answers[x].aid;
							}else{
								ansOrder = ansOrder + "," + answers[x].aid;
							}
						}
						ansOrder = ansOrder.split(",");
						let arr = res[j].answerid.split(',');
						let r = '';
						for(let m=0; m<arr.length; m++){
							for(let n=0;n<ansOrder.length;n++){
								if(parseInt(arr[m])==parseInt(ansOrder[n])){
									r += String.fromCharCode(n+65) + '、';
								}
							}
						}
						if(r.length>0){
							r=r.substr(0,r.length-1);
						}
						column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、<span>" + r + "</span></td>";
						columnCount++;
					}
					if(res[j].qtype == questiontype[i].QTID && questiontype[i].ISCON == 0 && questiontype[i].ATID == 4){
						count++;
						let answer = res[j].answer[0].acontent == "true"?"√":"×";
						column[columnCount] = "<td colspan='1' class='tdt'>" + count + "、<span>" + answer + "</span></td>";
						columnCount++;
					}
					if(res[j].qtype == questiontype[i].QTID && questiontype[i].ISCON == 0 && (questiontype[i].ATID == 5||questiontype[i].ATID == 6||questiontype[i].ATID==7||questiontype[i].ATID == 10||questiontype[i].ATID==11)){
						count++;
						column[columnCount]= "<td colspan='10' class='tdy'>" + count + "、<span>" + res[j].answer[0].acontent_6 + "</span></td>";
						columnCount++;
					}
				}
				var d = "";
				for(var j = 0; j < columnCount; j++){
					d = d + column[j];
					if(questiontype[i].ATID == 5||questiontype[i].ATID == 6||questiontype[i].ATID==7||questiontype[i].ATID == 10||questiontype[i].ATID==11){
						/* if(j % 2 == 1){
                            $("#answerTable").append("<tr>" + d + "</tr>");
                            d = "";
                        }
                        if(j == columnCount - 1 && j % 2 <1){
                            $("#answerTable").append("<tr>" + d + "</tr>");
                            d = "";
                        }*/

						$("#answerTable").append("<tr>" + d + "</tr>");
						d = "";

					}else{
						if(j % 10 == 9){
							$("#answerTable").append("<tr>" + d + "</tr>");
							d = "";
						}
						if(j == columnCount - 1 && j % 10 < 9){
							$("#answerTable").append("<tr>" + d + "</tr>");
							d = "";
						}
					}
				}
			}
		});
		$("#paperOnlyAnswer").show();
		$("#paperWithAnswer").hide();
		$("#exampaper_answer").hide();
		$("#exampaper").hide();
	}

	function seeExamPaper_answer() {
		$("#exampaper_answer").show();
		$("#exampaper").hide();
		$("#paperOnlyAnswer").hide();
		$("#paperWithAnswer").hide();
	}

	function seeExamPaper(){
		$("#exampaper").show();
		$("#paperOnlyAnswer").hide();
		$("#paperWithAnswer").hide();
		$("#exampaper_answer").hide();
	}

	//隐藏专业
	function spList(){
		var val = $('#hideSpList').prop("checked");
		if(val){
			$('.spList').hide();
			$('#major').hide();
			$('#major1').hide();
		}else{
			$('.spList').show();
			$('#major').show();
			$('#major1').show();
		}
	}

	function showWzrj(){
		var val = $('#showWzrj').prop("checked");
		if(val){
			localStorage.setItem("showWzrj","1");
			$('.schoolName').text("${organizationinfo.PARAM}仁济学院");
		}else{
			localStorage.removeItem("showWzrj");
			$('.schoolName').text("${organizationinfo.PARAM}");
		}
	}

	function exportPaperQuestion(){
		var winStr = '<table width="75%" align="center" style="margin-top:5px;">'
				+ '<tr><td><input type="radio" name="gs" value="0" checked="checked"/>原格式导出（如果需要导入系统，建议使用原格式导出）</td></tr>'
				+ '<tr><td><input type="radio" name="gs" value="1"/>智能过滤格式</td></tr>'
				+ '<tr><td><input type="button" id="ensureExport" value="导出"/></td></tr>'
				+'</table>';
		var obj = $(winStr);
		$('#exportPaperQuestion').html(null);
		obj.appendTo('#exportPaperQuestion');
		$('#exportPaperQuestion').window({
			width:510,
			height:200,
			modal:true,
			title:"请选择",
			collapsible:false,
			minimizable:false,
			maximizable:false,
            top: 100
		});
		$('#ensureExport').click(function(){
			$('#exportPaperQuestion').window('close');
			toastr.warning("正在后台生成Excel");
			var url = "${pageContext.request.contextPath}/paper/exportAllPaperQuestion?eid="+eid;
			window.location.href = url;
		});

	}

	function checkList(){
		openIframeDialog({
			url:"${pageContext.request.contextPath}/paper/checkList?c_id=" + "${examInfo.CID}" + "&ei_id=" + "${examInfo.ID}",
			fit:true,
			title:'双向细目表'
		},0);
	}
</script>