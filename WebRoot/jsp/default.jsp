<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>  
<head>
	<%
		String requestUrl=request.getRequestURL().toString();
		request.setAttribute("requestUrl",requestUrl);
	%>
	<c:if test="${fn:contains(requestUrl,'https') }">
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
	</c:if>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
<title>${organizationinfo.PARAM }网络题库与考试评价系统</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/bootstrap/css/bootstrap.min.css" type="text/css" />
<%@ include file="commons/styles.txt"%>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/default.css?t=2" type="text/css" />
<style>
.htitle{
	color: #5097F7;
	font-size: 24px;
	margin: 5px;
	float:left;
}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/default.js?t=2"></script>
<script>
var menuSearchData = [];
$(document).ready(function(){
	//判断当前连接是否是https，如果是，添加meta设置访问强制升级为https
    // 获取当前链接头
    var ishttps = 'https:' == document.location.protocol ? true : false;
    if(ishttps) {
    	// 创建一个新的meta元素
            var meta = document.createElement('meta');

    	// 设置meta标签的一些属性
            meta.setAttribute('http-equiv', 'Content-Security-Policy');
            meta.setAttribute('content', 'upgrade-insecure-requests');
    	// 将meta元素插入到head中
            document.head.appendChild(meta);
    }
    userCRole();
	$.post("${pageContext.request.contextPath}/common/getMenus", function(result){
		var m2str ='';
		var menu1 = [];
		var menu2 = [];

		$.each(result,function(i,item){
			if(item.MLEVEL =='1'){ menu1.push(item); return true; }
			if(item.MLEVEL =='2'){ menu2.push(item); return true; }
		});

		// 一级菜单 id -> name 映射，给搜索结果显示 “一级 / 二级”
		var m1NameMap = {};
		$.each(menu1, function(i,m1){ m1NameMap[m1.ID] = m1.NAME; });

		// 拼菜单 HTML（你的原逻辑）
		m2str += "<table style='border-collapse:collapse;'><tbody>";
		m2str+="<tr style='margin-bottom:2cm;'><td class='c2' onclick='newsList()' data-options='selected:true'>网站首页</td></tr><tr><td style='padding:0 0 1px 0;'></td></tr>";
		var m1_id;

		$.each(menu1,function(i,item){
			m2str += "<tr><td class='c2' onclick=selectedM2('" + item.ID + "')>" + item.NAME + "</td></tr>";
			m2str += "<tr><td style='padding:0 0 1px 0;'><div id='" + item.ID + "' class='m2' style='display: none;'><table><tbody>";
			m1_id = item.ID;
			$.each(menu2,function(i,item){
				if(m1_id == item.PARENTID){
					const fullUrl = "${pageContext.request.contextPath}/" + item.URL;
					m2str += "<tr style='text-align: left; width: 100%'><td class='c3' " +
							"data-mid='" + item.ID + "' " +
							"data-url='" + fullUrl + "' " +
							"data-name='" + item.NAME + "' " +
							"onclick=selectedM3(this,'" + fullUrl + "','" + item.NAME + "')>" +
							item.NAME + "</td></tr>";
				}
			});
			m2str += "</tbody></table></div></td></tr>";
		});
		m2str+="<tr><td class='c2' onclick='logout()'>退出系统</td></tr>";
		m2str += "</tbody></table>";
		$("#m2_container").append(m2str);

		// === 构建搜索数据：只放二级菜单（你说要二级也能搜到即可） ===
		menuSearchData = $.map(menu2, function(m2){
			var parentName = m1NameMap[m2.PARENTID] || '';
			var fullUrl = "${pageContext.request.contextPath}/" + m2.URL;
			return {
				id: m2.ID,
				text: parentName ? (parentName + " / " + m2.NAME) : m2.NAME, // 下拉显示
				name: m2.NAME,        // 真正 tab 名
				parentId: m2.PARENTID,
				url: fullUrl
			};
		});
		initMenuSearch(); // 初始化搜索框
	}, 'json');
	
	newsList();
});

function userCRole(){
	$.ajax({
		url:"${pageContext.request.contextPath}/users/wxSuccessLogin",
		async:false,
		type:"POST",
		success:function(data){
			if(data){				
				$("#realName").text(data.realname+"|"+data.roleName);
			}
		}
	})
}

function newsList(){
	if(window.parent.$('#nav_tab').tabs('exists','网站首页')){
		window.parent.$('#nav_tab').tabs('select','网站首页');
		var selTab = window.parent.$('#nav_tab').tabs('getSelected');
        var url = $(selTab.panel('options').content).attr('src');   
        var content = '<iframe style="width:100%;height:100%;border:0;overflow:auto;" src="'+url+'"></iframe>';
        window.parent.$('#nav_tab').tabs('update', {
            tab: selTab,
            options: {
                content:content
            }
        })
	}else{
		var url = "${pageContext.request.contextPath}/news/newsList?page=1&rows=20";
		var content = '<iframe style="width:100%;height:100%;border:0;overflow:auto;" src="'+url+'"</iframe>';
		window.parent.$('#nav_tab').tabs('add',{
			title: '网站首页',
			content: content,
			closable: true 
		});
	}
}

//注销登录
function logout(){
	$.ajax({
		url:"${pageContext.request.contextPath}/logoutLog",
		async: false,
		type: "POST",
		success: function(data){

		}
	});
	location.href="${pageContext.request.contextPath}/logout";
}

</script>
</head>
<body class="easyui-layout" id='mainlayout' >
<div data-options="region:'north',border:false" style="padding:0px;overflow-y:hidden;overflow-x:hidden;">
		<h1 class="htitle">${organizationinfo.PARAM }网络题库与考试评价系统</h1>		 
		<div style='width:20%;float:right' class="infoDiv">
			<div style="text-align:right;padding:20px;color:#0E2D5F;" id="realName">

			</div>
		</div>
</div>
<div data-options="region:'west',title:'系统导航',id:'west'" style="width:140px;padding:0px;overflow:auto;">
	<div id="search_container" style="padding:4px 5px;">
		<input id="searchMenu" />
	</div>
	<div id="m2_container"></div>
</div>

<div data-options="region:'south',border:false" style="height:25px;background:#F3F8FE;padding:5px;text-align:center">
${organizationinfo.PARAM }授权使用，仅限内部使用，授权到期时间：2099年
</div>
   <div data-options="region: 'center'" >
	    <div id="mainTabs_tools" class="tabs-tool">
	        <table style="width: auto">
	            <tr>
	                <td>
	                <a id="mainTabs_closeTab" class="easyui-linkbutton easyui-tooltip" title="关闭所有选项卡"
					   data-options="iconCls:'icon-trash',plain:true">关闭所有选项卡</a>
	                </td>
	                <td><div class="datagrid-btn-separator"></div></td>
	            </tr>
	        </table>
	    </div>
        <div id="nav_tab" class="easyui-tabs" data-options="fit: true, border: false, showOption: true, enableNewTabMenu: true, tools: '#mainTabs_tools', enableJumpTabMenu: true" >

        </div>
    </div>
    
</body>
</html>