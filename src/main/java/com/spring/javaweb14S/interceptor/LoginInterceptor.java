package com.spring.javaweb14S.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LoginInterceptor extends HandlerInterceptorAdapter{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		
		int level = session.getAttribute("sLevel") == null ? 0: (int)session.getAttribute("sLevel");
		
		if(level == 0) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/memberMsg/loginChkNo");
			dispatcher.forward(request, response);
			return false;
		}
		
		return true;
	}

}
