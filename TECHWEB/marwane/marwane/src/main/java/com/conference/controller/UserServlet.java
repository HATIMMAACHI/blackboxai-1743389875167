package com.conference.controller;

import com.conference.dao.UserDAO;
import com.conference.model.User;
import com.conference.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/login".equals(pathInfo)) {
                // Show login page
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            } else if ("/register".equals(pathInfo)) {
                // Show registration page
                request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
            } else if ("/profile".equals(pathInfo)) {
                // Show user profile
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("user") != null) {
                    User user = (User) session.getAttribute("user");
                    request.setAttribute("user", userDAO.getUser(user.getId()));
                    request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/login");
                }
            } else if ("/logout".equals(pathInfo)) {
                // Handle logout
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/user/login");
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
        String pathInfo = request.getPathInfo();
        
        try {
            if ("/login".equals(pathInfo)) {
                handleLogin(request, response);
            } else if ("/register".equals(pathInfo)) {
                handleRegistration(request, response);
            } else if ("/profile".equals(pathInfo)) {
                handleProfileUpdate(request, response);
            } else if ("/change-password".equals(pathInfo)) {
                handlePasswordChange(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = userDAO.authenticateUser(username, password);
        
        if (user != null) {
            // Create session and store user
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            
            // Redirect based on role
            String targetUrl = determineTargetUrl(user.getRole());
            response.sendRedirect(request.getContextPath() + targetUrl);
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Validate username and email uniqueness
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User user = new User();
        user.setUsername(username);
        user.setPassword(request.getParameter("password"));
        user.setEmail(email);
        user.setFirstName(request.getParameter("firstName"));
        user.setLastName(request.getParameter("lastName"));
        user.setRole(request.getParameter("role"));
        user.setAffiliation(request.getParameter("affiliation"));
        user.setAcademicBackground(request.getParameter("academicBackground"));
        
        // Save user
        int userId = userDAO.createUser(user);
        user.setId(userId);
        
        // Send welcome email
        try {
            EmailUtil.sendHtmlEmail(
                user.getEmail(),
                "Welcome to Conference Management System",
                generateWelcomeEmailContent(user)
            );
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to send welcome email", e);
        }
        
        // Create session and redirect
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());
        
        String targetUrl = determineTargetUrl(user.getRole());
        response.sendRedirect(request.getContextPath() + targetUrl);
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            User user = userDAO.getUser(currentUser.getId());
            
            if (user != null) {
                // Update user information
                user.setEmail(request.getParameter("email"));
                user.setFirstName(request.getParameter("firstName"));
                user.setLastName(request.getParameter("lastName"));
                user.setAffiliation(request.getParameter("affiliation"));
                user.setAcademicBackground(request.getParameter("academicBackground"));
                
                userDAO.updateUser(user);
                session.setAttribute("user", user);
                
                request.setAttribute("success", "Profile updated successfully");
                request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login");
        }
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            // Verify current password
            User user = userDAO.authenticateUser(currentUser.getUsername(), currentPassword);
            
            if (user != null) {
                userDAO.changePassword(user.getId(), newPassword);
                request.setAttribute("success", "Password changed successfully");
            } else {
                request.setAttribute("error", "Current password is incorrect");
            }
            
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login");
        }
    }

    private String determineTargetUrl(String role) {
        switch (role) {
            case "PRESIDENT":
                return "/conference/manage";
            case "COMMITTEE_MEMBER":
                return "/committee/dashboard";
            case "AUTHOR":
                return "/paper/submissions";
            case "REVIEWER":
                return "/review/assignments";
            default:
                return "/home";
        }
    }

    private String generateWelcomeEmailContent(User user) {
        return String.format(
            "<html><body>" +
            "<h2>Welcome to Conference Management System</h2>" +
            "<p>Dear %s %s,</p>" +
            "<p>Thank you for registering with our Conference Management System. " +
            "Your account has been successfully created with the following details:</p>" +
            "<ul>" +
            "<li>Username: %s</li>" +
            "<li>Role: %s</li>" +
            "</ul>" +
            "<p>You can now log in to your account and start using our system.</p>" +
            "<p>Best regards,<br>Conference Management Team</p>" +
            "</body></html>",
            user.getFirstName(),
            user.getLastName(),
            user.getUsername(),
            user.getRole()
        );
    }
}