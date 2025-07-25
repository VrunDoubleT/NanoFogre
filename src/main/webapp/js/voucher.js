// Handle with max value when voucher types changed
function handleTypeChange(typeInput, maxValueInput, maxValueError, status, isUsed) {
    const t = typeInput.value;
    const limited = (status === "Ongoing" || status === "Expired") && isUsed;
    if (t === "FIXED") {
        maxValueInput.disabled = true;
        maxValueInput.value = "";
        maxValueInput.classList.add("bg-gray-100", "cursor-not-allowed");
        maxValueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
        maxValueError.textContent = "";
    } else if (limited) {
        maxValueInput.disabled = true;
        maxValueInput.classList.add("bg-gray-100", "cursor-not-allowed");
        maxValueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
        maxValueError.textContent = "";
    } else if (t === "PERCENTAGE") {
        maxValueInput.disabled = false;
        maxValueInput.classList.remove("bg-gray-100", "cursor-not-allowed");
    }
}

// Validate voucher code
async function validateCode(codeInput, codeError) {
    const code = codeInput.value.trim();
    if (code === "") {
        codeError.textContent = "Voucher code is required.";
        codeInput.classList.add("border-red-500");
        return false;
    }
    if (code.length > 20) {
        codeError.textContent = "Voucher code must not exceed 20 characters.";
        codeInput.classList.add("border-red-500");
        return false;
    }
    if (/\s/.test(code)) {
        codeError.textContent = "Voucher code must not contain spaces.";
        codeInput.classList.add("border-red-500");
        return false;
    }
    try {
        const res = await fetch(`/voucher/view?type=checkVoucherCode&voucherCode=${code}`);
        const exists = await res.text();
        if (exists === "true") {
            codeError.textContent = "Voucher code already exists";
            codeInput.classList.add("border-red-500");
            return false;
        }
    } catch (e) {
        codeError.textContent = "Error checking code";
        codeInput.classList.add("border-red-500");
        return false;
    }
    codeError.textContent = "";
    codeInput.classList.remove("border-red-500");
    codeInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate discount value
function validateValue(valueInput, valueError, voucherType) {
    const rawValue = valueInput.value.trim();
    if (rawValue === "") {
        valueError.textContent = "Discount value is required.";
        valueInput.classList.add("border-red-500");
        return false;
    }
    const value = parseFloat(rawValue);
    if (isNaN(value) || value <= 0) {
        valueError.textContent = "Discount value must be greater than 0.";
        valueInput.classList.add("border-red-500");
        return false;
    }
    if (voucherType === "PERCENTAGE" && value > 100) {
        valueError.textContent = "Percentage cannot exceed 100%.";
        valueInput.classList.add("border-red-500");
        return false;
    }
    if (voucherType === "FIXED" && value < 1000) {
        valueError.textContent = "Value must be greater than 1000.";
        valueInput.classList.add("border-red-500");
        return false;
    }
    valueError.textContent = "";
    valueInput.classList.remove("border-red-500");
    valueInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate description
function validateDescription(descriptionInput, descriptionError) {
    const desc = descriptionInput.value.trim();
    if (desc === "") {
        descriptionError.textContent = "Description is required.";
        descriptionInput.classList.add("border-red-500");
        return false;
    }
    if (desc.length > 100) {
        descriptionError.textContent = "Description must not exceed 100 characters.";
        descriptionInput.classList.add("border-red-500");
        return false;
    }
    descriptionError.textContent = "";
    descriptionInput.classList.remove("border-red-500");
    descriptionInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate min order value
function validateMinValue(minValueInput, minValueError) {
    const rawMin = minValueInput.value.trim();
    const value = parseFloat(rawMin);
    if (rawMin === "") {
        minValueError.textContent = "Minimum order value is required.";
        minValueInput.classList.add("border-red-500");
        return false;
    }
    if (isNaN(value) || (value < 1000 && value != 0)) {
        minValueError.textContent = "Minimum order value must be 0 or greater than 1000.";
        minValueInput.classList.add("border-red-500");
        return false;
    }
    minValueError.textContent = "";
    minValueInput.classList.remove("border-red-500");
    minValueInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate max discount amount
function validateMaxValue(type, maxValueInput, maxValueError) {
    if (type === "FIXED")
        return true;
    const rawMax = maxValueInput.value.trim();
    const value = parseFloat(rawMax);
    if (rawMax === "") {
        maxValueError.textContent = "Maximum discount amount is required.";
        maxValueInput.classList.add("border-red-500");
        return false;
    }
    if (isNaN(value) || value < 1000) {
        maxValueError.textContent = "Maximum discount must be greater than 1000.";
        maxValueInput.classList.add("border-red-500");
        return false;
    }
    maxValueError.textContent = "";
    maxValueInput.classList.remove("border-red-500");
    maxValueInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate start date
function validateFromDate(validFromInput, validFromError) {
    const from = validFromInput.value;
    const now = new Date().toISOString().split("T")[0];
    if (!from) {
        validFromError.textContent = "Start date is required.";
        validFromInput.classList.add("border-red-500");
        return false;
    }
    if (from < now) {
        validFromError.textContent = "Start date must be in the future.";
        validFromInput.classList.add("border-red-500");
        validFromInput.classList.remove("ring-1", "ring-green-500");
        return false;
    }
    validFromError.textContent = "";
    validFromInput.classList.remove("border-red-500");
    validFromInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate end date
function validateToDate(validFromInput, validToInput, validToError) {
    const from = validFromInput.value;
    const to = validToInput.value;
    const now = new Date().toISOString().split("T")[0];
    if (!to) {
        validToError.textContent = "End date is required.";
        validToInput.classList.add("border-red-500");
        return false;
    }
    if (from && to < from) {
        validToError.textContent = "End date must be after start date.";
        validToInput.classList.add("border-red-500");
        return false;
    }
    if (to <= now) {
        validToError.textContent = "End date must be in the future.";
        validToInput.classList.add("border-red-500");
        return false;
    }
    validToError.textContent = "";
    validToInput.classList.remove("border-red-500");
    validToInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate total usage limit
function validateTotalLimit(validTotalInput, validTotalError) {
    const raw = validTotalInput.value.trim();
    if (raw === "") {
        validTotalError.textContent = "";
        validTotalInput.classList.remove("border-red-500");
        validTotalInput.classList.add("ring-1", "ring-yellow-500");
        return true;
    }
    const total = parseInt(raw);
    if (Number.isNaN(total)) {
        validTotalError.textContent = "Total Usage Limit must be a number.";
        validTotalInput.classList.add("border-red-500");
        return false;
    }
    if (total <= 0) {
        validTotalError.textContent = "Total Usage Limit must be greater than 0.";
        validTotalInput.classList.add("border-red-500");
        return false;
    }
    validTotalError.textContent = "";
    validTotalInput.classList.remove("border-red-500");
    validTotalInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate user usage limit
function validateUserLimit(validTotalInput, validUserInput, validUserError) {
    const raw = validUserInput.value.trim();
    if (raw === "") {
        validUserError.textContent = "";
        validUserInput.classList.remove("border-red-500");
        validUserInput.classList.add("ring-1", "ring-yellow-500");
        return true;
    }
    const user = parseInt(raw);
    const total = parseInt(validTotalInput.value.trim());
    if (Number.isNaN(user)) {
        validUserError.textContent = "User Usage Limit must be a number.";
        validUserInput.classList.add("border-red-500");
        return false;
    }
    if (user <= 0) {
        validUserError.textContent = "User Usage Limit must be greater than 0.";
        validUserInput.classList.add("border-red-500");
        return false;
    }
    if (!Number.isNaN(total) && user > total) {
        validUserError.textContent = "User Usage Limit cannot be greater than Total Usage Limit.";
        validUserInput.classList.add("border-red-500");
        return false;
    }
    validUserError.textContent = "";
    validUserInput.classList.remove("border-red-500");
    validUserInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Handle with Categories
function handleAddCategory(initialCategories = []) {
    const categoryInput = document.getElementById("category");
    const selectedWrapper = document.getElementById("selectedCategories");
    const hiddenInputsWrapper = document.getElementById("selectedCategoryInputs");
    const categoryError = document.getElementById("categoryError");
    const selectedCategories = new Set();

    // Render available categories (for update)
    initialCategories.forEach(({ id, name }) => {
        if (!selectedCategories.has(id)) {
            selectedCategories.add(id);
            addCategoryTag(id, name);
    }
    });

    // Select categories from select box
    categoryInput.addEventListener("change", function () {
        const selectedId = this.value;
        const selectedText = this.options[this.selectedIndex].text;
        // Select all categories
        if (selectedId === "all") {
            for (let option of this.options) {
                const id = option.value;
                const name = option.text;
                if (!id || id === "0" || id === "all" || selectedCategories.has(id))
                    continue;
                selectedCategories.add(id);
                addCategoryTag(id, name);
            }
            this.value = "";
            return;
        }
        // Select each category
        if (!selectedId || selectedId === "0" || selectedCategories.has(selectedId))
            return;

        selectedCategories.add(selectedId);
        addCategoryTag(selectedId, selectedText);
        this.value = "";
    });

    // Create category tags and hidden input
    function addCategoryTag(id, name) {
        if (hiddenInputsWrapper.querySelector(`input[data-id="${id}"]`))
            return;
        // Tag
        const tag = document.createElement("div");
        tag.className = "flex items-center gap-1 px-3 py-1 bg-blue-100 text-blue-800 rounded text-sm";
        tag.dataset.id = id;
        tag.innerHTML = `
            <span>${name}</span>
            <button type="button" class="text-blue-500 remove-category" title="Remove">&times;</button>
        `;
        selectedWrapper.appendChild(tag);

        // Hidden input
        const hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "categoryIds";
        hidden.value = id;
        hidden.dataset.id = id;
        hiddenInputsWrapper.appendChild(hidden);
    }

    // Delete button on category tags
    selectedWrapper.addEventListener("click", function (e) {
        if (e.target.classList.contains("remove-category")) {
            const tag = e.target.closest("div[data-id]");
            const id = tag.dataset.id;
            selectedCategories.delete(id);
            tag.remove();
            hiddenInputsWrapper.querySelector(`input[data-id="${id}"]`)?.remove();

            if (selectedCategories.size === 0) {
                categoryError.textContent = "Please select at least one category.";
                categoryInput.classList.remove("ring-1", "ring-green-500");
                categoryInput.classList.add("border-red-500");
            }
        }
    });

    // Return validate function for submit
    return function validateCategorySelection() {
        if (selectedCategories.size === 0) {
            categoryError.textContent = "Please select at least one category.";
            categoryInput.classList.add("border-red-500");
            return false;
        } else {
            categoryError.textContent = "";
            categoryInput.classList.remove("border-red-500");
            categoryInput.classList.add("ring-1", "ring-green-500");
            return true;
        }
    };
}

// Voucher list
const loadVoucherContentAndEvent = (page, categoryIdOfVoucher) => {
    lucide.createIcons();
    const tableContainer = document.getElementById('tabelContainer');
    const paginationContainer = document.getElementById('pagination');
    const loadingContainer = document.getElementById('loadingVoucher');

    tableContainer.innerHTML = '';
    loadingContainer.innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;

    const url = new URL(window.location);
    url.searchParams.set("view", "voucher");
    url.searchParams.set("page", page);
    if (categoryIdOfVoucher) {
        url.searchParams.set("categoryId", categoryIdOfVoucher);
    } else {
        url.searchParams.delete("categoryId");
    }
    document.getElementById("category-filter").value = categoryIdOfVoucher;
    history.pushState(null, '', url.toString());

    Promise.all([
        fetch(`/voucher/view?type=list&page=${page}&categoryId=${categoryIdOfVoucher}`).then(res => res.text()),
        fetch(`/voucher/view?type=pagination&page=${page}&categoryId=${categoryIdOfVoucher}`).then(res => res.text())
    ]).then(([voucherHTML, paginationHTML]) => {
        tableContainer.innerHTML = voucherHTML;
        paginationContainer.innerHTML = paginationHTML;
        loadingContainer.innerHTML = '';

        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    loadVoucherContentAndEvent(parseOptionNumber(pageClick, 1), categoryIdOfVoucher);
                }
            });
        });
    });

    document.getElementById("create-voucher-button").onclick = () => {
        const modal = document.getElementById("modal");
        openModal(modal);
        updateModalContent(`/voucher/view?type=create`, loadCreateVoucherEvent);
    };
};

// Add Voucher
async function loadCreateVoucherEvent() {
    lucide.createIcons();
    const codeInput = document.getElementById("code");
    const typeInput = document.getElementById("voucherType");
    const valueInput = document.getElementById("value");
    const totalLimitInput = document.getElementById("totalUsageLimit");
    const userLimitInput = document.getElementById("userUsageLimit");
    const descriptionInput = document.getElementById("description");
    const minValueInput = document.getElementById("minValue");
    const maxValueInput = document.getElementById("maxValue");
    const validFromInput = document.getElementById("validFrom");
    const validToInput = document.getElementById("validTo");
    const blockCheckbox = document.getElementById("block");
    const categoryInput = document.getElementById("category");

    const codeError = document.getElementById("voucherCodeError");
    const valueError = document.getElementById("valueError");
    const totalLimitError = document.getElementById("totalUsageLimitError");
    const userLimitError = document.getElementById("userUsageLimitError");
    const descriptionError = document.getElementById("descriptionError");
    const minValueError = document.getElementById("minValueError");
    const maxValueError = document.getElementById("maxValueError");
    const validFromError = document.getElementById("validFromError");
    const validToError = document.getElementById("validToError");
    const categoryError = document.getElementById("categoryError");
    const validateCategorySelection = handleAddCategory();

    typeInput.onchange = () => {
        handleTypeChange(typeInput, maxValueInput, maxValueError);
        if (valueInput.value.trim() !== "") {
            valueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
            valueError.textContent = "";
            const isValid = validateValue(valueInput, valueError, typeInput.value);
            if (!isValid) {
                valueInput.value = "";
            }
        }
    };
    codeInput.onblur = () => validateCode(codeInput, codeError);
    valueInput.onblur = () => validateValue(valueInput, valueError, typeInput.value);
    descriptionInput.onblur = () => validateDescription(descriptionInput, descriptionError);
    totalLimitInput.onblur = () => validateTotalLimit(totalLimitInput, totalLimitError);
    userLimitInput.onblur = () => validateUserLimit(totalLimitInput, userLimitInput, userLimitError);
    minValueInput.onblur = () => validateMinValue(minValueInput, minValueError);
    maxValueInput.onblur = () => validateMaxValue(typeInput.value, maxValueInput, maxValueError);
    validFromInput.onblur = () => validateFromDate(validFromInput, validFromError);
    validToInput.onblur = () => validateToDate(validFromInput, validToInput, validToError);
    categoryInput.onblur = () => validateCategorySelection();
    [codeInput, valueInput, descriptionInput, totalLimitInput, userLimitInput, minValueInput, maxValueInput, validFromInput, validToInput, categoryInput].forEach(input => {
        input.oninput = () => {
            input.classList.remove("border-red-500", "ring-1", "ring-green-500");
            if (input === codeInput)
                codeError.textContent = "";
            if (input === valueInput)
                valueError.textContent = "";
            if (input === descriptionInput)
                descriptionError.textContent = "";
            if (input === totalLimitInput)
                totalLimitError.textContent = "";
            if (input === userLimitInput)
                userLimitError.textContent = "";
            if (input === minValueInput)
                minValueError.textContent = "";
            if (input === maxValueInput)
                maxValueError.textContent = "";
            if (input === validFromInput)
                validFromError.textContent = "";
            if (input === validToInput)
                validToError.textContent = "";
            if (input === categoryInput)
                categoryError.textContent = "";
        };
    });

    document.getElementById("create-voucher-btn").onclick = async () => {
        const validCode = await validateCode(codeInput, codeError);
        const validVal = validateValue(valueInput, valueError, typeInput.value);
        const validDesc = validateDescription(descriptionInput, descriptionError);
        const validTotalLimit = validateTotalLimit(totalLimitInput, totalLimitError);
        const validUserLimit = validateUserLimit(totalLimitInput, userLimitInput, userLimitError);
        const validMinVal = validateMinValue(minValueInput, minValueError);
        const validMaxVal = validateMaxValue(typeInput.value, maxValueInput, maxValueError);
        const validFDate = validateFromDate(validFromInput, validFromError);
        const validTDate = validateToDate(validFromInput, validToInput, validToError);
        const validCategory = validateCategorySelection();
        if (!validCode || !validVal || !validDesc || !validTotalLimit || !validUserLimit || !validMinVal || !validMaxVal || !validFDate || !validTDate || !validCategory)
            return;
        const formData = new URLSearchParams();
        formData.append("type", "create");
        formData.append("code", codeInput.value.trim());
        formData.append("voucherType", typeInput.value);
        formData.append("value", valueInput.value.trim());
        formData.append("description", descriptionInput.value.trim());
        formData.append("totalUsageLimit", totalLimitInput.value.trim());
        formData.append("userUsageLimit", userLimitInput.value.trim());
        formData.append("minValue", minValueInput.value.trim());
        if (typeInput.value === "PERCENTAGE") {
            formData.append("maxValue", maxValueInput.value.trim());
        }
        formData.append("validFrom", validFromInput.value);
        formData.append("validTo", validToInput.value);
        if (!blockCheckbox.checked) {
            formData.append("active", "on");
        }
        document.querySelectorAll('input[name="categoryIds"]').forEach(input => {
            formData.append("categoryIds", input.value);
        });

        showLoading();
        fetch("/voucher/view?type=create", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString()
        })
                .then(res => res.text())
                .then(() => {
                    hiddenLoading();
                    closeModal();
                    Toastify({
                        text: "Voucher created successfully!",
                        duration: 5000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#22c55e"},
                        close: true
                    }).showToast();
                    loadVoucherContentAndEvent(1, 0);
                })
                .catch(() => {
                    hiddenLoading();
                    Toastify({
                        text: "Failed to create voucher.",
                        duration: 5000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#ef4444"},
                        close: true
                    }).showToast();
                });
    };
    handleTypeChange(typeInput, maxValueInput, maxValueError, "Upcoming", false);
}

// Delete voucher
document.addEventListener("click", function (e) {
    const deleteBtn = e.target.closest(".delete-voucher-button");
    if (deleteBtn) {
        const id = deleteBtn.dataset.id;
        Swal.fire({
            title: 'Are you sure you want to delete this voucher?',
            text: "This voucher will be removed permanently from the system.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, delete it',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/voucher/view?type=delete`, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `type=delete&id=${id}`
                })
                        .then(response => {
                            const isSuccess = response.ok;
                            Toastify({
                                text: isSuccess ? "Voucher deleted successfully!" : "Delete failed.",
                                duration: 5000,
                                gravity: "top",
                                position: "right",
                                style: {
                                    background: isSuccess ? "#2196F3" : "#f44336"
                                },
                                close: true
                            }).showToast();
                            if (isSuccess) {
                                const currentPage = getCurrentPageFromURL();
                                const rowCount = document.querySelectorAll("tbody tr").length;
                                const newPage = (rowCount === 1 && currentPage > 1) ? currentPage - 1 : currentPage;
                                const url = new URL(window.location);
                                url.searchParams.set("page", newPage);
                                history.pushState(null, '', url.toString());
                                loadVoucherContentAndEvent(newPage, 0);
                            }
                        })
                        .catch(() => {
                            Toastify({
                                text: "An error occurred while deleting.",
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
});

// Update voucher
document.addEventListener("click", async function (e) {
    const updateBtn = e.target.closest(".update-voucher-button");
    if (!updateBtn)
        return;

    const id = updateBtn.dataset.id;
    const response = await fetch(`/voucher/view?type=update&id=${id}`);
    const html = await response.text();
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");
    modalContent.innerHTML = html;

    const form = modalContent.querySelector("form");
    const codeInput = document.getElementById("code");
    const typeInput = document.getElementById("voucherType");
    const valueInput = document.getElementById("value");
    const totalLimitInput = document.getElementById("totalUsageLimit");
    const userLimitInput = document.getElementById("userUsageLimit");
    const descriptionInput = document.getElementById("description");
    const minValueInput = document.getElementById("minValue");
    const maxValueInput = document.getElementById("maxValue");
    const validFromInput = document.getElementById("validFrom");
    const validToInput = document.getElementById("validTo");
    const blockCheckbox = document.getElementById("block");
    const categoryInput = document.getElementById("category");
    const selectedWrapper = document.getElementById("selectedCategories");
    const hiddenInputsWrapper = document.getElementById("selectedCategoryInputs");

    const codeError = document.getElementById("voucherCodeError");
    const valueError = document.getElementById("valueError");
    const totalLimitError = document.getElementById("totalUsageLimitError");
    const userLimitError = document.getElementById("userUsageLimitError");
    const descriptionError = document.getElementById("descriptionError");
    const minValueError = document.getElementById("minValueError");
    const maxValueError = document.getElementById("maxValueError");
    const validFromError = document.getElementById("validFromError");
    const validToError = document.getElementById("validToError");
    const categoryError = document.getElementById("categoryError");

    const existingInputs = hiddenInputsWrapper.querySelectorAll("input[name='categoryIds']");
    const existingCategories = Array.from(existingInputs).map(input => ({
            id: input.value,
            name: input.dataset.name
        }));

    const validateUpdateCategory = handleAddCategory(existingCategories);

    // Validate voucher code for update
    async function validateCode() {
        const code = codeInput.value.trim();
        if (code === "") {
            codeError.textContent = "Voucher code is required.";
            codeInput.classList.add("border-red-500");
            return false;
        }
        if (code.length > 20) {
            codeError.textContent = "Voucher code must not exceed 20 characters.";
            codeInput.classList.add("border-red-500");
            return false;
        }
        try {
            const res = await fetch(`/voucher/view?type=checkVoucherCodeExceptOwn&voucherCode=${code}&id=${id}`);
            const exists = await res.text();
            if (exists === "true") {
                codeError.textContent = "Voucher code already exists";
                codeInput.classList.add("border-red-500");
                return false;
            }
        } catch (e) {
            codeError.textContent = "Error checking code";
            codeInput.classList.add("border-red-500");
            return false;
        }
        codeError.textContent = "";
        codeInput.classList.remove("border-red-500");
        codeInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate total usage limit for update
    async function validateTotalLimit() {
        const totalRaw = totalLimitInput.value;
        if (totalRaw === "") {
            totalLimitError.textContent = "";
            totalLimitInput.classList.remove("border-red-500");
            totalLimitInput.classList.add("ring-1", "ring-yellow-500");
            return true;
        }
        const total = parseInt(totalRaw);
        if (Number.isNaN(total)) {
            totalLimitError.textContent = "Total Usage Limit must be a number.";
            totalLimitInput.classList.add("border-red-500");
            return false;
        }
        if (total <= 0) {
            totalLimitError.textContent = "Total Usage Limit must be greater than 0.";
            totalLimitInput.classList.add("border-red-500");
            return false;
        }
        try {
            const res = await fetch(`/voucher/view?type=checkTotalLimit&totalUsageLimit=${encodeURIComponent(total)}&id=${id}`);
            const t = await res.text();
            if (t === "false") {
                totalLimitError.textContent = "Total usage limit must be greater than or equal to the total used.";
                totalLimitInput.classList.add("border-red-500");
                return false;
            }
        } catch (e) {
            totalLimitError.textContent = "Error checking total limit";
            totalLimitInput.classList.add("border-red-500");
            return false;
        }
        totalLimitError.textContent = "";
        totalLimitInput.classList.remove("border-red-500");
        totalLimitInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate user usage limit for update
    async function validateUserLimit() {
        const userRaw = userLimitInput.value;
        if (userRaw === "") {
            userLimitError.textContent = "";
            userLimitInput.classList.remove("border-red-500");
            userLimitInput.classList.add("ring-1", "ring-yellow-500");
            return true;
        }
        const user = parseInt(userRaw);
        const total = parseInt(totalLimitInput.value);
        if (Number.isNaN(user)) {
            userLimitError.textContent = "User Usage Limit must be a number.";
            userLimitInput.classList.add("border-red-500");
            return false;
        }
        if (user <= 0) {
            userLimitError.textContent = "User Usage Limit must be greater than 0.";
            userLimitInput.classList.add("border-red-500");
            return false;
        }
        if (!Number.isNaN(total) && user > total) {
            userLimitError.textContent = "User Usage Limit cannot be greater than Total Usage Limit.";
            userLimitInput.classList.add("border-red-500");
            return false;
        }
        try {
            const res = await fetch(`/voucher/view?type=checkUserLimit&userUsageLimit=${encodeURIComponent(user)}&id=${id}`);
            const u = await res.text();
            if (u === "false") {
                userLimitError.textContent = "....";
                userLimitInput.classList.add("border-red-500");
                return false;
            }
        } catch (e) {
            userLimitError.textContent = "Error checking user limit";
            userLimitInput.classList.add("border-red-500");
            return false;
        }
        userLimitError.textContent = "";
        userLimitInput.classList.remove("border-red-500");
        userLimitInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Lock input for status = "Ongoing" or "Expired" if voucher is used
    const status = document.getElementById("voucherStatus").value;
    const isUsed = document.getElementById("voucherIsUsed").value === "true";

    const editableInputs = [
        codeInput, typeInput, valueInput, totalLimitInput,
        userLimitInput, descriptionInput, minValueInput,
        maxValueInput, categoryInput, validFromInput
    ];

    // Reset
    editableInputs.forEach(input => {
        input.disabled = false;
        input.classList.remove("bg-gray-100", "cursor-not-allowed");
    });

    // Lock 
    const limited = (status === "Ongoing" || status === "Expired") && isUsed;
    if (limited) {
        editableInputs.forEach(input => {
            input.disabled = true;
            input.classList.add("bg-gray-100", "cursor-not-allowed");
        });
        handleTypeChange(typeInput, maxValueInput, maxValueError, status, isUsed);
    }

    lucide.createIcons();
    modal.classList.remove("hidden");
    modal.classList.add("flex");
    document.body.classList.add("overflow-hidden");

    typeInput.onchange = () => {
        handleTypeChange(typeInput, maxValueInput, maxValueError, status, isUsed);
        if (valueInput.value.trim() !== "") {
            valueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
            valueError.textContent = "";
            const isValid = validateValue(valueInput, valueError, typeInput.value);
            if (!isValid)
                valueInput.value = "";
        }
    };

    handleTypeChange(typeInput, maxValueInput, maxValueError, status, isUsed);
    codeInput.onblur = validateCode;
    valueInput.onblur = () => validateValue(valueInput, valueError, typeInput.value);
    descriptionInput.onblur = () => validateDescription(descriptionInput, descriptionError);
    totalLimitInput.onblur = validateTotalLimit;
    userLimitInput.onblur = validateUserLimit;
    minValueInput.onblur = () => validateMinValue(minValueInput, minValueError);
    maxValueInput.onblur = () => validateMaxValue(typeInput.value, maxValueInput, maxValueError);
    validFromInput.onblur = () => validateFromDate(validFromInput, validFromError);
    validToInput.onblur = () => validateToDate(validFromInput, validToInput, validToError);
    categoryInput.onblur = () => validateUpdateCategory();

    [codeInput, valueInput, descriptionInput, totalLimitInput, userLimitInput, minValueInput, maxValueInput, validFromInput, validToInput, categoryInput]
            .forEach(input => {
                input.oninput = () => {
                    input.classList.remove("border-red-500", "ring-1", "ring-green-500");
                    const errorMap = {
                        [codeInput]: codeError,
                        [valueInput]: valueError,
                        [descriptionInput]: descriptionError,
                        [totalLimitInput]: totalLimitError,
                        [userLimitInput]: userLimitError,
                        [minValueInput]: minValueError,
                        [maxValueInput]: maxValueError,
                        [validFromInput]: validFromError,
                        [validToInput]: validToError,
                        [categoryInput]: categoryError
                    };
                    errorMap[input].textContent = "";
                };
            });

    form.addEventListener("submit", async function (event) {
        event.preventDefault();

        if (!codeInput.disabled) {
            const validCode = await validateCode();
            if (!validCode)
                return;
        }
        if (!totalLimitInput.disabled) {
            const validTotalLimit = await validateTotalLimit();
            if (!validTotalLimit)
                return;
        }
        if (!userLimitInput.disabled) {
            const validUserLimit = await validateUserLimit();
            if (!validUserLimit)
                return;
        }
        if (!valueInput.disabled) {
            const validVal = validateValue(valueInput, valueError, typeInput.value);
            if (!validVal)
                return;
        }
        if (!descriptionInput.disabled) {
            const validDesc = validateDescription(descriptionInput, descriptionError);
            if (!validDesc)
                return;
        }
        if (!minValueInput.disabled) {
            const validMinVal = validateMinValue(minValueInput, minValueError);
            if (!validMinVal)
                return;
        }
        if (!maxValueInput.disabled) {
            const validMaxVal = validateMaxValue(typeInput.value, maxValueInput, maxValueError);
            if (!validMaxVal)
                return;
        }
        if (!validFromInput.disabled) {
            const validFDate = validateFromDate(validFromInput, validFromError);
            if (!validFDate)
                return;
        }
        if (!validToInput.disabled) {
            const validTDate = validateToDate(validFromInput, validToInput, validToError);
            if (!validTDate)
                return;
        }
        if (!categoryInput.disabled) {
            const isValid = validateUpdateCategory();
            if (!isValid)
                return;
        }
        form.querySelectorAll("input, select, textarea").forEach(input => {
            input.removeAttribute("disabled");
        });
        const formData = new FormData(form);
        const voucherType = formData.get("voucherType");

        const payload = {
            id: id,
            code: formData.get("code"),
            voucherType,
            value: formData.get("value"),
            description: formData.get("description"),
            totalUsageLimit: formData.get("totalUsageLimit"),
            userUsageLimit: formData.get("userUsageLimit"),
            minValue: formData.get("minValue"),
            validFrom: formData.get("validFrom"),
            validTo: formData.get("validTo"),
            isActive: formData.get("status"),
            categoryIds: formData.getAll("categoryIds")

        };

        if (voucherType === "PERCENTAGE") {
            payload.maxValue = formData.get("maxValue");
        }

        try {
            const res = await fetch("/voucher/view?type=update", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(payload)
            });

            if (res.ok) {
                Toastify({
                    text: "Voucher updated successfully!",
                    duration: 5000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#2196F3"},
                    close: true
                }).showToast();
                closeModal();
                const currentPage = getCurrentPageFromURL();
                loadVoucherContentAndEvent(currentPage, 0);
            } else {
                Toastify({
                    text: "Update failed.",
                    duration: 5000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#f44336"},
                    close: true
                }).showToast();
            }
        } catch (err) {
            Toastify({
                text: "An error occurred while updating.",
                duration: 5000,
                gravity: "top",
                position: "right",
                style: {background: "#f44336"},
                close: true
            }).showToast();
        }
    });
});

// Voucher details
document.addEventListener("click", async function (e) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const detailBtn = e.target.closest(".detail-voucher-button");
    if (detailBtn) {
        const id = detailBtn.dataset.id;
        const response = await fetch(`/voucher/view?type=detail&id=${id}`);
        const html = await response.text();

        modalContent.innerHTML = html;
        lucide.createIcons();
        modal.classList.remove("hidden");
        modal.classList.add("flex");
        document.body.classList.add("overflow-hidden");
    }
});


