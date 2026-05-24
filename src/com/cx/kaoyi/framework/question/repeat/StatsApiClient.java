package com.cx.kaoyi.framework.question.repeat;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONException;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.question.dto.DuplicatePairDTO;
import com.cx.kaoyi.framework.question.dto.QuestionStatDto;
import com.cx.kaoyi.framework.question.dto.RepeatABRate;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.serialize.FastJsonTypeRefs;
import okhttp3.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Component
public class StatsApiClient {

    private static final Logger logger = LoggerFactory.getLogger(StatsApiClient.class);

    private final OkHttpClient client = HttpClientHolder.
            getClientWithTimeout(10,20,20);

    @Value("${stats.baseUrl:}")
    private String baseUrl;
    @Value("${stats.apiKey:}")
    private String apiKey;
    @Value("${openFindRepeatSystem:0}")
    private Integer openFindRepeatSystem;

    public RepeatABRate checkRepeatInfo(String eid, String bid) {
        if(openFindRepeatSystem==0 || StringUtils.isAnyBlank(apiKey, baseUrl)){
            return null;
        }

        FormBody.Builder builder = new FormBody.Builder()
                .add("eid", eid);

        if (StringUtils.isNotBlank(bid)) builder.add("bid", bid);

        RequestBody body = builder.build();

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/checkRepeatInfo")
                .post(body)
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                logger.info("查重系统请求失败：eid：{}，HTTP {} {}", eid, resp.code(), resp.message());
                return null;
            }
            if(resp==null) return null;
            String resJson = resp.body() != null ? resp.body().string() : "";
            if(resJson==null || resJson.isEmpty() || !JSON.isValid(resJson)){
                logger.info("查重系统请求失败，返回值不正常：eid：{}", eid);
                return null;
            }
            return JSON.parseObject(resJson, FastJsonTypeRefs.REPEAT_AB_RATE_REFS);
        } catch (IOException e) {
            logger.info("查重系统请求失败，IO错误：", e);
            return null;
        } catch (JSONException e){
            logger.info("查重系统请求失败，格式解析错误：", e);
            return null;
        }
    }

    public Map<String, QuestionStatDto> queryDedupStatsMapByExam(String eid) {
        if(openFindRepeatSystem==0 || StringUtils.isAnyBlank(apiKey, baseUrl)){
            return Collections.emptyMap();
        }
        RequestBody body = new FormBody.Builder()
                .add("eid", eid)
                .build();

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/queryDedupStatsMapByExam")
                .post(body)
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                logger.info("查重系统请求失败：eid：{}，HTTP {} {}", eid, resp.code(), resp.message());
                return Collections.emptyMap();
            }
            if(resp==null) return Collections.emptyMap();
            String resJson = resp.body() != null ? resp.body().string() : "";
            if(resJson==null || resJson.isEmpty() || !JSON.isValid(resJson)){
                logger.info("查重系统请求失败，返回值不正常：eid：{}", eid);
                return Collections.emptyMap();
            }
            return JSON.parseObject(resJson, FastJsonTypeRefs.QUESTIONSTATDTO_MAP_REFS);
        } catch (IOException e) {
            logger.info("查重系统请求失败，IO错误：", e);
            return Collections.emptyMap();
        } catch (JSONException e){
            logger.info("查重系统请求失败，格式解析错误：", e);
            return Collections.emptyMap();
        }
    }

    public Map<String, QuestionStatDto> queryDedupStatsMapByQids(String eid, List<String> qids) {
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl)) {
            return Collections.emptyMap();
        }

        FormBody.Builder form = new FormBody.Builder()
                .add("eid", eid);

        for (String qid : qids) {
            if(StringUtils.isBlank(qid)) continue;
            form.add("qids", qid);
        }

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/queryDedupStatsMapByQids") // 注意路径要对上你 controller 的 mapping
                .post(form.build())
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                return Collections.emptyMap();
            }
            String resJson = resp.body() != null ? resp.body().string() : "";
            if (resJson.isEmpty() || !JSON.isValid(resJson)) {
                return Collections.emptyMap();
            }
            return JSON.parseObject(resJson, FastJsonTypeRefs.QUESTIONSTATDTO_MAP_REFS);
        } catch (IOException | JSONException e) {
            return Collections.emptyMap();
        }
    }

    public Map<String, List<DuplicatePairDTO>> statsDetailByExam(String eid, String bid) {
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl) || !Utils.isNumeric(eid)) {
            return Collections.emptyMap();
        }

        FormBody.Builder form = new FormBody.Builder()
                .add("eid", eid);

        if (StringUtils.isNotBlank(bid)) form.add("bid", bid);

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/statsDetailByExam") // 注意路径要对上你 controller 的 mapping
                .post(form.build())
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                return Collections.emptyMap();
            }
            String resJson = resp.body() != null ? resp.body().string() : "";
            if (resJson.isEmpty() || !JSON.isValid(resJson)) {
                return Collections.emptyMap();
            }
            return JSON.parseObject(resJson, FastJsonTypeRefs.DUP_LIST_MAP_REFS);
        } catch (IOException | JSONException e) {
            return Collections.emptyMap();
        }
    }

    public List<DuplicatePairDTO> statsDetailByQid(String eid, String qid, String fromPaper){
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl) || !Utils.isNumeric(eid)) {
            return Collections.emptyList();
        }

        FormBody.Builder form = new FormBody.Builder()
                .add("qid", qid)
                .add("fromPaper", fromPaper);

        if (StringUtils.isNotBlank(eid)) form.add("eid", eid);

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/statsDetailByQid") // 注意路径要对上你 controller 的 mapping
                .post(form.build())
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                return Collections.emptyList();
            }
            String resJson = resp.body() != null ? resp.body().string() : "";
            if (resJson.isEmpty() || !JSON.isValid(resJson)) {
                return Collections.emptyList();
            }
            return JSON.parseArray(resJson, DuplicatePairDTO.class);
        } catch (IOException | JSONException e) {
            return Collections.emptyList();
        }
    }

    // =========================
    // 新增：上传 HTML，让系统2转 PDF 并保存
    // 返回：1=成功，0=失败
    // =========================
    public int uploadHtmlAsPdf(String eid, String filename, String html) {
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl)) {
            return 0;
        }
        if (StringUtils.isBlank(eid) || StringUtils.isBlank(filename) || StringUtils.isBlank(html)) {
            logger.info("上传HTML失败，参数非法：eid={}, filename={}", eid, filename);
            return 0;
        }

        RequestBody body = new MultipartBody.Builder()
                .setType(MultipartBody.FORM)
                .addFormDataPart("eid", eid)
                .addFormDataPart("filename", filename)
                .addFormDataPart("html", html)
                .build();

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/uploadHtmlAsPdf")
                .post(body)
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                logger.info("上传HTML失败：eid={}, filename={}, HTTP {} {}",
                        eid, filename, resp.code(), resp.message());
                return 0;
            }

            String res = resp.body() != null ? resp.body().string() : "";
            return "1".equals(res == null ? "" : res.trim()) ? 1 : 0;
        } catch (IOException e) {
            logger.info("上传HTML失败，IO错误：eid={}, filename={}", eid, filename, e);
            return 0;
        } catch (Exception e) {
            logger.info("上传HTML失败，未知错误：eid={}, filename={}", eid, filename, e);
            return 0;
        }
    }

    // =========================
    // 新增：确认系统2文件是否存在
    // 返回：
    //  1 = 存在
    //  0 = 不存在
    // -1 = 系统繁忙（读锁没拿到）
    // -2 = 参数非法
    // -9 = 请求失败/返回异常
    // =========================
    public int pdfExists(String eid, String filename) {
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl)) {
            return -9;
        }
        if (StringUtils.isBlank(eid) || StringUtils.isBlank(filename)) {
            return -2;
        }

        RequestBody body = new FormBody.Builder()
                .add("eid", eid)
                .add("filename", filename)
                .build();

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/pdfExists")
                .post(body)
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (!resp.isSuccessful()) {
                logger.info("检查文件存在失败：eid={}, filename={}, HTTP {} {}",
                        eid, filename, resp.code(), resp.message());
                return -9;
            }

            String res = resp.body() != null ? resp.body().string() : "";
            return Utils.changeObjToInt(res, -9);
        } catch (IOException e) {
            logger.info("检查文件存在失败，IO错误：eid={}, filename={}", eid, filename, e);
            return -9;
        } catch (Exception e) {
            logger.info("检查文件存在失败，未知错误：eid={}, filename={}", eid, filename, e);
            return -9;
        }
    }

    // =========================
    // 新增：从系统2下载 PDF
    // 返回：
    //  成功 -> byte[]
    //  失败/繁忙/不存在 -> null
    // =========================
    public byte[] downloadPdfBytes(String eid, String filename) {
        if (openFindRepeatSystem == 0 || StringUtils.isAnyBlank(apiKey, baseUrl)) {
            return null;
        }
        if (StringUtils.isBlank(eid) || StringUtils.isBlank(filename)) {
            return null;
        }

        RequestBody body = new FormBody.Builder()
                .add("eid", eid)
                .add("filename", filename)
                .build();

        Request request = new Request.Builder()
                .url(baseUrl + "/repeat/downloadPdf")
                .post(body)
                .addHeader("X-Api-Key", apiKey)
                .build();

        try (Response resp = client.newCall(request).execute()) {
            if (resp.code() == 423) {
                logger.info("下载PDF失败：系统繁忙，eid={}, filename={}", eid, filename);
                return null;
            }
            if (resp.code() == 404) {
                logger.info("下载PDF失败：文件不存在，eid={}, filename={}", eid, filename);
                return null;
            }
            if (!resp.isSuccessful()) {
                logger.info("下载PDF失败：eid={}, filename={}, HTTP {} {}",
                        eid, filename, resp.code(), resp.message());
                return null;
            }
            return resp.body() != null ? resp.body().bytes() : null;
        } catch (IOException e) {
            logger.info("下载PDF失败，IO错误：eid={}, filename={}", eid, filename, e);
            return null;
        } catch (Exception e) {
            logger.info("下载PDF失败，未知错误：eid={}, filename={}", eid, filename, e);
            return null;
        }
    }
}
