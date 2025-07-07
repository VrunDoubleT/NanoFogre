<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    Integer pageAttr = (Integer) request.getAttribute("page");
    Integer limitAttr = (Integer) request.getAttribute("limit");
    int currentPage = pageAttr != null ? pageAttr : 1;
    int limit = limitAttr != null ? limitAttr : 5;
    int startIndex = (currentPage - 1) * limit + 1; // số thứ tự bắt đầu từ 1 trên mỗi trang
    request.setAttribute("startIndex", startIndex); // ĐẶT VÀO REQUEST ĐỂ DÙNG JSTL

%>

<c:choose>
    <c:when test="${empty brands}">
        <tr>
            <td colspan="4" class="text-center text-gray-500 py-8">No brands found in the database.</td>
        </tr>
    </c:when>
    <c:otherwise>
        <c:forEach var="brand" items="${brands}" varStatus="status">
            <tr class="hover:bg-gray-50 transition-colors" data-brand-id="${brand.id}">
                <td class="py-3 px-6 align-middle">
                    <c:out value="${startIndex + status.index}"/>
                </td>
                <td class="py-3 px-6 font-medium align-middle">
                    ${brand.name}
                </td>
                <td class="py-3 px-6 align-middle">
                    <c:if test="${not empty brand.url}">
                        <div class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
                            <img src="${fn:escapeXml(brand.url)}" alt="${fn:escapeXml(brand.name)}"
                                 class="max-h-12 max-w-[3.5rem] object-contain">
                        </div>
                    </c:if>
                </td>
                <td class="py-3 px-6 text-center align-middle">
                    <div class="flex justify-center items-center gap-3 min-h-[40px]">
                        <button
                            onclick="editBrand(
                                            '${brand.id}',
                                            '${brand.name != null ? fn:replace(fn:escapeXml(brand.name), '\'', '\\\'') : ''}',
                                            '${brand.url != null ? fn:replace(fn:escapeXml(brand.url), '\'', '\\\'') : ''}'
                                            )"
                            class="bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors"
                            title="Edit brand">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </button>
                        <button onclick="deleteBrand('${brand.id}')"
                                class="bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors"
                                title="Delete brand">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>
                </td>
            </tr>
        </c:forEach>
    </c:otherwise>
</c:choose>
