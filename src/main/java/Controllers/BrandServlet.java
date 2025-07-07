package Controllers;

import DAOs.BrandDAO;
import Models.Brand;
import Utils.Converter;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.List;
import static Utils.CloudinaryConfig.uploadSingleImage;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "BrandViewServlet", urlPatterns = {"/brand/view"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class BrandServlet extends HttpServlet {

    private final BrandDAO brandDao = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type") != null ? request.getParameter("type") : "list";
        int limit = 5;

        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Brand> brands = brandDao.getBrands(page, limit);
                request.setAttribute("brands", brands);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/brands/brandTeamplate.jsp").forward(request, response);
                break;

            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = brandDao.getTotalBrands();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "edit":
                int editBrandId = Integer.parseInt(request.getParameter("brandId"));
                Brand editBrand = brandDao.getBrandById(editBrandId);
                request.setAttribute("brand", editBrand);
                request.getRequestDispatcher("/WEB-INF/employees/templates/brand/editBrandTemplate.jsp").forward(request, response);
                break;
            case "total":
                int totalBrandCount = brandDao.getTotalBrands();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"total\":" + totalBrandCount + "}");
                break;
            case "check-name":
                String brandName = request.getParameter("brandName");
                boolean exists = brandDao.isBrandNameExists(brandName);
                response.setContentType("application/json");
                response.getWriter().write("{\"exists\":" + exists + "}");
                break;
            default:
                // fallback (optional)
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        switch (type) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                responseJson(response, false, "Invalid action");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("brandName");
        Part imagePart = request.getPart("brandImage");
        if (name == null || name.trim().isEmpty() || imagePart == null || imagePart.getSize() == 0) {
            responseJson(response, false, "Missing brand name or image.");
            return;
        }
        if (brandDao.isBrandNameExists(name)) {
            responseJson(response, false, "Brand name already exists.");
            return;
        }
        String imageUrl = Utils.CloudinaryConfig.uploadSingleImage(imagePart);
        if (imageUrl == null || imageUrl.isEmpty()) {
            responseJson(response, false, "Error uploading brand image!");
            return;
        }
        boolean created = brandDao.createBrand(name, imageUrl);
        responseJson(response, created, created ? "Brand created successfully." : "Failed to create brand.");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("brandId"));
        String name = request.getParameter("brandName");
        Brand oldBrand = brandDao.getBrandById(id);
        String imageUrl = oldBrand != null ? oldBrand.getUrl() : "";

        Part imagePart = request.getPart("brandImage");
        if (imagePart != null && imagePart.getSize() > 0) {
            imageUrl = Utils.CloudinaryConfig.uploadSingleImage(imagePart);
            if (imageUrl == null || imageUrl.isEmpty()) {
                responseJson(response, false, "Error uploading brand image!");
                return;
            }
        }
        if (name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.isEmpty()) {
            responseJson(response, false, "Missing brand name or image.");
            return;
        }
        if (brandDao.isBrandNameExistsExceptId(name, id)) {
            responseJson(response, false, "Brand name already exists.");
            return;
        }
        boolean updated = brandDao.updateBrand(id, name, imageUrl);
        responseJson(response, updated, updated ? "Brand updated successfully." : "Failed to update brand.");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
    int id = Integer.parseInt(request.getParameter("brandId"));
    Brand brand = brandDao.getBrandById(id);
    if (brand == null) {
        responseJson(response, false, "Brand does not exist.");
        return;
    }
    try {
        boolean deleted = brandDao.deleteBrand(id);
        responseJson(response, deleted, deleted ? "Brand deleted successfully." : "Cannot delete brand due to system error.");
    } catch (RuntimeException ex) {
        String msg = ex.getMessage() != null ? ex.getMessage() : "Cannot delete brand due to system error.";
        if (msg.contains("cannot be set to null") || msg.contains("product table constraints")) {
            responseJson(response, false, "Không thể xóa Brand vì sản phẩm còn tham chiếu đến Brand này hoặc Products.brandId không cho phép NULL!");
        } else {
            responseJson(response, false, msg);
        }
    }
}


    private void responseJson(HttpServletResponse response, boolean isSuccess, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", isSuccess);
        result.put("message", message);
        response.getWriter().write(new com.google.gson.Gson().toJson(result));
    }
}
