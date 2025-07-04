<%-- 
    Document   : RelatedProductsFragment
    Created on : Jul 4, 2025, 8:30:48 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
    <c:forEach var="product" items="${Items}">
        <div class="product-card p-4 flex flex-col items-center bg-white/5 border border-white/10 rounded-xl">
            <div class="relative w-full">
                <img src="${not empty product.urls ? product.urls[0] : 'https://placehold.co/250x200?text=No+Image'}"
                     alt="${product.title}" class="w-full h-48 object-cover rounded-lg mb-3 bg-gray-800 border border-gray-700"/>
                <c:if test="${product.quantity == 0}">
                    <span class="absolute top-2 right-2 bg-red-500 text-white px-2 py-1 rounded text-xs">Out of Stock</span>
                </c:if>
            </div>
            <h4 class="text-white font-semibold mb-2 text-center">${product.title}</h4>
            <p class="text-purple-400 font-bold text-xl mb-1">
                <fmt:formatNumber value="${product.price}" type="number" />₫
            </p>
            <c:choose>
                <c:when test="${product.quantity == 0}">
                    <button class="add-to-cart-btn w-full mt-2 opacity-50 cursor-not-allowed" disabled>Out of Stock</button>
                </c:when>
                <c:when test="${cartProductIds ne null && cartProductIds.contains(product.productId)}">
                    <button class="add-to-cart-btn w-full mt-2 opacity-50 cursor-not-allowed" disabled>✓ Added</button>
                </c:when>
                <c:otherwise>
                    <button class="add-to-cart-btn w-full mt-2" onclick="addToCart(${product.productId})">🛒 Add to Cart</button>
                </c:otherwise>
            </c:choose>
        </div>
    </c:forEach>
</div>
<c:if test="${fn:length(Items) == 0}">
    <div class="text-center py-12">
        <div class="text-6xl opacity-30 mb-4">🔍</div>
        <h3 class="text-xl text-gray-400 mb-2">No related products found</h3>
        <p class="text-gray-500">Try browsing our other categories</p>
    </div>
</c:if>

