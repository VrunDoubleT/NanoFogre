package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Customer {

    private int id;
    private String email;
    private String password;
    private String name;
    private String avatar;
    private String phone;
    private LocalDateTime createdAt;
    private boolean isBlock;

    public Customer() {
    }

    public Customer(int id, String email, String password, String name, String avatar, String phone, LocalDateTime createdAt, boolean isBlock) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.avatar = avatar;
        this.phone = phone;
        this.createdAt = createdAt;
        this.isBlock = isBlock;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isIsBlock() {
        return isBlock;
    }

    public void setIsBlock(boolean isBlock) {
        this.isBlock = isBlock;
    }

    @Override
    public String toString() {
        return "Customer{" + "id=" + id + ", email=" + email + ", password=" + password + ", name=" + name + ", avatar=" + avatar + ", phone=" + phone + ", createdAt=" + createdAt + '}';
    }

}
