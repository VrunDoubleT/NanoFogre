package Controllers;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.OrderDAO;
import DAOs.ProductDAO;
import DAOs.StaffDAO;
import Models.Brand;
import Models.Category;
import Models.Employee;
import Models.Order;
import Models.ProductStat;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class StaffViewServlet extends HttpServlet {

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
        HttpSession session = request.getSession(false);
        Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;

        if (emp == null || emp.getRole() == null || emp.getRole().getId() != 2) {
            response.sendRedirect(request.getContextPath() + "/staff/auth/login");
            return;
        }

        ProductDAO pDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        OrderDAO orderDao = new OrderDAO();
        StaffDAO sDao = new StaffDAO();
        BrandDAO brandDao = new BrandDAO();
        String viewPage = request.getParameter("viewPage");
        if (viewPage == null) {
            viewPage = "dashboard";
        }
        Employee staff = sDao.getStaffById(emp.getId());
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
            case "profile":
                request.setAttribute("staff", staff);
                viewPath = "/WEB-INF/employees/components/profileComponent.jsp";
                break;
            case "header":
                viewPath = "/WEB-INF/employees/common/employeeHeader.jsp";
                break;
            case "dashboard":
                // Forward request DashboardServlet
                request.getRequestDispatcher("/dashboard").forward(request, response);
                return;
            default:
                viewPath = "/WEB-INF/employees/components/adminDashboardComponent.jsp";
        }

        System.out.println("View Path: " + viewPath);
        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}
