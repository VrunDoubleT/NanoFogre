document.addEventListener("DOMContentLoaded", function () {
    const step1 = document.getElementById("step1");
    const step2 = document.getElementById("step2");
    const btnSendCode = document.getElementById("btnSendCode");
    const btnChangePassword = document.getElementById("btnChangePassword");
    const btnBack = document.getElementById("btnBack");

    const emailInput = document.getElementById("forgot-email");
    const emailError = document.getElementById("error-email");
    const codeError = document.getElementById("error-code");
    const pwdInput = document.getElementById("new-password");
    const pwdError = document.getElementById("error-password");
    const confirmInput = document.getElementById("confirm-password");
    const confirmError = document.getElementById("error-confirm");

    const codeInputs = document.querySelectorAll(".code-digit");

    if (!emailInput || !btnSendCode || !btnChangePassword || !btnBack || codeInputs.length !== 6) {
        console.log("Forgot.js skipped: not forgot password page.");
        return;
    }

    const forgotStep = localStorage.getItem("forgotStep");
    const forgotEmail = localStorage.getItem("forgotEmail");
    if (forgotStep === "verify") {
        step1.classList.add("hidden");
        step2.classList.remove("hidden");
        if (forgotEmail)
            emailInput.value = forgotEmail;
        if (codeInputs.length > 0)
            codeInputs[0].focus();
    } else {
        step1.classList.remove("hidden");
        step2.classList.add("hidden");
        if (emailInput)
            emailInput.focus();
    }

    function getCodeValue() {
        return Array.from(codeInputs).map(input => input.value).join("");
    }

    codeInputs.forEach((input, idx) => {
        input.addEventListener("input", () => {
            if (!/^\d$/.test(input.value)) {
                input.value = "";
                return;
            }
            if (idx < codeInputs.length - 1 && input.value) {
                codeInputs[idx + 1].focus();
            }
        });

        input.addEventListener("keydown", (e) => {
            if (e.key === "Backspace") {
                if (input.value === "" && idx > 0) {
                    codeInputs[idx - 1].focus();
                }
            } else if (e.key.length === 1 && !/\d/.test(e.key)) {
                e.preventDefault();
            }
        });

        input.addEventListener("paste", (e) => {
            e.preventDefault();
            let paste = (e.clipboardData || window.clipboardData).getData('text');
            const digits = paste.replace(/\D/g, '').slice(0, 6 - idx);
            for (let i = 0; i < digits.length; i++) {
                if (idx + i < codeInputs.length) {
                    codeInputs[idx + i].value = digits[i];
                }
            }
            const nextPos = idx + digits.length < codeInputs.length ? idx + digits.length : codeInputs.length - 1;
            codeInputs[nextPos].focus();
        });
    });

    btnSendCode.addEventListener("click", () => {
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

        if (!valid)
            return;

        btnSendCode.disabled = true;
        fetch("auth", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: `action=forgot&email=${encodeURIComponent(email)}`
        }).then(res => res.json())
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
                        codeInputs[0].focus();
                        localStorage.setItem("forgotStep", "verify");
                        localStorage.setItem("forgotEmail", email);
                    } else {
                        Swal.fire({icon: "error", title: "Error", text: data.message})
                                .then(() => {
                                    if (data.message && data.message.toLowerCase().includes("maximum number of resend attempts")) {
                                        step2.classList.add("hidden");
                                        step1.classList.remove("hidden");
                                        localStorage.removeItem("forgotStep");
                                        localStorage.removeItem("forgotEmail");
                                    }
                                });
                    }
                }).catch(() => {
            btnSendCode.disabled = false;
            Swal.fire({icon: "error", title: "Error", text: "Could not send request."});
        });
    });

    btnChangePassword.addEventListener("click", () => {
        let valid = true;
        const email = emailInput.value.trim();
        const code = getCodeValue().trim();
        const pwd = pwdInput.value;
        const confirm = confirmInput.value;

        if (code.length !== 6) {
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
        if (!valid)
            return;

        btnChangePassword.disabled = true;
        fetch("auth", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: `action=verifyCode&email=${encodeURIComponent(email)}&code=${encodeURIComponent(code)}&newPassword=${encodeURIComponent(pwd)}`
        }).then(res => res.json())
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
                                localStorage.removeItem("forgotStep");
                                localStorage.removeItem("forgotEmail");
                                window.location.href = "auth?action=login";
                            }
                        });
                    } else {
                        Swal.fire({icon: "error", title: "Error", text: data.message})
                                .then(() => {
                                    if (data.message && (
                                            data.message.toLowerCase().includes("too many times") ||
                                            data.message.toLowerCase().includes("request a new code")
                                            )) {
                                        step2.classList.add("hidden");
                                        step1.classList.remove("hidden");
                                        codeInputs.forEach(i => i.value = ""); // clear code input
                                        localStorage.removeItem("forgotStep");
                                        localStorage.removeItem("forgotEmail");
                                    }
                                });
                    }
                }).catch(() => {
            btnChangePassword.disabled = false;
            Swal.fire({icon: "error", text: "Could not send request."});
        });
    });

    btnBack.addEventListener("click", () => {
        step2.classList.add("hidden");
        step1.classList.remove("hidden");
        localStorage.removeItem("forgotStep");
    });

    emailInput.addEventListener("input", () => {
        if (emailInput.value.trim() && /^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emailInput.value.trim())) {
            emailError.classList.add("hidden");
        }
    });

    codeInputs.forEach(input => {
        input.addEventListener("input", () => {
            if (/^\d$/.test(input.value)) {
                codeError.classList.add("hidden");
            }
        });
    });

    pwdInput.addEventListener("input", () => {
        if (pwdInput.value.length >= 6 && isValidPassword(pwdInput.value)) {
            pwdError.classList.add("hidden");
        } else if (pwdInput.value && !isValidPassword(pwdInput.value)) {
            pwdError.textContent = "Password must not contain accents or spaces!";
            pwdError.classList.remove("hidden");
        }
        if (confirmInput.value === pwdInput.value && isValidPassword(confirmInput.value)) {
            confirmError.classList.add("hidden");
        }
    });

    confirmInput.addEventListener("input", () => {
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

function isValidPassword(pwd) {
    return /^[A-Za-z0-9!@#$%^&*()_+=\-{}\[\]:;"'<>,.?/\\|~]{6,}$/.test(pwd);
}

function togglePassword(id) {
    const input = document.getElementById(id);
    if (input)
        input.type = input.type === "password" ? "text" : "password";
}
