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

<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
    body, * {
        font-family: 'Inter', sans-serif;
    }

    .glass-card {
        background: linear-gradient(135deg, #fff 70%, #f6f8fa 100%);
        border-radius: 24px;
        box-shadow: 0 16px 50px -10px rgba(0,0,0,.10);
        border: 1.5px solid rgba(140,130,255,0.07);
        max-width: 860px;
        margin: 44px auto;
        overflow: hidden;
    }

    .gradient-header {
        background: linear-gradient(90deg, #4176fa 0%, #9c5cff 100%);
        padding: 24px 36px 18px 36px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .gradient-header .header-title {
        color: #fff;
        font-weight: 800;
        font-size: 2.1rem;
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 0;
    }
    .btn-create {
        background: linear-gradient(90deg, #10b981 0%, #059669 100%);
        color: #fff;
        font-weight: bold;
        border-radius: 12px;
        padding: 11px 26px;
        box-shadow: 0 2px 12px 0 rgba(16,185,129,0.10);
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 7px;
        border: none;
        outline: none;
        transition: all .17s;
    }
    .btn-create:hover {
        background: linear-gradient(90deg, #0ea5e9 0%, #6366f1 100%);
        transform: translateY(-1px) scale(1.01);
        box-shadow: 0 6px 16px 0 rgba(70,123,245,0.15);
    }

    .form-section {
        padding: 36px 36px 24px 36px;
        background: linear-gradient(135deg,#f8f9fc 60%,#f3f0fd 100%);
    }
    .avatar-center {
        display: flex;
        justify-content: center;
        margin-bottom: 24px;
    }
    .avatar-gradient {
        position: relative;
        background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
        border-radius: 50%;
        padding: 8px;
        box-shadow: 0 6px 32px rgba(59,130,246,0.10);
    }
    .avatar-gradient img {
        width: 110px;
        height: 110px;
        object-fit: cover;
        border-radius: 50%;
        border: 4px solid #fff;
        box-shadow: 0 2px 15px #c7d2fe60;
    }
    .input-block {
        margin-bottom: 25px;
    }
    .input-label {
        font-size: 15px;
        font-weight: 600;
        color: #4b5563;
        margin-bottom: 7px;
        display: block;
    }

    .input-error {
        color: #e11d48;
        font-size: 13px;
    }

    .custom-upload-box {
        min-height: 90px;
        border-radius: 14px;
        border: 2px dashed #d1d5db;
        background: #f6f8fa;
        cursor: pointer;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        transition: background 0.18s;
    }
    .custom-upload-box:hover {
        background: #f0f5ff;
    }

    .btn-add-attr {
        margin-top: 23px;
        background: linear-gradient(135deg, #3b82f6 0%, #9333ea 100%);
        font-size: 15px;
        font-weight: 600;
        border-radius: 12px;
        color: #fff;
        padding: 12px 28px;
        box-shadow: 0 4px 15px 0 rgba(59,130,246,0.11);
        display: flex;
        align-items: center;
        gap: 9px;
        transition: .13s;
    }
    .btn-add-attr:hover {
        transform: translateY(-1px);
        box-shadow: 0 10px 24px rgba(139,92,246,0.16);
    }
    .custom-attr-item {
        background: #f5faff;
        border-radius: 17px;
        border: 1.3px solid #dbeafe;
        box-shadow: 0 1px 7px 0 rgba(80,80,180,0.08);
        padding: 24px 28px 13px 28px;
        margin-bottom: 17px;
        position: relative;
    }
    .custom-checkbox {
        width: 18px;
        height: 18px;
        accent-color: #6d28d9;
        margin-right: 7px;
    }
    .custom-unit-input {
        width: 120px;
    }
    .custom-status-select {
        width: 125px;
        border-radius: 7px;
    }
    .custom-minmax-label {
        font-weight: 500;
        color: #444;
        margin-right: 4px;
    }
    .attr-fields-row {
        display: flex;
        gap: 26px;
    }
    .attr-delete-btn {
        color: #ef4444;
        background: #fff0f0;
        border-radius: 8px;
        padding: 5px 12px;
        border: none;
        outline: none;
        font-weight: 500;
        font-size: 15px;
        transition: background .13s, color .13s;
        position: absolute;
        right: 22px;
        bottom: 18px;
    }
    .attr-delete-btn:hover {
        background: #ffe5e5;
        color: #dc2626;
    }
    @media (max-width: 768px) {
        .glass-card, .form-section {
            padding: 18px !important;
        }
        .gradient-header {
            flex-direction: column;
            gap: 15px;
            padding: 18px !important;
        }
    }
</style>

<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">

    <!-- Header -->
    <div class="gradient-header">
        <span class="header-title">
            <i data-lucide="folder-plus" class="w-7 h-7"></i>
            Create Category
        </span>

        <form id="create-category-form" class="space-y-6" enctype="multipart/form-data" autocomplete="off">
            <!-- Action Buttons -->
            <div class="flex justify-end space-x-3">
                <button
                    type="submit"
                    id="create-category-btn"
                    class="btn-create">
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
            <div class="input-block">
                <label for="categoryName" class="input-label">Category Name</label>
                <input type="text" id="categoryName" name="categoryName" class="w-full h-[44px] px-[15px] bg-[#f7fafc] text-[#24292f] text-base rounded-[11px] border-[1.3px] border-[#e5e7eb] shadow-[0_1px_4px_rgba(60,72,120,0.04)] outline-none transition focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       required />
                <span id="categoryNameError" class="input-error"></span>
            </div>

            <!-- Upload input -->
            <div class="input-block">
                <label class="input-label">Category Image</label>
                <div id="image-preview" class="flex justify-center mb-3">
                    <img src="<%= imageUrl%>" id="category-image-preview-tag"
                         class="h-32 w-32 object-cover rounded-full border border-gray-200 shadow"
                         alt="Category Image Preview"
                         hidden=""/>
                </div>
            </div>

            <!-- Category Image Upload -->
            <div class=" pb-[15px]">
                <input type="file" id="categoryImage" name="categoryImage" accept="image/*" class="hidden" required />
                <label for="categoryImage"
                       class="custom-upload-box w-full">
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
            <button type="button" class="openAddAttributeProduct btn-add-attr">
                <i data-lucide="diamond-plus" class="w-5 h-5"></i>
                <span>Add Attribute Product</span>
            </button>

            <!--            hand attribute-->
            <div id="attributes-container" class="mt-4 space-y-4"></div>

            <!------------------------------------------------------------------>
            <!-- Attribute Item Template (Hidden) -->
            <div id="attribute-item-template" class="hidden">
                <div id="main-attribute-item" class="custom-attr-item">



                    <!-- Row: Attribute Name + Required Field -->
                    <div class="flex items-center mb-3 gap-4 pr-32">

                        <div class="flex-1">
                            <label class="block text-sm font-semibold text-gray-700 mb-1">
                                Attribute Name <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="attributeName"
                                   class="w-full h-[44px] px-[15px] bg-[#f7fafc] text-[#24292f] text-base rounded-[11px] border-[1.3px] border-[#e5e7eb] shadow-[0_1px_4px_rgba(60,72,120,0.04)] outline-none transition focus:ring-2 focus:ring-blue-500 focus:border-transparent"

                                   placeholder="Enter attribute name" required />
                            <p class="text-red-500 text-sm mt-1 error-message attribute-name-error"></p>
                        </div>

                        <div class="flex items-center space-x-2 ml-4">
                            <input type="checkbox" name="attributeRequired"
                                   class="custom-checkbox"
                                   checked />
                            <label class="text-sm text-gray-700 font-medium">Required Field</label>
                        </div>


                        <!--  Delete -->
                        <button type="button"
                                class="remove-attribute attr-delete-btn"
                                title="Delete attribute">
                            <i data-lucide="trash-2" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <!-- Row: Data Type, Min/Max -->
                    <div class="attr-fields-row">

                        <div class="min-w-[200px] flex flex-col">
                            <label class="input-label">Data Type <span class="text-red-500">*</span></label>
                            <select name="attributeDatatype" class="w-full h-[44px] px-[15px] bg-[#f7fafc] text-[#24292f] text-base rounded-[11px] border-[1.3px] border-[#e5e7eb] shadow-[0_1px_4px_rgba(60,72,120,0.04)] outline-none transition focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    required>
                                <option value="text" selected="">Text</option>
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
                        <label class="input-label">Unit (optional):</label>
                        <input type="text" name="attributeUnit"
                               class="w-full h-[44px] px-[15px] bg-[#f7fafc] text-[#24292f] text-base rounded-[11px] border-[1.3px] border-[#e5e7eb] shadow-[0_1px_4px_rgba(60,72,120,0.04)] outline-none transition focus:ring-2 focus:ring-blue-500 focus:border-transparent custom-unit-input"
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
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">Min:</label>
                        </div>
                        <input type="number" step="1" name="attributeMin"
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Min value" style="display:none;" />
                    </div>
                    <!-- Max -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">Max:</label>
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
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">Min:</label>
                        </div>
                        <input type="number" step="0.1" name="attributeMin" 
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition "
                               placeholder="Min value" style="display:none;" />
                    </div>
                    <!-- Max -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">Max:</label>
                        </div>
                        <input type="number" step="0.1" name="attributeMax" 
                               class="max-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Max value" style="display:none;" />
                    </div>
                </div>
            </div>

            <div id="date-template" class="hidden">
                <div class="flex flex-row gap-4 w-full">
                    <!-- Min date -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-min-input h-4 w-4" />
                            <label class="custom-minmax-label">Min date:</label>
                        </div>
                        <input type="date" name="attributeMin"
                               class="min-input w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-400 transition"
                               placeholder="Min date" style="display:none;" />
                    </div>
                    <!-- Max date -->
                    <div class="flex flex-col flex-1 min-w-[140px]">
                        <div class="flex items-center gap-2 mb-1">
                            <input type="checkbox" class="show-max-input h-4 w-4" />
                            <label class="custom-minmax-label">Max date:</label>
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