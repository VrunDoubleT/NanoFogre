<%-- 
    Document   : adminSidebar
    Created on : Jun 6, 2025, 4:29:23 PM
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
                <a id="staff" data-page="staff" href="#" class="nav-link flex items-center gap-3 py-2 px-3 rounded hover:bg-gray-100 text-gray-700 hover:text-blue-600 active:bg-gray-200">
                    <i data-lucide="user-cog" class="w-5 h-5"></i>
                    Staff
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
    <div>BOTTOM</div>
</div>


