function openCreateModal() {
    document.getElementById('createBrandModal').classList.remove('hidden');
    document.getElementById('newBrandName').value = '';
    document.getElementById('newBrandImage').value = '';
}

function openEditModal(id, name, image) {
    document.getElementById('editBrandModal').classList.remove('hidden');
    document.getElementById('editBrandId').value = id;
    document.getElementById('editBrandName').value = name;
    document.getElementById('editBrandImage').value = image;
}

function closeCreateModal() {
    document.getElementById('createBrandModal').classList.add('hidden');
}

function closeEditModal() {
    document.getElementById('editBrandModal').classList.add('hidden');
}

function editBrand(id) {
    fetch(`/brand?action=getBrand&id=${id}`)
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                openEditModal(data.brand.id, data.brand.name, data.brand.image);
            } else {
                showErrorAlert('Unable to fetch brand information');
            }
        })
        .catch(() => showErrorAlert('Server connection error'));
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
    const image = document.getElementById('newBrandImage').value.trim();

    if (!validateBrandData(name, image)) return;

    fetch('/brand', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=create&name=${encodeURIComponent(name)}&image=${encodeURIComponent(image)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showSuccessAlert(data.message);
            closeCreateModal();
            loadBrandContentAndEvent(1);
        } else {
            showErrorAlert(data.message);
        }
    })
    .catch(() => showErrorAlert('Server connection error'));
}

function handleUpdateBrand() {
    const id = document.getElementById('editBrandId').value;
    const name = document.getElementById('editBrandName').value.trim();
    const image = document.getElementById('editBrandImage').value.trim();

    if (!validateBrandData(name, image)) return;

    fetch('/brand', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: `action=update&id=${id}&name=${encodeURIComponent(name)}&image=${encodeURIComponent(image)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showSuccessAlert(data.message);
            closeEditModal();
            loadBrandContentAndEvent(1);
        } else {
            showErrorAlert(data.message);
        }
    })
    .catch(() => showErrorAlert('Server connection error'));
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
            showSuccessAlert(data.message);
            loadBrandContentAndEvent(1);
        } else {
            showErrorAlert(data.message);
        }
    })
    .catch(() => showErrorAlert('Server connection error'));
}

function validateBrandData(name, image) {
    const nameRegex = /^[a-zA-Z0-9\sÀ-ỹ]{3,50}$/;
    const imageRegex = /^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/\S+\.(jpg|jpeg|png|gif|webp|svg))$/i;

    if (!name || !image) {
        showErrorAlert('Please fill in all information');
        return false;
    }
    if (name.length < 3 || name.length > 50) {
        showErrorAlert('The brand name must be between 3 and 50 characters');
        return false;
    }
    if (!nameRegex.test(name)) {
        showErrorAlert('The brand name can only contain letters, numbers, and spaces');
        return false;
    }
    if (!imageRegex.test(image)) {
        showErrorAlert('Invalid image URL');
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
    if (page < 1) return;
    loadBrandContentAndEvent(page);
}

