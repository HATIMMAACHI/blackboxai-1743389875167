<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Committees - CMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- Navigation -->
        <nav class="bg-indigo-600 shadow-lg">
            <div class="max-w-7xl mx-auto px-4">
                <div class="flex justify-between h-16">
                    <div class="flex">
                        <div class="flex-shrink-0 flex items-center">
                            <a href="../dashboard" class="text-white text-xl font-bold">CMS</a>
                        </div>
                    </div>
                    <div class="flex items-center">
                        <a href="../dashboard" class="text-gray-200 hover:text-white">
                            <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <!-- Conference Info -->
            <div class="bg-white shadow overflow-hidden sm:rounded-lg mb-6">
                <div class="px-4 py-5 sm:px-6">
                    <h2 class="text-xl font-semibold text-gray-900">Conference Details</h2>
                    <p class="mt-1 max-w-2xl text-sm text-gray-500">${conference.name} (${conference.acronym})</p>
                </div>
            </div>

            <!-- Committee Management Tabs -->
            <div class="bg-white shadow sm:rounded-lg">
                <div class="border-b border-gray-200">
                    <nav class="-mb-px flex" aria-label="Tabs">
                        <button onclick="switchTab('sc')" 
                            class="tab-btn w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm border-indigo-500 text-indigo-600">
                            Scientific Committee
                        </button>
                        <button onclick="switchTab('pc')" 
                            class="tab-btn w-1/2 py-4 px-1 text-center border-b-2 font-medium text-sm border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300">
                            Program Committee
                        </button>
                    </nav>
                </div>

                <!-- Scientific Committee Section -->
                <div id="sc-section" class="committee-section p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-lg font-medium text-gray-900">Scientific Committee Members</h3>
                        <button onclick="openAddMemberModal('SC')" 
                            class="bg-indigo-600 px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="fas fa-plus mr-2"></i>Add Member
                        </button>
                    </div>

                    <!-- Members Table -->
                    <div class="flex flex-col">
                        <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
                            <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                                <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                                    <table class="min-w-full divide-y divide-gray-200">
                                        <thead class="bg-gray-50">
                                            <tr>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Member</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Expertise</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Statistics</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="bg-white divide-y divide-gray-200">
                                            <c:forEach items="${scMembers}" var="member">
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="flex items-center">
                                                            <div>
                                                                <div class="text-sm font-medium text-gray-900">${member.firstName} ${member.lastName}</div>
                                                                <div class="text-sm text-gray-500">${member.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${member.role == 'CHAIR' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                                            ${member.role}
                                                        </span>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                        ${member.expertise}
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="text-sm text-gray-900">Assigned: ${member.assignedPapers}</div>
                                                        <div class="text-sm text-gray-500">Completed: ${member.completedReviews}</div>
                                                        <div class="text-sm text-gray-500">Rate: ${member.participationRate}%</div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                        <button onclick="editMember(${member.id})" class="text-indigo-600 hover:text-indigo-900 mr-3">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button onclick="removeMember(${member.id}, 'SC')" class="text-red-600 hover:text-red-900">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
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

                <!-- Program Committee Section -->
                <div id="pc-section" class="committee-section hidden p-6">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="text-lg font-medium text-gray-900">Program Committee Members</h3>
                        <button onclick="openAddMemberModal('PC')" 
                            class="bg-indigo-600 px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="fas fa-plus mr-2"></i>Add Member
                        </button>
                    </div>

                    <!-- Members Table -->
                    <div class="flex flex-col">
                        <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
                            <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                                <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                                    <table class="min-w-full divide-y divide-gray-200">
                                        <thead class="bg-gray-50">
                                            <tr>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Member</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Expertise</th>
                                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="bg-white divide-y divide-gray-200">
                                            <c:forEach items="${pcMembers}" var="member">
                                                <tr>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <div class="flex items-center">
                                                            <div>
                                                                <div class="text-sm font-medium text-gray-900">${member.firstName} ${member.lastName}</div>
                                                                <div class="text-sm text-gray-500">${member.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap">
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${member.role == 'CHAIR' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                                            ${member.role}
                                                        </span>
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                        ${member.expertise}
                                                    </td>
                                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                        <button onclick="editMember(${member.id})" class="text-indigo-600 hover:text-indigo-900 mr-3">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button onclick="removeMember(${member.id}, 'PC')" class="text-red-600 hover:text-red-900">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
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
        </div>
    </div>

    <!-- Add/Edit Member Modal -->
    <div id="memberModal" class="fixed z-10 inset-0 overflow-y-auto hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
            <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                <form id="memberForm" onsubmit="submitMemberForm(event)">
                    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4" id="modal-title">Add Committee Member</h3>
                        <div class="space-y-4">
                            <input type="hidden" id="memberId" name="id">
                            <input type="hidden" id="committeeType" name="committeeType">
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700">Email</label>
                                <input type="email" name="email" id="memberEmail" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700">Role</label>
                                <select name="role" id="memberRole" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="MEMBER">Member</option>
                                    <option value="CHAIR">Chair</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700">Expertise Areas</label>
                                <input type="text" name="expertise" id="memberExpertise" required
                                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                                    placeholder="e.g., Machine Learning, Data Mining">
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                        <button type="submit"
                            class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Save
                        </button>
                        <button type="button" onclick="closeModal()"
                            class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white shadow mt-8">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <p class="text-center text-sm text-gray-500">© 2024 Conference Management System. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // Tab switching
        function switchTab(tab) {
            const sections = document.querySelectorAll('.committee-section');
            const buttons = document.querySelectorAll('.tab-btn');
            
            sections.forEach(section => {
                section.classList.add('hidden');
            });
            
            buttons.forEach(button => {
                button.classList.remove('border-indigo-500', 'text-indigo-600');
                button.classList.add('border-transparent', 'text-gray-500');
            });
            
            document.getElementById(`${tab}-section`).classList.remove('hidden');
            event.currentTarget.classList.remove('border-transparent', 'text-gray-500');
            event.currentTarget.classList.add('border-indigo-500', 'text-indigo-600');
        }

        // Modal handling
        function openAddMemberModal(type) {
            document.getElementById('modal-title').textContent = `Add ${type} Member`;
            document.getElementById('committeeType').value = type;
            document.getElementById('memberModal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('memberModal').classList.add('hidden');
            document.getElementById('memberForm').reset();
        }

        // Member management
        function editMember(memberId) {
            fetch(`/committee/member/${memberId}`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('memberId').value = data.id;
                    document.getElementById('memberEmail').value = data.email;
                    document.getElementById('memberRole').value = data.role;
                    document.getElementById('memberExpertise').value = data.expertise;
                    document.getElementById('committeeType').value = data.committeeType;
                    document.getElementById('modal-title').textContent = 'Edit Member';
                    document.getElementById('memberModal').classList.remove('hidden');
                });
        }

        function removeMember(memberId, type) {
            if (confirm('Are you sure you want to remove this member?')) {
                fetch(`/committee/member/${memberId}`, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        alert('Failed to remove member');
                    }
                });
            }
        }

        // Form submission
        function submitMemberForm(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            fetch('/committee/member', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Failed to save member');
                }
            });
        }
    </script>
</body>
</html>