package com.mulu.dao;

import com.mulu.model.Admin;
import com.mulu.util.DBConnection;
import com.mulu.util.PasswordUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Data access for the `admin_users` table. */
public class AdminDAO {

    private static final Logger log = LoggerFactory.getLogger(AdminDAO.class);

    private static final String SELECT_BY_USERNAME_SQL =
            "SELECT id, username, password, created_at FROM admin_users WHERE username = ? LIMIT 1";

    private static final String UPDATE_PASSWORD_SQL =
            "UPDATE admin_users SET password = ? WHERE id = ?";

    /**
     * Verify credentials. Returns the Admin on success (with the *hash* field
     * discarded), or null on failure. Uses constant-time-ish BCrypt check.
     */
    public Admin authenticate(String username, String plaintextPassword) {
        if (username == null || plaintextPassword == null) {
            return null;
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USERNAME_SQL)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    log.warn("Login failed: unknown username '{}'", username);
                    return null;
                }
                String storedHash = rs.getString("password");
                if (!PasswordUtil.verify(plaintextPassword, storedHash)) {
                    log.warn("Login failed: bad password for '{}'", username);
                    return null;
                }
                return new Admin(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getTimestamp("created_at"));
            }
        } catch (SQLException ex) {
            log.error("Admin auth error: {}", ex.getMessage(), ex);
            return null;
        }
    }

    /** Rotate password for an existing admin. */
    public boolean updatePassword(int adminId, String newPlaintext) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD_SQL)) {
            ps.setString(1, PasswordUtil.hash(newPlaintext));
            ps.setInt(2, adminId);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            log.error("Failed to update admin password: {}", ex.getMessage(), ex);
            return false;
        }
    }
}