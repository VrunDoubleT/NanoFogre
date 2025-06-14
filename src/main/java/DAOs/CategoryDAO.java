package DAOs;

import Models.Category;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class CategoryDAO extends DB.DBContext{
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
    
     /////// Lấy danh mục theo ID
     public int getTotalCategories() {
        String query = "SELECT COUNT(*) FROM Categories"; // SQL query to get the total count of categories
        try (ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1); // Return the count
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Default to 0 if there's an error
    }
}
