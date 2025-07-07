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
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author iphon
 */
@WebServlet(name = "ForgetServlet", urlPatterns = {"/forget"})
public class ForgetServlet extends HttpServlet {
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        ForgetDAO dao = new ForgetDAO();

        switch (action) {
            case "sendCode": {
                String email = request.getParameter("email");
                if (email == null || email.trim().isEmpty()) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Please enter your email.\"}");
                    return;
                }
                Employee emp = dao.findByEmail(email.trim());
                if (emp == null) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Email not found!\"}");
                    return;
                }

                // Tạo code random 6 số
                String code = String.valueOf((int) ((Math.random() * 900000) + 100000));
                java.time.LocalDateTime expiredAt = java.time.LocalDateTime.now().plusMinutes(5);
                boolean saved = dao.insertCode(emp.getId(), code, expiredAt);

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
                break;
            }
            case "verifyCode": {
                // Ví dụ xử lý xác nhận code + đổi mật khẩu (cần bạn triển khai)
                String email = request.getParameter("email");
                String code = request.getParameter("code");
                String newPassword = request.getParameter("newPassword");

                if (email == null || code == null || newPassword == null
                        || email.trim().isEmpty() || code.trim().isEmpty() || newPassword.trim().isEmpty()) {

                    response.getWriter().write("{\"success\":false,\"message\":\"Missing parameters.\"}");
                    return;
                }

                Employee emp = dao.findByEmail(email.trim());
                if (emp == null) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Email not found.\"}");
                    return;
                }

                boolean validCode = dao.checkVerifyCode(emp.getId(), code.trim());
                if (!validCode) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Invalid or expired code.\"}");
                    return;
                }

              
                boolean updated =dao.confirmResetPassword(emp.getId(), newPassword.trim());

                if (updated) {
                    dao.markCodeAsUsed(emp.getId(), code.trim());
                    response.getWriter().write("{\"success\":true,\"message\":\"Password changed successfully.\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to update password.\"}");
                }
                break;
            }
            default:
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid action.\"}");
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
