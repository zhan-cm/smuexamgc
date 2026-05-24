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
	line-height: 1.2;
	vertical-align: center;
	border: 1px solid #ddd;
}
.themeToggle {
	cursor: pointer;
	display: inline-block;
	width: 28px;
	text-align: center;
	user-select: none;
}

.themeToggleEmpty {
	display: inline-block;
	width: 28px;
}

.level2 .themeName { padding-left: 20px; }
.level3 .themeName { padding-left: 40px; }
</style>

<div style="text-align: center;">
	<input type="button" value="返回" onclick="back()">
</div>
<table width="100%">
	<tr>
		<td>课  程</td>
		<td>${ei.CNAME}</td>  
		<td>专业年级</td>
		<td colspan="2">${ti.SPECIALTY} - ${ti.GRADE}</td>
	</tr>
	<tr>
		<td>考试日期</td>
		<td>${ei.BEGINDATE}</td>
		<td>考试地点</td>
		<td colspan="2">${ei.VENUES}</td>
	</tr>
	<tr>
		<td>登录ip</td>
		<td>${ti.IP}</td>
		<td>联系方法</td>
		<td colspan="2">${ti.TEL}</td>
	</tr>
	<tr>
		<td>登录时间</td>
		<td>${ti.BEGINDATE}</td>
		<td>交卷时间</td>
		<td colspan="2">${ti.ENDDATE}</td>
	</tr>
	<tr>
		<td>考试时长</td>		
		<c:set var="etime" />   			    
	    <c:if test="${(ei.TIME%60) > 0}">
	    	<c:set var="etime" value="${(ei.TIME%60)} 秒" />	
	    </c:if>
	    <c:if test="${(ei.TIME%3600)/60 > 0}">
	    	<fmt:parseNumber var="min" integerOnly="true" value="${(ei.TIME%3600)/60}" />
	    	<c:set var="etime" value="${min} 分钟  ${etime}" />	
	    </c:if>
	    <c:if test="${(ei.TIME-1800)/3600 > 0}">
	    	<fmt:parseNumber var="hour" integerOnly="true" value="${(ei.TIME-1800)/3600}" />
	    	<c:set var="etime" value="${hour} 小时  ${etime}" />	
	    </c:if>	
		<td>${etime}</td> 
		<td>应答时长</td>		
		<td colspan="2">${answertime}</td>
	</tr>
	<tr>
		<td>卷面满分</td>
		<td>${ei.SCORE}</td>
		<td>参考人数</td>
		<td class="scount" colspan="2">${ei.SCOUNT}</td>
	</tr>
	<tr>
		<td>最高分</td>
		<td>${bi.MAXSCORE}</td>
		<td>最低分</td>
		<td colspan="2">${bi.MINSCORE}</td>
	</tr>
	<tr>
		<td>平均分</td>
		<td>${bi.AVERAGESCORE}</td>
		<td>全距</td>
		<td colspan="2">${bi.RANGE}</td>
	</tr>
	<tr>
		<td>个人得分</td>
		<td>${averagescore.SCORE}</td>
		<td>分数名次</td>
		<td class="ranking" colspan="2">${ti.RANKING}</td> 
	</tr>
	<tr>
		<td>排位百分比</td>
		<td class="rankPer">${ti.RANKPER}</td>
	</tr>
	<tr>
	  <th>认知类别</th>
	  <th>满分</th>
	  <th>得分</th>
	  <th colspan="2">得分率</th>
	</tr>
	<c:forEach var="co" items="${coRes}">
	 <tr class="scoreTr">
	   <td>${co.NAME}</td>
	   <td class="scoreTd">${co.FULL_SCORE_SUM}</td>
	   <td class="countTd">${co.STU_SCORE_SUM}</td>
	   <td class="perTd" colspan="2"></td>
	 </tr>
	</c:forEach>
	<tr>
	  <th>题型</th>
	  <th>满分</th>
	  <th>得分</th>
	  <th>得分率</th>
	  <th>每题平均用时（秒）</th>
	</tr>
	<c:forEach var="qt" items="${qtRes}">
	 <tr class="scoreTr">
	   <td>${qt.NAME}</td>
	   <td class="scoreTd">${qt.FULL_SCORE_SUM}</td>
	   <td class="countTd">${qt.STU_SCORE_SUM}</td>
	   <td class="perTd"></td>
	   <td class="avgTime">
	   		<c:forEach var="at" items="${avgTime}">
	   			<c:if test="${at.QTID eq qt.ID}">
	   				<fmt:formatNumber type="number" value="${at.AVGTIME}" pattern="0.00" maxFractionDigits="2"/>
	   			</c:if>
	   		</c:forEach>
	   </td>
	 </tr>
	</c:forEach>
	<tr>
		<th>一级主题词（可展开）</th>
		<th>满分</th>
		<th>得分</th>
		<th colspan="2">得分率</th>
	</tr>

	<c:forEach var="t1" items="${themeTree}">
		<tr class="scoreTr themeRow level1"
			data-id="${t1.id}" data-pid="${t1.pid}" data-level="1">
			<td class="themeName">
				<c:choose>
					<c:when test="${not empty t1.children}">
						<span class="themeToggle" data-id="${t1.id}" data-expanded="false">[+]</span>
					</c:when>
					<c:otherwise>
						<span class="themeToggleEmpty"></span>
					</c:otherwise>
				</c:choose>
					${t1.name}
			</td>
			<td class="scoreTd">${t1.fullScore}</td>
			<td class="countTd">${t1.stuScore}</td>
			<td class="perTd" colspan="2"></td>
		</tr>

		<c:forEach var="t2" items="${t1.children}">
			<tr class="scoreTr themeRow level2"
				data-id="${t2.id}" data-pid="${t1.id}" data-level="2"
				style="display:none;">
				<td class="themeName">
					<c:choose>
						<c:when test="${not empty t2.children}">
							<span class="themeToggle" data-id="${t2.id}" data-expanded="false">[+]</span>
						</c:when>
						<c:otherwise>
							<span class="themeToggleEmpty"></span>
						</c:otherwise>
					</c:choose>
						${t2.name}
				</td>
				<td class="scoreTd">${t2.fullScore}</td>
				<td class="countTd">${t2.stuScore}</td>
				<td class="perTd" colspan="2"></td>
			</tr>

			<c:forEach var="t3" items="${t2.children}">
				<tr class="scoreTr themeRow level3"
					data-id="${t3.id}" data-pid="${t2.id}" data-level="3"
					style="display:none;">
					<td class="themeName">
						<span class="themeToggleEmpty"></span>
							${t3.name}
					</td>
					<td class="scoreTd">${t3.fullScore}</td>
					<td class="countTd">${t3.stuScore}</td>
					<td class="perTd" colspan="2"></td>
				</tr>
			</c:forEach>
		</c:forEach>
	</c:forEach>
</table>

<script type="text/javascript">
	$(document).ready(function(){
		$.each($('.scoreTr'),function(i,item){
			var scoreTd = $(item).find('.scoreTd').html();
			var countTd = $(item).find('.countTd').html();
			if(scoreTd && countTd && scoreTd != 0){
				var perTd = (parseFloat(countTd)/parseFloat(scoreTd)).toFixed(2);
				$(item).find('.perTd').html(perTd);
			}
		});

		var scount = $('.scount').html();
		var ranking = $('.ranking').html();
		if(scount && ranking && scount != 0){
			var val = (parseFloat(ranking)/parseFloat(scount)).toFixed(2);
			$('.rankPer').html(val * 100.0 + '%');
		}

		function collapseNode(id){
			var $children = $('tr.themeRow[data-pid="' + id + '"]');
			$children.each(function(){
				var childId = $(this).attr('data-id');
				collapseNode(childId);
				$(this).find('.themeToggle').text('[+]').attr('data-expanded', 'false');
				$(this).hide();
			});
		}

		function expandNode(id){
			$('tr.themeRow[data-pid="' + id + '"]').show();
		}

		$(document).on('click', '.themeToggle', function(){
			var id = $(this).attr('data-id');
			var expanded = $(this).attr('data-expanded') === 'true';

			if(expanded){
				collapseNode(id);
				$(this).text('[+]');
				$(this).attr('data-expanded', 'false');
			}else{
				expandNode(id);
				$(this).text('[-]');
				$(this).attr('data-expanded', 'true');
			}
		});
	});

function back() {
	window.history.back(-1);
}
</script>

