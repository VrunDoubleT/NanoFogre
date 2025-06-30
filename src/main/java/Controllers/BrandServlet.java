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

@WebServlet(name = "BrandViewServlet", urlPatterns = {"/brand"})
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
        if ("getBrand".equals(request.getParameter("action"))) {
            try {
                String idParam = request.getParameter("id");
                System.out.println("Received ID parameter: " + idParam);
                int id = Integer.parseInt(idParam);
                System.out.println("Parsed ID: " + id);
                Brand brand = brandDao.getBrandById(id);
                System.out.println("Found brand: " + (brand != null ? brand.getName() : "null"));
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (brand != null) {
                    String jsonResponse = String.format(
                            "{\"success\":true,\"brand\":{\"id\":%d,\"name\":\"%s\",\"image\":\"%s\"}}",
                            brand.getId(),
                            brand.getName().replace("\"", "\\\""), // Escape quotes
                            brand.getUrl() != null ? brand.getUrl().replace("\"", "\\\"") : ""
                    );
                    response.getWriter().write(jsonResponse);
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Brand not found\"}");
                }
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Invalid ID format\"}");
            } catch (Exception e) {
                e.printStackTrace(); 
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Server error: " + e.getMessage() + "\"}");
            }
            return;
        }
        int page = Converter.parseOption(request.getParameter("page"), 1);
        int limit = 5;
        List<Brand> brands = brandDao.getBrandsPaginated(page, limit);
        int totalBrands = brandDao.getTotalBrandsForPagination();
        int totalPages = (int) Math.ceil((double) totalBrands / limit);
        // Set attribute
        request.setAttribute("brands", brands);
        request.setAttribute("total", totalBrands);
        request.setAttribute("limit", limit);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("page", page);
        String viewPath = (String) request.getAttribute("viewPath");
        request.getRequestDispatcher(viewPath).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        String action = request.getParameter("action");
        boolean success = false;
        String message = "Invalid action";
        try {
            if (action == null) {
                throw new RuntimeException("Missing action parameter");
            }
            switch (action.toLowerCase()) {
                case "create":
                    success = handleCreate(request);
                    message = success ? "Brand created successfully" : "Error creating brand";
                    break;
                case "update":
                    success = handleUpdate(request);
                    message = success ? "Brand updated successfully" : "Error updating brand";
                    break;
                case "delete":
                    success = handleDelete(request);
                    message = success ? "Brand deleted successfully" : "Error deleting brand";
                    break;
                default:
                    message = "Invalid action";
            }
        } catch (RuntimeException e) {
            message = e.getMessage() != null ? e.getMessage() : "System error";
            success = false;
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            message = e.getMessage() != null ? e.getMessage() : "System error";
            success = false;
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }

        response.getWriter().write(String.format(
                "{\"success\":%b,\"message\":\"%s\"}", success, message));
    }

    private boolean handleCreate(HttpServletRequest request) throws IOException, ServletException {
        String name = request.getParameter("name").trim();
        Part imagePart = request.getPart("image");
        if (name.isEmpty() || imagePart == null || imagePart.getSize() == 0) {
            throw new RuntimeException("Missing brand name or image.");
        }

        String imageUrl = uploadSingleImage(imagePart);

        if (imageUrl == null || imageUrl.isEmpty()) {
            throw new RuntimeException("Error uploading brand image!");
        }
        if (brandDao.isBrandNameExists(name)) {
            throw new RuntimeException("Brand name already exists");
        }
        return brandDao.createBrand(name, imageUrl);
    }

    private boolean handleUpdate(HttpServletRequest request) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name").trim();

        Brand oldBrand = brandDao.getBrandById(id);
        String imageUrl = oldBrand != null ? oldBrand.getUrl() : "";

        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            imageUrl = Utils.CloudinaryConfig.uploadSingleImage(imagePart);
            if (imageUrl == null || imageUrl.isEmpty()) {
                throw new RuntimeException("Error uploading brand image!");
            }
        }
        if (name.isEmpty() || imageUrl.isEmpty()) {
            throw new RuntimeException("Missing brand name or image.");
        }
        if (brandDao.isBrandNameExistsExceptId(name, id)) {
            throw new RuntimeException("The brand has existed.");
        }
        return brandDao.updateBrand(id, name, imageUrl);
    }

    private boolean handleDelete(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        Brand brand = brandDao.getBrandById(id);
        if (brand == null) {
            throw new RuntimeException("Brand does not exist");
        }
        boolean success = brandDao.deleteBrand(id);
        if (!success) {
            throw new RuntimeException("Cannot delete brand due to system error");
        }
        return true;
    }
}
