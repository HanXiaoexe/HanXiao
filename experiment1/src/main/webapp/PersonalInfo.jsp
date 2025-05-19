<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
<%--    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>--%>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
    <h1 class="mt-4">个人信息</h1>

    <c:choose>
    <c:when test="${not empty user}">
    <form action="PersonalInfoServlet" method="post" class="mt-3">
        <div class="form-group">
            <label for="userName">用户名</label>
            <input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" readonly>
        </div>
        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" class="form-control" id="password" name="password" value="${user.password}">
        </div>
        <div class="form-group">
            <label for="email">邮箱</label>
            <input type="email" class="form-control" id="email" name="email" value="${user.email}">
        </div>
        <div class="form-group">
            <label for="sex">性别</label>
            <select class="form-control" id="sex" name="sex">
                <option value="男" ${user.sex == '男' ? 'selected' : ''}>男</option>
                <option value="女" ${user.sex == '女' ? 'selected' : ''}>女</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">保存修改</button>
    </form>
    </c:when>
    <c:when test="${not empty admin}">
    <form action="PersonalInfoServlet" method="post" class="mt-3">
        <div class="form-group">
            <label for="AdminName">管理员名称</label>
            <input type="text" class="form-control" id="AdminName" name="AdminName" value=“${admin.adminName}" readonly>
        </div>
        <div class="form-group">
            <label for="AdminPassword">管理员密码</label>
            <input type="password" class="form-control" id="AdminPassword" name="password" value="${admin.password}">

        </div>
        <button type="submit" class="btn btn-primary">保存修改</button>
    </form>
        </form>
    </c:when>
    </c:choose>
</div>
</body>
</html>