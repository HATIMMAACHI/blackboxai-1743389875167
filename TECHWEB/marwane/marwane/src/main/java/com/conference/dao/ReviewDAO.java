package com.conference.dao;

import com.conference.model.Review;
import com.conference.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());

    /**
     * Create a new review
     */
    public int createReview(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (paper_id, reviewer_id, score, comments, decision, " +
                    "confidential_comments, expertise, is_completed) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, review.getPaperId());
            pstmt.setInt(2, review.getReviewerId());
            pstmt.setInt(3, review.getScore());
            pstmt.setString(4, review.getComments());
            pstmt.setString(5, review.getDecision());
            pstmt.setString(6, review.getConfidentialComments());
            pstmt.setString(7, review.getExpertise());
            pstmt.setBoolean(8, review.isCompleted());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating review failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating review failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating review", e);
            throw e;
        }
    }

    /**
     * Update an existing review
     */
    public boolean updateReview(Review review) throws SQLException {
        String sql = "UPDATE reviews SET score = ?, comments = ?, decision = ?, " +
                    "confidential_comments = ?, expertise = ?, is_completed = ? " +
                    "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, review.getScore());
            pstmt.setString(2, review.getComments());
            pstmt.setString(3, review.getDecision());
            pstmt.setString(4, review.getConfidentialComments());
            pstmt.setString(5, review.getExpertise());
            pstmt.setBoolean(6, review.isCompleted());
            pstmt.setInt(7, review.getId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating review", e);
            throw e;
        }
    }

    /**
     * Get review by ID
     */
    public Review getReview(int id) throws SQLException {
        String sql = "SELECT * FROM reviews WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReview(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving review", e);
            throw e;
        }
        return null;
    }

    /**
     * Get all reviews for a paper
     */
    public List<Review> getReviewsByPaper(int paperId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM reviews WHERE paper_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, paperId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving reviews by paper", e);
            throw e;
        }
        return reviews;
    }

    /**
     * Get all reviews by a reviewer
     */
    public List<Review> getReviewsByReviewer(int reviewerId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM reviews WHERE reviewer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapResultSetToReview(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving reviews by reviewer", e);
            throw e;
        }
        return reviews;
    }

    /**
     * Get completed reviews count for a reviewer
     */
    public int getCompletedReviewsCount(int reviewerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE reviewer_id = ? AND is_completed = true";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting completed reviews", e);
            throw e;
        }
        return 0;
    }

    /**
     * Get pending reviews count for a reviewer
     */
    public int getPendingReviewsCount(int reviewerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE reviewer_id = ? AND is_completed = false";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting pending reviews", e);
            throw e;
        }
        return 0;
    }

    /**
     * Delete a review
     */
    public boolean deleteReview(int id) throws SQLException {
        String sql = "DELETE FROM reviews WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting review", e);
            throw e;
        }
    }

    /**
     * Check if a reviewer has already reviewed a paper
     */
    public boolean hasReviewerReviewedPaper(int reviewerId, int paperId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE reviewer_id = ? AND paper_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewerId);
            pstmt.setInt(2, paperId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking reviewer's review status", e);
            throw e;
        }
        return false;
    }

    /**
     * Helper method to map ResultSet to Review object
     */
    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setPaperId(rs.getInt("paper_id"));
        review.setReviewerId(rs.getInt("reviewer_id"));
        review.setScore(rs.getInt("score"));
        review.setComments(rs.getString("comments"));
        review.setDecision(rs.getString("decision"));
        review.setReviewDate(rs.getTimestamp("review_date"));
        review.setConfidentialComments(rs.getString("confidential_comments"));
        review.setCompleted(rs.getBoolean("is_completed"));
        review.setExpertise(rs.getString("expertise"));
        return review;
    }
}