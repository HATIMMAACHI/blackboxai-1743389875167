package com.conference.controller;

import com.conference.dao.CommitteeDAO;
import com.conference.dao.UserDAO;
import com.conference.model.Committee;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/committee/*")
public class CommitteeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CommitteeServlet.class.getName());
    private final CommitteeDAO committeeDAO = new CommitteeDAO();
    private final UserDAO userDAO = new UserDAO();

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
            if ("/dashboard".equals(pathInfo)) {
                // Show committee dashboard
                User user = (User) session.getAttribute("user");
                handleDashboard(request, response, user);
            } else if ("/manage".equals(pathInfo)) {
                // Show committee management page (for conference chairs)
                if ("PRESIDENT".equals(session.getAttribute("role"))) {
                    int conferenceId = Integer.parseInt(request.getParameter("conferenceId"));
                    handleManageCommittee(request, response, conferenceId);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
            } else if ("/members".equals(pathInfo)) {
                // Show committee members list
                int committeeId = Integer.parseInt(request.getParameter("committeeId"));
                handleMembersList(request, response, committeeId);
            } else if ("/statistics".equals(pathInfo)) {
                // Show committee statistics
                int committeeId = Integer.parseInt(request.getParameter("committeeId"));
                handleStatistics(request, response, committeeId);
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
            if ("create".equals(action)) {
                handleCommitteeCreation(request, response);
            } else if ("add-member".equals(action)) {
                handleAddMember(request, response);
            } else if ("remove-member".equals(action)) {
                handleRemoveMember(request, response);
            } else if ("update-chair".equals(action)) {
                handleUpdateChair(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException, SQLException {
        // Get committees where user is a member
        Committee committees = committeeDAO.getCommitteeByConferenceAndType(
            Integer.parseInt(request.getParameter("conferenceId")), 
            request.getParameter("type")
        );
        
        request.setAttribute("committees", committees);
        request.getRequestDispatcher("/WEB-INF/views/committee/dashboard.jsp").forward(request, response);
    }

    private void handleManageCommittee(HttpServletRequest request, HttpServletResponse response, int conferenceId) 
            throws ServletException, IOException, SQLException {
        Committee sc = committeeDAO.getCommitteeByConferenceAndType(conferenceId, "SC");
        Committee pc = committeeDAO.getCommitteeByConferenceAndType(conferenceId, "PC");
        
        request.setAttribute("scientificCommittee", sc);
        request.setAttribute("programCommittee", pc);
        
        // Get available users for committee assignment
        List<User> availableUsers = userDAO.getUsersByRole("COMMITTEE_MEMBER");
        request.setAttribute("availableUsers", availableUsers);
        
        request.getRequestDispatcher("/WEB-INF/views/committee/manage.jsp").forward(request, response);
    }

    private void handleMembersList(HttpServletRequest request, HttpServletResponse response, int committeeId) 
            throws ServletException, IOException, SQLException {
        Committee committee = committeeDAO.getCommittee(committeeId);
        request.setAttribute("committee", committee);
        request.getRequestDispatcher("/WEB-INF/views/committee/members.jsp").forward(request, response);
    }

    private void handleStatistics(HttpServletRequest request, HttpServletResponse response, int committeeId) 
            throws ServletException, IOException, SQLException {
        Committee committee = committeeDAO.getCommittee(committeeId);
        request.setAttribute("committee", committee);
        request.setAttribute("participationRate", committee.getOverallParticipationRate());
        request.getRequestDispatcher("/WEB-INF/views/committee/statistics.jsp").forward(request, response);
    }

    private void handleCommitteeCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        // Verify user is conference chair
        if (!"PRESIDENT".equals(request.getSession().getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Committee committee = new Committee();
        committee.setConferenceId(Integer.parseInt(request.getParameter("conferenceId")));
        committee.setType(request.getParameter("type"));

        // Set chair if specified
        String chairId = request.getParameter("chairId");
        if (chairId != null && !chairId.isEmpty()) {
            Committee.Member chair = new Committee.Member(
                Integer.parseInt(chairId),
                "CHAIR"
            );
            committee.setChair(chair);
        }

        // Create committee
        int committeeId = committeeDAO.createCommittee(committee);

        // Send notification to chair if assigned
        if (committee.getChair() != null) {
            User chair = userDAO.getUser(committee.getChair().getUserId());
            EmailUtil.sendCommitteeInvitation(
                chair.getEmail(),
                request.getParameter("conferenceName"),
                "Chair"
            );
        }

        response.sendRedirect(request.getContextPath() + "/committee/manage?conferenceId=" + 
                            committee.getConferenceId());
    }

    private void handleAddMember(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int committeeId = Integer.parseInt(request.getParameter("committeeId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String expertise = request.getParameter("expertise");

        Committee committee = committeeDAO.getCommittee(committeeId);
        if (committee != null) {
            // Create new member
            Committee.Member member = new Committee.Member(userId, "MEMBER");
            member.setExpertise(expertise);
            committee.addMember(member);

            // Update committee
            committeeDAO.updateCommittee(committee);

            // Send invitation email
            User user = userDAO.getUser(userId);
            EmailUtil.sendCommitteeInvitation(
                user.getEmail(),
                request.getParameter("conferenceName"),
                "Member"
            );

            response.sendRedirect(request.getContextPath() + "/committee/members?committeeId=" + committeeId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleRemoveMember(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int committeeId = Integer.parseInt(request.getParameter("committeeId"));
        int memberId = Integer.parseInt(request.getParameter("memberId"));

        Committee committee = committeeDAO.getCommittee(committeeId);
        if (committee != null) {
            committee.removeMember(memberId);
            committeeDAO.updateCommittee(committee);
            response.sendRedirect(request.getContextPath() + "/committee/members?committeeId=" + committeeId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleUpdateChair(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int committeeId = Integer.parseInt(request.getParameter("committeeId"));
        int newChairId = Integer.parseInt(request.getParameter("newChairId"));

        Committee committee = committeeDAO.getCommittee(committeeId);
        if (committee != null) {
            // Create new chair member
            Committee.Member newChair = new Committee.Member(newChairId, "CHAIR");
            committee.setChair(newChair);

            // Update committee
            committeeDAO.updateCommittee(committee);

            // Send notification to new chair
            User chair = userDAO.getUser(newChairId);
            EmailUtil.sendCommitteeInvitation(
                chair.getEmail(),
                request.getParameter("conferenceName"),
                "Chair"
            );

            response.sendRedirect(request.getContextPath() + "/committee/manage?conferenceId=" + 
                                committee.getConferenceId());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}