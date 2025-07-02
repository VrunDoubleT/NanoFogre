<%-- 
    Document   : productByCategoryPage
    Created on : Jul 2, 2025, 9:54:17 PM
    Author     : Tran Thanh Van - CE181019
--%>

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
        <div class="w-full flex justify-center mt-[92px]">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8 py-6">
                <div class="grid grid-cols-10 gap-6 h-fit">
                    <div class="col-span-3 h-fit bg-[#f7f6f8]">
                        Filter product
                    </div>
                    <div id="listProduct" class="col-span-7 grid grid-cols-3 gap-4">

                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
        <script>
            function getUrlParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }
            const loadProducts = (categoryId) => {
                return fetch('/productsbycategory?type=list&categoryId=' + categoryId)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Network response was not ok');
                            return response.text();
                        })
                        .then(HTML => {
                            document.getElementById("listProduct").innerHTML = HTML
                            lucide.createIcons()
                        })
                        .catch(error => {
                            console.error('Lỗi khi fetch dữ liệu:', error);
                        });
            }

            const loadProductsAndPagination = (categoryId) => {
                Promise.all([
                    loadProducts(categoryId),
                ])
                        .then(() => {
                            console.log("Load success");
                        })
                        .catch(error => {
                            console.error("Error loading data:", error);
                        });
            }

            document.addEventListener("DOMContentLoaded", function () {
                const categoryId = getUrlParam("categoryId")
                loadProductsAndPagination(categoryId)
            });
        </script>
    </body>
</html>
