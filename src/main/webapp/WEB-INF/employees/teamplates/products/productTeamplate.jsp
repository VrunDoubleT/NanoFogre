<%-- 
    Document   : productTeamplate
    Created on : Jun 8, 2025, 11:28:47 AM
    Author     : Tran Thanh Van - CE181019
--%>

<%@page import="Models.Product"%>
<%@page import="java.util.List"%>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products != null) {
        for (Product product : products) {
%>
<tr>
    <td class="px-4 py-4 whitespace-nowrap">
        <span class="font-bold text-[20px] text-gray-500"><%= product.getProductId()%></span>
    </td>

    <td class="px-6 py-4 whitespace-nowrap">
        <div class="flex items-center">
            <div class="flex-shrink-0 h-16 w-16">
                <img class="h-16 w-16 rounded-lg object-cover border border-gray-200"
                     src="<%= product.getUrls().get(0)%>" alt="<%= product.getTitle()%>">
            </div>
            <div class="ml-4">
                <div class="text-sm font-medium text-gray-900 line-clamp-1"><%= product.getTitle()%></div>

                <div class="flex items-center mt-1">
                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800"><%= product.getScale()%></span>
                    <span class="ml-2 inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800"><%= product.getFeatures()%></span>
                </div>
            </div>
        </div>
    </td>

    <td class="px-4 py-4 whitespace-nowrap">
        <div class="text-sm text-gray-900">
            <div><strong>Manufacturer: </strong> <%= product.getManufacturer().length() > 30 ? product.getManufacturer().substring(0, 30) + "..." : product.getManufacturer()%></div>
            <div><strong>Material:</strong> <%= product.getMaterial()%></div>

        </div>
    </td>

    <td class="px-4 py-4 whitespace-nowrap">
        <div class="text-lg font-semibold text-gray-900">$<%= product.getPrice()%></div>
    </td>

    <td class="px-4 py-4 whitespace-nowrap">
        <div class="text-sm text-center font-medium text-gray-900"><%= product.getQuantity()%></div>
    </td>

    <td class="px-4 py-4 whitespace-nowrap">
        <% if (product.isDestroy()) { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-800">Disable</span>
        <% } else { %>
        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Active</span>
        <% }%>
    </td>

    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium">
        <div class="flex items-center space-x-2">
            <button data-product-id="<%= product.getProductId()%>" class="openViewModal bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                </svg>
            </button>
            <button data-product-id="<%= product.getProductId()%>" class="openEditProdctModal bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1.5 rounded-lg transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </button>
            <% if (!product.isDestroy()) {%>
            <button data-product-id="<%= product.getProductId()%>" class="openDisableProdct bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg transition-colors" title="Hide product">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
            <% } else {%>
            <button data-product-id="<%= product.getProductId()%>" class="openEnableProduct bg-green-100 text-green-700 hover:bg-green-200 px-3 py-1.5 rounded-lg transition-colors" title="Restore product">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
            </button>
            <% } %>


        </div>
    </td>
</tr>
<%
        }
    }
%>
