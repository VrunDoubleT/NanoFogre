package Controllers;

import DAOs.CategoryDAO;
import Models.Category;
import Utils.CloudinaryConfig;
import Utils.Common;
import Utils.Converter;
import com.google.gson.Gson;

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
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import jdk.nashorn.internal.ir.BreakNode;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
/**
 * Servlet implementation class CategoryViewServlet
 */
@WebServlet(name = "CategoryViewServlet", urlPatterns = {"/category/view"})
public class CategoryViewServlet extends HttpServlet {

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
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/categoryTeamplate.jsp").forward(request, response); // Forward to JSP
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = categoryDao.countCategory();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":

                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/createCategoryTeamplate.jsp").forward(request, response);
                break;
            case "edit":
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                Category category = categoryDao.getCategoryById(categoryId);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/category/editCategoryTeamplate.jsp").forward(request, response);
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
                Part imagePart = request.getPart("categoryImage");
                String imageUrl = null;
                if (imagePart != null && imagePart.getSize() > 0) {
                    List<Part> images = new ArrayList<>();
                    images.add(imagePart);
                    List<String> urls = CloudinaryConfig.uploadImages(images);
                    if (!urls.isEmpty()) {
                        imageUrl = urls.get(0);
                    }
                }

                category.setName(categoryName);
                category.setAvatar(imageUrl);

                if (categoryDAO.isCategoryNameExists(categoryName)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("isSuccess", false);
                    errorResponse.put("message", "Category name already exists.");
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(errorResponse));
                    return;
                }

                boolean isCreated = categoryDAO.createCategory(category);
                returnData.put("isSuccess", isCreated);
                returnData.put("message", isCreated ? "Category created successfully" : "An error occurred while creating the category");
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String jsonResponse = new Gson().toJson(returnData);
                response.getWriter().write(jsonResponse);
                break;

            case "update": 
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String newName = request.getParameter("categoryName");
                Category current = categoryDAO.getCategoryById(categoryId);

                if (categoryDAO.isCategoryNameExists(newName)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, Object> errorResponseUpdate = new HashMap<>();
                    errorResponseUpdate.put("isSuccess", false);
                    errorResponseUpdate.put("message", "Category name already exists.");
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new Gson().toJson(errorResponseUpdate));
                    return;
                }

                boolean updateImage = false;
                String imageUrls = current.getAvatar();
                Part imageParts = null;
                try {
                    imageParts = request.getPart("categoryImage");
                    if (imageParts != null && imageParts.getSize() > 0) {
                        List<Part> images = new ArrayList<>();
                        images.add(imageParts);
                        List<String> urls = CloudinaryConfig.uploadImages(images);
                        if (!urls.isEmpty()) {
                            imageUrls = urls.get(0);
                            updateImage = true;
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                current.setName(newName);
                current.setAvatar(imageUrls);

                boolean isUpdated = categoryDAO.updateCategory(current, updateImage);

                Map<String, Object> returnDataUpdate = new HashMap<>();
                returnDataUpdate.put("isSuccess", isUpdated);
                returnDataUpdate.put("message", isUpdated ? "Category updated successfully" : "An error occurred while updating the category");
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(returnDataUpdate));
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
