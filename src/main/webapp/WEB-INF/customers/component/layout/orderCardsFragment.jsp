<%-- 
    Document   : orderCardsFragment
    Created on : Jul 21, 2025, 11:29:10 PM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<%@page import="Utils.CurrencyFormatter"%>
<c:forEach var="order" items="${orders}">
    <div class="order-card transition-none opacity-100 scale-100 p-6 rounded-2xl border relative group"
         data-status="${order.orderStatus.id}" data-id="${order.id}">
        <div class="flex flex-wrap items-center justify-between gap-2 mb-4">
            <div>
                <span class="font-semibold text-gray-700 mr-4">
                    Order: <span class="text-blue-700">#${order.id}</span>
                </span>
                <span class="text-sm text-gray-400">
                    ${fn:replace(fn:substring(order.createdAt,0,16),'T',' ')}
                </span>
                <span class="ml-4 inline-block px-3 py-1 text-xs font-semibold rounded-xl tracking-wider shadow-sm
                      <c:choose>
                          <c:when test="${order.orderStatus.id == 1}">text-yellow-700 bg-yellow-100</c:when>
                          <c:when test="${order.orderStatus.id == 2}">text-blue-700 bg-blue-100</c:when>
                          <c:when test="${order.orderStatus.id == 3}">text-sky-700 bg-sky-100</c:when>
                          <c:when test="${order.orderStatus.id == 4}">text-green-700 bg-green-100</c:when>
                      </c:choose>
                      ">
                    ${order.orderStatus.name}
                </span>
            </div>
            <div class="flex flex-wrap items-center gap-3">
                <span class="text-lg font-bold text-blue-700 tracking-tight">
                    ${CurrencyFormatter.formatVietNamCurrency(order.totalAmount)}đ
                </span>
                <button type="button"
                        class="show-order-details-btn flex items-center gap-1 px-3 py-1.5 text-sm rounded-lg font-semibold bg-blue-100 text-blue-700 hover:bg-blue-600 hover:text-white transition shadow focus:ring-2 focus:ring-blue-300"
                        data-id="${order.id}">
                    <i data-lucide="eye" class="transition-transform group-hover:scale-110"></i>
                    Details
                </button>
            </div>
        </div>
        <!-- Products in order -->
        <c:if test="${not empty order.details}">
            <div class="flex flex-col gap-3 mb-4">
                <c:forEach var="item" items="${order.details}">
                    <div class="flex flex-wrap items-center gap-4 p-3 bg-white border border-gray-200 rounded-xl shadow-sm relative">
                        <c:if test="${not empty item.product.urls}">
                            <img src="${item.product.urls[0]}" alt="${item.product.title}" class="w-16 h-16 rounded-lg object-cover border" />
                        </c:if>
                        <div class="min-w-0 flex-1">
                            <div class="font-semibold truncate">${item.product.title}</div>
                            <div class="text-xs text-gray-500">x${item.quantity}</div>
                        </div>
                        <div class="font-bold text-blue-600 text-base ml-auto whitespace-nowrap">
                            ${CurrencyFormatter.formatVietNamCurrency(item.price)}đ
                        </div>
                        <c:if test="${order.orderStatus.id == 4}">
                            <c:choose>
                                <c:when test="${item.reviewed}">
                                    <button type="button"
                                            class="review-product-btn flex items-center gap-1 px-3 py-1 text-xs rounded bg-yellow-200 text-yellow-600 hover:bg-yellow-400 hover:text-white transition ml-2"
                                            data-order-id="${order.id}"
                                            data-product-id="${item.product.productId}"
                                            data-product-title="${item.product.title}"
                                            data-product-img="${item.product.urls[0]}"
                                            data-review-content="${fn:escapeXml(item.reviewContent)}"
                                            data-review-star="${item.reviewStar}">
                                        <i data-lucide="star"></i>
                                        Edit Review
                                    </button>

                                </c:when>
                                <c:otherwise>
                                    <button type="button"
                                            class="review-product-btn flex items-center gap-1 px-3 py-1 text-xs rounded bg-yellow-100 text-yellow-700 hover:bg-yellow-600 hover:text-white transition ml-2"
                                            data-order-id="${order.id}"
                                            data-product-id="${item.product.productId}"
                                            data-product-title="${item.product.title}"
                                            data-product-img="${item.product.urls[0]}">
                                        <i data-lucide="star"></i>
                                        Evaluate
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <div class="text-sm text-gray-500">
            Delivery to: <span class="font-semibold text-gray-700">${order.address.recipientName}</span>, ${order.address.details} | ${order.address.phone}
        </div>
    </div>
</c:forEach>
