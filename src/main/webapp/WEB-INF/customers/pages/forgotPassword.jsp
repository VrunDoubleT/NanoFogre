<%-- 
    Document   : loginPage
    Created on : Jul 5, 2025, 11:39:09 PM
    Author     : Modern 15
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Import Inter + Orbitron -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Orbitron:wght@600&display=swap" rel="stylesheet">
</head>
<body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center" style="font-family: 'Inter', sans-serif;">
    <form id="forgotForm" class="bg-white/10 backdrop-blur-md shadow-xl p-8 rounded-2xl w-full max-w-md border border-white/20 space-y-6 text-white">
        <!-- Heading dùng Orbitron cho đồng bộ -->
        <h2 class="text-3xl font-bold text-center text-blue-400" style="font-family: 'Orbitron', sans-serif;">Forgot Password</h2>

        <!-- Step 1: Enter Email -->
        <div id="step1">
            <input type="email" id="forgot-email" name="email" placeholder="Enter your email..."
                   autocomplete="off"
                   class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" required />
            <p class="mt-1 text-sm text-red-500 hidden" id="error-email"></p>
            <button type="button" id="btnSendCode"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg transition font-semibold mt-4">
                Send verification code
            </button>
        </div>

        <!-- Step 2: Enter code and new password -->
        <div id="step2" class="hidden space-y-4">
            <input type="text" id="verify-code" maxlength="6" placeholder="Verification code"
                   class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" autocomplete="off" />
            <p class="mt-1 text-sm text-red-500 hidden" id="error-code"></p>
            <div class="relative">
                <input type="password" id="new-password" placeholder="New password"
                       class="w-full px-4 py-2 pr-10 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" />
                <button type="button" onclick="togglePassword('new-password')" class="absolute right-2 top-2 text-xl hover:text-blue-400">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-password"></p>
            </div>
            <div class="relative">
                <input type="password" id="confirm-password" placeholder="Confirm new password"
                       class="w-full px-4 py-2 pr-10 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" />
                <button type="button" onclick="togglePassword('confirm-password')" class="absolute right-2 top-2 text-xl hover:text-blue-400">👁</button>
                <p class="mt-1 text-sm text-red-500 hidden" id="error-confirm"></p>
            </div>
            <button type="button" id="btnChangePassword"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg transition font-semibold">
                Change password
            </button>
            <button type="button" id="btnBack" class="w-full text-blue-400 hover:underline mt-2">← Back</button>
        </div>

        <p class="text-center text-sm mt-2">
            <a href="auth?action=login" class="text-blue-400 hover:underline">Back to login</a>
        </p>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/js/forgot.js"></script>
</body>
</html>
