<%@page import="DAOs.CategoryDAO"%>
<%@page import="Models.Category"%>
<%-- 
    Document   : createCategoryTeamplate
    Created on : Jun 15, 2025, 7:27:04 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Category category = new Category();
    String imageUrl = category.getAvatar();
%>

<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">

    <!-- Header -->
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center rounded-t-xl">
        <h2 class="text-2xl font-bold text-white">Create Category</h2>

        <form id="create-category-form" class="space-y-6" enctype="multipart/form-data" autocomplete="off">
            <!-- Action Buttons -->
            <div class="flex justify-end space-x-3">
                <button
                    type="submit"
                    id="create-category-btn"
                    class="px-4 py-2 flex bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                      <i data-lucide="plus"></i>
                    <span>Create</span>
                </button>
            </div>
        </form>
    </div>
    <div class="p-8 h-full w-full overflow-y-auto ">



        <!-- Form Section -->
        <div class="p-8">
            <!-- Category Name -->
            <div>
                <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">Category Name</label>
                <input type="text" id="categoryName" name="categoryName"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                       required />
                <p id="categoryNameError" class="text-red-500 text-sm mt-1"></p>
            </div>

            <!-- Upload input -->
            <div>
                <label class="block text-sm font-semibold text-gray-700 mb-1">Category Image</label>
                <div id="image-preview" class="flex justify-center mb-3">
                    <img src="<%= imageUrl%>" id="category-image-preview-tag"
                         class="h-32 w-32 object-cover rounded-full border border-gray-200 shadow"
                         alt="Category Image Preview"
                         hidden=""/>
                </div>
            </div>

            <!-- Category Image Upload -->
            <div>
                <input type="file" id="categoryImage" name="categoryImage" accept="image/*" class="hidden" required />
                <label for="categoryImage"
                       class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                    <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                    <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 5MB)</span>
                </label>
                <div id="image-preview" class="mt-2"></div>
                <p id="categoryImageError" class="text-red-500 text-sm mt-1"></p>
            </div>

            <!-- Status/Error -->
            <div id="upload-status" class="hidden flex justify-center items-center">
                <div class="bg-blue-50 border border-blue-200 rounded-lg p-2">
                    <span id="status-text" class="text-blue-700 text-sm"></span>
                </div>
            </div>
            <div id="upload-error" class="hidden flex justify-center items-center">
                <div class="bg-red-50 border border-red-200 rounded-lg p-2">
                    <span id="error-text" class="text-red-700 text-sm"></span>
                </div>
            </div>

            <!------------------------------------------------------------------>
            <!-- Add Attribute Product Button -->
            <button type="button" class="openAddAttributeProduct bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transform transition-all duration-200 flex items-center space-x-2">
                <i data-lucide="diamond-plus" class="w-5 h-5"></i>
                <span>Add Attribute Product</span>
            </button>

            <!--            hand attribute-->
            <div id="attributes-container" class="mt-4 space-y-4"></div>

            <!------------------------------------------------------------------>
            <!-- Attribute Item Template (Hidden) -->
            <div id="attribute-item-template" class="hidden">
                <div id="main-attribute-item" class="hidden border border-gray-200 rounded-lg p-4 mb-4 bg-gray-50 relative">



                    <!-- Row: Attribute Name + Required Field -->
                    <div class="flex items-center mb-3 gap-4 pr-32">

                        <div class="flex-1">
                            <label class="block text-sm font-semibold text-gray-700 mb-1">
                                Attribute Name <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="attributeName"
                                   class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
                                   placeholder="Enter attribute name" required />
                            <p class="text-red-500 text-sm mt-1 error-message attribute-name-error"></p>
                        </div>
                        <div class="flex items-center space-x-2 ml-4">
                            <input type="checkbox" name="attributeRequired"
                                   class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                                   checked />
                            <label class="text-sm text-gray-700 font-medium">Required Field</label>
                        </div>

                        <!--  Delete -->
                        <button type="button"
                                class="remove-attribute absolute  right-4 -translate-y-1/2 text-red-500 hover:text-red-700 transition-colors flex items-center gap-1 px-3 py-1 rounded"
                                title="Delete attribute">
                            <i data-lucide="x" class="w-5 h-5"></i> Delete
                        </button>
                    </div>

                    <!-- Row: Data Type, Min/Max -->
                    <div class="flex items-start gap-4 pr-32">

                        <div class="min-w-[200px] flex flex-col">
                            <label class="block text-sm font-semibold text-gray-700 mb-1">Data Type <span class="text-red-500">*</span></label>
                            <select name="attributeDatatype" class="w-[200px] px-3 py-2 h-10 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400" required>
                                <option value="">Select data type</option>
                                <option value="text">Text</option>
                                <option value="int">Integer</option>
                                <option value="float">Float</option>
                                <option value="date">Date</option>
                            </select>
                            <p class="text-red-500 text-sm mt-1 error-message attribute-datatype-error"></p>
                        </div>

                        <div class="min-max-container flex gap-4 flex-1"></div>
                    </div>
                    <!-- add Unit  -->
                    <div class="mt-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Unit (optional):</label>
                        <input type="text" name="attributeUnit"
                               class="w-[222px] px-3 py-1 border rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-400"
                               placeholder="eg: cm, g, % ..." />
                    </div>
                </div>
            </div>

            <!--...........................................................-->

            <!-- Min/Max Templates (Hidden) -->
            <div id="int-template" class="hidden">
                <div class="flex flex-row gap-4 w-full">
                    <!-- Min -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-min-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Min:</label>
                        </div>
                        <input type="number" step="1" name="attributeMin"
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Min value" style="display:none;" />
                    </div>
                    <!-- Max -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Max:</label>
                        </div>
                        <input type="number" step="1" name="attributeMax"
                               class="max-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Max value" style="display:none;" />
                    </div>
                </div>
            </div>


            <div id="float-template" class="hidden">
                <div class="flex flex-row gap-4 w-full">
                    <!-- Min -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-min-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Min:</label>
                        </div>
                        <input type="number" step="0.1" name="attributeMin" 
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition "
                               placeholder="Min value" style="display:none;" />
                    </div>
                    <!-- Max -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Max:</label>
                        </div>
                        <input type="number" step="0.1" name="attributeMax" 
                               class="max-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Max value" style="display:none;" />
                    </div>
                </div>
            </div>


            <div id="text-template" class="hidden">
                <div class="flex flex-col flex-1 w-900px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Text value:</label>
                    <input type="text" name="attributeTextValue" 
                           class="w-[230px] px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 transition"
                           placeholder="Enter text value" />
                </div>
            </div>


            <div id="date-template" class="hidden">
                <div class="flex flex-row gap-4 w-full">
                    <!-- Min date -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-min-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Min date:</label>
                        </div>
                        <input type="date" name="attributeMin"
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Min date" style="display:none;" />
                    </div>
                    <!-- Max date -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="block text-sm font-medium text-gray-700">Max date:</label>
                        </div>
                        <input type="date" name="attributeMax"
                               class="max-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Max date" style="display:none;" />
                    </div>
                </div>
            </div>


        </div>
    </div>
</div>