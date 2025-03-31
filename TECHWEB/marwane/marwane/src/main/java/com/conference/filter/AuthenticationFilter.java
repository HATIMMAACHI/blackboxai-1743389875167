package com.conference.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

public class AuthenticationFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());
    
    // URLs that can be accessed without authentication
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/user/login",
        "/user/register",
        "/index.jsp",
        "/css/",
        "/js/",
        "/images/"
    );

    // Role-based access control mappings
    private static final List<String> PRESIDENT_URLS = Arrays.asList(
        "/conference/create",
        "/conference/manage",
        "/committee/manage"
    );

    private static final List<String> COMMITTEE_URLS = Arrays.asList(
        "/review/assign",
        "/review/finalize",
        "/committee/statistics"
    );

    private static final List<String> AUTHOR_URLS = Arrays.asList(
        "/paper/submit",
        "/paper/submissions"
    );

    private static final List<String> REVIEWER_URLS = Arrays.asList(
        "/review/assignments",
        "/review/submit"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativeURI = requestURI.substring(contextPath.length());

        // Allow access to public URLs
        if (isPublicResource(relativeURI)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is authenticated
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Store the requested URL for redirect after login
            httpRequest.getSession().setAttribute("requestedURL", requestURI);
            httpResponse.sendRedirect(contextPath + "/user/login");
            return;
        }

        // Check role-based access
        String userRole = (String) session.getAttribute("role");
        if (!hasAccess(relativeURI, userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // If all checks pass, continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }

    private boolean isPublicResource(String uri) {
        return PUBLIC_URLS.stream().anyMatch(uri::startsWith) ||
               uri.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico)$");
    }

    private boolean hasAccess(String uri, String role) {
        if (role == null) {
            return false;
        }

        switch (role) {
            case "PRESIDENT":
                return true; // President has access to everything
            
            case "COMMITTEE_MEMBER":
                return !PRESIDENT_URLS.stream().anyMatch(uri::startsWith) &&
                       !AUTHOR_URLS.stream().anyMatch(uri::startsWith);
            
            case "AUTHOR":
                return AUTHOR_URLS.stream().anyMatch(uri::startsWith) ||
                       uri.startsWith("/conference/view") ||
                       uri.startsWith("/paper/view");
            
            case "REVIEWER":
                return REVIEWER_URLS.stream().anyMatch(uri::startsWith) ||
                       uri.startsWith("/conference/view") ||
                       uri.startsWith("/paper/view");
            
            default:
                return false;
        }
    }

    private void logAccessAttempt(String uri, String role, boolean granted) {
        LOGGER.info(String.format(
            "Access attempt - URI: %s, Role: %s, Access %s",
            uri,
            role != null ? role : "unauthenticated",
            granted ? "granted" : "denied"
        ));
    }
}