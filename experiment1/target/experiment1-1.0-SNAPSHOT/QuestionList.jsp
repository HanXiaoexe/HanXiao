<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>试题列表</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
    <h1 class="mt-4">试题管理</h1>

    <table class="table table-bordered mt-3">
        <thead class="thead-light">
        <tr>
            <th>题目</th>
            <th>A</th>
            <th>B</th>
            <th>C</th>
            <th>D</th>
            <th>正确答案</th>
            <c:if test="${not empty admin}">
                <th>操作</th>
            </c:if>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty questions}">
                <c:forEach var="q" items="${questions}">
                    <tr>
                        <td>${q.questionText}</td>
                        <td>${q.optionA}</td>
                        <td>${q.optionB}</td>
                        <td>${q.optionC}</td>
                        <td>${q.optionD}</td>
                        <td>${q.answer}</td>
                        <c:if test="${not empty admin}">
                            <td>
                                <button class="btn btn-warning btn-sm edit-question"
                                        data-id="${q.id}"
                                        data-question="${q.questionText}"
                                        data-a="${q.optionA}"
                                        data-b="${q.optionB}"
                                        data-c="${q.optionC}"
                                        data-d="${q.optionD}"
                                        data-answer="${q.answer}"
                                        data-toggle="modal"
                                        data-target="#editModal">修改</button>

                                <form action="QuestionServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${q.id}">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('确认删除这道题吗？')">删除</button>
                                </form>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="7" class="text-center">未查询到试题信息</td></tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<!-- 修改弹窗 -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">修改试题信息</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="QuestionServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editQuestionId">

                    <div class="form-group">
                        <label for="editQuestionText">题目</label>
                        <input type="text" class="form-control" name="questionText" id="editQuestionText">
                    </div>
                    <div class="form-group">
                        <label for="editOptionA">A 选项</label>
                        <input type="text" class="form-control" name="optionA" id="editOptionA">
                    </div>
                    <div class="form-group">
                        <label for="editOptionB">B 选项</label>
                        <input type="text" class="form-control" name="optionB" id="editOptionB">
                    </div>
                    <div class="form-group">
                        <label for="editOptionC">C 选项</label>
                        <input type="text" class="form-control" name="optionC" id="editOptionC">
                    </div>
                    <div class="form-group">
                        <label for="editOptionD">D 选项</label>
                        <input type="text" class="form-control" name="optionD" id="editOptionD">
                    </div>
                    <div class="form-group">
                        <label for="editAnswer">正确答案</label>
                        <select class="form-control" name="answer" id="editAnswer">
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">保存修改</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        $(".edit-question").click(function(){
            $("#editQuestionId").val($(this).data("id"));
            $("#editQuestionText").val($(this).data("question"));
            $("#editOptionA").val($(this).data("a"));
            $("#editOptionB").val($(this).data("b"));
            $("#editOptionC").val($(this).data("c"));
            $("#editOptionD").val($(this).data("d"));
            $("#editAnswer").val($(this).data("answer"));
        });
    });
</script>
</body>
</html>
