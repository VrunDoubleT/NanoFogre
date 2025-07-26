package Controllers;

import DAOs.ProductDAO;
import Models.Product;
import Utils.Converter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "ProductByCategoryServlet", urlPatterns = {"/productsbycategory"})
public class ProductByCategoryServlet extends HttpServlet {

    public List<Integer> getBrandIdList(HttpServletRequest request) {
        String[] brandIdStr = request.getParameterValues("brandId");
        List<Integer> brandIdList = new ArrayList<>();

        if (brandIdStr != null) {
            for (String id : brandIdStr) {
                int value = Converter.parseOption(id, -1);
                if (value != -1) {
                    brandIdList.add(value);
                }
            }
        }
        return brandIdList;
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
        int limit = 10;
        String type = request.getParameter("type");
        ProductDAO pDao = new ProductDAO();
        switch (type) {
            case "list":
                int categoryId = Converter.parseOption(request.getParameter("categoryId"), 0);
                String sort = !request.getParameter("sort").trim().isEmpty() ? request.getParameter("sort") : "title";
                List<Integer> brandIdList = getBrandIdList(request);
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Product> products = pDao.getActiveProductByCategory(categoryId, brandIdList, sort, page, limit);
                request.setAttribute("products", products);
                request.getRequestDispatcher("/WEB-INF/customers/component/products/products.jsp").forward(request, response);
                break;
            case "pagination":
                int cId = Converter.parseOption(request.getParameter("categoryId"), 0);
                int pageToPagination = Converter.parseOption(request.getParameter("page"), 1);
                List<Integer> brandIdListPagination = getBrandIdList(request);
                int total = pDao.countActiveProductByCategory(cId, brandIdListPagination);
                request.setAttribute("total", total);
                request.setAttribute("limit", limit);
                request.setAttribute("page", pageToPagination);
                request.getRequestDispatcher("/WEB-INF/customers/common/paginationTeamplate.jsp").forward(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }
}
