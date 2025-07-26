package DAOs;

import Models.Address;
import Models.Brand;
import Models.Cart;
import Models.Category;
import Models.Product;
import Models.Voucher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CartDAO extends DB.DBContext {

    public int getCountQuantityByCustomerAndProduct(int customerId, int productId) {
        int totalQuantity = 0;
        String sql = "SELECT SUM(cartQuantity) FROM Carts WHERE customerId = ? AND productId = ?";
        Object[] params = new Object[]{customerId, productId};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                totalQuantity = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalQuantity;
    }

    public boolean updateCartQuantityByCustomerAndProduct(int customerId, int productId, int newQuantity) {
        String sql = "UPDATE Carts SET cartQuantity = ? WHERE customerId = ? AND productId = ?";
        Object[] params = new Object[]{newQuantity, customerId, productId};

        try {
            int rowEffect = execQuery(sql, params);
            if (rowEffect > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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

                Product product = new Product();
                product.setProductId(rs.getInt("productId"));
                product.setTitle(rs.getString("productTitle"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));

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

    public boolean updateCartItemQuantity(int cartId, int quantity) {
        String sql
                = "UPDATE Carts "
                + "SET cartQuantity = ? "
                + "WHERE cartId = ? "
                + "AND ? <= (SELECT p.productQuantity "
                + "          FROM Products p JOIN Carts c2 ON p.productId = c2.productId "
                + "          WHERE c2.cartId = ?)";
        try {
            Object[] params = {quantity, cartId, quantity, cartId};
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

                    Brand brand = new Brand();
                    brand.setId(rs.getInt("brandId"));
                    product.setBrand(brand);

                    Category category = new Category();
                    category.setId(rs.getInt("categoryId"));
                    product.setCategory(category);

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

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cartIds.size(); i++) {
            sb.append("?");
            if (i < cartIds.size() - 1) {
                sb.append(", ");
            }
        }
        String placeholders = sb.toString();

        String sql
                = "SELECT c.cartId, c.cartQuantity, c.customerId, c.productId,  "
                + "       p.productTitle, p.productPrice, p.productQuantity,    "
                + "       (SELECT TOP 1 url                                "
                + "          FROM ProductImages                            "
                + "         WHERE productId = p.productId) AS imageUrl     "
                + "  FROM Carts c                                          "
                + "  JOIN Products p ON c.productId = p.productId           "
                + " WHERE c.cartId IN (" + placeholders + ")";

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

    public boolean hasDefaultAddress(int customerId) throws SQLException {
        String sql = "SELECT 1 FROM Address WHERE customerId = ? AND isDefault = 1";
        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            return rs.next();
        }
    }

    public boolean updateDefaultAddress(int customerId, String details, String name, String phone, String recipient) throws SQLException {
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
                        rs.getInt("totalUsageLimit"),
                        rs.getInt("userUsageLimit"),
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
/////////new cart
    public List<Cart> getCartItemsByUserIdPaginated(int customerId, int offset, int limit) {
        List<Cart> list = new ArrayList<>();
        String sql
                = "SELECT c.cartId, c.customerId, c.cartQuantity,  "
                + "       p.productId, p.productTitle, p.productPrice, p.productQuantity,  "
                + "       pi.imageUrl, ISNULL(r.avgStar,0) AS avgStar,  "
                + "       b.brandId, b.brandName,  "
                + "       cat.categoryId, cat.categoryName  "
                + "FROM Carts c  "
                + "JOIN Products p ON c.productId = p.productId  "
                + "LEFT JOIN (  "
                + "    SELECT productId, url AS imageUrl  "
                + "    FROM ProductImages  "
                + "    WHERE imageId IN (SELECT MIN(imageId) FROM ProductImages GROUP BY productId)  "
                + ") pi ON p.productId = pi.productId  "
                + "LEFT JOIN (  "
                + "    SELECT productId, AVG(CAST(star AS FLOAT)) AS avgStar  "
                + "    FROM Reviews  "
                + "    GROUP BY productId  "
                + ") r ON p.productId = r.productId  "
                + "LEFT JOIN Brands b    ON p.brandId    = b.brandId  "
                + "LEFT JOIN Categories cat ON p.categoryId = cat.categoryId  "
                + "WHERE c.customerId = ?  "
                + "ORDER BY c.cartId DESC  "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";

        Object[] params = {customerId, offset, limit};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("cartId"));
                cart.setCustomerId(rs.getInt("customerId"));
                cart.setQuantity(rs.getInt("cartQuantity"));

                Product p = new Product();
                p.setProductId(rs.getInt("productId"));
                p.setTitle(rs.getString("productTitle"));
                p.setPrice(rs.getDouble("productPrice"));
                p.setQuantity(rs.getInt("productQuantity"));
                p.setAverageStar(rs.getDouble("avgStar"));

                String img = rs.getString("imageUrl");
                List<String> urls = (List<String>) ((img != null && !img.isEmpty())
                        ? Collections.singletonList(img)
                        : Collections.emptyList());
                p.setUrls(urls);

                Brand b = new Brand();
                b.setId(rs.getInt("brandId"));
                b.setName(rs.getString("brandName"));
                p.setBrand(b);

                Category cat = new Category();
                cat.setId(rs.getInt("categoryId"));
                cat.setName(rs.getString("categoryName"));
                p.setCategory(cat);

                cart.setProduct(p);
                list.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countCartItems(int customerId) {
        String sql = "SELECT COUNT(*) FROM Carts WHERE customerId = ?";
        Object[] params = {customerId};
        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}
