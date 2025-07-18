/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Employee;
import Models.Role;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author iphon
 */
public class AdminDAO extends DB.DBContext {

    public Employee getAdminByEmailAndPassword(String email, String password) {
        Employee emp = null;
        String sql = "SELECT e.*, r.roleName "
                + "FROM Employees e "
                + "LEFT JOIN Roles r ON e.roleId = r.roleId "
                + "WHERE e.employeeEmail = ? "
                + "AND e.employeePassword = ? "
                + "AND e.isBlock = 0 "
                + "AND e._destroy = 0 "
                + "AND e.roleId = 1";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{email, password})) {
            if (rs.next()) {
                emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                emp.setEmail(rs.getString("employeeEmail"));
                emp.setPassword(rs.getString("employeePassword"));
                emp.setName(rs.getString("employeeName"));
                emp.setAvatar(rs.getString("employeeAvatar"));
                emp.setRole(new Role(rs.getInt("roleId"), rs.getString("roleName")));
                emp.setIsBlock(rs.getBoolean("isBlock"));
                emp.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                emp.setDestroy(rs.getBoolean("_destroy"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emp;
    }

    public Employee getStaffByEmailAndPassword(String email, String password) {
        Employee emp = null;
        String sql = "SELECT e.*, r.roleName "
                + "FROM Employees e "
                + "LEFT JOIN Roles r ON e.roleId = r.roleId "
                + "WHERE e.employeeEmail = ? "
                + "AND e.employeePassword = ? "
                + "AND e.isBlock = 0 "
                + "AND e._destroy = 0 "
                + "AND e.roleId = 2";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{email, password})) {
            if (rs.next()) {
                emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                emp.setEmail(rs.getString("employeeEmail"));
                emp.setPassword(rs.getString("employeePassword"));
                emp.setName(rs.getString("employeeName"));
                emp.setAvatar(rs.getString("employeeAvatar"));
                emp.setRole(new Role(rs.getInt("roleId"), rs.getString("roleName")));
                emp.setIsBlock(rs.getBoolean("isBlock"));
                emp.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                emp.setDestroy(rs.getBoolean("_destroy"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return emp;
    }

}
