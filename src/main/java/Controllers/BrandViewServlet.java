package Controllers;

import DAOs.BrandDAO;
import Models.Brand;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BrandViewServlet", urlPatterns = {"/brand"})
public class BrandViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        BrandDAO brandDao = new BrandDAO();
        String category = request.getParameter("category");
        if ("all".equalsIgnoreCase(category)) {
            category = null;
        }
        List<Brand> filteredBrands;
        int totalBrands;
        if (category != null && !category.isEmpty()) {
            filteredBrands = brandDao.getBrandsByCategory(category);
            totalBrands = brandDao.getTotalBrandsByCategory(category);
        } else {
            filteredBrands = brandDao.getAllBrands();
            totalBrands = brandDao.getTotalBrands();
        }
        request.setAttribute("selectedCategory", category != null ? category : "all");
        request.setAttribute("brands", filteredBrands);
        request.setAttribute("totalBrands", totalBrands);
        
        String viewPath = (String) request.getAttribute("viewPath");
        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}

