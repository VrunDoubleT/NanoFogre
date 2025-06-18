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

        showLoading();
        fetch("/staff/view", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: formData
        })
                .then(response => response.text())
                .then(lastPage => {
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
                    const url = new URL(window.location);
                    url.searchParams.set("page", lastPage);
                    history.pushState(null, '', url.toString());
                    loadStaffContentAndEvent(parseInt(lastPage));
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
document.addEventListener("click", async function (e) {
    const deleteBtn = e.target.closest(".delete-staff-button");
    if (deleteBtn) {
        const id = deleteBtn.dataset.id;
        try {
            const response = await fetch(`/staff/view?type=delete&id=${id}`);
            const html = await response.text();

            const modal = document.getElementById("modal");
            const modalContent = document.getElementById("modalContent");
            modalContent.innerHTML = html;
            lucide.createIcons();
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

                            Toastify({
                                text: "Staff deleted successfully!",
                                duration: 5000,
                                gravity: "top",
                                position: "right",
                                style: {
                                    background: "#2196F3"
                                },
                                close: true
                            }).showToast();

                            closeModal();
                            const newPage = (rowCount === 1 && currentPage > 1) ? currentPage - 1 : currentPage;
                            const url = new URL(window.location);
                            url.searchParams.set("page", newPage);
                            history.pushState(null, '', url.toString());
                            loadStaffContentAndEvent(newPage);
                        } else {
                            Toastify({
                                text: "Delete failed.",
                                duration: 5000,
                                gravity: "top",
                                position: "right",
                                style: {background: "#f44336"},
                                close: true
                            }).showToast();
                        }
                    } catch (err) {
                        Toastify({
                            text: "An error occurred while deleting.",
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
            alert("Cannot open delete dialog.");
        }
    }
});

// Update staff
document.addEventListener("click", async function (e) {
    const updateBtn = e.target.closest(".update-staff-button");
    if (updateBtn) {
        const id = updateBtn.dataset.id;
        try {
            const response = await fetch(`/staff/view?type=update&id=${id}`);
            const html = await response.text();

            const modal = document.getElementById("modal");
            const modalContent = document.getElementById("modalContent");
            modalContent.innerHTML = html;
            lucide.createIcons();
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