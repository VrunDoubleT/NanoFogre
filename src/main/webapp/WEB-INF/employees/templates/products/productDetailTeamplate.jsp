<%-- 
    Document   : productDetailTeamplate
    Created on : Jun 7, 2025, 12:01:59 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="Models.Product"%>
<%@page import="java.util.List"%>
<%@page import="Utils.CurrencyFormatter"%>
<div class="w-[1120px] h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-3xl font-bold text-white mb-2">#${product.productId}</h1>
            <div class="flex items-center space-x-4 text-blue-100">
                <span class="px-3 py-1 bg-white/20 rounded-full text-sm">${product.category != null ? product.category.name : "No category"}</span>
                <span class="px-3 py-1 bg-white/20 rounded-full text-sm">${product.brand != null ? product.brand.name : "No brand"}</span>
            </div>
        </div>

        <!-- Tab Navigation -->
        <div class="border-b border-gray-200">
            <nav class="flex px-8" aria-label="Tabs">
                <button id="details-tab" class="tab-button active px-6 py-3 text-sm font-medium border-b-2">
                    <i class="fas fa-info-circle mr-2"></i>Product Detail
                </button>
                <button id="preview-tab" class="tab-button px-6 py-3 text-sm font-medium border-b-2 text-gray-500 border-transparent hover:text-blue-600 hover:border-blue-300 transition-all duration-200">
                    <i class="fas fa-eye mr-2"></i>Preview
                </button>
            </nav>
        </div>
    </div>

    <!-- Tab Content -->
    <div id="containerScroll" class="p-8 h-full w-full overflow-y-auto">
        <!-- Details Tab -->
        <div id="details-content" class="tab-content w-full">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Product Images -->
                <div class="space-y-4">
                    <div class="relative">
                        <img id="main-image" src="${product.urls[0]}" alt="${product.title}" class="w-full h-96 border object-contain rounded-xl">
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
                             class="w-20 h-20 object-contain rounded-lg cursor-pointer overflow-hidden hover:ring-2 hover:ring-blue-500 transition-all duration-200 flex-shrink-0">
                        <%
                                }
                            }
                        %>
                    </div>
                    <!-- Description Section -->
                    <div class="mt-8 bg-gray-50 rounded-xl p-6">
                        <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center">
                            Product Description
                        </h3>
                        <p class="text-gray-700 leading-relaxed">${product.description}</p>
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
                                <p class="text-3xl font-bold text-blue-600">${CurrencyFormatter.formatVietNamCurrency(product.price)}</p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-600 mb-1">Quantity</p>
                                <p class="text-2xl font-semibold text-green-600">${product.quantity}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information -->
                    <div class="bg-gray-50 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                            Product Information
                        </h3>
                        <div class="grid grid-cols-1 gap-4">
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Category:</span>
                                    <span class="font-medium">${product.category != null ? product.category.name : "N/A"}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Brand:</span>
                                    <span class="font-medium">${product.brand != null ? product.brand.name : "N/A"}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Material:</span>
                                    <span class="font-medium">${product.material}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Status:</span>
                                    <span class="font-medium">
                                        <% if (product != null) { %>
                                        <% if (product.isDestroy()) { %>
                                        <span class="text-red-600">Disabled</span>
                                        <% } else if (!product.isActive()) { %>
                                        <span class="text-yellow-600">Inactive</span>
                                        <% } else { %>
                                        <span class="text-green-600">Active</span>
                                        <% } %>
                                        <% }%>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Info -->
                    <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-3 flex items-center">
                            Additional Information
                        </h3>
                        <div class="space-y-2">
                            <c:forEach var="productAttribute" items="${productAttributes}">
                                <c:if test="${productAttribute.value != null && !productAttribute.value.trim().isEmpty()}">
                                    <div class="flex justify-between gap-4">
                                        <span class="text-gray-600 whitespace-nowrap">${productAttribute.name}:</span>
                                        <span class="text-gray-500 flex-1 text-end">${productAttribute.value} ${(productAtribute.unit != null && !productAtribute.unit.trim().isEmpty()) ? productAtribute.unit : ''}</span>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty productAttributes}">
                                <span>No information</span>
                            </c:if>
                            <c:if test="${not empty productAttributes}">
                                <c:set var="hasValue" value="false" />
                                <c:forEach var="attr" items="${productAttributes}">
                                    <c:if test="${not empty attr.value}">
                                        <c:set var="hasValue" value="true" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${not hasValue}">
                                    <span>No information</span>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Preview Tab -->
        <div id="preview-content" class="tab-content hidden w-full">
            <input id="productDetailId" value="${product.productId}" class="hidden" />
            <div id="reviewStats">

            </div>
            <div id="reviewList">

            </div>
            <div id="reviewListLoading"></div>
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