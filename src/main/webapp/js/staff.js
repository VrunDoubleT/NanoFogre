// Staff list
const loadStaffContentAndEvent = (page) => {
    lucide.createIcons();
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingStaff').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    Promise.all([
        fetch("/staff/action?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/staff/action?type=pagination&page=" + page + paramUrl).then(res => res.text())
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
        updateModalContent(`/staff/action?type=create`, loadCreateStaffEvent);
    };
};

// Add Staff
function loadCreateStaffEvent() {
    lucide.createIcons();
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
            const res = await fetch(`/staff/action?type=checkEmail&email=${encodeURIComponent(email)}`);
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
    nameInput.oninput = () => {
        nameError.textContent = "";
        nameInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

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

        showLoading();
        fetch("/staff", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: formData
        })
                .then(response => response.text())
                .then(() => {
                    hiddenLoading();
                    closeModal();
                    Toastify({
                        text: "Staff created successfully!",
                        duration: 5000,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: "#2196F3"
                        },
                        close: true
                    }).showToast();
                    loadStaffContentAndEvent(1);
                })
                .catch(error => {
                    hiddenLoading();
                    Toastify({
                        text: "Failed to create staff.",
                        duration: 5000,
                        gravity: "top",
                        position: "right",
                        style: {
                            background: "#f44336"
                        },
                        close: true
                    }).showToast();
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

// Delete staff
document.addEventListener("click", function (e) {
    const deleteBtn = e.target.closest(".delete-staff-button");
    if (deleteBtn) {
        const id = deleteBtn.dataset.id;
        Swal.fire({
            title: 'Are you sure you want to delete this staff?',
            text: "This staff will be removed permanently from the system.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, delete it',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`/staff`, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `type=delete&id=${id}`
                })
                        .then(response => {
                            const isSuccess = response.ok;

                            Toastify({
                                text: isSuccess ? "Staff deleted successfully!" : "Delete failed.",
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

                                loadStaffContentAndEvent(newPage);
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

// Update staff
document.addEventListener("click", async function (e) {
    const updateBtn = e.target.closest(".update-staff-button");
    if (updateBtn) {
        const id = updateBtn.dataset.id;
        try {
            const response = await fetch(`/staff/action?type=update&id=${id}`);
            const html = await response.text();
            const modal = document.getElementById("modal");
            const modalContent = document.getElementById("modalContent");
            modalContent.innerHTML = html;
            lucide.createIcons();
            modal.classList.remove("hidden");
            modal.classList.add("flex");
            document.body.classList.add("overflow-hidden");
            const form = modalContent.querySelector("form");
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
                    const res = await fetch(`/staff/action?type=checkEmailExceptOwn&email=${encodeURIComponent(email)}&id=${id}`);
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
            nameInput.oninput = () => {
                nameError.textContent = "";
                nameInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
            };

            emailInput.onblur = validateEmail;
            emailInput.oninput = () => {
                emailError.textContent = "";
                emailInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
            };

            if (form) {
                form.addEventListener("submit", async function (event) {
                    event.preventDefault();
                    const isNameValid = validateName();
                    const isEmailValid = await validateEmail();
                    if (!isNameValid || !isEmailValid)
                        return;
                    const formData = new FormData(form);
                    const id = formData.get("id");
                    const name = formData.get("name");
                    const email = formData.get("email");
                    const status = formData.get("status");
                    const isBlock = status === "Block";
                    try {
                        const res = await fetch("/staff/action?type=update", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({
                                id: id,
                                name: name,
                                email: email,
                                status: isBlock ? 'Block' : 'Active'
                            })
                        });
                        if (res.ok) {
                            Toastify({
                                text: "Staff updated successfully!",
                                duration: 5000,
                                gravity: "top",
                                position: "right",
                                style: {background: "#2196F3"},
                                close: true
                            }).showToast();
                            closeModal();
                            const currentPage = getCurrentPageFromURL();
                            loadStaffContentAndEvent(currentPage);
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
            const response = await fetch(`/staff/action?type=detail&id=${id}`);
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