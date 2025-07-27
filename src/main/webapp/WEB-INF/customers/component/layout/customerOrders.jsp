<%-- 
    Document   : customerOrders
    Created on : Jul 3, 2025, 5:48:23 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<div class="w-full bg-white border border-gray-200 rounded-2xl p-8">
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
            <!-- Orders (Fragment) -->
            <div id="orders-list" class="space-y-7">
                <jsp:include page="orderCardsFragment.jsp"/>
            </div>
            <!-- Load more -->
            <div id="order-load-more-trigger" class="w-full text-center mt-6">
                <button type="button" id="load-more-orders-btn"
                        class="px-5 py-2 rounded-xl border bg-white text-blue-700 border-blue-200 shadow hover:bg-blue-50 transition font-semibold">
                    Load more orders
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>


<div id="order-detail-modal" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
    <div class="relative max-w-2xl w-full bg-white rounded-2xl shadow-2xl animate-fade-in flex flex-col max-h-[90vh] overflow-hidden">
        <div id="order-detail-content" class="overflow-y-auto px-6 py-4 flex-1 min-h-[100px] max-h-[60vh]"
             style="scrollbar-width: thin; scrollbar-color: #cbd5e1 #f1f5f9;">
        </div>
        <div class="flex justify-end px-6 py-4 border-t border-gray-100 bg-white rounded-b-2xl shrink-0">
            <button id="close-detail-modal-2" class="px-5 py-2 text-white bg-blue-600 rounded hover:bg-blue-700">Close</button>
        </div>
    </div>
</div>
<style>
    @keyframes fade-in {
        from {
            opacity: 0;
            transform: translateY(40px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .animate-fade-in {
        animation: fade-in 0.25s cubic-bezier(.4,2,.6,1.4);
    }
    #order-detail-modal #order-detail-content::-webkit-scrollbar {
        width: 8px;
        background: #f1f5f9;
        border-radius: 8px;
    }
    #order-detail-modal #order-detail-content::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 8px;
    }
</style>