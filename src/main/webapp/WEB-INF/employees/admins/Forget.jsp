<%-- 
    Document   : Forget
    Created on : Jul 22, 2025, 7:39:12 PM
    Author     : iphon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Forgot Password - NanoForge</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
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
            .forgot-container {
                background: rgba(255, 255, 255, 0.13);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.18);
                border-radius: 22px;
                padding: 38px 36px;
                width: 400px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.24);
                animation: scaleUp 1.3s;
            }
            @keyframes scaleUp {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }
            .forgot-header {
                text-align: center;
                margin-bottom: 32px;
            }
            .forgot-header h2 {
                color: #fff;
                font-size: 32px;
                margin-bottom: 10px;
                font-weight: 700;
            }
            .forgot-header p {
                color: #fff;
                opacity: 0.75;
                font-size: 15px;
                margin: 0;
            }
            .form-step {
                display: none;
            }
            .form-step.active {
                display: block;
                animation: fadeInUp 0.6s;
            }
            @keyframes fadeInUp {
                from{
                    opacity:0;
                    transform:translateY(20px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
            .forgot-form-group {
                margin-bottom: 20px;
                width: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .forgot-form-group label {
                color: #fff;
                font-size: 15px;
                font-weight: 600;
                margin-bottom: 8px;
                margin-left: 10px;
                text-align: left;
                width: 100%;
            }
            .forgot-form-group input {

                width: 90%;
                padding: 14px 16px;
                border: 2px solid #e1e5e9;
                border-radius: 11px;
                font-size: 16px;
                color: #1a1a2e;
                background: #fff;
                transition: all 0.3s;
            }
            .forgot-form-group input:focus {
                outline: none;
                border-color: #ff6b6b;
                box-shadow: 0 0 0 3px rgba(255,107,107,0.10);
            }
            .forgot-form-group input::placeholder {
                color: #999;
            }

            .forgot-btn, .back-btn {
                width: 100%;
                margin-bottom: 0;
            }

            .button-group {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }

            .button-group .forgot-btn, .button-group .back-btn {
                width: 50%;
                margin-bottom: 0;
            }

            @media (max-width: 480px) {
                .forgot-container {
                    width: 100%;
                    padding: 20px 4px;
                }
                .forgot-header h2 {
                    font-size: 22px;
                }
                .otp-input {
                    width: 30px;
                    height: 38px;
                    font-size:1rem;
                }
                .button-group {
                    flex-direction: column;
                    gap: 8px;
                }
                .button-group .forgot-btn, .button-group .back-btn {
                    width: 100%;
                }
            }

            .forgot-btn  {
                width: 100%;
                padding: 14px;
                background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
                border: none;
                border-radius: 12px;
                color: #fff;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                margin-bottom: 15px;
                transition: all 0.3s;
            }
            .forgot-btn:hover {
                background: linear-gradient(45deg, #ff5252, #ff7575);
            }
            .forgot-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
            }
            .forgot-error {
                min-height: 20px;
                margin-top: 10px;
                text-align: center;
                font-size: 15px;
                font-weight: 500;
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
            .step-indicator {
                display: flex;
                justify-content: center;
                margin-bottom: 23px;
                gap: 10px;
            }
            .step-dot {
                width: 13px;
                height: 13px;
                border-radius: 50%;
                background: #e1e5e9;
                transition: all 0.3s;
            }
            .step-dot.active {
                background: #ff6b6b;
                transform: scale(1.2);
            }
            .step-dot.completed {
                background: #27ae60;
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
            .otp-input.error {
                border-color: #e74c3c !important;
                background: #ffecec !important;
            }
            .back-btn {
                background-color: transparent;
                border: 2px solid #ff6b6b;
                color: #ff6b6b;
                padding: 10px 20px;
                font-size: 1rem;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s;
                font-weight: 600;
                display: inline-block;
            }
            .back-btn:hover {
                background-color: #ff6b6b;
                color: white;
            }
            @media (max-width: 480px) {
                .forgot-container {
                    width: 95%;
                    padding: 26px 8px;
                }
                .forgot-header h2 {
                    font-size: 25px;
                }
                .otp-input {
                    width: 32px;
                    height: 40px;
                    font-size:1.1rem;
                }
            }
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
        </style>
    </head>
    <body>
        <div class="forgot-container">
            <div class="forgot-header">
                <h2>Forgot Password?</h2>
                <p>Don't worry, we'll help you reset it</p>
            </div>
            <div class="step-indicator">
                <div class="step-dot active" id="step-dot-1"></div>
                <div class="step-dot" id="step-dot-2"></div>
                <div class="step-dot" id="step-dot-3"></div>
            </div>
            <div class="step-container">

                <!-- Step 1: Enter Email -->
                <div id="step-email" class="form-step active">
                    <div class="forgot-form-group">
                        <label for="forgot-email">Email Address</label>
                        <input id="forgot-email" type="email" placeholder="Enter your email address" required />
                    </div>
                    <div class="button-group">
                        <button class="back-btn" onclick="window.location.href = '<%=request.getContextPath()%>/staff/auth/login'">Back to Login</button>

                        <button id="send-code-btn" class="forgot-btn" onclick="sendForgotEmail()">Send Verification Code</button>
                    </div>
                </div>

                <!-- Step 2: Enter OTP Code -->
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
                    <div class="button-group">
                        <button class="back-btn" onclick="goBackToEmailStep()">Back</button>
                        <button id="verify-code-btn" class="forgot-btn" onclick="verifyOTPCode()" disabled>Verify Code</button>
                    </div>
                </div>

                <!-- Step 3: Enter New Passwords -->
                <div id="step-password" class="form-step">
                    <div class="forgot-form-group">
                        <label for="new-password">New Password</label>
                        <input id="new-password" type="password" placeholder="Enter new password" required />
                    </div>
                    <div class="forgot-form-group">
                        <label for="confirm-password">Confirm New Password</label>
                        <input id="confirm-password" type="password" placeholder="Confirm new password" required />
                    </div>
                    <div class="button-group">
                        <button class="back-btn" onclick="goBackToCodeStep()">Back</button>
                        <button id="change-password-btn" class="forgot-btn" onclick="changePassword()">Change Password</button>
                    </div>
                </div>
            </div>
            <div id="forgot-error" class="forgot-error"></div>
        </div>
        <script>
            let wrongOTPCount = 0;
            const MAX_WRONG_OTP = 3;
            function disableOTPInputs() {
                document.querySelectorAll('.otp-input').forEach(i => {
                    i.disabled = true;
                    i.classList.add('error');
                });
                document.getElementById('verify-code-btn').disabled = true;
            }
            function enableOTPInputs() {
                document.querySelectorAll('.otp-input').forEach(i => {
                    i.disabled = false;
                    i.value = '';
                    i.classList.remove('error');
                });
                document.getElementById('verify-code-btn').disabled = false;
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
                fetch('forget', {
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
                                }, 1200);
                            } else {
                                showError(data.message || "Failed to send verification code. Please try again.");
                            }
                        })
                        .catch(() => {
                            showError("Network error. Please try again.");
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
                        document.getElementById('verify-code-btn').disabled = false;
                    } else {
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
                    if (code.length === 6) {
                        document.getElementById('verify-code-btn').disabled = false;
                    } else {
                        document.getElementById('verify-code-btn').disabled = true;
                    }
                });
            });


            function checkOTPCode(code, callback) {
                const email = document.getElementById('forgot-email').value.trim();
                if (!email) {
                    showError("Please enter your email address first.");
                    return;
                }
                showInfo("Verifying code...");
                fetch('forget', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code) + '&action=checkCode'
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                wrongOTPCount = 0;
                                showSuccess("Verification code is correct! ");
                                setTimeout(() => {
                                    document.getElementById('forgot-error').textContent = '';
                                }, 1000);
                                document.getElementById('new-password').focus();
                                document.querySelectorAll('.otp-input').forEach(i => i.classList.remove('error'));
                                verifiedOTP = true;
                                document.getElementById('verify-code-btn').disabled = false;
                                if (typeof callback === "function")
                                    callback(true);
                            } else {
                                wrongOTPCount++;
                                showError(data.message || "Verification code is invalid or expired.");
                                document.querySelectorAll('.otp-input').forEach(i => i.classList.add('error'));
                                verifiedOTP = false;
                                document.getElementById('verify-code-btn').disabled = true;
                                if (wrongOTPCount >= MAX_WRONG_OTP) {
                                    showError("You have entered the wrong code too many times. Please request a new code.");
                                    disableOTPInputs();
                                }
                                if (typeof callback === "function")
                                    callback(false);
                            }
                        })
                        .catch(() => {
                            showError("Network error. Please try again.");
                            if (typeof callback === "function")
                                callback(false);
                        });
            }


            function changePassword() {
                const email = document.getElementById('forgot-email').value.trim();
                const code = Array.from(document.querySelectorAll('.otp-input')).map(i => i.value).join('');
                const newPassword = document.getElementById('new-password').value.trim();
                const confirmPassword = document.getElementById('confirm-password').value.trim();
                const button = document.getElementById('change-password-btn');

                if (!newPassword || newPassword.length < 6) {
                    showError("New password must be at least 6 characters long.");
                    document.getElementById('new-password').focus();
                    return;
                }

                if (!confirmPassword) {
                    showError("Please confirm your new password.");
                    document.getElementById('confirm-password').focus();
                    return;
                }

                if (newPassword !== confirmPassword) {
                    showError("Passwords do not match. Please try again.");
                    document.getElementById('confirm-password').focus();
                    document.getElementById('confirm-password').select();
                    return;
                }

                button.disabled = true;
                button.innerHTML = '<span class="loading-spinner"></span>Updating...';
                showInfo("Updating your password...");

                fetch('forget', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code) + '&newPassword=' + encodeURIComponent(newPassword) + '&action=verifyCode'
                })
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                showSuccess("Password updated successfully! You can now log in.");
                                setTimeout(() => {
                                    window.location.href = '/staff/auth/login';
                                }, 2000);
                            } else {
                                showError(data.message || "Failed to update password. Please try again.");
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

            function goBackToCodeStep() {
                document.getElementById('step-code').classList.add('active');
                document.getElementById('step-password').classList.remove('active');
                document.getElementById('step-dot-2').classList.add('active');
                document.getElementById('step-dot-2').classList.remove('completed');
                document.getElementById('step-dot-3').classList.remove('active');
                clearMessage();

                document.getElementById('new-password').value = '';
                document.getElementById('confirm-password').value = '';
            }

            document.getElementById('confirm-password').addEventListener('input', function () {
                const newPassword = document.getElementById('new-password').value;
                const confirmPassword = this.value;

                if (confirmPassword && newPassword !== confirmPassword) {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#e1e5e9';
                }
            });

            function verifyOTPCode() {
                const code = Array.from(document.querySelectorAll('.otp-input')).map(i => i.value).join('');
                if (code.length !== 6) {
                    showError("Please enter the 6-digit verification code.");
                    return;
                }
                checkOTPCode(code, function (ok) {
                    if (ok) {
                        document.getElementById('step-code').classList.remove('active');
                        document.getElementById('step-password').classList.add('active');
                        document.getElementById('step-dot-2').classList.remove('active');
                        document.getElementById('step-dot-2').classList.add('completed');
                        document.getElementById('step-dot-3').classList.add('active');
                    }
                });
            }

            function goBackToEmailStep() {
                document.getElementById('step-email').classList.add('active');
                document.getElementById('step-code').classList.remove('active');
                document.getElementById('step-dot-1').classList.add('active');
                document.getElementById('step-dot-1').classList.remove('completed');
                document.getElementById('step-dot-2').classList.remove('active');
                document.getElementById('forgot-error').textContent = '';
                enableOTPInputs();
            }
        </script>
    </body>
</html>