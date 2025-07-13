<%-- 
    Document   : orderDetail
    Created on : Jun 27, 2025
    Author     : iphon
    Updated    : Enhanced UI with modern design
--%>
<%@page import="Utils.CurrencyFormatter"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="Models.OrderDetails"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="Models.Order"%>
<%@page import="java.util.List"%>

<%
    // Retrieve the single Order object set in the controller
    Order order = (Order) request.getAttribute("order");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' hh:mm a");
    double subtotal = 0;
    List<OrderDetails> detailse = (List<OrderDetails>) request.getAttribute("orderDetails");
    for (OrderDetails d : detailse) {
        subtotal += d.getPrice() * d.getQuantity();
    }

    // Tính discount t? voucher
    double discount = 0;
    if (order.getVoucher() != null) {
        String type = order.getVoucher().getType();   // gi? s? "percentage" ho?c "fixed"
        double value = order.getVoucher().getValue();
        if ("percentage".equalsIgnoreCase(type)) {
            discount = subtotal * (value / 100.0);
            double max = order.getVoucher().getMaxValue();
            if (max > 0 && discount > max) {
                discount = max;
            }
        } else {
            discount = value;
        }
    }

    // L?y ti?p shippingFee và total t? order (ho?c tính l?i n?u c?n)
    double shippingFee = order.getShippingFee();
    double total = subtotal - discount + shippingFee;
%>

<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-700 px-8 py-2 h-[87px] relative overflow-hidden">

        <div class="relative flex justify-between items-center">
            <div class="flex items-center gap-4">
                <div class="p-2 bg-white/20 rounded-lg backdrop-blur-sm">
                    <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                    </svg>
                </div>
                <div>
                    <h2 class="text-3xl font-bold text-white drop-shadow-sm">Order Details</h2>
                </div>
            </div>
            <div class="text-right">
                <div class="text-white/80 text-sm mb-1">Order ID</div>
                <span class="inline-flex items-center px-4 py-2 bg-white/20 backdrop-blur-sm rounded-lg text-white text-xl font-bold border border-white/30">
                    #<%= order != null ? order.getId() : "N/A"%>
                </span>
            </div>
        </div>
    </div>

    <!-- Enhanced Body with better scrolling -->
    <div class="p-8 overflow-y-auto flex-1 bg-gradient-to-br from-gray-50 to-white">
        <% if (order == null) { %>
        <!-- Enhanced error state -->
        <div class="flex flex-col items-center justify-center h-64 text-center">
            <div class="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mb-4">
                <svg class="w-10 h-10 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"/>
                </svg>
            </div>
            <h3 class="text-xl font-semibold text-gray-700 mb-2">Order Not Found</h3>
            <p class="text-gray-500">The requested order could not be found in the system.</p>
        </div>
        <% } else {%>

        <!-- Enhanced Customer Info Section -->
        <div class="mb-8">
            <div class="flex items-center gap-2 mb-4">
                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">Customer Information</h3>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Customer Name Card -->
                <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow duration-200">
                    <div class="flex items-center gap-4">
                        <img src="${order.customer.avatar}"
                             alt="Avatar"
                             class="w-12 h-12 object-cover rounded-[50%] border overflow-hidden"/>


                        <div>
                            <p class="text-sm text-gray-500 mb-1">Customer Name</p>
                            <p class="font-semibold text-3xl text-gray-800">
                                <%= order.getCustomer() != null ? order.getCustomer().getName() : "N/A"%>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Contact & Address Card -->
                <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow duration-200">
                    <div class="space-y-4">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                            <div>
                                <p class="text-sm text-gray-500">Phone</p>
                                <p class="font-medium text-gray-800">
                                    <%= order.getCustomer() != null ? order.getCustomer().getPhone() : "N/A"%>
                                </p>
                            </div>
                        </div>
                        <div class="flex items-start gap-3">
                            <svg class="w-5 h-5 text-blue-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                            <div>
                                <p class="text-sm text-gray-500">Shipping Address</p>
                                <p class="font-medium text-gray-800 leading-relaxed">
                                    <%= order.getAddress() != null ? order.getAddress().getFullAddress() : "N/A"%>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Status Cards -->
        <div class="mb-8">
            <div class="flex items-center gap-2 mb-4">
                <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">Order Status</h3>
            </div>


            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-4xl w-full">
                <!-- Payment Method -->
                <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm hover:shadow-md transition-all duration-200 hover:border-blue-300">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-3">
                        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                        </svg>
                    </div>
                    <p class="text-sm text-gray-500 mb-2">Payment Method</p>
                    <p class="font-semibold text-gray-800">
                        <%= order.getPaymentMethod() != null ? order.getPaymentMethod().getName() : "N/A"%>
                    </p>
                </div>

                <!-- Payment Status -->
                <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm hover:shadow-md transition-all duration-200 hover:border-green-300">

                    <%
                        String paymentStatus = order.getPaymentStatus() != null ? order.getPaymentStatus().getName() : "";
                        String statusBg, statusIcon, badgeClass;

                        if ("Completed".equals(paymentStatus)) {
                            statusBg = "bg-green-100";
                            statusIcon = "<svg class='w-3 h-3 mr-1 text-green-600' fill='currentColor' viewBox='0 0 20 20'><path fill-rule='evenodd' d='M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z' clip-rule='evenodd'/></svg>";
                            badgeClass = "bg-green-100 text-green-800 border border-green-200";
                        } else if ("Pending".equals(paymentStatus)) {
                            statusBg = "bg-yellow-100";
                            statusIcon = "<svg class='w-3 h-3 mr-1 text-yellow-600' fill='currentColor' viewBox='0 0 20 20'><circle cx='10' cy='10' r='8'/><path fill-rule='evenodd' d='M10 6v4l3 3' clip-rule='evenodd'/></svg>";
                            badgeClass = "bg-yellow-100 text-yellow-800 border border-yellow-200";
                        } else {
                            statusBg = "bg-red-100";
                            statusIcon = "<svg class='w-3 h-3 mr-1 text-red-600' fill='currentColor' viewBox='0 0 20 20'><path fill-rule='evenodd' d='M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z' clip-rule='evenodd'/></svg>";
                            badgeClass = "bg-red-100 text-red-800 border border-red-200";
                        }
                    %>
                    <div class="w-12 h-12 <%= statusBg%> rounded-full flex items-center justify-center mx-auto mb-3">
                        <%= statusIcon%>
                    </div>

                    <p class="text-sm text-gray-500 mb-2">Payment Status</p>
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold <%= badgeClass%>">
                        <%= statusIcon%>
                        <%= paymentStatus.isEmpty() ? "N/A" : paymentStatus%>
                    </span>
                </div>

                <!-- Order Status -->
                <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm hover:shadow-md transition-all duration-200 hover:border-purple-300">
                    <%
                        String orderStatus = order.getOrderStatus() != null ? order.getOrderStatus().getName() : "";
                        String statusBgs, iconSVGs, badgeClasss;

                        if ("Delivered".equals(orderStatus) || "Completed".equals(orderStatus)) {
                            statusBg = "bg-green-100";
                            iconSVGs = "<svg class='w-6 h-6 text-green-600' fill='currentColor' viewBox='0 0 20 20'><path d='M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z'/></svg>";
                            badgeClass = "bg-green-100 text-green-800 border border-green-200";
                        } else if ("Processing".equals(orderStatus)) {
                            statusBg = "bg-blue-100";
                            iconSVGs = "<svg class='w-6 h-6 text-blue-600' fill='currentColor' viewBox='0 0 20 20'><path fill-rule='evenodd' d='M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z' clip-rule='evenodd'/></svg>";
                            badgeClass = "bg-blue-100 text-blue-800 border border-blue-200";
                        } else if ("Shipped".equals(orderStatus)) {
                            statusBg = "bg-purple-100";
                            iconSVGs = "<svg class='w-6 h-6 text-purple-600' fill='currentColor' viewBox='0 0 20 20'><path d='M8 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM15 16.5a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0z'/><path d='M3 4a1 1 0 00-1 1v10a1 1 0 001 1h1.05a2.5 2.5 0 014.9 0H10a1 1 0 001-1V5a1 1 0 00-1-1H3zM14 7a1 1 0 00-1 1v6.05A2.5 2.5 0 0115.95 16H17a1 1 0 001-1v-5a1 1 0 00-.293-.707L16 7.586A1 1 0 0015.414 7H14z'/></svg>";
                            badgeClass = "bg-purple-100 text-purple-800 border border-purple-200";
                        } else if ("Cancelled".equals(orderStatus)) {
                            statusBg = "bg-red-100";
                            iconSVGs = "<svg class='w-6 h-6 text-red-600' fill='currentColor' viewBox='0 0 20 20'><path fill-rule='evenodd' d='M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z' clip-rule='evenodd'/></svg>";
                            badgeClass = "bg-red-100 text-red-800 border border-red-200";
                        } else if (!orderStatus.isEmpty()) {
                            statusBg = "bg-gray-100";
                            iconSVGs = "<svg class='w-6 h-6 text-gray-600' fill='currentColor' viewBox='0 0 20 20'><circle cx='10' cy='10' r='8'/></svg>";
                            badgeClass = "bg-gray-100 text-gray-700 border border-gray-200";
                        } else {
                            statusBg = "bg-gray-100";
                            iconSVGs = "<svg class='w-6 h-6 text-gray-400' fill='currentColor' viewBox='0 0 20 20'><circle cx='10' cy='10' r='8'/></svg>";
                            badgeClass = "bg-gray-100 text-gray-400 border border-gray-200";
                        }
                    %>
                    <div class="w-12 h-12 <%= statusBg%> rounded-full flex items-center justify-center mx-auto mb-3">
                        <%= iconSVGs%>
                    </div>
                    <p class="text-sm text-gray-500 mb-2">Order Status</p>
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold <%= badgeClass%>">

                        <%= orderStatus.isEmpty() ? "N/A" : orderStatus%>
                    </span>
                </div>

            </div>
        </div>

        <!-- Enhanced Timestamps and Voucher -->
        <div class="mb-8">
            <div class="flex items-center gap-2 mb-4">
                <svg class="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">Timeline & Voucher</h3>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <!-- Created At -->
                <div class="bg-white border border-gray-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-all duration-200">
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                            <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                            </svg>
                        </div>
                        <p class="text-sm font-medium text-gray-500">Created</p>
                    </div>
                    <p class="font-semibold text-gray-800 text-sm">
                        <%= order.getCreatedAt() != null ? order.getCreatedAt().format(fmt) : "N/A"%>
                    </p>
                </div>

                <!-- Updated At -->
                <div class="bg-white border border-gray-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-all duration-200">
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                            <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                            </svg>
                        </div>
                        <p class="text-sm font-medium text-gray-500">Updated</p>
                    </div>
                    <p class="font-semibold text-gray-800 text-sm">
                        <%= order.getUpdatedAt() != null ? order.getUpdatedAt().format(fmt) : "N/A"%>
                    </p>
                </div>

                <!-- Voucher -->
                <div class="bg-white border border-gray-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-all duration-200">
                    <div class="flex items-center gap-3 mb-2">
                        <div class="w-8 h-8 bg-purple-100 rounded-full flex items-center justify-center">
                            <svg class="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/>
                            </svg>
                        </div>
                        <p class="text-sm font-medium text-gray-500">Voucher</p>
                    </div>
                    <% if (order.getVoucher() != null && order.getVoucher().getCode() != null) {%>
                    <span class="inline-flex items-center px-3 py-1 rounded-lg text-sm font-mono font-semibold bg-gradient-to-r from-purple-100 to-pink-100 text-purple-800 border border-purple-200">
                        <%= order.getVoucher().getCode()%>
                    </span>
                    <% } else { %>
                    <span class="text-sm text-gray-500">No voucher applied</span>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Enhanced Products Table -->
        <div class="mb-8">
            <div class="flex items-center gap-2 mb-4">
                <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart-icon lucide-shopping-cart"><circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/></svg>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">Purchased Items</h3>
            </div>

            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Product</th>
                                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700">Price</th>
                                <th class="px-6 py-4 text-center text-sm font-semibold text-gray-700">Quantity</th>
                                <th class="px-6 py-4 text-right text-sm font-semibold text-gray-700">Total</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <%
                                List<OrderDetails> details = (List<OrderDetails>) request.getAttribute("orderDetails");
                                for (OrderDetails d : details) {
                                    double lineTotal = d.getPrice() * d.getQuantity();
                            %>
                            <tr class="hover:bg-gray-50 transition-colors duration-150">
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3">
                                        <!-- Image -->
                                        <div class="flex-shrink-0 h-16 w-16">
                                            <%
                                                if (d.getProduct().getUrls().size() > 0) {
                                            %>
                                            <img class="h-16 w-16 rounded-lg object-cover border border-gray-200"
                                                 src="<%= d.getProduct().getUrls().get(0)%>">
                                            <%
                                            } else {
                                            %>
                                            <span class="h-16 w-16 flex justify-center items-center rounded-lg text-[10px] text-medium border border-gray-200">No image</span>
                                            <%
                                                }
                                            %>
                                        </div>
                                        <div>
                                            <p class="font-medium text-gray-900"><%= d.getProduct().getTitle()%></p>
                                        </div>
                                    </div>
                                </td>


                                <td class="px-6 py-4">

                                    <span class="text-sm font-semibold text-green-500"><%= CurrencyFormatter.formatVietNamCurrency(d.getPrice())%> VND</span>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex items-center justify-center w-8 h-8 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold">
                                        <%= d.getQuantity()%>
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">

                                    <span class="text-sm font-semibold text-green-500"> <%= CurrencyFormatter.formatVietNamCurrency(lineTotal)%> VND</span>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Enhanced Total Section -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex justify-end">
                <div class="w-80 space-y-4">

                    <div class="flex justify-between items-center py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-500">Subtotal:</span>
                        <span class="font-semibold text-green-500">
                            <%= CurrencyFormatter.formatVietNamCurrency(subtotal)%> VND
                        </span>
                    </div>

                    <div class="flex justify-between items-center py-2 border-b border-gray-100">
                        <span class="text-sm font-medium text-gray-500">Voucher Discount:</span>
                        <span class="font-semibold text-red-500">
                            -<%= CurrencyFormatter.formatVietNamCurrency(discount)%> VND
                        </span>
                    </div>

                    <div class="flex justify-between items-center py-2 border-b border-gray-100">
                        <span class="ttext-sm font-medium text-gray-500">Shipping Fee:</span>
                        <span class="font-semibold text-green-500">
                            <%= CurrencyFormatter.formatVietNamCurrency(shippingFee)%> VND
                        </span>
                    </div>

                    <div class="flex justify-between items-center py-3 border-t-2 border-gray-200">
                        <span class="text-xl font-bold text-gray-800">Total Amount:</span>
                        <div class="text-right">
                            <span class="text-2xl font-bold text-green-600">
                                <%= CurrencyFormatter.formatVietNamCurrency(total)%> VND
                            </span>
                            <p class="text-sm text-gray-500 mt-1">Including all fees</p>
                        </div>
                    </div>

                </div>
            </div>
        </div>


        <% }%>
    </div>
</div>