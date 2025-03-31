<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>Committee Statistics</h2>
    <div class="row">
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <h4 class="mb-0">${committee.type} Committee Performance</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card bg-light mb-3">
                                <div class="card-body text-center">
                                    <h5 class="card-title">Participation Rate</h5>
                                    <div class="display-4 text-primary">
                                        ${participationRate}%
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card bg-light mb-3">
                                <div class="card-body text-center">
                                    <h5 class="card-title">Total Members</h5>
                                    <div class="display-4 text-primary">
                                        ${committee.members.size() + (committee.chair != null ? 1 : 0)}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <h5 class="mt-4">Review Completion</h5>
                    <div class="progress mb-3">
                        <div class="progress-bar bg-success" 
                             role="progressbar" 
                             id="participationProgress"
                             aria-valuemin="0" 
                             aria-valuemax="100">
                        </div>
                    </div>
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            const progressBar = document.getElementById('participationProgress');
                            progressBar.style.width = '${participationRate}%';
                            progressBar.setAttribute('aria-valuenow', '${participationRate}');
                        });
                    </script>
                    
                    <div class="table-responsive mt-4">
                        <table class="table table-hover">
                            <thead class="thead-light">
                                <tr>
                                    <th>Member</th>
                                    <th>Assigned Reviews</th>
                                    <th>Completed</th>
                                    <th>Completion %</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${not empty committee.chair}">
                                    <tr>
                                        <td>${committee.chair.user.firstName} ${committee.chair.user.lastName} (Chair)</td>
                                        <td>${committee.chair.assignedReviews}</td>
                                        <td>${committee.chair.completedReviews}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${committee.chair.assignedReviews > 0}">
                                                    ${(committee.chair.completedReviews / committee.chair.assignedReviews) * 100}%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${committee.members}" var="member">
                                    <tr>
                                        <td>${member.user.firstName} ${member.user.lastName}</td>
                                        <td>${member.assignedReviews}</td>
                                        <td>${member.completedReviews}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${member.assignedReviews > 0}">
                                                    ${(member.completedReviews / member.assignedReviews) * 100}%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h4 class="mb-0">Quick Actions</h4>
                </div>
                <div class="card-body">
                    <a href="${pageContext.request.contextPath}/committee/members?committeeId=${committee.id}" 
                       class="btn btn-primary btn-block mb-2">
                        View Members
                    </a>
                    <a href="${pageContext.request.contextPath}/review/assignments?committeeId=${committee.id}" 
                       class="btn btn-secondary btn-block mb-2">
                        Review Assignments
                    </a>
                    <a href="${pageContext.request.contextPath}/committee/dashboard?conferenceId=${committee.conferenceId}&type=${committee.type}" 
                       class="btn btn-info btn-block">
                        Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />