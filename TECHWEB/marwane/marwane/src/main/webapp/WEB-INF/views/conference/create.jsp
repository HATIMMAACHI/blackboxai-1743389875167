<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Conference - CMS</title>
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
    <div class="min-h-screen">
        <!-- Navigation -->
        <nav class="bg-indigo-600 shadow-lg">
            <div class="max-w-7xl mx-auto px-4">
                <div class="flex justify-between h-16">
                    <div class="flex">
                        <div class="flex-shrink-0 flex items-center">
                            <a href="../dashboard" class="text-white text-xl font-bold">CMS</a>
                        </div>
                    </div>
                    <div class="flex items-center">
                        <a href="../dashboard" class="text-gray-200 hover:text-white">
                            <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <div class="px-4 py-5 sm:px-6">
                <h1 class="text-2xl font-semibold text-gray-900">Create New Conference</h1>
                <p class="mt-1 text-sm text-gray-500">Enter the conference details below.</p>
            </div>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <form action="conference/create" method="POST" enctype="multipart/form-data" class="p-6">
                    <!-- Basic Information -->
                    <div class="space-y-6">
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 rounded-lg">
                            <div class="col-span-3">
                                <h2 class="text-lg font-medium text-gray-900 mb-4">Basic Information</h2>
                            </div>
                            
                            <div class="col-span-3 sm:col-span-1">
                                <label class="block text-sm font-medium text-gray-700">Conference Name</label>
                                <input type="text" name="name" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                            </div>

                            <div class="col-span-3 sm:col-span-1">
                                <label class="block text-sm font-medium text-gray-700">Acronym</label>
                                <input type="text" name="acronym" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                            </div>

                            <div class="col-span-3 sm:col-span-1">
                                <label class="block text-sm font-medium text-gray-700">Website</label>
                                <input type="url" name="website" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                        </div>

                        <!-- Conference Type and Location -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6 rounded-lg">
                            <div class="col-span-3 sm:col-span-1">
                                <label class="block text-sm font-medium text-gray-700">Conference Type</label>
                                <select name="type" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="physical">Physical</option>
                                    <option value="virtual">Virtual</option>
                                    <option value="hybrid">Hybrid</option>
                                </select>
                            </div>

                            <div class="col-span-3 sm:col-span-2">
                                <label class="block text-sm font-medium text-gray-700">Location</label>
                                <input type="text" name="location" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                            </div>
                        </div>

                        <!-- Dates -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-2 sm:gap-4 sm:px-6 rounded-lg">
                            <div class="col-span-2">
                                <h2 class="text-lg font-medium text-gray-900 mb-4">Important Dates</h2>
                            </div>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Conference Start Date</label>
                                    <input type="date" name="startDate" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Conference End Date</label>
                                    <input type="date" name="endDate" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>
                            </div>

                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Submission Deadline</label>
                                    <input type="date" name="submissionDeadline" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Review Deadline</label>
                                    <input type="date" name="reviewDeadline" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>
                            </div>
                        </div>

                        <!-- Topics and Themes -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div>
                                <h2 class="text-lg font-medium text-gray-900 mb-4">Topics and Themes</h2>
                            </div>

                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Main Theme</label>
                                    <input type="text" name="thematic" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Topics (comma-separated)</label>
                                    <input type="text" name="topics" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                        placeholder="AI, Machine Learning, Data Science">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Sub-topics (comma-separated)</label>
                                    <input type="text" name="subTopics"
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                        placeholder="Deep Learning, Neural Networks, Big Data">
                                </div>
                            </div>
                        </div>

                        <!-- Logo Upload -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div>
                                <label class="block text-sm font-medium text-gray-700">Conference Logo</label>
                                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
                                    <div class="space-y-1 text-center">
                                        <i class="fas fa-cloud-upload-alt text-gray-400 text-3xl mb-3"></i>
                                        <div class="flex text-sm text-gray-600">
                                            <label for="logo" class="relative cursor-pointer bg-white rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500">
                                                <span>Upload a file</span>
                                                <input id="logo" name="logo" type="file" class="sr-only" accept="image/*">
                                            </label>
                                            <p class="pl-1">or drag and drop</p>
                                        </div>
                                        <p class="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="mt-6 flex items-center justify-end space-x-3">
                        <button type="button" onclick="window.history.back()" 
                            class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Cancel
                        </button>
                        <button type="submit"
                            class="bg-indigo-600 py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Create Conference
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white shadow mt-8">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <p class="text-center text-sm text-gray-500">© 2024 Conference Management System. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript for Form Validation and File Upload Preview -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Date validation
            const startDate = document.querySelector('input[name="startDate"]');
            const endDate = document.querySelector('input[name="endDate"]');
            const submissionDeadline = document.querySelector('input[name="submissionDeadline"]');
            const reviewDeadline = document.querySelector('input[name="reviewDeadline"]');

            function validateDates() {
                const start = new Date(startDate.value);
                const end = new Date(endDate.value);
                const submission = new Date(submissionDeadline.value);
                const review = new Date(reviewDeadline.value);

                if (end < start) {
                    alert('End date must be after start date');
                    endDate.value = '';
                    return false;
                }

                if (submission >= start) {
                    alert('Submission deadline must be before conference start date');
                    submissionDeadline.value = '';
                    return false;
                }

                if (review >= submission) {
                    alert('Review deadline must be before submission deadline');
                    reviewDeadline.value = '';
                    return false;
                }

                return true;
            }

            [endDate, submissionDeadline, reviewDeadline].forEach(input => {
                input.addEventListener('change', validateDates);
            });

            // File upload preview
            const fileInput = document.querySelector('input[type="file"]');
            fileInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    if (file.size > 10 * 1024 * 1024) { // 10MB
                        alert('File size must be less than 10MB');
                        e.target.value = '';
                    }
                }
            });

            // Form submission
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                if (validateDates()) {
                    this.submit();
                }
            });
        });
    </script>
</body>
</html>