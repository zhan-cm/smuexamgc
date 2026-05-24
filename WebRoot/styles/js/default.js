$(function(){
	$("#mainTabs_closeTab").click(
		function(){
			//询问是否关闭全部
			$.messager.confirm("提示",'是否要关闭所有选项卡 ?',function(r){ 
			    if (r){
						var allTabs = $("#nav_tab").tabs('tabs');
					    for(var i = 1, len = allTabs.length; i < len; i++) {
					      $("#nav_tab").tabs('close', 1);
					    }
			    }
			});
		}
	);
});

function addTab(menuname, url,closable) {
	if("undefined" == typeof closable) {
		closable = true;
	}
	if($('#nav_tab').tabs('exists',menuname)){
		$('#nav_tab').tabs('select',menuname);
		var tab = $('#nav_tab').tabs('getSelected');
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
		$('#nav_tab').tabs('update',{
			tab:tab,
			options:{
				content: content
			}
		});
	}else{
		var content = '<iframe frameborder="no" width="100%" height="100%" src="'+url+'" scrolling="auto" style="overflow:auto"></iframe>';
		$('#nav_tab').tabs('add',{
			title: menuname,
			content: content,
			closable: closable
		});
	}
};

function selectedM1(m1id,m1name){
	$("#"+m1id).siblings().hide();
	$("#"+m1id).show();
	$("#"+m1id+" .c2").first().click();
}
function selectedM2(m2id){
	$(".m2").not($("#"+m2id)).hide();
	$("#"+m2id).toggle();
}
function selectedM3(my,url,menuname){
	$(".popover").hide();
	$(".c3").removeClass('selectedM');
	$(my).toggleClass('selectedM');
	addTab(menuname,url);
}
function initMenuSearch(){
	$('#searchMenu').combobox({
		data: menuSearchData,
		valueField: 'id',
		textField: 'text',
		prompt: '搜索菜单',
		editable: true,
		hasDownArrow: false,
		panelHeight: 'auto',
		panelMaxHeight: 260,

		filter: function(q, row){
			q = $.trim(q);
			if(!q) return false; // ✅ 空的时候不“搜索”，也不展示全部
			return (row.text && row.text.indexOf(q) >= 0) ||
				(row.name && row.name.indexOf(q) >= 0);
		},

		onChange: function(newVal, oldVal){
			if(!$.trim(newVal)){
				$(this).combobox('hidePanel');
			}
		},

		onSelect: function(row){
			openM2(row.parentId);
			const $td = $("#" + row.parentId + " .c3[data-mid='" + row.id + "']");
			if($td.length){
				selectedM3($td[0], row.url, row.name);
				$td[0].scrollIntoView({behavior:'smooth', block:'center'});
				$td.addClass('menu-hit');
				setTimeout(function(){ $td.removeClass('menu-hit'); }, 1000);
			}else{
				addTab(row.name, row.url);
			}
			setTimeout(function(){
				$('#searchMenu').combobox('clear');
				$('#searchMenu').combobox('hidePanel');
			}, 0);
		}
	});
}

function openM2(m2id){
	$(".m2").not($("#"+m2id)).hide();
	$("#"+m2id).show();
}