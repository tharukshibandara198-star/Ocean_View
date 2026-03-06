package com.oceanview.dao;

import com.oceanview.db.DBConnection;
import com.oceanview.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * UserDAO - Data Access Object Pattern
 * ──────────────────────────────────────
 * Handles all database operations related to the 'users' table.
 * No SQL is allowed outside of DAO classes.
 *
 * Design Pattern: DAO (Data Access Object)
 */
public class UserDAO {

    private final Connection conn;

    public UserDAO() {
        // Get the single shared connection from the Singleton
        this.conn = DBConnection.getInstance().getConnection();
    }

    /**
     * Authenticates a user by username and password.
     * Returns the User object if credentials are valid, null otherwise.
     *
     * @param username entered username
     * @param password entered password
     * @return User object or null
     */
    public User authenticate(String username, String password) {
        String sql = "SELECT id, username, full_name, role FROM users "
                   + "WHERE username = ? AND password = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Build and return the User model
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] authenticate() error: " + e.getMessage());
        }
        return null; // Authentication failed
    }

    /**
     * Finds a user record by their ID (used to display "Created by" in reports).
     *
     * @param userId the user's ID
     * @return User object or null
     */
    public User findById(int userId) {
        String sql = "SELECT id, username, full_name, role FROM users WHERE id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] findById() error: " + e.getMessage());
        }
        return null;
    }
}
