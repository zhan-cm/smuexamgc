package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.framework.GPT.generateDTO.QuestionGeneratedParam;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.WebFilePath;
import com.cx.kaoyi.framework.utils.WordReadTextWithFormulasAsHTML;
import org.apache.poi.xwpf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.transform.TransformerException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;

@Service("intelliQuestionService")
public class IntelliQuestionService extends BaseService {

    @Autowired
    private QuestionService questionService;

    private static String namespace = "resources.mappers.intelliQuestion";

    public String getQuestionAIID() {
        return queryOne(namespace + ".getQuestionAIID");
    }

    public String getAnswerAIID() {
        return queryOne(namespace + ".getAnswerAIID");
    }

    public List<Map<String,Object>> getGeneratedQuestionByCid(Map<String, Object> param, PageUtils pu){
        return query(namespace+".getGeneratedQuestionByCid",param,pu.getRb());
    }

    public int getGeneratedQuestionCountByCid(Map<String,Object> param){
        return queryOne(namespace + ".getGeneratedQuestionCountByCid", param);
    }

    public int deleteSelectedQuestionAI(List<Map<String,Object>> qidAndIsmainList){
        Set<String> qidSet = new HashSet<>();
        for(Map<String,Object> qidAndIsmain : qidAndIsmainList){
            String qid = qidAndIsmain.get("qid").toString();
            qidSet.add(qid);
            if("1".equals(qidAndIsmain.get("ismain").toString())){
                List<String> qidList = queryList(namespace + ".findQuestionAIListByMqid", qidAndIsmain);
                for(String qidChild : qidList){
                    qidSet.add(qidChild);
                }
            }
        }
        int rtn = delete(namespace+".deleteSelectedQuestionAI",qidSet);
        rtn += delete(namespace+".deleteSelectedAnswerAI",qidSet);
        return rtn;
    }

    public int delQuestionByQid(String qid, int ismain){
        int rtn = 0;
        if(ismain==1){
            Map<String,Object> qidAndIsmain = new HashMap<>();
            qidAndIsmain.put("qid", qid);
            List<String> qidList = queryList(namespace + ".findQuestionAIListByMqid", qidAndIsmain);
            for(String qidChild : qidList){
                rtn += delete(namespace+".deleteQuestionAIOne",qidChild);
                rtn += delete(namespace+".deleteAnswerAIOne",qidChild);
            }
        }
        rtn += delete(namespace+".deleteQuestionAIOne",qid);
        rtn += delete(namespace+".deleteAnswerAIOne",qid);
        return rtn;
    }

    public int insertQuestionAI(QuestionGeneratedParam question, List<Map<String,Object>> answer) {
        int rtn = insert(namespace+".insertQuestionAI",question);
        for(int i=0;i<answer.size();i++) {
            insert(namespace + ".insertAnswerAI", answer.get(i));
        }
        return rtn;
    }

    public int insertQuestionAIIntoFormal(Map<String,String> param){
        int rtn = 0;
        param.put("mqid", "");
        if(param.get("ismain")!=null && "1".equals(String.valueOf(param.get("ismain")))){
            Map<String,String> searchParam = new HashMap<>();
            searchParam.put("cid", param.get("cid"));
            searchParam.put("mqid", param.get("qid"));
            String mqid = questionService.getQuestionID();
            param.put("newQid",mqid);
            param.put("answerid","");
            rtn +=insert(namespace+".insertQuestionAIIntoFormal",param);
            Map<String,Object> map = new HashMap<>();
            map.put("state",1);
            map.put("qid",param.get("qid"));
            update(namespace+".updateQuestionAI",map);
            List<Map<String,Object>> questionIsconList = query(namespace+".getGeneratedQuestionByCid",searchParam);
            searchParam.put("mqid", mqid);
            for(Map<String,Object> question : questionIsconList){
                searchParam.put("qid", (String) question.get("qid"));
                searchParam.put("answerid", (String) question.get("answerid"));
                rtn += insertQuestionAIIntoFormalOne(searchParam);
            }
        }else{
            rtn += insertQuestionAIIntoFormalOne(param);
        }
        update("resources.mappers.question.call_updateCourseQuestioncount", param.get("cid"));
        return rtn;
    }

    public int insertQuestionAIIntoFormalOne(Map<String,String> param){
        List<Map<String,Object>> answerList = query(namespace+".selectAnswerAIByQID",param);
        String[] preAids = new String[answerList.size()];
        for(int i=0;i<answerList.size();i++){
            preAids[i] = (String) answerList.get(i).get("AID");
        }
        String[] preAnsId = param.get("answerid").split(",");
        StringBuilder newAnswerIdBuilder = new StringBuilder();
        String newQid = questionService.getQuestionID();
        for(int i=0;i<answerList.size();i++){
            Map<String, Object> preAns = answerList.get(i);
            String newAnsId = questionService.getAnswerID();
            preAns.put("QID",newQid);
            preAns.put("AID",newAnsId);
            for(String id : preAnsId){
                if(id.equals(preAids[i])){ //这里要用旧的id，因为原id已经变了
                    newAnswerIdBuilder.append(newAnsId+",");
                    break;
                }
            }
        }
        if(newAnswerIdBuilder.length()<=0){
            return -1;
        }
        param.put("answerid",newAnswerIdBuilder.substring(0,newAnswerIdBuilder.length()-1));
        param.put("newQid",newQid);
        int rtn = insert(namespace+".insertAnswerAIIntoFormal",answerList);
        rtn += insert(namespace+".insertQuestionAIIntoFormal",param);
        Map<String,Object> map = new HashMap<>();
        map.put("state",1);
        map.put("qid",param.get("qid"));
        update(namespace+".updateQuestionAI",map);
        return rtn;
    }

    public String getImportWordStringWithFormula(MultipartFile mFile, String cid){
        String qFileName = mFile.getOriginalFilename();
        Random random = new Random();
        String picUrl = WebFilePath.getRealPath();
        String qFilePath = "uploadFile/word/question/" + new Date().getTime() + qFileName;

        File qFile = new File(WebFilePath.getProjectPath() + qFilePath);
        if (qFile.exists()) {
            qFile.delete();
        }
        qFile.getParentFile().mkdirs();
        String pathToImage=picUrl + "/kaoyi_upload/"+cid+"/";
        String nginxFileDirName = WebFilePath.getNginxRoot()+"kaoyi_upload/"+cid+"/";
        File pathToImageDir = new File(pathToImage);
        File nginxFileDir = new File(nginxFileDirName);
        if(!pathToImageDir.exists()){
            pathToImageDir.mkdirs();
        }
        if(!nginxFileDir.exists()){
            nginxFileDir.mkdirs();
        }
        try {
            mFile.transferTo(qFile);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try(FileInputStream is = new FileInputStream(qFile);
            XWPFDocument doc = new XWPFDocument(is)) {
            Iterator<IBodyElement> iter = doc.getBodyElementsIterator();
            StringBuilder conSB=new StringBuilder();
            while (iter.hasNext()) {
                IBodyElement element = iter.next();
                String filePath="";
                if (element instanceof XWPFParagraph) {
                    XWPFParagraph para = (XWPFParagraph) element;
                    List<XWPFRun> runsLists = para.getRuns();
                    for (XWPFRun run : runsLists) {
                        List<XWPFPicture> pictures = run.getEmbeddedPictures();
                        if (pictures.size() > 0) {
                            XWPFPicture picture = pictures.get(0);
                            XWPFPictureData pictureData = picture.getPictureData();
                            byte[] bytev = pictureData.getData();
                            if (bytev.length > 300) {
                                String fileName=pictureData.getFileName();
                                String suffix=fileName.substring(fileName.lastIndexOf(".")+1);
                                String imgName=System.currentTimeMillis()+random.nextInt(1000)+"";
                                String nowName=imgName+ "."+suffix;
                                FileOutputStream fos1 = new FileOutputStream(pathToImage+nowName);
                                fos1.write(bytev);
                                fos1.close();
                                Map<String, String> picRtn = null;
                                if("emf".equalsIgnoreCase(suffix)) {
                                    WordReadTextWithFormulasAsHTML.emfToPng(pathToImage+nowName, pathToImage+imgName+".png");
                                    nowName=imgName+ ".png";
                                    File emf=new File(pathToImage+imgName+"."+suffix);
                                    emf.delete();
                                }else if("tif".equalsIgnoreCase(suffix) || "tiff".equalsIgnoreCase(suffix)){
                                    WordReadTextWithFormulasAsHTML.localHardPicToPngWithGraphicsMagick(pathToImage+nowName, pathToImage+imgName+".png");
                                    nowName=imgName+ ".png";
                                    File emf=new File(pathToImage+imgName+"."+suffix);
                                    emf.delete();
                                }else if("wmf".equalsIgnoreCase(suffix)){
                                    picRtn = WordReadTextWithFormulasAsHTML.convertWmf(pathToImage+nowName);
                                    nowName=imgName+ picRtn.get("suffix");
                                    File emf=new File(pathToImage+imgName+"."+suffix);
                                    emf.delete();
                                }

                                filePath="/kaoyi_upload/"+cid+"/"+nowName;
                                Files.copy(Paths.get(picUrl+filePath), Paths.get(nginxFileDirName+nowName), StandardCopyOption.REPLACE_EXISTING);
                                if(picRtn!=null && !StringUtils.isEmpty(picRtn.get("wPx")) && !StringUtils.isEmpty(picRtn.get("hPx"))){
                                    conSB.append("<img src='"+filePath+"' style='width: "+picRtn.get("wPx")+"px;height:"+picRtn.get("hPx")+"px;'/>");
                                }else{
                                    conSB.append("<img src='"+filePath+"' style='max-width: 1000px;max-height:650px;'/>");
                                }
                            }
                        }else{
                            Node runNode = run.getCTR().getDomNode();
                            conSB.append(WordReadTextWithFormulasAsHTML.getText(runNode)); //纯文本内容
                            Node parentNode = run.getCTR().getDomNode().getParentNode();
                            if (parentNode.getNodeName().equals("w:p")) {
                                // 遍历 w:p 节点下的所有子节点
                                NodeList childNodes = parentNode.getChildNodes();
                                // 查找当前 w:r 节点的位置
                                for (int i = 0; i < childNodes.getLength(); i++) {
                                    Node childNode = childNodes.item(i);
                                    if (childNode == run.getCTR().getDomNode()) {
                                        if (i + 1 < childNodes.getLength()) { //只找同级w:r的下一级节点
                                            Node nextSibling = childNodes.item(i + 1);
                                            if (nextSibling.getNodeName().equals("m:oMath")) {
                                                String svgFileName = new Date().getTime()+".svg";
                                                String latexEncode = WordReadTextWithFormulasAsHTML.extractLatexFromNode(nextSibling,picUrl+"/kaoyi_upload/"+cid+"/"+svgFileName);
                                                if(!StringUtils.isEmpty(latexEncode)){
                                                    //conSB.append("<img src='/kaoyi_upload/"+cid+"/"+svgFileName+"' data-formula-image='"+latexEncode+"' style='height:32px;height:auto; width:auto;'/>");
                                                    conSB.append("<img src='/kaoyi_upload/"+cid+"/"+svgFileName+"' style='height:32px;'/>");//现在是不把latex信息写入内容的版本，上面写入进去，如果在答案中内容会过长，但是以后可修改latex
                                                    Path sourcePath = Paths.get(picUrl, "kaoyi_upload", cid, svgFileName);
                                                    Path targetPath = Paths.get(nginxFileDirName, svgFileName);
                                                    Files.copy(sourcePath, targetPath, StandardCopyOption.REPLACE_EXISTING);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Map<String,String> smallImageRtn = WordReadTextWithFormulasAsHTML.getSmallImage(run, runNode,picUrl + "/kaoyi_upload/"+cid);
                            String imgPath = smallImageRtn.get("rtnName");
                            if(!StringUtils.isEmpty(imgPath)){
                                Path rtnPicPath = Paths.get(pathToImage+imgPath);
                                //复制给nginx
                                Files.copy(rtnPicPath, Paths.get(nginxFileDirName+rtnPicPath.getFileName().toString()), StandardCopyOption.REPLACE_EXISTING);
                                if(smallImageRtn.get("wPx")!=null && smallImageRtn.get("hPx")!=null){
                                    conSB.append("<img src='/kaoyi_upload/"+cid+"/"+imgPath+"' style='height:"+smallImageRtn.get("hPx")+"px;width:"+smallImageRtn.get("wPx")+"px'/>");
                                }else{
                                    conSB.append("<img src='/kaoyi_upload/"+cid+"/"+imgPath+"' style='max-height:32px;'/>");
                                }
                            }
                        }
                    }
                    conSB.append("\n");
                }
                conSB.append("\n\n");
            }
            return conSB.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, BigDecimal> getAIQuestionUsedStatus(String cid){
        List<Map<String, BigDecimal>> list = queryList(namespace + ".getAIQuestionUsedStatus", cid);
        if(list==null || list.isEmpty()){
            return new HashMap<>();
        }
        return list.get(0);
    }
}