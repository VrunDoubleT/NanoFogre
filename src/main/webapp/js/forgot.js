document.addEventListener("DOMContentLoaded", function () {
    const step1 = document.getElementById("step1");
    const step2 = document.getElementById("step2");
    const btnSendCode = document.getElementById("btnSendCode");
    const btnChangePassword = document.getElementById("btnChangePassword");
    const btnBack = document.getElementById("btnBack");

    // error elements
    const emailInput = document.getElementById("forgot-email");
    const emailError = document.getElementById("error-email");
    const codeInput = document.getElementById("verify-code");
    const codeError = document.getElementById("error-code");
    const pwdInput = document.getElementById("new-password");
    const pwdError = document.getElementById("error-password");
    const confirmInput = document.getElementById("confirm-password");
    const confirmError = document.getElementById("error-confirm");

    // Send verification code
    btnSendCode.addEventListener("click", function () {
        const email = emailInput.value.trim();
        let valid = true;
        if (!email) {
            emailError.textContent = "Please enter your email!";
            emailError.classList.remove("hidden");
            valid = false;
        } else if (!/^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
            emailError.textContent = "Invalid email format!";
            emailError.classList.remove("hidden");
            valid = false;
        } else {
            emailError.classList.add("hidden");
        }
        if (!valid) return;

        btnSendCode.disabled = true;
        // Gửi request gửi mã xác thực
        fetch("auth", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: `action=forgot&email=${encodeURIComponent(email)}`
        })
        .then(res => res.json())
        .then(data => {
            btnSendCode.disabled = false;
            if (data.success) {
                Swal.fire({
                    icon: "success",
                    title: "Code sent successfully!",
                    text: "Please check your email for the verification code.",
                    timer: 2000
                });
                step1.classList.add("hidden");
                step2.classList.remove("hidden");
            } else {
                Swal.fire({ icon: "error", title: "Error", text: data.message });
            }
        })
        .catch(() => {
            btnSendCode.disabled = false;
            Swal.fire({ icon: "error", title: "Error", text: "Could not send request." });
        });
    });

    // Change password
    btnChangePassword.addEventListener("click", function () {
        let valid = true;
        const email = emailInput.value.trim();
        const code = codeInput.value.trim();
        const pwd = pwdInput.value;
        const confirm = confirmInput.value;

        if (!code) {
            codeError.textContent = "Please enter the verification code!";
            codeError.classList.remove("hidden");
            valid = false;
        } else if (!/^\d{6}$/.test(code)) {
            codeError.textContent = "The code must be 6 digits!";
            codeError.classList.remove("hidden");
            valid = false;
        } else {
            codeError.classList.add("hidden");
        }
        if (!pwd) {
            pwdError.textContent = "Please enter your new password!";
            pwdError.classList.remove("hidden");
            valid = false;
        } else if (pwd.length < 6) {
            pwdError.textContent = "Password must be at least 6 characters!";
            pwdError.classList.remove("hidden");
            valid = false;
        } else if (!isValidPassword(pwd)) {
            pwdError.textContent = "Password must not contain accents or spaces!";
            pwdError.classList.remove("hidden");
            valid = false;
        } else {
            pwdError.classList.add("hidden");
        }
        if (!confirm) {
            confirmError.textContent = "Please confirm your password!";
            confirmError.classList.remove("hidden");
            valid = false;
        } else if (!isValidPassword(confirm)) {
            confirmError.textContent = "Confirmation password must not contain accents or spaces!";
            confirmError.classList.remove("hidden");
            valid = false;
        } else if (pwd !== confirm) {
            confirmError.textContent = "Passwords do not match!";
            confirmError.classList.remove("hidden");
            valid = false;
        } else {
            confirmError.classList.add("hidden");
        }
        if (!valid) return;

        btnChangePassword.disabled = true;
        // Gửi request xác thực mã và đổi mật khẩu (ĐÚNG action=verifyCode!)
        fetch("auth", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: `action=verifyCode&email=${encodeURIComponent(email)}&code=${encodeURIComponent(code)}&newPassword=${encodeURIComponent(pwd)}`
        })
        .then(res => res.json())
        .then(data => {
            btnChangePassword.disabled = false;
            if (data.success) {
                Swal.fire({
                    icon: "success",
                    title: "Success!",
                    text: "Your password has been changed. Please login again.",
                    confirmButtonText: "Login now"
                }).then(result => {
                    if (result.isConfirmed) {
                        window.location.href = "auth?action=login";
                    }
                });
            } else {
                Swal.fire({ icon: "error", title: "Error", text: data.message });
            }
        })
        .catch(() => {
            btnChangePassword.disabled = false;
            Swal.fire({ icon: "error", text: "Could not send request." });
        });
    });

    btnBack.addEventListener("click", function () {
        step2.classList.add("hidden");
        step1.classList.remove("hidden");
    });

    // Real-time validation/hide errors
    emailInput.addEventListener("input", function () {
        if (emailInput.value.trim() && /^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emailInput.value.trim())) {
            emailError.classList.add("hidden");
        }
    });
    codeInput.addEventListener("input", function () {
        if (/^\d{6}$/.test(codeInput.value.trim())) {
            codeError.classList.add("hidden");
        }
    });
    pwdInput.addEventListener("input", function () {
        if (pwdInput.value.length >= 6 && isValidPassword(pwdInput.value)) {
            pwdError.classList.add("hidden");
        } else if (pwdInput.value && !isValidPassword(pwdInput.value)) {
            pwdError.textContent = "Password must not contain accents or spaces!";
            pwdError.classList.remove("hidden");
        }
        if (confirmInput.value === pwdInput.value && isValidPassword(confirmInput.value)) confirmError.classList.add("hidden");
    });
    confirmInput.addEventListener("input", function () {
        if (confirmInput.value === pwdInput.value && isValidPassword(confirmInput.value)) {
            confirmError.classList.add("hidden");
        } else if (confirmInput.value && !isValidPassword(confirmInput.value)) {
            confirmError.textContent = "Confirmation password must not contain accents or spaces!";
            confirmError.classList.remove("hidden");
        } else if (pwdInput.value !== confirmInput.value) {
            confirmError.textContent = "Passwords do not match!";
            confirmError.classList.remove("hidden");
        }
    });
});

// Password regex: No accent, no space, at least 6 characters
function isValidPassword(pwd) {
    return /^[A-Za-z0-9!@#$%^&*()_+=\-{}\[\]:;"'<>,.?/\\|~]{6,}$/.test(pwd);
}
function togglePassword(id) {
    const input = document.getElementById(id);
    if (input) input.type = input.type === "password" ? "text" : "password";
}
