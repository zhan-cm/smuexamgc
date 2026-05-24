package com.cx.kaoyi.framework.utils;

import org.apache.commons.lang3.StringUtils;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class AES {
    //密钥 (需要前端和后端保持一致)
    private static final String KEY = "abcdefgabcdefg12";
    private static final String ALGORITHMSTR = "AES/ECB/PKCS5Padding";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int T_LEN = 128; // GCM authentication tag length
    private static Base64.Encoder base64Encoder = Base64.getEncoder();

    private static Base64.Decoder base64Decoder = Base64.getDecoder();

    /**
     * AES加密
     * @throws Exception
     */
    public static String aesEncrypt(String content) throws Exception {
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        kgen.init(128);
        Cipher cipher = Cipher.getInstance(ALGORITHMSTR);
        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(KEY.getBytes(), "AES"));

        byte[] kcontent=cipher.doFinal(content.getBytes("utf-8"));
        String encriptPass=base64Encoder.encodeToString(kcontent);
        return encriptPass;
    }


    /**
     * AES解密
     * @throws Exception
     */
    public static String aesDecrypt(String encryptStr) throws Exception {
        if(StringUtils.isBlank(encryptStr)){
            return null;
        }
        encryptStr = encryptStr.trim();
        KeyGenerator kgen = KeyGenerator.getInstance("AES");
        kgen.init(128);

        Cipher cipher = Cipher.getInstance(ALGORITHMSTR);
        cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(KEY.getBytes(), "AES"));

        byte[] decryptBytes = cipher.doFinal(base64Decoder.decode(encryptStr));
        return new String(decryptBytes,"UTF-8");
    }

    public static String aesEncryptGCM(String content, String key) throws Exception {
        if(StringUtils.isBlank(content)){
            return null;
        }
        content = content.trim();
        SecretKey secretKey = new SecretKeySpec(base64Decoder.decode(key), "AES");

        SecureRandom secureRandom = new SecureRandom();
        byte[] iv = new byte[12]; // GCM standard recommends 96 bits
        secureRandom.nextBytes(iv);

        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(T_LEN, iv);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, gcmParameterSpec);

        byte[] encryptedContent = cipher.doFinal(content.getBytes("UTF-8"));

        byte[] output = new byte[iv.length + encryptedContent.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(encryptedContent, 0, output, iv.length, encryptedContent.length);

        return base64Encoder.encodeToString(output);
    }

    public static String aesDecryptGCM(String encryptStr, String key) throws Exception {
        if(StringUtils.isBlank(encryptStr)){
            return null;
        }
        encryptStr = encryptStr.trim();
        byte[] input = base64Decoder.decode(encryptStr);

        if (input.length < 12) { // Check minimal length of IV
            throw new IllegalArgumentException("Invalid encrypted text!");
        }

        byte[] iv = new byte[12];
        System.arraycopy(input, 0, iv, 0, iv.length);

        byte[] encryptedContent = new byte[input.length - iv.length];
        System.arraycopy(input, iv.length, encryptedContent, 0, encryptedContent.length);

        SecretKey secretKey = new SecretKeySpec(base64Decoder.decode(key), "AES");
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(T_LEN, iv);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, gcmParameterSpec);

        byte[] decryptedContent = cipher.doFinal(encryptedContent);
        return new String(decryptedContent, "UTF-8");
    }

    public static String generateRandomKey(int keySize) { //这个参数是字节，不是位
        if (keySize <= 0) {
            throw new IllegalArgumentException("Key size must be positive");
        }

        byte[] key = new byte[keySize];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(key);

        return base64Encoder.encodeToString(key);
    }
}