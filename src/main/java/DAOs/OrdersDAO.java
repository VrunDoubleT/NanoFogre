/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Address;
import Models.Brand;
import Models.Category;
import Models.Customer;
import Models.Employee;
import Models.Order;
import Models.OrderDetails;
import Models.OrderStatus;
import Models.OrderStatusHistory;
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Product;
import Models.Voucher;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author Modern 15
 */
public class OrdersDAO {

    private DBContext db = new DBContext();

    public List<Order> getOrdersByCustomer(int customerId) throws SQLException {
        return filterOrders(customerId, null, null, null, null);
    }

    public Order getOrderDetail(int orderId, int customerId) throws SQLException {
        String sql = "SELECT o.*, "
                + "os.statusId, os.statusName, os.statusDescription, "
                + "pm.paymentMethodId, pm.paymentMethodName, "
                + "ps.paymentStatusId, ps.paymentStatusName, "
                + "v.voucherId, v.voucherCode, v.value, "
                + "a.addressId, a.recipientName, a.addressDetails, a.addressPhone "
                + "FROM Orders o "
                + "LEFT JOIN Employees e ON o.employeeId = e.employeeId "
                + "JOIN OrderStatus os ON o.statusId = os.statusId "
                + "JOIN PaymentMethods pm ON o.paymentMethodId = pm.paymentMethodId "
                + "JOIN PaymentStatus ps ON o.paymentStatusId = ps.paymentStatusId "
                + "LEFT JOIN Vouchers v ON o.voucherId = v.voucherId "
                + "JOIN Address a ON o.addressId = a.addressId "
                + "WHERE o.orderId = ? AND o.customerId = ?";
        Object[] params = {orderId, customerId};
        ResultSet rs = db.execSelectQuery(sql, params);
        if (!rs.next()) {
            rs.getStatement().getConnection().close();
            return null;
        }

        Order order = new Order();
        order.setId(rs.getInt("orderId"));
        order.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        order.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
        order.setTotalAmount(rs.getDouble("totalAmount"));
        order.setShippingFee(rs.getDouble("shippingFee"));

        OrderStatus os = new OrderStatus();
        os.setId(rs.getInt("statusId"));
        os.setName(rs.getString("statusName"));
        os.setDescription(rs.getString("statusDescription"));
        order.setOrderStatus(os);

        // PaymentMethod
        PaymentMethod pm = new PaymentMethod();
        pm.setId(rs.getInt("paymentMethodId"));
        pm.setName(rs.getString("paymentMethodName"));
        order.setPaymentMethod(pm);

        // PaymentStatus
        PaymentStatus ps = new PaymentStatus();
        ps.setId(rs.getInt("paymentStatusId"));
        ps.setName(rs.getString("paymentStatusName"));
        order.setPaymentStatus(ps);

        if (rs.getObject("voucherId") != null) {
            Voucher v = new Voucher();
            v.setId(rs.getInt("voucherId"));
            v.setCode(rs.getString("voucherCode"));
            v.setValue(rs.getDouble("value"));
            order.setVoucher(v);
        }

        // Address
        Address addr = new Address();
        addr.setRecipientName(rs.getString("recipientName"));
        addr.setDetails(rs.getString("addressDetails"));
        addr.setPhone(rs.getString("addressPhone"));
        order.setAddress(addr);
        order.setDetails(getOrderDetails(orderId, customerId));

        rs.getStatement().getConnection().close();
        return order;
    }

    public List<OrderDetails> getOrderDetails(int orderId, int customerId) throws SQLException {
        List<OrderDetails> list = new ArrayList<>();
        String sql
                = "SELECT od.orderDetailId, od.detailQuantity, od.detailPrice, "
                + "       p.productId, p.productTitle, "
                + "       (SELECT TOP 1 pi.url FROM ProductImages pi WHERE pi.productId = p.productId) AS url "
                + "  FROM OrderDetails od "
                + "  JOIN Products p ON od.productId = p.productId "
                + " WHERE od.orderId = ?";
        ResultSet rs = db.execSelectQuery(sql, new Object[]{orderId});
        ReviewDAO reviewDAO = new ReviewDAO();
        while (rs.next()) {
            OrderDetails d = new OrderDetails();
            d.setId(rs.getInt("orderDetailId"));
            d.setOrderId(orderId);
            d.setQuantity(rs.getInt("detailQuantity"));
            d.setPrice(rs.getDouble("detailPrice"));

            Product p = new Product();
            p.setProductId(rs.getInt("productId"));
            p.setTitle(rs.getString("productTitle"));
            List<String> urls = new ArrayList<>();
            String url = rs.getString("url");
            if (url != null) {
                urls.add(url);
            }
            p.setUrls(urls);
            d.setProduct(p);
            d.setReviewed(isProductReviewed(customerId, p.getProductId()));
            Models.Review review = reviewDAO.getReviewByCustomerAndProduct(customerId, p.getProductId());
            if (review != null) {
                d.setReviewContent(review.getContent());
                d.setReviewStar(review.getStar());
            } else {
                d.setReviewContent("");
                d.setReviewStar(5);
            }

            list.add(d);
        }
        rs.getStatement().getConnection().close();
        return list;
    }

    // 4. Hủy đơn hàng (nếu status IN (1,2))
//    public boolean cancelOrder(int orderId, int customerId) throws SQLException {
//        String sql = "UPDATE Orders SET statusId = 5 "
//                + "WHERE orderId = ? AND customerId = ? AND statusId IN (1,2)";
//        Object[] params = {orderId, customerId};
//        int updated = db.execQuery(sql, params);
//        if (updated > 0) {
//            insertOrderStatusHistory(orderId, 5, 1); // 1 là employeeId của Admin User
//        }
//        return updated > 0;
//    }
    public List<Order> filterOrders(int customerId, Integer statusId, String search, Integer page, Integer pageSize) throws SQLException {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.orderId, o.createdAt, o.totalAmount, o.shippingFee, "
                + "       os.statusId, os.statusName, "
                + "       ps.paymentStatusId, ps.paymentStatusName, "
                + "       a.recipientName, a.addressDetails, a.addressPhone "
                + "  FROM Orders o "
                + "  JOIN OrderStatus os ON o.statusId = os.statusId "
                + "  JOIN PaymentStatus ps ON o.paymentStatusId = ps.paymentStatusId "
                + "  JOIN Address a ON o.addressId = a.addressId "
                + " WHERE o.customerId = ? "
        );
        List<Object> params = new ArrayList<>();
        params.add(customerId);

        if (statusId != null) {
            sql.append(" AND o.statusId = ? ");
            params.add(statusId);
        }
        if (search != null && !search.isEmpty()) {
            sql.append(" AND o.orderId LIKE ? ");
            params.add("%" + search + "%");
        }
        sql.append(" ORDER BY o.createdAt DESC ");

        if (page != null && pageSize != null && page > 0 && pageSize > 0) {
            int offset = (page - 1) * pageSize;
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
            params.add(offset);
            params.add(pageSize);
        }

        ResultSet rs = db.execSelectQuery(sql.toString(), params.toArray());
        while (rs.next()) {
            Order order = new Order();
            order.setId(rs.getInt("orderId"));
            order.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
            order.setTotalAmount(rs.getDouble("totalAmount"));
            order.setShippingFee(rs.getDouble("shippingFee"));

            OrderStatus os = new OrderStatus();
            os.setId(rs.getInt("statusId"));
            os.setName(rs.getString("statusName"));
            order.setOrderStatus(os);

            PaymentStatus ps = new PaymentStatus();
            ps.setId(rs.getInt("paymentStatusId"));
            ps.setName(rs.getString("paymentStatusName"));
            order.setPaymentStatus(ps);

            Address addr = new Address();
            addr.setRecipientName(rs.getString("recipientName"));
            addr.setDetails(rs.getString("addressDetails"));
            addr.setPhone(rs.getString("addressPhone"));
            order.setAddress(addr);
            order.setDetails(getOrderDetails(order.getId(), customerId));
            orders.add(order);
        }
        rs.getStatement().getConnection().close();
        return orders;
    }

    public List<OrderStatus> getAllOrderStatus() throws SQLException {
        List<OrderStatus> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderStatus";
        ResultSet rs = db.execSelectQuery(sql);
        while (rs.next()) {
            OrderStatus os = new OrderStatus();
            os.setId(rs.getInt("statusId"));
            os.setName(rs.getString("statusName"));
            os.setDescription(rs.getString("statusDescription"));
            list.add(os);
        }
        rs.getStatement().getConnection().close();
        return list;
    }

    public boolean isProductReviewed(int customerId, int productId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE customerId=? AND productId=?";
        ResultSet rs = db.execSelectQuery(sql, new Object[]{customerId, productId});
        boolean result = false;
        if (rs.next()) {
            result = rs.getInt(1) > 0;
        }
        rs.getStatement().getConnection().close();
        return result;
    }

    public void insertOrderStatusHistory(int orderId, int statusId, int updatedBy) throws SQLException {
        String sql = "INSERT INTO OrderStatusHistory (orderId, statusId, updatedAt, updatedBy) VALUES (?, ?, GETDATE(), ?)";
        db.execQuery(sql, new Object[]{orderId, statusId, updatedBy});
    }

    public List<OrderStatusHistory> getOrderStatusHistory(int orderId) throws SQLException {
        List<OrderStatusHistory> history = new ArrayList<>();
        String sql = "SELECT h.*, os.statusName, os.statusDescription "
                + "FROM OrderStatusHistory h "
                + "JOIN OrderStatus os ON h.statusId = os.statusId "
                + "WHERE h.orderId = ? ORDER BY h.updatedAt ASC";
        ResultSet rs = db.execSelectQuery(sql, new Object[]{orderId});
        while (rs.next()) {
            OrderStatusHistory item = new OrderStatusHistory();
            item.setHistoryId(rs.getInt("historyId"));
            item.setOrderId(rs.getInt("orderId"));
            item.setStatusId(rs.getInt("statusId"));
            item.setStatusName(rs.getString("statusName"));
            item.setStatusNote(rs.getString("statusDescription"));
            LocalDateTime updatedAt = rs.getTimestamp("updatedAt").toLocalDateTime();
            item.setUpdatedAt(updatedAt);
            item.setUpdatedAtStr(updatedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
            item.setUpdatedBy(rs.getInt("updatedBy"));
            // item.setUpdaterName(rs.getString("updaterName"));
            history.add(item);
        }
        rs.getStatement().getConnection().close();
        return history;
    }
}
