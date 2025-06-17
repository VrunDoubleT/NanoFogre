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

    public boolean updateCategory(Category category) {
        String query = "UPDATE Categories SET categoryName = ? WHERE categoryId = ?";
        try {
            int rowsUpdated = execQuery(query, new Object[]{category.getName(), category.getId()});
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public boolean createCategory(Category category) {
        String query = "INSERT INTO Categories (categoryName) VALUES (?)";
        try {
            int rowsAffected = execQuery(query, new Object[]{category.getName()});
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCategoryNameExists(String categoryName) {
        // Câu lệnh SQL để kiểm tra xem tên danh mục có tồn tại trong bảng Categories không
        String query = "SELECT COUNT(*) FROM Categories WHERE categoryName = ?";

        try ( ResultSet rs = execSelectQuery(query, new Object[]{categoryName})) {
            // Kiểm tra nếu có ít nhất 1 bản ghi với tên danh mục trùng khớp
            if (rs.next()) {
                return rs.getInt(1) > 0; // Nếu số lượng lớn hơn 0 thì danh mục đã tồn tại
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu không có bản ghi nào, trả về false
        return false;
    }

}
