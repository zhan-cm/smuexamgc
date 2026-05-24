package com.cx.kaoyi.business.component;

import com.cx.kaoyi.business.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component("QuestionTaskJob")
public class QuestionTaskJob {
    @Autowired
    private CommonService commonService;

    @Scheduled(cron = "0 15 * ? * *")
    public void refreshQuestionBankData(){
        commonService.calculateQuestionBankData(true);
    }
}