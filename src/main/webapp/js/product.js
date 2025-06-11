let handleCategoryChange = null;

/**
 * @param {int} categoryId 
 * @param {int} page 
 * */
const loadProductContentAndEvent = (categoryId, page) => {
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingProduct').innerHTML = `
  <div class="flex w-full justify-center items-center h-32">
    <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
  </div>
`;
    // PUSH PARAMS URL TO CALL SERVERLET
    let paramUrl = ''
    if (categoryId > 0) {
        paramUrl = '&categoryId=' + categoryId
    }
    // Fetch servlet to get list product html and add event for list
    Promise.all([
        fetch("/product/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/product/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([productHTML, paginationHTML]) => {
        // UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = productHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingProduct').innerHTML = '';

        // ADD EVENT FOR VIEW DETAIL PRODUCT
        document.querySelectorAll(".openViewModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal")
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-product-id]');
                const productId = buttonItem.getAttribute('data-product-id');
                // OPEN AND LOAD CONTEND FOR MODAL
                openModal(modal)
                fetch(`/product/view?productId=${productId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                        }).then(() => {
                    // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
                    loadProductDetailEvent()
                });
            })
        })

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
                    updatePageUrl(pageClick)
                    loadProductContentAndEvent(categoryId, parseOptionNumber(pageClick, 1))
                }
            });
        })

        // GET CATEGORY SELECT
        const selectElement = document.getElementById("categorySelect");
        // HANDLE UPDATE URL WHEN CATEGORY CHANGE
        function updateCategoryURL(categoryId, page) {
            const url = new URL(window.location);
            if (categoryId <= 0) {
                url.searchParams.delete('categoryId');
            } else {
                url.searchParams.set('categoryId', categoryId);
            }
            if (page <= 1) {
                url.searchParams.delete('page');
            } else {
                url.searchParams.set('page', categoryId);
            }
            history.pushState(null, '', url.toString());
        }
        // ADD EVENT FOR CATEGORY
        selectElement.addEventListener("change", function () {
            const selectedOption = this.options[this.selectedIndex];
            const categoryIdSelectString = selectedOption.getAttribute("data-category-id");
            const categoryIdSelect = parseOptionNumber(categoryIdSelectString, 0)
            if (categoryId !== categoryIdSelect) {
                updateCategoryURL(categoryIdSelect, page)
                loadProductContentAndEvent(categoryIdSelect, 1)
            }
        });
        // DEFINE OR REPLACE EVENT HANDLER
        if (handleCategoryChange !== null) {
            selectElement.removeEventListener("change", handleCategoryChange);
        }

        // DEFINE HANDLER FUNCTION
        handleCategoryChange = function () {
            const selectedOption = this.options[this.selectedIndex];
            const categoryIdSelectString = selectedOption.getAttribute("data-category-id");
            const categoryIdSelect = parseOptionNumber(categoryIdSelectString, 0);
            if (categoryId !== categoryIdSelect) {
                updateCategoryURL(categoryIdSelect, page);
                loadProductContentAndEvent(categoryIdSelect, 1);
            }
        };

        // ADD EVENT LISTENER
        selectElement.addEventListener("change", handleCategoryChange);
        // SHOW SELECTED CATEGORY
        const options = selectElement.options;
        for (let i = 0; i < options.length; i++) {
            if (options[i].dataset.categoryId == categoryId) {
                selectElement.selectedIndex = i;
                break;
            }
    }
    })
}



// HANDLE CHANGE IMAGE IN PRODUCT DETAIL
function changeMainImage(imageUrl) {
    document.getElementById('main-image').src = imageUrl;
}
// HANDLE LOAD EVENT FOR PRODUCT DETAIL
function loadProductDetailEvent() {
    const detailTab = document.getElementById('details-tab')
    if (detailTab) {
        detailTab.addEventListener('click', function () {
            showTab('details');
        });
    }
    const reviewTab = document.getElementById('preview-tab')
    if (reviewTab) {
        reviewTab.addEventListener('click', function () {
            showTab('preview');
        });
    }
}
// HANDLE SHOW SELECT TAB
function showTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.add('hidden');
    });
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active', 'text-gray-500', "border-transparent", "hover:text-blue-600", "hover:border-blue-300", "transition-all", "duration-200");
        button.classList.add('text-gray-500', "border-transparent", "hover:text-blue-600", "hover:border-blue-300", "transition-all", "duration-200");
    });
    document.getElementById(tabName + '-content').classList.remove('hidden');
    document.getElementById(tabName + '-tab').classList.add('active');
}