package HX.Controller;

import HX.Dao.AdminDao;
import HX.Dao.UserDao;
import HX.entity.admin;
import HX.entity.User;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDao userDao = new UserDao();
    private AdminDao adminDao = new AdminDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应格式
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        HttpSession session = request.getSession();

        // 获取ServletContext
        ServletContext context = getServletContext();
        Integer onlineCount = (Integer) context.getAttribute("onlineCount");
        if (onlineCount == null) {
            onlineCount = 0;
        }

        if ("user".equals(role)) {
            // 普通用户登录
            User user = userDao.searchUsersByUsername(username)
                    .stream()
                    .filter(u -> u.getPassword().equals(password))
                    .findFirst()
                    .orElse(null);

            if (user != null) {
                session.setAttribute("user", user);

                // 增加在线人数
                context.setAttribute("onlineCount", onlineCount + 1);

                out.write("{\"success\": true, \"message\": \"用户登录成功\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"用户名或密码错误\"}");
            }

        } else if ("admin".equals(role)) {
            // 管理员登录
            admin admin = adminDao.login(username, password);

            if (admin != null) {
                session.setAttribute("admin", admin);

                // 增加在线人数
                context.setAttribute("onlineCount", onlineCount + 1);

                out.write("{\"success\": true, \"message\": \"管理员登录成功\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"管理员用户名或密码错误\"}");
            }

        } else {
            out.write("{\"success\": false, \"message\": \"非法角色\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前在线人数
        ServletContext context = getServletContext();
        Integer onlineCount = (Integer) context.getAttribute("onlineCount");
        if (onlineCount == null) {
            onlineCount = 0;
        }
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.write("{\"onlineCount\": " + onlineCount + "}");
    }
}
