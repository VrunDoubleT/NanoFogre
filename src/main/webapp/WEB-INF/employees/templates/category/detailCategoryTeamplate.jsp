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

<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
    * {
        font-family: 'Inter', sans-serif;
    }
    .gradient-header {
        background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 50%, #ec4899 100%);
        position: relative;
        overflow: hidden;
    }
    .gradient-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(45deg, rgba(255,255,255,0.07) 0%, transparent 50%);
        animation: shimmer 3s ease-in-out infinite;
        z-index:0;
    }
    @keyframes shimmer {
        0%,100% {
            transform:translateX(-100%);
        }
        50% {
            transform:translateX(100%);
        }
    }
    .category-card {
        background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        border-radius: 20px;
        box-shadow: 0 25px 50px -12px rgba(0,0,0,0.10);
        border: 1px solid rgba(255,255,255,0.18);
        backdrop-filter: blur(10px);
        overflow: hidden;
    }
    .avatar-container {
        position: relative;
        background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
        border-radius: 50%;
        padding: 8px;
        box-shadow: 0 20px 40px rgba(59,130,246,0.3);
    }
    .avatar-container::before {
        content: '';
        position: absolute;
        inset: -4px;
        background: linear-gradient(45deg, #3b82f6, #8b5cf6, #ec4899, #3b82f6);
        border-radius: 50%;
        z-index: -1;
        animation: rotate 3s linear infinite;
    }
    @keyframes rotate {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }
    .info-card {
        background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
        position: relative;
        overflow: hidden;
    }
    .info-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg,#3b82f6,#8b5cf6);
        border-radius: 2px;
        transform: scaleX(0);
        transition: transform 0.3s ease;
    }

    .attribute-card {
        background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%);
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    .attribute-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background: linear-gradient(180deg, #10b981, #059669);
        transform: scaleY(0);
        transition: transform 0.3s ease;
    }

    .status-badge {
        position:relative;
        padding:6px 12px;
        border-radius:20px;
        font-weight:600;
        font-size:12px;
        text-transform:uppercase;
        letter-spacing:0.5px;
    }
    .status-active {
        background:linear-gradient(135deg,#10b981 0%,#059669 100%);
        color:white;
        box-shadow:0 4px 12px rgba(16,185,129,0.4);
    }
    .status-inactive {
        background:linear-gradient(135deg,#ef4444 0%,#dc2626 100%);
        color:white;
        box-shadow:0 4px 12px rgba(239,68,68,0.4);
    }
    .required-badge {
        background:linear-gradient(135deg,#f59e0b 0%,#d97706 100%);
        color:white;
        padding:4px 8px;
        border-radius:12px;
        font-size:10px;
        font-weight:700;
        display:flex;
        align-items:center;
        gap:2px;
        box-shadow:0 2px 8px rgba(245,158,11,0.3);
    }
    .section-title {
        background:linear-gradient(135deg,#1f2937 0%,#374151 100%);
        -webkit-background-clip:text;
        -webkit-text-fill-color:transparent;
        background-clip:text;
        position:relative;
    }
    .section-title::after {
        content:'';
        position:absolute;
        bottom:-8px;
        left:0;
        width:60px;
        height:4px;
        background:linear-gradient(90deg,#3b82f6,#8b5cf6);
        border-radius:2px;
    }
    .glassmorphism {
        background: rgba(255,255,255,0.25);
        backdrop-filter:blur(10px);
        border:1px solid rgba(255,255,255,0.18);
    }

</style>

<div class="bg-gray-100 w-[820px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="bg-gradient-to-r from-blue-600 to-purple-600 px-8 py-4 flex justify-between items-center rounded-t-xl">

        <div class="flex items-center gap-4">
            <div class="glassmorphism rounded-xl p-3">
                <i data-lucide="folder" class="w-8 h-8 text-white"></i>
            </div>
            <div>
                <h1 class="text-3xl font-bold text-white mb-1">Category Details</h1>

            </div>
        </div>
        <div class="glassmorphism rounded-xl px-4 py-2">
            <span class="text-white text-sm font-medium">ID: #<%=category.getId()%></span>
        </div>

    </div>

    <div class="p-8 h-full w-full overflow-y-auto ">

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
            <div class="text-center slide-up" style="animation-delay: 0.1s;">
                <div class="info-card p-6 max-w-md mx-auto">
                    <div class="flex items-center justify-center gap-2 mb-2">
                        <i data-lucide="tag" class="w-5 h-5 text-blue-600"></i>
                        <span class="text-sm font-medium text-gray-500 uppercase tracking-wide">Category Name</span>
                    </div>
                    <h2 class="text-2xl font-bold text-gray-800">
                        <%= category.getName() != null && !category.getName().isEmpty() ? category.getName() : "None"%>
                    </h2>
                </div>
            </div>


            <!-- Category Info -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 slide-up" style="animation-delay: 0.2s;">
                <div class="info-card p-6 text-center">
                    <div class="flex items-center justify-center gap-2 mb-3">
                        <i data-lucide="hash" class="w-5 h-5 text-purple-600"></i>
                        <span class="text-sm font-medium text-gray-500 uppercase tracking-wide">Category ID</span>
                    </div>
                    <p class="text-xl font-bold text-gray-800">#<%=category.getId()%></p>
                </div>
                <div class="info-card p-6 text-center">
                    <div class="flex items-center justify-center gap-2 mb-3">
                        <i data-lucide="activity" class="w-5 h-5 text-green-600"></i>
                        <span class="text-sm font-medium text-gray-500 uppercase tracking-wide">Status</span>
                    </div>
                    <span class="status-badge <%=category.isIsActive() ? "status-active" : "status-inactive"%>">
                        <%=category.isIsActive() ? "Active" : "Inactive"%>
                    </span>
                </div>
            </div>

            <!-- Attributes Section -->
            <div class="slide-up" style="animation-delay: 0.3s;">
                <div class="flex items-center gap-3 mb-6">
                    <i data-lucide="list" class="w-6 h-6 text-blue-600"></i>
                    <h3 class="section-title text-2xl font-bold">Product Attributes</h3>
                </div>
                <div class="space-y-4" id="attributes-container">
                    <% if (attributes == null || attributes.isEmpty()) { %>
                    <div class="text-center py-12" id="no-attributes">
                        <div class="bg-gray-50 rounded-2xl p-8 max-w-md mx-auto">
                            <div class="bg-gray-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
                                <i data-lucide="inbox" class="w-8 h-8 text-gray-400"></i>
                            </div>
                            <h3 class="text-lg font-semibold text-gray-600 mb-2">No Attributes Defined</h3>
                            <p class="text-gray-500 text-sm">This category doesn't have any attributes yet.</p>
                        </div>
                    </div>
                    <% } else { %>
                    <% for (ProductAttribute attr : attributes) {%>
                    <div class="attribute-card p-6">
                        <div class="flex justify-between items-start mb-4">
                            <div class="flex items-center gap-3">
                                <div class="bg-blue-100 text-blue-600 rounded-lg p-2">
                                    <i data-lucide="type" class="w-5 h-5"></i>
                                </div>
                                <div>
                                    <span class="text-xs font-medium text-gray-500 uppercase tracking-wide">Attribute Name</span>
                                    <h4 class="text-lg font-semibold text-gray-800 capitalize"><%= attr.getName()%></h4>
                                </div>
                            </div>
                            <% if (attr.getIsRequired() != null && attr.getIsRequired()) { %>
                            <div class="required-badge">
                                <span>Required</span>
                                <span>*</span>
                            </div>
                            <% }%>
                        </div>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                            <div class="bg-gray-50 rounded-lg p-3">
                                <span class="font-medium text-gray-600">Type:</span>
                                <p class="font-semibold text-gray-800 mt-1"><%= attr.getDataType()%></p>
                            </div>
                            <div class="bg-gray-50 rounded-lg p-3">
                                <span class="font-medium text-gray-600">Min:</span>
                                <p class="font-semibold text-gray-800 mt-1">
                                    <%= attr.getMinValue() != null ? attr.getMinValue() : "—"%>
                                </p>
                            </div>
                            <div class="bg-gray-50 rounded-lg p-3">
                                <span class="font-medium text-gray-600">Max:</span>
                                <p class="font-semibold text-gray-800 mt-1">
                                    <%= attr.getMaxValue() != null ? attr.getMaxValue() : "—"%>
                                </p>
                            </div>
                            <div class="bg-gray-50 rounded-lg p-3">
                                <span class="font-medium text-gray-600">Unit:</span>
                                <p class="font-semibold text-gray-800 mt-1">
                                    <%= (attr.getUnit() != null) ? attr.getUnit() : "—"%>
                                </p>
                            </div>
                        </div>
                        <div class="mt-4 flex justify-between items-center">
                            <span class="status-badge <%=attr.getIsActive() ? "status-active" : "status-inactive"%>">
                                <%=attr.getIsActive() ? "Active" : "Inactive"%>
                            </span>
                        </div>
                    </div>
                    <% } %>
                    <% }%>
                </div>
            </div>


        </div>
    </div>
</div>
