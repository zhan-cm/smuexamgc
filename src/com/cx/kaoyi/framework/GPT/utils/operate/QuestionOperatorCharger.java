package com.cx.kaoyi.framework.GPT.utils.operate;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.cx.kaoyi.framework.GPT.NormalDTO.Message;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;
import com.cx.kaoyi.framework.GPT.generateDTO.payload.AIPayloadV2;
import com.cx.kaoyi.framework.GPT.operationDTO.business.QuestionIntelliEditAction;
import com.cx.kaoyi.framework.GPT.utils.AIUtils;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.serialize.KryoPoolUtils;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Entities;
import org.jsoup.nodes.TextNode;
import org.jsoup.select.NodeTraversor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 题目处理器：
 * 1) 翻译题目
 * 2) 优化题目格式
 * 3) 出类似题目
 *
 * 依赖：
 * - 你现有的 GeneratedQuestion / MainGeneratedQuestion
 * - 你现有的 CorrectAPIConfig / HttpClientHolder
 * - okhttp
 * - fastjson
 * - commons-lang3
 */
public class QuestionOperatorCharger {

    private static final OkHttpClient CLIENT = HttpClientHolder.getClientWithTimeout(15, 120, 120);
    private static final MediaType MEDIA_TYPE = MediaType.get("application/json; charset=utf-8");

    private static final Logger logger = LoggerFactory.getLogger(QuestionOperatorCharger.class);

    /**
     * 当 answerList 原本为空，但“优化题目格式”需要从 content 中拆出选项时，
     * 默认新建的 map key 使用这两个名字。
     * 如果你前端固定用别的 key，比如 option/content、key/value，可改这里。
     */
    private static final String DEFAULT_OPTION_LABEL_KEY = "label";
    private static final String DEFAULT_OPTION_CONTENT_KEY = "content";

    /**
     * 多媒体/嵌入类标签：先占位，避免模型改坏。
     */
    private static final Pattern MEDIA_TAG_PATTERN = Pattern.compile(
            "(?is)"
                    + "<video\\b[^>]*?>.*?</video>"
                    + "|<audio\\b[^>]*?>.*?</audio>"
                    + "|<iframe\\b[^>]*?>.*?</iframe>"
                    + "|<object\\b[^>]*?>.*?</object>"
                    + "|<embed\\b[^>]*?/?>"
                    + "|<img\\b[^>]*?/?>"
                    + "|<source\\b[^>]*?/?>"
                    + "|<track\\b[^>]*?/?>"
    );

    // =========================
    // 对外入口
    // =========================

    public static GeneratedQuestion translateQuestion(GeneratedQuestion question, int retryTime) {
        return processQuestion(question, QuestionIntelliEditAction.TRANSLATE, retryTime, GeneratedQuestion.class);
    }

    public static MainGeneratedQuestion translateQuestion(MainGeneratedQuestion question, int retryTime) {
        return processQuestion(question, QuestionIntelliEditAction.TRANSLATE, retryTime, MainGeneratedQuestion.class);
    }

    public static GeneratedQuestion generateSimilarQuestion(GeneratedQuestion question, int retryTime) {
        return processQuestion(question, QuestionIntelliEditAction.GENERATE_SIMILAR, retryTime, GeneratedQuestion.class);
    }

    public static MainGeneratedQuestion generateSimilarQuestion(MainGeneratedQuestion question, int retryTime) {
        return processQuestion(question, QuestionIntelliEditAction.GENERATE_SIMILAR, retryTime, MainGeneratedQuestion.class);
    }

    /**
     * 通用入口，传什么类就返回什么类
     */
    public static Object handleQuestion(Object question, QuestionIntelliEditAction action, int retryTime) {
        if (question instanceof GeneratedQuestion) {
            return processQuestion((GeneratedQuestion) question, action, retryTime, GeneratedQuestion.class);
        }
        if (question instanceof MainGeneratedQuestion) {
            return processQuestion((MainGeneratedQuestion) question, action, retryTime, MainGeneratedQuestion.class);
        }
        return null;
    }

    // =========================
    // 核心处理
    // =========================

    private static <T> T processQuestion(T originalQuestion, QuestionIntelliEditAction action, int retryTime, Class<T> clazz) {
        if (originalQuestion == null) {
            return null;
        }

        String url = "https://spark-api-open.xf-yun.com/agent/v1/chat/completions";
        String model = "ernie-4.5-turbo-32k";

        // 1) 原题转 JSON
        String originalJson = JSON.toJSONString(originalQuestion);

        // 2) 保护多媒体标签，避免模型改坏
        MediaPlaceholderContext mediaContext = new MediaPlaceholderContext();
        String protectedJson = mediaContext.protect(originalJson);

        // 3) 构造提示词
        String systemPrompt = buildSystemPrompt(action);
        String userPrompt = buildUserPrompt(clazz, protectedJson);

        // 4) 发请求
        AIPayloadV2 payload = new AIPayloadV2();
        payload.setModel(model);
        payload.getResponseFormat().setType("text");
        payload.setTemperature(0.75f);
        payload.setMaxCompletionTokens(8192);

        List<Message> messages = new ArrayList<>();

        Message systemMessage = new Message();
        systemMessage.setRole("system");
        systemMessage.setContent(systemPrompt);
        messages.add(systemMessage);

        Message userMessage = new Message();
        userMessage.setRole("user");
        userMessage.setContent(userPrompt);
        messages.add(userMessage);

        payload.setMessages(messages);

        String requestJson = JSON.toJSONString(payload);
        RequestBody body = RequestBody.create(requestJson, MEDIA_TYPE);
        Request request = new Request.Builder()
                .url(url)
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + QuestionGeneratorConfig.getAPIKeyV2())
                .post(body)
                .build();

        try (Response response = CLIENT.newCall(request).execute()) {
            if (response.body() == null) {
                return null;
            }

            String rawResponse = response.body().string();
            Map<String, Object> responseMap = JSONObject.parseObject(rawResponse, LinkedHashMap.class);

            if (responseMap.get("error") != null) {
                logger.info("AI服务器报错：" + responseMap.get("error"));
                return null;
            }

            Object choicesObj = responseMap.get("choices");
            if (!(choicesObj instanceof JSONArray) || ((JSONArray) choicesObj).isEmpty()) {
                logger.info("choices 为空");
                return null;
            }

            JSONObject choice = ((JSONArray) choicesObj).getJSONObject(0);
            if (choice == null || !choice.containsKey("message")) {
                logger.info("message 字段缺失");
                return null;
            }

            JSONObject messageObj = choice.getJSONObject("message");
            if (messageObj == null || !messageObj.containsKey("content")) {
                logger.info("content 字段缺失");
                return null;
            }

            String modelContent = messageObj.getString("content");
            String pureJson = AIUtils.findJson(AIUtils.replaceMarkDownJson(modelContent));

            // 先还原多媒体占位，再 parse
            pureJson = mediaContext.restore(pureJson);

            T result = JSONObject.parseObject(pureJson, clazz);
            if (result == null) {
                logger.info("AI返回结果无法解析为 " + clazz.getSimpleName());
                return null;
            }

            // 5) 后处理：富文本文本转义、结构校验、补齐必要字段
            normalizeAndValidateResult(originalQuestion, result, action);

            return result;

        } catch (IOException e) {
            if (retryTime > 0 && e instanceof SocketTimeoutException) {
                return processQuestion(originalQuestion, action, retryTime - 1, clazz);
            }
            if (e instanceof SocketTimeoutException) {
                logger.info("输出超时", e);
            }
            if (e instanceof InterruptedIOException) {
                logger.info("任务被中断", e);
            }
            if (e instanceof UnknownHostException) {
                logger.info("AI服务器无法连接", e);
            }
            logger.info("AI请求失败：" + e.getMessage(), e);
        } catch (JSONException e) {
            if (retryTime > 0) {
                return processQuestion(originalQuestion, action, retryTime - 1, clazz);
            }
            logger.info("AI响应格式有误", e);
        } catch (Exception e) {
            if (retryTime > 0) {
                return processQuestion(originalQuestion, action, retryTime - 1, clazz);
            }
            logger.info("AI响应错误：" + e.getClass().getSimpleName(), e);
        }
        return null;
    }

    // =========================
    // 提示词
    // =========================

    private static String buildSystemPrompt(QuestionIntelliEditAction action) {
        StringBuilder sb = new StringBuilder();

        sb.append("你是“题目处理助手”。你只允许输出一个合法JSON对象，不允许输出代码块、解释、前后缀、备注。\n");
        sb.append("输入一定是题目对象的JSON，根对象类型只可能是 GeneratedQuestion 或 MainGeneratedQuestion。\n");
        sb.append("你必须严格遵守以下规则：\n");
        sb.append("1. 返回根对象类型必须与输入完全一致：输入是 GeneratedQuestion 就返回 GeneratedQuestion；输入是 MainGeneratedQuestion 就返回 MainGeneratedQuestion。\n");
        sb.append("2. 字段名必须完全一致，不得新增、删除、重命名字段。\n");
        sb.append("3. qtype 必须保留输入值，不要翻译，不要改成别的题型。\n");
        sb.append("4. 若输入是 MainGeneratedQuestion，则 questionList 数量必须与输入一致，不得增减子题数量。\n");
        sb.append("5. 如果字符串中出现形如 ___MEDIA_TAG_n___ 的占位符，它代表原始图片/音频/视频/嵌入标签。你必须原样保留这些占位符，不能修改、不能删除、不能新增、不能拆分。\n");
        sb.append("6. 所有富文本/HTML标签允许保留；但真正属于文本内容的字符必须做HTML实体转义：< 转 &lt;，> 转 &gt;，& 转 &amp;，双引号转 &quot;，单引号转 &#39;。\n");
        sb.append("7. 不要把文本写进标签名或标签属性；不要把已有实体再解码成原字符。\n");
        sb.append("8. 输出必须是合法JSON，所有双引号、反斜杠、换行都要正确转义。\n");
        sb.append("9. answerList 如果原本存在，尽量保持每个 option map 的 key 结构与顺序一致。\n");
        sb.append("10. 若原题无多媒体资源，就不要凭空新增多媒体标签。\n");

        switch (action) {
            case TRANSLATE:
                sb.append("\n【本次操作：翻译题目】\n");
                sb.append("A. 仅翻译给用户看的自然语言文本，包括 content、answer、explain、answerList 里的选项文本。\n");
                sb.append("B. 不翻译 qtype；不改变字段结构；不改变题目含义；不改变答案对应关系。\n");
                sb.append("C. 所有标签、标签属性、多媒体占位符必须保持原样。\n");
                sb.append("D. 由你自行判断目标语言：如果题目主体语言是中文，则翻译为英文；如果题目主体语言不是中文，则统一翻译为简体中文。\n");
                sb.append("E. 如果输入中出现多语言混合内容，以题目主体语言和主要服务对象为准决定翻译方向；专有名词、公式、固定缩写、单位、专门术语可按常规保留或做最合适的对应翻译。\n");
                break;

            case GENERATE_SIMILAR:
                sb.append("\n【本次操作：出类似题目】\n");
                sb.append("A. 生成一题或一组“类似但不相同”的新题，要求题型相同、难度接近、考点相近、答案与解析自洽。\n");
                sb.append("B. 若输入是 MainGeneratedQuestion，必须保留 questionList 的子题数量，并为每个子题生成新的 content、answer、answerList、explain。\n");
                sb.append("C. 若原题存在 answerList，新题应尽量保持相近的选项数量与作答形式。\n");
                sb.append("D. 若输入中存在 ___MEDIA_TAG_n___，新题不得脱离这些媒体资源可支撑的范围，并且这些占位符必须原样保留。\n");
                sb.append("E. 允许重新组织文案与样式，但返回字段结构必须一致，qtype 不变。\n");
                break;

            default:
                throw new IllegalArgumentException("未知操作类型");
        }

        sb.append("\n你最终只能输出处理后的JSON对象本身。");
        return sb.toString();
    }

    private static String buildUserPrompt(Class<?> clazz, String protectedJson) {
        StringBuilder sb = new StringBuilder();
        sb.append("输入对象类型：").append(clazz.getSimpleName()).append("\n");
        sb.append("请直接返回处理后的 JSON，不要输出其他内容。\n");
        sb.append("输入 JSON 如下：\n");
        sb.append(protectedJson);
        return sb.toString();
    }

    // =========================
    // 后处理与校验
    // =========================

    private static void normalizeAndValidateResult(Object originalQuestion, Object resultQuestion, QuestionIntelliEditAction action) {
        if (resultQuestion instanceof GeneratedQuestion && originalQuestion instanceof GeneratedQuestion) {
            normalizeGeneratedQuestion((GeneratedQuestion) resultQuestion,
                    (GeneratedQuestion) originalQuestion, action);
            validateGeneratedQuestion((GeneratedQuestion) resultQuestion,
                    (GeneratedQuestion) originalQuestion, action);
            return;
        }

        if (resultQuestion instanceof MainGeneratedQuestion && originalQuestion instanceof MainGeneratedQuestion) {
            normalizeMainGeneratedQuestion((MainGeneratedQuestion) resultQuestion,
                    (MainGeneratedQuestion) originalQuestion, action);
            validateMainGeneratedQuestion((MainGeneratedQuestion) resultQuestion,
                    (MainGeneratedQuestion) originalQuestion, action);
            return;
        }
    }

    private static void normalizeGeneratedQuestion(GeneratedQuestion result,
                                                   GeneratedQuestion original,
                                                   QuestionIntelliEditAction action) {
        if (result == null) {
            return;
        }

        // qtype 一律保留原值
        result.setQtype(original.getQtype());

        // 文本字段：保留标签、转义文本节点
        result.setContent(normalizeRichText(result.getContent()));
        result.setAnswer(normalizeRichText(result.getAnswer()));
        result.setExplain(normalizeRichText(result.getExplain()));
        result.setAnswerList(normalizeAnswerList(result.getAnswerList()));

        // 翻译/格式优化：若模型漏字段，尽量补回原内容，避免丢题
        if (action != QuestionIntelliEditAction.GENERATE_SIMILAR) {
            if (StringUtils.isBlank(result.getContent())) {
                result.setContent(normalizeRichText(original.getContent()));
            }
            if (StringUtils.isBlank(result.getAnswer())) {
                result.setAnswer(normalizeRichText(original.getAnswer()));
            }
            if (StringUtils.isBlank(result.getExplain())) {
                result.setExplain(normalizeRichText(original.getExplain()));
            }
            if ((result.getAnswerList() == null || result.getAnswerList().isEmpty())
                    && original.getAnswerList() != null && !original.getAnswerList().isEmpty()) {
                result.setAnswerList(KryoPoolUtils.deepCopy(original.getAnswerList()));
                result.setAnswerList(normalizeAnswerList(result.getAnswerList()));
            }
        }
    }

    private static void normalizeMainGeneratedQuestion(MainGeneratedQuestion result,
                                                       MainGeneratedQuestion original,
                                                       QuestionIntelliEditAction action) {
        if (result == null) {
            logger.info("返回的题组为空");
            return;
        }

        result.setQtype(original.getQtype());
        result.setContent(normalizeRichText(result.getContent()));

        if (action != QuestionIntelliEditAction.GENERATE_SIMILAR && StringUtils.isBlank(result.getContent())) {
            result.setContent(normalizeRichText(original.getContent()));
        }

        if (result.getQuestionList() == null) {
            result.setQuestionList(new ArrayList<>());
        }

        // questionList 数量必须一致
        int originalSize = original.getQuestionList() == null ? 0 : original.getQuestionList().size();
        int resultSize = result.getQuestionList().size();
        if (originalSize != resultSize) {
            throw new IllegalStateException("questionList 数量不一致，期望 " + originalSize + "，实际 " + resultSize);
        }

        for (int i = 0; i < result.getQuestionList().size(); i++) {
            GeneratedQuestion resultSub = result.getQuestionList().get(i);
            GeneratedQuestion originalSub = original.getQuestionList().get(i);
            normalizeGeneratedQuestion(resultSub, originalSub, action);
        }
    }

    private static void validateGeneratedQuestion(GeneratedQuestion result,
                                                  GeneratedQuestion original,
                                                  QuestionIntelliEditAction action) {
        if (result == null) {
            throw new IllegalStateException("返回题目为空");
        }
        if (StringUtils.isBlank(result.getContent())) {
            throw new IllegalStateException("content 不能为空");
        }

        if (action == QuestionIntelliEditAction.GENERATE_SIMILAR) {
            if (StringUtils.isBlank(result.getAnswer())
                    && (result.getAnswerList() == null || result.getAnswerList().isEmpty())) {
                throw new IllegalStateException("类似题缺少答案信息");
            }
        }

        if (original.getAnswerList() != null && !original.getAnswerList().isEmpty()) {
            if (result.getAnswerList() == null || result.getAnswerList().isEmpty()) {
                throw new IllegalStateException("返回题目缺少 answerList");
            }
            if (action == QuestionIntelliEditAction.GENERATE_SIMILAR
                    && result.getAnswerList().size() != original.getAnswerList().size()) {
                throw new IllegalStateException("类似题 answerList 数量与原题不一致");
            }
        }
    }

    private static void validateMainGeneratedQuestion(MainGeneratedQuestion result,
                                                      MainGeneratedQuestion original,
                                                      QuestionIntelliEditAction action) {
        if (result == null) {
            throw new IllegalStateException("返回题组为空");
        }
        if (StringUtils.isBlank(result.getQtype())) {
            throw new IllegalStateException("题组 qtype 不能为空");
        }
        if (StringUtils.isBlank(result.getContent())) {
            throw new IllegalStateException("题组 content 不能为空");
        }

        if (original.getQuestionList() != null) {
            if (result.getQuestionList() == null) {
                throw new IllegalStateException("questionList 不能为空");
            }
            if (result.getQuestionList().size() != original.getQuestionList().size()) {
                throw new IllegalStateException("questionList 数量不一致");
            }
        }

        if (result.getQuestionList() != null) {
            for (int i = 0; i < result.getQuestionList().size(); i++) {
                validateGeneratedQuestion(result.getQuestionList().get(i),
                        original.getQuestionList().get(i), action);
            }
        }
    }

    // =========================
    // 工具：answerList 处理
    // =========================

    private static List<Map<String, String>> normalizeAnswerList(List<Map<String, String>> answerList) {
        if (answerList == null) {
            return null;
        }

        List<Map<String, String>> result = new ArrayList<>();
        for (Map<String, String> optionMap : answerList) {
            if (optionMap == null) {
                continue;
            }
            Map<String, String> newMap = new LinkedHashMap<>();
            for (Map.Entry<String, String> entry : optionMap.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                newMap.put(key, normalizeRichText(value));
            }
            result.add(newMap);
        }
        return result;
    }

    /**
     * 对富文本做“保留标签，仅规范文本节点转义”。
     * 注意：
     * 1. 媒体标签先占位，最后原样还原，避免被 jsoup 规范化
     * 2. 其他标签会被 jsoup 解析并重新序列化，因此“语义保留”，不是“逐字符保留”
     */
    public static String normalizeRichText(String input) {
        if (input == null) {
            return null;
        }
        if (input.isEmpty()) {
            return input;
        }

        MediaPlaceholderContext mediaContext = new MediaPlaceholderContext();
        String protectedHtml = mediaContext.protect(input);

        Document doc = Jsoup.parseBodyFragment(protectedHtml);
        doc.outputSettings()
                .prettyPrint(false)
                .escapeMode(Entities.EscapeMode.base)
                .charset(StandardCharsets.UTF_8);

        NodeTraversor.traverse((node, depth) -> {
            if (node instanceof TextNode) {
                TextNode textNode = (TextNode) node;
                // getWholeText() 本来就是未编码文本；直接回写，让 jsoup 在 html() 时统一转义
                textNode.text(textNode.getWholeText());
            }
        }, doc.body());

        return mediaContext.restore(doc.body().html());
    }

    private static class MediaPlaceholderContext {
        private final LinkedHashMap<String, String> tokenToTag = new LinkedHashMap<>();
        private final String prefix = "__MEDIA_PLACEHOLDER_" + Utils.get32PrimaryKey();

        public String protect(String input) {
            if (StringUtils.isBlank(input)) {
                return input;
            }
            Matcher matcher = MEDIA_TAG_PATTERN.matcher(input);
            StringBuffer sb = new StringBuffer();
            int idx = 0;
            while (matcher.find()) {
                String originalTag = matcher.group();
                String token = prefix + (idx++) + "__";
                tokenToTag.put(token, originalTag);
                matcher.appendReplacement(sb, Matcher.quoteReplacement(token));
            }
            matcher.appendTail(sb);
            return sb.toString();
        }

        public String restore(String input) {
            if (StringUtils.isBlank(input) || tokenToTag.isEmpty()) {
                return input;
            }
            String result = input;
            for (Map.Entry<String, String> entry : tokenToTag.entrySet()) {
                result = result.replace(entry.getKey(), entry.getValue());
            }
            return result;
        }
    }
}