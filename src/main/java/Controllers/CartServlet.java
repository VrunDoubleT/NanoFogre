package Controllers;

import DAOs.CartDAO;
import DAOs.ProductDAO;
import Models.Customer;
import Utils.Converter;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

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
