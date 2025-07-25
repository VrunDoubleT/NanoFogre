<%-- 
    Document   : header
    Created on : Jul 1, 2025, 5:13:10 PM
    Author     : Tran Thanh Van - CE181019
--%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Header -->
<header class="w-full z-50 py-4 px-6 lg:px-12 bg-slate-900/90 backdrop-blur-sm fixed top-0 shadow-md">
    <div class="max-w-6xl mx-auto flex items-center justify-between">
        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/" class="text-white h-full text-2xl font-bold tracking-wide flex items-center space-x-2">
            <div class="h-[48px]">
                <img class="h-full object-cover" src="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png" alt="alt"/>
            </div>
        </a>

        <!-- Search Bar -->
        <div class="flex-1 px-6 hidden md:block">
            <div class="relative max-w-xl mx-auto">
                <form action="/search-products" method="get" autocomplete="off" class="relative">
                    <input
                        type="text"
                        name="keyword"
                        placeholder="Search models..."
                        class="w-full px-4 py-2 rounded-full bg-slate-800 text-white placeholder-blue-200 border border-slate-600 focus:outline-none focus:ring-2 focus:ring-yellow-400"
                        value="${param.keyword != null ? param.keyword : ''}"
                        autocomplete="off"
                        />
                    <button class="absolute top-1/2 right-3 -translate-y-1/2 text-yellow-400 hover:text-yellow-300">
                        <i data-lucide="search" class="w-5 h-5 p-[1px]"></i>
                    </button>
                </form>
            </div>
        </div>

        <!-- Login / Register / User Menu -->
        <div class="flex items-center space-x-4">
            <c:choose>
                <c:when test="${not empty sessionScope.customer}">
                    <!-- Cart Icon -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative group mr-4">
                        <svg class="w-7 h-7 text-yellow-400 group-hover:scale-110 transition" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.35 2.7A2 2 0 0 0 7.5 19h9a2 2 0 0 0 1.85-2.7L17 13M9 19a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm8 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
                        </svg>
                        <span id="cartTotal" class="cart-badge absolute top-0 right-0 translate-x-1/2 -translate-y-1/2
                              bg-red-600 text-white text-[0.625rem] leading-none
                              w-4 h-4 rounded-full flex items-center justify-center">
                            <c:out value="${sessionScope.cartQuantity}" default="0"/>
                        </span>
                    </a>
                    <a href="/account" class="text-white font-semibold flex items-center gap-2">
                        <i class="fa fa-user-circle text-yellow-400"></i>
                        ${sessionScope.customer.name}
                    </a>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="px-4 py-2 bg-gradient-to-r from-red-500 to-orange-500 text-white rounded-full text-sm font-semibold shadow hover:scale-105 transition">
                        Logout
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth?action=login" class="text-sm text-blue-100 hover:text-white transition font-medium">Login</a>
                    <a href="${pageContext.request.contextPath}/auth?action=register" class="px-4 py-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white rounded-full text-sm font-semibold shadow hover:scale-105 transition">
                        Register
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<script src="/js/search.js"></script>