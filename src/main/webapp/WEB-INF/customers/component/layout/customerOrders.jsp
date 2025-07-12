<%-- 
    Document   : customerOrders
    Created on : Jul 3, 2025, 5:48:23 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<div class="w-full bg-white rounded-2xl shadow-xl p-8">
    <h2 class="flex items-center gap-2 text-2xl font-bold mb-6">
        <i data-lucide="shopping-bag" class="w-6 h-6"></i>
        Your Orders
    </h2>

    <c:if test="${not empty error}">
        <div class="mb-4 p-4 bg-red-100 border border-red-300 text-red-700 rounded">
            ${error}
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="py-12 text-center text-gray-400">
                <i data-lucide="box" class="w-12 h-12 mx-auto mb-2"></i>
                You have no orders yet!
            </div>
        </c:when>
        <c:otherwise>
            <!-- Filter -->
            <div class="mb-6 flex flex-wrap gap-2">
                <button type="button"
                        class="order-status-btn px-5 py-1.5 rounded-xl font-medium border bg-blue-50 text-blue-600 border-blue-200 shadow transition focus:ring-2 focus:ring-blue-300"
                        data-status="all">All</button>
                <c:forEach var="status" items="${orderStatusList}">
                    <button type="button"
                            class="order-status-btn px-5 py-1.5 rounded-xl font-medium border bg-gray-100 hover:bg-blue-100 border-gray-200 shadow transition"
                            data-status="${status.id}">${status.name}</button>
                </c:forEach>
            </div>
            <!-- Orders -->
            <div id="orders-list" class="space-y-7">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card transition-all duration-200 opacity-100 scale-100 p-6 rounded-2xl border shadow-md bg-gradient-to-br from-white via-blue-50 to-gray-100 hover:scale-[1.01] hover:shadow-xl relative group"
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
                                          <c:when test="${order.orderStatus.id == 5}">text-red-700 bg-red-100</c:when>
                                      </c:choose>
                                      ">
                                    ${order.orderStatus.name}
                                </span>
                            </div>
                            <div class="flex flex-wrap items-center gap-3">
                                <span class="text-lg font-bold text-blue-700 tracking-tight">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/>₫
                                </span>
                                <button type="button"
                                        class="show-order-details-btn flex items-center gap-1 px-3 py-1.5 text-sm rounded-lg font-semibold bg-blue-100 text-blue-700 hover:bg-blue-600 hover:text-white transition shadow focus:ring-2 focus:ring-blue-300"
                                        data-id="${order.id}">
                                    <i data-lucide="eye" class="transition-transform group-hover:scale-110"></i>
                                    Details
                                </button>
                                <c:if test="${order.orderStatus.id == 1 or order.orderStatus.id == 2}">
                                    <button type="button"
                                            class="cancel-order-btn flex items-center gap-1 px-3 py-1.5 text-sm rounded-lg font-semibold bg-red-100 text-red-700 hover:bg-red-600 hover:text-white transition shadow"
                                            data-id="${order.id}">
                                        <i data-lucide="x-circle" class="transition-transform group-hover:scale-110"></i>
                                        Cancel
                                    </button>
                                </c:if>
                            </div>
                        </div>
                        <!-- Products in order -->
                        <c:if test="${not empty order.details}">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-4">
                                <c:forEach var="item" items="${order.details}">
                                    <div class="flex items-center gap-4 p-3 bg-white border border-gray-200 rounded-xl shadow-sm relative">
                                        <c:if test="${not empty item.product.urls}">
                                            <img src="${item.product.urls[0]}" alt="${item.product.title}" class="w-16 h-16 rounded-lg object-cover border" />
                                        </c:if>
                                        <div>
                                            <div class="font-semibold line-clamp-1">${item.product.title}</div>
                                            <div class="text-xs text-gray-500">x${item.quantity}</div>
                                        </div>
                                        <div class="ml-auto font-bold text-blue-600">
                                            <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/>₫
                                        </div>
                                        <c:if test="${order.orderStatus.id == 4}">
                                            <c:choose>
                                                <c:when test="${item.reviewed}">
                                                    <button type="button"
                                                            class="flex items-center gap-1 px-3 py-1 text-xs rounded bg-yellow-200 text-yellow-600 cursor-not-allowed opacity-70 ml-2"
                                                            disabled>Rated</button>
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
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="order-detail-modal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
    <div class="relative w-full max-w-2xl p-6 bg-white rounded-2xl shadow-2xl animate-fade-in">
        <button id="close-detail-modal" class="absolute top-3 right-4 text-2xl font-bold text-gray-400 hover:text-red-400">&times;</button>
        <div id="order-detail-content"></div>
        <div class="flex justify-end mt-4">
            <button id="close-detail-modal-2" class="px-5 py-2 text-white bg-blue-600 rounded hover:bg-blue-700">Close</button>
        </div>
    </div>
</div>
<style>
    @keyframes fade-in {
        from { opacity: 0; transform: translateY(40px);}
        to { opacity: 1; transform: translateY(0);}
    }
    .animate-fade-in {
        animation: fade-in 0.25s cubic-bezier(.4,2,.6,1.4);
    }
</style>

