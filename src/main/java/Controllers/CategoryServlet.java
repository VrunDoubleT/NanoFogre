package Controllers;

import DAOs.CategoryDAO;
import Models.Category;
import Models.ProductAttribute;
import Utils.CloudinaryConfig;
import Utils.Common;
import Utils.Converter;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import static java.lang.System.out;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import jdk.nashorn.internal.ir.BreakNode;
import org.cloudinary.json.JSONObject;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
/**
 * Servlet implementation class CategoryViewServlet
 */
@WebServlet(name = "CategoryViewServlet", urlPatterns = {"/category/view"})
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int limit = 5; // Default limit for pagination
        CategoryDAO categoryDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "categories"; // Get type for list or pagination

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Category> categories = categoryDao.getCategories(page, limit);
                request.setAttribute("categories", categories);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/category/categoryTeamplate.jsp").forward(request, response); // Forward to JSP
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = categoryDao.countCategory();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":

                request.getRequestDispatcher("/WEB-INF/employees/templates/category/createCategoryTeamplate.jsp").forward(request, response);
                break;
            case "detail":
                int categoryIds = Integer.parseInt(request.getParameter("categoryId"));

                CategoryDAO categoryDAO = new CategoryDAO();
                Category categorys = categoryDAO.getCategoryById(categoryIds);
                List<ProductAttribute> attributes = categoryDAO.getAttributesByCategoryId(categoryIds);

                request.setAttribute("category", categorys);
                request.setAttribute("attributes", attributes);

                request.getRequestDispatcher("/WEB-INF/employees/templates/category/detailCategoryTeamplate.jsp")
                        .forward(request, response);
                break;

            case "edit":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Category category = categoryDao.getCategoryById(categoryId);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/WEB-INF/employees/templates/category/editCategoryTeamplate.jsp").forward(request, response);
                break;
            case "total":
                int totalCategoryCount = categoryDao.countCategory();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                response.getWriter().write("{\"total\":" + totalCategoryCount + "}");
                break;

            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Category category = new Category();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        CategoryDAO categoryDAO = new CategoryDAO();
        String categoryName = request.getParameter("categoryName");
        Map<String, Object> returnData = new HashMap<>();
        switch (type) {

            case "create":
                CategoryDAO dao = new CategoryDAO();
                Gson gson = new Gson();

                String newName = request.getParameter("categoryName");

                if (dao.isCategoryNameExists(newName)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, Object> err = new HashMap<>();
                    err.put("isSuccess", false);
                    err.put("message", "Category name already exists.");
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(err));
                    return;
                }

                String attrsJson = request.getParameter("attributes"); // JSON từ front-end, có thể null hoặc "[]"

                String imageUrl = null;
                try {
                    Part imagePart = request.getPart("categoryImage");
                    if (imagePart != null && imagePart.getSize() > 0) {
                        List<Part> parts = Collections.singletonList(imagePart);
                        List<String> urls = CloudinaryConfig.uploadImages(parts);
                        if (!urls.isEmpty()) {
                            imageUrl = urls.get(0);
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();

                }

                // 4) save Category and ID new
                category.setName(newName);
                category.setAvatar(imageUrl);
                int newCategoryId = dao.createCategoryAndReturnId(category);
                if (newCategoryId <= 0) {
                    responseJson(response, false, "Failed to create category.");
                    return;
                }

                List<Map<String, Object>> attrMaps = new ArrayList<>();
                if (attrsJson != null && !attrsJson.trim().isEmpty()) {
                    try {
                        attrMaps = gson.fromJson(
                                attrsJson,
                                new TypeToken<List<Map<String, Object>>>() {
                                }.getType()
                        );
                    } catch (JsonSyntaxException e) {
                        responseJson(response, false, "Invalid attributes format.");
                        return;
                    }
                }

                if (!attrMaps.isEmpty()) {
                    List<ProductAttribute> attrs = new ArrayList<>();
                    for (Map<String, Object> m : attrMaps) {
                        ProductAttribute a = new ProductAttribute();
                        a.setName((String) m.get("name"));
                        a.setDataType((String) m.get("datatype"));
                        a.setUnit((String) m.get("unit"));

                        Object rawMin = m.get("minValue");
                        Object rawMax = m.get("maxValue");
                        a.setMinValue(rawMin != null ? rawMin.toString() : null);
                        a.setMaxValue(rawMax != null ? rawMax.toString() : null);

                        a.setIsRequired(Boolean.TRUE.equals(m.get("required")));
                        a.setCategoryId(newCategoryId);
                        attrs.add(a);
                    }
                    try {
                        dao.insertAttributes(newCategoryId, attrs);
                    } catch (SQLException ex) {
                        Logger.getLogger(CategoryServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                responseJson(response, true, "Category created successfully.");
                break;

            case "update":
                CategoryDAO daose = new CategoryDAO();
                Gson gsonse = new Gson();

                // 1.  params
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String newNamese = request.getParameter("categoryName");

                String attrsJsonse = request.getParameter("attributes");

                // 2. update image
                Category current = daose.getCategoryById(categoryId);
                boolean updateImage = false;
                String imageUrlse = current.getAvatar();
                try {
                    Part imageParts = request.getPart("categoryImage");
                    if (imageParts != null && imageParts.getSize() > 0) {
                        List<Part> images = new ArrayList<>();
                        images.add(imageParts);
                        List<String> urls = CloudinaryConfig.uploadImages(images);
                        if (!urls.isEmpty()) {
                            imageUrlse = urls.get(0);
                            updateImage = true;
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                current.setName(newNamese);
                if (updateImage) {
                    current.setAvatar(imageUrlse);
                }
                daose.updateCategory(current, updateImage);

                // 3. Parse JSON attributes
                List<Map<String, Object>> maps = gsonse.fromJson(
                        attrsJsonse,
                        new TypeToken<List<Map<String, Object>>>() {
                        }.getType()
                );

                // 4.  toUpdate vs toInsert
                List<ProductAttribute> toUpdate = new ArrayList<>();
                List<ProductAttribute> toInsert = new ArrayList<>();

                for (Map<String, Object> m : maps) {
                    Number rawId = (Number) m.get("attributeId");
                    int attrId = rawId != null ? rawId.intValue() : 0;

                    ProductAttribute a = new ProductAttribute();
                    if (attrId > 0) {
                        a.setId(attrId);
                    }
                    a.setName((String) m.get("attributeName"));
                    a.setDataType((String) m.get("datatype"));
                    a.setUnit((String) m.get("unit"));

                    Object rawMin = m.get("minValue"), rawMax = m.get("maxValue");
                    a.setMinValue(rawMin != null ? rawMin.toString() : null);
                    a.setMaxValue(rawMax != null ? rawMax.toString() : null);

                    a.setIsRequired(Boolean.TRUE.equals(m.get("isRequired")));
                    a.setIsActive(Boolean.TRUE.equals(m.get("isActive")));
                    a.setCategoryId(categoryId);

                    if (attrId > 0) {
                        toUpdate.add(a);
                    } else {
                        toInsert.add(a);
                    }
                }

                // 5. Call DAO o DB
                if (!toUpdate.isEmpty()) {
                    daose.saveAttributes(categoryId, toUpdate);
                }
                if (!toInsert.isEmpty()) {
                    try {
                        daose.insertAttributes(categoryId, toInsert);
                    } catch (SQLException e) {
                        e.printStackTrace();
                        responseJson(response, false, "Failed to insert new attributes: " + e.getMessage());
                        return;
                    }
                }

                responseJson(response, true, "Category updated successfully.");
                break;

            case "delete":
                int categoryIdToHide = Integer.parseInt(request.getParameter("categoryId"));
                boolean isHidden = categoryDAO.hideCategory(categoryIdToHide);
                responseJson(response, isHidden, "The product has been successfully hidden", "An error occurred while hide the product");
                break;
            case "enable":
                int categoryIdToEnable = Integer.parseInt(request.getParameter("categoryId"));
                boolean isEnable = categoryDAO.enableCategory(categoryIdToEnable);
                responseJson(response, isEnable, "The product has been successfully restored", "An error occurred while restoring the product");
                break;
            case "deleteAttribute":
                int attrId = Integer.parseInt(request.getParameter("attributeId"));
                boolean deleted = categoryDAO.deleteAttribute(attrId);

                JSONObject json = new JSONObject();
                json.put("isSuccess", deleted);
                json.put("message", deleted ? "Attribute deleted successfully" : "Deletion failed");

                response.setContentType("application/json");
                response.getWriter().write(json.toString());
                break;
        }
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

    public void responseJson(HttpServletResponse response, boolean isSuccess, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", isSuccess);
        result.put("message", message);
        response.getWriter().write(new Gson().toJson(result));
    }

    @Override
    public String getServletInfo() {
        return "Category management servlet";
    }
}