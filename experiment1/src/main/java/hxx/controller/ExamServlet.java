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

@WebServlet("/ExamServlet")
public class ExamServlet extends HttpServlet {
    private QuestionDAO questionDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = JdbcUtil.getConnection();
            questionDAO = new QuestionDAO(conn);
        } catch (SQLException e) {
            throw new RuntimeException("数据库连接失败", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


//抽取四道题, count=4 放在session中

        List<Question> questions = questionDAO.getRandomQuestions(4);
            request.getSession().setAttribute("questions", questions);


        request.setAttribute("questions", questions);//向请求对象中添加属性
//        将数据(questions列表)与当前的HTTP请求关联起来
//                使这些数据在请求处理的整个生命周期内可用
//        特别是让转发到的JSP页面能够访问这些数据request.setAttribute: 数据只在当前请求中有效
//session.setAttribute: 数据在整个会话中有效，可跨多个请求使用
        request.getRequestDispatcher("Exam.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double score = 0;
        List<Question> questions = (List<Question>) request.getSession().getAttribute("questions");

        if (questions != null) {
            double scorePerQuestion = 100.0 / questions.size();
            for (Question question : questions) {

//                用户答案保存在 request 对象中，仅用于一次性处理和评分；
//
//                没有存入数据库，而是直接在内存中进行比较并打分。
//获取answer_这个字段
                String userAnswer = request.getParameter("answer_" + question.getId());//储存用户的答案
                //这个 question.getId() 取的是当前这道被抽中并呈现在页面上的题目的 ID，也就是那四道题中的一个 ID。
                if (userAnswer != null && userAnswer.equalsIgnoreCase(String.valueOf(question.getAnswer()))) {//不区分大小写
                    score += scorePerQuestion;
                }
            }
        }

        request.setAttribute("score", score);
        request.getRequestDispatcher("Score.jsp").forward(request, response);
    }
}