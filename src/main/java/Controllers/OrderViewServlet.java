package Controllers;

import DAOs.OrderDAO;
import Models.Order;
import Models.OrderDetails;
import Utils.Converter;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for handling order view requests
 *
 * @author iphon
 */
@WebServlet(name = "OrderViewServlet", urlPatterns = {"/order/view"})
public class OrderViewServlet extends HttpServlet {

    private static final int DEFAULT_LIMIT = 5; // Default limit for pagination

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limit = 5; // Default limit for pagination
        OrderDAO orderDao = new OrderDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "orders";

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Order> order = orderDao.getOrders(page, limit);
                request.setAttribute("orders", order);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/order/orderTeamplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = orderDao.countOrders();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;

            case "total":
                int totalOrderCount = orderDao.countOrders();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                break;

            case "detail":
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                OrderDAO dao = new OrderDAO();

                Order o = dao.getOrderById(orderId);

                List<OrderDetails> details = dao.getOrderDetailsByOrderId(orderId);

                request.setAttribute("order", o);
                request.setAttribute("orderDetails", details);

                request.getRequestDispatcher(
                        "/WEB-INF/employees/teamplates/order/orderDetailTeamplate.jsp"
                ).forward(request, response);
                break;

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String type = request.getParameter("type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        OrderDAO orderDao = new OrderDAO();
        boolean ok = false;
        String message = "No action taken";
        switch (type) {
            case "updateStatus":
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String statusName = request.getParameter("statusName");
                ok = orderDao.updateOrderStatus(orderId, statusName);

                message = ok ? "Status updated" : "Update failed";
                break;
        }
        // Trả về JSON
        JsonObject result = new JsonObject();
        result.addProperty("isSuccess", ok);
        result.addProperty("message", message);
        response.getWriter().write(result.toString());
    }

}
