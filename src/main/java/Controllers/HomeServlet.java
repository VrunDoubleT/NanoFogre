package Controllers;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.HomeDAO;
import DAOs.ReviewDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import Models.Review;
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
@WebServlet(name = "HomeServlet", urlPatterns = {""})
public class HomeServlet extends HttpServlet {
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
        HomeDAO hDao = new HomeDAO();
        CategoryDAO cDao = new CategoryDAO();
        BrandDAO bDao = new BrandDAO();
        ReviewDAO rDao = new ReviewDAO();
        List<Product> topRated = hDao.getTopRatedProducts(8);
        List<Product> topSelling = hDao.getTopSellingProducts(8);
        List<Product> newest = hDao.getNewestProducts(8);
        List<Category> categories = cDao.getActiveCategories();
        List<Brand> brands = bDao.getAllBrands();
        List<Review> reviews = rDao.getTopFiveStarReviews(10);
        request.setAttribute("topRatedProducts", topRated);
        request.setAttribute("topSellingProducts", topSelling);
        request.setAttribute("newestProducts", newest);
        request.setAttribute("categories", categories);
        request.setAttribute("brands", brands);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/WEB-INF/customers/pages/homePage.jsp").forward(request, response);
    }
}
