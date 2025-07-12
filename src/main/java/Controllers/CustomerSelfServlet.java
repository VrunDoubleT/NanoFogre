/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import DAOs.OrdersDAO;
import Models.Customer;
import Models.Order;
import Models.OrderStatus;
import Utils.CloudinaryConfig;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet(name = "CustomerSelfServlet", urlPatterns = {"/customer/self"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class CustomerSelfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrdersDAO ordersDAO = new OrdersDAO();
        CustomerDAO dao = new CustomerDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "profile";

        HttpSession session = request.getSession(false);
        Customer sessionCustomer = (Customer) session.getAttribute("customer");
        int customerId = sessionCustomer.getId();
        switch (type) {
            case "profile":
                session.setAttribute("addressList", dao.getAddressesByCustomerId(sessionCustomer.getId()));
                session.setAttribute("address", dao.getAddressDefaultByCustomerId(sessionCustomer.getId()));
                request.getRequestDispatcher("/WEB-INF/customers/component/layout/customerProfileContent.jsp")
                        .forward(request, response);
                break;

            case "sidebar":
                request.getRequestDispatcher("/WEB-INF/customers/component/layout/customerSidebar.jsp")
                        .forward(request, response);
                break;

            case "order":
                try {
                    String statusRaw = request.getParameter("status");
                    Integer statusId = (statusRaw!=null && !statusRaw.isEmpty())
                                       ? Integer.parseInt(statusRaw) : null;
                    String search = request.getParameter("search");

                    List<Order> orders = ordersDAO.filterOrders(customerId, statusId, search);
                    List<OrderStatus> statusList = ordersDAO.getAllOrderStatus();
                    request.setAttribute("orders", orders);
                    request.setAttribute("orderStatusList", statusList);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("orders", new ArrayList<Order>());
                    request.setAttribute("orderStatusList", new ArrayList<OrderStatus>());
                    request.setAttribute("error", "Có lỗi khi tải danh sách đơn hàng!");
                }
                request.getRequestDispatcher(
                    "/WEB-INF/customers/component/layout/customerOrders.jsp")
                    .forward(request, response);
                break;

            case "orderDetail":
                try {
                    int orderId = Integer.parseInt(request.getParameter("id"));
                    Order order = ordersDAO.getOrderDetail(orderId, customerId);
                    request.setAttribute("order", order);
                    request.getRequestDispatcher(
                        "/WEB-INF/customers/component/layout/orderDetailModal.jsp")
                        .forward(request, response);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    response.setStatus(500);
                    response.getWriter().write("Error retrieving order details!");
                }
                break;

            case "cancelOrder":
                try {
                    int orderId = Integer.parseInt(request.getParameter("id"));
                    boolean ok = ordersDAO.cancelOrder(orderId, customerId);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":" + ok + "}");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    response.setStatus(500);
                    response.getWriter().write("{\"success\":false}");
                }
                break;

            case "checkEmail":
                String email = request.getParameter("email");
                int idCheck = sessionCustomer != null ? sessionCustomer.getId() : -1;

                if (email == null || email.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("false");
                    break;
                }

                boolean exists = dao.isEmailExistsExceptOwn(email.trim(), idCheck);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(exists));
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type") != null ? request.getParameter("type") : "";
        switch (type) {
            case "update": {
                CustomerDAO dao = new CustomerDAO();
                HttpSession session = request.getSession();
                Customer sessionCustomer = (Customer) session.getAttribute("customer");
                int customerId = sessionCustomer.getId();

                String name = request.getParameter("nameEdit");
                String email = request.getParameter("emailEdit");
                String phone = request.getParameter("phoneEdit");

                String defaultAddressIdRaw = request.getParameter("defaultAddressId");
                int defaultAddressId = (defaultAddressIdRaw != null && !defaultAddressIdRaw.isEmpty())
                        ? Integer.parseInt(defaultAddressIdRaw) : -1;

                String avatarUrl = sessionCustomer.getAvatar();
                Part avatarPart = request.getPart("avatar");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    List<Part> images = new ArrayList<>();
                    images.add(avatarPart);
                    List<String> urls = CloudinaryConfig.uploadImages(images);
                    if (!urls.isEmpty()) {
                        avatarUrl = urls.get(0);
                    }
                }

                boolean updatedCustomer = dao.updateCustomer(customerId, name, email, phone, avatarUrl);

                boolean updatedAddresses = true;
                String[] addressIdList = request.getParameterValues("addressIdList");

                if (addressIdList != null) {
                    for (String addrIdStr : addressIdList) {
                        try {
                            int addrId = Integer.parseInt(addrIdStr);
                            String recipient = request.getParameter("recipient_" + addrId);
                            String detail = request.getParameter("addressDetails_" + addrId);
                            String addrPhone = request.getParameter("phone_" + addrId);
                            boolean isDefault = (addrId == defaultAddressId);

                            if (recipient != null && detail != null && addrPhone != null
                                    && !recipient.trim().isEmpty()
                                    && !detail.trim().isEmpty()
                                    && !addrPhone.trim().isEmpty()) {

                                boolean updated = dao.updateAddress(
                                        addrId, recipient.trim(), detail.trim(), addrPhone.trim(), isDefault, customerId
                                );

                                if (!updated) {
                                    updatedAddresses = false;
                                }
                            }
                        } catch (Exception e) {
                            updatedAddresses = false;
                        }
                    }
                }

                if (updatedCustomer && updatedAddresses) {
                    Customer updated = dao.getCustomerById(customerId);
                    session.setAttribute("customer", updated);
                    session.setAttribute("address", dao.getAddressDefaultByCustomerId(customerId));
                    session.setAttribute("addressList", dao.getAddressesByCustomerId(customerId));
                    response.setStatus(200);
                } else {
                    response.setStatus(500);
                }
                break;
            }
        case "submitProductReview": {
            try {
                BufferedReader reader = request.getReader();
                Gson gson = new Gson();
                JsonObject json = gson.fromJson(reader, JsonObject.class);

                int productId = json.get("productId").getAsInt();
                int star = json.get("star").getAsInt();
                String content = json.get("content").getAsString();

                HttpSession session = request.getSession(false);
                Customer sessionCustomer = (Customer) session.getAttribute("customer");
                int customerId = sessionCustomer.getId();

                DAOs.ReviewDAO reviewDAO = new DAOs.ReviewDAO();
                boolean ok = reviewDAO.insertReview(productId, customerId, star, content);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\":" + ok + "}");
            } catch (Exception ex) {
                ex.printStackTrace();
                response.setStatus(500);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"message\":\"Server error.\"}");
            }
            break;
        }
    }
}
}
