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

    public Voucher findByCode(String code) {
        Voucher voucher = null;
        String sql = "SELECT TOP 1 [voucherId], [voucherCode], [type], [value], [minValue], [maxValue], [voucherDescription], [validFrom], [validTo], [isActive], [_destroy] "
                + "FROM [Vouchers] WHERE [voucherCode] = ? AND [_destroy] = 0";
        Object[] params = {code};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                voucher = new Voucher();
                voucher.setId(rs.getInt("voucherId"));
                voucher.setCode(rs.getString("voucherCode"));
                voucher.setType(rs.getString("type"));
                voucher.setValue(rs.getDouble("value"));
                voucher.setMinValue(rs.getDouble("minValue"));
                voucher.setMaxValue(rs.getDouble("maxValue"));
                voucher.setDescription(rs.getString("voucherDescription"));
                Timestamp validFrom = rs.getTimestamp("validFrom");
                Timestamp validTo = rs.getTimestamp("validTo");
                voucher.setValidFrom(validFrom != null ? validFrom.toLocalDateTime() : null);
                voucher.setValidTo(validTo != null ? validTo.toLocalDateTime() : null);
                voucher.setIsActive(rs.getInt("isActive") == 1);
                voucher.setDestroy(rs.getInt("_destroy") == 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return voucher;
    }

    public List<Voucher> getAllVouchers(int page, int limit) {
        int row = (page - 1) * limit;
        List<Voucher> list = new ArrayList<>();
        String query = "SELECT * FROM Vouchers "
                + "WHERE _destroy = 0 "
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
                        rs.getInt("isActive") == 1,
                        rs.getInt("_destroy") == 1
                );
                list.add(vouchers);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countVouchers() {
        String query = "SELECT COUNT(*) as total FROM Vouchers WHERE _destroy = 0";
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
        String query = "INSERT INTO Vouchers (voucherCode, type, value, minValue, maxValue, voucherDescription, validFrom, validTo, isActive, _destroy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            voucher.getCode(),
            voucher.getType(),
            voucher.getValue(),
            voucher.getMinValue(),
            voucher.getMaxValue(),
            voucher.getDescription(),
            Timestamp.valueOf(voucher.getValidFrom()),
            Timestamp.valueOf(voucher.getValidTo()),
            voucher.isIsActive(),
            voucher.isDestroy(),};
        try {
            int generatedId = execQueryReturnId(query, params);
            return generatedId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVoucherById(int id) {
        String query = "UPDATE Vouchers SET _destroy = 1, isActive = 0 WHERE voucherId = ?";
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
        String query = "SELECT 1 FROM Vouchers WHERE voucherCode = ? AND _destroy = 0";
        Object[] params = {code};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCodeExistsExceptOwn(String code, int id) {
        String query = "SELECT COUNT(*) FROM Vouchers WHERE voucherCode = ? AND voucherId != ? AND _destroy = 0";
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
                        rs.getInt("isActive") == 1,
                        rs.getInt("_destroy") == 1
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isAvailable(Voucher v, int userId) {
        if (v == null || !v.isIsActive()) {
            return false;
        }
        LocalDateTime now = LocalDateTime.now();
        return !now.isBefore(v.getValidFrom()) && !now.isAfter(v.getValidTo());
    }

    public void incrementVoucherUsage(int voucherId, int customerId) {
        String checkSql = "SELECT usageCount FROM VoucherUserUsage WHERE voucherId = ? AND customerId = ?";
        try ( ResultSet rs = execSelectQuery(checkSql, new Object[]{voucherId, customerId})) {
            if (rs.next()) {
                int currentUsage = rs.getInt("usageCount");
                String updateSql = "UPDATE VoucherUserUsage SET usageCount = ? WHERE voucherId = ? AND customerId = ?";
                execQuery(updateSql, new Object[]{currentUsage + 1, voucherId, customerId});
            } else {
                String insertSql = "INSERT INTO VoucherUserUsage (voucherId, customerId, usageCount) VALUES (?, ?, 1)";
                execQuery(insertSql, new Object[]{voucherId, customerId});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Voucher> getAvailableVouchersForUserByCategories(int userId, List<Integer> productCategoryIds) {
        List<Voucher> availableVouchers = new ArrayList<>();
        if (productCategoryIds == null || productCategoryIds.isEmpty()) {
            return availableVouchers;
        }

        String categoryPlaceholders = String.join(",", java.util.Collections.nCopies(productCategoryIds.size(), "?"));

        String sql
                = "SELECT DISTINCT v.*, "
                + "COALESCE(uvu.usageCount, 0) AS currentUsage, "
                + "COALESCE(total.totalUsed, 0) AS totalUsed "
                + "FROM Vouchers v "
                + "LEFT JOIN VoucherCategories vc ON v.voucherId = vc.voucherId "
                + "LEFT JOIN VoucherUserUsage uvu ON v.voucherId = uvu.voucherId AND uvu.customerId = ? "
                + "LEFT JOIN ( "
                + "    SELECT voucherId, SUM(usageCount) AS totalUsed "
                + "    FROM VoucherUserUsage GROUP BY voucherId "
                + ") total ON v.voucherId = total.voucherId "
                + "WHERE v.isActive = 1 AND v._destroy = 0 "
                + "AND v.validFrom <= ? AND v.validTo >= ? "
                + "AND (vc.categoryId IN (" + categoryPlaceholders + ") OR vc.categoryId IS NULL) "
                + "AND (v.userUsageLimit IS NULL OR COALESCE(uvu.usageCount, 0) < v.userUsageLimit) "
                + "AND (v.totalUsageLimit IS NULL OR COALESCE(total.totalUsed, 0) < v.totalUsageLimit) "
                + "ORDER BY v.validTo ASC";

        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(java.sql.Timestamp.valueOf(LocalDateTime.now()));
        params.add(java.sql.Timestamp.valueOf(LocalDateTime.now()));
        params.addAll(productCategoryIds);

        try ( ResultSet rs = execSelectQuery(sql, params.toArray())) {
            while (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setId(rs.getInt("voucherId"));
                voucher.setCode(rs.getString("voucherCode"));
                voucher.setDescription(rs.getString("voucherDescription"));
                voucher.setType(rs.getString("type"));
                voucher.setValue(rs.getDouble("value"));
                voucher.setMaxValue(rs.getDouble("maxValue"));
                voucher.setMinValue(rs.getDouble("minValue"));

                Object totalUsageLimitObj = rs.getObject("totalUsageLimit");
                if (totalUsageLimitObj != null) {
                    voucher.setTotalUsageLimit(rs.getInt("totalUsageLimit"));
                }
                Object userUsageLimitObj = rs.getObject("userUsageLimit");
                if (userUsageLimitObj != null) {
                    voucher.setUserUsageLimit(rs.getInt("userUsageLimit"));
                }

                Timestamp validFrom = rs.getTimestamp("validFrom");
                if (validFrom != null) {
                    voucher.setValidFrom(validFrom.toLocalDateTime());
                }
                Timestamp validTo = rs.getTimestamp("validTo");
                if (validTo != null) {
                    voucher.setValidTo(validTo.toLocalDateTime());
                }
                voucher.setIsActive(rs.getBoolean("isActive"));
                voucher.setDestroy(rs.getBoolean("_destroy"));
                availableVouchers.add(voucher);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return availableVouchers;
    }

    public double calcDiscount(Voucher voucher, double subtotal) {
        if (voucher == null) {
            return 0;
        }

        double discount = 0;
        if ("PERCENTAGE".equalsIgnoreCase(voucher.getType())) {
            discount = subtotal * (voucher.getValue() / 100.0);
            if (voucher.getMaxValue() > 0 && discount > voucher.getMaxValue()) {
                discount = voucher.getMaxValue();
            }
        } else if ("FIXED".equalsIgnoreCase(voucher.getType())) {
            discount = voucher.getValue();
        }

        return Math.min(discount, subtotal);
    }

}
