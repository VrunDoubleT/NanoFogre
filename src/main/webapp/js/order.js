const loadOrderContentAndEvent = (page) => {
    lucide.createIcons();
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingOrder').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
        // Fetch category list and pagination
         Promise.all([
        fetch("/order/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/order/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
        ]).then(([categoryHTML, paginationHTML]) => {

        // UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = categoryHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCategory').innerHTML = '';
        // UPDATE URL WHEN CLICK PAGE
        function updatePageUrl(page) {
            const url = new URL(window.location);
            url.searchParams.delete('page');
            url.searchParams.set('page', page);
            history.pushState(null, '', url.toString());
        }

        // ADD EVENT FOR PAGINATION
        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick);
                    loadCategoryContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });

    });
};