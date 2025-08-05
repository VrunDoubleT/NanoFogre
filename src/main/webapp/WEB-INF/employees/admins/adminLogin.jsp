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
        <title>Admin Login - Nano Forge</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

    </head>
    <body>

    <div class="bg-gray-50">
        <div class="flex items-center justify-center min-h-screen">
            <div class="w-full max-w-sm bg-white rounded-2xl border border-gray-300 p-8">
                <div class="text-center mb-6 ">
                    <h1 class="text-2xl font-bold text-gray-800 ">Login</h1>
                </div>

                <form id="loginForm" method="post" action="${pageContext.request.contextPath}/admin/auth/login">
                    <div class="mb-4">
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Enter your email</label>
                        <input type="email" id="email" name="email" placeholder="admin@example.com" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
                    </div>

                    <div class="mb-4">
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Enter your password</label>
                        <input type="password" id="password" name="password" placeholder="Enter your password" autocomplete="new-password" required
                               class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm text-gray-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
                    </div>

                    <div class="flex items-center mb-6">
                        <input type="checkbox" id="remember" name="remember"
                               class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 focus:ring-2" />
                        <label for="remember" class="ml-2 text-sm text-gray-700">Remember me</label>
                    </div>

                    <button type="submit"
                            class="w-full py-3 text-white font-semibold rounded-lg bg-gradient-to-r from-red-400 to-pink-400 hover:from-red-500 hover:to-pink-500 transition-all">
                        Log In
                    </button>

                    <div id="error-message" class="text-center text-red-500 text-sm mt-3 min-h-[22px]"></div>
                </form>
            </div>
        </div>
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