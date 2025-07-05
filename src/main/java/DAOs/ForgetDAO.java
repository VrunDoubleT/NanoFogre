/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Employee;
import Models.Customer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ForgetDAO extends DB.DBContext {
    // ========= EMPLOYEE =========
    public boolean checkVerifyCode(int userId, String code) {
        String sql = "SELECT COUNT(*) AS count FROM VerifyCodes WHERE userId = ? AND code = ? AND isVerified = 0 AND expiredAt > ?";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{userId, code, Timestamp.valueOf(LocalDateTime.now())})) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean markCodeAsUsed(int userId, String code) {
        String sql = "UPDATE VerifyCodes SET isVerified = 1 WHERE userId = ? AND code = ?";
        try {
            int rows = this.execQuery(sql, new Object[]{userId, code});
            return rows > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateNewPasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Employees SET employeeNewPassword = ? WHERE employeeEmail = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, email});
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean confirmResetPassword(int userId, String newPassword) {
        String sql = "UPDATE Employees SET employeePassword = ?, employeeNewPassword = NULL WHERE employeeId = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, userId});
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Employee findByEmail(String email) {
        String sql = "SELECT * FROM Employees WHERE employeeEmail = ? AND isBlock=0 AND _destroy=0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs.next()) {
                Employee emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                emp.setEmail(rs.getString("employeeEmail"));
                // ... set các trường khác nếu muốn
                return emp;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean insertCode(int userId, String code, LocalDateTime expiredAt) {
        String sql = "INSERT INTO VerifyCodes (userId, code, isVerified, createdAt, expiredAt) VALUES (?, ?, 0, ?, ?)";
        Object[] params = {
            userId,
            code,
            Timestamp.valueOf(LocalDateTime.now()),
            Timestamp.valueOf(expiredAt)
        };
        try {
            int result = this.execQuery(sql, params);
            return result > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // ========= CUSTOMER =========
    public boolean checkVerifyCodeCustomer(int userId, String code) {
        String sql = "SELECT COUNT(*) AS count FROM VerifyCodes WHERE userType = 0 AND userId = ? AND code = ? AND isVerified = 0 AND expiredAt > ?";
        try (ResultSet rs = this.execSelectQuery(sql, new Object[]{userId, code, Timestamp.valueOf(LocalDateTime.now())})) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean markCodeAsUsedCustomer(int userId, String code) {
        String sql = "UPDATE VerifyCodes SET isVerified = 1 WHERE userType = 0 AND userId = ? AND code = ?";
        try {
            int rows = this.execQuery(sql, new Object[]{userId, code});
            return rows > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateNewPasswordByEmailCustomer(String email, String newPassword) {
        String sql = "UPDATE Customers SET customerNewPassword = ? WHERE customerEmail = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, email});
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean confirmResetPasswordCustomer(int userId, String newPassword) {
        String sql = "UPDATE Customers SET customerPassword = ?, customerNewPassword = NULL WHERE customerId = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, userId});
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Customer findCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customers WHERE customerEmail = ? AND isBlock=0 AND _destroy=0";
        try (ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("customerId"));
                c.setEmail(rs.getString("customerEmail"));
                c.setName(rs.getString("customerName"));
                c.setAvatar(rs.getString("customerAvatar"));
                c.setPhone(rs.getString("customerPhone"));
                c.setIsBlock(rs.getBoolean("isBlock"));
                // ... set thêm nếu muốn
                return c;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean insertCodeCustomer(int userId, String code, LocalDateTime expiredAt) {
        String sql = "INSERT INTO VerifyCodes (userType, userId, code, isVerified, createdAt, expiredAt) VALUES (0, ?, ?, 0, ?, ?)";
        Object[] params = {
            userId,
            code,
            Timestamp.valueOf(LocalDateTime.now()),
            Timestamp.valueOf(expiredAt)
        };
        try {
            int result = this.execQuery(sql, params);
            return result > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
}

