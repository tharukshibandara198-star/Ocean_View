package com.oceanview.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - Singleton Pattern
 * ─────────────────────────────────
 * Ensures only ONE database connection object exists in the entire application.
 * Uses "double-checked locking" for thread safety.
 *
 * Design Pattern: Singleton
 */
public class DBConnection {

    // ── Database credentials ─────────────────────────────────────────────────
    private static final String DB_URL      = "jdbc:mysql://127.0.0.1:3306/ocean_view_resort?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";  // XAMPP MariaDB root has no password by default

    // ── Volatile ensures visibility across threads ────────────────────────────
    private static volatile DBConnection instance = null;

    // The actual JDBC connection object
    private Connection connection;

    /**
     * Private constructor — prevents direct instantiation.
     * Loads the MySQL driver and opens one connection.
     */
    private DBConnection() {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("[DBConnection] Database connected successfully.");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found in classpath!", e);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to connect to the database! Check URL/credentials.", e);
        }
    }

    /**
     * Returns the single instance of DBConnection.
     * Double-checked locking pattern for thread safety.
     *
     * @return DBConnection singleton instance
     */
    public static DBConnection getInstance() {
        if (instance == null) {                    // First check (no locking)
            synchronized (DBConnection.class) {
                if (instance == null) {            // Second check (with locking)
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }

    /**
     * Returns the underlying java.sql.Connection.
     * Reconnects automatically if the connection was closed.
     *
     * @return active java.sql.Connection
     */
    public Connection getConnection() {
        try {
            // Re-open connection if it timed out or was closed
            if (connection == null || connection.isClosed()) {
                System.out.println("[DBConnection] Connection lost, reconnecting...");
                connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to reconnect to the database!", e);
        }
        return connection;
    }

    /**
     * Closes the database connection (call only at application shutdown).
     */
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                instance = null;
                System.out.println("[DBConnection] Database connection closed.");
            }
        } catch (SQLException e) {
            System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
        }
    }
}
