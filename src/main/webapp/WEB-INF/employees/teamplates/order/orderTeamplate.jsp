<%-- 
    Document   : orderTeamplate
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
        int index = (currentPage - 1) * limit + 1;
%>

<table class="w-full max-w-full divide-y divide-gray-200">
    <tbody class="bg-white divide-y divide-gray-200">
    <c:forEach var="order" items="${orders}">
        <tr data-order-id="${order.orderId}">
            <td class="px-4 py-4 whitespace-nowrap">
                <span class="font-bold text-[20px] text-gray-500"><%= index++%></span>
            </td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.orderId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.employeeId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.customerId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.totalAmount}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.shippingFee}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.paymentMethodId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.paymentStatusId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.statusId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.voucherId}</td>
            <td class="px-3 py-3 whitespace-nowrap text-gray-700">${order.addressId}</td>
            <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${fn:substring(order.createdAt.toString(),0,19)}</td>
            <td class="px-4 py-4 whitespace-nowrap text-sm text-gray-700">${fn:substring(order.updatedAt.toString(),0,19)}</td>
        </tr>
    </c:forEach>
</tbody>
</table>

<% } else { %>
<p class="text-center py-4">No orders found.</p>
<% }%>
