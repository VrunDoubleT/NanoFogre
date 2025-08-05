<%-- 
    Document   : adminLayout
    Created on : Jun 6, 2025, 4:27:53 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Nano Forge</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
        <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
        <!-- CSS of Toastify -->
        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <!-- JS of Toastify -->
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <!-- SweetAlert2 CDN -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <!-- JS of chart -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>



    </head>
    <body>
        <%@ include file="../../common/loading.jsp" %>
        <%@ include file="../common/employeeHeader.jsp" %>
        <div id="modal" class="fixed inset-0 bg-black bg-opacity-80 flex items-center justify-center z-50 hidden">
            <div id="modalContent" class="bg-white max-h-[90%] rounded-2xl overflow-y-auto">
                <!-- Load content -->
            </div>
        </div>
        <div style="display: flex;">
            <%@ include file="adminSidebar.jsp" %>
            <div id="main-content" class="bg-gray-100 w-full h-[calc(100vh-74px)] px-8 py-6 overflow-y-auto">
                <!-- Dynamic content will be loaded here -->
            </div>
        </div>

        <script>
            lucide.createIcons();
            function parseOptionNumber(input, min) {
                const num = Number(input);
                if (isNaN(num) || num < min) {
                    return min;
                }
                return num;
            }

            const openModal = (modal) => {
                modal.classList.remove("hidden");
                modal.classList.add("flex");
                document.body.classList.add('overflow-hidden');
            };

            const closeModal = () => {
                document.getElementById("modal").classList.remove("flex")
                document.body.classList.remove("overflow-hidden")
                document.getElementById("modal").classList.add("hidden")
            }

            // Helper: Render Brand Page layout (title + loading + container)
            function renderBrandPageLayout() {
                document.getElementById('main-content').innerHTML = `
                    <div class="mb-8">
                        <div id="loadingBrand"></div>
                        <div id="brandContainer"></div>
                    </div>
                `;
            }

            function loadContent(path, push, params = []) {
                const rootUrl = '/admin/view?viewPage=' + path;
                let paramUrl = '';
                if (params.length > 0) {
                    params.forEach(objParam => {
                        paramUrl += '&' + objParam.name + '=' + objParam.value;
                    });
                }

                if (path === "brand") {
                    // Render layout for brand page first to avoid duplication
                    renderBrandPageLayout();
                }

                fetch(rootUrl + paramUrl)
                        .then(res => res.text())
                        .then(html => {
                            if (path === "brand") {
                                document.getElementById('loadingBrand').innerHTML = '';
                                document.getElementById('brandContainer').innerHTML = html;
                            } else {
                                document.getElementById('main-content').innerHTML = html;
                            }

                            if (push) {
                                history.pushState({page: path}, '', '/admin/dashboard?view=' + path);
                            }

                            // LOAD CONTENT FOR EACH PAGE COMPONENT
                            switch (path) {
                                case 'product':
                                    let cId = 0;
                                    let page = 1;
                                    if (params.length > 0) {
                                        cId = parseOptionNumber(params[0].value, 0);
                                        page = parseOptionNumber(params[1]?.value, 1);
                                    }
                                    loadProductContentAndEvent(cId, page);
                                    break;
                                case 'staff':
                                    let staffPage = 1;
                                    if (params.length > 0) {
                                        staffPage = parseOptionNumber(params[0].value, 1);
                                    }
                                    loadStaffContentAndEvent(staffPage);
                                    break;
                                case 'brand':
                                    let brandPage = 1;
                                    if (params.length > 0) {
                                        brandPage = parseOptionNumber(params[0].value, 1);
                                    }
                                    loadBrandContentAndEvent(brandPage);
                                    break;
                                case 'category':
                                    let categoryPage = 1;
                                    if (params.length > 0) {
                                        categoryPage = parseOptionNumber(params[0].value, 1);
                                    }
                                    loadCategoryContentAndEvent(categoryPage);
                                    break;
                                case 'order':
                                    let orderPage = 1;
                                    if (params.length > 0) {
                                        orderPage = parseOptionNumber(params[0].value, 1);
                                    }
                                    loadOrderContentAndEvent(orderPage);
                                    break;
                                case 'customer':
                                    let customerPage = 1;
                                    if (params.length > 0) {
                                        customerPage = parseOptionNumber(params[0].value, 1);
                                    }
                                    loadCustomerContentAndEvent(customerPage);
                                    break;
                                case 'voucher':
                                    let voucherPage = 1;
                                    let categoryIdOfVoucher = 0;
                                    if (params.length > 0) {
                                        voucherPage = parseOptionNumber(params[0].value, 1);
                                        categoryIdOfVoucher = parseOptionNumber(params[1].value, 0);
                                    }
                                    loadVoucherContentAndEvent(voucherPage, categoryIdOfVoucher);
                                    break;
                                default:
                                    break;
                            }
                            //dashboard
                            if (path === "dashboard") {
                                setTimeout(function () {
                                    if (typeof window.initDashboardTabs === 'function') {
                                        window.initDashboardTabs();
                                    } else {
                                        var event = document.createEvent('Event');
                                        event.initEvent('DOMContentLoaded', true, true);
                                        window.dispatchEvent(event);
                                    }
                                }, 50);
                            }
                        });
            }

            const updateActiveSidebar = (page) => {
                document.querySelectorAll(".nav-link").forEach((element) => {
                    if (element.getAttribute("data-page") === page) {
                        element.classList.add("bg-gray-100", "text-blue-600", "border-r-4", "border-blue-600");
                    } else {
                        element.classList.remove("bg-gray-100", "text-blue-600", "border-r-4", "border-blue-600");
                    }
                });
            };

            window.onload = function () {
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        const page = this.dataset.page;
                        updateActiveSidebar(page);
                        loadContent(page, true);
                    });
                });
                document.getElementById("modal").onclick = () => {
                    document.getElementById("modal").classList.remove("flex");
                    document.body.classList.remove("overflow-hidden");
                    document.getElementById("modal").classList.add("hidden");
                };
                document.getElementById("modalContent").addEventListener("click", function (event) {
                    event.stopPropagation();
                });
                const params = new URLSearchParams(window.location.search);
                const viewPage = params.get('view') || 'dashboard';
                updateActiveSidebar(viewPage);
                switch (viewPage) {
                    case "product":
                        const categoryId = params.get('categoryId') || '0';
                        const page = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'categoryId', value: categoryId}, {name: 'page', value: page}]);
                        break;
                    case "staff":
                        const staffPage = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'page', value: staffPage}
                        ]);
                        break;
                    case "brand":
                        const brandPage = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'page', value: brandPage}]);
                        break;
                    case "category":
                        const categoryPage = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'page', value: categoryPage}]);
                        break;
                    case "order":
                        const orderPage = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'page', value: orderPage}]);
                        break;
                    case "customer":
                        const customerPage = params.get('page') || '1';
                        loadContent(viewPage, false, [{name: 'page', value: customerPage}
                        ]);
                        break;
                    case "voucher":
                        const voucherPage = params.get('page') || '1';
                        const categoryIdOfVoucher = params.get('categoryId') || '0';
                        loadContent(viewPage, false, [{name: 'page', value: voucherPage},
                            {name: 'categoryId', value: categoryIdOfVoucher}
                        ]);
                        break;
                    default:
                        loadContent(viewPage, false);
                        break;
                }
            };
            window.onpopstate = function (e) {
                if (e.state && e.state.page) {
                    loadContent(e.state.page, false);
                }
            };
        </script>
        <script src="../../../js/product.js"></script>    
        <script src="../../../js/brand.js"></script>       
        <script src="../../../js/category.js"></script>       
        <script src="../../../js/staff.js"></script> 
        <script src="../../../js/loading.js"></script>
        <script src="../../../js/voucher.js"></script>
        <script src="../../../js/skeletonLoading.js"></script>
        <script src="../../../js/customer.js"></script>
        <script src="../../../js/order.js"></script>
        <script src="../../../js/dashboard.js"></script>  
    </body>
</html>