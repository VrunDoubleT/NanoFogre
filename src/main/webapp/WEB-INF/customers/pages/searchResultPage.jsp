<%-- 
    Document   : searchResultPage
    Created on : Jul 5, 2025, 1:46:39 AM
    Author     : Modern 15
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Results - Nano Forge</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .pulse-glow {
                animation: pulse-glow 3s ease-in-out infinite;
            }
            @keyframes pulse-glow {
                0%, 100% {
                    box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
                }
                50% {
                    box-shadow: 0 0 35px rgba(59, 130, 246, 0.6);
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <div class="w-full flex justify-center mt-24">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8">
                <c:choose>
                    <c:when test="${not empty keyword}">
                        <div class="flex items-center gap-3 mb-8">
                            <div class="w-12 h-12 bg-gradient-to-r from-blue-400 to-cyan-500 rounded-full flex items-center justify-center pulse-glow">
                                <i data-lucide="search" class="w-6 h-6 text-white"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    Search results for: <span class="text-blue-600">${keyword}</span>
                                </h2>
                                <p class="text-gray-600 font-light">See the products matching your keyword</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="flex items-center gap-3 mb-8">
                            <div class="w-12 h-12 bg-gradient-to-r from-gray-400 to-gray-500 rounded-full flex items-center justify-center">
                                <i data-lucide="info" class="w-6 h-6 text-white"></i>
                            </div>
                            <div>
                                <h2 class="text-2xl font-bold text-gray-800">
                                    No keyword provided
                                </h2>
                                <p class="text-gray-600 font-light">Please enter a keyword to search for products</p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div id="loading" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                </div>
                <div id="listProduct" class="grid md:grid-cols-3 grid-cols-2 lg:grid-cols-4 gap-4">
                </div>
                <div id="pagination">
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
        <script src="../../../js/header.js"></script>
        <script>
            lucide.createIcons();

            function getUrlParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }

            function updateUrlParam(key, value) {
                const url = new URL(window.location.href);
                const params = url.searchParams;
                params.delete(key);
                params.set(key, value);
                url.search = params.toString();
                window.history.replaceState({}, '', url);
            }

            const loadProducts = () => {
                const page = getUrlParam("page") || 1
                console.log("Product page: " + page);
                const keyword = getUrlParam("keyword")
                console.log("Product keyword " + keyword);
                let rootUrl = '/searchproduct?type=list'
                rootUrl += "&page=" + page
                rootUrl += "&keyword=" + keyword
                document.getElementById("loading").innerHTML = `
            <c:forEach begin="1" end="8" var="i">
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
                const page = getUrlParam("page") || 1
                const keyword = getUrlParam("keyword")
                console.log("Paginaiton page: " + page);
                let rootUrl = '/searchproduct?type=pagination'
                console.log("Paginaiton keyword " + page);
                rootUrl += "&page=" + page
                rootUrl += "&keyword=" + keyword
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

            document.addEventListener("DOMContentLoaded", function () {
                loadProductsAndPagination()
                reloadCart()
            });
        </script>
    </body>
</html>
