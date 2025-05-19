package hxx.dao;

import hxx.entity.Admin;
import hxx.util.JdbcUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDao {
    // 根据用户名和密码验证管理员登录
    public Admin getAdminByUsernameAndPassword(String AdminName, String password) {
        Admin admin = null;
        String sql = "SELECT * FROM admin WHERE AdminName = ? AND password = ?";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, AdminName);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminName(rs.getString("AdminName"));
                    admin.setPassword(rs.getString("password"));
                    // 设置其他管理员属性
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }

    public void updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET password = ? WHERE AdminName = ?";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, admin.getPassword());
            ps.setString(2, admin.getAdminName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}