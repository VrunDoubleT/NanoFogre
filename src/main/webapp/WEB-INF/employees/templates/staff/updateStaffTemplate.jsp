<%-- 
    Document   : updateStaffTemplate
    Created on : Jun 16, 2025, 8:27:00 AM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Models.Employee staff = (Models.Employee) request.getAttribute("staff");
%>
<div class="bg-gray-100">
    <div class="w-[80vh] mx-auto h-auto flex flex-col bg-white shadow-2xl overflow-hidden">
        <form method="post">
            <input type="hidden" name="type" value="update">
            <input type="hidden" name="id" value="<%= staff.getId()%>">
            <!-- Header -->
            <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
                <h1 class="text-2xl font-bold text-white m-2 ml-0">Update Staff</h1>
                <div class="flex items-center space-x-4">
                    <button type="submit" id="update-staff-btn" class="px-4 flex py-2 bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                        <i data-lucide="pencil"></i>
                        <i class="fas fa-save mr-2"></i>Update
                    </button>
                </div>
            </div>

            <!-- Content -->
            <div class="p-8 w-full h-full overflow-y-auto">
                <!-- Details Tab -->
                <div id="details-content" class="tab-content w-full">
                    <div id="staffForm">
                        <div class="bg-gray-50 rounded-xl p-6">

                            <div class="space-y-4">
                                <!-- Name -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Name</label>
                                    <input placeholder="Enter name" type="text" name="name" id="name" value="<%= staff.getName()%>"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                    <span id="nameError" class="text-sm text-red-500 mt-1 block"></span>
                                </div>

                                <!-- Email -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                                    <input placeholder="Enter email address" type="text" name="email" id="email" value="<%= staff.getEmail()%>"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                    <span id="emailError" class="text-sm text-red-500 mt-1 block"></span>
                                </div>

                                <!-- Status -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Change Status</label>
                                    <div class="flex space-x-10 pl-5">
                                        <label class="flex items-center space-x-2">
                                            <input type="radio" name="status" value="Active"
                                                   class="accent-blue-600"
                                                   <%= !staff.isIsBlock() ? "checked" : ""%>>
                                            <span class="text-gray-800">Active</span>
                                        </label>
                                        <label class="flex items-center space-x-2">
                                            <input type="radio" name="status" value="Block"
                                                   class="accent-red-600"
                                                   <%= staff.isIsBlock() ? "checked" : ""%>>
                                            <span class="text-gray-800">Block</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>



