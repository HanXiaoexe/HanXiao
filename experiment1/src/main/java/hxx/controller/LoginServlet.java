package hxx.controller;

import hxx.dao.AdminDao;
import hxx.dao.UserDao;
import hxx.entity.Admin;
import hxx.entity.Users;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private AdminDao adminDao = new AdminDao();

    @Override
    public void init() throws ServletException {
        // 初始化登录人数为 0（只执行一次）
        getServletContext().setAttribute("loginCount", 0);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String adminName = request.getParameter("AdminName");

        HttpSession session = request.getSession();
        ServletContext context = getServletContext();

        // 管理员登录
        if (adminName != null && !adminName.isEmpty()) {
            Admin admin = adminDao.getAdminByUsernameAndPassword(adminName, password);
            if (admin != null) {
                session.setAttribute("admin", admin);
                addLoginCount(context); // 计数器+1

                response.getWriter().println("<script>alert('管理员登录成功');window.location.href='index.jsp';</script>");
                return;
            }
        }

        // 用户登录
        Users user = userDao.getUserByUsernameAndPassword(userName, password);
        if (user != null) {
            session.setAttribute("user", user);
            addLoginCount(context); // 计数器+1

            response.getWriter().println("<script>alert('用户登录成功');window.location.href='index.jsp';</script>");
        } else {
            response.getWriter().println("<script>alert('用户名或密码错误');window.location.href='login.jsp';</script>");
        }
    }

    private void addLoginCount(ServletContext context) {
        //synchronized 是 Java 中的一个关键字，用于实现线程同步，
        // 确保多个线程在同一时间内只能有一个线程执行被同步的代码块或方法，
        // 从而避免线程间的竞争条件（race condition）。
        // 在 Servlet 中使用 synchronized 关键字来确保线程安全
        synchronized (context) {
            Integer count = (Integer) context.getAttribute("loginCount");
            context.setAttribute("loginCount", count + 1);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
