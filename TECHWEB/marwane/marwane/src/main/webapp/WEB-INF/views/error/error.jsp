<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Conference Management System</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen flex items-center justify-center">
        <div class="max-w-md w-full px-6 py-12">
            <div class="text-center">
                <i class="fas fa-bug text-yellow-600 text-6xl mb-4"></i>
                
                <h1 class="text-4xl font-bold text-yellow-600">Oops!</h1>
                
                <h2 class="mt-4 text-3xl font-bold tracking-tight text-gray-900">
                    Something went wrong
                </h2>
                
                <p class="mt-4 text-base text-gray-600">
                    We encountered an unexpected error while processing your request. 
                    Our team has been notified and is looking into the issue.
                </p>
                
                <div class="mt-8 space-y-4">
                    <button onclick="window.history.back()" 
                            class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-yellow-700 bg-yellow-100 hover:bg-yellow-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Go Back
                    </button>
                    
                    <div class="flex justify-center">
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                            <i class="fas fa-home mr-2"></i>
                            Return to Homepage
                        </a>
                    </div>
                </div>
                
                <div class="mt-8 text-center text-sm text-gray-500">
                    <p>
                        Error ID: <%= System.currentTimeMillis() %><br>
                        Please try again later or 
                        <a href="#" class="text-yellow-600 hover:text-yellow-500">contact support</a> 
                        if the problem persists.
                    </p>
                </div>

                <!-- Technical Details (only shown in development) -->
                <% if (exception != null) { %>
                    <div class="mt-8 p-4 bg-gray-100 rounded-lg">
                        <div class="text-left text-xs font-mono overflow-auto">
                            <strong>Error Type:</strong><br>
                            <%= exception.getClass().getName() %><br><br>
                            <strong>Error Message:</strong><br>
                            <%= exception.getMessage() %><br><br>
                            <strong>Stack Trace:</strong><br>
                            <% for (StackTraceElement element : exception.getStackTrace()) { %>
                                <%= element.toString() %><br>
                            <% } %>
                        </div>
                    </div>
                <% } %>

                <!-- Request Information -->
                <div class="mt-8 text-left text-xs text-gray-500">
                    <details>
                        <summary class="cursor-pointer hover:text-gray-700">Request Details</summary>
                        <div class="mt-2 p-4 bg-gray-100 rounded-lg font-mono">
                            <strong>Request URI:</strong> <%= request.getAttribute("javax.servlet.error.request_uri") %><br>
                            <strong>Servlet Name:</strong> <%= request.getAttribute("javax.servlet.error.servlet_name") %><br>
                            <strong>Status Code:</strong> <%= request.getAttribute("javax.servlet.error.status_code") %><br>
                            <strong>Time:</strong> <%= new java.util.Date() %><br>
                            <strong>User Agent:</strong> <%= request.getHeader("User-Agent") %><br>
                        </div>
                    </details>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Logging Script -->
    <script>
        // Log the error for monitoring
        console.error('Error occurred at:', window.location.href);
        
        // Collect error details
        const errorDetails = {
            timestamp: new Date().toISOString(),
            url: window.location.href,
            errorId: '<%= System.currentTimeMillis() %>',
            userAgent: navigator.userAgent,
            errorType: '<%= exception != null ? exception.getClass().getName() : "Unknown" %>',
            errorMessage: '<%= exception != null ? exception.getMessage() : "No message available" %>'
        };
        
        // You can implement your error reporting logic here
        // Example: sendErrorToMonitoring(errorDetails);
        
        // Helper function to copy error details
        function copyErrorDetails() {
            const errorText = JSON.stringify(errorDetails, null, 2);
            navigator.clipboard.writeText(errorText)
                .then(() => alert('Error details copied to clipboard'))
                .catch(err => console.error('Failed to copy error details:', err));
        }
    </script>
</body>
</html>