<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="hxx.entity.Users" %>
<%@ page import="hxx.entity.Admin" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>在线考试管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/element-ui/lib/theme-chalk/index.css" rel="stylesheet">
<%--    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.min.js"></script>--%>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; }
        .el-container { height: 100vh; }
        .el-header { background: #409EFF; color: white; font-size: 20px; display: flex; align-items: center; padding: 0 20px; }
        .el-aside { background: #f5f5f5; width: 200px; transition: width 0.3s; }
        .el-main { padding: 20px; background: #fff; height: 100vh; overflow: auto; }
        .ml-auto { margin-left: auto; }
        iframe { width: 100%; height: 100%; border: none; }


        .el-header {
            background: #409EFF;
            color: white;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            height: 60px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .system-title {
            font-weight: bold;
            font-size: 20px;
            margin-right: 10px;
        }

        .scroll-text-container {
            overflow: hidden;
            white-space: nowrap;
            max-width: 400px;
            position: relative;
            font-size: 16px;
            color: #fff8dc;
        }

        .scroll-text {
            display: inline-block;
            white-space: nowrap;
            animation: scroll-left 10s linear infinite;
            margin-left: 30px;
            font-weight: bold;
        }

        @keyframes scroll-left {
            0% {
                transform: translateX(100%);
            }
            100% {
                transform: translateX(-100%);
            }
        }


    </style>



</head>
<body>


<c:choose>
    <c:when test="${empty user and empty admin}">
        <c:redirect url="login.jsp" />
    </c:when>
</c:choose>
<div id="app">
    <el-container>
        <!-- 头部导航 -->
        <el-header>
            <div class="header-left">
                <span class="system-title">在线考试管理系统</span>
                <div class="scroll-text-container">
                    欢迎您！系统当前累计登录人数：
                    <span class="scroll-text">
                <%= application.getAttribute("loginCount") != null ? application.getAttribute("loginCount") : 0 %> 人
            </span>
                </div>
            </div>
            <div id="user-info" class="ml-auto">

            <c:choose>
    <c:when test="${not empty user or not empty admin}">
                <el-dropdown>
                    <span class="el-dropdown-link">
                        ${not empty user ? user.userName : admin.adminName} <i class="el-icon-arrow-down el-icon--right"></i>
                    </span>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item @click.native="logout">退出</el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
    </c:when>
    <c:otherwise>
        <el-button type="primary" @click="navigateTo('login.jsp')">登录</el-button>
    </c:otherwise>
</c:choose>
            </div>
        </el-header>

        <el-container>
            <!-- 侧边导航 -->
            <el-aside>

                <el-menu :default-openeds="['1', '2','3']" @select="navigateTo">
<%--                    用户权限--%>
<c:if test="${not empty user}">
                    <el-submenu index="1">
                        <template slot="title"><i class="el-icon-user"></i><span>用户管理</span></template>

                        <el-menu-item index="PersonalInfo.jsp">个人信息查询</el-menu-item>
                    </el-submenu>
                    <el-submenu index="2">
                        <template slot="title"><i class="el-icon-document"></i><span>试题管理</span></template>

                        <el-menu-item index="QuestionList.jsp">试题查询</el-menu-item>
                    </el-submenu>
                    <el-submenu index="3">
                        <template slot="title"><i class="el-icon-document"></i><span>考试管理</span></template>
                        <el-menu-item index="Exam.jsp">参加考试</el-menu-item>
                        <el-menu-item index="ExamList.jsp">考试记录</el-menu-item>
                    </el-submenu>

</c:if>
<!-- 管理员权限 -->
<c:if test="${not empty admin}">
                    <el-submenu index="1">
                        <template slot="title"><i class="el-icon-user"></i><span>用户管理</span></template>
                        <el-menu-item index="UserAdd.jsp">新用户注册</el-menu-item>
                        <el-menu-item index="userInfo.jsp">用户信息查询</el-menu-item>
                        <el-menu-item index="PersonalInfo.jsp">个人信息查询</el-menu-item>
                    </el-submenu>
                    <el-submenu index="2">
                        <template slot="title"><i class="el-icon-document"></i><span>试题管理</span></template>
                        <el-menu-item index="QuestionAdd.jsp">试题注册</el-menu-item>
                        <el-menu-item index="QuestionList.jsp">试题查询</el-menu-item>
                    </el-submenu>
                    <el-submenu index="3">
                        <template slot="title"><i class="el-icon-document"></i><span>考试管理</span></template>
                        <el-menu-item index="Exam.jsp">参加考试</el-menu-item>
<%--                        <el-menu-item index="ExamList.jsp">考试记录</el-menu-item>--%>
                    </el-submenu>
<%--                    <el-menu-item index="systemSettings.jsp">--%>
<%--                        <i class="el-icon-setting"></i>--%>
<%--                        <span>系统设置</span>--%>
<%--                    </el-menu-item>--%>
</c:if>
                </el-menu>
            </el-aside>

            <!-- 右侧内容区域 -->
            <el-main>
                <iframe v-if="currentPage" :src="currentPage" name="contentFrame"></iframe>
            </el-main>
        </el-container>
    </el-container>
</div>

<script>
    new Vue({
        el: '#app',
        data: {
            currentPage: ''  // 默认页面
        },
        methods: {
            navigateTo(url) {
                if (url === 'login.jsp') {
                    window.location.href = url;
                } else if (url === 'userInfo.jsp') {
                    this.currentPage = 'UserServlet'; // 直接请求 Servlet 获取用户数据
                } else if (url === 'QuestionList.jsp') {
                    this.currentPage = 'QuestionServlet?action=query'; // ⭐修改这一行⭐
                } else {
                    this.currentPage = url;
                }
            },
            logout() {
                window.location.href = "LogoutServlet";
            }
        }
    });
</script>
</body>
</html>
