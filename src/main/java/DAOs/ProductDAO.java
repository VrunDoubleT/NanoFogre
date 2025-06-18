package DAOs;

import Models.Brand;
import Models.Category;
import Models.Product;
import Models.ProductImage;
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
        String query = "select COUNT(p.productId) as total \n"
                + "from Products p\n"
                + "left join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "left join Brands b\n"
                + "on p.brandId = b.brandId\n";
        if (categoryId > 0) {
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
                + "left join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "left join Brands b\n"
                + "on p.brandId = b.brandId\n";
        if (categoryId > 0) {
            query += "where p.categoryId = " + categoryId + "\n";
        }
        query += "ORDER BY p.productId desc\n"
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
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
                Object brandIdObj = rs.getObject("brandId");
                if (brandIdObj != null) {
                    int brandId = (int) brandIdObj;
                    String brandName = rs.getString("brandName");
                    product.setBrand(new Brand(brandId, brandName, null));
                } else {
                    product.setBrand(null);
                }
                Object categoryIdObj = rs.getObject("categoryId");
                if (categoryIdObj != null) {
                    int categoryIdRs = (int) categoryIdObj;
                    String categoryName = rs.getString("categoryName");
                    product.setCategory(new Category(categoryIdRs, categoryName));
                } else {
                    product.setCategory(null);
                }
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

    public List<ProductImage> getProductImagesByProductId(int productId) {
        List<ProductImage> images = new ArrayList<>();
        String query = "SELECT imageId, url FROM ProductImages WHERE productId = ?";
        Object[] params = {productId};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                int imageId = rs.getInt("imageId");
                String url = rs.getString("url");
                images.add(new ProductImage(imageId, url));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return images;
    }

    public Product getProductById(int id) {
        Product product = new Product();
        String query = "select p.*, c.categoryName, b.brandName\n"
                + "from Products p\n"
                + "left join Categories c\n"
                + "on p.categoryId = c.categoryId\n"
                + "left join Brands b\n"
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
                Object brandIdObj = rs.getObject("brandId");
                if (brandIdObj != null) {
                    int brandId = (int) brandIdObj;
                    String brandName = rs.getString("brandName");
                    product.setBrand(new Brand(brandId, brandName, null));
                } else {
                    product.setBrand(null);
                }
                Object categoryIdObj = rs.getObject("categoryId");
                if (categoryIdObj != null) {
                    int categoryIdRs = (int) categoryIdObj;
                    String categoryName = rs.getString("categoryName");
                    product.setCategory(new Category(categoryIdRs, categoryName));
                } else {
                    product.setCategory(null);
                }
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

        try ( ResultSet rs = execSelectQuery(sql)) {

            if (rs.next()) {
                stat.setTotalProducts(rs.getInt("total"));
                stat.setInventory(rs.getInt("inventory"));
                stat.setInventoryValue(rs.getDouble("inventoryValue"));
                stat.setOutOfStockProducts(rs.getInt("outProducts"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println(stat);
        return stat;
    }

    public void deleteUnusedProductImages(int productId, String[] imageIds) {
        if (imageIds == null || imageIds.length == 0) {
            String deleteAllSql = "DELETE FROM ProductImages WHERE productId = ?";
            try {
                Object[] params = {productId};
                execQuery(deleteAllSql, params);
            } catch (SQLException ex) {
                System.out.println("Error deleting all images: " + ex);
            }
        } else {
            String placeholders = String.join(",", Collections.nCopies(imageIds.length, "?"));
            String deleteSql = "DELETE FROM ProductImages WHERE productId = ? AND imageId NOT IN (" + placeholders + ")";
            try {
                Object[] params = new Object[1 + imageIds.length];
                params[0] = productId;
                for (int i = 0; i < imageIds.length; i++) {
                    params[i + 1] = Integer.parseInt(imageIds[i]);
                }
                execQuery(deleteSql, params);
            } catch (SQLException ex) {
                System.out.println("Error deleting unused images: " + ex);
            } catch (NumberFormatException ex) {
                System.out.println("Invalid imageId in list: " + ex);
            }
        }
    }

    public boolean createProduct(Product product) {
        String sql = "INSERT INTO Products (\n"
                + "    productTitle, productDescription, scale, material, slug, productPrice, productQuantity,\n"
                + "    paint, features, manufacturer, length, width, height, weight,\n"
                + "    _destroy, categoryId, brandId\n"
                + ")\n"
                + "VALUES (\n"
                + "    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?\n"
                + ")";
        String sqlUrls = "INSERT INTO ProductImages (productId, url) VALUES\n";
        Object categoryIdConvert = product.getCategory().getId() == 0 ? null : product.getCategory().getId();
        Object brandIdConvert = product.getBrand().getId() == 0 ? null : product.getBrand().getId();
        Object[] paramsObj = {
            product.getTitle(),
            product.getDescription(),
            product.getScale(),
            product.getMaterial(),
            product.getSlug(),
            product.getPrice(),
            product.getQuantity(),
            product.getPaint(),
            product.getFeatures(),
            product.getManufacturer(),
            product.getLength(),
            product.getWidth(),
            product.getHeight(),
            product.getWeight(),
            product.isDestroy(),
            categoryIdConvert,
            brandIdConvert
        };

        try {
            int generateId = execQueryReturnId(sql, paramsObj);
            if (generateId > 0) {
                if (product.getUrls().size() > 0) {
                    for (int i = 0; i < product.getUrls().size(); i++) {
                        sqlUrls += String.format("(%d, N'%s')", generateId, product.getUrls().get(i));
                        if (i < product.getUrls().size() - 1) {
                            sqlUrls += ",";
                        }
                    }
                    int rowEffect = execQuery(sqlUrls);
                    if (rowEffect > 0) {
                        return true;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET\n"
                + "    productTitle = ?,\n"
                + "    productDescription = ?,\n"
                + "    scale = ?,\n"
                + "    material = ?,\n"
                + "    slug = ?,\n"
                + "    productPrice = ?,\n"
                + "    productQuantity = ?,\n"
                + "    paint = ?,\n"
                + "    features = ?,\n"
                + "    manufacturer = ?,\n"
                + "    length = ?,\n"
                + "    width = ?,\n"
                + "    height = ?,\n"
                + "    weight = ?,\n"
                + "    _destroy = ?,\n"
                + "    categoryId = ?,\n"
                + "    brandId = ?\n"
                + "WHERE productId = ?";

        String sqlInsertImage = "INSERT INTO ProductImages (productId, url) VALUES (?, ?)";
        Object categoryIdConvert = product.getCategory().getId() == 0 ? null : product.getCategory().getId();
        Object brandIdConvert = product.getBrand().getId() == 0 ? null : product.getBrand().getId();
        Object[] paramsObj = {
            product.getTitle(),
            product.getDescription(),
            product.getScale(),
            product.getMaterial(),
            product.getSlug(),
            product.getPrice(),
            product.getQuantity(),
            product.getPaint(),
            product.getFeatures(),
            product.getManufacturer(),
            product.getLength(),
            product.getWidth(),
            product.getHeight(),
            product.getWeight(),
            product.isDestroy(),
            categoryIdConvert,
            brandIdConvert,
            product.getProductId()
        };

        try {
            int rowEffect = execQuery(sql, paramsObj);
            if (rowEffect == 0) {
                System.out.println("No product updated with ID: " + product.getProductId());
                return false;
            }

            if (product.getUrls() != null && !product.getUrls().isEmpty()) {
                for (String url : product.getUrls()) {
                    Object[] imageParams = {product.getProductId(), url};
                    System.out.println("Inserting: " + url + " with productId: " + product.getProductId());
                    int row = execQuery(sqlInsertImage, imageParams);
                    System.out.println("Row affected: " + row);
                }
            }
            return true;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean hideProduct(int productId) {
        String sql = "UPDATE Products SET _destroy = 1 WHERE productId = ?";
        Object[] paramsObj = {productId};

        try {
            int rf = execQuery(sql, paramsObj);
            return rf > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean enableProduct(int productId) {
        String sql = "UPDATE Products SET _destroy = 0 WHERE productId = ?";
        Object[] paramsObj = {productId};

        try {
            int rf = execQuery(sql, paramsObj);
            return rf > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

}
