<%-- 
    Document   : orderComponent
    Created on : Jun 26, 2025, 6:38:57 PM
    Author     : iphon
--%>
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
            <div class="flex items-center space-x-4">
                <!-- Total Order Count -->
                <p class="text-3xl font-bold text-gray-900 order-count">
                    Total Orders: <%= count != null ? count : 0%>
                </p>
                <!-- Icon -->
                <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center ml-4">
                    <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                    </svg>
                </div>
            </div>
        </div>

        <!-- Table Section -->
        <div class="w-full overflow-x-auto">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Order ID</th>
                        <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Customer</th>
                        <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Total Amount</th>
                        <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Payment Method</th>
                        <th class="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Payment Status</th>
                        <th class="px-3 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Order Status</th>
                        <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Voucher</th>
                        <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="OrderContainer" class="bg-white divide-y divide-gray-200">
                    <!-- Order data will be loaded here dynamically -->
                </tbody>
            </table>
            <div id="LoadingOrders" class="text-center py-4">
                <!-- Loading Spinner will appear here -->
            </div>
        </div>
    </div>

    <!-- Pagination Section -->
    <div id="pagination" class="flex justify-center py-4 mt-6">
        <!-- Pagination will be loaded here -->
    </div>
</div>