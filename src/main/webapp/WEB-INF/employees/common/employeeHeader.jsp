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
                <div
                        class="flex items-center space-x-3 focus:outline-none group">
                    <img src="${sessionScope.employee.avatar}" alt="Avatar"
                         class="w-10 h-10 rounded-full border-2 border-gray-300 group-hover:border-blue-400 transition">
                        <div class="hidden md:block text-left">
                            <p class="text-sm font-medium text-gray-900"><%= emp.getName()%></p>
                            <p class="text-xs text-gray-500">${sessionScope.employee.role.name}</p>
                        </div>
                </div>
            </div>
        </c:if>
    </div>
</header>

