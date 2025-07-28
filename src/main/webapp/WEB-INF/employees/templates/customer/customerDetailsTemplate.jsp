<%-- 
    Document   : customerDetailsTemplate
    Created on : Jun 26, 2025, 5:35:18 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="Models.OrderDetails"%>
<%@page import="Models.Order"%>
<%@page import="java.util.List"%>
<%@page import="Models.Customer"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Customer cus = (Customer) request.getAttribute("customer");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String formattedDate = cus.getCreatedAt() != null ? cus.getCreatedAt().format(dtf) : "N/A";
%>

<div class="w-[780px] h-[90vh] mx-auto flex flex-col bg-white shadow-2xl overflow-hidden">
    <!-- Header -->
    <div class="bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-600 px-6 py-5 flex items-center gap-3">
        <i data-lucide="file-text" class="w-6 h-6 text-white"></i>
        <h1 class="text-2xl font-bold text-white">Customer Details</h1>
    </div>

    <!-- Tab Navigation -->
    <div class="flex border-b border-gray-200 text-sm font-medium px-6">
        <button id="profileBtn" class="tab-button px-4 py-2 border-b-2 border-indigo-500 font-semibold text-indigo-600" onclick="switchTab('profile')">Profile</button>
        <button id="ordersBtn" class="tab-button px-4 py-2" onclick="switchTab('orders')">Orders</button>
    </div>

    <!-- Body -->
    <div class="flex-1 min-h-0 overflow-y-auto px-6 space-y-6">
        <!-- Profile Tab -->
        <div id="profileTab" class="p-6">
            <!-- Avatar -->
            <div class="flex justify-center mb-2">
                <div class="relative">
                    <img src="<%= cus.getAvatar() != null && !cus.getAvatar().isEmpty() ? cus.getAvatar() : "/default-avatar.png"%>"
                         class="w-28 h-28 rounded-full object-cover border-4 border-white shadow-lg ring-2 ring-gray-200">
                    <div class="absolute bottom-1 right-1 w-5 h-5 bg-green-400 rounded-full border-2 border-white"></div>
                </div>
            </div>

            <!-- Name -->
            <div class="text-center p-6">
                <h2 class="text-2xl font-semibold text-gray-800 uppercase tracking-wider"><%= cus.getName()%></h2>
            </div>

            <!-- Info Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <!-- Email -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-blue-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Email</p>
                        <p class="font-semibold text-gray-800"><%= cus.getEmail()%></p>
                    </div>
                </div>

                <!-- Phone -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-blue-100 rounded-lg mr-3">
                        <i data-lucide="phone" class="w-5 h-5 text-blue-600"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Phone</p>
                        <p class="font-semibold text-gray-800">
                            <%--<%= (cus.getPhone().trim().isEmpty()) ? "No phone" : cus.getPhone() %>--%>
                        </p>
                    </div>
                </div>

                <!-- Address -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-purple-100 rounded-lg mr-3">
                        <i data-lucide="map-pin" class="w-5 h-5 text-purple-600"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Address</p>
                        <p class="font-semibold text-gray-800"><%= request.getAttribute("address")%></p>
                    </div>
                </div>

                <!-- Order -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-purple-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Orders</p>
                        <p class="font-semibold text-gray-800">
                            <%= request.getAttribute("orderCount")%> orders
                        </p>
                    </div>
                </div>

                <!-- Created At -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-green-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Created At</p>
                        <p class="font-semibold text-gray-800"><%= formattedDate%></p>
                    </div>
                </div>

                <!-- Status -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm justify-between">
                    <div class="flex items-center">
                        <div class="w-10 h-10 flex items-center justify-center bg-<%= cus.isIsBlock() ? "red" : "green"%>-100 rounded-lg mr-3">
                            <svg class="w-5 h-5 text-<%= cus.isIsBlock() ? "red" : "green"%>-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <% if (cus.isIsBlock()) { %>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728L5.636 5.636"/>
                            <% } else { %>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            <% }%>
                            </svg>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Status</p>
                            <p class="font-semibold text-<%= cus.isIsBlock() ? "red" : "green"%>-600">
                                <%= cus.isIsBlock() ? "Blocked" : "Active"%>
                            </p>
                        </div>
                    </div>
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                          <%= cus.isIsBlock() ? "bg-red-100 text-red-800" : "bg-green-100 text-green-800"%>">
                        <span class="w-2 h-2 mr-2 rounded-full <%= cus.isIsBlock() ? "bg-red-400" : "bg-green-400"%>"></span>
                        <%= cus.isIsBlock() ? "Blocked" : "Active"%>
                    </span>
                </div>
            </div>
        </div>

        <!-- Orders Tab -->
        <div id="ordersTab" class="hidden">
            <h3 class="text-base font-semibold text-gray-900 mb-2 flex items-center">
                <i data-lucide="package" class="w-5 h-5 mr-2 text-indigo-600"></i>
                Order List (<%= orders != null ? orders.size() : 0%>)
            </h3>

            <div class="">
                <%
                    if (orders != null && !orders.isEmpty()) {
                        int index = 1;
                        for (Order order : orders) {
                %>
                <div class="border border-gray-200 bg-gray-50 rounded-xl p-4 mb-6 shadow hover:shadow-md transition duration-300 bg-white">
                    <!-- Header -->
                    <div class="flex justify-between items-start mb-2">
                        <div>
                            <h4 class="font-semibold text-gray-900 text-sm">
                                Order: #<%= index++%>
                            </h4>
                        </div>
                        <div class="flex items-center text-xs rounded-full bg-green-200 text-green-800 px-2 py-1">
                            <i data-lucide="calendar" class="w-4 h-4 mr-1 text-green-600"></i>
                            <%= dtf.format(order.getCreatedAt())%>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="border-t pt-3 pb-2 space-y-2">
                        <% for (OrderDetails item : order.getDetails()) {%>
                        <div class="flex items-center gap-3">
                            <!-- Image -->
                            <div class="flex-shrink-0 h-16 w-16">
                                <%
                                    if (item.getProduct().getUrls().size() > 0) {
                                %>
                                <img class="h-16 w-16 rounded-lg object-cover border border-gray-200"
                                     src="<%= item.getProduct().getUrls().get(0)%>">
                                <%
                                } else {
                                %>
                                <span class="h-16 w-16 flex justify-center items-center rounded-lg text-[10px] text-medium border border-gray-200">No image</span>
                                <%
                                    }
                                %>
                            </div>
                            <!-- Details -->
                            <div class="flex-1">
                                <div class="flex justify-between items-center">
                                    <div class="text-sm font-medium text-gray-900">
                                        <%
                                            String title = item.getProduct().getTitle();
                                            if (title != null && title.length() > 30) {
                                                out.print(title.substring(0, 27) + "...");
                                            } else {
                                                out.print(title);
                                            }
                                        %>
                                    </div>
                                    <span class="font-medium text-gray-900">
                                        <%= String.format("%,.0f", item.getPrice())%> VND
                                    </span>
                                </div>
                                <span class="text-gray-500 text-sm">Amount: <%= item.getQuantity()%></span>
                            </div>

                        </div>
                        <% }%>
                    </div>

                    <!-- Footer -->
                    <div class="flex justify-end border-t pt-3 mt-2">
                        <div class="text-sm font-semibold text-gray-900 space-y-1">
                            <!-- Shipping -->
                            <div class="flex justify-between items-center py-1 px-3">
                                <span class="inline-block w-16">Shipping:</span>
                                <span><%= String.format("%,.0f", order.getShippingFee())%> VND</span>
                            </div>

                            <!-- Voucher -->
                            <div class="flex justify-between items-center py-1 px-3">
                                <span class="inline-block w-16">Voucher:</span>
                                <%
                                    String formatted = "No Voucher";
                                    if (order.getVoucher() != null) {
                                        double value = order.getVoucher().getValue();
                                        String type = order.getVoucher().getType();
                                        if ("PERCENTAGE".equalsIgnoreCase(type)) {
                                            formatted = (int) value + "%";
                                        } else {
                                            formatted = String.format("%,.0f VND", value);
                                        }
                                    }
                                %>
                                <span><%= formatted%></span>
                            </div>

                            <!-- Total -->
                            <div class="flex justify-between items-center py-1 px-3">
                                <span class="inline-block w-16">Total:</span>
                                <span><%= String.format("%,.0f", order.getTotalAmount())%> VND</span>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    } // end for orders 
                } else {
                %>
                <p class="text-gray-500 text-sm">This customer has no orders.</p>
                <% }%>
            </div>
        </div>
    </div>
</div>