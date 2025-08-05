<%-- 
    Document   : registerPage
    Created on : Jul 5, 2025, 11:39:09 PM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Register - Nano Forge</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
        <!-- Import Inter + Orbitron -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Orbitron:wght@600&display=swap" rel="stylesheet">
        <style>
            input[type="password"]::-ms-reveal,
            input[type="password"]::-ms-clear,
            input[type="password"]::-webkit-textfield-decoration-button {
                display: none;
            }
        </style>
    </head>
    <body class="bg-gray-100 min-h-screen flex items-center justify-center">

        <form id="registerForm" action="${pageContext.request.contextPath}/auth" method="post"
              class="bg-white shadow-xl p-8 rounded-2xl w-full max-w-md border border-gray-200 space-y-6 text-gray-800">

            <input type="hidden" name="action" value="register" />

            <h2 class="text-3xl font-bold text-center text-purple-600">Register</h2>

            <c:if test="${not empty error}">
                <div id="backend-error" class="text-red-500 text-sm text-center">${error}</div>
            </c:if>

            <!-- Full Name -->
            <div>
                <input type="text" name="name" id="register-name" placeholder="Full Name"
                       value="${param.name}" autocomplete="off"
                       class="w-full px-4 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-500 text-gray-900" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-name"></p>
            </div>

            <!-- Email -->
            <div>
                <input type="email" name="email" id="register-email" placeholder="Email" value="${param.email}"
                       class="w-full px-4 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-500 text-gray-900" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-email"></p>
            </div>

            <!-- Password -->
            <div class="relative">
                <input type="password" name="password" id="register-password" placeholder="Password"
                       class="w-full px-4 py-2 pr-10 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-500 text-gray-900" />
                <button type="button" onclick="togglePassword('register-password')"
                        class="absolute right-2 top-2 text-xl text-gray-500 hover:text-purple-600">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-password"></p>
            </div>

            <!-- Confirm Password -->
            <div class="relative">
                <input type="password" name="confirm_password" id="confirm-password" placeholder="Confirm Password"
                       class="w-full px-4 py-2 pr-10 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-500 text-gray-900" />
                <button type="button" onclick="togglePassword('confirm-password')"
                        class="absolute right-2 top-2 text-xl text-gray-500 hover:text-purple-600">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-confirm"></p>
            </div>

            <!-- Register Button -->
            <button type="submit"
                    class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 rounded-lg transition font-semibold">
                Register
            </button>

            <!-- Sign in redirect -->
            <p class="text-center text-sm text-gray-600">
                Already have an account?
                <a href="auth?action=login" class="text-purple-600 hover:underline">Sign in</a>
            </p>

            <!-- Back to Home -->
            <p class="text-center text-sm mt-4">
                <a href="${pageContext.request.contextPath}/"
                   class="inline-block w-full bg-gray-300 hover:bg-gray-400 text-gray-800 py-2 rounded-lg transition font-semibold">
                    ← Back to Home
                </a>
            </p>
        </form>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="${pageContext.request.contextPath}/js/auth.js"></script>

        <c:if test="${param.justRegistered == 'true' && sessionScope.registerSuccess == true}">
            <script>
                    localStorage.setItem("registerSuccess", "true");
            </script>
            <c:remove var="registerSuccess" scope="session"/>
        </c:if>

        <script>
            function togglePassword(id) {
                const input = document.getElementById(id);
                input.type = input.type === "password" ? "text" : "password";
            }
        </script>
    </body>
</html>

