<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2>${conference.name}</h2>
                        <span class="badge ${conference.status == 'ACTIVE' ? 'badge-success' : 
                                           conference.status == 'UPCOMING' ? 'badge-info' : 
                                           conference.status == 'COMPLETED' ? 'badge-secondary' : 'badge-warning'}">
                            ${conference.status}
                        </span>
                    </div>

                    <c:if test="${not empty conference.logoPath}">
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/uploads/${conference.logoPath}" 
                                 alt="${conference.name}" 
                                 class="img-fluid" style="max-height: 200px;">
                        </div>
                    </c:if>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5><i class="fas fa-calendar-alt mr-2"></i>Dates</h5>
                            <p>${conference.startDate} to ${conference.endDate}</p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-map-marker-alt mr-2"></i>Location</h5>
                            <p>${conference.location}</p>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h5><i class="fas fa-globe mr-2"></i>Website</h5>
                            <p><a href="${conference.website}" target="_blank">${conference.website}</a></p>
                        </div>
                        <div class="col-md-6">
                            <h5><i class="fas fa-tag mr-2"></i>Type</h5>
                            <p>${conference.type}</p>
                        </div>
                    </div>

                    <h5><i class="fas fa-info-circle mr-2"></i>Description</h5>
                    <p>${conference.thematic}</p>

                    <h5 class="mt-4"><i class="fas fa-tags mr-2"></i>Topics</h5>
                    <div class="d-flex flex-wrap">
                        <c:forEach items="${conference.topics}" var="topic">
                            <span class="badge badge-pill badge-light mr-2 mb-2">${topic}</span>
                        </c:forEach>
                    </div>

                    <h5 class="mt-4"><i class="fas fa-clock mr-2"></i>Important Dates</h5>
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <tbody>
                                <tr>
                                    <td>Submission Deadline:</td>
                                    <td>${conference.submissionDeadline}</td>
                                </tr>
                                <tr>
                                    <td>Review Deadline:</td>
                                    <td>${conference.reviewDeadline}</td>
                                </tr>
                                <tr>
                                    <td>Notification Deadline:</td>
                                    <td>${conference.notificationDeadline}</td>
                                </tr>
                                <tr>
                                    <td>Camera Ready Deadline:</td>
                                    <td>${conference.cameraReadyDeadline}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">Actions</h5>
                </div>
                <div class="card-body">
                    <c:if test="${sessionScope.role == 'PRESIDENT'}">
                        <a href="${pageContext.request.contextPath}/conference/edit?id=${conference.id}" 
                           class="btn btn-primary btn-block mb-2">
                            <i class="fas fa-edit"></i> Edit Conference
                        </a>
                        <button class="btn btn-danger btn-block mb-2" 
                                data-conference-id="${conference.id}" 
                                data-context-path="${pageContext.request.contextPath}" 
                                class="delete-conference-btn">
                            <i class="fas fa-trash"></i> Delete Conference
                        </button>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/paper/submit?conferenceId=${conference.id}" 
                       class="btn btn-success btn-block mb-2">
                        <i class="fas fa-plus"></i> Submit Paper
                    </a>
                    <a href="${pageContext.request.contextPath}/committee/manage?conferenceId=${conference.id}" 
                       class="btn btn-info btn-block">
                        <i class="fas fa-users"></i> Manage Committees
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Simple inline implementation
function confirmDelete(conferenceId) {
    if (confirm('Are you sure you want to delete this conference?')) {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '<c:out value="${pageContext.request.contextPath}"/>/conference/' + conferenceId;
        
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'DELETE';
        form.appendChild(methodInput);
        
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<jsp:include page="../common/footer.jsp" />