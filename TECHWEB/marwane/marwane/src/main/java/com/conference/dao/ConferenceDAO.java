package com.conference.dao;

import com.conference.model.Conference;
import com.conference.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConferenceDAO {
    private static final Logger LOGGER = Logger.getLogger(ConferenceDAO.class.getName());

    /**
     * Create a new conference
     */
    public int createConference(Conference conference) throws SQLException {
        String sql = "INSERT INTO conferences (name, acronym, website, type, location, " +
                    "start_date, end_date, thematic, topics, logo_path, submission_deadline, " +
                    "review_deadline, notification_deadline, camera_ready_deadline) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, conference.getName());
            pstmt.setString(2, conference.getAcronym());
            pstmt.setString(3, conference.getWebsite());
            pstmt.setString(4, conference.getType());
            pstmt.setString(5, conference.getLocation());
            pstmt.setDate(6, new java.sql.Date(conference.getStartDate().getTime()));
            pstmt.setDate(7, new java.sql.Date(conference.getEndDate().getTime()));
            pstmt.setString(8, conference.getThematic());
            pstmt.setString(9, String.join(",", conference.getTopics()));
            pstmt.setString(10, conference.getLogoPath());
            pstmt.setDate(11, new java.sql.Date(conference.getSubmissionDeadline().getTime()));
            pstmt.setDate(12, new java.sql.Date(conference.getReviewDeadline().getTime()));
            pstmt.setDate(13, new java.sql.Date(conference.getNotificationDeadline().getTime()));
            pstmt.setDate(14, new java.sql.Date(conference.getCameraReadyDeadline().getTime()));

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating conference failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating conference failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating conference", e);
            throw e;
        }
    }

    /**
     * Update an existing conference
     */
    public boolean updateConference(Conference conference) throws SQLException {
        String sql = "UPDATE conferences SET name = ?, acronym = ?, website = ?, type = ?, " +
                    "location = ?, start_date = ?, end_date = ?, thematic = ?, topics = ?, " +
                    "logo_path = ?, submission_deadline = ?, review_deadline = ?, " +
                    "notification_deadline = ?, camera_ready_deadline = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, conference.getName());
            pstmt.setString(2, conference.getAcronym());
            pstmt.setString(3, conference.getWebsite());
            pstmt.setString(4, conference.getType());
            pstmt.setString(5, conference.getLocation());
            pstmt.setDate(6, new java.sql.Date(conference.getStartDate().getTime()));
            pstmt.setDate(7, new java.sql.Date(conference.getEndDate().getTime()));
            pstmt.setString(8, conference.getThematic());
            pstmt.setString(9, String.join(",", conference.getTopics()));
            pstmt.setString(10, conference.getLogoPath());
            pstmt.setDate(11, new java.sql.Date(conference.getSubmissionDeadline().getTime()));
            pstmt.setDate(12, new java.sql.Date(conference.getReviewDeadline().getTime()));
            pstmt.setDate(13, new java.sql.Date(conference.getNotificationDeadline().getTime()));
            pstmt.setDate(14, new java.sql.Date(conference.getCameraReadyDeadline().getTime()));
            pstmt.setInt(15, conference.getId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating conference", e);
            throw e;
        }
    }

    /**
     * Get a conference by ID
     */
    public Conference getConference(int id) throws SQLException {
        String sql = "SELECT * FROM conferences WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToConference(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving conference", e);
            throw e;
        }
        return null;
    }

    /**
     * Get all conferences
     */
    public List<Conference> getAllConferences() throws SQLException {
        List<Conference> conferences = new ArrayList<>();
        String sql = "SELECT * FROM conferences ORDER BY start_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                conferences.add(mapResultSetToConference(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all conferences", e);
            throw e;
        }
        return conferences;
    }

    /**
     * Delete a conference
     */
    public boolean deleteConference(int id) throws SQLException {
        String sql = "DELETE FROM conferences WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting conference", e);
            throw e;
        }
    }

    /**
     * Update submission deadline
     */
    public boolean updateSubmissionDeadline(int conferenceId, Date newDeadline) throws SQLException {
        String sql = "UPDATE conferences SET submission_deadline = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, new java.sql.Date(newDeadline.getTime()));
            pstmt.setInt(2, conferenceId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating submission deadline", e);
            throw e;
        }
    }

    /**
     * Get active conferences (current or upcoming)
     */
    public List<Conference> getActiveConferences() throws SQLException {
        List<Conference> conferences = new ArrayList<>();
        String sql = "SELECT * FROM conferences WHERE end_date >= CURRENT_DATE ORDER BY start_date";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                conferences.add(mapResultSetToConference(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving active conferences", e);
            throw e;
        }
        return conferences;
    }

    /**
     * Helper method to map ResultSet to Conference object
     */
    private Conference mapResultSetToConference(ResultSet rs) throws SQLException {
        Conference conference = new Conference();
        conference.setId(rs.getInt("id"));
        conference.setName(rs.getString("name"));
        conference.setAcronym(rs.getString("acronym"));
        conference.setWebsite(rs.getString("website"));
        conference.setType(rs.getString("type"));
        conference.setLocation(rs.getString("location"));
        conference.setStartDate(rs.getDate("start_date"));
        conference.setEndDate(rs.getDate("end_date"));
        conference.setThematic(rs.getString("thematic"));
        
        // Convert comma-separated topics string to List
        String topicsStr = rs.getString("topics");
        if (topicsStr != null && !topicsStr.isEmpty()) {
            conference.setTopics(new ArrayList<>(List.of(topicsStr.split(","))));
        }
        
        conference.setLogoPath(rs.getString("logo_path"));
        conference.setSubmissionDeadline(rs.getDate("submission_deadline"));
        conference.setReviewDeadline(rs.getDate("review_deadline"));
        conference.setNotificationDeadline(rs.getDate("notification_deadline"));
        conference.setCameraReadyDeadline(rs.getDate("camera_ready_deadline"));
        
        return conference;
    }
}