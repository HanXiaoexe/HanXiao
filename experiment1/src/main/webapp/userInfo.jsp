<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>用户管理</title>
  <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
  <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<!-- 设置 JSTL 变量，获取 session 中的 user/admin -->
<c:set var="user" value="${sessionScope.user}" />
<c:set var="admin" value="${sessionScope.admin}" />

<div class="container">
  <h1 class="mt-4">用户信息管理</h1>

  <!-- 查询表单 -->
  <form action="UserServlet" method="get" class="form-inline mt-3">
    <input type="text" class="form-control mr-2" name="searchUserName" placeholder="输入用户名查询">
    <button type="submit" class="btn btn-primary">查询</button>
  </form>

  <!-- 用户信息表 -->
  <table class="table table-bordered mt-3">
    <thead>
    <tr>
      <th>用户名</th>
      <th>密码</th>
      <th>邮箱</th>
      <th>性别</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
      <c:when test="${not empty users}">
        <c:forEach var="u" items="${users}">
          <tr>
            <td>${u.userName}</td>
            <td>${u.password}</td>
            <td>${u.email}</td>
            <td>${u.sex}</td>
            <td>
              <!-- 修改用户 -->
              <button class="btn btn-warning btn-sm edit-user"
                      data-username="${u.userName}"
                      data-password="${u.password}"
                      data-email="${u.email}"
                      data-sex="${u.sex}"
                      data-toggle="modal"
                      data-target="#editModal">修改</button>

              <!-- 删除用户（仅 admin 可见） -->
              <c:if test="${not empty admin}">
                <button type="button" class="btn btn-danger btn-sm delete-user"
                        data-username="${u.userName}"
                        data-toggle="modal"
                        data-target="#deleteModal">删除</button>

              </c:if>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr><td colspan="5" class="text-center">未查询到用户信息</td></tr>
      </c:otherwise>
    </c:choose>
    </tbody>
  </table>
</div>

<!-- 修改用户的弹出框 -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="editModalLabel">修改用户信息</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form action="UserServlet" method="post">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="userName" id="editUserName">

          <div class="form-group">
            <label for="editPassword">密码</label>
            <input type="password" class="form-control" name="password" id="editPassword">
          </div>

          <div class="form-group">
            <label for="editSex">性别</label>
            <select class="form-control" name="sex" id="editSex">
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>

          <div class="form-group">
            <label for="editEmail">邮箱</label>
            <input type="email" class="form-control" name="email" id="editEmail">
          </div>

          <button type="submit" class="btn btn-primary">保存修改</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- 删除确认弹窗 -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form action="UserServlet" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteModalLabel">确认删除</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="关闭">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          确定要删除该用户：<strong id="deleteUserNameText"></strong> 吗？
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="userName" id="deleteUserNameInput">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
          <button type="submit" class="btn btn-danger">确认删除</button>
        </div>
      </form>
    </div>
  </div>
</div>


<script>
  $(document).ready(function(){
    $(".edit-user").click(function(){
      $("#editUserName").val($(this).data("username"));
      $("#editPassword").val($(this).data("password"));
      $("#editSex").val($(this).data("sex"));
      $("#editEmail").val($(this).data("email"));
    });

    $(".delete-user").click(function(){
      var userName = $(this).data("username");
      $("#deleteUserNameText").text(userName);
      $("#deleteUserNameInput").val(userName);
    });
  });
</script>

</body>
</html>
