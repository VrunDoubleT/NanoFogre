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
        String query = "select * from Categories";
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
        String query = "SELECT * FROM Categories ORDER BY categoryId OFFSET " + row + " ROWS FETCH NEXT " + limit + " ROWS ONLY";
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

    public boolean createCategory(Category category) {
        String query = "INSERT INTO Categories (categoryName) VALUES (?)";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category.getName());

            System.out.println("Executing query: " + query + " with categoryName: " + category.getName());

            int rowsAffected = stmt.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Category getCategoryById(int categoryId) {
        Category category = null;

        String query = "SELECT * FROM Categories WHERE categoryId = ?"; // SQL query to get category by ID

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId); // Set categoryId as parameter

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    category = new Category();
                    category.setId(rs.getInt("categoryId"));
                    category.setName(rs.getString("categoryName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public boolean updateCategory(Category category) {
        String updateQuery = "UPDATE Categories SET categoryName = ? WHERE categoryId = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, category.getName());
            stmt.setInt(2, category.getId());
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to update Products table, setting categoryId to NULL
    public boolean updateCategoryInProducts(int categoryId) {
        String updateProductsSql = "UPDATE Products SET categoryId = NULL WHERE categoryId = ?";

        try ( Connection conn = getConnection()) {
            try ( PreparedStatement stmt = conn.prepareStatement(updateProductsSql)) {
                stmt.setInt(1, categoryId);
                int rowsAffected = stmt.executeUpdate();

                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Method to delete a category by its categoryId
    public boolean deleteCategoryById(int categoryId) {
        String deleteCategorySql = "DELETE FROM Categories WHERE categoryId = ?";

        try ( Connection conn = getConnection()) {
            try ( PreparedStatement stmt = conn.prepareStatement(deleteCategorySql)) {
                stmt.setInt(1, categoryId);
                int rowsAffected = stmt.executeUpdate();

                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Handle error while deleting category
    }
}
