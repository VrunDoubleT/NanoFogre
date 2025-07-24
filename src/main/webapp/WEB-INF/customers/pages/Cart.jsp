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

        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

                                        <div class="product-card cart-product flex flex-col sm:flex-row items-center bg-white rounded-2xl mt-[15px] p-5 shadow-lg gap-6 transition-all duration-300"
                                             id="cart-item-${item.cartId}"
                                             style="${status.index >= 5 ? 'display:none;' : ''}"
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
                                                 alt="${item.product.title}" class="w-[146px] ${item.product.quantity <= 0 ? 'out-of-stock' : ''} h-auto object-cover rounded-lg border-2 border-gray-200" />
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

                                                <div class="flex items-center gap-3 mt-3"
                                                     id="qty-group-${item.cartId}"
                                                     data-min="1"
                                                     data-max="${item.product.quantity}">

                                                    <button type="button"
                                                            class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                                                            onclick="updateQuantity(${item.cartId}, -1)"
                                                            id="decrease-${item.cartId}"
                                                            ${item.quantity <= 1 || item.product.quantity <=0 ? "disabled" : ""}

                                                            >–</button>


                                                    <span id="qty-${item.cartId}" class="w-8 text-center font-bold text-gray-900">${item.quantity}</span>

                                                    <button type="button"
                                                            class="w-8 h-8 rounded-full bg-gray-200 text-gray-800 flex items-center justify-center font-bold hover:bg-gray-300 transition disabled:opacity-50 disabled:cursor-not-allowed"
                                                            onclick="updateQuantity(${item.cartId}, 1)"
                                                            id="increase-${item.cartId}"
                                                            ${item.quantity >= item.product.quantity ? "disabled" : ""}>+</button>

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
                                <c:if test="${fn:length(cartItems) > 5}">
                                    <div id="loadMoreDots" class="text-center my-8 hidden">
                                        <span class="inline-block px-4 py-2 rounded-full bg-white border border-gray-200">
                                            <img src="https://res.cloudinary.com/dd9jweqlv/image/upload/v1753013466/Ellipsis_1x-1.5s-200px-200px_qwtjaq.svg" alt="Loading..." style="width:60px; height:30px; display:inline-block;" />
                                        </span>
                                    </div>
                                </c:if>
                            </div>


                            <!-- Summary -->
                            <div class="cart-summary bg-slate-50 border border-gray-200 rounded-2xl p-8 flex flex-col shadow-lg h-fit sticky top-24">

                                <div class="fixed bottom-0 left-0 w-full z-50 bg-white border-t border-gray-200 px-4 py-3 shadow-2xl md:static md:shadow-none md:border-0" style="backdrop-filter: blur(8px);">
                                    <h2 class="uppercase text-center text-gray-800 font-bold text-xl mb-6 tracking-wider">Order Summary</h2>
                                    <div class="space-y-3 text-gray-700">
                                        <div class="flex justify-between">
                                            <span>Items:</span>
                                            <span class="font-bold text-lg text-yellow-500" id="itemCount">0</span>
                                        </div>
                                    </div>
                                    <div class="flex justify-between text-lg font-bold border-t border-gray-200 pt-4  text-gray-900">
                                        <span>Total:</span>
                                        <span class="text-2xl font-extrabold bg-gradient-to-r from-purple-500 to-pink-500 bg-clip-text text-transparent" id="grandTotal">0 ₫</span>
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


            document.addEventListener('DOMContentLoaded', function () {
                let loadedCount = 5;
                const items = document.querySelectorAll('#cart-list .cart-product');
                const totalCount = items.length;
                const dots = document.getElementById('loadMoreDots');
                for (let i = loadedCount; i < items.length; ++i) {
                    items[i].style.display = 'none';
                }

                let dotsShown = false;
                window.addEventListener('scroll', function () {
                    if (!dots || dotsShown || loadedCount >= totalCount)
                        return;
                    const idxToCheck = Math.max(0, totalCount - 5);
                    if (items[idxToCheck]) {
                        const rect = items[idxToCheck].getBoundingClientRect();
                        if (rect.top < window.innerHeight) {
                            dots.classList.remove('hidden');
                            dotsShown = true;
                            setTimeout(() => {
                                showMoreItems();
                            }, 1200);
                        }
                    }
                });

                function showMoreItems() {
                    let showCount = 0;
                    for (let i = loadedCount; i < items.length && showCount < 5; ++i, ++showCount) {
                        items[i].style.display = '';
                    }
                    loadedCount += showCount;
                    dots.classList.add('hidden');
                    dotsShown = false;
                    if (loadedCount < totalCount) {
                    } else {
                        window.removeEventListener('scroll', arguments.callee, false);
                    }
                }

                restoreChecked();
                document.querySelectorAll('.item-checkbox').forEach(ch => {
                    ch.addEventListener('change', () => {
                        saveChecked();
                        recalc();
                    });
                });
                updateCartLineCount();
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
                return amount.toLocaleString('vi-VN') + ' ₫';
            }

            //* check button quantity
            function syncQtyButtons(cartId, qty, min, max) {
                const decBtn = document.getElementById("decrease-" + cartId);
                const incBtn = document.getElementById("increase-" + cartId);
                if (!decBtn || !incBtn)
                    return;
                const outOfStock = max === 0;
                decBtn.disabled = outOfStock || qty <= min;
                incBtn.disabled = outOfStock || qty >= max;
            }



            //*  Update total money
            function updateLineTotal(cartId, qty) {
                const el = document.getElementById('lineTotal-' + cartId);
                const item = cartItems.find(it => String(it.id) === String(cartId));
                if (!el || !item)
                    return;
                el.textContent = (item.price * qty).toLocaleString('vi-VN') + ' ₫';
            }


            //*  Update quattiy
            function updateQuantity(cartId, delta) {
                cartId = String(cartId);

                const group = document.getElementById('qty-group-' + cartId);
                const qtyEl = document.getElementById('qty-' + cartId);
                if (!group || !qtyEl)
                    return;

                const min = parseInt(group.dataset.min, 10) || 1;
                const max = parseInt(group.dataset.max, 10);
                const maxVal = Number.isNaN(max) ? Infinity : max;
                const current = parseInt(qtyEl.textContent, 10) || 0;

                let newQty = current + delta;
                if (newQty < min)
                    newQty = min;
                if (newQty > maxVal)
                    newQty = maxVal;

                if (newQty === current) {
                    syncQtyButtons(cartId, current, min, maxVal);
                    return;
                }

                fetch('/cart?action=update', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        action: 'update',
                        cartId: cartId,
                        quantity: newQty
                    }).toString()
                })
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Update failed: ' + response.status);
                            return response.json();
                        })
                        .then(data => {
                            console.log('[updateQuantity resp]', data);

                            const confirmedQty = parseInt(data.quantity, 10);
                            const serverMax = data.maxQuantity != null ? parseInt(data.maxQuantity, 10) : maxVal;

                            qtyEl.textContent = confirmedQty;
                            group.dataset.max = serverMax;
                            syncQtyButtons(cartId, confirmedQty, min, serverMax);

                            const found = cartItems.find(it => String(it.id) === cartId);
                            if (found) {
                                found.quantity = confirmedQty;
                                found.stock = serverMax;
                                updateLineTotal(cartId, confirmedQty);
                            }

                            recalc();
                            if (data.message && window.Swal) {
                                Swal.fire({
                                    icon: 'info',
                                    title: 'Notification',
                                    text: data.message,
                                    customClass: {popup: 'bg-gray-800 text-white rounded-lg'}
                                });
                            }
                        })
                        .catch(error => {
                            console.error('Update failed:', error);
                            if (window.Swal)
                                Swal.fire('Error', 'Quantity not updated', 'error');
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
                fetch('/cart?action=remove', {
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
                document.getElementById('grandTotal').textContent = total.toLocaleString('vi-VN') + ' ₫';

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