<%-- 
    Document   : createCategoryTeamplate
    Created on : Jun 15, 2025, 7:27:04 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!-- createCategoryTeamplate.jsp -->

<div class="bg-gray-100">
    <div class="w-[500px] mx-auto h-auto flex flex-col bg-white shadow-2xl overflow-hidden rounded-xl">

        <!-- Header Section -->
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-center items-center">
            <h2 class="text-2xl font-bold text-white">Create Category</h2>
        </div>

        <!-- Form Section -->
        <div class="p-8">
            <form id="create-category-form" class="space-y-6" enctype="multipart/form-data" autocomplete="off">
                <!-- Category Name -->
                <div>
                    <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">Category Name</label>
                    <input type="text" id="categoryName" name="categoryName"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                           required />
                    <p id="categoryNameError" class="text-red-500 text-sm mt-1"></p>
                </div>

                <!-- Category Image Upload -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Category Image</label>
                    <input type="file" id="categoryImage" name="categoryImage" accept="image/*" class="hidden" required />
                    <label for="categoryImage"
                           class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                        <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                        <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 5MB)</span>
                    </label>
                    <div id="image-preview" class="mt-2"></div>
                    <p id="categoryImageError" class="text-red-500 text-sm mt-1"></p>
                </div>

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
                        id="create-category-btn"
                        class="px-4 py-2 bg-emerald-500 rounded-lg text-white hover:bg-emerald-600 transition-all flex items-center gap-2"DDD
                        >
                        <span>Create </span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
