// Handle with voucher types changed
function handleTypeChange(typeInput, maxValueInput, maxValueError) {
    const t = typeInput.value;
    if (t === "FIXED") {
        maxValueInput.disabled = true;
        maxValueInput.value = "";
        maxValueInput.classList.add("bg-gray-100", "cursor-not-allowed");
        maxValueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
        maxValueError.textContent = "";
    } else {
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
    try {
        const res = await fetch(`/voucher/view?type=checkVoucherCode&voucherCode=${encodeURIComponent(code)}`);
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
        maxValueError.textContent = "Maximum discount must be greater than 0.";
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
    if (!from) {
        validFromError.textContent = "Start date is required.";
        validFromInput.classList.add("border-red-500");
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
    if (!to) {
        validToError.textContent = "End date is required.";
        validToInput.classList.add("border-red-500");
        return false;
    }
    if (from && to && from > to) {
        validToError.textContent = "End date must be after start date.";
        validToInput.classList.add("border-red-500");
        return false;
    }
    validToError.textContent = "";
    validToInput.classList.remove("border-red-500");
    validToInput.classList.add("ring-1", "ring-green-500");
    return true;
}

// Voucher list
const loadVoucherContentAndEvent = (page) => {
    lucide.createIcons();
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingVoucher').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    Promise.all([
        fetch("/voucher/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/voucher/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([voucherHTML, paginationHTML]) => {
        document.getElementById('tabelContainer').innerHTML = voucherHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingVoucher').innerHTML = '';
        function updatePageUrl(page) {
            const url = new URL(window.location);
            url.searchParams.delete('page');
            url.searchParams.set('page', page);
            history.pushState(null, '', url.toString());
        }

        document.querySelectorAll("div.pagination").forEach(element => {
            element.addEventListener("click", function () {
                const pageClick = this.getAttribute("page");
                if (page !== parseOptionNumber(pageClick, 1)) {
                    updatePageUrl(pageClick);
                    loadVoucherContentAndEvent(parseOptionNumber(pageClick, 1));
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
    const descriptionInput = document.getElementById("description");
    const minValueInput = document.getElementById("minValue");
    const maxValueInput = document.getElementById("maxValue");
    const validFromInput = document.getElementById("validFrom");
    const validToInput = document.getElementById("validTo");
    const blockCheckbox = document.getElementById("block");
    const codeError = document.getElementById("voucherCodeError");
    const valueError = document.getElementById("valueError");
    const descriptionError = document.getElementById("descriptionError");
    const minValueError = document.getElementById("minValueError");
    const maxValueError = document.getElementById("maxValueError");
    const validFromError = document.getElementById("validFromError");
    const validToError = document.getElementById("validToError");

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
    minValueInput.onblur = () => validateMinValue(minValueInput, minValueError);
    maxValueInput.onblur = () => validateMaxValue(typeInput.value, maxValueInput, maxValueError);
    validFromInput.onblur = () => validateFromDate(validFromInput, validFromError);
    validToInput.onblur = () => validateToDate(validFromInput, validToInput, validToError);
    [codeInput, valueInput, descriptionInput, minValueInput, maxValueInput, validFromInput, validToInput].forEach(input => {
        input.oninput = () => {
            input.classList.remove("border-red-500", "ring-1", "ring-green-500");
            if (input === codeInput)
                codeError.textContent = "";
            if (input === valueInput)
                valueError.textContent = "";
            if (input === descriptionInput)
                descriptionError.textContent = "";
            if (input === minValueInput)
                minValueError.textContent = "";
            if (input === maxValueInput)
                maxValueError.textContent = "";
            if (input === validFromInput)
                validFromError.textContent = "";
            if (input === validToInput)
                validToError.textContent = "";
        };
    });

    document.getElementById("create-voucher-btn").onclick = async () => {
        const validCode = await validateCode(codeInput, codeError);
        const validVal = validateValue(valueInput, valueError, typeInput.value);
        const validDesc = validateDescription(descriptionInput, descriptionError);
        const validMinVal = validateMinValue(minValueInput, minValueError);
        const validMaxVal = validateMaxValue(typeInput.value, maxValueInput, maxValueError);
        const validFDate = validateFromDate(validFromInput, validFromError);
        const validTDate = validateToDate(validFromInput, validToInput, validToError);
        if (!validCode || !validVal || !validDesc || !validMinVal || !validMaxVal || !validFDate || !validTDate)
            return;
        const formData = new URLSearchParams();
        formData.append("type", "create");
        formData.append("code", codeInput.value.trim());
        formData.append("voucherType", typeInput.value);
        formData.append("value", valueInput.value.trim());
        formData.append("description", descriptionInput.value.trim());
        formData.append("minValue", minValueInput.value.trim());
        if (typeInput.value === "PERCENTAGE")
            formData.append("maxValue", maxValueInput.value.trim());
        formData.append("validFrom", validFromInput.value);
        formData.append("validTo", validToInput.value);
        if (!blockCheckbox.checked) {
            formData.append("active", "on");
        }

        showLoading();
        fetch("/voucher/view", {
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
                    loadVoucherContentAndEvent(1);
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
    handleTypeChange(typeInput, maxValueInput, maxValueError);
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
                fetch(`/voucher/view`, {
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
                                loadVoucherContentAndEvent(newPage);
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
    try {
        const response = await fetch(`/voucher/view?type=update&id=${id}`);
        const html = await response.text();
        const modal = document.getElementById("modal");
        const modalContent = document.getElementById("modalContent");
        modalContent.innerHTML = html;
        lucide.createIcons();
        modal.classList.remove("hidden");
        modal.classList.add("flex");
        document.body.classList.add("overflow-hidden");

        const form = modalContent.querySelector("form");
        const codeInput = document.getElementById("code");
        const typeInput = document.getElementById("voucherType");
        const valueInput = document.getElementById("value");
        const descriptionInput = document.getElementById("description");
        const minValueInput = document.getElementById("minValue");
        const maxValueInput = document.getElementById("maxValue");
        const validFromInput = document.getElementById("validFrom");
        const validToInput = document.getElementById("validTo");

        const codeError = document.getElementById("voucherCodeError");
        const valueError = document.getElementById("valueError");
        const descriptionError = document.getElementById("descriptionError");
        const minValueError = document.getElementById("minValueError");
        const maxValueError = document.getElementById("maxValueError");
        const validFromError = document.getElementById("validFromError");
        const validToError = document.getElementById("validToError");

        async function validateCode() {
            const code = codeInput.value.trim();
            if (code === "") {
                codeError.textContent = "Voucher code is required.";
                codeInput.classList.add("border-red-500");
                return false;
            }
            try {
                const res = await fetch(`/voucher/view?type=checkVoucherCodeExceptOwn&voucherCode=${encodeURIComponent(code)}&id=${id}`);
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

        typeInput.onchange = () => {
            handleTypeChange(typeInput, maxValueInput, maxValueError);
            if (valueInput.value.trim() !== "") {
                valueInput.classList.remove("ring-1", "ring-green-500", "border-red-500");
                valueError.textContent = "";
                const isValid = validateValue(valueInput, valueError, typeInput.value);
                if (!isValid)
                    valueInput.value = "";
            }
        };

        handleTypeChange(typeInput, maxValueInput, maxValueError);

        codeInput.onblur = validateCode;
        valueInput.onblur = () => validateValue(valueInput, valueError, typeInput.value);
        descriptionInput.onblur = () => validateDescription(descriptionInput, descriptionError);
        minValueInput.onblur = () => validateMinValue(minValueInput, minValueError);
        maxValueInput.onblur = () => validateMaxValue(typeInput.value, maxValueInput, maxValueError);
        validFromInput.onblur = () => validateFromDate(validFromInput, validFromError);
        validToInput.onblur = () => validateToDate(validFromInput, validToInput, validToError);

        [codeInput, valueInput, descriptionInput, minValueInput, maxValueInput, validFromInput, validToInput].forEach(input => {
            input.oninput = () => {
                input.classList.remove("border-red-500", "ring-1", "ring-green-500");
                const errorMap = {
                    [codeInput]: codeError,
                    [valueInput]: valueError,
                    [descriptionInput]: descriptionError,
                    [minValueInput]: minValueError,
                    [maxValueInput]: maxValueError,
                    [validFromInput]: validFromError,
                    [validToInput]: validToError
                };
                errorMap[input].textContent = "";
            };
        });

        form.addEventListener("submit", async function (event) {
            event.preventDefault();

            const validCode = await validateCode();
            const validVal = validateValue(valueInput, valueError, typeInput.value);
            const validDesc = validateDescription(descriptionInput, descriptionError);
            const validMinVal = validateMinValue(minValueInput, minValueError);
            const validMaxVal = validateMaxValue(typeInput.value, maxValueInput, maxValueError);
            const validFDate = validateFromDate(validFromInput, validFromError);
            const validTDate = validateToDate(validFromInput, validToInput, validToError);

            if (!validCode || !validVal || !validDesc || !validMinVal || !validMaxVal || !validFDate || !validTDate)
                return;

            const formData = new FormData(form);
            const id = formData.get("id");
            const code = formData.get("code");
            const voucherType = formData.get("voucherType");
            const value = formData.get("value");
            const description = formData.get("description");
            const minValue = formData.get("minValue");
            const validFrom = formData.get("validFrom");
            const validTo = formData.get("validTo");
            const maxValue = voucherType === "PERCENTAGE" ? formData.get("maxValue") : null;

            const statusRadio = form.querySelector('input[name="status"]:checked');
            const status = statusRadio ? statusRadio.value : "Block";

            const payload = {
                id,
                code,
                voucherType,
                value,
                description,
                minValue,
                validFrom,
                validTo,
                status
            };

            if (voucherType === "PERCENTAGE") {
                payload.maxValue = maxValue;
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
                    loadVoucherContentAndEvent(1);
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

    } catch (err) {
        alert("Cannot open update dialog.");
    }
});

// Voucher details
document.addEventListener("click", async function (e) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const detailBtn = e.target.closest(".detail-voucher-button");
    if (detailBtn) {
        const id = detailBtn.dataset.id;

        try {
            const response = await fetch(`/voucher/view?type=detail&id=${id}`);
            const html = await response.text();

            modalContent.innerHTML = html;
            lucide.createIcons();
            modal.classList.remove("hidden");
            modal.classList.add("flex");
            document.body.classList.add("overflow-hidden");
        } catch (err) {
            alert("Cannot open details dialog.");
        }
    }
});

// Get URL from page
function getCurrentPageFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get("page")) || 1;
}


