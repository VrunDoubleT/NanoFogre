<%-- 
    Document   : loginPage
    Created on : Jul 5, 2025, 11:39:09 PM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login - Nano Forge</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
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
    <body class="bg-gray-100 min-h-screen flex items-center justify-center">

        <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="post"
              class="bg-white shadow-xl p-8 rounded-2xl w-full max-w-md border border-gray-200 space-y-6 text-gray-800">

            <input type="hidden" name="action" value="login" />

            <h2 class="text-3xl font-bold text-center text-blue-600">Login</h2>

            <c:if test="${not empty error}">
                <div id="backend-error" class="text-red-500">${error}</div>
            </c:if>

            <!-- Email -->
            <div>
                <input type="email" name="email" id="login-email"
                       placeholder="Email"
                       value="<c:choose>
                           <c:when test='${not empty rememberedEmail}'>
                               ${rememberedEmail}
                           </c:when>
                           <c:otherwise>
                               ${param.email != null ? param.email : ''}
                           </c:otherwise>
                       </c:choose>"
                       class="w-full px-4 py-2 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-500 text-gray-900" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-email"></p>
            </div>

            <!-- Password -->
            <div class="relative mt-2">
                <input type="password" name="password" id="login-password"
                       placeholder="Password"
                       class="w-full px-4 py-2 pr-10 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-500 text-gray-900" />
                <button type="button" onclick="togglePassword('login-password')"
                        class="absolute right-2 top-2 text-xl text-gray-500 hover:text-blue-600">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-password"></p>
            </div>

            <!-- Remember me & Forgot -->
            <div class="flex justify-between text-sm text-gray-600">
                <label>
                    <input type="checkbox" name="remember" class="mr-1"
                           <c:if test="${not empty rememberedEmail}">checked</c:if> />
                           Remember me
                    </label>
                    <a href="auth?action=forgot" class="hover:text-blue-600">Forgot password?</a>
                </div>

                <!-- Login Button -->
                <button type="submit"
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg transition font-semibold">
                    Login
                </button>

                <!-- Sign up -->
                <p class="text-center text-sm text-gray-600">
                    Don't have an account?
                    <a href="auth?action=register" class="text-blue-600 hover:underline">Sign up</a>
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

        <!-- Toggle password visibility -->
        <script>
                    function togglePassword(id) {
                        const input = document.getElementById(id);
                        input.type = input.type === "password" ? "text" : "password";
                    }
        </script>
    </body>
</html>

