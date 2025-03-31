<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>Conference List</h2>
    
    <div class="text-right mb-3">
        <a href="${pageContext.request.contextPath}/conference/create" 
           class="btn btn-primary">
            <i class="fas fa-plus"></i> Create New Conference
        </a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Name</th>
                            <th>Dates</th>
                            <th>Location</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${conferences}" var="conference">
                            <tr>
                                <td>
                                    <c:if test="${not empty conference.logoPath}">
                                        <img src="${pageContext.request.contextPath}/uploads/${conference.logoPath}" 
                                             alt="${conference.name}" 
                                             style="max-height: 30px; margin-right: 10px;">
                                    </c:if>
                                    ${conference.name}
                                </td>
                                <td>
                                    ${conference.startDate} - ${conference.endDate}
                                </td>
                                <td>${conference.location}</td>
                                <td>
                                    <span class="badge ${conference.status == 'ACTIVE' ? 'badge-success' : 
                                                         conference.status == 'UPCOMING' ? 'badge-info' : 
                                                         conference.status == 'COMPLETED' ? 'badge-secondary' : 'badge-warning'}">
                                        ${conference.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/conference/${conference.id}" 
                                       class="btn btn-sm btn-outline-info">
                                        View
                                    </a>
                                    <c:if test="${sessionScope.role == 'PRESIDENT'}">
                                        <a href="${pageContext.request.contextPath}/conference/edit?id=${conference.id}" 
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