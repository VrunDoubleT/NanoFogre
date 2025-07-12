<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Profile</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
        <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <%@ include file="../../../common/loading.jsp" %>
        <%@ include file="../../common/header.jsp" %>

        <div class="bg-gray-100 w-full flex justify-center mt-6">
            <div class="container max-w-[1200px] w-full px-4 sm:px-6 lg:px-8">
                <div class="flex">
                    <div id="sidebar">
                        <%@ include file="customerSidebar.jsp" %>
                    </div>
                    <div id="main-content" class="w-full mt-[92px] mb-[80px] pl-8">
                        <!-- Main content will be loaded here -->
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../../common/footer.jsp" %>

        <script>
            lucide.createIcons();

            function parseOptionNumber(input, min) {
                const num = Number(input);
                return isNaN(num) || num < min ? min : num;
            }

            function loadSidebar() {
                fetch('/customer/self?type=sidebar')
                        .then(res => res.text())
                        .then(html => {
                            const sidebar = document.getElementById('sidebar');
                            if (sidebar) {
                                sidebar.innerHTML = html;
                                lucide.createIcons();

                                const params = new URLSearchParams(window.location.search);
                                const currentPage = params.get('view') || 'profile';
                                updateActiveSidebar(currentPage);

                                sidebar.querySelectorAll('.nav-link').forEach(link => {
                                    link.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        const page = this.dataset.page;
                                        updateActiveSidebar(page);
                                        loadContent(page, true);
                                    });
                                });
                            }
                        });
            }

            function loadContent(path, push, params = []) {
    const rootUrl = '/customer/self?type=' + path;
    let paramUrl = '';
    if (params.length > 0) {
        paramUrl = params.map(obj => `&${obj.name}=${obj.value}`).join('');
    }

    fetch(rootUrl + paramUrl)
        .then(res => res.text())
        .then(html => {
            const container = document.getElementById('main-content');
            container.innerHTML = html;   // GÁN HTML MỚI vào vùng #main-content
            lucide.createIcons();
            initCustomerForm();           // Gọi hàm khởi tạo form nếu cần

            // ---- THÊM ĐOẠN NÀY: ----
            if (path === 'order' && typeof initCustomerOrdersPage === 'function') {
                initCustomerOrdersPage(); // Gọi lại hàm khởi tạo cho trang orders
            }
            // ------------------------

            if (push) {
                history.pushState({page: path}, '', '/customer/account?view=' + path);
            }
        });
}



            const updateActiveSidebar = (page) => {
                document.querySelectorAll(".nav-link").forEach((element) => {
                    if (element.getAttribute("data-page") === page) {
                        element.classList.add("bg-blue-50", "text-blue-600", "border-l-4", "border-blue-600");
                    } else {
                        element.classList.remove("bg-blue-50", "text-blue-600", "border-l-4", "border-blue-600");
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

                const params = new URLSearchParams(window.location.search);
                const viewPage = params.get('view') || 'profile';
                updateActiveSidebar(viewPage);
                loadContent(viewPage, false);
            }

            window.onpopstate = function (e) {
                if (e.state && e.state.page) {
                    loadContent(e.state.page, false);
                    updateActiveSidebar(e.state.page);
                }
            };
        </script>
        <script src="/js/customer.js"></script>
        <script src="/js/loading.js"></script>
        <script src="/js/customerOrders.js"></script>
    </body>
</html>
