package com.oceanview.model;

/**
 * User Model
 * ───────────
 * Represents a staff member who can log into the system.
 *
 * Design Pattern: MVC - Model
 */
public class User {

    private int    id;
    private String username;
    private String password;
    private String fullName;
    private String role;       // "ADMIN" or "STAFF"

    // ── Constructors ──────────────────────────────────────────────────────────

    public User() {}

    public User(int id, String username, String fullName, String role) {
        this.id       = id;
        this.username = username;
        this.fullName = fullName;
        this.role     = role;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }

    public String getUsername()                  { return username; }
    public void   setUsername(String username)   { this.username = username; }

    public String getPassword()                  { return password; }
    public void   setPassword(String password)   { this.password = password; }

    public String getFullName()                  { return fullName; }
    public void   setFullName(String fullName)   { this.fullName = fullName; }

    public String getRole()              { return role; }
    public void   setRole(String role)   { this.role = role; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "'}";
    }
}
