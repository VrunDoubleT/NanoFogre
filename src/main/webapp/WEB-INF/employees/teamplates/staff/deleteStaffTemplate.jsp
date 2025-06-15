<%-- 
    Document   : deleteStaffTemplate
    Created on : Jun 15, 2025, 9:04:47 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String id = request.getParameter("id");
%>
<div class="bg-gray-100">
    <div class="w-4x1 mx-auto h-auto flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-5 py-2">
            <h2 class="text-1xl font-bold text-white ml-0 my-1">Delete Confirmation</h2>
        </div>

        <!-- Tab Content -->
        <div class="p-8 w-full h-full overflow-y-auto">
            <p class="text-gray-600 mb-6">Are you sure you want to delete this staff?</p>
            <div class="flex justify-center gap-4">
                <button id="btnConfirmDelete" data-id="<%= id%>" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded">Delete</button>
            </div>
        </div>
    </div>
</div>
