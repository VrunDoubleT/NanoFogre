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
        String query = "SELECT brandId, brandName, image FROM Brands";
        try (ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                brands.add(mapResultSetToBrand(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    public List<Brand> getBrands(int page, int limit) {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT brandId, brandName, image FROM Brands ORDER BY brandId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = this.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            int offset = (page - 1) * limit;
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    brands.add(mapResultSetToBrand(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    public int getTotalBrands() {
        String query = "SELECT COUNT(*) AS total FROM Brands";
        try (ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createBrand(String brandName, String imageUrl) {
        String query = "INSERT INTO Brands (brandName, image) VALUES (?, ?)";
        Object[] params = {brandName, imageUrl};
        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBrand(int brandId, String brandName, String imageUrl) {
        String query = "UPDATE Brands SET brandName = ?, image = ? WHERE brandId = ?";
        Object[] params = {brandName, imageUrl, brandId};
        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Kiểm tra tên brand đã tồn tại (dùng cho tạo mới)
    public boolean isBrandNameExists(String brandName) {
        String query = "SELECT COUNT(*) AS total FROM Brands WHERE brandName = ?";
        Object[] params = {brandName};
        try (ResultSet rs = execSelectQuery(query, params)) {
            return rs.next() && rs.getInt("total") > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isBrandNameExistsExceptId(String brandName, int brandId) {
        String query = "SELECT COUNT(*) AS total FROM Brands WHERE brandName = ? AND brandId <> ?";
        Object[] params = {brandName, brandId};
        try (ResultSet rs = execSelectQuery(query, params)) {
            return rs.next() && rs.getInt("total") > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Brand getBrandById(int brandId) {
        String query = "SELECT brandId, brandName, image FROM Brands WHERE brandId = ?";
        Object[] params = {brandId};
        try (ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return mapResultSetToBrand(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteBrand(int brandId) {
        Connection conn = null;
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false);

            String updateProductsSql = "UPDATE Products SET brandId = NULL WHERE brandId = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateProductsSql)) {
                updateStmt.setInt(1, brandId);
                updateStmt.executeUpdate();
            }

            String deleteBrandSql = "DELETE FROM Brands WHERE brandId = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteBrandSql)) {
                deleteStmt.setInt(1, brandId);
                int rowsAffected = deleteStmt.executeUpdate();

                if (rowsAffected > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private Brand mapResultSetToBrand(ResultSet rs) throws SQLException {
        return new Brand(
            rs.getInt("brandId"),
            rs.getString("brandName"),
            rs.getString("image")
        );
    }
}
