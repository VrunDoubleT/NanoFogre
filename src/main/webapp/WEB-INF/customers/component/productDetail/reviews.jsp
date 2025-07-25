<%-- 
    Document   : reviews
    Created on : Jul 2, 2025, 12:44:36 PM
    Author     : Tran Thanh Van - CE181019
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Utils.DateFormatter"%>
<c:choose>
    <c:when test="${not empty reviews}">
        <c:forEach var="review" items="${reviews}" varStatus="status">
            <div class="bg-white p-6 mb-5 bg-gray-50 rounded-xl shadow">
                <div class="flex justify-between">
                    <div class="flex gap-4">
                        <div class="w-12 h-12 rounded-[50%] overflow-hidden">
                            <img class="w-full h-full object-cover" src="${review.customer.avatar}" alt="alt"/>
                        </div>
                        <div>
                            <span class="font-bold text-gray-900">${review.customer.name}</span>
                            <div class="flex items-center space-x-2">
                                <div class="flex items-center">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i data-lucide="star" class="w-4 h-4 ${i <= review.star ? 'star-filled' : 'star-empty'}" 
                                           style="fill: ${i <= review.star ? '#fbbf24' : '#e5e7eb'}"></i>
                                    </c:forEach>
                                    <span class="ml-2 text-sm text-gray-600">${review.star}/5</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div>
                        <span class="text-sm text-gray-500">${DateFormatter.timeAgo(review.createdAt)}</span>
                    </div>
                </div>
                <div class="mt-3">
                    <span class="text-gray-700 leading-relaxed">${review.content}</span>
                    <c:if test="${not empty review.replies}">
                        <div class="border-l-4 border-blue-200 pl-4 ml-4 space-y-3 mt-3">
                            <c:forEach var="reply" items="${review.replies}">
                                <div class="bg-blue-50 rounded-lg p-4">
                                    <div class="flex items-center justify-between mb-2">
                                        <div class="flex items-center space-x-2">
                                            <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                                                <i class="fas fa-user-tie text-white text-xs"></i>
                                            </div>
                                            <span class="font-medium text-blue-900">Nano Forge - Admin</span>
                                            <span class="text-xs text-blue-600">${DateFormatter.timeAgo(reply.createdAt)}</span>
                                        </div>
                                    </div>
                                    <p class="text-blue-800">${reply.content}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="bg-gray-50 border border-dashed border-gray-300 rounded-xl shadow-sm text-center px-6 py-10">
            <div class="flex flex-col items-center justify-center space-y-3">
                <!-- Message -->
                <h3 class="text-lg font-semibold text-gray-600">No reviews yet</h3>
                <p class="text-sm text-gray-500 max-w-md">
                    This product hasn't received any reviews yet
                </p>

            </div>
        </div>

    </c:otherwise>
</c:choose>