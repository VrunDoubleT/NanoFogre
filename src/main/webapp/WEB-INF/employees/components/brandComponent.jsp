<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Modal Add Brand -->
<div id="createBrandModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm transition-opacity duration-300 opacity-0 pointer-events-none">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-8 relative scale-95 opacity-0 translate-y-8 transition-all duration-300">
        <h2 class="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
            <i data-lucide="plus-circle" class="w-7 h-7 text-blue-500"></i> Add New Brand
        </h2>
        <form id="createBrandForm" onsubmit="event.preventDefault(); handleCreateBrand();" class="space-y-5" enctype="multipart/form-data">
            <div>
                <label for="newBrandName" class="block text-sm font-medium text-gray-700 mb-1">Brand Name</label>
                <input type="text" id="newBrandName" placeholder="Enter brand name"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base" required>
            </div>
            <div>
                <label for="newBrandImage" class="block text-sm font-medium text-gray-700 mb-1">Brand Image</label>
                <input type="file" id="newBrandImage" name="image" accept="image/*"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base bg-white" required>
                <p class="text-xs text-gray-500 mt-1">Chỉ chấp nhận PNG, JPG, JPEG, GIF. Dung lượng tối đa 10MB.</p>
                <div id="addBrandImagePreview" class="flex justify-center mt-2"></div>
            </div>
            <div class="flex justify-end gap-3 pt-2">
                <button type="button" onclick="closeCreateModal()"
                        class="px-5 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition font-semibold">Cancel</button>
                <button type="submit"
                        class="flex items-center gap-2 px-5 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-blue-400 text-white hover:from-blue-700 hover:to-blue-500 shadow-lg font-semibold transition-all duration-200">
                    <svg id="loadingIconCreate" class="hidden animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path></svg>
                    Create
                </button>
            </div>
        </form>
        <button type="button" onclick="closeCreateModal()" class="absolute top-3 right-4 text-gray-400 hover:text-gray-600 text-2xl transition-colors duration-200">&times;</button>
    </div>
</div>
<!-- Modal Edit Brand -->
<div id="editBrandModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm transition-opacity duration-300 opacity-0 pointer-events-none">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-8 relative scale-95 opacity-0 translate-y-8 transition-all duration-300">
        <h2 class="text-2xl font-bold mb-6 text-gray-800 flex items-center gap-2">
            <i data-lucide="edit-3" class="w-7 h-7 text-blue-500"></i> Edit Brand
        </h2>
        <form onsubmit="event.preventDefault(); handleUpdateBrand();" class="space-y-5" enctype="multipart/form-data">
            <input type="hidden" id="editBrandId">
            <div>
                <label for="editBrandName" class="block text-sm font-medium text-gray-700 mb-1">Brand Name</label>
                <input type="text" id="editBrandName" placeholder="Enter brand name"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base" required>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Current Image</label>
                <div id="editBrandCurrentImageWrapper" class="flex items-center"></div>
            </div>
            <div>
                <label for="editBrandImage" class="block text-sm font-medium text-gray-700 mb-1">Upload New Image (optional)</label>
                <input type="file" id="editBrandImage" name="image" accept="image/*"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base bg-white">
                <p class="text-xs text-gray-500 mt-1">Chỉ chấp nhận PNG, JPG, JPEG, GIF. Dung lượng tối đa 10MB.</p>
                <div id="editBrandImagePreview" class="flex justify-center mt-2"></div>
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
        <button type="button" onclick="closeEditModal()" class="absolute top-3 right-4 text-gray-400 hover:text-gray-600 text-2xl transition-colors duration-200">&times;</button>
    </div>
</div>

<div class="mb-4 flex justify-end">
    <button onclick="openCreateModal()" 
            class="flex items-center px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
        <i data-lucide="plus" class="w-5 h-5 mr-2"></i>
        Add Brand
    </button>
</div>
<div id="loadingBrand" class="hidden"> <!-- Thêm class hidden để ẩn mặc định -->
    <div class="animate-pulse space-y-4">
        <div class="h-12 bg-gray-200 rounded"></div>
        <div class="h-12 bg-gray-200 rounded"></div>
        <div class="h-12 bg-gray-200 rounded"></div>
    </div>
</div>
<c:choose>
    <c:when test="${empty brands}">
        <div class="text-center text-gray-500 py-8">No brands found in the database.</div>
    </c:when>
    <c:otherwise>
        <div class="mb-8">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div class="bg-white rounded-xl p-4 shadow flex items-center gap-4 w-full md:w-auto">
                    <div class="bg-blue-100 p-2 rounded-full">
                        <i data-lucide="tags" class="w-6 h-6 text-blue-600"></i>
                    </div>
                    <div>
                        <div class="text-2xl font-bold">${totalBrands}</div>
                        <div class="text-gray-500 text-sm">Total Brands</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow overflow-hidden">
            <table class="min-w-full">
                <thead class="bg-gray-50">
                    <tr class="text-sm text-gray-700 uppercase">
                        <th class="py-4 px-6 text-left">#</th>
                        <th class="py-4 px-6 text-left">Brand Name</th>
                        <th class="py-4 px-6 text-left">Image</th>
                        <th class="py-4 px-6 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                    <c:forEach var="brand" items="${brands}" varStatus="status">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="py-3 px-6">${(currentPage - 1) * 5 + status.index + 1}</td>
                            <td class="py-3 px-6 font-medium">${brand.name}</td>
                            <td class="py-3 px-6">
                                <c:if test="${not empty brand.url}">
                                    <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                        <img src="${brand.url}" alt="${brand.name}" 
                                             class="max-h-12 max-w-[3.5rem] object-contain">
                                    </div>
                                </c:if>
                            </td>
                            <td class="py-3 px-6">
                                <div class="flex gap-3">
                                    <button class="text-blue-600 hover:text-blue-800 transition-colors hover:scale-110 active:scale-95"
                                            onclick="editBrand(${brand.id})">
                                        <i data-lucide="pen-square" class="w-5 h-5"></i>
                                    </button>
                                    <button class="text-red-600 hover:text-red-800 transition-colors hover:scale-110 active:scale-95"
                                            onclick="deleteBrand(${brand.id})">
                                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="mt-4 mb-2 text-sm text-gray-600 text-center">
            Showing <strong>${(currentPage - 1) * 5 + 1}</strong> to 
            <strong>${currentPage * 5 > totalBrands ? totalBrands : currentPage * 5}</strong> of 
            <strong>${totalBrands}</strong> results
        </div>

        <div class="mt-2 flex justify-center">
            <c:if test="${totalPages > 1}">
                <div class="flex items-center space-x-2">
                    <button class="px-3 py-2 text-sm rounded-lg border ${currentPage == 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                            onclick="loadBrandPage(1)" ${currentPage == 1 ? 'disabled' : ''}>&lt;&lt;</button>
                    <button class="px-3 py-2 text-sm rounded-lg border ${currentPage == 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                            onclick="loadBrandPage(${currentPage - 1})" ${currentPage == 1 ? 'disabled' : ''}>&lt;</button>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <button class="px-4 py-2 text-sm rounded-lg border ${currentPage == i ? 'bg-blue-600 text-white border-blue-600' : 'bg-white hover:bg-gray-50 text-gray-700'} transition-all duration-200 hover:-translate-y-0.5"
                                onclick="loadBrandPage(${i})">${i}</button>
                    </c:forEach>
                    <button class="px-3 py-2 text-sm rounded-lg border ${currentPage == totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                            onclick="loadBrandPage(${currentPage + 1})" ${currentPage == totalPages ? 'disabled' : ''}>&gt;</button>
                    <button class="px-3 py-2 text-sm rounded-lg border ${currentPage == totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                            onclick="loadBrandPage(${totalPages})" ${currentPage == totalPages ? 'disabled' : ''}>&gt;&gt;</button>
                </div>
            </c:if>
        </div>
    </c:otherwise>
</c:choose>
        
<div id="toast-container" class="fixed top-5 right-5 z-[9999] flex flex-col gap-3"></div>