package com.conference.controller;

import com.conference.dao.ConferenceDAO;
import com.conference.model.Conference;
import com.conference.util.FileUploadUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/conference/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ConferenceServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ConferenceServlet.class.getName());
    private final ConferenceDAO conferenceDAO = new ConferenceDAO();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // List all conferences
                List<Conference> conferences = conferenceDAO.getAllConferences();
                request.setAttribute("conferences", conferences);
                request.getRequestDispatcher("/WEB-INF/views/conference/list.jsp").forward(request, response);
            } else {
                // Get specific conference
                int conferenceId = Integer.parseInt(pathInfo.substring(1));
                Conference conference = conferenceDAO.getConference(conferenceId);
                
                if (conference != null) {
                    request.setAttribute("conference", conference);
                    request.getRequestDispatcher("/WEB-INF/views/conference/details.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createConference(request, response);
            } else if ("update".equals(action)) {
                updateConference(request, response);
            } else if ("extend-deadline".equals(action)) {
                extendSubmissionDeadline(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (ParseException e) {
            LOGGER.log(Level.SEVERE, "Date parsing error", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void createConference(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException, ParseException {
        // Create new conference object
        Conference conference = new Conference();
        
        // Set basic information
        conference.setName(request.getParameter("name"));
        conference.setAcronym(request.getParameter("acronym"));
        conference.setWebsite(request.getParameter("website"));
        conference.setType(request.getParameter("type"));
        conference.setLocation(request.getParameter("location"));
        conference.setThematic(request.getParameter("thematic"));
        
        // Parse and set dates
        conference.setStartDate(dateFormat.parse(request.getParameter("startDate")));
        conference.setEndDate(dateFormat.parse(request.getParameter("endDate")));
        conference.setSubmissionDeadline(dateFormat.parse(request.getParameter("submissionDeadline")));
        conference.setReviewDeadline(dateFormat.parse(request.getParameter("reviewDeadline")));
        conference.setNotificationDeadline(dateFormat.parse(request.getParameter("notificationDeadline")));
        conference.setCameraReadyDeadline(dateFormat.parse(request.getParameter("cameraReadyDeadline")));
        
        // Handle topics
        String[] topics = request.getParameterValues("topics");
        if (topics != null) {
            conference.setTopics(Arrays.asList(topics));
        }
        
        // Handle logo upload
        Part logoPart = request.getPart("logo");
        if (logoPart != null && logoPart.getSize() > 0) {
            String logoPath = FileUploadUtil.uploadLogo(logoPart, 0); // 0 as conference ID not yet created
            conference.setLogoPath(logoPath);
        }
        
        // Save conference
        int conferenceId = conferenceDAO.createConference(conference);
        
        // If logo was uploaded, update its path with the new conference ID
        if (conference.getLogoPath() != null) {
            Part logoPartUpdate = request.getPart("logo");
            String newLogoPath = FileUploadUtil.uploadLogo(logoPartUpdate, conferenceId);
            conference.setLogoPath(newLogoPath);
            conference.setId(conferenceId);
            conferenceDAO.updateConference(conference);
        }
        
        // Redirect to the new conference page
        response.sendRedirect(request.getContextPath() + "/conference/" + conferenceId);
    }

    private void updateConference(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException, ParseException {
        int conferenceId = Integer.parseInt(request.getParameter("id"));
        Conference conference = conferenceDAO.getConference(conferenceId);
        
        if (conference != null) {
            // Update basic information
            conference.setName(request.getParameter("name"));
            conference.setAcronym(request.getParameter("acronym"));
            conference.setWebsite(request.getParameter("website"));
            conference.setType(request.getParameter("type"));
            conference.setLocation(request.getParameter("location"));
            conference.setThematic(request.getParameter("thematic"));
            
            // Update dates
            conference.setStartDate(dateFormat.parse(request.getParameter("startDate")));
            conference.setEndDate(dateFormat.parse(request.getParameter("endDate")));
            conference.setSubmissionDeadline(dateFormat.parse(request.getParameter("submissionDeadline")));
            conference.setReviewDeadline(dateFormat.parse(request.getParameter("reviewDeadline")));
            conference.setNotificationDeadline(dateFormat.parse(request.getParameter("notificationDeadline")));
            conference.setCameraReadyDeadline(dateFormat.parse(request.getParameter("cameraReadyDeadline")));
            
            // Update topics
            String[] topics = request.getParameterValues("topics");
            if (topics != null) {
                conference.setTopics(Arrays.asList(topics));
            }
            
            // Handle logo update
            Part logoPart = request.getPart("logo");
            if (logoPart != null && logoPart.getSize() > 0) {
                // Delete old logo if exists
                if (conference.getLogoPath() != null) {
                    FileUploadUtil.deleteFile(conference.getLogoPath());
                }
                // Upload new logo
                String logoPath = FileUploadUtil.uploadLogo(logoPart, conferenceId);
                conference.setLogoPath(logoPath);
            }
            
            // Update conference
            conferenceDAO.updateConference(conference);
            
            // Redirect back to conference page
            response.sendRedirect(request.getContextPath() + "/conference/" + conferenceId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void extendSubmissionDeadline(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ParseException, ServletException {
        int conferenceId = Integer.parseInt(request.getParameter("id"));
        Date newDeadline = dateFormat.parse(request.getParameter("newDeadline"));
        
        Conference conference = conferenceDAO.getConference(conferenceId);
        if (conference != null) {
            // Validate that new deadline is after current deadline
            if (newDeadline.after(conference.getSubmissionDeadline())) {
                conferenceDAO.updateSubmissionDeadline(conferenceId,(Date) newDeadline);
                response.sendRedirect(request.getContextPath() + "/conference/" + conferenceId);
            } else {
                request.setAttribute("error", "New deadline must be after current deadline");
                request.getRequestDispatcher("/WEB-INF/views/conference/details.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int conferenceId = Integer.parseInt(request.getPathInfo().substring(1));
            Conference conference = conferenceDAO.getConference(conferenceId);
            
            if (conference != null) {
                // Delete logo file if exists
                if (conference.getLogoPath() != null) {
                    FileUploadUtil.deleteFile(conference.getLogoPath());
                }
                
                // Delete conference from database
                conferenceDAO.deleteConference(conferenceId);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}