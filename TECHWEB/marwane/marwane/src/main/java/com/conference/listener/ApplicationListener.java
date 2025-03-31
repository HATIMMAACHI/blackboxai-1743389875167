package com.conference.listener;

import com.conference.util.DBConnection;
import com.conference.util.FileUploadUtil;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class ApplicationListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(ApplicationListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Initializing Conference Management System...");
        ServletContext context = sce.getServletContext();

        try {
            // Initialize database and create tables if they don't exist
            initializeDatabase();

            // Initialize upload directories
            initializeUploadDirectories(context);

            // Set application-wide attributes
            setApplicationAttributes(context);

            LOGGER.info("Conference Management System initialized successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize application", e);
            throw new RuntimeException("Application initialization failed", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Shutting down Conference Management System...");
        try {
            // Close database connections
            DBConnection.closeConnection();

            // Perform any other cleanup
            cleanupResources();

            LOGGER.info("Conference Management System shut down successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during application shutdown", e);
        }
    }

    private void initializeDatabase() throws SQLException {
        LOGGER.info("Initializing database...");
        try {
            // Initialize database tables
            DBConnection.initializeDatabase();
            LOGGER.info("Database initialized successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database initialization failed", e);
            throw e;
        }
    }

    private void initializeUploadDirectories(ServletContext context) {
        LOGGER.info("Initializing upload directories...");

        // Get upload directory path from context parameters
        String uploadDirPath = context.getInitParameter("uploadDirectory");
        if (uploadDirPath == null) {
            uploadDirPath = context.getRealPath("/uploads");
        }

        // Create main upload directory
        File uploadDir = new File(uploadDirPath);
        createDirectory(uploadDir);

        // Create subdirectories for different types of uploads
        File paperDir = new File(uploadDir, "papers");
        File logoDir = new File(uploadDir, "logos");
        File tempDir = new File(uploadDir, "temp");

        createDirectory(paperDir);
        createDirectory(logoDir);
        createDirectory(tempDir);

        // Store directory paths in context
        context.setAttribute("UPLOAD_DIR", uploadDirPath);
        context.setAttribute("PAPER_UPLOAD_DIR", paperDir.getAbsolutePath());
        context.setAttribute("LOGO_UPLOAD_DIR", logoDir.getAbsolutePath());
        context.setAttribute("TEMP_DIR", tempDir.getAbsolutePath());

        LOGGER.info("Upload directories initialized successfully.");
    }

    private void createDirectory(File dir) {
        if (!dir.exists()) {
            if (dir.mkdirs()) {
                LOGGER.info("Created directory: " + dir.getAbsolutePath());
            } else {
                LOGGER.severe("Failed to create directory: " + dir.getAbsolutePath());
                throw new RuntimeException("Failed to create directory: " + dir.getAbsolutePath());
            }
        }
    }

    private void setApplicationAttributes(ServletContext context) {
        LOGGER.info("Setting application attributes...");

        // Set application version
        context.setAttribute("APP_VERSION", "1.0.0");

        // Set maximum file upload sizes (in bytes)
        context.setAttribute("MAX_FILE_SIZE", 10 * 1024 * 1024); // 10MB
        context.setAttribute("MAX_REQUEST_SIZE", 20 * 1024 * 1024); // 20MB

        // Set allowed file types
        context.setAttribute("ALLOWED_PAPER_TYPES", "application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        context.setAttribute("ALLOWED_IMAGE_TYPES", "image/jpeg,image/png");

        // Set email configuration (these should be in a properties file in production)
        context.setAttribute("SMTP_HOST", "smtp.gmail.com");
        context.setAttribute("SMTP_PORT", "587");
        context.setAttribute("MAIL_USERNAME", "conference.system@example.com");
        // Password should be stored securely in production
        context.setAttribute("MAIL_PASSWORD", "your-app-specific-password");

        // Set application URLs
        String contextPath = context.getContextPath();
        context.setAttribute("APP_URL", contextPath);
        context.setAttribute("LOGIN_URL", contextPath + "/user/login");
        context.setAttribute("REGISTER_URL", contextPath + "/user/register");

        LOGGER.info("Application attributes set successfully.");
    }

    private void cleanupResources() {
        LOGGER.info("Cleaning up application resources...");

        try {
            // Clean up temporary files
            File tempDir = new File(System.getProperty("java.io.tmpdir"), "conference-system");
            if (tempDir.exists()) {
                deleteDirectory(tempDir);
            }

            // Perform any other necessary cleanup
            
            LOGGER.info("Resource cleanup completed successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error during resource cleanup", e);
        }
    }

    private void deleteDirectory(File directory) {
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteDirectory(file);
                } else {
                    if (!file.delete()) {
                        LOGGER.warning("Failed to delete file: " + file.getAbsolutePath());
                    }
                }
            }
        }
        if (!directory.delete()) {
            LOGGER.warning("Failed to delete directory: " + directory.getAbsolutePath());
        }
    }
}