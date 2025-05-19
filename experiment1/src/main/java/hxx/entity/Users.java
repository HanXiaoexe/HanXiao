package hxx.entity;

public class Users {
    private Integer userId;
    private String userName;
    private String password;
    private String sex;
    private String email;

    public Users() {
    }

    // 修正构造函数，正确赋值字段
    public Users(String userName, String password, String email, String sex) {
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.sex = sex;
    }


    public Users(Integer userId, String userName, String password, String email, String sex) {
        this.userId = userId;
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.sex = sex;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
