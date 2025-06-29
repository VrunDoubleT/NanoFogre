// Customer list
const loadCustomerContentAndEvent = (page) => {
    lucide.createIcons();
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingCustomer').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    Promise.all([
        fetch("/customer/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/customer/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([customerHTML, paginationHTML]) => {
        document.getElementById('tabelContainer').innerHTML = customerHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCustomer').innerHTML = '';
        initToggleBlockEvents();
        function updatePageUrl(page) {
            const url = new URL(window.location);
            url.searchParams.delete('page');
            url.searchParams.set('page', page);
            history.pushState(null, '', url.toString());
        }

        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick);
                    loadCustomerContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });
    });
};

function initToggleBlockEvents() {
    document.querySelectorAll(".toggle-block").forEach(toggle => {
        toggle.addEventListener("change", async function () {
            const id = this.dataset.id;
            const isBlock = !this.checked;
            const currentPage = getCurrentPageFromURL();

            try {
                const res = await fetch("/customer/view", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `type=block&id=${id}&isBlock=${isBlock}`
                });

                if (res.ok) {
                    Toastify({
                        text: `Customer status updated successfully!`,
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#2196F3"},
                        close: true
                    }).showToast();
                    loadCustomerContentAndEvent(currentPage);
                } else {
                    this.checked = !this.checked;
                    Toastify({
                        text: "Update customer status failed.",
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#f44336"},
                        close: true
                    }).showToast();
                }
            } catch (e) {
                this.checked = !this.checked;
                Toastify({
                    text: "An error occurred while updating.",
                    duration: 4000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#f44336"},
                    close: true
                }).showToast();
            }
        });
    });
}

// Staff details
document.addEventListener("click", async function (e) {
    lucide.createIcons();
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const detailBtn = e.target.closest(".detail-customer-button");
    if (detailBtn) {
        const id = detailBtn.dataset.id;

        try {
            const response = await fetch(`/customer/view?type=detail&id=${id}`);
            const html = await response.text();

            modalContent.innerHTML = html;
            lucide.createIcons();
            modal.classList.remove("hidden");
            modal.classList.add("flex");
            document.body.classList.add("overflow-hidden");
        } catch (err) {
            alert("Cannot open details dialog.");
        }
    }
});

function switchTab(tabName) {
    // Ẩn tất cả tab content
    document.getElementById('profileTab').classList.add('hidden');
    document.getElementById('ordersTab').classList.add('hidden');

    // Hiện tab được chọn
    document.getElementById(tabName + 'Tab').classList.remove('hidden');

    // Cập nhật class cho nút tab
    const buttons = document.querySelectorAll('.tab-button');
    buttons.forEach(btn => btn.classList.remove('border-b-2', 'border-indigo-500', 'font-semibold', 'text-indigo-600'));

    const activeBtn = document.getElementById(tabName + 'Btn');
    activeBtn.classList.add('border-b-2', 'border-indigo-500', 'font-semibold', 'text-indigo-600');
}

// Get URL from page
function getCurrentPageFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get("page")) || 1;
}


