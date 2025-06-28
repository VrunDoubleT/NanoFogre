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


<!-- Modal Background -->
<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">

    <!-- Header Section -->
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center rounded-t-xl">

        <h2 class="text-2xl font-bold text-white">Edit Category</h2>
        <form id="edit-category-form" enctype="multipart/form-data">
            <!-- Action Buttons -->
            <div class="flex items-center space-x-4">
                <button
                    type="submit"
                    id="update-category-btn"
                    class="px-4 flex py-2 bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all"
                    >
                    <i data-lucide="pencil" class="mr-1"></i>
                    <span>Update</span>
                </button>
            </div>
        </form>
    </div>

    <!-- Form Section -->
    <div class="p-8 h-full w-full overflow-y-auto ">

        <!-- Hidden Input -->
        <input type="hidden" id="categoryId" value="<%= category.getId()%>" />

        <!-- Category Name Input -->
        <div class="mb-3">
            <label for="categoryName" class="block text-sm font-semibold text-gray-700 mb-1">Category Name</label>
            <input
                type="text"
                id="categoryName"
                value="<%= category.getName()%>"
                class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                required
                />
            <span id="categoryNameError" class="text-red-500 text-sm"></span>
        </div>


        <!-- avater curent -->
        <div class="mb-3"> 
            <label class="block text-sm font-semibold text-gray-700 mb-1">Category Image Current</label>
            <div class="flex justify-center">

                <div class="relative">
                    <img
                        src="<%= imageUrl%>"
                        alt="Category Avatar"
                        class="h-36 w-36 rounded-full object-cover border-4 border-white shadow-lg ring-2 ring-blue-200 transition-all duration-300"
                        style="background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);"
                        />
                </div>
            </div>
        </div>


        <!-- Upload input -->
        <div class="mb-4">
            <label class="block text-sm font-semibold text-gray-700 mb-1">Category Image</label>

            <div id="image-preview" class="flex justify-center mb-3">
                <img src="<%= imageUrl%>" id="category-image-preview-tag"
                     class="h-32 w-32 object-cover rounded-full border border-gray-200 shadow"
                     alt="Category Image Preview"
                     hidden=""/>
            </div>
            <!-- Upload input -->
            <input type="file"
                   id="categoryImage"
                   name="categoryImage"
                   accept="image/*"
                   class="hidden" />
            <label for="categoryImage"
                   class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 5MB)</span>
            </label>
            <p id="categoryImageError" class="text-red-500 text-sm mt-1"></p>
        </div>

        <!--//=========================================================================================-->
        <!-- Add attributeProduct-->

        <button type="button"
                class="openAddAttributeProduct bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg flex items-center gap-2">
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
                <div id="main-attribute-item" class="hidden border border-gray-200 rounded-lg p-4 mb-4 bg-gray-50 relative">
                    <!--  hidden input cho attributeId -->
                    <input type="hidden" name="attributeId" value="0"/>



                    <!--  Delete -->
                    <button type="button"
                            class="remove-attribute absolute pt-[38px]  right-4 -translate-y-1/2 text-red-500 hover:text-red-700 transition-colors flex items-center gap-1 px-3 py-1 rounded"
                            title="Delete attribute">
                        <i data-lucide="x" class="w-5 h-5"></i> Delete
                    </button>

                    <!-- Attribute Name -->
                    <div class="flex items-center mb-3 gap-4 pr-32">
                        <div class="flex-1">
                            <label class="block text-sm font-semibold text-gray-700 mb-1">
                                Attribute Name <span class="text-red-500">*</span>
                            </label>
                            <input type="text" name="attributeName"
                                   class="w-full px-3 py-2 border rounded-lg" placeholder="Enter new attribute name" required>
                        </div>
                        <div class="flex items-center space-x-2 ml-4">
                            <input type="checkbox" name="attributeRequired" class="h-4 w-4 text-blue-600" checked>
                            <label class="text-sm text-gray-700">Required Field</label>
                        </div>
                    </div>

                    <!-- Data Type + Min/Max -->
                    <div class="flex items-start gap-4 pr-32">
                        <div class="min-w-[200px] flex flex-col">
                            <label class="block text-sm font-semibold text-gray-700 mb-1">
                                Data Type <span class="text-red-500">*</span>
                            </label>
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
                               class="w-[222px] px-3 py-1 border rounded-lg" placeholder="eg: cm, g, % ...">
                    </div>
                </div>
            </div>
        </div>

        <!-- TEMPLATE MIN/MAX-->
        <div id="int-template" class="hidden">
            <div class="flex gap-4 w-full">
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1"><input type="checkbox" class="show-min-input">Min:</label>
                    <input type="number" name="attributeMin" class="min-input w-full px-3 py-2 border rounded-lg" style="display:none;" placeholder="Min Value">
                </div>
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1"><input type="checkbox" class="show-max-input">Max:</label>
                    <input type="number" name="attributeMax" class="max-input w-full px-3 py-2 border rounded-lg" style="display:none;" placeholder="Max Value">
                </div>
            </div>
        </div>
        <div id="float-template" class="hidden">
            <div class="flex gap-4 w-full">
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1"><input type="checkbox"  class="show-min-input">Min:</label>
                    <input type="number" name="attributeMin" class="min-input w-full px-3 py-2 border rounded-lg" step="0.1" style="display:none;" placeholder="Min Value">
                </div>
                <div class="flex flex-col flex-1">
                    <label class="flex items-center gap-2 mb-1"><input type="checkbox" class="show-max-input">Max:</label>
                    <input type="number" name="attributeMax" class="max-input w-full px-3 py-2 border rounded-lg" step="0.1" style="display:none;" placeholder="Max Value">
                </div>
            </div>
        </div>
        <div id="text-template" class="hidden">
            <div class="flex flex-col">
                <label class="mb-1">Text value:</label>
                <input type="text" name="attributeTextValue" class="px-3 py-2 border rounded-lg" placeholder="Enter text value">
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

        <!-- Add attributeProduct-->

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

        <!--/////////////////////////////////////////////////////////////////////////////////////////////////////////-->

        <div id="attributes-container" class="mt-4 space-y-4">
            <% for (ProductAttribute attr : attributes) {
                    String dataType = attr.getDataType();
                    String minVal = attr.getMinValue() != null ? attr.getMinValue() : "";
                    String maxVal = attr.getMaxValue() != null ? attr.getMaxValue() : "";
            %>

            <div class="attribute-item border border-gray-200 rounded-lg p-4 mb-4 bg-gray-50 relative">
                <input type="hidden" name="attributeId" value="<%= attr.getAttributeId()%>"/>

                <div class="flex items-center mb-3 gap-4 pr-32">
                    <div class="flex-1">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">
                            Attribute Name <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="attributeName"
                               class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400"
                               value="<%= attr.getAttributeName()%>" required/>
                    </div>
                    <div class="flex items-center space-x-2 ml-4">
                        <input type="checkbox" name="attributeRequired"
                               class="h-4 w-4 text-blue-600 border-gray-300 rounded"
                               <%= attr.getIsRequired() != null && attr.getIsRequired() ? "checked" : ""%> />
                        <label class="text-sm text-gray-700 font-medium">Required Field</label>
                    </div>

                    <!--  Delete -->
                    <button type="button"
                            class="remove-attribute absolute  right-4 -translate-y-1/2 text-red-500 hover:text-red-700 transition-colors flex items-center gap-1 px-3 py-1 rounded"
                            title="Delete attribute">
                        <i data-lucide="x" class="w-5 h-5"></i> Delete
                    </button>
                </div>

                <!-- Data Type + Min/Max -->
                <div class="flex items-start gap-4">
                    <div class="min-w-[200px]">
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Data Type <span class="text-red-500">*</span></label>
                        <select name="attributeDatatype" class="w-full px-3 py-2 border rounded-lg" required>
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
                            <label class="flex items-center gap-2 mb-1">
                                <input  class="show-min-input" <%= !minVal.isEmpty() ? "checked" : ""%>> Min:
                            </label>
                            <input type="<%= "float".equals(dataType) ? "number\" step=\"0.1" : "number"%>"
                                   name="attributeMin"
                                   class="min-input w-full px-3 py-2 border rounded-lg"
                                   style="<%= minVal.isEmpty() ? "display:none;" : ""%>"
                                   placeholder="Min Value"
                                   value="<%= minVal%>">
                        </div>

                        <div class="flex flex-col flex-1">
                            <label class="flex items-center gap-2 mb-1">
                                <input  class="show-max-input" <%= !maxVal.isEmpty() ? "checked" : ""%>> Max:
                            </label>
                            <input type="<%= "float".equals(dataType) ? "number\" step=\"0.1" : "number"%>"
                                   name="attributeMax"
                                   class="max-input w-full px-3 py-2 border rounded-lg"
                                   style="<%= maxVal.isEmpty() ? "display:none;" : ""%>"
                                   placeholder="Max Value"
                                   value="<%= maxVal%>">
                        </div>
                        <% } else if ("date".equals(dataType)) {%>
                        <div class="flex flex-col flex-1 min-w-[140px]">
                            <label class="flex items-center gap-2 mb-1">
                                <input  class="show-min-input h-4 w-4" <%= !minVal.isEmpty() ? "checked" : ""%> />
                                Min date:
                            </label>
                            <input type="date" name="attributeMin"
                                   class="min-input w-full px-3 py-2 border rounded-lg"
                                   style="<%= minVal.isEmpty() ? "display:none;" : ""%>"
                                   value="<%= minVal%>">
                        </div>

                        <div class="flex flex-col flex-1 min-w-[140px]">
                            <label class="flex items-center gap-2 mb-1">
                                <input  class="show-max-input h-4 w-4" <%= !maxVal.isEmpty() ? "checked" : ""%> />
                                Max date:
                            </label>
                            <input type="date" name="attributeMax"
                                   class="max-input w-full px-3 py-2 border rounded-lg"
                                   style="<%= maxVal.isEmpty() ? "display:none;" : ""%>"
                                   value="<%= maxVal%>">
                        </div>
                        <% } else if ("text".equals(dataType)) { %>
                        <div class="flex flex-col w-full">
                            <label class="mb-1">Text value:</label>
                            <input type="text" name="attributeTextValue"
                                   class="px-3 py-2 border rounded-lg"
                                   placeholder="Enter text value">
                        </div>
                        <% }%>
                    </div>
                </div>

                <!-- Unit & Status -->
                <div class="mt-2 flex items-center gap-4">
                    <label class="text-sm text-gray-700 font-medium ">Unit:</label>
                    <input type="text" name="attributeUnit"
                           class="w-[222px] px-3 py-1 border rounded-lg"
                           value="<%= attr.getUnit() != null ? attr.getUnit() : ""%>"
                           placeholder="eg: cm, g, % ..." />

                    <div class="flex items-center gap-2 ml-4">
                        <label for="attributeActive" class="text-sm text-gray-700 font-medium ">Status</label>
                        <select name="attributeActive" class="w-[133px] px-3 py-1 border rounded-lg text-center" required>
                            <option value="true"  <%= attr.getIsActive() != null && attr.getIsActive() ? "selected" : ""%>>Active</option>
                            <option value="false" <%= attr.getIsActive() != null && !attr.getIsActive() ? "selected" : ""%>>Inactive</option>
                        </select>
                    </div>
                </div>
            </div>
            <% }%>
        </div>



    </div>

</div>

