package com.conference.model;

import java.util.Date;

public class Review {
    private int id;
    private int paperId;
    private int reviewerId;
    private int score;
    private String comments;
    private String decision; // ACCEPT, REJECT, MAJOR_REVISION, MINOR_REVISION
    private Date reviewDate;
    private String confidentialComments; // Comments visible only to committee
    private boolean isCompleted;
    private String expertise; // Reviewer's expertise level for this paper's topic

    // Constructors
    public Review() {
        this.reviewDate = new Date();
        this.isCompleted = false;
    }

    public Review(int paperId, int reviewerId) {
        this();
        this.paperId = paperId;
        this.reviewerId = reviewerId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPaperId() {
        return paperId;
    }

    public void setPaperId(int paperId) {
        this.paperId = paperId;
    }

    public int getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(int reviewerId) {
        this.reviewerId = reviewerId;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        if (score >= 1 && score <= 5) { // Assuming 1-5 scale
            this.score = score;
        } else {
            throw new IllegalArgumentException("Score must be between 1 and 5");
        }
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getDecision() {
        return decision;
    }

    public void setDecision(String decision) {
        if (decision != null && (
            decision.equals("ACCEPT") ||
            decision.equals("REJECT") ||
            decision.equals("MAJOR_REVISION") ||
            decision.equals("MINOR_REVISION"))) {
            this.decision = decision;
        } else {
            throw new IllegalArgumentException("Invalid decision value");
        }
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getConfidentialComments() {
        return confidentialComments;
    }

    public void setConfidentialComments(String confidentialComments) {
        this.confidentialComments = confidentialComments;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public String getExpertise() {
        return expertise;
    }

    public void setExpertise(String expertise) {
        this.expertise = expertise;
    }

    // Method to validate if review is complete
    public boolean validateReview() {
        boolean isValid = score > 0 && 
                         comments != null && !comments.trim().isEmpty() &&
                         decision != null;
        this.isCompleted = isValid;
        return isValid;
    }

    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", paperId=" + paperId +
                ", reviewerId=" + reviewerId +
                ", score=" + score +
                ", decision='" + decision + '\'' +
                ", isCompleted=" + isCompleted +
                '}';
    }
}