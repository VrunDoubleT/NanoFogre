const loadCategoryContentAndEvent = (page) => {
    lucide.createIcons();
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingCategory').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    // Fetch category list and pagination
    Promise.all([
        fetch("/category/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/category/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([categoryHTML, paginationHTML]) => {

// UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = categoryHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCategory').innerHTML = '';
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
                    updatePageUrl(pageClick);
                    loadCategoryContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });

        // ADD EVENT FOR EDIT CATEGORY
        document.querySelectorAll(".openEditCategoryModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal");
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-category-id]');
                const categoryId = buttonItem ? buttonItem.getAttribute('data-category-id') : null;
                if (!categoryId) {
                    console.error("Category ID is missing or invalid.");
                    return;
                }
                openModal(modal);

                fetch(`/category/view?type=edit&categoryId=${categoryId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                            // Gọi đúng hàm cho edit
                            loadEditCategoryEvent(categoryId, page);
                        })
                        .catch(error => {
                            console.error("Error fetching the category data:", error);
                        });
            });
        });

        // ADD EVENT FOR CREATE CATEGORY
        document.getElementById("create-category-button").onclick = () => {
            const modal = document.getElementById("modal");
            openModal(document.getElementById('modal'));
            updateModalContent(`/category/view?type=create`, loadCreateCategoryEvent);
        }

        /////hIDE cATEGFORY
        function confirmHideCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to hide this category?',
                text: "This category will be hidden from users but still kept in system records.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, hide it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=delete&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }

        function confirmEnableCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to restore this category?',
                text: "This category will be visible to users again.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, restore it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=enable&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }
// DISABLE/HIDE
        document.querySelectorAll(".openDisableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmHideCategory(categoryId);
            });
        });

// ENABLE
        document.querySelectorAll(".openEnableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmEnableCategory(categoryId);
            });
        });
        ////
    });
};




//edit category
const loadCategoryContentAndEvent = (page) => {
    lucide.createIcons();
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingCategory').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    // Fetch category list and pagination
    Promise.all([
        fetch("/category/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/category/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([categoryHTML, paginationHTML]) => {

// UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = categoryHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCategory').innerHTML = '';
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
                    updatePageUrl(pageClick);
                    loadCategoryContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });

        // ADD EVENT FOR EDIT CATEGORY
        document.querySelectorAll(".openEditCategoryModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal");
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-category-id]');
                const categoryId = buttonItem ? buttonItem.getAttribute('data-category-id') : null;
                if (!categoryId) {
                    console.error("Category ID is missing or invalid.");
                    return;
                }
                openModal(modal);

                fetch(`/category/view?type=edit&categoryId=${categoryId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                            // Gọi đúng hàm cho edit
                            loadEditCategoryEvent(categoryId, page);
                        })
                        .catch(error => {
                            console.error("Error fetching the category data:", error);
                        });
            });
        });

        // ADD EVENT FOR CREATE CATEGORY
        document.getElementById("create-category-button").onclick = () => {
            const modal = document.getElementById("modal");
            openModal(document.getElementById('modal'));
            updateModalContent(`/category/view?type=create`, loadCreateCategoryEvent);
        }

        /////hIDE cATEGFORY
        function confirmHideCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to hide this category?',
                text: "This category will be hidden from users but still kept in system records.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, hide it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=delete&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }

        function confirmEnableCategory(categoryId) {
            Swal.fire({
                title: 'Are you sure you want to restore this category?',
                text: "This category will be visible to users again.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, restore it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/category/view?type=enable&categoryId=${categoryId}`, {
                        method: 'POST'
                    })
                            .then(response => response.json())
                            .then(data => {
                                Toastify({
                                    text: data.message,
                                    duration: 5000,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: data.isSuccess ? "#2196F3" : "#f44336"
                                    },
                                    close: true
                                }).showToast();
                                loadCategoryContentAndEvent(getPageFromUrl());
                            });
                }
            });
        }
// DISABLE/HIDE
        document.querySelectorAll(".openDisableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmHideCategory(categoryId);
            });
        });

// ENABLE
        document.querySelectorAll(".openEnableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const buttonItem = e.target.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmEnableCategory(categoryId);
            });
        });
        ////
    });
};


//edit category
function loadEditCategoryEvent(categoryId, currentPage) {
    lucide.createIcons();

    const nameInput = document.getElementById("categoryName");
    const imageInput = document.getElementById("categoryImage");
    const preview = document.getElementById("image-preview");
    const form = document.getElementById("edit-category-form");
    const errorDiv = document.getElementById("error-message");
    const nameError = document.getElementById("categoryNameError");
    const imageError = document.getElementById("categoryImageError");
    const statusDiv = document.getElementById("upload-status");
    const statusText = document.getElementById("status-text");
    const errorStatusDiv = document.getElementById("upload-error");
    const errorStatusText = document.getElementById("error-text");


    const oldImg = imageInput.getAttribute("data-old-image");

    if (oldImg && preview && !imageInput.files[0]) {
        preview.innerHTML = `<img src="${oldImg}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
    }

    imageInput.onchange = function () {
        if (imageInput.files && imageInput.files[0]) {
            const file = imageInput.files[0];
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.innerHTML = `<img src="${e.target.result}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
            };
            reader.readAsDataURL(file);
        } else if (oldImg) {

            preview.innerHTML = `<img src="${oldImg}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
        } else {
            preview.innerHTML = `<span class="text-gray-400 italic">No image available</span>`;
        }
    };

    function showStatus(message) {
        statusDiv.classList.remove("hidden");
//        statusText.textContent = message;
        errorStatusDiv.classList.add("hidden");
        hiddenLoading();
    }
    function showError(message) {
        errorStatusDiv.classList.remove("hidden");
        errorStatusText.textContent = message;
        statusDiv.classList.add("hidden");
        hiddenLoading();
    }

    // Validate
    function validate() {
        let isError = false;
        if (!nameInput.value.trim()) {
            nameError.textContent = "Category name is required";
            isError = true;
        } else {
            nameError.textContent = "";
        }
        return !isError;
    }

    // Submit
    form.onsubmit = function (e) {
        e.preventDefault();
        errorDiv.classList.add("hidden");
        errorStatusDiv.classList.add("hidden");
        statusDiv.classList.add("hidden");

        if (!validate())
            return;

        const formData = new FormData();
        formData.append("type", "update");
        formData.append("categoryId", categoryId);
        formData.append("categoryName", nameInput.value.trim());

        if (imageInput.files && imageInput.files[0]) {
            formData.append("categoryImage", imageInput.files[0]);
        }

        showLoading();

        fetch('/category/view', {
            method: 'POST',
            body: formData
        })
                .then(response => response.json())
                .then(data => {

                    if (data.isSuccess) {
                        showStatus(data.message || "Category updated!");
                        setTimeout(() => {
                            closeModal();
                            loadCategoryContentAndEvent(currentPage);
                        }, 800);
                    } else {
                        showError(data.message || "Update failed");
                    }
                })
                .catch(() => {
                    hiddenLoading();
                    showError("Something went wrong, please try again!");
                });
    };
}

//Create Category
function loadCreateCategoryEvent() {
    lucide.createIcons();

    const nameInput = document.getElementById("categoryName");
    const imageInput = document.getElementById("categoryImage");
    const preview = document.getElementById("image-preview");
    const btnCreate = document.getElementById("create-category-btn");
    const statusDiv = document.getElementById("upload-status");
    const statusText = document.getElementById("status-text");
    const errorDiv = document.getElementById("upload-error");
    const errorText = document.getElementById("error-text");

    // Preview
    imageInput.onchange = function () {
        preview.innerHTML = "";
        if (imageInput.files && imageInput.files[0]) {
            const file = imageInput.files[0];
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.innerHTML = `<img src="${e.target.result}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
            };
            reader.readAsDataURL(file);
        }
    };

    // Validate
    function validate() {
        let isError = false;
        if (!nameInput.value.trim()) {
            document.getElementById("categoryNameError").textContent = "Category name is required";
            isError = true;
        } else {
            document.getElementById("categoryNameError").textContent = "";
        }
        if (!imageInput.files || !imageInput.files[0]) {
            document.getElementById("categoryImageError").textContent = "Category image is required";
            isError = true;
        } else {
            document.getElementById("categoryImageError").textContent = "";
        }
        return !isError;
    }

    function showError(message) {
        errorDiv.classList.remove("hidden");
        errorText.textContent = message;
        statusDiv.classList.add("hidden");
    }

    btnCreate.onclick = function (e) {
        e.preventDefault();
        if (!validate())
            return;

        const formData = new FormData();
        formData.append("categoryName", nameInput.value.trim());
        formData.append("categoryImage", imageInput.files[0]);

        showLoading();

        fetch('/category/view?type=create', {
            method: 'POST',
            body: formData
        })
                .then(response => response.json())
                .then(data => {
                    hiddenLoading(); // Đặt ở đây
                    if (data.isSuccess) {
                        // Có thể showStatus nếu muốn, hoặc chỉ close luôn
                        setTimeout(() => {
                            closeModal();
                            if (typeof loadCategoryContentAndEvent === 'function') {
                                loadCategoryContentAndEvent(1);
                            }
                        }, 400);
                    } else {
                        showError(data.message || "Failed to create category");
                    }
                })
                .catch(() => {
                    hiddenLoading(); // Và ở đây nếu lỗi
                    showError("Something went wrong, please try again!");
                });
    }
}

function showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `fixed top-4 right-4 px-4 py-2 rounded shadow-lg text-white z-50 transition-all duration-300 ${
            type === "success" ? "bg-[#2196F3]" : "bg-[#f44336]"
            }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

function getPageFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get('page')) || 1;
}



// Update total category when deleted success or created new ctegory 
function updateCategoryCount() {
    fetch("/category/view?type=total")
            .then(response => response.json())
            .then(data => {
                const countElement = document.querySelector(".category-count");
                if (countElement) {
                    countElement.textContent = `Total Category: ${data.total}`;
                }
            })
            .catch(error => {
                console.error("Error fetching category count:", error);
            });
}


document.getElementById("modal").onclick = () => {
    document.getElementById("modal").classList.remove("flex");
    document.body.classList.remove("overflow-hidden");
    document.getElementById("modal").classList.add("hidden");
};
document.getElementById("modalContent").addEventListener("click", function (event) {
    event.stopPropagation();
});



//Create Category
function loadCreateCategoryEvent() {
    lucide.createIcons();

    const nameInput = document.getElementById("categoryName");
    const imageInput = document.getElementById("categoryImage");
    const preview = document.getElementById("image-preview");
    const btnCreate = document.getElementById("create-category-btn");
    const statusDiv = document.getElementById("upload-status");
    const statusText = document.getElementById("status-text");
    const errorDiv = document.getElementById("upload-error");
    const errorText = document.getElementById("error-text");

    // Preview
    imageInput.onchange = function () {
        preview.innerHTML = "";
        if (imageInput.files && imageInput.files[0]) {
            const file = imageInput.files[0];
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.innerHTML = `<img src="${e.target.result}" class="h-32 w-32 object-cover rounded-lg shadow" />`;
            };
            reader.readAsDataURL(file);
        }
    };

    // Validate
    function validate() {
        let isError = false;
        if (!nameInput.value.trim()) {
            document.getElementById("categoryNameError").textContent = "Category name is required";
            isError = true;
        } else {
            document.getElementById("categoryNameError").textContent = "";
        }
        if (!imageInput.files || !imageInput.files[0]) {
            document.getElementById("categoryImageError").textContent = "Category image is required";
            isError = true;
        } else {
            document.getElementById("categoryImageError").textContent = "";
        }
        return !isError;
    }

    function showError(message) {
        errorDiv.classList.remove("hidden");
        errorText.textContent = message;
        statusDiv.classList.add("hidden");
    }

    btnCreate.onclick = function (e) {
        e.preventDefault();
        if (!validate())
            return;

        const formData = new FormData();
        formData.append("categoryName", nameInput.value.trim());
        formData.append("categoryImage", imageInput.files[0]);

        showLoading();

        fetch('/category/view?type=create', {
            method: 'POST',
            body: formData
        })
                .then(response => response.json())
                .then(data => {
                    hiddenLoading(); // Đặt ở đây
                    if (data.isSuccess) {
                        // Có thể showStatus nếu muốn, hoặc chỉ close luôn
                        setTimeout(() => {
                            closeModal();
                            if (typeof loadCategoryContentAndEvent === 'function') {
                                loadCategoryContentAndEvent(1);
                            }
                        }, 400);
                    } else {
                        showError(data.message || "Failed to create category");
                    }
                })
                .catch(() => {
                    hiddenLoading(); // Và ở đây nếu lỗi
                    showError("Something went wrong, please try again!");
                });
    }
}

function showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `fixed top-4 right-4 px-4 py-2 rounded shadow-lg text-white z-50 transition-all duration-300 ${
            type === "success" ? "bg-[#2196F3]" : "bg-[#f44336]"
            }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

function getPageFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get('page')) || 1;
}



// Update total category when deleted success or created new ctegory 
function updateCategoryCount() {
    fetch("/category/view?type=total")
            .then(response => response.json())
            .then(data => {
                const countElement = document.querySelector(".category-count");
                if (countElement) {
                    countElement.textContent = `Total Category: ${data.total}`;
                }
            })
            .catch(error => {
                console.error("Error fetching category count:", error);
            });
}


document.getElementById("modal").onclick = () => {
    document.getElementById("modal").classList.remove("flex");
    document.body.classList.remove("overflow-hidden");
    document.getElementById("modal").classList.add("hidden");
};
document.getElementById("modalContent").addEventListener("click", function (event) {
    event.stopPropagation();
});

