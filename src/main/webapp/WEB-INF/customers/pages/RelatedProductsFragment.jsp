<%-- 
    Document   : RelatedProductsFragment
    Created on : Jul 4, 2025, 8:30:48 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 px-4 py-6">
  <c:forEach var="product" items="${Items}">
    <div class="product-card p-4 flex flex-col items-center bg-white/5 border border-white/10 rounded-xl">
      <div class="relative w-full h-56">
        <img
          src="${not empty product.urls ? product.urls[0] : 'https://placehold.co/250x200?text=No+Image'}"
          alt="${product.title}"
          class="w-full h-full object-cover"
        />
        <c:if test="${product.quantity == 0}">
          <span class="absolute top-3 right-3 bg-red-600 text-white text-xs font-semibold uppercase px-2 py-1 rounded-full">
            Out of Stock
          </span>
        </c:if>
      </div>
      <div class="p-4 flex flex-col justify-between h-48">
        <h4 class="text-white text-lg font-semibold mb-2 line-clamp-2">${product.title}</h4>
        <div class="flex items-center justify-between">
          <p class="text-purple-400 font-extrabold text-2xl">
            <fmt:formatNumber value="${product.price}" type="number" />₫
          </p>
          <!-- Ví dụ thêm đánh giá sao (nếu có) -->
          <div class="flex items-center space-x-1">
            <svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.946a1 1 0 00.95.69h4.157c.969 0 1.371 1.24.588 1.81l-3.37 2.449a1 1 0 00-.364 1.118l1.287 3.946c.3.921-.755 1.688-1.54 1.118L10 13.347l-3.37 2.449c-.784.57-1.838-.197-1.539-1.118l1.286-3.946a1 1 0 00-.364-1.118L2.643 9.373c-.783-.57-.38-1.81.588-1.81h4.157a1 1 0 00.95-.69l1.286-3.946z"/>
            </svg>
            <span class="text-gray-300 text-sm">4.5</span>
          </div>
        </div>
        <div class="mt-4">
          <c:choose>
            <c:when test="${product.quantity == 0}">
              <button disabled class="w-full py-2 rounded-lg bg-gray-600 text-gray-400 font-medium cursor-not-allowed">
                Out of Stock
              </button>
            </c:when>
            <c:when test="${cartProductIds ne null && cartProductIds.contains(product.productId)}">
              <button disabled class="w-full py-2 rounded-lg bg-green-600 text-white font-medium cursor-not-allowed">
                ✓ Added
              </button>
            </c:when>
            <c:otherwise>
              <button
                onclick="addToCart(${product.productId})"
                class="w-full py-2 rounded-lg bg-indigo-600 text-white font-medium hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-400 transition"
              >
                🛒 Add to Cart
              </button>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<c:if test="${fn:length(Items) == 0}">
  <div class="text-center py-16">
    <div class="text-6xl text-gray-600 mb-4 animate-pulse">🔍</div>
    <h3 class="text-2xl text-gray-400 mb-2">No related products found</h3>
    <p class="text-gray-500">Try browsing our other categories</p>
  </div>
</c:if>
