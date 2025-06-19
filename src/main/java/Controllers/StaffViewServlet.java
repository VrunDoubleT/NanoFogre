/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.StaffDAO;
import Models.Employee;
import Utils.Converter;
import Utils.MailUtil;
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
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet(name = "StaffViewServlet", urlPatterns = {"/staff/view"})
public class StaffViewServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        StaffDAO sDao = new StaffDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "slist";
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Employee> staff = sDao.getAllStaff(page, limit);
                request.setAttribute("slist", staff);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/staff/staffTemplate.jsp").forward(request, response);
                break;
            case "detail":
                int did = Integer.parseInt(request.getParameter("id"));
                Employee item = sDao.getStaffById(did);
                int orderCount = sDao.countOrdersByEmployeeId(did);
                request.setAttribute("staff", item);
                request.setAttribute("orderCount", orderCount);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/staff/staffDetailsTemplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = sDao.countStaff();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/products/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/staff/createStaffTemplate.jsp").forward(request, response);
                break;
            case "checkEmail":
                String allEmails = request.getParameter("email");
                boolean exists = sDao.isEmailExists(allEmails);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(exists));
                break;
            case "checkEmailExceptOwn":
                String email = request.getParameter("email");
                String idRaw = request.getParameter("id");
                int idCheckMail = idRaw != null ? Integer.parseInt(idRaw) : -1;
                boolean exist = sDao.isEmailExistsExceptOwn(email, idCheckMail);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(exist));
                break;
            case "update":
                try {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee staffToUpdate = sDao.getStaffById(id);
                request.setAttribute("staff", staffToUpdate);
                request.getRequestDispatcher("/WEB-INF/employees/teamplates/staff/updateStaffTemplate.jsp").forward(request, response);
            } catch (Exception e) {
                response.setStatus(500);
            }
            break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type") != null ? request.getParameter("type") : "create";
        StaffDAO sDao = new StaffDAO();

        switch (type) {
            case "create":
                Employee staff = new Employee();
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String name = request.getParameter("name");
                String avatar = request.getParameter("avatar");
                String isBlockedParam = request.getParameter("block");

                staff.setEmail(email);
                staff.setPassword(password);
                staff.setName(name);
                staff.setAvatar((avatar != null && !avatar.trim().isEmpty()) ? avatar : null);
                staff.setIsBlock(isBlockedParam != null);
                boolean created = sDao.createStaff(staff);

                if (created) {
                    try {
                        String subject = "New Account";
                        String content = "Hi " + name + ",\n\n"
                                + "Your account has been successfully created in the system.\n"
                                + "This is login information: \n"
                                + "Email: " + email + "\n"
                                + "Password: " + password + "\n\n"
                                + "Regard,\n"
                                + "NanoForge Team\n\n";
                        MailUtil.sendEmail(email, subject, content);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                break;
            case "delete":
                try {
                int staffIdToDelete = Integer.parseInt(request.getParameter("id"));
                boolean deleted = sDao.deleteStaffById(staffIdToDelete);
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
                int staffIdToUpdate = Integer.parseInt(obj.get("id").getAsString());
                String nameToUpdate = obj.get("name").getAsString();
                String emailToUpdate = obj.get("email").getAsString();
                String status = obj.get("status").getAsString();
                boolean isBlocked = "Block".equalsIgnoreCase(status);
                boolean updated = sDao.updateStaff(staffIdToUpdate, nameToUpdate, emailToUpdate, isBlocked);

                if (updated) {
                    response.setStatus(200);
                } else {
                    response.setStatus(500);
                }
            } catch (Exception e) {
                response.setStatus(500);
            }
            break;
            default:
                break;
        }
    }
}
