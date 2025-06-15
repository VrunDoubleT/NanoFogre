const loadStaffContentAndEvent = (page) => {
// SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingStaff').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;
    let paramUrl = '';
    // Fetch servlet to get list staff HTML and pagination
    Promise.all([
        fetch("/staff/view?type=list&page=" + page + paramUrl).then(res => res.text()),
        fetch("/staff/view?type=pagination&page=" + page + paramUrl).then(res => res.text())
    ]).then(([staffHTML, paginationHTML]) => {
// UPDATE HTML
        document.getElementById('tabelContainer').innerHTML = staffHTML;
        document.getElementById('pagination').innerHTML = paginationHTML;
        document.getElementById('loadingStaff').innerHTML = '';
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

    function required(value, message = "This field is required") {
        if (!value || value.trim() === "")
            return message;
        return null;
    }

    const configValidate = [
        {
            id: "name",
            validate: [required]
        },
        {
            id: "email",
            validate: [
                (value) => {
                    if (!value.trim())
                        return "Email is required";
                    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    return re.test(value) ? null : "Invalid email format";
                }
            ]
        }
    ];

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
        const errorElement = document.getElementById(config.id + "Error");
        if (errorMessage !== null) {
            errorElement.textContent = errorMessage;
            errorElement.classList.add("text-red-500", "text-sm");
            inputElement.classList.add("border-red-500");
            return true;
        } else {
            errorElement.textContent = "";
            inputElement.classList.remove("border-red-500");
            inputElement.classList.add("ring-1", "ring-green-500");
        }
        return false;
    };

    configValidate.forEach(config => {
        const inputElement = document.getElementById(config.id);
        if (inputElement) {
            inputElement.onfocus = () => {
                const errorElement = document.getElementById(config.id + "Error");
                errorElement.textContent = "";
                inputElement.classList.remove("border-red-500", "ring-1", "ring-green-500");
            };
            inputElement.onblur = () => {
                checkValidate(config);
            };
        }
    });

    document.getElementById("create-staff-btn").onclick = () => {
        let isError = false;
        configValidate.forEach(config => {
            const isErrorValidate = checkValidate(config);
            if (isErrorValidate)
                isError = true;
        });
        if (isError)
            return;

        const formData = new URLSearchParams();
        formData.append("type", "create");
        formData.append("name", document.getElementById("name").value.trim());
        formData.append("email", document.getElementById("email").value.trim());
        formData.append("password", password);
        if (document.getElementById("block").checked) {
            formData.append("block", "on");
        }

        fetch("/staff/view", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData
        }).then(res => {
            if (res.ok) {
                resetCreateStaffForm();
                showSuccessPopup("Staff created successfully!", () => {
                    location.reload();
                });
            } else {
                alert("Failed to create staff.");
            }
        });
    };
}

function generatePassword() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$!";
    let password = "";
    for (let i = 0; i < 10; i++) {
        password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return password;
}

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

                            // Đếm số dòng staff (trừ header)
                            const rowCount = document.querySelectorAll("tbody tr").length;

                            showSuccessPopup("Staff deleted successfully!", () => {
                                // Nếu chỉ còn 1 dòng (và đã xóa) → quay về trang trước
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
            alert("❌ Cannot open delete dialog.");
        }
    }
});

function getCurrentPageFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return parseInt(urlParams.get("page")) || 1;
}










