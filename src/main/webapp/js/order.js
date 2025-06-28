const loadOrderContentAndEvent = (page) => {
    lucide.createIcons();

    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('OrderContainer').innerHTML = '';
    document.getElementById('LoadingOrders').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;

    let paramUrl = '';
    // Fetch order list and pagination
    Promise.all([
        fetch("/order/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/order/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([orderHTML, paginationHTML]) => {

        // UPDATE HTML
        document.getElementById('OrderContainer').innerHTML = orderHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('LoadingOrders').innerHTML = '';

        // UPDATE URL WHEN CLICK PAGE
        function updatePageUrl(page) {
            const url = new URL(window.location);
            url.searchParams.delete('page');
            url.searchParams.set('page', page);
            history.pushState(null, '', url.toString());
        }

        // ADD EVENT FOR PAGINATION - FIXED: Call loadOrderContentAndEvent instead of loadCategoryContentAndEvent
        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick);
                    loadOrderContentAndEvent(parseOptionNumber(pageClick, 1)); // FIXED: Changed from loadCategoryContentAndEvent
                }
            });
        });

        //// detail order
        document.addEventListener("click", async function (e) {
            const modal = document.getElementById("modal");
            const modalContent = document.getElementById("modalContent");
            const detailCategoryBtn = e.target.closest(".detail-order-button");
            if (detailCategoryBtn) {
                const categoryId = detailCategoryBtn.dataset.id;
                try {
                    const response = await fetch(`/order/view?type=detail&orderId=${categoryId}`);
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
//////////////
        function confirmEditOrderStatus(orderId, currentStatus) {
            Swal.fire({
                title: 'Update Order Status',
                html: `
      <label for="swal-select" class="block mb-2 text-sm font-medium text-gray-700 text-left">
        Select new status:
      </label>
      <select id="swal-select" class="
        block w-full px-3 py-2 border border-gray-300 rounded-lg 
        focus:outline-none focus:ring-2 focus:ring-blue-500
      ">
        <option value="Pending">Pending</option>
        <option value="Processing">Processing</option>
        <option value="Shipped">Shipped</option>
        <option value="Delivered">Delivered</option>
        <option value="Cancelled">Cancelled</option>
      </select>
    `,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Update',
                cancelButtonText: 'Cancel',
                focusConfirm: false,
                customClass: {
                    popup: 'p-6 rounded-2xl shadow-xl',
                    title: 'text-xl font-semibold mb-4',
                    confirmButton: 'ml-[220px] mr-[25px] px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700',
                    cancelButton: 'px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700'
                },
                buttonsStyling: false,
                didOpen: () => {
                    const select = Swal.getPopup().querySelector('#swal-select');
                    select.value = currentStatus;
                },
                preConfirm: () => {
                    return Swal.getPopup().querySelector('#swal-select').value;
                }
            }).then((result) => {
                if (!result.isConfirmed)
                    return;
                const newStatus = result.value;
                fetch('/order/view', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: new URLSearchParams({
                        type: 'updateStatus',
                        orderId: orderId,
                        statusName: newStatus
                    })
                })
                        .then(res => res.json())
                        .then(data => {
                            Toastify({
                                text: data.message,
                                duration: 5000,
                                gravity: "top",
                                position: "right",
                                style: {background: data.isSuccess ? "#2196F3" : "#f44336"},
                                close: true
                            }).showToast();
                            if (data.isSuccess) {
                                loadOrderContentAndEvent(getPageFromUrl());
                            }
                        })
                        .catch(err => console.error("Error updating status:", err));
            });
        }

        document.querySelectorAll(".openEditOrderStatus").forEach(btn => {
            btn.addEventListener("click", e => {
                const wrapper = e.target.closest("[data-order-id]");
                const orderId = wrapper.getAttribute("data-order-id");
                const row = wrapper.closest("tr");
                const current = row.querySelector("td:nth-child(6) span").textContent.trim();
                confirmEditOrderStatus(orderId, current);
            });
        });


/////////
    }).catch(error => {
        console.error('Error loading order content:', error);
        document.getElementById('LoadingOrders').innerHTML = `
            <div class="text-red-500 text-center py-4">
                Error loading orders. Please try again.
            </div>
        `;
    });
};
