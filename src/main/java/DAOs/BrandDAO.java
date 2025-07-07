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

    // READ 
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT brandId, brandName, image FROM Brands";
        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                brands.add(mapResultSetToBrand(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    // READ 
    public List<Brand> getBrandsPaginated(int page, int pageSize) {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT brandId, brandName, image FROM Brands ORDER BY brandId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try ( Connection conn = this.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            int offset = (page - 1) * pageSize;
            stmt.setInt(1, offset);
            stmt.setInt(2, pageSize);
            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    brands.add(mapResultSetToBrand(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    // CREATE 
    public boolean createBrand(String name, String imageUrl) {
        String query = "INSERT INTO Brands (brandName, image) VALUES (?, ?)";
        Object[] params = {name, imageUrl};
        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE 
    public boolean updateBrand(int id, String newName, String newImageUrl) {
        String query = "UPDATE Brands SET brandName = ?, image = ? WHERE brandId = ?";
        Object[] params = {newName, newImageUrl, id};
        try {
            return execQuery(query, params) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isBrandInUse(int brandId) {
        String query = "SELECT COUNT(*) AS total FROM Products WHERE brandId = ?";
        Object[] params = {brandId};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next() && rs.getInt("total") > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBrand(int id) {
        Connection conn = null;
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false);
            String updateProductsSql = "UPDATE Products SET brandId = NULL WHERE brandId = ?";
            try ( PreparedStatement updateStmt = conn.prepareStatement(updateProductsSql)) {
                updateStmt.setInt(1, id);
                updateStmt.executeUpdate();
            }

            String deleteBrandSql = "DELETE FROM Brands WHERE brandId = ?";
            try ( PreparedStatement deleteStmt = conn.prepareStatement(deleteBrandSql)) {
                deleteStmt.setInt(1, id);
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
            handleException("Error deleting brand", e);
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

    public boolean isBrandNameExists(String name) {
        String query = "SELECT COUNT(*) AS total FROM Brands WHERE brandName = ?";
        Object[] params = {name};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next() && rs.getInt("total") > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isBrandNameExistsExceptId(String name, int id) {
        String query = "SELECT COUNT(*) AS total FROM Brands WHERE brandName = ? AND brandId <> ?";
        Object[] params = {name, id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            return rs.next() && rs.getInt("total") > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalBrandsForPagination() {
        String query = "SELECT COUNT(*) AS total FROM Brands";
        try ( ResultSet rs = execSelectQuery(query)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Brand getBrandById(int id) {
        String query = "SELECT brandId, brandName, image FROM Brands WHERE brandId = ?";
        Object[] params = {id};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return mapResultSetToBrand(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Brand mapResultSetToBrand(ResultSet rs) throws SQLException {
        return new Brand(
                rs.getInt("brandId"),
                rs.getString("brandName"),
                rs.getString("image")
        );
    }

    private void handleException(String message, SQLException e) {
        System.err.println(message + ": " + e.getMessage());
        e.printStackTrace();
    }

    public List<Brand> getBrandsByCategoryId(int categoryId) {
        List<Brand> brands = new ArrayList<>();
        String query = "select b.brandId, b.brandName, b.image\n"
                + "from Categories c\n"
                + "JOIN Products p\n"
                + "on c.categoryId = p.categoryId\n"
                + "join Brands b\n"
                + "on b.brandId = p.brandId\n"
                + "where c.categoryId = ?\n"
                + "group by b.brandId, b.brandName, b.image";
        Object[] params = {categoryId};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setId(rs.getInt("brandId"));
                brand.setName(rs.getString("brandName"));
                brand.setUrl(rs.getString("image"));
                brands.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }
}
