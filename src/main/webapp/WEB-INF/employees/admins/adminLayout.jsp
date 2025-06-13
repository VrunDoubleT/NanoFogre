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
        <title>Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>
    <body>
        <%@ include file="adminHeader.jsp" %>
        <div id="modal" class="fixed inset-0 bg-black bg-opacity-80 flex items-center justify-center z-50 hidden">
            <div id="modalContent" class="bg-white max-h-[90%] rounded-2xl overflow-y-auto">
                <!-- Load content -->
            </div>
        </div>
        <div style="display: flex;">
            <%@ include file="adminSidebar.jsp" %>
            <div id="main-content" class="bg-gray-100 w-full h-[calc(100vh-74px)] px-8 py-6 overflow-y-auto">
                <!-- Load content -->
            </div>
        </div>

        <script>
            // TO USE LUCIDE ICON
            lucide.createIcons();
            // METHOD TO COVERT STRING -> NUMBER (IF ERROR WHEN CASH OR LESS THAN MIN THEN RETURN MIN)
            function parseOptionNumber(input, min) {
                const num = Number(input);
                if (isNaN(num) || num < min) {
                    return 0;
                }
                return num;
            }
            // METHOD TO OPEN OPEN EMPTY MODAL
            const openModal = (modal) => {
                modal.classList.remove("hidden");
                modal.classList.add("flex");
                // DON'T SCROLL WHEN OPEN MODAL
                document.body.classList.add('overflow-hidden')
            }
            // METHOD TO LOAD CONTENT FOR EACH PAGE (category, product,...)
            /**
             * @argument {type} name description
             * @argument {String} path Use load valid content (HTML) for each page
             * @argument {Boolean} push Check push or not in history webside 
             * @argument {{name: string, value: string}[]} params Params of urls (Ex. /admin?name=value) 
             * */
            function loadContent(path, push, params = []) {
                // Default url (serverlet) to load content (HTML)
                const rootUrl = '/admin/view?viewPage=' + path
                // Params of url
                let paramUrl = ''
                if (params.length > 0) {
                    params.forEach(objParam => {
                        paramUrl += '&' + objParam.name + '=' + objParam.value
                    })
                }
                // CALL SERVERLET TO GET HTML
                fetch(rootUrl + paramUrl)
                            // CONVERT RESULT -> STRING HTML
                        .then(res => res.text())
                        // RENDER HTML
                        .then(html => {
                            document.getElementById('main-content').innerHTML = html;
                            // ADD HISTORY WEBSIDE
                            if (push)
                                history.pushState({page: path}, '', '/admin/dashboard?view=' + path);
                        }).then(() => {
                            // LOAD CONTENT FOR EACH PAGE COMPONENT
                    switch (path) {
                        case 'product':
                            let cId = 0;
                            let page = 1
                            if(params.length > 0){
                                cId = params[0].value
                                page = params[1].value
                            }
                            loadProductContentAndEvent(parseOptionNumber(cId, 0), parseOptionNumber(page, 1))
                            break;
                        case 'staff':
                            let staffPage = 1;
                            if (params.length > 0) {
                                staffPage = params[0].value;
                            }
                            loadStaffContentAndEvent(parseOptionNumber(staffPage, 1));
                            break;
                        default :
                            break;
                    }
                });
            }
            // HANDLE ACTIVE NAVBAR
            const updateAvtiveSidebar = (page) => {
                document.querySelectorAll(".nav-link").forEach((element) => {
                    if (element.getAttribute("data-page") === page) {
                        element.classList.add("bg-gray-100", "text-blue-600", "border-r-4", "border-blue-600");
                    } else {
                        element.classList.remove("bg-gray-100", "text-blue-600", "border-r-4", "border-blue-600");
                    }
                });
            }
            // AFTER CONTET LOADED WILL CALL FUNCTION
            window.onload = function () {
                // HANDLE CLICK NAVBAR
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        const page = this.dataset.page;
                        updateAvtiveSidebar(page)
                        loadContent(page, true);
                    });
                });
                // HANDLE CLICK OUTSIDE MODAL THEN CLOSE MODAL
                document.getElementById("modal").onclick = () => {
                    document.getElementById("modal").classList.remove("flex")
                    document.body.classList.remove("overflow-hidden")
                    document.getElementById("modal").classList.add("hidden")
                }
                document.getElementById("modalContent").addEventListener("click", function (event) {
                    event.stopPropagation();
                });
                // HANDLE LOAD CONTENT FOR EACH PAGE
                const params = new URLSearchParams(window.location.search);
                const viewPage = params.get('view') || 'dashboard';
                updateAvtiveSidebar(viewPage)
                switch (viewPage) {
                    case "product":
                        const categoryId = params.get('categoryId') || '0';
                        const page = params.get('page') || '1';
                        // LOAD CONTENT
                        loadContent(viewPage, false, [{name: 'categoryId', value: categoryId},{name: 'page', value: page}]);
                        break;
                    default:
                        loadContent(viewPage, false);
                        break;
                }
            };

            // POPSTATE
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
    </body>
</html>
