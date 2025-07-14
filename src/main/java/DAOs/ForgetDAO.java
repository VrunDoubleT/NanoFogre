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

    // ======= EMPLOYEE =======
    /**
     * Kiểm tra mã (chưa xác thực, chưa hết hạn) trong bảng VerifyCodeEmployees
     */
    public boolean checkVerifyCodeEmployee(int employeeId, String code) {
        String sql = ""
                + "SELECT COUNT(*) AS count "
                + "FROM VerifyCodeEmployees "
                + "WHERE employeeId = ? "
                + "  AND code = ? "
                + "  AND isVerified = 0 "
                + "  AND expiredAt > ?";
        Object[] params = {
            employeeId,
            code,
            Timestamp.valueOf(LocalDateTime.now())
        };
        try ( ResultSet rs = this.execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Đánh dấu mã của Employee đã được dùng (isVerified = 1)
     */
    public boolean markCodeAsUsedEmployee(int employeeId, String code) {
        String sql = ""
                + "UPDATE VerifyCodeEmployees "
                + "SET isVerified = 1 "
                + "WHERE employeeId = ? AND code = ?";
        try {
            int rows = this.execQuery(sql, new Object[]{employeeId, code});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Chèn một mã xác thực mới cho Employee
     */
    public boolean insertCodeEmployee(int employeeId, String code, LocalDateTime expiredAt) {
        String sql = ""
                + "INSERT INTO VerifyCodeEmployees "
                + "(employeeId, code, isVerified, createdAt, expiredAt) "
                + "VALUES (?, ?, 0, ?, ?)";
        Object[] params = {
            employeeId,
            code,
            Timestamp.valueOf(LocalDateTime.now()),
            Timestamp.valueOf(expiredAt)
        };
        try {
            int result = this.execQuery(sql, params);
            return result > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật mật khẩu mới tạm thời cho Employee (trước khi confirm)
     */
    public boolean updateNewPasswordByEmail(String email, String newPassword) {
        String sql = ""
                + "UPDATE Employees "
                + "SET employeeNewPassword = ? "
                + "WHERE employeeEmail = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, email});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Xác nhận reset mật khẩu: ghi mật khẩu mới vào trường chính và xóa trường
     * tạm
     */
    public boolean confirmResetPassword(int employeeId, String newPassword) {
        String sql = ""
                + "UPDATE Employees "
                + "SET employeePassword = ?, employeeNewPassword = NULL "
                + "WHERE employeeId = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, employeeId});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Tìm Employee theo email (để lấy employeeId khi bắt đầu reset)
     */
    public Employee findByEmail(String email) {
        String sql = ""
                + "SELECT * FROM Employees "
                + "WHERE employeeEmail = ? AND isBlock = 0 AND _destroy = 0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs.next()) {
                Employee emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                emp.setEmail(rs.getString("employeeEmail"));
                return emp;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // ======= CUSTOMER =======
    /**
     * Kiểm tra mã (chưa xác thực, chưa hết hạn) trong bảng VerifyCodes với
     * userType = 0
     */
    public boolean checkVerifyCodeCustomer(int customerId, String code) {
        String sql = ""
                + "SELECT COUNT(*) AS count "
                + "FROM VerifyCodes "
                + "WHERE userType = 0 "
                + "  AND userId = ? "
                + "  AND code = ? "
                + "  AND isVerified = 0 "
                + "  AND expiredAt > ?";
        Object[] params = {
            customerId,
            code,
            Timestamp.valueOf(LocalDateTime.now())
        };
        try ( ResultSet rs = this.execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Đánh dấu mã của Customer đã được dùng
     */
    public boolean markCodeAsUsedCustomer(int customerId, String code) {
        String sql = ""
                + "UPDATE VerifyCodes "
                + "SET isVerified = 1 "
                + "WHERE userType = 0 AND userId = ? AND code = ?";
        try {
            int rows = this.execQuery(sql, new Object[]{customerId, code});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Chèn mã xác thực mới cho Customer
     */
    public boolean insertCodeCustomer(int customerId, String code, LocalDateTime expiredAt) {
        String sql = ""
                + "INSERT INTO VerifyCodes "
                + "(userType, userId, code, isVerified, createdAt, expiredAt) "
                + "VALUES (0, ?, ?, 0, ?, ?)";
        Object[] params = {
            customerId,
            code,
            Timestamp.valueOf(LocalDateTime.now()),
            Timestamp.valueOf(expiredAt)
        };
        try {
            int result = this.execQuery(sql, params);
            return result > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Tìm Customer theo email
     */
    public Customer findCustomerByEmail(String email) {
        String sql = ""
                + "SELECT * FROM Customers "
                + "WHERE customerEmail = ? AND isBlock = 0 AND _destroy = 0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("customerId"));
                c.setEmail(rs.getString("customerEmail"));
                c.setName(rs.getString("customerName"));
                c.setAvatar(rs.getString("customerAvatar"));
                c.setPhone(rs.getString("customerPhone"));
                c.setIsBlock(rs.getBoolean("isBlock"));
                return c;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu mới tạm thời cho Customer
     */
    public boolean updateNewPasswordByEmailCustomer(String email, String newPassword) {
        String sql = ""
                + "UPDATE Customers "
                + "SET customerNewPassword = ? "
                + "WHERE customerEmail = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, email});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Xác nhận reset mật khẩu cho Customer
     */
    public boolean confirmResetPasswordCustomer(int customerId, String newPassword) {
        String sql = ""
                + "UPDATE Customers "
                + "SET customerPassword = ?, customerNewPassword = NULL "
                + "WHERE customerId = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, customerId});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
}
