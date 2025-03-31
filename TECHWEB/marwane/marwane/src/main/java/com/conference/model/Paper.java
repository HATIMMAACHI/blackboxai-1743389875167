package com.conference.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Paper {
    private int id;
    private String uniqueSubmissionId;
    private int conferenceId;
    private String title;
    private String summary;
    private String keywords;
    private String filePath;
    private Date submissionDate;
    private String status; // SUBMITTED, UNDER_REVIEW, ACCEPTED, REJECTED
    private List<Author> authors;
    private List<Review> reviews;

    // Inner class for Author details
    public static class Author {
        private String name;
        private String affiliation;
        private String email;
        private boolean isCorresponding;

        public Author(String name, String affiliation, String email, boolean isCorresponding) {
            this.name = name;
            this.affiliation = affiliation;
            this.email = email;
            this.isCorresponding = isCorresponding;
        }

        // Getters and Setters
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getAffiliation() {
            return affiliation;
        }

        public void setAffiliation(String affiliation) {
            this.affiliation = affiliation;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public boolean isCorresponding() {
            return isCorresponding;
        }

        public void setCorresponding(boolean corresponding) {
            isCorresponding = corresponding;
        }
    }

    // Constructors
    public Paper() {
        this.authors = new ArrayList<>();
        this.reviews = new ArrayList<>();
        this.submissionDate = new Date();
        this.status = "SUBMITTED";
    }

    public Paper(String title, String summary, String keywords) {
        this();
        this.title = title;
        this.summary = summary;
        this.keywords = keywords;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUniqueSubmissionId() {
        return uniqueSubmissionId;
    }

    public void setUniqueSubmissionId(String uniqueSubmissionId) {
        this.uniqueSubmissionId = uniqueSubmissionId;
    }

    public int getConferenceId() {
        return conferenceId;
    }

    public void setConferenceId(int conferenceId) {
        this.conferenceId = conferenceId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Date getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Date submissionDate) {
        this.submissionDate = submissionDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Author> getAuthors() {
        return authors;
    }

    public void setAuthors(List<Author> authors) {
        this.authors = authors;
    }

    public void addAuthor(Author author) {
        if (this.authors == null) {
            this.authors = new ArrayList<>();
        }
        this.authors.add(author);
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }

    public void addReview(Review review) {
        if (this.reviews == null) {
            this.reviews = new ArrayList<>();
        }
        this.reviews.add(review);
    }

    @Override
    public String toString() {
        return "Paper{" +
                "id=" + id +
                ", uniqueSubmissionId='" + uniqueSubmissionId + '\'' +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", authors=" + authors.size() +
                ", reviews=" + reviews.size() +
                '}';
    }
}