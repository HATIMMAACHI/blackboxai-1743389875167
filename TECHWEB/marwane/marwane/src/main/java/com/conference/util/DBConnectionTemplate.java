package com.conference.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnectionTemplate {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    // Database configuration - Replace with your values
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/conference_db";
    private static final String USERNAME = "your_username";
    private static final String PASSWORD = "your_password";
    
    // Rest of the DBConnection.java content remains the same
    // Copy the implementation from the original file
} 