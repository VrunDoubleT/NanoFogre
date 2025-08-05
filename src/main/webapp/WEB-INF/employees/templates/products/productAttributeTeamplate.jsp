<%-- 
    Document   : productAttributeTeamplate
    Created on : Jun 20, 2025, 9:43:33 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="bg-gray-50 rounded-xl p-6">
    <h3 class="text-lg font-semibold text-gray-900 mb-4">Additional Information</h3>
    <div class="space-y-4">
        <c:choose>
            <c:when test="${not empty productAttributes and productAttributes[0].id != 0}">
                <c:forEach var="productAttribute" items="${productAttributes}">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            ${productAttribute.name}
                        </label>
                        <c:choose>
                            <c:when test="${productAttribute.dataType == 'int' || productAttribute.dataType == 'float'}">
                                <input
                                    data-attribute-id="${productAttribute.id}"
                                    id="product-attribute-${productAttribute.id}"
                                    value="${(productAttribute.value != null || productAttribute.value.trim().length != 0) ? productAttribute.value : ''}"
                                    type="number"
                                    class="product-attribute w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
                                    <c:if test="${productAttribute.dataType == 'float'}">step="0.1"</c:if>
                                        >
                            </c:when>
                            <c:otherwise>
                                <input
                                    data-attribute-id="${productAttribute.id}"
                                    value="${(productAttribute.value != null || productAttribute.value.trim().length != 0) ? productAttribute.value : ''}"
                                    id="product-attribute-${productAttribute.id}"
                                    type="${productAttribute.dataType}"
                                    class="product-attribute w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none"
                                    >
                            </c:otherwise>
                        </c:choose>
                        <span id="product-attibute-${productAttribute.id}-error"
                              class="text-red-500 text-sm"></span>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="text-gray-500 italic">No attributes available for this product.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
