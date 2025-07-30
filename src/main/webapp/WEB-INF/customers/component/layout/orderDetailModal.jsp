<%-- 
    Document   : orderDetailModal
    Created on : Jul 3, 2025, 5:48:23 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<%@page import="Utils.CurrencyFormatter"%>
<c:choose>
    <c:when test="${empty order}">
        <div class="p-8 text-center text-red-500 text-lg">Order not found or you have no permission to view this order.</div>
    </c:when>
    <c:otherwise>
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
            <!-- Order Progress -->
        <c:if test="${not empty orderHistory}">
            <div class="mb-6 flex flex-col gap-4 px-2 py-2">
                <div class="font-semibold text-gray-700 mb-1">Order Progress</div>
                <div class="flex flex-col gap-0">
                    <c:forEach var="step" items="${orderHistory}" varStatus="loop">
                        <div class="flex flex-row items-center relative">
                            <div class="flex flex-col items-center" style="width: 40px;">
                                <c:if test="${!loop.first}">
                                    <div class="w-1 bg-blue-200" style="height: 16px;"></div>
                                </c:if>
                                <div class="
                                     w-7 h-7 flex items-center justify-center rounded-full border-4 font-bold text-base shadow
                                     <c:choose>
                                         <c:when test='${step.statusId == order.orderStatus.id}'>bg-blue-500 text-white border-blue-300</c:when>
                                         <c:otherwise>bg-white text-blue-500 border-blue-200</c:otherwise>
                                     </c:choose>
                                     ">
                                    ${loop.index + 1}
                                </div>
                                <c:if test="${!loop.last}">
                                    <div class="w-1 bg-blue-200" style="height: 16px;"></div>
                                </c:if>
                            </div>
                            <div class="flex-1 flex items-center gap-2 py-2">
                                <span class="font-bold <c:if test='${step.statusId == order.orderStatus.id}'>text-blue-700</c:if>">
                                    <c:out value="${step.statusName}" />
                                </span>
                                <span class="text-xs text-gray-400">${step.updatedAtStr}</span>
                                <c:if test="${step.statusNote ne null && not empty step.statusNote}">
                                    <span class="relative group ml-1">
                                        <i data-lucide="alert-circle" class="w-4 h-4 text-yellow-400 cursor-pointer"></i>
                                        <span class="invisible group-hover:visible opacity-0 group-hover:opacity-100 transition
                                              absolute left-1/2 z-10 -translate-x-1/2 mt-2 min-w-[180px] max-w-xs bg-yellow-50 text-yellow-900 text-xs
                                              font-medium rounded px-3 py-2 shadow-lg border border-yellow-200 whitespace-normal pointer-events-none"
                                              style="top:100%;">
                                            <c:out value="${step.statusNote}" />
                                        </span>
                                    </span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        <div class="mb-6 grid grid-cols-1 md:grid-cols-2 gap-3 text-gray-700">
            <div>
                <div class="text-xs text-gray-400 mb-1">Order Amount Details</div>
                <div class="bg-gray-50 rounded-xl p-4 shadow flex flex-col gap-1 mb-2">
                    <!-- Subtotal -->
                    <div class="flex justify-between">
                        <span>Subtotal</span>
                        <span>
                            ${CurrencyFormatter.formatVietNamCurrency(subtotal)}đ
                        </span>
                    </div>
                    <!-- Shipping Fee -->
                    <div class="flex justify-between">
                        <span>Shipping fee</span>
                        <span>
                            ${CurrencyFormatter.formatVietNamCurrency(order.shippingFee)}đ
                        </span>
                    </div>
                    <!-- Voucher -->
                    <c:if test="${not empty order.voucher}">
                        <div class="flex justify-between">
                            <span>Voucher 
                                <span class="text-xs text-blue-500">(${order.voucher.code})</span>
                            </span>
                            <span class="text-red-500">
                                -${CurrencyFormatter.formatVietNamCurrency(order.voucher.value)}đ</span>
                        </div>
                    </c:if>
                    <!-- Divider -->
                    <div class="border-t my-1"></div>
                    <!-- Total -->
                    <div class="flex justify-between font-bold text-blue-700 text-lg">
                        <span>Total to pay</span>
                        <span>
                            ${CurrencyFormatter.formatVietNamCurrency(order.totalAmount)}đ
                        </span>
                    </div>
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
                        <div class="flex items-center gap-4 bg-white border rounded-xl shadow-sm p-3">
                            <c:if test="${not empty item.product.urls}">
                                <a href="/product/detail?pId=${item.product.productId}" target="_blank">
                                    <img src="<c:out value='${item.product.urls[0]}'/>"
                                         class="w-16 h-16 rounded object-cover border"
                                         alt="${item.product.title}"/>
                                </a>
                            </c:if>
                            <div class="flex-1 min-w-0">
                                <a href="/product/detail?pId=${item.product.productId}" 
                                   class="font-semibold truncate hover:underline text-blue-700 cursor-pointer" 
                                   target="_blank">
                                    <c:out value="${item.product.title}"/>
                                </a>
                                <div class="text-sm text-gray-500">x<c:out value="${item.quantity}"/></div>
                            </div>
                            <div class="font-bold text-blue-700 text-base shrink-0">
                                ${CurrencyFormatter.formatVietNamCurrency(item.price)}đ
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
    </c:otherwise>
</c:choose>
