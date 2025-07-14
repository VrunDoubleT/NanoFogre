/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AddressDAO;
import DAOs.CartDAO;
import DAOs.CustomerDAO;
import DAOs.OrderDAO;
import DAOs.VoucherDAO;
import Models.Address;
import Models.Cart;
import Models.Customer;
import Models.Order;
import Models.OrderDetails;
import Models.Product;
import Models.Voucher;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sun.org.apache.bcel.internal.generic.AALOAD;
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
            // Nếu chưa login thì chuyển hướng về login hoặc trả về cart rỗng
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        int customerId = customer.getId();

        CartDAO dao = new CartDAO();
        // 1) Cập nhật tổng số lượng vào session mỗi lần GET
        int totalQty = dao.getTotalQuantity(customerId);
        session.setAttribute("cartQuantity", totalQty);
        List<Cart> cartItems = dao.getCartItemsByUserId(customerId);
        request.setAttribute("cartItems", cartItems);
        VoucherDAO voucherDAO = new VoucherDAO();
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForUser(customerId);
        System.out.println("Có " + (availableVouchers == null ? "null" : availableVouchers.size()) + " voucher");
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
            // Nếu chưa login thì chuyển hướng về login hoặc trả về cart rỗng
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

            case "update":
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int qtyU = Integer.parseInt(request.getParameter("quantity"));
                if (qtyU <= 0) { // Basic validation
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity must be positive.");
                    return;
                }
                dao.updateCartItemQuantity(cartId, qtyU);
                break;

            case "remove":
                int cartR = Integer.parseInt(request.getParameter("cartId"));
                dao.removeCartItem(cartR);

                int totalQty = dao.getTotalQuantity(customerId);
                session.setAttribute("cartQuantity", totalQty);
                break;

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

            case "voucher":
                VoucherDAO voucherDAO = new VoucherDAO();
                String code = request.getParameter("code");
                String subtotalParam = request.getParameter("subtotal");
                double subtotal = 0;
                try {
                    subtotal = Double.parseDouble(subtotalParam);
                } catch (Exception ex) {
                }

                Voucher voucher = voucherDAO.findByCode(code);

                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                if (voucher == null || !voucher.isIsActive() || voucher.isDestroy()) {
                    out.print("{\"valid\":false, \"message\":\"Voucher does not exist or has been locked.\"}");
                    return;
                }

                LocalDateTime now = LocalDateTime.now();
                if (now.isBefore(voucher.getValidFrom()) || now.isAfter(voucher.getValidTo())) {
                    out.print("{\"valid\":false, \"message\":\"Voucher is expired or not yet valid.\"}");
                    return;
                }

                if (subtotal < voucher.getMinValue()) {
                    out.print("{\"valid\":false, \"message\":\"Order value does not meet the minimum requirement.\"}");
                    return;
                }

                double discount = 0;
                String discountText = "";
                if ("percent".equalsIgnoreCase(voucher.getType()) || "percentage".equalsIgnoreCase(voucher.getType())) {
                    discount = subtotal * voucher.getValue() / 100.0;
                    if (discount > voucher.getMaxValue()) {
                        discount = voucher.getMaxValue();
                    }
                    discountText = "-" + String.format("%,.0f", discount) + "₫ (" + voucher.getValue() + "% off)";
                } else if ("fixed".equalsIgnoreCase(voucher.getType())) {
                    discount = voucher.getValue();
                    if (discount > voucher.getMaxValue()) {
                        discount = voucher.getMaxValue();
                    }
                    discountText = "-" + String.format("%,.0f", discount) + "₫";
                }

                out.print("{"
                        + "\"valid\":true,"
                        + "\"type\":\"" + voucher.getType() + "\","
                        + "\"discountAmount\":" + (int) discount + ","
                        + "\"discountText\":\"" + discountText + "\","
                        + "\"description\":\"" + voucher.getDescription() + "\","
                        + "\"code\":\"" + voucher.getCode() + "\""
                        + "}");
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

                // Lấy địa chỉ mặc định
                Address address = dao.getDefaultAddressByCustomerId(c.getId());
                System.out.println(address);
                // Nếu số điện thoại customer null, lấy từ địa chỉ (nếu có)
                if ((c.getPhone() == null || c.getPhone().trim().isEmpty())
                        && address != null && address.getPhone() != null && !address.getPhone().trim().isEmpty()) {
                    c.setPhone(address.getPhone());
                }

                // Lấy danh sách voucher khả dụng cho khách hàng
                List<Voucher> availableVouchers = voucherDAOs.getAvailableVouchersForUser(c.getId());

                request.setAttribute("address", address);
                request.setAttribute("customer", c);
                request.setAttribute("selectedItems", selectedItems);
                request.setAttribute("voucher", vouchers);
                request.setAttribute("availableVouchers", availableVouchers);  // <-- thêm vouchers list
                request.setAttribute("cartIdsJson", cartIdsJson);

                request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
                return;

            case "updateCustomerInfo":
                response.setContentType("application/json;charset=UTF-8");
                try ( PrintWriter outs = response.getWriter()) {
                    // 1) Lấy params

                    String addressDetails = request.getParameter("address");
                    String addressName = request.getParameter("addressName");
                    String addressPhone = request.getParameter("phone");
                    String recipientName = request.getParameter("recipientName");
                    // 2) Validate
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
                    // 3) Kiểm tra có default address chưa
                    boolean hasDefault = daos.hasDefaultAddress(custId);

                    // 4) Gọi insert hoặc update
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

                    // 5) Trả JSON kết quả
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
