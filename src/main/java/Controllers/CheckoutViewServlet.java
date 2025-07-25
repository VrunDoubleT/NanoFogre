/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AddressDAO;
import DAOs.CartDAO;
import DAOs.OrderDAO;
import DAOs.VoucherDAO;
import Models.Address;
import Models.Cart;
import Models.Customer;
import Models.OrderStatus;
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Voucher;
import Utils.CurrencyFormatter;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.cloudinary.json.JSONArray;
import org.cloudinary.json.JSONObject;

/**
 *
 * @author iphon
 */
@WebServlet(name = "CheckoutViewServlet", urlPatterns = {"/checkout"})
public class CheckoutViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        int customerId = customer.getId();

        String cartIdsJson = request.getParameter("cartIds");
        String voucherCode = request.getParameter("voucher");

        if (cartIdsJson == null || cartIdsJson.trim().isEmpty() || cartIdsJson.equals("[]")) {
            request.setAttribute("errorMessage", "No items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        List<Integer> cartIdList = new ArrayList<>();
        try {
            Gson gson = new Gson();
            Type listType = new TypeToken<List<Integer>>() {
            }.getType();
            cartIdList = gson.fromJson(cartIdsJson, listType);
        } catch (Exception ex) {

            request.setAttribute("errorMessage", "Invalid cart data.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        if (cartIdList == null || cartIdList.isEmpty()) {
            request.setAttribute("errorMessage", "No valid items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<Cart> selectedItems = new ArrayList<>();
        for (Integer cartIdInt : cartIdList) {
            Cart cartItem = cartDAO.getCartItemById(cartIdInt);
            if (cartItem != null && cartItem.getCustomerId() == customerId) {
                selectedItems.add(cartItem);
            }
        }

        if (selectedItems.isEmpty()) {
            request.setAttribute("errorMessage", "No valid items found in your cart.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        Voucher voucher = null;
        VoucherDAO voucherDAO = new VoucherDAO();
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            voucher = voucherDAO.findByCode(voucherCode.trim());
        }

        AddressDAO addressDAO = new AddressDAO();
        Address selectedAddress = (Address) session.getAttribute("selectedAddress");
        if (selectedAddress != null) {
            try {
                Address refreshed = addressDAO.getById(selectedAddress.getId());
                if (refreshed == null || refreshed.getCustomerId() != customerId) {
                    selectedAddress = null;
                    session.removeAttribute("selectedAddress");
                } else {
                    selectedAddress = refreshed;
                }
            } catch (Exception e) {
                selectedAddress = null;
            }
        }
        if (selectedAddress == null) {
            selectedAddress = cartDAO.getDefaultAddressByCustomerId(customerId);
            if (selectedAddress != null) {
                session.setAttribute("selectedAddress", selectedAddress);
            }
        }
        Address defaultAddress = addressDAO.getDefaultAddress(customerId);
        request.setAttribute("address", defaultAddress);

        if ((customer.getPhone() == null || customer.getPhone().trim().isEmpty())
                && selectedAddress != null && selectedAddress.getPhone() != null) {
            customer.setPhone(selectedAddress.getPhone());
        }

        List<Integer> productCategoryIds = new ArrayList<>();
        for (Cart cart : selectedItems) {
            int catId = cart.getProduct().getCategory().getId();
            if (!productCategoryIds.contains(catId)) {
                productCategoryIds.add(catId);
            }
        }

        List<Address> availableAddresses = addressDAO.getAddressesByCustomerId(customerId);
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForUserByCategories(customerId, productCategoryIds);

        request.setAttribute("customer", customer);
        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("voucher", voucher);
        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("cartIdsJson", cartIdsJson);
        request.setAttribute("availableAddresses", availableAddresses);
        request.setAttribute("address", selectedAddress);

        request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
