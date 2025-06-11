package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Employee {
    private int id;
    private String email;
    private String password;
    private String name;
    private String avatar;
    private Role role;
    private boolean isBlock;
    private LocalDateTime createdAt;

    public Employee() {
    }

    public Employee(int id, String email, String password, String name, String avatar, Role role, boolean isBlock, LocalDateTime createdAt) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.avatar = avatar;
        this.role = role;
        this.isBlock = isBlock;
        this.createdAt = createdAt;
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

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isIsBlock() {
        return isBlock;
    }

    public void setIsBlock(boolean isBlock) {
        this.isBlock = isBlock;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Employee{" + "id=" + id + ", email=" + email + ", password=" + password + ", name=" + name + ", avatar=" + avatar + ", role=" + role + ", isBlock=" + isBlock + ", createdAt=" + createdAt + '}';
    }

    
}
