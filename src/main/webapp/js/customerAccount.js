// Toggle input (basic info)
function toggleEdit(button, inputId) {
    const input = document.getElementById(inputId);
    if (input && input.hasAttribute("readonly")) {
        input.removeAttribute("readonly");
        input.classList.remove("bg-gray-50");
        input.focus();
        input.selectionStart = input.value.length;
    }
}

// Toggle address fields editable
function toggleEditAddress(button, addrId) {
    const container = button.closest('.address-item');
    const fieldIds = ['recipient_', 'address_', 'phone_', 'name_'];

    fieldIds.forEach(prefix => {
        const input = document.getElementById(prefix + addrId);
        if (input) {
            input.removeAttribute('readonly');
            input.classList.remove('bg-gray-50');
            input.focus();
            input.selectionStart = input.value.length;
        }
    });

    const radioRow = container.querySelector('.default-radio');
    if (radioRow) {
        radioRow.classList.remove('hidden');
    }
}

// Validate name
function validateName(input, errorEl) {
    const value = input.value.trim();
    if (!value) {
        errorEl.textContent = "Name is required.";
        input.classList.add("border-red-500");
        return false;
    }
    errorEl.textContent = "";
    input.classList.remove("border-red-500");
    input.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate phone
function validatePhone(input, errorEl) {
    const value = input.value.trim();
    const regex = /^\+?\d{8,15}$/;
    if (!value) {
        errorEl.textContent = "Phone number is required.";
        input.classList.add("border-red-500");
        return false;
    }
    if (!regex.test(value)) {
        errorEl.textContent = "Invalid phone number.";
        input.classList.add("border-red-500");
        return false;
    }
    errorEl.textContent = "";
    input.classList.remove("border-red-500");
    input.classList.add("ring-1", "ring-green-500");
    return true;
}

// Validate address
function validateAddress(input, errorEl) {
    const value = input.value.trim();
    if (!value) {
        errorEl.textContent = "Address is required.";
        input.classList.add("border-red-500");
        return false;
    }
    errorEl.textContent = "";
    input.classList.remove("border-red-500");
    input.classList.add("ring-1", "ring-green-500");
    return true;
}

// --- Form Handler ---
function initCustomerForm() {
    const form = document.getElementById("customerUpdateForm");
    if (!form || form.dataset.bound === "true") return;
    form.dataset.bound = "true"; 

    const avatarInput = document.getElementById("avatar");
    const avatarPreview = document.getElementById("avatar-image-preview-tag");

    // Avatar preview
    if (avatarInput && avatarPreview) {
        avatarInput.addEventListener("change", function () {
            const file = this.files[0];
            if (file && file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    avatarPreview.src = e.target.result;
                    avatarPreview.classList.remove("hidden");
                };
                reader.readAsDataURL(file);
            } else {
                avatarPreview.src = "";
                avatarPreview.classList.add("hidden");
            }
        });
    }

    const nameInput = document.getElementById("nameEdit");
    const phoneInput = document.getElementById("phoneEdit");

    const nameError = document.getElementById("nameError");
    const phoneError = document.getElementById("phoneError");

    const resetErrorStyle = (input, error) => {
        error.textContent = "";
        input.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    nameInput?.addEventListener("blur", () => validateName(nameInput, nameError));
    nameInput?.addEventListener("input", () => resetErrorStyle(nameInput, nameError));

    phoneInput?.addEventListener("blur", () => {
        const value = phoneInput.value.trim();
        const phoneRegex = /^0[0-9]{9}$/; 
        if (value !== "" && !phoneRegex.test(value)) {
            phoneError.textContent = "Invalid phone number format.";
            phoneInput.classList.add("border-red-500");
        } else if (value === ""){
            phoneInput.classList.remove("border-red-500");
        } else {
            phoneError.textContent = "";
            phoneInput.classList.remove("border-red-500");
            phoneInput.classList.add("ring-1", "ring-green-500");
        }
    });

    phoneInput?.addEventListener("input", () => resetErrorStyle(phoneInput, phoneError));

    const addressItems = document.querySelectorAll(".address-item");
    addressItems.forEach(item => {
        const id = item.dataset.addrId;

        const recipient = document.getElementById(`recipient_${id}`);
        const address = document.getElementById(`address_${id}`);
        const phone = document.getElementById(`phone_${id}`);
        const addrName = document.getElementById(`name_${id}`);

        const errRecipient = document.getElementById(`recipientError_${id}`);
        const errAddress = document.getElementById(`addressError_${id}`);
        const errPhone = document.getElementById(`phoneError_${id}`);
        const errAddrName = document.getElementById(`addrNameError_${id}`);

        recipient?.addEventListener("blur", () => {
            if (!recipient.hasAttribute("readonly")) validateName(recipient, errRecipient);
        });
        recipient?.addEventListener("input", () => resetErrorStyle(recipient, errRecipient));

        address?.addEventListener("blur", () => {
            if (!address.hasAttribute("readonly")) validateAddress(address, errAddress);
        });
        address?.addEventListener("input", () => resetErrorStyle(address, errAddress));

        phone?.addEventListener("blur", () => {
            if (!phone.hasAttribute("readonly")) validatePhone(phone, errPhone);
        });
        phone?.addEventListener("input", () => resetErrorStyle(phone, errPhone));
        
        addrName?.addEventListener("blur", () => {
            if (!recipient.hasAttribute("readonly")) validateName(addrName, errAddrName);
        });
        addrName?.addEventListener("input", () => resetErrorStyle(addrName, errAddrName));
    });

    const isChanged = () => {
        const check = (input) =>
            input && !input.hasAttribute("readonly") &&
            input.value.trim() !== input.dataset.original?.trim();

        if (check(nameInput) || check(phoneInput)) return true;
        if (avatarInput?.files.length > 0) return true;

        for (const item of addressItems) {
            const id = item.dataset.addrId;
            const recipient = document.getElementById(`recipient_${id}`);
            const address = document.getElementById(`address_${id}`);
            const phone = document.getElementById(`phone_${id}`);
            const addrName = document.getElementById(`name_${id}`);
            if (check(recipient) || check(address) || check(phone) || check(addrName)) return true;
        }
        const defaultRadios = document.querySelectorAll('input[name="defaultAddressId"]');
        for (const radio of defaultRadios) {
            if (radio.checked && radio.dataset.original !== "true") {
                return true; 
        }
    }
        return false;
    };
 
    form.addEventListener("submit", async function (e) {
        e.preventDefault();

        if (!isChanged()) {
            Toastify({
                text: "No changes detected.",
                duration: 3000,
                gravity: "top",
                position: "right",
                backgroundColor: "#f59e0b",
            }).showToast();
            return;
        }

        const nameValid = !nameInput.hasAttribute("readonly") ? validateName(nameInput, nameError) : true;
        const phoneValid = !phoneInput.hasAttribute("readonly") ? (() => {
        const value = phoneInput.value.trim();
        const phoneRegex = /^0[0-9]{9}$/; 
        if (value !== "" && !phoneRegex.test(value)) {
            phoneError.textContent = "Invalid phone number format.";
            phoneInput.classList.add("border-red-500", "ring-1", "ring-red-500");
            return false;
        }
        if (value === ""){
            phoneInput.classList.remove("border-red-500", "ring-1", "ring-red-500");
        }
        phoneError.textContent = "";
        phoneInput.classList.remove("border-red-500", "ring-1", "ring-red-500");
        phoneInput.classList.add("ring-1", "ring-green-500");
        return true;
        })() : true;

        let addressValid = true;
        for (const item of addressItems) {
            const id = item.dataset.addrId;
            const recipient = document.getElementById(`recipient_${id}`);
            const address = document.getElementById(`address_${id}`);
            const phone = document.getElementById(`phone_${id}`);
            const addrName = document.getElementById(`name_${id}`);

            const errRecipient = document.getElementById(`recipientError_${id}`);
            const errAddress = document.getElementById(`addressError_${id}`);
            const errPhone = document.getElementById(`phoneError_${id}`);
            const errAddrName = document.getElementById(`addrNameError_${id}`);

            if (!recipient.hasAttribute("readonly")) {
                if (!validateName(recipient, errRecipient)) addressValid = false;
                if (!validateAddress(address, errAddress)) addressValid = false;
                if (!validatePhone(phone, errPhone)) addressValid = false;
                if (!validateName(addrName, errAddrName)) addressValid = false;
            }
        }

        if (nameValid && phoneValid && addressValid) {
            showLoading();
            window.scrollTo({ top: 0});
            try {
                const res = await fetch(form.action, {
                    method: "POST",
                    body: new FormData(form)
                });

                if (res.status === 200) {
                    // Update sidebar
                    loadSidebar();
                    // Reload main content
                    fetch("/customer/self?type=profile")
                        .then(r => r.text())
                        .then(html => {
                            const main = document.querySelector("#main-content");
                            if (main) {
                                main.innerHTML = html;
                                lucide.createIcons();
                                initCustomerForm();
                                initCreateAddressButton();
                            }
                        });
                    hiddenLoading();
                    Toastify({
                        text: "Your profile has been updated successfully!",
                        duration: 3000,
                        gravity: "top",
                        position: "right",
                        backgroundColor: "#22c55e",
                    }).showToast();
                } else {
                    Toastify({
                        text: "Failed to update. Please try again.",
                        duration: 3000,
                        gravity: "top",
                        position: "right",
                        backgroundColor: "#ef4444",
                    }).showToast();
                }
            } catch (err) {
                console.error("Submit error:", err);
                Toastify({
                    text: "Server error. Please try again later.",
                    duration: 3000,
                    gravity: "top",
                    position: "right",
                    backgroundColor: "#ef4444",
                }).showToast();
            }
        }
    });
}

const updateModalContent = (path, loadEvent) => {
    fetch(path)
        .then(res => res.text())
        .then(html => {
            document.getElementById('modalContent').innerHTML = html;
            requestAnimationFrame(() => {
                if (typeof loadEvent === 'function') loadEvent();
            });
        });
};

// Handle create address button
function initCreateAddressButton() {
    const createAddressBtn = document.getElementById("create-address-button");
    createAddressBtn.addEventListener("click", () => {
        const modal = document.getElementById("modal");
        openModal(modal);
        updateModalContent("/customer/self?type=createAddress", loadCreateCustomerAddressEvent);
    });
}

// Add new address
function loadCreateCustomerAddressEvent() {
    lucide.createIcons();

    const nameInput = document.getElementById("addressName");
    const recipientInput = document.getElementById("recipientName");
    const detailInput = document.getElementById("addressDetails");
    const phoneInput = document.getElementById("addressPhone");
    const defaultCheckbox = document.getElementById("isDefault");

    const nameError = document.getElementById("addressNameError");
    const recipientError = document.getElementById("recipientNameError");
    const detailError = document.getElementById("addressDetailsError");
    const phoneError = document.getElementById("addressPhoneError");

    const resetErrorStyle = (input, errorEl) => {
        errorEl.textContent = "";
        input.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    nameInput?.addEventListener("blur", () => validateName(nameInput, nameError));
    recipientInput?.addEventListener("blur", () => validateName(recipientInput, recipientError));
    detailInput?.addEventListener("blur", () => validateAddress(detailInput, detailError));
    phoneInput?.addEventListener("blur", () => validatePhone(phoneInput, phoneError));

    nameInput?.addEventListener("input", () => resetErrorStyle(nameInput, nameError));
    recipientInput?.addEventListener("input", () => resetErrorStyle(recipientInput, recipientError));
    detailInput?.addEventListener("input", () => resetErrorStyle(detailInput, detailError));
    phoneInput?.addEventListener("input", () => resetErrorStyle(phoneInput, phoneError));

    // Submit event
    const createBtn = document.getElementById("create-address-btn");
    createBtn.onclick = () => {
        const isValidName = validateName(nameInput, nameError);
        const isValidRecipient = validateName(recipientInput, recipientError);
        const isValidDetail = validateAddress(detailInput, detailError);
        const isValidPhone = validatePhone(phoneInput, phoneError);

        if (!isValidName || !isValidRecipient || !isValidDetail || !isValidPhone) return;

        const formData = new URLSearchParams();
        formData.append("type", "createAddress");
        formData.append("addressName", nameInput.value.trim());
        formData.append("recipientName", recipientInput.value.trim());
        formData.append("addressDetails", detailInput.value.trim());
        formData.append("addressPhone", phoneInput.value.trim());
        if (defaultCheckbox?.checked) {
            formData.append("isDefault", "on");
        }

        showLoading();
        fetch("/customer/self", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: formData.toString()
        })
        .then(res => {
            if (!res.ok) throw new Error("Create failed");
            return res.text();
        })
        .then(() => {
            hiddenLoading();
            closeModal();
            Toastify({
                text: "Address created successfully!",
                duration: 4000,
                gravity: "top",
                position: "right",
                style: { background: "#22c55e" },
                close: true
            }).showToast();
            loadContent("profile", false);
        })
        .catch(() => {
            hiddenLoading();
            Toastify({
                text: "Failed to create address.",
                duration: 4000,
                gravity: "top",
                position: "right",
                style: { background: "#ef4444" },
                close: true
            }).showToast();
        });
    };
}

// Delete address
document.addEventListener("click", function (e) {
    const deleteBtn = e.target.closest(".delete-address-button");
    if (deleteBtn) {
        const id = deleteBtn.dataset.id;
        const isDefault = deleteBtn.dataset.default === "true";

        if (isDefault) {
            Toastify({
                text: "You cannot delete the default address.",
                duration: 4000,
                gravity: "top",
                position: "right",
                backgroundColor: "#f59e0b", // warning màu vàng
                close: true
            }).showToast();
            return;
        }

        Swal.fire({
            title: 'Are you sure you want to delete this address?',
            text: "This address will be permanently removed.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, delete it',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/customer/self`, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `type=deleteAddress&id=${id}`
                })
                .then(response => {
                    const isSuccess = response.ok;

                    Toastify({
                        text: isSuccess ? "Address deleted successfully!" : "Delete failed.",
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: isSuccess ? "#22c55e" : "#ef4444"
                        },
                        close: true
                    }).showToast();

                    if (isSuccess) {
                        loadContent("profile", false); // Reload trang profile
                    }
                })
                .catch(() => {
                    Toastify({
                        text: "An error occurred while deleting.",
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: { background: "#ef4444" },
                        close: true
                    }).showToast();
                });
            }
        });
    }
});


