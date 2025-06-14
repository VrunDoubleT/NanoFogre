package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import DAOs.StaffDAO;
import DAOs.BrandDAO;
import Models.Category;
import Models.Product;
import Models.ProductStat;
import Models.Brand;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminViewServerlet", urlPatterns = {"/admin/view"})
public class AdminViewServerlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO pDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        StaffDAO sDao = new StaffDAO();
        BrandDAO brandDao = new BrandDAO();
        String viewPage = request.getParameter("viewPage");
        if (viewPage == null) {
            viewPage = "dashboard";
        }
        String viewPath;
        switch (viewPage) {
            case "customer":
                viewPath = "/WEB-INF/employees/components/customerComponent.jsp";
                break;
            case "category":
                 List<Category> categor = categoryDao.getCategories();
                request.setAttribute("categories", categor);
                viewPath = "/WEB-INF/employees/components/categoryComponent.jsp";
                break;
            case "staff":
                int count = sDao.countStaff();
                request.setAttribute("count", count);
                viewPath = "/WEB-INF/employees/components/staffComponent.jsp";
                break;
            case "product":
                viewPath = "/WEB-INF/employees/components/productComponent.jsp";
                List<Category> categories = categoryDao.getCategories();
                ProductStat productStat = pDao.getProductStat();
                List<Brand> brands = brandDao.getAllBrands();
                request.setAttribute("productStat", productStat);
                request.setAttribute("categories", categories);
                request.setAttribute("brands", brands);
                break;
            case "brand":
                viewPath = "/WEB-INF/employees/components/brandComponent.jsp";
                request.setAttribute("viewPath", viewPath);
                request.getRequestDispatcher("/brand").forward(request, response);
                return;
            case "dashboard":
                viewPath = "/WEB-INF/employees/components/adminDashboardComponent.jsp";
                break;
            default:
                viewPath = "/WEB-INF/employees/components/dashboard.jsp";
        }

        System.out.println("View Path: " + viewPath);
        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}
