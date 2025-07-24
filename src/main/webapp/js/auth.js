document.addEventListener("DOMContentLoaded", function () {
    if (localStorage.getItem("registerSuccess") === "true") {
        localStorage.removeItem("registerSuccess");
        Swal.fire({
            icon: "success",
            title: "🎉 Registration Successful!",
            text: "Do you want to login now?",
            showCancelButton: true,
            confirmButtonText: "Yes",
            cancelButtonText: "No"
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "auth?action=login";
            }
        });
    }

    function getQueryParam(name) {
        const url = new URL(window.location.href);
        return url.searchParams.get(name);
    }
    const errorMsg = getQueryParam("error");
    if (errorMsg) {
        Swal.fire({
            icon: "error",
            title: "Oops!",
            text: decodeURIComponent(errorMsg)
        }).then(() => {
            const url = new URL(window.location.href);
            url.searchParams.delete("error");
            url.searchParams.delete("email");
            window.history.replaceState({}, document.title, url.pathname + url.search);
        });
    }

    // ---- validation ----
    const loginForm = document.getElementById("loginForm");
    if (loginForm) {
        const emailInput = document.getElementById("login-email");
        const passInput = document.getElementById("login-password");
        const emailError = document.getElementById("error-email");
        const passError = document.getElementById("error-password");

        loginForm.addEventListener("submit", function (e) {
            let valid = true;
            if (!emailInput.value.trim()) {
                emailError.textContent = "Please enter your email.";
                emailError.classList.remove("hidden");
                valid = false;
            } else {
                emailError.classList.add("hidden");
            }
            if (!passInput.value.trim()) {
                passError.textContent = "Please enter your password.";
                passError.classList.remove("hidden");
                valid = false;
            } else {
                passError.classList.add("hidden");
            }
            if (!valid)
                e.preventDefault();
        });

        emailInput.addEventListener("input", function () {
            if (emailInput.value.trim())
                emailError.classList.add("hidden");
        });
        passInput.addEventListener("input", function () {
            if (passInput.value.trim())
                passError.classList.add("hidden");
        });
    }

    // Register Validation
    const registerForm = document.getElementById("registerForm");
    if (registerForm) {
        const nameInput = document.getElementById("register-name");
        const emailInput = document.getElementById("register-email");
        const pwdInput = document.getElementById("register-password");
        const confirmInput = document.getElementById("confirm-password");

        const nameError = document.getElementById("error-name");
        const emailError = document.getElementById("error-email");
        const pwdError = document.getElementById("error-password");
        const confirmError = document.getElementById("error-confirm");

        registerForm.addEventListener("submit", function (e) {
            let valid = true;

            if (!nameInput.value.trim()) {
                nameError.textContent = "Please enter your full name.";
                nameError.classList.remove("hidden");
                valid = false;
            } else {
                nameError.classList.add("hidden");
            }

            if (!emailInput.value.trim()) {
                emailError.textContent = "Please enter your email.";
                emailError.classList.remove("hidden");
                valid = false;
            } else if (!/^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emailInput.value.trim())) {
                emailError.textContent = "Invalid email address.";
                emailError.classList.remove("hidden");
                valid = false;
            } else {
                emailError.classList.add("hidden");
            }

            if (!pwdInput.value.trim()) {
                pwdError.textContent = "Please enter your password.";
                pwdError.classList.remove("hidden");
                valid = false;
            } else if (pwdInput.value.trim().length < 6) {
                pwdError.textContent = "Password must be at least 6 characters!";
                pwdError.classList.remove("hidden");
                valid = false;
            } else if (!isValidPassword(pwdInput.value.trim())) {
                pwdError.textContent = "Password must not contain accents or spaces!";
                pwdError.classList.remove("hidden");
                valid = false;
            } else {
                pwdError.classList.add("hidden");
            }

            if (!confirmInput.value.trim()) {
                confirmError.textContent = "Please confirm your password.";
                confirmError.classList.remove("hidden");
                valid = false;
            } else if (!isValidPassword(confirmInput.value.trim())) {
                confirmError.textContent = "Confirmation password must not contain accents or spaces!";
                confirmError.classList.remove("hidden");
                valid = false;
            } else if (pwdInput.value !== confirmInput.value) {
                confirmError.textContent = "Passwords do not match!";
                confirmError.classList.remove("hidden");
                valid = false;
            } else {
                confirmError.classList.add("hidden");
            }

            if (!valid)
                e.preventDefault();
        });

        nameInput.addEventListener("input", function () {
            if (nameInput.value.trim())
                nameError.classList.add("hidden");
        });
        emailInput.addEventListener("input", function () {
            if (emailInput.value.trim() && /^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emailInput.value.trim()))
                emailError.classList.add("hidden");
        });
        pwdInput.addEventListener("input", function () {
            if (pwdInput.value.trim().length >= 6 && isValidPassword(pwdInput.value.trim()))
                pwdError.classList.add("hidden");
            if (confirmInput.value === pwdInput.value && isValidPassword(confirmInput.value))
                confirmError.classList.add("hidden");
        });
        confirmInput.addEventListener("input", function () {
            if (confirmInput.value === pwdInput.value && isValidPassword(confirmInput.value))
                confirmError.classList.add("hidden");
        });
    }

    // Toggle show/hide password
    window.togglePassword = function (id) {
        const input = document.getElementById(id);
        if (input) {
            input.type = input.type === "password" ? "text" : "password";
        }
    };

    // Password regex: No accent, no space
    function isValidPassword(pwd) {
        return /^[A-Za-z0-9!@#$%^&*()_+=\-{}\[\]:;"'<>,.?/\\|~]{6,}$/.test(pwd);
    }
});
document.addEventListener("DOMContentLoaded", function () {
    function getQueryParam(name) {
        const url = new URL(window.location.href);
        return url.searchParams.get(name);
    }

    const errorMsg = getQueryParam("error");
    if (errorMsg) {
        Swal.fire({
            icon: "error",
            title: "Oops!",
            text: decodeURIComponent(errorMsg)
        }).then(() => {
            const url = new URL(window.location.href);
            url.searchParams.delete("error");
            url.searchParams.delete("name");
            url.searchParams.delete("email");
            window.history.replaceState({}, document.title, url.pathname + url.search);
        });
    }
});
document.addEventListener("DOMContentLoaded", function () {
    var hiddenEmail = document.getElementById("hiddenEmail");
    if (hiddenEmail && hiddenEmail.value) {
        localStorage.setItem("registerEmail", hiddenEmail.value.trim());
        localStorage.setItem("registerStep", "verify");
    }
});