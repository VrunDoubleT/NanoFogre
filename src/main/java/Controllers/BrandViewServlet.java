package Controllers;

import DAOs.BrandDAO;
import Models.Brand;
import Utils.Converter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "BrandViewServlet", urlPatterns = {"/brand"})
public class BrandViewServlet extends HttpServlet {

    private final BrandDAO brandDao = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if ("getBrand".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            Brand brand = brandDao.getBrandById(id);
            response.setContentType("application/json");
            if (brand != null) {
                response.getWriter().write(String.format(
                        "{\"success\":true,\"brand\":{\"id\":%d,\"name\":\"%s\",\"image\":\"%s\"}}",
                        brand.getId(), brand.getName(), brand.getUrl()));
            } else {
                response.getWriter().write("{\"success\":false}");
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

    private boolean handleCreate(HttpServletRequest request) {
        String name = request.getParameter("name").trim();
        String imageUrl = request.getParameter("image").trim();
        if (name.isEmpty() || imageUrl.isEmpty()) {
            return false;
        }
        if (brandDao.isBrandNameExists(name)) {
            throw new RuntimeException("Brand name already exists");
        }
        return brandDao.createBrand(name, imageUrl);
    }

    private boolean handleUpdate(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name").trim();
        String imageUrl = request.getParameter("image").trim();
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
