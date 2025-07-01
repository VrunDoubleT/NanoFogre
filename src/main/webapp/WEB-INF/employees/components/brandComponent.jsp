<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Integer pageAttr = (Integer) request.getAttribute("page");
    int currentPage = pageAttr != null ? pageAttr : 1;
    pageContext.setAttribute("currentPage", currentPage);
%>

<input type="hidden" id="totalPages" value="${totalPages}"/>
<input type="hidden" id="limit" value="${limit}"/>
<input type="hidden" id="page" value="${currentPage}"/>

<div id="loadingBrand" class="hidden">
    <div class="flex w-full justify-center items-center h-32">
        <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
    </div>
</div>

<c:choose>
    <c:when test="${empty brands}">
        <div class="text-center text-gray-500 py-8">No brands found in the database.</div>
    </c:when>
    <c:otherwise>
        <div class="bg-white rounded-xl shadow overflow-hidden">
            <div class="flex items-center justify-between px-6 py-4 border-b">
                <div class="flex items-center">
                    <span class="text-2xl font-bold text-gray-900">
                        Total Brands: ${total}
                    </span>
                    <div class="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center ml-2">
                        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
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
            <table class="min-w-full">
                <thead class="bg-gray-50">
                    <tr class="text-sm text-gray-700 uppercase">
                        <th class="py-4 px-6 text-left">#</th>
                        <th class="py-4 px-6 text-left">Brand Name</th>
                        <th class="py-4 px-6 text-left">Image</th>
                        <th class="py-4 px-6 text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="brandTable" class="divide-y divide-gray-200">
                    <c:forEach var="brand" items="${brands}" varStatus="status">
                        <tr class="hover:bg-gray-50 transition-colors">
                            <td class="py-3 px-6 align-middle">${(currentPage - 1) * limit + status.index + 1}</td>
                            <td class="py-3 px-6 font-medium align-middle">${brand.name}</td>
                            <td class="py-3 px-6 align-middle">
                                <c:if test="${not empty brand.url}">
                                    <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                                        <img src="${brand.url}" alt="${brand.name}"
                                             class="max-h-12 max-w-[3.5rem] object-contain">
                                    </div>
                                </c:if>
                            </td>
                            <td class="py-3 px-6 text-center align-middle">
                                <c:if test="${not empty sessionScope.employee && sessionScope.employee.role.id == 1}">
                                    <div class="flex justify-center items-center gap-3 min-h-[40px]">
                                        <button onclick="editBrand(${brand.id})"
                                                class="bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors"
                                                title="Edit brand">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                            </svg>
                                        </button>
                                        <button onclick="deleteBrand(${brand.id})"
                                                class="bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors"
                                                title="Delete brand">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M6 18L18 6M6 6l12 12"/>
                                            </svg>
                                        </button>
                                    </div>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/employees/teamplates/brands/brandTeamplate.jsp" flush="true" />
