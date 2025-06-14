<%-- 
    Document   : categoryComponent
    Created on : Jun 10, 2025, 6:17:46 PM
    Author     : Tran Thanh Van - CE181019
--%>


<%@page import="Models.Category"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%

    List<Category> categories = (List<Category>) request.getAttribute("categories");

%>

<table class="min-w-full bg-white shadow-md rounded-lg overflow-hidden">
    <thead>
       <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">
        <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
                <h2 class="text-lg font-semibold text-gray-900 ">Category List</h2>

            </div>
        </div>
        <tr class="bg-gray-100">
            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-800">Category ID</th>
            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-800">Category Name</th>
            <th class="px-6 py-4 text-left text-sm font-semibold text-gray-800">Actions</th>
        </tr>
    </thead>
    <tbody>
        <% if (categories != null) {
            for (Category category : categories) { %>
        <tr class="border-t hover:bg-gray-50">
            <td class="px-6 py-4 text-sm text-gray-700"><%= category.getId() %></td>
            <td class="px-6 py-4 text-sm text-gray-700">
                <div class="flex items-center">
                    <div class="ml-4">
                        <div class="text-sm font-semibold text-gray-800"><%= category.getName() %></div>
                        <div class="text-xs text-gray-500">Category ID: <%= category.getId() %></div>
                    </div>
                </div>
            </td>
 
            <td class="px-6 py-4 text-sm text-gray-700">
  

                    <button data-category-id="<%= category.getId() %>" class="editCategoryBtn bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-4 py-2 rounded-lg transition-all duration-300" title="Edit Category">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                    </button>

                    <button data-category-id="<%= category.getId() %>" class="deleteCategoryBtn bg-red-100 text-red-700 hover:bg-red-200 px-4 py-2 rounded-lg transition-all duration-300" title="Delete Category">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                        </svg>
                    </button>
                </div>
            </td>
        </tr>
        <% } } %>
    </tbody>
</table>
