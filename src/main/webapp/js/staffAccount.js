// Toggle input (basic info)
function toggleEdit(button, inputId) {
    const input = document.getElementById(inputId);
    if (!input)
        return;

    // Gender select toggle
    if (inputId === 'genderEdit') {
        input.disabled = false;
        input.classList.remove('bg-gray-100');
        input.classList.add('bg-white');
        if (input.tagName === 'SELECT') {
            input.classList.remove('appearance-none');
        }
        return;
    }

    // DOB input toggle
    if (inputId === 'dobEdit') {
        if (input.type !== 'date') {
            input.type = 'date';
            input.readOnly = false;
            input.classList.remove('bg-gray-100');
            input.classList.add('bg-white');
        }
        return;
    }

    // Default toggle for other fields
    if (input.hasAttribute('readonly')) {
        input.removeAttribute('readonly');
        input.classList.remove('bg-gray-100');
        input.classList.add('bg-white');
    }
}

function loadHeader() {
    fetch('/staff/view?viewPage=header')
            .then(res => res.text())
            .then(html => {
                document.getElementById('header').innerHTML = html;
            });
}

function initStaffProfileForm() {
    const form = document.getElementById("staffProfileForm");
    if (!form)
        return;

    const avatarInput = document.getElementById("avatar");
    const avatarPreview = document.getElementById("avatar-preview");

    if (avatarInput && avatarPreview) {
        avatarInput.addEventListener("change", function () {
            const file = this.files[0];
            if (file && file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    avatarPreview.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    }

    const id = document.getElementById("id").value;
    const nameInput = document.getElementById("nameEdit");
    const phoneInput = document.getElementById("phoneEdit");
    const dobInput = document.getElementById("dobEdit");
    const genderSelect = document.getElementById("genderEdit");
    const addressInput = document.getElementById("addressEdit");

    const nameError = document.getElementById("nameError");
    const phoneError = document.getElementById("phoneError");
    const dobError = document.getElementById("dobError");
    const genderError = document.getElementById("genderError");
    const addressError = document.getElementById("addressError");

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

    // Validate Phone
    async function validatePhone() {
        const phone = phoneInput.value.trim();
        const phoneRegex = /^\+?\d{8,15}$/;
        if (phone === "") {
            phoneError.textContent = "Phone number is required";
            phoneInput.classList.add("border-red-500");
            return false;
        }
        if (!phoneRegex.test(phone)) {
            phoneError.textContent = "Invalid phone number";
            phoneInput.classList.add("border-red-500");
            return false;
        }
        try {
            const res = await fetch(`/staff/action?type=checkPhoneExceptOwn&phone=${encodeURIComponent(phone)}&id=${id}`);
            const exists = await res.text();
            if (exists === "true") {
                phoneError.textContent = "Phone number already exists";
                phoneInput.classList.add("border-red-500");
                return false;
            }
        } catch (e) {
            phoneError.textContent = "Error checking phone number";
            phoneInput.classList.add("border-red-500");
            return false;
        }
        phoneError.textContent = "";
        phoneInput.classList.remove("border-red-500");
        phoneInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate DOB
    function validateDob() {
        const dob = dobInput.value;
        if (dob === "") {
            dobError.textContent = "Date of birth is required";
            dobInput.classList.add("border-red-500");
            return false;
        }
        const selectedDate = new Date(dob);
        const today = new Date();
        if (selectedDate > today) {
            dobError.textContent = "Date of birth cannot be in the future";
            dobInput.classList.add("border-red-500");
            return false;
        }
        dobError.textContent = "";
        dobInput.classList.remove("border-red-500");
        dobInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    // Validate address
    function validateAddress() {
        const address = addressInput.value.trim();
        if (address === "") {
            addressError.textContent = "Address is required";
            addressInput.classList.add("border-red-500");
            return false;
        }
        addressError.textContent = "";
        addressInput.classList.remove("border-red-500");
        addressInput.classList.add("ring-1", "ring-green-500");
        return true;
    }

    nameInput.onblur = validateName;
    nameInput.oninput = () => {
        nameError.textContent = "";
        nameInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    phoneInput.onblur = validatePhone;
    phoneInput.oninput = () => {
        phoneError.textContent = "";
        phoneInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    dobInput.onblur = validateDob;
    dobInput.oninput = () => {
        dobError.textContent = "";
        dobInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    addressInput.onblur = validateAddress;
    addressInput.oninput = () => {
        addressError.textContent = "";
        addressInput.classList.remove("border-red-500", "ring-1", "ring-green-500");
    };

    // Check if any value changed
    const isChanged = () => {
        const check = (input) =>
                input && !input.hasAttribute("readonly") &&
                input.value.trim() !== input.dataset.original?.trim();

        const isGenderChanged = genderSelect && !genderSelect.hasAttribute("disabled") &&
                genderSelect.value !== genderSelect.dataset.original;

        if (check(nameInput) || check(phoneInput) || check(dobInput) || check(addressInput) || isGenderChanged) return true;
                if (avatarInput?.files.length > 0) return true;
        return false;
    };

    form.addEventListener("submit", async function (e) {
        e.preventDefault();

        if (!isChanged()) {
            Toastify({
                text: "No changes detected.",
                duration: 4000,
                gravity: "top",
                position: "right",
                style: {background: "#ffa000"},
                close: true
            }).showToast();
            return;
        }

        const validName = validateName();
        const validPhone = await validatePhone();
        const validDob = validateDob();
        const validAddress = validateAddress();
        if (!validName || !validPhone || !validDob || !validAddress)
            return;
        const disabledElements = form.querySelectorAll("[disabled]");
        disabledElements.forEach(el => el.disabled = false);
        const formData = new FormData(form);
        showLoading();
        disabledElements.forEach(el => el.disabled = true);
        try {
            const res = await fetch("/profile", {
                method: "POST",
                body: formData
            });
            if (res.ok) {
                hiddenLoading();
                Toastify({
                    text: "Profile updated successfully!",
                    duration: 5000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#4caf50"},
                    close: true
                }).showToast();
                loadContent("profile");
            } else {
                Toastify({
                    text: "Failed to update profile.",
                    duration: 5000,
                    gravity: "top",
                    position: "right",
                    style: {background: "#f44336"},
                    close: true
                }).showToast();
            }
        } catch (err) {
            Toastify({
                text: "Server error!",
                duration: 5000,
                gravity: "top",
                position: "right",
                style: {background: "#f44336"},
                close: true
            }).showToast();
        }
    });
}

