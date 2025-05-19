package hxx.dao;

import hxx.entity.Users;
import hxx.util.JdbcUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    public int addUser(Users user) {
        String sql = "INSERT INTO users(userName, password, sex, email) VALUES (?, ?, ?, ?)";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int generatedId = -1;

        try {
            con = JdbcUtil.getConnection();
            if (con != null) {
                ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, user.getUserName());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getSex());
                ps.setString(4, user.getEmail());

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            } else {
                throw new SQLException("Failed to add user: Connection is null");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(con, ps, rs);
        }
        return generatedId;
    }

    public Users getUserByUsernameAndPassword(String userName, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Users user = null;

        try {
            con = JdbcUtil.getConnection();
            String sql = "SELECT * FROM users WHERE userName = ? AND password = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, userName);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new Users();
                user.setUserName(rs.getString("userName"));
                user.setPassword(rs.getString("password"));
                user.setSex(rs.getString("sex"));
                user.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(con, ps, rs);
        }

        return user;
    }

    public List<Users> getAllUsers() {
        List<Users> userList = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users user = new Users();
                user.setUserName(rs.getString("userName"));
                user.setPassword(rs.getString("password"));
                user.setSex(rs.getString("sex"));
                user.setEmail(rs.getString("email"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // 按用户名模糊查询用户
    public List<Users> searchUsersByUserName(String userName) {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE userName LIKE ?";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + userName + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Users user = new Users(
                            rs.getString("userName"),
                            rs.getString("password"),
                            rs.getString("email"),
                            rs.getString("sex")
                    );
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // 更新用户信息
    public boolean updateUser(Users user) {
        String sql = "UPDATE users SET password = ?, email = ? ,sex = ? WHERE userName = ?";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getPassword());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getSex());
            ps.setString(4, user.getUserName());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteUser(String userName) {
        String sql = "DELETE FROM users WHERE userName = ?";
        try (Connection con = JdbcUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userName);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}