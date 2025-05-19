package hxx.controller;

import hxx.dao.UserDao;
import hxx.entity.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserServlet", value = "/UserServlet")
public class UserServlet extends HttpServlet {
    private UserDao userDao = new UserDao();
    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        Integer counter = (Integer) context.getAttribute("userCounter");
        if (counter == null) {
            counter = 0;
        }
        context.setAttribute("userCounter", counter);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//用户访问次数
        ServletContext context = getServletContext(); //获取Context对象
        HttpSession session = request.getSession(); //获取Session对象
        Integer counter = (Integer) context.getAttribute("userCounter"); //获取Context对象中的userCounter属性
        counter++; //访问次数加1
        context.setAttribute("userCounter", counter);//将访问次数重新设置到Context对象中

        System.out.println("访问了" + counter + " 次");//打印访问次数




        String searchUserName = request.getParameter("searchUserName");
        List<Users> users;

        if (searchUserName != null && !searchUserName.trim().isEmpty()) {
            users = userDao.searchUsersByUserName(searchUserName);
        } else {
            users = userDao.getAllUsers();
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("userInfo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");//获取JSP中 name=action的值

        if ("update".equals(action)) {
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String sex = request.getParameter("sex");

            Users user = new Users(userName, password, email, sex);
            userDao.updateUser(user);
        } else if ("delete".equals(action)) {
            String userName = request.getParameter("userName");
            userDao.deleteUser(userName);
        }

        response.sendRedirect("UserServlet");
    }
}
