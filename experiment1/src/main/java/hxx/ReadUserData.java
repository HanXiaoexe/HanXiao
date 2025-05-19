package hxx;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class ReadUserData {
    public static void main(String[] args) {
        Properties props = new Properties();

        try (InputStream input = ReadUserData.class.getClassLoader().getResourceAsStream("Properties")) {
            if (input == null) {
                System.out.println("无法找到 db.properties 文件");
                return;
            }

            // 加载配置文件
            props.load(input);
            String url = props.getProperty("url");
            String user = props.getProperty("user");
            String password = props.getProperty("password");
            String driver = props.getProperty("driver");

            // 加载 JDBC 驱动
            Class.forName(driver);

            // 建立连接
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sql = "SELECT * FROM user";
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(sql)) {

                    // 输出数据
                    while (rs.next()) {
                        int id = rs.getInt("id");  // 假设user表有id字段
                        String userName = rs.getString("userName");
                        String email = rs.getString("email");
                        String gender = rs.getString("gender");

                        System.out.println("ID: " + id + ", 用户名: " + userName + ", 邮箱: " + email + ", 性别: " + gender);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
