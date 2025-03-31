package com.conference.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

public class CharacterEncodingFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(CharacterEncodingFilter.class.getName());
    
    private String encoding;
    private boolean forceEncoding = true;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        encoding = filterConfig.getInitParameter("encoding");
        String force = filterConfig.getInitParameter("forceEncoding");
        
        if (force != null) {
            forceEncoding = Boolean.parseBoolean(force);
        }

        if (encoding == null) {
            encoding = "UTF-8";
        }
        
        LOGGER.info("CharacterEncodingFilter initialized with encoding: " + encoding + 
                   ", forceEncoding: " + forceEncoding);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Set character encoding for request if not already set or if forcing
        if (forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
        }

        // Set character encoding for response
        response.setCharacterEncoding(encoding);

        // Set content type for HTML responses if not already set
        if (httpResponse.getContentType() == null) {
            httpResponse.setContentType("text/html; charset=" + encoding);
        }

        // Add security headers
        addSecurityHeaders(httpResponse);

        try {
            chain.doFilter(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error in CharacterEncodingFilter: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
        encoding = null;
    }

    /**
     * Add security headers to prevent XSS, clickjacking, etc.
     */
    private void addSecurityHeaders(HttpServletResponse response) {
        // Prevent clickjacking
        response.setHeader("X-Frame-Options", "DENY");
        
        // Enable XSS protection
        response.setHeader("X-XSS-Protection", "1; mode=block");
        
        // Prevent MIME type sniffing
        response.setHeader("X-Content-Type-Options", "nosniff");
        
        // Enable HSTS (HTTP Strict Transport Security)
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        
        // Content Security Policy
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.tailwindcss.com https://cdnjs.cloudflare.com; " +
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com; " +
            "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; " +
            "img-src 'self' data: https:; " +
            "connect-src 'self'"
        );
        
        // Referrer Policy
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // Permissions Policy
        response.setHeader("Permissions-Policy", 
            "geolocation=(), " +
            "microphone=(), " +
            "camera=(), " +
            "payment=(), " +
            "usb=(), " +
            "magnetometer=(), " +
            "accelerometer=(), " +
            "gyroscope=()"
        );
    }
}