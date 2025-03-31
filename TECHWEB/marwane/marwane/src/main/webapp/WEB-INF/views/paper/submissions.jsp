<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>My Paper Submissions</h2>
    
    <div class="text-right mb-3">
        <a href="${pageContext.request.contextPath}/paper/submit" 
           class="btn btn-primary">
            <i class="fas fa-plus"></i> Submit New Paper
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Title</th>
                            <th>Conference</th>
                            <th>Status</th>
                            <th>Submission Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${papers}" var="paper">
                            <tr>
                                <td>${paper.title}</td>
                                <td>${paper.conference.name}</td>
                                <td>
                                    <span class="badge ${paper.status == 'ACCEPTED' ? 'badge-success' : 
                                                         paper.status == 'REJECTED' ? 'badge-danger' : 
                                                         paper.status == 'UNDER_REVIEW' ? 'badge-warning' : 'badge-secondary'}">
                                        ${paper.status}
                                    </span>
                                </td>
                                <td>${paper.submissionDate}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/paper/view?id=${paper.id}" 
                                       class="btn btn-sm btn-outline-info">
                                        View
                                    </a>
                                    <c:if test="${paper.status == 'DRAFT' || paper.status == 'REJECTED'}">
                                        <a href="${pageContext.request.contextPath}/paper/edit?id=${paper.id}" 
                                           class="btn btn-sm btn-outline-primary ml-1">
                                            Edit
                                        </a>
                                    </c:if>
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