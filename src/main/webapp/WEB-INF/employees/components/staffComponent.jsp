<%-- 
    Document   : staff
    Created on : Jun 12, 2025, 3:42:15 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    Integer count = (Integer) request.getAttribute("count");
%>
<div class="">
    <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">
<!--        <div class="px-6 py-4 border-b border-gray-200">-->
            <div class="flex items-center justify-between p-6">
                <h2 class="text-lg font-semibold text-gray-900">Staff List (Total: <%= count%>)</h2>
                <div class="flex items-center space-x-3">
                    <button id="create-staff-button" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2">
                        <i data-lucide="diamond-plus" class="w-5 h-5"></i>
                        <span>Add New Staff</span>
                    </button>
                </div>
            </div>

            <div class="w-full">
                <table class="w-full max-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Information</th>
                            <th class="px-5 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">

                    </tbody>
                </table>
                <div id="loadingStaff"></div>
            </div>
        </div>
    </div>     
</div>
<div id="pagination"></div>
