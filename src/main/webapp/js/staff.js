// Staff list
const loadStaffContentAndEvent = (page) => {
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingStaff').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    Promise.all([
        fetch("/staff/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/staff/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([staffHTML, paginationHTML]) => {
        document.getElementById('tabelContainer').innerHTML = staffHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingStaff').innerHTML = '';
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
                    loadStaffContentAndEvent(parseOptionNumber(pageClick, 1));
                }
            });
        });
    });
    document.getElementById("create-staff-button").onclick = () => {
        const modal = document.getElementById("modal");
        openModal(modal);
        updateModalContent(`/staff/view?type=create`, loadCreateStaffEvent);
    };
};

// Add Staff
function loadCreateStaffEvent() {
    const password = generatePassword();
    document.getElementById("password").value = password;
    document.getElementById("generatedPassword").classList.remove("hidden");
    document.getElementById("passwordDisplay").textContent = password;

    const nameInput = document.getElementById("name");
    const emailInput = document.getElementById("email");
    const nameError = document.getElementById("nameError");
    const emailError = document.getElementById("emailError");

    // Validate name
    function validateName() {
        const name = nameInput.value.trim();
        if (name === "") {
            nameError.textContent = "Name is required";
            nameInput.classList.add("border-red-500");
            return false;
        }
        nameError.textContent = "";
        nameInput.classList.remove("border-red-500");
        nameInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate email
    async function validateEmail() {
        const email = emailInput.value.trim();
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        console.log("Validating email:", email);

        if (email === "") {
            emailError.textContent = "Email is required";
            emailInput.classList.add("border-red-500");
            return false;
        }
        if (!re.test(email)) {
            emailError.textContent = "Invalid email format";
            emailInput.classList.add("border-red-500");
            return false;
        }

        try {
            const res = await fetch(`/staff/view?type=checkEmail&email=${encodeURIComponent(email)}`);
            const exists = await res.text();
            if (exists === "true") {
                emailError.textContent = "Email already exists";
                emailInput.classList.add("border-red-500");
                return false;
            }
        } catch (e) {
            emailError.textContent = "Error checking email";
            emailInput.classList.add("border-red-500");
            return false;
        }

        emailError.textContent = "";
        emailInput.classList.remove("border-red-500");
        emailInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    nameInput.onblur = validateName;
    emailInput.onblur = validateEmail;
    emailInput.oninput = () => {
        emailError.textContent = "";
        emailInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    document.getElementById("create-staff-btn").onclick = async () => {
        const isNameValid = validateName();
        const isEmailValid = await validateEmail();

        if (!isNameValid || !isEmailValid)
            return;

        const formData = new URLSearchParams();
        formData.append("type", "create");
        formData.append("name", nameInput.value.trim());
        formData.append("email", emailInput.value.trim());
        formData.append("password", password);
        if (document.getElementById("block").checked) {
            formData.append("block", "on");
        }

        fetch("/staff/view", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: formData
        }).then(async res => {
            if (res.ok) {
                const lastPage = await res.text(); // Nhận số trang chứa staff mới
                resetCreateStaffForm();
                showSuccessPopup("Staff created successfully!", () => {
                    const url = new URL(window.location);
                    url.searchParams.set("page", lastPage);
                    window.location.href = url.toString(); // Load đến trang chứa staff mới
                });
            } else {
                alert("Failed to create staff.");
            }
        });
    };
}

// Random password
function generatePassword() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$!";
    let password = "";
    for (let i = 0; i < 10; i++) {
        password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return password;
}

// Reset form
function resetCreateStaffForm() {
    document.getElementById("name").value = "";
    document.getElementById("email").value = "";
    document.getElementById("password").value = "";
    document.getElementById("block").checked = false;
    document.getElementById("generatedPassword").classList.add("hidden");
    document.getElementById("passwordDisplay").textContent = "";

    ["name", "email"].forEach(id => {
        document.getElementById(id).classList.remove("border-red-500", "ring-1", "ring-green-500");
        const errorElement = document.getElementById(id + "Error");
        if (errorElement)
            errorElement.textContent = "";
    });
}

// Delete staff
document.addEventListener("click", async function (e) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const deleteBtn = e.target.closest(".delete-staff-button");
    if (deleteBtn) {
        const id = deleteBtn.dataset.id;

        try {
            const response = await fetch(`/staff/view?type=delete&id=${id}`);
            const html = await response.text();

            modalContent.innerHTML = html;
            modal.classList.remove("hidden");
            modal.classList.add("flex");
            document.body.classList.add("overflow-hidden");

            const confirmBtn = document.getElementById("btnConfirmDelete");
            if (confirmBtn) {
                confirmBtn.addEventListener("click", async function () {
                    try {
                        const res = await fetch("/staff/view", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: `type=delete&id=${id}`
                        });

                        if (res.ok) {
                            const currentPage = getCurrentPageFromURL();

                            const rowCount = document.querySelectorAll("tbody tr").length;

                            showSuccessPopup("Staff deleted successfully!", () => {
                                if (rowCount === 1 && currentPage > 1) {
                                    const prevPageUrl = new URL(window.location.href);
                                    prevPageUrl.searchParams.set("page", currentPage - 1);
                                    window.location.href = prevPageUrl.toString();
                                } else {
                                    window.location.reload();
                                }
                            });
                        } else {
                            alert("Delete failed.");
                        }
                    } catch (err) {
                        alert("An error occurred while deleting.");
                    }
                });
            }

        } catch (err) {
            alert("Cannot open delete dialog.");
        }
    }
});

// Update staff
document.addEventListener("click", async function (e) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const updateBtn = e.target.closest(".update-staff-button");
    if (updateBtn) {
        const id = updateBtn.dataset.id;

        try {
            const response = await fetch(`/staff/view?type=update&id=${id}`);
            const html = await response.text();

            modalContent.innerHTML = html;
            modal.classList.remove("hidden");
            modal.classList.add("flex");
            document.body.classList.add("overflow-hidden");

            const form = modalContent.querySelector("form");
            if (form) {
                form.addEventListener("submit", async function (event) {
                    event.preventDefault();

                    const formData = new FormData(form);
                    const status = formData.get("status");

                    try {
                        const res = await fetch("/staff/view", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: `type=update&id=${id}&status=${encodeURIComponent(status)}`
                        });

                        if (res.ok) {
                            showSuccessPopup("Status updated successfully!", () => {
                                window.location.reload();
                            });
                        } else {
                            alert("Update failed.");
                        }
                    } catch (err) {
                        alert("An error occurred while updating.");
                    }
                });
            }

        } catch (err) {
            alert("Cannot open update dialog.");
        }
    }
});

// Staff details
document.addEventListener("click", async function (e) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("modalContent");

    const detailBtn = e.target.closest(".detail-staff-button");
    if (detailBtn) {
        const id = detailBtn.dataset.id;

        try {
            const response = await fetch(`/staff/view?type=detail&id=${id}`);
            const html = await response.text();

            modalContent.innerHTML = html;
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

// Pop up success action
function showSuccessPopup(message, onConfirm) {
    const overlay = document.createElement("div");
    overlay.className = "fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50";

    const popup = document.createElement("div");
    popup.className = "bg-white rounded-xl shadow-xl p-6 max-w-sm w-full text-center";

    popup.innerHTML = `
        <p class="text-lg font-semibold text-green-600 mb-4">${message}</p>
        <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">OK</button>
    `;

    overlay.appendChild(popup);
    document.body.appendChild(overlay);

    popup.querySelector("button").onclick = () => {
        document.body.removeChild(overlay);
        if (typeof onConfirm === "function") {
            onConfirm();
        }
    };
}
