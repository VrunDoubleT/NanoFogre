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
        <div id="modal" class="fixed inset-0 bg-black bg-opacity-80 flex items-center justify-center z-50 hidden">
            <div id="modalContent" class="bg-white max-h-[90%] rounded-2xl overflow-y-auto">
                <!-- Load content -->
            </div>
        </div>
        <div class="w-full flex justify-center mt-6">
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
        <script src="../../../js/header.js"></script>
        <script>
            lucide.createIcons();

            function parseOptionNumber(input, min) {
                const num = Number(input);
                return isNaN(num) || num < min ? min : num;
            }

            const openModal = (modal) => {
                modal.classList.remove("hidden");
                modal.classList.add("flex");
                document.body.classList.add('overflow-hidden');
            };

            const closeModal = () => {
                document.getElementById("modal").classList.remove("flex");
                document.body.classList.remove("overflow-hidden");
                document.getElementById("modal").classList.add("hidden");
            };

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
                            container.innerHTML = html;
                            if (push) {
                                history.pushState({page: path}, '', '/account?view=' + path);
                            }
                            switch (path) {
                                case 'profile':
                                    lucide.createIcons();
                                    if (typeof initCustomerForm === 'function')
                                        initCustomerForm();
                                    if (typeof initCreateAddressButton === 'function')
                                        initCreateAddressButton();
                                    break;
                                case 'order':
                                    if (path === 'order' && typeof initCustomerOrdersPage === 'function') {
                                        initCustomerOrdersPage();
                                    }
                                    break;
                            }
                            ;
                        })
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

                document.getElementById("modal").onclick = () => {
                    document.getElementById("modal").classList.remove("flex");
                    document.body.classList.remove("overflow-hidden");
                    document.getElementById("modal").classList.add("hidden");
                };

                document.getElementById("modalContent").addEventListener("click", function (event) {
                    event.stopPropagation();
                });

                const params = new URLSearchParams(window.location.search);
                const viewPage = params.get('view') || 'profile';
                updateActiveSidebar(viewPage);
                loadContent(viewPage, false);
                reloadCart();
            };

            window.onpopstate = function (e) {
                if (e.state && e.state.page) {
                    loadContent(e.state.page, false);
                    updateActiveSidebar(e.state.page);
                }
            };
        </script>
        <script src="/js/customerAccount.js"></script>
        <script src="/js/loading.js"></script>
        <script src="/js/customerOrders.js"></script>
    </body>
</html>
