<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Full Page Loading Overlay -->
<div id="fullPageLoader" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 hidden">
    <div class="bg-white rounded-lg p-8 flex flex-col items-center">
        <div class="animate-spin rounded-full h-16 w-16 border-t-4 border-b-4 border-indigo-600"></div>
        <p class="mt-4 text-lg font-semibold text-gray-700" id="loaderMessage">Loading...</p>
    </div>
</div>

<!-- Inline Loading Spinner -->
<div id="inlineLoader" class="flex items-center justify-center p-4 hidden">
    <div class="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-indigo-600"></div>
    <span class="ml-3 text-sm text-gray-600" id="inlineLoaderMessage">Loading...</span>
</div>

<!-- Small Loading Spinner (for buttons) -->
<div id="buttonLoader" class="inline-flex items-center hidden">
    <div class="animate-spin rounded-full h-4 w-4 border-t-2 border-b-2 border-current"></div>
    <span class="ml-2 text-sm">Loading...</span>
</div>

<!-- Progress Bar -->
<div id="progressBar" class="hidden">
    <div class="w-full bg-gray-200 rounded-full h-2.5">
        <div id="progressBarFill" 
             class="bg-indigo-600 h-2.5 rounded-full transition-all duration-300"
             style="width: 0%">
        </div>
    </div>
    <div class="flex justify-between mt-1">
        <span class="text-xs text-gray-500" id="progressBarStart">0%</span>
        <span class="text-xs text-gray-500" id="progressBarEnd">100%</span>
    </div>
</div>

<!-- Loading Skeleton Template -->
<template id="skeletonTemplate">
    <div class="animate-pulse">
        <div class="h-4 bg-gray-200 rounded w-3/4"></div>
        <div class="space-y-3 mt-4">
            <div class="h-4 bg-gray-200 rounded"></div>
            <div class="h-4 bg-gray-200 rounded w-5/6"></div>
            <div class="h-4 bg-gray-200 rounded w-4/6"></div>
        </div>
    </div>
</template>

<script>
    // Show full page loader
    function showFullPageLoader(message = 'Loading...') {
        const loader = document.getElementById('fullPageLoader');
        const messageElement = document.getElementById('loaderMessage');
        messageElement.textContent = message;
        loader.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    // Hide full page loader
    function hideFullPageLoader() {
        const loader = document.getElementById('fullPageLoader');
        loader.classList.add('hidden');
        document.body.style.overflow = '';
    }

    // Show inline loader
    function showInlineLoader(containerId, message = 'Loading...') {
        const container = document.getElementById(containerId);
        const loader = document.getElementById('inlineLoader').cloneNode(true);
        loader.id = `inlineLoader_${containerId}`;
        loader.querySelector('#inlineLoaderMessage').textContent = message;
        loader.classList.remove('hidden');
        container.innerHTML = '';
        container.appendChild(loader);
    }

    // Hide inline loader
    function hideInlineLoader(containerId) {
        const loader = document.getElementById(`inlineLoader_${containerId}`);
        if (loader) {
            loader.remove();
        }
    }

    // Show button loader
    function showButtonLoader(button, message = 'Loading...') {
        const originalContent = button.innerHTML;
        button.setAttribute('data-original-content', originalContent);
        const loader = document.getElementById('buttonLoader').cloneNode(true);
        loader.classList.remove('hidden');
        button.innerHTML = '';
        button.appendChild(loader);
        button.disabled = true;
    }

    // Hide button loader
    function hideButtonLoader(button) {
        const originalContent = button.getAttribute('data-original-content');
        if (originalContent) {
            button.innerHTML = originalContent;
            button.removeAttribute('data-original-content');
            button.disabled = false;
        }
    }

    // Update progress bar
    function updateProgress(percentage) {
        const progressBar = document.getElementById('progressBar');
        const progressBarFill = document.getElementById('progressBarFill');
        const progressBarStart = document.getElementById('progressBarStart');
        
        progressBar.classList.remove('hidden');
        progressBarFill.style.width = `${percentage}%`;
        progressBarStart.textContent = `${Math.round(percentage)}%`;
    }

    // Hide progress bar
    function hideProgress() {
        const progressBar = document.getElementById('progressBar');
        progressBar.classList.add('hidden');
    }

    // Create skeleton loader
    function createSkeleton(count = 1) {
        const template = document.getElementById('skeletonTemplate');
        const container = document.createElement('div');
        
        for (let i = 0; i < count; i++) {
            const skeleton = template.content.cloneNode(true);
            container.appendChild(skeleton);
            if (i < count - 1) {
                container.appendChild(document.createElement('hr'));
            }
        }
        
        return container;
    }

    // Show skeleton loader
    function showSkeleton(containerId, count = 1) {
        const container = document.getElementById(containerId);
        const skeleton = createSkeleton(count);
        container.innerHTML = '';
        container.appendChild(skeleton);
    }

    // Example usage of loading states with promises
    function withLoading(promise, options = {}) {
        const {
            fullPage = false,
            containerId = null,
            button = null,
            message = 'Loading...'
        } = options;

        if (fullPage) {
            showFullPageLoader(message);
        } else if (containerId) {
            showInlineLoader(containerId, message);
        } else if (button) {
            showButtonLoader(button, message);
        }

        return promise
            .finally(() => {
                if (fullPage) {
                    hideFullPageLoader();
                } else if (containerId) {
                    hideInlineLoader(containerId);
                } else if (button) {
                    hideButtonLoader(button);
                }
            });
    }

    // Example usage with file upload progress
    function withProgress(promise, progressCallback) {
        updateProgress(0);
        
        return promise
            .then(response => {
                progressCallback(100);
                setTimeout(hideProgress, 500);
                return response;
            })
            .catch(error => {
                hideProgress();
                throw error;
            });
    }
</script>