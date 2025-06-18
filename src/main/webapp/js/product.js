let handleCategoryChange = null;
const updateModalContent = (path, loadEvent) => {
    fetch(path)
            .then(res => res.text())
            .then(html => {
                document.getElementById("modalContent").innerHTML = html;
            }).then(() => {
        // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
        loadEvent()
    });
}

/**
 * @param {int} categoryId 
 * @param {int} page 
 * */
const loadProductContentAndEvent = (categoryId, page) => {
    //
    lucide.createIcons()
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingProduct').innerHTML = `
  <div class="flex w-full justify-center items-center h-32">
    <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
  </div>
`;
    // PUSH PARAMS URL TO CALL SERVERLET
    let paramUrl = ''
    if (categoryId > 0) {
        paramUrl = '&categoryId=' + categoryId
    }
    // Fetch servlet to get list product html and add event for list
    Promise.all([
        fetch("/product/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/product/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([productHTML, paginationHTML]) => {
        // UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = productHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingProduct').innerHTML = '';

        // ADD EVENT FOR VIEW DETAIL PRODUCT
        document.querySelectorAll(".openViewModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal")
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-product-id]');
                const productId = buttonItem.getAttribute('data-product-id');
                // OPEN AND LOAD CONTEND FOR MODAL
                openModal(modal)
                fetch(`/product/view?productId=${productId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                        }).then(() => {
                    // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
                    loadProductDetailEvent()
                });
            })
        })

        // ADD EVENT FOR EDIT PRODUCT
        document.querySelectorAll(".openEditProdctModal").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal")
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-product-id]');
                const productId = buttonItem.getAttribute('data-product-id');
                // OPEN AND LOAD CONTEND FOR MODAL
                openModal(modal)
                fetch(`/product/view?type=edit&productId=${productId}`)
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                        }).then(() => {
                    // AFTER OPEN MODAL, LOAD CONTENT FOR MODAL
                    loadCreateOrUpdateProductEvent(categoryId, page)
                });
            })
        })

        // Hanlde if confirm hide product
        function confirmHide(productId) {
            Swal.fire({
                title: 'Are you sure you want to hide this product?',
                text: "This product will no longer be visible to customers, but it will remain associated with existing orders and records in the system",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, hide it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/product/view?type=delete&productId=${productId}`, {
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
                                loadProductContentAndEvent(categoryId, page)
                            });
                }
            })
        }
        // Handle enale for product
        function confirmEnable(productId) {
            Swal.fire({
                title: 'Are you sure you want to restore this product?',
                text: "This product will become visible to customers again.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, restore it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/product/view?type=enable&productId=${productId}`, {
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
                                loadProductContentAndEvent(categoryId, page);
                            });
                }
            })
        }


        // ADD EVENT FOR DISABLE PRODUCT
        document.querySelectorAll(".openDisableProdct").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal")
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-product-id]');
                const productId = buttonItem.getAttribute('data-product-id');
                confirmHide(productId)
            })
        })

        // ADD EVENT FOR ENABLE PRODUCT
        document.querySelectorAll(".openEnableProduct").forEach(element => {
            element.addEventListener("click", (e) => {
                const modal = document.getElementById("modal")
                const clickedElement = e.target;
                const buttonItem = clickedElement.closest('[data-product-id]');
                const productId = buttonItem.getAttribute('data-product-id');
                confirmEnable(productId)
            })
        })

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
                    updatePageUrl(pageClick)
                    loadProductContentAndEvent(categoryId, parseOptionNumber(pageClick, 1))
                }
            });
        })

        // GET CATEGORY SELECT
        const selectElement = document.getElementById("categorySelect");
        // HANDLE UPDATE URL WHEN CATEGORY CHANGE
        function updateCategoryURL(categoryId, page) {
            const url = new URL(window.location);
            if (categoryId <= 0) {
                url.searchParams.delete('categoryId');
            } else {
                url.searchParams.set('categoryId', categoryId);
            }
            if (page <= 1) {
                url.searchParams.delete('page');
            } else {
                url.searchParams.set('page', categoryId);
            }
            history.pushState(null, '', url.toString());
        }
        // ADD EVENT FOR CATEGORY
        selectElement.addEventListener("change", function () {
            const selectedOption = this.options[this.selectedIndex];
            const categoryIdSelectString = selectedOption.getAttribute("data-category-id");
            const categoryIdSelect = parseOptionNumber(categoryIdSelectString, 0)
            if (categoryId !== categoryIdSelect) {
                updateCategoryURL(categoryIdSelect, page)
                loadProductContentAndEvent(categoryIdSelect, 1)
            }
        });
        // DEFINE OR REPLACE EVENT HANDLER
        if (handleCategoryChange !== null) {
            selectElement.removeEventListener("change", handleCategoryChange);
        }

        // DEFINE HANDLER FUNCTION
        handleCategoryChange = function () {
            const selectedOption = this.options[this.selectedIndex];
            const categoryIdSelectString = selectedOption.getAttribute("data-category-id");
            const categoryIdSelect = parseOptionNumber(categoryIdSelectString, 0);
            if (categoryId !== categoryIdSelect) {
                updateCategoryURL(categoryIdSelect, page);
                loadProductContentAndEvent(categoryIdSelect, 1);
            }
        };

        // ADD EVENT LISTENER
        selectElement.addEventListener("change", handleCategoryChange);
        // SHOW SELECTED CATEGORY
        const options = selectElement.options;
        for (let i = 0; i < options.length; i++) {
            if (options[i].dataset.categoryId == categoryId) {
                selectElement.selectedIndex = i;
                break;
            }
    }
    })
    // Hanlde click new product button
    document.getElementById("create-product-button").onclick = () => {
        const modal = document.getElementById("modal")
        openModal(modal);
        updateModalContent(`/product/view?type=create`, () => loadCreateOrUpdateProductEvent(categoryId, page))
    }
}



// HANDLE CHANGE IMAGE IN PRODUCT DETAIL
function changeMainImage(imageUrl) {
    document.getElementById('main-image').src = imageUrl;
}
// HANDLE LOAD EVENT FOR PRODUCT DETAIL
function loadProductDetailEvent() {
    const detailTab = document.getElementById('details-tab')
    if (detailTab) {
        detailTab.addEventListener('click', function () {
            showTab('details');
        });
    }
    const reviewTab = document.getElementById('preview-tab')
    if (reviewTab) {
        reviewTab.addEventListener('click', function () {
            showTab('preview');
        });
    }
}

// LOAD CREATE PRODUCT EVENT
function loadCreateOrUpdateProductEvent(categoryIdURL, pageURL) {
    lucide.createIcons()
    const MAX_FILES = 10;
    const imageInput = document.getElementById("image-files");
    const previewGrid = document.getElementById("image-preview-grid");
    const uploadStatus = document.getElementById("upload-status");
    const uploadError = document.getElementById("upload-error");
    const statusText = document.getElementById("status-text");
    const errorText = document.getElementById("error-text");
    // File[]
    let selectedImages = [];
    // Hanlde select image
    imageInput.onchange = function (event) {
        const files = Array.from(event.target.files);
        let newImages = [];

        // Check duplicate image
        for (const file of files) {
            const isDuplicate = selectedImages.some(img => img.name === file.name && img.size === file.size);
            if (!isDuplicate)
                newImages.push(file);
        }

        selectedImages = [...selectedImages, ...newImages];
        if (selectedImages.length > MAX_FILES) {
            selectedImages = selectedImages.slice(0, 10);
            showStatus("A maximum of 10 images is allowed. Some images have been ignored.");
        } else {
            showStatus(`${selectedImages.length} images selected`);
        }

        updatePreview();
    };

    function updatePreview() {
        previewGrid.innerHTML = "";
        // Render preview image
        selectedImages.forEach((file) => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const wrapper = document.createElement("div");
                wrapper.className = "relative group";

                const img = document.createElement("img");
                img.src = e.target.result;
                img.alt = file.name;
                img.className = "w-full h-32 object-cover rounded-lg shadow";

                const deleteBtn = document.createElement("button");
                deleteBtn.innerHTML = "&times;";
                deleteBtn.className = "absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 text-sm hidden group-hover:flex items-center justify-center";
                deleteBtn.onclick = (e) => {
                    e.preventDefault();
                    selectedImages = selectedImages.filter(f => !(f.name === file.name && f.size === file.size));
                    wrapper.remove();
                    if (selectedImages.length) {
                        showStatus(`${selectedImages.length} images selected`);
                    } else {
                        uploadStatus.classList.add("hidden");
                    }
                };

                wrapper.appendChild(img);
                wrapper.appendChild(deleteBtn);
                previewGrid.appendChild(wrapper);
            };
            reader.readAsDataURL(file);
        });
    }

    function showStatus(message) {
        uploadStatus.classList.remove("hidden");
        statusText.textContent = message;
        hiddenError()
    }

    function showError(message) {
        uploadError.classList.remove("hidden");
        errorText.textContent = message;
    }

    function hiddenError() {
        uploadError.classList.add("hidden");
    }

    new Sortable(previewGrid, {
        animation: 150,
        onEnd: () => {
            const newOrder = [];
            const items = previewGrid.children;
            for (let i = 0; i < items.length; i++) {
                const imgSrc = items[i].querySelector("img").src;
                const matched = selectedImages.find(f => {
                    const reader = new FileReader();
                    return new Promise(resolve => {
                        reader.onload = e => {
                            resolve(e.target.result === imgSrc);
                        };
                        reader.readAsDataURL(f);
                    });
                });
                newOrder.push(matched);
            }
            selectedImages = Array.from(items).map(item => {
                const fileName = item.querySelector("img").alt;
                return selectedImages.find(f => f.name === fileName);
            });
        }
    });

    // Validate function
    function required(value, message = "This field is required") {
        if (!value || value.trim() === "") {
            return message;
        }
        return null;
    }

    function parsePositiveDouble(value, message = "Please enter a valid positive number") {
        const normalized = value.replace(',', '.');
        const number = parseFloat(normalized);
        if (isNaN(number) || number <= 0) {
            return message;
        }
        return null;
    }

    function parsePositiveInteger(value, message = "Please enter a valid positive integer") {
        const number = Number(value);
        if (!Number.isInteger(number) || number <= 0) {
            return message;
        }
        return null;
    }

    function validateRatio(value, message = "Please enter a valid ratio like '1:64' where the first number is smaller") {
        if (!value || value.trim() === "") {
            return message;
        }
        const parts = value.split(':');
        if (parts.length !== 2) {
            return message;
        }
        const [left, right] = parts.map(part => Number(part.trim()));
        if (!Number.isInteger(left) || !Number.isInteger(right) || left <= 0 || right <= 0) {
            return message;
        }
        if (left >= right) {
            return message;
        }
        return null;
    }

    function validateMin(min, message = `Value must be greater than or equal to ${min}`) {
        return function (value) {
            if (value === null || value === undefined || value === '') {
                return message;
            }
            const number = Number(value);
            if (isNaN(number) || number < min) {
                return message;
            }
            return null;
        };
    }



    const configValidate = [
        {
            id: "title",
            validate: [required]
        },
        {
            id: "description",
            validate: [required]
        },
        {
            id: "features",
            validate: [required]
        },
        {
            id: "scale",
            validate: [required, validateRatio]
        },
        {
            id: "material",
            validate: [required]
        },
        {
            id: "paint",
            validate: [required]
        },
        {
            id: "manufacturer",
            validate: [required]
        },
        {
            id: "length",
            validate: [required, parsePositiveDouble]
        },
        {
            id: "width",
            validate: [required, parsePositiveDouble]
        },
        {
            id: "height",
            validate: [required, parsePositiveDouble]
        },
        {
            id: "weight",
            validate: [required, parsePositiveDouble]
        },
        {
            id: "price",
            validate: [required, parsePositiveDouble, validateMin(1000)]
        },
        {
            id: "quantity",
            validate: [required, validateMin(0)]
        }
    ];
    ]
    // Handle config validate for input
    const checkValidate = (config) => {
        const inputElement = document.getElementById(config.id);
        const value = inputElement.value;
        let errorMessage = null;
        for (let i = 0; i < config.validate.length; i++) {
            const error = config.validate[i](value);
            if (error !== null) {
                errorMessage = error;
                break;
            }
        }
        if (errorMessage !== null) {
            const errorElement = document.getElementById(config.id + "Error");
            if (errorElement) {
                errorElement.textContent = errorMessage;
                errorElement.classList.remove("text-red-500", "text-sm");
                errorElement.classList.add("text-red-500", "text-sm");
                inputElement.classList.remove("border-gray-300", "border-red-500", "ring-1", "ring-green-500");
                inputElement.classList.add("border-red-500");
            } else {
                errorElement.textContent = "";
            }
            return true;
        } else {
            inputElement.classList.remove("border-gray-300", "border-red-500", "ring-1", "ring-green-500");
            inputElement.classList.add("ring-1", "ring-green-500");
        }
        return false;
    };

    // Handle focus and blur input
    configValidate.forEach(config => {
        const inputElement = document.getElementById(config.id);
        if (inputElement) {
            inputElement.onfocus = () => {
                const errorElement = document.getElementById(config.id + "Error");
                errorElement.textContent = "";
                inputElement.classList.remove("border-gray-300", "border-red-500", "ring-1", "ring-green-500");
                inputElement.classList.add("ring-1", "ring-green-500");
            };
            inputElement.onblur = () => {
                checkValidate(config);
            };
        }
    });

    const createProductCategoryElm = document.getElementById("create-product-category")
    const createProductBrandElm = document.getElementById("create-product-brand")
    // Validate for category
    createProductCategoryElm.onchange = function () {
        const selectedOption = this.options[this.selectedIndex];
        const categoryId = selectedOption.getAttribute("data-category-id");

        createProductCategoryElm.classList.remove("border-gray-300", "border-red-500", "ring-1", "ring-green-500");
        if (categoryId !== "0") {
            createProductCategoryElm.classList.add("ring-1", "ring-green-500");
        } else {
            createProductCategoryElm.classList.add("border-red-500");
        }
    };
    // Validate for brand
    createProductBrandElm.onchange = function () {
        const selectedOption = this.options[this.selectedIndex];
        const brandId = selectedOption.getAttribute("data-brand-id");
        createProductBrandElm.classList.remove("border-gray-300", "border-red-500", "ring-1", "ring-green-500");
        if (brandId !== "0") {
            createProductBrandElm.classList.add("ring-1", "ring-green-500");
        } else {
            createProductBrandElm.classList.add("border-red-500");
        }
    };

    // Update product
    const updateProductButton = document.getElementById("update-product-btn")
    if (updateProductButton) {
        updateProductButton.onclick = () => {
            let isError = false;
            configValidate.forEach(config => {
                const isErrorValidate = checkValidate(config)
                if (isErrorValidate)
                    isError = isErrorValidate
            })
            // Handle select category and brand
            const selectCategory = document.getElementById("create-product-category");
            const selectedOptionCategory = selectCategory.options[selectCategory.selectedIndex];
            const categoryId = selectedOptionCategory.getAttribute("data-category-id");
            const selectBrand = document.getElementById("create-product-brand");
            const selectedOptionBrand = selectBrand.options[selectBrand.selectedIndex];
            const brandId = selectedOptionBrand.getAttribute("data-brand-id");

            if (categoryId === "0") {
                selectCategory.classList.remove("border-gray-300")
                selectCategory.classList.add("border-red-500")
                isError = true
            } else {
                selectCategory.classList.remove("border-red-500")
                selectCategory.classList.add("border-green-600")
            }
            if (brandId === "0") {
                selectBrand.classList.remove("border-gray-300")
                selectBrand.classList.add("border-red-500")
                isError = true
            } else {
                selectBrand.classList.remove("border-red-500")
                selectBrand.classList.add("border-green-600")
            }
            // Lấy imageId của những ảnh được tick
            const selectedImageIds = []
            document.querySelectorAll("#already-preview-grid input[type='checkbox']:checked").forEach(checkbox => {
                const imageId = checkbox.getAttribute('data-image-id');
                if (imageId) {
                    selectedImageIds.push(imageId);
                }
            })
            console.log(selectedImageIds); // [1, 3, 5] - ví dụ

            if (selectedImageIds.length === 0 && selectedImages.length === 0) {
                showError("Must have at least one image selected")
                isError = true
            }

            // Handle fetch servlet to create product
            if (!isError) {
                // Convert data to object
                const formData = new FormData();

                const isCheckedDestroy = document.getElementById("destroy").checked;
                configValidate.forEach(config => {
                    const value = document.getElementById(config.id).value
                    formData.append(config.id, value);
                })
                const productId = document.getElementById("productIdUpdate").textContent.trim();
                formData.append("productId", productId);
                formData.append("categoryId", categoryId);
                formData.append("brandId", brandId);
                formData.append("destroy", isCheckedDestroy)
                for (var i = 0; i < selectedImageIds.length; i++) {
                    formData.append("urlsId", selectedImageIds[i])
                }

                for (let i = 0; i < selectedImages.length; i++) {
                    formData.append("imageFiles", selectedImages[i]);
                }

                // Fetch to servlet
                showLoading()
                fetch('/product/view?type=update', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log(data);
                            hiddenLoading()
                            closeModal()
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
                            loadProductContentAndEvent(categoryIdURL, pageURL)
                        });
            } else {
                console.log("Can't update product");
            }
        }
    };
            // Lấy imageId của những ảnh được tick
            const selectedImageIds = []
            document.querySelectorAll("#already-preview-grid input[type='checkbox']:checked").forEach(checkbox => {
                const imageId = checkbox.getAttribute('data-image-id');
                if (imageId) {
                    selectedImageIds.push(imageId);
                }
            })

            if (selectedImageIds.length === 0 && selectedImages.length === 0) {
                showError("Must have at least one image selected")
                isError = true
            }

            if (selectedImageIds.length + selectedImages.length > MAX_FILES) {
                showError("A maximum of 10 images is allowed")
                isError = true
            }

            // Handle fetch servlet to create product
            if (!isError) {
                // Convert data to object
                const formData = new FormData();

                const isCheckedDestroy = document.getElementById("destroy").checked;
                configValidate.forEach(config => {
                    const value = document.getElementById(config.id).value
                    formData.append(config.id, value);
                })
                const productId = document.getElementById("productIdUpdate").textContent.trim();
                formData.append("productId", productId);
                formData.append("categoryId", categoryId);
                formData.append("brandId", brandId);
                formData.append("destroy", isCheckedDestroy)
                for (var i = 0; i < selectedImageIds.length; i++) {
                    formData.append("urlsId", selectedImageIds[i])
                }

                for (let i = 0; i < selectedImages.length; i++) {
                    formData.append("imageFiles", selectedImages[i]);
                }

                // Fetch to servlet
                showLoading()
                fetch('/product/view?type=update', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log(data);
                            hiddenLoading()
                            closeModal()
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
                            updateProductStat()
                            loadProductContentAndEvent(categoryIdURL, pageURL)
                        });
            } else {
                console.log("Can't update product");
            }
        }
    }

    // Create new product
    const createProductButton = document.getElementById("create-product-btn")
    console.log(createProductButton);
    if (createProductButton) {
        createProductButton.onclick = () => {
            console.log("create button click");
            let isError = false;
            configValidate.forEach(config => {
                const isErrorValidate = checkValidate(config)
                if (isErrorValidate)
                    isError = isErrorValidate
            })

            // Handle select category and brand
            const selectCategory = document.getElementById("create-product-category");
            const selectedOptionCategory = selectCategory.options[selectCategory.selectedIndex];
            const categoryId = selectedOptionCategory.getAttribute("data-category-id");
            const selectBrand = document.getElementById("create-product-brand");
            const selectedOptionBrand = selectBrand.options[selectBrand.selectedIndex];
            const brandId = selectedOptionBrand.getAttribute("data-brand-id");

            if (categoryId === "0") {
                selectCategory.classList.remove("border-gray-300")
                selectCategory.classList.add("border-red-500")
                isError = true
            } else {
                selectCategory.classList.remove("border-red-500")
                selectCategory.classList.add("border-green-600")
            }
            if (brandId === "0") {
                selectBrand.classList.remove("border-gray-300")
                selectBrand.classList.add("border-red-500")
                isError = true
            } else {
                selectBrand.classList.remove("border-red-500")
                selectBrand.classList.add("border-green-600")
            }

            if (selectedImages.length === 0) {
                showError("Must have at least one image selected")
                isError = true
            }

            // Handle fetch servlet to create product
            if (!isError) {
                // Convert data to object
                const formData = new FormData();

                const isCheckedDestroy = document.getElementById("destroy").checked;
                configValidate.forEach(config => {
                    const value = document.getElementById(config.id).value
                    formData.append(config.id, value);
                })
                formData.append("categoryId", categoryId);
                formData.append("brandId", brandId);
                formData.append("destroy", isCheckedDestroy);

                for (let i = 0; i < selectedImages.length; i++) {
                    formData.append("imageFiles", selectedImages[i]);
                }

                // Fetch to servlet
                showLoading()
                fetch('/product/view?type=create', {
                    method: 'POST',
                    body: formData
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log(data);
                            console.log(data.isSuccess);
                            hiddenLoading()
                            closeModal()
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
                            updateProductStat()
                            loadProductContentAndEvent(categoryIdURL, pageURL)
                        });
            } else {
                console.log("Can't create product");
            }
        }
    }
    // Add opacity for producat
    function toggleImageOpacity(index, isChecked) {
        const image = document.querySelector(`.image-${index}`);
        const icon = document.querySelector(`.checkbox-icon-${index}`);
        if (isChecked) {
            image.classList.remove('opacity-30', 'grayscale');
            icon.classList.remove('opacity-0');
            icon.classList.add('opacity-100');
        } else {
            image.classList.add('opacity-30', 'grayscale');
            icon.classList.remove('opacity-100');
            icon.classList.add('opacity-0');
        }
    }
    // Hanlde checkbox change
    document.getElementById('already-preview-grid').addEventListener('change', function (event) {
        if (event.target.type === 'checkbox' &&
                event.target.hasAttribute('data-index') &&
                event.target.id.startsWith('checkbox-')) {
            const index = event.target.getAttribute('data-index');
            toggleImageOpacity(index, event.target.checked);
        }
    });
    // Handle click or no click with already image
    document.getElementById('already-preview-grid').addEventListener('click', function (event) {
        const group = event.target.closest('.group')
        if (group) {
            const checkbox = group.querySelector('input[type="checkbox"]');
            if (checkbox && event.target !== checkbox) {
                checkbox.checked = !checkbox.checked;
                const index = checkbox.getAttribute('data-index');
                toggleImageOpacity(index, checkbox.checked);
            }
        }

    });
    // Init all checkbox is ticked
    const checkboxes = document.querySelectorAll('[data-index]');
    checkboxes.forEach((checkbox) => {
        const index = checkbox.getAttribute('data-index');
        const icon = document.querySelector(`.checkbox-icon-${index}`);
        if (checkbox.checked) {
            icon.classList.add('opacity-100');
        }
    });
}



const updateProductStat = () => {
    const totalProductELm = document.getElementById("totalProduct")
    const totalInventoryELm = document.getElementById("totalInventory")
    const inventoryValueELm = document.getElementById("inventoryValue")
    const outOfStockELm = document.getElementById("outOfStock")

    function formatCurrencyShort(amount) {
        if (amount >= 1000000000) {
            return (amount / 1000000000).toFixed(2) + "B";
        } else if (amount >= 1000000) {
            return (amount / 1000000).toFixed(2) + "M";
        } else if (amount >= 1000) {
            return (amount / 1000).toFixed(2) + "K";
        } else {
            return Math.floor(amount).toString();
        }
    }


    fetch('/product/view?type=stat', {
        method: 'GET'
    })
            .then(response => response.json())
            .then(data => {
                totalProductELm.textContent = data.data.totalProducts + ""
                totalInventoryELm.textContent = data.data.inventory + ""
                inventoryValueELm.textContent = formatCurrencyShort(data.data.inventoryValue)
                outOfStockELm.textContent = data.data.outOfStockProducts + ""
            });
}

// HANDLE SHOW SELECT TAB
function showTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.add('hidden');
    });
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active', 'text-gray-500', "border-transparent", "hover:text-blue-600", "hover:border-blue-300", "transition-all", "duration-200");
        button.classList.add('text-gray-500', "border-transparent", "hover:text-blue-600", "hover:border-blue-300", "transition-all", "duration-200");
    });
    document.getElementById(tabName + '-content').classList.remove('hidden');
    document.getElementById(tabName + '-tab').classList.add('active');
}