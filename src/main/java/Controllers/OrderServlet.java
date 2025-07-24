package Controllers;

import DAOs.OrderDAO;
import Models.Employee;
import Models.Order;
import Models.OrderDetails;
import Models.OrderStatusHistory;
import Utils.Converter;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling order view requests
 *
 * @author iphon
 */
@WebServlet(name = "OrderViewServlet", urlPatterns = {"/order/view"})
public class OrderServlet extends HttpServlet {

    private static final int DEFAULT_LIMIT = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limit = 5;
        OrderDAO orderDao = new OrderDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "orders";

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Order> order = orderDao.getOrders(page, limit);
                request.setAttribute("orders", order);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/order/orderTeamplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = orderDao.countOrders();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;

            case "total":
                int totalOrderCount = orderDao.countOrders();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                break;

            case "detail":
                OrderDAO dao = new OrderDAO();
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                Order o = dao.getOrderById(orderId);
                List<OrderDetails> details = dao.getOrderDetailsByOrderId(orderId);
                List<OrderStatusHistory> historyList = dao.getOrderStatusHistory(orderId);
                System.out.println("show list hgisstory" + historyList);
                request.setAttribute("order", o);
                request.setAttribute("orderDetails", details);
                request.setAttribute("orderStatusHistory", historyList);
                request.getRequestDispatcher("/WEB-INF/employees/templates/order/orderDetailTeamplate.jsp").forward(request, response);
                break;

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;

        int updatedBy = (emp != null) ? emp.getId() : 0;
        String updaterName = (emp != null) ? emp.getName() : "System/Auto";

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
                String statusNote = request.getParameter("statusNote");

                ok = orderDao.updateOrderStatus(orderId, statusName);
                System.out.println("test u pdateby" + updatedBy);
                if (ok) {

                    if (orderDao.isExistOrderStatusHistory(orderId, statusName)) {
                        orderDao.updateOrderStatusHistory(orderId, statusName, statusNote, updatedBy);
                    } else {
                        orderDao.insertOrderStatusHistory(orderId, statusName, statusNote, updatedBy);
                    }
                    message = "Status updated & history recorded";
                } else {
                    message = "Update failed";
                }
                break;
        }

        JsonObject result = new JsonObject();
        result.addProperty("isSuccess", ok);
        result.addProperty("message", message);
        response.getWriter().write(result.toString());
    }

}