UE.registerUI('kityformula', function(editor, uiname){

    var kfDialog = new UE.ui.Dialog({
        iframeUrl: editor.options.UEDITOR_HOME_URL + 'kityformula-plugin/kityFormulaDialog.html',
        editor: editor,
        name: uiname,
        title: '公式',
        cssRules: 'width:920px; height: 480px;',
        buttons:[
            {
                className:'edui-okbutton',
                label:'确定',
                onclick:function () {
                    kfDialog.close(true);
                }
            },
            {
                className:'edui-cancelbutton',
                label:'取消',
                onclick:function () {
                    kfDialog.close(false);
                }
            }
        ]
    });

    function isFormulaImage(img) {
        return img && img.tagName && img.tagName.toLowerCase() === 'img' &&
            (img.getAttribute('data-latex') || img.getAttribute('latex'));
    }

    if (editor.ui && editor.ui._dialogs) {
        editor.ui._dialogs.kityformulaDialog = kfDialog;
    }

    editor.ready(function(){
        if (editor.ui && editor.ui._dialogs) {
            editor.ui._dialogs.kityformulaDialog = kfDialog;
        }
        UE.utils.cssRule(
            'kfformula',
            'img[data-latex]{vertical-align: middle; max-width: 100%;}',
            editor.document
        );
        UE.dom.domUtils.on(editor.document, 'dblclick', function (evt) {
            evt = evt || window.event;
            var target = evt.target || evt.srcElement;
            if (isFormulaImage(target)) {
                editor.selection.getRange().selectNode(target).select();
                kfDialog.render();
                kfDialog.open();
                UE.dom.domUtils.preventDefault(evt);
            }
        });
    });

    var iconUrl = editor.options.UEDITOR_HOME_URL + 'kityformula-plugin/kf-icon.png';
    var tmpLink = document.createElement('a');
    tmpLink.href = iconUrl;
    tmpLink.href = tmpLink.href;
    iconUrl = tmpLink.href;

    var kfBtn = new UE.ui.Button({
        name:'插入' + uiname,
        title:'插入公式',
        cssRules :'background: url("' + iconUrl + '") !important',
        onclick:function () {
            kfDialog.render();
            kfDialog.open();
        }
    });

    editor.addListener('selectionchange', function () {
        var state = editor.queryCommandState(uiname);
        var img = editor.selection.getRange().getClosedNode();
        if (state == -1) {
            kfBtn.setDisabled(true);
            kfBtn.setChecked(false);
        } else {
            kfBtn.setDisabled(false);
            kfBtn.setChecked(!!isFormulaImage(img));
        }
    });

    return kfBtn;
});
