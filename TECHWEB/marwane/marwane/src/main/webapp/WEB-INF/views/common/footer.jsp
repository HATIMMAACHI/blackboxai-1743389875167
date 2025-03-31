<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="bg-white">
    <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 md:flex md:items-center md:justify-between lg:px-8">
        <div class="flex justify-center space-x-6 md:order-2">
            <!-- Social Media Links -->
            <a href="#" class="text-gray-400 hover:text-gray-500" target="_blank" rel="noopener noreferrer">
                <span class="sr-only">Twitter</span>
                <i class="fab fa-twitter text-xl"></i>
            </a>

            <a href="#" class="text-gray-400 hover:text-gray-500" target="_blank" rel="noopener noreferrer">
                <span class="sr-only">LinkedIn</span>
                <i class="fab fa-linkedin text-xl"></i>
            </a>
 
            <a href="#" class="text-gray-400 hover:text-gray-500" target="_blank" rel="noopener noreferrer">
                <span class="sr-only">GitHub</span>
                <i class="fab fa-github text-xl"></i>
            </a>
        </div>

        <div class="mt-8 md:mt-0 md:order-1">
            <!-- Copyright and Links -->
            <div class="flex flex-col md:flex-row md:items-center">
                <p class="text-center text-base text-gray-400">
                    &copy; <%= java.time.Year.now().getValue() %> Conference Management System. All rights reserved.
                </p>
                <nav class="flex justify-center space-x-4 mt-4 md:mt-0 md:ml-4">
                    <a href="${pageContext.request.contextPath}/about" class="text-gray-400 hover:text-gray-500 text-sm">
                        About
                    </a>
                    <span class="text-gray-400">|</span>
                    <a href="${pageContext.request.contextPath}/privacy" class="text-gray-400 hover:text-gray-500 text-sm">
                        Privacy Policy
                    </a>
                    <span class="text-gray-400">|</span>
                    <a href="${pageContext.request.contextPath}/terms" class="text-gray-400 hover:text-gray-500 text-sm">
                        Terms of Service
                    </a>
                    <span class="text-gray-400">|</span>
                    <a href="${pageContext.request.contextPath}/contact" class="text-gray-400 hover:text-gray-500 text-sm">
                        Contact
                    </a>
                </nav>
            </div>
        </div>
    </div>

    <!-- Quick Links Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- Conference Links -->
            <div>
                <h3 class="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                    Conferences
                </h3>
                <ul class="mt-4 space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/conference/list" class="text-base text-gray-400 hover:text-gray-500">
                            Browse Conferences
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/conference/calendar" class="text-base text-gray-400 hover:text-gray-500">
                            Conference Calendar
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/conference/past" class="text-base text-gray-400 hover:text-gray-500">
                            Past Conferences
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Author Resources -->
            <div>
                <h3 class="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                    For Authors
                </h3>
                <ul class="mt-4 space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/paper/submit" class="text-base text-gray-400 hover:text-gray-500">
                            Submit Paper
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/author/guidelines" class="text-base text-gray-400 hover:text-gray-500">
                            Submission Guidelines
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/author/faq" class="text-base text-gray-400 hover:text-gray-500">
                            Author FAQ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Reviewer Resources -->
            <div>
                <h3 class="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                    For Reviewers
                </h3>
                <ul class="mt-4 space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/reviewer/guidelines" class="text-base text-gray-400 hover:text-gray-500">
                            Review Guidelines
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/reviewer/ethics" class="text-base text-gray-400 hover:text-gray-500">
                            Ethics Policy
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/reviewer/faq" class="text-base text-gray-400 hover:text-gray-500">
                            Reviewer FAQ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Support -->
            <div>
                <h3 class="text-sm font-semibold text-gray-400 tracking-wider uppercase">
                    Support
                </h3>
                <ul class="mt-4 space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/help" class="text-base text-gray-400 hover:text-gray-500">
                            Help Center
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/support/ticket" class="text-base text-gray-400 hover:text-gray-500">
                            Submit Ticket
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/contact" class="text-base text-gray-400 hover:text-gray-500">
                            Contact Support
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Bottom Bar -->
    <div class="border-t border-gray-200">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <p class="text-xs text-center text-gray-400">
                This site is protected by reCAPTCHA and the Google
                <a href="https://policies.google.com/privacy" class="text-gray-500 hover:text-gray-600">Privacy Policy</a> and
                <a href="https://policies.google.com/terms" class="text-gray-500 hover:text-gray-600">Terms of Service</a> apply.
            </p>
        </div>
    </div>
</footer>

<!-- Back to top button -->
<button id="backToTop" 
        class="fixed bottom-4 right-4 bg-indigo-600 text-white rounded-full p-3 hidden hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        onclick="scrollToTop()">
    <span class="sr-only">Back to top</span>
    <i class="fas fa-arrow-up"></i>
</button>

<script>
    // Show/hide back to top button based on scroll position
    window.onscroll = function() {
        const button = document.getElementById('backToTop');
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            button.classList.remove('hidden');
        } else {
            button.classList.add('hidden');
        }
    };

    // Smooth scroll to top
    function scrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }
</script>