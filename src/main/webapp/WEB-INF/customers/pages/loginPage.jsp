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
        <title>Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&display=swap" rel="stylesheet">
    </head>
    <body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center font-[Orbitron]">
        <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="post"
              class="bg-white/10 backdrop-blur-md shadow-xl p-8 rounded-2xl w-full max-w-md border border-white/20 space-y-6 text-white">
            <input type="hidden" name="action" value="login" />
            <h2 class="text-3xl font-bold text-center text-blue-400">Login</h2>

            <c:if test="${not empty error}">
                <div id="backend-error" class="text-red-500 hidden">${error}</div>
            </c:if>

            <div>
                <input type="email" name="email" id="login-email"
                       placeholder="Email"
                       value="<c:choose>
                           <c:when test="${not empty rememberedEmail}">
                               ${rememberedEmail}
                           </c:when>
                           <c:otherwise>
                               ${param.email != null ? param.email : ''}
                           </c:otherwise>
                       </c:choose>"
                       class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" />
                <p class="mt-1 text-sm text-red-500 hidden" id="error-email"></p>
            </div>

            <div class="relative mt-2">
                <input type="password" name="password" id="login-password"
                       placeholder="Password"
                       class="w-full px-4 py-2 pr-10 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" />
                <button type="button" onclick="togglePassword('login-password')"
                        class="absolute right-2 top-2 text-xl hover:text-blue-400">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-password"></p>
            </div>

            <div class="flex justify-between text-sm text-gray-300">
                <label>
                    <input type="checkbox" name="remember" class="mr-1"
                           <c:if test="${not empty rememberedEmail}">checked</c:if>
                               > Remember me
                    </label>
                    <a href="auth?action=forgot" class="hover:text-blue-400">Forgot password?</a>
                </div>

                <button type="submit"
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg transition font-semibold">
                    Login
                </button>

                <p class="text-center text-sm">Don't have an account?
                    <a href="auth?action=register" class="text-blue-400 hover:underline">Sign up</a>
                </p>
                <p class="text-center text-sm mt-4">
                    <a href="${pageContext.request.contextPath}/" class="inline-block w-full bg-gray-600 hover:bg-gray-700 text-white py-2 rounded-lg transition font-semibold">
                    ← Back to Home
                </a>
            </p>

        </form>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="${pageContext.request.contextPath}/js/auth.js"></script>
    </body>
</html>
