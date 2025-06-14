<%-- Document : CategoryTeamplate  --%>


<%@page import="Models.Category"%>
<%@page import="java.util.List"%>
<%

    List<Category> categories = (List<Category>) request.getAttribute("category");

    if (categories != null) {
        for (Category category : categories) {
%>

<tr>
    <td class="px-4 py-4 whitespace-nowrap">
        <span class="font-bold text-[20px] text-gray-500"><%= category.getId() %></span>
    </td>
    <td class="px-6 py-4 whitespace-nowrap">
        <div class="flex items-center">
            <div class="ml-4">
                <div class="text-sm font-medium text-gray-900 line-clamp-1"><%= category.getName() %></div>
            </div>
        </div>
    </td>
    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
        <div class="flex items-center space-x-2">
            <button data-category-id="<%= category.getId() %>" class="openViewCategoryModal bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>
            <button class="bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </button>
            <button class="bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
    </td>
</tr>

<%
        }
    }
%>
