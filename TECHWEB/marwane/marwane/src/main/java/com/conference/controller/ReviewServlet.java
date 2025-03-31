package com.conference.controller;

import com.conference.dao.ReviewDAO;
import com.conference.dao.PaperDAO;
import com.conference.dao.CommitteeDAO;
import com.conference.model.Review;
import com.conference.model.Paper;
import com.conference.model.User;
import com.conference.model.Committee;
import com.conference.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Date;

@WebServlet("/review/*")
public class ReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final PaperDAO paperDAO = new PaperDAO();
    private final CommitteeDAO committeeDAO = new CommitteeDAO();

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
            if ("/assignments".equals(pathInfo)) {
                // Show reviewer's assigned papers
                User user = (User) session.getAttribute("user");
                List<Review> reviews = reviewDAO.getReviewsByReviewer(user.getId());
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/WEB-INF/views/review/assignments.jsp").forward(request, response);
            } else if ("/assign".equals(pathInfo)) {
                // Show paper assignment form (for committee chairs)
                if ("COMMITTEE_MEMBER".equals(session.getAttribute("role"))) {
                    int paperId = Integer.parseInt(request.getParameter("paperId"));
                    Paper paper = paperDAO.getPaper(paperId);
                    request.setAttribute("paper", paper);
                    request.getRequestDispatcher("/WEB-INF/views/review/assign.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
            } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
                // Show review form or review details
                int reviewId = Integer.parseInt(pathInfo.substring(1));
                Review review = reviewDAO.getReview(reviewId);
                
                if (review != null) {
                    request.setAttribute("review", review);
                    Paper paper = paperDAO.getPaper(review.getPaperId());
                    request.setAttribute("paper", paper);
                    request.getRequestDispatcher("/WEB-INF/views/review/form.jsp").forward(request, response);
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
            if ("assign".equals(action)) {
                handleReviewAssignment(request, response);
            } else if ("submit".equals(action)) {
                handleReviewSubmission(request, response);
            } else if ("finalize".equals(action)) {
                handleReviewFinalization(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleReviewAssignment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Verify user is committee chair
        HttpSession session = request.getSession(false);
        if (!"COMMITTEE_MEMBER".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int paperId = Integer.parseInt(request.getParameter("paperId"));
        int reviewerId = Integer.parseInt(request.getParameter("reviewerId"));
        String expertise = request.getParameter("expertise");

        // Check if reviewer has already been assigned
        if (reviewDAO.hasReviewerReviewedPaper(reviewerId, paperId)) {
            request.setAttribute("error", "Reviewer has already been assigned to this paper");
            request.getRequestDispatcher("/WEB-INF/views/review/assign.jsp").forward(request, response);
            return;
        }

        // Create new review assignment
        Review review = new Review(paperId, reviewerId);
        review.setExpertise(expertise);
        int reviewId = reviewDAO.createReview(review);

        // Update reviewer's statistics
        Committee.Member member = committeeDAO.getCommitteeByConferenceAndType(
            paperDAO.getPaper(paperId).getConferenceId(), 
            "PC"
        ).getMemberById(reviewerId);
        
        if (member != null) {
            member.setAssignedPapers(member.getAssignedPapers() + 1);
            committeeDAO.updateMemberStatistics(
                member.getId(), 
                member.getAssignedPapers(), 
                member.getCompletedReviews()
            );
        }

        // Send email notification to reviewer
        User reviewer = (User) request.getAttribute("reviewer");
        Paper paper = paperDAO.getPaper(paperId);
        EmailUtil.sendReviewAssignment(
            reviewer.getEmail(),
            paper.getTitle(),
            paper.getTitle() 
            // ntestiw banli had getReviewDeadline aslan makaynach
          //  paper.getReviewDeadline().toString()
        );

        response.sendRedirect(request.getContextPath() + "/paper/" + paperId);
    }

    private void handleReviewSubmission(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        Review review = reviewDAO.getReview(reviewId);
        
        if (review != null) {
            // Update review details
            review.setScore(Integer.parseInt(request.getParameter("score")));
            review.setComments(request.getParameter("comments"));
            review.setConfidentialComments(request.getParameter("confidentialComments"));
            review.setDecision(request.getParameter("decision"));
            review.setReviewDate(new Date());
            review.setCompleted(true);

            // Update review in database
            reviewDAO.updateReview(review);

            // Update reviewer's statistics
            Committee.Member member = committeeDAO.getCommitteeByConferenceAndType(
                paperDAO.getPaper(review.getPaperId()).getConferenceId(), 
                "PC"
            ).getMemberById(review.getReviewerId());
            
            if (member != null) {
                member.setCompletedReviews(member.getCompletedReviews() + 1);
                committeeDAO.updateMemberStatistics(
                    member.getId(), 
                    member.getAssignedPapers(), 
                    member.getCompletedReviews()
                );
            }

            response.sendRedirect(request.getContextPath() + "/review/assignments");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleReviewFinalization(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Verify user is committee chair
        HttpSession session = request.getSession(false);
        if (!"COMMITTEE_MEMBER".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int paperId = Integer.parseInt(request.getParameter("paperId"));
        String finalDecision = request.getParameter("finalDecision");
        
        // Update paper status
        Paper paper = paperDAO.getPaper(paperId);
        if (paper != null) {
            paper.setStatus(finalDecision);
            paperDAO.updatePaper(paper);

            // Send notification email to corresponding author
            for (Paper.Author author : paper.getAuthors()) {
                if (author.isCorresponding()) {
                    EmailUtil.sendAcceptanceNotification(
                        author.getEmail(),
                        paper.getTitle(),
                        "ACCEPTED".equals(finalDecision)
                    );
                    break;
                }
            }

            response.sendRedirect(request.getContextPath() + "/paper/" + paperId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}