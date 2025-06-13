package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Category;
import Models.Product;
import Models.ProductStat;
import Utils.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "AdminViewServerlet", urlPatterns = {"/admin/view"})
public class AdminViewServerlet extends HttpServlet {

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
        // MANAGE DAO
        ProductDAO pDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        // PATH THE JSP FILE
        String viewPage = request.getParameter("viewPage");
        String viewPath;
        // CHECK VIEW PAGE
        switch (viewPage) {
            case "customer":
                viewPath = "/WEB-INF/employees/components/customerComponent.jsp";
                break;
            case "product":
                viewPath = "/WEB-INF/employees/components/productComponent.jsp";
                List<Category> categories = categoryDao.getCategories();
                ProductStat productStat = pDao.getProductStat();
                request.setAttribute("productStat", productStat);
                request.setAttribute("categories", categories);
                break;
            case "dashboard":
                viewPath = "/WEB-INF/employees/components/adminDashboardComponent.jsp";
                break;
            case "brand":
                viewPath = "/WEB-INF/employees/components/brandComponent.jsp";
                break;
            case "category":
                 List<Category> categor = categoryDao.getCategories();
                request.setAttribute("categories", categor);
                viewPath = "/WEB-INF/employees/components/categoryComponent.jsp";
                break;
            case "staff":
                viewPath = "/WEB-INF/employees/components/staffComponent.jsp";
                break;
            default:
                viewPath = "/WEB-INF/employees/components/dashboard.jsp";
        }

        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}
