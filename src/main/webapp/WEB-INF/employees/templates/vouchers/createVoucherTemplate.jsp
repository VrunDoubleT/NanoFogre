<%-- 
    Document   : createVoucherTemplate
    Created on : Jun 22, 2025, 6:37:06 PM
    Author     : Duong Tran Ngoc Chau - CE181040
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
    <div class="w-[1120px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-2xl font-bold text-white m-2 ml-0">Create New Voucher</h1>
            <div class="flex items-center space-x-4">
                <button id="create-voucher-btn" class="px-4 py-2 flex bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                    <i data-lucide="plus"></i>
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
                        <div class="space-y-6 bg-gray-50 rounded-xl p-6">
                            <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>
                            <div class="space-y-4">
                                <!-- Voucher Code -->
                                <div>
                                    <label for="voucherCode" class="block text-sm font-medium text-gray-700 mb-2">Voucher Code</label>
                                    <input placeholder="Enter code" type="text" name="code" id="code"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                    <span id="voucherCodeError" class="text-sm text-red-500 mt-1 block"></span>                           
                                </div>

                                <!-- Type -->
                                <div>
                                    <label for="voucherType" class="block text-sm font-medium text-gray-700 mb-2">
                                        Discount Type
                                    </label>
                                    <select
                                        id="voucherType"
                                        name="voucherType"
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                        required
                                        >
                                        <option value="PERCENTAGE">Percentage (%)</option>
                                        <option value="FIXED">Fixed Amount</option>
                                    </select>
                                </div>

                                <!-- Value -->
                                <div>
                                    <label for="value" class="block text-sm font-medium text-gray-700 mb-2">
                                        Discount Value
                                    </label>
                                    <div class="relative">
                                        <input
                                            type="number"
                                            id="value"
                                            name="value"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                            placeholder="Enter discount value"
                                            step="1"
                                            min="0"
                                            required
                                            />                                      
                                        <span id="valueError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>
                                </div>

                                <!-- Multi-Category Select -->
                                <div>
                                    <label for="category" class="block text-sm font-medium text-gray-700 mb-2">Applicable Categories</label>
                                    <select id="category" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none">
                                        <option value="">Select Category</option>
                                        <c:forEach var="cat" items="${categoryList}">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                    <!-- Display selected categories -->
                                    <div id="selectedCategories" class="flex flex-wrap gap-2 mt-3"></div>
                                    <!-- Hidden inputs to send selected ids -->
                                    <div id="selectedCategoryInputs"></div>
                                    <span id="categoryError" class="text-sm text-red-500 mt-1 block"></span>
                                </div>

                                <!-- Description -->
                                <div>
                                    <label for="voucherDescription" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                    <textarea id="description" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required></textarea>
                                    <span id="descriptionError" class="text-sm text-red-500 mt-1 block"></span>
                                </div>
                            </div>
                        </div>

                        <!-- Conditions & Limits -->
                        <div class="space-y-6">
                            <div class="bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-6 border border-blue-100">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Conditions & Limits</h3>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label for="minValue" class="block text-sm font-medium text-gray-700 mb-2">Minimum Order Value</label>
                                        <input
                                            type="number"
                                            id="minValue"
                                            name="minValue"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                            placeholder="Minimum order amount"
                                            step="1"
                                            min="0"
                                            />
                                        <span id="minValueError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>

                                    <div>
                                        <label for="maxValue" class="block text-sm font-medium text-gray-700 mb-2">Maximum Discount Amount</label>
                                        <input
                                            type="number"
                                            id="maxValue"
                                            name="maxValue"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                            placeholder="Maximum discount cap"
                                            step="1"
                                            min="0"
                                            />
                                        <span id="maxValueError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>

                                    <div>
                                        <label for="totalUsageLimit" class="block text-sm font-medium text-gray-700 mb-2">Total Usage Limit</label>
                                        <input
                                            type="number"
                                            id="totalUsageLimit"
                                            name="totalUsageLimit"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                            placeholder="Total number of times this voucher can be used"
                                            step="1"
                                            min="0"
                                            />
                                        <span id="totalUsageLimitError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>

                                    <div>
                                        <label for="userUsageLimit" class="block text-sm font-medium text-gray-700 mb-2">Per User Limit</label>
                                        <input
                                            type="number"
                                            id="userUsageLimit"
                                            name="userUsageLimit"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                            placeholder="Number of times each user can use"
                                            step="1"
                                            min="0"
                                            />
                                        <span id="userUsageLimitError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Validity Period -->
                            <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border border-green-100">
                                <h3 class="text-lg font-semibold text-gray-900 mb-4">Validity Period</h3>
                                <div class="space-y-4">
                                    <div>
                                        <label for="validFrom" class="block text-sm font-medium text-gray-700 mb-2">Valid From</label>
                                        <input
                                            type="datetime-local"
                                            id="validFrom"
                                            name="validFrom"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            required
                                            />
                                        <span id="validFromError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>

                                    <div>
                                        <label for="validTo" class="block text-sm font-medium text-gray-700 mb-2">Valid Until</label>
                                        <input
                                            type="datetime-local"
                                            id="validTo"
                                            name="validTo"
                                            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                            required
                                            />
                                        <span id="validToError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Active -->
                    <div class="bg-yellow-50 rounded-xl p-6 border border-yellow-100">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Voucher Active</h3>
                        <div class="flex items-center">
                            <input type="checkbox" name="block" id="block"
                                   class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                            <label for="block" class="ml-2 text-sm font-medium text-gray-700">Mark as inactive</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
