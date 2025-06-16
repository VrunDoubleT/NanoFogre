package DAOs;

import Models.Brand;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import DB.DBContext;
import java.sql.Connection;



public class BrandDAO extends DBContext {
    // CREATE 
    public boolean createBrand(String name, String imageUrl) {
        String query = "INSERT INTO Brands (brandName, image) VALUES (?, ?)";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, name);
            stmt.setString(2, imageUrl);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            handleException("Error creating brand", e);
            return false;
        }
    }

    // READ 
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT brandId, brandName, image FROM Brands";
        
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                brands.add(mapResultSetToBrand(rs));
            }
        } catch (SQLException e) {
            handleException("Error fetching all brands", e);
        }
        return brands;
    }

    // READ 
    public List<Brand> getBrandsPaginated(int page, int pageSize) {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT brandId, brandName, image FROM Brands ORDER BY brandId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            int offset = (page - 1) * pageSize;
            stmt.setInt(1, offset);
            stmt.setInt(2, pageSize);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    brands.add(mapResultSetToBrand(rs));
                }
            }
        } catch (SQLException e) {
            handleException("Error fetching paginated brands", e);
        }
        return brands;
    }

    // UPDATE 
    public boolean updateBrand(int id, String newName, String newImageUrl) {
        String query = "UPDATE Brands SET brandName = ?, image = ? WHERE brandId = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, newName);
            stmt.setString(2, newImageUrl);
            stmt.setInt(3, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            handleException("Error updating brand", e);
            return false;
        }
    }

    // DELETE 
    public boolean deleteBrand(int id) {
        String query = "DELETE FROM Brands WHERE brandId = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            handleException("Error deleting brand", e);
            return false;
        }
    }

    public boolean isBrandNameExists(String name) {
        String query = "SELECT COUNT(*) FROM Brands WHERE brandName = ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            handleException("Error checking brand name", e);
            return false;
        }
    }

    public boolean isBrandNameExistsExceptId(String name, int id) {
        String query = "SELECT COUNT(*) FROM Brands WHERE brandName = ? AND brandId <> ?";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, name);
            stmt.setInt(2, id);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            handleException("Error checking brand name (update)", e);
            return false;
        }
    }

    public int getTotalBrandsForPagination() {
        int total = 0;
        String query = "SELECT COUNT(*) AS total FROM Brands";
        try (Connection conn = this.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            handleException("Error fetching total brands", e);
        }
        return total;
    }

    public Brand getBrandById(int id) {
    String query = "SELECT brandId, brandName, image FROM Brands WHERE brandId = ?"; // Sửa tên cột
    System.out.println("Executing query for ID: " + id);
    
    try (Connection conn = this.getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {
        
        stmt.setInt(1, id);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Brand brand = new Brand();
                brand.setId(rs.getInt("brandId"));
                brand.setName(rs.getString("brandName")); // Đúng tên cột
                brand.setUrl(rs.getString("image")); // Đúng tên cột
                System.out.println("Found brand in DB: " + brand.getName());
                return brand;
            } else {
                System.out.println("No brand found with ID: " + id);
            }
            return null;
        }
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
        handleException("Lỗi truy vấn brand theo ID", e);
        return null;
    }
}



    private Brand mapResultSetToBrand(ResultSet rs) throws SQLException {
    Brand brand = new Brand();
    brand.setId(rs.getInt("brandId"));
    brand.setName(rs.getString("brandName")); // Sửa thành brandName
    brand.setUrl(rs.getString("image")); // Sửa thành image
    return brand;
}


    private void handleException(String message, SQLException e) {
        System.err.println(message + ": " + e.getMessage());
        e.printStackTrace();
    }
}

