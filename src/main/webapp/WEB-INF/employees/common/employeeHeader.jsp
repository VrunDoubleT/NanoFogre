<%-- 
    Document   : employeeHeader
    Created on : Jun 30, 2025, 10:26:38 AM
    Author     : Tran Thanh Van - CE181019
--%>

<header class="h-[74px] bg-white shadow-sm border-b">
    <div class="h-full flex items-center justify-between px-6 py-4">
        <!-- Logo -->
        <div class="h-full">
            <img class="h-full object-cover" src="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png" alt="alt"/>
        </div>

        <% Models.Employee emp = (Models.Employee) session.getAttribute("employee");%>
        <c:if test="${not empty sessionScope.employee}">
            <div class="relative">
                <!-- Avatar + Info (clickable) -->
                <button id="profileMenuBtn" type="button"
                        class="flex items-center space-x-3 focus:outline-none group">
                    <img src="${sessionScope.employee.avatar}" alt="Avatar"
                         class="w-10 h-10 rounded-full border-2 border-gray-300 group-hover:border-blue-400 transition">
                        <div class="hidden md:block text-left">
                            <p class="text-sm font-medium text-gray-900"><%= emp.getName()%></p>
                            <p class="text-xs text-gray-500">${sessionScope.employee.role.name}</p>
                        </div>
                </button>
                <!-- Dropdown Menu -->
                <div id="profileDropdown"
                     class="hidden absolute right-0 mt-2 w-44 bg-white rounded-xl shadow-lg border divide-y divide-gray-100 overflow-hidden transition-all duration-200">
                    <a href="${pageContext.request.contextPath}/logout"
                       class="flex items-center gap-2 px-4 py-3 text-red-600 hover:bg-red-50 transition-colors duration-150">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="w-5 h-5 flex-shrink-0"
                             fill="none"
                             stroke="currentColor"
                             viewBox="0 0 24 24">
                            <path stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                        </svg>
                        <span class="flex-1 text-sm font-medium">Sign Out</span>
                    </a>
                </div>

            </div>
        </c:if>
    </div>
</header>

<script>
    const btn = document.getElementById('profileMenuBtn');
    const dropdown = document.getElementById('profileDropdown');
    btn?.addEventListener('click', function (e) {
    e.stopPropagation();
    dropdown.classList.toggle('hidden');
    });
    // ?n dropdown khi click ra ngoài
    document.addEventListener('click', function (e) {
    if (!dropdown.classList.contains('hidden')) {
    dropdown.classList.add('hidden');
    }
    });
    // Ng?n dropdown ?n khi click bên trong nó
    dropdown?.addEventListener('click', function (e) {
    e.stopPropagation();
    });
</script>
