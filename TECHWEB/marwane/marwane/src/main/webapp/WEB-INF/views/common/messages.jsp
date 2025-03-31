<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Success Message -->
<c:if test="${not empty successMessage}">
    <div id="successAlert" class="mb-4 rounded-lg p-4 bg-green-50 border border-green-200" role="alert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-check-circle text-green-600"></i>
            </div>
            <div class="ml-3">
                <p class="text-sm font-medium text-green-800">
                    ${successMessage}
                </p>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" 
                            onclick="dismissAlert('successAlert')"
                            class="inline-flex rounded-md p-1.5 text-green-500 hover:bg-green-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                        <span class="sr-only">Dismiss</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Error Message -->
<c:if test="${not empty errorMessage}">
    <div id="errorAlert" class="mb-4 rounded-lg p-4 bg-red-50 border border-red-200" role="alert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-exclamation-circle text-red-600"></i>
            </div>
            <div class="ml-3">
                <p class="text-sm font-medium text-red-800">
                    ${errorMessage}
                </p>
                <c:if test="${not empty errorDetails}">
                    <div class="mt-2">
                        <details class="text-sm text-red-700">
                            <summary class="cursor-pointer hover:text-red-800">Show Details</summary>
                            <pre class="mt-2 whitespace-pre-wrap">${errorDetails}</pre>
                        </details>
                    </div>
                </c:if>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" 
                            onclick="dismissAlert('errorAlert')"
                            class="inline-flex rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                        <span class="sr-only">Dismiss</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Warning Message -->
<c:if test="${not empty warningMessage}">
    <div id="warningAlert" class="mb-4 rounded-lg p-4 bg-yellow-50 border border-yellow-200" role="alert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-exclamation-triangle text-yellow-600"></i>
            </div>
            <div class="ml-3">
                <p class="text-sm font-medium text-yellow-800">
                    ${warningMessage}
                </p>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" 
                            onclick="dismissAlert('warningAlert')"
                            class="inline-flex rounded-md p-1.5 text-yellow-500 hover:bg-yellow-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                        <span class="sr-only">Dismiss</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Info Message -->
<c:if test="${not empty infoMessage}">
    <div id="infoAlert" class="mb-4 rounded-lg p-4 bg-blue-50 border border-blue-200" role="alert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-info-circle text-blue-600"></i>
            </div>
            <div class="ml-3">
                <p class="text-sm font-medium text-blue-800">
                    ${infoMessage}
                </p>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" 
                            onclick="dismissAlert('infoAlert')"
                            class="inline-flex rounded-md p-1.5 text-blue-500 hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        <span class="sr-only">Dismiss</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Validation Errors -->
<c:if test="${not empty validationErrors}">
    <div id="validationAlert" class="mb-4 rounded-lg p-4 bg-red-50 border border-red-200" role="alert">
        <div class="flex">
            <div class="flex-shrink-0">
                <i class="fas fa-exclamation-circle text-red-600"></i>
            </div>
            <div class="ml-3">
                <h3 class="text-sm font-medium text-red-800">
                    Please correct the following errors:
                </h3>
                <div class="mt-2 text-sm text-red-700">
                    <ul class="list-disc pl-5 space-y-1">
                        <c:forEach items="${validationErrors}" var="error">
                            <li>${error}</li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button type="button" 
                            onclick="dismissAlert('validationAlert')"
                            class="inline-flex rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                        <span class="sr-only">Dismiss</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- JavaScript for alert handling -->
<script>
    // Dismiss alert function
    function dismissAlert(alertId) {
        const alert = document.getElementById(alertId);
        if (alert) {
            alert.classList.add('opacity-0');
            setTimeout(() => {
                alert.style.display = 'none';
            }, 300);
        }
    }

    // Auto-dismiss success messages after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const successAlert = document.getElementById('successAlert');
        if (successAlert) {
            setTimeout(() => {
                dismissAlert('successAlert');
            }, 5000);
        }
    });

    // Add slide-in animation for alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('[role="alert"]');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.3s ease-in-out';
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.opacity = '1';
            }, 100);
        });
    });
</script>