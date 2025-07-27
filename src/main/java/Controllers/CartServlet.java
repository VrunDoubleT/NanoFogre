package Controllers;

import DAOs.CartDAO;
import DAOs.ProductDAO;
import DAOs.VoucherDAO;
import Models.Address;
import Models.Cart;
import Models.Customer;
import Models.Product;
import Models.Voucher;
import Utils.Converter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/carts"})
public class CartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        ProductDAO pDao = new ProductDAO();
        CartDAO cDao = new CartDAO();
        String type = request.getParameter("type");
        Gson gson = new Gson();
        switch (type) {
            case "quantity":
                int productId = Converter.parseOption(request.getParameter("productId"), 0);
                int quantity = pDao.getQuantityByProductId(productId);
                System.out.println("Quantity: " + quantity);
                Map<String, Object> result = new HashMap<>();
                result.put("isSuccess", true);
                result.put("quantity", quantity);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = gson.toJson(result);
                response.getWriter().write(json);
                break;
            case "total":
                HttpSession session = request.getSession(false);
                Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
                if (customer == null) {
                    response.sendRedirect(request.getContextPath() + "/auth?action=login");
                    return;
                }
                int customerId = customer.getId();
                int total = cDao.getTotalQuantity(customerId);
                Map<String, Object> resultTotal = new HashMap<>();
                resultTotal.put("isSuccess", true);
                resultTotal.put("total", total);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String jsonTotal = gson.toJson(resultTotal);
                response.getWriter().write(jsonTotal);
                break;
            default:
                throw new AssertionError();
        }
    }

    public void responseJson(HttpServletResponse response, boolean isSuccess, String successMessage, String errorMessage) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> returnData = new HashMap<>();
        returnData.put("isSuccess", isSuccess);
        returnData.put("message", isSuccess ? successMessage : errorMessage);
        Gson gson = new Gson();
        String json = gson.toJson(returnData);
        response.getWriter().write(json);
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
        ProductDAO pDao = new ProductDAO();
        CartDAO cDao = new CartDAO();
        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        int customerId = customer.getId();
        String type = request.getParameter("type");
        switch (type) {
            case "add":
                int productId = Converter.parseOption(request.getParameter("productId"), 0);
                int quantity = Converter.parseOption(request.getParameter("quantity"), 0);
                int quantityOfProduct = pDao.getQuantityByProductId(productId);
                int alreadyQuantity = cDao.getCountQuantityByCustomerAndProduct(customerId, productId);
                System.out.println("Add cart");
                System.out.println("Product id: " + productId);
                System.out.println("Quantity: " + quantity);
                if (alreadyQuantity == 0) {
                    if (quantity > 0 && quantity <= quantityOfProduct) {
                        cDao.insertCartItem(customerId, productId, quantity);
                        responseJson(response, true, "Product added to cart successfully", null);
                    } else {
                        responseJson(response, false, null, "The quantity you added to your cart is invalid");
                    }
                } else {
                    if (quantity > 0 && quantity + alreadyQuantity <= quantityOfProduct) {
                        cDao.updateCartQuantityByCustomerAndProduct(customerId, productId, quantity + alreadyQuantity);
                        responseJson(response, true, "Product added to cart successfully", null);
                    } else {
                        responseJson(response, false, null, "Cannot add the product to your cart because the quantity exceeds the available stock");
                    }
                }
                break;
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

                Cart item = cDao.getCartItemById(cartId);
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

                boolean ok = cDao.updateCartItemQuantity(cartId, newQty);

                int totalQty = cDao.getTotalQuantity(customerId);
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

                Cart item = cDao.getCartItemById(cartId);
                if (item == null || item.getCustomerId() != customerId) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Cart item not found.");
                    try ( PrintWriter out = response.getWriter()) {
                        out.write(json.toString());
                    }
                    return;
                }

                boolean ok = cDao.removeCartItem(cartId);

                int totalQty = cDao.getTotalQuantity(customerId);
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

            case "purchase":
                String cartIdsJson = request.getParameter("cartIds");
                String voucherCode = request.getParameter("voucher");

                if (cartIdsJson == null || cartIdsJson.isEmpty()) {
                    request.setAttribute("errorMessage", "No items selected for purchase.");
                    request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
                    return;
                }

                Gson gson = new Gson();
                Type listType = new TypeToken<List<Integer>>() {
                }.getType();
                List<Integer> cartIdList = gson.fromJson(cartIdsJson, listType);

                Customer c = (Customer) session.getAttribute("customer");

                List<Cart> selectedItems = new ArrayList<>();
                for (Integer cartIdInt : cartIdList) {
                    Cart cartItem = cDao.getCartItemById(cartIdInt);
                    if (cartItem != null && cartItem.getCustomerId() == c.getId()) {
                        selectedItems.add(cartItem);
                    }
                }

                VoucherDAO voucherDAOs = new VoucherDAO();
                Voucher vouchers = null;
                if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                    vouchers = voucherDAOs.findByCode(voucherCode.trim());
                }

                Address address = cDao.getDefaultAddressByCustomerId(c.getId());

                if ((c.getPhone() == null || c.getPhone().trim().isEmpty())
                        && address != null && address.getPhone() != null && !address.getPhone().trim().isEmpty()) {
                    c.setPhone(address.getPhone());
                }

                request.setAttribute("address", address);
                request.setAttribute("customer", c);
                request.setAttribute("selectedItems", selectedItems);
                request.setAttribute("cartIdsJson", cartIdsJson);

                request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
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

                    System.out.println("recipientName = " + recipientName);
                    System.out.println("addressName = " + addressName);
                    System.out.println("addressDetails = " + addressDetails);
                    System.out.println("addressPhone = " + addressPhone);
                    System.out.println("customerId = " + custId);

                    boolean hasDefault = cDao.hasDefaultAddress(custId);

                    boolean ok;
                    if (hasDefault) {
                        ok = cDao.updateDefaultAddress(customerId, addressDetails, addressName, addressPhone, recipientName);
                    } else {
                        ok = cDao.insertDefaultAddress(
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
            default:
                throw new AssertionError();
        }
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
