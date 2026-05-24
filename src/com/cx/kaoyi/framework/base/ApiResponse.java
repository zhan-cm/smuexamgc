package com.cx.kaoyi.framework.base;

public class ApiResponse<T> {
    private MyHttpStatus status;    // 使用枚举类型
    private String message;
    private T data;

    // 构造方法
    public ApiResponse(MyHttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }

    public ApiResponse(MyHttpStatus status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

    // Getter 和 Setter 方法
    public MyHttpStatus getStatus() {
        return status;
    }

    public void setStatus(MyHttpStatus status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    // 静态构造方法，改进泛型推断
    public static <T> ApiResponse<T> ofStatus(MyHttpStatus status) {
        return new ApiResponse<>(status, null);
    }

    public static <T> ApiResponseBuilder<T> status(MyHttpStatus status) {
        return new ApiResponseBuilder<>(status);
    }

    // Builder 类，简化构造 ApiResponse 对象
    public static class ApiResponseBuilder<T> {
        private MyHttpStatus status;
        private String message;
        private T data;

        public ApiResponseBuilder(MyHttpStatus status) {
            this.status = status;
        }

        public ApiResponseBuilder<T> message(String message) {
            this.message = message;
            return this;
        }

        public ApiResponseBuilder<T> data(T data) {
            this.data = data;
            return this;
        }

        public ApiResponse<T> build() {
            return new ApiResponse<>(status, message, data);
        }
    }
}