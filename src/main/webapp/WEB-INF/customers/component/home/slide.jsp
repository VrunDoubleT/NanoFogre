<%-- 
    Document   : slide
    Created on : Jul 1, 2025, 8:18:40 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="h-screen pt-[96px] flex items-center justify-center p-4 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
    <!-- Main Container -->
    <div class="w-full flex flex-col gap-2 h-full max-w-6xl mx-auto">
        <!-- Card -->
        <div class="rounded-3xl flex-1 h-full overflow-hidden shadow-2xl hover:shadow-3xl transition-all duration-500 hover:-translate-y-1 bg-gradient-to-br from-slate-800 to-slate-900 relative">
            <!-- Content -->
            <div class="relative h-full z-10 px-8 py-6">
                <div class="grid h-full lg:grid-cols-2 gap-12 items-center">
                    <!-- Text Section -->
                    <div class="h-full flex flex-col justify-center">
                        <!-- Badge -->
                        <div class="inline-flex w-fit items-center px-4 py-2 bg-gradient-to-r from-blue-500/80 to-indigo-600/80 backdrop-blur-sm text-white text-sm font-semibold rounded-full shadow-lg">
                            <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                            </svg>
                            Premium Quality Models
                        </div>

                        <!-- Title & Description -->
                        <div>
                            <h1 class="text-5xl lg:text-6xl font-bold text-white mb-4 leading-tight">
                                Model
                                <span class="bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent">
                                    Universe
                                </span>
                            </h1>
                            <p class="text-blue-100 text-xl leading-relaxed hidden md:block">
                                Discover extraordinary collectible models from world-renowned brands. 
                                Premium quality, competitive pricing, exceptional service.
                            </p>
                        </div>

                        <!-- Features -->
                        <div class="grid grid-cols-2 mt-3 gap-4">
                            <div class="flex items-center text-blue-100">
                                <div class="w-8 h-8 bg-gradient-to-r from-green-400 to-emerald-500 rounded-full flex items-center justify-center mr-3 shadow-lg">
                                    <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <span class="font-medium">Authentic Models</span>
                            </div>

                            <div class="flex items-center text-blue-100">
                                <div class="w-8 h-8 bg-gradient-to-r from-blue-400 to-indigo-500 rounded-full flex items-center justify-center mr-3 shadow-lg">
                                    <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" />
                                    </svg>
                                </div>
                                <span class="font-medium">Fast Shipping</span>
                            </div>

                            <div class="flex items-center text-blue-100">
                                <div class="w-8 h-8 bg-gradient-to-r from-purple-400 to-pink-500 rounded-full flex items-center justify-center mr-3 shadow-lg">
                                    <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <span class="font-medium">2-Year Warranty</span>
                            </div>

                            <div class="flex items-center text-blue-100">
                                <div class="w-8 h-8 bg-gradient-to-r from-orange-400 to-red-500 rounded-full flex items-center justify-center mr-3 shadow-lg">
                                    <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-2 0c0 .993-.241 1.929-.668 2.754l-1.524-1.525a3.997 3.997 0 00.078-2.183l1.562-1.562C15.802 8.249 16 9.1 16 10zm-5.165 3.913l1.58 1.58A5.98 5.98 0 0110 16a5.976 5.976 0 01-2.516-.552l1.562-1.562a4.006 4.006 0 001.789.027zm-4.677-2.796a4.002 4.002 0 01-.041-2.08l-1.564-1.564A5.986 5.986 0 004 10c0 .954.223 1.856.619 2.657l1.539-1.54zm4.258-5.81A4.007 4.007 0 0110 5.226c.693 0 1.337.172 1.907.477l1.42-1.42A5.969 5.969 0 0010 4a6.006 6.006 0 00-2.328.465l1.744 1.744z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                                <span class="font-medium">24/7 Support</span>
                            </div>
                        </div>
                    </div>

                    <!-- Image Section -->
                    <div class="h-full flex flex-col gap-3 overflow-hidden">
                        <div class="flex-1 lg:flex min-h-0 hidden items-center justify-center px-4 overflow-hidden">
                            <img src="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1751379206/36728ac821178e9037f8fa4486c45247-removebg-preview_fetifv.png"
                                 alt="Model Image"
                                 class="w-full h-full object-contain" />
                        </div>
                        <div class="h-[96px] bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/10 w-full">
                            <div class="grid grid-cols-3 gap-4 text-center h-full items-center">
                                <div>
                                    <div class="text-2xl font-bold text-white">1000+</div>
                                    <div class="text-sm text-blue-200">Models</div>
                                </div>
                                <div>
                                    <div class="text-2xl font-bold text-white">50K+</div>
                                    <div class="text-sm text-blue-200">Customers</div>
                                </div>
                                <div>
                                    <div class="text-2xl font-bold text-white">4.9</div>
                                    <div class="text-sm text-blue-200">Rating</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- End Visual -->
                </div>
            </div>
        </div>
        <div class="h-12">
            <!-- Brand Carousel Container -->
            <div class="relative h-full overflow-hidden rounded-lg">
                <!-- Gradient overlays for smooth fade effect -->
                <div class="absolute left-0 top-0 w-32 h-full bg-gradient-to-r from-white/5 to-transparent z-10"></div>
                <div class="absolute right-0 top-0 w-32 h-full bg-gradient-to-l from-white/5 to-transparent z-10"></div>
                <div class="flex h-full space-x-12 scroll-animation">
                    <div class="flex space-x-12 shrink-0">
                        <c:forEach var="brand" items="${brands}">
                            <div class="brand-item flex items-center justify-center h-full rounded-xl">
                                <span class="text-2xl font-bold text-blue-600 whitespace-nowrap">${brand.name}</span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="flex space-x-12 shrink-0">
                        <c:forEach var="brand" items="${brands}">
                            <div class="brand-item flex items-center justify-center h-full rounded-xl">
                                <span class="text-2xl font-bold text-blue-600 whitespace-nowrap">${brand.name}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div> 
            </div> 
        </div>
    </div>
</div>