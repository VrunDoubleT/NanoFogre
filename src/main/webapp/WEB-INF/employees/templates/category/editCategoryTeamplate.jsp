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

<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
    * {
        font-family: 'Inter', sans-serif;
    }

    .custom-attr-show {
        background: #f5faff;
        border-radius: 18px;
        border: 1.5px solid #dbeafe;
        box-shadow: 0 2px 7px 0 rgba(80,80,180,0.07);
        margin-bottom: 20px;
        padding: 26px 30px 16px 30px;
        position: relative;
    }

    .custom-card {

        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.12);
        background: #fff;
    }
    .custom-header-gradient {
        background: linear-gradient(90deg, #4176fa 0%, #9c5cff 100%);
        border-top-left-radius: 20px;
        border-top-right-radius: 20px;
    }
    .custom-section {
        background: #f6f8fa;
        border-radius: 14px;
        padding: 24px 32px;
        margin-bottom: 24px;
        box-shadow: 0 2px 8px 0 rgba(60, 72, 120, 0.08);
    }
    .custom-input, .custom-select {
        border-radius: 10px !important;
        font-size: 16px !important;
        background: #f7fafc;
        border: 1px solid #e5e7eb !important;
        box-shadow: 0 1px 4px 0 rgba(60,72,120,0.04);
        height: 42px !important;
        padding-left: 14px !important;
        padding-right: 14px !important;
        color: #24292f !important;
    }
    .custom-input:focus, .custom-select:focus {
        border-color: #7158e2 !important;
        background: #fff;
        box-shadow: 0 2px 12px 0 rgba(70, 123, 245, 0.08);
    }
    .custom-checkbox {
        width: 18px;
        height: 18px;
        accent-color: #6d28d9;
        margin-right: 6px;
    }
    .custom-btn-main {
        background: linear-gradient(90deg, #7158e2 0%, #46aefa 100%);
        color: #fff;
        font-weight: bold;
        border-radius: 12px;
        padding: 12px 28px;
        box-shadow: 0 2px 12px 0 rgba(70, 123, 245, 0.13);
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s;
        border: none;
        outline: none;
    }
    .custom-btn-main:hover {
        background: linear-gradient(90deg, #4176fa 0%, #9c5cff 100%);
        transform: translateY(-2px) scale(1.01);
        box-shadow: 0 4px 16px 0 rgba(70, 123, 245, 0.18);
    }
    .custom-label {
        font-size: 15px !important;
        font-weight: 600;
        color: #3f4864;
        margin-bottom: 5px;
        display: block;
    }
    .custom-section-title {
        font-weight: 700;
        font-size: 18px;
        color: #6046fa;
        background: #eceafd;
        padding: 7px 14px;
        border-radius: 14px;
        margin-bottom: 16px;
        display: inline-block;
    }
    .custom-advanced {
        background: #f5f3ff;
        border-radius: 10px;
        padding: 12px 20px 8px 20px;
        margin: 0 0 18px 0;
        box-shadow: 0 1px 5px 0 rgba(123,97,255,0.04);
        display: flex;
        gap: 32px;
        align-items: center;
    }
    .custom-delete-btn {
        color: #f87171;
        font-weight: 500;
        font-size: 15px;
        background: #fff0f0;
        border-radius: 8px;
        padding: 5px 14px;
        border: none;
        outline: none;
        transition: background 0.13s;
    }
    .custom-delete-btn:hover {
        background: #ffe5e5;
        color: #dc2626;
    }
    .custom-unit-input {
        width: 180px !important;
    }
    .custom-minmax-label {
        font-weight: 500;
        color: #444;
        margin-right: 4px;
    }

    .custom-attr-item {
        background: #fff;
        border-radius: 18px;
        border: 1.5px solid #e5e7eb;
        box-shadow: 0 2px 7px 0 rgba(200,210,230,0.08);
        margin-bottom: 20px;
        padding: 26px 30px 16px 30px;
        position: relative;
    }

    .custom-status-select {
        width: 130px !important;
        padding-left: 10px !important;
        padding-right: 10px !important;
        border-radius: 8px !important;
        font-size: 15px !important;
        height: 38px !important;
    }
    .custom-avatar-gradient {
        background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
    }
    .custom-upload-box {
        min-height: 128px;
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
    .btn-add {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    }
    .btn-add:hover {
        transform: translateY(-1px);
        box-shadow: 0 10px 20px rgba(16,185,129,0.17);
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
</style>

<!-- Modal Background -->
<div class="custom-card bg-gray-100 w-[1000px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">

    <!--     Header Section     -->
    <div class=" bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center rounded-t-xl">

        <div>
            <h1 class="text-3xl text-white font-bold mb-2">Edit Category</h1>
        </div>
        <form id="edit-category-form" enctype="multipart/form-data">

            <div class="flex space-x-4">
                <button
                    type="submit"
                    id="update-category-btn"
                    class="custom-btn-main custom-btn gradient-success text-white px-6 py-3 rounded-xl font-semibold flex items-center space-x-2">
                    <i data-lucide="save" class="w-5 h-5"></i>
                    <span>Update</span>
                </button>
            </div>
        </form>

    </div>

    <!-- Form Section -->
    <div class="p-8 h-full w-full overflow-y-auto bg-gradient-to-r ">

        <!-- Hidden Input -->
        <input type="hidden" id="categoryId" value="<%= category.getId()%>" />

        <!-- Category Name Input -->
        <div class="custom-section mb-4">
            <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">Category Name</label>
            <input
                type="text"
                id="categoryName"
                value="<%= category.getName()%>"
                class="custom-input w-full"
                required
                />
            <span id="categoryNameError" class="text-red-500 text-sm"></span>
        </div>  

        <!-- Image Section -->
        <div class="bg-gradient-to-r from-gray-50 to-blue-50 rounded-2xl p-6">
            <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center">
                <i data-lucide="image" class="w-6 h-6 mr-3 text-blue-600"></i>
                Category Image
            </h3>

            <div class="grid md:grid-cols-2 gap-8 items-center">
                <!-- avater curent -->
                <div class="custom-section mb-4 flex flex-col gap-3"> 
                    <label class="custom-label">Category Image Current</label>
                    <div class="flex justify-center">
                        <div class="relative custom-avatar-gradient p-2 rounded-full flex items-center justify-center">
                            <img
                                src="<%= imageUrl%>"
                                alt="Category Avatar"
                                class="h-[245px] w-auto rounded-full object-cover border-4 border-white shadow-lg ring-2 ring-blue-200 transition-all duration-300"
                                style="background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);"
                                />
                        </div>
                    </div>
                </div>

                <!-- Upload New -->
                <div>
                    <h4 class="text-sm font-semibold text-gray-600 mb-4">Upload New Image</h4>
                    <div id="image-preview" class="flex justify-center mb-3">
                        <img src="<%= imageUrl%>" id="category-image-preview-tag"
                             class="h-32 w-32 object-cover rounded-full border border-gray-200 shadow"
                             alt="Category Image Preview"
                             hidden=""/>
                    </div>
                    <div class="upload-zone rounded-2xl p-8 text-center cursor-pointer">

                        <label for="categoryImage"
                               class="custom-upload-box w-full h-32">
                            <i data-lucide="upload-cloud" class="w-12 h-12 mx-auto text-gray-400 mb-4"></i>
                            <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                            <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 5MB)</span>

                        </label>
                        <p id="categoryImageError" class="text-red-500 text-sm mt-1"></p>
                        <input type="file"

                               id="categoryImage"
                               name="categoryImage"
                               accept="image/*"
                               class="hidden" />
                    </div>
                </div>
            </div>
        </div>



        <!--////////////////////////////////ShowAttribute/////////////////////////////////////////////////////////////////////////-->

        <div id="attributes-container" class="mt-4 space-y-4 pb-[20px]">
            <% for (ProductAttribute attr : attributes) {
                    String dataType = attr.getDataType();
                    String minVal = attr.getMinValue() != null ? attr.getMinValue() : "";
                    String maxVal = attr.getMaxValue() != null ? attr.getMaxValue() : "";
            %>

            <div class="attribute-item custom-attr-show">
                <input type="hidden" name="attributeId" value="<%= attr.getId()%>"/>


                <!-- Category Basic Info -->
                <div class="flex items-center gap-8 mb-4">
                    <!-- Attribute Name -->
                    <div class="flex-1">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            Attribute Name <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="attributeName"
                               class="custom-input w-full"
                               value="<%= attr.getName()%>" required/>
                    </div>
                    <!-- Status -->
                    <div>
                        <label for="attributeActive" class="text-sm text-gray-700 font-medium">Status</label>
                        <select name="attributeActive" class="custom-select custom-status-select text-center" required>
                            <option value="true"  <%= attr.getIsActive() != null && attr.getIsActive() ? "selected" : ""%>>Active</option>
                            <option value="false" <%= attr.getIsActive() != null && !attr.getIsActive() ? "selected" : ""%>>Inactive</option>
                        </select>
                    </div>
                    <!-- Required Field -->
                    <div class="flex items-center gap-2">
                        <input type="checkbox" name="attributeRequired"
                               class="custom-checkbox"
                               <%= attr.getIsRequired() != null && attr.getIsRequired() ? "checked" : ""%> />
                        <label class="text-sm text-gray-700 font-medium">Required Field</label>
                    </div>
                    <!-- Delete -->
                    <button type="button"
                            class="remove-attribute attr-delete-btn ml-4"
                            title="Delete attribute">
                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                    </button>
                </div>



                <!-- Data Type + Min/Max -->
                <div class="flex items-start gap-4">
                    <div class="min-w-[200px] flex flex-col">
                        <label class="custom-label">Data Type <span class="text-red-500">*</span></label>
                        <select name="attributeDatatype" class="custom-select w-full" required>
                            <option value="">Select data type</option>
                            <option value="text"  <%= dataType.equals("text") ? "selected" : ""%>>Text</option>
                            <option value="int"   <%= dataType.equals("int") ? "selected" : ""%>>Integer</option>
                            <option value="float" <%= dataType.equals("float") ? "selected" : ""%>>Float</option>
                            <option value="date"  <%= dataType.equals("date") ? "selected" : ""%>>Date</option>
                        </select>
                    </div>

                    <div class="min-max-container flex-1 flex gap-4">
                        <% if ("int".equals(dataType) || "float".equals(dataType)) {%>
                        <div class="flex flex-col flex-1">
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">
                                <input  class="show-min-input" <%= !minVal.isEmpty() ? "checked" : ""%>> Min:
                            </label>
                            <input type="<%= "float".equals(dataType) ? "number\" step=\"0.1" : "number"%>"
                                   name="attributeMin"
                                   class="min-input custom-input w-full"
                                   style="<%= minVal.isEmpty() ? "display:none;" : ""%>"
                                   placeholder="Min Value"
                                   value="<%= minVal%>">
                        </div>

                        <div class="flex flex-col flex-1">
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">
                                <input  class="show-max-input" <%= !maxVal.isEmpty() ? "checked" : ""%>> Max:
                            </label>
                            <input type="<%= "float".equals(dataType) ? "number\" step=\"0.1" : "number"%>"
                                   name="attributeMax"
                                   class="custom-input max-input w-full"
                                   style="<%= maxVal.isEmpty() ? "display:none;" : ""%>"
                                   placeholder="Max Value"
                                   value="<%= maxVal%>">
                        </div>
                        <% } else if ("date".equals(dataType)) {%>
                        <div class="flex flex-col flex-1 min-w-[140px]">
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">
                                <input  class="custom-checkbox show-min-input" <%= !minVal.isEmpty() ? "checked" : ""%> />
                                Min date:
                            </label>
                            <input type="date" name="attributeMin"
                                   class="custom-input min-input w-ful"
                                   style="<%= minVal.isEmpty() ? "display:none;" : ""%>"
                                   value="<%= minVal%>">
                        </div>

                        <div class="flex flex-col flex-1 min-w-[140px]">
                            <label class="flex items-center gap-2 mb-1 custom-minmax-label">
                                <input  class="custom-checkbox show-max-input" <%= !maxVal.isEmpty() ? "checked" : ""%> />
                                Max date:
                            </label>
                            <input type="date" name="attributeMax"
                                   class="custom-input max-input w-full"
                                   style="<%= maxVal.isEmpty() ? "display:none;" : ""%>"
                                   value="<%= maxVal%>">
                        </div>
                        <% }%>
                    </div>
                </div>

                <!-- Unit & Status -->
                <div class="mt-2 flex items-center gap-4">
                    <label class="text-sm text-gray-700 font-medium ">Unit:</label>
                    <input type="text" name="attributeUnit"
                           class="custom-input custom-unit-input"
                           value="<%= attr.getUnit() != null ? attr.getUnit() : ""%>"
                           placeholder="eg: cm, g, % ..." />


                </div>
            </div>
            <% }%>
        </div>


        <!-- Error Message -->
        <div id="error-message" class="text-red-600 text-sm hidden"></div>

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


        <!--//============================Add attributeProduct=============================================================-->

        <button type="button"
                class="openAddAttributeProduct custom-btn-main"  style="gap:10px;font-size:15px;">

            <i data-lucide="diamond-plus" class="w-5 h-5"></i>
            <span>Add Attribute Product</span>
        </button>

        <!-- Attributes Container -->
        <div id="attributes-container" class="mt-4 space-y-4">
            <c:forEach var="attr" items="${attributes}">

            </c:forEach>
        </div>

        <!-- TEMPLATE COUNT -->
        <div id="attributes-container-template" class="hidden">



            <!-- TEMPLATE ITEM -->
            <div id="attribute-item-template" class="hidden">
                <div id="main-attribute-item" class="custom-attr-item">
                    <!--  hidden input cho attributeId -->
                    <input type="hidden" name="attributeId" value="0"/>


                    <!--  Delete -->
                    <button type="button"
                            class="remove-attribute attr-delete-btn"
                            title="Delete attribute">
                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                    </button>

                    <!-- Attribute Name -->
                    <div class="flex items-center mb-3 gap-4 pr-32">
                        <div class="flex-1">
                            <label class="custom-label">
                                Attribute Name <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="attributeName"
                                   class="custom-input w-full" placeholder="Enter new attribute name" required>
                        </div>
                        <div class="flex items-center space-x-2 ml-4">
                            <input type="checkbox" name="attributeRequired" class="custom-checkbox" checked>
                            <label class="text-sm text-gray-700 font-medium">Required Field</label>
                        </div>
                    </div>

                    <!-- Data Type + Min/Max -->
                    <div class="flex items-start gap-4 pr-32">
                        <div class="min-w-[200px] flex flex-col">
                            <label class="custom-label">Data Type <span class="text-red-500">*</span></label>
                            <select name="attributeDatatype" class="w-[200px] px-3 py-2 border rounded-lg" required>
                                <option value="">Select data type</option>
                                <option value="text">Text</option>
                                <option value="int">Integer</option>
                                <option value="float">Float</option>
                                <option value="date">Date</option>
                            </select>
                        </div>
                        <div class="min-max-container flex gap-4 flex-1"></div>
                    </div>

                    <!-- Unit -->
                    <div class="mt-2">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Unit (optional):</label>
                        <input type="text" name="attributeUnit"
                               class="custom-input custom-unit-input" placeholder="eg: cm, g, % ...">
                    </div>
                </div>
            </div>
        </div>

        <!-- TEMPLATE MIN/MAX-->
        <div id="int-template" class="hidden">
            <div class="flex gap-4 w-full">
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1 custom-minmax-label"><input type="checkbox" class="show-min-input">Min:</label>
                    <input type="number" name="attributeMin" class="min-input custom-input w-full" style="display:none;" placeholder="Min Value">
                </div>
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1 custom-minmax-label"><input type="checkbox" class="show-max-input">Max:</label>
                    <input type="number" name="attributeMax" class="max-input custom-input w-full" style="display:none;" placeholder="Max Value">
                </div>
            </div>
        </div>
        <div id="float-template" class="hidden">
            <div class="flex gap-4 w-full">
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1 custom-minmax-label"><input type="checkbox"  class="show-min-input">Min:</label>
                    <input type="number" name="attributeMin" class="min-input custom-input w-full" step="0.1" style="display:none;" placeholder="Min Value">
                </div>
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1 custom-minmax-label"><input type="checkbox" class="show-max-input">Max:</label>
                    <input type="number" name="attributeMax" class="max-input custom-input w-full" step="0.1" style="display:none;" placeholder="Max Value">
                </div>
            </div>
        </div>

        <div id="date-template" class="hidden">
            <div class="flex flex-row gap-4 w-full">
                <!-- Min date -->
                <div class="flex flex-col flex-1 min-w-[140px]">
                    <div class="flex items-center gap-2 mb-1">
                        <input type="checkbox" class="show-min-input h-4 w-4" />
                        <label class="flex items-center gap-2 mb-1 custom-minmax-label">Min date:</label>
                    </div>
                    <input type="date" name="attributeMin"
                           class="min-input custom-input w-full"
                           placeholder="Min date" style="display:none;" />
                </div>
                <!-- Max date -->
                <div class="flex flex-col flex-1 min-w-[140px]">
                    <div class="flex items-center gap-2 mb-1">
                        <input type="checkbox" class="show-max-input h-4 w-4" />
                        <label class="flex items-center gap-2 mb-1 custom-minmax-label">Max date:</label>
                    </div>
                    <input type="date" name="attributeMax"
                           class="max-input custom-input w-full"
                           placeholder="Max date" style="display:none;" />
                </div>
            </div>
        </div>

        <!-- Add attributeProduct-->

    </div>

</div>

