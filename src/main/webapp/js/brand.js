
function openCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    if (!overlay) return;
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
    // Reset form
    const nameInput = document.getElementById('newBrandName');
    if (nameInput) nameInput.value = '';
    const imageInput = document.getElementById('newBrandImage');
    if (imageInput) imageInput.value = '';
    const preview = document.getElementById('createBrandImagePreview');
    if (preview) preview.innerHTML = '';
    const nameError = document.getElementById('createBrandNameError');
    if (nameError) nameError.textContent = '';
    const imageError = document.getElementById('createBrandImageError');
    if (imageError) imageError.textContent = '';
    if (nameInput) nameInput.classList.remove('border-red-500');
    // Reset label file name
    const fileNameLabel = document.querySelector('#createBrandModal .file-name');
    if (fileNameLabel) fileNameLabel.textContent = 'No file chosen';

    if (nameInput && nameError) {
        nameInput.onfocus = function () {
            nameError.textContent = '';
            this.classList.remove('border-red-500');
        };
        nameInput.onblur = function () {
            if (!this.value.trim()) {
                nameError.textContent = 'Please enter brand name';
                this.classList.add('border-red-500');
            }
        };
    }

    if (imageInput && imageError) {
        imageInput.onchange = function () {
            if (typeof showFileName === 'function') showFileName(this);
            imageError.textContent = '';
        };
        imageInput.onclick = function () {
            imageError.textContent = '';
        };
        const uploadLabel = document.querySelector('label[for="newBrandImage"]');
        if (uploadLabel) {
            uploadLabel.onclick = function () {
                imageError.textContent = '';
            };
        }
    }

    if (!overlay.dataset.outsideClickAttached) {
        overlay.addEventListener('mousedown', function (e) {
            if (e.target === overlay) {
                closeCreateModal();
            }
        });
        overlay.dataset.outsideClickAttached = "true";
    }
}


function closeCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    if (!overlay)
        return;
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
        const preview = document.getElementById('createBrandImagePreview');
        if (preview)
            preview.innerHTML = '';
        const fileNameLabel = document.querySelector('#createBrandModal .file-name');
        if (fileNameLabel)
            fileNameLabel.textContent = 'No file chosen';
    }, 300);
}

function openEditModal(id, name, imageUrl) {
    const overlay = document.getElementById('editBrandModal');
    if (!overlay) return;
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
    // Set value
    const idInput = document.getElementById('editBrandId');
    const nameInput = document.getElementById('editBrandName');
    const imageInput = document.getElementById('editBrandImage');
    if (idInput) idInput.value = id || '';
    if (nameInput) nameInput.value = (name !== undefined && name !== null) ? name : '';
    if (imageInput) imageInput.value = '';
    const nameError = document.getElementById('editBrandNameError');
    const imageError = document.getElementById('editBrandImageError');
    if (nameInput) nameInput.classList.remove('border-red-500');
    if (nameError) nameError.textContent = '';
    if (imageError) imageError.textContent = '';
    // Clear preview
    const preview = document.getElementById('editBrandImagePreview');
    if (preview) preview.innerHTML = '';
    const fileNameLabel = document.querySelector('#editBrandModal .file-name');
    if (fileNameLabel) fileNameLabel.textContent = 'No file chosen';
    const currentImageWrapper = document.getElementById('editBrandCurrentImageWrapper');
    if (currentImageWrapper) {
        if (imageUrl && imageUrl.trim() !== '') {
            currentImageWrapper.innerHTML = `<img src="${imageUrl}" alt="Current Image" class="max-h-20 rounded shadow border">`;
        } else {
            currentImageWrapper.innerHTML = '<p class="text-gray-500 text-sm">No current image</p>';
        }
    }

    if (nameInput && nameError) {
        nameInput.onfocus = function () {
            nameError.textContent = '';
            this.classList.remove('border-red-500');
        };
        nameInput.onblur = function () {
            if (!this.value.trim()) {
                nameError.textContent = 'Please enter brand name';
                this.classList.add('border-red-500');
            }
        };
    }

    if (!overlay.dataset.outsideClickAttached) {
        overlay.addEventListener('mousedown', function (e) {
            if (e.target === overlay) {
                closeEditModal();
            }
        });
        overlay.dataset.outsideClickAttached = "true";
    }
}
    




function closeEditModal() {
    const overlay = document.getElementById('editBrandModal');
    if (!overlay)
        return;
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    }, 300);
}
['createBrandModal', 'editBrandModal'].forEach(function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.addEventListener('mousedown', function (e) {
            if (e.target === modal) {
                if (modalId === 'createBrandModal')
                    closeCreateModal();
                if (modalId === 'editBrandModal')
                    closeEditModal();
            }
        });
    }
});

// =========================== CRUD HANDLER ==========================

function editBrand(id, name, url) {
    openEditModal(id, name, url);
}

function handleCreateBrand() {
    const nameInput = document.getElementById('newBrandName');
    const imageInput = document.getElementById('newBrandImage');
    const nameError = document.getElementById('createBrandNameError');
    const imageError = document.getElementById('createBrandImageError');
    const submitBtn = document.querySelector('#createBrandForm button[type="submit"]');
    const loadingIcon = submitBtn ? submitBtn.querySelector('#loadingIconCreate') : null;

    if (nameError)
        nameError.textContent = '';
    if (nameInput)
        nameInput.classList.remove('border-red-500');
    if (imageError)
        imageError.textContent = '';

    let hasError = false;
    if (!nameInput || !nameInput.value.trim()) {
        if (nameError)
            nameError.textContent = 'Please enter brand name';
        if (nameInput)
            nameInput.classList.add('border-red-500');
        hasError = true;
    }
    if (!imageInput || !imageInput.files.length) {
        if (imageError)
            imageError.textContent = 'Please upload brand image';
        hasError = true;
    }
    if (hasError)
        return;

    if (submitBtn)
        submitBtn.disabled = true;

    showLoading()
    const formData = new FormData();
    formData.append('type', 'create');
    formData.append('brandName', nameInput.value.trim());
    formData.append('brandImage', imageInput.files[0]);

    fetch('/brand/view', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.isSuccess || data.success) {
                    showToast(data.message, 'success');
                    closeCreateModal();
                    loadBrandContentAndEvent(1);
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(() => showToast('Server connection error', 'error'))
            .finally(() => {
                if (submitBtn)
                    submitBtn.disabled = false;
                hiddenLoading()
            });
}

function handleUpdateBrand() {
    const idInput = document.getElementById('editBrandId');
    const nameInput = document.getElementById('editBrandName');
    const imageInput = document.getElementById('editBrandImage');
    const nameError = document.getElementById('editBrandNameError');
    const imageError = document.getElementById('editBrandImageError');
    const submitBtn = document.querySelector('#editBrandModal button[type="submit"]');
    const loadingIcon = submitBtn ? submitBtn.querySelector('#loadingIconEdit') : null;

    if (nameError) nameError.textContent = '';
    if (nameInput) nameInput.classList.remove('border-red-500');
    if (imageError) imageError.textContent = '';

    // === VALIDATE ===
    let hasError = false;
    if (!nameInput || !nameInput.value.trim()) {
        if (nameError) nameError.textContent = 'Please enter brand name';
        if (nameInput) nameInput.classList.add('border-red-500');
        if (nameInput) nameInput.focus();
        hasError = true;
    }
    if (hasError) return;

    if (submitBtn) submitBtn.disabled = true;

    const formData = new FormData();
    formData.append('type', 'update');
    formData.append('brandId', idInput ? idInput.value : '');
    formData.append('brandName', nameInput.value.trim());
    if (imageInput && imageInput.files.length > 0) {
        formData.append('brandImage', imageInput.files[0]);
    }

    showLoading();
    fetch('/brand/view', {
        method: 'POST',
        body: formData
    })
    .then(async response => {
        const data = await response.json().catch(() => ({}));
        if (!response.ok) throw new Error(data.message || 'An error occurred.');
        return data;
    })
    .then(data => {
        if (data.isSuccess || data.success) {
            showToast(data.message, 'success');
            closeEditModal();
            let currentPage = parseInt(getQueryParam('page')) || 1;
            loadBrandContentAndEvent(currentPage);
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(error => {
        showToast(error.message, 'error');
    })
    .finally(() => {
        if (submitBtn) submitBtn.disabled = false;
        hiddenLoading()
    });
}


function handleDeleteBrand(id) {
    const formData = new FormData();
    formData.append('type', 'delete');
    formData.append('brandId', id);

    fetch('/brand/view', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                if (data.isSuccess || data.success) {
                    showToast(data.message, 'success');
                    let currentPage = parseInt(getQueryParam('page')) || 1;
                    loadBrandContentAndEvent(currentPage);
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(() => showToast('Server connection error'));
}

function deleteBrand(id) {
    if (typeof Swal === 'undefined')
        return alert('Xác nhận xoá bị lỗi! Vui lòng reload lại trang.');
    Swal.fire({
        title: 'Are you sure you want to delete this brand?',
        text: "This brand will be permanently deleted and cannot be restored. All products under this brand will be affected.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, delete it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            handleDeleteBrand(id);
        }
    });
}

// ====================== IMAGE PREVIEW ==========================

function showFileName(input) {
    const fileName = input.files && input.files.length > 0 ? input.files[0].name : 'No file chosen';
    let label = input.parentNode.querySelector('.file-name');
    if (!label)
        label = input.closest('div').querySelector('.file-name');
    if (label)
        label.textContent = fileName;
    if (input.id === 'newBrandImage') {
        previewImage(input, 'createBrandImagePreview');
    } else if (input.id === 'editBrandImage') {
        previewImage(input, 'editBrandImagePreview');
    }
}

function previewImage(input, previewId) {
    const preview = document.getElementById(previewId);
    if (!preview)
        return;
    preview.innerHTML = '';
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="max-h-24 rounded shadow border">`;
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function updateBrandUrl(page) {
    const url = new URL(window.location);
    url.searchParams.set('view', 'brand');
    url.searchParams.set('page', page);
    window.history.pushState(null, '', url.toString());
}

function updateBrandUrl(page) {
    const url = new URL(window.location);
    url.searchParams.set('view', 'brand');
    // Nếu page > 1 hoặc hiện tại đã có page trên URL, thì show page lên url
    // page==1 nhưng url đang có page rồi => vẫn giữ page
    if (page > 1 || url.searchParams.has('page')) {
        url.searchParams.set('page', page);
    } else {
        url.searchParams.delete('page');
    }
    window.history.pushState(null, '', url.toString());
}

function getBrandPageFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return params.has('page') ? parseInt(params.get('page')) || 1 : 1;
}

// Hàm load brand, truyền đúng page
function loadBrandContentAndEvent(page = 1, updateUrl = true) {
    const brandTableContainer = document.getElementById('brandTable');
    const loadingBrand = document.getElementById('loadingBrand');
    const paginationContainer = document.getElementById('pagination');
    if (brandTableContainer) brandTableContainer.innerHTML = '';
    if (paginationContainer) paginationContainer.innerHTML = '';
    if (loadingBrand) {
        loadingBrand.innerHTML = `
            <div class="flex w-full justify-center items-center h-32">
                <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
            </div>
        `;
    }
    Promise.all([
        fetch(`/brand/view?type=list&page=${page}`).then(res => res.text()),
        fetch(`/brand/view?type=pagination&page=${page}`).then(res => res.text())
    ]).then(([brandHTML, paginationHTML]) => {
        if (brandTableContainer) brandTableContainer.innerHTML = brandHTML;
        if (paginationContainer) paginationContainer.innerHTML = paginationHTML;
        if (loadingBrand) loadingBrand.innerHTML = '';

        // --------- Chỉ updateUrl nếu là do user click, không update khi popstate hoặc load đầu tiên (reload page gốc) ---------
        if (updateUrl) updateBrandUrl(page);

        // Gắn event cho các nút phân trang
        document.querySelectorAll("div.pagination, [page]").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = parseInt(this.getAttribute("page"));
                if (!isNaN(pageClick) && pageClick !== page) {
                    loadBrandContentAndEvent(pageClick, true);
                }
            });
        });

        updateBrandTotalCount();
        if (window.lucide && typeof lucide.createIcons === "function") {
            lucide.createIcons();
        }
    }).catch((error) => {
        if (loadingBrand) loadingBrand.innerHTML = '';
        if (brandTableContainer) {
            brandTableContainer.innerHTML = `
            <div class="text-center text-red-600 py-8">⚠️ Error loading brand data</div>
        `;
        }
        if (paginationContainer) paginationContainer.innerHTML = '';
        console.error('Error loading brand data:', error);
    });
}

// Đếm brand tổng (nếu có)
function updateBrandTotalCount() {
    fetch('/brand/view?type=total')
        .then(res => res.json())
        .then(data => {
            document.getElementById('brandTotalCount').textContent = data.total;
        });
}

// Popstate: back/forward trình duyệt
window.addEventListener('popstate', function () {
    const params = new URLSearchParams(window.location.search);
    const view = params.get('view');
    let page = getBrandPageFromUrl();
    if (view === 'brand') {
        loadBrandContentAndEvent(page, false); // không update url khi back/forward
    }
});

// Initial load
document.addEventListener('DOMContentLoaded', function () {
    const params = new URLSearchParams(window.location.search);
    const view = params.get('view');
    let page = getBrandPageFromUrl();
    if (view === 'brand') {
        loadBrandContentAndEvent(page, false); // không update url khi load lần đầu
    }
});

// Hỗ trợ Enter/Space cho pagination (accessibility)
document.addEventListener('keydown', function (e) {
    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement && document.activeElement.hasAttribute('page')) {
        const btn = document.activeElement;
        const page = parseInt(btn.getAttribute('page'));
        if (!isNaN(page)) {
            e.preventDefault();
            loadBrandContentAndEvent(page, true);
        }
    }
});



document.addEventListener('keydown', function (e) {
    if (e.key === "Escape") {
        closeCreateModal();
        closeEditModal();
    }
});
['createBrandModal', 'editBrandModal'].forEach(function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.addEventListener('mousedown', function (e) {
            if (e.target === modal) {
                if (modalId === 'createBrandModal')
                    closeCreateModal();
                if (modalId === 'editBrandModal')
                    closeEditModal();
            }
        });
    }
});

// ===================== TOAST NOTIFY ======================
function showToast(message, type = 'success') {
    // type: 'success', 'error', 'info', 'warning'
    const icons = {
        success: `<svg class="w-5 h-5 text-green-500" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M5 13l4 4L19 7"/></svg>`,
        error: `<svg class="w-5 h-5 text-red-500" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>`,
        info: `<svg class="w-5 h-5 text-blue-500" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01"/></svg>`,
        warning: `<svg class="w-5 h-5 text-yellow-500" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M12 9v2m0 4h.01M5.07 18.93A10 10 0 1 1 18.93 5.07 10 10 0 0 1 5.07 18.93z"/></svg>`
    };
    const bgColors = {
        success: "bg-green-50 border-green-500",
        error: "bg-red-50 border-red-500",
        info: "bg-blue-50 border-blue-500",
        warning: "bg-yellow-50 border-yellow-500"
    };
    const toast = document.createElement('div');
    toast.className = `flex items-center max-w-xs w-full p-4 border-l-4 rounded-lg shadow-lg ${bgColors[type]} animate-slide-in`;
    toast.innerHTML = `
        <div class="mr-3">${icons[type]}</div>
        <div class="text-sm font-medium text-gray-800 flex-1">${message}</div>
        <button onclick="this.parentElement.remove()" class="ml-3 text-gray-400 hover:text-gray-700 transition">
            <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24"><path stroke="currentColor" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
    `;
    const toastContainer = document.getElementById('toast-container');
    if (toastContainer) {
        toastContainer.appendChild(toast);
        setTimeout(() => {
            toast.classList.add('opacity-0', 'translate-x-10');
            setTimeout(() => toast.remove(), 300);
        }, 2500);
    } else {
        // fallback
        alert(message);
}
}

function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}
