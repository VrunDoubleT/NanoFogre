<%-- 
    Document   : vouchersTemplate
    Created on : Jun 22, 2025, 4:12:05 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:choose>
    <c:when test="${empty vlist}">
        <tr>
            <td colspan="7">
                <div class="flex justify-center items-center text-gray-500 text-center w-full h-20">
                    Can't find any vouchers matching your request
                </div>
            </td>
        </tr>
    </c:when>
    <c:otherwise>
        <c:set var="index" value="${(page - 1) * limit + 1}" />
        <c:forEach var="v" items="${vlist}">
            <tr>
                <!-- Index -->
                <td class="px-9 py-3 whitespace-nowrap text-center">
                    <span class="font-bold text-[20px] text-gray-500">${v.id}</span>
                </td>

                <!-- Code -->
                <td class="px-10 py-3 whitespace-nowrap">
                    <span class="px-2 py-1 rounded-md bg-gray-100 text-gray-900 font-mono text-sm border border-gray-300">
                        ${v.code}
                    </span>
                </td>

                <!-- Value -->
                <td class="px-10 py-3 whitespace-nowrap text-center">
                    <c:choose>
                        <c:when test="${v.type == 'PERCENTAGE'}">
                            <span class="text-sm text-gray-900">
                                <strong><fmt:formatNumber value="${v.value}" type="number" maxFractionDigits="0" />%</strong>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-sm text-gray-900">
                                <strong><fmt:formatNumber value="${v.value}" type="number" groupingUsed="true" /></strong>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <!-- Usage Limits -->
                <td class="px-8 py-3 whitespace-nowrap text-center">
                    <div class="text-sm text-gray-900">
                        <div><strong>Total:</strong> <c:out value="${v.totalUsageLimit != null ? v.totalUsageLimit : 'Unlimited'}"/></div>
                        <div><strong>User:</strong> <c:out value="${v.userUsageLimit != null ? v.userUsageLimit : 'Unlimited'}"/></div>
                    </div>
                </td>

                <!-- Status -->
                <td class="px-8 py-3 whitespace-nowrap text-center">
                    <c:choose>
                        <c:when test="${v.status == 'Ongoing'}">
                            <c:set var="statusClass" value="bg-green-100 text-green-800" />
                        </c:when>
                        <c:when test="${v.status == 'Upcoming'}">
                            <c:set var="statusClass" value="bg-yellow-100 text-yellow-800" />
                        </c:when>
                        <c:when test="${v.status == 'Expired'}">
                            <c:set var="statusClass" value="bg-red-100 text-red-800" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusClass" value="bg-gray-100 text-gray-800" />
                        </c:otherwise>
                    </c:choose>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${statusClass}">
                        ${v.status}
                    </span>
                </td>

                <!-- Active/Inactive -->
                <td class="px-9 py-3 whitespace-nowrap text-center">
                    <c:choose>
                        <c:when test="${v.isActive}">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-200 text-green-800">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <!-- Action Buttons -->
                <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex justify-center space-x-2">
                        <button type="button" data-id="${v.id}" class="detail-voucher-button bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                        </button>

                        <c:if test="${sessionScope.employee.role.id == 1}">
                            <button data-id="${v.id}" class="update-voucher-button bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                </svg>
                            </button>

                            <button data-id="${v.id}" class="delete-voucher-button bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M6 18L18 6M6 6l12 12"/>
                                </svg>
                            </button>
                        </c:if>
                    </div>
                </td>
            </tr>
            <c:set var="index" value="${index + 1}" />
        </c:forEach>
    </c:otherwise>
</c:choose>
