package com.conference.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    // Database configuration
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/conference_db";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";
    
    private static Connection connection = null;

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found.", e);
            throw new RuntimeException("MySQL JDBC Driver not found.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                connection = DriverManager.getConnection(URL, USERNAME, "");
                LOGGER.info("Database connection established successfully.");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Failed to establish database connection.", e);
                throw e;
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                LOGGER.info("Database connection closed successfully.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database connection.", e);
            }
        }
    }

    // Utility method to create database tables if they don't exist
    public static void initializeDatabase() {
        try (Connection conn = getConnection()) {
            String[] createTableQueries = {
                // Conferences table
                "CREATE TABLE IF NOT EXISTS conferences (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "name VARCHAR(255) NOT NULL, " +
                "acronym VARCHAR(50) NOT NULL, " +
                "website VARCHAR(255), " +
                "type VARCHAR(20) NOT NULL, " +
                "location VARCHAR(255), " +
                "start_date DATE, " +
                "end_date DATE, " +
                "thematic TEXT, " +
                "topics TEXT, " +
                "logo_path VARCHAR(255), " +
                "submission_deadline DATE, " +
                "review_deadline DATE, " +
                "notification_deadline DATE, " +
                "camera_ready_deadline DATE, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",

                // Users table
                "CREATE TABLE IF NOT EXISTS users (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "username VARCHAR(50) UNIQUE NOT NULL, " +
                "password VARCHAR(255) NOT NULL, " +
                "email VARCHAR(255) UNIQUE NOT NULL, " +
                "first_name VARCHAR(100), " +
                "last_name VARCHAR(100), " +
                "role VARCHAR(20) NOT NULL, " +
                "affiliation VARCHAR(255), " +
                "academic_background TEXT, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",

                // Committees table
                "CREATE TABLE IF NOT EXISTS committees (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "conference_id INT NOT NULL, " +
                "type VARCHAR(2) NOT NULL, " +
                "chair_id INT, " +
                "FOREIGN KEY (conference_id) REFERENCES conferences(id), " +
                "FOREIGN KEY (chair_id) REFERENCES users(id))",

                // Committee members table
                "CREATE TABLE IF NOT EXISTS committee_members (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "committee_id INT NOT NULL, " +
                "user_id INT NOT NULL, " +
                "role VARCHAR(20) NOT NULL, " +
                "assigned_papers INT DEFAULT 0, " +
                "completed_reviews INT DEFAULT 0, " +
                "expertise TEXT, " +
                "is_active BOOLEAN DEFAULT TRUE, " +
                "FOREIGN KEY (committee_id) REFERENCES committees(id), " +
                "FOREIGN KEY (user_id) REFERENCES users(id))",

                // Papers table
                "CREATE TABLE IF NOT EXISTS papers (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "unique_submission_id VARCHAR(50) UNIQUE NOT NULL, " +
                "conference_id INT NOT NULL, " +
                "title VARCHAR(255) NOT NULL, " +
                "summary TEXT, " +
                "keywords TEXT, " +
                "file_path VARCHAR(255) NOT NULL, " +
                "submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "status VARCHAR(20) NOT NULL, " +
                "FOREIGN KEY (conference_id) REFERENCES conferences(id))",

                // Paper authors table
                "CREATE TABLE IF NOT EXISTS paper_authors (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "paper_id INT NOT NULL, " +
                "name VARCHAR(255) NOT NULL, " +
                "affiliation VARCHAR(255), " +
                "email VARCHAR(255), " +
                "is_corresponding BOOLEAN DEFAULT FALSE, " +
                "FOREIGN KEY (paper_id) REFERENCES papers(id))",

                // Reviews table
                "CREATE TABLE IF NOT EXISTS reviews (" +
                "id INT PRIMARY KEY AUTO_INCREMENT, " +
                "paper_id INT NOT NULL, " +
                "reviewer_id INT NOT NULL, " +
                "score INT, " +
                "comments TEXT, " +
                "decision VARCHAR(20), " +
                "review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "confidential_comments TEXT, " +
                "is_completed BOOLEAN DEFAULT FALSE, " +
                "expertise VARCHAR(50), " +
                "FOREIGN KEY (paper_id) REFERENCES papers(id), " +
                "FOREIGN KEY (reviewer_id) REFERENCES users(id))"
            };

            for (String query : createTableQueries) {
                try {
                    conn.createStatement().execute(query);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error creating table: " + e.getMessage(), e);
                    throw e;
                }
            }
            LOGGER.info("Database tables initialized successfully.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database initialization failed.", e);
            throw new RuntimeException("Database initialization failed.", e);
        }
    }
}