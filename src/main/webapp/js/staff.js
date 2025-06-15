const loadStaffContentAndEvent = (page) => {
    // SHOW LOADING WHEN CALL SERVLET GET HTML
    document.getElementById('tabelContainer').innerHTML = '';
    document.getElementById('loadingStaff').innerHTML = `
        <div class="flex w-full justify-center items-center h-32">
            <div class="w-10 h-10 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
        </div>
    `;

    let paramUrl = ''
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
};

document.getElementById("create-staff-button").onclick = () => {
    const modal = document.getElementById("modal");
    openModal(modal);
    updateModalContent(`/staff/view?type=create`, loadCreateStaffEvent);
};

function loadCreateStaffEvent() {
    const password = generatePassword();
    document.getElementById("password").value = password;
    document.getElementById("generatedPassword").classList.remove("hidden");
    document.getElementById("passwordDisplay").textContent = password;

    function required(value, message = "This field is required") {
        if (!value || value.trim() === "") {
            return message;
        }
        return null;
    }

    const configValidate = [
        {
            id: "name",
            validate: [required]
        },
        {
            id: "email",
            validate: [required, (value) => {
                const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return re.test(value) ? null : "Invalid email format";
            }]
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
            if (isErrorValidate) isError = true;
        });

        if (isError) return;

        const name = document.getElementById("name").value.trim();
        const email = document.getElementById("email").value.trim();
        const isBlocked = document.getElementById("block").checked;

        const payload = {
            name: name,
            email: email,
            password: password,
            isBlocked: isBlocked
        };

        fetch("/staff/create", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        }).then(res => {
            if (res.ok) {
                alert("Staff created successfully!");
                closeModal(document.getElementById("modal"));
                loadStaffContentAndEvent(1);
            } else {
                alert("Failed to create staff.");
            }
        }).catch(err => {
            alert("Error: " + err.message);
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

