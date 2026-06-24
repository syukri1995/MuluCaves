package com.mulu.model;

import java.sql.Timestamp;

/**
 * Admin — represents an authenticated administrator (session-bound).
 */
public class Admin {
    private int id;
    private String username;
    private Timestamp createdAt;

    public Admin() {}

    public Admin(int id, String username, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}