package com.cx.kaoyi.framework.shiro;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Locale;

public class LocaleResolverCommon extends SessionLocaleResolver {

    @Override
    public Locale resolveLocale(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String string=request.getParameter("lang");
        Locale locale = Locale.SIMPLIFIED_CHINESE;
        if(StringUtils.isNotBlank(string) && string.contains("_")){
            String[] strings=string.split("_");
            locale=new Locale(strings[0],strings[1]);
            session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME,locale);
        }else {
            Locale localesession = (Locale) session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
            if (localesession!=null){
                locale=localesession;
            }
        }
        return locale;
    }


}

