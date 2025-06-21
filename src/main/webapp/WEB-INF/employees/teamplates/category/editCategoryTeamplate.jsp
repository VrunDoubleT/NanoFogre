<%@page import="DAOs.CategoryDAO"%>
<%@page import="Models.Category"%>

<%
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    CategoryDAO categoryDAO = new CategoryDAO();
    Category category = categoryDAO.getCategoryById(categoryId);
%>


<!-- Modal Background -->
<div class="bg-gray-100">
    <div class="w-[820px] mx-auto h-auto flex flex-col bg-white shadow-2xl overflow-hidden">

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

            <form id="edit-category-form" class="space-y-6" enctype="multipart/form-data">
                <!-- Hidden Input -->
                <input type="hidden" id="categoryId" value="<%= category.getId()%>" />

                <!-- Category Name Input -->
                <div>
                    <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">Category Name</label>
                    <input
                        type="text"
                        id="categoryName"
                        value="<%= category.getName()%>"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        required
                        />
                    <span id="categoryNameError" class="text-red-500 text-sm"></span>
                </div>

                <!-- Category Image Input -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Category Image</label>
                    <input    type="file"
                              id="categoryImage"
                              name="categoryImage"
                              accept="image/*"
                              class="hidden"
                              data-old-image="<%= category.getAvatar() != null ? category.getAvatar() : ""%>"/>
                    <label for="categoryImage"
                           class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                        <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                        <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 5MB)</span>
                    </label>
                    <div id="image-preview" class="mt-2"></div>
                    <p id="categoryImageError" class="text-red-500 text-sm mt-1"></p>
                </div>

                <!-- Error Message -->
                <div id="error-message" class="text-red-600 text-sm hidden"></div>

                <!-- Status/Error -->
                <div id="upload-status" class="hidden flex justify-center items-center">
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-2">
                        <span id="status-text" class="text-blue-700 text-sm"></span>
                    </div>
                </div>
                <div id="upload-error" class="hidden flex justify-center items-center">
                    <div class="bg-red-50 border border-red-200 rounded-lg p-2">
                        <span id="error-text" class="text-red-700 text-sm"></span>
                    </div>
                </div>


                <!-- Action Buttons -->
                <div class="flex justify-end space-x-3">
                    <button type="button"
                            class="px-5 py-2 text-sm bg-gray-200 hover:bg-gray-300 text-gray-700 rounded-md transition"
                            onclick="closeModal()">
                        Cancel
                    </button>
                    <button
                        type="submit"
                        id="update-category-btn"
                        class="px-6 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition flex items-center"
                        >
                        <i data-lucide="pencil" class="mr-1"></i>
                        <span>Update</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
