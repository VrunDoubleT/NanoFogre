<%-- 
    Document   : orderTemplate
    Created on : Jun 26, 2025, 6:39:55 PM
    Author     : iphon
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
<tr data-order-id="<%= order.getId()%>" class="hover:bg-gray-50 transition-colors duration-200">
    <!-- Order ID -->
    <td class="px-4 py-4 whitespace-nowrap text-center ">
        <span class="font-bold text-lg text-gray-900 ">#<%= order.getId()%></span>
    </td>

    <!-- Customer Name -->
    <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
        <div class="text-sm font-medium text-md">
            <%= order.getCustomer() != null ? order.getCustomer().getName() : "N/A"%>
        </div>
    </td>

    <!-- Total Amount -->
    <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
        <span class="text-sm font-semibold text-green-600 text-md">$<%= String.format("%.2f", order.getTotalAmount() + order.getShippingFee())%></span>
    </td>

    <!-- Payment Method -->
    <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
        <span class=" text-md">
            <%= order.getPaymentMethod() != null ? order.getPaymentMethod().getName() : "N/A"%>
        </span>
    </td>

    <!-- Payment Status -->
    <td class="px-3 py-3 whitespace-nowrap text-center text-center">
        <% if (order.getPaymentStatus() != null) {%>
        <span class="inline-flex px-2 py-1 rounded-full text-md <%= "Paid".equals(order.getPaymentStatus().getName()) ? "bg-green-100 text-green-800" : "Pending".equals(order.getPaymentStatus().getName()) ? "bg-yellow-100 text-yellow-800" : "bg-red-100 text-red-800"%> font-semibold text-xs">
            <%= order.getPaymentStatus().getName()%>
        </span>
        <% } else { %>
        <span class="inline-flex px-2 py-1 rounded-full bg-gray-200 text-gray-700 font-semibold text-xs">N/A</span>
        <% } %>
    </td>

    <!-- Order Status -->
    <td class="px-3 py-3 whitespace-nowrap text-center">
        <% if (order.getOrderStatus() != null) {%>
        <span class="inline-flex px-2 py-1 rounded-full text-md <%= "Delivered".equals(order.getOrderStatus().getName()) ? "bg-green-100 text-green-800" : "Processing".equals(order.getOrderStatus().getName()) ? "bg-blue-100 text-blue-800" : "Shipped".equals(order.getOrderStatus().getName()) ? "bg-purple-100 text-purple-800" : "Cancelled".equals(order.getOrderStatus().getName()) ? "bg-red-100 text-red-800" : "bg-gray-100 text-gray-800"%> font-semibold text-xs">
            <%= order.getOrderStatus().getName()%>
        </span>
        <% } else { %>
        <span class="inline-flex px-2 py-1 rounded-full bg-gray-200 text-gray-700 font-semibold text-xs">N/A</span>
        <% }%>
    </td>

    <!-- Voucher Code -->
    <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
        <span class="ttext-md <%= order.getVoucher() != null && order.getVoucher().getCode() != null ? "text-purple-600 font-medium" : "text-gray-500"%>">
            <%= order.getVoucher() != null && order.getVoucher().getCode() != null ? order.getVoucher().getCode() : "No voucher"%>
        </span>
    </td>
    <!-- End status -->
    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
        <div class="flex items-center justify-center space-x-4">

            <button type="button" data-id="<%= order.getId()%>" 
                    class="detail-order-button bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>   

            <!-- Edit Button -->
            <button data-order-id="<%= order.getId()%>"
                    class="openEditOrderStatus bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors"
                    title="Edit order status">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </button>

        </div>
    </td>
</tr>
<% } %>

<% } else { %>
<tr>
    <td colspan="11" class="px-6 py-8 text-center text-gray-500">
        <div class="flex flex-col items-center">
            <svg class="w-12 h-12 text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
            </svg>
            <p class="text-lg font-medium">No orders found</p>
            <p class="text-sm">There are no orders to display at the moment.</p>
        </div>
    </td>
</tr>
<% }%>
