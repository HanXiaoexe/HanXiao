package HX.Controller;

import HX.Dao.UserDao;
import HX.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchUserName = request.getParameter("searchUserName");
        List<User> users = (searchUserName != null && !searchUserName.isEmpty())
                ? userDao.searchUsersByUsername(searchUserName)
                : userDao.getAllUsers();

        request.setAttribute("users", users);
        request.getRequestDispatcher("UserList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userDao.deleteUser(id);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User u = userDao.getUserById(id);
            if (u != null) {
                u.setUsername(request.getParameter("username"));
                u.setEmail(request.getParameter("email"));
                u.setGender(request.getParameter("gender"));
                userDao.updateUser(u);
            }
        }

        // 编辑后重定向回 UserList.jsp，刷新页面
        response.sendRedirect("UserServlet");
    }
}
