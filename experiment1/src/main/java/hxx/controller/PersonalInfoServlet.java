package hxx.controller;

import hxx.dao.AdminDao;
import hxx.dao.UserDao;
import hxx.entity.Admin;
import hxx.entity.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "PersonalInfoServlet", value = "/PersonalInfoServlet")
public class PersonalInfoServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    private AdminDao adminDao = new AdminDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        Admin admin = (Admin) session.getAttribute("admin");
        if (user != null) {
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String sex = request.getParameter("sex");

            user.setPassword(password);
            user.setEmail(email);
            user.setSex(sex);

            userDao.updateUser(user);
            session.setAttribute("user", user);
        }
        if (admin != null) {
            String password = request.getParameter("password");


            admin.setPassword(password);
            adminDao.updateAdmin(admin);
            session.setAttribute("admin", admin);
        }

        response.sendRedirect("PersonalInfo.jsp");
    }
}