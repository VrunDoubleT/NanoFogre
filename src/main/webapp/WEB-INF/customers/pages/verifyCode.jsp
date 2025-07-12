<%-- 
    Document   : verifyCode
    Created on : Jul 10, 2025, 3:15:45 AM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Email Verification</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Orbitron:wght@600&display=swap" rel="stylesheet">
    </head>
    <body class="bg-gradient-to-br from-gray-900 to-gray-800 min-h-screen flex items-center justify-center" style="font-family: 'Inter', sans-serif;">
        <form id="verifyForm" method="post" action="${pageContext.request.contextPath}/auth"
              class="bg-white/10 backdrop-blur-md shadow-xl p-8 rounded-2xl w-full max-w-md border border-white/20 space-y-6 text-white">
            <input type="hidden" name="action" value="verifyEmail" />
            <input type="hidden" name="email" value="${email}" />
            <h2 class="text-3xl font-bold text-center text-blue-400" style="font-family: 'Orbitron', sans-serif;">Verify Your Email</h2>
            <p class="text-center mb-2">Enter the 6-digit code sent to your email.</p>
            <input type="text" name="code" maxlength="6" placeholder="Verification code"
                   class="w-full px-4 py-2 bg-white/20 text-white border border-white/30 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-300" autocomplete="off" required />
            <c:if test="${not empty error}">
                <div class="text-red-500 text-center">${error}</div>
            </c:if>
            <button type="submit"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-lg transition font-semibold">
                Verify
            </button>
            <p class="text-center text-sm mt-4">
                <a href="${pageContext.request.contextPath}/auth?action=login" class="text-blue-400 hover:underline">Back to login</a>
            </p>
        </form>
    </body>
</html>
