<%@ page import="hxx.entity.Question" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>在线考试</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
<%--    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>--%>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>


    <script>
        $(document).ready(function () {
            let examStarted = sessionStorage.getItem("examStarted");

            if (examStarted) {
                // 如果考试已经开始，弹出“继续考试”弹窗
                $('#continueExamModal').modal('show');
            } else {
                // 如果考试未开始，弹出“确认开始考试”弹窗
                $('#startExamModal').modal('show');
            }
        });

        // 用户点击“确认开始”考试
        function startExam() {
            sessionStorage.setItem("examStarted", "true"); // 记录考试已开始
            $('#startExamModal').modal('hide'); // 关闭弹窗
            setTimeout(() => {
                window.location.href = "ExamServlet"; // 重新抽题
            }, 300);
        }

        // 继续考试（不刷新页面）
        function continueExam() {
            $('#continueExamModal').modal('hide'); // 关闭弹窗
        }

        // 取消考试，返回主页
        function cancelExam() {
            sessionStorage.removeItem("examStarted"); // 清除考试状态
            window.location.href = "welcome.jsp";
        }

        // 确认提交考试
        function confirmExam() {
            if (confirm("确认提交答案？")) {
                document.getElementById("examForm").submit();
            }
        }
    </script>
</head>
<body>
<div class="container">
    <h1 class="mt-4 text-center">在线考试</h1>

    <!-- 试题表单 -->
    <form id="examForm" action="ExamServlet" method="post">
<c:choose>
    <c:when test="${not empty sessionScope.questions}">
        <c:forEach var="q" items="${sessionScope.questions}">
        <div class="card my-3">
            <div class="card-body">
                <h5 class="card-title">${q.questionText}</h5>
                <div class="form-check">
<%--                    每道题的选项用 <input type="radio"> 展示，name="answer_题目ID"，这样可以用 Servlet 接收用户的选择。--%>

                    <input class="form-check-input" type="radio" name="answer_${q.id}" value="A" required>
                    <label class="form-check-label">${q.optionA}</label>
                    //假设ID为1选择了A 提交的结果为 anser_1=A
                    //HTTP 表单提交（特别是 GET 或 POST）时的数据格式是标准的键值对形式：key=value
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_${q.id}" value="B" required>
                    <label class="form-check-label">${q.optionB}</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_${q.id}" value="C" required>
                    <label class="form-check-label">${q.optionC}</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answer_${q.id}" value="D" required>
                    <label class="form-check-label">${q.optionD}</label>
                </div>
            </div>
        </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <p class="text-center text-muted">暂无考试题目。</p>
    </c:otherwise>
</c:choose>
        <button type="button" class="btn btn-success btn-block" onclick="confirmExam()">提交考试</button>
    </form>
</div>

<!-- 确认开始考试的弹窗 -->
<div class="modal fade" id="startExamModal" tabindex="-1" aria-labelledby="startExamModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="startExamModalLabel">考试开始确认</h5>
            </div>
            <div class="modal-body text-center">
                <p>你即将开始考试，确认后将随机抽取题目！</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cancelExam()">取消</button>
                <button type="button" class="btn btn-primary" onclick="startExam()">确认开始</button>
            </div>
        </div>
    </div>
</div>

<!-- 继续考试的弹窗 -->
<div class="modal fade" id="continueExamModal" tabindex="-1" aria-labelledby="continueExamModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="continueExamModalLabel">继续考试</h5>
            </div>
            <div class="modal-body text-center">
                <p>你上次的考试还未完成，是否继续？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cancelExam()">取消考试</button>
                <button type="button" class="btn btn-primary" onclick="continueExam()">继续考试</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
