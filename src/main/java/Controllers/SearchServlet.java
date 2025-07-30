package Controllers;

import DAOs.ProductDAO;
import Models.Product;
import Utils.Converter;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/searchproduct"})
public class SearchServlet extends HttpServlet {

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
            out.println("<title>Servlet SearchServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchServlet at " + request.getContextPath() + "</h1>");
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
        int limit = 20;
        ProductDAO pDao = new ProductDAO();
        String type = !request.getParameter("type").trim().isEmpty() ? request.getParameter("type").trim() : "list";

        switch (type) {
            case "list":
                String keywordToSearch = request.getParameter("keyword");
                if (keywordToSearch == null || keywordToSearch.trim().isEmpty()) {
                    request.setAttribute("products", null);
                    request.getRequestDispatcher("/WEB-INF/customers/component/products/products.jsp").forward(request, response);
                    break;
                }
                List<Product> products = pDao.getActiveProductByKeyword(keywordToSearch, 1, limit);
                request.setAttribute("products", products);
                request.getRequestDispatcher("/WEB-INF/customers/component/products/products.jsp").forward(request, response);
                break;
            case "pagination":
                int pageToPagination = Converter.parseOption(request.getParameter("page"), 1);
                String keyword = request.getParameter("keyword");
                if (keyword == null || keyword.trim().isEmpty()) {
                    request.setAttribute("total", 0);
                    request.setAttribute("limit", limit);
                    request.setAttribute("page", pageToPagination);
                    request.getRequestDispatcher("/WEB-INF/customers/common/paginationTeamplate.jsp").forward(request, response);
                }
                int total = pDao.countActiveProductByKeyword(keyword);
                request.setAttribute("total", total);
                request.setAttribute("limit", limit);
                request.setAttribute("page", pageToPagination);
                request.getRequestDispatcher("/WEB-INF/customers/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "items":
                String keywordSearch = request.getParameter("keyword");
                if (keywordSearch == null || keywordSearch.trim().isEmpty()) {
                    response.setContentType("application/json");
                    response.getWriter().write("[]");
                    return;
                }

                List<Product> productsSearch = pDao.getActiveProductByKeyword(keywordSearch, 1, 16);
                Gson gson = new Gson();
                String json = gson.toJson(productsSearch);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json);
                break;
            default:
                throw new AssertionError();
        }
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
        processRequest(request, response);
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
