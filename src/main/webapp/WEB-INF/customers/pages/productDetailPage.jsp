
<%-- 
    Document   : productDetailPage
    Created on : Jul 2, 2025, 8:40:24 AM
    Author     : Tran Thanh Van - CE181019
--%>

<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Utils.CurrencyFormatter"%>
<%@page import="Utils.DateFormatter"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${product.title} - Product Detail</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            .star-filled {
                color: #fbbf24;
            }
            .star-empty {
                color: #e5e7eb;
            }
            .gradient-button {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            .gradient-button:hover {
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <div class="w-full flex justify-center mt-[92px]">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8 py-6">
                <!-- Main Product Section -->
                <div class="">

                    <div class="grid grid-cols-1 lg:grid-cols-10 gap-10">
                        <!-- Product Images -->
                        <div class="lg:col-span-4">
                            <!-- Main Image -->
                            <div class="aspect-square bg-white rounded-lg overflow-hidden mb-4 shadow-sm">
                                <img id="mainImage" 
                                     src="${product.urls[0]}" 
                                     alt="${product.title}"
                                     class="w-full h-full object-cover">
                            </div>

                            <!-- Thumbnail Images -->
                            <div class="flex gap-3 flex-wrap justify-center">
                                <c:forEach var="imageUrl" items="${product.urls}" varStatus="status">
                                    <div class="w-20 h-20 bg-white rounded-lg overflow-hidden border border-gray-200 cursor-pointer hover:border-blue-400 transition-colors"
                                         onclick="changeMainImage('${imageUrl}')">
                                        <img src="${imageUrl}" 
                                             alt="${product.title} ${status.index + 1}"
                                             class="w-full h-full object-cover">
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Product Information -->
                        <div class="space-y-3 lg:col-span-6">
                            <!-- Product Title -->
                            <h1 class="text-2xl lg:text-3xl font-bold text-gray-900 leading-tight">
                                ${product.title}
                            </h1>

                            <!-- Brand & Stock Status -->
                            <div class="flex items-center justify-between">
                                <div class="flex gap-3">
                                    <span class="text-blue-600 bg-blue-50 font-medium text-sm px-2 py-1 rounded-md">
                                        ${product.brand.name}
                                    </span>
                                    <span class="text-pink-600 bg-pink-50 font-medium text-sm px-2 py-1 rounded-md">
                                        ${product.category.name}
                                    </span>
                                </div>
                                <div>
                                    <c:if test="${product.quantity > 0}">
                                        <span class="text-green-600 font-medium text-sm bg-green-50 px-2 py-1 rounded-md">
                                            In Stock
                                        </span>
                                    </c:if>
                                    <c:if test="${product.quantity == 0}">
                                        <span class="text-red-600 font-medium text-sm bg-red-50 px-2 py-1 rounded-md">
                                            Out of Stock
                                        </span>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Rating & Reviews -->
                            <div class="flex items-center gap-2">
                                <div class="flex items-center">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i data-lucide="star" class="w-4 h-4 ${i <= product.averageStar ? 'star-filled' : 'star-empty'}" 
                                           style="fill: ${i <= product.averageStar ? '#fbbf24' : '#e5e7eb'}"></i>
                                    </c:forEach>
                                </div>
                                <span class="font-semibold text-gray-900">${product.averageStar}</span>
                                <span class="text-blue-600 text-sm">
                                    (${product.totalReviews} reviews)
                                </span>
                            </div>

                            <!-- Price -->
                            <div class="text-3xl font-bold text-red-500 mt-2 mb-4">
                                ${CurrencyFormatter.formatVietNamCurrency(product.price)}đ
                            </div>

                            <!-- Specifications -->
                            <div class="space-y-4 mt-2">
                                <h3 class="text-lg font-semibold text-gray-900">Specifications</h3>
                                <div class="space-y-3">
                                    <c:set var="hasValue" value="false" />
                                    <c:forEach var="attr" items="${product.attributes}">
                                        <c:if test="${not empty attr.value}">
                                            <c:set var="hasValue" value="true" />
                                            <div class="flex justify-between items-center">
                                                <span class="text-gray-600">${attr.name}:</span>
                                                <span class="font-semibold text-gray-900 text-right">
                                                    ${attr.value}<c:if test="${not empty attr.unit}"> ${attr.unit}</c:if>
                                                    </span>
                                                </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty product.attributes or not hasValue}">
                                        <div class="text-gray-500 text-sm italic">
                                            This product has no attributes.
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Quantity & Add to Cart -->
                            <div class="space-y-4 pt-6 border-t border-gray-200">
                                <!-- Quantity Selector -->
                                <div class="flex items-center gap-4">
                                    <label class="font-medium text-gray-700">Quantity:</label>
                                    <div class="flex items-center border border-gray-300 rounded-md">
                                        <button type="button" 
                                                id="decreaseQuantityBtn"
                                                class="px-3 py-2 hover:bg-gray-50 transition-colors border-r border-gray-300">
                                            <i data-lucide="minus" class="w-4 h-4 text-gray-600"></i>
                                        </button>
                                        <input type="number" id="quantity" value="0" min="1" max="${product.quantity}" 
                                               class="w-16 bg-transparent text-center border-0 focus:ring-0 focus:outline-none py-2 font-medium appearance-none [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none">
                                        <button type="button" 
                                                class="px-3 py-2 hover:bg-gray-50 transition-colors border-l border-gray-300" 
                                                id="increaseQuantityBtn">
                                            <i data-lucide="plus" class="w-4 h-4 text-gray-600"></i>
                                        </button>
                                    </div>
                                    <span class="text-sm text-gray-500">${product.quantity} available</span>
                                </div>

                                <!-- Action Buttons -->
                                <div class="flex gap-3">
                                    <button type="button" 
                                            class="flex-1 gradient-button text-white font-semibold py-3 px-6 rounded-md transition-all duration-200 flex items-center justify-center gap-2 ${product.quantity == 0 ? 'opacity-50 cursor-not-allowed' : 'hover:shadow-md'}"
                                            onclick="addToCart()"
                                            ${product.quantity == 0 ? 'disabled' : ''}>
                                        <i data-lucide="shopping-cart" class="w-5 h-5"></i>
                                        Add to Cart
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Details Tabs -->
                <div class="bg-white mt-8">
                    <h2 class="px-4 py-4 text-2xl font-semibold text-gray-800 border-b pb-2 border-gray-200">
                        About this Item
                    </h2>
                    <div class="p-4">
                        <div class="prose max-w-none">
                            <p class="text-gray-600 leading-relaxed">
                                ${product.description}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Reviews Section -->
                <div class="rounded-lg mt-8">
                    <h2 class="px-4 mb-5 py-4 text-2xl font-semibold text-gray-800 border-b pb-2 border-gray-200">
                        Reviews
                    </h2>
                    <div class="bg-white rounded-3xl shadow-sm border border-gray-200 p-8 flex items-center flex-col lg:flex-row gap-6 mb-6">
                        <div class="px-8 flex items-center border-b py-3 lg:border-r lg:border-b-0 lg:py-0">
                            <div class="flex items-center gap-4">
                                <div class="text-center">
                                    <div class="text-3xl font-bold text-gray-900">${reviewStats.averageStars}</div>
                                    <div class="flex items-center justify-center gap-1 mb-1">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i data-lucide="star" class="w-4 h-4 ${i <= reviewStats.averageStars ? 'star-filled' : 'star-empty'}" 
                                               style="fill: ${i <= product.averageStar ? '#fbbf24' : '#e5e7eb'}"></i>
                                        </c:forEach>
                                    </div>
                                    <div class="text-sm text-gray-500 mt-2">Based on ${reviewStats.totalReviews} reviews</div>
                                </div>
                            </div>
                        </div>
                        <div class="flex-1 px-8 flex flex-wrap gap-3">
                            <!-- All button -->
                            <button star="0" onclick="handleFilterReview(event, 0)" class="active filterReview px-4 py-2 border text-gray-700 border-gray-400 bg-gray-300 hover:bg-gray-300 hover:border-gray-400 rounded-lg text-sm font-medium ">
                                All (${reviewStats.totalReviews})
                            </button>

                            <!-- 5 stars -->
                            <button star="5" onclick="handleFilterReview(event, 5)" class="px-4 filterReview py-2 border border-yellow-300 rounded-lg text-sm font-medium text-yellow-600 bg-yellow-50 hover:bg-yellow-200 hover:border-yellow-400 transition flex items-center gap-2">
                                <div class="flex items-center gap-1">
                                    <span>5</span>
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                </div>
                                <span>(${reviewStats.fiveStar})</span>
                            </button>

                            <!-- 4 stars -->
                            <button star="4" onclick="handleFilterReview(event, 4)" class="px-4 filterReview py-2 border border-yellow-300 rounded-lg text-sm font-medium text-yellow-600 bg-yellow-50 hover:bg-yellow-200 hover:border-yellow-400 transition flex items-center gap-2">
                                <div class="flex items-center gap-1">
                                    <span>4</span>
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                </div>
                                <span>(${reviewStats.fourStar})</span>
                            </button>

                            <!-- 3 stars -->
                            <button star="3" onclick="handleFilterReview(event, 3)" class="px-4 filterReview py-2 border border-yellow-300 rounded-lg text-sm font-medium text-yellow-600 bg-yellow-50 hover:bg-yellow-200 hover:border-yellow-400 transition flex items-center gap-2">
                                <div class="flex items-center gap-1">
                                    <span>3</span>
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                </div>
                                <span>(${reviewStats.threeStar})</span>
                            </button>

                            <!-- 2 stars -->
                            <button star="2" onclick="handleFilterReview(event, 2)" class="px-4 filterReview py-2 border border-yellow-300 rounded-lg text-sm font-medium text-yellow-600 bg-yellow-50 hover:bg-yellow-200 hover:border-yellow-400 transition flex items-center gap-2">
                                <div class="flex items-center gap-1">
                                    <span>2</span>
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                </div>
                                <span>(${reviewStats.twoStar})</span>
                            </button>

                            <!-- 1 star -->
                            <button star="1" onclick="handleFilterReview(event, 1)" class="px-4 py-2 filterReview border border-yellow-300 rounded-lg text-sm font-medium text-yellow-600 bg-yellow-50 hover:bg-yellow-200 hover:border-yellow-400 transition flex items-center gap-2">
                                <div class="flex items-center gap-1">
                                    <span>1</span>
                                    <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-current"></i>
                                </div>
                                <span>(${reviewStats.oneStar})</span>
                            </button>
                        </div>

                    </div>

                    <!-- Reviews List -->
                    <div id="reviewList">

                    </div>

                    <!-- View All Reviews -->
                    <div id="pagination" class="text-center mt-6">
                    </div>
                </div>

            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />

        <script src="../../../js/header.js"></script>
        <script>
            // Initialize Lucide icons
            lucide.createIcons();

            // Change main image
            function changeMainImage(imageUrl) {
                document.getElementById('mainImage').src = imageUrl;

                // Update active thumbnail
                const thumbnails = document.querySelectorAll('[onclick*="changeMainImage"]');
                thumbnails.forEach(thumb => {
                    thumb.classList.remove('border-blue-400');
                    thumb.classList.add('border-gray-200');
                });
                event.target.closest('[onclick*="changeMainImage"]').classList.add('border-blue-400');
                event.target.closest('[onclick*="changeMainImage"]').classList.remove('border-gray-200');
            }



            function getUrlParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }


            function loadReview(productId, star, page) {
                return fetch('/review?type=list&productId=' + productId + "&star=" + star + "&page=" + page)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.text();
                        })
                        .then(HTML => {
                            document.getElementById("reviewList").innerHTML = HTML
                            lucide.createIcons()
                        })
                        .catch(error => {
                            console.error('Lỗi khi fetch dữ liệu:', error);
                        });
            }

            function loadPagination(productId, star, page) {
                return fetch('/review?type=pagination&productId=' + productId + "&star=" + star + "&page=" + page)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.text();
                        })
                        .then(HTML => {
                            document.getElementById("pagination").innerHTML = HTML
                            lucide.createIcons()
                            document.querySelectorAll("div.pagination").forEach(elm => {
                                elm.addEventListener("click", function () {
                                    const page = parseInt(elm.getAttribute("page")) || 1;
                                    loadReview(productId, star, page);
                                    loadPagination(productId, star, page);
                                });
                            })
                        })
                        .catch(error => {
                            console.error('Lỗi khi fetch dữ liệu:', error);
                        });
            }

            function loadReviewAndPagination(productId, star, page) {
                Promise.all([
                    loadReview(productId, star, page),
                    loadPagination(productId, star, page)
                ])
                        .then(() => {
                            console.log("Load success");
                        })
                        .catch(error => {
                            console.error("Error loading data:", error);
                        });
            }

            function handleFilterReview(event, star) {
                const element = event.currentTarget;
                document.querySelectorAll(".filterReview").forEach((elm) => {
                    elm.classList.remove("bg-gray-300", "border-gray-400", "bg-yellow-200", "border-yellow-400", "active")
                })
                if (star === 0) {
                    element.classList.add("bg-gray-300", "border-gray-400", "active");
                } else {
                    element.classList.add("bg-yellow-200", "border-yellow-400", "active");
                }
                const productId = getUrlParam("pId") || 0
                loadReviewAndPagination(productId, star, 1)
            }

            const getQuantityOfProduct = async () => {
                const productId = getUrlParam("pId");
                try {
                    const res = await fetch('/carts?type=quantity&productId=' + productId);
                    const data = await res.json();
                    return data.quantity;
                } catch (err) {
                    console.error(err);
                    return 0;
                }
            };

            let quantity = 1;

            const loadQuantity = (value) => {
                document.getElementById("quantity").value = value
            }

            document.getElementById("increaseQuantityBtn").onclick = async  () => {
                const quantityOfProduct = await getQuantityOfProduct();
                if (quantity < quantityOfProduct) {
                    quantity++;
                    loadQuantity(quantity)
                }
                console.log(quantityOfProduct);
            }

            document.getElementById("decreaseQuantityBtn").onclick = async  () => {
                if (quantity > 1) {
                    quantity--;
                    loadQuantity(quantity)
                }
            }

            const quantityInput = document.getElementById("quantity");
            let isFocused = false
            quantityInput.addEventListener("focus", () => {
                isFocused = true;
            });
            quantityInput.addEventListener("blur", () => {
                isFocused = false;
                if (!quantityInput.value) {
                    loadQuantity(quantity)
                } else {
                    quantity = parseInt(quantityInput.value)
                }
            });

            quantityInput.addEventListener("input", async (e) => {
                if (isFocused) {
                    const quantityOfProduct = await getQuantityOfProduct();
                    const valueStr = e.target.value;
                    if (valueStr === "") {
                        return;
                    }

                    const value = parseInt(valueStr);

                    if (isNaN(value) || value < 1 || value > quantityOfProduct) {
                        if (value < 1) {
                            loadQuantity(1)
                        } else {
                            loadQuantity(quantityOfProduct)
                        }
                    } else {
                        console.log("Giá trị hợp lệ:", value);
                    }
                }
            });

            document.addEventListener("DOMContentLoaded", function () {
                const productId = getUrlParam("pId") || 0
                loadReviewAndPagination(productId, 0, 1)
                loadQuantity(quantity)
                reloadCart()
            });


            function addToCart() {
                const productId = getUrlParam('pId');

                fetch('/carts', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        type: 'add',
                        productId: productId,
                        quantity: quantity
                    })
                })
                        .then(res => res.json())
                        .then(data => {
                            quantity = 1
                            loadQuantity(quantity)
                            Swal.fire(data.isSuccess ? 'Added' : 'Error', data.message, data.isSuccess ? 'success' : 'error');
                            reloadCart();
//                            if (data.success) {
//
//                                const badge = document.querySelector('.cart-badge');
//                                if (badge)
//                                    badge.textContent = data.cartQuantity;
//
//                                const cartCountEl = document.getElementById('cartCount');
//                                if (cartCountEl)
//                                    cartCountEl.textContent = data.cartQuantity;
//                                
//                            } else {
//                                Swal.fire('Error', data.message || 'Could not add to cart!', 'error');
//                            }
                        })
                        .catch(err => {
                            window.location.href = "/auth?action=login";
                        });
            }

        </script>
    </body>
</html>
