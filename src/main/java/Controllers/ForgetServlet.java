/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAOs.ForgetDAO;
import Models.Employee;
import Models.Customer;
import Utils.Common;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Modern 15
 */
@WebServlet(name = "ForgetServlet", urlPatterns = {"/forget"})
public class ForgetServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String userType = request.getParameter("userType"); // "employee" | "customer"
        if (userType == null) userType = "employee"; // default if not provided

        ForgetDAO dao = new ForgetDAO();

        switch (action) {
            case "sendCode": {
                String email = request.getParameter("email");
                if (email == null || email.trim().isEmpty()) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Please enter your email.\"}");
                    return;
                }
                if ("customer".equalsIgnoreCase(userType)) {
                    // ----- CUSTOMER -----
                    Customer cus = dao.findCustomerByEmail(email.trim());
                    if (cus == null) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Email not found!\"}");
                        return;
                    }
                    // Generate 6-digit code
                    String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
                    java.time.LocalDateTime expiredAt = java.time.LocalDateTime.now().plusMinutes(5);
                    boolean saved = dao.insertCodeCustomer(cus.getId(), code, expiredAt);

                    if (!saved) {
                        response.getWriter().write("{\"success\":false,\"message\":\"System error, please try again!\"}");
                        return;
                    }
                    String subject = "Password reset verification code";
                    String content = "Your verification code is: " + code + "\nThis code is valid for 5 minutes.";
                    String mailResult = Utils.MailUtil.sendEmail(email, subject, content);

                    if (mailResult.startsWith("Email sent")) {
                        response.getWriter().write("{\"success\":true,\"message\":\"Verification code has been sent to your email!\"}");
                    } else {
                        response.getWriter().write("{\"success\":false,\"message\":\"Failed to send email! " + mailResult + "\"}");
                    }
                } else {
                    // ----- EMPLOYEE -----
                    Employee emp = dao.findByEmail(email.trim());
                    if (emp == null) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Email not found!\"}");
                        return;
                    }
                    String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
                    java.time.LocalDateTime expiredAt = java.time.LocalDateTime.now().plusMinutes(5);
                    boolean saved = dao.insertCode(emp.getId(), code, expiredAt);

                    if (!saved) {
                        response.getWriter().write("{\"success\":false,\"message\":\"System error, please try again!\"}");
                        return;
                    }
                    String subject = "Password reset verification code";
                    String content = "Your verification code is: " + code + "\nThis code is valid for 5 minutes.";
                    String mailResult = Utils.MailUtil.sendEmail(email, subject, content);

                    if (mailResult.startsWith("Email sent")) {
                        response.getWriter().write("{\"success\":true,\"message\":\"Verification code has been sent to your email!\"}");
                    } else {
                        response.getWriter().write("{\"success\":false,\"message\":\"Failed to send email! " + mailResult + "\"}");
                    }
                }
                break;
            }
            case "verifyCode": {
                String email = request.getParameter("email");
                String code = request.getParameter("code");
                String newPassword = request.getParameter("newPassword");

                if (email == null || code == null || newPassword == null
                        || email.trim().isEmpty() || code.trim().isEmpty() || newPassword.trim().isEmpty()) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Missing information.\"}");
                    return;
                }

                if ("customer".equalsIgnoreCase(userType)) {
                    // ----- CUSTOMER -----
                    Customer cus = dao.findCustomerByEmail(email.trim());
                    if (cus == null) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Email not found.\"}");
                        return;
                    }

                    boolean validCode = dao.checkVerifyCodeCustomer(cus.getId(), code.trim());
                    if (!validCode) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired verification code.\"}");
                        return;
                    }
                    // Hash new password
                    String hashedPassword = Common.hashPassword(newPassword.trim());
                    boolean updated = dao.confirmResetPasswordCustomer(cus.getId(), hashedPassword);

                    if (updated) {
                        dao.markCodeAsUsedCustomer(cus.getId(), code.trim());
                        response.getWriter().write("{\"success\":true,\"message\":\"Password reset successfully.\"}");
                    } else {
                        response.getWriter().write("{\"success\":false,\"message\":\"Failed to update password.\"}");
                    }
                } else {
                    // ----- EMPLOYEE -----
                    Employee emp = dao.findByEmail(email.trim());
                    if (emp == null) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Email not found.\"}");
                        return;
                    }

                    boolean validCode = dao.checkVerifyCode(emp.getId(), code.trim());
                    if (!validCode) {
                        response.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired verification code.\"}");
                        return;
                    }
                    String hashedPassword = Common.hashPassword(newPassword.trim());
                    boolean updated = dao.confirmResetPassword(emp.getId(), hashedPassword);

                    if (updated) {
                        dao.markCodeAsUsed(emp.getId(), code.trim());
                        response.getWriter().write("{\"success\":true,\"message\":\"Password reset successfully.\"}");
                    } else {
                        response.getWriter().write("{\"success\":false,\"message\":\"Failed to update password.\"}");
                    }
                }
                break;
            }
            default:
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid request.\"}");
                break;
        }
    }
}
