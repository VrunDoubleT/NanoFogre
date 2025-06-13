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
                <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
                    <div class="relative flex-1">
                    </div>
                    <select id="brandCategoryFilter" class="border rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500"
                            onchange="filterByCategory(this.value)">
                        <option value="all" ${empty selectedCategory || selectedCategory eq 'all' ? 'selected' : ''}>All Categories</option>
                        <option value="moto" ${selectedCategory eq 'moto' ? 'selected' : ''}>Moto</option>
                        <option value="airplane" ${selectedCategory eq 'airplane' ? 'selected' : ''}>Airplane</option>
                        <option value="oto" ${selectedCategory eq 'oto' ? 'selected' : ''}>Oto</option>
                        <option value="other" ${selectedCategory eq 'other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
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
                        <tr class="hover:bg-gray-50 transition-colors" data-category="${brand.category}">
                            <td class="py-3 px-6">${status.index + 1}</td>
                            <td class="py-3 px-6 font-medium">
                                ${brand.name}
                                <c:if test="${not empty brand.category}">
                                    <span class="block text-sm text-gray-500">Category: ${brand.category}</span>
                                </c:if>
                            </td>
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
    </c:otherwise>
</c:choose>
