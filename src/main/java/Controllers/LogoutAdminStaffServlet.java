/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author iphon
 */
@WebServlet(name = "LogoutAdminServlet", urlPatterns = {"/logout/*"})
public class LogoutAdminStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        String redirectPath = "/";

        if (session != null) {
            Object employee = session.getAttribute("employee");

            if (employee != null) {
                // Ép kiểu để lấy role
                Models.Employee emp = (Models.Employee) employee;

                // Kiểm tra role để quyết định redirect
                if (emp.getRole().getName().equals("Administrator")) {
                    redirectPath = "/admin/auth/login";
                } else {
                    redirectPath = "/staff/auth/login";
                }
            }

            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + redirectPath);
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
