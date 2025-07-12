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
//    public boolean updateDefaultAddressByCustomerId(int customerId, String newAddress) {
//    String sql = "UPDATE Address SET addressDetails = ? WHERE customerId = ? AND isDefault = 1";
//    Object[] params = {newAddress, customerId};
//    try {
//        int rows = execQuery(sql, params);
//        System.out.println("DEBUG updateDefaultAddressByCustomerId → rows updated: " + rows);
//        return rows > 0;
//    } catch (Exception e) {
//        System.out.println("Error in updateDefaultAddressByCustomerId: " + e.getMessage());
//        e.printStackTrace();
//        return false;
//    }
//}

    public List<Address> getAddressesByCustomerId(int customerId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT addressId, addressName, recipientName, addressDetails, addressPhone, isDefault "
                + "FROM Address WHERE customerId = ?";
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

    // Thêm mới
    public int insert(Address a) throws SQLException {
        String sql = "INSERT INTO Address(addressName, recipientName, addressDetails, addressPhone, customerId, isDefault) "
                + "VALUES(?,?,?,?,?,0)";
        return execQuery(sql, new Object[]{
            a.getName(), a.getRecipientName(), a.getDetails(), a.getPhone(), a.getCustomerId()
        });
    }

    // Cập nhật (không thay đổi isDefault)
    public boolean update(Address a) throws SQLException {
        String sql = "UPDATE Address SET addressName=?, recipientName=?, addressDetails=?, addressPhone=? "
                + "WHERE addressId=?";
        return execQuery(sql, new Object[]{
            a.getName(), a.getRecipientName(), a.getDetails(), a.getPhone(), a.getId()
        }) > 0;
    }

    // Xoá
    public boolean delete(int addressId) throws SQLException {
        String sql = "DELETE FROM Address WHERE addressId=?";
        return execQuery(sql, new Object[]{addressId}) > 0;
    }

    /**
     * Lấy Address theo addressId
     */
    public Address getById(int addressId) throws SQLException {
        String sql = "SELECT * "
                + "FROM Address WHERE addressId = ?";
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
    String sql = "SELECT TOP 1 addressId, addressName, recipientName, addressDetails, addressPhone, isDefault "
               + "FROM Address WHERE customerId = ? AND isDefault = 1";

    Address address = null;

    // Mở connection 1 lần và đóng đúng cách.
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);

        try (ResultSet rs = ps.executeQuery()) {
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

    return address; // trả về null nếu không tìm thấy
}


    
    public boolean setDefaultAddress(int customerId, int addressId) throws SQLException {
        // 1. Kiểm tra addressId có thuộc customerId không
        String sqlCheck = "SELECT addressId FROM Address WHERE addressId = ? AND customerId = ?";
        Object[] checkParams = {addressId, customerId};
        try ( ResultSet rs = execSelectQuery(sqlCheck, checkParams)) {
            if (!rs.next()) {
                return false; // Không tìm thấy address thuộc customer
            }
        }

        // 2. Bỏ mặc định các address khác của customer này
        String sqlUnset = "UPDATE Address SET isDefault = 0 WHERE customerId = ?";
        Object[] unsetParams = {customerId};
        execQuery(sqlUnset, unsetParams);

        // 3. Đặt mặc định cho addressId vừa chọn
        String sqlSet = "UPDATE Address SET isDefault = 1 WHERE addressId = ? AND customerId = ?";
        Object[] setParams = {addressId, customerId};
        return execQuery(sqlSet, setParams) > 0;
    }

//public boolean setDefaultAddress(int customerId, int addressId) throws SQLException {
//    Connection conn = getConnection();
//    try {
//        // 1. Bỏ mặc định tất cả địa chỉ của customer
//        String unsetSql = "UPDATE Address SET isDefault = 0 WHERE customerId = ?";
//        PreparedStatement ps1 = conn.prepareStatement(unsetSql);
//        ps1.setInt(1, customerId);
//        ps1.executeUpdate();
//
//        // 2. Set mặc định cho addressId vừa chọn
//        String setSql = "UPDATE Address SET isDefault = 1 WHERE addressId = ? AND customerId = ?";
//        PreparedStatement ps2 = conn.prepareStatement(setSql);
//        ps2.setInt(1, addressId);
//        ps2.setInt(2, customerId);
//        int affected = ps2.executeUpdate();
//
//        return affected > 0;
//    } finally {
//        conn.close();
//    }
//}

}
