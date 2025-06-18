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
<<<<<<< HEAD
        <% 
            // L?p qua t?ng category trong danh sách
            for (Category category : categories) {
        %>
            <tr data-category-id="<%= category.getId() %>">
                <td class="px-4 py-4 whitespace-nowrap">
                    <span class="font-bold text-[20px] text-gray-500"><%= category.getId() %></span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="ml-4">
                            <div class="text-sm font-medium text-gray-900 line-clamp-1">
                                <%= category.getName() %> 
                                <% if (category.isIsDeleted()) { %>
                                    <span>(Deleted)</span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </td>
                <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex items-center justify-center space-x-4">
                        <!-- Nút Edit -->
                        <button data-category-id="<%= category.getId() %>" class="openEditCategoryModal bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                            </svg>
                        </button>

                        <!-- Nút Delete ho?c Enable -->
                        <% if (!category.isIsDeleted()) { %>
                            <!-- Nút Delete khi isDeleted = false -->
                            <button data-category-id="<%= category.getId() %>" class="openDisableCategory bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors" title="Delete category">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        <% } else { %>
                            <!-- Nút Restore khi isDeleted = true -->
                            <button data-category-id="<%= category.getId() %>" class="openEnableCategory bg-green-100 text-green-700 hover:bg-green-200 px-3 py-1.5 rounded-lg transition-colors" title="Restore category">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        <% } %>
                    </div>
                </td>
            </tr>
=======
        <%
            // L?p qua t?ng category trong danh sách
            for (Category category : categories) {
        %>
        <tr data-category-id="<%= category.getId()%>">
            <td class="px-4 py-4 whitespace-nowrap">
                <span class="font-bold text-[20px] text-gray-500"><%= category.getId()%></span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                    <div class="ml-4">
                        <div class="text-sm font-medium text-gray-900 line-clamp-1">
                            <%= category.getName()%> 
                            <% if (category.isIsDeleted()) { %>
                            <span>(Deleted)</span>
                            <% }%>
                        </div>
                    </div>
                </div>
            </td>
            <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
                <div class="flex items-center justify-center space-x-4">
                    <!-- Nút Edit -->
                    <button data-category-id="<%= category.getId()%>" class="openEditCategoryModal bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                    </button>

                    <!-- Nút Delete khi isDeleted = false -->
                    <button data-category-id="<%= category.getId()%>" class="openDisableCategory bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors" title="Delete category">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>

                </div>
            </td>
        </tr>
>>>>>>> feature/category-full
        <% } %>
    </tbody>
</table>

<% } else { %>
<<<<<<< HEAD
    <p>No categories found.</p>
<% } %>
=======
<p>No categories found.</p>
<% }%>
>>>>>>> feature/category-full
