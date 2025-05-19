<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>用户注册</title>
  <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
<%--  <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>--%>
  <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
  <style>
    .container { max-width: 500px; margin-top: 50px; }
  </style>
</head>
<body>
<div class="container">
  <h2 class="text-center">新用户注册</h2>
  <form id="registrationForm" action="UserAddServlet" method="post">

  <div class="mb-3">
      <label for="userName" class="form-label">用户名</label>
      <input type="text" class="form-control" id="userName" name="userName" required>
    </div>
    <div class="mb-3">
      <label for="password" class="form-label">用户密码</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>
    <div class="mb-3">
      <label for="email" class="form-label">用户邮箱</label>
      <input type="email" class="form-control" id="email" name="email" required>
    </div>
    <div class="mb-3">
      <label class="form-label">性别</label>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="sex" value="男" required> 男
        <input class="form-check-input" type="radio" name="sex" value="女" required> 女
      </div>
    </div>
    <button type="submit" class="btn btn-primary">注册</button>
    <button type="reset" class="btn btn-secondary">重置</button>
  </form>
</div>



</body>
</html>
