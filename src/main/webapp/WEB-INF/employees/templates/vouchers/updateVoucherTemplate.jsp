<%-- 
    Document   : updateVoucherTemplate
    Created on : Jun 23, 2025, 10:51:24 AM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Voucher"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    Voucher voucher = (Voucher) request.getAttribute("voucher");
    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    String validFromFormatted = voucher.getValidFrom().format(formatter);
    String validToFormatted = voucher.getValidTo().format(formatter);
%>
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
    <form method="post">
        <div class="w-[1120px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
            <input type="hidden" id="id" name="id" value="<%= voucher.getId()%>">
            <input type="hidden" id="voucherStatus" value="${voucherStatus}">
            <input type="hidden" id="voucherIsUsed" value="${voucherIsUsed}">

            <!-- Header Section -->
            <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
                <h1 class="text-2xl font-bold text-white m-2 ml-0">Edit Voucher</h1>
                <div class="flex items-center space-x-4">
                    <button type="submit" id="update-staff-btn" class="px-4 flex py-2 bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                        <i data-lucide="pencil"></i>
                        <i class="fas fa-save mr-2"></i>Update
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
                                        <input placeholder="Enter code" type="text" name="code" id="code" value="<%= voucher.getCode()%>"
                                               data-origin="<%= voucher.getCode()%>"
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
                                            />
                                            <option value="PERCENTAGE" <%= "PERCENTAGE".equals(voucher.getType()) ? "selected" : ""%>>Percentage (%)</option>
                                            <option value="FIXED" <%= "FIXED".equals(voucher.getType()) ? "selected" : ""%>>Fixed Amount</option>
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
                                                value="<%= voucher.getValue()%>"
                                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
                                                placeholder="Enter discount value"
                                                step="1"
                                                min="0"
                                                required
                                                />                                     
                                            <span id="valueError" class="text-sm text-red-500 mt-1 block"></span>
                                        </div>
                                    </div>

                                    <!-- Category Multi-select for Update -->
                                    <div>
                                        <label for="category" class="block text-sm font-medium text-gray-700 mb-2">
                                            Applicable Categories
                                        </label>
                                        <select id="category"
                                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none">
                                            <option value="">Select Category</option>
                                            <c:forEach var="cat" items="${categoryList}">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="selectedCategories" class="flex flex-wrap gap-2 mt-2">
                                            <c:forEach var="cat" items="${selectedCategories}">
                                                <div class="flex items-center gap-1 px-3 py-1 bg-blue-100 text-blue-800 rounded text-sm category-tag"
                                                     data-id="${cat.id}">
                                                    <span>${cat.name}</span>
                                                    <button type="button" class="text-blue-500 remove-category" title="Remove">&times;</button>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div id="selectedCategoryInputs">
                                            <c:forEach var="cat" items="${selectedCategories}">
                                                <input type="hidden" name="categoryIds" value="${cat.id}" data-id="${cat.id}" data-name="${cat.name}" />
                                            </c:forEach>
                                        </div>
                                        <span id="categoryError" class="text-sm text-red-500 mt-1 block"></span>
                                    </div>

                                    <!-- Description -->
                                    <div>
                                        <label for="voucherDescription" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                        <textarea id="description"  data-origin="<%= voucher.getDescription()%>" name="description" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none" required><%= voucher.getDescription()%></textarea>
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
                                                value="<%= voucher.getMinValue()%>"
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
                                                value="<%= voucher.getMaxValue() != null ? voucher.getMaxValue() : "" %>"
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
                                                value="<%= voucher.getTotalUsageLimit() != null ? voucher.getTotalUsageLimit() : "" %>"
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
                                                value="<%= voucher.getUserUsageLimit() != null ? voucher.getUserUsageLimit() : "" %>"
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
                                                value="<%= validFromFormatted%>"
                                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
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
                                                value="<%= validToFormatted%>"
                                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none"
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
                            <label class="block text-sm font-medium text-gray-700 mb-2">Voucher Active</label>
                            <div class="pl-5">
                                <label class="flex items-center space-x-2 pb-3">
                                    <input type="radio" name="status" value="Active"
                                           class="accent-blue-600"
                                           <%= voucher.isIsActive() ? "checked" : ""%>>
                                    <span class="text-gray-800">Active</span>
                                </label>
                                <label class="flex items-center space-x-2">
                                    <input type="radio" name="status" value="Block"
                                           class="accent-red-600"
                                           <%= !voucher.isIsActive() ? "checked" : ""%>>
                                    <span class="text-gray-800">Inactive</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
