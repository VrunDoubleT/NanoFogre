/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Product;
import DAOs.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

/**
 *
 * @author Modern 15
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/SearchServlet"})
public class SearchServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        Integer categoryId = null;
        Integer brandId = null;
        try {
            categoryId = Integer.valueOf(request.getParameter("categoryId"));
        } catch (Exception e) {
        }
        try {
            brandId = Integer.valueOf(request.getParameter("brandId"));
        } catch (Exception e) {
        }

        List<Product> products = productDAO.search(keyword, categoryId, brandId);

        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(isAjax)) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(productsToJson(products));
            out.flush();
            return;
        }

        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("brandId", brandId);
        request.getRequestDispatcher("/WEB-INF/customers/pages/searchResultPage.jsp").forward(request, response);
    }

    private String productsToJson(List<Product> products) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            String img = (p.getUrls() != null && !p.getUrls().isEmpty()) ? p.getUrls().get(0) : "";
            sb.append("{")
                    .append("\"id\":").append(p.getProductId()).append(",")
                    .append("\"title\":\"").append(p.getTitle().replace("\"", "\\\"")).append("\",")
                    .append("\"price\":").append(p.getPrice()).append(",")
                    .append("\"slug\":\"").append(p.getSlug()).append("\",")
                    .append("\"img\":\"").append(img.replace("\"", "\\\"")).append("\"")
                    .append("}");
            if (i < products.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}