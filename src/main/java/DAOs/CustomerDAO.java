/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
public class CustomerDAO extends DB.DBContext {

    public List<Customer> getAllCustomer(int page, int limit) {
        int row = (page - 1) * limit;
        List<Customer> list = new ArrayList<>();
        String query = "SELECT * FROM Customers "
                + "ORDER BY customerId DESC "
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Customer cus = new Customer(
                        rs.getInt("customerId"),
                        rs.getString("customerEmail"),
                        rs.getString("customerPassword"),
                        rs.getString("customerName"),
                        rs.getString("customerAvatar"),
                        rs.getString("customerPhone"),
                        rs.getTimestamp("createdAt").toLocalDateTime(),
                        rs.getInt("isBlock") == 1
                );
                list.add(cus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countCustomer() {
        String query = "SELECT COUNT(*) as total FROM Customers";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateBlockStatus(int id, boolean isBlock) {
        String query = "UPDATE Customers SET isBlock = ? WHERE customerId = ?";
        Object[] params = {isBlock, id};

        try {
            int rowsAffected = execQuery(query, params);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Customer getCustomerById(int id) {
        String query = "SELECT * FROM Customers WHERE customerId = ?";
        Object[] params = {id};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                Customer cus = new Customer();
                cus.setId(rs.getInt("customerId"));
                cus.setEmail(rs.getString("customerEmail"));
                cus.setPassword(rs.getString("customerPassword"));
                cus.setName(rs.getString("customerName"));
                cus.setAvatar(rs.getString("customerAvatar"));
                cus.setPhone(rs.getString("customerPhone"));
                Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) {
                    cus.setCreatedAt(ts.toLocalDateTime());
                }
                cus.setIsBlock(rs.getBoolean("isBlock"));
                return cus;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getAddressDetailsByCustomerId(int customerId) {
        String query = "SELECT addressDetails FROM Address WHERE customerId = ?";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{customerId})) {
            if (rs.next()) {
                return rs.getString("addressDetails");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countOrdersByCustomerId(int customerId) {
        String query = "SELECT COUNT(*) as total FROM Orders WHERE customerId = ?";
        Object[] params = {customerId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.orderId, o.totalAmount, o.shippingFee, o.createdAt, o.updatedAt, "
                + "o.voucherId, v.value, v.type "
                + "FROM Orders o "
                + "LEFT JOIN Vouchers v ON o.voucherId = v.voucherId "
                + "WHERE o.customerId = ?";
        Object[] params = {customerId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("orderId"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setShippingFee(rs.getDouble("shippingFee"));
                order.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                order.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());

                Voucher voucherValue = new Voucher();
                voucherValue.setValue(rs.getDouble("value"));
                voucherValue.setType(rs.getString("type"));
                order.setVoucher(voucherValue);

                order.setDetails(getOrderDetailsByOrderId(order.getId()));

                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<OrderDetails> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetails> details = new ArrayList<>();
        String query = "SELECT od.orderDetailId, od.orderId, od.detailPrice, od.detailQuantity, "
                + "p.productId, p.productTitle, "
                + "(SELECT TOP 1 url FROM ProductImages WHERE productId = p.productId) AS imageUrl "
                + "FROM OrderDetails od "
                + "JOIN Products p ON od.productId = p.productId "
                + "WHERE od.orderId = ?";
        Object[] params = {orderId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                // Tạo đối tượng Product
                Product product = new Product();
                product.setProductId(rs.getInt("productId"));
                product.setTitle(rs.getString("productTitle"));

                // Xử lý URL hình ảnh
                List<String> urls = new ArrayList<>();
                String imageUrl = rs.getString("imageUrl");
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    urls.add(imageUrl);
                }
//else {
//                    // Nếu không có ảnh, thêm ảnh default để tránh lỗi khi JSP gọi .get(0)
//                    urls.add("/default-image.png");
//                }
                product.setUrls(urls);

                // Tạo đối tượng OrderDetails
                OrderDetails detail = new OrderDetails();
                detail.setId(rs.getInt("orderDetailId"));
                detail.setOrderId(rs.getInt("orderId"));
                detail.setProduct(product);
                detail.setPrice(rs.getDouble("detailPrice"));
                detail.setQuantity(rs.getInt("detailQuantity"));

                // Thêm vào list
                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }
// Đăng nhập khách hàng

    public Customer login(String email, String hashedPassword) {
        String sql = "SELECT * FROM Customers WHERE customerEmail=? AND customerPassword=? AND isBlock=0 AND _destroy=0";
        Object[] params = {email, hashedPassword};
        try ( ResultSet rs = this.execSelectQuery(sql, params)) {
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("customerId"));
                c.setEmail(rs.getString("customerEmail"));
                c.setPassword(rs.getString("customerPassword"));
                c.setName(rs.getString("customerName"));
                c.setAvatar(rs.getString("customerAvatar"));
                c.setPhone(rs.getString("customerPhone"));
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) {
                    c.setCreatedAt(ts.toLocalDateTime());
                }
                c.setIsBlock(rs.getInt("isBlock") == 1);
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// Kiểm tra email đã tồn tại chưa
    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM Customers WHERE customerEmail=? AND _destroy=0";
        Object[] params = {email};
        try ( ResultSet rs = this.execSelectQuery(sql, params)) {
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Đăng ký khách hàng mới
    public boolean register(Customer c) {
        String sql = "INSERT INTO Customers (customerEmail, customerPassword, customerName, isVerify, isBlock, _destroy, createdAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        Object[] params = {
            c.getEmail(),
            c.getPassword(),
            c.getName(),
            0, // isVerify
            c.isIsBlock() ? 1 : 0, // isBlock
            0 // _destroy
        };
        try {
            int result = this.execQuery(sql, params);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
