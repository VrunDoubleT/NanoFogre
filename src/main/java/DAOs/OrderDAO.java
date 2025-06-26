/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Address;
import Models.Customer;
import Models.Employee;
import Models.Order;
import Models.OrderStatus;
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Voucher;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author iphon
 */
public class OrderDAO extends DBContext {

    /**
     * Retrieve all orders, sorted descending by ID.
     */
    /**
     * Retrieve all orders, sorted by orderId descending, mapping each ResultSet
     * row to an Order object inline.
     */
    public List<Order> getOrders() {
        List<Order> list = new ArrayList<>();
        String sql
                = "SELECT [orderId], [employeeId], [customerId], [totalAmount], [shippingFee], "
                + "[paymentMethodId], [paymentStatusId], [statusId], [voucherId], [addressId], "
                + "[createdAt], [updatedAt] "
                + "FROM [DBNanoForge].[dbo].[Orders] "
                + "ORDER BY orderId DESC";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                Order o = new Order();
                // Primitive fields
                o.setId(rs.getInt("orderId"));
                o.setTotalAmount(rs.getDouble("totalAmount"));
                o.setShippingFee(rs.getDouble("shippingFee"));
                o.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                o.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());

                // Associated entities (only id set; full details can be loaded later)
                Employee emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                o.setEmployee(emp);

                Customer cust = new Customer();
                cust.setId(rs.getInt("customerId"));
                o.setCustomer(cust);

                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("paymentMethodId"));
                o.setPaymentMethod(pm);

                PaymentStatus ps = new PaymentStatus();
                ps.setId(rs.getInt("paymentStatusId"));
                o.setPaymentStatus(ps);

                OrderStatus os = new OrderStatus();
                os.setId(rs.getInt("statusId"));
                o.setOrderStatus(os);

                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                o.setVoucher(v);

                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                o.setAddress(a);

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieve a page of orders with pagination.
     *
     * @param page 1-based page index
     * @param limit number of records per page
     */
    public List<Order> getOrders(int page, int limit) {
        List<Order> list = new ArrayList<>();
        int offset = (page - 1) * limit;
        String sql
                = "SELECT [orderId], [employeeId], [customerId], [totalAmount], [shippingFee], "
                + "[paymentMethodId], [paymentStatusId], [statusId], [voucherId], [addressId], "
                + "[createdAt], [updatedAt] "
                + "FROM [DBNanoForge].[dbo].[Orders] "
                + "ORDER BY orderId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{offset, limit})) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("orderId"));
                o.setTotalAmount(rs.getDouble("totalAmount"));
                o.setShippingFee(rs.getDouble("shippingFee"));
                o.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                o.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
                Employee emp = new Employee();
                emp.setId(rs.getInt("employeeId"));
                o.setEmployee(emp);
                Customer cust = new Customer();
                cust.setId(rs.getInt("customerId"));
                o.setCustomer(cust);
                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("paymentMethodId"));
                o.setPaymentMethod(pm);
                PaymentStatus ps = new PaymentStatus();
                ps.setId(rs.getInt("paymentStatusId"));
                o.setPaymentStatus(ps);
                OrderStatus os = new OrderStatus();
                os.setId(rs.getInt("statusId"));
                o.setOrderStatus(os);
                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                o.setVoucher(v);
                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                o.setAddress(a);
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Count total orders in database.
     */
    public int countOrders() {
        String sql = "SELECT COUNT(*) AS total FROM [DBNanoForge].[dbo].[Orders]";
        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
