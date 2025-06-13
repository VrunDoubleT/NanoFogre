//Document : CategoryViewServlet


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Category;
import Utils.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author iphon
 */
@WebServlet(name = "CategoryViewServlet", urlPatterns = {"/category/view"})
public class CategoryViewServlet extends HttpServlet {

    /**
     * Handles the HTTP GET method to show category list and pagination
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       int limit = 5; // Default limit for pagination
        CategoryDAO categoryDao = new CategoryDAO();

        // Get the "type" parameter to distinguish between listing categories or pagination
        String type = request.getParameter("type") != null ? request.getParameter("type") : "list";

        // Handle list or pagination
        switch (type) {
            case "list":
                // Fetch all categories
                List<Category> categories = categoryDao.getCategories();
                request.setAttribute("categories", categories); // Set categories as request attribute

                // Forward the request to the category template JSP
                  request.getRequestDispatcher("/WEB-INF/employees/teamplates/categoryTeamplate.jsp").forward(request, response);
                break;

            case "pagination":
                // Pagination for categories
                int page = Converter.parseOption(request.getParameter("page"), 1); // Get page number
                int totalCategories = categoryDao.getTotalCategories(); // Get total categories count
                int totalPages = (int) Math.ceil((double) totalCategories / limit); // Calculate total pages

                request.setAttribute("total", totalCategories); // Set total categories
                request.setAttribute("totalPages", totalPages); // Set total pages
                request.setAttribute("page", page); // Set current page
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/categoryTeamplate.jsp").forward(request, response);
                break;

            default:
                break;
        }
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
