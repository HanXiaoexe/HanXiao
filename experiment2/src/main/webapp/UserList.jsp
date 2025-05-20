<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户列表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.6/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.6/dist/layui.js"></script>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
</head>
<body>

<div class="layui-container">
    <h2 class="layui-text-center">用户列表</h2>

    <!-- 搜索框 -->
    <form class="layui-form" method="get" action="UserServlet">
        <div class="layui-form-item">
            <div class="layui-inline">
                <input type="text" name="searchUserName" placeholder="搜索用户名" class="layui-input">
            </div>
            <button class="layui-btn" lay-submit>搜索</button>
        </div>
    </form>

    <!-- 用户表格 -->
    <table class="layui-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>邮箱</th>
            <th>性别</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <!-- 使用 JSTL 迭代显示用户列表 -->
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.id}</td>
                <td>${user.username}</td>
                <td>${user.email}</td>
                <td>${user.gender}</td>
                <td>${user.createTime}</td>
                <td>
                    <!-- 删除按钮 -->
                    <form method="post" action="UserServlet" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${user.id}">
                        <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" onclick="confirmDelete(${user.id})">删除</button>
                    </form>

                    <!-- 编辑按钮 -->
                    <button type="button" class="layui-btn layui-btn-normal layui-btn-sm"
                            onclick="openEditModal('${user.id}', '${user.username}', '${user.email}', '${user.gender}')">编辑</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- 编辑用户弹窗 -->
<div id="editModal" style="display: none; padding: 20px;">
    <form class="layui-form" method="post" action="UserServlet">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" id="editId">

        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" id="editUsername" required class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="email" name="email" id="editEmail" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <select name="gender" id="editGender">
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" type="submit">提交</button>
            </div>
        </div>
    </form>
</div>

<script>
    layui.use(['layer', 'form'], function () {
        const layer = layui.layer;
        const form = layui.form;

        window.openEditModal = function (id, username, email, gender) {
            $('#editId').val(id);
            $('#editUsername').val(username);
            $('#editEmail').val(email);
            $('#editGender').val(gender);

            layer.open({
                type: 1,
                title: '编辑用户',
                area: ['500px', '350px'],
                content: $('#editModal'),  // ✅ 正确写法
                success: function () {
                    form.render(); // 渲染下拉菜单
                }
            });
        }
    });
</script>
<script>
    layui.use('layer', function() {
        const layer = layui.layer;

        // 删除确认弹窗
        window.confirmDelete = function(userId) {
            layer.confirm('确定要删除该用户吗？', {
                btn: ['确定', '取消'] //按钮
            }, function() {
                // 确定后提交删除请求
                // 模拟点击提交按钮
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'UserServlet';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = userId;
                form.appendChild(idInput);

                document.body.appendChild(form);
                form.submit();
            }, function() {
                // 取消删除，不做任何操作
                layer.closeAll();
            });
        }
    });
</script>

</body>
</html>
