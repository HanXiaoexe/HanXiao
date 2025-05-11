package HX.Service;

import HX.Dao.ProductDao;
import HX.entity.Product;

import java.util.List;

public class ProductService {

    private ProductDao productDao = new ProductDao();  // 使用ProductDao与数据库交互

    // 获取所有商品列表
    public List<Product> getAllProducts() {
        return productDao.getAllProducts();
    }

    // 根据商品ID获取商品详情
    public Product getProductById(int productId) {
        return productDao.getProductById(productId);
    }
}
