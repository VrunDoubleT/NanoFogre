<%-- 
    Document   : productByCategoryPage
    Created on : Jul 2, 2025, 9:54:17 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
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
        <div class="w-full flex justify-center mt-[72px]">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8 py-6">
                <div class="border-y flex flex-col gap-3 md:flex-row justify-between items-center py-2 mb-5 bg-[#fafafa] px-3 border-[##d5dbdb]">
                    <div class="flex items-center gap-2">
                        <div class="w-10 h-10 rounded-[50%] overflow-hidden">
                            <img class="w-full h-full object-cover" src="${category.avatar}" alt="alt"/>
                        </div>
                        <span>${category.name}</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <label class="block text-md font-bold text-gray-700">Sort By</label>
                        <select id="sortSelect" class="px-1 w-[240px] py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="title">Title A-Z</option>
                            <option value="-title">Title Z-A</option>
                            <option value="-price">Highest price</option>
                            <option value="price">Lowest price</option>
                        </select>
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-10 gap-6 h-fit">
                    <div class="md:col-span-3 h-fit bg-[#f7f6f8] px-6 py-4 rounded-lg">
                        <h2 class="text-lg font-semibold text-gray-800 mb-4"">Filter by brand</h2>
                        <c:if test="${not empty brands}">
                            <c:forEach var="brand" items="${brands}"> 
                                <div class="flex gap-3 mb-1 items-center">
                                    <input id="brand-${brand.id}" data-id="${brand.id}" class="brand-checkbox shrink-0 w-4 h-4 cursor-pointer" id="brand-${brand.id}" type="checkbox" />
                                    <label for="brand-${brand.id}" class="flex gap-2">
                                        <div class="w-6 h-6">
                                            <img class="h-full w-full object-cover" src="${brand.url}" alt="alt"/>
                                        </div>
                                        <h3>${brand.name}</h3>
                                    </label>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty brands}">
                            <div class="text-red-500">No brand</div>
                        </c:if>

                    </div>
                    <div class="md:col-span-7">
                        <div id="loading" class="grid grid-cols-2 lg:grid-cols-3 gap-4">
                        </div>
                        <div id="listProduct" class="grid grid-cols-2 lg:grid-cols-3 gap-4">
                        </div>
                        <div id="pagination">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
        <script src="../../../js/header.js"></script>
        <script>
            function getUrlParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }
            function getUrlParamValues(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.getAll(name);
            }

            function addToUrlParamIfNotExists(key, value) {
                const url = new URL(window.location.href);
                const params = url.searchParams;
                const existingValues = params.getAll(key);
                if (!existingValues.includes(value.toString())) {
                    params.append(key, value);
                    url.search = params.toString();
                    window.history.replaceState({}, '', url);
                }
            }
            function updateUrlParam(key, value) {
                const url = new URL(window.location.href);
                const params = url.searchParams;
                params.delete(key);
                params.set(key, value);
                url.search = params.toString();
                window.history.replaceState({}, '', url);
            }

            function removeFromUrlParam(key, value) {
                const url = new URL(window.location.href);
                const params = url.searchParams;
                const remainingValues = params.getAll(key).filter(val => val !== value.toString());
                params.delete(key);
                remainingValues.forEach(val => params.append(key, val));
                url.search = params.toString();
                window.history.replaceState({}, '', url);
            }


            const loadProducts = () => {
                const categoryId = getUrlParam("categoryId")
                const brandIdList = getUrlParamValues("brandId");
                const sort = getUrlParam("sort") || "title"
                const page = getUrlParam("page") || 1
                let rootUrl = '/productsbycategory?type=list&categoryId=' + categoryId
                brandIdList.forEach(bid => {
                    rootUrl += "&brandId=" + bid
                })
                rootUrl += "&sort=" + sort
                rootUrl += "&page=" + page

                document.getElementById("loading").innerHTML = `
            <c:forEach begin="1" end="6" var="i">
        <div class="rounded-xl border overflow-hidden animate-pulse bg-white">
            <div class="mb-6 bg-gradient-to-br from-gray-100 to-gray-200 h-48 w-full"></div>

            <div class="px-5 space-y-3">
                <div class="h-4 bg-gray-200 rounded w-3/4"></div>
                <div class="flex items-center gap-2">
                    <div class="flex gap-1">
                        <div class="w-3 h-3 bg-gray-200 rounded-full"></div>
                        <div class="w-3 h-3 bg-gray-200 rounded-full"></div>
                        <div class="w-3 h-3 bg-gray-200 rounded-full"></div>
                        <div class="w-3 h-3 bg-gray-200 rounded-full"></div>
                        <div class="w-3 h-3 bg-gray-200 rounded-full"></div>
                    </div>
                    <div class="h-3 bg-gray-200 rounded w-8"></div>
                    <div class="h-3 bg-gray-200 rounded w-16"></div>
                </div>
                <div class="flex gap-4">
                    <div class="h-3 bg-gray-200 rounded w-20"></div>
                    <div class="h-3 bg-gray-200 rounded w-16"></div>
                </div>
                <div class="flex gap-3">
                    <div class="h-5 bg-gray-200 rounded-full w-20"></div>
                    <div class="h-5 bg-gray-200 rounded-full w-24"></div>
                </div>
                <div class="h-3 bg-gray-200 rounded w-24"></div>
                <div class="h-6 bg-gray-300 rounded w-28 mt-3 mb-4"></div>
            </div>
        </div>
            </c:forEach>
`;
                document.getElementById("listProduct").innerHTML = ''
                return fetch(rootUrl)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.text();
                        })
                        .then(HTML => {
                            document.getElementById("listProduct").innerHTML = HTML
                            document.getElementById("loading").innerHTML = ''
                            lucide.createIcons()
                        })
                        .catch(error => {
                            console.error('Error when loading error:', error);
                        });
            }

            function loadPagination() {
                const categoryId = getUrlParam("categoryId")
                const brandIdList = getUrlParamValues("brandId");
                const page = getUrlParam("page") || 1
                let rootUrl = '/productsbycategory?type=pagination&categoryId=' + categoryId
                brandIdList.forEach(bid => {
                    rootUrl += "&brandId=" + bid
                })
                rootUrl += "&page=" + page
                return fetch(rootUrl)
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
                                    updateUrlParam("page", page)
                                    loadProductsAndPagination()
                                });
                            })
                        })
                        .catch(error => {
                            console.error('Lỗi khi fetch dữ liệu:', error);
                        });
            }

            const loadProductsAndPagination = () => {
                Promise.all([
                    loadProducts(),
                    loadPagination()
                ])
                        .then(() => {
                            console.log("Load success");
                        })
                        .catch(error => {
                            console.error("Error loading data:", error);
                        });
            }

            const reRenderSort = () => {
                const sortBy = getUrlParam("sort") || "title"
                const select = document.getElementById('sortSelect');
                if (select) {
                    select.value = sortBy
                }
            }

            const reRenderBrand = () => {
                const brandIdList = getUrlParamValues("brandId");
                brandIdList.forEach(brandId => {
                    document.getElementById("brand-" + brandId).checked = true;
                })
            }

            document.addEventListener("DOMContentLoaded", function () {
                const categoryId = getUrlParam("categoryId")
                loadProductsAndPagination()
                reRenderBrand()
                reRenderSort()
                reloadCart();
            });

            document.querySelectorAll('input.brand-checkbox').forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    const id = this.dataset.id;
                    const checked = this.checked;
                    if (checked) {
                        addToUrlParamIfNotExists("brandId", id)
                    } else {
                        removeFromUrlParam("brandId", id)
                    }
                    updateUrlParam("page", 1)
                    loadProductsAndPagination();
                });
            });
            document.getElementById('sortSelect').addEventListener('change', function () {
                const value = this.value;
                updateUrlParam("sort", value)
                loadProductsAndPagination();
            });
        </script>
    </body>
</html>
