<%-- 
    Document   : createProductTeamplate
    Created on : Jun 12, 2025, 7:41:30 AM
    Author     : Tran Thanh Van - CE181019
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <div class="w-[1120px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-3xl font-bold text-white mb-2">Create Product</h1>
            <div class="flex items-center space-x-4">
                <button id="create-product-btn" class="px-4 py-2 bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                    <i class="fas fa-save mr-2"></i>Create
                </button>
            </div>
        </div>

        <!-- Tab Content -->
        <div class="p-8 h-full w-full overflow-y-auto">
            <!-- Details Tab -->
            <div id="details-content" class="tab-content w-full">
                <div id="productForm" class="space-y-6">
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                        <!-- Basic Information -->
                        <div class="space-y-6">
                            <div class="bg-gray-50 rounded-xl p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>

                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
                                        <input value="This is value title" type="text" name="title" id="title" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="titleError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                        <textarea id="description" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>"This is value description"</textarea>
                                        <span id="descriptionError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Features</label>
                                        <textarea name="features" id="features" rows="3" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">"This is value features"</textarea>
                                        <span id="featuresError"></span>
                                    </div>
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
                                                <option data-category-id="${category.id}">${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Brand</label>
                                        <select id="create-product-brand" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                            <option data-brand-id="0">Select Brand</option>
                                            <c:forEach var="brand" items="${brands}">
                                                <option data-brand-id="${brand.id}">${brand.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Product Specifications -->
                        <div class="space-y-6">
                            <div class="bg-gray-50 rounded-xl p-6">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Specifications</h3>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Scale</label>
                                        <input value="1:64" type="text" name="scale" id="scale" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" placeholder="1:64">
                                        <span id="scaleError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Material</label>
                                        <input value="This is value material" type="text" name="material" id="material" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" placeholder="Metal">
                                        <span id="materialError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Paint</label>
                                        <input value="This is value paint" type="text" name="paint" id="paint" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" placeholder="Glossy">
                                        <span id="paintError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Manufacturer</label>
                                        <input value="This is value manufacturer" type="text" name="manufacturer" id="manufacturer" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" placeholder="Mattel Inc.">
                                        <span id="manufacturerError"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Dimensions -->
                            <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Dimensions</h3>

                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Length (cm)</label>
                                        <input value="10" type="number" step="0.1" name="length" id="length" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="lengthError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Width (cm)</label>
                                        <input value="10" type="number" step="0.1" name="width" id="width" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="widthError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Height (cm)</label>
                                        <input value="11" type="number" step="0.1" name="height" id="height" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="heightError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Weight (g)</label>
                                        <input value="5.4" type="number" step="0.1" name="weight" id="weight" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="weightError"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Price and Quantity -->
                            <div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-6 border border-blue-100">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Price ($)</label>
                                        <input value="100000" type="number" step="0.01" name="price" id="price" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                        <span id="priceError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
                                        <input value="101" type="number" name="quantity" id="quantity" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
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
                                           id="image-files" 
                                           name="imageFiles" 
                                           multiple 
                                           accept="image/*" 
                                           class="hidden">
                                    <label for="image-files" id="drop-zone" class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
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
                            <div id="upload-status" class="hidden">
                                <div class="bg-blue-50 border border-blue-200 rounded-lg p-3">
                                    <div class="flex items-center">
                                        <i class="fas fa-info-circle text-blue-500 mr-2"></i>
                                        <span id="status-text" class="text-sm text-blue-700"></span>
                                    </div>
                                </div>
                            </div>
                            <!-- Upload error -->
                            <div id="upload-error" class="hidden">
                                <div class="bg-red-50 border border-red-200 rounded-lg p-3">
                                    <div class="flex items-center">
                                        <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                                        <span id="error-text" class="text-sm text-red-700"></span>
                                    </div>
                                </div>
                            </div>


                            <!-- Image Preview Grid -->
                            <div id="image-preview-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4"></div>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="bg-yellow-50 rounded-xl p-6 border border-yellow-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Product Status</h3>
                        <div class="flex items-center">
                            <input type="checkbox" name="destroy" id="destroy" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                            <label for="destroy" class="ml-2 text-sm font-medium text-gray-700">Mark as destroyed/discontinued</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>