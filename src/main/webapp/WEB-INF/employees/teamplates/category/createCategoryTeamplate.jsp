<%-- 
    Document   : createCategoryTeamplate
    Created on : Jun 15, 2025, 7:27:04 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Modal Background -->
<div class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">

    <!-- Modal Container -->
    <div class="w-full max-w-2xl bg-white rounded-xl shadow-lg overflow-hidden">
        <!-- Header Section -->
            <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center">
                  </div>

        <!-- Form Section -->
        <div class="p-8">
            <div class="mb-6 border-b pb-3">
                <h2 class="text-3xl font-bold text-gray-800 text-center">Create Category</h2>
            </div>

            <form id="create-category-form" class="space-y-6">

                <!-- Category Name Input -->
                <div>

                    <input
                        type="text"
                        id="categoryName"
                        placeholder="Enter category name"
                        class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
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
                        class="px-6 py-2 bg-green-600 text-white text-sm font-medium rounded-md hover:bg-green-700 transition"
                    >
                        Create
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>
