/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAOs.CustomerDAO;
import DAOs.ForgetDAO;
import Models.Customer;
import Utils.Common;
import jakarta.servlet.http.Cookie;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import Utils.MailUtil;

/**
 *
 * @author Modern 15
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/AuthServlet", "/auth"})
public class AuthServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        // Get remembered email from cookie if exists
        String rememberedEmail = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("customer_email".equals(c.getName())) {
                    rememberedEmail = c.getValue();
                    break;
                }
            }
        }
        request.setAttribute("rememberedEmail", rememberedEmail);

        if ("login".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
        } else if ("forgot".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/forgotPassword.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        } else if ("verifyCode".equals(action)) {
            // Lấy email từ session
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("verifyEmail");
            if (email == null) {
                // Nếu user truy cập trực tiếp mà chưa có email trong session
                response.sendRedirect(request.getContextPath() + "/auth?action=login&error=" + java.net.URLEncoder.encode("You need to register first!", "UTF-8"));
                return;
            }
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/verifyCode.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                handleRegister(request, response);
                break;
            case "verifyEmail":
                handleVerifyEmail(request, response);
                break;
            case "forgot":
                handleForgotCustomer(request, response);
                break;
            case "verifyCode":
                handleVerifyForgotCode(request, response);
                break;
            default:
                break;
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        Customer customer = customerDAO.login(email, Common.hashPassword(password));

        if (customer != null) {
            if (!customer.isIsVerify()) {
                response.sendRedirect(request.getContextPath() + "/auth?action=login"
                        + "&error=" + java.net.URLEncoder.encode("Your email has not been verified! Please check your email and verify your account.", "UTF-8")
                        + "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                return;
            }
            if (customer.isIsBlock()) {
                response.sendRedirect(request.getContextPath() + "/auth?action=login"
                        + "&error=" + java.net.URLEncoder.encode("Your account is blocked!", "UTF-8")
                        + "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);

            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("customer_email", email);
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                response.addCookie(cookie);
            } else {
                Cookie cookie = new Cookie("customer_email", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth?action=login"
                    + "&error=" + java.net.URLEncoder.encode("Invalid email or password!", "UTF-8")
                    + "&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        String redirectBase = request.getContextPath() + "/auth?action=register"
                + "&name=" + java.net.URLEncoder.encode(name == null ? "" : name, "UTF-8")
                + "&email=" + java.net.URLEncoder.encode(email == null ? "" : email, "UTF-8");

        if (!password.equals(confirm)) {
            response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Passwords do not match!", "UTF-8"));
            return;
        }
        if (customerDAO.checkEmailExists(email)) {
            response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Email already exists!", "UTF-8"));
            return;
        }

        Customer newCustomer = new Customer();
        newCustomer.setName(name);
        newCustomer.setEmail(email);
        newCustomer.setPassword(Common.hashPassword(password));
        newCustomer.setIsBlock(false);

        if (customerDAO.register(newCustomer)) {
            Customer saved = customerDAO.findCustomerByEmail(email);
            if (saved == null) {
                response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Registration error, please try again!", "UTF-8"));
                return;
            }
            String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(10);

            ForgetDAO forgetDAO = new ForgetDAO();
            ForgetDAO.SendResult codeResult = forgetDAO.upsertCodeCustomer(saved.getId(), code, expiredAt, true);
            if (codeResult == ForgetDAO.SendResult.TOO_MANY_REQUESTS) {
                response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("You have reached the maximum number of resend attempts today. Please try again later!", "UTF-8"));
                return;
            }
            if (codeResult != ForgetDAO.SendResult.OK) {
                response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Could not save verification code, try again later!", "UTF-8"));
                return;
            }

            String subject = "Account Verification";
            String content = "Hello " + name + ",\n\nYour verification code is: " + code
                    + "\nThis code will expire in 10 minutes.\n\nThank you!";
            String mailResult = Utils.MailUtil.sendEmail(email, subject, content);

            if (!mailResult.startsWith("Email sent")) {
                response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Registration succeeded, but sending email failed. " + mailResult, "UTF-8"));
                return;
            }
            request.getSession().setAttribute("verifyEmail", email);
            response.sendRedirect(request.getContextPath() + "/auth?action=verifyCode");
        } else {
            response.sendRedirect(redirectBase + "&error=" + java.net.URLEncoder.encode("Registration failed, please try again!", "UTF-8"));
        }
    }

    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String code = request.getParameter("code");

        if (email == null || code == null || email.trim().isEmpty() || code.trim().isEmpty()) {
            request.setAttribute("error", "Missing information!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/verifyCode.jsp").forward(request, response);
            return;
        }
        Customer customer = customerDAO.findCustomerByEmail(email.trim());
        if (customer == null) {
            request.setAttribute("error", "Invalid email!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
            return;
        }
        ForgetDAO forgetDAO = new ForgetDAO();
        boolean valid = forgetDAO.checkVerifyCodeCustomer(customer.getId(), code.trim());
        if (!valid) {
            request.setAttribute("error", "Invalid or expired code!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/verifyCode.jsp").forward(request, response);
            return;
        }

        customerDAO.setVerified(customer.getId());
        forgetDAO.deleteCodeCustomer(customer.getId(), code.trim());

        request.getSession().removeAttribute("verifyEmail");

        request.getSession().setAttribute("registerSuccess", true);
        response.sendRedirect(request.getContextPath() + "/auth?action=register&justRegistered=true");
    }

    private void handleForgotCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Please enter your email.\"}");
            return;
        }
        ForgetDAO dao = new ForgetDAO();
        Customer cus = dao.findCustomerByEmail(email.trim());
        if (cus == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Email not found!\"}");
            return;
        }
        String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        ForgetDAO.SendResult result = dao.upsertCodeCustomer(cus.getId(), code, expiredAt, false);
        if (result == ForgetDAO.SendResult.TOO_MANY_REQUESTS) {
            response.getWriter().write("{\"success\":false,\"message\":\"You have reached the maximum number of resend attempts today. Please try again later!\"}");
            return;
        }
        if (result != ForgetDAO.SendResult.OK) {
            response.getWriter().write("{\"success\":false,\"message\":\"System error, please try again!\"}");
            return;
        }
        String subject = "Your password reset code";
        String content = "Your verification code: " + code + "\n\nCode will expire in 5 minutes.";
        String mailResult = Utils.MailUtil.sendEmail(email, subject, content);
        if (mailResult.startsWith("Email sent")) {
            response.getWriter().write("{\"success\":true,\"message\":\"Verification code sent to your email!\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Send mail failed! " + mailResult + "\"}");
        }
    }

    private void handleVerifyForgotCode(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String code = request.getParameter("code");
        String newPassword = request.getParameter("newPassword");

        if (email == null || code == null || newPassword == null
                || email.trim().isEmpty() || code.trim().isEmpty() || newPassword.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Missing parameters.\"}");
            return;
        }

        ForgetDAO dao = new ForgetDAO();
        Customer customer = dao.findCustomerByEmail(email.trim());
        if (customer == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Email not found.\"}");
            return;
        }

        int failedCount = dao.getFailedCount(customer.getId());
        if (failedCount >= 3) {
            response.getWriter().write("{\"success\":false,\"message\":\"You have entered the wrong code too many times. Please request a new code.\"}");
            return;
        }

        boolean validCode = dao.checkVerifyCodeCustomer(customer.getId(), code.trim());
        if (!validCode) {
            try {
                dao.incrementFailedCountForCustomer(customer.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
            failedCount = dao.getFailedCountForCustomer(customer.getId());
            if (failedCount >= 3) {
                response.getWriter().write("{\"success\":false,\"message\":\"You have entered the wrong code too many times. Please request a new code.\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired code. (" + failedCount + "/3 attempts used)\"}");
            }
            return;
        }

        String hashedPwd = Utils.Common.hashPassword(newPassword.trim());
        if (hashedPwd.equals(customer.getPassword())) {
            response.getWriter().write("{\"success\":false,\"message\":\"The new password cannot be the same as the old password.\"}");
            return;
        }

        boolean updated = dao.confirmResetPasswordCustomer(customer.getId(), hashedPwd);
        if (updated) {
            dao.deleteCodeCustomer(customer.getId(), code.trim());

            response.getWriter().write("{\"success\":true,\"message\":\"Password changed successfully.\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to update password.\"}");
        }
    }
}
