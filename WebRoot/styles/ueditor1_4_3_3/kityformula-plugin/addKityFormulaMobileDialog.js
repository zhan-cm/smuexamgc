UE.registerUI('kityformula-mobile', function(editor, uiname){

    var mobileDialog = new UE.ui.Dialog({
        iframeUrl: editor.options.UEDITOR_HOME_URL + 'kityformula-plugin/kityFormulaMobileDialog.html',
        editor: editor,
        name: uiname,
        title: '公式',
        // UEditor 的 cssRules 只作用在 .edui-dialog-content 上，不能用 width:100%;height:100%。
        // 移动端直接使用 UEditor 内置 fullscreen 逻辑，让它按 viewport 计算像素尺寸。
        fullscreen: true,
        draggable: false,
        buttons:[
            {
                className:'edui-okbutton',
                label:'确定',
                onclick:function () {
                    mobileDialog.close(true);
                }
            },
            {
                className:'edui-cancelbutton',
                label:'取消',
                onclick:function () {
                    mobileDialog.close(false);
                }
            }
        ]
    });

    function isFormulaImage(img) {
        return img && img.tagName && img.tagName.toLowerCase() === 'img' &&
            (img.getAttribute('data-latex') || img.getAttribute('latex'));
    }

    function activateIframeKeyboard() {
        try {
            var iframe = mobileDialog.getDom && mobileDialog.getDom('iframe');
            if (iframe && iframe.contentWindow && iframe.contentWindow.KityFormulaMobile) {
                iframe.contentWindow.KityFormulaMobile.activate();
            }
        } catch (e) {}
    }

    function openMobileDialog() {
        mobileDialog.render();
        mobileDialog.open();
        // UEditor.open() 最后会 focus iframe，本页面再稍后把焦点抢回 math-field。
        setTimeout(activateIframeKeyboard, 80);
        setTimeout(activateIframeKeyboard, 250);
        setTimeout(activateIframeKeyboard, 600);
    }

    function openFormulaDialogFromNode(img, evt) {
        if (!isFormulaImage(img)) return false;
        editor.selection.getRange().selectNode(img).select();
        openMobileDialog();
        if (evt) {
            UE.dom.domUtils.preventDefault(evt);
        }
        return true;
    }

    if (editor.ui && editor.ui._dialogs) {
        editor.ui._dialogs.kityformulaMobileDialog = mobileDialog;
    }

    editor.ready(function(){
        if (editor.ui && editor.ui._dialogs) {
            editor.ui._dialogs.kityformulaMobileDialog = mobileDialog;
        }
        UE.utils.cssRule(
            'kfformula-mobile',
            'img[data-latex]{vertical-align: middle; max-width: 100%;}',
            editor.document
        );

        // 移动端：点已有公式直接编辑。PC 端原 kityformula 的双击逻辑不受影响。
        UE.dom.domUtils.on(editor.document, 'touchend', function (evt) {
            evt = evt || window.event;
            var target = evt.target || evt.srcElement;
            openFormulaDialogFromNode(target, evt);
        });

        // 兼容部分手机浏览器把 touchend 转成 click 的情况。
        UE.dom.domUtils.on(editor.document, 'click', function (evt) {
            evt = evt || window.event;
            var target = evt.target || evt.srcElement;
            openFormulaDialogFromNode(target, evt);
        });
    });

    var iconUrl = editor.options.UEDITOR_HOME_URL + 'kityformula-plugin/kf-icon.png';
    var tmpLink = document.createElement('a');
    tmpLink.href = iconUrl;
    tmpLink.href = tmpLink.href;
    iconUrl = tmpLink.href;

    var mobileBtn = new UE.ui.Button({
        name:'插入' + uiname,
        title:'插入公式',
        cssRules :'background: url("' + iconUrl + '") !important',
        onclick:function () {
            openMobileDialog();
        }
    });

    editor.addListener('selectionchange', function () {
        var state = editor.queryCommandState(uiname);
        var img = editor.selection.getRange().getClosedNode();
        if (state == -1) {
            mobileBtn.setDisabled(true);
            mobileBtn.setChecked(false);
        } else {
            mobileBtn.setDisabled(false);
            mobileBtn.setChecked(!!isFormulaImage(img));
        }
    });

    return mobileBtn;
});
