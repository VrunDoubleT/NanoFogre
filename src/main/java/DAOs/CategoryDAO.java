package DAOs;

import DB.DBContext;
import Models.Category;
import Models.ProductAttribute;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class CategoryDAO extends DB.DBContext {

    public List<Category> getCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories ";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("categoryId"));
                category.setName(rs.getString("categoryName"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Category> getCategories(int page, int limit) {
        int row = (page - 1) * limit;
        List<Category> categories = new ArrayList<>();

        String query = "SELECT * FROM Categories ORDER BY categoryId DESC OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getBoolean("isActive"),
                        rs.getString("image")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public List<Category> getActiveCategories(int page, int limit) {
        int row = (page - 1) * limit;
        List<Category> categories = new ArrayList<>();

        String query = "SELECT * FROM Categories c "
                + "WHERE c.isActive = 1 "
                + "ORDER BY c.categoryId "
                + "OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("categoryId"));
                category.setName(rs.getString("categoryName"));
                category.setAvatar(rs.getString("image"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public int countActiveCategories() {
        String query = "SELECT COUNT(*) AS total FROM Categories WHERE isActive = 1";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countCategory() {
        String query = "SELECT COUNT(*) FROM Categories";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateCategory(Category category, boolean updateImage) {
        String query;
        Object[] params;

        if (updateImage) {
            query = "UPDATE Categories SET categoryName = ?, image = ? WHERE categoryId = ?";
            params = new Object[]{category.getName(), category.getAvatar(), category.getId()};
        } else {
            query = "UPDATE Categories SET categoryName = ? WHERE categoryId = ?";
            params = new Object[]{category.getName(), category.getId()};
        }

        try {
            int rowsUpdated = execQuery(query, params);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Category getCategoryById(int categoryId) {
        Category category = null;
        String query = "SELECT * FROM Categories WHERE categoryId = ?";
        try ( ResultSet rs = execSelectQuery(query, new Object[]{categoryId})) {
            if (rs.next()) {
                category = new Category();
                category.setId(rs.getInt("categoryId"));
                category.setName(rs.getString("categoryName"));
                category.setAvatar(rs.getString("image"));
                category.setIsActive(rs.getBoolean("isActive"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public boolean createCategory(Category category) {
        String query = "INSERT INTO Categories (categoryName, image) VALUES (?, ?)";
        try {
            int rowsAffected = execQuery(query, new Object[]{
                category.getName(),
                category.getAvatar()
            });

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCategoryNameExists(String categoryName) {

        String query = "SELECT COUNT(*) FROM Categories WHERE categoryName = ?";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{categoryName})) {

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hideCategory(int categoryId) {
        String sql = "UPDATE Categories SET isActive = 0 WHERE categoryId = ?";
        Object[] params = {categoryId};
        try {
            int rows = execQuery(sql, params);
            System.out.println("Rows affected (hide): " + rows);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean enableCategory(int categoryId) {
        String sql = "UPDATE Categories SET isActive = 1 WHERE categoryId = ?";
        Object[] params = {categoryId};
        try {
            int rows = execQuery(sql, params);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createCategoryAndReturnId(Category category) {
        String sql = "INSERT INTO Categories (categoryName, image, isActive) VALUES (?, ?, 1)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getAvatar());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void saveAttributes(int categoryId, List<ProductAttribute> list) {
        String updateSql = "UPDATE ProductAttributes SET "
                + "attributeName = ?, unit = ?, minValue = ?, maxValue = ?, dataType = ?, "
                + "isRequired = ?, isActive = ? "
                + "WHERE attributeId = ?";

        for (ProductAttribute attr : list) {
            try {
                Object[] params = new Object[]{
                    attr.getName(),
                    attr.getUnit(),
                    attr.getMinValue(),
                    attr.getMaxValue(),
                    attr.getDataType(),
                    attr.getIsRequired() != null && attr.getIsRequired(),
                    attr.getIsActive() != null && attr.getIsActive(),
                    attr.getId()
                };
                execQuery(updateSql, params);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<ProductAttribute> getAttributesByCategoryId(int categoryId) {
        List<ProductAttribute> list = new ArrayList<>();
        String sql = "SELECT * FROM ProductAttributes WHERE categoryId = ?";
        try ( ResultSet rs = execSelectQuery(sql, new Object[]{categoryId})) {
            while (rs.next()) {
                ProductAttribute attr = new ProductAttribute();
                attr.setId(rs.getInt("attributeId"));
                attr.setName(rs.getString("attributeName"));
                attr.setUnit(rs.getString("unit"));
                attr.setMinValue(rs.getString("minValue"));
                attr.setMaxValue(rs.getString("maxValue"));
                attr.setDataType(rs.getString("dataType"));
                attr.setIsRequired(rs.getBoolean("isRequired"));
                attr.setIsActive(rs.getBoolean("isActive"));
                attr.setCategoryId(rs.getInt("categoryId"));
                list.add(attr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertAttributes(int categoryId, List<ProductAttribute> list) throws SQLException {
        if (list == null || list.isEmpty()) {
            return;
        }

        String insertSql
                = "INSERT INTO ProductAttributes "
                + "(attributeName, unit, minValue, maxValue, dataType, isRequired, isActive, categoryId) "
                + "VALUES (?, ?, ?, ?, ?, ?, 1, ?)";

        try ( Connection conn = getConnection();  PreparedStatement pstmt = conn.prepareStatement(insertSql)) {

            for (ProductAttribute attr : list) {
                if (attr.getName() == null || attr.getName().trim().isEmpty()) {
                    throw new SQLException("Attribute name cannot be null or empty");
                }
                if (attr.getDataType() == null || attr.getDataType().trim().isEmpty()) {
                    throw new SQLException("Data type cannot be null or empty");
                }

                pstmt.setString(1, attr.getName().trim());
                pstmt.setString(2, attr.getUnit());

                if (attr.getMinValue() != null) {
                    pstmt.setString(3, attr.getMinValue());
                } else {
                    pstmt.setNull(3, Types.NVARCHAR);
                }
                if (attr.getMaxValue() != null) {
                    pstmt.setString(4, attr.getMaxValue());
                } else {
                    pstmt.setNull(4, Types.NVARCHAR);
                }

                pstmt.setString(5, attr.getDataType());
                pstmt.setBoolean(6, attr.getIsRequired() != null && attr.getIsRequired());
                pstmt.setInt(7, categoryId);

                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    public boolean deleteAttribute(int attributeId) {
        String sql = "DELETE FROM ProductAttributes WHERE attributeId = ?";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attributeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT TOP 10 *\n"
                + "FROM Categories c\n"
                + "WHERE c.isActive = 1;";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("categoryId"));
                category.setName(rs.getString("categoryName"));
                category.setAvatar(rs.getString("image"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }
}
