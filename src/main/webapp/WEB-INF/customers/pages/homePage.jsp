<%-- 
    Document   : homePage
    Created on : Jul 1, 2025, 5:22:11 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="Utils.CurrencyFormatter"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .section-divider {
                background: linear-gradient(90deg, transparent, rgba(139, 92, 246, 0.3), transparent);
                height: 1px;
                margin: 2rem 0;
            }
            @keyframes float {
                0%, 100% {
                    transform: translateY(0px) rotate(0deg);
                }
                50% {
                    transform: translateY(-12px) rotate(5deg);
                }
            }

            @keyframes pulse-glow {
                0%, 100% {
                    box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
                }
                50% {
                    box-shadow: 0 0 35px rgba(59, 130, 246, 0.6);
                }
            }

            @keyframes gradient-shift {
                0% {
                    background-position: 0% 50%;
                }
                50% {
                    background-position: 100% 50%;
                }
                100% {
                    background-position: 0% 50%;
                }
            }

            .float-animation {
                animation: float 4s ease-in-out infinite;
            }

            .pulse-glow {
                animation: pulse-glow 3s ease-in-out infinite;
            }

            .gradient-bg {
                background: linear-gradient(-45deg, #1e3a8a, #3b82f6, #6366f1, #8b5cf6);
                background-size: 400% 400%;
                animation: gradient-shift 15s ease infinite;
            }

            .seamless-blend {
                background: linear-gradient(135deg,
                    rgba(255, 255, 255, 0.1) 0%,
                    rgba(255, 255, 255, 0.05) 50%,
                    rgba(255, 255, 255, 0.1) 100%);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .content-overlay {
                background: linear-gradient(135deg,
                    rgba(30, 58, 138, 0.95) 0%,
                    rgba(59, 130, 246, 0.85) 50%,
                    rgba(139, 92, 246, 0.95) 100%);
            }


            @keyframes scroll {
                0% {
                    transform: translateX(0);
                }
                100% {
                    transform: translateX(-100%);
                }
            }

            .scroll-animation {
                animation: scroll 20s linear infinite;
            }

            .brand-item {
                transition: all 0.3s ease;
            }

            .brand-item:hover {
                transform: scale(1.1);
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />
        <jsp:include page="../component/home/slide.jsp" />

        <div class="w-full flex justify-center mt-6">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8">
                <div class="mb-16">
                    <div class="text-center mb-10">
                        <h2 class="text-5xl leading-normal font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent mb-2">
                            Category List
                        </h2>
                        <p class="text-base text-gray-500">
                            Discover high-quality models across all collections
                        </p>
                    </div>
                    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 px-4 sm:px-6 lg:px-8 gap-4 sm:gap-6 lg:gap-8 mt-8">
                        <c:forEach var="category" items="${categories}">
                            <div class="w-full flex justify-center items-center flex-col group transform transition-all duration-300 hover:scale-105">
                                <div class="relative rounded-full border-2 border-gray-200 w-28 h-28 sm:w-32 sm:h-32 lg:w-36 lg:h-36 overflow-hidden cursor-pointer shadow-lg hover:shadow-xl transition-all duration-300 group-hover:border-blue-400">
                                    <a href="/products/category?categoryId=${category.id}" class="block w-full h-full">
                                        <img class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110 group-hover:rotate-2" 
                                             src="${category.avatar}" 
                                             alt="${category.name}"
                                             loading="lazy" />
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-all duration-300 flex items-center justify-center">
                                            <div class="text-center transform translate-y-2 group-hover:translate-y-0 transition-transform duration-300">
                                                <span class="text-white font-bold text-sm sm:text-base drop-shadow-lg">Xem ngay</span>
                                                <div class="w-8 h-0.5 bg-white mx-auto mt-1 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-300"></div>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                <span class="text-sm sm:text-base font-semibold text-gray-800 mt-3 text-center leading-tight px-2 group-hover:text-blue-600 transition-colors duration-300">
                                    ${category.name}
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="section-divider"></div>
                <div class="space-y-16 mt-16">
                    <!-- Newest Products -->
                    <section>
                        <div class="flex items-center gap-2 mb-8">
                            <div class="w-12 h-12 bg-gradient-to-r from-purple-400 to-pink-500 rounded-full flex items-center justify-center pulse-glow">
                                <i data-lucide="sparkles" class="w-6 h-6 text-white"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    New Arrivals
                                </h2>
                                <p class="text-gray-600 font-light">Fresh additions to our collection</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="p" items="${newestProducts}">
                                <div class="group relative bg-white rounded-3xl p-6 border border-gray-200 overflow-hidden">
                                    <!-- Product Badge -->
                                    <div class="absolute top-4 right-4 z-10">
                                        <span class="bg-gradient-to-r from-purple-400 to-pink-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                                            ✨ NEW
                                        </span>
                                    </div>

                                    <!-- Image Container -->
                                    <div class="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
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
                                        <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-all duration-300"></div>
                                    </div>

                                    <!-- Product Info -->
                                    <div class="space-y-3">
                                        <a href="/product/detail?pId=${p.productId}" class="font-bold text-gray-800 text-lg leading-tight line-clamp-2 hover:text-purple-600 hover:underline transition-colors">
                                            ${p.title}
                                        </a>

                                        <div class="flex items-center justify-between">
                                            <div class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                                                ${CurrencyFormatter.formatVietNamCurrency(p.price)}đ
                                            </div>
                                            <div class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                                                Stock: ${p.quantity}
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="package" class="w-4 h-4"></i>
                                            ${p.material}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <div class="section-divider"></div>

                    <!-- Top Rated Products -->
                    <section>
                        <div class="flex items-center gap-2 mb-8">
                            <div class="w-12 h-12 bg-gradient-to-r from-yellow-400 to-orange-500 rounded-full flex items-center justify-center pulse-glow">
                                <i data-lucide="star" class="w-6 h-6 text-white"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    Top Rated Products
                                </h2>
                                <p class="text-gray-600 font-light">Highest rated by our community</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="p" items="${topRatedProducts}">
                                <div class="group relative bg-white rounded-3xl p-6 card-hover border border-gray-100 overflow-hidden">
                                    <!-- Product Badge -->
                                    <div class="absolute top-4 right-4 z-10">
                                        <span class="bg-gradient-to-r from-yellow-400 to-orange-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                                            ⭐ TOP
                                        </span>
                                    </div>

                                    <!-- Image Container -->
                                    <div class="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
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
                                        <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-all duration-300"></div>
                                    </div>

                                    <!-- Product Info -->
                                    <div class="space-y-3">
                                        <a href="/product/detail?pId=${p.productId}" class="font-bold text-gray-800 text-lg leading-tight line-clamp-2 hover:underline hover:text-blue-600 transition-colors">
                                            ${p.title}
                                        </a>

                                        <div class="flex items-center justify-between">
                                            <div class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                                                ${CurrencyFormatter.formatVietNamCurrency(p.price)}đ
                                            </div>
                                            <div class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                                                Stock: ${p.quantity}
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="package" class="w-4 h-4"></i>
                                            ${p.material}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <div class="section-divider"></div>

                    <!-- Top Selling Products -->
                    <section>
                        <div class="flex items-center gap-2 mb-8">
                            <div class="w-12 h-12 bg-gradient-to-r from-green-400 to-emerald-500 rounded-full flex items-center justify-center pulse-glow">
                                <i data-lucide="trending-up" class="w-6 h-6 text-white"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    Best Sellers
                                </h2>
                                <p class="text-gray-600 font-light">Most popular among collectors</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="p" items="${topSellingProducts}">
                                <div class="group relative bg-white rounded-3xl p-6 card-hover border border-gray-100 overflow-hidden">
                                    <!-- Product Badge -->
                                    <div class="absolute top-4 right-4 z-10">
                                        <span class="bg-gradient-to-r from-green-400 to-emerald-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                                            🔥 HOT
                                        </span>
                                    </div>

                                    <!-- Image Container -->
                                    <div class="relative mb-6 rounded-2xl overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
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
                                        <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-all duration-300"></div>
                                    </div>

                                    <!-- Product Info -->
                                    <div class="space-y-3">
                                        <a href="/product/detail?pId=${p.productId}" class="font-bold text-gray-800 text-lg leading-tight line-clamp-2 hover:underline hover:text-green-600 transition-colors">
                                            ${p.title}
                                        </a>

                                        <div class="flex items-center justify-between">
                                            <div class="text-2xl font-bold bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                                                <fmt:formatNumber value="${p.price / 100}" type="currency" currencySymbol="$"/>
                                            </div>
                                            <div class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                                                Stock: ${p.quantity}
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="package" class="w-4 h-4"></i>
                                            ${p.material}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
        <script>
            // Initialize Lucide icons
            lucide.createIcons();
        </script>
    </body>
</html>