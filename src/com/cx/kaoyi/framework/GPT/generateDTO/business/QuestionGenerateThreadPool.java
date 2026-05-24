package com.cx.kaoyi.framework.GPT.generateDTO.business;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

public class QuestionGenerateThreadPool {
    private static final int THREAD_POOL_SIZE = 5;
    private static QuestionGenerateThreadPool instance;
    private ThreadPoolExecutor executor;

    private final Map<String, Future<?>> taskMap = new ConcurrentHashMap<>(); // 用于存储cid到任务的映射

    private QuestionGenerateThreadPool() {
        executor = new ThreadPoolExecutor(
                THREAD_POOL_SIZE/2, THREAD_POOL_SIZE, 20L, TimeUnit.MINUTES,
                new SynchronousQueue<>(),
                Executors.defaultThreadFactory(),
                new ThreadPoolExecutor.AbortPolicy()); // 使用AbortPolicy作为默认的拒绝策略
    }

    public static synchronized QuestionGenerateThreadPool getInstance() {
        if (instance == null) {
            instance = new QuestionGenerateThreadPool();
        }
        return instance;
    }

    public synchronized boolean submitTask(String cid, Runnable task) {
        if(taskMap.size()<THREAD_POOL_SIZE && !taskMap.containsKey(cid)){
            Future<?> future = executor.submit(task); // 提交任务时，将Future与cid关联
            taskMap.put(cid, future);
            return true;
        }
        return false;
    }

    public boolean isTaskRunning(String cid) {
        return taskMap.containsKey(cid);
    }

    public synchronized int cancelTask(String cid) { // 取消特定cid的任务，如果返回0就说明取消失败，否则返回当前cid的改卷次数
        Future<?> task = taskMap.remove(cid);
        if(task==null){
            return 0;
        }
        if (task != null) {
            //boolean cancelSuccess = task.cancel(true);// 如果希望中断正在执行的任务，则参数为true，但中断会影响sql
            return 1;
        }
        return 0;
    }

    public List<String> getRunningCids() {
        List<String> running = new ArrayList<>();
        for (Map.Entry<String, Future<?>> e : taskMap.entrySet()) {
            Future<?> f = e.getValue();
            if (f != null && !f.isDone() && !f.isCancelled()) {
                running.add(e.getKey());
            }
        }
        return running;
    }

    public void shutdownThreadPool() {
        executor.shutdown();
    }

    public synchronized void restartThreadPool() {
        if (executor==null || executor.isShutdown() || executor.isTerminated()) {
            executor = new ThreadPoolExecutor(
                    THREAD_POOL_SIZE/3, THREAD_POOL_SIZE, 20L, TimeUnit.MINUTES,
                    new SynchronousQueue<>(),
                    Executors.defaultThreadFactory(),
                    new ThreadPoolExecutor.AbortPolicy()); // 使用AbortPolicy作为默认的拒绝策略
        }
    }
}