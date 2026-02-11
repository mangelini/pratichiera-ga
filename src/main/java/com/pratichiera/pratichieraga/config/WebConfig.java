package com.pratichiera.pratichieraga.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new HandlerInterceptor() {
                    @Override
                    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
                        HttpSession session = request.getSession(false);

                        if (session == null || session.getAttribute("user_id") == null) {
                            response.sendRedirect("/login");
                            return false;
                        }
                        return true;
                    }
                })
                .addPathPatterns("/**")
                .excludePathPatterns("/login", "/register", "/css/**", "/js/**", "/error");
    }
}
