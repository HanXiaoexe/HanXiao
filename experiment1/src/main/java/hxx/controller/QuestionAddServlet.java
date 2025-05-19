package hxx.controller;

import hxx.dao.QuestionDAO;
import hxx.entity.Question;
import hxx.util.JdbcUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet(value = "/QuestionAddServlet")
public class QuestionAddServlet extends HttpServlet {
    private QuestionDAO questionDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        questionDAO = new QuestionDAO(conn);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求中的试题信息
        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        char answer = request.getParameter("answer").charAt(0);

        // 创建试题对象并添加到数据库
        Question question = new Question(0, questionText, optionA, optionB, optionC, optionD, answer);
        questionDAO.addQuestion(question);

//        // 使用 RequestDispatcher 调用 QuestionServlet 的查询方法，更新试题列表
//        request.setAttribute("action", "query"); // 设置 action 参数为查询
//        request.getRequestDispatcher("QuestionServlet?action=query").forward(request, response);
        // 设置响应内容类型并输出 JS 提示
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<script>alert('试题添加成功！'); window.location='QuestionServlet?action=query';</script>");
    }
}
