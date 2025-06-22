package DAOs;

import DB.DBContext;
import Models.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        String query = "SELECT * FROM Categories DESC";
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
                // Instantiate Category using the constructor that takes parameters
                Category category = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName"),
                        rs.getBoolean("isActive"), // Assuming the column for active status is 'isActive'
                        rs.getString("image") // Column for image
                );
                categories.add(category); // Add category to the list
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    public int countCategory() {
        String query = "SELECT COUNT(*) FROM Categories"; // SQL query to get the total count of categories
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteCategoryById(int categoryId) {
        String query = "DELETE FROM Categories WHERE categoryId = ?";
        try {
            int rowsAffected = execQuery(query, new Object[]{categoryId});
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCategoryInProducts(int categoryId) {
        String query = "UPDATE Products SET categoryId = NULL WHERE categoryId = ?";
        try {
            int rowsAffected = execQuery(query, new Object[]{categoryId});
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public boolean createCategory(Category category) {
        // Updated query to insert categoryName, image, and isActive status
        String query = "INSERT INTO Categories (categoryName, image) VALUES (?, ?)";

        try {
            // Pass categoryName, image, and isActive status to the query
            int rowsAffected = execQuery(query, new Object[]{
                category.getName(), // categoryName
                category.getAvatar() // image (assuming 'avatar' stores the image URL)
            });

            return rowsAffected > 0; // Return true if the insertion is successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Return false in case of an error
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

}
