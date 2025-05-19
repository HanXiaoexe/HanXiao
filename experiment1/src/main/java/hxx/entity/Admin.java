package hxx.entity;

public class Admin {
    private String AdminName;
    private String password;
    // 其他管理员属性的getter和setter方法


    public String getAdminName() {
        return AdminName;
    }

    public void setAdminName(String adminName) {
        AdminName = adminName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}