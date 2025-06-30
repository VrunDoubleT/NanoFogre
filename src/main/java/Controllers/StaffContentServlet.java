package Controllers;

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
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "StaffContentServlet", urlPatterns = {"/staff/dashboard"})
public class StaffContentServlet extends HttpServlet {

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
        Employee employee = new Employee();
        employee.setRole(new Role(2, "Staff"));
        employee.setName("Vrun");
        employee.setAvatar("https://res.cloudinary.com/dk4fqvp3v/image/upload/v1749917338/82724695f4647bb11463f3ff2207f462.jpg.jpg");
        HttpSession session = request.getSession();
        session.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/employees/staff/staffLayout.jsp").forward(request, response);
    }
}
