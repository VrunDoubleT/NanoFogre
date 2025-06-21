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
                <c:choose>
                    <c:when test="${'create' eq type}">
                        Create Product
                    </c:when>
                    <c:otherwise>
                        Edit Product
                    </c:otherwise>
                </c:choose>
            </h1>
            <div class="flex items-center space-x-4">
                <c:choose>
                    <c:when test="${type == 'create'}">
                        <button id="create-product-btn" class="px-4 py-2 bg-emerald-500 rounded-lg text-white hover:bg-emerald-600 transition-all flex items-center gap-2">
                            <i data-lucide="plus"></i>
                            Create
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button id="update-product-btn" class="px-4 py-2 bg-sky-500 rounded-lg text-white hover:bg-sky-600 transition-all flex items-center gap-2">
                            <i data-lucide="pencil"></i>
                            Update
                        </button>
                    </c:otherwise>
                </c:choose>

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
                                        <input value="${not empty product ? product.title : 'This is a title'}" type="text" name="title" id="title" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="titleError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                        <textarea id="description" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>${not empty product ? product.description : 'This is a descrition'}</textarea>
                                        <span id="descriptionError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Material</label>
                                        <input value="${not empty product ? product.material : 'This is a material'}" type="text" name="title" id="material" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                        <span id="materialError"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Price and Quantity -->
                            <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Price</label>
                                        <input value="${not empty product ? product.price : '50000'}" type="number" step="1000" name="price" id="price" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
                                        <span id="priceError"></span>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
                                        <input value="${not empty product ? product.quantity : '32'}" type="number" name="quantity" id="quantity" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required>
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

                            <!-- OLD IMAGES -->
                            <div class="${'edit' eq type ? "block" : "hidden"}">
                                <div class="bg-gray-100 border border-gray-300 rounded-lg p-3">
                                    <div class="flex items-center">
                                        <i class="fas fa-info-circle text-gray-600 mr-2"></i>
                                        <span class="text-sm text-gray-800">You have already added this image before.</span>
                                    </div>
                                </div>
                            </div>

                            <div id="already-preview-grid" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                                <c:forEach var="productImage" items="${productImages}" varStatus="status">
                                    <div class="relative group">
                                        <img src="${productImage.url}" alt="already image" 
                                             class="w-full h-32 object-cover rounded-lg shadow transition-all duration-300 image-${status.index}">

                                        <input type="checkbox" 
                                               class="absolute top-2 right-2 w-5 h-5 appearance-none border-2 border-white rounded bg-black bg-opacity-50
                                               checked:bg-green-500 checked:border-green-500 cursor-pointer transition-all duration-200
                                               hover:scale-110 focus:outline-none focus:ring-2 focus:ring-green-300"
                                               id="checkbox-${status.index}"
                                               data-index="${status.index}"
                                               data-image-id="${productImage.imageId}"
                                               checked>

                                        <svg class="absolute top-2 right-2 w-5 h-5 text-white pointer-events-none opacity-0 checkbox-icon-${status.index}" 
                                             fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                        </svg>
                                    </div>
                                </c:forEach>
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
                                           <label for="isActive" class="ml-2 text-sm font-medium text-gray-700">Product is active (visible to customers)</label>
                                    </div>
                                    <div class="flex items-center">
                                        <input type="checkbox" name="destroy" id="destroy" value="true"
                                        <c:if test="${product.destroy}">checked</c:if>
                                        class="h-4 w-4 text-red-600 focus:ring-red-500 border-gray-300 rounded">
                                    <label for="destroy" class="ml-2 text-sm font-medium text-gray-700">Mark as destroyed/discontinued</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>