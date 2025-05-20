package HX.Dao;

import HX.Util.DBUtil;
import HX.entity.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDao {

    // 根据用户名和密码查询管理员
    public admin login(String username, String password) {
        String sql = "SELECT * FROM Admin WHERE username = ? AND password = ?";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        admin admin = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                admin = new admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setEmail(rs.getString("email"));
                admin.setCreateTime(rs.getTimestamp("create_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(con, ps, rs);
        }
        return admin;
    }
}
