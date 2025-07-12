function initCustomerOrdersPage() {
    // 1. Lucide icons
    if (window.lucide) {
        window.lucide.createIcons();
    }

    // 2. Filter by status
    var statusBtns = document.querySelectorAll('.order-status-btn');
    Array.prototype.forEach.call(statusBtns, function (btn) {
        btn.addEventListener('click', function () {
            var status = this.dataset.status;
            Array.prototype.forEach.call(statusBtns, function (b) {
                b.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-200');
            });
            this.classList.add('bg-blue-50', 'text-blue-600', 'border-blue-200');
            var orderCards = document.querySelectorAll('.order-card');
            Array.prototype.forEach.call(orderCards, function (card) {
                card.style.display = (status === 'all' || card.dataset.status === status) ? '' : 'none';
            });
        });
    });

    // 3. Modal & Cancel logic
    var modal = document.getElementById('order-detail-modal');
    var content = document.getElementById('order-detail-content');

    document.body.addEventListener('click', function (e) {
        // a) Show details
        var dBtn = e.target.closest('.show-order-details-btn');
        if (dBtn) {
            fetch('/customer/self?type=orderDetail&id=' + dBtn.dataset.id)
                .then(function (res) { return res.text(); })
                .then(function (html) {
                    content.innerHTML = html;
                    modal.classList.remove('hidden');
                    if (window.lucide)
                        window.lucide.createIcons();
                })
                .catch(function () {
                    content.innerHTML = '<div class="py-10 text-center text-red-500">'
                        + 'Error loading order details!'
                        + '</div>';
                    modal.classList.remove('hidden');
                });
            return;
        }

        // b) Cancel order (Pending / Processing)
        var cBtn = e.target.closest('.cancel-order-btn');
        if (cBtn) {
            var orderId = cBtn.dataset.id;
            var CANCELLED_STATUS_ID = "5";
            if (window.Swal) {
                Swal.fire({
                    title: `Cancel order #${orderId}?`,
                    text: "Do you really want to cancel this order? You cannot undo this action.",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Yes, cancel it",
                    cancelButtonText: "No, keep it",
                    confirmButtonColor: "#d33",
                    cancelButtonColor: "#3085d6"
                }).then(function (result) {
                    if (result.isConfirmed) {
                        fetch('/customer/self?type=cancelOrder&id=' + orderId)
                            .then(function (res) { return res.json(); })
                            .then(function (json) {
                                if (json.success) {
                                    var card = document.querySelector('.order-card[data-id="' + orderId + '"]');
                                    if (card) {
                                        card.dataset.status = CANCELLED_STATUS_ID;
                                        var statusLabel = card.querySelector('.inline-block.px-3');
                                        if (statusLabel) statusLabel.textContent = "Cancelled";
                                        var cancelBtn = card.querySelector('.cancel-order-btn');
                                        if (cancelBtn) cancelBtn.remove();
                                        var currentStatusBtn = document.querySelector('.order-status-btn.bg-blue-50, .order-status-btn.text-blue-600');
                                        var currentStatus = currentStatusBtn ? currentStatusBtn.dataset.status : "all";
                                        if (currentStatus !== "all" && currentStatus !== CANCELLED_STATUS_ID) {
                                            card.style.display = "none";
                                        } else {
                                            card.style.display = "";
                                        }
                                    }
                                    Swal.fire('Canceled!', 'Order #' + orderId + ' has been canceled.', 'success');
                                } else {
                                    Swal.fire('Lỗi', 'Order cannot be cancelled.', 'error');
                                }
                            })
                            .catch(function () {
                                Swal.fire('Lỗi', 'Server error.', 'error');
                            });
                    }
                });
            } else {
                if (!confirm('Cancel order #' + orderId + '?')) return;
                fetch('/customer/self?type=cancelOrder&id=' + orderId)
                    .then(function (res) { return res.json(); })
                    .then(function (json) {
                        if (json.success) {
                            var card = document.querySelector('.order-card[data-id="' + orderId + '"]');
                            if (card) {
                                card.dataset.status = CANCELLED_STATUS_ID;
                                var statusLabel = card.querySelector('.inline-block.px-3');
                                if (statusLabel) statusLabel.textContent = "Cancelled";
                                var cancelBtn = card.querySelector('.cancel-order-btn');
                                if (cancelBtn) cancelBtn.remove();
                                var currentStatusBtn = document.querySelector('.order-status-btn.bg-blue-50, .order-status-btn.text-blue-600');
                                var currentStatus = currentStatusBtn ? currentStatusBtn.dataset.status : "all";
                                if (currentStatus !== "all" && currentStatus !== CANCELLED_STATUS_ID) {
                                    card.style.display = "none";
                                } else {
                                    card.style.display = "";
                                }
                            }
                            alert('Order #' + orderId + ' cancelled.');
                        } else {
                            alert('Cancel failed.');
                        }
                    })
                    .catch(function () { alert('Server error.'); });
            }
            return;
        }

        // c) Đánh giá sản phẩm trong đơn delivered
        var reviewBtn = e.target.closest('.review-product-btn');
        if (reviewBtn) {
            var orderId = reviewBtn.dataset.orderId;
            var productId = reviewBtn.dataset.productId;
            var productTitle = reviewBtn.dataset.productTitle;
            var productImg = reviewBtn.dataset.productImg;
            showReviewProductModal(orderId, productId, productTitle, productImg, reviewBtn);
            return;
        }
    });

    // 4. Đóng modal
    var close1 = document.getElementById('close-detail-modal');
    if (close1) {
        close1.addEventListener('click', function () {
            modal.classList.add('hidden');
        });
    }
    var close2 = document.getElementById('close-detail-modal-2');
    if (close2) {
        close2.addEventListener('click', function () {
            modal.classList.add('hidden');
        });
    }
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.classList.add('hidden');
            }
        });
    }
}

// Modal đánh giá sản phẩm, đẹp, chuẩn Tailwind+SweetAlert2
function showReviewProductModal(orderId, productId, productTitle, productImg, btn) {
    Swal.fire({
        html: `
            <div style="display: flex; flex-direction: column; align-items: center; width:100%; padding-top:8px;">
                <img src="${productImg}" alt="${productTitle}" 
                     style="width:64px;height:64px;border-radius:0.75rem;object-fit:cover;border:1px solid #eee; margin-bottom:12px; background:#fafafd;" 
                     onerror="this.style.display='none'"/>
                <div style="font-weight:600;font-size:1.15rem;margin-bottom:16px; color:#374151; text-align:center">${productTitle}</div>
                <div id="swal-rating-stars" style="display:flex;gap:4px;justify-content:center;margin-bottom:20px;"></div>
                <textarea id="swal-review-content"
                    placeholder="Write your review here..."
                    style="width:100%;max-width:340px;min-height:70px;padding:10px;border-radius:8px;border:1px solid #e5e7eb;background:#fafbfc;resize:none;box-shadow:none;font-size:1rem;margin-bottom:0"
                ></textarea>
            </div>
        `,
        showCancelButton: true,
        confirmButtonText: 'Submit Review',
        cancelButtonText: 'Skip',
        focusConfirm: false,
        customClass: {
            popup: 'p-0 rounded-2xl shadow-xl bg-white',
            confirmButton: 'bg-blue-600 text-white rounded px-5 py-2 hover:bg-blue-700 font-semibold mt-3',
            cancelButton: 'bg-gray-200 text-gray-700 rounded px-5 py-2 ml-2 hover:bg-gray-300 font-semibold mt-3'
        },
        width: 400,
        allowOutsideClick: true,
        didOpen: () => {
            // Remove scroll bar
            document.querySelector('.swal2-actions').style.marginTop = '18px';
            // Star rating
            const starsDiv = document.getElementById('swal-rating-stars');
            let rating = 5;
            function renderStars() {
                starsDiv.innerHTML = '';
                for (let i = 1; i <= 5; ++i) {
                    const star = document.createElement('span');
                    star.textContent = i <= rating ? '★' : '☆';
                    star.style.cursor = 'pointer';
                    star.style.fontSize = "2rem";
                    star.style.color = "#facc15";
                    star.onmouseenter = () => { rating = i; renderStars(); };
                    star.onclick = () => { rating = i; renderStars(); };
                    starsDiv.appendChild(star);
                }
                window._swal_rating = rating;
            }
            renderStars();
        },
        preConfirm: () => {
            const content = document.getElementById('swal-review-content').value.trim();
            const rating = window._swal_rating || 5;
            if (!content) {
                Swal.showValidationMessage('Please write your review!');
                return false;
            }
            if (!rating) {
                Swal.showValidationMessage('Please select the number of stars!');
                return false;
            }
            return { content, rating };
        }
    }).then((result) => {
        if (result.isConfirmed && result.value) {
            fetch('/customer/self?type=submitProductReview', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    orderId: orderId,
                    productId: productId,
                    content: result.value.content,
                    star: result.value.rating
                })
            })
            .then(res => res.json())
            .then(json => {
                if (json.success) {
                    Swal.fire('Thank you!', 'Your review has been submitted.', 'success');
                    if (btn) {
                        btn.textContent = 'Rated';
                        btn.className = "flex items-center gap-1 px-3 py-1 text-xs rounded bg-yellow-200 text-yellow-600 cursor-not-allowed opacity-70 ml-2";
                        btn.disabled = true;
                    }
                } else {
                    Swal.fire('Error', json.message || 'Could not submit review.', 'error');
                }
            })
            .catch(() => Swal.fire('Error', 'Server error.', 'error'));
        }
    });
}


// Auto-init khi DOM sẵn sàng
document.addEventListener('DOMContentLoaded', initCustomerOrdersPage);
