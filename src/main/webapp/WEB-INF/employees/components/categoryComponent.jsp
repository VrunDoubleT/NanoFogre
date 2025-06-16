<%-- 
    Document   : categoryComponent
    Created on : Jun 10, 2025, 6:17:46 PM
    Author     : Tran Thanh Van - CE181019
--%>


<%-- 
    Document   : categoryComponent
    Created on : Jun 10, 2025, 6:17:46 PM
    Author     : Tran Thanh Van - CE181019
--%>



<%-- 
    Document   : CategoryComponnent
    Created on : Jun 15, 2025, 7:27:04 PM
    Author     : iphon
--%>

<%@page import="Models.Category"%>
<%@page import="Models.Category"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    Integer count = (Integer) request.getAttribute("total");
%>

<div class="">
    <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">


        <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <div class="flex items-center justify-center space-x-4">
                <div>
                    <p class="text-3xl font-bold text-gray-900">Total Category: <%= count%></p>
                </div>
                <div class="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                    </svg>
                </div>
            </div>

            <button id="create-category-button" data-category-id="${category.id} class="openEditCategoryModal" class="bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-2 rounded-lg transition-colors flex items-center space-x-2" title="Add Category">

                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v14m7-7H5" />
                </svg>
                <span class="text-lg font-semibold">Add Category</span>


            </button>


        </div>


        <div class="w-full">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category Name</th>
                        <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">

                </tbody>
            </table>
            <div id="loadingCategory"></div>
        </div>
    </div>
    <div id="pagination"></div> 
</div>
