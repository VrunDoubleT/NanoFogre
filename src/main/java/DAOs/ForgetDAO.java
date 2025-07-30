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

    public boolean checkVerifyCodeEmployee(int employeeId, String code) {
        String sql = ""
                + "SELECT COUNT(*) AS count "
                + "FROM VerifyCodeEmployees "
                + "WHERE employeeId = ? "
                + "  AND code = ? "
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

    public Employee findByEmail(String email) {
        String sql = ""
                + "SELECT * FROM Employees "
                + "WHERE employeeEmail = ? AND roleId = 2 AND isBlock = 0 AND _destroy = 0";
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

    public enum SendResult {
        OK, TOO_MANY_REQUESTS, DB_ERROR
    }

    public SendResult upsertCodeEmployee(int employeeId, String code, LocalDateTime expiredAt) {
        String sel = "SELECT requestCount, createdAt FROM VerifyCodeEmployees WHERE employeeId = ?";
        try ( ResultSet rs = execSelectQuery(sel, new Object[]{employeeId})) {
            LocalDateTime now = LocalDateTime.now();
            if (rs.next()) {
                int count = rs.getInt("requestCount");
                LocalDateTime created = rs.getTimestamp("createdAt").toLocalDateTime();

                boolean olderThanDay = created.isBefore(now.minusHours(24));
                if (!olderThanDay && count >= 3) {
                    return SendResult.TOO_MANY_REQUESTS;
                }

                String upd = "UPDATE VerifyCodeEmployees SET "
                        + "code = ?, createdAt = ?, expiredAt = ?, "
                        + "requestCount = ?, failedCount = 0"
                        + "WHERE employeeId = ?";
                int newCount = olderThanDay ? 1 : count + 1;
                int rows = execQuery(upd, new Object[]{
                    code,
                    Timestamp.valueOf(now),
                    Timestamp.valueOf(expiredAt),
                    newCount,
                    employeeId
                });
                return rows > 0 ? SendResult.OK : SendResult.DB_ERROR;
            } else {

                String ins = "INSERT INTO VerifyCodeEmployees "
                        + "(employeeId, code, createdAt, expiredAt, requestCount, failedCount) "
                        + "VALUES (?, ?, ?, ?, 1, 0)";
                int rows = execQuery(ins, new Object[]{
                    employeeId,
                    code,
                    Timestamp.valueOf(now),
                    Timestamp.valueOf(expiredAt)
                });
                return rows > 0 ? SendResult.OK : SendResult.DB_ERROR;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return SendResult.DB_ERROR;
        }
    }

    public void incrementFailedCount(int employeeId) throws SQLException {
        String sql = "UPDATE VerifyCodeEmployees SET failedCount = failedCount + 1 WHERE employeeId = ?";
        execQuery(sql, new Object[]{employeeId});
    }

    public int getFailedCount(int employeeId) {
        String sql = "SELECT failedCount FROM VerifyCodeEmployees WHERE employeeId = ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{employeeId})) {
            if (rs.next()) {
                return rs.getInt("FailedCount");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public boolean deleteCodeEmployee(int employeeId) {
        String sql = "DELETE FROM VerifyCodeEmployees where employeeId = ? ";
        try {
            int row = execQuery(sql, new Object[]{employeeId});
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ======= CUSTOMER =======
    public SendResult upsertCodeCustomer(int customerId, String code, LocalDateTime expiredAt, boolean isRegister) {
        if (isRegister) {
            int failedCount = 0;
            String sel = "SELECT failedCount FROM VerifyCodes WHERE userType=0 AND customerId=? ORDER BY createdAt DESC";
            try ( ResultSet rs = execSelectQuery(sel, new Object[]{customerId})) {
                if (rs.next()) {
                    failedCount = rs.getInt("failedCount");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
                return SendResult.DB_ERROR;
            }
            // delete code old insert new
            String del = "DELETE FROM VerifyCodes WHERE userType=0 AND customerId=?";
            try {
                execQuery(del, new Object[]{customerId});
            } catch (SQLException ex) {
                ex.printStackTrace();
                return SendResult.DB_ERROR;
            }

            // Insert code giữ lại failedCount cũ
            String ins = "INSERT INTO VerifyCodes (userType, customerId, code, createdAt, expiredAt, requestCount, failedCount) VALUES (0, ?, ?, ?, ?, 0, ?)";
            try {
                int rows = execQuery(ins, new Object[]{
                    customerId,
                    code,
                    new Timestamp(System.currentTimeMillis()),
                    Timestamp.valueOf(expiredAt),
                    failedCount
                });
                return rows > 0 ? SendResult.OK : SendResult.DB_ERROR;
            } catch (SQLException ex) {
                ex.printStackTrace();
                return SendResult.DB_ERROR;
            }
        } else {
            String sel = "SELECT requestCount, createdAt FROM VerifyCodes WHERE userType = 0 AND customerId = ?";
            try ( ResultSet rs = execSelectQuery(sel, new Object[]{customerId})) {
                LocalDateTime now = LocalDateTime.now();
                if (rs.next()) {
                    int count = rs.getInt("requestCount");
                    LocalDateTime created = rs.getTimestamp("createdAt").toLocalDateTime();
                    boolean olderThanDay = created.isBefore(now.minusHours(24));
                    if (!olderThanDay && count >= 3) {
                        return SendResult.TOO_MANY_REQUESTS;
                    }
                    String upd = "UPDATE VerifyCodes SET code=?, createdAt=?, expiredAt=?, requestCount=? WHERE userType=0 AND customerId=?";
                    int newCount = olderThanDay ? 1 : count + 1;
                    int rows = execQuery(upd, new Object[]{
                        code,
                        Timestamp.valueOf(now),
                        Timestamp.valueOf(expiredAt),
                        newCount,
                        customerId
                    });
                    return rows > 0 ? SendResult.OK : SendResult.DB_ERROR;
                } else {
                    String ins = "INSERT INTO VerifyCodes (userType, customerId, code, createdAt, expiredAt, requestCount, failedCount) VALUES (0, ?, ?, ?, ?, 1, 0)";
                    int rows = execQuery(ins, new Object[]{
                        customerId,
                        code,
                        new Timestamp(System.currentTimeMillis()),
                        Timestamp.valueOf(expiredAt)
                    });
                    return rows > 0 ? SendResult.OK : SendResult.DB_ERROR;
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
                return SendResult.DB_ERROR;
            }
        }
    }

    public boolean checkVerifyCodeCustomer(int customerId, String code) {
        String sql = "SELECT COUNT(*) AS count FROM VerifyCodes WHERE userType = 0 AND customerId = ? AND code = ? AND expiredAt > ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId, code, new Timestamp(System.currentTimeMillis())})) {
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public int getLatestVerifyCodeId(int customerId) {
        String sql = "SELECT id FROM VerifyCodes WHERE userType = 0 AND customerId = ? ORDER BY createdAt DESC LIMIT 1";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return -1;
    }

    public void incrementFailedCountForCustomer(int customerId) throws SQLException {
        String sql = "UPDATE VerifyCodes SET failedCount = failedCount + 1 WHERE userType = 0 AND customerId = ?";
        execQuery(sql, new Object[]{customerId});

        String sel = "SELECT failedCount FROM VerifyCodes WHERE userType = 0 AND customerId = ? ORDER BY createdAt DESC LIMIT 1";
        try ( ResultSet rs = execSelectQuery(sel, new Object[]{customerId})) {
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public int getLatestFailedCount(int customerId) {
        String sql = "SELECT failedCount FROM VerifyCodes WHERE userType = 0 AND customerId = ? ORDER BY createdAt DESC LIMIT 1";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) {
                return rs.getInt("failedCount");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public int getFailedCountForCustomer(int customerId) {
        String sql = "SELECT failedCount FROM VerifyCodes WHERE userType = 0 AND customerId = ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) {
                return rs.getInt("failedCount");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public Customer findCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customers WHERE customerEmail = ? AND isVerify = 1 AND isBlock = 0 AND _destroy = 0";
        try ( ResultSet rs = this.execSelectQuery(sql, new Object[]{email})) {
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("customerId"));
                c.setEmail(rs.getString("customerEmail"));
                c.setPassword(rs.getString("customerPassword"));
                c.setName(rs.getString("customerName"));
                c.setAvatar(rs.getString("customerAvatar"));
                c.setPhone(rs.getString("customerPhone"));
                return c;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

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

    public boolean confirmResetPasswordCustomer(int customerId, String newPassword) {
        String sql = "UPDATE Customers SET customerPassword = ?, customerNewPassword = NULL WHERE customerId = ? AND isBlock = 0 AND _destroy = 0";
        try {
            int rows = execQuery(sql, new Object[]{newPassword, customerId});
            return rows > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public void deleteCodeCustomer(int customerId, String code) {
        String sql = "DELETE FROM VerifyCodes WHERE userType = 0 AND customerId = ? AND code = ?";
        try {
            execQuery(sql, new Object[]{customerId, code});
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void blockCustomer(int customerId) {
        String sql = "UPDATE Customers SET isBlock = 1 WHERE customerId = ?";
        try {
            execQuery(sql, new Object[]{customerId});
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

// Unblock account
    public void unblockCustomer(int customerId) {
        String sql = "UPDATE Customers SET isBlock = 0 WHERE customerId = ?";
        try {
            execQuery(sql, new Object[]{customerId});
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void autoUnblockIfNeeded(int customerId) {
        String sql = "SELECT TOP 1 createdAt FROM VerifyCodes WHERE customerId = ? AND (requestCount >= 3 OR failedCount >= 5) ORDER BY createdAt DESC";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId})) {
            if (rs.next()) {
                LocalDateTime created = rs.getTimestamp("createdAt").toLocalDateTime();
                if (created.plusHours(24).isBefore(LocalDateTime.now())) {
                    unblockCustomer(customerId);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public boolean isCustomerBlockedByFailedCount(int customerId) {
        String sql = "SELECT 1 FROM VerifyCodes WHERE userType=0 AND customerId=? AND failedCount >= 5 AND createdAt >= ?";
        Timestamp since = Timestamp.valueOf(LocalDateTime.now().minusHours(24));
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{customerId, since})) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
