<%-- 
    Document   : Cart
    Created on : Jul 3, 2025, 4:21:17 PM
    Author     : iphon
--%>
<%-- 
    Document   : Cart
    Created on : Jul 3, 2025, 4:21:17 PM
    Author     : iphon
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="Utils.CurrencyFormatter" %>
<c:url var="cartUrl" value="/cart"/>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cart - NanoForge</title>
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <style>
            :root {
                --tech-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .cart-item {
                border: 1px solid rgba(255, 255, 255, 0.1);
                transition: all 0.3s ease;
            }

            .cart-item:hover {
                border-color: rgba(255, 255, 255, 0.2);
                transform: translateY(-2px);
            }

            .quantity-controls button {
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                color: white;
                width: 35px;
                height: 35px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.2s ease;
                font-size: 18px;
                font-weight: bold;
            }

            .quantity-controls button:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: scale(1.05);
            }

            .quantity-controls button:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .quantity-controls span {
                min-width: 40px;
                text-align: center;
                font-weight: bold;
                font-size: 16px;
            }

            .remove-btn {
                background: linear-gradient(135deg, #ff4757, #ff3838);
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s ease;
                margin-top: 8px;
            }

            .remove-btn:hover {
                background: linear-gradient(135deg, #ff3838, #ff2f2f);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(255, 71, 87, 0.4);
            }

            .related-btn {
                background: linear-gradient(135deg, #10b981, #059669);
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s ease;
                margin-top: 8px;
                margin-left: 8px;
            }

            .related-btn:hover {
                background: linear-gradient(135deg, #059669, #047857);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
            }

            .checkbox-custom {
                appearance: none;
                width: 20px;
                height: 20px;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 4px;
                position: relative;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .checkbox-custom:checked {
                background: var(--tech-gradient);
                border-color: #667eea;
            }

            .checkbox-custom:checked::after {
                content: '✓';
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: white;
                font-size: 12px;
                font-weight: bold;
            }


            .summary-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
                color: white;
            }

            .summary-row {
                padding: 0.5rem 0;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                margin-bottom: 0.5rem;
            }

            .checkout-btn {
                background: var(--tech-gradient);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 12px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .checkout-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            .continue-shopping {
                background: var(--tech-gradient);
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .continue-shopping:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            .loading {
                opacity: 0.6;
                pointer-events: none;
            }

            /* Modal Styles */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.8);
                backdrop-filter: blur(4px);
                z-index: 1000;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
            }

            .modal-overlay.active {
                opacity: 1;
                visibility: visible;
            }

            .modal-content {
                background: rgba(31, 41, 55, 0.95);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 20px;
                width: 90%;
                max-width: 1200px;
                max-height: 90vh;
                overflow-y: auto;
                transform: scale(0.9);
                transition: transform 0.3s ease;
            }

            .modal-overlay.active .modal-content {
                transform: scale(1);
            }

            .product-card {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 12px;
                transition: all 0.3s ease;
            }

            .product-card:hover {
                transform: translateY(-4px);
                border-color: rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(102, 126, 234, 0.2);
            }

            .add-to-cart-btn {
                background: var(--tech-gradient);
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s ease;
                width: 100%;
            }

            .add-to-cart-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            .add-to-cart-btn:disabled {
                background: rgba(255, 255, 255, 0.1);
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            /* Scrollbar styling */
            .modal-content::-webkit-scrollbar {
                width: 8px;
            }

            .modal-content::-webkit-scrollbar-track {
                background: rgba(255, 255, 255, 0.1);
                border-radius: 4px;
            }

            .modal-content::-webkit-scrollbar-thumb {
                background: rgba(255, 255, 255, 0.3);
                border-radius: 4px;
            }

            .modal-content::-webkit-scrollbar-thumb:hover {
                background: rgba(255, 255, 255, 0.5);
            }

            .glass-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .product-card {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
            }
            .product-card:hover {
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                transform: translateY(-2px);
            }
            .voucher-suggestion {
                cursor: pointer;
                outline: none;
            }
            .voucher-suggestion:focus {
                box-shadow: 0 0 0 2px #c4b5fd;
            }
        </style>
    </head>

    <body class="flex flex-col min-h-screen bg-white-900 text-white font-rajdhani">
        <jsp:include page="../common/header.jsp" />

        <!-- main -->
        <main class="flex-grow pt-24 container mx-auto px-4">

            <div class="max-w-5xl mx-auto">

                <!-- Header -->
                <div class="mb-10 text-center">
                    <h1 class="text-5xl font-black orbitron text-gray-800 mb-2" style="font-family: 'Orbitron', monospace;">🛒 Your Shopping Cart</h1>
                    <p class="text-gray-600 text-lg">Premium Model Collection – NanoForge</p>
                </div>

                <c:choose>
                    <c:when test="${not empty cartItems}">
                        <c:set var="totalCart" value="${fn:length(cartItems)}" />

                        <!-- Thẻ thông báo số lượng sản phẩm -->
                        <div class="bg-white rounded-2xl p-6 mb-8 border-l-4 border-purple-500 shadow-md">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                                    <svg class="w-6 h-6 text-purple-600" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M16 11V9a4 4 0 00-3-3.87V4a2 2 0 00-4 0v1.13A4 4 0 006 9v2l-2 2v1h16v-1l-2-2zM7 18a2 2 0 004 0H7z"/>
                                    </svg>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-700">
                                        You have <span class="text-purple-600 font-bold">${totalCart}</span> item(s) in your cart.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="grid lg:grid-cols-3 gap-8">
                            <!-- Cart Items -->
                            <div class="lg:col-span-2 space-y-6">
                                <c:forEach var="item" items="${cartItems}" varStatus="status">
                                    <!-- Card sản phẩm -->
                                    <div class="product-card flex flex-col sm:flex-row items-center bg-white rounded-2xl p-5 shadow-lg gap-6 transition-all duration-300 hover:shadow-xl hover:ring-2 hover:ring-purple-400 group">
                                        <!-- Checkbox -->
                                        <input type="checkbox"
                                               class="item-checkbox accent-purple-500 w-5 h-5 mt-1 mr-0 cursor-pointer"
                                               data-index="${status.index}"
                                               data-id="${item.cartId}"
                                               onchange="handleCheckboxChange(this)">
                                        <!-- Image -->
                                        <img src="${not empty item.product.urls ? item.product.urls[0] : 'default.png'}"
                                             alt="${item.product.title}" class="w-[146px] h-auto object-cover rounded-lg border-2 border-gray-200" />
                                        <!-- Info -->
                                        <div class="flex-1 ml-0 sm:ml-6 w-full">
                                            <h2 class="font-bold text-lg text-gray-800 leading-tight line-clamp-2 hover:text-purple-600 transition-colors cursor-pointer">${item.product.title}</h2>
                                            <div class="flex items-center flex-wrap gap-2 mt-2 text-sm">
                                                <span class="px-2 py-1 rounded-full bg-green-100 text-green-800 font-semibold"
                                                      <c:if test="${item.product.quantity == 0}">style="display:none;"</c:if>>
                                                          In Stock
                                                      </span>
                                                      <span class="px-2 py-1 rounded-full bg-red-100 text-red-800 font-semibold"
                                                      <c:if test="${item.product.quantity > 0}">style="display:none;"</c:if>>
                                                          Out of Stock
                                                      </span>
                                                      <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800">${item.product.brand.name}</span>
                                                <span class="px-2 py-1 rounded-full bg-pink-100 text-pink-800">${item.product.category.name}</span>
                                                <c:if test="${item.product.averageStar > 0}">
                                                    <span class="flex items-center gap-1 text-yellow-500 font-bold">
                                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                                        </svg>
                                                        ${item.product.averageStar}
                                                    </span>
                                                </c:if>
                                            </div>
                                            <p class="text-gray-500 mt-2">
                                                Price:
                                                <span class="font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                                                    ${CurrencyFormatter.formatVietNamCurrency(item.product.price)}đ
                                                </span>
                                            </p>
                                            <div class="flex items-center gap-3 mt-3">
                                                <button type="button"
                                                        class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                                                        onclick="updateQuantity(${status.index}, -1)"
                                                        id="decrease-${status.index}"
                                                        <c:if test="${item.quantity <= 1 || item.product.quantity == 0}">disabled</c:if>>
                                                            –
                                                        </button>
                                                        <span id="qty-${status.index}" class="w-8 text-center font-bold text-gray-900">${item.quantity}</span>
                                                <button type="button"
                                                        class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                                                        onclick="updateQuantity(${status.index}, 1)"
                                                        id="increase-${status.index}"
                                                        <c:if test="${item.product.quantity == 0}">disabled</c:if>>
                                                            +
                                                        </button>
                                                </div>
                                            </div>
                                            <!-- Price & Action -->
                                            <div class="flex flex-col items-end gap-2 w-full sm:w-40 text-right sm:text-left mt-4 sm:mt-0">
                                                <div id="total-${status.index}"
                                                 class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                                                ${CurrencyFormatter.formatVietNamCurrency(item.product.price * item.quantity)}đ
                                            </div>
                                            <button class="remove-btn w-full bg-gradient-to-r from-red-500 to-pink-600 text-white py-1.5 rounded-lg font-semibold mt-2 hover:scale-105 transition" onclick="removeItem(${status.index})" id="remove-${status.index}">🗑 Remove</button>
                                            <button class="related-btn w-full bg-gradient-to-r from-blue-500 to-purple-500 text-white py-1.5 rounded-lg font-semibold hover:scale-105 transition"
                                                    onclick="showRelatedProducts(${item.product.productId}, ${item.product.brand.id}, ${item.product.category.id})">
                                                🔍 Related
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Summary -->
                            <div class="cart-summary bg-slate-50 border border-gray-200 rounded-2xl p-8 flex flex-col shadow-lg h-fit sticky top-24">
                                <h2 class="uppercase text-center text-gray-800 font-bold text-xl mb-6 tracking-wider">Order Summary</h2>
                                <div class="space-y-3 text-gray-700">
                                    <div class="flex justify-between">
                                        <span>Items:</span>
                                        <span class="font-bold text-lg text-yellow-500" id="itemCount">0</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span>Subtotal:</span>
                                        <span class="font-bold text-green-600" id="subtotal">0 ₫</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span>Tax (10%):</span>
                                        <span class="font-bold text-green-600" id="vat">0 ₫</span>
                                    </div>
                                </div>
                                <div class="flex justify-between text-lg font-bold border-t border-gray-200 pt-4 mt-4 mb-5 text-gray-900">
                                    <span>Total:</span>
                                    <span class="text-2xl font-extrabold bg-gradient-to-r from-purple-500 to-pink-500 bg-clip-text text-transparent" id="grandTotal">0 ₫</span>
                                </div>
                                <!--voucher-->
                                <div class="flex flex-col items-center mb-2 gap-3">
                                    <div class="w-full flex gap-2">
                                        <input id="voucherInput" type="text"
                                               class="bg-white border border-gray-300 text-gray-800 text-sm rounded-lg focus:ring-purple-500 focus:border-purple-500 block w-full p-2.5 text-center"
                                               placeholder="Enter voucher code...">
                                        <button id="applyVoucherBtn"
                                                class="bg-gradient-to-r from-green-500 to-green-600 text-white font-bold px-6 py-2 rounded-lg hover:brightness-110 transition"
                                                onclick="applyVoucher()">
                                            Apply
                                        </button>
                                    </div>

                                    <c:if test="${not empty availableVouchers}">
                                        <div class="mt-3 w-full">
                                            <label class="block text-sm text-gray-500">Available vouchers:</label>
                                            <div class="flex flex-wrap gap-2">
                                                <c:forEach var="v" items="${availableVouchers}">
                                                    <button type="button"
                                                            class="voucher-suggestion px-3 py-1 rounded bg-purple-100 hover:bg-purple-200 text-purple-700 text-sm font-semibold shadow border border-purple-300 transition"
                                                            data-code="${v.code}"
                                                            onclick="selectVoucher('${v.code}')"
                                                            title="${v.description}">
                                                        ${v.code}
                                                    </button>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>


                                <div id="voucherMessage" class="text-sm mt-2 min-h-[32px] text-center font-medium rounded-lg"></div>



                                <button class="checkout-btn w-full mt-6 py-3 rounded-xl bg-gradient-to-r from-purple-500 to-pink-500 font-bold text-lg text-white shadow-lg hover:scale-105 transition-transform duration-300">
                                    Proceed to Checkout
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart text-center py-20 bg-white rounded-2xl shadow-md">
                            <div class="empty-cart-icon text-7xl opacity-30">🛒</div>
                            <h3 class="text-3xl text-gray-700 font-semibold mt-4 mb-2">Your cart is empty!</h3>
                            <p class="text-gray-500 mb-8">Looks like you haven't added anything to your cart yet.</p>
                            <a href="/" class="continue-shopping inline-block px-8 py-3 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 text-white font-semibold shadow-lg hover:scale-105 transition-transform duration-300">Continue Shopping</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />

        <!-- Related Products Modal -->
        <div id="relatedProductsModal" class="modal-overlay">
            <div class="modal-content p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-white">Related Products</h2>
                    <button onclick="closeRelatedProducts()" class="text-gray-400 hover:text-white text-2xl font-bold">×</button>
                </div>
                <div id="relatedProductsContent">
                    <!-- Loading animation -->
                    <div class="flex justify-center items-center py-12">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-500"></div>
                        <span class="ml-3 text-gray-400">Loading related products...</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript -->
        <script>
            const baseUrl = '${cartUrl}';
            let isProcessing = false;

            const cartItems = [];
            <c:forEach var="item" items="${cartItems}" varStatus="status">
            cartItems.push({
                id: ${item.cartId},
                productId: ${item.product.productId},
                price: ${item.product.price},
                quantity: ${item.quantity},
                stock: ${item.product.quantity},
                title: "${item.product.title}"
            });
            </c:forEach>


            // loading state
            function setLoading(index, isLoading) {
                const cartItem = document.getElementById(`cart-item-${index}`);
                const decreaseBtn = document.getElementById(`decrease-${index}`);
                const increaseBtn = document.getElementById(`increase-${index}`);
                const removeBtn = document.getElementById(`remove-${index}`);

                if (cartItem) {
                    if (isLoading) {
                        cartItem.classList.add('loading');
                    } else {
                        cartItem.classList.remove('loading');
                    }
                }

                if (decreaseBtn) {
                    decreaseBtn.disabled = isLoading;
                }

                if (increaseBtn) {
                    increaseBtn.disabled = isLoading;
                }

                if (removeBtn) {
                    removeBtn.disabled = isLoading;
                }
            }

            //  update quantity vs improved UX
            function updateQuantity(index, delta) {
                if (isProcessing)
                    return;

                const item = cartItems[index];
                // in product íntock don't can change
                if (item.stock === 0)
                    return;
                const newQuantity = Math.max(1, item.quantity + delta);
                if (newQuantity === item.quantity)
                    return;

                isProcessing = true;
                setLoading(index, true);

                const oldQuantity = item.quantity;

                fetch(baseUrl, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'update',
                        cartId: item.id,
                        quantity: newQuantity
                    }).toString()
                })
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Update Successs');
                            updateUIQuantity(index, newQuantity);
                            recalc();
                            window.location.href = baseUrl;
                        })
                        .catch(error => {
                            console.error('Update failed:', error);
                            updateUIQuantity(index, newQuantity);
                            recalc(); // cập nhật Order Summary

                        })
                        .finally(() => {
                            isProcessing = false;
                            setLoading(index, false);
                        });
            }

            // update UI quantity
            function updateUIQuantity(index, quantity) {
                const qtyEl = document.getElementById(`qty-${index}`);
                const totalEl = document.getElementById(`total-${index}`);

                if (cartItems[index]) {
                    cartItems[index].quantity = quantity;
                }

                if (qtyEl) {
                    qtyEl.textContent = quantity;
                }

                if (totalEl) {
                    const total = quantity * cartItems[index].price;
                    totalEl.textContent = total.toLocaleString('vi-VN') + ' ₫';
                }
            }

            //  remove item với confirmation
            const toast = Swal.mixin({
                buttonsStyling: false,
                customClass: {
                    popup: 'bg-gray-800 text-white rounded-lg p-6',
                    title: 'text-2xl font-semibold',
                    content: 'mt-2 text-gray-300',
                    // cho nút Cancel bình thường
                    cancelButton: 'bg-gray-600 hover:bg-gray-700 focus:ring-gray-500 text-white font-medium px-4 py-2 rounded mr-4',
                    // cho nút Confirm thêm margin-left để dãn cách
                    confirmButton: 'bg-red-600 hover:bg-red-700 focus:ring-red-500 text-white font-medium px-4 py-2 rounded mr-4'
                }
            });

            function removeItem(index) {
                if (isProcessing)
                    return;
                if (index < 0 || index >= cartItems.length) {
                    console.error('Invalid cart item index:', index);
                    return;
                }
                const item = cartItems[index];

                toast.fire({
                    title: 'Remove "' + item.title + '"?',
                    text: "This item will be permanently removed from your cart.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, delete it',
                    cancelButtonText: 'Cancel',
                    reverseButtons: false,
                    focusCancel: true
                }).then((result) => {
                    if (!result.isConfirmed)
                        return;

                    isProcessing = true;
                    setLoading(index, true);

                    fetch(baseUrl, {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({
                            action: 'remove',
                            cartId: item.id
                        }).toString()
                    })
                            .then(response => {
                                if (!response.ok)
                                    throw new Error('Network response was not ok');
                                //  slide-out vs Tailwind:
                                const cartItemEl = document.getElementById(`cart-item-${index}`);
                                if (cartItemEl) {
                                    cartItemEl.classList.add('transition-all', 'duration-300', 'ease-in-out');
                                    cartItemEl.classList.add('translate-x-full', 'opacity-0');
                                    // animation, reload or redirect
                                    setTimeout(() => window.location.href = baseUrl, 500);
                                } else {
                                    // fallback
                                    window.location.href = baseUrl;
                                }
                            })
                            .catch(err => {
                                console.error('Error removing item:', err);
                                toast.fire({
                                    icon: 'error',
                                    title: 'Oops...',
                                    text: 'Failed to remove item. Please try again.',
                                    confirmButtonText: 'OK'
                                });
                                setLoading(index, false);
                            })
                            .finally(() => {
                                isProcessing = false;
                            });
                });
            }

            // persist checkbox state in localStorage
            function saveChecked() {
                const checked = Array.from(document.querySelectorAll('.item-checkbox'))
                        .filter(ch => ch.checked)
                        .map(ch => ch.getAttribute('data-id'));
                localStorage.setItem('cart_checked', JSON.stringify(checked));
            }

            function restoreChecked() {
                const data = localStorage.getItem('cart_checked');
                if (!data)
                    return;
                const checked = JSON.parse(data);
                document.querySelectorAll('.item-checkbox').forEach(ch => {
                    ch.checked = checked.includes(ch.getAttribute('data-id'));
                });
            }

            // recalc summary and toggle checkout button
            function recalc() {
                let itemCount = 0, subtotal = 0;

                document.querySelectorAll('.item-checkbox').forEach((ch, idx) => {
                    if (ch.checked) {
                        const item = cartItems[idx];
                        itemCount += item.quantity;
                        subtotal += item.quantity * item.price;
                    }
                });

                const vat = Math.round(subtotal * 0.1);
                let total = subtotal + vat;

                // Delete old voucher
                const discountEl = document.getElementById('voucherDiscountRow');
                if (discountEl)
                    discountEl.remove();

                if (voucherDiscount > 0) {
                    const discountLine = `
            <div id="voucherDiscountRow" class="summary-row flex justify-between text-green-400 font-bold">
                <span>Voucher Discount:</span>
                <span>- ${voucherDiscount.toLocaleString('vi-VN')} ₫</span>
            </div>
        `;
                    const totalRow = document.getElementById('grandTotalRow');
                    if (totalRow)
                        totalRow.insertAdjacentHTML('beforebegin', discountLine);

                    total -= voucherDiscount;
                    if (total < 0)
                        total = 0;
                }

                document.getElementById('itemCount').textContent = itemCount;
                document.getElementById('subtotal').textContent = subtotal.toLocaleString('vi-VN') + ' ₫';
                document.getElementById('vat').textContent = vat.toLocaleString('vi-VN') + ' ₫';
                document.getElementById('grandTotal').textContent = total.toLocaleString('vi-VN') + ' ₫';

                // toggle nút checkout
                const btn = document.querySelector('.checkout-btn');
                if (itemCount > 0) {
                    btn.disabled = false;
                    btn.classList.remove('disabled');
                } else {
                    btn.disabled = true;
                    btn.classList.add('disabled');
                }
            }
////------------Show Related Product-------------/////////////////////
// Show Related Products Modal + Fetch
            function showRelatedProducts(productId, brandId, categoryId) {
                const modal = document.getElementById('relatedProductsModal');
                const content = document.getElementById('relatedProductsContent');
                modal.classList.add('active');
                content.innerHTML = `
        <div class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-500"></div>
            <span class="ml-3 text-gray-400">Loading related products...</span>
        </div>
    `;
                fetch('/cart', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'related',
                        productId: productId,
                        brandId: brandId,
                        categoryId: categoryId
                    })
                })
                        .then(res => res.text())
                        .then(html => {
                            content.innerHTML = html;
                        })
                        .catch(() => {
                            content.innerHTML = `
            <div class="text-center py-12">
                <div class="text-6xl opacity-30 mb-4">⚠️</div>
                <h3 class="text-xl text-red-400 mb-2">Error loading related products</h3>
            </div>
        `;
                        });
            }


// Đóng modal
            function closeRelatedProducts() {
                document.getElementById('relatedProductsModal').classList.remove('active');
                setTimeout(() => window.location.reload());
            }

// Đóng khi click nền tối
            document.getElementById('relatedProductsModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeRelatedProducts();
            });
////-----------------Add Cart-------------///////
            const cartProductIdSet = new Set(cartItems.map(item => item.productId));

            function addToCart(productId) {
                const button = event.target;
                const originalText = button.textContent;
                button.textContent = 'Adding...';
                button.disabled = true;

                if (cartProductIdSet.has(productId)) {
                    Swal.fire({
                        icon: 'info',
                        title: 'Notice',
                        text: 'This product is already in your cart!',
                        customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                    });
                    button.textContent = '✓ Added';
                    button.classList.add('opacity-50', 'cursor-not-allowed');
                    button.disabled = true;
                    return;
                }

                fetch('/cart', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'add',
                        productId: productId,
                        quantity: 1
                    })
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                button.textContent = '✓ Added';
                                button.classList.add('opacity-50', 'cursor-not-allowed');
                                button.disabled = true;
                                cartProductIdSet.add(productId);
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Added to Cart!',
                                    text: 'Product has been added to your cart.',
                                    timer: 1200,
                                    showConfirmButton: false,
                                    customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                                });

                            } else {
                                throw new Error(data.message || 'Failed to add to cart');
                            }
                        })
                        .catch(error => {
                            console.error('Error adding to cart:', error);
                            button.textContent = originalText;
                            button.disabled = false;
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: error.message || 'Failed to add product to cart. Please try again.',
                                customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                            });
                        });
            }


            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN').format(amount);
            }

            // Close modal when clicking outside
            document.getElementById('relatedProductsModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeRelatedProducts();
                    setTimeout(() => window.location.reload());
                }
            });

            // Close modal on Escape key
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeRelatedProducts();
                    setTimeout(() => window.location.reload());
                }
            });


            /////////-----------voucher-----------////////////////
            let currentVoucher = null;
            let voucherDiscount = 0; // Unit:  VNĐ
            function selectVoucher(code) {
                document.getElementById('voucherInput').value = code;
                document.getElementById('voucherInput').focus();

            }

            function applyVoucher() {
                const code = document.getElementById('voucherInput').value.trim();
                if (!code) {
                    showVoucherMessage("Please enter a voucher code.", "red");
                    return;
                }

                let subtotal = 0;
                document.querySelectorAll('.item-checkbox').forEach((ch, idx) => {
                    if (ch.checked) {
                        const item = cartItems[idx];
                        subtotal += item.quantity * item.price;
                    }
                });

                fetch(baseUrl, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'voucher',
                        code: code,
                        subtotal: subtotal
                    })
                })
                        .then(res => res.json())
                        .then(data => {
                            console.log('Voucher API response:', data);
                            if (data.valid) {
                                voucherDiscount = data.discountAmount;
                                showVoucherMessage("🎉 Voucher applied: " + data.description, "green");
                            } else {
                                voucherDiscount = 0;
                                showVoucherMessage("❌ " + data.message, "red");
                            }
                            recalc();
                        })
                        .catch(() => {
                            showVoucherMessage("❌ Error applying voucher. Try again!", "red");
                        });
            }

            function showVoucherMessage(msg, color) {
                const el = document.getElementById('voucherMessage');
                el.textContent = msg;
                // Reset
                el.className = 'text-sm mt-2 min-h-[32px] text-center font-medium rounded-lg px-3 py-2 transition-all';
                // Xác định màu nền + màu chữ phù hợp
                if (color === "red") {
                    el.classList.add("bg-red-100", "text-red-700", "border", "border-red-300");
                } else if (color === "green") {
                    el.classList.add("bg-green-100", "text-green-700", "border", "border-green-300");
                } else if (color === "yellow") {
                    el.classList.add("bg-yellow-100", "text-yellow-800", "border", "border-yellow-300");
                } else {
                    el.classList.add("bg-gray-100", "text-gray-700", "border", "border-gray-300");
                }
            }




            document.addEventListener('DOMContentLoaded', () => {
                restoreChecked();
                document.querySelectorAll('.item-checkbox').forEach(ch => {
                    ch.addEventListener('change', () => {
                        saveChecked();
                        recalc();
                    });
                });
                recalc();
            });

        </script>
    </body>
</html>