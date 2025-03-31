package com.conference.dao;

import com.conference.model.Committee;
import com.conference.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CommitteeDAO {
    private static final Logger LOGGER = Logger.getLogger(CommitteeDAO.class.getName());

    /**
     * Create a new committee
     */
    public int createCommittee(Committee committee) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert committee
            String sql = "INSERT INTO committees (conference_id, type, chair_id) VALUES (?, ?, ?)";
            int committeeId;

            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, committee.getConferenceId());
                pstmt.setString(2, committee.getType());
                pstmt.setInt(3, committee.getChair() != null ? committee.getChair().getUserId() : null);

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating committee failed, no rows affected.");
                }

                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        committeeId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating committee failed, no ID obtained.");
                    }
                }
            }

            // Insert committee members
            if (committee.getMembers() != null && !committee.getMembers().isEmpty()) {
                insertCommitteeMembers(conn, committeeId, committee.getMembers());
            }

            conn.commit();
            return committeeId;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error creating committee", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    /**
     * Update committee details
     */
    public boolean updateCommittee(Committee committee) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update committee
            String sql = "UPDATE committees SET type = ?, chair_id = ? WHERE id = ?";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, committee.getType());
                pstmt.setInt(2, committee.getChair() != null ? committee.getChair().getUserId() : null);
                pstmt.setInt(3, committee.getId());

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    return false;
                }
            }

            // Update members
            deleteCommitteeMembers(conn, committee.getId());
            if (committee.getMembers() != null && !committee.getMembers().isEmpty()) {
                insertCommitteeMembers(conn, committee.getId(), committee.getMembers());
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error updating committee", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    /**
     * Get committee by ID
     */
    public Committee getCommittee(int id) throws SQLException {
        String sql = "SELECT * FROM committees WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Committee committee = mapResultSetToCommittee(rs);
                    committee.setMembers(getCommitteeMembers(committee.getId()));
                    return committee;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving committee", e);
            throw e;
        }
        return null;
    }

    /**
     * Get committee by conference ID and type
     */
    public Committee getCommitteeByConferenceAndType(int conferenceId, String type) throws SQLException {
        String sql = "SELECT * FROM committees WHERE conference_id = ? AND type = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, conferenceId);
            pstmt.setString(2, type);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Committee committee = mapResultSetToCommittee(rs);
                    committee.setMembers(getCommitteeMembers(committee.getId()));
                    return committee;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving committee by conference and type", e);
            throw e;
        }
        return null;
    }

    /**
     * Update member statistics
     */
    public boolean updateMemberStatistics(int memberId, int assignedPapers, int completedReviews) throws SQLException {
        String sql = "UPDATE committee_members SET assigned_papers = ?, completed_reviews = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, assignedPapers);
            pstmt.setInt(2, completedReviews);
            pstmt.setInt(3, memberId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating member statistics", e);
            throw e;
        }
    }

    /**
     * Delete committee
     */
    public boolean deleteCommittee(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete members first
            deleteCommitteeMembers(conn, id);

            // Then delete the committee
            String sql = "DELETE FROM committees WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, id);
                int affectedRows = pstmt.executeUpdate();
                
                conn.commit();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error deleting committee", e);
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    // Private helper methods

    private void insertCommitteeMembers(Connection conn, int committeeId, List<Committee.Member> members) 
            throws SQLException {
        String sql = "INSERT INTO committee_members (committee_id, user_id, role, assigned_papers, " +
                    "completed_reviews, expertise, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (Committee.Member member : members) {
                pstmt.setInt(1, committeeId);
                pstmt.setInt(2, member.getUserId());
                pstmt.setString(3, member.getRole());
                pstmt.setInt(4, member.getAssignedPapers());
                pstmt.setInt(5, member.getCompletedReviews());
                pstmt.setString(6, member.getExpertise());
                pstmt.setBoolean(7, member.isActive());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    private void deleteCommitteeMembers(Connection conn, int committeeId) throws SQLException {
        String sql = "DELETE FROM committee_members WHERE committee_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, committeeId);
            pstmt.executeUpdate();
        }
    }

    private List<Committee.Member> getCommitteeMembers(int committeeId) throws SQLException {
        List<Committee.Member> members = new ArrayList<>();
        String sql = "SELECT * FROM committee_members WHERE committee_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, committeeId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Committee.Member member = new Committee.Member();
                    member.setId(rs.getInt("id"));
                    member.setUserId(rs.getInt("user_id"));
                    member.setRole(rs.getString("role"));
                    member.setAssignedPapers(rs.getInt("assigned_papers"));
                    member.setCompletedReviews(rs.getInt("completed_reviews"));
                    member.setExpertise(rs.getString("expertise"));
                    member.setActive(rs.getBoolean("is_active"));
                    members.add(member);
                }
            }
        }
        return members;
    }

    private Committee mapResultSetToCommittee(ResultSet rs) throws SQLException {
        Committee committee = new Committee();
        committee.setId(rs.getInt("id"));
        committee.setConferenceId(rs.getInt("conference_id"));
        committee.setType(rs.getString("type"));
        
        int chairId = rs.getInt("chair_id");
        if (!rs.wasNull()) {
            Committee.Member chair = new Committee.Member(chairId, "CHAIR");
            committee.setChair(chair);
        }
        
        return committee;
    }
}