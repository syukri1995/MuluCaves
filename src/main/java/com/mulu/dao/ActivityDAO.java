package com.mulu.dao;

import com.mulu.model.Activity;
import com.mulu.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for the `activities` table. */
public class ActivityDAO {

    private static final Logger log = LoggerFactory.getLogger(ActivityDAO.class);

    private static final String SELECT_ALL_SQL =
            "SELECT id, name, description, long_description, image_path, sort_order " +
            "FROM activities ORDER BY sort_order ASC, id ASC";

    private static final String SELECT_BY_ID_SQL =
            "SELECT id, name, description, long_description, image_path, sort_order " +
            "FROM activities WHERE id = ?";

    /** Return all activities ordered by sort_order. Returns empty list on error. */
    public List<Activity> findAll() {
        List<Activity> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Activity a = new Activity();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setDescription(rs.getString("description"));
                a.setLongDescription(rs.getString("long_description"));
                a.setImagePath(rs.getString("image_path"));
                a.setSortOrder(rs.getInt("sort_order"));
                list.add(a);
            }
        } catch (SQLException ex) {
            log.error("Failed to fetch activities: {}", ex.getMessage(), ex);
        }
        return list;
    }

    public Activity findById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID_SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Activity a = new Activity();
                    a.setId(rs.getInt("id"));
                    a.setName(rs.getString("name"));
                    a.setDescription(rs.getString("description"));
                    a.setLongDescription(rs.getString("long_description"));
                    a.setImagePath(rs.getString("image_path"));
                    a.setSortOrder(rs.getInt("sort_order"));
                    return a;
                }
            }
        } catch (SQLException ex) {
            log.error("Failed to fetch activity {}: {}", id, ex.getMessage(), ex);
        }
        return null;
    }
}