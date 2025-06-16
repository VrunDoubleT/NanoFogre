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
        <!-- Header -->
        <div class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white justify-center pl-6 p-4 rounded-t-2xl">
            <h2 class="text-lg font-bold">Change Status</h2>
        </div>

        <!-- Content -->
        <form class="p-6 space-y-5" method="post">
            <input type="hidden" name="type" value="update">
            <input type="hidden" name="id" value="<%= staff.getId()%>">

            <div>
                <label class="block text-gray-700 text-sm font-medium text-[15px] mb-4">Change account status:</label>
                <div class="flex flex-col space-y-3 pl-8">
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

            <div class="text-center">
                <button type="submit"
                        class="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition">
                    Apply
                </button>
            </div>
        </form>
    </div>
</div>



