<%-- 
    Document   : orderTemplate
    Created on : Jun 26, 2025, 6:39:55 PM
    Author     : iphon
    Updated    : Enhanced UI with modern design
--%>

<%@ page import="Models.Order" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Integer currentPage = (Integer) request.getAttribute("page");
    Integer limit = (Integer) request.getAttribute("limit");

    if (orders != null && !orders.isEmpty()) {
%>

<% for (Order order : orders) {%>
<tr data-order-id="<%= order.getId()%>" 
    class="group hover:bg-gradient-to-r hover:from-blue-50 hover:to-indigo-50 transition-all duration-300 border-b border-gray-100 hover:shadow-sm">

    <!-- Order ID with enhanced styling -->
    <td class="px-6 py-5 whitespace-nowrap text-center">
        <div class="flex items-center justify-center">
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-bold bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-sm">
                #<%= order.getId()%>
            </span>
        </div>
    </td>

    <!-- Customer Name with avatar placeholder -->
    <td class="px-4 py-5 whitespace-nowrap">
        <div class="flex items-center justify-center">
            <div class="flex-shrink-0 h-8 w-8 mr-3">
                <div class="h-8 w-8 rounded-full bg-gradient-to-r from-purple-400 to-pink-400 flex items-center justify-center text-white text-xs font-semibold">
                    <%= order.getCustomer() != null && order.getCustomer().getName() != null
                            ? order.getCustomer().getName().substring(0, 1).toUpperCase() : "?"%>
                </div>
            </div>
            <div class="text-sm font-medium text-gray-900">
                <%= order.getCustomer() != null ? order.getCustomer().getName() : "N/A"%>
            </div>
        </div>
    </td>

    <!-- Total Amount with currency styling -->
    <td class="px-4 py-5 whitespace-nowrap text-center">
        <div class="flex items-center justify-center">
            <span class="inline-flex items-center px-3 py-1 rounded-lg text-sm font-bold bg-green-100 text-green-800 border border-green-200">
                <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z"/>
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.51-1.31c-.562-.649-1.413-1.076-2.353-1.253V5z" clip-rule="evenodd"/>
                </svg>
                <%= String.format("%.2f", order.getTotalAmount() + order.getShippingFee())%>VND
            </span>
        </div>
    </td>

    <!-- Payment Method -->
    <td class="px-4 py-5 whitespace-nowrap text-center">
        <div class="flex items-center justify-center">
            <span class="inline-flex items-center px-3 py-1 rounded-lg text-sm font-medium bg-blue-100 text-gray-800 border border-gray-200">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                </svg>
                <%= order.getPaymentMethod() != null ? order.getPaymentMethod().getName() : "N/A"%>
            </span>
        </div>
    </td>

    <!-- Payment Status-->

    <td class="px-4 py-5 whitespace-nowrap text-center">
        <% if (order.getPaymentStatus() != null) {
                String payStatus = order.getPaymentStatus().getName();
                String payClass
                        = ("Paid".equals(payStatus) || "Completed".equals(payStatus)) ? "bg-green-50 text-green-700 border-green-200"
                        : "Pending".equals(payStatus) ? "bg-yellow-50 text-yellow-700 border-yellow-200"
                        : "bg-red-50 text-red-700 border-red-200";
        %>
        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border-2 <%= payClass%>">
            <% if ("Paid".equals(payStatus) || "Completed".equals(payStatus)) { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <% } else if ("Pending".equals(payStatus)) { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <circle cx="10" cy="10" r="8"/>
            <path fill-rule="evenodd" d="M10 6v4l3 3" clip-rule="evenodd"/>
            </svg>
            <% } else { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
            </svg>
            <% }%>
            <%= payStatus%>
        </span>
        <% } else { %>
        <span class="inline-flex items-center px-3 py-1 rounded-full bg-gray-100 text-gray-600 font-semibold text-xs border-2 border-gray-200">
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"/>
            </svg>
            N/A
        </span>
        <% } %>
    </td>


    <!-- Order Status -->
    <td class="px-4 py-5 whitespace-nowrap text-center">
        <% if (order.getOrderStatus() != null) {%>
        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border-2 <%="Delivered".equals(order.getOrderStatus().getName()) ? "bg-green-50 text-green-700 border-green-200"
                : "Processing".equals(order.getOrderStatus().getName()) ? "bg-blue-50 text-blue-700 border-blue-200"
                : "Shipped".equals(order.getOrderStatus().getName()) ? "bg-purple-50 text-purple-700 border-purple-200"
                : "Cancelled".equals(order.getOrderStatus().getName()) ? "bg-red-50 text-red-700 border-red-200"
                : "bg-gray-50 text-gray-700 border-gray-200"%>">
            <% if ("Delivered".equals(order.getOrderStatus().getName())) { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z"/>
            </svg>
            <% } else if ("Processing".equals(order.getOrderStatus().getName())) { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd"/>
            </svg>
            <% } else if ("Shipped".equals(order.getOrderStatus().getName())) { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path d="M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z"/>
            <path d="M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1V5a1 1 0 00-1-1H3zM14 7a1 1 0 00-1 1v6.05A2.5 2.5 0 0115.95 16H17a1 1 0 001-1v-5a1 1 0 00-.293-.707L16 7.586A1 1 0 0015.414 7H14z"/>
            </svg>
            <% } else { %>
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
            </svg>
            <% }%>
            <%= order.getOrderStatus().getName()%>
        </span>
        <% } else { %>
        <span class="inline-flex items-center px-3 py-1 rounded-full bg-gray-100 text-gray-600 font-semibold text-xs border-2 border-gray-200">
            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"/>
            </svg>
            N/A
        </span>
        <% }%>
    </td>

    <!-- Voucher Code-->
    <td class="px-4 py-5 whitespace-nowrap text-center">
        <% if (order.getVoucher() != null && order.getVoucher().getCode() != null) {%>
        <span class="inline-flex items-center px-3 py-1 rounded-lg text-sm font-mono font-semibold bg-gradient-to-r from-purple-100 to-pink-100 text-purple-800 border border-purple-200">
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M5 5a3 3 0 015-2.236A3 3 0 0114.83 6H16a2 2 0 110 4h-5V9a1 1 0 10-2 0v1H4a2 2 0 110-4h1.17C5.06 5.687 5 5.35 5 5zm4 1V5a1 1 0 10-1 1h1zm3 0a1 1 0 10-1-1v1h1z" clip-rule="evenodd"/>
            <path d="M9 11H3v5a2 2 0 002 2h4v-7zM11 18h4a2 2 0 002-2v-5h-6v7z"/>
            </svg>
            <%= order.getVoucher().getCode()%>
        </span>
        <% } else { %>
        <span class="inline-flex items-center px-3 py-1 rounded-lg text-sm text-gray-500 bg-gray-50 border border-gray-200">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
            No voucher
        </span>
        <% }%>
    </td>

    <!-- Action Buttons with enhanced styling -->
    <td class="px-6 py-5 whitespace-nowrap text-center">
        <div class="flex items-center justify-center space-x-3">
            <!-- View Details Button -->
            <button type="button" data-id="<%= order.getId()%>" 
                    class="detail-order-button group relative inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:from-blue-600 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transform hover:scale-105 transition-all duration-200 shadow-sm hover:shadow-md"
                    title="View order details">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
                Details
            </button>   

            <!-- Edit Button -->
            <button data-order-id="<%= order.getId()%>"
                    class="openEditOrderStatus group relative inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium bg-gradient-to-r from-amber-500 to-orange-500 text-white hover:from-amber-600 hover:to-orange-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-amber-500 transform hover:scale-105 transition-all duration-200 shadow-sm hover:shadow-md"
                    title="Edit order status">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
                Edit
            </button>
        </div>
    </td>
</tr>
<% } %>

<% } else { %>
<tr>
    <td colspan="9" class="px-6 py-16 text-center">
        <div class="flex flex-col items-center justify-center space-y-4">
            <!-- Enhanced empty state icon -->
            <div class="relative">
                <svg class="w-20 h-20 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                </svg>
                <div class="absolute -top-1 -right-1 w-6 h-6 bg-gray-200 rounded-full flex items-center justify-center">
                    <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </div>
            </div>

            <!-- Enhanced empty state text -->
            <div class="text-center">
                <h3 class="text-xl font-semibold text-gray-700 mb-2">No Orders Found</h3>
                <p class="text-gray-500 max-w-md">
                    There are currently no orders to display. Orders will appear here once customers start placing them.
                </p>
            </div>

            <!-- Optional call-to-action -->
            <div class="mt-4">
                <button class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-blue-700 bg-blue-100 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                    </svg>
                    Refresh
                </button>
            </div>
        </div>
    </td>
</tr>
<% }%>