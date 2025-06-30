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
    <!-- Order ID with enhanced styling -->
    <!-- Order ID -->
    <td class="px-4 py-4 whitespace-nowrap text-center ">
        <span class="font-bold text-lg text-gray-900 ">#<%= order.getId()%></span>
    </td>

    <!-- Customer Name with avatar placeholder -->
    <td class="px-4 py-5 whitespace-nowrap">
        <div class="flex items-center justify-center">
            <div class="text-md font-medium text-gray-900">
                <%= order.getCustomer() != null ? order.getCustomer().getName() : "N/A"%>
            </div>
        </div>
    </td>

    <!-- Total Amount -->
    <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
        <span class="text-md font-semibold text-green-600 text-md"><%= String.format("%.2f", order.getTotalAmount() + order.getShippingFee())%>VND</span>
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
        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold border-2 <%= payClass%>">
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
        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold border-2 <%="Delivered".equals(order.getOrderStatus().getName()) ? "bg-green-50 text-green-700 border-green-200"
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
