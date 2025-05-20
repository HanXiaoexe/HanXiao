package HX.Controller;

import HX.Dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/DeleteUser")
public class DeleteUserServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取要删除的用户ID
        int userId = Integer.parseInt(request.getParameter("id"));

        // 删除用户
        boolean success = userDao.deleteUser(userId);

        // 设置响应类型为JSON格式
        response.setContentType("application/json;charset=UTF-8");

        // 返回删除结果
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }
}
