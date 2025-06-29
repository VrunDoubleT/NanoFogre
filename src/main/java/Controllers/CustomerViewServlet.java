/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import Models.Customer;
import Models.Order;
import Models.OrderDetails;
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
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet(name = "CustomerViewServlet", urlPatterns = {"/customer/view"})
public class CustomerViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int limit = 5;
        CustomerDAO cDao = new CustomerDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "clist";
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Customer> cus = cDao.getAllCustomer(page, limit);
                request.setAttribute("clist", cus);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/customer/customerTemplate.jsp").forward(request, response);
                break;
            case "detail":
                int did = Integer.parseInt(request.getParameter("id"));
                Customer item = cDao.getCustomerById(did);
                int orderCount = cDao.countOrdersByCustomerId(did);
                String address = cDao.getAddressDetailsByCustomerId(did);
                List<Order> orders = cDao.getOrdersByCustomerId(did);
                
                request.setAttribute("customer", item);
                request.setAttribute("orderCount", orderCount);
                request.setAttribute("address", address);
                request.setAttribute("orders", orders);
                
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/customer/customerDetailsTemplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = cDao.countCustomer();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "";
        CustomerDAO cDao = new CustomerDAO();

        switch (type) {
            case "block":
                int id = Integer.parseInt(request.getParameter("id"));
                boolean isBlock = Boolean.parseBoolean(request.getParameter("isBlock"));
                boolean success = cDao.updateBlockStatus(id, isBlock);
                response.setStatus(success ? 200 : 500);
                break;
            default:
                break;
        }
    }
}
