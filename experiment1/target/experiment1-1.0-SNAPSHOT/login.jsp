<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="zh">

<head>

    <meta charset="UTF-8">

    <title>Sign in</title>

    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/element-ui/lib/theme-chalk/index.css" rel="stylesheet">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
<%--    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>--%>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>

    <style>
        body {
            background: #f4f7f9;
        }
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        .login-title {
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        .el-form-item {
            margin-bottom: 20px;
        }
        .el-button {
            width: 100%;
        }
        /* 让选择框样式与输入框一致 */
        .el-select {
            width: 100%;
        }
        .el-input__inner, .el-select .el-input__inner {
            height: 40px; /* 统一高度 */
            border-radius: 5px;
        }
        .el-select-dropdown {
            border-radius: 5px;
        }
    </style>

</head>

<body>

<div id="app" class="login-container">

    <h2 class="login-title">登录</h2>

    <el-form ref="form" :model="form" label-width="100px">

        <!-- 选择角色，放到下一行 -->
        <el-form-item label="" label-width="0">
            <el-select v-model="form.userType" placeholder="请选择角色">
                <el-option label="用户" value="user"></el-option>
                <el-option label="管理员" value="admin"></el-option>
            </el-select>
        </el-form-item>

        <!-- 用户登录 -->
        <el-form v-if="form.userType === 'user'" :model="form" action="LoginServlet" method="post">
            <el-form-item label="用户名">
                <el-input v-model="form.userName" name="userName" placeholder="请输入用户名"></el-input>
            </el-form-item>

            <el-form-item label="密码">
                <el-input type="password" v-model="form.password" name="password" placeholder="请输入密码"></el-input>
            </el-form-item>

            <el-form-item>
                <el-button type="primary" native-type="submit">用户登录</el-button>
            </el-form-item>
        </el-form>

        <!-- 管理员登录 -->
        <el-form v-if="form.userType === 'admin'" :model="form" action="LoginServlet" method="post">
            <el-form-item label="管理员名">
                <el-input v-model="form.AdminName" name="AdminName" placeholder="请输入管理员名"></el-input>
            </el-form-item>

            <el-form-item label="密码">
                <el-input type="password" v-model="form.password" name="password" placeholder="请输入密码"></el-input>
            </el-form-item>

            <el-form-item>
                <el-button type="primary" native-type="submit">管理员登录</el-button>
            </el-form-item>
        </el-form>

    </el-form>

</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                form: {
                    userType: 'user',  // 默认选择用户登录
                    userName: '',
                    password: '',
                    AdminName: ''
                }
            };
        }
    });
</script>

</body>

</html>
