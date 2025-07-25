package Controllers;

import DAOs.OrderDAO;
import Models.Employee;
import com.google.gson.JsonObject;
import java.io.IOException;
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
@WebServlet(name = "OrderServlet", urlPatterns = {"/order/views"})
public class OrderServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
