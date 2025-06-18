function openCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
    // Reset form
    document.getElementById('newBrandName').value = '';
    document.getElementById('newBrandImage').value = '';
    document.getElementById('addBrandImagePreview').innerHTML = '';
}

function closeCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
        // Reset form
        document.getElementById('newBrandName').value = '';
        document.getElementById('newBrandImage').value = '';
        document.getElementById('addBrandImagePreview').innerHTML = '';
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
    // Fill form
    document.getElementById('editBrandId').value = id;
    document.getElementById('editBrandName').value = name;
    document.getElementById('editBrandImage').value = '';
    document.getElementById('editBrandImagePreview').innerHTML = '';
    const currentImageWrapper = document.getElementById('editBrandCurrentImageWrapper');
    if (imageUrl && imageUrl.trim() !== '') {
        currentImageWrapper.innerHTML = `<img src="${imageUrl}" alt="Current Image" class="max-h-20 rounded shadow border">`;
    } else {
        currentImageWrapper.innerHTML = '<p class="text-gray-500 text-sm">No current image</p>';
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
        document.getElementById('editBrandName').value = '';
        document.getElementById('editBrandImage').value = '';
        document.getElementById('editBrandImagePreview').innerHTML = '';
        document.getElementById('editBrandCurrentImageWrapper').innerHTML = '';
    }, 300);
}


function editBrand(id) {
    console.log('Editing brand with ID:', id); 
    
    fetch(`/brand?action=getBrand&id=${id}`)
        .then(res => {
            console.log('Response status:', res.status);
            if (!res.ok) throw new Error('HTTP error');
            return res.json();
        })
        .then(data => {
            console.log('Response data:', data);
            if (data.success) {
                openEditModal(data.brand.id, data.brand.name, data.brand.image);
            } else {
                 showToast(data.message || 'Brand not found!');
            }
        })
        .catch((error) => {
            console.error('Error:', error); // Debug log
             showToast('Data processing error: ' + error.message);
        });
}



let brandIdToDelete = null;

function showConfirmDeleteModal() {
    const overlay = document.getElementById('confirmDeleteModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('hidden');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.body.classList.add('overflow-hidden');
}

function closeConfirmDeleteModal() {
    const overlay = document.getElementById('confirmDeleteModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
        brandIdToDelete = null;
    }, 300);
}

function deleteBrand(id) {
    brandIdToDelete = id;
    showConfirmDeleteModal();
}

document.addEventListener('click', function(e) {
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
});
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeConfirmDeleteModal();
});




function handleCreateBrand() {
    const name = document.getElementById('newBrandName').value.trim();
    const imageInput = document.getElementById('newBrandImage');
     const submitBtn = document.querySelector('#createBrandForm button[type="submit"]');
    const loadingIcon = submitBtn.querySelector('#loadingIconCreate');
    // Hiển thị loading
    submitBtn.disabled = true;
    loadingIcon.classList.remove('hidden');
    if (!name || !imageInput.files.length) {
    showToast('Please enter complete information');
    submitBtn.disabled = false;
    loadingIcon.classList.add('hidden');
    return;
}
    const formData = new FormData();
    formData.append('action', 'create');
    formData.append('name', name);
    formData.append('image', imageInput.files[0]);
    fetch('/brand', {
        method: 'POST',
        body: formData
    })
            .then(response => response.json())
            .then(data => {
        if (data.success) {
            showToast(data.message);
            closeCreateModal();
            loadBrandContentAndEvent(1);
        } else {
            showToast(data.message);
        }
    })
    .catch(() => showToast('Lỗi kết nối server', 'error'))
    .finally(() => {
        submitBtn.disabled = false;
        loadingIcon.classList.add('hidden');
    });
}

function handleUpdateBrand() {
    const id = document.getElementById('editBrandId').value;
    const name = document.getElementById('editBrandName').value.trim();
    const imageInput = document.getElementById('editBrandImage');

    if (!name) {
        showToast('Please enter brand name');
        return;
    }

    const formData = new FormData();
    formData.append('action', 'update');
    formData.append('id', id);
    formData.append('name', name);

    if (imageInput.files.length > 0) {
        formData.append('image', imageInput.files[0]);
    }

    fetch('/brand', {
        method: 'POST',
        body: formData
    })
    .then(async response => {
        const data = await response.json().catch(() => ({}));
        if (!response.ok) {
            throw new Error(data.message || 'Có lỗi xảy ra');
        }
        return data;
    })
    .then(data => {
        showToast(data.message, 'success');
        loadBrandContentAndEvent(1);
    })
    .catch(error => {
        showToast(error.message, 'error');
    });
}

document.addEventListener('DOMContentLoaded', function() {
    var confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', function() {
            if (brandIdToDelete !== null) {
                handleDeleteBrand(brandIdToDelete);
                closeConfirmDeleteModal();
            }
        });
    }
    var cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener('click', closeConfirmDeleteModal);
    }
    var closeDeleteModalBtn = document.getElementById('closeDeleteModalBtn');
    if (closeDeleteModalBtn) {
        closeDeleteModalBtn.addEventListener('click', closeConfirmDeleteModal);
    }
    var confirmDeleteModal = document.getElementById('confirmDeleteModal');
    if (confirmDeleteModal) {
        confirmDeleteModal.addEventListener('click', function(e) {
            if (e.target === this) closeConfirmDeleteModal();
        });
    }
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeConfirmDeleteModal();
    });
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
                    loadBrandContentAndEvent(1);
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

function loadBrandContentAndEvent(page = 1, updateUrl = true) {
    var brandContainer = document.getElementById('brandContainer');
    if (brandContainer) {
        brandContainer.innerHTML = '';
    }
    var loadingBrand = document.getElementById('loadingBrand');
    if (loadingBrand) {
        loadingBrand.innerHTML = `
        <div class="flex justify-center items-center py-8">
            <svg class="animate-spin h-8 w-8 text-blue-600" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
            </svg>
            <span class="ml-2 text-blue-600 font-medium">Loading brands...</span>
        </div>
        `;
    }
    fetch(`/admin/view?viewPage=brand&page=${page}`)
        .then(res => res.text())
        .then(html => {
            var loadingBrand = document.getElementById('loadingBrand');
            if (loadingBrand) loadingBrand.innerHTML = '';

            var brandContainer = document.getElementById('brandContainer');
            if (brandContainer) brandContainer.innerHTML = html;

            lucide.createIcons && lucide.createIcons();

            // Cập nhật totalPages từ hidden input
            const totalPagesInput = document.getElementById('totalPages');
            if (totalPagesInput) {
                totalPages = parseInt(totalPagesInput.value);
            }

            if (updateUrl) {
                let url;
                if (page === 1) {
                    if (window.location.search !== '?view=brand') {
                        url = '/admin/dashboard?view=brand&page=1';
                        window.history.pushState({page: page}, '', url);
                    }
                } else {
                    url = `/admin/dashboard?view=brand&page=${page}`;
                    window.history.pushState({page: page}, '', url);
                }
            }

            initPaginationAccessibility();
        })
        .catch(error => {
            var loadingBrand = document.getElementById('loadingBrand');
            if (loadingBrand) loadingBrand.innerHTML = '';

            var brandContainer = document.getElementById('brandContainer');
            if (brandContainer) {
                brandContainer.innerHTML = `
                <div class="text-center text-red-600 py-8">⚠️ Error loading data</div>
                `;
            }
            console.error('Error:', error);
        });
}


function loadBrandPage(page) {
    if (page < 1 || page > totalPages) return;
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

document.addEventListener('click', function(e) {
    const paginationBtn = e.target.closest('.pagination, [page]');
    if (paginationBtn && paginationBtn.hasAttribute('page')) {
        const isDisabled = paginationBtn.classList.contains('pointer-events-none') ||
            paginationBtn.getAttribute('aria-disabled') === 'true' ||
            paginationBtn.style.pointerEvents === 'none';
        if (isDisabled) return;
        const page = parseInt(paginationBtn.getAttribute('page'));
        if (!isNaN(page)) loadBrandPage(page);
    }
});

document.addEventListener('keydown', function(e) {
    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement && document.activeElement.hasAttribute('page')) {
        const btn = document.activeElement;
        const isDisabled = btn.classList.contains('pointer-events-none') ||
            btn.getAttribute('aria-disabled') === 'true' ||
            btn.style.pointerEvents === 'none';
        if (isDisabled) return;
        const page = parseInt(btn.getAttribute('page'));
        if (!isNaN(page)) {
            e.preventDefault();
            loadBrandPage(page);
        }
    }
});

document.addEventListener('DOMContentLoaded', function() {
    initPaginationAccessibility();

    let pageParam = getQueryParam('page');
    let page = 1;
    if (pageParam) {
        page = parseInt(pageParam) || 1;
    }
    if (page === 1 && window.location.search === '?view=brand&page=1') {
        window.history.replaceState({page: 1}, '', '/admin/dashboard?view=brand');
    }
    loadBrandContentAndEvent(page, false); 
});



document.addEventListener('DOMContentLoaded', function() {
    // Add Brand
    const addImageInput = document.getElementById('newBrandImage');
    const addImagePreviewId = 'addBrandImagePreview';
    if (addImageInput) {
        addImageInput.addEventListener('change', function() {
            let preview = document.getElementById(addImagePreviewId);
            if (!preview) {
                preview = document.createElement('div');
                preview.id = addImagePreviewId;
                preview.className = 'flex justify-center mt-2';
                this.parentNode.appendChild(preview);
            }
            preview.innerHTML = '';
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="max-h-24 rounded shadow border">`;
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

    // Edit Brand
    const editImageInput = document.getElementById('editBrandImage');
    const editImagePreviewId = 'editBrandImagePreview';
    if (editImageInput) {
        editImageInput.addEventListener('change', function() {
            let preview = document.getElementById(editImagePreviewId);
            if (!preview) {
                preview = document.createElement('div');
                preview.id = editImagePreviewId;
                preview.className = 'flex justify-center mt-2';
                this.parentNode.appendChild(preview);
            }
            preview.innerHTML = '';
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="max-h-24 rounded shadow border">`;
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
        closeCreateModal();
        closeEditModal();
    }
});
['createBrandModal', 'editBrandModal'].forEach(function(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.addEventListener('mousedown', function(e) {
            if (e.target === modal) {
                if (modalId === 'createBrandModal') closeCreateModal();
                if (modalId === 'editBrandModal') closeEditModal();
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



