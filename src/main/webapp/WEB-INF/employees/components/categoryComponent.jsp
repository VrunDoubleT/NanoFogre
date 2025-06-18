<%@page import="Models.Category"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    Integer count = (Integer) request.getAttribute("total");
%>

<div class="">

    <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">

        <!-- Header Section -->
        <div class="flex items-center justify-between p-6">
            <div class="flex items-center space-x-4"> <!-- Added space-x-4 for spacing between text and icon -->
                <!-- Total Category -->
                <p class="text-3xl font-bold text-gray-900 category-count">
                    Total Category: <%= count%>
                </p>

                <!-- Icon -->
                <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center ml-4"> <!-- Added ml-4 for spacing -->
                    <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                    </svg>
                </div>
            </div>

            <!-- Add Category Button -->
            <div class="flex items-center space-x-3">
                <button id="create-category-button" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center justify-center space-x-2"> <!-- Added justify-center -->
                    <span class="text-center">Add New Category</span>
                </button>
            </div>
        </div>

        <!-- Table Section -->
        <div class="w-full">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category Name</th>
                        <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">
                    <!-- Data Rows go here -->
                    <tr>
                        <td class="px-6 py-4 text-sm font-medium text-gray-900">1</td>
                        <td class="px-6 py-4 text-sm text-gray-500">Category 1</td>
                        <td class="px-4 py-3 text-center">
                            <button class="bg-blue-200 hover:bg-blue-300 p-2 rounded-full">
                                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                                </svg>
                            </button>
                            <button class="bg-yellow-200 hover:bg-yellow-300 p-2 rounded-full ml-2">
                                <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                                </svg>
                            </button>
                            <button class="bg-red-200 hover:bg-red-300 p-2 rounded-full ml-2">
                                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </td>
                    </tr>
                    <!-- More rows can be added dynamically -->
                </tbody>
            </table>

            <div id="loadingCategory" class="text-center py-4">
                <!-- Loading Spinner or Message -->
            </div>
        </div>

        <!-- Pagination Section -->
        <div id="pagination" class="flex justify-center py-4">
        </div>

    </div>

</div>
