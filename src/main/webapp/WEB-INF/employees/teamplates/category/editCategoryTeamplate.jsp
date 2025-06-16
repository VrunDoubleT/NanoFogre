<%@page import="DAOs.CategoryDAO"%>
<%@page import="Models.Category"%>

<%
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    CategoryDAO categoryDAO = new CategoryDAO();
    Category category = categoryDAO.getCategoryById(categoryId);
%>

<!-- Modal Background -->
<div class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
    <!-- Modal Container -->
    <div class="w-full max-w-2xl bg-white rounded-xl shadow-lg overflow-hidden">

        <!-- Header Section -->
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center">
            <h1 class="text-3xl font-bold text-white">#<%= category.getId()%></h1>
            <div class="flex items-center space-x-4 text-blue-100">
                <span class="px-3 py-1 bg-white/20 rounded-full text-sm"><%= category.getName()%></span>
            </div>
        </div>

        <!-- Form Section -->
        <div class="p-8">
            <div class="mb-6 border-b pb-3">
                <h2 class="text-3xl font-bold text-gray-800 text-center">Edit Category</h2>
            </div>

            <form id="edit-category-form" class="space-y-6">
                <!-- Hidden Input -->
                <input type="hidden" id="categoryId" value="<%= category.getId()%>" />

                <!-- Category Name Input -->
                <div>
                    <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">
                        Category Name
                    </label>
                    <input
                        type="text"
                        id="categoryName"
                        value="<%= category.getName()%>"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        required
                        />
                </div>

                <!-- Error Message -->
                <div id="error-message" class="text-red-600 text-sm hidden"></div>

                <!-- Action Buttons -->
                <div class="flex justify-end space-x-3">
                    <button
                        type="button"
                        class="px-5 py-2 text-sm bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-md transition"
                        onclick="closeModal()"
                        >
                        Cancel
                    </button>

                    <button
                        type="submit"
                        id="update-category-btn"
                        class="px-6 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition"
                        >
                        Update
                    </button>
                  

                </div>
            </form>
        </div>
    </div>
</div>
