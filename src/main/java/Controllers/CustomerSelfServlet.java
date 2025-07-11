/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import Models.Customer;
import Utils.CloudinaryConfig;
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

        CustomerDAO dao = new CustomerDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "profile";

        HttpSession session = request.getSession(false);
        Customer sessionCustomer = (Customer) session.getAttribute("customer");

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
                request.getRequestDispatcher("/WEB-INF/customers/component/layout/customerOrders.jsp")
                        .forward(request, response);
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
        }
    }
}
