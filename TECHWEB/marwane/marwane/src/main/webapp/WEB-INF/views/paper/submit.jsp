<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Paper - CMS</title>
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
                <h1 class="text-2xl font-semibold text-gray-900">Submit Paper</h1>
                <p class="mt-1 text-sm text-gray-500">Submit your paper for review.</p>
            </div>

            <div class="bg-white shadow overflow-hidden sm:rounded-lg">
                <form action="paper/submit" method="POST" enctype="multipart/form-data" class="p-6">
                    <!-- Conference Selection -->
                    <div class="space-y-6">
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div>
                                <label class="block text-sm font-medium text-gray-700">Select Conference</label>
                                <select name="conferenceId" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="">Choose a conference...</option>
                                    <c:forEach items="${conferences}" var="conference">
                                        <option value="${conference.id}">${conference.name} (${conference.acronym})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Paper Details -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Paper Title</label>
                                    <input type="text" name="title" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Abstract</label>
                                    <textarea name="summary" rows="4" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"></textarea>
                                </div>

                                <div>
                                    <label class="block text-sm font-medium text-gray-700">Keywords (comma-separated)</label>
                                    <input type="text" name="keywords" required
                                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                        placeholder="machine learning, artificial intelligence, data mining">
                                </div>
                            </div>
                        </div>

                        <!-- Authors -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div>
                                <h2 class="text-lg font-medium text-gray-900 mb-4">Authors</h2>
                                <div id="authors-container">
                                    <div class="author-entry space-y-3">
                                        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700">Author Name</label>
                                                <input type="text" name="authorNames[]" required
                                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700">Email</label>
                                                <input type="email" name="authorEmails[]" required
                                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700">Affiliation</label>
                                            <input type="text" name="authorAffiliations[]" required
                                                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                        </div>
                                        <div>
                                            <label class="inline-flex items-center">
                                                <input type="radio" name="correspondingAuthor" value="0" required
                                                    class="form-radio h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300">
                                                <span class="ml-2 text-sm text-gray-700">Corresponding Author</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" onclick="addAuthor()"
                                    class="mt-4 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                    <i class="fas fa-plus mr-2"></i>Add Author
                                </button>
                            </div>
                        </div>

                        <!-- Paper Upload -->
                        <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6 rounded-lg">
                            <div>
                                <label class="block text-sm font-medium text-gray-700">Paper File (PDF/DOC)</label>
                                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
                                    <div class="space-y-1 text-center">
                                        <i class="fas fa-file-upload text-gray-400 text-3xl mb-3"></i>
                                        <div class="flex text-sm text-gray-600">
                                            <label for="paper-file" class="relative cursor-pointer bg-white rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500">
                                                <span>Upload a file</span>
                                                <input id="paper-file" name="paperFile" type="file" class="sr-only" required accept=".pdf,.doc,.docx">
                                            </label>
                                            <p class="pl-1">or drag and drop</p>
                                        </div>
                                        <p class="text-xs text-gray-500">PDF or DOC up to 20MB</p>
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
                            Submit Paper
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

    <!-- JavaScript for Form Handling -->
    <script>
        let authorCount = 1;

        function addAuthor() {
            authorCount++;
            const container = document.getElementById('authors-container');
            const newAuthor = document.createElement('div');
            newAuthor.className = 'author-entry space-y-3 mt-6 pt-6 border-t border-gray-200';
            newAuthor.innerHTML = `
                <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Author Name</label>
                        <input type="text" name="authorNames[]" required
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Email</label>
                        <input type="email" name="authorEmails[]" required
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700">Affiliation</label>
                    <input type="text" name="authorAffiliations[]" required
                        class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                </div>
                <div>
                    <label class="inline-flex items-center">
                        <input type="radio" name="correspondingAuthor" value="${authorCount - 1}" required
                            class="form-radio h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300">
                        <span class="ml-2 text-sm text-gray-700">Corresponding Author</span>
                    </label>
                </div>
                <button type="button" onclick="removeAuthor(this)" class="text-red-600 hover:text-red-800">
                    <i class="fas fa-trash mr-1"></i>Remove Author
                </button>
            `;
            container.appendChild(newAuthor);
        }

        function removeAuthor(button) {
            button.parentElement.remove();
            authorCount--;
        }

        // File validation
        document.getElementById('paper-file').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                if (file.size > 20 * 1024 * 1024) { // 20MB
                    alert('File size must be less than 20MB');
                    e.target.value = '';
                    return;
                }

                const validTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
                if (!validTypes.includes(file.type)) {
                    alert('Please upload a PDF or DOC file');
                    e.target.value = '';
                    return;
                }
            }
        });

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate conference selection
            const conference = document.querySelector('select[name="conferenceId"]').value;
            if (!conference) {
                alert('Please select a conference');
                return;
            }

            // Validate at least one author
            const authors = document.querySelectorAll('input[name="authorNames[]"]');
            if (authors.length === 0) {
                alert('Please add at least one author');
                return;
            }

            // Validate corresponding author selection
            const correspondingAuthor = document.querySelector('input[name="correspondingAuthor"]:checked');
            if (!correspondingAuthor) {
                alert('Please select a corresponding author');
                return;
            }

            this.submit();
        });
    </script>
</body>
</html>