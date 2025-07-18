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
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Product;
import Models.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Modern 15
 */
public class OrdersDAO {

    private DBContext db = new DBContext();

    public List<Order> getOrdersByCustomer(int customerId) throws SQLException {

        return filterOrders(customerId, null, null);
    }

    public Order getOrderDetail(int orderId, int customerId) throws SQLException {
        String sql = "SELECT o.*, e.employeeId, e.employeeName, "
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

        // Employee
        Employee emp = new Employee();
        emp.setId(rs.getInt("employeeId"));
        emp.setName(rs.getString("employeeName"));
        order.setEmployee(emp);

        // OrderStatus
        OrderStatus os = new OrderStatus();
        os.setId(rs.getInt("statusId"));
        os.setName(rs.getString("statusName"));
        os.setDescription(rs.getString("statusDescription"));
        order.setOrderStatus(os);

        // PaymentStatus
        PaymentStatus ps = new PaymentStatus();
        ps.setId(rs.getInt("paymentStatusId"));
        ps.setName(rs.getString("paymentStatusName"));
        order.setPaymentStatus(ps);

        // Voucher 
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

            list.add(d);
        }
        rs.getStatement().getConnection().close();
        return list;
    }

    public boolean cancelOrder(int orderId, int customerId) throws SQLException {
        String sql = "UPDATE Orders SET statusId = 5 "
                + "WHERE orderId = ? AND customerId = ? AND statusId IN (1,2)";
        Object[] params = {orderId, customerId};
        int updated = db.execQuery(sql, params);
        return updated > 0;
    }

    public List<Order> filterOrders(int customerId, Integer statusId, String search) throws SQLException {
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
        sql.append(" ORDER BY o.createdAt DESC");

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
}
