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
        <title>Register</title>
        <script src="https://cdn.tailwindcss.com"></script>
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
    <body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center" style="font-family: 'Inter', sans-serif;">
        <form id="registerForm" action="${pageContext.request.contextPath}/auth" method="post"
              class="bg-white/10 backdrop-blur-md shadow-xl p-8 rounded-2xl w-full max-w-md border border-white/20 space-y-6 text-white">
            <input type="hidden" name="action" value="register" />
            <h2 class="text-3xl font-bold text-center text-purple-400" style="font-family: 'Orbitron', sans-serif;">Register</h2>
            <c:if test="${not empty error}">
                <div id="backend-error" class="text-red-400 text-sm text-center">${error}</div>
            </c:if>

            <div>
                <input type="text" name="name" id="register-name" placeholder="Full Name"
                       value="${param.name}" autocomplete="off"
                       class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-300" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-name"></p>
            </div>

            <div>
                <input type="email" name="email" id="register-email" placeholder="Email" value="${param.email}"
                       class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-300" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-email"></p>
            </div>

            <div class="relative">
                <input type="password" name="password" id="register-password" placeholder="Password"
                       class="w-full px-4 py-2 pr-10 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-300" />
                <button type="button" onclick="togglePassword('register-password')"
                        class="absolute right-2 top-2 text-xl hover:text-purple-400">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-password"></p>
            </div>

            <div class="relative">
                <input type="password" name="confirm_password" id="confirm-password" placeholder="Confirm Password"
                       class="w-full px-4 py-2 pr-10 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 placeholder-gray-300" />
                <button type="button" onclick="togglePassword('confirm-password')"
                        class="absolute right-2 top-2 text-xl hover:text-purple-400">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-confirm"></p>
            </div>

            <button type="submit"
                    class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 rounded-lg transition font-semibold">
                Register
            </button>

            <p class="text-center text-sm">Already have an account?
                <a href="auth?action=login" class="text-purple-400 hover:underline">Sign in</a>
            </p>
            <p class="text-center text-sm mt-4">
                <a href="${pageContext.request.contextPath}/" class="inline-block w-full bg-gray-600 hover:bg-gray-700 text-white py-2 rounded-lg transition font-semibold">
                    ← Back to Home
                </a>
            </p>
        </form>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="${pageContext.request.contextPath}/js/auth.js"></script>
        <c:if test="${param.justRegistered == 'true' && sessionScope.registerSuccess == true}">
            <script>
                    localStorage.setItem("registerSuccess", "true");
            </script>
            <c:remove var="registerSuccess" scope="session"/>
        </c:if>
    </body>
</html>

