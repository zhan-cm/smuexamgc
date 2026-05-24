/*The MIT License (MIT)

Copyright (c) 2014 https://github.com/kayalshri/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

(function($){
        $.extend({
            jsonExport: function(options) {
                var defaults = {
                		//gridid: '',
						separator: ',',
						ignoreField: [],
						//tableName:'yourTableName',
						type:'csv',
						pdfFontSize:14,
						pdfLeftMargin:20,
						htmlContent:'false',
						escape:'false',
						consoleLog:'false',
						dataGridId:'datalist',
						data:{}
				};
                
				var options = $.extend(defaults, options);
				var data = options.data;
				var header = $('#'+options.dataGridId).datagrid("options").columns[0];
				var outputField=[],outputName=[];
				var exptype = '';

				for(var n=0;n<header.length;n++){//清除
					if(defaults.ignoreField.join(",").indexOf(header[n].field) == -1 && (header[n].checkbox == false || header[n].checkbox == undefined) && (header[n].hidden == false || header[n].hidden == undefined)){
						outputField.push(header[n].field);
						outputName.push(header[n].title);
					}
				}
				
				if(defaults.type == 'csv' || defaults.type == 'txt'){
					var tdData = "";
					$.each(outputName,function(i,col){
						tdData += '"'+ parseString(col) + '"'+ defaults.separator;
					});
					
					tdData = $.trim(tdData).substring(0, tdData.length -1);
					tdData += "\n";
					$.each(data,function(i,itemRow){
						$.each(outputField,function(j,itemHeader){
							tdData += '"'+ parseString(itemRow[itemHeader]) + '"'+ defaults.separator;
						});
						tdData = $.trim(tdData).substring(0, tdData.length -1);
						tdData += "\n";
					});
					
					if ($.browser.msie){
						doFileExport('download.'+defaults.type,tdData);
					}else{
						var base64data = "base64," + Base64.encode(tdData);
						window.location.href = 'data:application/octet-stream;charset=utf-8;filename=exportData.'+defaults.type+';' + base64data;						
					}
				}else if(defaults.type == 'excel' || defaults.type == 'word'  ){
					var excel="<table style='mso-number-format:\\@;'>";
					excel += "<tr>";
					$.each(outputName,function(i,col){
						excel += "<td style='background-color:#D3D3D3;font-weight:bold;'>"+ parseString(col) + "</td>";
					});
					excel += '</tr>';	
					
					$.each(data,function(i,itemRow){
						excel += "<tr >";
						$.each(outputField,function(j,itemHeader){
							excel += "<td>"+ parseString(itemRow[itemHeader]) + "</td>";
						});
						excel += '</tr>';
					});					
					excel += '</table>';
					
					var excelFile = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:"+defaults.type+"' xmlns='http://www.w3.org/TR/REC-html40' >";
					excelFile += "<head>";
					excelFile += "<!--[if gte mso 9]>";
					excelFile += "<xml>";
					excelFile += "<x:ExcelWorkbook>";
					excelFile += "<x:ExcelWorksheets>";
					excelFile += "<x:ExcelWorksheet>";
					excelFile += "<x:Name>";
					excelFile += "{worksheet}";
					excelFile += "</x:Name>";
					excelFile += "<x:WorksheetOptions>";
					excelFile += "<x:DisplayGridlines/>";
					excelFile += "</x:WorksheetOptions>";
					excelFile += "</x:ExcelWorksheet>";
					excelFile += "</x:ExcelWorksheets>";
					excelFile += "</x:ExcelWorkbook>";
					excelFile += "</xml>";
					excelFile += "<![endif]-->";
					excelFile += "<style　type='text/css'>td {mso-number-format:'\@';}</style>";
					excelFile += '<meta http-equiv="content-type" content="text/html; charset=UTF-8" /></head>';
					excelFile += "<body>";
					excelFile += excel;
					excelFile += "</body>";
					excelFile += "</html>";

					//console.log(excelFile);
					var base64data = "base64," + Base64.encode(excelFile);
					exptype = (defaults.type == 'excel') ? 'vnd.ms-excel':'msword';
					if ($.browser.msie){
						exptype = (defaults.type == 'excel') ? 'xls':'doc';
						doFileExport('download.'+exptype,excelFile);
					}else
						window.location.href = 'data:application/'+exptype+';filename=exportData.'+defaults.type+';' + base64data;
				}else if(defaults.type == 'pdf'){//because jsPdf.js unsupport chinese now, waitting.....
					var doc = new jsPDF('p','pt', 'a4', true);
					doc.setFontSize(defaults.pdfFontSize);
					// Header
					var startColPosition=defaults.pdfLeftMargin;
					$.each(outputField,function(k,col){
							var colPosition = startColPosition + (k * 50);									
							doc.text(colPosition,20, col);
					});
					// Row Vs Column
					var startRowPosition = 20; var page =1; var rowPosition=0;
					$.each(data,function(i,itemRow){
						rowCalc = i+1;
						if(i>1) return false;
						if (rowCalc % 26 == 0){
							doc.addPage();
							page++;
							startRowPosition = startRowPosition + 10;
						}
						rowPosition=(startRowPosition + (rowCalc * 10)) - ((page -1) * 280);
						$.each(outputField,function(j,itemHeader){
							var colPosition = startColPosition+ (i * 50);
							doc.text(colPosition,rowPosition, parseString(itemRow[itemHeader]));
						});
					});	
					// Output as Data URI
					doc.output('datauri');
				}
				
				function parseString(data){
					content_data =  data;
					if(defaults.escape == 'true'){
						content_data = escape(data);
					}
					return content_data;
				}
				
				function doFileExport(inName,inStr){
					var xlsWin = null; 
					if (!!document.all("glbHideFrm")) { 
						xlsWin = glbHideFrm; 
					}else{ 
						var width = 1; 
						var height = 1; 
						var openPara = "left=" + (window.screen.width / 2 + width / 2) 
						+ ",top=" + (window.screen.height + height / 2) 
						+ ",scrollbars=no,width=" + width + ",height=" + height; 
						xlsWin = window.open("", "_blank", openPara); 
					}
					xlsWin.document.write(inStr); 
					xlsWin.document.close(); 
					xlsWin.document.execCommand('Saveas', true, inName); 
					xlsWin.close(); 
				}
			}
        });
    })(jQuery);