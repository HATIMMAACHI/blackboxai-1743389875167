<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Internal Server Error</title>
    
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
                <i class="fas fa-exclamation-triangle text-red-600 text-6xl mb-4"></i>
                
                <h1 class="text-9xl font-bold text-red-600">500</h1>
                
                <h2 class="mt-4 text-3xl font-bold tracking-tight text-gray-900">
                    Internal Server Error
                </h2>
                
                <p class="mt-4 text-base text-gray-600">
                    Oops! Something went wrong on our end. Our team has been notified and is working 
                    to fix the issue. Please try again later.
                </p>
                
                <div class="mt-8 space-y-4">
                    <button onclick="window.location.reload()" 
                            class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                        <i class="fas fa-sync-alt mr-2"></i>
                        Try Again
                    </button>
                    
                    <div class="flex justify-center">
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                            <i class="fas fa-home mr-2"></i>
                            Return to Homepage
                        </a>
                    </div>
                </div>
                
                <div class="mt-8 text-center text-sm text-gray-500">
                    <p>
                        Error ID: <%= System.currentTimeMillis() %><br>
                        If this problem persists, please 
                        <a href="#" class="text-red-600 hover:text-red-500">contact support</a>.
                    </p>
                </div>

                <!-- Technical Details (only shown in development) -->
                <% if (request.getAttribute("javax.servlet.error.exception") != null) { %>
                    <div class="mt-8 p-4 bg-gray-100 rounded-lg">
                        <div class="text-left text-xs font-mono overflow-auto">
                            <strong>Error Details:</strong><br>
                            <%= exception.getMessage() %>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Error Logging Script -->
    <script>
        // Log the error for monitoring
        console.error('500 error occurred at:', window.location.href);
        
        // Optional: Send error details to monitoring service
        const errorDetails = {
            timestamp: new Date().toISOString(),
            url: window.location.href,
            errorId: '<%= System.currentTimeMillis() %>',
            userAgent: navigator.userAgent
        };
        
        // You can implement your error reporting logic here
        // Example: sendErrorToMonitoring(errorDetails);
    </script>
</body>
</html>