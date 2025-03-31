<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Conference Management System</title>
    
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
    <!-- Navigation -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <div class="flex-shrink-0 flex items-center">
                        <a href="${pageContext.request.contextPath}/">
                            <i class="fas fa-university text-indigo-600 text-2xl mr-2"></i>
                            <span class="text-xl font-semibold text-gray-800">ConferenceMS</span>
                        </a>
                    </div>
                </div>
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/user/logout" 
                       class="ml-4 text-red-600 hover:text-red-700 px-3 py-2 rounded-md text-sm font-medium">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <!-- Profile header -->
        <div class="bg-white shadow overflow-hidden sm:rounded-lg mb-6">
            <div class="px-4 py-5 sm:px-6">
                <h3 class="text-lg leading-6 font-medium text-gray-900">
                    Profile Information
                </h3>
                <p class="mt-1 max-w-2xl text-sm text-gray-500">
                    Manage your personal and academic information
                </p>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty success}">
                <div class="mx-4 mb-4 bg-green-50 border border-green-200 text-green-600 px-4 py-3 rounded relative" role="alert">
                    <span class="block sm:inline">${success}</span>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mx-4 mb-4 bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded relative" role="alert">
                    <span class="block sm:inline">${error}</span>
                </div>
            </c:if>

            <!-- Profile Form -->
            <div class="border-t border-gray-200">
                <form id="profileForm" action="${pageContext.request.contextPath}/user/profile" method="POST" class="divide-y divide-gray-200">
                    <!-- Personal Information Section -->
                    <div class="px-4 py-5 sm:p-6">
                        <div class="grid grid-cols-6 gap-6">
                            <div class="col-span-6 sm:col-span-3">
                                <label for="firstName" class="block text-sm font-medium text-gray-700">First name</label>
                                <input type="text" name="firstName" id="firstName" value="${user.firstName}"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6 sm:col-span-3">
                                <label for="lastName" class="block text-sm font-medium text-gray-700">Last name</label>
                                <input type="text" name="lastName" id="lastName" value="${user.lastName}"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6 sm:col-span-4">
                                <label for="email" class="block text-sm font-medium text-gray-700">Email address</label>
                                <input type="email" name="email" id="email" value="${user.email}"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6 sm:col-span-4">
                                <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                                <input type="text" name="username" id="username" value="${user.username}" readonly
                                    class="mt-1 bg-gray-50 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>
                        </div>
                    </div>

                    <!-- Academic Information Section -->
                    <div class="px-4 py-5 sm:p-6">
                        <div class="grid grid-cols-6 gap-6">
                            <div class="col-span-6 sm:col-span-4">
                                <label for="affiliation" class="block text-sm font-medium text-gray-700">Institution/Affiliation</label>
                                <input type="text" name="affiliation" id="affiliation" value="${user.affiliation}"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6">
                                <label for="academicBackground" class="block text-sm font-medium text-gray-700">Academic Background</label>
                                <textarea name="academicBackground" id="academicBackground" rows="3"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">${user.academicBackground}</textarea>
                            </div>

                            <div class="col-span-6 sm:col-span-3">
                                <label for="role" class="block text-sm font-medium text-gray-700">Role</label>
                                <input type="text" name="role" id="role" value="${user.role}" readonly
                                    class="mt-1 bg-gray-50 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>
                        </div>
                    </div>

                    <!-- Change Password Section -->
                    <div class="px-4 py-5 sm:p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Change Password</h3>
                        <div class="grid grid-cols-6 gap-6">
                            <div class="col-span-6 sm:col-span-4">
                                <label for="currentPassword" class="block text-sm font-medium text-gray-700">Current Password</label>
                                <input type="password" name="currentPassword" id="currentPassword"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6 sm:col-span-4">
                                <label for="newPassword" class="block text-sm font-medium text-gray-700">New Password</label>
                                <input type="password" name="newPassword" id="newPassword"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>

                            <div class="col-span-6 sm:col-span-4">
                                <label for="confirmNewPassword" class="block text-sm font-medium text-gray-700">Confirm New Password</label>
                                <input type="password" name="confirmNewPassword" id="confirmNewPassword"
                                    class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                            </div>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="px-4 py-3 bg-gray-50 text-right sm:px-6">
                        <button type="submit" name="action" value="updateProfile"
                            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Activity Section -->
        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
            <div class="px-4 py-5 sm:px-6">
                <h3 class="text-lg leading-6 font-medium text-gray-900">
                    Recent Activity
                </h3>
            </div>
            <div class="border-t border-gray-200">
                <div class="px-4 py-5 sm:p-6">
                    <c:choose>
                        <c:when test="${user.role == 'AUTHOR'}">
                            <!-- Author's submissions -->
                            <h4 class="text-md font-medium text-gray-700 mb-4">Your Submissions</h4>
                            <!-- Add submission list here -->
                        </c:when>
                        <c:when test="${user.role == 'REVIEWER'}">
                            <!-- Reviewer's assignments -->
                            <h4 class="text-md font-medium text-gray-700 mb-4">Your Review Assignments</h4>
                            <!-- Add review assignments list here -->
                        </c:when>
                        <c:when test="${user.role == 'COMMITTEE_MEMBER'}">
                            <!-- Committee member's activities -->
                            <h4 class="text-md font-medium text-gray-700 mb-4">Committee Activities</h4>
                            <!-- Add committee activities here -->
                        </c:when>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for form validation -->
    <script>
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmNewPassword = document.getElementById('confirmNewPassword').value;
            
            // If password fields are filled, validate them
            if (newPassword || confirmNewPassword) {
                if (newPassword !== confirmNewPassword) {
                    e.preventDefault();
                    alert('New passwords do not match!');
                    return;
                }
                
                // Password strength validation
                const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
                if (!passwordRegex.test(newPassword)) {
                    e.preventDefault();
                    alert('Password must be at least 8 characters long and contain at least one letter, one number, and one special character.');
                    return;
                }
            }
            
            // Email validation
            const email = document.getElementById('email').value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Please enter a valid email address.');
                return;
            }
        });
    </script>
</body>
</html>