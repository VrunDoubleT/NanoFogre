package Controllers;

import DAOs.ProductDAO;
import Models.Employee;
import Models.Role;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * THIS IS A LAYOUT OF ADMIN
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "AdminContentServlet", urlPatterns = {"/admin/dashboard"})
public class AdminContentServlet extends HttpServlet {

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
        HttpSession session = request.getSession(false);
        Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;

        if (emp == null || emp.getRole() == null || emp.getRole().getId() != 1) {
            response.sendRedirect(request.getContextPath() + "/admin/auth/login");
            return;
        }
        // show dashboard
        request.getRequestDispatcher("/WEB-INF/employees/admins/adminLayout.jsp").forward(request, response);
    }
}
