<%-- 
    Document   : Purchase
    Created on : Jul 8, 2025, 1:58:17 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Cart" %>
<%@ page import="Models.Customer" %>
<%@ page import="Models.Product" %>
<%@ page import="Models.Voucher" %>
<%@ page import="Models.Address" %>
<%@ page import="Utils.CurrencyFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<Cart> selectedItems = (List<Cart>) request.getAttribute("selectedItems");
    Address address = (Address) request.getAttribute("address");
    Voucher voucher = (Voucher) request.getAttribute("voucher");
    List<Voucher> availableVouchers = (List<Voucher>) request.getAttribute("availableVouchers");
    String cartIdsJson = (String) request.getAttribute("cartIdsJson");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");

    if (cartIdsJson == null || cartIdsJson.isEmpty()) {
        cartIdsJson = "[]";
    }

    double subtotal = 0;
    int totalItems = 0;
    if (selectedItems != null) {
        for (Cart cart : selectedItems) {
            subtotal += cart.getQuantity() * cart.getProduct().getPrice();
            totalItems += cart.getQuantity();
        }
    }

    double discount = 0;
    String voucherDescription = "";
    if (voucher != null) {
        if (voucher.getType().equals("percentage")) {
            discount = subtotal * (voucher.getValue() / 100.0);
            if (voucher.getMaxValue() > 0 && discount > voucher.getMaxValue()) {
                discount = voucher.getMaxValue();
            }
        } else {
            discount = voucher.getValue();
        }
        voucherDescription = voucher.getDescription();
    }

    double shippingFee = subtotal >= 500_000 ? 0 : 40_000;
    double total = subtotal - discount + shippingFee;
    if (total < 0) {
        total = 0;
    }

    // Check if customer info is complete
    boolean isPhoneComplete = (customer != null && customer.getPhone() != null && !customer.getPhone().trim().isEmpty());
    boolean isAddressComplete = (address != null && address.getFullAddress() != null && !address.getFullAddress().trim().isEmpty());
    boolean canPurchase = isPhoneComplete && isAddressComplete;

    // Format current date and time
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    String currentDateTime = now.format(formatter);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Purchase Confirmation</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!-- ở trong <head> hoặc ngay trước </body> -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Buttons cơ bản */
            .btn-primary {
                background: linear-gradient(135deg, #4f46e5 0%, #9333ea 100%);
                transition: all 0.25s ease;
                box-shadow: 0 4px 6px rgba(79, 70, 229, 0.4);
            }
            .btn-primary:hover:not(.btn-disabled) {
                transform: translateY(-3px);
                box-shadow: 0 12px 20px rgba(79, 70, 229, 0.6);
            }
            .btn-success {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                transition: all 0.25s ease;
                box-shadow: 0 4px 6px rgba(16, 185, 129, 0.4);
            }
            .btn-success:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 20px rgba(16, 185, 129, 0.6);
            }
            .btn-disabled {
                background: #9ca3af;
                cursor: not-allowed;
                box-shadow: none !important;
                transform: none !important;
                opacity: 0.7;
            }

            /* Fade-in chung */
            .animate-fade-in {
                animation: fadeIn 0.5s ease forwards;
                opacity: 0;
            }
            @keyframes fadeIn {
                to {
                    opacity: 1;
                    transform: none;
                }
            }

            /* Success message */
            .success-message {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
                border-radius: 10px;
                padding: 18px 22px;
                margin: 20px 0;
                border-left: 6px solid #10b981;
                font-weight: 700;
                box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);
            }

            /* Trường bắt buộc */
            .required-field {
                border: 2px solid #fbbf24 !important;
                background-color: #fffbeb !important;
            }

            /* Ảnh sản phẩm */
            .product-image {
                width: 90px;
                height: 90px;
                object-fit: cover;
                border-radius: 12px;
                border: 2px solid #e0e7ff;
                transition: transform 0.3s ease;
            }
            .product-image:hover {
                transform: scale(1.05);
                border-color: #7c3aed;
            }

            /* Modal confirm */
            .modal {
                display: none;
                position: fixed;
                inset: 0;
                background-color: rgba(0, 0, 0, 0.55);
                z-index: 1050;
                overflow-y: auto;
            }
            .modal-content {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 28px 30px;
                border-radius: 16px;
                max-width: 540px;
                width: 95%;
                max-height: 85vh;
                overflow-y: auto;
                box-shadow: 0 20px 40px rgba(0,0,0,0.2);
                font-size: 1rem;
                color: #333;
            }

            /* Scrollbar addresses */
            #addressesList {
                max-height: 300px;
                overflow-y: auto;
                scrollbar-width: thin;
                scrollbar-color: #a78bfa transparent;
            }
            #addressesList::-webkit-scrollbar {
                width: 8px;
            }
            #addressesList::-webkit-scrollbar-track {
                background: transparent;
            }
            #addressesList::-webkit-scrollbar-thumb {
                background-color: #a78bfa;
                border-radius: 20px;
                border: 2px solid transparent;
            }

            /* Responsive nhỏ */
            @media (max-width: 640px) {
                body {
                    font-size: 14px;
                }
                .product-image {
                    width: 70px;
                    height: 70px;
                }
            }

            /* Glassmorphism card */
            .glass-card {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }

            /* Slide-in & pulse-glow */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(-30px);
                }
                to   {
                    opacity: 1;
                    transform: translateX(0);
                }
            }
            @keyframes pulse-glow {
                0%,100% {
                    box-shadow: 0 0 20px rgba(99,102,241,0.3);
                }
                50%     {
                    box-shadow: 0 0 30px rgba(99,102,241,0.5);
                }
            }
            .animate-fade-in-up {
                animation: fadeInUp 0.8s ease-out;
            }
            .animate-slide-in   {
                animation: slideIn 0.6s ease-out;
            }
            .animate-pulse-glow {
                animation: pulse-glow 2s infinite;
            }

            /* Button hiện đại */
            .btn-modern {
                position: relative;
                overflow: hidden;
                transition: all 0.3s ease;
            }
            .btn-modern::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s ease;
            }
            .btn-modern:hover::before {
                left: 100%;
            }
            .btn-primary-modern {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                box-shadow: 0 4px 15px rgba(102,126,234,0.4);
            }
            .btn-primary-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102,126,234,0.6);
            }
            .btn-success-modern {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
                box-shadow: 0 4px 15px rgba(17,153,142,0.4);
            }
            .btn-success-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(17,153,142,0.6);
            }

            /* Card hiện đại */
            .modern-card {
                border-radius: 20px;
                transition: all 0.3s ease;
                border: 1px solid rgba(255,255,255,0.1);
            }
            .modern-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }

            /* Product card */
            .product-card {
                background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(255,255,255,0.8));
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255,255,255,0.2);
                transition: all 0.3s ease;
            }
            .product-card:hover {
                transform: scale(1.02);
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            }

            /* Voucher card (phiên bản cuối) */
            .voucher-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-radius: 16px;
                padding: 20px;
                color: white;
                position: relative;
                overflow: hidden;
            }
            .voucher-card::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
                animation: shimmer 3s infinite;
            }
            @keyframes shimmer {
                0%   {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Input hiện đại */
            .modern-input {
                background: rgba(255,255,255,0.9);
                border: 2px solid rgba(255,255,255,0.3);
                border-radius: 12px;
                padding: 12px 16px;
                transition: all 0.3s ease;
            }
            .modern-input:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
                background: rgba(255,255,255,1);
            }

            /* Media (small) */
            @media (max-width: 768px) {
                .container {
                    padding: 1rem;
                }
                .modern-card {
                    border-radius: 16px;
                }
                .btn-modern {
                    padding: 12px 24px;
                    font-size: 14px;
                }
            }
            /* Viền xanh khi valid */
            .valid-field {
                border-width: 2px !important;
                border-color: #10b981 !important; /* xanh lá */
            }
            /* Viền đỏ khi invalid */
            .invalid-field {
                border-width: 2px !important;
                border-color: #ef4444 !important; /* đỏ */
            }
            body.modal-open {
                overflow: hidden !important;
                touch-action: none;
                overscroll-behavior: contain;
            }
        </style>


    </head>

    <body class="min-h-screen bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-50">
        <jsp:include page="../common/header.jsp" />
        <main class="container mx-auto max-w-6xl px-4 py-8">
            <div class="w-full h-full overflow-auto px-4 py-8">
                <!-- Header -->
                <div class="text-center mb-8 mt-8 animate-fade-in">
                    <h1 class="text-4xl md:text-5xl font-bold text-black mb-2">
                        <i class="fas fa-shopping-cart mr-3"></i>
                        Purchase Confirmation
                    </h1>
                    <p class="text-black/80 text-lg">Complete your order information</p>
                </div>

                <!-- Success Message -->
                <% if (successMessage != null && !successMessage.isEmpty()) {%>
                <div class="success-message animate-fade-in">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle mr-3 text-2xl"></i>
                        <div>
                            <h3 class="font-bold text-lg">Order Placed Successfully!</h3>
                            <p class="mt-1"><%= successMessage%></p>
                        </div>
                    </div>
                    <div class="mt-4 flex gap-4">
                        <a href="<%= request.getContextPath()%>/customer/orders" 
                           class="bg-white text-green-600 px-4 py-2 rounded-lg font-medium hover:bg-gray-100 transition-colors">
                            <i class="fas fa-list mr-2"></i>View Orders
                        </a>
                        <a href="<%= request.getContextPath()%>/products" 
                           class="bg-white/20 text-white px-4 py-2 rounded-lg font-medium hover:bg-white/30 transition-colors">
                            <i class="fas fa-shopping-bag mr-2"></i>Continue Shopping
                        </a>
                    </div>
                </div>
                <% }%>
            </div>
            <!-- Main Content -->

            <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">

                <!-- Left Column - Customer Info & Products -->
                <div class="xl:col-span-2 space-y-8">
                    <!-- Customer Information Section -->
                    <!-- Fixed Purchase.jsp HTML Structure -->
                    <section id="customerInfoSection" class="modern-card glass-card p-8 animate-slide-in">
                        <!-- Header -->
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center">
                                <div class="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center mr-4">
                                    <i class="fas fa-user text-white text-lg"></i>
                                </div>
                                <div>
                                    <h2 class="text-2xl font-bold text-gray-800">Customer Information</h2>
                                    <p class="text-gray-600">Your personal and delivery details</p>
                                </div>
                            </div>

                            <button
                                id="toggleAddressesBtn"
                                class="p-2 rounded-lg hover:bg-gray-100 transition-colors"
                                onclick="toggleAddresses()">
                                <i id="addressesChevron"  class="fas fa-chevron-down text-gray-500"></i>
                            </button>
                        </div>


                        <div id="basicInfo" class="space-y-6">
                            <!-- Full Name -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="space-y-2">
                                    <label class="text-sm font-medium text-gray-700">Full Name</label>
                                    <input type="text" readonly value="<%= customer.getName()%>"
                                           class="modern-input w-full" />
                                </div>
                                <div class="space-y-2">
                                    <label class="text-sm font-medium text-gray-700">Email</label>
                                    <input type="email" readonly value="<%= customer.getEmail()%>"
                                           class="modern-input w-full" />
                                </div>
                            </div>

                            <!-- Fixed Currently Selected Address -->
                            <div id="selectedAddressCard"
                                 class="glass-card p-4 rounded-2xl border border-gray-200 transition-shadow hover:shadow-lg flex justify-between items-start bg-white/80 backdrop-blur-sm">
                                <% if (address != null) {%>
                                <label class="flex items-start space-x-4 flex-1 cursor-pointer">
                                    <input type="radio"
                                           name="selectedAddress"
                                           value="<%= address.getId()%>"
                                           checked
                                           class="h-5 w-5 text-indigo-600 accent-indigo-500 mt-1" />
                                    <div>
                                        <p class="font-semibold text-gray-800 text-lg"><%= address.getName()%></p>
                                        <div class="text-sm text-gray-600 mt-1 space-y-1">
                                            <p><i class="fas fa-phone mr-2 text-indigo-500"></i><%= address.getPhone()%></p>
                                            <p><i class="fas fa-user mr-2 text-indigo-500"></i><%= address.getRecipientName()%></p>
                                            <p><i class="fas fa-location-dot mr-2 text-indigo-500"></i><%= address.getDetails()%></p>
                                        </div>
                                    </div>
                                </label>
                                <!-- Nút thay đổi địa chỉ -->
                                <button onclick="toggleAddresses()"
                                        class="ml-4 flex-shrink-0 text-indigo-600 hover:text-indigo-800 transition-colors">

                                    <span>Change Address</span>
                                </button>
                                <% } else { %>
                                <div class="flex items-center space-x-3 flex-1">
                                    <i class="fas fa-exclamation-circle text-red-500 text-xl"></i>
                                    <p class="text-red-600 font-medium">Please add a delivery address.</p>
                                </div>
                                <button onclick="toggleAddresses()"
                                        class="ml-4 flex-shrink-0 text-indigo-600 hover:text-indigo-800 transition-colors">
                                    <i class="fas fa-chevron-down"></i>
                                </button>
                                <% }%>
                            </div>


                        </div>

                        <!-- Delivery Addresses -->
                        <div id="addressesSection" class="hidden bg-white p-6 space-y-8">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="text-xl font-semibold text-gray-800">
                                    <i class="fas fa-map-marker-alt text-indigo-600 mr-2"></i>
                                    Delivery Addresses
                                </h3>
                                <button
                                    id="addAddressBtn"
                                    class="btn-success inline-flex items-center px-4 py-2 rounded-lg"
                                    type="button">
                                    <i class="fas fa-plus mr-2"></i>Add New
                                </button>
                            </div>

                            <!-- Fixed Addresses List -->
                            <div id="addressesList" class="space-y-4">
                                <c:choose>
                                    <c:when test="${empty availableAddresses}">
                                        <p class="text-gray-600">Please add delivery address.</p>
                                        <button id="addAddressBtn" class="btn-success inline-flex items-center px-4 py-2 rounded-lg" type="button">
                                            <i class="fas fa-plus mr-2"></i>Add New
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="addr" items="${availableAddresses}">
                                            <div class="address-item group flex items-start justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 hover:bg-white hover:shadow-md transition-all ${addr.equals(address) ? 'ring-2 ring-indigo-400 bg-white' : ''}"
                                                 data-address-id="${addr.id}"
                                                 data-name="${fn:escapeXml(addr.name)}"
                                                 data-recipient="${fn:escapeXml(addr.recipientName)}"
                                                 data-phone="${fn:escapeXml(addr.phone)}"
                                                 data-details="${fn:escapeXml(addr.details)}">
                                                <div class="flex-1">
                                                    <div class="flex items-center gap-2 mb-2">
                                                        <input type="radio"
                                                               name="selectedAddress"
                                                               value="${addr.id}"
                                                               class="text-indigo-600 h-5 w-5 cursor-pointer"
                                                               ${addr.equals(address) ? 'checked' : ''} />
                                                        <span class="font-medium text-gray-900">${fn:escapeXml(addr.name)}</span>
                                                        <c:if test="${addr.equals(address)}">
                                                            <span class="text-xs font-semibold uppercase bg-indigo-100 text-indigo-800 px-2 py-0.5 rounded-full">
                                                                Default
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <p class="text-sm text-gray-600 flex items-center mb-1">
                                                        <i class="fas fa-phone mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Phone:</strong>${fn:escapeXml(addr.phone)}
                                                    </p>
                                                    <p class="text-sm text-gray-600 flex items-center mb-1">
                                                        <i class="fas fa-user mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Recipient:</strong>${fn:escapeXml(addr.recipientName)}
                                                    </p>
                                                    <p class="text-sm text-gray-600 flex items-center">
                                                        <i class="fas fa-location-dot mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Address:</strong>${fn:escapeXml(addr.details)}
                                                    </p>
                                                </div>
                                                <div class="flex-shrink-0 ml-4 flex flex-col space-y-2">
                                                    <button type="button"
                                                            class="text-blue-600 hover:text-blue-800 transition-colors edit-address-btn"
                                                            onclick="editAddress(${addr.id})"
                                                            title="Edit address">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button type="button"
                                                            class="delete-address-btn text-red-500 hover:text-red-700 transition-colors"
                                                            data-address-id="${addr.id}"
                                                            title="Delete address">
                                                        <i class="fas fa-trash"></i>
                                                    </button>

                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>


                    <!-- Product Details -->
                    <section class="modern-card glass-card p-8 animate-slide-in">
                        <div class="flex items-center mb-6">
                            <div class="w-12 h-12 bg-gradient-to-br from-green-500 to-teal-600 rounded-full flex items-center justify-center mr-4">
                                <i class="fas fa-shopping-bag text-white text-lg"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">Order Items</h2>
                                <p class="text-gray-600"><%= totalItems%> items</p>
                            </div>
                        </div>
                        <div class="space-y-4">
                            <% for (Cart cart : selectedItems) {
                                    Product p = cart.getProduct();
                                    int qty = cart.getQuantity();
                                    double lineTotal = p.getPrice() * qty; %>
                            <div class="product-card p-6 rounded-xl">
                                <div class="flex flex-col sm:flex-row sm:items-center gap-4 sm:gap-4">
                                    <div  class="flex-shrink-0 w-20 h-20 mx-auto sm:mx-0">
                                        <% if (p.getUrls() != null && !p.getUrls().isEmpty()) {%>
                                        <img loading="lazy"
                                             src="<%= p.getUrls().get(0)%>"
                                             alt="<%= p.getTitle()%>"
                                             class="product-image">
                                        <% } else { %>
                                        <div class="product-image bg-gray-200 flex items-center justify-center"><i class=" text-gray-400 text-2xl"></i></div>
                                            <% }%>
                                    </div>
                                    <div class="flex-1">
                                        <h3 class="font-semibold text-gray-800 text-lg"><%= p.getTitle()%></h3>
                                        <% if (p.getDescription() != null && !p.getDescription().isEmpty()) {%>
                                        <p class="font-semibold text-gray-800 text-lg"><%= p.getDescription().length() > 80 ? p.getDescription().substring(0, 80) + "..." : p.getDescription()%></p>
                                        <% }%>
                                        <div class="flex items-center mt-3 space-x-4">
                                            <span class="text-indigo-600 font-bold"><i class="fas fa-tag mr-1"></i><%= CurrencyFormatter.formatVietNamCurrency(p.getPrice())%> VND</span>
                                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm font-medium">Quantity: <%= qty%></span>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div class="text-xl font-bold text-indigo-600"><%= CurrencyFormatter.formatVietNamCurrency(lineTotal)%> VND</div>
                                    </div> 
                                </div>
                            </div>
                            <% }%>
                        </div>
                    </section>

                    <!-- Payment Method -->
                    <section class="modern-card glass-card p-8 animate-slide-in">
                        <div class="flex items-center mb-6">
                            <div class="w-12 h-12 bg-gradient-to-br from-yellow-500 to-orange-600 rounded-full flex items-center justify-center mr-4">
                                <i class="fas fa-credit-card text-white text-lg"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-semibold text-gray-800">Payment Method</h2>  
                            </div>

                        </div>
                        <div class="bg-gradient-to-r from-yellow-50 to-orange-50 p-6 rounded-xl border border-yellow-200">
                            <div class="flex items-center">
                                <div class="w-12 h-12 bg-yellow-500 rounded-full flex items-center justify-center mr-4">
                                    <i class="fas fa-money-bill-wave text-white text-lg"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-yellow-800">Cash on Delivery (COD)</h3>
                                    <p class="text-yellow-700 text-sm mt-1">Pay when you receive your order - Safe and secure</p>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>

                <!-- Right Column - Order Summary & Vouchers -->
                <div class="xl:col-span-1">
                    <div class="modern-card glass-card p-8 sticky top-24 animate-fade-in-up">
                        <!-- Voucher Section -->
                        <div class="mb-8">
                            <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-tags text-indigo-600 mr-2"></i>
                                Voucher Codes
                            </h3>

                            <!-- 🌟 Hidden holder for the applied voucher ID -->
                            <input
                                type="hidden"
                                name="voucherId"
                                id="voucherId"
                                value="<%= (voucher != null ? voucher.getId() : "")%>" 
                                />

                            <% if (voucher != null) {%>
                            <!-- Applied Voucher -->
                            <div class="voucher-card">
                                >
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center">
                                        <i class="fas fa-ticket-alt text-xl mr-3"></i>
                                        <div>
                                            <h4 class="font-semibold">Applied Voucher</h4>
                                            <p class="text-white/80 text-sm">Code: <span class="font-mono bg-white/20 px-2 py-1 rounded"><%= voucher.getCode()%></span></p>
                                        </div>
                                    </div>
                                    <button onclick="removeVoucher()" class="text-white/80 hover:text-white text-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                                <div class="mt-3 pt-3 border-t border-white/20">
                                    <p class="text-white/90 text-sm"><%= voucherDescription%></p>
                                    <p class="text-white font-bold mt-2">Discount: -<%= CurrencyFormatter.formatVietNamCurrency(discount)%> VND</p>
                                </div>
                            </div>

                            <% } else { %>
                            <!-- Voucher Input -->
                            <div class="space-y-3">
                                <div class="space-y-2">
                                    <div class="flex gap-2 items-center">

                                        <div class="relative flex-1">
                                            <input id="voucherInput"
                                                   type="text"
                                                   class="w-full rounded-xl border border-gray-200 bg-white/70 shadow-inner px-4 py-3 text-sm pr-10 placeholder-gray-400 focus:ring-2 focus:ring-blue-300 outline-none transition-all"
                                                   placeholder="Enter voucher code..." />

                                            <button
                                                type="button"
                                                onclick="removeVoucher()"
                                                class="absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 flex items-center justify-center bg-gray-100 hover:bg-red-200 text-gray-400 hover:text-red-500 rounded-full transition-all duration-150"
                                                tabindex="-1"
                                                style="z-index:1;"
                                                >
                                                <i class="fas fa-times text-base"></i>
                                            </button>
                                        </div>

                                        <button id="applyVoucherBtn"
                                                class="bg-gradient-to-tr from-teal-400 via-green-400 to-cyan-500 hover:from-green-500 hover:to-cyan-600 transition-all px-8 py-3 rounded-xl font-bold shadow-lg text-white text-base focus:ring-2 focus:ring-teal-300 active:scale-95"
                                                onclick="applyVoucher()"
                                                >
                                            Apply
                                        </button>
                                    </div>
                                </div>


                                <% if (availableVouchers != null && !availableVouchers.isEmpty()) {%>
                                <div class="mt-4">
                                    <label class="block text-sm text-gray-600 mb-2">Available vouchers:</label>
                                    <div class="flex flex-wrap gap-2">
                                        <% for (Voucher v : availableVouchers) {%>
                                        <button type="button"
                                                class="voucher-suggestion px-3 py-1 rounded-full bg-purple-100 hover:bg-purple-200 text-purple-700 text-sm font-medium shadow-sm border border-purple-200 transition-all"
                                                data-code="<%= v.getCode()%>"
                                                onclick="selectVoucher('<%= v.getCode()%>')"
                                                title="<%= v.getDescription()%>">
                                            <span class="font-mono"><%= v.getCode()%></span>
                                            <span class="ml-1 text-gray-500 text-xs">
                                                (<% if ("PERCENTAGE".equalsIgnoreCase(v.getType())) {%>
                                                <%= ((int) v.getValue())%>% off, up to <%= CurrencyFormatter.formatVietNamCurrency(v.getMaxValue())%>VND
                                                <% } else {%>
                                                <%= CurrencyFormatter.formatVietNamCurrency(v.getValue())%> off
                                                <% } %>)
                                            </span>
                                        </button>
                                        <% } %>

                                    </div>
                                </div>
                                <% }%>
                            </div>
                            <div id="voucherMessage" class="text-sm mt-3 min-h-[20px] text-center font-medium rounded-lg"></div>
                            <% }%>
                        </div>


                        <!-- Order Summary -->
                        <div class="border-t border-gray-200 pt-6">
                            <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center">
                                <i class="fas fa-calculator text-indigo-600 mr-2"></i>Order Summary</h3>

                            <div class="space-y-4">
                                <div class="flex justify-between text-gray-600">
                                    <span class="text-gray-600">Items (<%= totalItems%>):</span>
                                    <!-- give the span an id so your JS can find it -->
                                    <span id="subtotalAmount" class="font-medium text-gray-800">
                                        <%= CurrencyFormatter.formatVietNamCurrency(subtotal)%> VND
                                    </span>
                                </div>

                                <div class="flex justify-between text-gray-600">
                                    <span class="text-gray-600">Shipping:</span>

                                    <span id="shippingAmount" class="font-medium text-green-600">
                                        <%= shippingFee > 0 ? CurrencyFormatter.formatVietNamCurrency(shippingFee) + " VND" : "Free"%>
                                    </span>
                                </div>

                                <div class="flex justify-between text-gray-600" id="discountRow" style="<%= discount > 0 ? "display:flex;" : "display:none;"%>"><span class="text-gray-600">Voucher Discount:</span><span id="discountAmount" class="text-green-600 font-medium">-<%= CurrencyFormatter.formatVietNamCurrency(discount)%> VND</span></div>

                                <div class="border-t border-gray-200 pt-4">
                                    <div class="flex justify-between">
                                        <span class="text-lg font-bold text-gray-800">Total Amount:</span><span id="totalAmount" class="text-2xl font-bold text-indigo-600 animate-pulse-glow"><%= CurrencyFormatter.formatVietNamCurrency(total)%> VND</span></div>
                                </div>

                            </div>
                        </div>

                        <!-- Purchase Button -->
                        <div class="mt-6 space-y-3">
                            <button id="purchaseBtn" type="button" onclick="confirmPurchase()" class="w-full btn-<%= canPurchase ? "primary" : "disabled"%> btn-modern btn-primary-modern w-full text-white py-4 rounded-xl font-bold text-lg"><i class="fas fa-<%= canPurchase ? "credit-card" : "lock"%> mr-2"></i><%= canPurchase ? "Place Order" : "Complete Info to Order"%></button>
                            <a href="<%= request.getContextPath()%>/cart" class="w-full inline-flex items-center justify-center px-6 py-3 border-2 border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50 transition-colors"><i class="fas fa-arrow-left mr-2"></i>Back to Cart</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="../common/footer.jsp" />   


        <!-- Confirmation Modal -->
        <div id="confirmModal"
             class="fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center opacity-0 pointer-events-none transition-opacity duration-300 z-50">
            <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-xl w-full max-w-lg p-6 animate-fade-in-up">
                <h3 class="text-2xl font-bold text-gray-800 mb-4 flex items-center animate-slide-in">
                    <i class="fas fa-check-circle text-green-500 mr-2"></i>
                    Confirm Your Order
                </h3>
                <p class="text-gray-600 mb-6 animate-fade-in-up">
                    Are you sure you want to place this order? Once confirmed, it will be processed immediately.
                </p>
                <div class="bg-white p-4 rounded-lg mb-6 border border-gray-200 animate-fade-in-up">
                    <div class="flex justify-between items-center">
                        <span class="font-semibold text-gray-700">Total Amount:</span>
                        <span id="confirmModalTotal" class="text-xl font-bold text-indigo-600">
                            <%= CurrencyFormatter.formatVietNamCurrency(total)%> VND
                        </span>
                    </div>
                    <div class="text-sm text-gray-600 mt-2">
                        Payment Method: Cash on Delivery (COD)
                    </div>
                </div>
                <div class="flex gap-4">
                    <button onclick="closeModal()"
                            class="flex-1 px-5 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-100 transition">
                        Cancel
                    </button>
                    <button id="confirmButton"
                            class="flex-1 btn-modern btn-primary-modern text-white px-5 py-3 rounded-lg font-medium animate-pulse-glow">
                        <i class="fas fa-check mr-2"></i>
                        Confirm Order
                    </button>
                </div>
            </div>
        </div>



        <!-- ==================== Add/Edit Address Modal ==================== -->
        <!-- Add/Edit Address Modal -->
        <div id="addressModal"
             class="fixed inset-0 bg-black bg-opacity-40 backdrop-blur-sm flex items-center justify-center opacity-0 pointer-events-none transition-opacity duration-300 z-40">
            <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg w-full max-w-md p-6 relative animate-fade-in-up">
                <button type="button"
                        class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 transition"
                        onclick="closeAddressModal()">×</button>
                <h3 class="text-2xl font-semibold mb-4 flex items-center">
                    <i id="modalIcon" class="fas fa-plus-circle text-indigo-600 mr-2"></i>
                    <span id="modalTitle">Add New Address</span>
                </h3>
                <form id="addressForm" class="space-y-5">
                    <input type="hidden" id="addressIdInput" name="addressId" value="">
                    <div>
                        <label class="block text-sm font-medium mb-1">Address Name *</label>
                        <input id="addressNameInput" name="addressName" type="text"
                               class="modern-input w-full" required>
                        <span id="nameError" class="text-sm text-red-500 mt-1"></span>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Recipient Name *</label>
                        <input id="recipientInput" name="recipientName" type="text"
                               class="modern-input w-full" required>
                        <span id="recError" class="text-sm text-red-500 mt-1"></span>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Phone *</label>
                        <input id="phoneInput" name="addressPhone" type="text"
                               class="modern-input w-full" required>
                        <p id="phoneError" class="text-sm text-red-500 mt-1"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Full Address *</label>
                        <textarea id="detailsInput" name="addressDetails" rows="3"
                                  class="modern-input w-full" required></textarea>
                        <span id="detailsError" class="text-sm text-red-500 mt-1"></span>
                    </div>
                    <div class="mt-6 flex justify-end space-x-3">
                        <button type="button"
                                class="px-4 py-2 border rounded hover:bg-gray-100 transition"
                                onclick="closeAddressModal()">Cancel</button>
                        <button type="submit"
                                class="btn-modern btn-primary-modern text-white px-4 py-2 rounded-lg font-medium">
                            <i class="fas fa-save mr-2"></i>
                            <span id="modalSubmit">Save Address</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Enhanced Address Selection System
            document.addEventListener('DOMContentLoaded', function () {
                // Initialize the address selection system
                initializeAddressSelection();

                // Update purchase button state on page load
                updatePurchaseButton();

                // Render initial selected address card if address exists
                renderInitialSelectedAddress();
            });

            // Initialize address selection system
            function initializeAddressSelection() {
                attachRadioListeners();
                setupMutationObserver();
            }

            // Function to handle address selection
            function selectAddress(addressId) {
                console.log('Selecting address ID:', addressId);

                // Show loading state
                showLoadingState();

                fetch('<%= request.getContextPath()%>/checkout', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({action: 'selectAddress', addressId})
                })
                        .then(res => {
                            console.log('HTTP status:', res.status);
                            return res.json();
                        })
                        .then(json => {
                            console.log('Full response:', json);
                            console.log('Address payload:', json.address);

                            if (json.success) {
                                // Update the selected address card
                                renderSelectedAddressCard(json.address);

                                // Update radio button states in the addresses list
                                updateAddressListSelection(addressId);

                                // Update purchase button
                                updatePurchaseButton();

                                // Show success notification
                                showNotification(json.message, 'success');
                                window.location.reload();
                            } else {
                                showNotification(json.message || 'Có lỗi xảy ra', 'error');
                            }
                        })
                        .catch(err => {
                            console.error('Fetch error:', err);
                            showNotification('Lỗi kết nối. Vui lòng thử lại.', 'error');
                        })
                        .finally(() => {
                            hideLoadingState();
                        });
            }

            // Enhanced function to render selected address card
            function renderSelectedAddressCard(address) {
                const container = document.getElementById('selectedAddressCard');
                if (!container)
                    return;

                // Add smooth transition
                container.style.opacity = '0.5';

                setTimeout(() => {
                    if (address && Object.keys(address).length > 0) {
                        // Render address details
                        container.innerHTML = `
                <label class="flex items-start space-x-4 flex-1 cursor-pointer">
                    <input type="radio"
                           name="selectedAddress"
                           value="${address.id}"
                           checked
                           class="h-5 w-5 text-indigo-600 accent-indigo-500 mt-1" />
                    <div>
                        <p class="font-semibold text-gray-800 text-lg">${address.name}</p>
                        <div class="text-sm text-gray-600 mt-1 space-y-1">
                            <p><i class="fas fa-phone mr-2 text-indigo-500"></i>${address.phone}</p>
                            <p><i class="fas fa-user mr-2 text-indigo-500"></i>${address.recipientName}</p>
                            <p><i class="fas fa-location-dot mr-2 text-indigo-500"></i>${address.details}</p>
                        </div>
                    </div>
                </label>
                <button onclick="toggleAddresses()"
                        class="ml-4 flex-shrink-0 text-indigo-600 hover:text-indigo-800 transition-colors">
                    <i class="fas fa-pen"></i>
                </button>
            `;
                    } else {
                        // Render empty state
                        container.innerHTML = `
                <div class="flex items-center space-x-3 flex-1">
                    <i class="fas fa-exclamation-circle text-red-500 text-xl"></i>
                    <p class="text-red-600 font-medium">Please add a delivery address.</p>
                </div>
                <button onclick="toggleAddresses()"
                        class="ml-4 flex-shrink-0 text-indigo-600 hover:text-indigo-800 transition-colors">
                    <i class="fas fa-chevron-down"></i>
                </button>
            `;
                    }

                    // Restore opacity with smooth transition
                    container.style.opacity = '1';
                }, 150);
            }

            // Function to update address list selection state
            function updateAddressListSelection(selectedAddressId) {
                const addressItems = document.querySelectorAll('.address-item');

                addressItems.forEach(item => {
                    const radio = item.querySelector('input[name="selectedAddress"]');
                    const addressId = item.dataset.addressId;

                    if (addressId === selectedAddressId) {
                        // Select this address
                        radio.checked = true;
                        item.classList.add('ring-2', 'ring-indigo-400', 'bg-white');

                        // Add "Default" badge if not exists
                        if (!item.querySelector('.bg-indigo-100')) {
                            const nameContainer = item.querySelector('.flex.items-center.gap-2.mb-2');
                            const defaultBadge = document.createElement('span');
                            defaultBadge.className = 'text-xs font-semibold uppercase bg-indigo-100 text-indigo-800 px-2 py-0.5 rounded-full';
                            defaultBadge.textContent = 'Default';
                            nameContainer.appendChild(defaultBadge);
                        }
                    } else {
                        // Deselect other addresses
                        radio.checked = false;
                        item.classList.remove('ring-2', 'ring-indigo-400', 'bg-white');

                        // Remove "Default" badge
                        const defaultBadge = item.querySelector('.bg-indigo-100');
                        if (defaultBadge) {
                            defaultBadge.remove();
                        }
                    }
                });
            }

            // Function to render initial selected address
            function renderInitialSelectedAddress() {
                const checkedRadio = document.querySelector('input[name="selectedAddress"]:checked');
                if (checkedRadio) {
                    const addressItem = checkedRadio.closest('.address-item');
                    if (addressItem) {
                        const address = {
                            id: addressItem.dataset.addressId,
                            name: addressItem.dataset.name,
                            recipientName: addressItem.dataset.recipient,
                            phone: addressItem.dataset.phone,
                            details: addressItem.dataset.details
                        };
                        renderSelectedAddressCard(address);
                    }
                } else {
                    renderSelectedAddressCard({});
                }
            }

            // Enhanced radio button event handling
            function attachRadioListeners() {
                document.querySelectorAll('#addressesList input[name="selectedAddress"]').forEach(radio => {
                    // Remove existing listeners to prevent duplicates
                    radio.removeEventListener('change', handleRadioChange);
                    radio.addEventListener('change', handleRadioChange);
                });
            }

            function handleRadioChange(event) {
                if (event.target.checked) {
                    const addressId = event.target.value;
                    console.log('Radio changed to address ID:', addressId);
                    selectAddress(addressId);
                }
            }

            // Setup mutation observer for dynamic content
            function setupMutationObserver() {
                const observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (mutation.type === 'childList' && mutation.target.id === 'addressesList') {
                            attachRadioListeners();
                        }
                    });
                });

                const addressesList = document.getElementById('addressesList');
                if (addressesList) {
                    observer.observe(addressesList, {childList: true, subtree: true});
                }
            }

            // Enhanced update purchase button function
            function updatePurchaseButton() {
                const purchaseBtn = document.getElementById('purchaseBtn');
                const selectedAddressCard = document.getElementById('selectedAddressCard');

                if (!purchaseBtn || !selectedAddressCard)
                    return;

                const hasAddress = selectedAddressCard.querySelector('input[name="selectedAddress"]');

                if (hasAddress) {
                    purchaseBtn.classList.remove('btn-disabled');
                    purchaseBtn.classList.add('btn-primary');
                    purchaseBtn.innerHTML = '<i class="fas fa-credit-card mr-2"></i>Place Order';
                    purchaseBtn.disabled = false;
                } else {
                    purchaseBtn.classList.remove('btn-primary');
                    purchaseBtn.classList.add('btn-disabled');
                    purchaseBtn.innerHTML = '<i class="fas fa-lock mr-2"></i>Complete Info to Order';
                    purchaseBtn.disabled = true;
                }
            }

            // Enhanced toggle addresses function
            function toggleAddresses() {
                const sec = document.getElementById('addressesSection');
                const chevron = document.getElementById('addressesChevron');

                if (!sec || !chevron)
                    return;

                const isHidden = sec.classList.contains('hidden');

                if (isHidden) {
                    sec.classList.remove('hidden');
                    // Smooth scroll to section
                    setTimeout(() => {
                        sec.scrollIntoView({behavior: 'smooth', block: 'nearest'});
                    }, 100);
                } else {
                    sec.classList.add('hidden');
                }

                chevron.classList.toggle('rotate-180');
            }

            // Helper function to safely display text (optional, for extra security)
            function safeText(text) {
                return text || '';
            }

            // Loading state functions
            function showLoadingState() {
                const container = document.getElementById('selectedAddressCard');
                if (container) {
                    container.style.opacity = '0.6';
                    container.style.pointerEvents = 'none';
                }
            }

            function hideLoadingState() {
                const container = document.getElementById('selectedAddressCard');
                if (container) {
                    container.style.opacity = '1';
                    container.style.pointerEvents = 'auto';
                }
            }

            // Enhanced notification function
            function showNotification(message, type = 'success') {
                // Remove existing notifications
                document.querySelectorAll('.notification').forEach(n => n.remove());

                const notification = document.createElement('div');
                notification.className = `notification fixed top-4 right-4 z-50 px-6 py-3 rounded-lg shadow-lg transition-all duration-300 transform translate-x-full`;

                if (type === 'success') {
                    notification.classList.add('bg-green-500', 'text-white');
                    notification.innerHTML = `<i class="fas fa-check-circle mr-2"></i>${message}`;
                } else if (type === 'error') {
                    notification.classList.add('bg-red-500', 'text-white');
                    notification.innerHTML = `<i class="fas fa-times-circle mr-2"></i>${message}`;
                }

                document.body.appendChild(notification);

                // Animate in
                setTimeout(() => {
                    notification.classList.remove('translate-x-full');
                }, 10);

                // Auto remove after 3 seconds
                setTimeout(() => {
                    notification.classList.add('translate-x-full');
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.parentNode.removeChild(notification);
                        }
                    }, 300);
                }, 3000);
            }

            ///craeete/edit address 
            document.addEventListener('DOMContentLoaded', () => {

                const addressModal = document.getElementById('addressModal');
                const form = document.getElementById('addressForm');
                const addrIdInput = document.getElementById('addressIdInput');
                const nameInput = document.getElementById('addressNameInput');
                const recInput = document.getElementById('recipientInput');
                const phoneInput = document.getElementById('phoneInput');
                const detailsInput = document.getElementById('detailsInput');
                const nameError = document.getElementById('nameError');
                const recError = document.getElementById('recError');
                const phoneError = document.getElementById('phoneError');
                const detailsError = document.getElementById('detailsError');
                const addBtn = document.getElementById('addAddressBtn');
                const editBtns = document.querySelectorAll('.edit-address-btn');

                const prefixes = [
                    '032', '033', '034', '035', '036', '037', '038', '039',
                    '056', '058', '059', '099',
                    '070', '076', '077', '078', '079', '089', '090', '091', '093', '094',
                    '081', '082', '083', '084', '085',
                    '086', '096', '097', '098'
                ];


                function validateField(el, ok, errEl, msg) {
                    el.classList.toggle('valid-field', ok);
                    el.classList.toggle('invalid-field', !ok);
                    errEl.textContent = ok ? '' : msg;
                }


                function getExistingAddresses() {
                    return Array
                            .from(document.querySelectorAll('.address-item'))
                            .map(item => item.dataset.details.trim().toLowerCase());
                }


                function clearValidation() {
                    [nameInput, recInput, phoneInput, detailsInput].forEach(i => {
                        i.classList.remove('valid-field', 'invalid-field');
                    });
                    [nameError, recError, phoneError, detailsError].forEach(e => {
                        e.textContent = '';
                    });
                }

                function openModal() {
                    addressModal.classList.remove('opacity-0', 'pointer-events-none');
                    document.body.classList.add('modal-open'); // <-- Thêm dòng này
                }

                function closeAddressModal() {
                    addressModal.classList.add('opacity-0', 'pointer-events-none');
                    document.body.classList.remove('modal-open'); // <-- Và dòng này
                }

                addressModal.addEventListener('click', e => {
                    if (e.target === addressModal)
                        closeModal();
                });


                addBtn.addEventListener('click', () => {
                    clearValidation();
                    addrIdInput.value = '';
                    [nameInput, recInput, phoneInput, detailsInput].forEach(i => i.value = '');
                    document.getElementById('modalTitle').textContent = 'Add New Address';
                    document.getElementById('modalIcon').className = 'fas fa-plus-circle text-indigo-600 mr-2';
                    document.getElementById('modalSubmit').textContent = 'Save Address';
                    openModal();
                });


                editBtns.forEach(btn => btn.addEventListener('click', e => {
                        clearValidation();
                        const item = e.currentTarget.closest('.address-item');
                        addrIdInput.value = item.dataset.addressId;
                        nameInput.value = item.dataset.name;
                        recInput.value = item.dataset.recipient;
                        phoneInput.value = item.dataset.phone;
                        detailsInput.value = item.dataset.details;
                        document.getElementById('modalTitle').textContent = 'Edit Address';
                        document.getElementById('modalIcon').className = 'fas fa-edit text-blue-600 mr-2';
                        document.getElementById('modalSubmit').textContent = 'Update Address';
                        openModal();
                    }));


                nameInput.addEventListener('input', () => {
                    validateField(nameInput, nameInput.value.trim() !== '', nameError, 'Address name is required.');
                });
                recInput.addEventListener('input', () => {
                    validateField(recInput, recInput.value.trim() !== '', recError, 'Recipient name is required.');
                });
                phoneInput.addEventListener('input', () => {
                    const v = phoneInput.value.trim();
                    if (!v) {
                        validateField(phoneInput, false, phoneError, 'Please enter your phone number.');
                        return;
                    }
                    if (!/^\d+$/.test(v)) {
                        validateField(phoneInput, false, phoneError, 'Phone number must contain only digits.');
                        return;
                    }
                    if (!(v.length === 10 || v.length === 11)) {
                        validateField(phoneInput, false, phoneError, 'Phone number must be 10 or 11 digits.');
                        return;
                    }
                    const p3 = v.slice(0, 3), p4 = v.slice(0, 4);
                    if (!prefixes.includes(p3) && !prefixes.includes(p4)) {
                        validateField(phoneInput, false, phoneError, 'Phone prefix invalid.');
                        return;
                    }
                    validateField(phoneInput, true, phoneError, '');
                });
                detailsInput.addEventListener('input', () => {
                    const v = detailsInput.value.trim();
                    // a) Empty
                    if (!v) {
                        validateField(detailsInput, false, detailsError, 'Full address is required.');
                        return;
                    }
                    // b) Duplicate
                    const existing = getExistingAddresses();
                    if (existing.includes(v.toLowerCase())) {
                        validateField(detailsInput, false, detailsError,
                                'This address already exists. Please enter a different address.');
                        return;
                    }

                    validateField(detailsInput, true, detailsError, '');
                });

                
                form.addEventListener('submit', e => {
                    let ok = true;
                    if (nameInput.value.trim() === '') {
                        validateField(nameInput, false, nameError, 'Address name is required.');
                        ok = false;
                    }
                    if (recInput.value.trim() === '') {
                        validateField(recInput, false, recError, 'Recipient name is required.');
                        ok = false;
                    }
                    if (detailsInput.value.trim() === '') {
                        validateField(detailsInput, false, detailsError, 'Full address is required.');
                        ok = false;
                    }
                    const v = phoneInput.value.trim();
                    const phoneOk = v &&
                            /^\d+$/.test(v) &&
                            (v.length === 10 || v.length === 11) &&
                            (prefixes.includes(v.slice(0, 3)) || prefixes.includes(v.slice(0, 4)));
                    if (!phoneOk) {
                        validateField(phoneInput, false, phoneError, 'Invalid phone number.');
                        ok = false;
                    }
                    if (!ok)
                        e.preventDefault();
                });
            });




            // --- DOM ---
            const addressModal = document.getElementById('addressModal');
            const form = document.getElementById('addressForm');
            const addrIdInput = document.getElementById('addressIdInput');
            const nameInput = document.getElementById('addressNameInput');
            const recInput = document.getElementById('recipientInput');
            const phoneInput = document.getElementById('phoneInput');
            const phoneError = document.getElementById('phoneError');
            const detailsInput = document.getElementById('detailsInput');
            const modalTitle = document.getElementById('modalTitle');
            const modalIcon = document.getElementById('modalIcon');
            const modalSubmit = document.getElementById('modalSubmit');
            const addressesList = document.getElementById('addressesList'); // nơi chứa danh sách địa chỉ


            function openModal() {
                addressModal.classList.remove('opacity-0', 'pointer-events-none');
            }
            function closeAddressModal() {
                addressModal.classList.add('opacity-0', 'pointer-events-none');
            }

            document.addEventListener('DOMContentLoaded', function () {
                const addressModal = document.getElementById('addressModal');

                addressModal.addEventListener('click', function (event) {

                    if (event.target === addressModal) {
                        closeAddressModal();
                    }
                });
            });



            document.getElementById('addAddressBtn').addEventListener('click', () => {
                addrIdInput.value = '';
                nameInput.value = '';
                recInput.value = '';
                phoneInput.value = '';
                detailsInput.value = '';
                modalTitle.textContent = 'Add New Address';
                modalIcon.className = 'fas fa-plus-circle text-indigo-600 mr-2';
                modalSubmit.textContent = 'Save Address';
                openModal();
            });


            document.querySelectorAll('.edit-address-btn').forEach(btn =>
                btn.addEventListener('click', e => {
                    const item = e.currentTarget.closest('.address-item');
                    addrIdInput.value = item.dataset.addressId;
                    nameInput.value = item.dataset.name;
                    recInput.value = item.dataset.recipient;
                    phoneInput.value = item.dataset.phone;
                    detailsInput.value = item.dataset.details;
                    modalTitle.textContent = 'Edit Address';
                    modalIcon.className = 'fas fa-edit text-blue-600 mr-2';
                    modalSubmit.textContent = 'Update Address';
                    openModal();
                })
            );


            form.addEventListener('submit', e => {
                e.preventDefault();


                const newDetails = detailsInput.value.trim();


                const existingAddresses = Array.from(document.querySelectorAll('#addressesList .address-item'))
                        .map(item => item.dataset.details.trim());


                const isDuplicate = existingAddresses.some(addr => addr.toLowerCase() === newDetails.toLowerCase());


                if (isDuplicate && !addrIdInput.value.trim()) {

                    detailsError.textContent = 'This address already exists. Please enter a different address.';
                    detailsInput.classList.add('invalid-field');
                    detailsInput.focus();
                    return;
                } else {

                    detailsError.textContent = '';
                    detailsInput.classList.remove('invalid-field');
                }


                const isEdit = addrIdInput.value.trim() !== '';
                const action = isEdit ? 'editAddress' : 'addAddress';

                const params = new URLSearchParams();
                params.append('action', action);
                if (isEdit)
                    params.append('addressId', addrIdInput.value.trim());
                params.append('addressName', nameInput.value.trim());
                params.append('recipientName', recInput.value.trim());
                params.append('addressPhone', phoneInput.value.trim());
                params.append('addressDetails', detailsInput.value.trim());

                fetch('<%= request.getContextPath()%>/checkout', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params
                })
                        .then(r => r.json())
                        .then(json => {
                            Toastify({
                                text: json.message,
                                duration: 3000,
                                gravity: 'top',
                                position: 'right',
                                style: {background: json.success ? '#28a745' : '#f44336'},
                                close: true
                            }).showToast();

                            if (json.success) {
                                closeAddressModal();
                                window.location.reload();

                                if (isEdit) {

                                    const existingItem = addressesList.querySelector(`.address-item[data-address-id="${addrIdInput.value.trim()}"]`);
                                    if (existingItem) {
                                        existingItem.dataset.name = nameInput.value.trim();
                                        existingItem.dataset.recipient = recInput.value.trim();
                                        existingItem.dataset.phone = phoneInput.value.trim();
                                        existingItem.dataset.details = detailsInput.value.trim();


                                        existingItem.querySelector('span.font-medium').textContent = nameInput.value.trim();
                                        existingItem.querySelector('p.text-sm:nth-child(2)').innerHTML = `
                        <i class="fas fa-phone mr-2 text-gray-400"></i><strong class="mr-1">Phone:</strong>${phoneInput.value.trim()}
                    `;
                                        existingItem.querySelector('p.text-sm:nth-child(3)').innerHTML = `
                        <i class="fas fa-user mr-2 text-gray-400"></i><strong class="mr-1">Recipient:</strong>${recInput.value.trim()}
                    `;
                                        existingItem.querySelector('p.text-sm:nth-child(4)').innerHTML = `
                        <i class="fas fa-location-dot mr-2 text-gray-400"></i><strong class="mr-1">Address:</strong>${detailsInput.value.trim()}
                    `;
                                    }
                                } else {

                                    const newId = json.newAddressId;
                                    if (newId) {
                                        const newDiv = document.createElement('div');
                                        newDiv.className = 'address-item group flex items-start justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 hover:bg-white hover:shadow-md transition-all';
                                        newDiv.dataset.addressId = newId;
                                        newDiv.dataset.name = nameInput.value.trim();
                                        newDiv.dataset.recipient = recInput.value.trim();
                                        newDiv.dataset.phone = phoneInput.value.trim();
                                        newDiv.dataset.details = detailsInput.value.trim();

                                        newDiv.innerHTML = `
    <div class="flex-1">
        <div class="flex items-center gap-2 mb-2">
            <input type="radio" name="selectedAddress" value="${newId}" class="text-indigo-600 h-5 w-5 cursor-pointer" />
            <span class="font-medium text-gray-900">${nameInput.value.trim()}</span>
        </div>
        <p class="text-sm text-gray-600 flex items-center mb-1">
            <i class="fas fa-phone mr-2 text-gray-400"></i>
            <strong class="mr-1">Phone:</strong>${phoneInput.value.trim()}
        </p>
        <p class="text-sm text-gray-600 flex items-center mb-1">
            <i class="fas fa-user mr-2 text-gray-400"></i>
            <strong class="mr-1">Recipient:</strong>${recInput.value.trim()}
        </p>
        <p class="text-sm text-gray-600 flex items-center">
            <i class="fas fa-location-dot mr-2 text-gray-400"></i>
            <strong class="mr-1">Address:</strong>${detailsInput.value.trim()}
        </p>
    </div>
    <div class="flex-shrink-0 ml-4 flex flex-col space-y-2">
        <button type="button" class="text-blue-600 hover:text-blue-800 transition-colors edit-address-btn" onclick="editAddress(${newId})" title="Edit address">
            <i class="fas fa-edit"></i>
        </button>
        <button type="button" class="delete-address-btn text-red-500 hover:text-red-700 transition-colors" data-address-id="${newId}" title="Delete address">
            <i class="fas fa-trash"></i>
        </button>
    </div>
`;

                                        addressesList.appendChild(newDiv);


                                        newDiv.querySelector('.edit-address-btn').addEventListener('click', e => {
                                            const item = e.currentTarget.closest('.address-item');
                                            addrIdInput.value = item.dataset.addressId;
                                            nameInput.value = item.dataset.name;
                                            recInput.value = item.dataset.recipient;
                                            phoneInput.value = item.dataset.phone;
                                            detailsInput.value = item.dataset.details;
                                            modalTitle.textContent = 'Edit Address';
                                            modalIcon.className = 'fas fa-edit text-blue-600 mr-2';
                                            modalSubmit.textContent = 'Update Address';
                                            openModal();
                                        });
                                        newDiv.querySelector('.delete-address-btn').addEventListener('click', handleDeleteAddressClick);
                                    }
                                }
                            }
                        })
                        .catch(() => {
                            Toastify({
                                text: 'An error occurred, please try again.',
                                duration: 3000,
                                gravity: 'top',
                                position: 'right',
                                style: {background: '#f44336'},
                                close: true
                            }).showToast();
                        });
            });

            phoneInput.addEventListener('input', function () {
                document.getElementById('phoneError').textContent = '';
            });


            function handleDeleteAddressClick(evt) {
                const btn = evt.currentTarget;
                const addressId = btn.dataset.addressId;
                const itemDiv = btn.closest('.address-item');
                if (!addressId || addressId === '0') {
                    itemDiv.remove();
                    updatePurchaseButton();
                    return;
                }
                Swal.fire({
                    title: 'Are you sure you want to delete this address?',
                    text: 'The address will be permanently deleted.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Delete',
                    cancelButtonText: 'Cancle',
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d'
                }).then(result => {
                    if (!result.isConfirmed)
                        return;
                    console.log('⚙️ Deleting addressId =', addressId);
                    fetch('<%= request.getContextPath()%>/checkout', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({action: 'deleteAddress', addressId})
                    })
                            .then(r => r.json())
                            .then(js => {
                                Toastify({
                                    text: js.message,
                                    duration: 3000,
                                    gravity: 'top',
                                    position: 'right',
                                    style: {background: js.success ? '#28a745' : '#f44336'},
                                    close: true
                                }).showToast();
                                if (js.success) {
                                    itemDiv.remove();
                                    updatePurchaseButton();

                                    const sel = document.querySelector(`input[name="selectedAddress"][value="${addressId}"]`);
                                    if (sel) {
                                        document.getElementById('selectedAddressCard').innerHTML = `
            <div class="flex items-center space-x-3">
              <i class="fas fa-exclamation-circle text-red-500 text-xl"></i>
              <p class="text-red-600 font-medium">Please add delivery address.</p>
            </div>
            <button onclick="toggleAddresses()"
                    class="ml-4 text-indigo-600 hover:text-indigo-800">
              <i class="fas fa-chevron-down"></i>
            </button>`;
                                    }
                                }
                            })
                            .catch(() => {
                                Toastify({
                                    text: 'Có lỗi xảy ra, vui lòng thử lại.',
                                    duration: 3000,
                                    gravity: 'top',
                                    position: 'right',
                                    style: {background: '#f44336'},
                                    close: true
                                }).showToast();
                            });
                });
            }

            function bindDeleteAddressButtons() {
                document.querySelectorAll('.delete-address-btn')
                        .forEach(btn => btn.addEventListener('click', handleDeleteAddressClick));
            }

            document.addEventListener('DOMContentLoaded', bindDeleteAddressButtons);




            /////////////////code /////////////////////////////////////

            function selectVoucher(code, event) {
                if (event)
                    event.preventDefault();

                const input = document.getElementById('voucherInput');
                input.value = code;
                input.focus();
                applyVoucher();
            }

            function applyVoucher() {
                const code = document.getElementById('voucherInput').value.trim();
                if (!code) {
                    showVoucherMessage("Please enter a voucher code.", "red");
                    return;
                }
                const btn = document.getElementById('applyVoucherBtn');
                const orig = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Applying...';
                btn.disabled = true;

                const params = new URLSearchParams({
                    action: 'applyVoucher',
                    voucherCode: code,
                    cartIds: '<%= cartIdsJson%>'
                });

                fetch('<%= request.getContextPath()%>/checkout', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params.toString()
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showVoucherMessage(data.message, "green");

                                document.getElementById('subtotalAmount').textContent = data.subtotalFormatted + " VND";
                                if (data.discount > 0) {
                                    document.getElementById('discountRow').style.display = 'flex';
                                    document.getElementById('discountAmount').textContent = "-" + data.discountFormatted + " VND";
                                } else {
                                    document.getElementById('discountRow').style.display = 'none';
                                }


                                document.getElementById('totalAmount').textContent = data.totalFormatted + " VND";
                                document.getElementById('confirmModalTotal').textContent = data.totalFormatted + " VND";

                                document.getElementById('voucherId').value = data.voucherId;
                            } else {
                                showVoucherMessage(data.message, "red");
                            }
                        })
                        .catch(() => showVoucherMessage("An error occurred. Please try again.", "red"))
                        .finally(() => {
                            btn.innerHTML = orig;
                            btn.disabled = false;
                        });
            }

            function removeVoucher() {
                fetch('<%= request.getContextPath()%>/checkout?action=removeVoucher', {
                    method: 'POST',
                    body: new URLSearchParams({cartIds: '<%= cartIdsJson%>'})
                })
                        .then(response => response.json())
                        .then(data => {
                            // Ẩn block voucher
                            const voucherCard = document.querySelector('.voucher-card');
                            if (voucherCard)
                                voucherCard.style.display = 'none';
                            // Hiện lại input voucher
                            const voucherFormBlock = document.querySelector('.space-y-3');
                            if (voucherFormBlock)
                                voucherFormBlock.style.display = '';

                            // Cập nhật các field
                            if (document.getElementById('voucherId'))
                                document.getElementById('voucherId').value = '';
                            if (document.getElementById('voucherInput'))
                                document.getElementById('voucherInput').value = '';
                            if (document.getElementById('discountRow'))
                                document.getElementById('discountRow').style.display = 'none';
                            if (document.getElementById('discountAmount'))
                                document.getElementById('discountAmount').textContent = '';

                            if (document.getElementById('itemsLine'))
                                document.getElementById('itemsLine').textContent = `Items (${data.totalItems}):`;
                            if (document.getElementById('subtotalAmount'))
                                document.getElementById('subtotalAmount').textContent = data.subtotalFormatted + " VND";
                            if (document.getElementById('shippingAmount'))
                                document.getElementById('shippingAmount').textContent =
                                        (data.shipping > 0 ? data.shippingFormatted + " VND" : "Free");


                            if (document.getElementById('totalAmount'))
                                document.getElementById('totalAmount').textContent = data.totalFormatted + " VND";
                            if (document.getElementById('confirmModalTotal'))
                                document.getElementById('confirmModalTotal').textContent = data.totalFormatted + " VND";
   showVoucherMessage(data.message, "red");
                             
                        });
            }

            document.getElementById('voucherInput').focus();




            function showVoucherMessage(message, color) {
                const messageDiv = document.getElementById('voucherMessage');
                messageDiv.textContent = message;


                if (color === "green") {
                    messageDiv.className = 'text-sm mt-3 min-h-[20px] text-center font-medium rounded-lg text-green-600 bg-green-50 p-2';
                } else {
                    messageDiv.className = 'text-sm mt-3 min-h-[20px] text-center font-medium rounded-lg text-red-600 bg-red-50 p-2';
                }

            }

            // FIXED: Customer information update function
            function updateCustomerInfo(event) {
                event.preventDefault();

                const recipient = document.getElementById('recipientInput').value.trim();
                const addressName = document.getElementById('addressNameInput').value.trim();
                const phone = document.getElementById('phoneInput').value.trim();
                const address = document.getElementById('addressInput').value.trim();

                if (!recipient || !addressName || !phone || !address) {
                    alert('Please fill in recipient name, address label, phone number and address.');
                    return;
                }

                const btn = event.currentTarget;
                const orig = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Updating...';
                btn.disabled = true;

                const formData = new FormData();
                formData.append('recipientName', recipient);
                formData.append('addressName', addressName);
                formData.append('phone', phone);
                formData.append('address', address);

                fetch(`/checkout`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'updateCustomerInfo',
                        recipientName: recipient,
                        addressName: addressName,
                        phone: phone,
                        address: address
                    })
                })


                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showUpdateMessage(data.message, "green");

                                document.getElementById('recipientInput').classList.remove('required-field');
                                document.getElementById('addressNameInput').classList.remove('required-field');
                                document.getElementById('phoneInput').classList.remove('required-field');
                                document.getElementById('addressInput').classList.remove('required-field');

                            } else {
                                showUpdateMessage(data.message, "red");
                            }
                        })
                        .catch(err => {
                            console.error(err);
                            showUpdateMessage("An error occurred. Please try again.", "red");
                        })
                        .finally(() => {
                            btn.innerHTML = orig;
                            btn.disabled = false;
                        });
            }

            function showUpdateMessage(message, color) {
                // Create or update message element
                let messageDiv = document.getElementById('updateMessage');
                if (!messageDiv) {
                    messageDiv = document.createElement('div');
                    messageDiv.id = 'updateMessage';
                    messageDiv.className = 'mt-4 p-3 rounded-lg text-center font-medium';
                    document.getElementById('customerInfoForm').appendChild(messageDiv);
                }

                messageDiv.textContent = message;


                if (color === "green") {
                    messageDiv.className = 'mt-4 p-3 rounded-lg text-center font-medium text-green-600 bg-green-50 border border-green-200';
                } else {
                    messageDiv.className = 'mt-4 p-3 rounded-lg text-center font-medium text-red-600 bg-red-50 border border-red-200';
                }

            }

            function confirmPurchase() {
                const modal = document.getElementById('confirmModal');
                modal.classList.remove('opacity-0', 'pointer-events-none');
                document.body.classList.add('modal-open'); // <-- Thêm dòng này
            }

            function closeModal() {
                const modal = document.getElementById('confirmModal');
                modal.classList.add('opacity-0', 'pointer-events-none');
                document.body.classList.remove('modal-open'); // <-- Và dòng này
            }



            document.addEventListener('DOMContentLoaded', () => {
                document
                        .getElementById('confirmButton')
                        .addEventListener('click', processPurchase);
            });

            function processPurchase() {
                const btn = document.getElementById('confirmButton');
                const orig = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Confirming…';
                btn.disabled = true;

                const params = new URLSearchParams();
                params.append('cartIds', '<%= cartIdsJson%>');

                const addr = document.querySelector('input[name="selectedAddress"]:checked');
                if (!addr) {
                    Swal.fire('Please select an address');
                    btn.innerHTML = orig;
                    btn.disabled = false;
                    return;
                }
                params.append('addressId', addr.value);

                const vid = document.getElementById('voucherId').value;
                if (vid) {
                    params.append('voucherId', vid);
                }

                fetch('<%= request.getContextPath()%>/checkout?action=processPurchase', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params.toString()
                })
                        .then(r => r.json())
                        .then(data => {
                            if (!data.success && data.message === "You must log in first.") {
                                Swal.fire({
                                    icon: 'warning',
                                    title: 'Login required',
                                    text: data.message,
                                    confirmButtonText: 'Go to Login',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false
                                }).then(() => {
                                    window.location.href = '<%= request.getContextPath()%>/login';
                                });
                                return;
                            }

                            if (data.success) {
                                closeModal();
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Order Placed Successfully!',
                                    text: data.message || 'Your order has been placed.',
                                    showConfirmButton: true,
                                    confirmButtonText: 'View My Carts',
                                    willClose: () => {
                                        // Redirect after closing popup
                                        window.location.href = '<%= request.getContextPath()%>/cart';
                                    }
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Oops...',
                                    text: data.message || 'Failed to process order'
                                });
                                closeModal();
                            }
                        })
                        .catch(() => {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'An error occurred. Please try again.'
                            });
                            closeModal();
                        })
                        .finally(() => {
                            btn.innerHTML = orig;
                            btn.disabled = false;
                        });
            }





            function validateForm() {
                const phone = document.getElementById('phoneInput').value.trim();
                const address = document.getElementById('addressInput').value.trim();

                let isValid = true;

                if (!phone) {
                    document.getElementById('phoneInput').classList.add('required-field');
                    isValid = false;
                } else {
                    document.getElementById('phoneInput').classList.remove('required-field');
                }

                if (!address) {
                    document.getElementById('addressInput').classList.add('required-field');
                    isValid = false;
                } else {
                    document.getElementById('addressInput').classList.remove('required-field');
                }

                return isValid;
            }


            document.addEventListener('DOMContentLoaded', function () {

                const updateBtn = document.getElementById('updateInfoBtn');
                if (updateBtn) {
                    updateBtn.addEventListener('click', updateCustomerInfo);
                }


                const phoneInput = document.getElementById('phoneInput');
                if (phoneInput && !phoneInput.value.trim()) {
                    phoneInput.focus();
                }


                const voucherInput = document.getElementById('voucherInput');
                if (voucherInput) {
                    voucherInput.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            applyVoucher();
                        }
                    });
                }


                if (phoneInput) {
                    phoneInput.addEventListener('input', function () {
                        if (this.value.trim()) {
                            this.classList.remove('required-field');
                        }
                    });
                }

                const addressInput = document.getElementById('addressInput');
                if (addressInput) {
                    addressInput.addEventListener('input', function () {
                        if (this.value.trim()) {
                            this.classList.remove('required-field');
                        }
                    });
                }

                const recipientInput = document.getElementById('recipientInput');
                if (recipientInput) {
                    recipientInput.addEventListener('input', function () {
                        if (this.value.trim()) {
                            this.classList.remove('required-field');
                        }
                    });
                }

                const addressNameInput = document.getElementById('addressNameInput');
                if (addressNameInput) {
                    addressNameInput.addEventListener('input', function () {
                        if (this.value.trim()) {
                            this.classList.remove('required-field');
                        }
                    });
                }


                const modal = document.getElementById('confirmModal');
                if (modal) {
                    window.onclick = function (event) {
                        if (event.target === modal) {
                            closeModal();
                        }
                    }
                }
            }
            );
        </script>
    </body>
</html>