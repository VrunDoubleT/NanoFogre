<%-- 
    Document   : categories
    Created on : Jul 18, 2025, 8:55:41 AM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        <span class="text-white font-bold text-sm sm:text-base drop-shadow-lg">View now</span>
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