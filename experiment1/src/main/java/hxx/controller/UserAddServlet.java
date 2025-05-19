package hxx.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import hxx.dao.UserDao;
import hxx.entity.Users;

import java.io.IOException;

@WebServlet(name = "UserAddServlet", value = "/UserAddServlet")
public class UserAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 获取表单数据
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String sex = request.getParameter("sex");

        // 创建用户对象
        Users user = new Users(userName, password,  email,sex);
        UserDao userDao = new UserDao();

        // 插入用户并获取新生成的 userId
        int userId = userDao.addUser(user);

        response.setContentType("text/html;charset=UTF-8");
        if (userId > 0) {
            response.getWriter().println("<script>alert('注册成功，用户ID：" + userId + "');window.location.href='UserAdd.jsp';</script>");
        } else {
            response.getWriter().println("<script>alert('注册失败，请重试');window.location.href='UserAdd.jsp';</script>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("UserAdd.jsp");
    }
}
