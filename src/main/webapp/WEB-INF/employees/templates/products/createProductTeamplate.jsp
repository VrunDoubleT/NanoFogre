<%-- 
    Document   : createProductTeamplate
    Created on : Jun 12, 2025, 7:41:30 AM
    Author     : Tran Thanh Van - CE181019
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    .tab-button.active {
        color: #2563eb;
        border-color: #2563eb;
    }
    .tab-content.hidden {
        display: none;
    }
</style>
<div class="bg-gray-100">
    <div class="w-[900px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <span id="productIdUpdate" class="hidden">${not empty product ? product.productId : 0}</span>
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-3xl font-bold text-white mb-2">
                Create Product
            </h1>
            <div class="flex items-center space-x-4">
                <button id="create-product-btn" class="px-4 py-2 bg-emerald-500 rounded-lg text-white hover:bg-emerald-600 transition-all flex items-center gap-2">
                    <i data-lucide="plus"></i>
                    Create
                </button>
            </div>
        </div>

        <!-- Tab Content -->
        <div class="p-8 h-full w-full overflow-y-auto">
            <!-- Details Tab -->
            <div id="details-content" class="tab-content w-full">
                <div id="productForm" class="space-y-6">
                    <div class="grid grid-cols-1 gap-8">
                        <!-- Basic Information -->
                        <div class="space-y-6">
                            <div class="bg-gray-50 rounded-xl p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>

                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
                                        <input placeholder="Enter product title (e.g., Gundam RX-78-2)" type="text" name="title" id="title" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="titleError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                        <textarea placeholder="Enter detailed product description..." id="description" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required></textarea>
                                        <span id="descriptionError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Material</label>
                                        <input placeholder="Enter material (e.g., plastic, resin, metal)" type="text" name="title" id="material" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="materialError"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Price and Quantity -->
                            <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Price</label>
                                        <input placeholder="Enter price (e.g., 499000)" type="number" step="1000" name="price" id="price" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                        <span id="priceError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
                                        <input placeholder="Enter available quantity (e.g., 10)" type="number" name="quantity" id="quantity" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                        <span id="quantityError"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product Images -->
                    <div class="bg-gray-50 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Product Images</h3>
                        <div class="space-y-4">
                            <!-- File Upload Section -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Upload Images (Max 10 files)</label>
                                <div class="relative">
                                    <input type="file" 
                                           id="image-files-create" 
                                           name="imageFiles" 
                                           multiple 
                                           accept="image/*" 
                                           class="hidden">
                                    <label for="image-files-create" id="drop-zone" class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                                        <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                            <i class="fas fa-cloud-upload-alt text-3xl text-gray-400 mb-2"></i>
                                            <p class="text-sm text-gray-500">
                                                <span class="font-semibold">Click to upload</span> or drag and drop
                                            </p>
                                            <p class="text-xs text-gray-500">PNG, JPG, JPEG, GIF up to 10MB each</p>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <!-- Upload Status -->
                            <div id="upload-status-create" class="hidden">
                                <div class="bg-blue-50 border border-blue-200 rounded-lg p-3">
                                    <div class="flex items-center">
                                        <i class="fas fa-info-circle text-blue-500 mr-2"></i>
                                        <span id="status-text-create" class="text-sm text-blue-700"></span>
                                    </div>
                                </div>
                            </div>
                            <!-- Upload error -->
                            <div id="upload-error-create" class="hidden">
                                <div class="bg-red-50 border border-red-200 rounded-lg p-3">
                                    <div class="flex items-center">
                                        <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                                        <span id="error-text-create" class="text-sm text-red-700"></span>
                                    </div>
                                </div>
                            </div>


                            <!-- Image Preview Grid -->
                            <div id="image-preview-grid-create" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4"></div>
                        </div>
                    </div>

                    <!-- Category and Brand -->
                    <div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-6 border border-blue-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Category & Brand</h3>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Category</label>
                                <select id="create-product-category" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                    <option data-category-id="0">Select Category</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}"
                                                data-category-id="${category.id}"
                                                <c:if test="${not empty product && product.category.id == category.id}">
                                                    selected="selected"
                                                </c:if>>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Brand</label>
                                <select id="create-product-brand" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                    <option data-brand-id="0">Select Brand</option>
                                    <c:forEach var="brand" items="${brands}">
                                        <option value="${brand.id}"
                                                data-brand-id="${brand.id}"
                                                <c:if test="${not empty product && product.brand.id == brand.id}">
                                                    selected="selected"
                                                </c:if>>
                                            ${brand.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div id="createAtrributeProduct" class="w-full"></div>

                    <!-- Status -->
                    <div class="bg-yellow-50 rounded-xl p-6 border border-yellow-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Product Status</h3>
                        <div class="space-y-3">
                            <div class="flex items-center">
                                <div>
                                    <input type="checkbox" name="isActive" id="isActiveCreateProduct" value="true"
                                           <c:if test="${product.isActive}">checked</c:if>
                                           class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded">
                                    <label for="isActiveCreateProduct" class="ml-2 text-sm font-medium text-gray-700">Product is active (visible to customers)</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>