<%-- 
    Document   : customerSidebar
    Created on : Jul 2, 2025, 8:46:25 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<div class="w-[300px] border border-gray-200 h-[420px] flex justify-center mt-[92px] rounded-xl object-cover">
    <div class="container max-w-[1200px] w-[300px] px-4 sm:px-6 lg:px-6 py-6">
        <!-- Profile Section -->
        <div class="px-8 py-6 relative">
            <c:if test="${not empty sessionScope.customer}">
                <div class="">
                    <div class="flex justify-center pb-3">
                        <img src="${sessionScope.customer.avatar}" alt="Avatar" class="w-20 h-20 border rounded-full border-3 border-gray-300">
                    </div>
                    <div class="text-gray-800 text-center space-y-1">
                        <h3 class="text-lg font-semibold leading-tight">${sessionScope.customer.name}</h3>
                        <p class="text-gray-600 text-xs">My Account</p>
                    </div>
                </div>
            </c:if>
            <div class="absolute bottom-0 left-6 right-6 h-[1px] transition-transform duration-500 origin-center scale-x-100 hover:scale-x-110"></div>
        </div>

        <!-- Navigation Menu -->
        <nav class="flex-1 py-6">
            <div class="space-y-2">
                <!-- Profile Link -->
                <a id="profile" data-page="profile" href="#" class="nav-link group flex items-center gap-3 py-3 px-5 rounded text-gray-700 hover:text-blue-600 hover:bg-blue-50 transition-all duration-200 ease-in-out transform hover:scale-105 relative overflow-hidden before:absolute before:left-0 before:top-0 before:h-full before:w-1 before:bg-gray-600 before:-translate-x-full before:transition-transform before:duration-300">
                    <div class="flex items-center justify-center w-10 h-10 bg-white group-hover:bg-blue-50 rounded">
                        <i data-lucide="user-2" class="w-5 h-5"></i>
                    </div>
                    <div class="flex-1">
                        <span class="font-medium">Profile</span>
                        <p class="text-xs">Manage your account</p>
                    </div>
                </a>

                <!-- Orders Link -->
                <a id="order" data-page="order" href="#" class="nav-link group flex items-center gap-3 py-3 px-5 rounded text-gray-700 hover:text-blue-600 hover:bg-blue-50 transition-all duration-200 ease-in-out transform hover:scale-105 relative overflow-hidden before:absolute before:left-0 before:top-0 before:h-full before:w-1 before:bg-gray-600 before:-translate-x-full before:transition-transform before:duration-300">
                    <div class="flex items-center justify-center w-10 h-10 bg-white group-hover:bg-blue-50 rounded">
                        <i data-lucide="shopping-bag" class="w-5 h-5"></i>
                    </div>
                    <div class="flex-1">
                        <span class="font-medium">Orders</span>
                        <p class="text-xs">View your purchases</p>
                    </div>
                </a>
            </div>
        </nav>
    </div>
</div>



