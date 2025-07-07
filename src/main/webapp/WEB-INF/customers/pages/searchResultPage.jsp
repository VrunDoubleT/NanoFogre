<%-- 
    Document   : searchResultPage
    Created on : Jul 5, 2025, 1:46:39 AM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Search Results</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="container mx-auto px-4 my-6">
        <h2 class="text-xl font-bold mb-4">
            Search results for: <span class="text-blue-600">${keyword}</span>
        </h2>
        
        <c:choose>
            <c:when test="${not empty products}">
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-6">
                    <c:forEach var="p" items="${products}">
                        <div class="bg-white rounded-xl shadow p-3 hover:shadow-lg transition">
                            <a href="/product/${p.slug}" class="block group">
                                <img src="${p.urls[0]}" class="w-full h-48 object-cover rounded-lg mb-2 border group-hover:scale-105 transition" alt="${p.title}" />
                                <div class="font-semibold text-lg line-clamp-2 mb-1 group-hover:text-blue-700">${p.title}</div>
                            </a>
                            <div class="text-pink-600 font-bold text-base">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>₫
                            </div>
                            <a href="/product/${p.slug}"
                               class="inline-flex items-center gap-2 mt-2 px-4 py-2 bg-blue-50 text-blue-600 font-medium rounded-full shadow-sm hover:bg-blue-600 hover:text-white transition duration-200 focus:ring-2 focus:ring-blue-300 focus:outline-none"
                            >
                                <i class="fa fa-search"></i>
                                View details
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-gray-500 py-8 text-lg font-semibold">
                    No products found.
                </div>
            </c:otherwise>
        </c:choose>

        <div class="mt-6">
            <a href="/"
               class="inline-flex items-center gap-1 px-4 py-2 bg-gray-50 text-blue-700 font-medium rounded-full shadow-sm hover:bg-blue-700 hover:text-white transition duration-200 ease-in-out focus:ring-2 focus:ring-blue-300 focus:outline-none"
            >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                </svg>
                Back to home
            </a>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>
</body>
</html>
