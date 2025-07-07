// FOR ADMIN/STAFF
// Customer list
const loadCustomerContentAndEvent = (page) => {
    lucide.createIcons();
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingCustomer').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    Promise.all([
        fetch("/customer/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/customer/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([customerHTML, paginationHTML]) => {
        document.getElementById('tabelContainer').innerHTML = customerHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingCustomer').innerHTML = '';
        initToggleBlockEvents();
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
                    loadCustomerContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });
    });
};

// Handle with block button
function initToggleBlockEvents() {
    document.querySelectorAll(".toggle-block").forEach(toggle => {
        toggle.addEventListener("change", async function () {
            const id = this.dataset.id;
            const isBlock = !this.checked;
            const currentPage = getCurrentPageFromURL();
            try {
                const res = await fetch("/customer/view", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `type=block&id=${id}&isBlock=${isBlock}`
                });
                if (res.ok) {
                    Toastify({
                        text: `Customer status updated successfully!`,
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#2196F3"},
                        close: true
                    }).showToast();
                    loadCustomerContentAndEvent(currentPage);
                } else {
                    this.checked = !this.checked;
                    Toastify({
                        text: "Update customer status failed.",
                        duration: 4000,
                        gravity: "top",
                        position: "right",
                        style: {background: "#f44336"},
                        close: true
                    }).showToast();
                }
            } catch (e) {
                this.checked = !this.checked;
                Toastify({
                    text: "An error occurred while updating.",
                    duration: 4000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#f44336"},
                    close: true
                }).showToast();
            }
        });
    });
}

// Customer details
document.addEventListener("click", async function (e) {
    lucide.createIcons();
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");
    const detailBtn = e.target.closest(".detail-customer-button");
    if (detailBtn) {
        const id = detailBtn.dataset.id;
        try {
            const response = await fetch(`/customer/view?type=detail&id=${id}`);
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

// Handle with switch tab (Profile/Orders) in detail
function switchTab(tabName) {
    document.getElementById('profileTab').classList.add('hidden');
    document.getElementById('ordersTab').classList.add('hidden');
    document.getElementById(tabName + 'Tab').classList.remove('hidden');
    const buttons = document.querySelectorAll('.tab-button');
    buttons.forEach(btn => btn.classList.remove('border-b-2', 'border-indigo-500', 'font-semibold', 'text-indigo-600'));
    const activeBtn = document.getElementById(tabName + 'Btn');
    activeBtn.classList.add('border-b-2', 'border-indigo-500', 'font-semibold', 'text-indigo-600');
}

// Get URL from page
function getCurrentPageFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get("page")) || 1;
}

// FOR CUSTOMER
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
    const fieldIds = ['recipient_', 'address_', 'phone_'];

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

// Validate email
async function validateEmail(input, errorEl) {
    const value = input.value.trim();
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    input.classList.remove("border-red-500", "ring-1", "ring-green-500");
    errorEl.textContent = "";

    if (!value) {
        errorEl.textContent = "Email is required.";
        input.classList.add("border-red-500");
        return false;
    }
    if (!regex.test(value)) {
        errorEl.textContent = "Invalid email format.";
        input.classList.add("border-red-500");
        return false;
    }

    try {
        const res = await fetch(`/customer/self?type=checkEmail&email=${encodeURIComponent(value)}`);
        const isExist = await res.text();
        if (isExist === "true") {
            errorEl.textContent = "This email is already in use.";
            input.classList.add("border-red-500");
            return false;
        }
    } catch (err) {
        errorEl.textContent = "Failed to validate email.";
        input.classList.add("border-red-500");
        return false;
    }

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
    const emailInput = document.getElementById("emailEdit");
    const phoneInput = document.getElementById("phoneEdit");

    const nameError = document.getElementById("nameError");
    const emailError = document.getElementById("emailError");
    const phoneError = document.getElementById("phoneError");

    const resetErrorStyle = (input, error) => {
        error.textContent = "";
        input.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    nameInput?.addEventListener("blur", () => validateName(nameInput, nameError));
    nameInput?.addEventListener("input", () => resetErrorStyle(nameInput, nameError));

    emailInput?.addEventListener("blur", () => validateEmail(emailInput, emailError));
    emailInput?.addEventListener("input", () => resetErrorStyle(emailInput, emailError));

    phoneInput?.addEventListener("blur", () => validatePhone(phoneInput, phoneError));
    phoneInput?.addEventListener("input", () => resetErrorStyle(phoneInput, phoneError));

    const addressItems = document.querySelectorAll(".address-item");
    addressItems.forEach(item => {
        const id = item.dataset.addrId;

        const recipient = document.getElementById(`recipient_${id}`);
        const address = document.getElementById(`address_${id}`);
        const phone = document.getElementById(`phone_${id}`);

        const errRecipient = document.getElementById(`recipientError_${id}`);
        const errAddress = document.getElementById(`addressError_${id}`);
        const errPhone = document.getElementById(`phoneError_${id}`);

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
    });

    const isChanged = () => {
        const check = (input) =>
            input && !input.hasAttribute("readonly") &&
            input.value.trim() !== input.dataset.original?.trim();

        if (check(nameInput) || check(emailInput) || check(phoneInput)) return true;
        if (avatarInput?.files.length > 0) return true;

        for (const item of addressItems) {
            const id = item.dataset.addrId;
            const recipient = document.getElementById(`recipient_${id}`);
            const address = document.getElementById(`address_${id}`);
            const phone = document.getElementById(`phone_${id}`);
            if (check(recipient) || check(address) || check(phone)) return true;
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
        const emailValid = !emailInput.hasAttribute("readonly") ? await validateEmail(emailInput, emailError) : true;
        const phoneValid = !phoneInput.hasAttribute("readonly") ? validatePhone(phoneInput, phoneError) : true;

        let addressValid = true;
        for (const item of addressItems) {
            const id = item.dataset.addrId;
            const recipient = document.getElementById(`recipient_${id}`);
            const address = document.getElementById(`address_${id}`);
            const phone = document.getElementById(`phone_${id}`);

            const errRecipient = document.getElementById(`recipientError_${id}`);
            const errAddress = document.getElementById(`addressError_${id}`);
            const errPhone = document.getElementById(`phoneError_${id}`);

            if (!recipient.hasAttribute("readonly")) {
                if (!validateName(recipient, errRecipient)) addressValid = false;
                if (!validateAddress(address, errAddress)) addressValid = false;
                if (!validatePhone(phone, errPhone)) addressValid = false;
            }
        }

        if (nameValid && emailValid && phoneValid && addressValid) {
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







