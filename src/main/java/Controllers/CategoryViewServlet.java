package Controllers;

import DAOs.CategoryDAO;
import Models.Category;
import Utils.CloudinaryConfig;
import Utils.Common;
import Utils.Converter;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jdk.nashorn.internal.ir.BreakNode;

/**
 * Servlet implementation class CategoryViewServlet
 */
@WebServlet(name = "CategoryViewServlet", urlPatterns = {"/category/view"})
public class CategoryViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limit = 5; // Default limit for pagination
        CategoryDAO categoryDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "categories"; // Get type for list or pagination

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1); // Get current page
                List<Category> categories = categoryDao.getCategories(page, limit); // Get categories for the page
                request.setAttribute("categories", categories); // Set categories as request attribute
                request.setAttribute("page", page); // Set page number
                request.setAttribute("limit", limit); // Set limit per page
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/categoryTeamplate.jsp").forward(request, response); // Forward to JSP
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = categoryDao.countCategory();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":

                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/createCategoryTeamplate.jsp").forward(request, response);
                break;
            case "edit":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Category category = categoryDao.getCategoryById(categoryId);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/editCategoryTeamplate.jsp").forward(request, response);
                break;
//            case "delete":
//                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/deleteCategoryTeamplate.jsp").forward(request, response);
//                break;
//
//            case "enable":
//                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/enableCategoryTemplate.jsp").forward(request, response);
//                break;

            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Category category = new Category();

        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        CategoryDAO categoryDAO = new CategoryDAO();
        String categoryName = request.getParameter("categoryName");

        switch (type) {
            case "create":
                // Validate category name
                if (categoryName == null || categoryName.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("isSuccess", false);
                    errorResponse.put("message", "Category name is required.");

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(errorResponse));

                    return; // Exit if validation fails
                }

                // Don't set categoryId manually, let the DB auto-generate it
                category.setName(categoryName);

                // Log the category details for debugging purposes
                System.out.println("Creating category with name: " + category.getName());

                // Try to create the category
                boolean isCreated = categoryDAO.createCategory(category);

                // Log the result of category creation
                System.out.println("Category creation result: " + isCreated);

                // Prepare response
                Map<String, Object> returnData = new HashMap<>();
                returnData.put("isSuccess", isCreated);
                returnData.put("message", isCreated ? "Category created successfully" : "An error occurred while creating the category");

                // Send response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String jsonResponse = new Gson().toJson(returnData);
                response.getWriter().write(jsonResponse);
                break;

            case "update":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                category.setId(categoryId);
                category.setName(categoryName);

                boolean isUpdated = categoryDAO.updateCategory(category);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                Map<String, Object> returnDataUpdate = new HashMap<>();
                returnDataUpdate.put("isSuccess", isUpdated);
                returnDataUpdate.put("message", isUpdated ? "Category updated successfully" : "An error occurred while updating the category");

                Gson gsonUpdate = new Gson();
                String jsonUpdate = gsonUpdate.toJson(returnDataUpdate);
                response.getWriter().write(jsonUpdate);
                break;

            case "delete":
                int categoryIdToHide = Integer.parseInt(request.getParameter("categoryId"));
                boolean isHidden = categoryDAO.hideCategory(categoryIdToHide);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> returnDataDelete = new HashMap<>();
                returnDataDelete.put("isSuccess", isHidden);
                returnDataDelete.put("message", isHidden ? "The category has been successfully hidden" : "An error occurred while hide the category");
                Gson gsonDelete = new Gson();
                String jsonDelete = gsonDelete.toJson(returnDataDelete);
                response.getWriter().write(jsonDelete);
                break;

        }
    }

    @Override
    public String getServletInfo() {
        return "Category management servlet";
    }
}
