package hxx.dao;

import hxx.entity.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {
    private Connection conn;

    public QuestionDAO(Connection conn) {
        this.conn = conn;
    }

    // 添加试题
    public boolean addQuestion(Question question) {
        String sql = "INSERT INTO questions (TITLE, optionA, optionB, optionC, optionD, answer) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getQuestionText());
            stmt.setString(2, question.getOptionA());
            stmt.setString(3, question.getOptionB());
            stmt.setString(4, question.getOptionC());
            stmt.setString(5, question.getOptionD());
            stmt.setString(6, String.valueOf(question.getAnswer()));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询所有试题
    public List<Question> getAllQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Question(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("optionA"),
                        rs.getString("optionB"),
                        rs.getString("optionC"),
                        rs.getString("optionD"),
                        rs.getString("answer").charAt(0)
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 修改试题
    public boolean updateQuestion(Question question) {
        String sql = "UPDATE questions SET title=?, optionA=?, optionB=?, optionC=?, optionD=?, answer=? WHERE id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getQuestionText());
            stmt.setString(2, question.getOptionA());
            stmt.setString(3, question.getOptionB());
            stmt.setString(4, question.getOptionC());
            stmt.setString(5, question.getOptionD());
            stmt.setString(6, String.valueOf(question.getAnswer()));
            stmt.setInt(7, question.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除试题
    public boolean deleteQuestion(int id) {
        String sql = "DELETE FROM questions WHERE id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // 随机提取四道考试题的方法
    public List<Question> getRandomQuestions(int count) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions ORDER BY RAND() LIMIT ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, count);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Question(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("optionA"),
                        rs.getString("optionB"),
                        rs.getString("optionC"),
                        rs.getString("optionD"),
                        rs.getString("answer").charAt(0)
                        //从数据库查询结果中获取名为 "answer" 的列的值
                        //在处理数据库查询结果时，从 "answer" 字段获取第一个字符的操作。
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
