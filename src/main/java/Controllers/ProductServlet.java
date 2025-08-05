package Controllers;

import DAOs.BrandDAO;
import DAOs.CategoryDAO;
import DAOs.ProductDAO;
import DAOs.ReviewDAO;
import Models.Attribute;
import Models.Brand;
import Models.Category;
import Models.Customer;
import Models.Employee;
import Models.Product;
import Models.ProductAttribute;
import Models.ProductImage;
import Models.ProductStat;
import Models.Review;
import Models.ReviewStats;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.http.HttpSession;

import java.lang.reflect.Type;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
@MultipartConfig
@WebServlet(name = "ProductViewServlet", urlPatterns = {"/product/view"})
public class ProductServlet extends HttpServlet {

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
        ProductDAO pDao = new ProductDAO();
        ReviewDAO rDao = new ReviewDAO();
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
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/productTeamplate.jsp").forward(request, response);
                break;
            case "item":
                String productId = request.getParameter("productId");
                Product product = pDao.getProductById(Integer.parseInt(productId));
                List<ProductAttribute> productAttributes = pDao.getAttributesByProductId(Integer.parseInt(productId));
                request.setAttribute("product", product);
                request.setAttribute("productAttributes", productAttributes);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/productDetailTeamplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = pDao.getTotalPagination(categoryId);
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                List<Category> cs = categoryDao.getCategories();
                List<Brand> brs = brandDao.getAllBrands();
                request.setAttribute("categories", cs);
                request.setAttribute("brands", brs);
                request.setAttribute("type", "create");
                request.setAttribute("product", null);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/createProductTeamplate.jsp").forward(request, response);
                break;
            case "edit":
                int productIdToEdit = Integer.parseInt(request.getParameter("productId"));
                Product productToEdit = pDao.getProductById(productIdToEdit);
                List<Category> cas = categoryDao.getCategories();
                List<Brand> bras = brandDao.getAllBrands();
                List<ProductImage> productImages = pDao.getProductImagesByProductId(productIdToEdit);
                List<ProductAttribute> paEdit = pDao.getAttributesByProductId(productIdToEdit);
                request.setAttribute("categories", cas);
                request.setAttribute("brands", bras);
                request.setAttribute("type", "edit");
                request.setAttribute("product", productToEdit);
                request.setAttribute("productImages", productImages);
                request.setAttribute("productAttributes", paEdit);
                System.out.println(paEdit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/editProductTeamplate.jsp").forward(request, response);
                break;
            case "stat":
                ProductStat productStat = pDao.getProductStat();
                responseJson(response, true, "Success", "Error", productStat);
                break;
            case "productAttribute":
                List<ProductAttribute> pa = pDao.getAttributesByProductIdAndCategoryId(Converter.parseOption(request.getParameter("productId"), 0), Converter.parseOption(request.getParameter("categoryId"), 0));
                request.setAttribute("productAttributes", pa);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/productAttributeTeamplate.jsp").forward(request, response);
                break;
            case "productAttributeData":
                List<ProductAttribute> productAttributesData = pDao.getAttributesByCategoryId(Converter.parseOption(request.getParameter("categoryId"), 0));
                responseJson(response, true, "Get product attribute success", "Something went wrong", productAttributesData);
                break;
            case "reviewStats":
                ReviewStats reviewStats = rDao.getReviewStatsByProductId(Converter.parseOption(request.getParameter("productId"), 0));
                request.setAttribute("reviewStats", reviewStats);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/reviewStatsTeamplate.jsp").forward(request, response);
                System.out.println(reviewStats);
                break;
            case "review":
                int limitReview = 5;
                int pageReview = Converter.parseOption(request.getParameter("page"), 1);
                List<Review> reviews = rDao.getReviewsByProductId(Converter.parseOption(request.getParameter("productId"), 0), Converter.parseOption(request.getParameter("star"), 0), pageReview, limitReview);
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/WEB-INF/employees/templates/products/reviewTeamplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }

    private Product getProductByRequest(HttpServletRequest request) throws ServletException, IOException {
        Product product = new Product();
        List<Part> imageParts = Common.extractImageParts(request.getParts(), "imageFiles");
        List<String> urls = CloudinaryConfig.uploadImages(imageParts);
        product.setProductId(Converter.parseOption(request.getParameter("productId"), 0));
        product.setTitle(request.getParameter("title"));
        product.setSlug(request.getParameter("title"));
        product.setDescription(request.getParameter("description"));
        product.setMaterial(request.getParameter("material"));
        product.setPrice(Double.parseDouble(request.getParameter("price").replace(",", ".")));
        product.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        product.setDestroy(Boolean.parseBoolean(request.getParameter("destroy")));
        product.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));
        product.setBrand(new Brand(Integer.parseInt(request.getParameter("brandId")), null, null));
        product.setCategory(new Category(Integer.parseInt(request.getParameter("categoryId")), null));
        product.setUrls(urls);
        String json = request.getParameter("attributes");
        Gson gson = new Gson();
        Type listType = new TypeToken<List<Attribute>>() {
        }.getType();
        List<Attribute> attributes = gson.fromJson(json, listType);
        List<ProductAttribute> pas = new ArrayList<>();
        for (Attribute attribute : attributes) {
            ProductAttribute pa = new ProductAttribute();
            pa.setId(attribute.getId());
            pa.setValue(attribute.getValue());
            pas.add(pa);
        }
        product.setAttributes(pas);
        return product;
    }

    public void responseJson(HttpServletResponse response, boolean isSuccess, String successMessage, String errorMessage) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> returnData = new HashMap<>();
        returnData.put("isSuccess", isSuccess);
        returnData.put("message", isSuccess ? successMessage : errorMessage);
        Gson gson = new Gson();
        String json = gson.toJson(returnData);
        response.getWriter().write(json);
    }

    public void responseJson(HttpServletResponse response, boolean isSuccess, String successMessage, String errorMessage, Object data) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> returnData = new HashMap<>();
        returnData.put("isSuccess", isSuccess);
        returnData.put("message", isSuccess ? successMessage : errorMessage);
        returnData.put("data", data);
        Gson gson = new Gson();
        String json = gson.toJson(returnData);
        response.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        ProductDAO pDao = new ProductDAO();
        ReviewDAO rDao = new ReviewDAO();
        HttpSession session = request.getSession(false);
        Employee employee = (session != null) ? (Employee) session.getAttribute("employee") : null;
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/admin/auth/login");
            return;
        }
        switch (type) {
            case "create":
                Product product = getProductByRequest(request);
                boolean isSuccess = pDao.createProduct(product);
                responseJson(response, isSuccess, "Product has been created successfully", "An error occurred while creating the product");
                break;
            case "update":
                Product productToUpdate = getProductByRequest(request);
                String[] alreadyUrlsId = request.getParameterValues("urlsId");
                pDao.deleteUnusedProductImages(productToUpdate.getProductId(), alreadyUrlsId);
                boolean isUpdateSuccess = pDao.updateProduct(productToUpdate);
                pDao.upsertProductAttributeValues(productToUpdate.getProductId(), productToUpdate.getAttributes());
                System.out.println(productToUpdate.isActive());
                responseJson(response, isUpdateSuccess, "Product has been updated successfully", "An error occurred while update the product");
                break;
            case "delete":
                int productIdToDelete = Integer.parseInt(request.getParameter("productId"));
                boolean isHidden = pDao.deleteProduct(productIdToDelete);
                responseJson(response, isHidden, "The product has been successfully deleted", "An error occurred while deleted the product");
                break;
            case "reply":
                Gson gson = new Gson();
                JsonObject json = gson.fromJson(request.getReader(), JsonObject.class);

                int reviewId = json.get("reviewId").getAsInt();
                String replyText = json.get("replyText").getAsString();
                int employeeId = employee.getId();
                boolean isSuccessReply = rDao.addReply(reviewId, employeeId, replyText);
                if(isSuccessReply){
                    Review newReview = rDao.getReviewById(reviewId);
                    request.setAttribute("review", newReview);
                    request.getRequestDispatcher("/WEB-INF/employees/templates/products/reviewItemTeamplate.jsp").forward(request, response);
                }
                break;
            default:
                break;
        }
    }
}
