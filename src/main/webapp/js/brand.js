function openCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
    document.getElementById('newBrandName').value = '';
    document.getElementById('newBrandImage').value = '';
    document.getElementById('createBrandImagePreview').innerHTML = '';
    document.getElementById('createBrandNameError').textContent = '';
    document.getElementById('createBrandImageError').textContent = '';
    document.getElementById('newBrandName').classList.remove('border-red-500');

    const fileNameLabel = document.querySelector('#createBrandModal .file-name');
    if (fileNameLabel)
        fileNameLabel.textContent = 'No file chosen';
    const nameInput = document.getElementById('newBrandName');
    const nameError = document.getElementById('createBrandNameError');
    if (nameInput && nameError) {
        nameInput.onfocus = nameInput.oninput = function () {
            nameError.textContent = '';
            this.classList.remove('border-red-500');
        };
    }
    const imageInput = document.getElementById('newBrandImage');
    const imageError = document.getElementById('createBrandImageError');
    if (imageInput && imageError) {
        imageInput.onchange = function () {
            showFileName(this);
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
}

function closeCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
        document.getElementById('createBrandImagePreview').innerHTML = '';
        const fileNameLabel = document.querySelector('#createBrandModal .file-name');
        if (fileNameLabel) {
            fileNameLabel.textContent = 'No file chosen';
        }
    }, 300);
}

function openEditModal(id, name, imageUrl) {
    const overlay = document.getElementById('editBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
    document.getElementById('editBrandId').value = id;
    document.getElementById('editBrandName').value = name;
    document.getElementById('editBrandImage').value = '';
    document.getElementById('editBrandImagePreview').innerHTML = '';
    document.getElementById('editBrandNameError').textContent = '';
    document.getElementById('editBrandImageError').textContent = '';
    document.getElementById('editBrandName').classList.remove('border-red-500');

    const currentImageWrapper = document.getElementById('editBrandCurrentImageWrapper');
    if (imageUrl && imageUrl.trim() !== '') {
        currentImageWrapper.innerHTML = `<img src="${imageUrl}" alt="Current Image" class="max-h-20 rounded shadow border">`;
    } else {
        currentImageWrapper.innerHTML = '<p class="text-gray-500 text-sm">No current image</p>';
    }

    const nameInput = document.getElementById('editBrandName');
    const nameError = document.getElementById('editBrandNameError');
    if (nameInput && nameError) {
        nameInput.onclick = null;
        nameInput.oninput = null;
        nameInput.onclick = function () {
            nameError.textContent = '';
            this.classList.remove('border-red-500');
        };
        nameInput.oninput = function () {
            nameError.textContent = '';
            this.classList.remove('border-red-500');
        };
    }

    const imageInput = document.getElementById('editBrandImage');
    const imageError = document.getElementById('editBrandImageError');
    if (imageInput && imageError) {
        imageInput.onchange = function () {
            showFileName(this);
            imageError.textContent = '';
        };
        imageInput.onclick = function () {
            imageError.textContent = '';
        };
        const uploadLabel = document.querySelector('label[for="editBrandImage"]');
        if (uploadLabel) {
            uploadLabel.onclick = function () {
                imageError.textContent = '';
            };
        }
    }
}



function closeEditModal() {
    const overlay = document.getElementById('editBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    }, 300);
}

function editBrand(id) {
    fetch(`/brand?action=getBrand&id=${id}`)
            .then(res => {
                if (!res.ok)
                    throw new Error('HTTP error');
                return res.json();
            })
            .then(data => {
                if (data.success) {
                    openEditModal(data.brand.id, data.brand.name, data.brand.image);
                } else {
                    showToast(data.message || 'Brand not found!', 'error');
                }
            })
            .catch((error) => {
                showToast('Data processing error: ' + error.message, 'error');
            });
}

let brandIdToDelete = null;

function deleteBrand(id) {
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
            fetch(`/brand?action=delete&id=${id}`, {
                method: 'POST'
            })
                    .then(response => response.json())
                    .then(data => {
                        console.log('Delete brand response:', data); // Debug
                        Toastify({
                            text: data.message,
                            duration: 5000,
                            gravity: "top",
                            position: "right",
                            style: {
                                background: (data.success || data.isSuccess) ? "#2196F3" : "#f44336"
                            },
                            close: true
                        }).showToast();
                        if ((data.success || data.isSuccess) && typeof loadBrandContentAndEvent === "function") {
                            let currentPage = parseInt(getQueryParam('page')) || 1;
                            loadBrandContentAndEvent(currentPage);
                        }
                    })
                    .catch(error => {
                        console.error('Delete brand error:', error);
                        Toastify({
                            text: "Delete failed! Server error.",
                            duration: 5000,
                            gravity: "top",
                            position: "right",
                            style: {background: "#f44336"},
                            close: true
                        }).showToast();
                    });
        }
    });
}

document.addEventListener('click', function (e) {
    if (e.target && e.target.id === 'confirmDeleteBtn') {
        if (brandIdToDelete !== null) {
            handleDeleteBrand(brandIdToDelete);
            closeConfirmDeleteModal();
        }
    }
    if (e.target && e.target.id === 'cancelDeleteBtn') {
        closeConfirmDeleteModal();
    }
    if (e.target && e.target.id === 'closeDeleteModalBtn') {
        closeConfirmDeleteModal();
    }
    if (e.target && e.target.id === 'confirmDeleteModal') {
        closeConfirmDeleteModal();
    }
    if (e.target && e.target.id === 'createBrandModal')
        closeCreateModal();
    if (e.target && e.target.id === 'editBrandModal')
        closeEditModal();
});
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape')
        closeConfirmDeleteModal();
});
function showFileName(input) {
    const fileName = input.files && input.files.length > 0 ? input.files[0].name : 'No file chosen';
    let label = input.parentNode.querySelector('.file-name');
    if (!label)
        label = input.closest('div').querySelector('.file-name');
    if (label)
        label.textContent = fileName;
    // Preview ảnh
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


function handleCreateBrand() {
    const nameInput = document.getElementById('newBrandName');
    const name = nameInput.value.trim();
    const imageInput = document.getElementById('newBrandImage');
    const nameError = document.getElementById('createBrandNameError');
    const imageError = document.getElementById('createBrandImageError');
    const submitBtn = document.querySelector('#createBrandForm button[type="submit"]');
    const loadingIcon = submitBtn.querySelector('#loadingIconCreate');

    nameError.textContent = '';
    nameInput.classList.remove('border-red-500');
    imageError.textContent = '';

    let hasError = false;
    if (!name) {
        nameError.textContent = 'Please enter brand name';
        nameInput.classList.add('border-red-500');
        hasError = true;
    }
    if (!imageInput.files.length) {
        imageError.textContent = 'Please upload brand image';
        hasError = true;
    }
    if (hasError)
        return;

    submitBtn.disabled = true;
//    showLoading();
    loadingIcon.classList.remove('hidden');
    const formData = new FormData();
    formData.append('action', 'create');
    formData.append('name', name);
    formData.append('image', imageInput.files[0]);
    showLoading();
    fetch('/brand', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
                hiddenLoading();
                if (data.success) {
                    showToast(data.message, 'success');
                    closeCreateModal();
                    loadBrandContentAndEvent(1);
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(() => showToast('Server connection error', 'error'))
            .finally(() => {
                submitBtn.disabled = false;
                loadingIcon.classList.add('hidden');
                hideLoading();
            });
}

function handleUpdateBrand() {
    const id = document.getElementById('editBrandId').value;
    const nameInput = document.getElementById('editBrandName');
    const name = nameInput.value.trim();
    const imageInput = document.getElementById('editBrandImage');
    const nameError = document.getElementById('editBrandNameError');
    const imageError = document.getElementById('editBrandImageError');
    const submitBtn = document.querySelector('#editBrandModal button[type="submit"]');
    const loadingIcon = submitBtn.querySelector('#loadingIconEdit');

    nameError.textContent = '';
    nameInput.classList.remove('border-red-500');
    if (imageError)
        imageError.textContent = '';
    if (!name) {
        nameError.textContent = 'Please enter brand name';
        nameInput.classList.add('border-red-500');
        nameInput.focus();
        return;
    }
    submitBtn.disabled = true;
    loadingIcon.classList.remove('hidden');
    const formData = new FormData();
    formData.append('action', 'update');
    formData.append('id', id);
    formData.append('name', name);

    if (imageInput.files.length > 0) {
        formData.append('image', imageInput.files[0]);
    }
    showLoading();
    fetch('/brand', {
        method: 'POST',
        body: formData
    })
            .then(async response => {
                const data = await response.json().catch(() => ({}));
                hiddenLoading();
                if (!response.ok) {
                    throw new Error(data.message || 'An error occurred.');
                }
                return data;
            })
            .then(data => {
                showToast(data.message, 'success');
                closeEditModal();
                let currentPage = parseInt(getQueryParam('page')) || 1;
                loadBrandContentAndEvent(currentPage);
            })
            .catch(error => {
                showToast(error.message, 'error');
            })
            .finally(() => {
                submitBtn.disabled = false;
                loadingIcon.classList.add('hidden');
            });
}

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape')
        closeConfirmDeleteModal();
});



function handleDeleteBrand(id) {
    fetch('/brand', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=delete&id=${id}`
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message);
                    let currentPage = parseInt(getQueryParam('page')) || 1;
                    loadBrandContentAndEvent(currentPage);
                } else {
                    showToast(data.message);
                }
            })
            .catch(() => showToast('Server connection error'));
}

function validateBrandData(name, image) {
    const imageRegex = /^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/\S+\.(jpg|jpeg|png|gif|webp|svg))$/i;

    if (!name || !image) {
        showToast('Please fill in all information');
        return false;
    }
    if (!imageRegex.test(image)) {
        showToast('Invalid image URL');
        return false;
    }
    return true;
}
function showSuccessAlert(message) {
    if (typeof Swal !== "undefined") {
        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: message,
            showConfirmButton: false,
            timer: 2000
        });
    } else {
        alert(message);
    }
}

function showErrorAlert(message) {
    if (typeof Swal !== "undefined") {
        Swal.fire({
            icon: 'error',
            title: 'error',
            text: message,
            confirmButtonColor: '#3085d6'
        });
    } else {
        alert(message);
    }
}
let totalPages = 1;

function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}
function updateBrandUrl(page) {
    const url = new URL(window.location);
    url.searchParams.set('view', 'brand');
    url.searchParams.delete('page');
    if (page > 1 || (page === 1 && window.location.search.includes('page='))) {
        url.searchParams.set('page', page);
    }
    window.history.pushState(null, '', url.toString());
}

function loadBrandContentAndEvent(page = 1, updateUrl = true) {
    const currentView = getQueryParam('view');
    if (currentView !== 'brand')
        return;
    if (updateUrl)
        updateBrandUrl(page);
    var brandContainer = document.getElementById('brandContainer');
    if (brandContainer) {
        brandContainer.innerHTML = '';
    }

    var loadingBrand = document.getElementById('loadingBrand');
    if (loadingBrand) {
        loadingBrand.innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
        <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
    </div>
`;
    }

    fetch(`/admin/view?viewPage=brand&page=${page}`)
            .then(res => res.text())
            .then(html => {
                if (loadingBrand)
                    loadingBrand.innerHTML = '';
                if (brandContainer)
                    brandContainer.innerHTML = html;

                lucide.createIcons && lucide.createIcons();

                const totalPagesInput = document.getElementById('totalPages');
                if (totalPagesInput) {
                    totalPages = parseInt(totalPagesInput.value);
                }

                initPaginationAccessibility();
            })
            .catch(error => {
                if (loadingBrand)
                    loadingBrand.innerHTML = '';
                if (brandContainer) {
                    brandContainer.innerHTML = `
                <div class="text-center text-red-600 py-8">⚠️ Error loading data</div>
            `;
                }
                console.error('Error:', error);
            });
}

function loadBrandPage(page) {
    if (page < 1 || page > totalPages)
        return;
    document.querySelectorAll('[page]').forEach(btn => {
        btn.style.pointerEvents = 'none';
        btn.style.opacity = '0.7';
    });

    loadBrandContentAndEvent(page);
}

function initPaginationAccessibility() {
    document.querySelectorAll('[page]').forEach(btn => {
        btn.setAttribute('role', 'button');
        btn.setAttribute('tabindex', '0');
        btn.style.pointerEvents = '';
        btn.style.opacity = '';
    });
}

window.addEventListener('popstate', function (event) {
    const params = new URLSearchParams(window.location.search);
    const view = params.get('view');
    let page = 1;
    if (params.has('page')) {
        page = parseInt(params.get('page')) || 1;
    }
    if (view === 'brand') {
        loadBrandContentAndEvent(page, false);
    }
});

document.addEventListener('click', function (e) {
    const paginationBtn = e.target.closest('.pagination, [page]');
    if (!paginationBtn || !paginationBtn.hasAttribute('page'))
        return;

    const isDisabled = paginationBtn.classList.contains('pointer-events-none') ||
            paginationBtn.getAttribute('aria-disabled') === 'true' ||
            paginationBtn.style.pointerEvents === 'none';
    if (isDisabled)
        return;

    const page = parseInt(paginationBtn.getAttribute('page'));
    if (isNaN(page))
        return;

    const currentView = getQueryParam('view');
    if (currentView === 'brand') {
        loadBrandPage(page);
    }
});

document.addEventListener('keydown', function (e) {
    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement && document.activeElement.hasAttribute('page')) {
        const btn = document.activeElement;
        const isDisabled = btn.classList.contains('pointer-events-none') ||
                btn.getAttribute('aria-disabled') === 'true' ||
                btn.style.pointerEvents === 'none';
        if (isDisabled)
            return;
        const page = parseInt(btn.getAttribute('page'));
        if (!isNaN(page)) {
            e.preventDefault();

            const currentView = getQueryParam('view');
            if (currentView === 'brand') {
                loadBrandPage(page);
            }
        }
    }
});

document.addEventListener('DOMContentLoaded', function () {
    initPaginationAccessibility();

    const params = new URLSearchParams(window.location.search);
    const view = params.get('view');
    let page = 1;
    if (params.has('page')) {
        page = parseInt(params.get('page')) || 1;
    }
    if (view === 'brand') {
        loadBrandContentAndEvent(page, false);
    }
    const setupImagePreview = (inputId, previewId) => {
        const input = document.getElementById(inputId);
        if (!input)
            return;
        input.addEventListener('change', function () {
            previewImage(this, previewId);
        });
    };
    setupImagePreview('newBrandImage', 'createBrandImagePreview');
    setupImagePreview('editBrandImage', 'editBrandImagePreview');
});

document.addEventListener('keydown', function (e) {
    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement && document.activeElement.hasAttribute('page')) {
        const btn = document.activeElement;
        const isDisabled = btn.classList.contains('pointer-events-none') ||
                btn.getAttribute('aria-disabled') === 'true' ||
                btn.style.pointerEvents === 'none';
        if (isDisabled)
            return;
        const page = parseInt(btn.getAttribute('page'));
        if (!isNaN(page)) {
            e.preventDefault();

            const params = new URLSearchParams(window.location.search);
            const currentView = params.get('view');

            if (currentView === 'brand') {
                loadBrandPage(page);
            }
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
    document.getElementById('toast-container').appendChild(toast);
    setTimeout(() => {
        toast.classList.add('opacity-0', 'translate-x-10');
        setTimeout(() => toast.remove(), 300);
    }, 2500);
}

