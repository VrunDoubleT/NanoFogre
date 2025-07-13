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
import Models.OrderDetails;
import Models.OrderStatus;
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Product;
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

    public Order getOrderById(int orderId) {
        Order o = null;
        String sql
                = "SELECT "
                + "  o.[orderId], "
                + "  o.[employeeId], "
                + "  o.[customerId], "
                + "  o.[totalAmount], "
                + "  o.[shippingFee], "
                + "  o.[paymentMethodId], "
                + "  o.[paymentStatusId], "
                + "  o.[statusId], "
                + "  o.[voucherId], "
                + "  o.[addressId], "
                + "  o.[createdAt], "
                + "  o.[updatedAt], "
                + "  c.[customerName]       AS customerName, "
                + "  c.[customerAvatar]     AS customerAvatar, "
                + "  c.[customerPhone]      AS customerPhone, "
                + "  pm.[paymentMethodName] AS paymentMethodName, "
                + "  ps.[paymentStatusName] AS paymentStatusName, "
                + "  os.[statusName]        AS orderStatusName, "
                + "  v.[voucherCode]        AS voucherCode, "
                + "  a.[addressDetails]     AS shippingAddress "
                + "FROM .[Orders]        o "
                + "JOIN [Customers]   c  ON o.[customerId]      = c.[customerId] "
                + "LEFT JOIN [PaymentMethods] pm ON o.[paymentMethodId] = pm.[paymentMethodId] "
                + "LEFT JOIN [PaymentStatus]  ps ON o.[paymentStatusId] = ps.[paymentStatusId] "
                + "LEFT JOIN [OrderStatus]    os ON o.[statusId]        = os.[statusId] "
                + "LEFT JOIN [Vouchers]       v  ON o.[voucherId]       = v.[voucherId] "
                + "LEFT JOIN [Address]        a  ON o.[addressId]       = a.[addressId] "
                + "WHERE o.[orderId] = ?";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{orderId})) {
            if (rs.next()) {
                o = new Order();
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
                cust.setName(rs.getString("customerName"));
                cust.setPhone(rs.getString("customerPhone"));

                String avatar = rs.getString("customerAvatar");
                cust.setAvatar(avatar);
                o.setCustomer(cust);
                System.out.println(rs.getString("customerAvatar"));

                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("paymentMethodId"));
                pm.setName(rs.getString("paymentMethodName"));
                o.setPaymentMethod(pm);

                PaymentStatus psObj = new PaymentStatus();
                psObj.setId(rs.getInt("paymentStatusId"));
                psObj.setName(rs.getString("paymentStatusName"));
                o.setPaymentStatus(psObj);

                OrderStatus osObj = new OrderStatus();
                osObj.setId(rs.getInt("statusId"));
                osObj.setName(rs.getString("orderStatusName"));
                o.setOrderStatus(osObj);

                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                v.setCode(rs.getString("voucherCode"));
                o.setVoucher(v);

                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                a.setFullAddress(rs.getString("shippingAddress"));
                o.setAddress(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return o;
    }

    /**
     * OrderDetails
     */
    public List<OrderDetails> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetails> list = new ArrayList<>();
        String sql
                = "SELECT od.orderDetailId, od.orderId, "
                + "       od.detailPrice    AS detailPrice, "
                + "       od.detailQuantity AS detailQuantity, "
                + "       p.productId, "
                + "       p.productTitle    AS productTitle, "
                + "(SELECT TOP 1 url FROM ProductImages WHERE productId = p.productId) AS imageUrl "
                + "  FROM OrderDetails od "
                + "  JOIN Products p ON od.productId = p.productId "
                + " WHERE od.orderId = ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{orderId})) {
            while (rs.next()) {
                OrderDetails d = new OrderDetails();
                d.setId(rs.getInt("orderDetailId"));
                d.setOrderId(rs.getInt("orderId"));

                Product prod = new Product();
                prod.setProductId(rs.getInt("productId"));
                prod.setTitle(rs.getString("productTitle"));

                List<String> urls = new ArrayList<>();
                String imageUrl = rs.getString("imageUrl");
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    urls.add(imageUrl);
                }
                prod.setUrls(urls);
                d.setProduct(prod);

                d.setPrice(rs.getDouble("detailPrice"));
                d.setQuantity(rs.getInt("detailQuantity"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrders() {
        List<Order> list = new ArrayList<>();
        String sql
                = "SELECT TOP (1000) "
                + "  o.[orderId], o.[employeeId], o.[customerId], o.[totalAmount], o.[shippingFee], "
                + "  o.[paymentMethodId], o.[paymentStatusId], o.[statusId], o.[voucherId], o.[addressId], "
                + "  o.[createdAt], o.[updatedAt], "
                + "  c.[customerName]       AS customerName, "
                + "  pm.[paymentMethodName] AS paymentMethodName, "
                + "  ps.[paymentStatusName] AS paymentStatusName, "
                + "  os.[statusName]        AS orderStatusName, "
                + "  v.[voucherCode]        AS voucherCode, "
                + "  a.[addressDetails]     AS shippingAddress "
                + "FROM [DBNanoForge].[dbo].[Orders] o "
                + "LEFT JOIN [Customers]      c  ON o.[customerId]      = c.[customerId] "
                + "LEFT JOIN [PaymentMethods] pm ON o.[paymentMethodId] = pm.[paymentMethodId] "
                + "LEFT JOIN [PaymentStatus]  ps ON o.[paymentStatusId] = ps.[paymentStatusId] "
                + "LEFT JOIN [dbo].[OrderStatus]    os ON o.[statusId]         = os.[statusId] "
                + "LEFT JOIN [Vouchers]       v  ON o.[voucherId]        = v.[voucherId] "
                + "LEFT JOIN [Address]        a  ON o.[addressId]        = a.[addressId] "
                + "ORDER BY o.[orderId] DESC";

        try ( ResultSet rs = execSelectQuery(sql)) {
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
                cust.setName(rs.getString("customerName"));
                o.setCustomer(cust);

                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("paymentMethodId"));
                pm.setName(rs.getString("paymentMethodName"));
                o.setPaymentMethod(pm);

                PaymentStatus ps = new PaymentStatus();
                ps.setId(rs.getInt("paymentStatusId"));
                ps.setName(rs.getString("paymentStatusName"));
                o.setPaymentStatus(ps);

                OrderStatus os = new OrderStatus();
                os.setId(rs.getInt("statusId"));
                os.setName(rs.getString("orderStatusName"));
                o.setOrderStatus(os);

                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                v.setCode(rs.getString("voucherCode"));
                o.setVoucher(v);

                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                a.setFullAddress(rs.getString("shippingAddress"));
                o.setAddress(a);

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Order> getOrders(int page, int limit) {
        List<Order> list = new ArrayList<>();
        int offset = (page - 1) * limit;
        String sql
                = "SELECT "
                + "  o.[orderId], o.[employeeId], o.[customerId], o.[totalAmount], o.[shippingFee], "
                + "  o.[paymentMethodId], o.[paymentStatusId], o.[statusId], o.[voucherId], o.[addressId], "
                + "  o.[createdAt], o.[updatedAt], "
                + "  c.[customerName]       AS customerName, "
                + "  pm.[paymentMethodName] AS paymentMethodName, "
                + "  ps.[paymentStatusName] AS paymentStatusName, "
                + "  os.[statusName]        AS orderStatusName, "
                + "  v.[voucherCode]        AS voucherCode, "
                + "  a.[addressDetails]     AS shippingAddress "
                + "FROM [Orders] o "
                + "LEFT JOIN [Customers]      c  ON o.[customerId]      = c.[customerId] "
                + "LEFT JOIN [PaymentMethods] pm ON o.[paymentMethodId] = pm.[paymentMethodId] "
                + "LEFT JOIN [PaymentStatus]  ps ON o.[paymentStatusId] = ps.[paymentStatusId] "
                + "LEFT JOIN [OrderStatus]    os ON o.[statusId]         = os.[statusId] "
                + "LEFT JOIN [Vouchers]       v  ON o.[voucherId]        = v.[voucherId] "
                + "LEFT JOIN [Address]        a  ON o.[addressId]        = a.[addressId] "
                + "ORDER BY o.[orderId] DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
                cust.setName(rs.getString("customerName"));
                o.setCustomer(cust);

                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("paymentMethodId"));
                pm.setName(rs.getString("paymentMethodName"));
                o.setPaymentMethod(pm);

                PaymentStatus ps = new PaymentStatus();
                ps.setId(rs.getInt("paymentStatusId"));
                ps.setName(rs.getString("paymentStatusName"));
                o.setPaymentStatus(ps);

                OrderStatus os = new OrderStatus();
                os.setId(rs.getInt("statusId"));
                os.setName(rs.getString("orderStatusName"));
                o.setOrderStatus(os);

                Voucher v = new Voucher();
                v.setId(rs.getInt("voucherId"));
                v.setCode(rs.getString("voucherCode"));
                o.setVoucher(v);

                Address a = new Address();
                a.setId(rs.getInt("addressId"));
                a.setFullAddress(rs.getString("shippingAddress"));
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
        String sql = "SELECT COUNT(*) AS total FROM [Orders]";
        try ( ResultSet rs = execSelectQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateOrderStatus(int orderId, String statusName) {
        String sql = "UPDATE o\n"
                + "SET o.statusId = s.statusId,\n"
                + "    o.paymentStatusId = CASE s.statusName\n"
                + "        WHEN 'Pending' THEN 1\n"
                + "        WHEN 'Processing' THEN 1\n"
                + "        WHEN 'Shipped' THEN 1\n"
                + "        WHEN 'Delivered' THEN 2\n"
                + "        WHEN 'Cancelled' THEN 3\n"
                + "        ELSE o.paymentStatusId\n"
                + "    END,\n"
                + "    o.updatedAt = GETDATE()\n"
                + "FROM Orders o\n"
                + "INNER JOIN OrderStatus s ON s.statusName = ?\n"
                + "WHERE o.orderId = ?";
        try {
            int rows = execQuery(sql, new Object[]{statusName, orderId});
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean decreaseProductStock(int productId, int quantity) {
        String sql = "UPDATE Products SET productQuantity = productQuantity - ? WHERE productId = ?";

        try {
            Object[] params = new Object[]{quantity, productId};
            return execQuery(sql, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean insertOrderDetail(int orderId, int productId, int quantity, double price) {
        String sql = "INSERT INTO OrderDetails (orderId, productId, detailQuantity, detailPrice) VALUES (?, ?, ?, ?)";
        try {
            Object[] params = new Object[]{orderId, productId, quantity, price};
            return execQuery(sql, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int insertOrder(Order order) {
        String sql = "INSERT INTO Orders "
                + "(employeeId, customerId, totalAmount, shippingFee, "
                + "paymentMethodId, paymentStatusId, statusId, voucherId, addressId, createdAt) "
                + "VALUES (2, ?, ?, ?, ?, 1, 1, ?, ?, GETDATE())";

        try {
            Object[] params = new Object[]{
                order.getCustomer().getId(),
                order.getTotalAmount(),
                order.getShippingFee(),
                order.getPaymentMethod().getId(),
                order.getVoucher() != null ? order.getVoucher().getId() : null,
                order.getAddress().getId()
            };
            return execQueryReturnId(sql, params);
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

}
