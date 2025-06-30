<%-- 
    Document   : staffSidebar
    Created on : Jun 30, 2025, 10:29:02 AM
    Author     : Tran Thanh Van - CE181019
--%>

<div id="sidebar" class="h-[calc(100vh-74px)] shadow-md flex flex-col justify-between w-[300px] px-5 pt-5 bg-white border-r sidebar-transition transform lg:translate-x-0 -translate-x-full">
    <div class="flex flex-col gap-3">
        <div>
            <h3 class="text-sm font-semibold text-gray-500 uppercase mb-1">General</h3>
            <a id="dashboard" data-page="dashboard" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                <i data-lucide="layout-dashboard" class="w-5 h-5"></i>
                Dashboard
            </a>
        </div>
        <div>
            <h3 class="text-sm font-semibold text-gray-500 uppercase mb-1">User Management</h3>
            <div>
                <a id="customer" data-page="customer" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="users" class="w-5 h-5"></i>
                    Customer
                </a>
                <a id="staff" data-page="profile" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="user-cog" class="w-5 h-5"></i>
                    Profile
                </a>
            </div>
        </div>
        <div>
            <h3 class="text-sm font-semibold text-gray-500 uppercase mb-1">Product Management</h3>
            <div>
                <a id="product" data-page="product" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="package" class="w-5 h-5"></i>
                    Products
                </a>
                <a id="order" data-page="order" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="shopping-cart" class="w-5 h-5"></i>
                    Orders
                </a>
                <a id="category" data-page="category" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="tags" class="w-5 h-5"></i>
                    Categories
                </a>
                <a id="voucher" data-page="voucher" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="ticket" class="w-5 h-5"></i>
                    Vouchers
                </a>
                <a id="brand" data-page="brand" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="layers"></i>
                    Brands
                </a>
            </div>
        </div>
    </div>
    <div class="w-full px-3 flex justify-center mb-3">
        <button class="px-6 w-full flex justify-center py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-lg transition-colors duration-200 flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
            </svg>
            Logout
        </button>
    </div>
</div>
