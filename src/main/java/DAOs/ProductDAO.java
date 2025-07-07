package DAOs;

import Models.Brand;
import Models.Category;
import Models.ProductAttribute;
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
import java.util.HashMap;
import java.util.Map;

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
                + "on p.brandId = b.brandId\n"
                + "where p._destroy = 0";
        if (categoryId > 0) {
            query += " AND p.categoryId = " + categoryId + "\n";
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
                + "on p.brandId = b.brandId\n"
                + "where p._destroy = 0";
        if (categoryId > 0) {
            query += " AND p.categoryId = " + categoryId + "\n";
        }
        query += "ORDER BY p.productId \n"
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Product product = new Product();
                int productId = rs.getInt("productId");
                product.setProductId(productId);
                product.setTitle(rs.getString("productTitle"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("productDescription"));
                product.setMaterial(rs.getString("material"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));
                product.setDestroy(rs.getBoolean("_destroy"));
                product.setIsActive(rs.getBoolean("isActive"));
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
                String reviewStatsQuery = "select COUNT(r.reviewId) as totalReivew, AVG(CAST(r.star AS FLOAT)) as averageStar\n"
                        + "from Reviews r\n"
                        + "where r.productId = ?\n"
                        + "group by r.productId";
                ResultSet reviewStatsResult = execSelectQuery(reviewStatsQuery, params);
                if (reviewStatsResult.next()) {
                    product.setTotalReviews(reviewStatsResult.getInt("totalReivew"));
                    product.setAverageStar(reviewStatsResult.getDouble("averageStar"));
                }
                ResultSet soltResult = execSelectQuery("select SUM(od.detailQuantity) as sold\n"
                        + "from OrderDetails od\n"
                        + "where od.productId = ?\n"
                        + "group by od.productId", params);
                if (soltResult.next()) {
                    product.setSold(soltResult.getInt("sold"));
                }
                List<ProductAttribute> pas = getAttributesByProductId(productId);
                product.setAttributes(pas);
                pros.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pros;
    }

    public List<Product> getProductByCategory(int categoryId, List<Integer> brandIds, String sort, int page, int limit) {
        int row = (page - 1) * limit;
        List<Product> pros = new ArrayList<>();

        String query = "SELECT p.*, c.categoryName, b.brandName\n"
                + "FROM Products p\n"
                + "LEFT JOIN Categories c ON p.categoryId = c.categoryId\n"
                + "LEFT JOIN Brands b ON p.brandId = b.brandId\n"
                + "WHERE p._destroy = 0";

        if (categoryId > 0) {
            query += " AND p.categoryId = " + categoryId;
        }

        // Lọc theo brandIds
        if (brandIds != null && !brandIds.isEmpty()) {
            StringBuilder brandFilter = new StringBuilder();
            for (int i = 0; i < brandIds.size(); i++) {
                brandFilter.append(brandIds.get(i));
                if (i < brandIds.size() - 1) {
                    brandFilter.append(",");
                }
            }
            query += " AND p.brandId IN (" + brandFilter.toString() + ")";
        }
        String sortColumn = "p.productId";
        String sortDirection = "ASC";

        if (sort != null && !sort.isEmpty()) {
            if (sort.equals("title")) {
                sortColumn = "p.productTitle";
            } else if (sort.equals("-title")) {
                sortColumn = "p.productTitle";
                sortDirection = "DESC";
            } else if (sort.equals("price")) {
                sortColumn = "p.productPrice";
            } else if (sort.equals("-price")) {
                sortColumn = "p.productPrice";
                sortDirection = "DESC";
            }
        }

        query += "\nORDER BY " + sortColumn + " " + sortDirection;
        query += "\nOFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY;";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Product product = new Product();
                int productId = rs.getInt("productId");
                product.setProductId(productId);
                product.setTitle(rs.getString("productTitle"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getString("productDescription"));
                product.setMaterial(rs.getString("material"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));
                product.setDestroy(rs.getBoolean("_destroy"));
                product.setIsActive(rs.getBoolean("isActive"));
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
                ResultSet urlsResult = execSelectQuery("SELECT * FROM ProductImages WHERE productId = ?", params);
                List<String> urls = new ArrayList<>();
                while (urlsResult.next()) {
                    urls.add(urlsResult.getString("url"));
                }
                product.setUrls(urls);
                String reviewStatsQuery = "SELECT COUNT(r.reviewId) AS totalReivew, AVG(CAST(r.star AS FLOAT)) AS averageStar\n"
                        + "FROM Reviews r WHERE r.productId = ? GROUP BY r.productId";
                ResultSet reviewStatsResult = execSelectQuery(reviewStatsQuery, params);
                if (reviewStatsResult.next()) {
                    product.setTotalReviews(reviewStatsResult.getInt("totalReivew"));
                    product.setAverageStar(reviewStatsResult.getDouble("averageStar"));
                }
                ResultSet soldResult = execSelectQuery("SELECT SUM(od.detailQuantity) AS solt FROM OrderDetails od\n"
                        + "WHERE od.productId = ? GROUP BY od.productId", params);
                if (soldResult.next()) {
                    product.setSold(soldResult.getInt("solt"));
                }
                List<ProductAttribute> pas = getAttributesByProductId(productId);
                product.setAttributes(pas);

                pros.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return pros;
    }

    public int countProductByCategory(int categoryId, List<Integer> brandIds) {
        int total = 0;

        String query = "SELECT COUNT(*) AS total FROM Products p "
                + "WHERE p._destroy = 0";

        if (categoryId > 0) {
            query += " AND p.categoryId = " + categoryId;
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            StringBuilder brandFilter = new StringBuilder();
            for (int i = 0; i < brandIds.size(); i++) {
                brandFilter.append(brandIds.get(i));
                if (i < brandIds.size() - 1) {
                    brandFilter.append(",");
                }
            }
            query += " AND p.brandId IN (" + brandFilter.toString() + ")";
        }

        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
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
            if (rs.next()) {
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
                String reviewStatsQuery = "select COUNT(r.reviewId) as totalReivew, AVG(CAST(r.star AS FLOAT)) as averageStar\n"
                        + "from Reviews r\n"
                        + "where r.productId = ?\n"
                        + "group by r.productId";
                ResultSet reviewStatsResult = execSelectQuery(reviewStatsQuery, params);
                if (reviewStatsResult.next()) {
                    product.setTotalReviews(reviewStatsResult.getInt("totalReivew"));
                    product.setAverageStar(reviewStatsResult.getDouble("averageStar"));
                }
                ResultSet soltResult = execSelectQuery("select SUM(od.detailQuantity) as solt\n"
                        + "from OrderDetails od\n"
                        + "where od.productId = ?\n"
                        + "group by od.productId", params);
                if (soltResult.next()) {
                    product.setSold(soltResult.getInt("solt"));
                }
                List<ProductAttribute> pas = getAttributesByProductId(productId);
                product.setAttributes(pas);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    public ProductStat getProductStat() {
        ProductStat stat = new ProductStat();
        String sql = "select COUNT(p.productId) as total, SUM(p.productQuantity) as inventory, SUM((p.productQuantity * p.productPrice)) as inventoryValue, SUM(CASE WHEN p.productQuantity = 0 THEN 1 ELSE 0 END) AS outProducts from Products p where p._destroy = 0";

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
                + "    productTitle,\n"
                + "    productDescription,\n"
                + "    material,\n"
                + "    slug,\n"
                + "    productPrice,\n"
                + "    productQuantity,\n"
                + "    isActive,\n"
                + "    _destroy,\n"
                + "    categoryId,\n"
                + "    brandId\n"
                + ")\n"
                + "VALUES (?,?,?,?,?,?,?,?,?,?);";
        String sqlUrls = "INSERT INTO ProductImages (productId, url) VALUES\n";
        Object categoryIdConvert = product.getCategory().getId() == 0 ? null : product.getCategory().getId();
        Object brandIdConvert = product.getBrand().getId() == 0 ? null : product.getBrand().getId();
        Object[] paramsObj = {
            product.getTitle(),
            product.getDescription(),
            product.getMaterial(),
            product.getSlug(),
            product.getPrice(),
            product.getQuantity(),
            product.isActive(),
            product.isDestroy(),
            categoryIdConvert,
            brandIdConvert
        };

        try {
            int generateId = execQueryReturnId(sql, paramsObj);
            System.out.println(generateId);
            if (generateId > 0) {
                if (!product.getUrls().isEmpty()) {
                    for (int i = 0; i < product.getUrls().size(); i++) {
                        sqlUrls += String.format("(%d, N'%s')", generateId, product.getUrls().get(i));
                        if (i < product.getUrls().size() - 1) {
                            sqlUrls += ",";
                        }
                    }
                    int rowEffect = execQuery(sqlUrls);
                }
                if (!product.getAttributes().isEmpty()) {
                    String sqlAttribute = "INSERT INTO ProductAttributeValues (productId, attributeId, value) VALUES\n";
                    for (int i = 0; i < product.getAttributes().size(); i++) {
                        sqlAttribute += String.format("(%d, %d, N'%s')", generateId, product.getAttributes().get(i).getId(), product.getAttributes().get(i).getValue());
                        if (i < product.getAttributes().size() - 1) {
                            sqlAttribute += ",";
                        }
                    }
                    System.out.println(sqlAttribute);
                    int rowEffect = execQuery(sqlAttribute);
                }
                return true;
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
                + "    material = ?,\n"
                + "    slug = ?,\n"
                + "    productPrice = ?,\n"
                + "    productQuantity = ?,\n"
                + "    isActive = ?,\n"
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
            product.getMaterial(),
            product.getSlug(),
            product.getPrice(),
            product.getQuantity(),
            product.isActive(),
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

    public boolean deleteProduct(int productId) {
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

    public List<ProductAttribute> getAttributesByProductId(int productId) {
        List<ProductAttribute> attributes = new ArrayList<>();

        String query = "select pa.*, pav.value \n"
                + "from Products p\n"
                + "left join Categories  c\n"
                + "on p.categoryId = c.categoryId\n"
                + "left join ProductAttributes pa\n"
                + "on c.categoryId = pa.categoryId\n"
                + "left join ProductAttributeValues pav\n"
                + "on pa.attributeId = pav.attributeId AND pav.productId = p.productId\n"
                + "where p.productId = ?";
        Object[] params = {productId};
        try ( ResultSet rs = this.execSelectQuery(query, params)) {
            while (rs.next()) {
                ProductAttribute pa = new ProductAttribute();
                pa.setId(rs.getInt("attributeId"));
                pa.setName(rs.getString("attributeName"));
                pa.setUnit(rs.getString("unit"));
                pa.setMinValue(rs.getString("minValue"));
                pa.setMaxValue(rs.getString("maxValue"));
                pa.setDataType(rs.getString("dataType"));
                pa.setIsRequired(rs.getBoolean("isRequired"));
                pa.setIsActive(rs.getBoolean("isActive"));
                pa.setValue(rs.getString("value"));
                attributes.add(pa);
                System.out.println(pa);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attributes;
    }

    public List<ProductAttribute> getAttributesByProductIdAndCategoryId(int productId, int categoryId) {
        List<ProductAttribute> attributes = new ArrayList<>();

        String query = "SELECT pa.*, pav.value\n"
                + "FROM Categories c\n"
                + "JOIN ProductAttributes pa \n"
                + "ON c.categoryId = pa.categoryId\n"
                + "LEFT JOIN ProductAttributeValues pav \n"
                + "    ON pa.attributeId = pav.attributeId \n"
                + "    AND pav.productId = ?\n"
                + "WHERE c.categoryId = ?;";
        Object[] params = {productId, categoryId};
        try ( ResultSet rs = this.execSelectQuery(query, params)) {
            while (rs.next()) {
                ProductAttribute pa = new ProductAttribute();
                pa.setId(rs.getInt("attributeId"));
                pa.setName(rs.getString("attributeName"));
                pa.setUnit(rs.getString("unit"));
                pa.setMinValue(rs.getString("minValue"));
                pa.setMaxValue(rs.getString("maxValue"));
                pa.setDataType(rs.getString("dataType"));
                pa.setIsRequired(rs.getBoolean("isRequired"));
                pa.setIsActive(rs.getBoolean("isActive"));
                pa.setValue(rs.getString("value"));
                attributes.add(pa);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attributes;
    }

    public List<ProductAttribute> getAttributesByCategoryId(int categoryId) {
        List<ProductAttribute> attributes = new ArrayList<>();

        String query = "select *\n"
                + "from ProductAttributes pa\n"
                + "where pa.categoryId = ?";
        Object[] params = {categoryId};
        try ( ResultSet rs = this.execSelectQuery(query, params)) {
            while (rs.next()) {
                ProductAttribute pa = new ProductAttribute();
                pa.setId(rs.getInt("attributeId"));
                pa.setName(rs.getString("attributeName"));
                pa.setUnit(rs.getString("unit"));
                pa.setMinValue(rs.getString("minValue"));
                pa.setMaxValue(rs.getString("maxValue"));
                pa.setDataType(rs.getString("dataType"));
                pa.setIsRequired(rs.getBoolean("isRequired"));
                pa.setIsActive(rs.getBoolean("isActive"));
                attributes.add(pa);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attributes;
    }

    public boolean upsertProductAttributeValues(int productId, List<ProductAttribute> attributes) {
        String selectSql = "SELECT attributeId FROM ProductAttributeValues WHERE productId = ? AND attributeId = ?";
        String updateSql = "UPDATE ProductAttributeValues SET value = ? WHERE productId = ? AND attributeId = ?";
        String insertSql = "INSERT INTO ProductAttributeValues (productId, attributeId, value) VALUES (?, ?, ?)";

        try {
            for (ProductAttribute attr : attributes) {
                int attributeId = attr.getId();
                String value = (attr.getValue() != null && !attr.getValue().isEmpty()) ? attr.getValue() : null;
                Object[] selectParams = {productId, attributeId};
                ResultSet rs = execSelectQuery(selectSql, selectParams);
                if (rs.next()) {
                    System.out.println("Update");
                    Object[] updateParams = {value, productId, attributeId};
                    execQuery(updateSql, updateParams);
                } else {
                    System.out.println("Insert");
                    Object[] insertParams = {productId, attributeId, value};
                    execQuery(insertSql, insertParams);
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     public List<Product> search(String keyword, Integer categoryId, Integer brandId) {
        List<Product> list = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT p.productId, p.productTitle, p.productPrice, p.slug, i.url "
                + "FROM Products p "
                + "LEFT JOIN ProductImages i ON p.productId = i.productId "
                + "WHERE p._destroy = 0 "
        );
        List<Object> params = new ArrayList<>();

        // Có keyword thì thêm điều kiện
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append("AND p.productTitle LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        // Có category thì thêm điều kiện
        if (categoryId != null && categoryId > 0) {
            query.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        // Có brand thì thêm điều kiện
        if (brandId != null && brandId > 0) {
            query.append("AND p.brandId = ? ");
            params.add(brandId);
        }

        try ( ResultSet rs = execSelectQuery(query.toString(), params.toArray())) {
            Map<Integer, Product> productMap = new HashMap<>();
            while (rs.next()) {
                int pid = rs.getInt("productId");
                Product p = productMap.get(pid);
                if (p == null) {
                    p = new Product();
                    p.setProductId(pid);
                    p.setTitle(rs.getString("productTitle"));
                    p.setPrice(rs.getDouble("productPrice"));
                    p.setSlug(rs.getString("slug"));
                    p.setUrls(new ArrayList<String>());
                    productMap.put(pid, p);
                    list.add(p);
                }
                String url = rs.getString("url");
                if (url != null && !url.isEmpty()) {
                    p.getUrls().add(url);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> searchByKeyword(String keyword) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.productId, p.productTitle, p.productPrice, p.slug, i.url "
                + "FROM Products p "
                + "LEFT JOIN ProductImages i ON p.productId = i.productId "
                + "LEFT JOIN Brands b ON p.brandId = b.brandId "
                + "LEFT JOIN Categories c ON p.categoryId = c.categoryId "
                + "WHERE (p.productTitle LIKE ? OR b.brandName LIKE ? OR c.categoryName LIKE ?) AND p._destroy = 0";
        Object[] params = {"%" + keyword + "%", "%" + keyword + "%", "%" + keyword + "%"};

        try ( ResultSet rs = execSelectQuery(query, params)) {
            Map<Integer, Product> productMap = new HashMap<>();
            while (rs.next()) {
                int pid = rs.getInt("productId");
                Product p = productMap.get(pid);
                if (p == null) {
                    p = new Product();
                    p.setProductId(pid);
                    p.setTitle(rs.getString("productTitle"));
                    p.setPrice(rs.getDouble("productPrice"));
                    p.setSlug(rs.getString("slug"));
                    p.setUrls(new ArrayList<String>());
                    productMap.put(pid, p);
                    list.add(p);
                }
                String url = rs.getString("url");
                if (url != null && !url.isEmpty()) {
                    p.getUrls().add(url);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductBySlug(String slug) {
        Product product = null;
        String query = "SELECT p.*, c.categoryName, b.brandName "
                + "FROM Products p "
                + "LEFT JOIN Categories c ON p.categoryId = c.categoryId "
                + "LEFT JOIN Brands b ON p.brandId = b.brandId "
                + "WHERE p.slug = ? AND p._destroy = 0";
        Object[] params = {slug};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                product = new Product();
                int productId = rs.getInt("productId");
                product.setProductId(productId);
                product.setTitle(rs.getString("productTitle"));
                product.setSlug(slug);
                product.setDescription(rs.getString("productDescription"));
                product.setMaterial(rs.getString("material"));
                product.setPrice(rs.getDouble("productPrice"));
                product.setQuantity(rs.getInt("productQuantity"));
                product.setDestroy(rs.getBoolean("_destroy"));
                product.setIsActive(rs.getBoolean("isActive"));
                Object brandIdObj = rs.getObject("brandId");
                if (brandIdObj != null) {
                    int brandId = (int) brandIdObj;
                    String brandName = rs.getString("brandName");
                    product.setBrand(new Brand(brandId, brandName, null));
                }
                Object categoryIdObj = rs.getObject("categoryId");
                if (categoryIdObj != null) {
                    int categoryIdRs = (int) categoryIdObj;
                    String categoryName = rs.getString("categoryName");
                    product.setCategory(new Category(categoryIdRs, categoryName));
                }
                // Lấy ảnh
                ResultSet urlsResult = execSelectQuery("SELECT * FROM ProductImages WHERE productId = ?", new Object[]{productId});
                List<String> urls = new ArrayList<>();
                while (urlsResult.next()) {
                    urls.add(urlsResult.getString("url"));
                }
                product.setUrls(urls);
                // Có thể bổ sung lấy reviewStats/attributes nếu muốn
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }
}
