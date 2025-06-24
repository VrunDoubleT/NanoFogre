/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Voucher;
import java.sql.Timestamp;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
public class VoucherDAO extends DB.DBContext {

    public List<Voucher> getAllVouchers(int page, int limit) {
        int row = (page - 1) * limit;
        List<Voucher> list = new ArrayList<>();
        String query = "SELECT * FROM Vouchers "
                + "ORDER BY voucherId DESC "
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Voucher vouchers = new Voucher(
                        rs.getInt("voucherId"),
                        rs.getString("voucherCode"),
                        rs.getString("type"),
                        rs.getDouble("value"),
                        rs.getDouble("minValue"),
                        rs.getDouble("maxValue"),
                        rs.getString("voucherDescription"),
                        rs.getTimestamp("validFrom").toLocalDateTime(),
                        rs.getTimestamp("validTo").toLocalDateTime(),
                        rs.getInt("isActive") == 1
                );
                list.add(vouchers);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countVouchers() {
        String query = "SELECT COUNT(*) as total FROM Vouchers";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createVoucher(Voucher voucher) {
        String query = "INSERT INTO Vouchers (voucherCode, type, value, minValue, maxValue, voucherDescription, validFrom, validTo, isActive) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            voucher.getCode(),
            voucher.getType(),
            voucher.getValue(),
            voucher.getMinValue(),
            voucher.getMaxValue(),
            voucher.getDescription(),
            Timestamp.valueOf(voucher.getValidFrom()),
            Timestamp.valueOf(voucher.getValidTo()),
            voucher.isIsActive()
        };
        try {
            int generatedId = execQueryReturnId(query, params);
            return generatedId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVoucherById(int id) {
        String query = "DELETE FROM Vouchers WHERE voucherId = ?";
        Object[] params = {id};
        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVoucher(int id, String code, String type, double value, double minValue, double maxValue, String description, LocalDateTime validFrom, LocalDateTime validTo, boolean isActive) {
        String query = "UPDATE Vouchers SET voucherCode = ?, type = ?, value = ?, minValue = ?, maxValue = ?, voucherDescription = ?, validFrom = ?, validTo = ?, isActive = ? WHERE voucherId = ?";
        Object[] params = {
            code,
            type,
            value,
            minValue,
            maxValue,
            description,
            Timestamp.valueOf(validFrom), 
            Timestamp.valueOf(validTo),
            isActive ? 1 : 0,
            id
        };
        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCodeExists(String code) {
        String query = "SELECT 1 FROM Vouchers WHERE voucherCode = ?";
        Object[] params = {code};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCodeExistsExceptOwn(String code, int id) {
        String query = "SELECT COUNT(*) FROM Vouchers WHERE voucherCode = ? AND voucherId != ?";
        Object[] params = {code, id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Voucher getVoucherById(int id) {
        String query = "SELECT * FROM Vouchers WHERE voucherId = ?";
        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return new Voucher(
                        rs.getInt("voucherId"),
                        rs.getString("voucherCode"),
                        rs.getString("type"),
                        rs.getDouble("value"),
                        rs.getDouble("minValue"),
                        rs.getObject("maxValue") != null ? rs.getDouble("maxValue") : 0,
                        rs.getString("voucherDescription"),
                        rs.getTimestamp("validFrom").toLocalDateTime(),
                        rs.getTimestamp("validTo").toLocalDateTime(),
                        rs.getInt("isActive") == 1
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
