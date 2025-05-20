package HX.Controller;

import HX.Service.ProductService;
import HX.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置字符编码，避免中文乱码
        request.setCharacterEncoding("UTF-8");

        // 获取请求参数
        String action = request.getParameter("action");
        String format = request.getParameter("format");

        if ("list".equals(action)) {
            // 处理商品列表请求
            handleProductList(request, response, format);
        } else if ("detail".equals(action)) {
            // 处理商品详情请求
            handleProductDetail(request, response);
        } else if ("update".equals(action)) {
            // 处理更新商品请求
            handleProductUpdate(request, response);
        } else if ("delete".equals(action)) {
            // 处理删除商品请求
            handleProductDelete(request, response);
        } else if ("getById".equals(action)) {
            // 通过ID获取商品信息（用于编辑表单）
            handleGetProductById(request, response);
        }
    }

    /**
     * 处理商品列表请求
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @param format 返回格式，json或html
     */
    private void handleProductList(HttpServletRequest request, HttpServletResponse response, String format)
            throws ServletException, IOException {
        // 获取所有商品
        List<Product> allProducts = productService.getAllProducts();

        // 如果是JSON格式请求，进行分页处理
        if ("json".equals(format)) {
            response.setContentType("application/json;charset=UTF-8");

            // 获取分页参数
            int page = 1;
            int limit = 10;

            try {
                // 尝试从请求中获取页码和每页数量
                String pageStr = request.getParameter("page");
                String limitStr = request.getParameter("limit");
                if (pageStr != null && !pageStr.isEmpty()) {
                    page = Integer.parseInt(pageStr);
                }
                if (limitStr != null && !limitStr.isEmpty()) {
                    limit = Integer.parseInt(limitStr);
                }
            } catch (NumberFormatException e) {
                // 如果参数无法解析为数字，使用默认值
                page = 1;
                limit = 10;
            }

            // 获取搜索参数
            String searchName = request.getParameter("name");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");
            String sortField = request.getParameter("field");
            String sortOrder = request.getParameter("order");

            // 过滤商品列表
            List<Product> filteredProducts = filterProducts(
                    allProducts, searchName, minPriceStr, maxPriceStr, sortField, sortOrder);

            // 计算分页数据
            int total = filteredProducts.size();
            int fromIndex = (page - 1) * limit;
            int toIndex = Math.min(fromIndex + limit, total);

            // 截取当前页的数据
            List<Product> pageData;
            if (fromIndex < toIndex) {
                pageData = filteredProducts.subList(fromIndex, toIndex);
            } else {
                pageData = new ArrayList<>(); // 空列表
            }

            // 构建Layui表格所需的JSON格式
            String jsonResponse = buildJsonResponse(pageData, total);
            response.getWriter().write(jsonResponse);
        } else {
            // 传统方式，转发到JSP页面
            request.setAttribute("productList", allProducts);
            request.getRequestDispatcher("/ProductList.jsp").forward(request, response);
        }
    }

    /**
     * 通过ID获取单个商品信息（用于编辑表单）
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     */
    private void handleGetProductById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product product = productService.getProductById(productId);

            if (product != null) {
                // 构建JSON响应
                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("{\"code\":0,\"msg\":\"success\",\"data\":{")
                        .append("\"id\":").append(product.getId())
                        .append(",\"name\":\"").append(escapeJsonString(product.getName())).append("\"")
                        .append(",\"price\":").append(product.getPrice())
                        .append(",\"description\":\"").append(escapeJsonString(product.getDescription())).append("\"")
                        .append(",\"stock\":").append(product.getStock());

                // 如果imageUrl不为空，添加到JSON中
                if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) {
                    jsonBuilder.append(",\"imageUrl\":\"").append(escapeJsonString(product.getImageUrl())).append("\"");
                }

                jsonBuilder.append("}}");
                response.getWriter().write(jsonBuilder.toString());
            } else {
                response.getWriter().write("{\"code\":1,\"msg\":\"商品不存在\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"code\":1,\"msg\":\"无效的商品ID\"}");
        }
    }

    /**
     * 处理更新商品请求
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     */
    private void handleProductUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            // 从请求中获取商品信息
            int productId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String imageUrl = request.getParameter("imageUrl");

            // 创建商品对象
            Product product = new Product();
            product.setId(productId);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImageUrl(imageUrl);

            // 更新商品
            boolean success = productService.updateProduct(product);

            // 返回结果
            Map<String, Object> result = new HashMap<>();
            if (success) {
                result.put("code", 0);
                result.put("msg", "商品更新成功");
            } else {
                result.put("code", 1);
                result.put("msg", "商品更新失败");
            }

            // 构建JSON响应
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\"code\":").append(result.get("code"))
                    .append(",\"msg\":\"").append(result.get("msg")).append("\"}");

            response.getWriter().write(jsonBuilder.toString());
        } catch (Exception e) {
            response.getWriter().write("{\"code\":1,\"msg\":\"更新商品时发生错误: " + e.getMessage() + "\"}");
        }
    }

    /**
     * 处理删除商品请求
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     */
    private void handleProductDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            // 从请求中获取商品ID
            int productId = Integer.parseInt(request.getParameter("productId"));

            // 删除商品
            boolean success = productService.deleteProduct(productId);

            // 返回结果
            Map<String, Object> result = new HashMap<>();
            if (success) {
                result.put("code", 0);
                result.put("msg", "商品删除成功");
            } else {
                result.put("code", 1);
                result.put("msg", "商品删除失败");
            }

            // 构建JSON响应
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{\"code\":").append(result.get("code"))
                    .append(",\"msg\":\"").append(result.get("msg")).append("\"}");

            response.getWriter().write(jsonBuilder.toString());
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"code\":1,\"msg\":\"无效的商品ID\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"code\":1,\"msg\":\"删除商品时发生错误: " + e.getMessage() + "\"}");
        }
    }

    /**
     * 过滤商品列表
     * @param products 原始商品列表
     * @param searchName 搜索名称
     * @param minPriceStr 最低价格字符串
     * @param maxPriceStr 最高价格字符串
     * @param sortField 排序字段
     * @param sortOrder 排序顺序（asc/desc）
     * @return 过滤后的商品列表
     */
    private List<Product> filterProducts(
            List<Product> products,
            String searchName,
            String minPriceStr,
            String maxPriceStr,
            String sortField,
            String sortOrder) {

        // 创建结果列表
        List<Product> result = new ArrayList<>();

        // 解析价格范围
        double minPrice = -1;
        double maxPrice = Double.MAX_VALUE;

        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
            }
        } catch (NumberFormatException e) {
            // 价格格式无效时使用默认值
        }

        // 过滤商品
        for (Product product : products) {
            boolean nameMatch = searchName == null || searchName.isEmpty() ||
                    product.getName().toLowerCase().contains(searchName.toLowerCase());

            boolean priceMatch = product.getPrice() >= minPrice && product.getPrice() <= maxPrice;

            if (nameMatch && priceMatch) {
                result.add(product);
            }
        }

        // 排序
        if (sortField != null && !sortField.isEmpty()) {
            boolean isAsc = !"desc".equals(sortOrder);

            result.sort((p1, p2) -> {
                int compareResult = 0;

                // 根据字段进行比较
                switch (sortField) {
                    case "id":
                        compareResult = Integer.compare(p1.getId(), p2.getId());
                        break;
                    case "price":
                        compareResult = Double.compare(p1.getPrice(), p2.getPrice());
                        break;
                    case "stock":
                        compareResult = Integer.compare(p1.getStock(), p2.getStock());
                        break;
                    case "name":
                        compareResult = p1.getName().compareTo(p2.getName());
                        break;
                    default:
                        // 默认按ID排序
                        compareResult = Integer.compare(p1.getId(), p2.getId());
                }

                // 根据排序方向返回结果
                return isAsc ? compareResult : -compareResult;
            });
        }

        return result;
    }

    /**
     * 构建JSON响应数据
     * @param products 当前页的商品列表
     * @param total 总记录数
     * @return JSON格式的响应字符串
     */
    private String buildJsonResponse(List<Product> products, int total) {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{\"code\":0,\"msg\":\"\",\"count\":").append(total).append(",\"data\":[");

        for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            jsonBuilder.append("{\"id\":").append(p.getId())
                    .append(",\"name\":\"").append(escapeJsonString(p.getName())).append("\"")
                    .append(",\"price\":").append(p.getPrice())
                    .append(",\"description\":\"").append(escapeJsonString(p.getDescription())).append("\"")
                    .append(",\"stock\":").append(p.getStock());

            // 如果imageUrl不为空，添加到JSON中
            if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) {
                jsonBuilder.append(",\"imageUrl\":\"").append(escapeJsonString(p.getImageUrl())).append("\"");
            }

            jsonBuilder.append("}");
            if (i < products.size() - 1) {
                jsonBuilder.append(",");
            }
        }
        jsonBuilder.append("]}");

        return jsonBuilder.toString();
    }

    /**
     * 处理商品详情请求
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     */
    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product product = productService.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/ProductDetail.jsp").forward(request, response);
            } else {
                response.getWriter().write("商品不存在");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("无效的商品ID");
        }
    }

    /**
     * 转义JSON字符串中的特殊字符
     * @param input 输入字符串
     * @return 转义后的字符串
     */
    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}