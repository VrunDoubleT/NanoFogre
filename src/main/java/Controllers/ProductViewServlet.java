package Controllers;

import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import Utils.CloudinaryConfig;
import Utils.Common;
import Utils.Converter;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@MultipartConfig
@WebServlet(name = "ProductViewServlet", urlPatterns = {"/product/view"})
public class ProductViewServlet extends HttpServlet {

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
        int limit = 5;
        ProductDAO pDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "item";
        int categoryId = Converter.parseOption(request.getParameter("categoryId"), 0);

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Category> categories = categoryDao.getCategories();
                List<Product> products = pDao.products(categoryId, page, limit);
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/productTeamplate.jsp").forward(request, response);
                break;
            case "item":
                String productId = request.getParameter("productId");
                Product product = pDao.getProductById(Integer.parseInt(productId));
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/productDetailTeamplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = pDao.getTotalPagination(categoryId);
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                List<Category> cs = new ArrayList<>();
                cs.add(new Category(1, "Category 1"));
                cs.add(new Category(2, "Category 2"));
                List<Brand> brs = new ArrayList<>();
                brs.add(new Brand(1, "Brand 1", null));
                brs.add(new Brand(2, "Brand 2", null));
                request.setAttribute("categories", cs);
                request.setAttribute("brands", brs);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/createProductTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse respponse) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        ProductDAO pDao = new ProductDAO();
        
        switch (type) {
            case "create":
                Product product = new Product();
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String features = request.getParameter("features");
                String scale = request.getParameter("scale");
                String material = request.getParameter("material");
                String paint = request.getParameter("paint");
                String manufacturer = request.getParameter("manufacturer");
                String length = request.getParameter("length");
                String width = request.getParameter("width");
                String height = request.getParameter("height");
                String weight = request.getParameter("weight");
                String price = request.getParameter("price");
                String quantity = request.getParameter("quantity");
                String destroy = request.getParameter("destroy");
                String categoryId = request.getParameter("categoryId");
                String brandId = request.getParameter("brandId");

                Collection<Part> parts = request.getParts();
                List<Part> imageParts = Common.extractImageParts(request.getParts(), "imageFiles");
                List<String> urls = CloudinaryConfig.uploadImages(imageParts);
                product.setProductId(0);
                product.setTitle(title);
                product.setSlug(title);
                product.setDescription(description);
                product.setScale(scale);
                product.setMaterial(material);
                product.setPrice(Double.parseDouble(price));
                product.setQuantity(Integer.parseInt(quantity));
                product.setPaint(paint);
                product.setFeatures(features);
                product.setManufacturer(manufacturer);
                product.setLength(Double.parseDouble(length));
                product.setWidth(Double.parseDouble(width));
                product.setHeight(Double.parseDouble(height));
                product.setWeight(Double.parseDouble(weight));
                product.setDestroy(Boolean.parseBoolean(destroy));
                product.setBrand(new Brand(Integer.parseInt(brandId), null, null));
                product.setCategory(new Category(Integer.parseInt(categoryId), null));
                product.setUrls(urls);
                pDao.createProduct(product);
                break;
            default:
                break;
        }
    }
}
