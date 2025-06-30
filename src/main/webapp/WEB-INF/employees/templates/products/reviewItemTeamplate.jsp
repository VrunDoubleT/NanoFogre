<%-- 
    Document   : reviewItemTeamplate
    Created on : Jun 27, 2025, 2:49:35 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="Utils.DateFormatter"%>
<c:set var="borderColor">
    <c:choose>
        <c:when test="${review.star >= 5}">border-l-green-500</c:when>
        <c:when test="${review.star >= 4}">border-l-blue-500</c:when>
        <c:when test="${review.star >= 3}">border-l-yellow-500</c:when>
        <c:when test="${review.star >= 2}">border-l-orange-500</c:when>
        <c:otherwise>border-l-red-500</c:otherwise>
    </c:choose>
</c:set>
<div class="bg-white rounded-xl shadow-lg mb-4 hover:shadow-xl transition-all duration-300 p-6 border-l-4 ${borderColor}">
    <!-- Review Header -->
    <div class="flex justify-between mb-4">
        <div class="flex gap-3">
            <img src="${review.customer.avatar}" alt="Avatar" class="w-12 h-12 object-cover rounded-[50%] border overflow-hidden"/>
            <div>
                <h4 class="font-semibold text-gray-800">${review.customer.name}</h4>
                <p class="text-sm text-gray-500">${review.customer.email}</p>
                <div class="flex items-center space-x-2 mt-1">
                    <div class="text-yellow-500 flex text-lg">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= review.star}">
                                    <i data-lucide="star" class="w-3 h-3 text-yellow-400 fill-yellow-400 stroke-yellow-400"></i>
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="star" class="w-3 h-3 text-yellow-400"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    <span class="font-semibold text-gray-700">${review.star}/5</span>
                </div>
            </div>
        </div>
        <p class="text-sm text-gray-500 mt-1">${DateFormatter.formatReadable(review.createdAt)}</p>
    </div>

    <!-- Review Content -->
    <div class="bg-gray-50 rounded-lg p-4 mb-4 border-l-4 border-indigo-500">
        <p class="text-gray-700 leading-relaxed">
            <i class="fas fa-quote-left text-gray-400 mr-2"></i>
            ${review.content}
            <i class="fas fa-quote-right text-gray-400 ml-2"></i>
        </p>
    </div>

    <div class="flex flex-wrap gap-2 mb-4">
        <button onclick="toggleReplyForm(${review.id})" class="bg-indigo-500 flex items-center gap-2 over:bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200">
            <i data-lucide="reply" class="w-6 h-6"></i>
            <span>Reply</span>
        </button>
    </div>

    <div id="replyForm${review.id}" class="reply-form hidden bg-blue-50 border-2 border-blue-200 rounded-lg p-4 mb-4">
        <textarea id="replyText${review.id}" onfocus="handleFocusReplyText(${review.id})" onblur="handleBlurReplyText(${review.id})" placeholder="Enter your response to the customer..." 
                  class="replyText w-full p-3 border-2 border-gray-200 outline-none rounded-lg resize-none h-24 mb-3"></textarea>
        <div class="flex gap-2">
            <button onclick="sendReply(${review.id})" class="bg-indigo-500 flex gap-[6px] items-center hover:bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200">
                <i data-lucide="send" class="w-4 h-4"></i>
                <span>Send reply</span>
            </button>
            <button onclick="toggleReplyForm(${
                    review.id
                    })" class="bg-gray-500 hover:bg-gray-600 flex gap-[6px] items-center text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200">
                <i data-lucide="x" class="w-4 h-4"></i>
                <span>Cancel</span>
            </button>
        </div>
    </div>

    <!-- Admin Replies -->
    <div id="replyList">
        <c:if test="${not empty review.replies}">
            <div class="bg-blue-50 border-l-4 border-blue-500 rounded-lg p-4">
                <h6 class="font-semibold text-blue-800 mb-3">
                    <i class="fas fa-reply mr-2"></i>Reply from Admin:
                </h6>
                <c:forEach var="reply" items="${review.replies}">
                    <div class="flex items-start space-x-3 mb-2">
                        <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold text-sm">A</div>
                        <div class="flex-1">
                            <div class="flex items-center space-x-2 mb-1">
                                <span class="font-semibold text-gray-800">${reply.employee.name}</span>
                                <span class="text-xs text-gray-500">${DateFormatter.formatReadable(reply.createdAt)}</span>
                            </div>
                            <p class="text-gray-700">${reply.content}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>
