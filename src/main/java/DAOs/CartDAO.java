package DAOs;

import DB.DBContext;
import Models.Brand;
import Models.Cart;
import Models.Category;
import Models.Product;
import Models.Review;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CartDAO extends DB.DBContext {

    /**
     * Lấy danh sách sản phẩm trong giỏ hàng của user
     */
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
                + // ảnh đầu tiên
                "LEFT JOIN ( "
                + "    SELECT productId, url AS imageUrl "
                + "    FROM ProductImages "
                + "    WHERE imageId IN (SELECT MIN(imageId) FROM ProductImages GROUP BY productId) "
                + ") pi ON p.productId = pi.productId "
                + // rating trung bình
                "LEFT JOIN ( "
                + "    SELECT productId, AVG(CAST(star AS FLOAT)) AS avgStar "
                + "    FROM Reviews GROUP BY productId "
                + ") r ON p.productId = r.productId "
                + // join Brand và Category
                "LEFT JOIN Brands b ON p.brandId = b.brandId "
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
                product.setBrand(bra);          // ← Thêm dòng này

                Category c = new Category();
                c.setId(rs.getInt("categoryId"));
                c.setName(rs.getString("categoryName"));
                product.setCategory(c);       // ← Thêm dòng này

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

    /**
     * Thêm hoặc cập nhật sản phẩm vào giỏ hàng
     */
    public boolean addOrUpdateCartItem(int customerId, int productId, int quantity) {
        try {
            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            String checkSql = "SELECT cartId, cartQuantity FROM Carts WHERE customerId = ? AND productId = ?";
            Object[] checkParams = {customerId, productId};

            try ( ResultSet rs = execSelectQuery(checkSql, checkParams)) {
                if (rs.next()) {
                    // Sản phẩm đã có, cập nhật số lượng
                    int currentQuantity = rs.getInt("cartQuantity");
                    int newQuantity = currentQuantity + quantity;

                    String updateSql = "UPDATE Carts SET cartQuantity = ? WHERE customerId = ? AND productId = ?";
                    Object[] updateParams = {newQuantity, customerId, productId};

                    return execQuery(updateSql, updateParams) > 0;
                } else {
                    // Sản phẩm chưa có, thêm mới
                    String insertSql = "INSERT INTO Carts (customerId, productId, cartQuantity) VALUES (?, ?, ?)";
                    Object[] insertParams = {customerId, productId, quantity};

                    return execQuery(insertSql, insertParams) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
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

    /**
     * Xóa một sản phẩm khỏi giỏ hàng
     */
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
                + // lấy ảnh đầu tiên mỗi product
                "  JOIN ( "
                + "    SELECT productId, url "
                + "    FROM ( "
                + "      SELECT productId, url, "
                + "             ROW_NUMBER() OVER (PARTITION BY productId ORDER BY imageId) AS rn "
                + "      FROM ProductImages "
                + "    ) t WHERE rn = 1 "
                + "  ) pi ON pi.productId = p.productId "
                + "WHERE p.productId <> ? "
                + // loại trừ chính nó
                "  AND (p.brandId = ? OR p.categoryId = ?) "
                + // filter cùng brand hoặc cùng category
                "ORDER BY p.productId DESC";

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

                // Map image(s)
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
}
