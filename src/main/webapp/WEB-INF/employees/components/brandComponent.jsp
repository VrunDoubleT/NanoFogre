<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">
    <div class="flex items-center justify-between p-6">
        <div class="flex items-center space-x-4">
            <p class="text-3xl font-bold text-gray-900 category-count">
                Total Brands: <span id="brandTotalCount">${total}</span>
            </p>
            <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center ml-4">
                <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                </svg>
            </div>
        </div>
        <c:if test="${not empty sessionScope.employee && sessionScope.employee.role.id == 1}">
            <button id="create-brand-button"
                    onclick="openCreateModal()"
                    class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2 ml-4">
                <i data-lucide="diamond-plus"></i>
                <span>Add Brand</span>
            </button>
        </c:if>
    </div>
    <div>
        <table class="w-full max-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Brand Name</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Image</th>
                        <c:if test="${not empty sessionScope.employee && sessionScope.employee.role.id == 1}">
                        <th class="px-6 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                        </c:if>
                </tr>
            </thead>
            <tbody id="brandTable"></tbody>
        </table>
        <div id="loadingBrand" class="hidden"></div>
    </div>
</div>
<div id="pagination" class="flex justify-center py-4"></div>
<input type="hidden" id="totalBrandHidden" value="${total}"/>
<%@ include file="/WEB-INF/employees/templates/brands/createBrandTeamplate.jsp" %>
<%@ include file="/WEB-INF/employees/templates/brands/editBrandTeamplate.jsp" %>
