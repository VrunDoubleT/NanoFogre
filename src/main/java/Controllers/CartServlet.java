/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CartDAO;
import DAOs.ProductDAO;
import DAOs.VoucherDAO;
import Models.Address;
import Models.Cart;
import Models.Customer;
import Models.Product;
import Models.Voucher;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

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

        CartDAO dao = new CartDAO();

        int totalQty = dao.getTotalQuantity(customerId);
        session.setAttribute("cartQuantity", totalQty);
        List<Cart> cartItems = dao.getCartItemsByUserId(customerId);
        request.setAttribute("cartItems", cartItems);
        VoucherDAO voucherDAO = new VoucherDAO();
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForUser(customerId);

        request.setAttribute("availableVouchers", availableVouchers);
        request.getRequestDispatcher("/WEB-INF/customers/pages/Cart.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CartDAO dao = new CartDAO();
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {

            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        int customerId = customer.getId();

        switch (action) {

            case "add":
                response.setContentType("application/json;charset=UTF-8");
                try ( PrintWriter out = response.getWriter()) {
                    int pId = Integer.parseInt(request.getParameter("productId"));
                    int qtyA = Integer.parseInt(request.getParameter("quantity"));

                    if (dao.existsCartItem(customerId, pId)) {
                        out.print("{"
                                + "\"success\":false,"
                                + "\"message\":\"This product is already in your cart.\""
                                + "}");
                        return;
                    }

                    dao.insertCartItem(customerId, pId, qtyA);

                    int totalQty = dao.getTotalQuantity(customerId);

                    session.setAttribute("cartQuantity", totalQty);

                    out.print("{"
                            + "\"success\":true,"
                            + "\"cartQuantity\":" + totalQty
                            + "}");
                } catch (Exception e) {
                    e.printStackTrace();
                    try ( PrintWriter out = response.getWriter()) {
                        String msg = e.getMessage().replace("\"", "\\\"");
                        out.print("{\"success\":false,\"message\":\"" + msg + "\"}");
                    }
                }
                return;

            case "update": {
                response.setContentType("application/json;charset=UTF-8");
                JsonObject json = new JsonObject();

        
                int cartId;
                try {
                    cartId = Integer.parseInt(request.getParameter("cartId"));
                } catch (Exception ex) {
                    cartId = -1;
                }
                int requestedQty;
                try {
                    requestedQty = Integer.parseInt(request.getParameter("quantity"));
                } catch (Exception ex) {
                    requestedQty = 1;
                }

                if (cartId <= 0) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Invalid cartId.");
                    try ( PrintWriter out = response.getWriter()) {
                        out.write(json.toString());
                    }
                    return;
                }

                Cart item = dao.getCartItemById(cartId);
                if (item == null || item.getCustomerId() != customerId) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Cart item not found.");
                    try ( PrintWriter out = response.getWriter()) {
                        out.write(json.toString());
                    }
                    return;
                }

                Product prod = item.getProduct();
                int stock = (prod != null) ? prod.getQuantity() : requestedQty;
                if (stock < 0) {
                    stock = 0;
                }

                int min = 1;
                int newQty = Math.max(min, Math.min(requestedQty, stock));

                boolean ok = dao.updateCartItemQuantity(cartId, newQty);

                int totalQty = dao.getTotalQuantity(customerId);
                request.getSession().setAttribute("cartQuantity", totalQty);

                json.addProperty("success", ok);
                json.addProperty("cartId", cartId);
                json.addProperty("quantity", newQty);
                json.addProperty("maxQuantity", stock);
                json.addProperty("cartQuantity", totalQty);
                if (newQty != requestedQty) {
                    json.addProperty("message", "Quantity adjusted to available stock (" + stock + ").");
                }

                try ( PrintWriter out = response.getWriter()) {
                    out.write(json.toString());
                }
                return;
            }

            case "remove": {
                response.setContentType("application/json;charset=UTF-8");
                JsonObject json = new JsonObject();

                int cartId;
                try {
                    cartId = Integer.parseInt(request.getParameter("cartId"));
                } catch (Exception ex) {
                    cartId = -1;
                }

                if (cartId <= 0) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Invalid cartId.");
                    try ( PrintWriter out = response.getWriter()) {
                        out.write(json.toString());
                    }
                    return;
                }

                Cart item = dao.getCartItemById(cartId);
                if (item == null || item.getCustomerId() != customerId) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Cart item not found.");
                    try ( PrintWriter out = response.getWriter()) {
                        out.write(json.toString());
                    }
                    return;
                }

                boolean ok = dao.removeCartItem(cartId);

                int totalQty = dao.getTotalQuantity(customerId);
                request.getSession().setAttribute("cartQuantity", totalQty);

                json.addProperty("success", ok);
                json.addProperty("cartId", cartId);
                json.addProperty("cartQuantity", totalQty);
                json.addProperty("message", ok ? "Item removed." : "Failed to remove item.");

                try ( PrintWriter out = response.getWriter()) {
                    out.write(json.toString());
                }
                return;
            }

            case "related":
                int excludeId = Integer.parseInt(request.getParameter("productId"));
                int brandId = Integer.parseInt(request.getParameter("brandId"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                List<Product> related = dao.getRelatedProducts(excludeId, brandId, categoryId);
                request.setAttribute("Items", related);

                List<Cart> cartItems = dao.getCartItemsByUserId(customerId);
                Set<Integer> cartProductIds = new HashSet<>();
                for (Cart cart : cartItems) {
                    cartProductIds.add(cart.getProduct().getProductId());
                }
                request.setAttribute("cartProductIds", cartProductIds);

                request.getRequestDispatcher("/WEB-INF/customers/pages/RelatedProductsFragment.jsp")
                        .forward(request, response);
                return;

            case "purchase":
                String cartIdsJson = request.getParameter("cartIds");
                String voucherCode = request.getParameter("voucher");

                if (cartIdsJson == null || cartIdsJson.isEmpty()) {
                    request.setAttribute("errorMessage", "No items selected for purchase.");
                    request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
                    return;
                }

                Gson gson = new Gson();
                Type listType = new TypeToken<List<Integer>>() {
                }.getType();
                List<Integer> cartIdList = gson.fromJson(cartIdsJson, listType);

                Customer c = (Customer) session.getAttribute("customer");

                List<Cart> selectedItems = new ArrayList<>();
                for (Integer cartIdInt : cartIdList) {
                    Cart cartItem = dao.getCartItemById(cartIdInt);
                    if (cartItem != null && cartItem.getCustomerId() == c.getId()) {
                        selectedItems.add(cartItem);
                    }
                }

                VoucherDAO voucherDAOs = new VoucherDAO();
                Voucher vouchers = null;
                if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                    vouchers = voucherDAOs.findByCode(voucherCode.trim());
                }

                Address address = dao.getDefaultAddressByCustomerId(c.getId());

                if ((c.getPhone() == null || c.getPhone().trim().isEmpty())
                        && address != null && address.getPhone() != null && !address.getPhone().trim().isEmpty()) {
                    c.setPhone(address.getPhone());
                }

                List<Voucher> availableVouchers = voucherDAOs.getAvailableVouchersForUser(c.getId());

                request.setAttribute("address", address);
                request.setAttribute("customer", c);
                request.setAttribute("selectedItems", selectedItems);
                request.setAttribute("voucher", vouchers);
                request.setAttribute("availableVouchers", availableVouchers);
                request.setAttribute("cartIdsJson", cartIdsJson);

                request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
                return;

            case "updateCustomerInfo":
                response.setContentType("application/json;charset=UTF-8");
                try ( PrintWriter outs = response.getWriter()) {

                    String addressDetails = request.getParameter("address");
                    String addressName = request.getParameter("addressName");
                    String addressPhone = request.getParameter("phone");
                    String recipientName = request.getParameter("recipientName");

                    if (recipientName == null || recipientName.trim().isEmpty()
                            || addressName == null || addressName.trim().isEmpty()
                            || addressDetails == null || addressDetails.trim().isEmpty()
                            || addressPhone == null || addressPhone.trim().isEmpty()) {
                        outs.print("{\"success\":false,\"message\":\"All fields are required.\"}");
                        return;
                    }

                    int custId = customer.getId();
                    CartDAO daos = new CartDAO();
                    System.out.println("recipientName = " + recipientName);
                    System.out.println("addressName = " + addressName);
                    System.out.println("addressDetails = " + addressDetails);
                    System.out.println("addressPhone = " + addressPhone);
                    System.out.println("customerId = " + custId);

                    boolean hasDefault = daos.hasDefaultAddress(custId);

                    boolean ok;
                    if (hasDefault) {
                        ok = daos.updateDefaultAddress(customerId, addressDetails, addressName, addressPhone, recipientName);
                    } else {
                        ok = daos.insertDefaultAddress(
                                custId,
                                addressDetails,
                                addressName,
                                addressPhone,
                                recipientName
                        );
                    }

                    if (ok) {
                        outs.print("{\"success\":true,\"message\":\"Information updated successfully.\"}");
                    } else {
                        outs.print("{\"success\":false,\"message\":\"Failed to update information.\"}");
                    }

                } catch (SQLException e) {
                    e.printStackTrace();
                    response.getWriter().print(
                            "{\"success\":false,\"message\":\""
                            + e.getMessage().replace("\"", "\\\"")
                            + "\"}"
                    );
                }
                return;

        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
