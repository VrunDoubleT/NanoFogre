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
    Address address = (Address) (request.getAttribute("address") != null
            ? request.getAttribute("address")
            : session.getAttribute("selectedAddress"));
    Voucher voucher = (Voucher) request.getAttribute("voucher");
    List<Address> availableAddresses = (List<Address>) request.getAttribute("availableAddresses");
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

    boolean isPhoneComplete = (customer != null && customer.getPhone() != null && !customer.getPhone().trim().isEmpty());
    boolean isAddressComplete = (address != null && address.getFullAddress() != null && !address.getFullAddress().trim().isEmpty());
    boolean canPurchase = isPhoneComplete && isAddressComplete;

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
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>

            .btn-primary {
                background: linear-gradient(135deg, #4f46e5 0%, #9333ea 100%);
                transition: all 0.25s ease;
                box-shadow: 0 4px 6px rgba(79, 70, 229, 0.4);
            }

            .btn-success {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                transition: all 0.25s ease;
                box-shadow: 0 4px 6px rgba(16, 185, 129, 0.4);
            }

            .btn-disabled {
                background: #9ca3af;
                cursor: not-allowed;
                box-shadow: none !important;
                transform: none !important;
                opacity: 0.7;
            }


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


            .required-field {
                border: 2px solid #fbbf24 !important;
                background-color: #fffbeb !important;
            }

            .product-image {
                width: 90px;
                height: 90px;
                object-fit: cover;
                border-radius: 12px;
                border: 2px solid #e0e7ff;
                transition: transform 0.3s ease;
            }


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

            @media (max-width: 640px) {
                body {
                    font-size: 14px;
                }
                .product-image {
                    width: 70px;
                    height: 70px;
                }
            }

            .glass-card {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }

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


            .modern-card {
                border-radius: 20px;
                transition: all 0.3s ease;
                border: 1px solid rgba(255,255,255,0.1);
            }

            .product-card {
                background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(255,255,255,0.8));
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255,255,255,0.2);
                transition: all 0.3s ease;
            }

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

            .valid-field {
                border-width: 2px !important;
                border-color: #10b981 !important;
            }

            .invalid-field {
                border-width: 2px !important;
                border-color: #ef4444 !important;
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

                <div class="xl:col-span-2 space-y-8">
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

                                    <input id="selectedAddressTopRadio"
                                           type="checkbox"
                                           name="selectedAddress"
                                           value="<%= address.getId()%>"
                                           hidden=""
                                           class="h-5 w-5 text-indigo-600 accent-indigo-500 mt-1"
                                           onchange="if (this.checked)
                                                       selectAddress(this.value)" />
                                    <div>
                                        <p id="selectedAddressName" class="font-semibold text-gray-800 text-lg">
                                            <%= address.getName()%>
                                        </p>
                                        <div class="text-sm text-gray-600 mt-1 space-y-1">
                                            <p>
                                                <i class="fas fa-phone mr-2 text-indigo-500"></i>
                                                <span id="selectedAddressPhone"><%= address.getPhone()%></span>
                                            </p>
                                            <p>
                                                <i class="fas fa-user mr-2 text-indigo-500"></i>
                                                <span id="selectedAddressRecipient"><%= address.getRecipientName()%></span>
                                            </p>
                                            <p>
                                                <i class="fas fa-location-dot mr-2 text-indigo-500"></i>
                                                <span id="selectedAddressDetails"><%= address.getDetails()%></span>
                                            </p>
                                        </div>
                                    </div>
                                </label>

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

                                            <div class="address-item group flex items-start justify-between p-4 bg-gray-50 rounded-lg border border-gray-200 hover:bg-white hover:shadow-md transition-all ${addr.id.equals(address.id) ? 'ring-2 ring-indigo-400 bg-white' : ''}"
                                                 data-address-id="${addr.id}"
                                                 data-name="${addr.name}"
                                                 data-recipient="${addr.recipientName}"
                                                 data-phone="${addr.phone}"
                                                 data-details="${addr.details}">
                                                <div class="flex-1">
                                                    <div class="flex items-center gap-2 mb-2">
                                                        <input type="radio" name="selectedAddress" value="${addr.id}"
                                                               class="text-indigo-600 h-5 w-5 cursor-pointer"/>

                                                        <span class="font-medium text-gray-900">${addr.name}</span>

                                                    </div>
                                                    <p class="text-sm text-gray-600 flex items-center mb-1">
                                                        <i class="fas fa-phone mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Phone:</strong>${addr.phone}
                                                    </p>
                                                    <p class="text-sm text-gray-600 flex items-center mb-1">
                                                        <i class="fas fa-user mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Recipient:</strong>${addr.recipientName}
                                                    </p>
                                                    <p class="text-sm text-gray-600 flex items-center">
                                                        <i class="fas fa-location-dot mr-2 text-gray-400"></i>
                                                        <strong class="mr-1">Address:</strong>${addr.details}
                                                    </p>
                                                </div>
                                                <div class="flex-shrink-0 ml-4 flex flex-col space-y-2">
                                                    <button type="button"
                                                            class="text-blue-600 hover:text-blue-800 transition-colors edit-address-btn"
                                                            onclick="editAddress(${addr.id})"
                                                            title="Edit address">
                                                        <i class="fas fa-edit"></i>
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
                    <section class="modern-card glass-card p-8 ">
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
                                            <span class="text-indigo-600 font-bold"><i class="fas fa-tag mr-1"></i><%= CurrencyFormatter.formatVietNamCurrency(p.getPrice())%>đ</span>
                                            <span class="bg-indigo-100 text-indigo-800 px-3 py-1 rounded-full text-sm font-medium">Quantity: <%= qty%></span>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div class="text-xl font-bold text-indigo-600"><%= CurrencyFormatter.formatVietNamCurrency(lineTotal)%>đ</div>
                                    </div> 
                                </div>
                            </div>
                            <% }%>
                        </div>
                    </section>

                    <!-- Payment Method -->
                    <section class="modern-card glass-card p-8">
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

                <div class="xl:col-span-1">
                    <div class="modern-card glass-card p-8 sticky top-24 animate-fade-in-up">
                        <!-- Voucher Section -->
                        <div class="mb-8">
                            <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-tags text-indigo-600 mr-2"></i>
                                Voucher Codes
                            </h3>

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
                                    <p class="text-white font-bold mt-2">Discount: -<%= CurrencyFormatter.formatVietNamCurrency(discount)%>đ</p>
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
                                    <div class="flex flex-wrap gap-2 max-h-48 overflow-y-auto">
                                        <% for (Voucher v : availableVouchers) {%>
                                        <button type="button"
                                                class="voucher-suggestion px-3 py-1 rounded-full bg-purple-100 hover:bg-purple-200 text-purple-700 text-sm font-medium shadow-sm border border-purple-200 transition-all"
                                                data-code="<%= v.getCode()%>"
                                                onclick="selectVoucher('<%= v.getCode()%>')"
                                                title="<%= v.getDescription()%>">
                                            <span class="font-mono"><%= v.getCode()%></span>
                                            <span class="ml-1 text-gray-500 text-xs">
                                                (<% if ("PERCENTAGE".equalsIgnoreCase(v.getType())) {%>
                                                <%= ((int) v.getValue())%>% off, up to <%= CurrencyFormatter.formatVietNamCurrency(v.getMaxValue())%>đ
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

                                    <span id="subtotalAmount" class="font-medium text-gray-800">
                                        <%= CurrencyFormatter.formatVietNamCurrency(subtotal)%>đ
                                    </span>
                                </div>

                                <div class="flex justify-between text-gray-600">
                                    <span class="text-gray-600">Shipping:</span>

                                    <span id="shippingAmount" class="font-medium text-green-600">
                                        <%= shippingFee > 0 ? CurrencyFormatter.formatVietNamCurrency(shippingFee) + "đ" : "Free"%>
                                    </span>
                                </div>

                                <div class="flex justify-between text-gray-600" id="discountRow" style="<%= discount > 0 ? "display:flex;" : "display:none;"%>"><span class="text-gray-600">Voucher Discount:</span><span id="discountAmount" class="text-green-600 font-medium">-<%= CurrencyFormatter.formatVietNamCurrency(discount)%> đ</span></div>

                                <div class="border-t border-gray-200 pt-4">
                                    <div class="flex justify-between">
                                        <span class="text-lg font-bold text-gray-800">Total Amount:</span><span id="totalAmount" class="text-2xl font-bold text-indigo-600 animate-pulse-glow"><%= CurrencyFormatter.formatVietNamCurrency(total)%>đ</span></div>
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
                <h3 class="text-2xl font-bold text-gray-800 mb-4 flex items-center ">
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
                            <%= CurrencyFormatter.formatVietNamCurrency(total)%>đ
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
                               class="modern-input w-full" >
                        <span id="nameError" class="text-sm text-red-500 mt-1"></span>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Recipient Name *</label>
                        <input id="recipientInput" name="recipientName" type="text"
                               class="modern-input w-full" >
                        <span id="recError" class="text-sm text-red-500 mt-1"></span>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Phone *</label>
                        <input id="phoneInput" name="addressPhone" type="text"
                               class="modern-input w-full" >
                        <p id="phoneError" class="text-sm text-red-500 mt-1"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">Full Address *</label>
                        <textarea id="detailsInput" name="addressDetails" rows="3"
                                  class="modern-input w-full" ></textarea>
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
            function renderSelectedAddressCard(addr) {
                document.getElementById('selectedAddressName').textContent = addr.name;
                document.getElementById('selectedAddressPhone').textContent = addr.phone;
                document.getElementById('selectedAddressRecipient').textContent = addr.recipient;
                document.getElementById('selectedAddressDetails').textContent = addr.details;
            }

            function updateAddressListSelection(selectedId) {
                document.querySelectorAll('#addressesList .address-item').forEach(div => {
                    const id = div.dataset.addressId;
                    const radio = div.querySelector('input[name="selectedAddress"]');
                    if (id === String(selectedId)) {
                        radio.checked = true;
                        div.classList.add('ring-2', 'ring-indigo-400', 'bg-white');
                        div.style.display = 'none';
                    } else {
                        div.classList.remove('ring-2', 'ring-indigo-400', 'bg-white');
                        div.style.display = '';
                    }
                });
            }


            function updatePurchaseButton() {
                const btn = document.getElementById('purchaseBtn');
                btn.disabled = false;
                btn.classList.remove('btn-disabled');
                btn.classList.add('btn-primary');
                btn.innerHTML = '<i class="fas fa-credit-card mr-2"></i>Place Order';
            }

            function showLoadingState() {
                const btn = document.getElementById('purchaseBtn');
                if (btn)
                    btn.disabled = true;

            }


            function hideLoadingState() {
                const btn = document.getElementById('purchaseBtn');
                if (btn)
                    btn.disabled = false;
            }


            function showNotification(message, type = 'success') {
                Toastify({
                    text: message,
                    duration: 3000,
                    gravity: 'top',
                    position: 'right',
                    close: true,
                    style: {
                        background: type === 'success' ? '#38a169' : '#e53e3e'
                    }
                }).showToast();
            }
            function selectAddress(addressId) {
                showLoadingState();
                fetch('<%= request.getContextPath()%>/checkout', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({action: 'selectAddress', addressId})
                })
                        .then(res => res.json())
                        .then(json => {
                            if (json.success) {
                                const addr = json.address;
                                renderSelectedAddressCard(addr);
                                updateAddressListSelection(addressId);

                                document.querySelectorAll('.address-item').forEach(item => {
                                    if (item.dataset.addressId == String(addressId)) {
                                        const topRadio = document.getElementById('selectedAddressTopRadio');
                                        topRadio.value = addr.id;
                                        topRadio.checked = true;

                                    }
                                });
                                updatePurchaseButton();
                                document.getElementById('addressesSection').classList.add('hidden');
                                showNotification(json.message, 'success');
                            } else {
                                showNotification(json.message || 'Error', 'error');
                            }
                        })
                        .catch(() => {
                            showNotification('Connection error', 'error');
                        })
                        .finally(hideLoadingState);
            }

            document.addEventListener('DOMContentLoaded', () => {

                document.querySelectorAll('#addressesList input[name="selectedAddress"]')
                        .forEach(radio => {
                            radio.addEventListener('change', e => {
                                selectAddress(e.target.value);
                            });
                        });

                const selectedTop = document.getElementById('selectedAddressTopRadio');
                if (selectedTop) {
                    updatePurchaseButton();
                    updateAddressListSelection(selectedTop.value);

                }
            });


            function toggleAddresses() {
                const sec = document.getElementById('addressesSection');
                const chevron = document.getElementById('addressesChevron');
                if (!sec || !chevron)
                    return;

                const nowHidden = sec.classList.toggle('hidden');
                chevron.classList.toggle('rotate-180');

                if (!nowHidden) {
                    setTimeout(() => sec.scrollIntoView({behavior: 'smooth', block: 'nearest'}), 100);
                }
            }

            // ==== Address Modal: Add & Edit ====
            const addressModal = document.getElementById('addressModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalIcon = document.getElementById('modalIcon');
            const addressForm = document.getElementById('addressForm');
            const addressIdInput = document.getElementById('addressIdInput');
            const addressNameInput = document.getElementById('addressNameInput');
            const recipientInput = document.getElementById('recipientInput');
            const phoneInput = document.getElementById('phoneInput');
            const detailsInput = document.getElementById('detailsInput');

            const prefixes = [
                '032', '033', '034', '035', '036', '037', '038', '039',
                '056', '058', '059', '099',
                '070', '076', '077', '078', '079', '089', '090', '091', '093', '094',
                '081', '082', '083', '084', '085',
                '086', '096', '097', '098'
            ];

            function openAddAddressModal() {
                modalTitle.textContent = 'Add New Address';
                modalIcon.className = 'fas fa-plus-circle text-indigo-600 mr-2';
                addressForm.reset();
                addressIdInput.value = '';
                addressModal.classList.remove('opacity-0', 'pointer-events-none');
                document.body.classList.add('modal-open');
                clearValidation();
            }

            function openEditAddressModal(addr) {
                modalTitle.textContent = 'Edit Address';
                modalIcon.className = 'fas fa-edit text-blue-600 mr-2';
                addressIdInput.value = addr.id;
                addressNameInput.value = addr.name;
                recipientInput.value = addr.recipient;
                phoneInput.value = addr.phone;
                detailsInput.value = addr.details;
                addressModal.classList.remove('opacity-0', 'pointer-events-none');
                document.body.classList.add('modal-open');
                clearValidation();
            }

            function editAddress(addressId) {
                const div = document.querySelector('.address-item[data-address-id="' + addressId + '"]');
                if (!div)
                    return;
                openEditAddressModal({
                    id: div.dataset.addressId,
                    name: div.dataset.name,
                    recipient: div.dataset.recipient,
                    phone: div.dataset.phone,
                    details: div.dataset.details
                });
            }


            function closeAddressModal() {
                addressModal.classList.add('opacity-0', 'pointer-events-none');
                document.body.classList.remove('modal-open');
            }


            addressModal.addEventListener('click', function (e) {
                if (e.target === addressModal) {
                    closeAddressModal();
                }
            });

            document.getElementById('addAddressBtn')
                    .addEventListener('click', openAddAddressModal);


            function bindEditButtons() {
                document.querySelectorAll('.edit-address-btn').forEach(btn => {
                    btn.onclick = null;
                    btn.addEventListener('click', e => {
                        const div = e.currentTarget.closest('.address-item');
                        openEditAddressModal({
                            id: div.dataset.addressId,
                            name: div.dataset.name,
                            recipient: div.dataset.recipient,
                            phone: div.dataset.phone,
                            details: div.dataset.details
                        });
                    });
                });
            }


            function validateField(el, ok, errEl, msg) {
                el.classList.toggle('valid-field', ok);
                el.classList.toggle('invalid-field', !ok);
                errEl.textContent = ok ? '' : msg;
            }

            function getExistingAddresses() {
                return Array.from(document.querySelectorAll('.address-item'))
                        .map(item => item.dataset.details.trim().toLowerCase());
            }

            function clearValidation() {
                [addressNameInput, recipientInput, phoneInput, detailsInput].forEach(i => {
                    i.classList.remove('valid-field', 'invalid-field');
                });
                [nameError, recError, phoneError, detailsError].forEach(e => {
                    e.textContent = '';
                });
            }


            // Submit form Add/Edit
            const contextPath = '<%= request.getContextPath()%>';
            addressForm.addEventListener('submit', e => {
                e.preventDefault();

                let ok = true;
                if (addressNameInput.value.trim() === '') {
                    validateField(nameInput, false, nameError, 'Address name is required.');
                    ok = false;
                }
                if (recipientInput.value.trim() === '') {
                    validateField(recipientInput, false, recError, 'Recipient name is required.');
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

                if (!ok) {
                    e.preventDefault();
                    return;
                }

                const d = detailsInput.value.trim().toLowerCase();
                const existing = getExistingAddresses();

                const currentId = addressIdInput.value;

                const id = addressIdInput.value.trim();
                const action = id ? 'editAddress' : 'addAddress';

                const params = new URLSearchParams({
                    action,
                    addressName: addressNameInput.value.trim(),
                    recipientName: recipientInput.value.trim(),
                    addressPhone: phoneInput.value.trim(),
                    addressDetails: detailsInput.value.trim()
                });

                if (id)
                    params.append('addressId', id);

                fetch(`${contextPath}/checkout`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params.toString()
                })
                        .then(r => r.json())
                        .then(json => {
                            if (!json.success) {
                                showNotification(json.message || 'Error', 'error');
                                return;
                            }
                            const addr = json.address;
                            if (action === 'addAddress') {
                                appendAddressItem(addr);
                                document.getElementById('addressesSection').classList;
                            } else {
                                updateAddressItem(addr);
                            }
                            closeAddressModal();
                            bindEditButtons();

                            showNotification(json.message || 'Address saved.', 'success');


                        })
                        .catch(() => showNotification('Network error', 'error'));
            });


            function appendAddressItem(addr) {
                const tpl = document.createElement('div');
                console.log('DEBUG innerHTML:', tpl.innerHTML);
                tpl.className = 'address-item group flex items-start justify-between p-4 bg-gray-50 rounded-lg border hover:bg-white';
                tpl.dataset.addressId = addr.id;
                tpl.dataset.name = addr.name;
                tpl.dataset.recipient = addr.recipient;
                tpl.dataset.phone = addr.phone;
                tpl.dataset.details = addr.details;
                console.log("test bug", tpl.dataset);

                tpl.innerHTML =
                        '<div class="flex-1">' +
                        '<div class="flex items-center gap-2 mb-2">' +
                        '<input type="radio" name="selectedAddress" value="' + addr.id + '" ' +
                        'onclick="selectAddress(' + addr.id + ')" ' +
                        'class="text-indigo-600 h-5 w-5 cursor-pointer" />' +
                        '<span class="font-medium text-gray-900">' + addr.name + '</span>' +
                        '</div>' +
                        '<p class="text-sm text-gray-600 flex items-center mb-1">' +
                        '<i class="fas fa-phone mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Phone:</strong> ' + addr.phone +
                        '</p>' +
                        '<p class="text-sm text-gray-600 flex items-center mb-1">' +
                        '<i class="fas fa-user mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Recipient:</strong> ' + addr.recipient +
                        '</p>' +
                        '<p class="text-sm text-gray-600 flex items-center">' +
                        '<i class="fas fa-location-dot mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Address:</strong> ' + addr.details +
                        '</p>' +
                        '</div>' +
                        '<div class="flex-shrink-0 ml-4 flex flex-col space-y-2">' +
                        '<button type="button" ' +
                        'class="text-blue-600 hover:text-blue-800 transition-colors edit-address-btn" ' +
                        'onclick="editAddress( ${addr.id} )" ' +
                        'title="Edit address">' +
                        '<i class="fas fa-edit"></i>' +
                        '</button>' +
                        '</div>';

                document.getElementById('addressesList').appendChild(tpl);
                bindEditButtons();

            }

            function updateAddressItem(addr) {
                const div = document.querySelector('.address-item[data-address-id="' + addr.id + '"]');
                if (!div)
                    return;

                div.dataset.name = addr.name;
                div.dataset.recipient = addr.recipient;
                div.dataset.phone = addr.phone;
                div.dataset.details = addr.details;

                div.querySelector('.flex-1').innerHTML =
                        '<div class="flex items-center gap-2 mb-2">' +
                        '<input type="radio" name="selectedAddress" value="' + addr.id + '"' +
                        ' onclick="selectAddress(' + addr.id + ')"' +
                        ' class="text-indigo-600 h-5 w-5 cursor-pointer" />' +
                        '<span class="font-medium text-gray-900">' + addr.name + '</span>' +
                        '</div>' +
                        '<p class="text-sm text-gray-600 flex items-center mb-1">' +
                        '<i class="fas fa-phone mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Phone:</strong> ' + addr.phone +
                        '</p>' +
                        '<p class="text-sm text-gray-600 flex items-center mb-1">' +
                        '<i class="fas fa-user mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Recipient:</strong> ' + addr.recipient +
                        '</p>' +
                        '<p class="text-sm text-gray-600 flex items-center">' +
                        '<i class="fas fa-location-dot mr-2 text-gray-400"></i>' +
                        '<strong class="mr-1">Address:</strong> ' + addr.details +
                        '</p>';

                div.querySelector('input[name="selectedAddress"]').checked = true;
            }
            addressForm.addEventListener('submit', function (e) {
                let ok = true;

                if (addressNameInput.value.trim() === '') {
                    validateField(addressNameInput, false, nameError, 'Address name is required.');
                    ok = false;
                }

                if (recipientInput.value.trim() === '') {
                    validateField(recipientInput, false, recError, 'Recipient name is required.');
                    ok = false;
                }

                const v = phoneInput.value.trim();
                if (!v) {
                    validateField(phoneInput, false, phoneError, 'Please enter your phone number.');
                    ok = false;
                }

                if (detailsInput.value.trim() === '') {
                    validateField(detailsInput, false, detailsError, 'Full address is required.');
                    ok = false;
                }
                if (!ok) {
                    e.preventDefault();
                    return;
                }
            });

            function validateField(el, ok, errEl, msg) {
                el.classList.toggle('valid-field', ok);
                el.classList.toggle('invalid-field', !ok);
                errEl.textContent = ok ? '' : msg;
            }
            phoneInput.addEventListener('input', () => {
                const v = phoneInput.value.trim();
                let ok = false, msg = '';
                if (!v) {
                    msg = 'Please enter your phone number.';
                } else if (!/^\d+$/.test(v)) {
                    msg = 'Phone must be digits only.';
                } else if (!(v.length === 10 || v.length === 11)) {
                    msg = 'Phone must be 10 or 11 digits.';
                } else {
                    const p3 = v.slice(0, 3), p4 = v.slice(0, 4);
                    if (!prefixes.includes(p3) && !prefixes.includes(p4)) {
                        msg = 'Invalid phone prefix.';
                    } else {
                        ok = true;
                    }
                }
                validateField(phoneInput, ok, document.getElementById('phoneError'), msg);
            });
            addressNameInput.addEventListener('input', () => {
                const ok = addressNameInput.value.trim() !== '';
                validateField(addressNameInput, ok, document.getElementById('nameError'), ok ? '' : 'Address name is required.');
            });
            recipientInput.addEventListener('input', () => {
                const ok = recipientInput.value.trim() !== '';
                validateField(recipientInput, ok, document.getElementById('recError'), ok ? '' : 'Recipient name is required.');
            });
            detailsInput.addEventListener('input', () => {
                const v = detailsInput.value.trim().toLowerCase();
                let ok = false, msg = '';
                if (!v) {
                    msg = 'Full address is required.';
                } else {
                    ok = true;
                }
                validateField(detailsInput, ok, document.getElementById('detailsError'), msg);
            });

            /////////////////Voucher /////////////////////////////////////
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
                                document.getElementById('subtotalAmount').textContent = data.subtotalFormatted + "đ";
                                if (data.discount > 0) {
                                    document.getElementById('discountRow').style.display = 'flex';
                                    document.getElementById('discountAmount').textContent = "-" + data.discountFormatted + "đ";
                                } else {
                                    document.getElementById('discountRow').style.display = 'none';
                                }
                                document.getElementById('totalAmount').textContent = data.totalFormatted + "đ";
                                document.getElementById('confirmModalTotal').textContent = data.totalFormatted + "đ";
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

                            const voucherCard = document.querySelector('.voucher-card');
                            if (voucherCard)
                                voucherCard.style.display = 'none';

                            const voucherFormBlock = document.querySelector('.space-y-3');
                            if (voucherFormBlock)
                                voucherFormBlock.style.display = '';
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
                                document.getElementById('subtotalAmount').textContent = data.subtotalFormatted + "đ";
                            if (document.getElementById('shippingAmount'))
                                document.getElementById('shippingAmount').textContent =
                                        (data.shipping > 0 ? data.shippingFormatted + "đ" : "Free");
                            if (document.getElementById('totalAmount'))
                                document.getElementById('totalAmount').textContent = data.totalFormatted + "đ";
                            if (document.getElementById('confirmModalTotal'))
                                document.getElementById('confirmModalTotal').textContent = data.totalFormatted + "đ";
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

            function confirmPurchase() {
                const modal = document.getElementById('confirmModal');
                modal.classList.remove('opacity-0', 'pointer-events-none');
                document.body.classList.add('modal-open');
            }

            function closeModal() {
                const modal = document.getElementById('confirmModal');
                modal.classList.add('opacity-0', 'pointer-events-none');
                document.body.classList.remove('modal-open');
            }

            document.addEventListener('DOMContentLoaded', () => {
                document
                        .getElementById('confirmButton')
                        .addEventListener('click', processPurchase);
            });
            ///-----------Purchase
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