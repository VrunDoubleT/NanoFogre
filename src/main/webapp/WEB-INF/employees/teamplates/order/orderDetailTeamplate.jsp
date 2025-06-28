<%-- 
    Document   : orderDetail
    Created on : Jun 27, 2025
    Author     : iphon
--%>
<%@page import="java.math.BigDecimal"%>
<%@page import="Models.OrderDetails"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="Models.Order"%>
<%@page import="java.util.List"%>

<%
    // Retrieve the single Order object set in the controller
    Order order = (Order) request.getAttribute("order");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
%>

<div class="bg-white w-[860px] mx-auto h-[65vh] flex flex-col shadow-lg rounded-lg overflow-hidden">
    <!-- Header -->
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center">
        <div class="flex items-center gap-3">
            <i data-lucide="file-text" class="w-6 h-6 text-white"></i>
            <h2 class="text-2xl font-bold text-white">Order Details</h2>
        </div>
        <span class="text-white text-2xl font-medium">#<%= order != null ? order.getId() : "N/A"%></span>
    </div>

    <!-- Body -->
    <div class="p-6 overflow-y-auto flex-1">
        <% if (order == null) { %>
        <p class="text-center text-gray-500 mt-10">Order not found.</p>
        <% } else {%>
        <!-- Customer Info -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
            <div class="bg-gray-50 border rounded-lg p-4 shadow-sm text-center">
                <p class="text-sm text-gray-500">Customer:</p>
                <p class="font-semibold text-3xl text-gray-800">
                    <%= order.getCustomer() != null ? order.getCustomer().getName() : "N/A"%>
                </p>
            </div>
            <div class="bg-gray-50 border rounded-lg p-4 shadow-sm">
                <p class="text-sm text-gray-500">Contact Phone:</p>
                <p class="font-semibold text-gray-800">
                    <%= order.getCustomer() != null ? order.getCustomer().getPhone() : "N/A"%>
                </p>
                <p class="text-sm text-gray-500 mt-2">Shipping Address:</p>
                <p class="font-semibold text-gray-800">
                    <%= order.getAddress() != null ? order.getAddress().getFullAddress() : "N/A"%>
                </p>
            </div>
        </div>

        <!-- Order Meta -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">

            <!-- Payment Method -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Payment Method</p>
                <p class="font-medium text-gray-800 text-sm">
                    <%= order.getPaymentMethod() != null ? order.getPaymentMethod().getName() : "N/A"%>
                </p>
            </div>
            <!-- Payment Status -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Payment Status</p>
                <p class="font-medium text-sm <%= "Paid".equals(order.getPaymentStatus().getName()) ? "text-green-600" : "text-yellow-600"%>">
                    <%= order.getPaymentStatus() != null ? order.getPaymentStatus().getName() : "N/A"%>
                </p>
            </div>
            <!-- Order Status -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Order Status</p>
                <p class="font-medium text-sm <%= "Delivered".equals(order.getOrderStatus().getName()) ? "text-green-600" : "text-blue-600"%>">
                    <%= order.getOrderStatus() != null ? order.getOrderStatus().getName() : "N/A"%>
                </p>
            </div>
        </div>

        <!-- Order Meta 2-->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <!-- Created At -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Created At</p>
                <p class="font-medium text-gray-800 text-sm">
                    <%= order.getCreatedAt() != null ? order.getCreatedAt().format(fmt) : "N/A"%>
                </p>
            </div>

            <!-- Updated At -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Updated At</p>
                <p class="font-medium text-gray-800 text-sm">
                    <%= order.getUpdatedAt() != null ? order.getUpdatedAt().format(fmt) : "N/A"%>
                </p>
            </div>

            <!-- Voucher -->
            <div class="bg-gray-50 border rounded-lg p-4 text-center shadow-sm">
                <p class="text-sm text-gray-500">Voucher</p>
                <td class="px-3 py-3 whitespace-nowrap text-gray-700 text-center">
                    <span class="ttext-md <%= order.getVoucher() != null && order.getVoucher().getCode() != null ? "text-purple-600 font-medium" : "text-gray-500"%>">
                        <%= order.getVoucher() != null && order.getVoucher().getCode() != null ? order.getVoucher().getCode() : "No voucher"%>
                    </span>
                </td>
            </div>    

        </div>

        <div class="flex justify-end flex-col space-y-2  mt-4">
            <div class="mb-6">
                <h3 class="text-lg font-semibold mb-2">Purchased Items</h3>
                <div class="overflow-x-auto">
                    <table class="w-full border-collapse text-left">
                        <thead>
                            <tr>
                                <th class="p-2 border-b">Product</th>
                                <th class="p-2 border-b">Price</th>
                                <th class="p-2 border-b text-center">Quantity</th>
                                <th class="p-2 border-b">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<OrderDetails> details
                                        = (List<OrderDetails>) request.getAttribute("orderDetails");
                                for (OrderDetails d : details) {
                                    double lineTotal = d.getPrice() * d.getQuantity();
                            %>
                            <tr>
                                <td class="p-2 border-b"><%= d.getProduct().getTitle()%></td>
                                <td class="p-2 border-b">$<%= String.format("%.2f", d.getPrice())%></td>
                                <td class="p-2 border-b text-center "><%= d.getQuantity()%></td>
                                <td class="p-2 border-b">$<%= String.format("%.2f", lineTotal)%></td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
            </div>



            <div class="flex flex-col items-end pr-[67px]">
                <div class="flex justify-between w-40">
                    <p class="text-sm text-gray-500">Shipping Fee:</p>
                    <p class="font-semibold text-gray-800 text-lg">
                        $<%= String.format("%.2f", order.getShippingFee())%>
                    </p>
                </div>
                <div class="flex justify-between w-40 border-t border-gray-200 pt-2">
                    <p class="text-sm text-gray-500">Total:</p>
                    <p class="font-bold text-2xl text-green-600">
                        $<%= String.format("%.2f", order.getTotalAmount() + order.getShippingFee())%>
                    </p>
                </div>

            </div>

        </div>
        <% }%>
    </div>
</div>
