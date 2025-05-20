<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>在线购物系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/element-ui/lib/theme-chalk/index.css" rel="stylesheet">
    <!-- 添加 Layui CSS -->
    <link rel="stylesheet" href="https://www.layuicdn.com/layui-v2.6.8/css/layui.css">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- 添加 Layui JS -->
    <script src="https://www.layuicdn.com/layui-v2.6.8/layui.js"></script>

    <style>
        body { margin: 0; font-family: Arial, sans-serif; }
        .el-container { height: 100vh; }
        .el-header { background: #409EFF; color: white; font-size: 20px; display: flex; align-items: center; padding: 0 20px; }
        .el-aside { background: #f5f5f5; width: 200px; transition: width 0.3s; }
        .el-main { padding: 20px; background: #fff; height: 100vh; overflow: auto; }
        .ml-auto { margin-left: auto; }
        iframe { width: 100%; height: 100%; border: none; }
        .system-title { font-weight: bold; font-size: 20px; margin-right: 10px; }
        .scroll-text-container { overflow: hidden; white-space: nowrap; max-width: 400px; position: relative; font-size: 16px; color: #fff8dc; }
        .scroll-text { display: inline-block; white-space: nowrap; animation: scroll-left 10s linear infinite; margin-left: 30px; font-weight: bold; }
        @keyframes scroll-left {
            0% { transform: translateX(100%); }
            100% { transform: translateX(-100%); }
        }
        /* 添加 Layui 按钮样式覆盖 */
        .layui-btn-primary {
            background-color: #ffffff;
            color: #409EFF;
            border: 1px solid #DCDFE6;
            width: 100%;
            text-align: left;
            margin: 5px 0;
            padding: 6px 15px;
        }
        .layui-btn-primary:hover {
            background-color: #ecf5ff;
            color: #409EFF;
            border-color: #c6e2ff;
        }
        /* 自定义菜单项样式 */
        .custom-menu-item {
            padding: 0 20px;
            position: relative;
            white-space: nowrap;
            transition: border-color .3s,background-color .3s,color .3s;
            box-sizing: border-box;
            height: 56px;
            line-height: 56px;
            display: block;
        }
        .custom-menu-item:hover {
            background-color: #ecf5ff;
        }
    </style>

</head>

<body>

<div id="app">
    <el-container>
        <!-- 头部 -->
        <el-header>
            <div class="header-left">
                <span class="system-title">在线购物系统</span>
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
                                ${not empty user ? user.username : admin.adminName} <i class="el-icon-arrow-down el-icon--right"></i>
                            </span>
                            <el-dropdown-menu slot="dropdown">
                                <el-dropdown-item @click.native="logout">退出</el-dropdown-item>
                            </el-dropdown-menu>
                        </el-dropdown>
                    </c:when>
                    <c:otherwise>
                        <el-button type="primary" @click="goLoginPage">登录</el-button>
                    </c:otherwise>
                </c:choose>
            </div>
        </el-header>

        <!-- 主体 -->
        <el-container>
            <el-aside>
                <el-menu :default-openeds="['1', '2', '3']" @select="navigateTo">
                    <c:if test="${not empty user}">
                        <el-submenu index="1">
                            <template slot="title"><i class="el-icon-user"></i><span>用户中心</span></template>
                            <el-menu-item index="PersonalInfo.jsp">个人信息</el-menu-item>
                        </el-submenu>
                        <el-submenu index="2">
                            <template slot="title"><i class="el-icon-goods"></i><span>商品浏览</span></template>
                            <!-- 修改后的商品列表菜单项 -->
                            <li class="custom-menu-item">
                                <button class="layui-btn layui-btn-primary" id="viewProductList">查看商品列表</button>
                            </li>
                        </el-submenu>
                        <el-submenu index="3">
                            <template slot="title"><i class="el-icon-shopping-cart-full"></i><span>我的购物车</span></template>
                            <el-menu-item index="Cart.jsp">查看购物车</el-menu-item>
                            <el-menu-item index="OrderList.jsp">我的订单</el-menu-item>
                        </el-submenu>
                    </c:if>

                    <c:if test="${not empty admin}">
                        <el-submenu index="1">
                            <template slot="title"><i class="el-icon-user"></i><span>用户管理</span></template>
                            <el-menu-item index="UserAdd.jsp">新增用户</el-menu-item>
                            <el-menu-item index="UserServlet">用户列表</el-menu-item>
                        </el-submenu>
                        <el-submenu index="2">
                            <template slot="title"><i class="el-icon-setting"></i><span>商品管理</span></template>
                            <el-menu-item index="ProductAdd.jsp">添加商品</el-menu-item>
                            <el-menu-item index="ProductList.jsp">商品列表</el-menu-item>
                        </el-submenu>
                    </c:if>
                </el-menu>
            </el-aside>

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
            currentPage: '',
        },
        mounted() {
            // Vue 实例挂载完成后初始化 Layui
            this.initLayui();
        },
        methods: {
            navigateTo(url) {
                // 过滤特殊值，避免产生错误URL
                if (url === "productList") {
                    return;
                }
                this.currentPage = url;
            },
            logout() {
                window.location.href = "LogoutServlet";
            },
            goLoginPage() {
                this.currentPage = 'Login.jsp';
            },
            // 初始化 Layui
            initLayui() {
                // 等待 DOM 完全加载
                this.$nextTick(() => {
                    // 使用 layui 模块
                    layui.use(['element', 'layer'], () => {
                        const layer = layui.layer;

                        // 为商品列表按钮添加点击事件
                        const productListBtn = document.getElementById('viewProductList');
                        if (productListBtn) {
                            productListBtn.addEventListener('click', () => {
                                // 显示加载提示
                                layer.load(1, {
                                    shade: [0.1, '#fff']
                                });

                                // 直接加载 ProductList.jsp，它会通过 Ajax 请求 ProductServlet
                                this.currentPage = 'ProductList.jsp';

                                // 0.5秒后关闭加载提示
                                setTimeout(() => {
                                    layer.closeAll('loading');
                                }, 500);
                            });
                        }
                    });
                });
            }
        }
    });
</script>

</body>
</html>