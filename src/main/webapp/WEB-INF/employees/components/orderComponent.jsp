<%-- 
    Document   : orderComponent
    Created on : Jun 26, 2025, 6:38:57 PM
    Author     : iphon
--%>

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
                    Total Order: <%= count%>
                </p>

                <!-- Icon -->
                <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center ml-4"> <!-- Added ml-4 for spacing -->
                    <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                    </svg>
                </div>
            </div>


        </div>

        <!-- Table Section -->
        <div class="w-full">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer Name </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Amount </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Shipping Fee </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Payment Method </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Payment Status </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Status Name </th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Voucher</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Address</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Created At</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ">Updated At</th>
                    </tr>
                </thead>

                <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">

                </tbody>
            </table>

            <div id="loadingOrder" class="text-center py-4">
                <!-- Loading Spinner or Message -->
            </div>
        </div>

    </div>
    <!-- Pagination Section -->
    <div id="pagination" class="flex justify-center py-4">
    </div>

</div>


