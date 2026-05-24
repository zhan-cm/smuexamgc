function openIframeDialog(options,reload){
    var defaults = {
        fit:true,
        title:'查看',
        modal:true,
        resizable:true,
        hrefMode:"iframe",
        onClose:function(){
            $(this).dialog("destroy");
            if(reload===1){
                $('#datalist').datagrid('reload');
            }
        }
    };

    options = $.extend(defaults, options);
    //先渲染dlg，再加载
    var $dlg = $('<div id="ifmdlg"><iframe style="width:100%;height:100%;border:0;overflow:auto;"></iframe></div>');
    var ret = $dlg.dialog(options);
    $dlg.find('iframe')[0].src=options.url;
    return ret;
}

function formatDate(val) {
    if (!val) return '';
    try {
        let d;
        if (typeof val === 'number') {
            d = new Date(val);
        } else if (typeof val === 'string') {
            const m = val.match(/Date\((\d+)\)/); // /Date(1699968000000)/
            if (m) d = new Date(parseInt(m[1], 10));
            else d = new Date(val);
        } else if (val.time) { // 可能是 {time: xxx}
            d = new Date(val.time);
        } else {
            return String(val);
        }
        if (isNaN(d.getTime())) return String(val);
        const pad = n => String(n).padStart(2, '0');
        return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + ' ' +
            pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
    } catch (e) {
        return String(val);
    }
}

function formatTime(timestamp) {
    // 毫秒转秒，并向下取整
    const totalSeconds = Math.floor(timestamp / 1000);

    const h = Math.floor(totalSeconds / 3600);
    const m = Math.floor((totalSeconds % 3600) / 60);
    const s = totalSeconds % 60;

    const parts = [];
    if (h > 0) parts.push(h + '小时');
    if (m > 0) parts.push(m + '分钟');
    if (s > 0) parts.push(s + '秒');

    // 如果三者都为 0，则显示 “0秒”
    return parts.length > 0 ? parts.join('') : '0秒';
}

function cancelEasyUiFrame(parentReload){
    var p = window.parent;
    if (parentReload === 1) { try { p.location.reload(); } catch(e){} }

    try {
        var $p = p.$ || p.jQuery;
        // 1) 先定位“承载我的那个 iframe”元素
        var host = (function(){
            var iframes = p.document.getElementsByTagName('iframe');
            for (var i = 0; i < iframes.length; i++) {
                if (iframes[i].contentWindow === window) return iframes[i];
            }
            return null;
        })();

        if ($p && host) {
            var $host = $p(host);

            // a) 如果我在 EasyUI dialog/window 里：直接点“关闭”按钮
            var $win = $host.closest('div.window');        // EasyUI dialog/window 外层
            if ($win.length) {
                $win.find('a.panel-tool-close').trigger('click');
                return;
            }

            // b) 如果我在 tabs 的一个 panel 里：关闭这个 panel
            var $tabs = $p && $p.fn && $p.fn.tabs ? $p('#nav_tab') : null;
            if ($tabs && $tabs.length && host) {
                try {
                    var tabs = $tabs.tabs('tabs'); // Array<jQuery panel>
                    for (var i = 0; i < tabs.length; i++) {
                        var panelEl = tabs[i] && tabs[i][0];
                        if (panelEl && panelEl.contains(host)) {
                            $tabs.tabs('close', i);
                            return;
                        }
                    }
                } catch(e){}
            }
        }

        // c) 兜底：如果父页里确有 #ifmdlg，且它真是个 dialog，就关它
        if ($p) {
            var $dlg = $p('#ifmdlg');
            if ($dlg.length && ($dlg.data('dialog') || $p.fn.dialog)) {
                try { $dlg.dialog('close'); return; } catch(e){}
            }
            if (typeof p.tabsClose === 'function') { p.tabsClose(); return; }
        }
    } catch (e) {
        console.error(e);
    }

    try {
        // window.open 打开的页面，优先用 opener
        if (window.opener && !window.opener.closed) {
            if (parentReload === 1) {
                try { window.opener.location.reload(); } catch (e) {}
            }
            window.close();
            return;
        }
    } catch (e) {
        console.error(e);
    }

    // d) 仍然关不掉：不是脚本打开的新窗，浏览器不让 close —— 就回退或跳转
    if (history.length > 1) history.back();
    else location.href = (window.APP_HOME || '/');
}

var chnNumChar = ["零","一","二","三","四","五","六","七","八","九"];
var chnUnitSection = ["","万","亿","万亿","亿亿"];
var chnUnitChar = ["","十","百","千"];

function SectionToChinese(section) {
    if (section === 0) return '';
    var strIns = '';
    var chnStr = '';
    var unitPos = 0;
    var zero = true;
    while (section > 0) {
        var v = section % 10;
        if (v === 0) {
            if (!zero) {
                zero = true;
                chnStr = chnNumChar[v] + chnStr;
            }
        } else {
            zero = false;
            strIns = chnNumChar[v] + chnUnitChar[unitPos];
            chnStr = strIns + chnStr;
        }
        unitPos++;
        section = Math.floor(section / 10);
    }
    // 仅对“十几”形式去掉前导“一”
    if (chnStr.startsWith('一十')) {
        chnStr = chnStr.substring(1);
    }
    return chnStr;
}

function NumberToChinese(num) {
    if (num === 0) return chnNumChar[0];
    var unitPos = 0;
    var strIns = '';
    var chnStr = '';
    var needZero = false;

    while (num > 0) {
        var section = num % 10000;
        if (needZero) {
            chnStr = chnNumChar[0] + chnStr;
        }
        strIns = SectionToChinese(section) + (section !== 0 ? chnUnitSection[unitPos] : '');
        chnStr = strIns + chnStr;
        needZero = section > 0 && section < 1000;
        num = Math.floor(num / 10000);
        unitPos++;
    }

    return chnStr;
}

function ajaxLoading() {
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: $(document).height() }).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候...").appendTo("body").css({
        display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(document).height() - 45) / 2 ,
        height: "fit-content"
    });
}

function ajaxLoadEnd() {
    $("div[class='datagrid-mask']").remove();
    $("div[class='datagrid-mask-msg']").remove();
}

// 严格校验 ISO 日期（YYYY-MM-DD），含闰年与当月天数
function isValidISODateStr(s){
    if(!s || typeof s !== 'string') return false;
    var m = s.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if(!m) return false;
    var y = +m[1], mo = +m[2], d = +m[3];
    if(mo < 1 || mo > 12) return false;
    // 当月天数（y, mo, 0）得到 mo 月最后一天
    var maxD = new Date(y, mo, 0).getDate();
    return d >= 1 && d <= maxD;
}

// 把 YYYY-MM-DD 转成“UTC 下的日序号”，用于比较大小（避免时区影响）
function isoToEpochDay(s){
    var m = s.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if(!m) return NaN;
    var y = +m[1], mo = +m[2] - 1, d = +m[3];
    return Math.floor(Date.UTC(y, mo, d) / 86400000);
}

Date.prototype.format = function(format)
{
    var o = {
        "M+" : this.getMonth()+1, //month
        "d+" : this.getDate(), //day
        "h+" : this.getHours(), //hour
        "m+" : this.getMinutes(), //minute
        "s+" : this.getSeconds(), //second
        "q+" : Math.floor((this.getMonth()+3)/3), //quarter
        "S" : this.getMilliseconds() //millisecond
    };
    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
        (this.getFullYear()+"").substr(4- RegExp.$1.length));
    for(var k in o)if(new RegExp("("+ k +")").test(format))
        format = format.replace(RegExp.$1,
            RegExp.$1.length==1? o[k] :
                ("00"+ o[k]).substr((""+ o[k]).length));
    return format;
};

