<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../commons/taglibs.jsp"%>
<%@ include file="../commons/styles.txt"%>
<html>
<head>
  <title>预览试卷</title>
  <script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/export/jszip.min.js"></script>
  <script type="text/javascript" src="${pageContext.request.contextPath}/styles/js/export/docx-preview.min.js"></script>
  <style>
    #output {
      border: 1px solid #ccc;
      padding: 20px;
      margin-top: 20px;
      background: white;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .docx-wrapper table.has-score {
      float: right !important;
      margin-left: 20px; /* 根据实际需要调整间距 */
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
<button type="button" onclick="window.location.href='${pageContext.request.contextPath}/viewPaper/seePaper_normal?eid=${eid}'">切换通用预览试卷</button>
<button id="downloadBtn" type="button" style="display:none;margin-top:20px;">下载文档(docx格式)</button>
<button id="downloadPDFBtn" type="button" style="display:none;margin-top:20px;">下载文档(pdf格式)</button>
<button type="button" onclick="changeShowAns()">显示答案</button>
<button type="button" onclick="checkList()">预览双向细目表</button>
<div id="output"></div>
</body>
<script type="text/javascript">
  var showAns = "";
  $(document).ready(function(){
    // 获取并预览DOCX
    fetchDocx(true);

    // 下载按钮点击事件
    $('#downloadBtn').click(function() {
      fetchDocx(false);
    });

    $('#downloadPDFBtn').click(function() {
      downloadPDF();
    });
  });

  function fetchDocx(preview) {
    let isPreview = "";
    if(preview){
      isPreview = "yes";
    }
    $.ajax({
      url: "${pageContext.request.contextPath}/viewPaper/getDocxInfo",
      method: "POST",
      data: { eid: "${eid}",showAns:showAns,isPreview:isPreview},
      xhrFields: {
        responseType: 'blob' // 处理二进制数据
      },
      success: function(data) {
        if(preview) {
          // 预览文档
          const reader = new FileReader();
          reader.onload = function(e) {
            docx.renderAsync(e.target.result, document.getElementById("output"))
                    .then(() => {
                      const allCells = document.querySelectorAll('.docx-wrapper td');
                      allCells.forEach(cell => {
                        if (cell.textContent.includes('得分')) {
                          const table = cell.closest('table');
                          if (table) {
                            table.classList.add('has-score');
                          }
                        }
                      });
                      $('#downloadBtn').show();
                      $('#downloadPDFBtn').show();
                    });
          };
          reader.readAsArrayBuffer(data);
        } else {
          // 下载文档
          const url = window.URL.createObjectURL(data);
          const a = document.createElement('a');
          a.href = url;
          a.download = '${ename}.docx';
          document.body.appendChild(a);
          a.click();
          window.URL.revokeObjectURL(url);
          document.body.removeChild(a);
        }
      },
      error: function(xhr) {
        toastr.error("错误码："+xhr.status+ '。服务器错误。请暂时切换至通用预览');
      }
    });
  }

  function changeShowAns(){
    if(showAns===""){
      showAns = "showAns";
    }else{
      showAns = "";
    }
    fetchDocx(true);
  }

  function switchViewPaperMode(){
    window.location.href="${pageContext.request.contextPath}/viewPaper/seePaper_normal?eid=" + "${eid}";
  }

  function downloadPDF(){
    let xhr = new XMLHttpRequest();
    xhr.open("POST", "${pageContext.request.contextPath}/viewPaper/exportTmpDocxPDF?eid=" + "${eid}", true);
    xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
    xhr.responseType = "blob"; // 将响应类型设置为 blob，以处理文件
    xhr.onload = function () {
      if (xhr.status === 200) {
        let blob = xhr.response;
        let link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = "${ename}.pdf";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      } else {
        toastr.error("下载失败");
      }
    };
    xhr.send("");
  }

  function checkList(){
    openIframeDialog({
      url:"${pageContext.request.contextPath}/paper/checkList?c_id=" + "${cid}" + "&ei_id=" + "${eid}",
      fit:true,
      title:'双向细目表'
    },0);
  }
</script>
</html>