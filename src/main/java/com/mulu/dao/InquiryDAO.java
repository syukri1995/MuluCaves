package com.mulu.dao;

import com.mulu.model.Inquiry;
import com.mulu.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data access for the `inquiries` table.
 */
public class InquiryDAO {

    private static final Logger log = LoggerFactory.getLogger(InquiryDAO.class);

    private static final String INSERT_SQL =
            "INSERT INTO inquiries (name, contact, gender, email, heard_from, message) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_ALL_SQL =
            "SELECT id, name, contact, gender, email, heard_from, message, submitted_at " +
            "FROM inquiries ORDER BY submitted_at DESC";

    private static final String DELETE_SQL =
            "DELETE FROM inquiries WHERE id = ?";

    private static final String UPDATE_SQL =
            "UPDATE inquiries SET name = ?, contact = ?, gender = ?, email = ?, heard_from = ?, message = ? WHERE id = ?";

    /** Insert a new inquiry. Returns true on success. */
    public boolean insert(Inquiry inquiry) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            ps.setString(1, inquiry.getName());
            ps.setString(2, inquiry.getContact());
            ps.setString(3, inquiry.getGender());
            ps.setString(4, inquiry.getEmail());
            ps.setString(5, inquiry.getHeardFrom());
            ps.setString(6, inquiry.getMessage());

            int rows = ps.executeUpdate();
            log.info("Inserted inquiry (rows={})", rows);
            return rows == 1;

        } catch (SQLException ex) {
            log.error("Failed to insert inquiry: {}", ex.getMessage(), ex);
            return false;
        }
    }

    /** Fetch all inquiries, newest first. Used by the admin dashboard. */
    public List<Inquiry> findAll() {
        List<Inquiry> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Inquiry inq = new Inquiry();
                inq.setId(rs.getInt("id"));
                inq.setName(rs.getString("name"));
                inq.setContact(rs.getString("contact"));
                inq.setGender(rs.getString("gender"));
                inq.setEmail(rs.getString("email"));
                inq.setHeardFrom(rs.getString("heard_from"));
                inq.setMessage(rs.getString("message"));
                inq.setSubmittedAt(rs.getTimestamp("submitted_at"));
                list.add(inq);
            }
        } catch (SQLException ex) {
            log.error("Failed to fetch inquiries: {}", ex.getMessage(), ex);
        }
        return list;
    }

    /** Delete an inquiry by ID. Returns true on success. */
    public boolean delete(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {

            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            log.info("Deleted inquiry id={} (rows={})", id, rows);
            return rows == 1;

        } catch (SQLException ex) {
            log.error("Failed to delete inquiry id={}: {}", id, ex.getMessage(), ex);
            return false;
        }
    }

    /** Update an inquiry. Returns true on success. */
    public boolean update(Inquiry inquiry) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {

            ps.setString(1, inquiry.getName());
            ps.setString(2, inquiry.getContact());
            ps.setString(3, inquiry.getGender());
            ps.setString(4, inquiry.getEmail());
            ps.setString(5, inquiry.getHeardFrom());
            ps.setString(6, inquiry.getMessage());
            ps.setInt(7, inquiry.getId());

            int rows = ps.executeUpdate();
            log.info("Updated inquiry id={} (rows={})", inquiry.getId(), rows);
            return rows == 1;

        } catch (SQLException ex) {
            log.error("Failed to update inquiry id={}: {}", inquiry.getId(), ex.getMessage(), ex);
            return false;
        }
    }
}