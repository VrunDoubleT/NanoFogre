package DAOs;

import Models.Revenue;
import Models.TopProduct;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

public class DashboardDAO extends DB.DBContext {

    public List<Revenue> getRevenueData(String period, String startDate, String endDate) {
        List<Revenue> result = new ArrayList<>();
        String sql;

        switch (period.toLowerCase()) {
            case "daily":
                sql = "SELECT CAST(createdAt AS DATE) AS period, SUM(totalAmount) AS revenue, COUNT(orderId) AS orderCount "
                    + "FROM Orders WHERE createdAt BETWEEN ? AND ? AND statusId != 5 "
                    + "GROUP BY CAST(createdAt AS DATE) ORDER BY period ASC";
                break;
            case "monthly":
                sql = "SELECT FORMAT(createdAt, 'yyyy-MM') AS period, SUM(totalAmount) AS revenue, COUNT(orderId) AS orderCount "
                    + "FROM Orders WHERE createdAt BETWEEN ? AND ? AND statusId != 5 "
                    + "GROUP BY FORMAT(createdAt, 'yyyy-MM') ORDER BY period ASC";
                break;
            case "yearly":
                sql = "SELECT CAST(YEAR(createdAt) AS VARCHAR) AS period, SUM(totalAmount) AS revenue, COUNT(orderId) AS orderCount "
                    + "FROM Orders WHERE createdAt BETWEEN ? AND ? AND statusId != 5 "
                    + "GROUP BY YEAR(createdAt) ORDER BY period ASC";
                break;
            default:
                throw new IllegalArgumentException("Invalid period: " + period);
        }

        Object[] params = {startDate, endDate};
        try (ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                result.add(new Revenue(
                        rs.getString("period"),
                        rs.getBigDecimal("revenue") != null
                                ? rs.getBigDecimal("revenue").setScale(2, RoundingMode.HALF_UP)
                                : BigDecimal.ZERO,
                        rs.getInt("orderCount")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    public List<TopProduct> getTopProducts(String startDate, String endDate, int limit) {
        List<TopProduct> result = new ArrayList<>();
        String sql = "SELECT TOP (?) p.productId, p.productTitle, "
                   + "SUM(od.detailQuantity) AS totalSold, "
                   + "SUM(od.detailPrice * od.detailQuantity) AS totalRevenue "
                   + "FROM Products p "
                   + "INNER JOIN OrderDetails od ON p.productId = od.productId "
                   + "INNER JOIN Orders o ON od.orderId = o.orderId "
                   + "WHERE o.createdAt BETWEEN ? AND ? AND o.statusId != 5 AND p.isActive = 1 "
                   + "GROUP BY p.productId, p.productTitle "
                   + "ORDER BY totalSold DESC";

        Object[] params = {limit, startDate, endDate};
        try (ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                TopProduct product = new TopProduct();
                product.setProductId(rs.getInt("productId"));
                product.setProductTitle(rs.getString("productTitle"));
                product.setTotalSold(rs.getInt("totalSold"));
                product.setTotalRevenue(
                    rs.getBigDecimal("totalRevenue") != null
                        ? rs.getBigDecimal("totalRevenue").setScale(2, RoundingMode.HALF_UP)
                        : BigDecimal.ZERO
                );
                result.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM Customers WHERE _destroy = 0";
        try (ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countStaff() {
        String sql = "SELECT COUNT(*) FROM Employees WHERE _destroy = 0 AND isBlock = 0";
        try (ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Integer> getOrderStatusDistribution(LocalDate start, LocalDate end) {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT s.statusName, COUNT(o.orderId) AS count "
                   + "FROM OrderStatus s "
                   + "LEFT JOIN Orders o ON o.statusId = s.statusId "
                   + "AND o.createdAt BETWEEN ? AND ? "
                   + "GROUP BY s.statusName, s.statusId "
                   + "ORDER BY s.statusId ASC";

        Object[] params = {start.toString(), end.toString()};
        try (ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                result.put(rs.getString("statusName"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}
