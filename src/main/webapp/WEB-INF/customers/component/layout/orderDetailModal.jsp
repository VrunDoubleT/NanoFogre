<%-- 
    Document   : orderDetailModal
    Created on : Jul 11, 2025, 12:35:11 AM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<!-- HEADER -->
<div class="flex items-center gap-3 mb-6">
  <i data-lucide="receipt" class="w-8 h-8 text-blue-600"></i>
  <h3 class="text-2xl font-bold">
    Order Detail <span class="text-blue-700">#<c:out value="${order.id}"/></span>
  </h3>
</div>

<!-- INFO + BADGE -->
<div class="mb-4 flex flex-wrap items-center gap-4">
  <span class="inline-block bg-gray-100 px-3 py-1 text-xs rounded-xl font-semibold text-gray-500">
    <i data-lucide="calendar" class="w-4 h-4 inline -mt-1 mr-1"></i>
    ${fn:replace(fn:substring(order.createdAt,0,16),'T',' ')}
  </span>
  
  <c:choose>
    <c:when test="${order.orderStatus.name eq 'Cancelled'}">
      <span class="inline-block bg-red-100 text-red-500 font-bold px-3 py-1 text-xs rounded-xl">Cancelled</span>
    </c:when>
    <c:when test="${order.orderStatus.name eq 'Pending'}">
      <span class="inline-block bg-yellow-100 text-yellow-600 font-bold px-3 py-1 text-xs rounded-xl">Pending</span>
    </c:when>
    <c:when test="${order.orderStatus.name eq 'Processing'}">
      <span class="inline-block bg-blue-100 text-blue-700 font-bold px-3 py-1 text-xs rounded-xl">Processing</span>
    </c:when>
    <c:when test="${order.orderStatus.name eq 'Shipped'}">
      <span class="inline-block bg-purple-100 text-purple-700 font-bold px-3 py-1 text-xs rounded-xl">Shipped</span>
    </c:when>
    <c:when test="${order.orderStatus.name eq 'Delivered'}">
      <span class="inline-block bg-green-100 text-green-600 font-bold px-3 py-1 text-xs rounded-xl">Delivered</span>
    </c:when>
    <c:otherwise>
      <span class="inline-block bg-gray-200 text-gray-500 px-3 py-1 text-xs rounded-xl">
        <c:out value="${order.orderStatus.name}"/>
      </span>
    </c:otherwise>
  </c:choose>
</div>

<!-- INFO GRID -->
<div class="mb-6 grid grid-cols-1 md:grid-cols-2 gap-3 text-gray-700">
  <div>
    <div class="text-xs text-gray-400 mb-1">Total Amount</div>
    <div class="font-bold text-2xl text-blue-700">
      <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/>₫
    </div>
  </div>
  <div>
    <div class="text-xs text-gray-400 mb-1">Payment Method</div>
    <span class="inline-block bg-green-50 text-green-700 px-2 py-0.5 rounded font-semibold text-sm">
      <c:out value="${order.paymentMethod.name}"/>
    </span>
    <span class="ml-2 bg-blue-100 text-blue-600 px-2 py-0.5 rounded text-xs font-semibold">
      <c:out value="${order.paymentStatus.name}"/>
    </span>
  </div>
  <div class="md:col-span-2">
    <div class="text-xs text-gray-400 mb-1">Ship to</div>
    <span class="font-semibold"><c:out value="${order.address.recipientName}"/></span>,
    <c:out value="${order.address.details}"/> | <c:out value="${order.address.phone}"/>
  </div>
</div>

<!-- PRODUCTS LIST -->
<div>
  <div class="font-semibold text-gray-700 mb-2">Products</div>
  <c:if test="${not empty order.details}">
    <div class="space-y-3">
      <c:forEach var="item" items="${order.details}">
        <div class="flex items-center gap-4 bg-white border rounded-xl shadow-sm p-3 transition hover:shadow-md">
          <c:if test="${not empty item.product.urls}">
            <img src="<c:out value='${item.product.urls[0]}'/>"
                 class="w-16 h-16 rounded object-cover border"
                 alt="${item.product.title}"/>
          </c:if>
          <div class="flex-1 min-w-0">
            <div class="font-semibold truncate"><c:out value="${item.product.title}"/></div>
            <div class="text-sm text-gray-500">x<c:out value="${item.quantity}"/></div>
          </div>
          <div class="font-bold text-blue-700 text-base shrink-0">
            <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/>₫
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>
  <c:if test="${empty order.details}">
    <div class="text-gray-400 italic text-center py-6">
      No product details found for this order.
    </div>
  </c:if>
</div>
