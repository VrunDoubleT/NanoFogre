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
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between pb-4">
                <h2 class="text-lg font-semibold text-gray-900">Staff List (Total: <%= count%>)</h2>
                <div class="flex items-center space-x-3">
                    <button id="create-product-button" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2">
                        <span>Add New Staff</span>
                    </button>
                    <div class="flex items-center justify-center">
                        <div class="relative w-full max-w-md">
                            <input type="text" placeholder="Search..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"/>
                            <div class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">
                                <!-- Icon -->
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-4.35-4.35M16 10a6 6 0 11-12 0 6 6 0 0112 0z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
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

        <div id="pagination"></div>
