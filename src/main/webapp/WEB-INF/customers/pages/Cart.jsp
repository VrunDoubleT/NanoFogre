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

        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

    </head>
    <style>
        /* Chrome, Safari, Edge, Opera */
        input[type="number"]::-webkit-outer-spin-button,
        input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        /* Firefox */
        input[type="number"] {
            -moz-appearance: textfield;
        }
    </style>

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

                        <div class="bg-white rounded-2xl p-6 mb-8 border-l-4 border-purple-500 shadow-md">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                                    <svg class="w-6 h-6 text-purple-600" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M16 11V9a4 4 0 00-3-3.87V4a2 2 0 00-4 0v1.13A4 4 0 006 9v2l-2 2v1h16v-1l-2-2zM7 18a2 2 0 004 0H7z"/>
                                    </svg>
                                </div>
                                <div>
                                    <p class="font-semibold text-gray-700" >
                                        You have <span id="cartLineCount" class="text-purple-600 font-bold">${totalCart}</span> item(s) in your cart.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="grid lg:grid-cols-3 gap-8">
                            <!-- Cart Items -->
                            <div class="lg:col-span-2 space-y-6">
                                <div id="cart-list">
                                    <c:forEach var="item" items="${cartItems}" varStatus="status">

                                        <div class="product-card cart-product flex flex-col border sm:flex-row items-center bg-white rounded-2xl mb-5 p-5 gap-6 transition-all duration-300"
                                             id="cart-item-${item.cartId}"                                           
                                             data-idx="${status.index}">
                                            <!-- Checkbox -->
                                            <input 
                                                type="checkbox"
                                                class="item-checkbox accent-purple-500 w-5 h-5 mt-1 mr-0 cursor-pointer
                                                <c:if test='${item.product.quantity == 0}'> opacity-50 cursor-not-allowed</c:if>'"
                                                data-index="${status.index}"
                                                data-id="${item.cartId}"
                                                <c:if test='${item.product.quantity <=0}'>disabled</c:if>
                                                    >
                                                <!-- Image -->
                                                <img src="${not empty item.product.urls ? item.product.urls[0] : 'default.png'}"
                                                 alt="${item.product.title}" class="w-[146px] ${item.product.quantity <= 0 ? 'out-of-stock' : ''} h-[146px] object-cover rounded-lg border-2 border-gray-200" />
                                            <!-- Info -->
                                            <div class="flex-1 ml-0 sm:ml-6 w-full ${item.product.quantity <= 0 ? 'out-of-stock' : ''}">
                                                <h2 class="font-bold text-lg text-gray-800 leading-tight line-clamp-2 hover:text-purple-600 transition-colors cursor-pointer">${item.product.title}</h2>
                                                <div class="flex items-center flex-wrap gap-2 mt-2 text-sm">
                                                    <c:choose>
                                                        <c:when test="${item.product.quantity > 0}">
                                                            <span class="px-2 py-1 rounded-full bg-green-100 text-green-800 font-semibold">In Stock</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 py-1 rounded-full bg-red-100 text-red-800 font-semibold">Out of Stock</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800">${item.product.brand.name}</span>
                                                    <span class="px-2 py-1 rounded-full bg-pink-100 text-pink-800">${item.product.category.name}</span>
                                                </div>

                                                <p class="text-gray-500 mt-2">
                                                    Price:
                                                    <span class="font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                                                        ${CurrencyFormatter.formatVietNamCurrency(item.product.price)}đ
                                                    </span>
                                                </p>

                                                <div class="flex items-center gap-4 mt-3">
                                                    <label class="font-medium text-gray-700">Quantity:</label>
                                                    <div class="flex items-center border border-gray-300 rounded-md">
                                                        <button
                                                            type="button"
                                                            class="px-3 py-2 hover:bg-gray-50 transition-colors border-r border-gray-300 decreaseQuantityBtn"
                                                            data-cartid="${item.cartId}"
                                                            ${item.product.quantity <= 0 ? 'disabled' : ''}>
                                                            <i data-lucide="minus" class="w-4 h-4 text-gray-600"></i>
                                                        </button>

                                                        <input
                                                            type="number"
                                                            id="quantity-${item.cartId}"
                                                            value="${item.quantity > 0 ? item.quantity : 1}"
                                                            min="1"
                                                            max="${item.product.quantity}"
                                                            class="w-16 h-10 text-center  bg-transparent text-gray-900 focus:outline-none focus:ring-2 focus:ring-purple-500"
                                                            ${item.product.quantity <= 0 ? 'disabled' : ''}
                                                            />

                                                        <button
                                                            type="button"
                                                            class="px-3 py-2 hover:bg-gray-50 transition-colors border-l border-gray-300 increaseQuantityBtn"
                                                            data-cartid="${item.cartId}"
                                                            ${item.product.quantity <= 0 ? 'disabled' : ''}>
                                                            <i data-lucide="plus" class="w-4 h-4 text-gray-600"></i>
                                                        </button>
                                                    </div>
                                                    <span class="text-sm text-gray-500 ml-2">${item.product.quantity} available</span>
                                                </div>

                                            </div>
                                            <!-- Price & Action -->
                                            <div class="flex flex-col items-end gap-2 w-full sm:w-40 text-right sm:text-left mt-4 sm:mt-0">
                                                <div id="lineTotal-${item.cartId}"
                                                     class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                                                    ${CurrencyFormatter.formatVietNamCurrency(item.product.price * item.quantity)}đ
                                                </div>
                                                <button type="button" class="remove-btn  w-full py-1.5 rounded-md text-white bg-gradient-to-r from-rose-500 to-rose-600 hover:from-rose-600 hover:to-rose-700 text-sm" onclick="removeFromCart(${item.cartId})">🗑 Remove</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div id="loadMoreDots" class="text-center my-8 hidden">
                                    <span class="inline-block px-4 py-2 rounded-full bg-white border border-gray-200">
                                        <img src="https://res.cloudinary.com/dd9jweqlv/image/upload/v1753013466/Ellipsis_1x-1.5s-200px-200px_qwtjaq.svg" alt="Loading..." style="width:60px; height:30px; display:inline-block;" />
                                    </span>
                                </div>
                            </div>


                            <!-- Summary -->
                            <div class="cart-summary border border-gray-200 rounded-2xl p-8 flex flex-col h-fit sticky top-24">

                                <div class="fixed bottom-0 left-0 w-full z-50 bg-white border-t border-gray-200 shadow-2xl md:static md:shadow-none md:border-0" style="backdrop-filter: blur(8px);">
                                    <h2 class="uppercase text-center text-gray-800 font-bold text-xl mb-6 tracking-wider">Order Summary</h2>
                                    <div class="space-y-3 text-gray-700">
                                        <div class="flex justify-between">
                                            <span>Items:</span>
                                            <span class="font-bold text-lg text-yellow-500" id="itemCount">0</span>
                                        </div>
                                    </div>
                                    <div class="flex justify-between text-lg font-bold border-t border-gray-200 pt-4  text-gray-900">
                                        <span>Total:</span>
                                        <span class="text-2xl font-extrabold bg-gradient-to-r from-purple-500 to-pink-500 bg-clip-text text-transparent" id="grandTotal">0đ</span>
                                    </div>

                                    <button
                                        id="purchaseBtn"
                                        type="button"
                                        class="checkout-btn w-full mt-6 py-3 rounded-xl bg-gradient-to-r from-purple-500 to-pink-500 font-bold text-lg text-white shadow-lg duration-300 opacity-50 cursor-not-allowed"
                                        disabled
                                        >
                                        Purchase
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


        <!--        purchase-->
        <div id="purchaseModal" class="modal-overlay">
            <div class="modal-content p-6">
                <div id="purchaseModalContent">

                </div>
            </div>
        </div>

        <!-- JavaScript -->
        <script>

            lucide.createIcons();
            let currentPage = ${currentPage};
            const totalPages = ${totalPages};
            let isLoading = false;

            window.addEventListener('scroll', function () {
                if (isLoading || currentPage >= totalPages)
                    return;

                if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 100) {
                    setTimeout(() => {
                        loadMoreItems();
                    }, 500);
                }
            });

            function loadMoreItems() {

                console.log('loadMoreItems triggered');
                isLoading = true;
                currentPage++;

                const dots = document.getElementById('loadMoreDots');
                dots.classList.remove('hidden');

                fetch('${cartUrl}?action=loadMore&page=' + currentPage)
                        .then(resp => resp.json())
                        .then(data => {
                            if (data.length === 0) {
                                currentPage--;
                                return;
                            }
                            appendCartItems(data);
                        })
                        .catch(err => {
                            console.error(err);
                            currentPage--;
                        })
                        .finally(() => {
                            dots.classList.add('hidden');
                            isLoading = false;
                        });
            }


            function appendCartItems(items) {
                const cartList = document.getElementById('cart-list');

                items.forEach(item => {
                    cartItems.push({
                        id: item.cartId,
                        productId: item.product.productId,
                        price: item.product.price,
                        quantity: item.quantity,
                        stock: item.product.quantity,
                        title: item.product.title
                    });

                    const inStock = item.product.quantity > 0;
                    const disableCheckbox = !inStock ? 'disabled' : '';
                    const checkboxClass = !inStock ? 'opacity-50 cursor-not-allowed' : '';
                    const disableMinus = item.quantity <= 1 || !inStock ? 'disabled' : '';
                    const disablePlus = item.quantity >= item.product.quantity || !inStock ? 'disabled' : '';

                    const itemHtml = `
<div class="product-card cart-product flex flex-col sm:flex-row items-center bg-white rounded-2xl mt-[15px] p-5 shadow-lg gap-6 transition-all duration-300"
     id="cart-item-\${item.cartId}">

    <input type="checkbox"
           class="item-checkbox accent-purple-500 w-5 h-5 mt-1 mr-0 cursor-pointer \${checkboxClass}"
           data-id="\${item.cartId}" \${disableCheckbox} />

    <img src="\${item.product.urls[0] || 'default.png'}"
         alt="\${item.product.title}"
         class="w-[146px] \${!inStock ? 'out-of-stock' : ''} h-auto object-cover rounded-lg border-2 border-gray-200" />

    <div class="flex-1 ml-0 sm:ml-6 w-full \${!inStock ? 'out-of-stock' : ''}">
        <h2 class="font-bold text-lg text-gray-800 leading-tight line-clamp-2 hover:text-purple-600 transition-colors cursor-pointer">
            \${item.product.title}
        </h2>

        <div class="flex items-center flex-wrap gap-2 mt-2 text-sm">
            <span class="px-2 py-1 rounded-full \${inStock ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} font-semibold">
                \${inStock ? 'In Stock' : 'Out of Stock'}
            </span>
            <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800">\${item.product.brand.name}</span>
            <span class="px-2 py-1 rounded-full bg-pink-100 text-pink-800">\${item.product.category.name}</span>
        </div>

        <p class="text-gray-500 mt-2">
            Price: <span class="font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
                \${formatCurrencyVND(item.product.price)}
            </span>
        </p>

        <div class="flex items-center gap-3 mt-3" id="qty-group-\${item.cartId}" data-min="1" data-max="\${item.product.quantity}">
            <button type="button" class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                    onclick="updateQuantity(\${item.cartId}, -1)" id="decrease-\${item.cartId}" \${disableMinus}>–</button>

            <span id="qty-\${item.cartId}" class="w-8 text-center font-bold text-gray-900">\${item.quantity}</span>

            <button type="button" class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                    onclick="updateQuantity(\${item.cartId}, 1)" id="increase-\${item.cartId}" \${disablePlus}>+</button>
        </div>
    </div>

    <div class="flex flex-col items-end gap-2 w-full sm:w-40 text-right sm:text-left mt-4 sm:mt-0">
        <div id="lineTotal-\${item.cartId}" class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            \${formatCurrencyVND(item.product.price * item.quantity)}
        </div>
        <button type="button" class="remove-btn w-full py-1.5 rounded-md text-white bg-gradient-to-r from-rose-500 to-rose-600 hover:from-rose-600 hover:to-rose-700 text-sm"
                onclick="removeFromCart(\${item.cartId})">🗑 Remove</button>
    </div>
</div>`;



                    cartList.insertAdjacentHTML('beforeend', itemHtml);
                });

                attachCheckboxEvent();
                updateCartLineCount();
                recalc();
            }



            function attachCheckboxEvent() {
                document.querySelectorAll('.item-checkbox').forEach(ch => {
                    ch.removeEventListener('change', saveChecked);
                    ch.addEventListener('change', () => {
                        saveChecked();
                        recalc();
                    });
                });
            }

            document.addEventListener("DOMContentLoaded", function () {
                restoreChecked();
                attachCheckboxEvent();
                recalc();
            });


            const baseUrl = '${cartUrl}';
            const cartItems = [];
            <c:forEach var="item" items="${cartItems}">
            cartItems.push({
                id: ${item.cartId},
                productId: ${item.product.productId},
                price: ${item.product.price},
                quantity: ${item.quantity},
                stock: ${item.product.quantity},
                title: "${fn:escapeXml(item.product.title)}"
            });
            </c:forEach>


            function formatCurrencyVND(amount) {
                return amount.toLocaleString('vi-VN') + 'đ';
            }

            //////////quantiry////////////
            document.addEventListener("DOMContentLoaded", function () {
                attachQuantityBtnEvent();
                attachQuantityInputEvent();

                restoreChecked();
                attachCheckboxEvent();
                recalc();
            });


            function attachQuantityBtnEvent() {
                document.querySelectorAll('.increaseQuantityBtn').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const cartId = btn.getAttribute('data-cartid');
                        updateQuantity(cartId, 1);

                    });
                });
                document.querySelectorAll('.decreaseQuantityBtn').forEach(btn => {
                    btn.addEventListener('click', function () {
                        const cartId = btn.getAttribute('data-cartid');
                        updateQuantity(cartId, -1);
                    });
                });
            }

            function attachQuantityInputEvent() {
                document.querySelectorAll('input[id^="quantity-"]').forEach(input => {
                    input.addEventListener('change', function () {
                        const cartId = input.id.replace('quantity-', '');
                        let val = parseInt(input.value);
                        const max = parseInt(input.max) || 0;
                        const min = parseInt(input.min) || 1;
                        if (isNaN(val) || val < min)
                            val = min;
                        if (val > max)
                            val = max;
                        input.value = val;
                        updateQuantity(cartId, 0);
                    });
                });
            }


            function updateQuantity(cartId, change) {
                const input = document.getElementById('quantity-' + cartId);
                console.log("debug", input);

                if (!input || input.disabled)
                    return;

                let current = parseInt(input.value) || 0;
                const max = parseInt(input.max) || 0;
                const min = parseInt(input.min) || 1;

                if (max < min || max === 0) {
                    input.value = 0;
                    return;
                }

                let newVal = current + change;
                if (change === 0)
                    newVal = current;
                if (newVal > max)
                    newVal = max;
                if (newVal < min)
                    newVal = min;
                if (newVal === current && change !== 0)
                    return;

                input.value = newVal;


                fetch('/carts?type=update', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        cartId: cartId,
                        quantity: newVal
                    })
                })
                        .then(resp => resp.json())
                        .then(data => {
                            if (data.success) {

                                const item = cartItems.find(it => it.id == cartId);
                                if (item)
                                    item.quantity = newVal;

                                document.getElementById('lineTotal-' + cartId).textContent = formatCurrencyVND(item.price * newVal);
                                recalc();
                            } else {

                                alert(data.message || 'Update failed');
                                input.value = current;
                            }
                        })
                        .catch(() => {
                            input.value = current;
                            alert('Could not update quantity, please try again.');
                        });
            }

            //*  REMOVE  cart
            function removeFromCart(cartId) {
                cartId = Number(cartId);
                const found = cartItems.find(it => it.id === cartId);

                if (window.Swal) {
                    Swal.fire({
                        title: 'Remove item?',
                        text: 'Remove this item from your cart?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Yes, remove',
                        cancelButtonText: 'Cancel',
                        customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                    }).then(result => {
                        if (result.isConfirmed) {
                            doRemoveCartItem(cartId);
                        }
                    });
                } else {
                    if (confirm('Remove this item from your cart?')) {
                        doRemoveCartItem(cartId);
                    }
                }
            }


            function doRemoveCartItem(cartId) {
                setRemoveLoading(cartId, true);
                fetch('/carts?type=remove', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'remove',
                        cartId: cartId
                    })
                })
                        .then(resp => {
                            if (!resp.ok)
                                throw new Error('Remove failed');
                            return resp.json();
                        })
                        .then(data => {
                            if (!data.success) {
                                throw new Error(data.message || 'Remove failed');
                            }
                            const row = document.getElementById('cart-item-' + cartId);
                            if (row)
                                row.remove();
                            const idx = cartItems.findIndex(it => it.id === cartId);
                            if (idx > -1)
                                cartItems.splice(idx, 1);
                            if (typeof recalc === 'function')
                                recalc();
                            updateCartLineCount()
                            if (window.Swal) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Removed',
                                    text: data.message || 'Item removed from cart.',
                                    timer: 1200,
                                    showConfirmButton: false,
                                    customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                                });
                            }
                        })
                        .catch(err => {
                            console.error('Error removing item:', err);
                            if (window.Swal) {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: err.message || 'Failed to remove item. Please try again.',
                                    customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                                });
                            }
                        })

            }


            function setRemoveLoading(cartId, isLoading) {
                const row = document.getElementById('cart-item-' + cartId);
                if (row)
                    row.classList.toggle('loading', isLoading);
                ['decrease-', 'increase-', 'remove-'].forEach(prefix => {
                    const btn = document.getElementById(prefix + cartId);
                    if (btn)
                        btn.disabled = isLoading;
                });
            }

            //* update "You have X item(s) in your cart."
            function updateCartLineCount() {
                const el = document.getElementById('cartLineCount');
                if (!el)
                    return;
                el.textContent = cartItems.length;
            }



            // recalc summary 
            function recalc() {
                let itemCount = 0;
                let total = 0;
                document.querySelectorAll('.item-checkbox').forEach(ch => {
                    if (!ch.checked)
                        return;
                    const cartId = Number(ch.dataset.id);
                    const item = cartItems.find(it => it.id === cartId);
                    if (!item) {
                        console.warn('[recalc] No cartItem found for id', cartId);
                        return;
                    }
                    itemCount += item.quantity;
                    total += item.quantity * item.price;
                });

                document.getElementById('itemCount').textContent = itemCount;
                document.getElementById('grandTotal').textContent = total.toLocaleString('vi-VN') + 'đ';

                const btn = document.getElementById('purchaseBtn');
                if (btn) {
                    btn.disabled = itemCount === 0;
                    btn.classList.toggle('opacity-50', itemCount === 0);
                    btn.classList.toggle('cursor-not-allowed', itemCount === 0);
                }
            }



            const checked = Array.from(document.querySelectorAll('.item-checkbox'))
                    .filter(ch => ch.checked && !ch.disabled)
                    .map(ch => ch.dataset.id);

            function saveChecked() {
                const checked = Array.from(document.querySelectorAll('.item-checkbox'))
                        .filter(ch => ch.checked && !ch.disabled)
                        .map(ch => ch.dataset.id);
                localStorage.setItem('cart_checked', JSON.stringify(checked));
            }


            function restoreChecked() {
                const raw = localStorage.getItem('cart_checked');
                if (!raw)
                    return;
                let arr;
                try {
                    arr = JSON.parse(raw);
                } catch (e) {
                    return;
                }


                document.querySelectorAll('.item-checkbox').forEach(ch => {

                    if (!ch.disabled && arr.includes(ch.dataset.id)) {
                        ch.checked = true;
                    } else {
                        ch.checked = false;
                    }
                });
            }


            function removeCheckedCartId(cartId) {
                const key = 'cart_checked';
                const raw = localStorage.getItem(key);
                if (!raw)
                    return;
                let arr;
                try {
                    arr = JSON.parse(raw);
                } catch (e) {
                    arr = [];
                }
                const filtered = arr.filter(id => String(id) !== String(cartId));
                localStorage.setItem(key, JSON.stringify(filtered));
            }

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

                fetch('/carts', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        type: 'add',
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

            //----------Purchase-----------------//
            document.getElementById('purchaseBtn').addEventListener('click', () => {
                const checked = Array.from(document.querySelectorAll('.item-checkbox'))
                        .filter(ch => ch.checked)
                        .map(ch => ch.dataset.id);
                if (!checked.length) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'No items selected',
                        text: 'Please select at least one item to purchase.'
                    });
                    return;
                }
                const param = encodeURIComponent(JSON.stringify(checked));
                window.location.href = '<%= request.getContextPath()%>/checkout?cartIds=' + param;
            });

        </script>
    </body>
</html>