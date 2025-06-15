/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Employee;
import Models.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                + "ORDER BY employeeId "
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
                        rs.getTimestamp("createdAt").toLocalDateTime()
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
        String query = "INSERT INTO Employees (employeeEmail, employeePassword, employeeName, employeeAvatar, roleId, isBlock, createdAt) "
                + "VALUES (?, ?, ?, ?, 2, ?, GETDATE())";
        Object[] params = {
            staff.getEmail(),
            staff.getPassword(),
            staff.getName(),
            staff.getAvatar(),
            staff.isIsBlock() // boolean → bit
        };

        try {
            int generatedId = execQueryReturnId(query, params);
            return generatedId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
