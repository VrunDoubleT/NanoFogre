<%-- 
    Document   : searchResultPage
    Created on : Jul 5, 2025, 1:46:39 AM
    Author     : Modern 15
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Results</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .pulse-glow {
                animation: pulse-glow 3s ease-in-out infinite;
            }
            @keyframes pulse-glow {
                0%, 100% {
                    box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
                }
                50% {
                    box-shadow: 0 0 35px rgba(59, 130, 246, 0.6);
                }
            }
        </style>
    </head>
    <body class="bg-gradient-to-br from-blue-50 to-white min-h-screen">
        <jsp:include page="../common/header.jsp" />

        <div class="w-full flex justify-center mt-20">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8">
                <div class="bg-white rounded-3xl shadow-lg border border-gray-100 p-8">
                    <div class="flex items-center gap-3 mb-8">
                        <div class="w-12 h-12 bg-gradient-to-r from-blue-400 to-cyan-500 rounded-full flex items-center justify-center pulse-glow">
                            <i data-lucide="search" class="w-6 h-6 text-white"></i>
                        </div>
                        <div>
                            <h2 class="text-2xl font-bold text-gray-800">
                                Search results for: <span class="text-blue-600">${keyword}</span>
                            </h2>
                            <p class="text-gray-600 font-light">See the products matching your keyword</p>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty products}">
                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                                <c:forEach var="p" items="${products}">
                                    <div class="rounded-xl border bg-white shadow hover:shadow-xl transition-all duration-300 flex flex-col h-full">
                                        <a href="/product/detail?pId=${p.productId}" class="group flex flex-col h-full">
                                            <!-- Hình ảnh -->
                                            <div class="mb-6 rounded-md overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
                                                <c:choose>
                                                    <c:when test="${not empty p.urls and not empty p.urls[0]}">
                                                        <img src="${p.urls[0]}" alt="${p.title}"
                                                             class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500" loading="lazy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="w-full h-48 flex items-center justify-center bg-gray-100">
                                                            <i data-lucide="image" class="w-12 h-12 text-gray-400"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Thông tin (bỏ grow/mt-auto ở đây) -->
                                            <div class="px-5 pb-4 flex flex-col flex-1">
                                                <div class="font-bold text-gray-800 cursor-pointer text-[17px] leading-tight line-clamp-2 hover:text-blue-600 hover:underline transition-colors mb-1">
                                                    ${p.title}
                                                </div>
                                                <div class="mt-1 flex items-center gap-2 mb-1">
                                                    <div class="flex items-center">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i data-lucide="star" class="w-3 h-3 ${i <= p.averageStar ? 'text-yellow-400' : 'text-[#e5e7eb]'}"
                                                               style="fill: currentColor"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="font-semibold text-gray-900">${p.averageStar}</span>
                                                    <span class="text-blue-600 text-sm">
                                                        (${p.totalReviews} reviews)
                                                    </span>
                                                </div>
                                                <div class="flex gap-4 items-center mb-1">
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
                                                <span class="text-sm text-[#7f8c8d] mb-2">Quantity: ${p.quantity}</span>
                                                <!-- GIÁ TIỀN LUÔN Ở ĐÁY VÀ MÀU ĐỎ -->
                                                <div class="text-2xl font-bold text-red-500 mt-auto">
                                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                                </div>
                                            </div>
                                        </a>
                                    </div>

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

                    <div class="flex justify-center pt-8">
                        <a href="/"
                           class="inline-flex items-center gap-2 px-6 py-2 bg-white border border-blue-200 text-blue-700 font-semibold rounded-full shadow hover:bg-blue-600 hover:text-white transition duration-200 text-lg">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                            Back to home
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
