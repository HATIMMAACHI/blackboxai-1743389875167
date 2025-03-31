<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/head.jsp" />
<jsp:include page="../common/header.jsp" />

<div class="container mt-4">
    <h2>Committee Members</h2>
    <div class="card shadow-sm">
        <div class="card-header">
            <h4 class="mb-0">${committee.type} Committee</h4>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Expertise</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${not empty committee.chair}">
                            <tr>
                                <td>${committee.chair.user.firstName} ${committee.chair.user.lastName}</td>
                                <td>Chair</td>
                                <td>-</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-danger" 
                                        onclick="confirmRemoveMember('${committee.chair.user.id}')">
                                        Remove
                                    </button>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach items="${committee.members}" var="member">
                            <tr>
                                <td>${member.user.firstName} ${member.user.lastName}</td>
                                <td>Member</td>
                                <td>${member.expertise}</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-danger" 
                                        onclick="confirmRemoveMember('${member.user.id}')">
                                        Remove
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${sessionScope.role eq 'PRESIDENT'}">
                <div class="mt-4">
                    <button class="btn btn-primary" data-toggle="modal" data-target="#addMemberModal">
                        Add New Member
                    </button>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Add Member Modal -->
<div class="modal fade" id="addMemberModal" tabindex="-1" role="dialog" aria-labelledby="addMemberModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addMemberModalLabel">Add Committee Member</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/committee/members?committeeId=${committee.id}" method="post">
                <input type="hidden" name="action" value="add-member">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="userId">Select Member</label>
                        <select class="form-control" id="userId" name="userId" required>
                            <option value="">-- Select User --</option>
                            <c:forEach items="${availableUsers}" var="user">
                                <option value="${user.id}">${user.firstName} ${user.lastName} (${user.affiliation})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="expertise">Expertise Area</label>
                        <input type="text" class="form-control" id="expertise" name="expertise" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Member</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function confirmRemoveMember(userId) {
    if (confirm('Are you sure you want to remove this member from the committee?')) {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/committee/members?committeeId=${committee.id}';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'remove-member';
        form.appendChild(actionInput);
        
        const memberInput = document.createElement('input');
        memberInput.type = 'hidden';
        memberInput.name = 'memberId';
        memberInput.value = userId.toString();
        form.appendChild(memberInput);
        
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<jsp:include page="../common/footer.jsp" />