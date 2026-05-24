<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<?mso-application progid="Word.Document"?>
<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
	<pkg:part pkg:name="/_rels/.rels" pkg:contentType="application/vnd.openxmlformats-package.relationships+xml" pkg:padding="512">
		<pkg:xmlData>
			<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
				<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
				<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
				<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
				<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties" Target="docProps/custom.xml"/>
			</Relationships>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/document.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml">
		<pkg:xmlData>
			<w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du wp14">
				<w:body>
					<#macro textWithBr s>
						<#if s?? && s?has_content>
							<#assign clean = s?string?replace("(\\n)+", "\n", "r")>
							<#assign lines = clean?split("\n")>
							<#list lines as line>
								<#if line?has_content>
									<w:t xml:space="preserve">${line?xml}</w:t>
									<#if line_has_next><w:br/></#if>
								</#if>
							</#list>
						</#if>
					</#macro>
					<w:p w14:paraId="1207A19C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="49CF87EE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>密级:</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>保密</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="399EA062" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="157BB129" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="45483867" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="7EA89E55" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="25CF17B2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="14CCC209" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.organizationName}</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="0E3C99DB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.ENAME?xml}</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.EXAMTYPE}</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="44"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>试卷分析报告</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="45E71E15" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.examYear}</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>(</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.TERMNAME}</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>)</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4E79D5F5" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="3311F90A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="538BB0B9" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="31079CF9" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="0C1DC84A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="6D996B76" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="31BC90FE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2A133552" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="3DF1447C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="6BDD1DA3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="1CC6F931" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="185293C3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="32FB53D7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="6ECC3B31" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2C07A9B5" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="3D06559A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="370ECE69" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="4E116756" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="0CB63C3E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="28"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="4631BC83" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:wordWrap w:val="0"/>
							<w:ind w:right="105"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>报告单位：</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.organizationName}</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="7D19CAF2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:ind w:right="105"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>报告日期：</w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>${examInfo.createDate}</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="618BB28E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:ind w:right="210"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="黑体" w:eastAsia="黑体" w:hAnsi="黑体" w:cs="黑体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="474DC92D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="等线" w:hAnsi="等线" w:cs="等线" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:sectPr w:rsidR="00BD1ACA">
								<w:footerReference w:type="default" r:id="rId6"/>
								<w:pgSz w:w="12240" w:h="15840"/>
								<w:pgMar w:top="907" w:right="851" w:bottom="907" w:left="851" w:header="851" w:footer="992" w:gutter="0"/>
								<w:cols w:space="720"/>
								<w:titlePg/>
								<w:docGrid w:linePitch="360"/>
							</w:sectPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="0E2BAA27" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="1"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="141"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:kern w:val="36"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:lastRenderedPageBreak/>
							<w:t>1.考试概况</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="3C2B55BD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>1.1.考试信息</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="545D0E7F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:spacing w:line="420" w:lineRule="auto"/>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblBorders>
								<w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>
							</w:tblBorders>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="1650"/>
							<w:gridCol w:w="2972"/>
							<w:gridCol w:w="1877"/>
							<w:gridCol w:w="3077"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="14C23CBB" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="6584F6A5" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷编号：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="38F7009E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.ID}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="76DF7DB8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷满分：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="76E6F141" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.SCORE}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="67521D1A" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="7AA09DFC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试课程：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="7ED9B465" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.CNAME?xml}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="00EA7D9B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>参与分析试卷：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="3EE160FA" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.ENAME?xml}试卷</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="01EB9E57" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="54336249" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试学年：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="524E5D51" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.examYear}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="235EBB41" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试学期：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="04426364" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.TERMNAME}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="2A561DB9" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="47262D1F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试阶段：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="1E9DDCFA" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.EXAMTYPE}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="29331DB7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考核方式：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="2907C67B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.testWay}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="581534F9" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="44BF0F29" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试日期：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="70B56046" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.BEGINDATE}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="793B4919" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试时长：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="72704508" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.examTime}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="54089F58" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="409E120B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>考试方式：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="0B2704D2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>机考</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="72F09113" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>应考人数：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="11FA8D3A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.SHOULD_CNT}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="67C6E571" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="283"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1650" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="69D5D26D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>实考人数：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="2972" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="4AF6892C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.ACTUAL_CNT}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1877" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="6EF93433" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>缺考人数：</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3077" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="695472D9" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="both"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${examInfo.NOT_TAKEN_CNT}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
					</w:tbl>
					<w:p w14:paraId="1101EDF0" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:spacing w:line="420" w:lineRule="auto"/>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="1211D4D3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
							<w:t>1.2 成绩分析统计</w:t>
						</w:r>
					</w:p>
					<w:tbl>
						<w:tblPr>
							<w:tblpPr w:leftFromText="180" w:rightFromText="180" w:vertAnchor="text" w:horzAnchor="page" w:tblpX="595" w:tblpY="33"/>
							<w:tblOverlap w:val="never"/>
							<w:tblW w:w="11512" w:type="dxa"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="1207"/>
							<w:gridCol w:w="895"/>
							<w:gridCol w:w="550"/>
							<w:gridCol w:w="619"/>
							<w:gridCol w:w="620"/>
							<w:gridCol w:w="603"/>
							<w:gridCol w:w="603"/>
							<w:gridCol w:w="717"/>
							<w:gridCol w:w="670"/>
							<w:gridCol w:w="670"/>
							<w:gridCol w:w="836"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="2792B051" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="400"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1207" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="160E6851" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>专业</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="895" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="41C49C5B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>应答时长</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="619" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="0E84CAF7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>考试人数</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="603" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="04CC5FBF" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>最高分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="603" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2F81D20B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>最低分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="717" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2263B78E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>平均分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="710" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="668587F8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>及格率</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="710" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2BBE1694" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>不及格率</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="710" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3674EB4E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>优秀率</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="710" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3E73EA60" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>标准差</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="670" w:type="dxa"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:noWrap/>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="7FF332F2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:textAlignment w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
											<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
										</w:rPr>
										<w:t>中位数</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#if (analysisParam.质量指标??) && (analysisParam.质量指标?size &gt; 0)>
							<#list analysisParam.质量指标 as 质量指标>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="4602DB1C" w14:textId="77777777">
									<w:trPr>
										<w:trHeight w:val="400"/>
									</w:trPr>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="448" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4182D73C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.专业}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="448" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="53880165" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<#if 质量指标.应答时长??>
													<w:t>${质量指标.应答时长}</w:t>
												<#else>
													<w:t>无人交卷</w:t>
												</#if>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="619" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="5C80E250" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.考试人数}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="603" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="0C96B678" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.最高分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="603" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="0CE2C67B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.最低分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="717" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="72E50897" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.平均分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="895" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="578773A1" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t><#if 质量指标.及格率??>${质量指标.及格率?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="1207" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="026BBB30" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t><#if 质量指标.及格率??>${(1 - 质量指标.及格率)?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="836" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="79F8CFCA" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t><#if 质量指标.优秀率??>${质量指标.优秀率?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="717" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="594870CB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.标准差}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="670" w:type="dxa"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4B1C089E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="Arial" w:eastAsia="宋体" w:hAnsi="Arial" w:cs="Arial" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${质量指标.中位数}</w:t>
											</w:r>
										</w:p>
									</w:tc>
								</w:tr>
							</#list>
						</#if>
					</w:tbl>
					<w:p w14:paraId="511E64D0" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
					</w:p>

					<w:tbl>
						<w:p w14:paraId="511E64D0" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
							<w:pPr>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:sz w:val="21"/>
									<w:szCs w:val="21"/>
								</w:rPr>
							</w:pPr>
						</w:p>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblBorders>
								<w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>
							</w:tblBorders>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="3009"/>
							<w:gridCol w:w="1779"/>
							<w:gridCol w:w="1779"/>
							<w:gridCol w:w="3009"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="12B1194D" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="284"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:gridSpan w:val="4"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="4FB5F627" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>各等级人数占比情况</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="27EDA742" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="284"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3009" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="2F245E5D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>成绩等级</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1779" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="2144E2E3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>分数段</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1779" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="6AC0F4C8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>人数</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="3009" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="077B8017" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#list analysisParam.各等级人数占比情况 as 各等级人数>
							<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="0583DE6C" w14:textId="77777777">
								<w:trPr>
									<w:trHeight w:val="284"/>
								</w:trPr>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="3009" w:type="dxa"/>
									</w:tcPr>
									<w:p w14:paraId="63364B97" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>${各等级人数.成绩等级}</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="1779" w:type="dxa"/>
									</w:tcPr>
									<w:p w14:paraId="34FEDE09" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>${各等级人数.分数段}</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="1779" w:type="dxa"/>
									</w:tcPr>
									<w:p w14:paraId="3098D49D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>${各等级人数.人数}</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="3009" w:type="dxa"/>
									</w:tcPr>
									<w:p w14:paraId="7221609A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>${各等级人数.百分比}</w:t>
										</w:r>
									</w:p>
								</w:tc>
							</w:tr>
						</#list>
					</w:tbl>
					<w:p w14:paraId="521E64D2" w14:textId="77777778" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="20AAD0DA" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
							<w:lastRenderedPageBreak/>
							<w:t>1.3.成绩分布统计</w:t>
						</w:r>
					</w:p>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="698"/>
							<w:gridCol w:w="995"/>
							<w:gridCol w:w="993"/>
							<w:gridCol w:w="957"/>
							<w:gridCol w:w="886"/>
							<w:gridCol w:w="852"/>
							<w:gridCol w:w="848"/>
							<w:gridCol w:w="852"/>
							<w:gridCol w:w="864"/>
							<w:gridCol w:w="848"/>
							<w:gridCol w:w="717"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="1658302D" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="367" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2158E5BA" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>专业</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="523" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="6A71DE1E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>90以上</w:t>
									</w:r>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t xml:space="preserve"/>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="522" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2D632507" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>80-89</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="503" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="4F90483F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>70-79</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="466" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="6D307665" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>60-69</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="448" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="773AF4E7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>50-59</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="446" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2BD237A2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>40-49</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="448" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3AAD031D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>30-39</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="454" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="1A5D5165" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>20-29</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="446" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="09084BB6" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>10-19</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="377" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="1E4D4B8D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="20"/>
											<w:szCs w:val="20"/>
										</w:rPr>
										<w:t>0-9</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#if (analysisParam.分数分布??) && (analysisParam.分数分布?size &gt; 0)>
							<#list analysisParam.分数分布 as 分数分布>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="123BB402" w14:textId="77777777">
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="367" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="503CDA8E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="16"/>
													<w:szCs w:val="16"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="16"/>
													<w:szCs w:val="16"/>
												</w:rPr>
												<w:t>${分数分布.SPNAME?xml}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="523" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="499959DE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER9_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="522" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1B198326" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER8_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="503" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="3CC9190E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER7_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="466" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="09D2F62C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER6_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="448" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="7D3A9F6B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER5_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="446" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4D02B6DE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER4_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="448" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="7C2E4B2C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER3_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="454" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1706BFBD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER2_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="446" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="78F666BC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER1_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="377" w:type="pct"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1FD03987" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
												<w:t>${分数分布.PER0_PER}</w:t>
											</w:r>
										</w:p>
									</w:tc>
								</w:tr>
							</#list>
						</#if>
					</w:tbl>
					<w:p w14:paraId="511E64D0" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="24DB8491" w14:textId="77777777" w:rsidR="00ED2243" w:rsidRDefault="002D351A">
						<w:pPr>
							<w:divId w:val="1262178115"/>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:noProof/>
							</w:rPr>
						</w:pPr>
						<w:r w:rsidRPr="009D07C6">
							<w:rPr>
								<w:noProof/>
							</w:rPr>
							<w:pict w14:anchorId="7B4C6EE7">
								<v:shapetype id="_x0000_t77" coordsize="21600,21600" o:spt="77" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
									<v:stroke joinstyle="miter"/>
									<v:formulas>
										<v:f eqn="if lineDrawn pixelLineWidth 0"/>
										<v:f eqn="sum @0 1 0"/>
										<v:f eqn="sum 0 0 @1"/>
										<v:f eqn="prod @2 1 2"/>
										<v:f eqn="prod @3 21600 pixelWidth"/>
										<v:f eqn="prod @3 21600 pixelHeight"/>
										<v:f eqn="sum @0 0 1"/>
										<v:f eqn="prod @6 1 2"/>
										<v:f eqn="prod @7 21600 pixelWidth"/>
										<v:f eqn="sum @8 21600 0"/>
										<v:f eqn="prod @7 21600 pixelHeight"/>
										<v:f eqn="sum @10 21600 0"/>
									</v:formulas>
									<v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
									<o:lock v:ext="edit" aspectratio="t"/>
								</v:shapetype>
								<v:shape id="图片 3" o:spid="_x0000_i1027" type="#_x0000_t77" style="width:530pt;height:270pt;visibility:visible">
									<v:imagedata r:id="rIdImg3" o:title=""/>
								</v:shape>
							</w:pict>
						</w:r>
					</w:p>

					<w:p w14:paraId="2A8A93E8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="6D30CCA3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="14389F44" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="5B42A11C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="1"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="141"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:kern w:val="36"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>2.试卷分析</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="262B8BDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>2.1 试卷概况</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="6FA144D8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="3"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="210"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>2.1.1 主题词分类得分分析</w:t>
						</w:r>
					</w:p>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="10160"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="26DE2871" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="18DB0F14" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
										<w:t>主题词分类得分分析</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
					</w:tbl>
					 <w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="1265"/>
							<w:gridCol w:w="625"/>
							<w:gridCol w:w="1265"/>
							<w:gridCol w:w="625"/>
							<w:gridCol w:w="1200"/>
							<w:gridCol w:w="1200"/>
							<w:gridCol w:w="830"/>
							<w:gridCol w:w="690"/>
							<w:gridCol w:w="820"/>
							<w:gridCol w:w="820"/>
							<w:gridCol w:w="820"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="34BEAA0D" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3CC6591E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>主题词分类</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2055AF9D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="123EDA1A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="1041D68A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分值</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="48D01D5C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分数百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="73033938" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>专业</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="5DB721A3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>平均分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="559253A3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>难度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="699F83DB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>区分度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="27925B20" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>标准差</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="27925B20" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>得分率</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#if (analysisParam.主题词分类得分分析??) && (analysisParam.主题词分类得分分析?size &gt; 0)>
							<#list analysisParam.主题词分类得分分析 as 主题词分析>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="539B4652" w14:textId="77777777">
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="118E7CE2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${主题词分析.一级主题词}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="22599A82" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<#if 主题词分析.题量??>
													<w:t>${主题词分析.题量}</w:t>
												<#else>
													<w:t>0</w:t>
												</#if>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="62892DBD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 主题词分析.题量百分比??>${主题词分析.题量百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="43AC948F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${主题词分析.总分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4ECC172D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 主题词分析.分数百分比??>${主题词分析.分数百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<#if (主题词分析.明细??) && (主题词分析.明细?size &gt; 0)>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="20"/>
														<w:szCs w:val="20"/>
													</w:rPr>
													<w:t>${主题词分析.明细[0].专业}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${主题词分析.明细[0].平均分}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${主题词分析.明细[0].难度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${主题词分析.明细[0].区分度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${主题词分析.明细[0].标准差}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<#if 主题词分析.明细[0].平均分?? && 主题词分析.总分?? && (主题词分析.明细[0].总分?number != 0)>
														<w:t>${(主题词分析.明细[0].平均分?number / 主题词分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													<#else>
														<w:t>${(主题词分析.明细[0].平均分?number / 主题词分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													</#if>
												</w:r>
											</w:p>
										</w:tc>
									</#if>
								</w:tr>
								<#if (主题词分析.明细?size &gt; 1)>
                                	<#list 主题词分析.明细[1..] as 明细>
										<w:tr>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="20"/>
															<w:szCs w:val="20"/>
														</w:rPr>
														<w:t>${明细.专业}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.平均分}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.难度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.区分度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.标准差}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<#if 明细.平均分?? && 明细.总分?? && (明细.总分?number != 0)>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														<#else>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														</#if>
													</w:r>
												</w:p>
											</w:tc>
										</w:tr>
									</#list>
								</#if>
							</#list>
						</#if>
					</w:tbl>
					<w:p w14:paraId="32058F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="24DB8491" w14:textId="77777777" w:rsidR="00ED2243" w:rsidRDefault="002D351A">
						<w:pPr>
							<w:divId w:val="1262178115"/>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:noProof/>
							</w:rPr>
						</w:pPr>
						<w:r w:rsidRPr="009D07C6">
							<w:rPr>
								<w:noProof/>
							</w:rPr>
							<w:pict w14:anchorId="7B4C6EE7">
								<v:shapetype id="_x0000_t78" coordsize="21600,21600" o:spt="78" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
									<v:stroke joinstyle="miter"/>
									<v:formulas>
										<v:f eqn="if lineDrawn pixelLineWidth 0"/>
										<v:f eqn="sum @0 1 0"/>
										<v:f eqn="sum 0 0 @1"/>
										<v:f eqn="prod @2 1 2"/>
										<v:f eqn="prod @3 21600 pixelWidth"/>
										<v:f eqn="prod @3 21600 pixelHeight"/>
										<v:f eqn="sum @0 0 1"/>
										<v:f eqn="prod @6 1 2"/>
										<v:f eqn="prod @7 21600 pixelWidth"/>
										<v:f eqn="sum @8 21600 0"/>
										<v:f eqn="prod @7 21600 pixelHeight"/>
										<v:f eqn="sum @10 21600 0"/>
									</v:formulas>
									<v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
									<o:lock v:ext="edit" aspectratio="t"/>
								</v:shapetype>
								<v:shape id="图片 4" o:spid="_x0000_i1028" type="#_x0000_t78" style="width:500pt;height:260pt;visibility:visible">
									<v:imagedata r:id="rIdImg4" o:title=""/>
								</v:shape>
							</w:pict>
						</w:r>
					</w:p>

					<w:p w14:paraId="33C2370A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:vanish/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="5BE9F418" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>


					<w:p w14:paraId="545B0A89" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="3"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="210"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
							<w:t>2.1.2 认知分类得分分析</w:t>
						</w:r>
					</w:p>

					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="9510"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="3CB0075C" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="533F4111" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
										<w:t>认知分类得分分析</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
					</w:tbl>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="1177"/>
							<w:gridCol w:w="689"/>
							<w:gridCol w:w="968"/>
							<w:gridCol w:w="550"/>
							<w:gridCol w:w="968"/>
							<w:gridCol w:w="1462"/>
							<w:gridCol w:w="746"/>
							<w:gridCol w:w="698"/>
							<w:gridCol w:w="696"/>
							<w:gridCol w:w="656"/>
							<w:gridCol w:w="656"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="32D3A24F" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="619" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3E30DCAC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>认知分类</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="362" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="738E9670" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="509" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="402E2C5E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="289" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="4668D85B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分值</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="509" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3F40FC77" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分数百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1242" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3B22402A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>专业</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="392" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2C046A6B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>平均分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="367" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="40735892" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>难度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="366" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="2419C0BE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>区分度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="345" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="0B03FB7D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>标准差</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="345" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="0B03FB7D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>得分率</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#if (analysisParam.认知分类得分分析??) && (analysisParam.认知分类得分分析?size &gt; 0)>
							<#list analysisParam.认知分类得分分析 as 认知分析>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="539B4652" w14:textId="77777777">
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="118E7CE2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${认知分析.认知类型}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="22599A82" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${认知分析.题量}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="62892DBD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 认知分析.题量百分比??>${认知分析.题量百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="43AC948F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${认知分析.总分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4ECC172D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 认知分析.分数百分比??>${认知分析.分数百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<#if (认知分析.明细??) && (认知分析.明细?size &gt; 0)>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="20"/>
														<w:szCs w:val="20"/>
													</w:rPr>
													<w:t>${认知分析.明细[0].专业}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${认知分析.明细[0].平均分}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${认知分析.明细[0].难度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${认知分析.明细[0].区分度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${认知分析.明细[0].标准差}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<#if 认知分析.明细[0].平均分?? && 认知分析.总分?? && (认知分析.明细[0].总分?number != 0)>
														<w:t>${(认知分析.明细[0].平均分?number / 认知分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													<#else>
														<w:t>${(认知分析.明细[0].平均分?number / 认知分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													</#if>
												</w:r>
											</w:p>
										</w:tc>
									</#if>
								</w:tr>
								<#if (认知分析.明细?size &gt; 1)>
									<#list 认知分析.明细[1..] as 明细>
										<w:tr>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="20"/>
															<w:szCs w:val="20"/>
														</w:rPr>
														<w:t>${明细.专业}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.平均分}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.难度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.区分度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.标准差}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<#if 明细.平均分?? && 明细.总分?? && (明细.总分?number != 0)>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														<#else>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														</#if>
													</w:r>
												</w:p>
											</w:tc>
										</w:tr>
									</#list>
								</#if>
							</#list>
						</#if>
					</w:tbl>
					<w:p w14:paraId="32058F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="24DB8491" w14:textId="77777777" w:rsidR="00ED2243" w:rsidRDefault="002D351A">
						<w:pPr>
							<w:divId w:val="1262178115"/>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:noProof/>
							</w:rPr>
						</w:pPr>
						<w:r w:rsidRPr="009D07C6">
							<w:rPr>
								<w:noProof/>
							</w:rPr>
							<w:pict w14:anchorId="7B4C6EE7">
								<v:shapetype id="_x0000_t79" coordsize="21600,21600" o:spt="79" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
									<v:stroke joinstyle="miter"/>
									<v:formulas>
										<v:f eqn="if lineDrawn pixelLineWidth 0"/>
										<v:f eqn="sum @0 1 0"/>
										<v:f eqn="sum 0 0 @1"/>
										<v:f eqn="prod @2 1 2"/>
										<v:f eqn="prod @3 21600 pixelWidth"/>
										<v:f eqn="prod @3 21600 pixelHeight"/>
										<v:f eqn="sum @0 0 1"/>
										<v:f eqn="prod @6 1 2"/>
										<v:f eqn="prod @7 21600 pixelWidth"/>
										<v:f eqn="sum @8 21600 0"/>
										<v:f eqn="prod @7 21600 pixelHeight"/>
										<v:f eqn="sum @10 21600 0"/>
									</v:formulas>
									<v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
									<o:lock v:ext="edit" aspectratio="t"/>
								</v:shapetype>
								<v:shape id="图片 5" o:spid="_x0000_i1029" type="#_x0000_t79" style="width:500pt;height:260pt;visibility:visible">
									<v:imagedata r:id="rIdImg5" o:title=""/>
								</v:shape>
							</w:pict>
						</w:r>
					</w:p>

					<w:p w14:paraId="43B00867" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:pStyle w:val="3"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="210"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="60C1A56F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="4A6D7F02" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="3"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="210"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
							<w:t>2.1.3 题型分类得分分析</w:t>
						</w:r>
					</w:p>

					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="9510"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="234F6278" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="0" w:type="auto"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="6D990B32" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="30"/>
											<w:szCs w:val="30"/>
										</w:rPr>
										<w:t>题型分类得分分析</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
					</w:tbl>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="1188"/>
							<w:gridCol w:w="695"/>
							<w:gridCol w:w="979"/>
							<w:gridCol w:w="558"/>
							<w:gridCol w:w="978"/>
							<w:gridCol w:w="1550"/>
							<w:gridCol w:w="694"/>
							<w:gridCol w:w="696"/>
							<w:gridCol w:w="694"/>
							<w:gridCol w:w="656"/>
							<w:gridCol w:w="694"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="447CC7A5" w14:textId="77777777">
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="623" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="792FE2ED" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题型分类</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="365" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3D21A5A5" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="513" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="4EDC750B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>题量百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="293" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="7A83197C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分值</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="513" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="127598DE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>分数百分比</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1246" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="44764900" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>专业</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="365" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="08DB625D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>平均分</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="366" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="635949B2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>难度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="365" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="736D2F8A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>区分度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="345" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="3EC5C754" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>标准差</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="365" w:type="pct"/>
									<w:tcBorders>
										<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
										<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
									</w:tcBorders>
									<w:tcMar>
										<w:top w:w="75" w:type="dxa"/>
										<w:left w:w="75" w:type="dxa"/>
										<w:bottom w:w="75" w:type="dxa"/>
										<w:right w:w="75" w:type="dxa"/>
									</w:tcMar>
									<w:vAlign w:val="center"/>
								</w:tcPr>
								<w:p w14:paraId="736D2F8A" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="center"/>
										<w:rPr>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
									</w:pPr>
									<w:r w:rsidRPr="00871F38">
										<w:rPr>
											<w:rFonts w:hint="eastAsia"/>
											<w:b/>
											<w:bCs/>
											<w:sz w:val="16"/>
											<w:szCs w:val="16"/>
										</w:rPr>
										<w:t>得分率</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<#if (analysisParam.题型分类得分分析??) && (analysisParam.题型分类得分分析?size &gt; 0)>
							<#list analysisParam.题型分类得分分析 as 题型分析>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="539B4652" w14:textId="77777777">
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="118E7CE2" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${题型分析.题型}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="22599A82" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${题型分析.题量}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="62892DBD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 题型分析.题量百分比??>${题型分析.题量百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="43AC948F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t>${题型分析.总分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:vMerge w:val="restart"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:tcMar>
												<w:top w:w="75" w:type="dxa"/>
												<w:left w:w="75" w:type="dxa"/>
												<w:bottom w:w="75" w:type="dxa"/>
												<w:right w:w="75" w:type="dxa"/>
											</w:tcMar>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="4ECC172D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:rPr>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
											</w:pPr>
											<w:r w:rsidRPr="00871F38">
												<w:rPr>
													<w:rFonts w:hint="eastAsia"/>
													<w:sz w:val="21"/>
													<w:szCs w:val="21"/>
												</w:rPr>
												<w:t><#if 题型分析.分数百分比??>${题型分析.分数百分比?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<#if (题型分析.明细??) && (题型分析.明细?size &gt; 0)>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="20"/>
														<w:szCs w:val="20"/>
													</w:rPr>
													<w:t>${题型分析.明细[0].专业}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${题型分析.明细[0].平均分}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${题型分析.明细[0].难度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${题型分析.明细[0].区分度}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<w:t>${题型分析.明细[0].标准差}</w:t>
												</w:r>
											</w:p>
										</w:tc>
										<w:tc>
											<w:tcPr>
												<w:tcW w:w="0" w:type="auto"/>
												<w:tcBorders>
													<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
												</w:tcBorders>
												<w:tcMar>
													<w:top w:w="75" w:type="dxa"/>
													<w:left w:w="75" w:type="dxa"/>
													<w:bottom w:w="75" w:type="dxa"/>
													<w:right w:w="75" w:type="dxa"/>
												</w:tcMar>
												<w:vAlign w:val="center"/>
											</w:tcPr>
											<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
												<w:pPr>
													<w:jc w:val="center"/>
													<w:rPr>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
												</w:pPr>
												<w:r w:rsidRPr="00871F38">
													<w:rPr>
														<w:rFonts w:hint="eastAsia"/>
														<w:sz w:val="21"/>
														<w:szCs w:val="21"/>
													</w:rPr>
													<#if 题型分析.明细[0].平均分?? && 题型分析.总分?? && (题型分析.明细[0].总分?number != 0)>
														<w:t>${(题型分析.明细[0].平均分?number / 题型分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													<#else>
														<w:t>${(题型分析.明细[0].平均分?number / 题型分析.明细[0].总分?number)?string["0.##%"]}</w:t>
													</#if>
												</w:r>
											</w:p>
										</w:tc>
									</#if>
								</w:tr>
								<#if (题型分析.明细?size &gt; 1)>
									<#list 题型分析.明细[1..] as 明细>
										<w:tr>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:vMerge/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:vAlign w:val="center"/>
													<w:hideMark/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="06A20267" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="20"/>
															<w:szCs w:val="20"/>
														</w:rPr>
														<w:t>${明细.专业}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="1042CFDC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.平均分}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="6E2CE55D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.难度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="4B6814B3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.区分度}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<w:t>${明细.标准差}</w:t>
													</w:r>
												</w:p>
											</w:tc>
											<w:tc>
												<w:tcPr>
													<w:tcW w:w="0" w:type="auto"/>
													<w:tcBorders>
														<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>
														<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>
													</w:tcBorders>
													<w:tcMar>
														<w:top w:w="75" w:type="dxa"/>
														<w:left w:w="75" w:type="dxa"/>
														<w:bottom w:w="75" w:type="dxa"/>
														<w:right w:w="75" w:type="dxa"/>
													</w:tcMar>
													<w:vAlign w:val="center"/>
												</w:tcPr>
												<w:p w14:paraId="72EEF0DD" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w:rsidRDefault="00000000">
													<w:pPr>
														<w:jc w:val="center"/>
														<w:rPr>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
													</w:pPr>
													<w:r w:rsidRPr="00871F38">
														<w:rPr>
															<w:rFonts w:hint="eastAsia"/>
															<w:sz w:val="21"/>
															<w:szCs w:val="21"/>
														</w:rPr>
														<#if 明细.平均分?? && 明细.总分?? && (明细.总分?number != 0)>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														<#else>
															<w:t>${(明细.平均分?number / 明细.总分?number)?string["0.##%"]}</w:t>
														</#if>
													</w:r>
												</w:p>
											</w:tc>
										</w:tr>
									</#list>
								</#if>
							</#list>
						</#if>
					</w:tbl>
					<w:p w14:paraId="32058F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="24DB8491" w14:textId="77777777" w:rsidR="00ED2243" w:rsidRDefault="002D351A">
						<w:pPr>
							<w:divId w:val="1262178115"/>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:noProof/>
							</w:rPr>
						</w:pPr>
						<w:r w:rsidRPr="009D07C6">
							<w:rPr>
								<w:noProof/>
							</w:rPr>
							<w:pict w14:anchorId="7B4C6EE7">
								<v:shapetype id="_x0000_t80" coordsize="21600,21600" o:spt="80" o:preferrelative="t" path="m@4@5l@4@11@9@11@9@5xe" filled="f" stroked="f">
									<v:stroke joinstyle="miter"/>
									<v:formulas>
										<v:f eqn="if lineDrawn pixelLineWidth 0"/>
										<v:f eqn="sum @0 1 0"/>
										<v:f eqn="sum 0 0 @1"/>
										<v:f eqn="prod @2 1 2"/>
										<v:f eqn="prod @3 21600 pixelWidth"/>
										<v:f eqn="prod @3 21600 pixelHeight"/>
										<v:f eqn="sum @0 0 1"/>
										<v:f eqn="prod @6 1 2"/>
										<v:f eqn="prod @7 21600 pixelWidth"/>
										<v:f eqn="sum @8 21600 0"/>
										<v:f eqn="prod @7 21600 pixelHeight"/>
										<v:f eqn="sum @10 21600 0"/>
									</v:formulas>
									<v:path o:extrusionok="f" gradientshapeok="t" o:connecttype="rect"/>
									<o:lock v:ext="edit" aspectratio="t"/>
								</v:shapetype>
								<v:shape id="图片 6" o:spid="_x0000_i1030" type="#_x0000_t80" style="width:500pt;height:260pt;visibility:visible">
									<v:imagedata r:id="rIdImg6" o:title=""/>
								</v:shape>
							</w:pict>
						</w:r>
					</w:p>

					<w:p w14:paraId="65AE5FAB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="37815F40" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:vanish/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="0C2BAB04" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="491A5807" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:ind w:firstLine="420"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="12AFEE1F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
							</w:rPr>
							<w:t>2.2 试卷的四度分析</w:t>
						</w:r>
					</w:p>
					<w:tbl>
						<w:tblPr>
							<w:tblW w:w="5000" w:type="pct"/>
							<w:tblBorders>
								<w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								<w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>
							</w:tblBorders>
							<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
						</w:tblPr>
						<w:tblGrid>
							<w:gridCol w:w="2394"/>
							<w:gridCol w:w="2394"/>
							<w:gridCol w:w="2394"/>
							<w:gridCol w:w="2394"/>
						</w:tblGrid>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="34506EBD" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="368"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="024EE31F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷信度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="276BD728" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${analysisParam.成绩概览.信度}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="6F29EA87" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷效度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="36173B73" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${analysisParam.成绩概览.效度}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
						<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="1A0A729A" w14:textId="77777777">
							<w:trPr>
								<w:trHeight w:val="368"/>
							</w:trPr>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="0CB518D6" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷难度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="1A868ADC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${analysisParam.成绩概览.难度}</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
									<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
								</w:tcPr>
								<w:p w14:paraId="3689C77B" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>试卷区分度</w:t>
									</w:r>
								</w:p>
							</w:tc>
							<w:tc>
								<w:tcPr>
									<w:tcW w:w="1704" w:type="dxa"/>
								</w:tcPr>
								<w:p w14:paraId="5EB67DF1" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
									<w:pPr>
										<w:jc w:val="right"/>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
									</w:pPr>
									<w:r>
										<w:rPr>
											<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
											<w:color w:val="000000"/>
											<w:sz w:val="21"/>
											<w:lang w:eastAsia="zh-CN"/>
										</w:rPr>
										<w:t>${analysisParam.成绩概览.区分度}</w:t>
									</w:r>
								</w:p>
							</w:tc>
						</w:tr>
					</w:tbl>
					<w:p w14:paraId="1DDB2E94" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="378B5ED4" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="78C1AB14" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="2"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="174"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b w:val="0"/>
								<w:bCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:i w:val="0"/>
								<w:iCs w:val="0"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>3.试题分析</w:t>
						</w:r>
					</w:p>

					<#if (analysisParam.掌握不佳的题目??) && (analysisParam.掌握不佳的题目?size &gt; 0)>
						<w:p w14:paraId="38CD03B8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
							<w:pPr>
								<w:jc w:val="both"/>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
						</w:p>
						<w:p w14:paraId="38CD03B8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
							<w:pPr>
								<w:jc w:val="both"/>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
							<w:r>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="20"/>
									<w:szCs w:val="20"/>
									<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
								</w:rPr>
								<w:t>在全部${examInfo.SUBJECTSUM}道题目的知识点考点中，以下${analysisParam.掌握不佳的题目?size}个题目知识点掌握不佳：</w:t>
							</w:r>
						</w:p>

						<w:tbl>
							<w:tblPr>
								<w:tblW w:w="5000" w:type="pct"/>
								<w:tblLayout w:type="fixed"/>
								<w:tblInd w:w="96" w:type="pct"/>
								<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
							</w:tblPr>
							<w:tblGrid>
								<w:gridCol w:w="300"/>
								<w:gridCol w:w="500"/>
								<w:gridCol w:w="1000"/>
								<w:gridCol w:w="500"/>
								<w:gridCol w:w="350"/>
								<w:gridCol w:w="400"/>
								<w:gridCol w:w="950"/>
								<w:gridCol w:w="1000"/>
							</w:tblGrid>
							<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="3F3A5F16" w14:textId="77777777">
								<w:trPr>
									<w:trHeight w:val="400"/>
								</w:trPr>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="081F5B32" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>序号</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="35FA5552" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>题目</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="5FA8018E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>主题词分类</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="4B508B76" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>题型</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="4D8D426E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>难度</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="4D8D426E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>区分度</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="4D8D426E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>分析原因</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="0" w:type="auto"/>
										<w:tcBorders>
											<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
										</w:tcBorders>
										<w:noWrap/>
										<w:vAlign w:val="center"/>
									</w:tcPr>
									<w:p w14:paraId="4D8D426E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="center"/>
											<w:textAlignment w:val="center"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="20"/>
												<w:szCs w:val="20"/>
												<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
											</w:rPr>
											<w:t>改进措施</w:t>
										</w:r>
									</w:p>
								</w:tc>
							</w:tr>
							<#list analysisParam.掌握不佳的题目 as 掌握不佳的题目>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="1456C88A" w14:textId="77777777">
									<w:trPr>
										<w:trHeight w:val="400"/>
									</w:trPr>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="3D5EA2C3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${掌握不佳的题目.index}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="7296EF86" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${掌握不佳的题目.answerTypeAndTh}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="236FDBF8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<#if 掌握不佳的题目.t2name?? && (掌握不佳的题目.t2name?has_content)>
													<w:t xml:space="preserve">${掌握不佳的题目.t1name?xml}/${掌握不佳的题目.t2name?xml}</w:t>
												<#else>
													<w:t xml:space="preserve">${掌握不佳的题目.t1name?xml}</w:t>
												</#if>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="15568F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${掌握不佳的题目.qtname?xml}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1F6582C7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${掌握不佳的题目.realdiff}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1F6582C7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t>${掌握不佳的题目.distinction}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1F6582C7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t> </w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="0" w:type="auto"/>
											<w:tcBorders>
												<w:top w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:left w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:bottom w:val="single" w:sz="4" w:space="0" w:color="000000"/>
												<w:right w:val="single" w:sz="4" w:space="0" w:color="000000"/>
											</w:tcBorders>
											<w:noWrap/>
											<w:vAlign w:val="center"/>
										</w:tcPr>
										<w:p w14:paraId="1F6582C7" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="center"/>
												<w:textAlignment w:val="center"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="20"/>
													<w:szCs w:val="20"/>
													<w:lang w:eastAsia="zh-CN" w:bidi="ar"/>
												</w:rPr>
												<w:t> </w:t>
											</w:r>
										</w:p>
									</w:tc>
								</w:tr>
							</#list>
						</w:tbl>
						<w:p w14:paraId="0D729519" w14:textId="77777777" w:rsidR="00447A8E" w:rsidRDefault="00000000">
							<w:pPr>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="FF0000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
							<w:r>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="FF0000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
								<w:t>填写说明：教师填写分析原因和改进措施。根据P（难度系数）和D（区分度）分析试题质量，主要具体分析P≤0.3且D＜0.2试题。</w:t>
							</w:r>
						</w:p>
					<#else>
						<w:p w14:paraId="0D729519" w14:textId="77777777" w:rsidR="00447A8E" w:rsidRDefault="00000000">
							<w:pPr>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
							<w:r>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
								<w:t>难度小于0.3且区分度小于0.2的属于质量不佳的题目，该试卷题目质量均可</w:t>
							</w:r>
						</w:p>
					</#if>

					<w:p w14:paraId="38CD03B8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="38CD03B8" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2C148196" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:pStyle w:val="1"/>
							<w:keepNext w:val="0"/>
							<w:spacing w:before="0" w:after="141"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:kern w:val="36"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:sz w:val="21"/>
								<w:szCs w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>4.历年成绩对比分析</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4FB2C296" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>填写说明：</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="17DFDED1" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>近三年同一门课程名称，相同专业的课程纵向对比情况</w:t>
						</w:r>
					</w:p>
					<#if (analysisParam.课程纵向分析??) && (analysisParam.课程纵向分析?size &gt; 0)>
						<w:tbl>
							<w:tblPr>
								<w:tblW w:w="0" w:type="auto"/>
								<w:tblBorders>
									<w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/>
									<w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/>
									<w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/>
									<w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/>
									<w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/>
									<w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>
								</w:tblBorders>
								<w:tblLayout w:type="fixed"/>
								<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
							</w:tblPr>
							<w:tblGrid>
								<w:gridCol w:w="1400"/>
								<w:gridCol w:w="1300"/>
								<w:gridCol w:w="780"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="780"/>
								<w:gridCol w:w="860"/>
								<w:gridCol w:w="860"/>
							</w:tblGrid>
							<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="48EB91FA" w14:textId="77777777">
								<w:trPr>
									<w:trHeight w:val="284"/>
								</w:trPr>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="1400" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="59D7AB3C" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>学年学期</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="1300" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="41D110A3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>课程名称</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="780" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="750B11E9" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>学生人数</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="44BB1B25" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>最高分</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="590D2BE3" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>最低分</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="69598E4F" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>平均分</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="2AC6BC27" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>及格率</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="2AC6BC27" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>优秀率</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="2AC6BC27" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>区分度</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="770" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="2AC6BC27" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>难度</w:t>
										</w:r>
									</w:p>
								</w:tc>
								<w:tc>
									<w:tcPr>
										<w:tcW w:w="860" w:type="dxa"/>
										<w:shd w:val="clear" w:color="auto" w:fill="B4C6E7"/>
									</w:tcPr>
									<w:p w14:paraId="252CF624" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
										<w:pPr>
											<w:jc w:val="both"/>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
										</w:pPr>
										<w:r>
											<w:rPr>
												<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
												<w:color w:val="000000"/>
												<w:sz w:val="21"/>
												<w:lang w:eastAsia="zh-CN"/>
											</w:rPr>
											<w:t>偏态量</w:t>
										</w:r>
									</w:p>
								</w:tc>
							</w:tr>
							<#list analysisParam.课程纵向分析 as 课程纵向分析>
								<w:tr w:rsidR="00BD1ACA" w:rsidRPr="00871F38" w14:paraId="6EEA7F25" w14:textId="77777777">
									<w:trPr>
										<w:trHeight w:val="284"/>
									</w:trPr>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="104C07EE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.examYear}${课程纵向分析.TERMNAME}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="4FD8DC59" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.CNAME}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="47F723AE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.SCOUNT}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="6F20A638" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.最高分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="5295B4A5" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.最低分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="543FF2FC" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.平均分}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="3BC54588" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t><#if 课程纵向分析.及格率??>${课程纵向分析.及格率?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="3BC54588" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t><#if 课程纵向分析.优秀率??>${课程纵向分析.优秀率?string["0.##%"]}<#else>-</#if></w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="3BC54588" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.区分度}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="3BC54588" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.难度}</w:t>
											</w:r>
										</w:p>
									</w:tc>
									<w:tc>
										<w:tcPr>
											<w:tcW w:w="768" w:type="dxa"/>
										</w:tcPr>
										<w:p w14:paraId="1A09395E" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
											<w:pPr>
												<w:jc w:val="both"/>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
											</w:pPr>
											<w:r>
												<w:rPr>
													<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
													<w:color w:val="000000"/>
													<w:sz w:val="21"/>
													<w:lang w:eastAsia="zh-CN"/>
												</w:rPr>
												<w:t>${课程纵向分析.偏态值!""}</w:t>
											</w:r>
										</w:p>
									</w:tc>
								</w:tr>
							</#list>
						</w:tbl>
						<w:p w14:paraId="32058F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
							<w:pPr>
								<w:jc w:val="center"/>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:color w:val="000000"/>
									<w:sz w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
						</w:p>
					<#else>
						<w:p w14:paraId="29BC25DE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
							<w:pPr>
								<w:pStyle w:val="1"/>
								<w:keepNext w:val="0"/>
								<w:spacing w:before="0" w:after="141"/>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:sz w:val="21"/>
									<w:szCs w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
							</w:pPr>
							<w:r>
								<w:rPr>
									<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
									<w:kern w:val="36"/>
									<w:sz w:val="21"/>
									<w:szCs w:val="21"/>
									<w:lang w:eastAsia="zh-CN"/>
								</w:rPr>
								<w:t>暂无课程纵向分析数据</w:t>
							</w:r>
						</w:p>
					</#if>

					<w:p w14:paraId="32058F57" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="1A58C058" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="center"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="10F031EE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="05BF900D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="21060962" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="7FA2B317" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="1FBD65EE" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>5.结论</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="3FFC1694" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:lastRenderedPageBreak/>
							<w:t>5.1 成绩统计分析</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4FB2C296" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>填写说明：</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="17DFDED1" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>与预测平均分是否存在偏差，偏差10分及以上重点分析；与预计卷面平均分无偏差，总结教学亮点。</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="44FB11AB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<@textWithBr s=analysisParam.成绩统计分析 />
						</w:r>
					</w:p>
					<w:p w14:paraId="05BF900D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="3FFC1694" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:lastRenderedPageBreak/>
							<w:t>5.2 从命题方面分析存在的问题并提出改进措施</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="44FB11AB" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<@textWithBr s=analysisParam.从考试结果分析 />
						</w:r>
					</w:p>
					<w:p w14:paraId="05BF900D" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00BD1ACA">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="7F859F00" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>与上届相比有何变化（教师自行填写）</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4431B09F" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>例：从题型上分析，本学期增加了填空题5分，选择题增加了多项选择5个，适当调整了不同题型间的分值比例，题型较为合理，涉及所学内容较全面，难度适度，区分度良好，考试结果分布曲线呈偏态分布，基本能够反映学生成绩及教学效果。名词解释通过率高，得分较高；简答题、病例分析题得分率分别是80.6%、80.2%，得分率良好；选择题得分率低，仅为39.6%；填空题得分率较低，为65.4%。说明学生对某些基本知识的掌握的欠扎实，但综合分析能力和知识的灵活运用较好。</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="415193B6" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00186EB6">
						<w:pPr>
							<w:spacing w:line="440" w:lineRule="exact"/>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="3FFC1694" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:hint="eastAsia"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:lastRenderedPageBreak/>
							<w:t>5.3 从教学方面分析存在的问题并提出改进措施</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4FB2C296" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>填写说明：</w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="17DFDED1" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t>需从教学组织、教学方法、手段、内容、教学过程（含过程考核）、学生表现等方面进行分析，在改进措施方面不能用“今后要努力改进”等措辞代替，要针对问题分析写出具体可行的措施。 </w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="2ED04E8F" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00186EB6">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="086297E0" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00186EB6">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="49692146" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00186EB6">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="612E5D69" w14:textId="77777777" w:rsidR="00186EB6" w:rsidRDefault="00000000">
						<w:pPr>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:color w:val="FF0000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
					</w:p>

					<w:p w14:paraId="04428C89" w14:textId="77777777" w:rsidR="00EF21E6" w:rsidRDefault="00EF21E6">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2087BDE4" w14:textId="77777777" w:rsidR="00EF21E6" w:rsidRDefault="00EF21E6">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2EAF146F" w14:textId="77777777" w:rsidR="00EF21E6" w:rsidRDefault="00EF21E6">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="26D40651" w14:textId="77777777" w:rsidR="00EF21E6" w:rsidRDefault="00EF21E6">
						<w:pPr>
							<w:jc w:val="both"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:color w:val="000000"/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="2E32C7E8" w14:textId="4209F0BF" w:rsidR="00EF21E6" w:rsidRDefault="00000000" w:rsidP="00EF21E6">
						<w:pPr>
							<w:wordWrap w:val="0"/>
							<w:ind w:firstLine="440"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve">教研室主任签字：           </w:t>
						</w:r>
						<w:r w:rsidR="00EF21E6">
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="4AC25CF6" w14:textId="21C21881" w:rsidR="00000000" w:rsidRDefault="00EF21E6" w:rsidP="00EF21E6">
						<w:pPr>
							<w:ind w:right="211" w:firstLine="440"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
					</w:p>
					<w:p w14:paraId="58592A81" w14:textId="77777777" w:rsidR="00EF21E6" w:rsidRDefault="00EF21E6" w:rsidP="00EF21E6">
						<w:pPr>
							<w:ind w:firstLine="440"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
					</w:p>
					<w:p w14:paraId="66D5810C" w14:textId="187D80C7" w:rsidR="00000000" w:rsidRPr="00EF21E6" w:rsidRDefault="00000000" w:rsidP="00EF21E6">
						<w:pPr>
							<w:wordWrap w:val="0"/>
							<w:jc w:val="right"/>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
						</w:pPr>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
						<w:r w:rsidR="00EF21E6">
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
						<w:r>
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"> 年    月    日</w:t>
						</w:r>
						<w:r w:rsidR="00EF21E6">
							<w:rPr>
								<w:rFonts w:ascii="宋体" w:eastAsia="宋体" w:hAnsi="宋体" w:cs="宋体" w:hint="eastAsia"/>
								<w:b/>
								<w:sz w:val="21"/>
								<w:lang w:eastAsia="zh-CN"/>
							</w:rPr>
							<w:t xml:space="preserve"></w:t>
						</w:r>
					</w:p>

					<w:sectPr w:rsidR="00BD1ACA">
						<w:pgSz w:w="12240" w:h="15840"/>
						<w:pgMar w:top="907" w:right="851" w:bottom="907" w:left="851" w:header="851" w:footer="992" w:gutter="0"/>
						<w:cols w:space="720"/>
						<w:titlePg/>
						<w:docGrid w:linePitch="360"/>
					</w:sectPr>
				</w:body>
			</w:document>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/_rels/document.xml.rels" pkg:contentType="application/vnd.openxmlformats-package.relationships+xml" pkg:padding="256">
		<pkg:xmlData>
			<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
				<Relationship Id="rIdImg3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/image3.png"/>
				<Relationship Id="rIdImg4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/image4.png"/>
				<Relationship Id="rIdImg5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/image5.png"/>
				<Relationship Id="rIdImg6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/image6.png"/>
				<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings" Target="webSettings.xml"/>
				<Relationship Id="rId12" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
				<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
				<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
				<Relationship Id="rId6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer" Target="footer1.xml"/>
				<Relationship Id="rId11" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>
				<Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/endnotes" Target="endnotes.xml"/>
				<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes" Target="footnotes.xml"/>
			</Relationships>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/footnotes.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footnotes+xml">
		<pkg:xmlData>
			<w:footnotes xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du wp14">
				<w:footnote w:type="separator" w:id="-1">
					<w:p w14:paraId="790E489B" w14:textId="77777777" w:rsidR="007F74EA" w:rsidRDefault="007F74EA">
						<w:r>
							<w:separator/>
						</w:r>
					</w:p>
				</w:footnote>
				<w:footnote w:type="continuationSeparator" w:id="0">
					<w:p w14:paraId="28ED7A33" w14:textId="77777777" w:rsidR="007F74EA" w:rsidRDefault="007F74EA">
						<w:r>
							<w:continuationSeparator/>
						</w:r>
					</w:p>
				</w:footnote>
			</w:footnotes>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/endnotes.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.endnotes+xml">
		<pkg:xmlData>
			<w:endnotes xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du wp14">
				<w:endnote w:type="separator" w:id="-1">
					<w:p w14:paraId="7397480E" w14:textId="77777777" w:rsidR="007F74EA" w:rsidRDefault="007F74EA">
						<w:r>
							<w:separator/>
						</w:r>
					</w:p>
				</w:endnote>
				<w:endnote w:type="continuationSeparator" w:id="0">
					<w:p w14:paraId="578CE1CE" w14:textId="77777777" w:rsidR="007F74EA" w:rsidRDefault="007F74EA">
						<w:r>
							<w:continuationSeparator/>
						</w:r>
					</w:p>
				</w:endnote>
			</w:endnotes>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/footer1.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml">
		<pkg:xmlData>
			<w:ftr xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
				   xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex"
				   xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex"
				   xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex"
				   xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex"
				   xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex"
				   xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex"
				   xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex"
				   xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex"
				   xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex"
				   xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
				   xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink"
				   xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d"
				   xmlns:o="urn:schemas-microsoft-com:office:office"
				   xmlns:oel="http://schemas.microsoft.com/office/2019/extlst"
				   xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
				   xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
				   xmlns:v="urn:schemas-microsoft-com:vml"
				   xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
				   xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
				   xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
				   xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
				   xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml"
				   xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex"
				   xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid"
				   xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml"
				   xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du"
				   xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash"
				   xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock"
				   xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex"
				   xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
				   xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
				   xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
				   xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
				   mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du wp14">
				<w:p w14:paraId="66F4FA91" w14:textId="77777777" w:rsidR="00BD1ACA" w:rsidRDefault="00000000">
					<w:pPr>
						<w:jc w:val="center"/>
					</w:pPr>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:t xml:space="preserve">第</w:t>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="begin"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:instrText xml:space="preserve">PAGE</w:instrText>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="separate"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:t>4</w:t>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="end"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:t xml:space="preserve">页，共</w:t>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="begin"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:instrText xml:space="preserve">NUMPAGES</w:instrText>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="separate"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:t>5</w:t>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:fldChar w:fldCharType="end"/>
					</w:r>
					<w:r>
						<w:rPr>
							<w:rFonts w:ascii="方正仿宋简体" w:eastAsia="方正仿宋简体" w:hAnsi="方正仿宋简体" w:cs="方正仿宋简体"/>
						</w:rPr>
						<w:t xml:space="preserve">页</w:t>
					</w:r>
				</w:p>
			</w:ftr>
		</pkg:xmlData>
	</pkg:part>
	<#--<pkg:part pkg:name="/word/media/image1.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.成绩概览_base64}</pkg:binaryData>
	</pkg:part>
	<pkg:part pkg:name="/word/media/image2.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.质量指标_base64}</pkg:binaryData>
	</pkg:part>-->
	<pkg:part pkg:name="/word/media/image3.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.分数分布_base64}</pkg:binaryData>
	</pkg:part>
	<pkg:part pkg:name="/word/media/image4.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.主题词分类得分分析_base64}</pkg:binaryData>
	</pkg:part>
	<pkg:part pkg:name="/word/media/image5.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.认知分类得分分析_base64}</pkg:binaryData>
	</pkg:part>
	<pkg:part pkg:name="/word/media/image6.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.题型分类得分分析_base64}</pkg:binaryData>
	</pkg:part>
	<#--<pkg:part pkg:name="/word/media/image7.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.试卷四度分析_base64}</pkg:binaryData>
	</pkg:part>-->
	<#--<pkg:part pkg:name="/word/media/image8.png" pkg:contentType="image/png" pkg:compression="store">
		<pkg:binaryData>${analysisParam.课程纵向分析_base64}</pkg:binaryData>
	</pkg:part>-->
	<pkg:part pkg:name="/word/theme/theme1.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.theme+xml">
		<pkg:xmlData>
			<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office 主题​​">
				<a:themeElements>
					<a:clrScheme name="Office">
						<a:dk1>
							<a:sysClr val="windowText" lastClr="000000"/>
						</a:dk1>
						<a:lt1>
							<a:sysClr val="window" lastClr="FFFFFF"/>
						</a:lt1>
						<a:dk2>
							<a:srgbClr val="0E2841"/>
						</a:dk2>
						<a:lt2>
							<a:srgbClr val="E8E8E8"/>
						</a:lt2>
						<a:accent1>
							<a:srgbClr val="156082"/>
						</a:accent1>
						<a:accent2>
							<a:srgbClr val="E97132"/>
						</a:accent2>
						<a:accent3>
							<a:srgbClr val="196B24"/>
						</a:accent3>
						<a:accent4>
							<a:srgbClr val="0F9ED5"/>
						</a:accent4>
						<a:accent5>
							<a:srgbClr val="A02B93"/>
						</a:accent5>
						<a:accent6>
							<a:srgbClr val="4EA72E"/>
						</a:accent6>
						<a:hlink>
							<a:srgbClr val="467886"/>
						</a:hlink>
						<a:folHlink>
							<a:srgbClr val="96607D"/>
						</a:folHlink>
					</a:clrScheme>
					<a:fontScheme name="Office">
						<a:majorFont>
							<a:latin typeface="等线 Light" panose="02110004020202020204"/>
							<a:ea typeface=""/>
							<a:cs typeface=""/>
							<a:font script="Jpan" typeface="游ゴシック Light"/>
							<a:font script="Hang" typeface="맑은 고딕"/>
							<a:font script="Hans" typeface="等线 Light"/>
							<a:font script="Hant" typeface="新細明體"/>
							<a:font script="Arab" typeface="Times New Roman"/>
							<a:font script="Hebr" typeface="Times New Roman"/>
							<a:font script="Thai" typeface="Angsana New"/>
							<a:font script="Ethi" typeface="Nyala"/>
							<a:font script="Beng" typeface="Vrinda"/>
							<a:font script="Gujr" typeface="Shruti"/>
							<a:font script="Khmr" typeface="MoolBoran"/>
							<a:font script="Knda" typeface="Tunga"/>
							<a:font script="Guru" typeface="Raavi"/>
							<a:font script="Cans" typeface="Euphemia"/>
							<a:font script="Cher" typeface="Plantagenet Cherokee"/>
							<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
							<a:font script="Tibt" typeface="Microsoft Himalaya"/>
							<a:font script="Thaa" typeface="MV Boli"/>
							<a:font script="Deva" typeface="Mangal"/>
							<a:font script="Telu" typeface="Gautami"/>
							<a:font script="Taml" typeface="Latha"/>
							<a:font script="Syrc" typeface="Estrangelo Edessa"/>
							<a:font script="Orya" typeface="Kalinga"/>
							<a:font script="Mlym" typeface="Kartika"/>
							<a:font script="Laoo" typeface="DokChampa"/>
							<a:font script="Sinh" typeface="Iskoola Pota"/>
							<a:font script="Mong" typeface="Mongolian Baiti"/>
							<a:font script="Viet" typeface="Times New Roman"/>
							<a:font script="Uigh" typeface="Microsoft Uighur"/>
							<a:font script="Geor" typeface="Sylfaen"/>
							<a:font script="Armn" typeface="Arial"/>
							<a:font script="Bugi" typeface="Leelawadee UI"/>
							<a:font script="Bopo" typeface="Microsoft JhengHei"/>
							<a:font script="Java" typeface="Javanese Text"/>
							<a:font script="Lisu" typeface="Segoe UI"/>
							<a:font script="Mymr" typeface="Myanmar Text"/>
							<a:font script="Nkoo" typeface="Ebrima"/>
							<a:font script="Olck" typeface="Nirmala UI"/>
							<a:font script="Osma" typeface="Ebrima"/>
							<a:font script="Phag" typeface="Phagspa"/>
							<a:font script="Syrn" typeface="Estrangelo Edessa"/>
							<a:font script="Syrj" typeface="Estrangelo Edessa"/>
							<a:font script="Syre" typeface="Estrangelo Edessa"/>
							<a:font script="Sora" typeface="Nirmala UI"/>
							<a:font script="Tale" typeface="Microsoft Tai Le"/>
							<a:font script="Talu" typeface="Microsoft New Tai Lue"/>
							<a:font script="Tfng" typeface="Ebrima"/>
						</a:majorFont>
						<a:minorFont>
							<a:latin typeface="等线" panose="02110004020202020204"/>
							<a:ea typeface=""/>
							<a:cs typeface=""/>
							<a:font script="Jpan" typeface="游明朝"/>
							<a:font script="Hang" typeface="맑은 고딕"/>
							<a:font script="Hans" typeface="等线"/>
							<a:font script="Hant" typeface="新細明體"/>
							<a:font script="Arab" typeface="Arial"/>
							<a:font script="Hebr" typeface="Arial"/>
							<a:font script="Thai" typeface="Cordia New"/>
							<a:font script="Ethi" typeface="Nyala"/>
							<a:font script="Beng" typeface="Vrinda"/>
							<a:font script="Gujr" typeface="Shruti"/>
							<a:font script="Khmr" typeface="DaunPenh"/>
							<a:font script="Knda" typeface="Tunga"/>
							<a:font script="Guru" typeface="Raavi"/>
							<a:font script="Cans" typeface="Euphemia"/>
							<a:font script="Cher" typeface="Plantagenet Cherokee"/>
							<a:font script="Yiii" typeface="Microsoft Yi Baiti"/>
							<a:font script="Tibt" typeface="Microsoft Himalaya"/>
							<a:font script="Thaa" typeface="MV Boli"/>
							<a:font script="Deva" typeface="Mangal"/>
							<a:font script="Telu" typeface="Gautami"/>
							<a:font script="Taml" typeface="Latha"/>
							<a:font script="Syrc" typeface="Estrangelo Edessa"/>
							<a:font script="Orya" typeface="Kalinga"/>
							<a:font script="Mlym" typeface="Kartika"/>
							<a:font script="Laoo" typeface="DokChampa"/>
							<a:font script="Sinh" typeface="Iskoola Pota"/>
							<a:font script="Mong" typeface="Mongolian Baiti"/>
							<a:font script="Viet" typeface="Arial"/>
							<a:font script="Uigh" typeface="Microsoft Uighur"/>
							<a:font script="Geor" typeface="Sylfaen"/>
							<a:font script="Armn" typeface="Arial"/>
							<a:font script="Bugi" typeface="Leelawadee UI"/>
							<a:font script="Bopo" typeface="Microsoft JhengHei"/>
							<a:font script="Java" typeface="Javanese Text"/>
							<a:font script="Lisu" typeface="Segoe UI"/>
							<a:font script="Mymr" typeface="Myanmar Text"/>
							<a:font script="Nkoo" typeface="Ebrima"/>
							<a:font script="Olck" typeface="Nirmala UI"/>
							<a:font script="Osma" typeface="Ebrima"/>
							<a:font script="Phag" typeface="Phagspa"/>
							<a:font script="Syrn" typeface="Estrangelo Edessa"/>
							<a:font script="Syrj" typeface="Estrangelo Edessa"/>
							<a:font script="Syre" typeface="Estrangelo Edessa"/>
							<a:font script="Sora" typeface="Nirmala UI"/>
							<a:font script="Tale" typeface="Microsoft Tai Le"/>
							<a:font script="Talu" typeface="Microsoft New Tai Lue"/>
							<a:font script="Tfng" typeface="Ebrima"/>
						</a:minorFont>
					</a:fontScheme>
					<a:fmtScheme name="Office">
						<a:fillStyleLst>
							<a:solidFill>
								<a:schemeClr val="phClr"/>
							</a:solidFill>
							<a:gradFill rotWithShape="1">
								<a:gsLst>
									<a:gs pos="0">
										<a:schemeClr val="phClr">
											<a:lumMod val="110000"/>
											<a:satMod val="105000"/>
											<a:tint val="67000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="50000">
										<a:schemeClr val="phClr">
											<a:lumMod val="105000"/>
											<a:satMod val="103000"/>
											<a:tint val="73000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="100000">
										<a:schemeClr val="phClr">
											<a:lumMod val="105000"/>
											<a:satMod val="109000"/>
											<a:tint val="81000"/>
										</a:schemeClr>
									</a:gs>
								</a:gsLst>
								<a:lin ang="5400000" scaled="0"/>
							</a:gradFill>
							<a:gradFill rotWithShape="1">
								<a:gsLst>
									<a:gs pos="0">
										<a:schemeClr val="phClr">
											<a:satMod val="103000"/>
											<a:lumMod val="102000"/>
											<a:tint val="94000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="50000">
										<a:schemeClr val="phClr">
											<a:satMod val="110000"/>
											<a:lumMod val="100000"/>
											<a:shade val="100000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="100000">
										<a:schemeClr val="phClr">
											<a:lumMod val="99000"/>
											<a:satMod val="120000"/>
											<a:shade val="78000"/>
										</a:schemeClr>
									</a:gs>
								</a:gsLst>
								<a:lin ang="5400000" scaled="0"/>
							</a:gradFill>
						</a:fillStyleLst>
						<a:lnStyleLst>
							<a:ln w="12700" cap="flat" cmpd="sng" algn="ctr">
								<a:solidFill>
									<a:schemeClr val="phClr"/>
								</a:solidFill>
								<a:prstDash val="solid"/>
								<a:miter lim="800000"/>
							</a:ln>
							<a:ln w="19050" cap="flat" cmpd="sng" algn="ctr">
								<a:solidFill>
									<a:schemeClr val="phClr"/>
								</a:solidFill>
								<a:prstDash val="solid"/>
								<a:miter lim="800000"/>
							</a:ln>
							<a:ln w="25400" cap="flat" cmpd="sng" algn="ctr">
								<a:solidFill>
									<a:schemeClr val="phClr"/>
								</a:solidFill>
								<a:prstDash val="solid"/>
								<a:miter lim="800000"/>
							</a:ln>
						</a:lnStyleLst>
						<a:effectStyleLst>
							<a:effectStyle>
								<a:effectLst/>
							</a:effectStyle>
							<a:effectStyle>
								<a:effectLst/>
							</a:effectStyle>
							<a:effectStyle>
								<a:effectLst>
									<a:outerShdw blurRad="57150" dist="19050" dir="5400000" algn="ctr" rotWithShape="0">
										<a:srgbClr val="000000">
											<a:alpha val="63000"/>
										</a:srgbClr>
									</a:outerShdw>
								</a:effectLst>
							</a:effectStyle>
						</a:effectStyleLst>
						<a:bgFillStyleLst>
							<a:solidFill>
								<a:schemeClr val="phClr"/>
							</a:solidFill>
							<a:solidFill>
								<a:schemeClr val="phClr">
									<a:tint val="95000"/>
									<a:satMod val="170000"/>
								</a:schemeClr>
							</a:solidFill>
							<a:gradFill rotWithShape="1">
								<a:gsLst>
									<a:gs pos="0">
										<a:schemeClr val="phClr">
											<a:tint val="93000"/>
											<a:satMod val="150000"/>
											<a:shade val="98000"/>
											<a:lumMod val="102000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="50000">
										<a:schemeClr val="phClr">
											<a:tint val="98000"/>
											<a:satMod val="130000"/>
											<a:shade val="90000"/>
											<a:lumMod val="103000"/>
										</a:schemeClr>
									</a:gs>
									<a:gs pos="100000">
										<a:schemeClr val="phClr">
											<a:shade val="63000"/>
											<a:satMod val="120000"/>
										</a:schemeClr>
									</a:gs>
								</a:gsLst>
								<a:lin ang="5400000" scaled="0"/>
							</a:gradFill>
						</a:bgFillStyleLst>
					</a:fmtScheme>
				</a:themeElements>
				<a:objectDefaults>
					<a:lnDef>
						<a:spPr/>
						<a:bodyPr/>
						<a:lstStyle/>
						<a:style>
							<a:lnRef idx="2">
								<a:schemeClr val="accent1"/>
							</a:lnRef>
							<a:fillRef idx="0">
								<a:schemeClr val="accent1"/>
							</a:fillRef>
							<a:effectRef idx="1">
								<a:schemeClr val="accent1"/>
							</a:effectRef>
							<a:fontRef idx="minor">
								<a:schemeClr val="tx1"/>
							</a:fontRef>
						</a:style>
					</a:lnDef>
				</a:objectDefaults>
				<a:extraClrSchemeLst/>
				<a:extLst>
					<a:ext uri="{05A4C25C-085E-4340-85A3-A5531E510DB2}">
						<thm15:themeFamily xmlns:thm15="http://schemas.microsoft.com/office/thememl/2012/main" name="Office Theme" id="{2E142A2C-CD16-42D6-873A-C26D2A0506FA}" vid="{1BDDFF52-6CD6-40A5-AB3C-68EB2F1E4D0A}"/>
					</a:ext>
				</a:extLst>
			</a:theme>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/settings.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml">
		<pkg:xmlData>
			<w:settings xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:sl="http://schemas.openxmlformats.org/schemaLibrary/2006/main" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du">
				<w:zoom w:percent="100"/>
				<w:stylePaneFormatFilter w:val="3F01" w:allStyles="1" w:customStyles="0" w:latentStyles="0" w:stylesInUse="0" w:headingStyles="0" w:numberingStyles="0" w:tableStyles="0" w:directFormattingOnRuns="1" w:directFormattingOnParagraphs="1" w:directFormattingOnNumbering="1" w:directFormattingOnTables="1" w:clearFormatting="1" w:top3HeadingStyles="1" w:visibleStyles="0" w:alternateStyleNames="0"/>
				<w:doNotTrackMoves/>
				<w:defaultTabStop w:val="720"/>
				<w:noPunctuationKerning/>
				<w:characterSpacingControl w:val="doNotCompress"/>
				<w:footnotePr>
					<w:footnote w:id="-1"/>
					<w:footnote w:id="0"/>
				</w:footnotePr>
				<w:endnotePr>
					<w:endnote w:id="-1"/>
					<w:endnote w:id="0"/>
				</w:endnotePr>
				<w:compat>
					<w:doNotExpandShiftReturn/>
					<w:doNotWrapTextWithPunct/>
					<w:doNotUseEastAsianBreakRules/>
					<w:useWord2002TableStyleRules/>
					<w:growAutofit/>
					<w:useFELayout/>
					<w:useNormalStyleForList/>
					<w:doNotUseIndentAsNumberingTabStop/>
					<w:useAltKinsokuLineBreakRules/>
					<w:allowSpaceOfSameStyleInTable/>
					<w:doNotSuppressIndentation/>
					<w:doNotAutofitConstrainedTables/>
					<w:autofitToFirstFixedWidthCell/>
					<w:displayHangulFixedWidth/>
					<w:splitPgBreakAndParaMark/>
					<w:doNotVertAlignCellWithSp/>
					<w:doNotBreakConstrainedForcedTable/>
					<w:doNotVertAlignInTxbx/>
					<w:useAnsiKerningPairs/>
					<w:cachedColBalance/>
					<w:compatSetting w:name="compatibilityMode" w:uri="http://schemas.microsoft.com/office/word" w:val="11"/>
					<w:compatSetting w:name="allowHyphenationAtTrackBottom" w:uri="http://schemas.microsoft.com/office/word" w:val="1"/>
					<w:compatSetting w:name="useWord2013TrackBottomHyphenation" w:uri="http://schemas.microsoft.com/office/word" w:val="1"/>
				</w:compat>
				<w:rsids>
					<w:rsidRoot w:val="00A77B3E"/>
					<w:rsid w:val="000224EA"/>
					<w:rsid w:val="0014340C"/>
					<w:rsid w:val="001D217B"/>
					<w:rsid w:val="002041CD"/>
					<w:rsid w:val="00381025"/>
					<w:rsid w:val="00480CA2"/>
					<w:rsid w:val="00557CEF"/>
					<w:rsid w:val="00595267"/>
					<w:rsid w:val="007F74EA"/>
					<w:rsid w:val="00822DB0"/>
					<w:rsid w:val="008443B3"/>
					<w:rsid w:val="00871F38"/>
					<w:rsid w:val="00A77B3E"/>
					<w:rsid w:val="00AA7D03"/>
					<w:rsid w:val="00AC14E8"/>
					<w:rsid w:val="00AC19CA"/>
					<w:rsid w:val="00B32D8D"/>
					<w:rsid w:val="00BD1ACA"/>
					<w:rsid w:val="00BD5173"/>
					<w:rsid w:val="00BF0F10"/>
					<w:rsid w:val="00C506D1"/>
					<w:rsid w:val="00CA2A55"/>
					<w:rsid w:val="00E63248"/>
					<w:rsid w:val="0213141D"/>
					<w:rsid w:val="02331EF9"/>
					<w:rsid w:val="05DE0C0A"/>
					<w:rsid w:val="06224B87"/>
					<w:rsid w:val="06C5252B"/>
					<w:rsid w:val="07195A0D"/>
					<w:rsid w:val="07950B26"/>
					<w:rsid w:val="07AE35A7"/>
					<w:rsid w:val="09507574"/>
					<w:rsid w:val="0B7C0033"/>
					<w:rsid w:val="0E855450"/>
					<w:rsid w:val="0F5F5CA1"/>
					<w:rsid w:val="11222DE3"/>
					<w:rsid w:val="117B0D2A"/>
					<w:rsid w:val="12011292"/>
					<w:rsid w:val="12B6313B"/>
					<w:rsid w:val="12EB5A2F"/>
					<w:rsid w:val="130C4392"/>
					<w:rsid w:val="144A22F5"/>
					<w:rsid w:val="147026FF"/>
					<w:rsid w:val="149C1746"/>
					<w:rsid w:val="15BA6327"/>
					<w:rsid w:val="15E213DA"/>
					<w:rsid w:val="16184DFC"/>
					<w:rsid w:val="169D3553"/>
					<w:rsid w:val="178070FD"/>
					<w:rsid w:val="18D019BE"/>
					<w:rsid w:val="197C38F4"/>
					<w:rsid w:val="1BD619E1"/>
					<w:rsid w:val="1BF010DD"/>
					<w:rsid w:val="1EE14925"/>
					<w:rsid w:val="1FE67D19"/>
					<w:rsid w:val="20BA367F"/>
					<w:rsid w:val="22B12860"/>
					<w:rsid w:val="23671171"/>
					<w:rsid w:val="23A45F21"/>
					<w:rsid w:val="25F52A64"/>
					<w:rsid w:val="26213859"/>
					<w:rsid w:val="26887D7C"/>
					<w:rsid w:val="273323C1"/>
					<w:rsid w:val="287C121A"/>
					<w:rsid w:val="28AD3ACA"/>
					<w:rsid w:val="29C4731D"/>
					<w:rsid w:val="2A73664D"/>
					<w:rsid w:val="2AC475ED"/>
					<w:rsid w:val="2D081307"/>
					<w:rsid w:val="2D1E6D44"/>
					<w:rsid w:val="2D32788D"/>
					<w:rsid w:val="2DD613CD"/>
					<w:rsid w:val="2EEB534C"/>
					<w:rsid w:val="2EF73CF0"/>
					<w:rsid w:val="2F100682"/>
					<w:rsid w:val="2F120B2A"/>
					<w:rsid w:val="30D8545C"/>
					<w:rsid w:val="316513E5"/>
					<w:rsid w:val="31657E03"/>
					<w:rsid w:val="31796C3F"/>
					<w:rsid w:val="31F369F1"/>
					<w:rsid w:val="32994204"/>
					<w:rsid w:val="329A7AD3"/>
					<w:rsid w:val="32BF7B7A"/>
					<w:rsid w:val="33784CD4"/>
					<w:rsid w:val="34415619"/>
					<w:rsid w:val="344A041F"/>
					<w:rsid w:val="34A212C9"/>
					<w:rsid w:val="36513CE6"/>
					<w:rsid w:val="36F40B16"/>
					<w:rsid w:val="373D426B"/>
					<w:rsid w:val="3A0C0AEA"/>
					<w:rsid w:val="3B9D79CE"/>
					<w:rsid w:val="3C793F97"/>
					<w:rsid w:val="3D566086"/>
					<w:rsid w:val="3FB11C9A"/>
					<w:rsid w:val="3FDA2F9E"/>
					<w:rsid w:val="41D61543"/>
					<w:rsid w:val="4504286C"/>
					<w:rsid w:val="4588524B"/>
					<w:rsid w:val="45DE1B35"/>
					<w:rsid w:val="4B6126FE"/>
					<w:rsid w:val="4B844C80"/>
					<w:rsid w:val="4C26756B"/>
					<w:rsid w:val="4D043409"/>
					<w:rsid w:val="4F0E67C1"/>
					<w:rsid w:val="4F986314"/>
					<w:rsid w:val="4FCE6017"/>
					<w:rsid w:val="503B1837"/>
					<w:rsid w:val="51F36142"/>
					<w:rsid w:val="54BF40B9"/>
					<w:rsid w:val="5596306C"/>
					<w:rsid w:val="5627460C"/>
					<w:rsid w:val="56AC47C9"/>
					<w:rsid w:val="571701DC"/>
					<w:rsid w:val="57BD6030"/>
					<w:rsid w:val="591724A4"/>
					<w:rsid w:val="5B8027F4"/>
					<w:rsid w:val="5C657C3C"/>
					<w:rsid w:val="5FC66BFB"/>
					<w:rsid w:val="626C770B"/>
					<w:rsid w:val="632717A7"/>
					<w:rsid w:val="641E2BAA"/>
					<w:rsid w:val="646515A5"/>
					<w:rsid w:val="6481138B"/>
					<w:rsid w:val="64B74DAD"/>
					<w:rsid w:val="65476233"/>
					<w:rsid w:val="656B62C3"/>
					<w:rsid w:val="66AE1605"/>
					<w:rsid w:val="671169F6"/>
					<w:rsid w:val="679411BF"/>
					<w:rsid w:val="68165F31"/>
					<w:rsid w:val="688E075D"/>
					<w:rsid w:val="69157C85"/>
					<w:rsid w:val="69600902"/>
					<w:rsid w:val="69643755"/>
					<w:rsid w:val="699219DD"/>
					<w:rsid w:val="6AF9611F"/>
					<w:rsid w:val="6B39651C"/>
					<w:rsid w:val="6C027255"/>
					<w:rsid w:val="6C0F1F4D"/>
					<w:rsid w:val="6D413DAD"/>
					<w:rsid w:val="6E6E472E"/>
					<w:rsid w:val="6F38269A"/>
					<w:rsid w:val="705636CC"/>
					<w:rsid w:val="71EA67C2"/>
					<w:rsid w:val="72712A3F"/>
					<w:rsid w:val="74085625"/>
					<w:rsid w:val="759C4277"/>
					<w:rsid w:val="75DC4673"/>
					<w:rsid w:val="76393874"/>
					<w:rsid w:val="76746FA2"/>
					<w:rsid w:val="77AB254F"/>
					<w:rsid w:val="783764D9"/>
					<w:rsid w:val="796E4E17"/>
					<w:rsid w:val="79A47B9E"/>
					<w:rsid w:val="7A0348C4"/>
					<w:rsid w:val="7B6C0400"/>
					<w:rsid w:val="7C855A65"/>
					<w:rsid w:val="7CA254F1"/>
					<w:rsid w:val="7F1629A4"/>
					<w:rsid w:val="7F802513"/>
				</w:rsids>
				<m:mathPr>
					<m:mathFont m:val="Cambria Math"/>
					<m:brkBin m:val="before"/>
					<m:brkBinSub m:val="--"/>
					<m:smallFrac m:val="0"/>
					<m:dispDef/>
					<m:lMargin m:val="0"/>
					<m:rMargin m:val="0"/>
					<m:defJc m:val="centerGroup"/>
					<m:wrapIndent m:val="1440"/>
					<m:intLim m:val="subSup"/>
					<m:naryLim m:val="undOvr"/>
				</m:mathPr>
				<w:themeFontLang w:val="en-US" w:eastAsia="zh-CN"/>
				<w:clrSchemeMapping w:bg1="light1" w:t1="dark1" w:bg2="light2" w:t2="dark2" w:accent1="accent1" w:accent2="accent2" w:accent3="accent3" w:accent4="accent4" w:accent5="accent5" w:accent6="accent6" w:hyperlink="hyperlink" w:followedHyperlink="followedHyperlink"/>
				<w:doNotIncludeSubdocsInStats/>
				<w:shapeDefaults>
					<o:shapedefaults v:ext="edit" spidmax="1026"/>
					<o:shapelayout v:ext="edit">
						<o:idmap v:ext="edit" data="1"/>
					</o:shapelayout>
				</w:shapeDefaults>
				<w:decimalSymbol w:val="."/>
				<w:listSeparator w:val=","/>
				<w14:docId w14:val="70A3542D"/>
				<w15:docId w15:val="{5C104F01-7D93-4EDA-86DE-AA554926F00E}"/>
			</w:settings>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/styles.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml">
		<pkg:xmlData>
			<w:styles xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du">
				<w:docDefaults>
					<w:rPrDefault>
						<w:rPr>
							<w:rFonts w:ascii="Times New Roman" w:eastAsia="宋体" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
							<w:lang w:val="en-US" w:eastAsia="zh-CN" w:bidi="ar-SA"/>
						</w:rPr>
					</w:rPrDefault>
					<w:pPrDefault/>
				</w:docDefaults>
				<w:latentStyles w:defLockedState="0" w:defUIPriority="0" w:defSemiHidden="0" w:defUnhideWhenUsed="0" w:defQFormat="0" w:count="376">
					<w:lsdException w:name="Normal" w:qFormat="1"/>
					<w:lsdException w:name="heading 1" w:qFormat="1"/>
					<w:lsdException w:name="heading 2" w:qFormat="1"/>
					<w:lsdException w:name="heading 3" w:qFormat="1"/>
					<w:lsdException w:name="heading 4" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="heading 5" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="heading 6" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="heading 7" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="heading 8" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="heading 9" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="header" w:qFormat="1"/>
					<w:lsdException w:name="footer" w:qFormat="1"/>
					<w:lsdException w:name="caption" w:semiHidden="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="Title" w:qFormat="1"/>
					<w:lsdException w:name="Default Paragraph Font" w:semiHidden="1" w:uiPriority="1" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="Subtitle" w:qFormat="1"/>
					<w:lsdException w:name="Strong" w:qFormat="1"/>
					<w:lsdException w:name="Emphasis" w:qFormat="1"/>
					<w:lsdException w:name="HTML Top of Form" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="HTML Bottom of Form" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Normal Table" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="No List" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Outline List 1" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Outline List 2" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Outline List 3" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Simple 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Simple 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Simple 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Classic 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Classic 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Classic 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Classic 4" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Colorful 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Colorful 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Colorful 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Columns 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Columns 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Columns 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Columns 4" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Columns 5" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 4" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 5" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 6" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 7" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Grid 8" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 4" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 5" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 6" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 7" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table List 8" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table 3D effects 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table 3D effects 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table 3D effects 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Contemporary" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Elegant" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Professional" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Subtle 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Subtle 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Web 1" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Web 2" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Web 3" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Table Theme" w:semiHidden="1" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Placeholder Text" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="No Spacing" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Light Shading" w:uiPriority="60"/>
					<w:lsdException w:name="Light List" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 1" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 1" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 1" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 1" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 1" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 1" w:uiPriority="65"/>
					<w:lsdException w:name="Revision" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="List Paragraph" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Quote" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Intense Quote" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Medium List 2 Accent 1" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 1" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 1" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 1" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 1" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 1" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 1" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 1" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 2" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 2" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 2" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 2" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 2" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 2" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2 Accent 2" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 2" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 2" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 2" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 2" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 2" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 2" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 2" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 3" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 3" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 3" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 3" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 3" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 3" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2 Accent 3" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 3" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 3" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 3" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 3" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 3" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 3" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 3" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 4" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 4" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 4" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 4" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 4" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 4" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2 Accent 4" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 4" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 4" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 4" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 4" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 4" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 4" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 4" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 5" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 5" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 5" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 5" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 5" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 5" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2 Accent 5" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 5" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 5" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 5" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 5" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 5" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 5" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 5" w:uiPriority="73"/>
					<w:lsdException w:name="Light Shading Accent 6" w:uiPriority="60"/>
					<w:lsdException w:name="Light List Accent 6" w:uiPriority="61"/>
					<w:lsdException w:name="Light Grid Accent 6" w:uiPriority="62"/>
					<w:lsdException w:name="Medium Shading 1 Accent 6" w:uiPriority="63"/>
					<w:lsdException w:name="Medium Shading 2 Accent 6" w:uiPriority="64"/>
					<w:lsdException w:name="Medium List 1 Accent 6" w:uiPriority="65"/>
					<w:lsdException w:name="Medium List 2 Accent 6" w:uiPriority="66"/>
					<w:lsdException w:name="Medium Grid 1 Accent 6" w:uiPriority="67"/>
					<w:lsdException w:name="Medium Grid 2 Accent 6" w:uiPriority="68"/>
					<w:lsdException w:name="Medium Grid 3 Accent 6" w:uiPriority="69"/>
					<w:lsdException w:name="Dark List Accent 6" w:uiPriority="70"/>
					<w:lsdException w:name="Colorful Shading Accent 6" w:uiPriority="71"/>
					<w:lsdException w:name="Colorful List Accent 6" w:uiPriority="72"/>
					<w:lsdException w:name="Colorful Grid Accent 6" w:uiPriority="73"/>
					<w:lsdException w:name="Subtle Emphasis" w:uiPriority="19" w:qFormat="1"/>
					<w:lsdException w:name="Intense Emphasis" w:uiPriority="21" w:qFormat="1"/>
					<w:lsdException w:name="Subtle Reference" w:uiPriority="31" w:qFormat="1"/>
					<w:lsdException w:name="Intense Reference" w:uiPriority="32" w:qFormat="1"/>
					<w:lsdException w:name="Book Title" w:uiPriority="33" w:qFormat="1"/>
					<w:lsdException w:name="Bibliography" w:semiHidden="1" w:uiPriority="37" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="TOC Heading" w:semiHidden="1" w:uiPriority="39" w:unhideWhenUsed="1" w:qFormat="1"/>
					<w:lsdException w:name="Plain Table 1" w:uiPriority="41"/>
					<w:lsdException w:name="Plain Table 2" w:uiPriority="42"/>
					<w:lsdException w:name="Plain Table 3" w:uiPriority="43"/>
					<w:lsdException w:name="Plain Table 4" w:uiPriority="44"/>
					<w:lsdException w:name="Plain Table 5" w:uiPriority="45"/>
					<w:lsdException w:name="Grid Table Light" w:uiPriority="40"/>
					<w:lsdException w:name="Grid Table 1 Light" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 1" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 1" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 1" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 1" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 1" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 1" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 1" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 2" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 2" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 2" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 2" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 2" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 2" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 2" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 3" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 3" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 3" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 3" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 3" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 3" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 3" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 4" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 4" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 4" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 4" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 4" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 4" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 4" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 5" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 5" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 5" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 5" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 5" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 5" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 5" w:uiPriority="52"/>
					<w:lsdException w:name="Grid Table 1 Light Accent 6" w:uiPriority="46"/>
					<w:lsdException w:name="Grid Table 2 Accent 6" w:uiPriority="47"/>
					<w:lsdException w:name="Grid Table 3 Accent 6" w:uiPriority="48"/>
					<w:lsdException w:name="Grid Table 4 Accent 6" w:uiPriority="49"/>
					<w:lsdException w:name="Grid Table 5 Dark Accent 6" w:uiPriority="50"/>
					<w:lsdException w:name="Grid Table 6 Colorful Accent 6" w:uiPriority="51"/>
					<w:lsdException w:name="Grid Table 7 Colorful Accent 6" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 1" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 1" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 1" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 1" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 1" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 1" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 1" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 2" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 2" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 2" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 2" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 2" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 2" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 2" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 3" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 3" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 3" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 3" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 3" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 3" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 3" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 4" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 4" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 4" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 4" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 4" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 4" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 4" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 5" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 5" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 5" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 5" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 5" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 5" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 5" w:uiPriority="52"/>
					<w:lsdException w:name="List Table 1 Light Accent 6" w:uiPriority="46"/>
					<w:lsdException w:name="List Table 2 Accent 6" w:uiPriority="47"/>
					<w:lsdException w:name="List Table 3 Accent 6" w:uiPriority="48"/>
					<w:lsdException w:name="List Table 4 Accent 6" w:uiPriority="49"/>
					<w:lsdException w:name="List Table 5 Dark Accent 6" w:uiPriority="50"/>
					<w:lsdException w:name="List Table 6 Colorful Accent 6" w:uiPriority="51"/>
					<w:lsdException w:name="List Table 7 Colorful Accent 6" w:uiPriority="52"/>
					<w:lsdException w:name="Mention" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Smart Hyperlink" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Hashtag" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Unresolved Mention" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
					<w:lsdException w:name="Smart Link" w:semiHidden="1" w:uiPriority="99" w:unhideWhenUsed="1"/>
				</w:latentStyles>
				<w:style w:type="paragraph" w:default="1" w:styleId="a">
					<w:name w:val="Normal"/>
					<w:qFormat/>
					<w:rPr>
						<w:rFonts w:eastAsia="等线"/>
						<w:sz w:val="24"/>
						<w:szCs w:val="24"/>
						<w:lang w:eastAsia="en-US"/>
					</w:rPr>
				</w:style>
				<w:style w:type="paragraph" w:styleId="1">
					<w:name w:val="heading 1"/>
					<w:basedOn w:val="a"/>
					<w:next w:val="a"/>
					<w:qFormat/>
					<w:pPr>
						<w:keepNext/>
						<w:spacing w:before="240" w:after="60"/>
						<w:outlineLvl w:val="0"/>
					</w:pPr>
					<w:rPr>
						<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
						<w:b/>
						<w:bCs/>
						<w:kern w:val="32"/>
						<w:sz w:val="32"/>
						<w:szCs w:val="32"/>
					</w:rPr>
				</w:style>
				<w:style w:type="paragraph" w:styleId="2">
					<w:name w:val="heading 2"/>
					<w:basedOn w:val="a"/>
					<w:next w:val="a"/>
					<w:qFormat/>
					<w:pPr>
						<w:keepNext/>
						<w:spacing w:before="240" w:after="60"/>
						<w:outlineLvl w:val="1"/>
					</w:pPr>
					<w:rPr>
						<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
						<w:b/>
						<w:bCs/>
						<w:i/>
						<w:iCs/>
						<w:sz w:val="28"/>
						<w:szCs w:val="28"/>
					</w:rPr>
				</w:style>
				<w:style w:type="paragraph" w:styleId="3">
					<w:name w:val="heading 3"/>
					<w:basedOn w:val="a"/>
					<w:next w:val="a"/>
					<w:qFormat/>
					<w:pPr>
						<w:keepNext/>
						<w:spacing w:before="240" w:after="60"/>
						<w:outlineLvl w:val="2"/>
					</w:pPr>
					<w:rPr>
						<w:rFonts w:ascii="Arial" w:hAnsi="Arial" w:cs="Arial"/>
						<w:b/>
						<w:bCs/>
						<w:sz w:val="26"/>
						<w:szCs w:val="26"/>
					</w:rPr>
				</w:style>
				<w:style w:type="character" w:default="1" w:styleId="a0">
					<w:name w:val="Default Paragraph Font"/>
					<w:uiPriority w:val="1"/>
					<w:semiHidden/>
					<w:unhideWhenUsed/>
				</w:style>
				<w:style w:type="table" w:default="1" w:styleId="a1">
					<w:name w:val="Normal Table"/>
					<w:uiPriority w:val="99"/>
					<w:semiHidden/>
					<w:unhideWhenUsed/>
					<w:tblPr>
						<w:tblInd w:w="0" w:type="dxa"/>
						<w:tblCellMar>
							<w:top w:w="0" w:type="dxa"/>
							<w:left w:w="108" w:type="dxa"/>
							<w:bottom w:w="0" w:type="dxa"/>
							<w:right w:w="108" w:type="dxa"/>
						</w:tblCellMar>
					</w:tblPr>
				</w:style>
				<w:style w:type="numbering" w:default="1" w:styleId="a2">
					<w:name w:val="No List"/>
					<w:uiPriority w:val="99"/>
					<w:semiHidden/>
					<w:unhideWhenUsed/>
				</w:style>
				<w:style w:type="paragraph" w:styleId="a3">
					<w:name w:val="footer"/>
					<w:basedOn w:val="a"/>
					<w:link w:val="a4"/>
					<w:qFormat/>
					<w:pPr>
						<w:tabs>
							<w:tab w:val="center" w:pos="4153"/>
							<w:tab w:val="right" w:pos="8306"/>
						</w:tabs>
						<w:snapToGrid w:val="0"/>
					</w:pPr>
					<w:rPr>
						<w:sz w:val="18"/>
						<w:szCs w:val="18"/>
					</w:rPr>
				</w:style>
				<w:style w:type="paragraph" w:styleId="a5">
					<w:name w:val="header"/>
					<w:basedOn w:val="a"/>
					<w:link w:val="a6"/>
					<w:qFormat/>
					<w:pPr>
						<w:tabs>
							<w:tab w:val="center" w:pos="4153"/>
							<w:tab w:val="right" w:pos="8306"/>
						</w:tabs>
						<w:snapToGrid w:val="0"/>
						<w:jc w:val="center"/>
					</w:pPr>
					<w:rPr>
						<w:sz w:val="18"/>
						<w:szCs w:val="18"/>
					</w:rPr>
				</w:style>
				<w:style w:type="character" w:customStyle="1" w:styleId="a6">
					<w:name w:val="页眉 字符"/>
					<w:link w:val="a5"/>
					<w:qFormat/>
					<w:rPr>
						<w:sz w:val="18"/>
						<w:szCs w:val="18"/>
					</w:rPr>
				</w:style>
				<w:style w:type="character" w:customStyle="1" w:styleId="a4">
					<w:name w:val="页脚 字符"/>
					<w:link w:val="a3"/>
					<w:qFormat/>
					<w:rPr>
						<w:sz w:val="18"/>
						<w:szCs w:val="18"/>
					</w:rPr>
				</w:style>
			</w:styles>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/webSettings.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.webSettings+xml">
		<pkg:xmlData>
			<w:webSettings xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du"/>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/word/fontTable.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml">
		<pkg:xmlData>
			<w:fonts xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16sdtfl="http://schemas.microsoft.com/office/word/2024/wordml/sdtformatlock" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16sdtfl w16du">
				<w:font w:name="Times New Roman">
					<w:panose1 w:val="02020603050405020304"/>
					<w:charset w:val="00"/>
					<w:family w:val="roman"/>
					<w:pitch w:val="variable"/>
					<w:sig w:usb0="E0002EFF" w:usb1="C000785B" w:usb2="00000009" w:usb3="00000000" w:csb0="000001FF" w:csb1="00000000"/>
				</w:font>
				<w:font w:name="宋体">
					<w:altName w:val="SimSun"/>
					<w:panose1 w:val="02010600030101010101"/>
					<w:charset w:val="86"/>
					<w:family w:val="auto"/>
					<w:pitch w:val="variable"/>
					<w:sig w:usb0="00000203" w:usb1="288F0000" w:usb2="00000016" w:usb3="00000000" w:csb0="00040001" w:csb1="00000000"/>
				</w:font>
				<w:font w:name="等线">
					<w:altName w:val="DengXian"/>
					<w:panose1 w:val="02010600030101010101"/>
					<w:charset w:val="86"/>
					<w:family w:val="auto"/>
					<w:pitch w:val="variable"/>
					<w:sig w:usb0="A00002BF" w:usb1="38CF7CFA" w:usb2="00000016" w:usb3="00000000" w:csb0="0004000F" w:csb1="00000000"/>
				</w:font>
				<w:font w:name="Arial">
					<w:panose1 w:val="020B0604020202020204"/>
					<w:charset w:val="00"/>
					<w:family w:val="swiss"/>
					<w:pitch w:val="variable"/>
					<w:sig w:usb0="E0002EFF" w:usb1="C000785B" w:usb2="00000009" w:usb3="00000000" w:csb0="000001FF" w:csb1="00000000"/>
				</w:font>
				<w:font w:name="黑体">
					<w:altName w:val="SimHei"/>
					<w:panose1 w:val="02010609060101010101"/>
					<w:charset w:val="86"/>
					<w:family w:val="modern"/>
					<w:pitch w:val="fixed"/>
					<w:sig w:usb0="800002BF" w:usb1="38CF7CFA" w:usb2="00000016" w:usb3="00000000" w:csb0="00040001" w:csb1="00000000"/>
				</w:font>
				<w:font w:name="方正仿宋简体">
					<w:altName w:val="宋体"/>
					<w:charset w:val="86"/>
					<w:family w:val="roman"/>
					<w:pitch w:val="default"/>
				</w:font>
				<w:font w:name="等线 Light">
					<w:panose1 w:val="02010600030101010101"/>
					<w:charset w:val="86"/>
					<w:family w:val="auto"/>
					<w:pitch w:val="variable"/>
					<w:sig w:usb0="A00002BF" w:usb1="38CF7CFA" w:usb2="00000016" w:usb3="00000000" w:csb0="0004000F" w:csb1="00000000"/>
				</w:font>
			</w:fonts>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/docProps/core.xml" pkg:contentType="application/vnd.openxmlformats-package.core-properties+xml" pkg:padding="256">
		<pkg:xmlData>
			<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<dc:title/>
				<dc:subject/>
				<dc:creator>Administrator</dc:creator>
				<cp:keywords/>
				<cp:lastModifiedBy>KM33910</cp:lastModifiedBy>
				<cp:revision>2</cp:revision>
				<dcterms:created xsi:type="dcterms:W3CDTF">2025-09-03T02:15:00Z</dcterms:created>
				<dcterms:modified xsi:type="dcterms:W3CDTF">2025-09-03T02:15:00Z</dcterms:modified>
			</cp:coreProperties>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/docProps/app.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.extended-properties+xml" pkg:padding="256">
		<pkg:xmlData>
			<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
				<Template>Normal.dotm</Template>
				<TotalTime>0</TotalTime>
				<Pages>8</Pages>
				<Words>663</Words>
				<Characters>3782</Characters>
				<Application>Microsoft Office Word</Application>
				<DocSecurity>0</DocSecurity>
				<Lines>31</Lines>
				<Paragraphs>8</Paragraphs>
				<ScaleCrop>false</ScaleCrop>
				<Company/>
				<LinksUpToDate>false</LinksUpToDate>
				<CharactersWithSpaces>4437</CharactersWithSpaces>
				<SharedDoc>false</SharedDoc>
				<HyperlinksChanged>false</HyperlinksChanged>
				<AppVersion>16.0000</AppVersion>
			</Properties>
		</pkg:xmlData>
	</pkg:part>
	<pkg:part pkg:name="/docProps/custom.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.custom-properties+xml" pkg:padding="256">
		<pkg:xmlData>
			<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
				<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="2" name="KSOTemplateDocerSaveRecord">
					<vt:lpwstr>eyJoZGlkIjoiNGY1N2NmYmU0NDBlMDg2NjkyZDhiOTE2ZjA3ZmM4ZjkiLCJ1c2VySWQiOiIzMDI0MDk5MTYifQ==</vt:lpwstr>
				</property>
				<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="3" name="KSOProductBuildVer">
					<vt:lpwstr>2052-12.1.0.20784</vt:lpwstr>
				</property>
				<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="4" name="ICV">
					<vt:lpwstr>8B53838086444D90823A8DE1AED79053_12</vt:lpwstr>
				</property>
			</Properties>
		</pkg:xmlData>
	</pkg:part>
</pkg:package>