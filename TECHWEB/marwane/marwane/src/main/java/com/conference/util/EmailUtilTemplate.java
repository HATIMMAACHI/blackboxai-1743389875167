package com.conference.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtilTemplate {
    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    // Email configuration - Replace with your values
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "your-email@example.com";
    private static final String EMAIL_PASSWORD = "your-app-specific-password";

    // Rest of the EmailUtil.java content remains the same
    // Copy the implementation from the original file
}