<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Navigation -->
<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <!-- Logo and Primary Navigation -->
            <div class="flex">
                <div class="flex-shrink-0 flex items-center">
                    <a href="${pageContext.request.contextPath}/" class="flex items-center">
                        <i class="fas fa-university text-indigo-600 text-2xl mr-2"></i>
                        <span class="text-xl font-semibold text-gray-800">ConferenceMS</span>
                    </a>
                </div>

                <!-- Primary Navigation -->
                <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                    <a href="${pageContext.request.contextPath}/conference/list" 
                       class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                        <i class="fas fa-list-ul mr-1"></i> Conferences
                    </a>

                    <c:if test="${sessionScope.user != null}">
                        <c:choose>
                            <c:when test="${sessionScope.role == 'PRESIDENT'}">
                                <a href="${pageContext.request.contextPath}/conference/manage" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-tasks mr-1"></i> Manage Conferences
                                </a>
                                <a href="${pageContext.request.contextPath}/committee/manage" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-users-cog mr-1"></i> Committees
                                </a>
                            </c:when>
                            
                            <c:when test="${sessionScope.role == 'COMMITTEE_MEMBER'}">
                                <a href="${pageContext.request.contextPath}/committee/dashboard" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-clipboard-list mr-1"></i> Committee Dashboard
                                </a>
                                <a href="${pageContext.request.contextPath}/review/assignments" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-tasks mr-1"></i> Review Assignments
                                </a>
                            </c:when>
                            
                            <c:when test="${sessionScope.role == 'REVIEWER'}">
                                <a href="${pageContext.request.contextPath}/review/assignments" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-file-alt mr-1"></i> My Reviews
                                </a>
                            </c:when>
                            
                            <c:when test="${sessionScope.role == 'AUTHOR'}">
                                <a href="${pageContext.request.contextPath}/paper/submit" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-upload mr-1"></i> Submit Paper
                                </a>
                                <a href="${pageContext.request.contextPath}/paper/submissions" 
                                   class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900">
                                    <i class="fas fa-folder-open mr-1"></i> My Submissions
                                </a>
                            </c:when>
                        </c:choose>
                    </c:if>
                </div>
            </div>

            <!-- Secondary Navigation / User Menu -->
            <div class="hidden sm:ml-6 sm:flex sm:items-center">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <!-- Login/Register buttons for non-authenticated users -->
                        <div class="flex items-center space-x-4">
                            <a href="${pageContext.request.contextPath}/user/login" 
                               class="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
                                <i class="fas fa-sign-in-alt mr-1"></i> Login
                            </a>
                            <a href="${pageContext.request.contextPath}/user/register" 
                               class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-md text-sm font-medium">
                                <i class="fas fa-user-plus mr-1"></i> Register
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- User menu dropdown for authenticated users -->
                        <div class="ml-3 relative">
                            <div class="relative">
                                <button type="button" 
                                        onclick="toggleUserMenu()"
                                        class="flex text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" 
                                        id="user-menu-button" 
                                        aria-expanded="false" 
                                        aria-haspopup="true">
                                    <span class="sr-only">Open user menu</span>
                                    <div class="h-8 w-8 rounded-full bg-indigo-600 flex items-center justify-center text-white">
                                        ${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}
                                    </div>
                                </button>
                            </div>

                            <!-- Dropdown menu -->
                            <div id="user-menu-dropdown" 
                                 class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none" 
                                 role="menu" 
                                 aria-orientation="vertical" 
                                 aria-labelledby="user-menu-button" 
                                 tabindex="-1">
                                <a href="${pageContext.request.contextPath}/user/profile" 
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" 
                                   role="menuitem">
                                    <i class="fas fa-user mr-2"></i> Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/user/settings" 
                                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" 
                                   role="menuitem">
                                    <i class="fas fa-cog mr-2"></i> Settings
                                </a>
                                <div class="border-t border-gray-100"></div>
                                <a href="${pageContext.request.contextPath}/user/logout" 
                                   class="block px-4 py-2 text-sm text-red-700 hover:bg-red-50" 
                                   role="menuitem">
                                    <i class="fas fa-sign-out-alt mr-2"></i> Sign out
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Mobile menu button -->
            <div class="flex items-center sm:hidden">
                <button type="button" 
                        onclick="toggleMobileMenu()"
                        class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500" 
                        aria-controls="mobile-menu" 
                        aria-expanded="false">
                    <span class="sr-only">Open main menu</span>
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Mobile menu -->
    <div class="sm:hidden hidden" id="mobile-menu">
        <div class="pt-2 pb-3 space-y-1">
            <a href="${pageContext.request.contextPath}/conference/list" 
               class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                Conferences
            </a>

            <c:if test="${sessionScope.user != null}">
                <c:choose>
                    <c:when test="${sessionScope.role == 'PRESIDENT'}">
                        <a href="${pageContext.request.contextPath}/conference/manage" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Manage Conferences
                        </a>
                        <a href="${pageContext.request.contextPath}/committee/manage" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Committees
                        </a>
                    </c:when>
                    
                    <c:when test="${sessionScope.role == 'COMMITTEE_MEMBER'}">
                        <a href="${pageContext.request.contextPath}/committee/dashboard" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Committee Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/review/assignments" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Review Assignments
                        </a>
                    </c:when>
                    
                    <c:when test="${sessionScope.role == 'REVIEWER'}">
                        <a href="${pageContext.request.contextPath}/review/assignments" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            My Reviews
                        </a>
                    </c:when>
                    
                    <c:when test="${sessionScope.role == 'AUTHOR'}">
                        <a href="${pageContext.request.contextPath}/paper/submit" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Submit Paper
                        </a>
                        <a href="${pageContext.request.contextPath}/paper/submissions" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            My Submissions
                        </a>
                    </c:when>
                </c:choose>
            </c:if>
        </div>

        <!-- Mobile menu user section -->
        <div class="pt-4 pb-3 border-t border-gray-200">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <div class="space-y-1">
                        <a href="${pageContext.request.contextPath}/user/login" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Login
                        </a>
                        <a href="${pageContext.request.contextPath}/user/register" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-indigo-600 hover:bg-gray-50 hover:border-indigo-500">
                            Register
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="flex items-center px-4">
                        <div class="flex-shrink-0">
                            <div class="h-10 w-10 rounded-full bg-indigo-600 flex items-center justify-center text-white">
                                ${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}
                            </div>
                        </div>
                        <div class="ml-3">
                            <div class="text-base font-medium text-gray-800">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </div>
                            <div class="text-sm font-medium text-gray-500">
                                ${sessionScope.user.email}
                            </div>
                        </div>
                    </div>
                    <div class="mt-3 space-y-1">
                        <a href="${pageContext.request.contextPath}/user/profile" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Profile
                        </a>
                        <a href="${pageContext.request.contextPath}/user/settings" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800">
                            Settings
                        </a>
                        <a href="${pageContext.request.contextPath}/user/logout" 
                           class="block pl-3 pr-4 py-2 border-l-4 text-base font-medium border-transparent text-red-600 hover:bg-red-50 hover:border-red-500">
                            Sign out
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- JavaScript for menu toggles -->
<script>
    function toggleUserMenu() {
        const menu = document.getElementById('user-menu-dropdown');
        menu.classList.toggle('hidden');
    }

    function toggleMobileMenu() {
        const menu = document.getElementById('mobile-menu');
        menu.classList.toggle('hidden');
    }

    // Close menus when clicking outside
    document.addEventListener('click', function(event) {
        const userMenu = document.getElementById('user-menu-dropdown');
        const userMenuButton = document.getElementById('user-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');
        const mobileMenuButton = document.querySelector('[aria-controls="mobile-menu"]');

        if (!userMenuButton.contains(event.target) && !userMenu.contains(event.target)) {
            userMenu.classList.add('hidden');
        }

        if (!mobileMenuButton.contains(event.target) && !mobileMenu.contains(event.target)) {
            mobileMenu.classList.add('hidden');
        }
    });
</script>