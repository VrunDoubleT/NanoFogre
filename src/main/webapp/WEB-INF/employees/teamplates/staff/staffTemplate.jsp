<%-- 
    Document   : staffTemplate
    Created on : Jun 12, 2025, 5:39:19 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Employee"%>
<%@page import="java.util.List"%>
<%
    List<Employee> staff = (List<Employee>) request.getAttribute("slist");
    Integer currentPage = (Integer) request.getAttribute("page");
    Integer limit = (Integer) request.getAttribute("limit");

    if (staff != null && page != null && limit != null) {
        int index = (currentPage - 1) * limit + 1;
        for (Employee st : staff) {
%>
<tr>
    <td class="px-9 py-3 whitespace-nowrap">
        <span class="font-bold text-[20px] text-gray-500"><%= index++%></span>
    </td>

    <td class="px-10 py-3 whitespace-nowrap">
        <div class="flex items-center">
            <div class="flex-shrink-0 h-16 w-16">
                <img class="h-16 w-16 rounded-full object-cover border border-gray-200"
                     src="<%= st.getAvatar()%>">
            </div>
            <div class="ml-4">
                <div class="text-sm font-medium text-gray-900 line-clamp-1"><%= st.getName()%></div>

                <div class="flex items-center mt-1">
                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800"><%= st.getEmail()%></span>
                </div>
            </div>
        </div>
    </td>

    <td class="px-9 py-3 whitespace-nowrap">
        <% if (st.isIsBlock()) { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-800">Disable</span>
        <% } else { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Active</span>
        <% }%>
    </td>

    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
        <div class="flex justify-center space-x-2">
            <button type="button" data-id="<%= st.getId()%>" class="detail-staff-button bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>
            <button data-id="<%= st.getId()%>" class="update-staff-button bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </button>
            <button data-id="<%= st.getId()%>" class="delete-staff-button bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors">
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