<%-- 
    Document   : brandTeamplate
    Created on : Jun 18, 2025, 1:14:13 AM
    Author     : Modern 15
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Integer totalAttr = (Integer) request.getAttribute("total");
    Integer limitAttr = (Integer) request.getAttribute("limit");
    Integer pageAttr = (Integer) request.getAttribute("page");

    int total = totalAttr != null ? totalAttr : 0;
    int limit = limitAttr != null ? limitAttr : 10;
    int currentPage = pageAttr != null ? pageAttr : 1;

    pageContext.setAttribute("currentPage", currentPage);
    pageContext.setAttribute("limit", limit);
    pageContext.setAttribute("total", total);

    int totalPages = (int) Math.ceil((double) total / limit);
    int maxPagesToShow = 5;
    int half = maxPagesToShow / 2;
    int startPage = Math.max(1, currentPage - half);
    int endPage = Math.min(totalPages, currentPage + half);
    if (endPage - startPage + 1 < maxPagesToShow) {
        if (startPage == 1) {
            endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);
        } else if (endPage == totalPages) {
            startPage = Math.max(1, endPage - maxPagesToShow + 1);
        }
    }
%>
<!-- CREATE BRAND MODAL -->
<div id="createBrandModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-30 transition-all duration-300">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-0 relative transform scale-95 opacity-0 translate-y-8 transition-all duration-300 flex flex-col">
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-t-2xl px-6 py-4 flex items-center justify-between">
            <h2 class="text-xl font-bold">Add New Brand</h2>
        </div>
        <form id="createBrandForm" onsubmit="event.preventDefault(); handleCreateBrand();" class="space-y-5 p-8 pt-6" enctype="multipart/form-data">
            <div>
                <label for="newBrandName" class="block text-sm font-medium text-gray-700 mb-1">Brand Name</label>
                <input type="text" id="newBrandName" placeholder="Enter brand name"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base">
                <span id="createBrandNameError" class="text-red-500 text-sm mt-1 block"></span>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Brand Image</label>
                <input type="file" id="newBrandImage" name="image" accept="image/*" class="hidden" onchange="showFileName(this)">
                <label for="newBrandImage"
                       class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                    <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                    <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 10MB)</span>
                </label>
                <span class="file-name text-xs text-gray-500 ml-3">No file chosen</span>
                <div id="createBrandImagePreview" class="mt-2 flex justify-center"></div>
                <p id="createBrandImageError" class="text-red-500 text-sm mt-1"></p>
            </div>
            <div class="flex justify-end gap-3 pt-2">
                <button type="button" onclick="closeCreateModal()" class="px-5 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition font-semibold">Cancel</button>
                <button type="submit" class="flex items-center gap-2 px-5 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-blue-400 text-white hover:from-blue-700 hover:to-blue-500 shadow-lg font-semibold transition-all duration-200">
                    <svg id="loadingIconCreate" class="hidden animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
                    </svg>
                    Create
                </button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT BRAND MODAL -->
<div id="editBrandModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-30 transition-all duration-300">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-0 relative transform scale-95 opacity-0 translate-y-8 transition-all duration-300 flex flex-col">
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-t-2xl px-6 py-4 flex items-center justify-between">
            <h2 class="text-xl font-bold flex items-center gap-2">
                <i data-lucide="edit-3" class="w-7 h-7 text-white"></i> Edit Brand
            </h2>
        </div>
        <form onsubmit="event.preventDefault(); handleUpdateBrand();" class="space-y-5 p-8 pt-6" enctype="multipart/form-data">
            <input type="hidden" id="editBrandId">
            <div>
                <label for="editBrandName" class="block text-sm font-medium text-gray-700 mb-1">Brand Name</label>
                <input type="text" id="editBrandName" placeholder="Enter brand name"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base">
                <span id="editBrandNameError" class="text-red-500 text-sm mt-1 block"></span>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Current Image</label>
                <div id="editBrandCurrentImageWrapper" class="flex items-center"></div>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Upload New Image (optional)</label>
                <input type="file" id="editBrandImage" name="image" accept="image/*" class="hidden" onchange="showFileName(this)">
                <label for="editBrandImage"
                       class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                    <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                    <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 10MB)</span>
                </label>
                <span class="file-name text-xs text-gray-500 ml-3">No file chosen</span>
                <div id="editBrandImagePreview" class="mt-2 flex justify-center"></div>
                <p id="editBrandImageError" class="text-red-500 text-sm mt-1"></p>
            </div>
            <div class="flex justify-end gap-3 pt-2">
                <button type="button" onclick="closeEditModal()"
                        class="px-5 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition font-semibold">Cancel</button>
                <button type="submit"
                        class="flex items-center gap-2 px-5 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-blue-400 text-white hover:from-blue-700 hover:to-blue-500 shadow-lg font-semibold transition-all duration-200">
                    <svg id="loadingIconEdit" class="hidden animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path></svg>
                    Update
                </button>
            </div>
        </form>
    </div>
</div>

<button onclick="deleteBrand(${brand.id})" class="text-red-600 hover:text-red-800">
    <i class="fas fa-trash"></i>
</button>

<div class="flex flex-col items-center space-y-4 mt-8">
    <div class="text-sm text-gray-600 font-medium">
        Showing <span id="from" class="font-semibold text-gray-900"><%= Math.min((currentPage - 1) * limit + 1, total)%></span>
        to <span id="end" class="font-semibold text-gray-900"><%= Math.min(currentPage * limit, total)%></span>
        of <span id="total" class="font-semibold text-gray-900"><%= total%></span> results
    </div>
    <nav class="isolate inline-flex -space-x-px rounded-xl shadow-lg bg-white ring-1 ring-gray-200" aria-label="Pagination">
        <div page="1"
             class="pagination relative inline-flex items-center px-3 py-2 rounded-l-xl text-sm font-medium
             <%= currentPage == 1 ? "text-gray-400 bg-gray-50 pointer-events-none"
                     : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == 1 ? "aria-disabled='true'" : ""%>
             role="button" tabindex="0">
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M18.75 19.5l-7.5-7.5 7.5-7.5m-6 15L5.25 12l6-6" />
            </svg>
            <span class="sr-only">First page</span>
        </div>
        <div page="<%= Math.max(1, currentPage - 1)%>"
             class="pagination relative inline-flex items-center px-3 py-2 text-sm font-medium
             <%= currentPage == 1 ? "text-gray-400 cursor-not-allowed bg-gray-50"
                     : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == 1 ? "aria-disabled='true'" : ""%>
             role="button" tabindex="0">
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span class="sr-only">Previous page</span>
        </div>

        <!-- Ellipsis (Start) -->
        <% if (startPage > 1) { %>
        <span class="relative inline-flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-white">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z"/>
            </svg>
        </span>
        <% } %>
        <% for (int i = startPage; i <= endPage; i++) {%>
        <div page="<%= i%>"
             class="pagination cursor-pointer relative inline-flex items-center px-4 py-2 text-sm font-semibold
             <%= i == currentPage
                     ? "z-10 bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg ring-2 ring-blue-500 ring-offset-2 transform scale-105"
                     : "text-gray-700 bg-white hover:bg-gradient-to-r hover:from-gray-50 hover:to-gray-100 hover:text-gray-900 hover:shadow-md hover:scale-105"%>
             transition-all duration-200 ease-in-out"
             aria-current="<%= i == currentPage ? "page" : "false"%>"
             role="button" tabindex="0">
            <%= i%>
        </div>
        <% } %>
        <% if (endPage < totalPages) { %>
        <span class="relative inline-flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-white">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z"/>
            </svg>
        </span>
        <% }%>
        <div page="<%= Math.min(totalPages, currentPage + 1)%>"
             class="pagination relative inline-flex items-center px-3 py-2 text-sm font-medium
             <%= currentPage == totalPages ? "text-gray-400 cursor-not-allowed bg-gray-50"
                     : "text-gray-700 bg-white hover:bg-gray-50 cursor-pointer hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == totalPages ? "aria-disabled='true'" : ""%>
             role="button" tabindex="0">
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span class="sr-only">Next page</span>
        </div>
        <div page="<%= totalPages%>"
             class="pagination relative inline-flex items-center px-3 py-2 rounded-r-xl text-sm font-medium
             <%= currentPage == totalPages ? "text-gray-400 cursor-not-allowed bg-gray-50"
                     : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == totalPages ? "aria-disabled='true'" : ""%>
             role="button" tabindex="0">
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 4.5l7.5 7.5-7.5 7.5m6-15l7.5 7.5-7.5 7.5" />
            </svg>
            <span class="sr-only">Last page</span>
        </div>
        <input type="hidden" id="totalPages" value="<%= totalPages%>">
    </nav>
    <div class="flex items-center justify-between w-full max-w-xs sm:hidden mt-2">
        <div page="<%= Math.max(1, currentPage - 1)%>"
             class="pagination relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
             <%= currentPage == 1 ? "style='pointer-events: none; opacity: 0.5;'" : ""%>
             role="button" tabindex="0">
            Previous
        </div>
        <span class="text-sm text-gray-700 font-medium">
            Page <%= currentPage%> of <%= totalPages%>
        </span>
        <div page="<%= Math.min(totalPages, currentPage + 1)%>"
             class="pagination relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
             <%= currentPage == totalPages ? "style='pointer-events: none; opacity: 0.5;'" : ""%>
             role="button" tabindex="0">
            Next
        </div>
    </div>
</div>
<div id="toast-container" class="fixed top-5 right-5 z-[9999] flex flex-col gap-3"></div>
