/**
 * kaoyi-exam-normal.with-face.js
 * 在 exam-normal.js 基础上集成人脸识别逻辑。
 * 约束：
 * 1) 保持原有切屏/快捷键/guardedAjax/图片预览等功能不变。
 * 2) 人脸识别保留旧入口：faceRec / takePic / isTimeToRec。
 * 3) 默认不阻塞考试提交流程，仍采用异步触发。
 * 4) 尽量降低 JSP 侵入：不再要求页面中保留隐藏 canvas 标签。
 * 5) 兼容 Chrome 50，避免引入 async/await、可选链等新语法。
 */

/**
 * exam-normal.js
 * 自动绑定切屏检测（visibilitychange），且保证不重复绑定
 * 依赖：jQuery
 */

/* =========================
 * 0) 兼容全局变量（如果外部没声明）
 * ========================= */
if (typeof window.APP_CTX === "undefined") window.APP_CTX = "";
if (typeof isSubmitting === "undefined") var isSubmitting = false; // 跳转标志，避免误判切屏记录

/* =========================
 * 1) apiUrl：显式拼接 JSP 的 contextPath（不影响全站 ajax）
 * ========================= */
function apiUrl(path) {
    var ctx = window.APP_CTX || "";
    if (!path) return ctx;

    if (/^https?:\/\//i.test(path)) return path; // 绝对地址不处理
    if (path.charAt(0) !== "/") path = "/" + path; // 确保以 / 开头

    return ctx + path;
}

function showimage(source) {
    const $m = $("#imgModal");
    const el = $m[0];

    const $dialog = $m.find(".modal-dialog");
    const $content = $m.find(".modal-content");
    const $viewport = $m.find("#imgViewport");
    const $img = $m.find("#previewImg");

    // 固定模态框大小
    $dialog.css({
        width: "75vw",
        maxWidth: "none",
        marginLeft: "auto",
        marginRight: "auto",
        marginTop: "0",
        marginBottom: "0",
        top: "0",
        transform: "none"
    });

    $content.css({
        width: "75vw",
        height: "75vh",
        overflow: "hidden",
        position: "relative"
    });

    let naturalWidth = 0;
    let naturalHeight = 0;

    let baseScale = 1;   // 初始适配比例
    let scale = 1;       // 当前比例
    let minScale = 0.5;  // 最小缩放到 50%
    let maxScale = 5;    // 最大可放大倍数

    let x = 0;           // 当前平移
    let y = 0;

    let dragging = false;
    let startX = 0;
    let startY = 0;
    let startTranslateX = 0;
    let startTranslateY = 0;

    function getViewportSize() {
        return {
            w: $viewport.innerWidth(),
            h: $viewport.innerHeight()
        };
    }

    function clampTranslate() {
        const { w: vw, h: vh } = getViewportSize();
        const imgW = naturalWidth * scale;
        const imgH = naturalHeight * scale;

        // 横向
        if (imgW <= vw) {
            x = (vw - imgW) / 2;
        } else {
            const minX = vw - imgW;
            const maxX = 0;
            x = Math.min(maxX, Math.max(minX, x));
        }

        // 纵向
        if (imgH <= vh) {
            y = (vh - imgH) / 2;
        } else {
            const minY = vh - imgH;
            const maxY = 0;
            y = Math.min(maxY, Math.max(minY, y));
        }
    }

    function render() {
        clampTranslate();
        $img.css("transform", `translate(${x}px, ${y}px) scale(${scale})`);
    }

    function fitImage() {
        const { w: vw, h: vh } = getViewportSize();

        if (!naturalWidth || !naturalHeight || !vw || !vh) return;

        // 大图缩小，小图保持原尺寸
        baseScale = Math.min(vw / naturalWidth, vh / naturalHeight, 1);
        scale = baseScale;

        // 最小缩放限制为 “初始显示比例的一半” 或 0.5，二选一
        minScale = Math.min(baseScale, 1) * 0.5;
        maxScale = Math.max(baseScale, 1) * 5;

        // 设置图片原始尺寸，用 scale 控制显示大小
        $img.css({
            width: naturalWidth + "px",
            height: naturalHeight + "px",
            left: 0,
            top: 0
        });

        // 初始居中
        x = (vw - naturalWidth * scale) / 2;
        y = (vh - naturalHeight * scale) / 2;

        render();
    }

    function zoomAt(clientX, clientY, deltaY) {
        const rect = $viewport[0].getBoundingClientRect();
        const offsetX = clientX - rect.left;
        const offsetY = clientY - rect.top;

        const oldScale = scale;
        const step = 0.1;

        if (deltaY < 0) {
            scale = scale * (1 + step); // 放大
        } else if (deltaY > 0) {
            scale = scale * (1 - step); // 缩小
        }

        scale = Math.max(minScale, Math.min(maxScale, scale));

        if (scale === oldScale) return;

        const imgX = (offsetX - x) / oldScale;
        const imgY = (offsetY - y) / oldScale;

        x = offsetX - imgX * scale;
        y = offsetY - imgY * scale;

        render();
    }

    function onWheel(e) {
        e.preventDefault();

        const oe = e.originalEvent || e;
        const deltaY = oe.deltaY !== undefined
            ? oe.deltaY
            : (oe.wheelDelta !== undefined ? -oe.wheelDelta : 0);

        zoomAt(oe.clientX, oe.clientY, deltaY);
    }

    function onMouseDown(e) {
        e.preventDefault();
        dragging = true;
        startX = e.clientX;
        startY = e.clientY;
        startTranslateX = x;
        startTranslateY = y;
        $viewport.addClass("dragging");
    }

    function onMouseMove(e) {
        if (!dragging) return;

        x = startTranslateX + (e.clientX - startX);
        y = startTranslateY + (e.clientY - startY);

        render();
    }

    function onMouseUp() {
        dragging = false;
        $viewport.removeClass("dragging");
    }

    function bindEvents() {
        $viewport.on("wheel.imagezoom", onWheel);
        $viewport.on("mousedown.imagezoom", onMouseDown);
        $(document).on("mousemove.imagezoom", onMouseMove);
        $(document).on("mouseup.imagezoom", onMouseUp);
        $(window).on("resize.imagezoom", fitImage);
    }

    function unbindEvents() {
        $viewport.off(".imagezoom");
        $(document).off(".imagezoom");
        $(window).off(".imagezoom");
    }

    function centerModal() {
        requestAnimationFrame(() => {
            const vh = window.innerHeight;
            const dh = $dialog.outerHeight(true);
            const mt = (dh >= vh - 16) ? 8 : Math.floor((vh - dh) / 2);
            $dialog.css({
                marginTop: mt + "px",
                marginBottom: mt + "px"
            });
        });
    }

    function initAfterLoad() {
        naturalWidth = $img[0].naturalWidth;
        naturalHeight = $img[0].naturalHeight;
        fitImage();
        centerModal();
    }

    // 先解绑，避免重复绑定
    unbindEvents();

    $img.off("load").on("load", initAfterLoad);
    $img.attr("src", source);

    if ($img[0].complete) {
        initAfterLoad();
    }

    const onShown = function () {
        fitImage();
        centerModal();
        bindEvents();
    };

    const onHidden = function () {
        unbindEvents();
        dragging = false;
    };

    // BS3 / BS4
    if (window.jQuery && $.fn && $.fn.modal) {
        $m.one("shown.bs.modal", onShown);
        $m.one("hidden.bs.modal", onHidden);
        $m.modal("show");
    } else if (window.bootstrap && bootstrap.Modal) {
        // BS5
        el.addEventListener("shown.bs.modal", onShown, { once: true });
        el.addEventListener("hidden.bs.modal", onHidden, { once: true });
        bootstrap.Modal.getOrCreateInstance(el).show();
    }
}

/* =========================
 * guardedAjax：通用锁 + 冷却 + 自动禁用按钮
 * ========================= */
var guardedAjax = (function () {
    var states = new Map();
    var styleInjected = false;

    function injectStyleOnce() {
        if (styleInjected) return;
        styleInjected = true;

        // 主要给 <a class="btn"> 这种没有 disabled 属性的元素用
        var css =
            ".guarded-disabled{cursor:not-allowed !important;}" +
            "a.guarded-disabled{pointer-events:none !important; opacity:.65;}";

        var style = document.createElement("style");
        style.type = "text/css";
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);
    }

    function escapeRegExp(str) {
        return String(str).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    // 找到所有 onclick 中“调用了 guardKey(” 的按钮/链接
    function findTargetsByGuardKey(guardKey) {
        if (!guardKey) return $();

        var key = escapeRegExp(guardKey);
        // 匹配 refreshTime( / refreshTime ( / ... refreshTime( ...
        // 这里用 “非标识符字符或开头” 来避免误匹配 refreshTime2(
        var re = new RegExp("(^|[^\\w$])" + key + "\\s*\\(");

        return $("button[onclick],input[type=button][onclick],input[type=submit][onclick],a[onclick]")
            .filter(function () {
                var onclick = this.getAttribute("onclick") || "";
                return re.test(onclick);
            });
    }

    // 支持自定义 selector，不想靠 onclick 扫描时用它
    function getTargets(options, key) {
        if (options && options.disableSelector) return $(options.disableSelector);
        return findTargetsByGuardKey(key);
    }

    function disableTargets($targets) {
        if (!$targets || !$targets.length) return;
        injectStyleOnce();

        $targets.each(function () {
            var $el = $(this);

            // 已经被我们禁用过就不重复处理
            if ($el.data("guarded_lock_applied")) return;

            // 如果本来就是 disabled（button/input），就别动它（避免误恢复）
            if ($el.is("button,input") && $el.prop("disabled") === true) return;

            $el.data("guarded_lock_applied", true);

            // 记录原始状态，便于恢复
            $el.data("guarded_prev_disabled", $el.is("button,input") ? $el.prop("disabled") : null);
            $el.data("guarded_prev_pointer_events", $el.is("a") ? $el.css("pointer-events") : null);

            if ($el.is("button,input")) {
                $el.prop("disabled", true);
            } else {
                // a 标签等
                $el.addClass("guarded-disabled disabled").attr("aria-disabled", "true").css("pointer-events", "none");
            }
        });
    }

    function enableTargets($targets) {
        if (!$targets || !$targets.length) return;

        $targets.each(function () {
            var $el = $(this);
            if (!$el.data("guarded_lock_applied")) return;

            var prevDisabled = $el.data("guarded_prev_disabled");
            var prevPE = $el.data("guarded_prev_pointer_events");

            $el.removeData("guarded_lock_applied");
            $el.removeData("guarded_prev_disabled");
            $el.removeData("guarded_prev_pointer_events");

            if ($el.is("button,input")) {
                // 只恢复我们改过的（上面已跳过“原本就 disabled”的）
                $el.prop("disabled", !!prevDisabled);
            } else {
                $el.removeClass("guarded-disabled disabled").removeAttr("aria-disabled");
                $el.css("pointer-events", prevPE || "");
            }
        });
    }

    function scheduleEnable(options, key, state) {
        // 冷却结束再恢复
        var delay = Math.max(0, state.nextAllowedAt - Date.now());

        if (state.enableTimer) clearTimeout(state.enableTimer);

        state.enableTimer = setTimeout(function () {
            // 到点重新找一次（避免 DOM 替换后找不到）
            var $targets = getTargets(options, key);
            enableTargets($targets);
            state.enableTimer = null;
        }, delay);
    }

    return function (options) {
        options = options || {};

        var cooldown = (typeof options.cooldown === "number") ? options.cooldown : 2000;
        var autoDisable = (options.autoDisable !== false); // 默认 true

        var type = (options.type || "GET");
        var key = options.guardKey || (String(type).toUpperCase() + " " + options.url);

        var now = Date.now();
        var state = states.get(key) || { busy: false, nextAllowedAt: 0, enableTimer: null };

        // 记录本次 UI 配置，供 scheduleEnable 用
        state._lastOptions = options;

        // 如果正在请求 or 冷却期：拦截，同时确保按钮处于禁用状态，并安排恢复
        if (state.busy || now < state.nextAllowedAt) {
            if (autoDisable) {
                var $t0 = getTargets(options, key);
                disableTargets($t0);
                if (!state.busy && now < state.nextAllowedAt) {
                    scheduleEnable(options, key, state);
                }
            }
            states.set(key, state);
            return $.Deferred().reject({ guarded: true, reason: state.busy ? "busy" : "cooldown", key: key }).promise();
        }

        // 放行：先禁用按钮（请求中也禁用）
        if (autoDisable) {
            var $t1 = getTargets(options, key);
            disableTargets($t1);
        }

        state.busy = true;
        states.set(key, state);

        var jqXHR = $.ajax(options);

        jqXHR.always(function () {
            state.busy = false;
            state.nextAllowedAt = Date.now() + cooldown;
            states.set(key, state);

            if (autoDisable) {
                scheduleEnable(options, key, state);
            }
        });

        return jqXHR;
    };
})();

/* =========================
 * 3) 切屏检测 / 作弊记录通用逻辑
 * ========================= */
var cheat_time = false;
var countdown = null;
var princ_state = 2;

function client_cheat(msg) {
    mark_cheat(2, "");

    if ("exit1" === msg) {
        $("#cheatMsg").html("系统检测到考生离开考试端，已上报！请严肃对待考试，否则将会取消您的考试资格，如有异常请及时报告监考老师！");
        $("#cheatModal").modal();

        if (!cheat_time) {
            cheat_time = true;
            countdown = setTimeout(function () {
                mark_cheat(3, "切屏超过10s。");
            }, 10000);
        }
    }

    if ("back" === msg) {
        if (countdown) {
            clearTimeout(countdown);
            countdown = null;
        }
        cheat_time = false;
    }
}

function mark_cheat(princ_state, content) {
    $.ajax({
        url: apiUrl("/exam/mark_cheat"),
        type: "POST",
        data: { content: content, princ_state: princ_state },
        success: function () { }
    });
}

function locationHref(url) {
    unbindCheatDetection();
    isSubmitting = true; // 设置标志，指示正在提交考试，否则跳转会让页面记录下正在切屏
    window.location.href = apiUrl("/" + url).replace(/\/{2,}/g, "/").replace(window.APP_CTX + "http", "http"); // 简单容错
}

function record_cheat(state, addSeconds) {
    if (!addSeconds) addSeconds = 0;

    if (!isSubmitting) {
        $.ajax({
            url: apiUrl("/exam/record_cheat"),
            type: "POST",
            async: true,
            data: { state: state, addSeconds: addSeconds },
            success: function (data) {
                if (data !== "limit") {
                    $("#cheat_tip").html("警告，系统检测到您在考试过程有切屏行为，已经通知监考教师重点关注，请严肃对待每一场考试！");
                } else {
                    mark_cheat(3, "检测到切屏超过限制次数");
                    locationHref("exam/toEnd?exit=6&locale=" + $("#lan").val());
                }
            }
        });
    }
}

/* =========================
 * 4) visibilitychange 监听（你原逻辑保留）
 * ========================= */
var hiddenTimer = null;
var isHidden = false;
var hiddenTriggered = false;
var waitHiddenSeconds = 3;

var handleVisibilityChange = function () {
    if (document.visibilityState === "hidden") {
        isHidden = true;

        hiddenTimer = setTimeout(function () {
            if (isHidden) {
                record_cheat("out");
                hiddenTriggered = true;
            }
        }, waitHiddenSeconds * 1000);

    } else if (document.visibilityState === "visible") {
        if (hiddenTimer) {
            clearTimeout(hiddenTimer);
            hiddenTimer = null;
        }

        if (hiddenTriggered) {
            record_cheat("back", waitHiddenSeconds);
            hiddenTriggered = false;
        }

        isHidden = false;
    }
};

/* =========================
 * 5) 绑定/解绑：保证不重复绑定（全局一次）
 * ========================= */
function bindCheatDetection() {
    if (typeof $ === "undefined") return;
    if (window.__EXAM_VISIBILITY_BOUND__) return; // 已绑定过就直接返回

    // 先 off 再 on，双保险
    $(document).off("visibilitychange", handleVisibilityChange);
    $(document).on("visibilitychange", handleVisibilityChange);

    window.__EXAM_VISIBILITY_BOUND__ = true;
}

function unbindCheatDetection() {
    if (typeof $ === "undefined") return;

    $(document).off("visibilitychange", handleVisibilityChange);
    window.__EXAM_VISIBILITY_BOUND__ = false;
}

function __examContextMenuHandler(e) {
    e.preventDefault(); // 阻止右键菜单
}

function __examKeydownHandler(e) {
    const key = e.key;
    const isCtrl = e.ctrlKey;
    const isAlt = e.altKey;
    const isMeta = e.metaKey;

    const isF4 = key === "F4";
    const isF5 = key === "F5";
    const isF11 = key === "F11";
    const isF12 = key === "F12";
    const isF6 = key === "F6";
    const isTab = key === "Tab";

    const isCtrlS = (key === "s" || key === "S") && isCtrl;
    const isCtrlW = (key === "w" || key === "W") && isCtrl;
    const isCtrlC = (key === "c" || key === "C") && isCtrl;
    const isCtrlV = (key === "v" || key === "V") && isCtrl;

    const isCtrlR = (key === "r" || key === "R") && isCtrl;
    const isCtrlL = (key === "l" || key === "L") && isCtrl;

    const isAltD  = (key === "d" || key === "D") && isAlt;
    const isAltE  = (key === "e" || key === "E") && isAlt;

    const isAltDirection = isAlt && (key === "ArrowLeft" || key === "ArrowRight");
    const isAltF4 = isAlt && key === "F4";

    const isCmdR = (key === "r" || key === "R") && isMeta;
    const isCmdL = (key === "l" || key === "L") && isMeta;

    const isCmdLeftBracket  = key === "[" && isMeta;
    const isCmdRightBracket = key === "]" && isMeta;
    const isCmdArrowLeft  = key === "ArrowLeft" && isMeta;
    const isCmdArrowRight = key === "ArrowRight" && isMeta;

    const shouldBlock =
        isTab ||
        [isF4, isF5, isF6, isF11, isF12].includes(true) ||
        [isCtrlS, isCtrlW, isCtrlC, isCtrlV, isCtrlR, isCtrlL].includes(true) ||
        (isAltDirection || isAltD || isAltE) ||
        (isCmdR || isCmdL || isCmdLeftBracket || isCmdRightBracket || isCmdArrowLeft || isCmdArrowRight);

    if (shouldBlock) {
        e.preventDefault();
        e.stopPropagation();
        return false;
    }
}

function bindExamKeyBlockers() {
    if (window.__EXAM_KEYBLOCK_BOUND__) return;

    window.removeEventListener("contextmenu", __examContextMenuHandler, false);
    window.addEventListener("contextmenu", __examContextMenuHandler, false);

    window.removeEventListener("keydown", __examKeydownHandler, false);
    window.addEventListener("keydown", __examKeydownHandler, false);

    window.__EXAM_KEYBLOCK_BOUND__ = true;
}

function unbindExamKeyBlockers() {
    window.removeEventListener("contextmenu", __examContextMenuHandler, false);
    window.removeEventListener("keydown", __examKeydownHandler, false);
    window.__EXAM_KEYBLOCK_BOUND__ = false;
}

/* =========================
 * 6) 脚本加载后自动绑定
 * ========================= */
(function autoBindOnLoad() {
    if (typeof $ !== "undefined" && $.fn && $.fn.jquery) {
        if (document.readyState === "loading") {
            $(function () { bindCheatDetection(); });
        } else {
            bindCheatDetection();
        }
    } else {
        // 兜底：没 jQuery 时用原生
        if (!window.__EXAM_VISIBILITY_BOUND_NATIVE__) {
            document.addEventListener("visibilitychange", handleVisibilityChange, false);
            window.__EXAM_VISIBILITY_BOUND_NATIVE__ = true;
        }
    }

    // 2) 右键/快捷键：不依赖 jQuery，直接绑定一次
    bindExamKeyBlockers();
})();

const chnNumChar = [ "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" ];
const chnUnitSection = [ "", "万", "亿", "万亿", "亿亿" ];
const chnUnitChar = [ "", "十", "百", "千" ];

function SectionToChinese(section) {
    let strIns = '', chnStr = '';
    let unitPos = 0;
    let zero = true;
    while (section > 0) {
        let v = section % 10;
        if (v === 0) {
            if (!zero) {
                zero = true;
                chnStr = chnNumChar[v] + chnStr;
            }
        } else {
            zero = false;
            strIns = chnNumChar[v];
            strIns += chnUnitChar[unitPos];
            chnStr = strIns + chnStr;
        }
        unitPos++;
        section = Math.floor(section / 10);
    }
    return chnStr;
}
function NumberToChinese(num) {
    let unitPos = 0;
    let strIns = '', chnStr = '';
    let needZero = false;

    if (num === 0) {
        return chnNumChar[0];
    }

    while (num > 0) {
        let section = num % 10000;
        if (needZero) {
            chnStr = chnNumChar[0] + chnStr;
        }
        strIns = SectionToChinese(section);
        strIns += (section !== 0) ? chnUnitSection[unitPos]
            : chnUnitSection[0];
        chnStr = strIns + chnStr;
        needZero = (section < 1000) && (section > 0);
        num = Math.floor(num / 10000);
        unitPos++;
    }

    return chnStr;
}

/* =========================
 * 7) 人脸识别低侵入封装
 * ========================= */
(function (window) {
    if (!window) return;

    var document = window.document;
    var $ = window.jQuery;

    function extend(target, source) {
        var key;
        target = target || {};
        source = source || {};
        for (key in source) {
            if (source.hasOwnProperty(key)) {
                target[key] = source[key];
            }
        }
        return target;
    }

    function trimSlashRight(str) {
        return String(str || "").replace(/\/+$/, "");
    }

    function buildUrl(path, ctx) {
        if (typeof window.apiUrl === "function") {
            return window.apiUrl(path);
        }

        ctx = trimSlashRight(ctx || window.APP_CTX || "");
        path = path || "";

        if (/^https?:\/\//i.test(path)) return path;
        if (path.charAt(0) !== "/") path = "/" + path;

        return ctx + path;
    }

    function safeToastr(type, message) {
        try {
            if (window.toastr && typeof window.toastr[type] === "function") {
                window.toastr[type](message);
            }
        } catch (e) {}
    }

    function setHtml(id, html) {
        try {
            if ($ && $("#" + id).length) {
                $("#" + id).html(html);
                return;
            }
            var el = document.getElementById(id);
            if (el) el.innerHTML = html;
        } catch (e) {}
    }

    function showCheatModal(message) {
        if (typeof message !== "undefined") {
            setHtml("cheatMsg", message);
        }

        try {
            if ($ && $("#cheatModal").length && $.fn && $.fn.modal) {
                $("#cheatModal").modal();
            }
        } catch (e) {}
    }

    function getLanFlag() {
        try {
            if (typeof window.lan !== "undefined") {
                return window.lan;
            }
            var lanEl = document.getElementById("lan");
            if (lanEl && typeof lanEl.value !== "undefined") {
                return lanEl.value;
            }
        } catch (e) {}
        return 0;
    }

    function shouldVerifyFromValue(value) {
        return String(value) === "2";
    }

    var module = {
        opts: {
            enabled: false,
            sidverify: null,
            contextPath: "",
            videoId: "video",
            videoBoxId: "videoBox",
            canvasId: "",
            canvasWidth: 180,
            canvasHeight: 220,
            imageType: "image/jpeg",
            isTimeToRecUrl: "/exam/isTimeToRec",
            saveExamPicUrl: "/exam/saveExamPic",
            faceSimilarUrl: "/exam/faceSimilar",
            faceSimilar4ClientUrl: "/exam/faceSimilar4Client",
            endExamUrl: "/exam/toEnd"
        },

        state: {
            initialized: false,
            enabled: false,
            initStarted: false,
            resizeBound: false,
            stream: null,
            video: null,
            canvas: null,
            context: null,
            cropRect: { sx: 0, sy: 0, sw: 0, sh: 0 }
        },

        init: function (options) {
            if (options) {
                extend(this.opts, options);
            }

            if (typeof this.opts.enabled === "boolean") {
                this.state.enabled = this.opts.enabled;
            } else if (this.opts.sidverify !== null && typeof this.opts.sidverify !== "undefined") {
                this.state.enabled = shouldVerifyFromValue(this.opts.sidverify);
            } else {
                var sidEl = document.getElementById("sidverify");
                this.state.enabled = sidEl ? shouldVerifyFromValue(sidEl.value) : false;
            }

            if (!this.state.enabled) {
                return this;
            }

            this.state.video = document.getElementById(this.opts.videoId);
            if (!this.state.video) {
                return this;
            }

            this.ensureCanvas();

            if (!this.state.resizeBound && window.addEventListener) {
                var self = this;
                window.addEventListener("resize", function () {
                    self.syncVideoLayout();
                }, false);
                this.state.resizeBound = true;
            }

            if (!this.state.initStarted) {
                this.startCamera();
                this.state.initStarted = true;
            }

            this.state.initialized = true;
            return this;
        },

        ensureCanvas: function () {
            if (this.state.canvas && this.state.context) {
                return true;
            }

            var canvas = null;
            if (this.opts.canvasId) {
                canvas = document.getElementById(this.opts.canvasId);
            }

            if (!canvas) {
                canvas = document.createElement("canvas");
            }

            canvas.width = this.opts.canvasWidth;
            canvas.height = this.opts.canvasHeight;

            this.state.canvas = canvas;
            this.state.context = canvas.getContext ? canvas.getContext("2d") : null;

            return !!this.state.context;
        },

        startCamera: function () {
            var self = this;

            function onSuccess(stream) {
                var video = self.state.video;
                var compatibleURL = window.URL || window.webkitURL;

                self.state.stream = stream;

                try {
                    if ("srcObject" in video) {
                        video.srcObject = stream;
                    } else {
                        video.src = compatibleURL.createObjectURL(stream);
                    }
                } catch (e) {
                    try {
                        video.src = compatibleURL.createObjectURL(stream);
                    } catch (e2) {}
                }

                video.onloadedmetadata = function () {
                    try {
                        self.syncVideoLayout();
                    } catch (e3) {}
                    try {
                        video.play();
                    } catch (e4) {}
                };

                window.setTimeout(function () {
                    if (video.videoWidth && video.videoHeight) {
                        self.syncVideoLayout();
                    }
                }, 500);
            }

            function onError() {
                safeToastr("error", "摄像头调用失败，无法拍照！");
            }

            this.getUserMedia({ video: true, audio: false }, onSuccess, onError);
        },

        getUserMedia: function (constraints, success, error) {
            try {
                if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                    var p = navigator.mediaDevices.getUserMedia(constraints);
                    if (p && typeof p.then === "function") {
                        p.then(success, error);
                        return;
                    }
                } else if (navigator.webkitGetUserMedia) {
                    navigator.webkitGetUserMedia(constraints, success, error);
                    return;
                } else if (navigator.mozGetUserMedia) {
                    navigator.mozGetUserMedia(constraints, success, error);
                    return;
                } else if (navigator.getUserMedia) {
                    navigator.getUserMedia(constraints, success, error);
                    return;
                }
            } catch (e) {
                error(e);
                return;
            }

            safeToastr("error", "不支持访问用户媒体！");
        },

        syncVideoLayout: function () {
            var video = this.state.video;
            var box = document.getElementById(this.opts.videoBoxId);
            var cropRect = this.state.cropRect;
            var boxW = this.opts.canvasWidth;
            var boxH = this.opts.canvasHeight;
            var boxRatio = boxW / boxH;
            var vw, vh, videoRatio;
            var renderW, renderH, left, top;

            if (!video || !box) return;

            vw = video.videoWidth;
            vh = video.videoHeight;
            if (!vw || !vh) return;

            videoRatio = vw / vh;

            if (videoRatio > boxRatio) {
                renderH = boxH;
                renderW = renderH * videoRatio;
                left = -Math.round((renderW - boxW) / 2);
                top = 0;

                cropRect.sh = vh;
                cropRect.sw = Math.round(vh * boxRatio);
                cropRect.sx = Math.round((vw - cropRect.sw) / 2);
                cropRect.sy = 0;
            } else {
                renderW = boxW;
                renderH = renderW / videoRatio;
                left = 0;
                top = -Math.round((renderH - boxH) / 2);

                cropRect.sw = vw;
                cropRect.sh = Math.round(vw / boxRatio);
                cropRect.sx = 0;
                cropRect.sy = Math.round((vh - cropRect.sh) / 2);
            }

            video.style.width = renderW + "px";
            video.style.height = renderH + "px";
            video.style.left = left + "px";
            video.style.top = top + "px";
        },

        drawVideoToCanvas: function () {
            var video = this.state.video;
            var canvas = this.state.canvas;
            var context = this.state.context;
            var cropRect = this.state.cropRect;

            if (!video || !canvas || !context) return false;

            this.syncVideoLayout();

            if (!video.videoWidth || !video.videoHeight) {
                return false;
            }

            try {
                context.drawImage(
                    video,
                    cropRect.sx,
                    cropRect.sy,
                    cropRect.sw,
                    cropRect.sh,
                    0,
                    0,
                    canvas.width,
                    canvas.height
                );
                return true;
            } catch (e) {
                return false;
            }
        },

        captureBase64: function () {
            var canvas = this.state.canvas;
            var context = this.state.context;
            var imageData = "";

            if (!this.drawVideoToCanvas()) {
                return "";
            }

            try {
                imageData = canvas.toDataURL(this.opts.imageType).replace(/^data:image\/\w+;base64,/, "");
                window.base64Str = imageData;
            } catch (e) {
                imageData = "";
            }

            try {
                context.clearRect(0, 0, canvas.width, canvas.height);
            } catch (e2) {}

            return imageData;
        },

        savePicAndCompare: function (compareUrl, extraData) {
            var self = this;
            var base64 = this.captureBase64();
            var data = extraData || {};

            if (!base64) {
                return;
            }

            $.ajax({
                url: buildUrl(this.opts.saveExamPicUrl, this.opts.contextPath),
                async: true,
                type: "POST",
                data: { base64Str: base64 },
                success: function (picPath) {
                    if (picPath == null || picPath == "-1") {
                        if (getLanFlag() == 1 || getLanFlag() == "en_US") {
                            showCheatModal("Fail to save pictures!");
                        } else {
                            showCheatModal("照片保存本地失败");
                        }
                        return;
                    }

                    $.ajax({
                        url: buildUrl(compareUrl, self.opts.contextPath),
                        async: true,
                        type: "POST",
                        data: data,
                        success: function (res) {
                            if (res == "warning") {
                                setHtml("cheat_tip", "警告：人脸识别相似度低！请确保整个人脸在摄像头范围内！");
                                showCheatModal("人脸识别相似度低！请确保整个人脸在摄像头范围内！请严肃对待考试");
                            } else if (res != "success") {
                                safeToastr("error", "对比失败");
                                window.location.href = buildUrl(self.opts.endExamUrl, self.opts.contextPath) + "?exit=5&locale=" + getLanFlag();
                            }
                        }
                    });
                }
            });
        },

        faceRec: function () {
            var self = this;
            if (!this.state.enabled) return;

            $.ajax({
                url: buildUrl(this.opts.isTimeToRecUrl, this.opts.contextPath),
                async: true,
                type: "POST",
                success: function (data) {
                    if (data > 0) {
                        self.savePicAndCompare(self.opts.faceSimilarUrl, { situation: "test" });
                    }
                }
            });
        },

        takePic: function () {
            if (!this.state.enabled) return;

            this.captureBase64();

            try {
                if (window.CefSharp && typeof window.CefSharp.BindObjectAsync === "function") {
                    window.CefSharp.BindObjectAsync("googlebrower");
                }
            } catch (e) {}
        },

        isTimeToRec: function (flag) {
            var compareUrl = this.opts.faceSimilar4ClientUrl;

            if (!this.state.enabled) return;

            if (flag == 1) {
                safeToastr("warning", "检测不到人脸，请确保整个人脸在摄像头范围内！请严肃考试！");
                return;
            } else if (flag == 2) {
                compareUrl = this.opts.faceSimilarUrl;
            }

            this.savePicAndCompare(compareUrl, {
                situation: "test",
                clientFeatures: flag
            });
        }
    };

    window.ExamFaceVerify = module;

    window.faceRec = function () {
        return module.faceRec();
    };

    window.takePic = function () {
        return module.takePic();
    };

    window.isTimeToRec = function (flag) {
        return module.isTimeToRec(flag);
    };

    window.initExamFaceVerify = function (options) {
        return module.init(options);
    };

    if (typeof window.base64Str === "undefined") {
        window.base64Str = "";
    }
})(window);