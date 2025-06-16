function openCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('opacity-0', 'pointer-events-none');
    overlay.classList.add('opacity-100', 'pointer-events-auto');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.getElementById('newBrandName').value = '';
    document.getElementById('newBrandImage').value = '';
    document.getElementById('addBrandImagePreview').innerHTML = '';
}

function openEditModal(id, name, imageUrl) {
    const overlay = document.getElementById('editBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    overlay.classList.remove('opacity-0', 'pointer-events-none');
    overlay.classList.add('opacity-100', 'pointer-events-auto');
    setTimeout(() => {
        modal.classList.remove('scale-95', 'opacity-0', 'translate-y-8');
        modal.classList.add('scale-100', 'opacity-100', 'translate-y-0');
    }, 10);
    document.getElementById('editBrandId').value = id;
    document.getElementById('editBrandName').value = name;
    document.getElementById('editBrandImage').value = '';
    document.getElementById('editBrandImagePreview').innerHTML = '';
    const currentImageWrapper = document.getElementById('editBrandCurrentImageWrapper');
    if (imageUrl && imageUrl.trim() !== '') {
        currentImageWrapper.innerHTML = `<img src="${imageUrl}" alt="Current Image" class="max-h-20 rounded shadow border">`;
    } else {
        currentImageWrapper.innerHTML = '<p class="text-gray-500 text-sm">Không có ảnh hiện tại</p>';
    }
}

function closeCreateModal() {
    const overlay = document.getElementById('createBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.remove('opacity-100', 'pointer-events-auto');
        overlay.classList.add('opacity-0', 'pointer-events-none');
    }, 300);
    document.getElementById('newBrandName').value = '';
    document.getElementById('newBrandImage').value = '';
    document.getElementById('addBrandImagePreview').innerHTML = '';
}

function closeEditModal() {
    const overlay = document.getElementById('editBrandModal');
    const modal = overlay.querySelector('.shadow-2xl');
    modal.classList.remove('scale-100', 'opacity-100', 'translate-y-0');
    modal.classList.add('scale-95', 'opacity-0', 'translate-y-8');
    setTimeout(() => {
        overlay.classList.remove('opacity-100', 'pointer-events-auto');
        overlay.classList.add('opacity-0', 'pointer-events-none');
    }, 300);
    document.getElementById('editBrandName').value = '';
    document.getElementById('editBrandImage').value = '';
    document.getElementById('editBrandImagePreview').innerHTML = '';
    document.getElementById('editBrandCurrentImageWrapper').innerHTML = '';
}


function editBrand(id) {
    console.log('Editing brand with ID:', id); // Debug log
    
    fetch(`/brand?action=getBrand&id=${id}`)
        .then(res => {
            console.log('Response status:', res.status); // Debug log
            if (!res.ok) throw new Error('HTTP error');
            return res.json();
        })
        .then(data => {
            console.log('Response data:', data); // Debug log
            if (data.success) {
                openEditModal(data.brand.id, data.brand.name, data.brand.image);
            } else {
                 showToast(data.message || 'Không tìm thấy thương hiệu!');
            }
        })
        .catch((error) => {
            console.error('Error:', error); // Debug log
             showToast('Lỗi xử lý dữ liệu: ' + error.message);
        });
}



function deleteBrand(id) {
    if (typeof Swal === "undefined") {
        if (confirm('Are you sure you want to delete this brand?')) {
            handleDeleteBrand(id);
        }
        return;
    }

    Swal.fire({
        title: 'Confirm deletion',
        text: 'Are you sure you want to delete this brand?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            handleDeleteBrand(id);
        }
    });
}

function handleCreateBrand() {
    const name = document.getElementById('newBrandName').value.trim();
    const imageInput = document.getElementById('newBrandImage');
     const submitBtn = document.querySelector('#createBrandForm button[type="submit"]');
    const loadingIcon = submitBtn.querySelector('#loadingIconCreate');
    // Hiển thị loading
    submitBtn.disabled = true;
    loadingIcon.classList.remove('hidden');
    if (!name || !imageInput.files.length) {
    showToast('Vui lòng nhập đầy đủ thông tin');
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
        showToast('Vui lòng nhập tên thương hiệu');
        return;
    }
    
    const formData = new FormData();
    formData.append('action', 'update');
    formData.append('id', id);
    formData.append('name', name);
    
    // Chỉ append file nếu người dùng đã chọn file mới
    if (imageInput.files.length > 0) {
        formData.append('image', imageInput.files[0]);
    }
    
    fetch('/brand', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast(data.message);
            closeEditModal();
            loadBrandContentAndEvent(1); // Refresh danh sách
        } else {
            showToast(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Lỗi kết nối server');
    });
}


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
    const nameRegex = /^[a-zA-Z0-9\sÀ-ỹ]{3,50}$/;
    const imageRegex = /^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/\S+\.(jpg|jpeg|png|gif|webp|svg))$/i;

    if (!name || !image) {
         showToast('Please fill in all information');
        return false;
    }
    if (name.length < 3 || name.length > 50) {
         showToast('The brand name must be between 3 and 50 characters');
        return false;
    }
    if (!nameRegex.test(name)) {
         showToast('The brand name can only contain letters, numbers, and spaces');
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

function loadBrandContentAndEvent(page = 1) {
    document.getElementById('brandContainer').innerHTML = '';
    document.getElementById('loadingBrand').innerHTML = `
        <div class="flex justify-center items-center py-8">
            <svg class="animate-spin h-8 w-8 text-blue-600" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
            </svg>
            <span class="ml-2 text-blue-600 font-medium">Loading brands...</span>
        </div>
    `;

    fetch(`/admin/view?viewPage=brand&page=${page}`)
            .then(res => res.text())
            .then(html => {
                document.getElementById('loadingBrand').innerHTML = '';
                document.getElementById('brandContainer').innerHTML = html;
                lucide.createIcons();
                setBrandActionEvents();
                history.pushState({page: page}, '', `/admin/dashboard?view=brand&page=${page}`);
            })
            .catch(error => console.error('Error loading brands:', error));
}

function loadBrandPage(page) {
    if (page < 1)
        return;
    loadBrandContentAndEvent(page);
}
// Preview ảnh khi chọn file ở modal Add Brand và Edit Brand
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

// Đóng modal khi nhấn ESC hoặc click ra ngoài modal content
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



