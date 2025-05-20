<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Layui -->
    <link rel="stylesheet" href="https://www.layuicdn.com/layui-v2.6.8/css/layui.css">
    <script src="https://www.layuicdn.com/layui-v2.6.8/layui.js"></script>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <style>
        /* 全局样式，使页面占满整个iframe */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* 防止出现滚动条导致布局跳动 */
        }

        /* 容器样式，确保内容占满整个页面 */
        .main-container {
            height: 100%;
            padding: 15px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
        }

        /* 表格容器，使其填充剩余空间 */
        .table-container {
            flex: 1;
            overflow: auto;
            position: relative;
        }

        /* 自定义表格单元格样式，允许内容换行显示 */
        .layui-table-cell {
            height: auto;
            line-height: 28px;
            padding: 6px 15px;
            position: relative;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: normal;
            box-sizing: border-box;
        }

        /* 设置商品图片大小 */
        .product-image {
            max-width: 100px;
            max-height: 100px;
            transition: transform 0.3s ease;
        }

        /* 鼠标悬停时图片放大效果 */
        .product-image:hover {
            transform: scale(1.2);
            cursor: pointer;
        }

        /* 页面标题样式 */
        .page-title {
            font-size: 24px;
            font-weight: bold;
            color: #409EFF;
            margin-bottom: 15px;
            text-align: center;
            position: relative;
            padding-bottom: 10px;
        }

        .page-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 3px;
            background: #409EFF;
        }

        /* 搜索区域样式 */
        .search-area {
            margin-bottom: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* 操作按钮样式 */
        .layui-btn-xs {
            height: 28px;
            line-height: 28px;
            padding: 0 10px;
            font-size: 12px;
        }

        /* 确保表格在容器内部正常显示 */
        .layui-table-view {
            margin: 0;
        }

        /* 响应式布局调整 */
        @media screen and (max-width: 768px) {
            .layui-form-item .layui-inline {
                margin-bottom: 5px;
                margin-right: 0;
                width: 100%;
            }
            .layui-form-label {
                width: auto;
                padding-left: 0;
            }
            .layui-input-inline {
                margin-right: 0;
                width: auto !important;
            }
        }

        /* 编辑表单样式 */
        .edit-form .layui-form-label {
            width: 100px;
        }

        .edit-form .layui-input-block {
            margin-left: 130px;
        }
    </style>
</head>
<body>

<div class="main-container">
    <!-- 页面标题 -->
    <h1 class="page-title">商品列表</h1>

    <!-- 搜索区域 -->
    <div class="search-area">
        <div class="layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">商品名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchName" placeholder="请输入商品名称" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">价格区间</label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" id="minPrice" placeholder="￥" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" id="maxPrice" placeholder="￥" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <button id="searchBtn" class="layui-btn layui-btn-normal">
                        <i class="layui-icon layui-icon-search"></i> 搜索
                    </button>
                    <button id="resetBtn" class="layui-btn layui-btn-primary">
                        <i class="layui-icon layui-icon-refresh"></i> 重置
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 表格容器 -->
    <div class="table-container">
        <!-- Layui表格 -->
        <table id="productTable" lay-filter="productTable"></table>
    </div>

    <!-- 操作按钮模板 -->
    <script type="text/html" id="operationBar">
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="detail">查看详情</a>
        <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
        <a class="layui-btn layui-btn-xs" lay-event="addToCart">加入购物车</a>
    </script>

    <!-- 图片模板 -->
    <script type="text/html" id="imageTpl">
        {{#  if(d.imageUrl){ }}
        <img src="{{d.imageUrl}}" class="product-image" alt="{{d.name}}" onclick="showBigImage('{{d.imageUrl}}', '{{d.name}}')">
        {{#  } else { }}
        <span>无图片</span>
        {{#  } }}
    </script>

    <!-- 自定义价格显示模板 -->
    <script type="text/html" id="priceTpl">
        <span style="color: #ff6b6b; font-weight: bold;">￥{{d.price}}</span>
    </script>

    <!-- 自定义库存显示模板 -->
    <script type="text/html" id="stockTpl">
        {{# if(d.stock > 50) { }}
        <span class="layui-badge layui-bg-green">{{d.stock}}</span>
        {{# } else if(d.stock > 20) { }}
        <span class="layui-badge layui-bg-blue">{{d.stock}}</span>
        {{# } else { }}
        <span class="layui-badge layui-bg-orange">{{d.stock}}</span>
        {{# } }}
    </script>
</div>

<!-- 放大图片的模态框 -->
<div id="imageModal" style="display:none; text-align: center;">
    <img id="largeImage" src="" style="max-width: 90%; max-height: 90%;" />
    <div id="imageTitle" style="margin-top: 10px; font-size: 16px; font-weight: bold;"></div>
</div>

<!-- 编辑商品表单 -->
<div id="editFormContainer" style="display:none; padding: 20px;">
    <form class="layui-form edit-form" id="editForm" lay-filter="editForm">
        <input type="hidden" name="id" id="editId">

        <div class="layui-form-item">
            <label class="layui-form-label">商品名称</label>
            <div class="layui-input-block">
                <input type="text" name="name" required lay-verify="required" placeholder="请输入商品名称"
                       autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">商品价格</label>
            <div class="layui-input-block">
                <input type="text" name="price" required lay-verify="required|number" placeholder="请输入价格"
                       autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">库存数量</label>
            <div class="layui-input-block">
                <input type="text" name="stock" required lay-verify="required|number" placeholder="请输入库存数量"
                       autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">图片URL</label>
            <div class="layui-input-block">
                <input type="text" name="imageUrl" placeholder="请输入商品图片URL"
                       autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">商品描述</label>
            <div class="layui-input-block">
                <textarea name="description" placeholder="请输入商品描述" class="layui-textarea"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="saveEditForm">保存</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>

<script>
    // 显示大图的函数
    function showBigImage(url, title) {
        document.getElementById('largeImage').src = url;
        document.getElementById('imageTitle').innerText = title;

        // 使用Layui的layer模块显示模态框
        layui.use('layer', function(){
            var layer = layui.layer;
            layer.open({
                type: 1,
                title: '商品图片预览',
                content: $('#imageModal'),
                area: ['60%', '70%'],
                shadeClose: true
            });
        });
    }

    // 当文档加载完成后执行
    layui.use(['table', 'layer', 'form', 'laypage'], function() {
        var table = layui.table;
        var layer = layui.layer;
        var form = layui.form;
        var laypage = layui.laypage;

        // 获取窗口高度，用于计算表格高度
        var getTableHeight = function() {
            // 计算表格应该的高度
            var searchAreaHeight = document.querySelector('.search-area').offsetHeight;
            var titleHeight = document.querySelector('.page-title').offsetHeight;
            var containerHeight = document.querySelector('.main-container').offsetHeight;
            // 预留一些边距
            var padding = 50;
            // 计算表格应该的高度
            return containerHeight - searchAreaHeight - titleHeight - padding;
        };

        // 初始化表格
        var tableIns = table.render({
            elem: '#productTable',                          // 指定表格容器
            url: 'ProductServlet?action=list&format=json',  // 数据接口URL
            page: true,                                     // 开启分页
            limits: [5, 10, 15, 20, 50, 100],               // 每页条数选择列表
            limit: 10,                                      // 默认每页显示的数量
            skin: 'line',                                   // 表格风格
            even: true,                                     // 开启隔行背景
            size: 'lg',                                     // 表格尺寸
            height: getTableHeight(),                       // 设置表格高度，自适应
            text: {
                none: '暂无相关数据' // 空数据提示文本
            },
            // 表头设置
            cols: [[
                {type: 'checkbox', fixed: 'left', width: 50},  // 复选框列
                {field: 'id', title: 'ID', width: 80, sort: true, fixed: 'left'}, // ID列，支持排序
                {field: 'imageUrl', title: '商品图片', width: 120, templet: '#imageTpl'}, // 商品图片列，使用自定义模板
                {field: 'name', title: '商品名称', width: 200}, // 商品名称列
                {field: 'price', title: '价格', width: 100, sort: true, templet: '#priceTpl'}, // 价格列，使用自定义模板
                {field: 'stock', title: '库存', width: 100, sort: true, templet: '#stockTpl'}, // 库存列，使用自定义模板
                {field: 'description', title: '描述', minWidth: 300}, // 商品描述列，最小宽度
                {fixed: 'right', title: '操作', toolbar: '#operationBar', width: 300} // 操作列，使用自定义工具条
            ]],

            // 请求发送前的回调，用于处理请求参数
            request: {
                pageName: 'page', // 页码的参数名称
                limitName: 'limit' // 每页数据量的参数名称
            },
            // 解析服务器返回的数据
            parseData: function(res) {
                return {
                    "code": res.code, // 状态码
                    "msg": res.msg,   // 提示文本
                    "count": res.count, // 总数据条数
                    "data": res.data   // 列表数据
                };
            },
            // 数据渲染完成的回调
            done: function() {
                console.log('表格加载完成');
            }
        });

        // 监听窗口大小变化，重新计算表格高度
        window.addEventListener('resize', function() {
            // 延迟重载表格，确保DOM元素已经重新计算完尺寸
            clearTimeout(window.resizeTimer);
            window.resizeTimer = setTimeout(function() {
                tableIns.reload({
                    height: getTableHeight()
                });
            }, 100);
        });

        // 监听搜索按钮点击事件
        $('#searchBtn').on('click', function() {
            var searchName = $('#searchName').val();
            var minPrice = $('#minPrice').val();
            var maxPrice = $('#maxPrice').val();

            // 表格重载，传入搜索参数
            tableIns.reload({
                where: {
                    name: searchName,
                    minPrice: minPrice,
                    maxPrice: maxPrice
                },
                page: {
                    curr: 1 // 从第一页开始
                }
            });
        });

        // 监听重置按钮点击事件
        $('#resetBtn').on('click', function() {
            // 清空输入框
            $('#searchName').val('');
            $('#minPrice').val('');
            $('#maxPrice').val('');

            // 重置表格，不传任何搜索参数
            tableIns.reload({
                where: {
                    name: '',
                    minPrice: '',
                    maxPrice: ''
                },
                page: {
                    curr: 1 // 从第一页开始
                }
            });
        });

        // 监听工具条点击事件
        table.on('tool(productTable)', function(obj) {
            var data = obj.data;      // 获得当前行数据
            var layEvent = obj.event;  // 获得 lay-event 对应的值
            var tr = obj.tr;          // 获得当前行 tr 的 DOM 对象

            // 查看详情
            if (layEvent === 'detail') {
                // 跳转到商品详情页
                window.parent.document.querySelector('#app').__vue__.currentPage = 'ProductServlet?action=detail&productId=' + data.id;
            }
            // 编辑商品
            else if (layEvent === 'edit') {
                // 加载商品数据
                $.ajax({
                    url: 'ProductServlet?action=getById&productId=' + data.id,
                    type: 'GET',
                    dataType: 'json',
                    success: function(res) {
                        if (res.code === 0) {
                            // 打开编辑表单
                            var editIndex = layer.open({
                                type: 1,
                                title: '编辑商品',
                                content: $('#editFormContainer'),
                                area: ['500px', '550px'],
                                success: function() {
                                    // 表单赋值
                                    form.val('editForm', res.data);
                                }
                            });
                        } else {
                            layer.msg(res.msg, {icon: 2});
                        }
                    },
                    error: function() {
                        layer.msg('加载商品数据失败', {icon: 2});
                    }
                });
            }
            // 删除商品
            else if (layEvent === 'delete') {
                layer.confirm('确认删除该商品吗？', {icon: 3, title:'提示'}, function(index){
                    // 发送ajax请求删除商品
                    $.ajax({
                        url: 'ProductServlet?action=delete&productId=' + data.id,
                        type: 'POST',
                        dataType: 'json',
                        success: function(res) {
                            if (res.code === 0) {
                                layer.msg(res.msg, {icon: 1});
                                // 删除成功后刷新表格
                                tableIns.reload();
                            } else {
                                layer.msg(res.msg, {icon: 2});
                            }
                        },
                        error: function() {
                            layer.msg('删除请求发送失败', {icon: 2});
                        }
                    });

                    layer.close(index);
                });
            }
            // 加入购物车
            else if (layEvent === 'addToCart') {
                // 这里可以添加购物车逻辑
                layer.msg('商品 ' + data.name + ' 已添加到购物车', {
                    icon: 1,
                    time: 2000
                });
            }
        });

        // 监听表单提交
        form.on('submit(saveEditForm)', function(data) {
            // 发送ajax请求保存编辑的商品数据
            $.ajax({
                url: 'ProductServlet?action=update',
                type: 'POST',
                data: data.field,
                dataType: 'json',
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg(res.msg, {icon: 1});
                        // 关闭表单
                        layer.closeAll('page');
                        // 刷新表格
                        tableIns.reload();
                    } else {
                        layer.msg(res.msg, {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('保存请求发送失败', {icon: 2});
                }
            });

            // 阻止表单跳转
            return false;
        });

        // 监听表格复选框选择事件
        table.on('checkbox(productTable)', function(obj) {
            console.log(obj);
        });

        // 监听排序事件
        table.on('sort(productTable)', function(obj) {
            // 重载表格，按照排序参数重新请求
            tableIns.reload({
                initSort: obj, // 记录初始排序，如果不设定，则重载时丢失排序状态
                where: { // 请求参数
                    field: obj.field, // 排序字段
                    order: obj.type   // 排序方式
                }
            });
        });
    });
</script>

</body>
</html>