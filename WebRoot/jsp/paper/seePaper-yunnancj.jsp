<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<html>
<head>
  <title>预览试卷</title>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      background: #f5f5f5;
    }

    .toolbar {
      padding: 15px 15px 0 15px;
    }

    .toolbar button {
      margin-right: 10px;
      margin-bottom: 10px;
    }

    #output {
      margin: 15px;
      background: #fff;
      border: 1px solid #ccc;
      box-shadow: 0 0 10px rgba(0,0,0,0.08);
      min-height: 600px;
      position: relative;
    }

    #loadingBox {
      padding: 30px;
      text-align: center;
      color: #666;
      font-size: 14px;
    }

    #pdfFrame {
      width: 100%;
      height: calc(100vh - 120px);
      min-height: 700px;
      border: none;
      display: block;
      background: #fff;
    }
  </style>
</head>
<body>
<div class="toolbar">
  <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/viewPaper/seePaper_normal?eid=${eid}'">
    切换通用预览试卷
  </button>
  <button id="downloadBtn" type="button" style="display:none;">下载文档(docx格式)</button>
  <button id="downloadPDFBtn" type="button" style="display:none;">下载文档(pdf格式)</button>
  <button id="showAnsBtn" type="button" onclick="changeShowAns()">显示答案</button>
  <button type="button" onclick="checkList()">预览双向细目表</button>
</div>

<div id="output">
  <div id="loadingBox">正在生成并预览 PDF，请稍候...</div>
  <iframe id="pdfFrame" style="display:none;"></iframe>
</div>
</body>

<script type="text/javascript">
  var showAns = "";
  var currentPdfUrl = null;

  $(document).ready(function () {
    fetchPdfPreview();

    $('#downloadBtn').click(function () {
      downloadFile('docx');
    });

    $('#downloadPDFBtn').click(function () {
      downloadFile('pdf');
    });
  });

  function fetchPdfPreview() {
    $('#loadingBox').text('正在生成并预览 PDF，请稍候...').show();
    $('#pdfFrame').hide();

    $.ajax({
      url: "${pageContext.request.contextPath}/viewPaper/getDocxInfo_yunnancj",
      method: "POST",
      data: {
        eid: "${eid}",
        showAns: showAns
      },
      xhrFields: {
        responseType: 'blob'
      },
      success: function (data, textStatus, xhr) {
        if (currentPdfUrl) {
          window.URL.revokeObjectURL(currentPdfUrl);
          currentPdfUrl = null;
        }

        var contentType = xhr.getResponseHeader("Content-Type");
        if (contentType && contentType.indexOf("application/pdf") === -1) {
          $('#loadingBox').hide();
          toastr.error("返回内容不是 PDF，请暂时切换至通用预览。");
          return;
        }

        currentPdfUrl = window.URL.createObjectURL(data);
        $('#pdfFrame').attr('src', currentPdfUrl).show();
        $('#loadingBox').hide();
        $('#downloadBtn').show();
        $('#downloadPDFBtn').show();
      },
      error: function (xhr) {
        $('#pdfFrame').hide();
        $('#loadingBox').text('预览失败');
        toastr.error("错误码：" + xhr.status + "。服务器错误。请暂时切换至通用预览。");
      }
    });
  }

  function changeShowAns() {
    if (showAns === "") {
      showAns = "showAns";
      $('#showAnsBtn').text('隐藏答案');
    } else {
      showAns = "";
      $('#showAnsBtn').text('显示答案');
    }
    fetchPdfPreview();
  }

  function downloadFile(type) {
    var url = "${pageContext.request.contextPath}/viewPaper/exportTmpDocxPDF_yunnancj"
            + "?eid=${eid}&type=" + encodeURIComponent(type);

    var link = document.createElement('a');
    link.href = url;
    link.style.display = 'none';

    if (type === 'docx') {
      link.download = "${ename}.docx";
    } else {
      link.download = "${ename}.pdf";
    }

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  function checkList() {
    openIframeDialog({
      url: "${pageContext.request.contextPath}/paper/checkList?c_id=${cid}&ei_id=${eid}",
      fit: true,
      title: '双向细目表'
    }, 0);
  }

  window.onbeforeunload = function () {
    if (currentPdfUrl) {
      window.URL.revokeObjectURL(currentPdfUrl);
      currentPdfUrl = null;
    }
  };
</script>
</html>