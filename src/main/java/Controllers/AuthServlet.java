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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("verifyEmail".equals(action)) {
            handleVerifyEmail(request, response);
        } else if ("forgot".equals(action)) {
            handleForgotCustomer(request, response); // Gửi mã về email
        } else if ("verifyCode".equals(action)) {
            handleVerifyForgotCode(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        System.out.println(Common.hashPassword(password));
        Customer customer = customerDAO.login(email, Common.hashPassword(password));

        if (customer != null) {
            // **Thêm kiểm tra đã xác thực email chưa**
            if (!customer.isIsVerify()) {
                request.setAttribute("error", "Your email has not been verified! Please check your email and verify your account.");
                request.setAttribute("rememberedEmail", email);
                request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
                return;
            }
            if (customer.isIsBlock()) {
                request.setAttribute("error", "Your account is blocked!");
                request.setAttribute("rememberedEmail", email);
                request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);

            // Set cookie if user checks "Remember me"
            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("customer_email", email);
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                response.addCookie(cookie);
            } else {
                // Remove cookie if not checked
                Cookie cookie = new Cookie("customer_email", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }

            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.setAttribute("rememberedEmail", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        request.setAttribute("name", name);
        request.setAttribute("email", email);

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
            return;
        }

        if (customerDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
            return;
        }

        Customer newCustomer = new Customer();
        newCustomer.setName(name);
        newCustomer.setEmail(email);
        newCustomer.setPassword(Common.hashPassword(password));
        newCustomer.setIsBlock(false);

        if (customerDAO.register(newCustomer)) {
            // Lấy lại Customer vừa đăng ký
            Customer saved = customerDAO.findCustomerByEmail(email);
            if (saved == null) {
                request.setAttribute("error", "Registration error, please try again!");
                request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
                return;
            }
            // Random code 6 số
            String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(10);

            // Lưu mã xác thực
            boolean savedCode = customerDAO.insertCodeCustomer(saved.getId(), code, expiredAt);
            if (!savedCode) {
                request.setAttribute("error", "Could not save verification code, try again later!");
                request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
                return;
            }

            // Gửi mail xác thực
            String subject = "Account Verification";
            String content = "Hello " + name + ",\n\nYour verification code is: " + code
                    + "\nThis code will expire in 10 minutes.\n\nThank you!";
            String mailResult = Utils.MailUtil.sendEmail(email, subject, content);

            if (!mailResult.startsWith("Email sent")) {
                request.setAttribute("error", "Registration succeeded, but sending email failed. " + mailResult);
                request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
                return;
            }

            // Sang trang nhập mã xác thực
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/verifyCode.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed, please try again!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
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

        // Sử dụng ForgetDAO để check verify code
        ForgetDAO forgetDAO = new ForgetDAO();
        boolean valid = forgetDAO.checkVerifyCodeCustomer(customer.getId(), code.trim());
        if (!valid) {
            request.setAttribute("error", "Invalid or expired code!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/verifyCode.jsp").forward(request, response);
            return;
        }

        forgetDAO.markCodeAsUsedCustomer(customer.getId(), code.trim());
        customerDAO.setVerified(customer.getId());

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
        java.time.LocalDateTime expiredAt = java.time.LocalDateTime.now().plusMinutes(5);
        boolean saved = dao.insertCodeCustomer(cus.getId(), code, expiredAt);
        if (!saved) {
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

        boolean validCode = dao.checkVerifyCodeCustomer(customer.getId(), code.trim());
        if (!validCode) {
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired code.\"}");
            return;
        }

        String hashedPwd = Utils.Common.hashPassword(newPassword.trim());
        if (hashedPwd.equals(customer.getPassword())) {
            response.getWriter().write("{\"success\":false,\"message\":\"The new password cannot be the same as the old password.\"}");
            return;
        }

        boolean updated = dao.confirmResetPasswordCustomer(customer.getId(), hashedPwd);
        if (updated) {
            dao.markCodeAsUsedCustomer(customer.getId(), code.trim());
            response.getWriter().write("{\"success\":true,\"message\":\"Password changed successfully.\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to update password.\"}");
        }
    }

}
