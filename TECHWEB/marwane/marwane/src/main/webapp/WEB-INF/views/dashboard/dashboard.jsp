<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conference Management System - Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-indigo-600 shadow-lg">
        <div class="max-w-7xl mx-auto px-4">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <div class="flex-shrink-0 flex items-center">
                        <span class="text-white text-xl font-bold">CMS</span>
                    </div>
                    <div class="hidden md:ml-6 md:flex md:space-x-8">
                        <a href="#" class="text-white hover:text-gray-200 px-3 py-2 rounded-md text-sm font-medium">Dashboard</a>
                        <a href="#" class="text-gray-200 hover:text-white px-3 py-2 rounded-md text-sm font-medium">Conferences</a>
                        <a href="#" class="text-gray-200 hover:text-white px-3 py-2 rounded-md text-sm font-medium">Papers</a>
                        <a href="#" class="text-gray-200 hover:text-white px-3 py-2 rounded-md text-sm font-medium">Reviews</a>
                    </div>
                </div>
                <div class="flex items-center">
                    <div class="flex-shrink-0">
                        <span class="text-white">${user.firstName} ${user.lastName}</span>
                    </div>
                    <div class="ml-4">
                        <a href="logout" class="text-gray-200 hover:text-white"><i class="fas fa-sign-out-alt"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <!-- Welcome Section -->
        <div class="px-4 py-5 sm:px-6">
            <h1 class="text-2xl font-semibold text-gray-900">Welcome to Conference Management System</h1>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">Manage your conferences, papers, and reviews efficiently.</p>
        </div>

        <!-- Stats Section -->
        <div class="mt-8 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <!-- Conference Stats -->
            <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <i class="fas fa-calendar-alt text-indigo-500 text-3xl"></i>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">Active Conferences</dt>
                                <dd class="flex items-baseline">
                                    <div class="text-2xl font-semibold text-gray-900">${activeConferences}</div>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Papers Stats -->
            <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <i class="fas fa-file-alt text-green-500 text-3xl"></i>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">Submitted Papers</dt>
                                <dd class="flex items-baseline">
                                    <div class="text-2xl font-semibold text-gray-900">${submittedPapers}</div>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reviews Stats -->
            <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <i class="fas fa-star text-yellow-500 text-3xl"></i>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">Pending Reviews</dt>
                                <dd class="flex items-baseline">
                                    <div class="text-2xl font-semibold text-gray-900">${pendingReviews}</div>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Committee Stats -->
            <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                    <div class="flex items-center">
                        <div class="flex-shrink-0">
                            <i class="fas fa-users text-blue-500 text-3xl"></i>
                        </div>
                        <div class="ml-5 w-0 flex-1">
                            <dl>
                                <dt class="text-sm font-medium text-gray-500 truncate">Committee Members</dt>
                                <dd class="flex items-baseline">
                                    <div class="text-2xl font-semibold text-gray-900">${committeeMembers}</div>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="mt-8">
            <h2 class="text-lg font-medium text-gray-900">Quick Actions</h2>
            <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <a href="conference/new" class="bg-white shadow rounded-lg p-6 hover:shadow-lg transition duration-150">
                    <div class="flex items-center">
                        <i class="fas fa-plus-circle text-indigo-500 text-2xl"></i>
                        <div class="ml-4">
                            <h3 class="text-lg font-medium text-gray-900">Create Conference</h3>
                            <p class="text-sm text-gray-500">Set up a new conference with all details</p>
                        </div>
                    </div>
                </a>

                <a href="paper/submit" class="bg-white shadow rounded-lg p-6 hover:shadow-lg transition duration-150">
                    <div class="flex items-center">
                        <i class="fas fa-upload text-green-500 text-2xl"></i>
                        <div class="ml-4">
                            <h3 class="text-lg font-medium text-gray-900">Submit Paper</h3>
                            <p class="text-sm text-gray-500">Submit a new paper for review</p>
                        </div>
                    </div>
                </a>

                <a href="review/assigned" class="bg-white shadow rounded-lg p-6 hover:shadow-lg transition duration-150">
                    <div class="flex items-center">
                        <i class="fas fa-tasks text-yellow-500 text-2xl"></i>
                        <div class="ml-4">
                            <h3 class="text-lg font-medium text-gray-900">Review Papers</h3>
                            <p class="text-sm text-gray-500">View and complete assigned reviews</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <!-- Recent Activities -->
        <div class="mt-8">
            <h2 class="text-lg font-medium text-gray-900">Recent Activities</h2>
            <div class="mt-4 bg-white shadow rounded-lg">
                <ul class="divide-y divide-gray-200">
                    <c:forEach items="${recentActivities}" var="activity">
                        <li class="p-4">
                            <div class="flex items-center space-x-4">
                                <div class="flex-shrink-0">
                                    <i class="fas ${activity.icon} text-${activity.color}-500"></i>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <p class="text-sm font-medium text-gray-900 truncate">${activity.description}</p>
                                    <p class="text-sm text-gray-500">${activity.timestamp}</p>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white shadow mt-8">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <p class="text-center text-sm text-gray-500">© 2024 Conference Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>