package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import Utils.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "ProductViewServlet", urlPatterns = {"/product/view"})
public class ProductViewServlet extends HttpServlet {
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
        int limit = 5;
        ProductDAO pDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "item";
        int categoryId = Converter.parseOption(request.getParameter("categoryId"), 0);
        
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Category> categories = categoryDao.getCategories();
                List<Product> products = pDao.products(categoryId, page, limit);
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/productTeamplate.jsp").forward(request, response);
                break;
            case "item":
                String productId = request.getParameter("productId");
                Product product = pDao.getProductById(Integer.parseInt(productId));
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/productDetailTeamplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = pDao.getTotalPagination(categoryId);
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }
}
