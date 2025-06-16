package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class DBContext {
    private static final String DB_URL = "jdbc:sqlserver://127.0.0.1:1433;databaseName=DBNonoForge;encrypt=false";
    private static final String DB_USER = "sa";
    private static final String DB_PWD = "123";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "❌ Driver not found", ex);
        }
    }

    public Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
            return conn;
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Failed to connect to database", ex);
            return null;
        }
    }

    // Execute a SELECT query with parameters and return a ResultSet
    public ResultSet execSelectQuery(String query, Object[] params) throws SQLException {
        PreparedStatement preparedStatement = this.getConnection().prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        return preparedStatement.executeQuery();
    }

    // Overloaded method to execute a SELECT query without any parameters
    public ResultSet execSelectQuery(String query) throws SQLException {
        return this.execSelectQuery(query, null);
    }

    // Execute an update query (INSERT, UPDATE, DELETE) with parameters
    // Returns the number of affected rows
    public int execQuery(String query, Object[] params) throws SQLException {
        PreparedStatement preparedStatement = this.getConnection().prepareStatement(query);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                preparedStatement.setObject(i + 1, params[i]);
            }
        }
        return preparedStatement.executeUpdate();
    }

    public int execQuery(String query) throws SQLException {
        return this.execQuery(query, null);
    }

    public int execQueryReturnId(String query, Object[] params) throws SQLException {
        int generatedId = -1;
        try ( PreparedStatement preparedStatement = this.getConnection().prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    preparedStatement.setObject(i + 1, params[i]);
                }
            }
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows > 0) {
                try ( ResultSet rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }
}
