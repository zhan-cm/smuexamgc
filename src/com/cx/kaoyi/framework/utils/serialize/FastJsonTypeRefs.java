package com.cx.kaoyi.framework.utils.serialize;

import com.alibaba.fastjson2.TypeReference;
import com.cx.kaoyi.framework.question.dto.DuplicatePairDTO;
import com.cx.kaoyi.framework.question.dto.QuestionStatDto;
import com.cx.kaoyi.framework.question.dto.RepeatABRate;

import java.util.List;
import java.util.Map;

public class FastJsonTypeRefs {
    public static final TypeReference<List<String>> LIST_STR_REFS =
            new TypeReference<List<String>>(){};
    public static final TypeReference<List<Map<String,Object>>> LIST_MAP_STR_OBJ_REFS =
            new TypeReference<List<Map<String,Object>>>() {};
    public static final TypeReference<RepeatABRate> REPEAT_AB_RATE_REFS = new TypeReference<RepeatABRate>() {};
    public static final TypeReference<Map<String, QuestionStatDto>> QUESTIONSTATDTO_MAP_REFS = new TypeReference<Map<String, QuestionStatDto>>() {};
    public static final TypeReference<Map<String, List<DuplicatePairDTO>>> DUP_LIST_MAP_REFS = new TypeReference<Map<String, List<DuplicatePairDTO>>>() {};
}
