package Controllers;

import DAOs.ProductDAO;
import DAOs.ReviewDAO;
import Models.Product;
import Models.ReviewStats;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Modern 15
 */
@WebServlet(name = "ProductSlugServlet", urlPatterns = {"/product/*"})
public class ProductSlugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // "/slug"
        String slug = (pathInfo != null && pathInfo.length() > 1) ? pathInfo.substring(1) : null;
        if (slug == null || slug.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        ProductDAO pDao = new ProductDAO();
        ReviewDAO rDao = new ReviewDAO();

        Product product = pDao.getProductBySlug(slug);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        ReviewStats reviewStats = rDao.getReviewStatsByProductId(product.getProductId());

        request.setAttribute("product", product);
        request.setAttribute("reviewStats", reviewStats);
        request.getRequestDispatcher("/WEB-INF/customers/pages/productDetailPage.jsp").forward(request, response);
    }
}