<%-- 
    Document   : voucherComponent
    Created on : Jun 22, 2025, 4:05:45 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="">
    <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">
        <div class="flex items-center justify-between p-6">  
            <div class="flex items-center gap-3">
                <div class="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                    <i data-lucide="ticket-percent" class="w-6 h-6 text-blue-600"></i>
                </div>
                <div>
                    <h2 class="text-[20px] font-semibold text-gray-800">Vouchers</h2>
                </div>
            </div>
            <div class="flex items-center space-x-3">
                <c:if test="${sessionScope.employee.role.id == 1}">
                    <div class="flex items-center space-x-3">
                        <button id="create-voucher-button" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2">
                            <i data-lucide="diamond-plus" class="w-5 h-5"></i>
                            <span>Add New Voucher</span>
                        </button>
                    </div>
                </c:if>
                <select id="category-filter" onchange="loadVoucherContentAndEvent(1, this.value)"
                        class="border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="0">All Categories</option>
                    <c:forEach var="cat" items="${categoryList}">
                        <option value="${cat.id}" 
                                <c:if test="${param.categoryId == cat.id}">selected</c:if>>${cat.name}</option>
                    </c:forEach>
                </select>

            </div>
        </div>

        <div class="w-full">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">#</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Code</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Value</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Limit</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Status</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Active</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">

                </tbody>
            </table>
            <div id="loadingVoucher"></div>
        </div>
    </div>
    <div id="pagination"></div>
</div>     

