if (typeof jQuery !== "undefined" && typeof saveAs !== "undefined") {
    (function ($) {
        $.fn.wordExport = function (fileName, styles) {
            fileName = typeof fileName !== "undefined" ? fileName : "jQuery-Word-Export";
            styles = typeof styles !== "undefined" ? styles : "";

            // 用 window.location，避免被局部变量意外遮蔽
            var pageHref = (window.location && window.location.href) ? window.location.href : "";

            var static = {
                mhtml: {
                    top:
                        "Mime-Version: 1.0\n" +
                        "Content-Base: " + pageHref + "\n" +
                        "Content-Type: Multipart/related; boundary=\"NEXT.ITEM-BOUNDARY\";type=\"text/html\"\n\n" +
                        "--NEXT.ITEM-BOUNDARY\n" +
                        "Content-Type: text/html; charset=\"utf-8\"\n" +
                        "Content-Location: " + pageHref + "\n\n" +
                        "<!DOCTYPE html>\n<html>\n_html_</html>",
                    head:
                        "<head>\n" +
                        "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\n" +
                        "<style>\n_styles_\n</style>\n" +
                        "</head>\n",
                    body: "<body>_body_</body>",
                },
            };

            var options = {
                maxWidth: 624,
            };

            // Clone selected element before manipulating it
            var markup = $(this).clone();

            // Remove hidden elements from the output
            markup.each(function () {
                var self = $(this);
                if (self.is(":hidden")) self.remove();
            });

            // ===== Embed all images using Data URLs (按“固定高度 + 原图比例”导出) =====
            var images = [];
            var srcImgs = $(this).find("img").toArray();   // 原页面 img（已加载/比例可靠）
            var outImgs = markup.find("img").toArray();    // clone 后要导出的 img

            function pxNum(v) {
                var n = parseFloat(v);
                return Number.isFinite(n) ? n : 0;
            }

            for (var i = 0; i < outImgs.length; i++) {
                var srcImg = srcImgs[i];
                var outImg = outImgs[i];
                if (!srcImg || !outImg) continue;

                // 原图真实像素（保证比例）
                var nw = srcImg.naturalWidth || srcImg.width;
                var nh = srcImg.naturalHeight || srcImg.height;
                if (!nw || !nh) continue;

                var ratio = nw / nh;

                // 1) 取你在 HTML 里写的“固定高度”（height属性优先，其次 style height；再兜底用当前高度）
                var fixedH =
                    pxNum(outImg.getAttribute("height")) ||
                    pxNum($(outImg).css("height")) ||
                    pxNum(srcImg.getAttribute("height")) ||
                    pxNum($(srcImg).css("height")) ||
                    srcImg.height ||
                    nh;

                var h = fixedH > 0 ? fixedH : nh;

                // 2) 可选：word-file-img 最大高度 500，超过按比例缩
                if (srcImg.classList.contains("word-file-img") && h > 500) h = 500;

                // 3) 用固定高度 + 原图比例推出宽度（防止变扁/变形）
                var w = h * ratio;

                // 4) 再做 maxWidth 限制（避免撑破 Word 页面）
                var maxW = options.maxWidth || 624;
                if (w > maxW) {
                    var scale = maxW / w;
                    w = maxW;
                    h = h * scale;
                }

                w = Math.max(1, Math.round(w));
                h = Math.max(1, Math.round(h));

                // 5) 画到 canvas（用原图，不用 clone，避免未加载导致 0 尺寸/比例错）
                var canvas = document.createElement("canvas");
                canvas.width = w;
                canvas.height = h;
                var context = canvas.getContext("2d");
                context.drawImage(srcImg, 0, 0, w, h);

                // 跨域图片可能会导致这里抛错；不中断整个导出
                var uri;
                try {
                    uri = canvas.toDataURL("image/png");
                } catch (e) {
                    // 回退：不转 base64，保留原 src 让 Word 自己去取（如果能取到的话）
                    // 仍然强制尺寸，避免变形
                    outImg.setAttribute("width", w);
                    outImg.setAttribute("height", h);
                    outImg.style.width = w + "px";
                    outImg.style.height = h + "px";
                    continue;
                }

                // 6) 关键：把 width/height 写进导出 DOM（Word 更吃属性，不写容易“宽很大高固定”）
                outImg.setAttribute("width", w);
                outImg.setAttribute("height", h);
                outImg.style.width = w + "px";
                outImg.style.height = h + "px";

                // 7) Content-Location 用干净路径；注意不要叫 location（会遮蔽 window.location）
                var imgLocation = "word/media/image" + i + ".png";
                $(outImg).attr("src", imgLocation);

                images[i] = {
                    type: "image/png",
                    encoding: "base64",
                    location: imgLocation,
                    data: uri.substring(uri.indexOf(",") + 1),
                };
            }

            // Prepare bottom of mhtml file with image data
            var mhtmlBottom = "\n";
            for (var j = 0; j < images.length; j++) {
                if (!images[j]) continue;
                mhtmlBottom += "--NEXT.ITEM-BOUNDARY\n";
                mhtmlBottom += "Content-Location: " + images[j].location + "\n";
                mhtmlBottom += "Content-Type: " + images[j].type + "\n";
                mhtmlBottom += "Content-Transfer-Encoding: " + images[j].encoding + "\n\n";
                mhtmlBottom += images[j].data + "\n\n";
            }
            mhtmlBottom += "--NEXT.ITEM-BOUNDARY--";

            // Aggregate parts of the file together
            var fileContent =
                static.mhtml.top.replace(
                    "_html_",
                    static.mhtml.head.replace("_styles_", styles) +
                    static.mhtml.body.replace("_body_", markup.html())
                ) + mhtmlBottom;

            // Create a Blob with the file contents
            var blob = new Blob([fileContent], {
                type: "application/msword;charset=utf-8",
            });

            saveAs(blob, fileName + ".doc");
        };
    })(jQuery);
} else {
    if (typeof jQuery === "undefined") {
        console.error("jQuery Word Export: missing dependency (jQuery)");
    }
    if (typeof saveAs === "undefined") {
        console.error("jQuery Word Export: missing dependency (FileSaver.js)");
    }
}