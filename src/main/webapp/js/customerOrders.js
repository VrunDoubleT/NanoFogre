function initCustomerOrdersPage() {
    // 1. Lucide icons
    if (window.lucide) {
        window.lucide.createIcons();
    }

    let page = 2;
    const pageSize = 4;
    let loading = false;
    let noMoreOrders = false;
    let currentStatus = "all";
    let currentSearch = "";
    const ordersList = document.getElementById('orders-list');
    const loadMoreTrigger = document.getElementById('order-load-more-trigger');
    const loadMoreBtn = document.getElementById('load-more-orders-btn');
    if (loadMoreBtn)
        loadMoreBtn.style.display = 'none';

    // --- FILTER BY STATUS ---
    var statusBtns = document.querySelectorAll('.order-status-btn');
    Array.prototype.forEach.call(statusBtns, function (btn) {
        btn.addEventListener('click', function () {
            var status = this.dataset.status;
            Array.prototype.forEach.call(statusBtns, function (b) {
                b.classList.remove('bg-blue-50', 'text-blue-600', 'border-blue-200');
            });
            this.classList.add('bg-blue-50', 'text-blue-600', 'border-blue-200');
            currentStatus = status;
            page = 2;
            noMoreOrders = false;
            ordersList.innerHTML = '';
            loadMoreTrigger.style.display = '';
            loadOrders(true);
        });
    });

    // --- LOAD ORDERS AJAX ---
    function loadOrders(reset = false) {
        if (loading || noMoreOrders)
            return;
        loading = true;
        let reqPage = page;
        if (reset)
            reqPage = 1;
        let url = `/customer/self?type=orderFragment&page=${reqPage}&pageSize=${pageSize}`;
        if (currentStatus && currentStatus !== 'all')
            url += `&status=${encodeURIComponent(currentStatus)}`;
        if (currentSearch && currentSearch.length > 0)
            url += `&search=${encodeURIComponent(currentSearch)}`;
        fetch(url)
                .then(res => {
                    if (!res.ok)
                        throw new Error();
                    return res.text();
                })
                .then(html => {
                    if (reset)
                        ordersList.innerHTML = '';
                    ordersList.insertAdjacentHTML('beforeend', html.trim());
                    if (reset)
                        page = 2;
                    else
                        page++;
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = html.trim();
                    if (!tempDiv.querySelector('.order-card') || tempDiv.querySelectorAll('.order-card').length < pageSize) {
                        noMoreOrders = true;
                        loadMoreTrigger.style.display = 'none';
                    }
                    if (window.lucide)
                        window.lucide.createIcons();
                })
                .catch(() => {
                })
                .finally(() => {
                    loading = false;
                });
    }

    // --- SCROLL AUTO LOAD ---
    window.addEventListener('scroll', function () {
        if (noMoreOrders || loading)
            return;
        if (!loadMoreTrigger)
            return;
        var rect = loadMoreTrigger.getBoundingClientRect();
        if (rect.top < window.innerHeight + 60) {
            loadOrders(false);
        }
    });

    var modal = document.getElementById('order-detail-modal');
    var content = document.getElementById('order-detail-content');

    document.body.addEventListener('click', function (e) {
        // a) Show details
        var dBtn = e.target.closest('.show-order-details-btn');
        if (dBtn) {
            fetch('/customer/self?type=orderDetail&id=' + dBtn.dataset.id)
                    .then(function (res) {
                        return res.text();
                    })
                    .then(function (html) {
                        content.innerHTML = html;
                        modal.classList.remove('hidden');
                        document.body.style.overflow = 'hidden';
                        if (window.lucide)
                            window.lucide.createIcons();
                    })
                    .catch(function () {
                        content.innerHTML = '<div class="py-10 text-center text-red-500">'
                                + 'Error loading order details!'
                                + '</div>';
                        modal.classList.remove('hidden');
                        document.body.style.overflow = 'hidden'
                    });
            return;
        }

        var reviewBtn = e.target.closest('.review-product-btn');
        if (reviewBtn) {
            var orderId = reviewBtn.dataset.orderId;
            var productId = reviewBtn.dataset.productId;
            var productTitle = reviewBtn.dataset.productTitle;
            var productImg = reviewBtn.dataset.productImg;
            var reviewContent = reviewBtn.dataset.reviewContent || "";
            var reviewStar = parseInt(reviewBtn.dataset.reviewStar) || 5;
            showReviewProductModal(orderId, productId, productTitle, productImg, reviewBtn, reviewContent, reviewStar);
            return;
        }
    });

    var close1 = document.getElementById('close-detail-modal');
    if (close1) {
        close1.addEventListener('click', function () {
            modal.classList.add('hidden');
            document.body.style.overflow = '';
        });
    }
    var close2 = document.getElementById('close-detail-modal-2');
    if (close2) {
        close2.addEventListener('click', function () {
            modal.classList.add('hidden');
            document.body.style.overflow = '';
        });
    }
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.classList.add('hidden');
                document.body.style.overflow = '';
            }
        });
    }
}

function showReviewProductModal(orderId, productId, productTitle, productImg, btn, reviewContent = "", reviewStar = 5) {
    Swal.fire({
        html: `
            <div style="display: flex; flex-direction: column; align-items: center; width:100%; padding-top:8px;">
                <img src="${productImg}" alt="${productTitle}" 
                     style="width:100px;height:100px;border-radius:50%;object-fit:cover;border:3px solid #e0e7ef; margin-bottom:16px; background:#fafafd;" 
                     onerror="this.style.display='none'"/>
                <div style="font-weight:700;font-size:1.7rem;margin-bottom:20px; color:#334155; text-align:center; font-family:sans-serif">${productTitle}</div>
                <div id="swal-rating-stars" style="display:flex;gap:10px;justify-content:center;margin-bottom:24px;"></div>
                <textarea id="swal-review-content"
                    placeholder="Write your review here..."
                    style="width:96%;max-width:520px;min-height:130px;padding:18px 20px;border-radius:15px;border:2.2px solid #6366f1;outline:none;box-shadow:0 4px 32px 0 rgba(50,60,80,.09);background:#f8fafc;font-size:1.13rem;line-height:1.4;margin-bottom:0;resize:vertical;transition:all .22s"
                ></textarea>
            </div>
        `,
        showCancelButton: false,
        confirmButtonText: reviewContent ? 'Update Review' : 'Submit Review',
        focusConfirm: false,
        customClass: {
            popup: 'p-0 rounded-3xl shadow-2xl bg-white',
            confirmButton: 'bg-blue-600 text-white rounded-xl px-8 py-3 text-lg hover:bg-blue-700 font-bold mt-5',
        },
        width: 570,
        padding: '36px 18px 32px 18px',
        allowOutsideClick: true,
        didOpen: () => {
            // Custom star rating
            const starsDiv = document.getElementById('swal-rating-stars');
            let rating = reviewStar || 5;
            function renderStars() {
                starsDiv.innerHTML = '';
                for (let i = 1; i <= 5; ++i) {
                    const star = document.createElement('span');
                    star.textContent = i <= rating ? '★' : '☆';
                    star.style.cursor = 'pointer';
                    star.style.fontSize = "3rem";
                    star.style.color = "#facc15";
                    star.style.transition = "transform .13s";
                    star.onmouseenter = () => { rating = i; renderStars(); };
                    star.onclick = () => { rating = i; renderStars(); };
                    starsDiv.appendChild(star);
                }
                window._swal_rating = rating;
            }
            renderStars();
            document.getElementById('swal-review-content').value = reviewContent || '';
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
            return {content, rating};
        }
    }).then((result) => {
        if (result.isConfirmed && result.value) {
            fetch('/customer/self?type=submitProductReview', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
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
                        btn.innerHTML = '<i data-lucide="star"></i> Edit Review';
                        btn.className = "review-product-btn flex items-center gap-1 px-3 py-1 text-xs rounded bg-yellow-200 text-yellow-600 hover:bg-yellow-400 hover:text-white transition ml-2";
                        btn.disabled = false;
                        if (window.lucide)
                            window.lucide.createIcons();
                    }
                } else {
                    Swal.fire('Error', json.message || 'Could not submit review.', 'error');
                }
            })
            .catch(() => Swal.fire('Error', 'Server error.', 'error'));
        }
    });
}

