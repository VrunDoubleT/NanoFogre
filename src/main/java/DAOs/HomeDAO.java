package DAOs;

import DB.DBContext;
import Models.Brand;
import Models.Category;
import Models.Product;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class HomeDAO extends DBContext {

    public List<Product> getTopRatedProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT TOP (?) p.*, AVG(CAST(r.star AS FLOAT)) AS avgStar\n"
                + "        FROM Products p\n"
                + "        JOIN Reviews r ON p.productId = r.productId\n"
                + "        WHERE p._destroy = 0 AND p.isActive = 1\n"
                + "        GROUP BY p.productId, p.productTitle, p.productDescription, p.material, p.slug, p.productPrice,\n"
                + "                 p.productQuantity, p.isActive, p._destroy, p.categoryId, p.brandId, p.createdAt, p.updatedAt\n"
                + "        ORDER BY avgStar DESC";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{limit})) {
            while (rs.next()) {
                Product p = extractProductFromResultSet(rs);
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getTopSellingProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT TOP (?) p.*, SUM(od.detailQuantity) AS totalSold\n" +
"        FROM Products p\n" +
"        JOIN OrderDetails od ON p.productId = od.productId\n" +
"        JOIN Orders o ON od.orderId = o.orderId\n" +
"        WHERE p._destroy = 0 AND p.isActive = 1\n" +
"        GROUP BY p.productId, p.productTitle, p.productDescription, p.material, p.slug, p.productPrice,\n" +
"                 p.productQuantity, p.isActive, p._destroy, p.categoryId, p.brandId, p.createdAt, p.updatedAt\n" +
"        ORDER BY totalSold DESC";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{limit})) {
            while (rs.next()) {
                Product p = extractProductFromResultSet(rs);
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getNewestProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT TOP (?) * FROM Products\n" +
"        WHERE _destroy = 0 AND isActive = 1\n" +
"        ORDER BY createdAt DESC";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{limit})) {
            while (rs.next()) {
                Product p = extractProductFromResultSet(rs);
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product product = new Product();
        int productId = rs.getInt("productId");
        product.setProductId(productId);
        product.setTitle(rs.getString("productTitle"));
        product.setSlug(rs.getString("slug"));
        product.setDescription(rs.getString("productDescription"));
        product.setMaterial(rs.getString("material"));
        product.setPrice(rs.getDouble("productPrice"));
        product.setQuantity(rs.getInt("productQuantity"));
        product.setIsActive(rs.getBoolean("isActive"));
        product.setDestroy(rs.getBoolean("_destroy"));

        int brandId = rs.getInt("brandId");
        int categoryId = rs.getInt("categoryId");
        product.setBrand(new Brand(brandId, "Brand", null)); // Set thêm tên nếu JOIN Brands
        product.setCategory(new Category(categoryId, "Category")); // Set thêm tên nếu JOIN Categories

        // Lấy thêm hình ảnh
        ResultSet urlsResult = execSelectQuery("SELECT url FROM ProductImages WHERE productId = ?", new Object[]{productId});
        List<String> urls = new ArrayList<>();
        while (urlsResult.next()) {
            urls.add(urlsResult.getString("url"));
        }
        product.setUrls(urls);

        return product;
    }

}
