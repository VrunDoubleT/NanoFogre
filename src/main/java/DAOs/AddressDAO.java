/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Address;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author iphon
 */
public class AddressDAO extends DB.DBContext {

    public List<Address> getAddressesByCustomerId(int customerId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT addressId, addressName, recipientName, addressDetails, addressPhone, isDefault,_destroy "
                + "FROM Address WHERE customerId = ? AND _destroy = 0";
        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                a.setName(rs.getString("addressName"));
                a.setRecipientName(rs.getString("recipientName"));
                a.setDetails(rs.getString("addressDetails"));
                a.setPhone(rs.getString("addressPhone"));
                a.setIsDefault(rs.getBoolean("isDefault"));
                a.setCustomerId(customerId);
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insert(Address a) throws SQLException {
        String sql = "INSERT INTO Address(addressName, recipientName, addressDetails, addressPhone, customerId, isDefault, _destroy ) VALUES (?, ?, ?, ?, ?, 0,0)";
        Object[] params = {
            a.getName(),
            a.getRecipientName(),
            a.getDetails(),
            a.getPhone(),
            a.getCustomerId()
        };
        return execQueryReturnId(sql, params);
    }

    public boolean update(Address a) throws SQLException {
        String sql = "UPDATE Address SET addressName=?, recipientName=?, addressDetails=?, addressPhone=?"
                + "WHERE addressId=?";
        return execQuery(sql, new Object[]{
            a.getName(), a.getRecipientName(), a.getDetails(), a.getPhone(), a.getId()
        }) > 0;
    }

    public boolean delete(int addressId) throws SQLException {
        String sql = "DELETE FROM Address WHERE addressId=?";
        return execQuery(sql, new Object[]{addressId}) > 0;
    }

    public Address getById(int addressId) throws SQLException {
        String sql = "SELECT * "
                + "FROM Address WHERE addressId = ? AND _destroy = 0";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{addressId})) {
            if (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                a.setName(rs.getString("addressName"));
                a.setRecipientName(rs.getString("recipientName"));
                a.setDetails(rs.getString("addressDetails"));
                a.setPhone(rs.getString("addressPhone"));
                a.setIsDefault(rs.getBoolean("isDefault"));
                a.setCustomerId(rs.getInt("customerId"));
                return a;
            }
        }
        return null;
    }

    public Address getDefaultAddress(int customerId) {
        String sql = "SELECT TOP 1 addressId, addressName, recipientName, addressDetails, addressPhone, isDefault , _destroy "
                + "FROM Address WHERE customerId = ? AND isDefault = 1 AND _destroy = 0";

        Address address = null;

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    address = new Address();
                    address.setId(rs.getInt("addressId"));
                    address.setName(rs.getString("addressName"));
                    address.setRecipientName(rs.getString("recipientName"));
                    address.setDetails(rs.getString("addressDetails"));
                    address.setPhone(rs.getString("addressPhone"));
                    address.setIsDefault(rs.getBoolean("isDefault"));
                    address.setCustomerId(customerId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return address;
    }

    public boolean setDefaultAddress(int customerId, int addressId) throws SQLException {
        String sqlCheck = "SELECT addressId FROM Address WHERE addressId = ? AND customerId = ? AND _destroy = 0";
        Object[] checkParams = {addressId, customerId};
        try ( ResultSet rs = execSelectQuery(sqlCheck, checkParams)) {
            if (!rs.next()) {
                return false;
            }
        }

        String sqlUnset = "UPDATE Address SET isDefault = 0 WHERE customerId = ? AND _destroy = 0";
        Object[] unsetParams = {customerId};
        execQuery(sqlUnset, unsetParams);

        String sqlSet = "UPDATE Address SET isDefault = 1 WHERE addressId = ? AND customerId = ? AND _destroy = 0";
        Object[] setParams = {addressId, customerId};
        return execQuery(sqlSet, setParams) > 0;
    }

}
