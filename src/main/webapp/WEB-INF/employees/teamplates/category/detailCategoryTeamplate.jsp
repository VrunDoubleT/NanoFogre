<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="Models.ProductAttribute"%>
<%@page import="java.util.List"%>
<%@page import="DAOs.CategoryDAO"%>
<%@page import="Models.Category"%>

<%
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    CategoryDAO categoryDAO = new CategoryDAO();
    Category category = categoryDAO.getCategoryById(categoryId);
    List<ProductAttribute> attributes = categoryDAO.getAttributesByCategoryId(categoryId);
    String imageUrl = category.getAvatar();
    if (imageUrl == null || imageUrl.trim().isEmpty()) {
        imageUrl = "/assets/images/no-image.png";
    } else if (imageUrl.startsWith("http")) {

    } else if (!imageUrl.startsWith("/")) {
        imageUrl = "/uploads/category/" + imageUrl;
    }
%>

<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center rounded-t-xl">
        <!-- Header Section -->
        <div class="flex items-center gap-3">
            <i data-lucide="file-text" class="w-6 h-6 text-white"></i>
            <h2 class="text-2xl font-bold text-white text-center">Category Details</h2>

        </div>
    </div>

    <div class="p-8 h-full w-full overflow-y-auto ">

        <!-- Body Section -->
        <div class="p-8 space-y-6">

            <!-- Category Image -->
            <div> 
                <div class="flex justify-center">

                    <div class="relative">
                        <img
                            src="<%= imageUrl%>"
                            alt="Category Avatar"
                            class="w-36 h-36 rounded-full object-cover border-4 border-white shadow-lg ring-2 ring-blue-200 transition-all duration-300 "
                            style="background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);"
                            />

                    </div>
                </div>
            </div>

            <!-- Category Name -->

            <div class="bg-gray-50 border rounded-lg p-4 shadow-sm text-center">
                <span class="text-sm text-gray-500">Category Name:</span>
                <p class="font-semibold text-gray-800">
                    <%= category.getName() != null && !category.getName().isEmpty() ? category.getName() : "None"%>
                </p>
            </div>


            <!-- Category Info -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div class="bg-gray-50 border rounded-lg p-4 shadow-sm text-center">
                    <span class="text-sm text-gray-500">Category ID:</span>
                    <p class="font-semibold text-gray-800"><%= category.getId()%></p>
                </div>


                <div class="bg-gray-50 border rounded-lg p-4 shadow-sm text-center">
                    <span class="text-sm text-gray-500">Status:</span>
                    <p class="font-semibold <%= category.isIsActive() ? "text-green-600" : "text-red-600"%>">
                        <%= category.isIsActive() ? "Active" : "Inactive"%>
                    </p>
                </div>
            </div>


            <!-- Attributes List-->
            <div class="space-y-4">
                <h3 class="text-3xl font-bold text-gray-700 border-b pb-2 mb-4">Product Attributes</h3>

                <% if (attributes == null || attributes.isEmpty()) { %>
                <p class="italic text-gray-500 text-center py-4 text-lg">No attributes defined.</p>
                <% } else { %>
                <% for (ProductAttribute attr : attributes) {%>
                <div class="bg-white shadow rounded-lg border border-gray-200 p-4 hover:shadow-md transition-shadow">
                    <div class="flex justify-between items-center mb-2">
                        <span class="text-xl font-semibold text-gray-800 capitalize">
                            <span class="text-sm text-gray-500">Attribute Name:</span>
                            <%= attr.getAttributeName()%>
                        </span>
                        <% if (attr.getIsRequired() != null && attr.getIsRequired()) { %>
                        <span class="px-2 py-1 rounded-full  text-red-700 text-xs font-medium flex items-center gap-1">
                            Required
                            <span class="text-base">*</span>
                        </span>
                        <% }%>
                    </div>

                    <div class="text-md text-gray-600 grid grid-cols-2 gap-y-1">
                        <div>
                            <span class="font-medium">Type:</span>
                            <%= attr.getDataType()%>
                        </div>

                        <% if (attr.getMinValue() != null || attr.getMaxValue() != null) {%>
                        <div>
                            <% if (attr.getMinValue() != null) {%>
                            Min: <span class="font-medium"><%= attr.getMinValue()%></span>
                            <% } %>
                            <% if (attr.getMaxValue() != null) {%>
                            | Max: <span class="font-medium"><%= attr.getMaxValue()%></span>
                            <% } %>

                        </div>
                        <% } %>

                        <% if (attr.getUnit() != null && !attr.getUnit().isEmpty()) {%>
                        <div>
                            <span class="font-medium">Unit:</span>
                            <%= attr.getUnit()%>
                        </div>
                        <% }%>

                        <div>
                            <span class="font-medium">Status:</span>
                            <span class="font-medium <%= attr.getIsActive() ? "text-green-600" : "text-red-600"%>">
                                <%= attr.getIsActive() ? "Active" : "Inactive"%>
                            </span>
                        </div>
                    </div>
                </div>
                <% } %>
                <% }%>
            </div>


        </div>
    </div>
</div>
