/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Employee;
import Models.Role;
import java.sql.Connection;
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
                + "WHERE roleId = 3 "
                + "AND _destroy = 0 "
                + "ORDER BY employeeId DESC "
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Employee staff = new Employee(
                        rs.getInt("employeeId"),
                        rs.getString("employeeEmail"),
                        rs.getString("employeePassword"),
                        rs.getString("employeeName"),
                        rs.getString("employeeAvatar"),
                        new Role(rs.getInt("roleId"), ""),
                        rs.getInt("isBlock") == 1,
                        rs.getTimestamp("createdAt").toLocalDateTime(),
                        rs.getInt("_destroy") == 1
                );
                list.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countStaff() {
        String query = "SELECT COUNT(*) as total FROM Employees WHERE roleId = 2";
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
        String query = "INSERT INTO Employees (employeeEmail, employeePassword, employeeName, employeeAvatar, roleId, isBlock, createdAt, _destroy) "
                + "VALUES (?, ?, ?, ?, 3, ?, GETDATE(), ?)";
        Object[] params = {
            staff.getEmail(),
            staff.getPassword(),
            staff.getName(),
            staff.getAvatar(),
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
        String query = "SELECT * FROM Employees WHERE employeeId = ?";
        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                Employee staff = new Employee();
                staff.setId(rs.getInt("employeeId"));
                staff.setEmail(rs.getString("employeeEmail"));
                staff.setPassword(rs.getString("employeePassword"));
                staff.setName(rs.getString("employeeName"));
                staff.setAvatar(rs.getString("employeeAvatar"));

                Role role = new Role();
                role.setId(rs.getInt("roleId"));
                staff.setRole(role);

                Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) {
                    staff.setCreatedAt(ts.toLocalDateTime());
                }

                staff.setIsBlock(rs.getBoolean("isBlock"));
                return staff;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStaff(int id, String name, String email, boolean isBlock) {
        String query = "UPDATE Employees SET employeeName = ?, employeeEmail = ?, isBlock = ? WHERE employeeId = ?";
        Object[] params = {name, email, isBlock, id};

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
}
