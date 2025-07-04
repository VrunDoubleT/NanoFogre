/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.ProductDAO;
import Models.Product;
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
 * @author Modern 15
 */
@WebServlet(name = "ProductSuggestionServlet", urlPatterns = {"/product-suggestion"})
public class ProductSuggestionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String term = request.getParameter("term");
        if (term == null) {
            term = "";
        }
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.searchByKeyword(term);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("[");
        for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            String imageUrl = "";
            if (p.getUrls() != null && !p.getUrls().isEmpty()) {
                imageUrl = p.getUrls().get(0);
            }
            out.print("{");
            out.print("\"title\":\"" + p.getTitle().replace("\"", "\\\"") + "\",");
            out.print("\"price\":" + p.getPrice() + ",");
            out.print("\"image\":\"" + imageUrl.replace("\"", "\\\"") + "\",");
            out.print("\"slug\":\"" + (p.getSlug() != null ? p.getSlug().replace("\"", "\\\"") : p.getProductId()) + "\"");
            out.print("}");
            if (i < products.size() - 1) {
                out.print(",");
            }
        }
        out.print("]");
        out.close();
    }
}