<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加用户</title>
    <!-- 引入 Layui 样式 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.9.6/dist/css/layui.css">
    <!-- 引入 Layui JS -->
    <script src="https://cdn.jsdelivr.net/npm/layui@2.9.6/dist/layui.js"></script>
</head>

<body>
<div class="layui-container">
    <h2 class="layui-text-center">添加用户</h2>

    <!-- 添加用户表单 -->
    <form class="layui-form" id="userForm" lay-filter="userForm">

        <!-- 用户名 -->
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" required placeholder="请输入用户名" class="layui-input">
            </div>
        </div>

        <!-- 密码 -->
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <input type="password" name="password" required placeholder="请输入密码" class="layui-input">
            </div>
        </div>

        <!-- 邮箱 -->
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="email" name="email" placeholder="请输入邮箱" class="layui-input">
            </div>
        </div>

        <!-- 性别 -->
        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <select name="gender" class="layui-input">
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>
        </div>

        <!-- 提交按钮 -->
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn layui-btn-normal" lay-submit lay-filter="submitUser">提交</button>
                <a href="UserServlet" class="layui-btn layui-btn-primary">返回列表</a>
            </div>
        </div>
    </form>
</div>

<!-- 使用 AJAX 提交表单 -->
<script>
    layui.use(['form', 'layer'], function () {
        const form = layui.form;
        const layer = layui.layer;

        form.on('submit(submitUser)', function (data) {
            fetch('UserAdd', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams(data.field)
            }).then(response => response.text())
                .then(res => {
                    if (res === 'success') {
                        layer.msg('添加成功！', {icon: 1});
                        form.val('userForm', {
                            username: '',
                            password: '',
                            email: '',
                            gender: '男'
                        });
                    } else {
                        layer.msg(res, {icon: 2});
                    }
                });
            return false;
        });
    });
</script>
</body>
</html>
