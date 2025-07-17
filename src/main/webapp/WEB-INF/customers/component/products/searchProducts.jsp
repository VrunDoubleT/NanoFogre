<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:choose>
    <c:when test="${not empty products}">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <c:forEach var="p" items="${products}">
                <a href="/product/detail?pId=${p.productId}" class="group relative bg-white rounded-3xl p-6 border border-gray-200 overflow-hidden shadow hover:shadow-xl transition-all duration-300 block focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-3xl h-full">
                    <!-- Image -->
                    <div class="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
                        <c:choose>
                            <c:when test="${not empty p.urls and not empty p.urls[0]}">
                                <img src="${p.urls[0]}" alt="${p.title}" 
                                     class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500" loading="lazy"/>
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-48 flex items-center justify-center bg-gray-100">
                                    <i data-lucide="image" class="w-12 h-12 text-gray-300"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-all duration-300"></div>
                    </div>
                    <!-- Info -->
                    <div class="space-y-2">
                        <div class="font-bold text-gray-800 text-lg leading-tight line-clamp-2 group-hover:text-blue-600 group-hover:underline transition-colors">
                            ${p.title}
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
                            </div>
                            <div class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                                Stock: ${p.quantity}
                            </div>
                        </div>
                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <i data-lucide="package" class="w-4 h-4"></i>
                            <c:choose>
                                <c:when test="${p.category != null}">
                                    ${p.category.name}
                                </c:when>
                                <c:otherwise>
                                    Unknown
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="flex flex-col items-center py-16">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-28 h-28 mb-6 opacity-60" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <circle cx="11" cy="11" r="7" stroke-width="2" stroke="gray"/>
            <path stroke="gray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="M21 21l-4.35-4.35"/>
            </svg>
            <div class="text-2xl text-gray-500 font-bold mb-2">No products found</div>
            <div class="text-base text-gray-400 mb-4">Try searching with a different keyword!</div>
        </div>
    </c:otherwise>
</c:choose>
