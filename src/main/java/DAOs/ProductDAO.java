package DAOs;

import Models.Brand;
import Models.Category;
import Models.Product;
import Models.ProductStat;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class ProductDAO extends DB.DBContext {
    public int getTotalPagination(int categoryId) {
        int limit = 10;
        String query = "select COUNT(p.productId) as total \n"
                + "from Products p\n"
                + "join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "join Brands b\n"
                + "on p.brandId = b.brandId\n";
        if(categoryId > 0){
            query += "where p.categoryId = " + categoryId + "\n";
        }
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    public List<Product> products(int categoryId, int page, int limit) {
        int row = (page - 1) * limit;
        List<Product> pros = new ArrayList<>();
        String query = "select p.*, c.categoryName, b.brandName\n"
                + "from Products p\n"
                + "join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "join Brands b\n"
                + "on p.brandId = b.brandId\n";
        if(categoryId > 0){
            query += "where p.categoryId = " + categoryId + "\n";
        }
        query += "ORDER BY p.productId\n" +
                "OFFSET " + row + " ROWS FETCH NEXT " + limit +" ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Product product = new Product();
                int productId = rs.getInt("productId");
                product.setProductId(productId);
                product.setTitle(rs.getString("productTitle"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("productDescription"));
                product.setScale(rs.getString("scale"));
                product.setMaterial(rs.getString("material"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));
                product.setPaint(rs.getString("paint"));
                product.setFeatures(rs.getString("features"));
                product.setManufacturer(rs.getString("manufacturer"));
                product.setLength(rs.getDouble("length"));
                product.setWidth(rs.getDouble("width"));
                product.setHeight(rs.getDouble("height"));
                product.setWeight(rs.getDouble("length"));
                product.setDestroy(rs.getBoolean("_destroy"));
                product.setBrand(new Brand(rs.getInt("brandId"), rs.getString("categoryName"), null));
                product.setCategory(new Category(rs.getInt("categoryId"), rs.getString("brandName")));
                Object[] params = {productId};
                ResultSet urlsResult = execSelectQuery("select * from ProductImages pi where pi.productId = ?", params);
                List<String> urls = new ArrayList<>();
                while (urlsResult.next()) {
                    urls.add(urlsResult.getString("url"));
                }
                product.setUrls(urls);
                pros.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pros;
    }

    public Product getProductById(int id) {
        Product product = new Product();
        String query = "select p.*, c.categoryName, b.brandName\n"
                + "from Products p\n"
                + "join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "join Brands b\n"
                + "on p.brandId = b.brandId\n"
                + "where p.productId = ?";
        Object[] obj = {id};
        try ( ResultSet rs = execSelectQuery(query, obj)) {
            while (rs.next()) {
                int productId = rs.getInt("productId");
                product.setProductId(productId);
                product.setTitle(rs.getString("productTitle"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("productDescription"));
                product.setScale(rs.getString("scale"));
                product.setMaterial(rs.getString("material"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));
                product.setPaint(rs.getString("paint"));
                product.setFeatures(rs.getString("features"));
                product.setManufacturer(rs.getString("manufacturer"));
                product.setLength(rs.getDouble("length"));
                product.setWidth(rs.getDouble("width"));
                product.setHeight(rs.getDouble("height"));
                product.setWeight(rs.getDouble("length"));
                product.setDestroy(rs.getBoolean("_destroy"));
                product.setBrand(new Brand(rs.getInt("brandId"), rs.getString("categoryName"), null));
                product.setCategory(new Category(rs.getInt("categoryId"), rs.getString("brandName")));
                Object[] params = {productId};
                ResultSet urlsResult = execSelectQuery("select * from ProductImages pi where pi.productId = ?", params);
                List<String> urls = new ArrayList<>();
                while (urlsResult.next()) {
                    urls.add(urlsResult.getString("url"));
                }
                product.setUrls(urls);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    public ProductStat getProductStat() {
        ProductStat stat = new ProductStat();
        String sql = "select COUNT(p.productId) as total, SUM(p.productQuantity) as inventory, SUM((p.productQuantity * p.productPrice)) as inventoryValue, SUM(CASE WHEN p.productQuantity = 0 THEN 1 ELSE 0 END) AS outProducts from Products p";

        try (ResultSet rs = execSelectQuery(sql)) {

            if (rs.next()) {
                stat.setTotalProducts(rs.getInt("total"));
                stat.setInventory(rs.getInt("inventory"));
                stat.setInventoryValue(rs.getDouble("inventoryValue"));
                stat.setOutOfStockProducts(rs.getInt("outProducts"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stat;
    }

}
