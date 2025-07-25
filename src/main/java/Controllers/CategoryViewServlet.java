package Controllers;

import DAOs.CategoryDAO;
import Models.Category;
import Models.ProductAttribute;
import Utils.Converter;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
/**
 * Servlet implementation class CategoryViewServlet
 */
@WebServlet(name = "CategoryViewServlet", urlPatterns = {"/category/view"})
public class CategoryViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limit = 5;
        CategoryDAO categoryDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "categories";

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Category> categories = categoryDao.getCategories(page, limit);
                request.setAttribute("categories", categories);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/category/categoryTeamplate.jsp").forward(request, response); // Forward to JSP
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = categoryDao.countCategory();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":

                request.getRequestDispatcher("/WEB-INF/employees/templates/category/createCategoryTeamplate.jsp").forward(request, response);
                break;
            case "detail":
                int categoryIds = Integer.parseInt(request.getParameter("categoryId"));

                CategoryDAO categoryDAO = new CategoryDAO();
                Category categorys = categoryDAO.getCategoryById(categoryIds);
                List<ProductAttribute> attributes = categoryDAO.getAttributesByCategoryId(categoryIds);

                request.setAttribute("category", categorys);
                request.setAttribute("attributes", attributes);

                request.getRequestDispatcher("/WEB-INF/employees/templates/category/detailCategoryTeamplate.jsp")
                        .forward(request, response);
                break;

            case "edit":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Category category = categoryDao.getCategoryById(categoryId);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/WEB-INF/employees/templates/category/editCategoryTeamplate.jsp").forward(request, response);
                break;
            case "total":
                int totalCategoryCount = categoryDao.countCategory();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                response.getWriter().write("{\"total\":" + totalCategoryCount + "}");
                break;
            case "check-name":
                String checkName = request.getParameter("categoryName");
                boolean exists = categoryDao.isCategoryNameExists(checkName);
                response.setContentType("application/json");
                response.getWriter().write("{\"exists\":" + exists + "}");
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      

    }

 

    @Override
    public String getServletInfo() {
        return "Category management servlet";
    }
}
