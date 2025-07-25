package Controllers;

import DAOs.CartDAO;
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

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "CartViewServlet", urlPatterns = {"/cart"})
public class CartViewServlet extends HttpServlet {

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

        String action = request.getParameter("action");
        int limit = 5;
        if ("loadMore".equals(action)) {
            int page = Integer.parseInt(request.getParameter("page"));

            int offset = (page - 1) * limit;

            List<Cart> cartItems = dao.getCartItemsByUserIdPaginated(customerId, offset, limit);

            List<Map<String, Object>> cartJsonList = new ArrayList<>();
            for (Cart cart : cartItems) {
                Map<String, Object> item = new HashMap<>();
                item.put("cartId", cart.getCartId());
                item.put("quantity", cart.getQuantity());

                Map<String, Object> product = new HashMap<>();
                product.put("productId", cart.getProduct().getProductId());
                product.put("title", cart.getProduct().getTitle());
                product.put("price", cart.getProduct().getPrice());
                product.put("quantity", cart.getProduct().getQuantity());
                product.put("averageStar", cart.getProduct().getAverageStar());
                product.put("urls", cart.getProduct().getUrls());

                Map<String, Object> brand = new HashMap<>();
                brand.put("name", cart.getProduct().getBrand().getName());

                Map<String, Object> category = new HashMap<>();
                category.put("name", cart.getProduct().getCategory().getName());

                product.put("brand", brand);
                product.put("category", category);

                item.put("product", product);

                cartJsonList.add(item);
            }

            response.setContentType("application/json;charset=UTF-8");
            new Gson().toJson(cartJsonList, response.getWriter());
            return;
        }

        String pageParam = request.getParameter("page");
        int currentPage = (pageParam != null && pageParam.matches("\\d+"))
                ? Integer.parseInt(pageParam)
                : 1;

        int offset = (currentPage - 1) * limit;

        int totalItems = dao.countCartItems(customerId);
        int totalPages = (int) Math.ceil((double) totalItems / limit);

        List<Cart> cartItems = dao.getCartItemsByUserIdPaginated(customerId, offset, limit);

        int totalQty = dao.getTotalQuantity(customerId);
        session.setAttribute("cartQuantity", totalQty);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/customers/pages/cart.jsp")
                .forward(request, response);

    }

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
    }
}
