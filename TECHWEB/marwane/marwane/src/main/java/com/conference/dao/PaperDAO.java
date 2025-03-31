package com.conference.dao;

import com.conference.model.Paper;
import com.conference.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaperDAO {
    private static final Logger LOGGER = Logger.getLogger(PaperDAO.class.getName());

    /**
     * Submit a new paper
     */
    public int submitPaper(Paper paper) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Generate unique submission ID
            String uniqueSubmissionId = generateSubmissionId();
            paper.setUniqueSubmissionId(uniqueSubmissionId);

            // Insert paper details
            String sql = "INSERT INTO papers (unique_submission_id, conference_id, title, " +
                        "summary, keywords, file_path, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, paper.getUniqueSubmissionId());
                pstmt.setInt(2, paper.getConferenceId());
                pstmt.setString(3, paper.getTitle());
                pstmt.setString(4, paper.getSummary());
                pstmt.setString(5, paper.getKeywords());
                pstmt.setString(6, paper.getFilePath());
                pstmt.setString(7, paper.getStatus());

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating paper failed, no rows affected.");
                }

                int paperId;
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        paperId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating paper failed, no ID obtained.");
                    }
                }

                // Insert authors
                insertAuthors(conn, paperId, paper.getAuthors());

                conn.commit();
                return paperId;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error submitting paper", e);
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
     * Update paper details
     */
    public boolean updatePaper(Paper paper) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE papers SET title = ?, summary = ?, keywords = ?, " +
                        "file_path = ?, status = ? WHERE id = ?";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, paper.getTitle());
                pstmt.setString(2, paper.getSummary());
                pstmt.setString(3, paper.getKeywords());
                pstmt.setString(4, paper.getFilePath());
                pstmt.setString(5, paper.getStatus());
                pstmt.setInt(6, paper.getId());

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    return false;
                }

                // Update authors
                deleteAuthors(conn, paper.getId());
                insertAuthors(conn, paper.getId(), paper.getAuthors());

                conn.commit();
                return true;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error updating paper", e);
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
     * Get paper by ID
     */
    public Paper getPaper(int id) throws SQLException {
        String sql = "SELECT * FROM papers WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Paper paper = mapResultSetToPaper(rs);
                    paper.setAuthors(getAuthors(paper.getId()));
                    return paper;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving paper", e);
            throw e;
        }
        return null;
    }

    /**
     * Get papers by conference ID
     */
    public List<Paper> getPapersByConference(int conferenceId) throws SQLException {
        List<Paper> papers = new ArrayList<>();
        String sql = "SELECT * FROM papers WHERE conference_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, conferenceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Paper paper = mapResultSetToPaper(rs);
                    paper.setAuthors(getAuthors(paper.getId()));
                    papers.add(paper);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving papers by conference", e);
            throw e;
        }
        return papers;
    }

    /**
     * Update paper status
     */
    public boolean updatePaperStatus(int paperId, String status) throws SQLException {
        String sql = "UPDATE papers SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, paperId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating paper status", e);
            throw e;
        }
    }

    /**
     * Delete paper
     */
    public boolean deletePaper(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete authors first
            deleteAuthors(conn, id);

            // Then delete the paper
            String sql = "DELETE FROM papers WHERE id = ?";
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
            LOGGER.log(Level.SEVERE, "Error deleting paper", e);
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

    private String generateSubmissionId() {
        return "SUB-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private void insertAuthors(Connection conn, int paperId, List<Paper.Author> authors) throws SQLException {
        String sql = "INSERT INTO paper_authors (paper_id, name, affiliation, email, is_corresponding) " +
                    "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (Paper.Author author : authors) {
                pstmt.setInt(1, paperId);
                pstmt.setString(2, author.getName());
                pstmt.setString(3, author.getAffiliation());
                pstmt.setString(4, author.getEmail());
                pstmt.setBoolean(5, author.isCorresponding());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    private void deleteAuthors(Connection conn, int paperId) throws SQLException {
        String sql = "DELETE FROM paper_authors WHERE paper_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, paperId);
            pstmt.executeUpdate();
        }
    }

    private List<Paper.Author> getAuthors(int paperId) throws SQLException {
        List<Paper.Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM paper_authors WHERE paper_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, paperId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Paper.Author author = new Paper.Author(
                        rs.getString("name"),
                        rs.getString("affiliation"),
                        rs.getString("email"),
                        rs.getBoolean("is_corresponding")
                    );
                    authors.add(author);
                }
            }
        }
        return authors;
    }

    private Paper mapResultSetToPaper(ResultSet rs) throws SQLException {
        Paper paper = new Paper();
        paper.setId(rs.getInt("id"));
        paper.setUniqueSubmissionId(rs.getString("unique_submission_id"));
        paper.setConferenceId(rs.getInt("conference_id"));
        paper.setTitle(rs.getString("title"));
        paper.setSummary(rs.getString("summary"));
        paper.setKeywords(rs.getString("keywords"));
        paper.setFilePath(rs.getString("file_path"));
        paper.setSubmissionDate(rs.getTimestamp("submission_date"));
        paper.setStatus(rs.getString("status"));
        return paper;
    }
}