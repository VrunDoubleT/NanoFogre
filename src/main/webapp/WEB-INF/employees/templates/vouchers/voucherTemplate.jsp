<%-- 
    Document   : vouchersTemplate
    Created on : Jun 22, 2025, 4:12:05 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Voucher"%>
<%@page import="java.util.List"%>
<%
    List<Voucher> voucher = (List<Voucher>) request.getAttribute("vlist");
    Integer currentPage = (Integer) request.getAttribute("page");
    Integer limit = (Integer) request.getAttribute("limit");

    if (voucher != null && page != null && limit != null) {
        int index = (currentPage - 1) * limit + 1;
        for (Voucher v : voucher) {
%>
<tr>
    <td class="px-9 py-3 whitespace-nowrap">
        <span class="font-bold text-[20px] text-gray-500"><%= index++%></span>
    </td>

    <td class="px-10 py-3 whitespace-nowrap">
        <span class="px-2 py-1 rounded-md bg-gray-100 text-gray-900 font-mono text-sm border border-gray-300">
            <%= v.getCode()%>
        </span>
    </td>

    <td class="px-10 py-3 whitespace-nowrap">
        <%
            double value = v.getValue();
            String formatted = "";
            if ("PERCENTAGE".equalsIgnoreCase(v.getType())) {
                formatted = (int) value + "%";
            } else {
                long moneyInThousands = (long) value / 1000;
                formatted = moneyInThousands + ".000";
            }
        %>
        <span class="text-sm font-medium text-gray-900"><%= formatted%></span>
    </td>

    <td class="px-8 py-3 whitespace-nowrap">
        <%
            String status = v.getStatus();
            String colorClass = "bg-gray-100 text-gray-800";
            if (status.equals("Ongoing")) {
                colorClass = "bg-green-100 text-green-800";
            } else if (status.equals("Upcoming")) {
                colorClass = "bg-yellow-100 text-yellow-800";
            } else if (status.equals("Expired")) {
                colorClass = "bg-red-100 text-red-800";
            }
        %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= colorClass%>">
            <%= status%>
        </span>
    </td>

    <td class="px-9 py-3 whitespace-nowrap">
        <% if (v.isIsActive()) { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-200 text-green-800">Active</span>
        <% } else { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">Inactive</span>
        <% }%>
    </td>

    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
        <div class="flex justify-center space-x-2">
            <button type="button" data-id="<%= v.getId()%>" class="detail-voucher-button bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>
            <button data-id="<%= v.getId()%>" class="update-voucher-button bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </button>
            <button data-id="<%= v.getId()%>" class="delete-voucher-button bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
    </td>
</tr>
<%
        }
    }
%>
