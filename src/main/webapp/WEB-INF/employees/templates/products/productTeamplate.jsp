<%-- 
    Document   : productTeamplate
    Created on : Jun 8, 2025, 11:28:47 AM
    Author     : Tran Thanh Van - CE181019
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="Utils.CurrencyFormatter" %> 
<%@page import="Utils.CurrencyFormatter"%>
<%@page import="Utils.Converter"%>
<%@page import="Models.Product"%>
<%@page import="java.util.List"%>
<c:choose>
    <c:when test="${not empty products}">
        <c:forEach var="product" items="${products}">
            <tr>
                <td class="px-4 py-4 whitespace-nowrap">
                    <div class="text-lg font-semibold text-gray-900">
                        ${product.productId}
                    </div>
                </td>
                <!-- Image + Info -->
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 h-16 w-16">
                            <c:choose>
                                <c:when test="${not empty product.urls}">
                                    <img class="h-16 w-16 rounded-lg object-cover border border-gray-200"
                                         src="${product.urls[0]}" alt="${product.title}" />
                                </c:when>
                                <c:otherwise>
                                    <span class="h-16 w-16 flex justify-center items-center rounded-lg text-[10px] text-medium border border-gray-200">No image</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="ml-4">
                            <div class="text-sm font-medium text-gray-900">
                                <c:choose>
                                    <c:when test="${fn:length(product.title) > 30}">
                                        ${fn:substring(product.title, 0, 27)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${product.title}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex items-center mt-1">
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                    <c:out value="${empty product.category.name ? 'No category' : product.category.name}" />
                                </span>
                                <span class="ml-2 inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                    <c:out value="${empty product.brand.name ? 'No brand' : product.brand.name}" />
                                </span>
                            </div>
                        </div>
                    </div>
                </td>

                <!-- Material + Image count -->
                <td class="px-4 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">
                        <div><strong>Images:</strong> ${fn:length(product.urls)}</div>
                        <div><strong>Material:</strong> ${product.material}</div>
                    </div>
                </td>

                <!-- Price -->
                <td class="px-4 py-4 whitespace-nowrap">
                    <div class="text-lg font-semibold text-gray-900">
                        ${CurrencyFormatter.formatVietNamCurrency(product.price)}
                    </div>
                </td>

                <!-- Quantity -->
                <td class="px-4 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-900 text-center">${product.quantity}</div>
                </td>

                <!-- Status -->
                <td class="px-4 py-4 whitespace-nowrap">
                    <c:choose>
                        <c:when test="${!product.active}">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-200 text-yellow-800">
                                Inactive
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                Active
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <!-- Action buttons -->
                <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex justify-center items-center space-x-2">
                        <button data-product-id="${product.productId}" class="openViewModal bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                            <!-- Eye SVG -->
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </button>

                           <c:if test="${sessionScope.employee.role.id eq 1}">
                            <button data-product-id="${product.productId}" class="openEditProdctModal bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                                <!-- Pencil SVG -->
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                </svg>
                            </button>

                            <button data-product-id="${product.productId}" class="openDeleteProdct bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors" title="Hide product">
                                <!-- X SVG -->
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </c:if>
                    </div>
                </td>
            </tr>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <tr>
            <td colspan="7" class="text-center text-gray-500 py-6">
                Can't find any products matching your request
            </td>
        </tr>
    </c:otherwise>
</c:choose>

