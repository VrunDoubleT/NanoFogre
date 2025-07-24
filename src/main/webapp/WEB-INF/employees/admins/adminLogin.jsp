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

                <div class="form-group">
                    <label for="email">Enter your email</label>
                    <input type="email" id="email" name="email" placeholder="admin@example.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Enter your password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" autocomplete="new-password" required>

                </div>

                <div class="form-options">
                    <div class="checkbox-group">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember me</label>
                    </div>               
                </div>

                <button type="submit" class="login-btn">Log In</button>
                <div id="error-message" style="color:#ff4d4f; margin-top:10px; text-align:center; min-height:22px;"></div>
            </form>
        </div>
            
   <script>
        

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

            document.getElementById("loginForm").addEventListener("submit", function (e) {
                e.preventDefault();
                const email = document.getElementById("email").value.trim();
                const password = document.getElementById("password").value.trim();
                const remember = document.getElementById("remember").checked;

                const errorDiv = document.getElementById("error-message");
                errorDiv.textContent = "";

                let params = "email=" + encodeURIComponent(email) + "&password=" + encodeURIComponent(password);
                if (remember)
                    params += "&remember=on";

                fetch('${pageContext.request.contextPath}/admin/auth/login', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: params
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {
                                if (remember) {
                                    setCookie("remember_email", email, 1);
                                    setCookie("remember_pass", password, 1);
                                } else {
                                    setCookie("remember_email", "", -1);
                                    setCookie("remember_pass", "", -1);
                                }
                                window.location.href = '${pageContext.request.contextPath}/admin/dashboard';
                            } else {
                                errorDiv.textContent = data.message || "Invalid email or password!";
                            }
                        })
                        .catch(() => {
                            errorDiv.textContent = "Network error. Please try again!";
                        });
            });

   
            window.addEventListener("DOMContentLoaded", function () {

                const email = getCookie("remember_email");
                const pass = getCookie("remember_pass");
                if (email) {
                    document.getElementById("email").value = email;
                }
                if (pass && !error) {
                    document.getElementById("password").value = pass;
                    document.getElementById("remember").checked = true;
                } else {
                    document.getElementById("password").value = "";
                    document.getElementById("remember").checked = false;
                }
            });


        </script>
    </body>
</html>