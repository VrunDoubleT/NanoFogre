<%-- 
    Document   : adminLogin
    Created on : Jun 30, 2025, 12:03:34 PM
    Author     : Tran Thanh Van - CE181019
--%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>NanoForge Login</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                height: 100vh;
                background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                overflow: hidden;
                position: relative;
            }

            .background-video-container {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                z-index: -1;
                overflow: hidden;
            }

            .background-video-container video {
                width: 100vw;
                height: 100vh;
                object-fit: cover;
                position: absolute;
                top: 0;
                left: 0;
                z-index: -1;
                pointer-events: none;
            }

            .login-container {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 20px;
                padding: 40px;
                width: 400px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
                animation: scaleUp 2.5s ease forwards;
            }

            @keyframes scaleUp {
                from {
                    opacity: 0;
                    transform: scale(0.8);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .login-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .login-header h1 {
                color: white;
                font-size: 38px;
                font-weight: 600;
                margin-bottom: 10px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                color: #ffffff;
                font-size: 14px;
                margin-bottom: 8px;
                font-weight: 500;
            }

            .form-group input {
                width: 100%;
                padding: 12px 16px;
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 10px;
                color: #ffffff;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .form-group input:focus {
                outline: none;
                border-color: #ff6b6b;
                box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.2);
                background: rgba(255, 255, 255, 0.15);
            }

            .form-group input::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .checkbox-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .checkbox-group input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .checkbox-group label {
                color: #ffffff;
                font-size: 14px;
                cursor: pointer;
                margin: 0;
            }

            .forgot-password {
                color: #ff6b6b;
                font-size: 14px;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .forgot-password:hover {
                color: #ff8e8e;
            }

            .login-btn {
                width: 100%;
                padding: 14px;
                background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                border: none;
                border-radius: 10px;
                color: #ffffff;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }

            .login-btn:hover {
                background: linear-gradient(45deg, #ff5252, #ff7575);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
            }

            .login-btn:active {
                transform: translateY(0);
            }

            .register-link {
                text-align: center;
                color: rgba(255, 255, 255, 0.8);
                font-size: 14px;
            }

            .register-link a {
                color: #ff6b6b;
                text-decoration: none;
                font-weight: 500;
            }

            .register-link a:hover {
                color: #ff8e8e;
            }

            /* Forgot Password Popup Styles */
            .forgot-popup {
                display: none;
                position: fixed;
                z-index: 1000;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .forgot-popup.active {
                display: flex !important;
                opacity: 1;
            }

            .forgot-content {
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                border-radius: 20px;
                padding: 40px 35px;
                max-width: 420px;
                width: 90%;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                position: relative;
                transform: scale(0.9);
                transition: transform 0.3s ease;
            }

            .forgot-popup.active .forgot-content {
                transform: scale(1);
            }

            .close-btn {
                position: absolute;
                right: 20px;
                top: 20px;
                background: none;
                border: none;
                font-size: 24px;
                color: #666;
                cursor: pointer;
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }

            .close-btn:hover {
                background: rgba(255, 107, 107, 0.1);
                color: #ff6b6b;
                transform: rotate(90deg);
            }

            .forgot-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .forgot-header h2 {
                font-size: 28px;
                font-weight: 700;
                color: #1a1a2e;
                margin-bottom: 8px;
            }

            .forgot-header p {
                color: #666;
                font-size: 14px;
                margin: 0;
            }

            .step-container {
                min-height: 200px;
            }

            .form-step {
                display: none;
                animation: fadeInUp 0.4s ease forwards;
            }

            .form-step.active {
                display: block;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .forgot-form-group {
                margin-bottom: 20px;
            }

            .forgot-form-group label {
                display: block;
                color: #1a1a2e;
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .forgot-form-group input {
                width: 100%;
                padding: 14px 16px;
                border: 2px solid #e1e5e9;
                border-radius: 12px;
                font-size: 16px;
                color: #1a1a2e;
                background: #ffffff;
                transition: all 0.3s ease;
            }

            .forgot-form-group input:focus {
                outline: none;
                border-color: #ff6b6b;
                box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
                background: #fff;
            }

            .forgot-form-group input::placeholder {
                color: #999;
            }

            .forgot-btn {
                width: 100%;
                padding: 14px;
                background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                border: none;
                border-radius: 12px;
                color: #ffffff;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 15px;
                position: relative;
                overflow: hidden;
            }

            .forgot-btn:hover {
                background: linear-gradient(45deg, #ff5252, #ff7575);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
            }

            .forgot-btn:active {
                transform: translateY(0);
            }

            .forgot-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .forgot-btn:disabled:hover {
                background: #ccc;
                transform: none;
                box-shadow: none;
            }

            .forgot-error {
                min-height: 20px;
                margin-top: 10px;
                text-align: center;
                font-size: 14px;
                font-weight: 500;
                padding: 0 10px;
                line-height: 1.4;
            }

            .error-message {
                color: #e74c3c;
            }

            .success-message {
                color: #27ae60;
            }

            .info-message {
                color: #3498db;
            }

            .back-btn {
                background-color: transparent;
                border: 2px solid #ff6b6b;
                color: #ff6b6b;
                padding: 10px 20px;
                font-size: 1rem;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 600;
                display: inline-block;
            }

            .back-btn:hover {
                background-color: #ff6b6b;
                color: white;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
                transform: translateY(-2px);
            }

            .back-btn:active {
                transform: translateY(0);
                box-shadow: none;
            }

            .step-indicator {
                display: flex;
                justify-content: center;
                margin-bottom: 25px;
                gap: 10px;
            }

            .step-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #e1e5e9;
                transition: all 0.3s ease;
            }

            .step-dot.active {
                background: #ff6b6b;
                transform: scale(1.2);
            }

            .step-dot.completed {
                background: #27ae60;
            }

            @media (max-width: 480px) {
                .login-container {
                    width: 90%;
                    padding: 30px 20px;
                }

                .forgot-content {
                    padding: 30px 25px;
                    max-width: 95%;
                }

                .forgot-header h2 {
                    font-size: 24px;
                }

                .close-btn {
                    right: 15px;
                    top: 15px;
                }
            }

            /* Loading animation */
            .loading-spinner {
                display: inline-block;
                width: 16px;
                height: 16px;
                border: 2px solid #ffffff;
                border-radius: 50%;
                border-top-color: transparent;
                animation: spin 1s ease-in-out infinite;
                margin-right: 8px;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
            .otp-input {
                width: 38px;
                height: 45px;
                text-align: center;
                font-size: 1.4rem;
                border-radius: 8px;
                border: 2px solid #e1e5e9;
                background: #fff;
                margin-right: 2px;
                outline: none;
                transition: border 0.2s;
            }
            .otp-input:focus {
                border-color: #ff6b6b;
                box-shadow: 0 0 0 2px rgba(255,107,107,0.13);
            }
            @media (max-width: 480px) {
                .otp-input {
                    width: 32px;
                    height: 40px;
                    font-size:1.1rem;
                }
            }
            .otp-input.error {
                border-color: #e74c3c !important;
                background: #ffecec !important;
            }
        </style>
    </head>
    <body>
        <div class="background-video-container">          
        </div>

        <div class="login-container">
            <div class="login-header">
                <h1>Login</h1>
            </div>

            <form id="loginForm" method="post" action="${pageContext.request.contextPath}/admin/auth/login">
                <% String error = (String) request.getAttribute("error");
                    if (error != null) {%>
                <div style="
                     color: #b22222;
                     background: rgba(178, 34, 34, 0.2);
                     border-radius: 8px;
                     padding: 12px 16px;
                     margin-bottom: 18px;
                     text-align: center;
                     font-weight: 700;
                     ">
                    <%= error%>
                </div>
                <% }%>

                <div class="form-group">
                    <label for="email">Enter your email</label>
                    <input type="email" id="email" name="email" placeholder="admin@example.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Enter your password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <div class="form-options">
                    <div class="checkbox-group">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember me</label>
                    </div>
                    <a href="#" class="forgot-password" onclick="openForgotPopup(); return false;">Forgot password?</a>
                </div>

                <button type="submit" class="login-btn">Log In</button>
            </form>
        </div>

        <!-- Improved Forgot Password Popup -->
        <div id="forgot-popup" class="forgot-popup">
            <div class="forgot-content">
                <button class="close-btn" onclick="closeForgotPopup()">×</button>

                <div class="forgot-header">
                    <h2>Forgot Password?</h2>
                    <p>Don't worry, we'll help you reset it</p>
                </div>

                <div class="step-indicator">
                    <div class="step-dot active" id="step-dot-1"></div>
                    <div class="step-dot" id="step-dot-2"></div>
                </div>

                <div class="step-container">
                    <!-- Step 1: Enter Email -->
                    <div id="step-email" class="form-step active">
                        <div class="forgot-form-group">
                            <label for="forgot-email">Email Address</label>
                            <input id="forgot-email" type="email" placeholder="Enter your email address" required />
                        </div>
                        <button id="send-code-btn" class="forgot-btn" onclick="sendForgotEmail()">
                            Send Verification Code
                        </button>
                    </div>

                    <!-- Step 2: Enter Code & New Password -->
                    <div id="step-code" class="form-step">
                        <div class="forgot-form-group">
                            <label for="forgot-code">Verification Code</label>
                            <div id="otp-group" style="display:flex;gap:10px;justify-content:center;">
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                                <input type="text" inputmode="numeric" pattern="[0-9]*" maxlength="1" class="otp-input" />
                            </div>
                        </div>

                        <div class="forgot-form-group">
                            <label for="new-password">New Password</label>
                            <input id="new-password" type="password" placeholder="Enter new password" required />
                        </div>
                        <button id="verify-code-btn" class="forgot-btn" onclick="verifyCodeAndChangePass()">
                            Change Password
                        </button>
                        <button class="back-btn" onclick="goBackToEmailStep()"> Back to email</button>
                    </div>
                </div>

                <div id="forgot-error" class="forgot-error"></div>
            </div>
        </div>

        <script>
            // OTP input handler
            document.querySelectorAll('.otp-input').forEach((input, idx, arr) => {
                input.addEventListener('input', function (e) {
                    this.value = this.value.replace(/[^0-9]/g, ''); 
                    if (this.value.length === 1 && idx < arr.length - 1) {
                        arr[idx + 1].focus();
                    }
                });
                input.addEventListener('keydown', function (e) {
                    if (e.key === "Backspace" && !this.value && idx > 0) {
                        arr[idx - 1].focus();
                    }
                    if (e.key.length === 1 && !/[0-9]/.test(e.key)) {
                        e.preventDefault();
                    }
                });
                input.addEventListener('paste', function (e) {
                    e.preventDefault();
                    const paste = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '').substring(0, 6);
                    for (let i = 0; i < arr.length; i++) {
                        arr[i].value = paste[i] || '';
                    }
                    if (paste.length === 6)
                        arr[5].focus();
                    else if (paste.length > 0)
                        arr[paste.length - 1].focus();
                });
            });

            document.querySelectorAll('input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentElement.style.transform = 'translateY(-2px)';
                });
                input.addEventListener('blur', function () {
                    this.parentElement.style.transform = 'translateY(0)';
                });
            });

            function setCookie(name, value, days) {
                const d = new Date();
                d.setTime(d.getTime() + (days * 24 * 60 * 60 * 1000));
                let expires = "expires=" + d.toUTCString();
                document.cookie = name + "=" + encodeURIComponent(value) + ";" + expires + ";path=/";
            }

            function getCookie(name) {
                let decodedCookie = decodeURIComponent(document.cookie);
                let ca = decodedCookie.split(';');
                name = name + "=";
                for (let i = 0; i < ca.length; i++) {
                    let c = ca[i];
                    while (c.charAt(0) == ' ')
                        c = c.substring(1);
                    if (c.indexOf(name) == 0)
                        return c.substring(name.length, c.length);
                }
                return "";
            }

            window.addEventListener("DOMContentLoaded", function () {
                const email = getCookie("remember_email");
                const pass = getCookie("remember_pass");
                if (email && pass) {
                    document.getElementById("email").value = email;
                    document.getElementById("password").value = pass;
                    document.getElementById("remember").checked = true;
                }
            });

            document.getElementById("loginForm").addEventListener("submit", function () {
                const email = document.getElementById("email").value;
                const pass = document.getElementById("password").value;
                const remember = document.getElementById("remember").checked;
                if (remember) {
                    setCookie("remember_email", email, 1);
                    setCookie("remember_pass", pass, 1);
                } else {
                    setCookie("remember_email", "", -1);
                    setCookie("remember_pass", "", -1);
                }
            });

            function openForgotPopup() {
                const popup = document.getElementById('forgot-popup');
                popup.classList.add('active');
                resetForgotForm();
            }

            function closeForgotPopup() {
                const popup = document.getElementById('forgot-popup');
                popup.classList.remove('active');
            }

            function resetForgotForm() {
                document.getElementById('forgot-email').value = '';
                document.getElementById('forgot-code').value = '';
                document.getElementById('new-password').value = '';
                document.getElementById('forgot-error').textContent = '';

                document.getElementById('step-email').classList.add('active');
                document.getElementById('step-code').classList.remove('active');
                document.getElementById('step-dot-1').classList.add('active');
                document.getElementById('step-dot-1').classList.remove('completed');
                document.getElementById('step-dot-2').classList.remove('active');

                document.getElementById('send-code-btn').disabled = false;
                document.getElementById('verify-code-btn').disabled = false;
                document.getElementById('send-code-btn').innerHTML = 'Send Verification Code';
                document.getElementById('verify-code-btn').innerHTML = 'Change Password';
            }

            function goBackToEmailStep() {
                document.getElementById('step-email').classList.add('active');
                document.getElementById('step-code').classList.remove('active');
                document.getElementById('step-dot-1').classList.add('active');
                document.getElementById('step-dot-1').classList.remove('completed');
                document.getElementById('step-dot-2').classList.remove('active');
                document.getElementById('forgot-error').textContent = '';
            }

            function showError(message) {
                const errorDiv = document.getElementById('forgot-error');
                errorDiv.textContent = message;
                errorDiv.className = 'forgot-error error-message';
            }

            function showSuccess(message) {
                const errorDiv = document.getElementById('forgot-error');
                errorDiv.textContent = message;
                errorDiv.className = 'forgot-error success-message';
            }

            function showInfo(message) {
                const errorDiv = document.getElementById('forgot-error');
                errorDiv.textContent = message;
                errorDiv.className = 'forgot-error info-message';
            }

            function sendForgotEmail() {
                const email = document.getElementById('forgot-email').value.trim();
                const button = document.getElementById('send-code-btn');

                if (!email) {
                    showError("Please enter your email address.");
                    return;
                }

                if (!/^[\w-.]+@[\w-]+\.[a-zA-Z]{2,}$/.test(email)) {
                    showError("Please enter a valid email address.");
                    return;
                }

                button.disabled = true;
                button.innerHTML = '<span class="loading-spinner"></span>Sending...';
                showInfo("Sending verification code...");

                fetch('${pageContext.request.contextPath}/forget', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'email=' + encodeURIComponent(email) + '&action=sendCode'
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showSuccess("Verification code sent! Check your email.");

                                setTimeout(() => {
                                    document.getElementById('step-email').classList.remove('active');
                                    document.getElementById('step-code').classList.add('active');
                                    document.getElementById('step-dot-1').classList.remove('active');
                                    document.getElementById('step-dot-1').classList.add('completed');
                                    document.getElementById('step-dot-2').classList.add('active');
                                    document.getElementById('forgot-error').textContent = '';
                                }, 1500);
                            } else {
                                showError(data.message || "Failed to send verification code. Please try again.");
                            }
                        })
                        .catch(() => {
                            showError("Network error. Please check your connection and try again.");
                        })
                        .finally(() => {
                            button.disabled = false;
                            button.innerHTML = 'Send Verification Code';
                        });
            }
            
            let verifiedOTP = false;

            document.querySelectorAll('.otp-input').forEach((input, idx, arr) => {
                input.addEventListener('input', function () {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    if (this.value.length === 1 && idx < arr.length - 1)
                        arr[idx + 1].focus();
                    this.classList.remove('error');
                    const code = Array.from(arr).map(i => i.value).join('');
                    if (code.length === 6) {
                        checkOTPCode(code);
                    } else {
                        verifiedOTP = false;
                        document.getElementById('verify-code-btn').disabled = true;
                    }
                });

                input.addEventListener('keydown', function (e) {
                    if (e.key === "Backspace" && !this.value && idx > 0)
                        arr[idx - 1].focus();
                    if (e.key.length === 1 && !/[0-9]/.test(e.key))
                        e.preventDefault();
                });

                input.addEventListener('paste', function (e) {
                    e.preventDefault();
                    const paste = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '').substring(0, 6);
                    for (let i = 0; i < arr.length; i++)
                        arr[i].value = paste[i] || '';
                    const code = Array.from(arr).map(i => i.value).join('');
                    if (code.length === 6)
                        checkOTPCode(code);
                });
            });

            function checkOTPCode(code) {
                const email = document.getElementById('forgot-email').value.trim();
                if (!email) {
                    showError("Please enter your email address first.");
                    return;
                }

                showInfo("Verifying code...");
                fetch('${pageContext.request.contextPath}/forget', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'email=' + encodeURIComponent(email) +
                            '&code=' + encodeURIComponent(code) +
                            '&action=checkCode'
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showSuccess("Verification code is correct! Please enter your new password.");
                                verifiedOTP = true;
                                document.getElementById('verify-code-btn').disabled = false;
                                document.getElementById('new-password').focus();
                                document.querySelectorAll('.otp-input').forEach(i => i.classList.remove('error'));
                            } else {
                                showError(data.message || "Verification code is invalid or expired.");
                                verifiedOTP = false;
                                document.getElementById('verify-code-btn').disabled = true;
                                document.querySelectorAll('.otp-input').forEach(i => i.classList.add('error'));
                            }
                        })
                        .catch(() => {
                            showError("Network error. Please try again.");
                            verifiedOTP = false;
                            document.getElementById('verify-code-btn').disabled = true;
                            document.querySelectorAll('.otp-input').forEach(i => i.classList.add('error'));
                        });
            }


            function verifyCodeAndChangePass() {
                if (!verifiedOTP) {
                    showError("Please enter a valid verification code first.");
                    return;
                }
                const email = document.getElementById('forgot-email').value.trim();
                const code = Array.from(document.querySelectorAll('.otp-input')).map(i => i.value).join('');
                const newPass = document.getElementById('new-password').value.trim();
                const button = document.getElementById('verify-code-btn');

                if (!newPass || newPass.length < 6) {
                    showError("Please enter a new password with at least 6 characters.");
                    document.getElementById('new-password').focus();
                    return;
                }

                button.disabled = true;
                button.innerHTML = '<span class="loading-spinner"></span>Updating...';
                showInfo("Updating your password...");

                fetch('${pageContext.request.contextPath}/forget', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'email=' + encodeURIComponent(email) +
                            '&code=' + encodeURIComponent(code) +
                            '&newPassword=' + encodeURIComponent(newPass) +
                            '&action=verifyCode'
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showSuccess("Password updated successfully! You can now log in.");
                                setTimeout(() => {
                                    closeForgotPopup();
                                }, 2000);
                            } else {
                                showError(data.message || "Invalid or expired verification code.");
                            }
                        })
                        .catch(() => {
                            showError("Network error. Please try again.");
                        })
                        .finally(() => {
                            button.disabled = false;
                            button.innerHTML = 'Change Password';
                        });
            }




            // Close popup when clicking outside
            document.getElementById('forgot-popup').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeForgotPopup();
                }
            });
        </script>
    </body>
</html>