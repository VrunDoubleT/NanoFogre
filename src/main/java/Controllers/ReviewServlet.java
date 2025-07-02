package Controllers;

import DAOs.ReviewDAO;
import Models.Review;
import Models.ReviewStats;
import Utils.Converter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.BorderLayout;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

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
            out.println("<title>Servlet ReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewServlet at " + request.getContextPath() + "</h1>");
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
        String type = request.getParameter("type");
        ReviewDAO rDao = new ReviewDAO();
        int limit = 5;
        System.out.println(type);
        switch (type) {
            case "list":
                int productId = Converter.parseOption(request.getParameter("productId"), 0);
                int page = Converter.parseOption(request.getParameter("page"), 1);
                int star = Converter.parseOption(request.getParameter("star"), 0);
                List<Review> reviews = rDao.getReviewsByProductId(productId, star, page, limit);
                System.out.println(reviews);
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/WEB-INF/customers/component/productDetail/reviews.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int pId = Converter.parseOption(request.getParameter("productId"), 0);
                int starFilter = Converter.parseOption(request.getParameter("star"), 0);
                int total = rDao.countReviewByProductIdAndStar(pId, starFilter);
                System.out.println(pId);
                request.setAttribute("total", total);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/customers/common/paginationTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
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
