<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    
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
                <i class="fas fa-exclamation-circle text-indigo-600 text-6xl mb-4"></i>
                
                <h1 class="text-9xl font-bold text-indigo-600">404</h1>
                
                <h2 class="mt-4 text-3xl font-bold tracking-tight text-gray-900">
                    Page not found
                </h2>
                
                <p class="mt-4 text-base text-gray-600">
                    Sorry, we couldn't find the page you're looking for. The page might have been removed, 
                    had its name changed, or is temporarily unavailable.
                </p>
                
                <div class="mt-8 space-y-4">
                    <button onclick="window.history.back()" 
                            class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Go Back
                    </button>
                    
                    <div class="flex justify-center">
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="fas fa-home mr-2"></i>
                            Return to Homepage
                        </a>
                    </div>
                </div>
                
                <div class="mt-8 text-center text-sm text-gray-500">
                    <p>
                        If you believe this is a mistake, please 
                        <a href="#" class="text-indigo-600 hover:text-indigo-500">contact support</a>.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Optional: Add tracking or support scripts -->
    <script>
        // Log the 404 error for monitoring
        console.error('404 error occurred at:', window.location.href);
    </script>
</body>
</html>