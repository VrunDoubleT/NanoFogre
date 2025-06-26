/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.VoucherDAO;
import Models.Voucher;
import Utils.Converter;
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
public class VoucherViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int limit = 5;
        VoucherDAO vDao = new VoucherDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "vlist";
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Voucher> vouchers = vDao.getAllVouchers(page, limit);
                request.setAttribute("vlist", vouchers);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/vouchers/voucherTemplate.jsp").forward(request, response);
                break;
            case "detail":
                int did = Integer.parseInt(request.getParameter("id"));
                Voucher item = vDao.getVoucherById(did);
                request.setAttribute("voucher", item);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/vouchers/voucherDetailsTemplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = vDao.countVouchers();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/vouchers/createVoucherTemplate.jsp").forward(request, response);
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
            case "update":
                try {
                int id = Integer.parseInt(request.getParameter("id"));
                Voucher voucherToUpdate = vDao.getVoucherById(id);
                request.setAttribute("voucher", voucherToUpdate);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/vouchers/updateVoucherTemplate.jsp").forward(request, response);
            } catch (Exception e) {
                response.setStatus(500);
            }
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
                String voucherType = request.getParameter("voucherType");
                String description = request.getParameter("description");
                String isActiveParam = request.getParameter("active");
                double value = Converter.parseDouble(request.getParameter("value"), 0);
                double minValue = Converter.parseDouble(request.getParameter("minValue"), 0);
                double maxValue = Converter.parseDouble(request.getParameter("maxValue"), 0);
                LocalDateTime validFrom = Converter.parseLocalDateTime(request.getParameter("validFrom"));
                LocalDateTime validTo = Converter.parseLocalDateTime(request.getParameter("validTo"));
                boolean isActive = (isActiveParam != null);

                voucher.setCode(code);
                voucher.setType(voucherType);
                voucher.setValue(value);
                voucher.setMinValue(minValue);
                voucher.setMaxValue(maxValue);
                voucher.setDescription(description);
                voucher.setValidFrom(validFrom);
                voucher.setValidTo(validTo);
                voucher.setIsActive(isActive);

                boolean created = vDao.createVoucher(voucher);
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
                double maxValueToUpdate = obj.has("maxValue") && !obj.get("maxValue").isJsonNull() ? obj.get("maxValue").getAsDouble() : 0;
                String descriptionToUpdate = obj.get("description").getAsString();
                String validFromStr = obj.get("validFrom").getAsString();
                String validToStr = obj.get("validTo").getAsString();
                LocalDateTime validFromToUpdate = Converter.parseLocalDateTime(validFromStr);
                LocalDateTime validToToUpdate = Converter.parseLocalDateTime(validToStr);
                String status = obj.get("status").getAsString();
                boolean isActiveToUpdate = "Active".equalsIgnoreCase(status);

                boolean updated = vDao.updateVoucher(voucherId, codeToUpdate, typeToUpdate, valueToUpdate, minValueToUpdate, maxValueToUpdate, descriptionToUpdate, validFromToUpdate, validToToUpdate, isActiveToUpdate);
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
