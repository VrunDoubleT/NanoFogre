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
        <title>Home Page - Nano Forge</title>
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

            .scroll-animation-review {
                animation: scroll 16s linear infinite;
                animation-play-state: running;
            }

            .scroll-animation-review:hover {
                animation-play-state: paused;
            }

            .paused:hover{
                animation-play-state: paused;
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
                    <div id="categories" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 px-4 sm:px-6 lg:px-8 gap-4 sm:gap-6 lg:gap-8 mt-8">
                    </div>
                    <div class="flex justify-center mt-8">
                        <button id="loadCategoriesBtn" class="bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-2 rounded-full shadow-md hover:shadow-lg hover:from-indigo-600 hover:to-purple-700 transition-all duration-300">
                            Load more
                        </button>
                    </div>
                    <div style="display : none" class="text-center text-blue-500" id="categoryFull">All categories have been displayed.</div>
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
                            <c:if test="${not empty newestProducts}">
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
                            </c:if>
                            <c:if test="${empty newestProducts}">
                                <div class="text-red-500 font-bold text-center">No products found</div>
                            </c:if>
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
                            <c:if test="${not empty topRatedProducts}">
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
                            </c:if>
                            <c:if test="${empty topRatedProducts}">
                                <div class="text-red-500 font-bold text-center">No products found</div>
                            </c:if>
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
                            <c:if test="${not empty topSellingProducts}">
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
                            </c:if>
                            <c:if test="${empty topSellingProducts}">
                                <div class="text-red-500 font-bold text-center">No products found</div>
                            </c:if>
                        </div>
                    </section>
                </div>

                <div class="h-auto mt-8">
                    <div class="w-full px-[20%] flex flex-col items-center mb-10">
                        <h2 class="text-center text-4xl font-bold leading-tight">Discover why users love the models from NanoForge</h2>
                        <span class="text-center text-gray-500 text-lg font-medium">What our users have to say about NanoForge's models</span>
                    </div>
                    <div class="relative h-full overflow-hidden rounded-lg"> 
                        <div class="flex h-full space-x-4 scroll-animation-review">
                            <c:forEach var="review" items="${reviews}">
                                <div class="min-w-[250px] cursor-pointer max-w-sm border border-gray-200 rounded-2xl p-4 bg-white flex flex-col space-y-3">
                                    <!-- Avatar + Name -->
                                    <div class="flex items-center space-x-4">
                                        <div class="w-14 h-14 rounded-full overflow-hidden">
                                            <img class="w-full h-full object-cover" src="${review.customer.avatar}" alt="avatar"/>
                                        </div>
                                        <div>
                                            <span class="font-semibold text-gray-800">${review.customer.name}</span><br/>
                                            <div class="flex items-center">
                                                <c:forEach var="i" begin="1" end="${review.star}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-yellow-400 fill-current mr-1" viewBox="0 0 24 24"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.845 1.552 8.318L12 18.896l-7.488 4.573 1.552-8.318L0 9.306l8.332-1.151z"/></svg>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <p class="text-wrap text-gray-700 text-sm">${review.content}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div> 
                </div> 
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
        <script src="../../../js/header.js"></script>
        <script>
            // Initialize Lucide icons
            lucide.createIcons();
            let page = 1;
            let hasMore = true;

            const loadCategories = () => {
                if (!hasMore)
                    return;

                fetch("/home?page=" + page, {
                    headers: {'X-Requested-With': 'XMLHttpRequest'}
                })
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.json();
                        })
                        .then(data => {
                            document.getElementById("categories").insertAdjacentHTML("beforeend", data.html);

                            if (data.isLastPage) {
                                hasMore = false;
                                document.getElementById("categoryFull").style.display = "block";
                                document.getElementById("loadCategoriesBtn").style.display = "none";
                            }

                            page++;
                        })
                        .catch(error => {
                            console.error('Error when loading categories:', error);
                        });
            };

            document.addEventListener("DOMContentLoaded", function () {
                loadCategories();
                reloadCart()
            });

            document.getElementById("loadCategoriesBtn").onclick = () => {
                loadCategories();
            };
        </script>
    </body>
</html>