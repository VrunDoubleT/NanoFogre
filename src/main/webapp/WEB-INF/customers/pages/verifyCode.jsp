<%-- 
    Document   : verifyCode
    Created on : Jul 10, 2025, 3:15:45 AM
    Author     : Modern 15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Email Verification - Nano Forge</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/dk4fqvp3v/image/upload/v1752501574/1_1_r1trli.png">
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Orbitron:wght@600&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex items-center justify-center" style="font-family: 'Inter', sans-serif;">
        <form id="verifyForm" method="post" action="${pageContext.request.contextPath}/auth"
              class="bg-white shadow-xl p-8 rounded-2xl w-full max-w-md border border-gray-200 space-y-6 text-gray-800">

            <input type="hidden" name="action" value="verifyEmail" />
            <input type="hidden" name="email" value="${email}" id="hiddenEmail" />

            <h2 class="text-3xl font-bold text-center text-purple-600" style="font-family: 'Orbitron', sans-serif;">Verify Email</h2>
            <p class="text-center text-sm text-gray-600">Enter the 6-digit code sent to your email.</p>

            <!-- Code Inputs -->
            <div class="flex justify-center space-x-2" id="code-inputs">
                <c:forEach var="i" begin="1" end="6">
                    <input type="text" maxlength="1" pattern="[0-9]*" inputmode="numeric"
                           class="code-input w-12 h-12 text-center text-xl rounded-lg bg-white border border-gray-300 focus:ring-2 focus:ring-purple-500 text-gray-900 outline-none"
                           autocomplete="off"/>
                </c:forEach>
            </div>

            <input type="hidden" id="verify-code" name="code">

            <c:if test="${not empty error}">
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        Swal.fire({
                            icon: "error",
                            title: "Error",
                            text: "${error.replace("\"", "\\\"")}"
                        }).then(function () {
                            var msg = "${error}";
                            if (msg && msg.toLowerCase().includes("locked for 24 hours")) {
                                window.location.href = "auth?action=register";
                            }
                        });
                    });
                </script>
            </c:if>

            <button type="submit"
                    class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 rounded-lg transition font-semibold">
                Verify
            </button>

            <p class="text-center text-sm text-gray-600">
                <a href="${pageContext.request.contextPath}/auth?action=login" class="text-purple-600 hover:underline">Back to login</a>
            </p>
        </form>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var hiddenEmail = document.getElementById("hiddenEmail");
                if (hiddenEmail && hiddenEmail.value) {
                    localStorage.setItem("registerEmail", hiddenEmail.value.trim());
                    localStorage.setItem("registerStep", "verify");
                }

                const codeInputs = document.querySelectorAll('.code-input');
                const hiddenInput = document.getElementById('verify-code');
                const codeLength = codeInputs.length;

                codeInputs.forEach((input, idx) => {
                    input.addEventListener('input', () => {
                        const value = input.value;
                        if (!/^\d$/.test(value)) {
                            input.value = '';
                            return;
                        }
                        if (idx < codeLength - 1)
                            codeInputs[idx + 1].focus();
                        updateHiddenInput();
                    });

                    input.addEventListener('keydown', (e) => {
                        if (e.key === 'Backspace') {
                            if (input.value === '' && idx > 0)
                                codeInputs[idx - 1].focus();
                            setTimeout(updateHiddenInput, 0);
                        } else if (!/[0-9]/.test(e.key)) {
                            e.preventDefault();
                        }
                    });

                    input.addEventListener('paste', function (e) {
                        let paste = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '');
                        paste = paste.slice(0, codeLength - idx);
                        for (let i = 0; i < paste.length; i++) {
                            if (idx + i < codeLength)
                                codeInputs[idx + i].value = paste[i];
                        }
                        if (idx + paste.length < codeLength)
                            codeInputs[idx + paste.length].focus();
                        updateHiddenInput();
                        e.preventDefault();
                    });
                });

                function updateHiddenInput() {
                    hiddenInput.value = Array.from(codeInputs).map(inp => inp.value).join('');
                }

                const form = document.getElementById('verifyForm');
                form.addEventListener('submit', function (e) {
                    if (hiddenInput.value.length < 6 || !/^\d{6}$/.test(hiddenInput.value)) {
                        e.preventDefault();
                        Swal.fire("Oops!", "Please enter the full 6-digit code (numbers only).", "error");
                        codeInputs[0].focus();
                    }
                });

                codeInputs[0].focus();
            });
        </script>
    </body>
</html>
