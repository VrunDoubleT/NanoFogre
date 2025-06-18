const loadCategoryContentAndEvent = (page) => {

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

                // Kiểm tra categoryId trước khi gửi yêu cầu
                if (!categoryId) {
                    console.error("Category ID is missing or invalid.");
                    return;
                }

                console.log("Category ID:", categoryId);

                // Mở modal và tải dữ liệu cho modal
                openModal(modal);

                fetch(`/category/view?type=edit&categoryId=${categoryId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                            loadCreateCategoryEvent(categoryId, page);
                        })
                        .catch(error => {
                            console.error("Error fetching the category data:", error);
                        });
            });
        });

        // Add event for disable category
        document.querySelectorAll(".openDisableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmDeleteCategory(categoryId);
            });
        });

        // Add event for enable category
        document.querySelectorAll(".openEnableCategory").forEach(element => {
            element.addEventListener("click", (e) => {
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-category-id]');
                const categoryId = buttonItem.getAttribute('data-category-id');
                confirmEnableCategory(categoryId);
            });
        });

        // ADD EVENT FOR CREATE CATEGORY
        document.getElementById("create-category-button").onclick = () => {
            const modal = document.getElementById("modal");
            openModal(modal);
            updateModalContent(`/category/view?type=create`, loadCreateCategoryEvent);
        }; // Fix: Thêm dấu ; ở đây
    });
};

const loadCreateCategoryEvent = (categoryId, currentPage) => {
    const updateBtn = document.getElementById("update-category-btn");
    const categoryNameInput = document.getElementById("categoryName");
    const errorDiv = document.getElementById("error-message");

    updateBtn.addEventListener("click", (e) => {
        e.preventDefault();

        const categoryName = categoryNameInput.value.trim();

        // Validate category name
        if (categoryName === "") {
            errorDiv.textContent = "Category name cannot be empty.";
            errorDiv.classList.remove("hidden");
            return;
        }

        const isCreate = categoryId == null;

        const postData = isCreate
                ? `type=create&categoryName=${encodeURIComponent(categoryName)}`
                : `type=update&categoryId=${encodeURIComponent(categoryId)}&categoryName=${encodeURIComponent(categoryName)}`;

        fetch("/category/view", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: postData
        })
                .then(res => {
                    if (!res.ok) {
                        throw new Error(`Category name already exists.`);
                    }
                    return res.text();
                })
                .then(responseText => {
                    if (!responseText) {
                        throw new Error("Empty response from the server");
                    }
                    return JSON.parse(responseText);
                })
                .then(data => {
                    if (data.isSuccess) {
                        showToast(isCreate ? "✅ Category created!" : "✅ Category updated!", "success");
                        closeModal();
                        loadCategoryContentAndEvent(currentPage);
                    } else {
                        errorDiv.textContent = data.message || "Failed to save category.";
                        errorDiv.classList.remove("hidden");
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    errorDiv.textContent = error.message || "Server error. Please try again.";
                    errorDiv.classList.remove("hidden");
                });
    });
};

function showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `fixed top-4 right-4 px-4 py-2 rounded shadow-lg text-white z-50 transition-all duration-300 ${
            type === "success" ? "bg-green-600" : "bg-red-600"
            }`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

// Function to retrieve the page number from the URL (default to 1 if not found)
function getPageFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get('page')) || 1;
}

function confirmDeleteCategory(categoryId) {
    const page = getPageFromUrl();

    Swal.fire({
        title: 'Are you sure you want to hide this category?',
        text: "This category will no longer be visible to customers, but it will remain associated with existing orders and records in the system",
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
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Failed to delete category');
                        }
                        return response.text();
                    })
                    .then(responseText => {
                        let data;
                        try {
                            if (!responseText || responseText.trim() === '') {
                                data = {isSuccess: false, message: 'Invalid server response'};
                            } else {
                                data = JSON.parse(responseText);
                            }
                        } catch (e) {
                            console.error('JSON parse error:', e);
                            data = {isSuccess: true, message: 'Category deleted successfully'};
                        }

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

                        updateCategoryUI(categoryId, 1);
                        loadCategoryContentAndEvent(page);
                    })
                    .catch(error => {
                        console.error("Error deleting category:", error);
                        Swal.fire('Error!', 'There was an issue deleting the category.', 'error');
                    });
        }
    });
}

function confirmEnableCategory(categoryId) {
    const page = getPageFromUrl();

    Swal.fire({
        title: 'Are you sure you want to restore this category?',
        text: "This category will become visible to customers again.",
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

                        updateCategoryUI(categoryId, 0);
                        loadCategoryContentAndEvent(page);
                    });
        }
    });
}

function updateCategoryUI(categoryId, isDeleted) {
    const categoryRow = document.querySelector(`[data-category-id='${categoryId}']`);

    if (categoryRow) {
        const enableButton = categoryRow.querySelector(".openEnableCategory");
        const disableButton = categoryRow.querySelector(".openDisableCategory");

        if (enableButton && disableButton) {
            if (isDeleted) {
                enableButton.classList.remove("bg-green-100", "text-green-700");
                disableButton.classList.add("bg-red-100", "text-red-700");
                disableButton.innerHTML = "&times;";
            } else {
                enableButton.classList.add("bg-green-100", "text-green-700");
                disableButton.classList.remove("bg-red-100", "text-red-700");
                disableButton.innerHTML = "Restore";
            }
        }
    } else {
        console.error(`Category row with ID ${categoryId} not found`);
    }
}