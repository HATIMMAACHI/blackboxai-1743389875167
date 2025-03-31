<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Paper - CMS</title>
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
            <!-- Paper Information -->
            <div class="bg-white shadow overflow-hidden sm:rounded-lg mb-6">
                <div class="px-4 py-5 sm:px-6">
                    <h2 class="text-xl font-semibold text-gray-900">Paper Details</h2>
                </div>
                <div class="border-t border-gray-200 px-4 py-5 sm:px-6">
                    <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
                        <div class="sm:col-span-1">
                            <dt class="text-sm font-medium text-gray-500">Paper ID</dt>
                            <dd class="mt-1 text-sm text-gray-900">${paper.uniqueSubmissionId}</dd>
                        </div>
                        <div class="sm:col-span-1">
                            <dt class="text-sm font-medium text-gray-500">Conference</dt>
                            <dd class="mt-1 text-sm text-gray-900">${conference.name}</dd>
                        </div>
                        <div class="sm:col-span-2">
                            <dt class="text-sm font-medium text-gray-500">Title</dt>
                            <dd class="mt-1 text-sm text-gray-900">${paper.title}</dd>
                        </div>
                        <div class="sm:col-span-2">
                            <dt class="text-sm font-medium text-gray-500">Abstract</dt>
                            <dd class="mt-1 text-sm text-gray-900">${paper.summary}</dd>
                        </div>
                        <div class="sm:col-span-2">
                            <dt class="text-sm font-medium text-gray-500">Keywords</dt>
                            <dd class="mt-1 text-sm text-gray-900">${paper.keywords}</dd>
                        </div>
                        <div class="sm:col-span-2">
                            <dt class="text-sm font-medium text-gray-500">Paper Download</dt>
                            <dd class="mt-1 text-sm text-gray-900">
                                <a href="${paper.filePath}" class="text-indigo-600 hover:text-indigo-900">
                                    <i class="fas fa-download mr-1"></i>Download Paper
                                </a>
                            </dd>
                        </div>
                    </dl>
                </div>
            </div>

            <!-- Review Form -->
            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6">
                    <h2 class="text-xl font-semibold text-gray-900">Review Form</h2>
                    <p class="mt-1 text-sm text-gray-500">Please provide your evaluation and feedback.</p>
                </div>
                <form action="review/submit" method="POST" class="border-t border-gray-200">
                    <input type="hidden" name="paperId" value="${paper.id}">
                    <input type="hidden" name="reviewerId" value="${reviewer.id}">
                    
                    <div class="px-4 py-5 sm:px-6 space-y-6">
                        <!-- Expertise Level -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Your Expertise Level in the Paper's Topic</label>
                            <select name="expertise" required
                                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                <option value="">Select your expertise level...</option>
                                <option value="EXPERT">Expert in the field</option>
                                <option value="KNOWLEDGEABLE">Knowledgeable</option>
                                <option value="FAMILIAR">Familiar with the topic</option>
                                <option value="BASIC">Basic understanding</option>
                            </select>
                        </div>

                        <!-- Overall Score -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Overall Score (1-5)</label>
                            <div class="mt-1 flex items-center space-x-4">
                                <div class="flex items-center">
                                    <input type="radio" name="score" value="1" required
                                        class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                                    <label class="ml-2 text-sm text-gray-700">1 (Poor)</label>
                                </div>
                                <div class="flex items-center">
                                    <input type="radio" name="score" value="2" required
                                        class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                                    <label class="ml-2 text-sm text-gray-700">2 (Fair)</label>
                                </div>
                                <div class="flex items-center">
                                    <input type="radio" name="score" value="3" required
                                        class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                                    <label class="ml-2 text-sm text-gray-700">3 (Good)</label>
                                </div>
                                <div class="flex items-center">
                                    <input type="radio" name="score" value="4" required
                                        class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                                    <label class="ml-2 text-sm text-gray-700">4 (Very Good)</label>
                                </div>
                                <div class="flex items-center">
                                    <input type="radio" name="score" value="5" required
                                        class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300">
                                    <label class="ml-2 text-sm text-gray-700">5 (Excellent)</label>
                                </div>
                            </div>
                        </div>

                        <!-- Review Comments -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Review Comments</label>
                            <p class="mt-1 text-sm text-gray-500">Please provide detailed feedback for the authors.</p>
                            <textarea name="comments" rows="8" required
                                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                placeholder="Provide your detailed review here..."></textarea>
                        </div>

                        <!-- Confidential Comments -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Confidential Comments to Committee</label>
                            <p class="mt-1 text-sm text-gray-500">These comments will only be visible to the committee.</p>
                            <textarea name="confidentialComments" rows="4"
                                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                placeholder="Optional comments for the committee..."></textarea>
                        </div>

                        <!-- Review Decision -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Recommendation</label>
                            <select name="decision" required
                                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                <option value="">Select your recommendation...</option>
                                <option value="ACCEPT">Accept</option>
                                <option value="MINOR_REVISION">Accept with Minor Revisions</option>
                                <option value="MAJOR_REVISION">Major Revision Required</option>
                                <option value="REJECT">Reject</option>
                            </select>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="flex justify-end space-x-3 pt-6">
                            <button type="button" onclick="saveDraft()"
                                class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                Save as Draft
                            </button>
                            <button type="submit"
                                class="bg-indigo-600 py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                Submit Review
                            </button>
                        </div>
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

    <!-- JavaScript -->
    <script>
        // Save review as draft
        function saveDraft() {
            const form = document.querySelector('form');
            const formData = new FormData(form);
            formData.append('isDraft', 'true');
            
            fetch('review/save-draft', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Review saved as draft successfully');
                } else {
                    alert('Failed to save draft: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while saving the draft');
            });
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate score
            const score = document.querySelector('input[name="score"]:checked');
            if (!score) {
                alert('Please select a score');
                return;
            }

            // Validate comments
            const comments = document.querySelector('textarea[name="comments"]').value.trim();
            if (comments.length < 100) {
                alert('Please provide more detailed comments (minimum 100 characters)');
                return;
            }

            // Validate decision
            const decision = document.querySelector('select[name="decision"]').value;
            if (!decision) {
                alert('Please select a recommendation');
                return;
            }

            // Submit form if all validations pass
            this.submit();
        });
    </script>
</body>
</html>