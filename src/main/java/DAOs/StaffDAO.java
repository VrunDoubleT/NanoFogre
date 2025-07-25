/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Employee;
import Models.Role;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
public class StaffDAO extends DB.DBContext {

    public List<Employee> getAllStaff(int page, int limit) {
        int row = (page - 1) * limit;
        List<Employee> list = new ArrayList<>();
        String query = "SELECT * FROM Employees "
                + "WHERE roleId = 2 "
                + "AND _destroy = 0 "
                + "ORDER BY employeeId DESC "
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Employee staff = new Employee();
                staff.setId(rs.getInt("employeeId"));
                staff.setEmail(rs.getString("employeeEmail"));
                staff.setPassword(rs.getString("employeePassword"));
                staff.setNewPassword(rs.getString("employeeNewPassword"));
                staff.setName(rs.getString("employeeName"));
                staff.setAvatar(rs.getString("employeeAvatar"));
                staff.setCitizenIdentityId(rs.getString("citizenIdentityId"));
                staff.setPhoneNumber(rs.getString("phoneNumber"));
                if (rs.getDate("dateOfBirth") != null) {
                    staff.setDateOfBirth(rs.getDate("dateOfBirth").toLocalDate());
                }
                staff.setGender(rs.getString("gender"));
                staff.setAddress(rs.getString("address"));
                staff.setRole(new Role(rs.getInt("roleId"), ""));
                staff.setIsBlock(rs.getBoolean("isBlock"));
                staff.setDestroy(rs.getBoolean("_destroy"));
                if (rs.getTimestamp("createdAt") != null) {
                    staff.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                }
                list.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countStaff() {
        String query = "SELECT COUNT(*) as total FROM Employees WHERE roleId = 2 AND _destroy = 0";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createStaff(Employee staff) {
        String query = "INSERT INTO Employees ("
                + "employeeEmail, employeePassword, employeeNewPassword, employeeName, employeeAvatar, "
                + "citizenIdentityId, phoneNumber, dateOfBirth, gender, address, "
                + "roleId, isBlock, createdAt, _destroy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 2, ?, GETDATE(), ?)";
        Object[] params = {
            staff.getEmail(),
            staff.getPassword(),
            staff.getNewPassword(),
            staff.getName(),
            staff.getAvatar(),
            staff.getCitizenIdentityId(),
            staff.getPhoneNumber(),
            staff.getDateOfBirth(),
            staff.getGender(),
            staff.getAddress(),
            staff.isIsBlock(),
            staff.isDestroy()
        };
        try {
            int generatedId = execQueryReturnId(query, params);
            return generatedId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Employee getStaffById(int id) {
        String query = "SELECT e.*, r.roleName "
                + "FROM Employees e "
                + "JOIN Roles r ON e.roleId = r.roleId "
                + "WHERE e.employeeId = ?";
        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                Employee staff = new Employee();
                staff.setId(rs.getInt("employeeId"));
                staff.setEmail(rs.getString("employeeEmail"));
                staff.setPassword(rs.getString("employeePassword"));
                staff.setNewPassword(rs.getString("employeeNewPassword"));
                staff.setName(rs.getString("employeeName"));
                staff.setAvatar(rs.getString("employeeAvatar"));
                staff.setCitizenIdentityId(rs.getString("citizenIdentityId"));
                staff.setPhoneNumber(rs.getString("phoneNumber"));

                Date dob = rs.getDate("dateOfBirth");
                if (dob != null) {
                    staff.setDateOfBirth(dob.toLocalDate());
                }

                staff.setGender(rs.getString("gender"));
                staff.setAddress(rs.getString("address"));

                Role role = new Role();
                role.setId(rs.getInt("roleId"));
                role.setName(rs.getString("roleName"));
                staff.setRole(role);

                Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) {
                    staff.setCreatedAt(ts.toLocalDateTime());
                }

                staff.setIsBlock(rs.getBoolean("isBlock"));
                staff.setDestroy(rs.getBoolean("_destroy"));
                return staff;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStaff(Employee staff) {
        String query = "UPDATE Employees SET "
                + "employeeName = ?, "
                + "employeeEmail = ?, "
                + "isBlock = ?, "
                + "citizenIdentityId = ?, "
                + "gender = ?, "
                + "dateOfBirth = ?, "
                + "address = ?, "
                + "phoneNumber = ? "
                + "WHERE employeeId = ?";

        Object[] params = {
            staff.getName(),
            staff.getEmail(),
            staff.isIsBlock(),
            staff.getCitizenIdentityId(),
            staff.getGender(),
            staff.getDateOfBirth(),
            staff.getAddress(),
            staff.getPhoneNumber(),
            staff.getId()
        };

        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteStaffById(int id) {
        String query = "UPDATE Employees SET _destroy = 1 WHERE employeeId = ?";
        Object[] params = {id};
        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEmailExists(String email) {
        String query = "SELECT 1 FROM Employees WHERE employeeEmail = ? AND _destroy = 0";
        Object[] params = {email};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCitizenIdExists(String citizenId) {
        String query = "SELECT 1 FROM Employees WHERE citizenIdentityId = ? AND _destroy = 0";
        Object[] params = {citizenId};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isPhoneExists(String phone) {
        String query = "SELECT 1 FROM Employees WHERE phoneNumber = ? AND _destroy = 0";
        Object[] params = {phone};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEmailExistsExceptOwn(String email, int id) {
        String query = "SELECT COUNT(*) FROM Employees WHERE employeeEmail = ? AND employeeId != ? AND _destroy = 0";
        Object[] params = {email, id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCitizenIdExistsExceptOwn(String citizenId, int id) {
        String query = "SELECT COUNT(*) FROM Employees WHERE citizenIdentityId = ? AND employeeId != ? AND _destroy = 0";
        Object[] params = {citizenId, id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isPhoneExistsExceptOwn(String phone, int id) {
        String query = "SELECT COUNT(*) FROM Employees WHERE phoneNumber = ? AND employeeId != ? AND _destroy = 0";
        Object[] params = {phone, id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countOrdersByEmployeeId(int employeeId) {
        String query = "SELECT COUNT(*) as total FROM Orders WHERE employeeId = ?";
        Object[] params = {employeeId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean updateProfile(Employee staff) {
        String query = "UPDATE Employees SET "
                + "employeeName = ?, "
                + "employeeAvatar = ?, "
                + "gender = ?, "
                + "dateOfBirth = ?, "
                + "address = ?, "
                + "phoneNumber = ? "
                + "WHERE employeeId = ?";

        Object[] params = {
            staff.getName(),
            staff.getAvatar(),
            staff.getGender(),
            staff.getDateOfBirth(),
            staff.getAddress(),
            staff.getPhoneNumber(),
            staff.getId()
        };

        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
