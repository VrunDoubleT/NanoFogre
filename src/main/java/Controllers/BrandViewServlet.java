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
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "BrandViewServlet", urlPatterns = {"/brand"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class BrandViewServlet extends HttpServlet {

    private final BrandDAO brandDao = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("getBrand".equals(request.getParameter("action"))) {
            try {
                String idParam = request.getParameter("id");
                System.out.println("Received ID parameter: " + idParam); // Debug log

                int id = Integer.parseInt(idParam);
                System.out.println("Parsed ID: " + id); // Debug log

                Brand brand = brandDao.getBrandById(id);
                System.out.println("Found brand: " + (brand != null ? brand.getName() : "null")); // Debug log

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
                e.printStackTrace(); // In lỗi ra console
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

        request.setAttribute("brands", brands);
        request.setAttribute("totalBrands", totalBrands);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

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
        } catch (Exception e) {
            message = e.getMessage() != null ? e.getMessage() : "System error: " + e.getMessage();
            e.printStackTrace();
        }

        response.getWriter().write(String.format(
                "{\"success\":%b,\"message\":\"%s\"}", success, message));
    }

    private boolean handleCreate(HttpServletRequest request) throws IOException, ServletException {
        String name = request.getParameter("name").trim();
        Part imagePart = request.getPart("image");

        if (name.isEmpty() || imagePart == null || imagePart.getSize() == 0) {
            return false;
        }

        // Tạo thư mục lưu ảnh trong webapp (public)
        String uploadPath = getServletContext().getRealPath("/") + "uploads/brands";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Tạo tên file unique để tránh trùng
        String fileName = System.currentTimeMillis() + "_" + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String filePath = uploadPath + File.separator + fileName;
        imagePart.write(filePath);

        // Đường dẫn hiển thị phải bắt đầu bằng /
        String imageUrl = "/uploads/brands/" + fileName;

        if (brandDao.isBrandNameExists(name)) {
            throw new RuntimeException("Brand name already exists");
        }
        return brandDao.createBrand(name, imageUrl);
    }

    private boolean handleUpdate(HttpServletRequest request) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name").trim();

        // Lấy ảnh cũ từ DB (hoặc từ request nếu bạn truyền lên)
        Brand oldBrand = brandDao.getBrandById(id);
        String imageUrl = oldBrand != null ? oldBrand.getUrl() : "";

        Part imagePart = request.getPart("image");
        // Nếu người dùng upload ảnh mới thì xử lý upload
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("/") + "uploads/brands";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String fileName = System.currentTimeMillis() + "_" + Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String filePath = uploadPath + File.separator + fileName;
            imagePart.write(filePath);

            imageUrl = "/uploads/brands/" + fileName;
        }

        if (name.isEmpty() || imageUrl.isEmpty()) {
            return false;
        }
        if (brandDao.isBrandNameExistsExceptId(name, id)) {
            throw new RuntimeException("Brand name already exists");
        }
        return brandDao.updateBrand(id, name, imageUrl);
    }

    private boolean handleDelete(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        return brandDao.deleteBrand(id);
    }
}
