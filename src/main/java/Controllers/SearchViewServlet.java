
package Controllers;

import DAOs.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@WebServlet(name="SearchViewServlet", urlPatterns={"/search-products"})
public class SearchViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/customers/pages/searchResultPage.jsp").forward(request, response);
    }
}
