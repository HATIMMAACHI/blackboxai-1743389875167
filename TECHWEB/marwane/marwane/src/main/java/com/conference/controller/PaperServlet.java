package com.conference.controller;

import com.conference.dao.PaperDAO;
import com.conference.dao.ReviewDAO;
import com.conference.model.Paper;
import com.conference.model.Review;
import com.conference.model.User;
import com.conference.util.EmailUtil;
import com.conference.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/paper/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class PaperServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PaperServlet.class.getName());
    private final PaperDAO paperDAO = new PaperDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            if ("/submit".equals(pathInfo)) {
                // Show paper submission form
                request.getRequestDispatcher("/WEB-INF/views/paper/submit.jsp").forward(request, response);
            } else if ("/submissions".equals(pathInfo)) {
                // List user's submissions
                User user = (User) session.getAttribute("user");
                List<Paper> papers = paperDAO.getPapersByConference(user.getId());
                request.setAttribute("papers", papers);
                request.getRequestDispatcher("/WEB-INF/views/paper/list.jsp").forward(request, response);
            } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
                // Show paper details
                int paperId = Integer.parseInt(pathInfo.substring(1));
                Paper paper = paperDAO.getPaper(paperId);
                
                if (paper != null) {
                    request.setAttribute("paper", paper);
                    List<Review> reviews = reviewDAO.getReviewsByPaper(paperId);
                    request.setAttribute("reviews", reviews);
                    request.getRequestDispatcher("/WEB-INF/views/paper/details.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            if ("submit".equals(action)) {
                handlePaperSubmission(request, response);
            } else if ("update".equals(action)) {
                handlePaperUpdate(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handlePaperSubmission(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Create new paper object
        Paper paper = new Paper();
        paper.setConferenceId(Integer.parseInt(request.getParameter("conferenceId")));
        paper.setTitle(request.getParameter("title"));
        paper.setSummary(request.getParameter("summary"));
        paper.setKeywords(request.getParameter("keywords"));
        paper.setStatus("SUBMITTED");

        // Handle authors
        List<Paper.Author> authors = new ArrayList<>();
        String[] authorNames = request.getParameterValues("authorName");
        String[] authorAffiliations = request.getParameterValues("authorAffiliation");
        String[] authorEmails = request.getParameterValues("authorEmail");
        String correspondingAuthor = request.getParameter("correspondingAuthor");

        if (authorNames != null) {
            for (int i = 0; i < authorNames.length; i++) {
                Paper.Author author = new Paper.Author(
                    authorNames[i],
                    authorAffiliations[i],
                    authorEmails[i],
                    String.valueOf(i).equals(correspondingAuthor)
                );
                authors.add(author);
            }
        }
        paper.setAuthors(authors);

        // Handle file upload
        Part filePart = request.getPart("paperFile");
        if (filePart != null && filePart.getSize() > 0) {
            // Generate unique submission ID first
            int paperId = paperDAO.submitPaper(paper);
            paper.setId(paperId);
            
            // Upload file with the paper ID
            String filePath = FileUploadUtil.uploadPaper(filePart, paper.getUniqueSubmissionId());
            paper.setFilePath(filePath);
            
            // Update paper with file path
            paperDAO.updatePaper(paper);

            // Send confirmation email to corresponding author
            for (Paper.Author author : authors) {
                if (author.isCorresponding()) {
                    EmailUtil.sendSubmissionConfirmation(
                        author.getEmail(),
                        paper.getTitle(),
                        paper.getUniqueSubmissionId()
                    );
                    break;
                }
            }

            response.sendRedirect(request.getContextPath() + "/paper/" + paperId);
        } else {
            request.setAttribute("error", "Paper file is required");
            request.getRequestDispatcher("/WEB-INF/views/paper/submit.jsp").forward(request, response);
        }
    }

    private void handlePaperUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int paperId = Integer.parseInt(request.getParameter("paperId"));
        Paper paper = paperDAO.getPaper(paperId);
        
        if (paper != null) {
            // Check if update is allowed (before deadline)
            if (!"SUBMITTED".equals(paper.getStatus())) {
                request.setAttribute("error", "Paper cannot be updated after review process has started");
                request.getRequestDispatcher("/WEB-INF/views/paper/details.jsp").forward(request, response);
                return;
            }

            // Update paper details
            paper.setTitle(request.getParameter("title"));
            paper.setSummary(request.getParameter("summary"));
            paper.setKeywords(request.getParameter("keywords"));

            // Handle authors update
            List<Paper.Author> authors = new ArrayList<>();
            String[] authorNames = request.getParameterValues("authorName");
            String[] authorAffiliations = request.getParameterValues("authorAffiliation");
            String[] authorEmails = request.getParameterValues("authorEmail");
            String correspondingAuthor = request.getParameter("correspondingAuthor");

            if (authorNames != null) {
                for (int i = 0; i < authorNames.length; i++) {
                    Paper.Author author = new Paper.Author(
                        authorNames[i],
                        authorAffiliations[i],
                        authorEmails[i],
                        String.valueOf(i).equals(correspondingAuthor)
                    );
                    authors.add(author);
                }
            }
            paper.setAuthors(authors);

            // Handle file update if provided
            Part filePart = request.getPart("paperFile");
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old file
                if (paper.getFilePath() != null) {
                    FileUploadUtil.deleteFile(paper.getFilePath());
                }
                
                // Upload new file
                String filePath = FileUploadUtil.uploadPaper(filePart, paper.getUniqueSubmissionId());
                paper.setFilePath(filePath);
            }

            // Update paper
            paperDAO.updatePaper(paper);

            // Send update confirmation email
            for (Paper.Author author : authors) {
                if (author.isCorresponding()) {
                    EmailUtil.sendHtmlEmail(
                        author.getEmail(),
                        "Paper Update Confirmation",
                        generateUpdateConfirmationEmail(paper)
                    );
                    break;
                }
            }

            response.sendRedirect(request.getContextPath() + "/paper/" + paperId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private String generateUpdateConfirmationEmail(Paper paper) {
        return String.format(
            "<html><body>" +
            "<h2>Paper Update Confirmation</h2>" +
            "<p>Your paper has been successfully updated:</p>" +
            "<ul>" +
            "<li>Title: %s</li>" +
            "<li>Submission ID: %s</li>" +
            "<li>Status: %s</li>" +
            "</ul>" +
            "<p>You can view your paper details by logging into the system.</p>" +
            "<p>Best regards,<br>Conference Management Team</p>" +
            "</body></html>",
            paper.getTitle(),
            paper.getUniqueSubmissionId(),
            paper.getStatus()
        );
    }
}