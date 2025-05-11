<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="HX.entity.Product" %>
<%@ page import="HX.Service.ProductService" %>


<%
    String id = request.getParameter("id");
    ProductService productService = new ProductService();
    Product product = productService.getProductById(Integer.parseInt(id));
    request.setAttribute("product", product);
%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - 商品详情</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/element-ui/lib/theme-chalk/index.css" rel="stylesheet">
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <style>
        body {
            background: #f9f9f9;
            padding: 20px;
        }
        .product-detail {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .product-title {
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .product-price {
            color: #e4393c;
            font-size: 24px;
            margin: 20px 0;
            font-weight: bold;
        }
        .product-description {
            font-size: 16px;
            color: #555;
            margin-top: 20px;
        }
        .product-img {
            width: 100%;
            max-width: 450px;
            object-fit: cover;
            border-radius: 10px;
            transition: transform 0.5s;
        }
        .product-img:hover {
            transform: scale(1.03);
        }
        .el-button--primary {
            transition: all 0.3s;
        }
        .el-button--primary:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(64,158,255,0.4);
        }
    </style>
</head>

<body>
<div id="app">
    <div class="container">
        <div class="row">
            <div class="col-md-5">
                <img src="${product.imageUrl}" alt="${product.name}" class="product-img">
            </div>
            <div class="col-md-7">
                <div class="product-detail">
                    <div class="product-title">${product.name}</div>
                    <div class="product-price">¥ ${product.price}</div>
                    <div class="product-description">${product.description}</div>
                    <el-button type="primary" size="medium" @click="addToCart(${product.id})" style="margin-top:30px;">加入购物车</el-button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    new Vue({
        el: '#app',
        methods: {
            addToCart(productId) {
                // 调用Servlet加购物车
                $.get("AddToCartServlet", {productId: productId}, (res) => {
                    if (res.trim() === 'success') {
                        this.$message({
                            message: '✅ 商品成功加入购物车！',
                            type: 'success',
                            duration: 2000
                        });
                    } else {
                        this.$message({
                            message: '❌ 加入购物车失败，请重试',
                            type: 'error',
                            duration: 2000
                        });
                    }
                });
            }
        }
    });
</script>

</body>
</html>
