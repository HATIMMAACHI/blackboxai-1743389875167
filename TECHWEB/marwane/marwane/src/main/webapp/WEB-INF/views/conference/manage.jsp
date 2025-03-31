<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>Conference Management</h2>
    
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Quick Actions</h4>
                </div>
                <div class="card-body">
                    <a href="${pageContext.request.contextPath}/conference/create" 
                       class="btn btn-success btn-block mb-2">
                        Create New Conference
                    </a>
                    <a href="${pageContext.request.contextPath}/committee/manage" 
                       class="btn btn-info btn-block mb-2">
                        Manage Committees
                    </a>
                    <a href="${pageContext.request.contextPath}/paper/review" 
                       class="btn btn-warning btn-block">
                        Review Papers
                    </a>
                </div>
            </div>
        </div>
        
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h4 class="mb-0">Active Conferences</h4>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="thead-light">
                                <tr>
                                    <th>Conference</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${conferences}" var="conference">
                                    <tr>
                                        <td>${conference.name}</td>
                                        <td>${conference.startDate} - ${conference.endDate}</td>
                                        <td>
                                            <span class="badge ${conference.status == 'ACTIVE' ? 'badge-success' : 'badge-secondary'}">
                                                ${conference.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/conference/edit?id=${conference.id}" 
                                               class="btn btn-sm btn-outline-primary">
                                                Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/conference/details?id=${conference.id}" 
                                               class="btn btn-sm btn-outline-info ml-1">
                                                Details
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
    </div>
</div>

<jsp:include page="../common/footer.jsp" />