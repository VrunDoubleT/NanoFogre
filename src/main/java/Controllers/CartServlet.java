/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CartDAO;
import DAOs.VoucherDAO;
import Models.Cart;
import Models.Product;
import Models.Voucher;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int customerId = 2;
        CartDAO dao = new CartDAO();
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
        int customerId = 2;

        switch (action) {
            case "add":
                int pId = Integer.parseInt(request.getParameter("productId"));
                int qtyA = Integer.parseInt(request.getParameter("quantity"));
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter outs = response.getWriter();
                if (qtyA <= 0) {
                    outs.print("{\"success\":false, \"message\":\"Quantity must be positive.\"}");
                    return;
                }
                try {
                    dao.addOrUpdateCartItem(customerId, pId, qtyA);
                    outs.print("{\"success\":true}");
                } catch (Exception e) {
                    outs.print("{\"success\":false, \"message\":\"Add to cart failed.\"}");
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
