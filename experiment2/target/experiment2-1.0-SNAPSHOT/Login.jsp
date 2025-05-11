<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>在线购物系统 - 登录</title>
    <link href="https://unpkg.com/element-ui/lib/theme-chalk/index.css" rel="stylesheet">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- 引入粒子背景 -->
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>

    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            font-family: 'Arial', sans-serif;
        }
        #particles-js {
            position: absolute;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, rgba(64,158,255,0.7), rgba(102,177,255,0.7));
            backdrop-filter: blur(6px);
            z-index: -1; /* 让粒子在最底层 */
        }
        .login-container {
            position: relative;
            width: 400px;
            margin: 120px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
            animation: fadeIn 1s ease;
            backdrop-filter: blur(10px);
        }
        .login-title {
            text-align: center;
            font-size: 26px;
            font-weight: bold;
            color: #409EFF;
            margin-bottom: 30px;
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(-20px); }
            100% { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>

<!-- 粒子背景层 -->
<div id="particles-js"></div>

<div id="app">
    <div class="login-container">
        <div class="login-title">在线购物系统登录</div>

        <el-form :model="loginForm" ref="loginForm" label-width="80px">
            <el-form-item label="身份选择">
                <el-radio-group v-model="loginForm.role">
                    <el-radio-button label="user">用户</el-radio-button>
                    <el-radio-button label="admin">管理员</el-radio-button>
                </el-radio-group>
            </el-form-item>

            <el-form-item label="用户名">
                <el-input v-model="loginForm.username" prefix-icon="el-icon-user" placeholder="请输入用户名"></el-input>
            </el-form-item>

            <el-form-item label="密码">
                <el-input v-model="loginForm.password" prefix-icon="el-icon-lock" placeholder="请输入密码" show-password></el-input>
            </el-form-item>

            <el-form-item style="text-align: center;">
                <el-button type="primary" @click="submitLogin" style="width: 100%;">登录</el-button>
            </el-form-item>
        </el-form>
    </div>
</div>

<script>
    new Vue({
        el: '#app',
        data: {
            loginForm: {
                username: '',
                password: '',
                role: 'user'   // 默认选中 用户
            }
        },
        methods: {
            submitLogin() {
                if (!this.loginForm.username || !this.loginForm.password) {
                    this.$message.error('请填写完整信息');
                    return;
                }

                $.post('LoginServlet', {
                    username: this.loginForm.username,
                    password: this.loginForm.password,
                    role: this.loginForm.role
                }, (response) => {
                    if (response.success) {
                        this.$message.success('登录成功！');
                        setTimeout(() => {
                            window.top.location.href = "index.jsp";
                        }, 1000);
                    } else {
                        this.$message.error(response.message || '登录失败');
                    }
                }, 'json');
            }
        }
    });

    // 初始化粒子背景
    particlesJS('particles-js', {
        "particles": {
            "number": { "value": 80 },
            "size": { "value": 3 },
            "color": { "value": "#ffffff" },
            "line_linked": {
                "enable": true,
                "distance": 150,
                "color": "#ffffff",
                "opacity": 0.4,
                "width": 1
            },
            "move": {
                "enable": true,
                "speed": 2
            }
        },
        "interactivity": {
            "events": {
                "onhover": { "enable": true, "mode": "repulse" },
                "onclick": { "enable": true, "mode": "push" }
            },
            "modes": {
                "repulse": { "distance": 100 },
                "push": { "particles_nb": 4 }
            }
        }
    });
</script>

</body>
</html>
