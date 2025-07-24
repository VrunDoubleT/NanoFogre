package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Employee {

    private int id;
    private String email;
    private String password;
    private String newPassword;
    private String name;
    private String avatar;
    private String citizenIdentityId;
    private String phoneNumber;
    private LocalDate dateOfBirth;
    private String gender;
    private String address;
    private Role role;
    private boolean isBlock;
    private boolean destroy;
    private LocalDateTime createdAt;

    public Employee() {
    }

    public Employee(int id, String email, String password, String newPassword, String name, String avatar,
            String citizenIdentityId, String phoneNumber, LocalDate dateOfBirth, String gender,
            String address, Role role, boolean isBlock, boolean destroy, LocalDateTime createdAt) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.newPassword = newPassword;
        this.name = name;
        this.avatar = avatar;
        this.citizenIdentityId = citizenIdentityId;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.role = role;
        this.isBlock = isBlock;
        this.destroy = destroy;
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

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
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

    public String getCitizenIdentityId() {
        return citizenIdentityId;
    }

    public void setCitizenIdentityId(String citizenIdentityId) {
        this.citizenIdentityId = citizenIdentityId;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public void setIsBlock(boolean block) {
        isBlock = block;
    }

    public boolean isDestroy() {
        return destroy;
    }

    public void setDestroy(boolean destroy) {
        this.destroy = destroy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Employee{"
                + "id=" + id
                + ", email='" + email + '\''
                + ", password='" + password + '\''
                + ", newPassword='" + newPassword + '\''
                + ", name='" + name + '\''
                + ", avatar='" + avatar + '\''
                + ", citizenIdentityId='" + citizenIdentityId + '\''
                + ", phoneNumber='" + phoneNumber + '\''
                + ", dateOfBirth=" + dateOfBirth
                + ", gender='" + gender + '\''
                + ", address='" + address + '\''
                + ", role=" + role
                + ", isBlock=" + isBlock
                + ", destroy=" + destroy
                + ", createdAt=" + createdAt
                + '}';
    }
}
