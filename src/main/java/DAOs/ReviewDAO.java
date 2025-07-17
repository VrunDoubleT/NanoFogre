package DAOs;

import DB.DBContext;
import Models.Customer;
import Models.Employee;
import Models.Reply;
import Models.Review;
import Models.ReviewStats;
import Models.Voucher;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class ReviewDAO extends DBContext {

    public Review getReviewById(int reviewId) {
        Review review = null;

        String query = "SELECT * FROM Reviews r "
                + "JOIN Customers c ON r.customerId = c.customerId "
                + "WHERE r.reviewId = ?";

        String queryReply = "SELECT * FROM Replies p "
                + "JOIN Employees e ON p.employeeId = e.employeeId "
                + "WHERE p.reviewId = ? "
                + "ORDER BY p.replyId desc";

        Object[] params = {reviewId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                review = new Review();
                review.setId(rs.getInt("reviewId"));
                review.setProductId(rs.getInt("productId"));
                review.setStar(rs.getInt("star"));
                review.setContent(rs.getString("reviewContent"));
                review.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());

                Customer customer = new Customer(
                        rs.getInt("customerId"),
                        rs.getString("customerEmail"),
                        rs.getString("customerPassword"),
                        rs.getString("customerName"),
                        rs.getString("customerAvatar"),
                        rs.getString("customerPhone"),
                        rs.getTimestamp("createdAt").toLocalDateTime(),
                        rs.getInt("isBlock") == 1,
                        rs.getInt("isVerify") == 1 // <<== Bổ sung dòng này
                );
                review.setCustomer(customer);

                // Lấy danh sách phản hồi
                Object[] replyParams = {reviewId};
                List<Reply> replies = new ArrayList<>();

                try ( ResultSet rsR = execSelectQuery(queryReply, replyParams)) {
                    while (rsR.next()) {
                        Reply reply = new Reply();
                        reply.setId(rsR.getInt("replyId"));
                        reply.setPreviewId(reviewId);
                        reply.setContent(rsR.getString("replyContent"));
                        reply.setCreatedAt(rsR.getTimestamp("createdAt").toLocalDateTime());

                        Employee employee = new Employee();
                        employee.setName(rsR.getString("employeeName"));
                        employee.setEmail(rsR.getString("employeeEmail"));
                        employee.setAvatar(rsR.getString("employeeAvatar"));

                        reply.setEmployee(employee);
                        replies.add(reply);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                review.setReplies(replies);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return review;
    }

    public List<Review> getReviewsByProductId(int productId, int star, int page, int limit) {
        List<Review> reviews = new ArrayList<>();
        int offset = (page - 1) * limit;

        String query = "SELECT * FROM Reviews r "
                + "JOIN Customers c ON r.customerId = c.customerId "
                + "WHERE r.productId = ?";

        if (star > 0) {
            query += " AND r.star = " + star;
        }

        query += " ORDER BY r.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        String queryReply = "SELECT * FROM Replies p "
                + "JOIN Employees e ON p.employeeId = e.employeeId "
                + "WHERE p.reviewId = ? "
                + "ORDER BY p.replyId desc";

        Object[] params = {productId, offset, limit};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                Review review = new Review();
                int reviewId = rs.getInt("reviewId");
                review.setId(reviewId);
                review.setProductId(rs.getInt("productId"));
                review.setStar(rs.getInt("star"));
                review.setContent(rs.getString("reviewContent"));
                review.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());

                review.setCustomer(new Customer(
                        rs.getInt("customerId"),
                        rs.getString("customerEmail"),
                        rs.getString("customerPassword"),
                        rs.getString("customerName"),
                        rs.getString("customerAvatar"),
                        rs.getString("customerPhone"),
                        LocalDateTime.MAX,
                        rs.getBoolean("isBlock")
                ));

                Object[] replyParams = {reviewId};
                List<Reply> replies = new ArrayList<>();

                try ( ResultSet rsR = execSelectQuery(queryReply, replyParams)) {
                    while (rsR.next()) {
                        Reply reply = new Reply();
                        reply.setId(rsR.getInt("replyId"));
                        reply.setPreviewId(reviewId);
                        reply.setContent(rsR.getString("replyContent"));
                        reply.setCreatedAt(rsR.getTimestamp("createdAt").toLocalDateTime());

                        Employee employee = new Employee();
                        employee.setName(rsR.getString("employeeName"));
                        employee.setEmail(rsR.getString("employeeEmail"));
                        employee.setAvatar(rsR.getString("employeeAvatar"));

                        reply.setEmployee(employee);
                        replies.add(reply);
                    }
                } catch (SQLException sQLException) {
                    sQLException.printStackTrace();
                }

                review.setReplies(replies);
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public List<Review> getTopFiveStarReviews(int limit) {
        List<Review> reviews = new ArrayList<>();

        String query = "SELECT * FROM Reviews r "
                + "JOIN Customers c ON r.customerId = c.customerId "
                + "WHERE r.star = 5 "
                + "ORDER BY r.createdAt DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        Object[] params = {limit};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("reviewId"));
                review.setProductId(rs.getInt("productId"));
                review.setStar(rs.getInt("star"));
                review.setContent(rs.getString("reviewContent"));
                review.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());

                Customer customer = new Customer(
                        rs.getInt("customerId"),
                        rs.getString("customerEmail"),
                        rs.getString("customerPassword"),
                        rs.getString("customerName"),
                        rs.getString("customerAvatar"),
                        rs.getString("customerPhone"),
                        LocalDateTime.MAX,
                        rs.getBoolean("isBlock")
                );

                review.setCustomer(customer);
                review.setReplies(null);

                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public ReviewStats getReviewStatsByProductId(int productId) {
        ReviewStats stats = new ReviewStats();
        String sql = "SELECT \n"
                + "            COUNT(*) AS totalReviews,\n"
                + "            AVG(CAST(star AS FLOAT)) AS averageStars,\n"
                + "            SUM(CASE WHEN star = 5 THEN 1 ELSE 0 END) AS fiveStar,\n"
                + "            SUM(CASE WHEN star = 4 THEN 1 ELSE 0 END) AS fourStar,\n"
                + "            SUM(CASE WHEN star = 3 THEN 1 ELSE 0 END) AS threeStar,\n"
                + "            SUM(CASE WHEN star = 2 THEN 1 ELSE 0 END) AS twoStar,\n"
                + "            SUM(CASE WHEN star = 1 THEN 1 ELSE 0 END) AS oneStar\n"
                + "        FROM Reviews\n"
                + "        WHERE productId = ?";
        Object[] params = {productId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                stats.setTotalReviews(rs.getInt("totalReviews"));
                stats.setAverageStars(rs.getDouble("averageStars"));
                stats.setFiveStar(rs.getInt("fiveStar"));
                stats.setFourStar(rs.getInt("fourStar"));
                stats.setThreeStar(rs.getInt("threeStar"));
                stats.setTwoStar(rs.getInt("twoStar"));
                stats.setOneStar(rs.getInt("oneStar"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    public boolean addReply(int reviewId, int employeeId, String replyContent) {
        String sql = "INSERT INTO Replies (reviewId, employeeId, replyContent, createdAt) "
                + "VALUES (?, ?, ?, GETDATE())";

        Object[] params = {reviewId, employeeId, replyContent};

        try {
            int rowsAffected = execQuery(sql, params);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countReviewByProductIdAndStar(int productId, int star) {
        int count = 0;
        String sql;
        Object[] params;

        if (star > 0) {
            sql = "SELECT COUNT(*) FROM Reviews WHERE productId = ? AND star = ?";
            params = new Object[]{productId, star};
        } else {
            sql = "SELECT COUNT(*) FROM Reviews WHERE productId = ?";
            params = new Object[]{productId};
        }

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public boolean insertReview(int productId, int customerId, int star, String content) {
        String sql = "INSERT INTO Reviews (productId, customerId, star, reviewContent, createdAt, _destroy) VALUES (?, ?, ?, ?, GETDATE(), 0)";
        Object[] params = {productId, customerId, star, content};
        try {
            int rows = execQuery(sql, params);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
