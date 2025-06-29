package DAOs;

import Models.Revenue;
import Models.TopProduct;
import DB.DBContext;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

public class DashboardDAO {

    /**
     * Lấy danh sách revenue theo period: daily (yyyy-MM-dd), monthly (yyyy-MM),
     * yearly (yyyy)
     *
     * @param period daily / monthly / yearly
     * @param startDate Chuỗi ngày bắt đầu (yyyy-MM-dd)
     * @param endDate Chuỗi ngày kết thúc (yyyy-MM-dd)
     * @return List<Revenue>
     */
    public List<Revenue> getRevenueData(String period, String startDate, String endDate) {
        List<Revenue> result = new ArrayList<>();
        String sql = "";

        switch (period.toLowerCase()) {
            case "daily":
                sql = "SELECT CAST(createdAt AS DATE) AS period, "
                        + "SUM(totalAmount) AS revenue, "
                        + "COUNT(orderId) AS orderCount "
                        + "FROM Orders "
                        + "WHERE createdAt >= ? AND createdAt <= ? AND statusId != 5 "
                        + "GROUP BY CAST(createdAt AS DATE) "
                        + "ORDER BY period ASC";
                break;
            case "monthly":
                sql = "SELECT FORMAT(createdAt, 'yyyy-MM') AS period, "
                        + "SUM(totalAmount) AS revenue, "
                        + "COUNT(orderId) AS orderCount "
                        + "FROM Orders "
                        + "WHERE createdAt >= ? AND createdAt <= ? AND statusId != 5 "
                        + "GROUP BY FORMAT(createdAt, 'yyyy-MM') "
                        + "ORDER BY period ASC";
                break;
            case "yearly":
                sql = "SELECT CAST(YEAR(createdAt) AS VARCHAR) AS period, "
                        + "SUM(totalAmount) AS revenue, "
                        + "COUNT(orderId) AS orderCount "
                        + "FROM Orders "
                        + "WHERE createdAt >= ? AND createdAt <= ? AND statusId != 5 "
                        + "GROUP BY YEAR(createdAt) "
                        + "ORDER BY period ASC";
                break;
            default:
                throw new IllegalArgumentException("Invalid period: " + period);
        }

        DBContext dbContext = new DBContext();
        try ( Connection conn = dbContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String periodValue = rs.getString("period");
                BigDecimal revenue = rs.getBigDecimal("revenue");
                int orderCount = rs.getInt("orderCount");

                result.add(new Revenue(
                        periodValue,
                        revenue != null ? revenue.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO,
                        orderCount
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy top sản phẩm bán chạy nhất trong khoảng thời gian
     *
     * @param startDate ngày bắt đầu (yyyy-MM-dd)
     * @param endDate ngày kết thúc (yyyy-MM-dd)
     * @param limit số lượng sản phẩm top trả về
     * @return List<TopProduct>
     */
    public List<TopProduct> getTopProducts(String startDate, String endDate, int limit) {
        List<TopProduct> result = new ArrayList<>();

        String sql = "SELECT TOP (?) p.productId, p.productTitle, "
                + "SUM(od.detailQuantity) AS totalSold, "
                + "SUM(od.detailPrice * od.detailQuantity) AS totalRevenue "
                + "FROM Products p "
                + "INNER JOIN OrderDetails od ON p.productId = od.productId "
                + "INNER JOIN Orders o ON od.orderId = o.orderId "
                + "WHERE o.createdAt >= ? AND o.createdAt <= ? "
                + "AND o.statusId != 5 AND p.isActive = 1 "
                + "GROUP BY p.productId, p.productTitle "
                + "ORDER BY totalSold DESC";

        DBContext dbContext = new DBContext();
        try ( Connection conn = dbContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setString(2, startDate);
            ps.setString(3, endDate);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopProduct data = new TopProduct();
                data.setProductId(rs.getInt("productId"));
                data.setProductTitle(rs.getString("productTitle"));
                data.setTotalSold(rs.getInt("totalSold"));

                BigDecimal totalRevenue = rs.getBigDecimal("totalRevenue");
                if (totalRevenue != null) {
                    data.setTotalRevenue(totalRevenue.setScale(2, RoundingMode.HALF_UP));
                } else {
                    data.setTotalRevenue(BigDecimal.ZERO);
                }

                result.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int countCustomers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Customers WHERE _destroy = 0";
        DBContext dbContext = new DBContext();
        try ( Connection conn = dbContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int countStaff() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Employees WHERE _destroy = 0 AND isBlock = 0";
        DBContext dbContext = new DBContext();
        try ( Connection conn = dbContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public Map<String, Integer> getOrderStatusDistribution(LocalDate start, LocalDate end) {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql
                = "SELECT s.statusName, COUNT(o.orderId) AS count "
                + "FROM OrderStatus s "
                + "LEFT JOIN Orders o ON o.statusId = s.statusId "
                + "AND o.createdAt >= ? AND o.createdAt <= ? "
                + "GROUP BY s.statusName, s.statusId "
                + "ORDER BY s.statusId ASC";
        DBContext dbContext = new DBContext();
        try ( Connection conn = dbContext.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, start.toString());
            ps.setString(2, end.toString());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.put(rs.getString("statusName"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

}
