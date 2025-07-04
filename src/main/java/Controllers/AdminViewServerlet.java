package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import DAOs.StaffDAO;
import DAOs.BrandDAO;
import DAOs.OrderDAO;
import Models.Category;
import Models.Product;
import Models.ProductStat;
import Models.Brand;
import Models.Order;
import Utils.Converter;
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
        OrderDAO orderDao = new OrderDAO();
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
                int total = categoryDao.countCategory();
                request.setAttribute("total", total);
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
                int brandPage = Converter.parseOption(request.getParameter("page"), 1);
                int brandLimit = 5;
                List<Brand> brandList = brandDao.getBrands(brandPage, brandLimit);
                int totalBrands = brandDao.getTotalBrands();
                int totalBrandPages = (int) Math.ceil((double) totalBrands / brandLimit);
                request.setAttribute("brands", brandList);
                request.setAttribute("total", totalBrands);
                request.setAttribute("limit", brandLimit);
                request.setAttribute("totalPages", totalBrandPages);
                request.setAttribute("page", brandPage);
                viewPath = "/WEB-INF/employees/components/brandComponent.jsp";
                break;

            case "voucher":
                viewPath = "/WEB-INF/employees/components/voucherComponent.jsp";
                break;
            case "order":
                viewPath = "/WEB-INF/employees/components/orderComponent.jsp";
                List<Order> order = orderDao.getOrders();
                int totalOrder = orderDao.countOrders();
                request.setAttribute("total", totalOrder);
                request.setAttribute("orders", order);
                break;
            case "dashboard":
                request.getRequestDispatcher("/dashboard").include(request, response);
                viewPath = "/WEB-INF/employees/components/adminDashboardComponent.jsp";
                break;
            default:
                viewPath = "/WEB-INF/employees/components/adminDashboardComponent.jsp";
        }

        System.out.println("View Path: " + viewPath);
        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}
