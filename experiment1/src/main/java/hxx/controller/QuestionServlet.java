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
import java.util.List;

@WebServlet("/QuestionServlet")
public class QuestionServlet extends HttpServlet {
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
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String questionText = request.getParameter("questionText");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            char answer = request.getParameter("answer").charAt(0);

            Question question = new Question(0, questionText, optionA, optionB, optionC, optionD, answer);
            questionDAO.addQuestion(question);
            response.sendRedirect("QuestionList.jsp");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String questionText = request.getParameter("questionText");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            char answer = request.getParameter("answer").charAt(0);

            Question question = new Question(id, questionText, optionA, optionB, optionC, optionD, answer);
            questionDAO.updateQuestion(question);

            // 修改完成后，重新查询试题并转发到 QuestionList.jsp
            List<Question> questions = questionDAO.getAllQuestions();
            request.setAttribute("questions", questions);
            request.setAttribute("isAdmin", true); // 假设管理员已登录，设置管理员权限
            request.getRequestDispatcher("QuestionList.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            questionDAO.deleteQuestion(id);

            // 删除后重新查询试题并转发到 QuestionList.jsp
            List<Question> questions = questionDAO.getAllQuestions(); // 获取最新的试题列表
            request.setAttribute("questions", questions); // 将试题列表传递给 JSP 页面
            request.setAttribute("isAdmin", true); // 假设管理员已登录，设置管理员权限
            request.getRequestDispatcher("QuestionList.jsp").forward(request, response); // 转发请求到 QuestionList.jsp
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 处理 action=query 的 GET 请求
        String action = request.getParameter("action");

        if ("query".equals(action)) {
            List<Question> questions = questionDAO.getAllQuestions();
            request.setAttribute("questions", questions);
            request.getRequestDispatcher("QuestionList.jsp").forward(request, response);//转发请求到 QuestionList.jsp
        } else {
            doPost(request, response); // 其他情况交给 doPost 处理
        }
    }
}

