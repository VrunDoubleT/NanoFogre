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

    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT * FROM Brands";
        try ( Connection conn = this.getConnection();  PreparedStatement stmt = conn.prepareStatement(query);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                brands.add(mapResultSetToBrand(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all brands: " + e.getMessage());
        }
        return brands;
    }

    public List<Brand> getBrandsByCategory(String category) {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT * FROM Brands WHERE category = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Brand brand = mapResultSetToBrand(rs);
                    brands.add(brand);
                }
            }
        } catch (SQLException e) {
            handleException("Error fetching brands by category", e);
        }
        return brands;
    }

    public int getTotalBrands() {
        int total = 0;
        String query = "SELECT COUNT(*) AS total FROM Brands";
        try ( Connection conn = this.getConnection();  PreparedStatement stmt = conn.prepareStatement(query);  ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            handleException("Error fetching total brands", e);
        }
        return total;
    }

    public int getTotalBrandsByCategory(String category) {
        int total = 0;
        String query = "SELECT COUNT(*) FROM Brands WHERE category = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            try ( ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            handleException("Error fetching total brands by category", e);
        }
        return total;
    }

    private Brand mapResultSetToBrand(ResultSet rs) throws SQLException {
        Brand brand = new Brand();
        brand.setId(rs.getInt("brandId"));
        brand.setName(rs.getString("brandName"));
        brand.setUrl(rs.getString("image"));
        brand.setCategory(rs.getString("category"));
        return brand;
    }

    private void handleException(String message, SQLException e) {
        System.err.println(message + ": " + e.getMessage());
        e.printStackTrace();
    }
}
