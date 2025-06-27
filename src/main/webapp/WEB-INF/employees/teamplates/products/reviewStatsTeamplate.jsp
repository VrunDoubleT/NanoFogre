
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
    Document   : ReviewStat
    Created on : Jun 27, 2025, 11:36:44 AM
    Author     : Tran Thanh Van - CE181019
--%>
<div class="relative overflow-hidden bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900 rounded-2xl shadow-2xl mb-8">
    <!-- Decorative Elements -->
    <div class="absolute top-0 right-0 w-72 h-72 bg-gradient-to-br from-blue-400/20 to-purple-600/20 rounded-full -mr-36 -mt-36 blur-3xl"></div>
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-gradient-to-tr from-indigo-400/10 to-cyan-400/10 rounded-full -ml-48 -mb-48 blur-3xl"></div>

    <!-- Content Container -->
    <div class="relative z-10 px-8 py-12 lg:px-12">
        <!-- Header Content -->
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
            <!-- Left Section - Title & Description -->
            <div class="flex-1">
                <div class="flex items-center gap-3 mb-4">
                    <!-- Icon -->
                    <div class="w-12 h-12 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center shadow-lg">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                        </svg>
                    </div>
                    <div class="w-px h-8 bg-gradient-to-b from-transparent via-blue-400/50 to-transparent"></div>
                    <div>
                        <span class="text-sm font-medium text-blue-300 uppercase tracking-wider">Product Management</span>
                    </div>
                </div>

                <h1 class="text-4xl lg:text-5xl font-bold text-white mb-3 leading-tight">
                    Manage Product 
                    <span class="bg-gradient-to-r from-blue-400 to-cyan-400 bg-clip-text text-transparent">Reviews</span>
                </h1>

                <p class="text-lg text-blue-100/80 max-w-2xl leading-relaxed">
                    Monitor, analyze, and respond to customer feedback to improve your products and build stronger relationships with your customers.
                </p>
            </div>

            <!-- Right Section - Quick Stats -->
            <div class="flex gap-4 lg:flex-col lg:gap-3">
                <div class="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20 min-w-[120px]">
                    <div class="text-2xl font-bold text-white">${reviewStats.totalReviews}</div>
                    <div class="text-sm text-blue-200">Total Reviews</div>
                </div>
                <div class="bg-white/10 backdrop-blur-sm rounded-xl p-4 border border-white/20 min-w-[120px]">
                    <div class="flex items-center gap-1">
                        <span class="text-2xl font-bold text-white">
                            <fmt:formatNumber value="${reviewStats.averageStars}" type="number" maxFractionDigits="1" minFractionDigits="1" />
                        </span>

                        <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                        </svg>
                    </div>
                    <div class="text-sm text-blue-200">Avg Rating</div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="bg-white/90 backdrop-blur-sm border border-gray-200/50 rounded-2xl shadow-xl p-6 mb-8">
    <!-- Filter Header -->
    <div class="flex items-center gap-4 mb-6">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center shadow-lg">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.707A1 1 0 013 7V4z"></path>
                </svg>
            </div>
            <div>
                <h3 class="text-lg font-semibold text-gray-800">Filter Reviews</h3>
                <p class="text-sm text-gray-500">Filter by rating to find specific feedback</p>
            </div>
        </div>
    </div>
    <div class="flex flex-wrap gap-3">
        <button id="star-0" onclick="handleClickStarFilter(0)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-gray-50 to-gray-100
                hover:from-blue-50 hover:to-indigo-100 hover:shadow-xl hover:shadow-blue-200/25
                border-2 border-gray-200
                hover:border-blue-300
                text-gray-700
                hover:text-blue-700
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105" 
                data-rating="all">
            <div class="flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"></path>
                </svg>
                <span>All Reviews</span>
                <span class="ml-1 px-2 py-1
                      bg-gray-200
                      group-hover:bg-blue-200
                      group-[&.active]:bg-white/20
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.totalReviews})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-blue-500/0 via-blue-500/5 to-blue-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>
        <button id="star-5" onclick="handleClickStarFilter(5)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-emerald-50 to-green-100
                hover:from-emerald-100 hover:to-green-200 hover:shadow-xl hover:shadow-emerald-200/25
                border-2 border-emerald-200
                hover:border-emerald-400
                text-emerald-700
                hover:text-emerald-800
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105 active:scale-95" 
                data-rating="5">
            <div class="flex items-center gap-2">
                <div class="flex items-center">
                    <svg class="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                    </svg>
                    <span class="ml-1">5</span>
                </div>
                <span class="ml-1 px-2 py-1
                      bg-emerald-200
                      group-hover:bg-emerald-300
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.fiveStar})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-emerald-500/0 via-emerald-500/5 to-emerald-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>
        <!-- 4 Star Button -->
        <button id="star-4" onclick="handleClickStarFilter(4)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-lime-50 to-green-100
                hover:from-lime-100 hover:to-green-200 hover:shadow-xl hover:shadow-lime-200/25
                border-2 border-lime-200
                hover:border-lime-400
                text-lime-700
                hover:text-lime-800
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105 active:scale-95" 
                data-rating="4">
            <div class="flex items-center gap-2">
                <div class="flex items-center">
                    <svg class="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                    </svg>
                    <span class="ml-1">4</span>
                </div>
                <span class="ml-1 px-2 py-1
                      bg-lime-200
                      group-hover:bg-lime-300
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.fourStar})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-lime-500/0 via-lime-500/5 to-lime-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>
        <!-- 3 Star Button -->
        <button id="star-3" onclick="handleClickStarFilter(3)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-yellow-50 to-amber-100
                hover:from-yellow-100 hover:to-amber-200 hover:shadow-xl hover:shadow-yellow-200/25
                border-2 border-yellow-200
                hover:border-yellow-400
                text-yellow-700
                hover:text-yellow-800
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105 active:scale-95" 
                data-rating="3">
            <div class="flex items-center gap-2">
                <div class="flex items-center">
                    <svg class="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                    </svg>
                    <span class="ml-1">3</span>
                </div>
                <span class="ml-1 px-2 py-1
                      bg-yellow-200
                      group-hover:bg-yellow-300
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.threeStar})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-yellow-500/0 via-yellow-500/5 to-yellow-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>
        <!-- 2 Star Button -->
        <button id="star-2" onclick="handleClickStarFilter(2)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-orange-50 to-red-100
                hover:from-orange-100 hover:to-red-200 hover:shadow-xl hover:shadow-orange-200/25
                border-2 border-orange-200
                hover:border-orange-400
                text-orange-700
                hover:text-orange-800
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105 active:scale-95" 
                data-rating="2">
            <div class="flex items-center gap-2">
                <div class="flex items-center">
                    <svg class="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                    </svg>
                    <span class="ml-1">2</span>
                </div>
                <span class="ml-1 px-2 py-1
                      bg-orange-200
                      group-hover:bg-orange-300
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.twoStar})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-orange-500/0 via-orange-500/5 to-orange-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>

        <!-- 1 Star Button -->
        <button id="star-1" onclick="handleClickStarFilter(1)" 
                class="star-filter-btn group relative overflow-hidden
                bg-gradient-to-r from-orange-50 to-red-100
                hover:from-orange-100 hover:to-red-200 hover:shadow-xl hover:shadow-orange-200/25
                border-2 border-orange-200
                hover:border-orange-400
                text-orange-700
                hover:text-orange-800
                px-4 py-3 rounded-xl font-medium transition-all duration-300
                hover:scale-105 active:scale-95" 
                data-rating="1">
            <div class="flex items-center gap-2">
                <div class="flex items-center">
                    <svg class="w-4 h-4 text-yellow-500 fill-current" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.518 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
                    </svg>
                    <span class="ml-1">1</span>
                </div>
                <span class="ml-1 px-2 py-1
                      bg-orange-200
                      group-hover:bg-orange-300
                      text-xs rounded-full font-semibold transition-colors duration-300">(${reviewStats.oneStar})</span>
            </div>
            <div class="absolute inset-0 bg-gradient-to-r from-orange-500/0 via-orange-500/5 to-orange-500/0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </button>
    </div>
</div>
