package hxx.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*") // 过滤所有请求
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化过滤器（可选）
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        String loginURI = httpRequest.getContextPath() + "/login.jsp";

        boolean loggedIn = (session != null && (session.getAttribute("user") != null || session.getAttribute("admin") != null));
        boolean loginRequest = httpRequest.getRequestURI().equals(loginURI) || httpRequest.getRequestURI().endsWith("/LoginServlet");

        if (loggedIn || loginRequest) {
            chain.doFilter(request, response); // 用户已登录或正在访问登录页面，继续请求
        } else {
            httpResponse.sendRedirect(loginURI); // 未登录，重定向到登录页面
        }
    }

    @Override
    public void destroy() {
        // 销毁过滤器（可选）
    }
}