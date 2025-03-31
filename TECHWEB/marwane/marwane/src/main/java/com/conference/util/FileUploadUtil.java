package com.conference.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.http.Part;

public class FileUploadUtil {
    private static final Logger LOGGER = Logger.getLogger(FileUploadUtil.class.getName());
    
    // Base upload directories
    private static final String PAPER_UPLOAD_DIR = "uploads/papers/";
    private static final String LOGO_UPLOAD_DIR = "uploads/logos/";
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    
    // Allowed file extensions
    private static final String[] ALLOWED_PAPER_EXTENSIONS = {".pdf", ".doc", ".docx"};
    private static final String[] ALLOWED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png"};

    static {
        // Create upload directories if they don't exist
        createDirectory(PAPER_UPLOAD_DIR);
        createDirectory(LOGO_UPLOAD_DIR);
    }

    private static void createDirectory(String dirPath) {
        File directory = new File(dirPath);
        if (!directory.exists()) {
            if (directory.mkdirs()) {
                LOGGER.info("Created directory: " + dirPath);
            } else {
                LOGGER.warning("Failed to create directory: " + dirPath);
            }
        }
    }

    /**
     * Upload a paper file
     * @param filePart The uploaded file part
     * @param submissionId The unique submission ID
     * @return The path where the file was saved
     * @throws IOException If file upload fails
     */
    public static String uploadPaper(Part filePart, String submissionId) throws IOException {
        validateFileSize(filePart);
        String fileName = getSubmittedFileName(filePart);
        validatePaperFileExtension(fileName);

        // Generate unique filename using submission ID
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        String newFileName = submissionId + fileExtension;
        String uploadPath = PAPER_UPLOAD_DIR + newFileName;

        saveFile(filePart, uploadPath);
        return uploadPath;
    }

    /**
     * Upload a conference logo
     * @param filePart The uploaded file part
     * @param conferenceId The conference ID
     * @return The path where the file was saved
     * @throws IOException If file upload fails
     */
    public static String uploadLogo(Part filePart, int conferenceId) throws IOException {
        validateFileSize(filePart);
        String fileName = getSubmittedFileName(filePart);
        validateImageFileExtension(fileName);

        // Generate unique filename using conference ID
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        String newFileName = "conf_" + conferenceId + "_" + UUID.randomUUID().toString() + fileExtension;
        String uploadPath = LOGO_UPLOAD_DIR + newFileName;

        saveFile(filePart, uploadPath);
        return uploadPath;
    }

    /**
     * Delete a file from the upload directory
     * @param filePath The path of the file to delete
     * @return true if deletion was successful
     */
    public static boolean deleteFile(String filePath) {
        try {
            Path path = Paths.get(filePath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to delete file: " + filePath, e);
            return false;
        }
    }

    private static void saveFile(Part filePart, String uploadPath) throws IOException {
        try (InputStream input = filePart.getInputStream()) {
            Path path = Paths.get(uploadPath);
            Files.copy(input, path, StandardCopyOption.REPLACE_EXISTING);
            LOGGER.info("File saved successfully: " + uploadPath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to save file: " + uploadPath, e);
            throw e;
        }
    }

    private static String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private static void validateFileSize(Part filePart) throws IOException {
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 10MB");
        }
    }

    private static void validatePaperFileExtension(String fileName) throws IOException {
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        boolean isValid = false;
        for (String allowedExt : ALLOWED_PAPER_EXTENSIONS) {
            if (extension.equals(allowedExt)) {
                isValid = true;
                break;
            }
        }
        if (!isValid) {
            throw new IOException("Invalid file type. Allowed types: PDF, DOC, DOCX");
        }
    }

    private static void validateImageFileExtension(String fileName) throws IOException {
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        boolean isValid = false;
        for (String allowedExt : ALLOWED_IMAGE_EXTENSIONS) {
            if (extension.equals(allowedExt)) {
                isValid = true;
                break;
            }
        }
        if (!isValid) {
            throw new IOException("Invalid image type. Allowed types: JPG, JPEG, PNG");
        }
    }

    /**
     * Get the MIME type of a file
     * @param fileName The name of the file
     * @return The MIME type
     */
    public static String getMimeType(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        switch (extension) {
            case ".pdf":
                return "application/pdf";
            case ".doc":
                return "application/msword";
            case ".docx":
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case ".jpg":
            case ".jpeg":
                return "image/jpeg";
            case ".png":
                return "image/png";
            default:
                return "application/octet-stream";
        }
    }

    /**
     * Check if a file exists
     * @param filePath The path of the file to check
     * @return true if the file exists
     */
    public static boolean fileExists(String filePath) {
        return Files.exists(Paths.get(filePath));
    }

    /**
     * Get file size in bytes
     * @param filePath The path of the file
     * @return The size of the file in bytes
     * @throws IOException If file cannot be accessed
     */
    public static long getFileSize(String filePath) throws IOException {
        return Files.size(Paths.get(filePath));
    }
}