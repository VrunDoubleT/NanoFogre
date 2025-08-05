<%-- 
    Document   : products
    Created on : Jul 2, 2025, 10:15:19 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Utils.CurrencyFormatter"%>
<%@page import="Utils.DateFormatter"%>
<c:choose>
    <c:when test="${not empty products}">
        <c:forEach var="p" items="${products}">
            <div class="rounded-xl border overflow-hidden">
                <div class="mb-6 rounded-md overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
                    <c:choose>
                        <c:when test="${not empty p.urls and not empty p.urls[0]}">
                            <img src="${p.urls[0]}" alt="${p.title}" 
                                 class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-48 shimmer flex items-center justify-center">
                                <i data-lucide="image" class="w-12 h-12 text-gray-400"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="px-5">
                    <a href="/product/detail?pId=${p.productId}" class="font-bold text-gray-800 cursor-pointer text-[17px] leading-tight line-clamp-2 hover:text-purple-600 hover:underline transition-colors">
                        ${p.title}
                    </a>

                    <div class="mt-1 flex items-center gap-2">
                        <div class="flex items-center">
                            <c:forEach begin="1" end="5" var="i">
                                <i data-lucide="star" class="w-3 h-3 ${i <= p.averageStar ? 'text-yellow-400' : 'text-[#e5e7eb]'}" 
                                   style="fill: currentColor"></i>
                            </c:forEach>
                        </div>
                        <span class="font-semibold text-gray-900">
                            <fmt:formatNumber value="${p.averageStar}" type="number" maxFractionDigits="1" minFractionDigits="1" />
                        </span>
                        <span class="text-blue-600 text-sm">
                            (${p.totalReviews} reviews)
                        </span>
                    </div>
                    <div class="flex gap-4 items-center">
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i data-lucide="package" class="w-4 h-4"></i>
                            ${p.material}
                        </div>
                        <span class="text-sm text-gray-600">Sold: ${p.sold}</span>
                    </div>
                    <div class="flex gap-3 text-sm items-center mt-2 mb-2">
                        <span class="bg-blue-100 text-blue-600 text-xs font-medium px-2 py-1 rounded-full">
                            ${p.brand.name}
                        </span>
                        <div>
                            <c:if test="${p.quantity > 0}">
                                <span class="bg-green-100 text-green-600 text-xs font-medium px-2 py-1 rounded-full">
                                    In Stock
                                </span>
                            </c:if>
                            <c:if test="${p.quantity == 0}">
                                <span class="bg-red-100 text-red-600 text-xs font-medium px-2 py-1 rounded-full">
                                    Out of Stock
                                </span>
                            </c:if>
                        </div>
                    </div>
                    <span class="text-sm text-[#7f8c8d]">Quantity: ${p.quantity}</span>

                    <div class="text-2xl font-bold text-red-500 mb-4">
                        ${CurrencyFormatter.formatVietNamCurrency(p.price)}đ
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="text-center col-span-full flex flex-col items-center text-gray-500 py-10">
            <i data-lucide="box" class="w-12 h-12 mx-auto mb-2 text-gray-400"></i>
            <p class="text-lg font-semibold">No products found</p>
            <p class="text-sm text-gray-400">Try adjusting your search or filters</p>
        </div>
    </c:otherwise>
</c:choose>