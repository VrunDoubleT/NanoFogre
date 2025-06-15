<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

        <!-- Thông tin số lượng hiển thị -->
        <div class="mb-4 text-sm text-gray-600 text-center">
            Showing <strong>${(currentPage - 1) * 5 + 1}</strong>
            to <strong>${currentPage * 5 > totalBrands ? totalBrands : currentPage * 5}</strong>
            of <strong>${totalBrands}</strong> results
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
                                    <button class="text-blue-600 hover:text-blue-800 transition-colors"
                                            onclick="editBrand(${brand.id})">
                                        <i data-lucide="pen-square" class="w-5 h-5"></i>
                                    </button>
                                    <button class="text-red-600 hover:text-red-800 transition-colors"
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

        <!-- Phần phân trang -->
        <div class="mt-6 flex justify-center">
            <c:if test="${totalPages > 1}">
                <div class="flex items-center space-x-2">
                    <button 
                        class="px-3 py-2 text-sm rounded-lg border ${currentPage == 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                        onclick="loadBrandPage(1)"
                        ${currentPage == 1 ? 'disabled' : ''}>
                        &lt;&lt;
                    </button>
                    <button 
                        class="px-3 py-2 text-sm rounded-lg border ${currentPage == 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                        onclick="loadBrandPage(${currentPage - 1})"
                        ${currentPage == 1 ? 'disabled' : ''}>
                        &lt;
                    </button>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <button 
                            class="px-4 py-2 text-sm rounded-lg border ${currentPage == i ? 'bg-blue-600 text-white border-blue-600' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                            onclick="loadBrandPage(${i})">
                            ${i}
                        </button>
                    </c:forEach>
                    <button 
                        class="px-3 py-2 text-sm rounded-lg border ${currentPage == totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                        onclick="loadBrandPage(${currentPage + 1})"
                        ${currentPage == totalPages ? 'disabled' : ''}>
                        &gt;
                    </button>
                    <button 
                        class="px-3 py-2 text-sm rounded-lg border ${currentPage == totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white hover:bg-gray-50 text-gray-700'}"
                        onclick="loadBrandPage(${totalPages})"
                        ${currentPage == totalPages ? 'disabled' : ''}>
                        &gt;&gt;
                    </button>
                </div>
            </c:if>
        </div>
    </c:otherwise>
</c:choose>
