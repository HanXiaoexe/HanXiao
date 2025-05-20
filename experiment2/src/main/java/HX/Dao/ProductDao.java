package HX.Dao;

import HX.entity.Product;
import HX.Util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    // 获取所有商品
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM product";  // 假设商品表名是 product

        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            // 获取数据库连接
            connection = DBUtil.getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(query);

            while (resultSet.next()) {
                Product product = new Product();
                product.setId(resultSet.getInt("id"));
                product.setName(resultSet.getString("name"));
                product.setDescription(resultSet.getString("description"));
                product.setPrice(resultSet.getDouble("price"));
                product.setImageUrl(resultSet.getString("image_url"));
                product.setStock(resultSet.getInt("stock"));
                product.setCreateTime(resultSet.getTimestamp("create_time"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(connection, statement, resultSet);
        }

        return products;
    }

    // 根据商品ID获取商品
    public Product getProductById(int productId) {
        Product product = null;
        String query = "SELECT * FROM product WHERE id = ?";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            // 获取数据库连接
            connection = DBUtil.getConnection();
            statement = connection.prepareStatement(query);
            statement.setInt(1, productId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                product = new Product();
                product.setId(resultSet.getInt("id"));
                product.setName(resultSet.getString("name"));
                product.setDescription(resultSet.getString("description"));
                product.setPrice(resultSet.getDouble("price"));
                product.setImageUrl(resultSet.getString("image_url"));
                product.setStock(resultSet.getInt("stock"));
                product.setCreateTime(resultSet.getTimestamp("create_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(connection, statement, resultSet);
        }

        return product;
    }

    // 更新商品信息
    public boolean updateProduct(Product product) {
        String query = "UPDATE product SET name = ?, description = ?, price = ?, image_url = ?, stock = ? WHERE id = ?";
        Connection connection = null;
        PreparedStatement statement = null;
        boolean success = false;

        try {
            connection = DBUtil.getConnection();
            statement = connection.prepareStatement(query);
            statement.setString(1, product.getName());
            statement.setString(2, product.getDescription());
            statement.setDouble(3, product.getPrice());
            statement.setString(4, product.getImageUrl());
            statement.setInt(5, product.getStock());
            statement.setInt(6, product.getId());

            int rowsAffected = statement.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(connection, statement, null);
        }

        return success;
    }

    // 删除商品
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM product WHERE id = ?";
        Connection connection = null;
        PreparedStatement statement = null;
        boolean success = false;

        try {
            connection = DBUtil.getConnection();
            statement = connection.prepareStatement(query);
            statement.setInt(1, productId);

            int rowsAffected = statement.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(connection, statement, null);
        }

        return success;
    }
}