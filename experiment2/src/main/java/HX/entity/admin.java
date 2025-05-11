package HX.entity;

import java.util.Date;

public class admin {
    private int id;
    private String adminName;
    private String password;
    private String email;
    private Date createTime;

    // 构造方法
    public admin() {}

    public admin(int id, String adminName, String password, String email, Date createTime) {
        this.id = id;
        this.adminName = adminName;
        this.password = password;
        this.email = email;
        this.createTime = createTime;
    }

    // Getter和Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAdminName() { return adminName; }
    public void setUsername(String adminName) { this.adminName= adminName; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
