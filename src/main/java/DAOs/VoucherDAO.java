/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import Models.Category;
import Models.Voucher;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
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

    public List<Voucher> vouchers(int categoryId, int page, int limit) {
        int offset = (page - 1) * limit;
        List<Voucher> list = new ArrayList<>();

        String query = "SELECT v.* FROM Vouchers v\n";

        List<Object> paramsList = new ArrayList<>();
        if (categoryId > 0) {
            query += "JOIN VoucherCategories vc ON v.voucherId = vc.voucherId\n";
            query += "WHERE vc.categoryId = ? AND v._destroy = 0\n";
            paramsList.add(categoryId);
        } else {
            query += "WHERE v._destroy = 0\n";
        }

        query += "ORDER BY v.voucherId DESC\n";
        query += "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        paramsList.add(offset);
        paramsList.add(limit);

        Object[] params = paramsList.toArray();

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                Voucher voucher = new Voucher();

                int voucherId = rs.getInt("voucherId");
                voucher.setId(voucherId);
                voucher.setCode(rs.getString("voucherCode"));
                voucher.setType(rs.getString("type"));
                voucher.setValue(rs.getDouble("value"));
                voucher.setMinValue(rs.getDouble("minValue"));
                voucher.setMaxValue(rs.getObject("maxValue") != null ? rs.getDouble("maxValue") : 0);
                voucher.setTotalUsageLimit(rs.getObject("totalUsageLimit", Integer.class));
                voucher.setUserUsageLimit(rs.getObject("userUsageLimit", Integer.class));
                voucher.setDescription(rs.getString("voucherDescription"));
                voucher.setValidFrom(rs.getTimestamp("validFrom").toLocalDateTime());
                voucher.setValidTo(rs.getTimestamp("validTo").toLocalDateTime());
                voucher.setIsActive(rs.getInt("isActive") == 1);
                voucher.setDestroy(rs.getInt("_destroy") == 1);
                list.add(voucher);
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

    public int countVouchersByCategory(int categoryId) {
        String query;
        if (categoryId == 0) {
            query = "SELECT COUNT(*) as total FROM Vouchers WHERE _destroy = 0";
            try ( ResultSet rs = execSelectQuery(query)) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            query = "SELECT COUNT(DISTINCT V.voucherId) as total "
                    + "FROM Vouchers V "
                    + "JOIN VoucherCategories VC ON V.voucherId = VC.voucherId "
                    + "WHERE VC.categoryId = ? AND V._destroy = 0";
            Object[] params = new Object[]{categoryId};
            try ( ResultSet rs = execSelectQuery(query, params)) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    public boolean createVoucher(Voucher voucher, String[] categoryId) {
        String query = "INSERT INTO Vouchers (voucherCode, type, value, minValue, maxValue, totalUsageLimit, userUsageLimit, voucherDescription, validFrom, validTo, isActive, _destroy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            voucher.getCode(),
            voucher.getType(),
            voucher.getValue(),
            voucher.getMinValue(),
            voucher.getMaxValue(),
            voucher.getTotalUsageLimit(),
            voucher.getUserUsageLimit(),
            voucher.getDescription(),
            Timestamp.valueOf(voucher.getValidFrom()),
            Timestamp.valueOf(voucher.getValidTo()),
            voucher.isIsActive(),
            voucher.isDestroy(),};
        try {
            int generatedId = execQueryReturnId(query, params);
            return generatedId > 0 && insertVoucherCategories(generatedId, categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean insertVoucherCategories(int voucherId, String[] categoryIds) throws SQLException {
        String sql = "INSERT INTO VoucherCategories (voucherId, categoryId) VALUES (?, ?)";
        int totalInserted = 0;

        for (String catId : categoryIds) {
            Object[] params = {voucherId, catId};
            totalInserted += execQuery(sql, params);
        }

        return totalInserted == categoryIds.length;
    }

    public boolean updateVoucherCategory(int voucherId, String[] categoryIds) throws SQLException {
        String deleteSQL = "DELETE FROM VoucherCategories WHERE voucherId = ?";
        execQuery(deleteSQL, new Object[]{voucherId});

        String insertSQL = "INSERT INTO VoucherCategories (voucherId, categoryId) VALUES (?, ?)";
        int totalInserted = 0;

        for (String catId : categoryIds) {
            Object[] params = {voucherId, Integer.parseInt(catId)};
            totalInserted += execQuery(insertSQL, params);
        }

        return totalInserted == categoryIds.length;
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

    public boolean updateVoucher(int id, String code, String type, double value, double minValue, Double maxValue, Integer totalUsageLimit, Integer userUsageLimit, String description, LocalDateTime validFrom, LocalDateTime validTo, boolean isActive) {
        String query = "UPDATE Vouchers SET voucherCode = ?, type = ?, value = ?, minValue = ?, maxValue = ?, totalUsageLimit = ?, userUsageLimit = ?, voucherDescription = ?, validFrom = ?, validTo = ?, isActive = ? WHERE voucherId = ?";
        Object[] params = {
            code,
            type,
            value,
            minValue,
            maxValue,
            totalUsageLimit,
            userUsageLimit,
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
        Object[] params = {code.toUpperCase()};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCodeExistsExceptOwn(String code, int id) {
        String query = "SELECT COUNT(*) FROM Vouchers WHERE voucherCode = ? AND voucherId != ? AND _destroy = 0";
        Object[] params = {code.toUpperCase(), id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Category> getCategoriesByVoucherId(int voucherId) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT c.categoryId, c.categoryName "
                + "FROM Categories c "
                + "JOIN VoucherCategories vc ON c.categoryId = vc.categoryId "
                + "WHERE vc.voucherId = ?";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{voucherId})) {
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("categoryId"));
                category.setName(rs.getString("categoryName"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public Voucher getVoucherById(int id) {
        String query = "SELECT * FROM Vouchers WHERE voucherId = ?";
        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                BigDecimal maxValueRaw = (BigDecimal) rs.getObject("maxValue");
                Double maxValue = (maxValueRaw != null) ? maxValueRaw.doubleValue() : null;

                Integer totalLimit = (Integer) rs.getObject("totalUsageLimit");
                Integer userLimit = (Integer) rs.getObject("userUsageLimit");

                return new Voucher(
                        rs.getInt("voucherId"),
                        rs.getString("voucherCode"),
                        rs.getString("type"),
                        rs.getDouble("value"),
                        rs.getDouble("minValue"),
                        maxValue,
                        totalLimit,
                        userLimit,
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
    
    public boolean isValidTotalUsageLimit(int voucherId, int totalLimit) {
        String query = "SELECT "
                + "SUM(uv.usageCount) AS totalUsed "
                + "FROM VoucherUserUsage uv "
                + "WHERE uv.voucherId = ?";
        Object[] params = {voucherId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                int totalUsed = rs.getInt("totalUsed");
                System.out.println("Total used: " + totalUsed + ", New total limit: " + totalLimit);
                return totalLimit >= totalUsed;

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return true;
    }

    public boolean isValidUserUsageLimit(int voucherId, int userLimit) {
        String query = "SELECT "
                + "MAX(uv.usageCount) AS maxUsageCount "
                + "FROM VoucherUserUsage uv "
                + "WHERE uv.voucherId = ?";
        Object[] params = {voucherId};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                int maxUsageCount = rs.getInt("maxUsageCount");

                return userLimit >= maxUsageCount;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean hasUsage(int voucherId) {
        String query = "SELECT COUNT(*) FROM VoucherUserUsage WHERE voucherId = ?";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{voucherId})) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách voucher còn hiệu lực cho user (chung cho tất cả user)
     */
    public List<Voucher> getAvailableVouchersForUser(int userId) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers "
                + "WHERE isActive = 1 AND _destroy = 0 "
                + "AND validFrom <= ? AND validTo >= ? "
                + "ORDER BY validTo ASC";
        Object[] params = {
            java.sql.Timestamp.valueOf(LocalDateTime.now()),
            java.sql.Timestamp.valueOf(LocalDateTime.now())
        };
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                v.setCode(rs.getString("voucherCode"));
                v.setDescription(rs.getString("voucherDescription"));
                v.setType(rs.getString("type"));
                v.setValue(rs.getDouble("value"));
                v.setMaxValue(rs.getDouble("maxValue"));
                v.setMinValue(rs.getDouble("minValue"));
                v.setValidFrom(rs.getTimestamp("validFrom").toLocalDateTime());
                v.setValidTo(rs.getTimestamp("validTo").toLocalDateTime());
                v.setIsActive(rs.getBoolean("isActive"));
                v.setDestroy(rs.getBoolean("_destroy"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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
