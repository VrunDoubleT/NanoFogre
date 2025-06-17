<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Integer pageAttr = (Integer) request.getAttribute("page"); // Lấy từ attribute "page"
    int currentPage = pageAttr != null ? pageAttr : 1;
    pageContext.setAttribute("currentPage", currentPage); // Set vào pageContext
%>


<div id="loadingBrand" class="hidden"> 
    <div class="animate-pulse space-y-4">
        <div class="h-12 bg-gray-200 rounded"></div>
        <div class="h-12 bg-gray-200 rounded"></div>
        <div class="h-12 bg-gray-200 rounded"></div>
    </div>
</div>
<c:choose>
    <c:when test="${empty brands}">
        <div class="text-center text-gray-500 py-8">No brands found in the database.</div>
    </c:when>
    <c:otherwise>
        <div class="flex items-center justify-between mb-8">
    <div class="bg-white rounded-xl p-4 shadow flex items-center gap-4 w-full md:w-auto">
        <div class="bg-blue-100 p-2 rounded-full">
            <i data-lucide="tags" class="w-6 h-6 text-blue-600"></i>
        </div>
        <div>
            <div class="text-2xl font-bold">${total}</div>
            <div class="text-gray-500 text-sm">Total Brands</div>
        </div>
    </div>
    <button id="create-brand-button"
            onclick="openCreateModal()"
            class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2 ml-4">
        <span>Add Brand</span>
    </button>
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
                <tbody id="brandTable" class="divide-y divide-gray-200">
                    <c:forEach var="brand" items="${brands}" varStatus="status">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="py-3 px-6">${(currentPage - 1) * limit + status.index + 1}</td>
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
                                    <button class="text-blue-600 hover:text-blue-800 transition-colors hover:scale-110 active:scale-95"
                                            onclick="editBrand(${brand.id})">
                                        <i data-lucide="pen-square" class="w-5 h-5"></i>
                                    </button>
                                    <button class="text-red-600 hover:text-red-800 transition-colors hover:scale-110 active:scale-95"
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
<jsp:include page="/WEB-INF/employees/teamplates/brands/brandTeamplate.jsp" flush="true" />
