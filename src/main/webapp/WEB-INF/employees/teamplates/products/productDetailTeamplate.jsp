<%-- 
    Document   : productDetailTeamplate
    Created on : Jun 7, 2025, 12:01:59 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@page import="Models.Product"%>
<%@page import="java.util.List"%>
<div class="w-[1120px] h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-3xl font-bold text-white mb-2">#${product.productId}</h1>
            <div class="flex items-center space-x-4 text-blue-100">
                <span class="px-3 py-1 bg-white/20 rounded-full text-sm">${product.category.name}</span>
                <span class="px-3 py-1 bg-white/20 rounded-full text-sm">${product.brand.name}</span>
            </div>
        </div>

        <!-- Tab Navigation -->
        <div class="border-b border-gray-200">
            <nav class="flex px-8" aria-label="Tabs">
                <button id="details-tab" class="tab-button active px-6 py-3 text-sm font-medium border-b-2">
                    <i class="fas fa-info-circle mr-2"></i>Product Detail
                </button>
                <button id="preview-tab" class="tab-button px-6 py-3 text-sm font-medium border-b-2 text-gray-500 border-transparent hover:text-blue-600 hover:border-blue-300 transition-all duration-200>
                        <i class="fas fa-eye mr-2"></i>Reviews
                </button>
            </nav>
        </div>
    </div>

    <!-- Tab Content -->
    <div class="p-8 h-full w-full overflow-y-auto">
        <!-- Details Tab -->
        <div id="details-content" class="tab-content w-full">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Product Images -->
                <div class="space-y-4">
                    <div class="relative">
                        <img id="main-image" src="${product.urls[0]}" alt="${product.title}" class="w-full h-96 object-cover rounded-xl shadow-lg">
                        <div class="absolute top-4 right-4">
                            <%
                                Product product = (Product) request.getAttribute("product");
                                if (product != null) {
                                    if (product.getQuantity() > 0) {
                            %>
                            <span class="px-3 py-1 bg-green-500 text-white text-sm rounded-full">In stock</span>
                            <%
                            } else {
                            %>
                            <span class="px-3 py-1 bg-red-500 text-white text-sm rounded-full">Out of stock</span>
                            <%
                                }
                            } else {
                            %>
                            <span style="color: red;">No product found</span>
                            <%
                                }
                            %>

                        </div>
                    </div>
                    <!-- Image Gallery -->
                    <div class="flex space-x-3 overflow-x-auto p-2">
                        <%
                            List<String> urls = (List<String>) (((Product) request.getAttribute("product")).getUrls());
                            if (urls != null) {
                                for (String url : urls) {
                        %>
                        <img onclick="changeMainImage('<%= url%>')"
                             src="<%= url%>" 
                             alt="Image" 
                             class="w-20 h-20 object-cover rounded-lg cursor-pointer overflow-hidden hover:ring-2 hover:ring-blue-500 transition-all duration-200 flex-shrink-0">
                        <%
                                }
                            }
                        %>

                    </div>
                </div>

                <!-- Product Information -->
                <div class="space-y-6">
                    <h2 class="font-bold text-3xl">${product.title}</h2>
                    <!-- Price Section -->
                    <div class="bg-gradient-to-r from-blue-50 to-purple-50 p-6 rounded-xl border border-blue-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600 mb-1">Price</p>
                                <p class="text-3xl font-bold text-blue-600">$${product.price}</p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-600 mb-1">Quantity</p>
                                <p class="text-2xl font-semibold text-green-600">${product.quantity}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Specifications -->
                    <div class="bg-gray-50 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                            Specifications
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Scale:</span><span class="font-medium">${product.scale}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Material:</span><span class="font-medium">${product.material}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Paint:</span><span class="font-medium">${product.paint}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Manufacturer:</span><span class="font-medium">${product.manufacturer}</span>
                                </div>
                            </div>
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Length:</span><span class="font-medium">${product.length} cm</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Width:</span><span class="font-medium">${product.width} cm</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Height:</span><span class="font-medium">${product.height} cm</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Weight:</span><span class="font-medium">${product.weight} g</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Features -->
                    <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                            Special Features
                        </h3>
                        <p class="text-gray-700 leading-relaxed">${product.features}</p>

                    </div>
                </div>
            </div>

            <!-- Description Section -->
            <div class="mt-8 bg-gray-50 rounded-xl p-6">
                <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                    Product Description
                </h3>
                <p class="text-gray-700 leading-relaxed">${product.description}</p>
            </div>
        </div>

        <!-- Preview Tab -->
        <div id="preview-content" class="tab-content hidden w-full">
            <div class="bg-gradient-to-br from-blue-50 to-purple-50 rounded-2xl p-8 border border-blue-100">
                <div class="w-full mx-auto">
                    <!-- Preview Card -->
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                        <div class="relative">
                            <img src="${product.urls[0]}" alt="${product.title}" class="w-full h-64 object-cover">
                            <div class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center">
                                <div class="text-center text-white">
                                    <h2 class="text-2xl font-bold mb-2">${product.title}</h2>
                                    <p class="text-lg">$${product.price}</p>
                                </div>
                            </div>
                        </div>

                        <div class="p-6">
                            <div class="flex items-center justify-between mb-4">
                                <div class="flex items-center space-x-2">
                                    <span class="px-3 py-1 bg-blue-100 text-blue-800 text-sm rounded-full">${product.category.name}</span>
                                    <span class="px-3 py-1 bg-purple-100 text-purple-800 text-sm rounded-full">${product.brand.name}</span>
                                </div>
                                <div class="flex items-center space-x-1 text-yellow-500">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                            </div>

                            <p class="text-gray-600 mb-4">${product.description}</p>

                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                                <div class="text-center p-3 bg-gray-50 rounded-lg">
                                    <i class="fas fa-ruler text-blue-600 mb-1"></i>
                                    <p class="font-medium">${product.scale}</p>
                                    <p class="text-gray-500">Scale</p>
                                </div>
                                <div class="text-center p-3 bg-gray-50 rounded-lg">
                                    <i class="fas fa-cube text-green-600 mb-1"></i>
                                    <p class="font-medium">${product.material}</p>
                                    <p class="text-gray-500">Material</p>
                                </div>
                                <div class="text-center p-3 bg-gray-50 rounded-lg">
                                    <i class="fas fa-weight text-purple-600 mb-1"></i>
                                    <p class="font-medium">${product.weight} g</p>
                                    <p class="text-gray-500">Weight</p>
                                </div>
                                <div class="text-center p-3 bg-gray-50 rounded-lg">
                                    <i class="fas fa-boxes text-orange-600 mb-1"></i>
                                    <p class="font-medium">${product.quantity}</p>
                                    <p class="text-gray-500">Available</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .tab-button.active {
        color: #2563eb;
        border-color: #2563eb;
    }

    .tab-content {
        animation: fadeIn 0.3s ease-in-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

<script src="../../../js/productDetailTeamplate.js"></script>