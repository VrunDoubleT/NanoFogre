package Controllers;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import Models.Brand;
import Models.Category;
import Models.Product;
import Models.ProductImage;
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
import java.util.HashMap;
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
        BrandDAO brandDao = new BrandDAO();
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
                List<Category> cs = categoryDao.getCategories();
                List<Brand> brs = brandDao.getAllBrands();
                request.setAttribute("categories", cs);
                request.setAttribute("brands", brs);
                request.setAttribute("type", "create");
                request.setAttribute("product", null);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/createProductTeamplate.jsp").forward(request, response);
                break;
            case "edit":
                int productIdToEdit = Integer.parseInt(request.getParameter("productId"));
                Product productToEdit = pDao.getProductById(productIdToEdit);
                List<Category> cas = categoryDao.getCategories();
                List<Brand> bras = brandDao.getAllBrands();
                List<ProductImage> productImages = pDao.getProductImagesByProductId(productIdToEdit);
                request.setAttribute("categories", cas);
                request.setAttribute("brands", bras);
                request.setAttribute("type", "edit");
                request.setAttribute("product", productToEdit);
                request.setAttribute("productImages", productImages);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/createProductTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        ProductDAO pDao = new ProductDAO();

        switch (type) {
            case "create":
                Product product = new Product();
                List<Part> imageParts = Common.extractImageParts(request.getParts(), "imageFiles");
                List<String> urls = CloudinaryConfig.uploadImages(imageParts);
                product.setProductId(0);
                product.setTitle(request.getParameter("title"));
                product.setSlug(request.getParameter("title"));
                product.setDescription(request.getParameter("description"));
                product.setScale(request.getParameter("scale"));
                product.setMaterial(request.getParameter("material"));
                product.setPrice(Double.parseDouble(request.getParameter("price")));
                product.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                product.setPaint(request.getParameter("paint"));
                product.setFeatures(request.getParameter("features"));
                product.setManufacturer(request.getParameter("manufacturer"));
                product.setLength(Double.parseDouble(request.getParameter("length")));
                product.setWidth(Double.parseDouble(request.getParameter("width")));
                product.setHeight(Double.parseDouble(request.getParameter("height")));
                product.setWeight(Double.parseDouble(request.getParameter("weight")));
                product.setDestroy(Boolean.parseBoolean(request.getParameter("destroy")));
                product.setBrand(new Brand(Integer.parseInt(request.getParameter("brandId")), null, null));
                product.setCategory(new Category(Integer.parseInt(request.getParameter("categoryId")), null));
                product.setUrls(urls);
                boolean isSuccess = pDao.createProduct(product);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> returnData = new HashMap<>();
                returnData.put("isSuccess", isSuccess);
                returnData.put("message", isSuccess ? "Product has been created successfully" : "An error occurred while creating the product");
                Gson gson = new Gson();
                String json = gson.toJson(returnData);
                response.getWriter().write(json);
                break;
            case "update":
                Product productToUpdate = new Product();
                int productIdToUpdate = Integer.parseInt(request.getParameter("productId"));
                List<Part> imagePartsToUpdate = Common.extractImageParts(request.getParts(), "imageFiles");
                List<String> urlsToUpdate = CloudinaryConfig.uploadImages(imagePartsToUpdate);
                productToUpdate.setProductId(productIdToUpdate);
                productToUpdate.setTitle(request.getParameter("title"));
                productToUpdate.setSlug(request.getParameter("title"));
                productToUpdate.setDescription(request.getParameter("description"));
                productToUpdate.setScale(request.getParameter("scale"));
                productToUpdate.setMaterial(request.getParameter("material"));
                productToUpdate.setPrice(Double.parseDouble(request.getParameter("price")));
                productToUpdate.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                productToUpdate.setPaint(request.getParameter("paint"));
                productToUpdate.setFeatures(request.getParameter("features"));
                productToUpdate.setManufacturer(request.getParameter("manufacturer"));
                productToUpdate.setLength(Double.parseDouble(request.getParameter("length")));
                productToUpdate.setWidth(Double.parseDouble(request.getParameter("width")));
                productToUpdate.setHeight(Double.parseDouble(request.getParameter("height")));
                productToUpdate.setWeight(Double.parseDouble(request.getParameter("weight")));
                productToUpdate.setDestroy(Boolean.parseBoolean(request.getParameter("destroy")));
                productToUpdate.setBrand(new Brand(Integer.parseInt(request.getParameter("brandId")), null, null));
                productToUpdate.setCategory(new Category(Integer.parseInt(request.getParameter("categoryId")), null));
                productToUpdate.setUrls(urlsToUpdate);
                String[] alreadyUrlsId = request.getParameterValues("urlsId");
                pDao.deleteUnusedProductImages(productIdToUpdate, alreadyUrlsId);
                pDao.updateProduct(productToUpdate);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> returnDataUpdate = new HashMap<>();
                returnDataUpdate.put("isSuccess", true);
                returnDataUpdate.put("message", true ? "Product has been created successfully" : "An error occurred while creating the product");
                Gson gsonUpdate = new Gson();
                String jsonUpdate = gsonUpdate.toJson(returnDataUpdate);
                response.getWriter().write(jsonUpdate);
                break;
            case "delete":
                int productIdToHide = Integer.parseInt(request.getParameter("productId"));
                boolean isHidden = pDao.hideProduct(productIdToHide);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> returnDataDelete = new HashMap<>();
                returnDataDelete.put("isSuccess", isHidden);
                returnDataDelete.put("message", isHidden ? "The product has been successfully hidden" : "An error occurred while hide the product");
                Gson gsonDelete = new Gson();
                String jsonDelete = gsonDelete.toJson(returnDataDelete);
                response.getWriter().write(jsonDelete);
                break;
            case "enable":
                int productIdToEnable = Integer.parseInt(request.getParameter("productId"));
                boolean isEnable = pDao.enableProduct(productIdToEnable);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> returnDataEnable = new HashMap<>();
                returnDataEnable.put("isSuccess", isEnable);
                returnDataEnable.put("message", isEnable ? "The product has been successfully restored" : "An error occurred while restoring the product");
                Gson gsonEnable = new Gson();
                String jsonEnable = gsonEnable.toJson(returnDataEnable);
                response.getWriter().write(jsonEnable);
                break;
            default:
                break;
        }
    }
}
