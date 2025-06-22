<%@ page import="Models.Category" %>
<%@ page import="java.util.List" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Integer currentPage = (Integer) request.getAttribute("page");
    Integer limit = (Integer) request.getAttribute("limit");

    if (categories != null && !categories.isEmpty()) {
        int index = (currentPage - 1) * limit + 1;
%>

<table class="w-full max-w-full divide-y divide-gray-200">
    <tbody class="bg-white divide-y divide-gray-200">
        <%
            for (Category category : categories) {
        %>
        <tr data-category-id="<%= category.getId()%>">
            <td class="px-4 py-4 whitespace-nowrap">
                <span class="font-bold text-[20px] text-gray-500"><%= category.getId()%></span>
            </td>

            <td class="px-3 py-3 whitespace-nowrap">
                <div class="flex items-center">
                    <div class="flex-shrink-0 h-16 w-16">
                        <!-- image category -->
                        <img class="h-16 w-16 rounded-full object-cover border border-gray-200" 
                             src="<%= category.getAvatar()%>" alt="Category Avatar"/>
                    </div>
                </div>
            </td>

            <td class="px-3 py-4 whitespace-nowrap">
                <div class="flex items-center">
                    <div class="ml-4">
                        <div class="text-sm font-medium text-gray-900 line-clamp-1">
                            <%= category.getName()%>
                        </div>
                    </div>
                </div>
            </td>
            <!-- Status -->
            <td class="px-3 py-4 whitespace-nowrap text-center">
                <% if (category.isIsActive()) { %>
                <span class="inline-block px-2 py-1 rounded-full bg-green-100 text-green-800 font-semibold text-xs">Active</span>
                <% } else { %>
                <span class="inline-block px-2 py-1 rounded-full bg-yellow-200 text-yellow-800 font-semibold text-xs">Inactive</span>
                <% }%>
            </td>

            <!-- End status -->
            <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
                <div class="flex items-center justify-center space-x-4">
                    <!-- Edit Button -->
                    <button data-category-id="<%= category.getId()%>" 
                            class="openEditCategoryModal bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                    </button>

                    <% if (category.isIsActive()) {%>
                    <button data-category-id="<%= category.getId()%>" class="openDisableCategory bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors" title="Hide category">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                    <% } else {%>
                    <button data-category-id="<%= category.getId()%>" class="openEnableCategory bg-green-100 text-green-700 hover:bg-green-200 px-3 py-1.5 rounded-lg transition-colors" title="Restore category">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                        </svg>
                    </button>
                    <% } %>

                </div>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>

<% } else { %>
<p>No categories found.</p>
<% }%>
