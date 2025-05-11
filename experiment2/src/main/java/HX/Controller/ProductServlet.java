import HX.Service.ProductService;
import HX.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private ProductService productService = new ProductService(); // 使用 ProductService 获取商品数据

    // 处理显示商品列表
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置字符编码，避免中文乱码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            // 获取所有商品列表
            List<Product> productList = productService.getAllProducts();
            request.setAttribute("productList", productList);
            // 转发到商品列表的 JSP 页面
            request.getRequestDispatcher("/ProductList.jsp").forward(request, response);
        } else if ("detail".equals(action)) {
            // 获取商品详情
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                Product product = productService.getProductById(productId);

                if (product != null) {
                    request.setAttribute("product", product);
                    // 转发到商品详情页面
                    request.getRequestDispatcher("/ProductDetail.jsp").forward(request, response);
                } else {
                    response.getWriter().write("商品不存在");
                }
            } catch (NumberFormatException e) {
                response.getWriter().write("无效的商品ID");
            }
        }
    }

    // 处理其他请求（如 POST，若有扩展需求）
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);  // 默认转到 GET 处理
    }
}
