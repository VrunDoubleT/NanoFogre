/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CategoryDAO;
import DAOs.VoucherDAO;
import Models.Category;
import Models.Voucher;
import Utils.Converter;
import static Utils.Converter.parseNullableDouble;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet(name = "VoucherViewServlet", urlPatterns = {"/voucher/view"})
public class VoucherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int limit = 5;
        VoucherDAO vDao = new VoucherDAO();
        CategoryDAO cDao = new CategoryDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "list";
        int categoryId = Converter.parseOption(request.getParameter("categoryId"), 0);
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Voucher> vouchers = vDao.vouchers(categoryId, page, limit);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.setAttribute("vlist", vouchers);
                request.getRequestDispatcher("/WEB-INF/employees/templates/vouchers/voucherTemplate.jsp").forward(request, response);
                break;
            case "detail":
                int did = Integer.parseInt(request.getParameter("id"));
                Voucher item = vDao.getVoucherById(did);
                List<Category> clist = vDao.getCategoriesByVoucherId(did);
                request.setAttribute("voucher", item);
                request.setAttribute("categories", clist);
                request.getRequestDispatcher("/WEB-INF/employees/templates/vouchers/voucherDetailsTemplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = vDao.countVouchersByCategory(categoryId);
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                List<Category> categoryList = cDao.getCategories();
                request.setAttribute("categoryList", categoryList);
                request.getRequestDispatcher("/WEB-INF/employees/templates/vouchers/createVoucherTemplate.jsp").forward(request, response);
                break;
            case "checkVoucherCode":
                String codes = request.getParameter("voucherCode");
                boolean exists = vDao.isCodeExists(codes);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(exists));
                break;
            case "checkVoucherCodeExceptOwn":
                String code = request.getParameter("voucherCode");
                String idRaw = request.getParameter("id");
                int idCheckCode = idRaw != null ? Integer.parseInt(idRaw) : -1;
                boolean exist = vDao.isCodeExistsExceptOwn(code, idCheckCode);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(exist));
                break;
            case "checkTotalLimit":
                String vIdForTotal = request.getParameter("id");
                int idForTotal = vIdForTotal != null ? Integer.parseInt(vIdForTotal) : -1;
                int totalLimit = Integer.parseInt(request.getParameter("totalUsageLimit"));
                boolean validTotal = vDao.isValidTotalUsageLimit(idForTotal, totalLimit);
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.valueOf(validTotal));
                break;
            case "checkUserLimit":
                String vIdForUser = request.getParameter("id");
                int idForUser = vIdForUser != null ? Integer.parseInt(vIdForUser) : -1;
                int userLimit = Integer.parseInt(request.getParameter("userUsageLimit"));
                boolean validUser = vDao.isValidUserUsageLimit(idForUser, userLimit);
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.valueOf(validUser));
                break;
            case "update":
                int id = Integer.parseInt(request.getParameter("id"));
                Voucher voucherToUpdate = vDao.getVoucherById(id);
                boolean isUsed = vDao.hasUsage(id);
                String status = voucherToUpdate.getStatus();
                request.setAttribute("voucher", voucherToUpdate);
                request.setAttribute("voucherStatus", status);
                request.setAttribute("voucherIsUsed", isUsed);
                List<Category> selectedCategories = vDao.getCategoriesByVoucherId(id);
                request.setAttribute("selectedCategories", selectedCategories);
                request.setAttribute("categoryList", cDao.getCategories());
                request.getRequestDispatcher("/WEB-INF/employees/templates/vouchers/updateVoucherTemplate.jsp").forward(request, response);
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        VoucherDAO vDao = new VoucherDAO();

        switch (type) {
            case "create":
                Voucher voucher = new Voucher();
                String code = request.getParameter("code");
                if (code != null) {
                    code = code.trim().toUpperCase();
                }
                String voucherType = request.getParameter("voucherType");
                String description = request.getParameter("description");
                String isActiveParam = request.getParameter("active");
                double value = Converter.parseDouble(request.getParameter("value"), 0);
                double minValue = Converter.parseDouble(request.getParameter("minValue"), 0);
                Double maxValue = Converter.parseNullableDouble(request.getParameter("maxValue"));
                Integer totalLimit = Converter.parseNullableInt(request.getParameter("totalLimit"));
                Integer userLimit = Converter.parseNullableInt(request.getParameter("userUsageLimit"));
                LocalDateTime validFrom = Converter.parseLocalDateTime(request.getParameter("validFrom"));
                LocalDateTime validTo = Converter.parseLocalDateTime(request.getParameter("validTo"));
                boolean isActive = (isActiveParam != null);
                String[] categoryIds = request.getParameterValues("categoryIds");
                if (categoryIds != null) {
                    for (String catIdStr : categoryIds) {
                        int catId = Integer.parseInt(catIdStr);
                    }
                }
                voucher.setCode(code);
                voucher.setType(voucherType);
                voucher.setValue(value);
                voucher.setMinValue(minValue);
                voucher.setMaxValue(maxValue);
                voucher.setTotalUsageLimit(totalLimit);
                voucher.setUserUsageLimit(userLimit);
                voucher.setDescription(description);
                voucher.setValidFrom(validFrom);
                voucher.setValidTo(validTo);
                voucher.setIsActive(isActive);

                boolean created = vDao.createVoucher(voucher, categoryIds);
                response.setStatus(created ? 200 : 500);
                break;
            case "delete":
                try {
                int voucherIdToDelete = Integer.parseInt(request.getParameter("id"));
                boolean deleted = vDao.deleteVoucherById(voucherIdToDelete);
                response.setStatus(deleted ? 200 : 500);
            } catch (Exception e) {
                response.setStatus(500);
            }
            break;
            case "update":
                try {
                BufferedReader reader = request.getReader();
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                String json = sb.toString();
                JsonObject obj = JsonParser.parseString(json).getAsJsonObject();
                int voucherId = Integer.parseInt(obj.get("id").getAsString());
                String codeToUpdate = obj.get("code").getAsString();
                String typeToUpdate = obj.get("voucherType").getAsString();
                double valueToUpdate = obj.get("value").getAsDouble();
                double minValueToUpdate = obj.get("minValue").getAsDouble();
                Double maxValueToUpdate = Converter.parseNullableDouble(obj.has("maxValue") ? obj.get("maxValue").getAsString() : null);
                Integer totalUsageLimit = Converter.parseNullableInt(obj.has("totalUsageLimit") ? obj.get("totalUsageLimit").getAsString() : null);
                Integer userUsageLimit = Converter.parseNullableInt(obj.has("userUsageLimit") ? obj.get("userUsageLimit").getAsString() : null);
                String descriptionToUpdate = obj.get("description").getAsString();
                String validFromStr = obj.get("validFrom").getAsString();
                String validToStr = obj.get("validTo").getAsString();
                LocalDateTime validFromToUpdate = Converter.parseLocalDateTime(validFromStr);
                LocalDateTime validToToUpdate = Converter.parseLocalDateTime(validToStr);
                String status = obj.get("isActive").getAsString();
                boolean isActiveToUpdate = "Active".equalsIgnoreCase(status);
                String[] categoryIdToUpdate = new String[0];
                if (obj.has("categoryIds") && obj.get("categoryIds").isJsonArray()) {
                    JsonArray arr = obj.getAsJsonArray("categoryIds");
                    categoryIdToUpdate = new String[arr.size()];
                    for (int i = 0; i < arr.size(); i++) {
                        categoryIdToUpdate[i] = String.valueOf(arr.get(i).getAsInt());
                    }
                }
                boolean updated = vDao.updateVoucher(voucherId, codeToUpdate, typeToUpdate, valueToUpdate, minValueToUpdate, maxValueToUpdate, totalUsageLimit, userUsageLimit, descriptionToUpdate, validFromToUpdate, validToToUpdate, isActiveToUpdate);
                boolean updatedCategory = vDao.updateVoucherCategory(voucherId, categoryIdToUpdate);
                response.setStatus(updated ? 200 : 500);
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(500);
            }
            break;
            default:
                break;
        }
    }

}
