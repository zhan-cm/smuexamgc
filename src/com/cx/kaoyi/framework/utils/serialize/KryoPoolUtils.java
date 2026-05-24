package com.cx.kaoyi.framework.utils.serialize;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.domain.download.Progress;
import com.cx.kaoyi.business.domain.exampaper.ExampaperAnswer;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestion;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestionType;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.GPT.operationDTO.business.QuestionEditInfo;
import com.cx.kaoyi.framework.shiro.dto.PasswordWrongRecord;
import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import com.esotericsoftware.kryo.io.Output;
import com.esotericsoftware.kryo.util.Pool;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;

/**
 * Kryo 池化工具类，使用 com.esotericsoftware.kryo.util.Pool 实现线程安全的 Kryo 实例复用。
 * 空闲实例可使用软引用策略（如需），在内存紧张时可被 GC 回收。
 */
public class KryoPoolUtils {
    // 默认缓冲区初始大小（字节）
    private static final int DEFAULT_BUFFER_SIZE = 4 * 1024;
    // 默认缓冲区最大大小，-1 表示不限制
    private static final int DEFAULT_MAX_BUFFER_SIZE = -1;

    // 全部需要注册的类型集合（初始包含常用类型）
    private static final List<Class<?>> registeredClasses = Arrays.asList(
            HashMap.class,
            ArrayList.class,
            HashSet.class,
            BigDecimal.class,
            Date.class,
            PasswordWrongRecord.class,
            Permission.class,
            ExampaperQuestionType.class,
            ExampaperQuestion.class,
            ExampaperAnswer.class,
            String[].class,
            Progress.class,
            MainGeneratedQuestion.class,
            GeneratedQuestion.class,
            QuestionEditInfo.class
    );

    /**
     * 使用 Pool 实现 Kryo 对象复用：
     * - 第一个参数 true 表示线程安全
     * - 第二个参数 true 表示池中空闲实例使用 SoftReference
     * 构造时不限制最大实例数
     */
    private static final Pool<Kryo> pool = new Pool<Kryo>(true, true) {
        @Override
        protected Kryo create() {
            Kryo kryo = new Kryo();
            kryo.setReferences(false);              // 不支持循环引用
            kryo.setRegistrationRequired(false);   // 不强制注册
            // 注册所有类型
            for (Class<?> cls : registeredClasses) {
                kryo.register(cls);
            }
            return kryo;
        }
    };

    /**
     * 内部方法：借出 Kryo 实例，执行回调后归还实例
     * @param callback 对 Kryo 实例的操作
     * @param <R> 回调返回类型
     * @return 回调结果
     */
    private static <R> R run(Function<Kryo, R> callback) {
        Kryo kryo = pool.obtain();
        try {
            return callback.apply(kryo);
        } finally {
            pool.free(kryo);
        }
    }

    /**
     * 对象深拷贝
     * @param obj 源对象
     * @param <T> 对象类型
     * @return 深拷贝后的新对象
     */
    @SuppressWarnings("unchecked")
    public static <T> T deepCopy(T obj) {
        return run(kryo -> kryo.copy(obj));
    }

    /**
     * 对象序列化为字节数组
     * @param obj 源对象
     * @param <T> 对象类型
     * @return 序列化后的字节数组
     */
    public static <T> byte[] serialize(T obj) {
        return run(kryo -> {
            Output out = new Output(DEFAULT_BUFFER_SIZE, DEFAULT_MAX_BUFFER_SIZE);
            kryo.writeClassAndObject(out, obj);
            return out.toBytes();
        });
    }

    /**
     * 从字节数组反序列化对象
     * @param bytes 序列化字节数组
     * @param <T> 对象类型
     * @return 反序列化后的对象
     */
    @SuppressWarnings("unchecked")
    public static <T> T deserialize(byte[] bytes) {
        return run(kryo -> {
            Input in = new Input(bytes);
            return (T) kryo.readClassAndObject(in);
        });
    }
}