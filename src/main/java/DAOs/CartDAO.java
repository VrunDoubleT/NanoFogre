package DAOs;

import Models.Address;
import Models.Brand;
import Models.Cart;
import Models.Category;
import Models.Product;
import Models.Voucher;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DB.DBContext {

    public List<Cart> getCartItemsByUserId(int customerId) {
        List<Cart> list = new ArrayList<>();
        String sql
                = "SELECT c.cartId, c.customerId, c.cartQuantity, "
                + "       p.productId, p.productTitle, p.productPrice, p.productQuantity, "
                + "       pi.imageUrl, "
                + "       ISNULL(r.avgStar, 0) AS avgStar, "
                + "       b.brandName, b.brandId, cat.categoryName,cat.categoryId "
                + "FROM Carts c "
                + "JOIN Products p ON c.productId = p.productId "
                + "LEFT JOIN ( "
                + "    SELECT productId, url AS imageUrl "
                + "    FROM ProductImages "
                + "    WHERE imageId IN (SELECT MIN(imageId) FROM ProductImages GROUP BY productId) "
                + ") pi ON p.productId = pi.productId "
                + "LEFT JOIN ( "
                + "    SELECT productId, AVG(CAST(star AS FLOAT)) AS avgStar "
                + "    FROM Reviews GROUP BY productId "
                + ") r ON p.productId = r.productId "
                + "LEFT JOIN Brands b ON p.brandId = b.brandId "
                + "LEFT JOIN Categories cat ON p.categoryId = cat.categoryId "
                + "WHERE c.customerId = ? "
                + "ORDER BY c.cartId DESC";

        Object[] params = {customerId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cartId"));
                cart.setCustomerId(rs.getInt("customerId"));
                cart.setQuantity(rs.getInt("cartQuantity"));

                // Map Product
                Product product = new Product();
                product.setProductId(rs.getInt("productId"));
                product.setTitle(rs.getString("productTitle"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));

                // Map image(s)
                List<String> urls = new ArrayList<>();
                String imgUrl = rs.getString("imageUrl");
                if (imgUrl != null && !imgUrl.isEmpty()) {
                    urls.add(imgUrl);
                }
                product.setUrls(urls);

                Brand bra = new Brand();
                bra.setId(rs.getInt("brandId"));
                bra.setName(rs.getString("brandName"));
                product.setBrand(bra);

                Category c = new Category();
                c.setId(rs.getInt("categoryId"));
                c.setName(rs.getString("categoryName"));
                product.setCategory(c);

                double avg = rs.getDouble("avgStar");
                product.setAverageStar(avg);

                cart.setProduct(product);
                list.add(cart);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addOrUpdateCartItem(int customerId, int productId, int quantity) {
        try {

            String checkProductSql = "SELECT quantity FROM Products WHERE productId = ?";
            Object[] checkProductParams = {productId};
            try ( ResultSet productRs = execSelectQuery(checkProductSql, checkProductParams)) {
                if (!productRs.next()) {
                    System.out.println("Product not found: " + productId);
                    return false;
                }
                int availableQuantity = productRs.getInt("quantity");
                if (availableQuantity <= 0) {
                    System.out.println("Product out of stock: " + productId);
                    return false;
                }
            }

            String checkSql = "SELECT cartId, cartQuantity FROM Carts WHERE customerId = ? AND productId = ?";
            Object[] checkParams = {customerId, productId};
            try ( ResultSet rs = execSelectQuery(checkSql, checkParams)) {
                if (rs.next()) {

                    int currentQuantity = rs.getInt("cartQuantity");
                    int newQuantity = currentQuantity + quantity;
                    String updateSql = "UPDATE Carts SET cartQuantity = ? WHERE customerId = ? AND productId = ?";
                    Object[] updateParams = {newQuantity, customerId, productId};
                    int result = execQuery(updateSql, updateParams);
                    System.out.println("Updated cart item, rows affected: " + result);
                    return result > 0;
                } else {

                    String insertSql = "INSERT INTO Carts (customerId, productId, cartQuantity) VALUES (?, ?, ?)";
                    Object[] insertParams = {customerId, productId, quantity};
                    int result = execQuery(insertSql, insertParams);
                    System.out.println("Inserted new cart item, rows affected: " + result);
                    return result > 0;
                }
            }
        } catch (Exception e) {
            System.out.println("Error in addOrUpdateCartItem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCartItemQuantity(int cartId, int quantity) {
        try {
            String sql = "UPDATE Carts SET cartQuantity = ? WHERE cartId = ?";
            Object[] params = {quantity, cartId};

            return execQuery(sql, params) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeCartItem(int cartId) {
        try {
            String sql = "DELETE FROM Carts WHERE cartId = ?";
            Object[] params = {cartId};

            return execQuery(sql, params) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getRelatedProducts(int excludeProductId, int brandId, int categoryId) {
        List<Product> list = new ArrayList<>();

        String sql
                = "SELECT p.productId, p.productTitle, p.productPrice, p.productQuantity, "
                + "       pi.url AS imageUrl "
                + "FROM Products p "
                + "  JOIN ( "
                + "    SELECT productId, url "
                + "    FROM ( "
                + "      SELECT productId, url, "
                + "             ROW_NUMBER() OVER (PARTITION BY productId ORDER BY imageId) AS rn "
                + "      FROM ProductImages "
                + "    ) t WHERE rn = 1 "
                + "  ) pi ON pi.productId = p.productId "
                + "WHERE p.productId <> ? "
                + "  AND (p.brandId = ? OR p.categoryId = ?) "
                + "ORDER BY p.productId DESC";

        Object[] params = {
            excludeProductId,
            brandId,
            categoryId
        };

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Product prod = new Product();
                prod.setProductId(rs.getInt("productId"));
                prod.setTitle(rs.getString("productTitle"));
                prod.setPrice(rs.getDouble("productPrice"));
                prod.setQuantity(rs.getInt("productQuantity"));

                List<String> urls = new ArrayList<>();
                String imgUrl = rs.getString("imageUrl");
                if (imgUrl != null && !imgUrl.isEmpty()) {
                    urls.add(imgUrl);
                }
                prod.setUrls(urls);

                list.add(prod);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertCartItem(int customerId, int productId, int quantity) {
        String sql = "INSERT INTO Carts (customerId, productId, cartQuantity) VALUES (?, ?, ?)";
        Object[] params = {customerId, productId, quantity};
        try {
            int rows = execQuery(sql, params);
            System.out.println("DEBUG insertCartItem → rows inserted: " + rows);
            return rows > 0;
        } catch (Exception e) {
            System.out.println("Error in insertCartItem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalQuantity(int customerId) {
        String sql = "SELECT COUNT(*) FROM Carts"
                + " WHERE customerId = ?";
        Object[] params = {customerId};
        try (
                 ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                int total = rs.getInt(1);
                System.out.println("DEBUG getTotalQuantity → total: " + total);
                return total;
            }
        } catch (Exception e) {
            System.out.println("Error in getTotalQuantity: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public boolean existsCartItem(int customerId, int productId) {
        String sql = "SELECT 1 FROM Carts WHERE customerId = ? AND productId = ?";
        Object[] params = {customerId, productId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Cart getCartItemById(int cartId) {
        Cart cart = null;
        String sql
                = "SELECT c.cartId, c.cartQuantity, c.customerId, c.productId, "
                + "       p.productTitle, p.productPrice, p.productQuantity, "
                + "       p.brandId, p.categoryId, "
                + "       (SELECT TOP 1 url "
                + "          FROM ProductImages "
                + "         WHERE productId = p.productId) AS imageUrl "
                + "  FROM Carts c "
                + "  JOIN Products p ON c.productId = p.productId "
                + " WHERE c.cartId = ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cart = new Cart();
                    cart.setCartId(rs.getInt("cartId"));
                    cart.setQuantity(rs.getInt("cartQuantity"));
                    cart.setCustomerId(rs.getInt("customerId"));

                    Product product = new Product();
                    product.setProductId(rs.getInt("productId"));
                    product.setTitle(rs.getString("productTitle"));
                    product.setPrice(rs.getDouble("productPrice"));
                    product.setQuantity(rs.getInt("productQuantity"));

                    // brand & category
                    Brand brand = new Brand();
                    brand.setId(rs.getInt("brandId"));
                    product.setBrand(brand);

                    Category category = new Category();
                    category.setId(rs.getInt("categoryId"));
                    product.setCategory(category);

                    // lấy imageUrl vào List<String>
                    List<String> urls = new ArrayList<>();
                    String imageUrl = rs.getString("imageUrl");
                    if (imageUrl != null && !imageUrl.isEmpty()) {
                        urls.add(imageUrl);
                    }
                    product.setUrls(urls);

                    cart.setProduct(product);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return cart;
    }

    public Address getDefaultAddressByCustomerId(int customerId) {
        String sql = "SELECT TOP 1 addressId, addressName, recipientName, addressDetails, addressPhone, isDefault, customerId "
                + "FROM Address WHERE customerId = ? AND isDefault = 1";
        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                Address addr = new Address();
                addr.setId(rs.getInt("addressId"));
                addr.setName(rs.getString("addressName"));
                addr.setRecipientName(rs.getString("recipientName"));
                addr.setDetails(rs.getString("addressDetails"));
                addr.setPhone(rs.getString("addressPhone"));
                addr.setIsDefault(rs.getBoolean("isDefault"));
                addr.setCustomerId(rs.getInt("customerId"));

                // Tạo fullAddress nếu chưa có sẵn
                String fullAddr = addr.getName() + ", " + addr.getDetails();
                addr.setFullAddress(fullAddr);

                return addr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Cart> getCartItemById(List<Integer> cartIds) {
        List<Cart> carts = new ArrayList<>();
        if (cartIds == null || cartIds.isEmpty()) {
            return carts;
        }

        // 1) Xây placeholder
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cartIds.size(); i++) {
            sb.append("?");
            if (i < cartIds.size() - 1) {
                sb.append(", ");
            }
        }
        String placeholders = sb.toString();

        // 2) SQL với sub-query lấy TOP 1 url
        String sql
                = "SELECT c.cartId, c.cartQuantity, c.customerId, c.productId,  "
                + "       p.productTitle, p.productPrice, p.productQuantity,    "
                + "       (SELECT TOP 1 url                                "
                + "          FROM ProductImages                            "
                + "         WHERE productId = p.productId) AS imageUrl     "
                + "  FROM Carts c                                          "
                + "  JOIN Products p ON c.productId = p.productId           "
                + " WHERE c.cartId IN (" + placeholders + ")";

        // 3) Chuyển List<Integer> thành mảng Object[] để truyền cho execSelectQuery
        Object[] params = cartIds.toArray(new Object[0]);

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cartId"));
                cart.setQuantity(rs.getInt("cartQuantity"));
                cart.setCustomerId(rs.getInt("customerId"));

                Product prod = new Product();
                prod.setProductId(rs.getInt("productId"));
                prod.setTitle(rs.getString("productTitle"));
                prod.setPrice(rs.getDouble("productPrice"));
                prod.setQuantity(rs.getInt("productQuantity"));

                List<String> urls = new ArrayList<>();
                String imageUrl = rs.getString("imageUrl");
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    urls.add(imageUrl);
                }
                prod.setUrls(urls);

                cart.setProduct(prod);
                carts.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return carts;
    }

    ////
    /**
     * Kiểm tra xem customer đã có default address chưa
     */
    public boolean hasDefaultAddress(int customerId) throws SQLException {
        String sql = "SELECT 1 FROM Address WHERE customerId = ? AND isDefault = 1";
        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            return rs.next();
        }
    }

    public boolean updateDefaultAddress(int customerId,
            String details,
            String name,
            String phone,
            String recipient) throws SQLException {
        String sql = "UPDATE Address "
                + "SET addressDetails = ?, addressName = ?, addressPhone = ?, recipientName = ? "
                + "WHERE customerId = ? AND isDefault = 1";
        Object[] params = {details, name, phone, recipient, customerId};
        int rows = execQuery(sql, params);
        System.out.println("DEBUG updateDefaultAddress rows affected: " + rows);
        return rows > 0;
    }

    public boolean insertDefaultAddress(int customerId,
            String details,
            String name,
            String phone,
            String recipient) throws SQLException {
        String sql = "INSERT INTO Address "
                + "(addressDetails, addressName, addressPhone, recipientName, customerId, isDefault) "
                + "VALUES (?, ?, ?, ?, ?, 1)";
        Object[] params = {details, name, phone, recipient, customerId};
        int rows = execQuery(sql, params);
        System.out.println("DEBUG insertDefaultAddress rows affected: " + rows);
        return rows > 0;
    }

    /**
     * Cập nhật hoặc chèn default Address từ form
     */
    public boolean updateCustomerInfo(int customerId,
            String addressName,
            String recipientName,
            String phone,
            String details) {
        try {
            if (!hasDefaultAddress(customerId)) {
                return insertDefaultAddress(customerId, details, addressName, phone, recipientName);
            } else {
                return updateDefaultAddress(customerId, details, addressName, phone, recipientName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tính subtotal từ JSON của cartIds
     */
    public double calculateSubtotalFromJson(String cartIdsJson) {
        Gson gson = new Gson();
        Type listType = new TypeToken<List<Integer>>() {
        }.getType();
        List<Integer> ids = gson.fromJson(cartIdsJson, listType);
        double subtotal = 0;
        for (Integer cartId : ids) {
            Cart c = getCartItemById(cartId);
            if (c != null && c.getProduct() != null) {
                subtotal += c.getQuantity() * c.getProduct().getPrice();
            }
        }
        return subtotal;
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

    public boolean createOrderFromCart(String cartIdsJson, int customerId, String voucherIdStr) throws Exception {
        Connection conn = null;
        PreparedStatement psOrder = null, psOrderDetail = null, psUpdateProduct = null, psRemoveCart = null;
        ResultSet rs = null;
        boolean success = false;
        try {
            // Kiểm tra cartIdsJson
            if (cartIdsJson == null || cartIdsJson.trim().isEmpty() || cartIdsJson.equals("[]")) {
                throw new Exception("CartIds is empty, nothing to order.");
            }

            // Parse cartIds using Gson (same as in your servlet)
            List<Integer> cartIds = new ArrayList<>();
            try {
                Gson gson = new Gson();
                Type listType = new TypeToken<List<Integer>>() {
                }.getType();
                cartIds = gson.fromJson(cartIdsJson, listType);
            } catch (Exception ex) {
                throw new Exception("Invalid cart data format: " + ex.getMessage());
            }

            if (cartIds == null || cartIds.isEmpty()) {
                throw new Exception("No valid cart item id to process.");
            }

            // Lấy các mục cart theo id
            List<Cart> selectedCarts = getCartItemById(cartIds);
            if (selectedCarts == null || selectedCarts.isEmpty()) {
                throw new Exception("Could not find cart items for selected cart ids.");
            }

            // Tổng tiền
            double subtotal = 0;
            for (Cart cart : selectedCarts) {
                subtotal += cart.getQuantity() * cart.getProduct().getPrice();
            }

            double discount = 0;
            Integer voucherId = null;
            if (voucherIdStr != null && !voucherIdStr.isEmpty()) {
                voucherId = Integer.parseInt(voucherIdStr);
                Voucher voucher = getVoucherById(voucherId);
                if (voucher != null) {
                    if ("percentage".equalsIgnoreCase(voucher.getType())) {
                        discount = subtotal * (voucher.getValue() / 100.0);
                        if (voucher.getMaxValue() > 0 && discount > voucher.getMaxValue()) {
                            discount = voucher.getMaxValue();
                        }
                    } else {
                        discount = voucher.getValue();
                    }
                } else {
                    throw new Exception("Voucher not found.");
                }
            }
            double totalAmount = subtotal - discount;
            if (totalAmount < 0) {
                totalAmount = 0;
            }

            // Lấy địa chỉ mặc định
            Address address = getDefaultAddressByCustomerId(customerId);
            if (address == null) {
                throw new Exception("No default delivery address for customer. Please add/select an address.");
            }

            // Kiểm tra tồn kho từng sản phẩm trước khi bắt đầu transaction
            for (Cart cart : selectedCarts) {
                int stock = cart.getProduct().getQuantity();
                if (cart.getQuantity() > stock) {
                    throw new Exception("Not enough stock for product: " + cart.getProduct().getTitle());
                }
            }

            int paymentMethodId = 1;   // 1: COD
            int paymentStatusId = 1;   // 1: Chưa thanh toán
            int statusId = 1;          // 1: Chờ xác nhận
            double shippingFee = 0;

            conn = getConnection();
            conn.setAutoCommit(false);

            // 1. Tạo đơn hàng mới
            String sqlOrder = "INSERT INTO Orders (employeeId, customerId, totalAmount, shippingFee, paymentMethodId, paymentStatusId, statusId, voucherId, addressId, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setNull(1, Types.INTEGER); // Không có employeeId tại thời điểm này
            psOrder.setInt(2, customerId);
            psOrder.setBigDecimal(3, BigDecimal.valueOf(totalAmount));
            psOrder.setBigDecimal(4, BigDecimal.valueOf(shippingFee));
            psOrder.setInt(5, paymentMethodId);
            psOrder.setInt(6, paymentStatusId);
            psOrder.setInt(7, statusId);
            if (voucherId != null) {
                psOrder.setInt(8, voucherId);
            } else {
                psOrder.setNull(8, Types.INTEGER);
            }
            psOrder.setInt(9, address.getId());
            psOrder.executeUpdate();

            rs = psOrder.getGeneratedKeys();
            int orderId = -1;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            if (orderId == -1) {
                throw new SQLException("Cannot get orderId after insert.");
            }

            // 2. Tạo OrderDetails và giảm tồn kho
            String sqlDetail = "INSERT INTO OrderDetails (orderId, productId, quantity, price, createdAt, updatedAt) VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";
            String sqlUpdateProduct = "UPDATE Products SET productQuantity = productQuantity - ? WHERE productId = ? AND productQuantity >= ?";
            psOrderDetail = conn.prepareStatement(sqlDetail);
            psUpdateProduct = conn.prepareStatement(sqlUpdateProduct);

            for (Cart cart : selectedCarts) {
                int productId = cart.getProduct().getProductId();
                int qty = cart.getQuantity();
                double price = cart.getProduct().getPrice();

                // Giảm tồn kho trước (kiểm tra đủ hàng)
                psUpdateProduct.setInt(1, qty);
                psUpdateProduct.setInt(2, productId);
                psUpdateProduct.setInt(3, qty);
                int affected = psUpdateProduct.executeUpdate();
                if (affected == 0) {
                    throw new SQLException("Insufficient stock for productId: " + productId + " (" + cart.getProduct().getTitle() + ")");
                }

                // Ghi order detail
                psOrderDetail.setInt(1, orderId);
                psOrderDetail.setInt(2, productId);
                psOrderDetail.setInt(3, qty);
                psOrderDetail.setBigDecimal(4, BigDecimal.valueOf(price));
                psOrderDetail.addBatch();
            }
            psOrderDetail.executeBatch();

            // 3. Xóa các mục trong Cart đã mua
            String sqlRemove = "DELETE FROM Cart WHERE id = ?";
            psRemoveCart = conn.prepareStatement(sqlRemove);
            for (Cart cart : selectedCarts) {
                psRemoveCart.setInt(1, cart.getCartId());
                psRemoveCart.addBatch();
            }
            psRemoveCart.executeBatch();

            conn.commit();
            success = true;

        } catch (Exception ex) {
            ex.printStackTrace();
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ignore) {
            }
            throw ex; // Ném ra ngoài để servlet bắt và trả về message cụ thể
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psOrderDetail != null) {
                    psOrderDetail.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psUpdateProduct != null) {
                    psUpdateProduct.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psRemoveCart != null) {
                    psRemoveCart.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (Exception ignore) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignore) {
            }
        }
        return success;
    }

    public boolean removeCartItems(List<Integer> cartIds) {
        if (cartIds == null || cartIds.isEmpty()) {
            return false;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < cartIds.size(); i++) {
            placeholders.append("?");
            if (i < cartIds.size() - 1) {
                placeholders.append(",");
            }
        }
        String sql = "DELETE FROM Carts WHERE cartId IN (" + placeholders.toString() + ")";

        try {
            Object[] params = cartIds.toArray();
            return execQuery(sql, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
