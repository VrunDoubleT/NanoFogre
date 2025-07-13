/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAOs.AdminDAO;
import Models.Employee;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author iphon
 */
@WebServlet(name="LoginStaffServlet", urlPatterns={"/staff/auth/login"})
public class LoginStaffServlet extends HttpServlet {
   
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         request.getRequestDispatcher("/WEB-INF/employees/admins/staffLogin.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
               String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        AdminDAO ad = new AdminDAO();
        Employee emp = ad.getStaffByEmailAndPassword(email, password); 

        if (emp == null) {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/WEB-INF/employees/admins/staffLogin.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("employee", emp);
        if (remember != null && remember.equals("on")) {
            Cookie cookie = new Cookie("employee_email", email);
            cookie.setMaxAge(1 * 24 * 60 * 60); 
            response.addCookie(cookie);
        }
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
