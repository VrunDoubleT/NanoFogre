<%-- 
    Document   : customerTemplate
    Created on : Jun 26, 2025, 3:41:21 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Customer"%>
<%@page import="java.util.List"%>
<%
    List<Customer> cus = (List<Customer>) request.getAttribute("clist");
    Integer currentPage = (Integer) request.getAttribute("page");
    Integer limit = (Integer) request.getAttribute("limit");

    if (cus != null && page != null && limit != null) {
        int index = (currentPage - 1) * limit + 1;
        for (Customer cs : cus) {
%>
<tr>
    <td class="px-9 py-3 whitespace-nowrap">
        <span class="font-bold text-[20px] text-gray-500"><%= index++%></span>
    </td>

    <td class="px-10 py-3 whitespace-nowrap">
        <div class="flex items-center">
            <div class="flex-shrink-0 h-16 w-16">
                <img class="h-16 w-16 rounded-full object-cover border border-gray-200"
                     src="<%= cs.getAvatar()%>">
            </div>
            <div class="ml-4">
                <div class="text-sm font-medium text-gray-900 line-clamp-1"><%= cs.getName()%></div>

                <div class="flex items-center mt-1">
                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800"><%= cs.getEmail()%></span>
                </div>
            </div>
        </div>
    </td>

    <td class="px-4 py-4 whitespace-nowrap text-sm text-center relative">
        <label class="inline-flex items-center cursor-pointer relative">
            <input type="checkbox"
                   class="sr-only peer toggle-block"
                   data-id="<%= cs.getId()%>"
                   <%= cs.isIsBlock() ? "" : "checked"%> />
            <div class="w-11 h-6 bg-gray-500 rounded-full peer peer-checked:bg-green-500 transition-colors duration-200 ease-in-out"></div>
            <div class="absolute left-0.5 top-0.5 bg-white border border-gray-300 h-5 w-5 rounded-full transition-all duration-200 ease-in-out peer-checked:translate-x-full peer-checked:border-white"></div>
        </label>
    </td>

    <td class="px-10 py-3 whitespace-nowrap text-sm font-medium">
        <div class="flex justify-center space-x-2">
            <button type="button" data-id="<%= cs.getId()%>" class="detail-customer-button bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>
        </div>
    </td>
</tr>
<%
        }
    }
%>
