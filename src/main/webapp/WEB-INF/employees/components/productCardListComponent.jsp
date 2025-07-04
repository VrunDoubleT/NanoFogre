<%-- 
    Document   : productCardListComponent
    Created on : Jul 4, 2025, 6:12:39 PM
    Author     : Modern 15
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Utils.CurrencyFormatter" %>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
    <c:choose>
        <c:when test="${not empty products}">
            <c:forEach var="p" items="${products}">
                <div class="group relative bg-white rounded-3xl p-6 border border-gray-200 overflow-hidden">
                    <!-- Badge -->
                    <div class="absolute top-4 right-4 z-10">
                        <span class="bg-gradient-to-r from-blue-400 to-purple-500 text-white text-xs font-bold px-3 py-1 rounded-full">Product</span>
                    </div>
                    <!-- Image -->
                    <div class="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
                        <c:choose>
                            <c:when test="${not empty p.urls and not empty p.urls[0]}">
                                <a href="/product/${p.slug}">
                                    <img src="${p.urls[0]}" alt="${p.title}" class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500">
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-48 flex items-center justify-center bg-gray-100">
                                    <i class="fa fa-image text-gray-300 text-3xl"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Info -->
                    <div class="space-y-2">
                        <a href="/product/${p.slug}" class="font-bold text-gray-800 text-lg line-clamp-2 hover:text-blue-600 hover:underline">
                            ${p.title}
                        </a>
                        <div class="flex items-center justify-between">
                            <div class="text-lg font-bold text-blue-600">
                                ${CurrencyFormatter.formatVietNamCurrency(p.price)}đ
                            </div>
                            <div class="text-sm text-gray-500">Warehouse: ${p.quantity}</div>
                        </div>
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i class="fa fa-box"></i> ${p.material}
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="col-span-4 text-center text-gray-500 py-8">No products found.</div>
        </c:otherwise>
    </c:choose>
</div>