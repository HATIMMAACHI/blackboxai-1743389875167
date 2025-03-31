<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>Review Assignments</h2>
    
    <div class="card shadow-sm">
        <div class="card-header">
            <h4 class="mb-0">Papers Assigned for Review</h4>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Paper Title</th>
                            <th>Authors</th>
                            <th>Conference</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${assignments}" var="assignment">
                            <tr>
                                <td>${assignment.paper.title}</td>
                                <td>
                                    <c:forEach items="${assignment.paper.authors}" var="author" varStatus="loop">
                                        ${author.firstName} ${author.lastName}<c:if test="${!loop.last}">, </c:if>
                                    </c:forEach>
                                </td>
                                <td>${assignment.paper.conference.name}</td>
                                <td>${assignment.dueDate}</td>
                                <td>
                                    <span class="badge ${assignment.status == 'COMPLETED' ? 'badge-success' : 
                                                         assignment.status == 'PENDING' ? 'badge-warning' : 'badge-secondary'}">
                                        ${assignment.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/review/submit?paperId=${assignment.paper.id}" 
                                       class="btn btn-sm ${assignment.status == 'COMPLETED' ? 'btn-outline-info' : 'btn-primary'}">
                                        ${assignment.status == 'COMPLETED' ? 'View Review' : 'Submit Review'}
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />