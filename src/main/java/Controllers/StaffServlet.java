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
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet("/staff")
public class StaffServlet extends HttpServlet {

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
        int limit = 10;
        StaffDAO sDao = new StaffDAO();
        String type = request.getParameter("type") != null ? request.getParameter("type") : "slist";
        String idStaff = request.getParameter("id");
        switch (type) {
            case "list":
                int page = Converter.parseOption(request.getParameter("page"), 1);
                List<Employee> staff = sDao.getAllStaff(page, limit);
                request.setAttribute("slist", staff);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("/WEB-INF/employees/templates/staff/staffTemplate.jsp").forward(request, response);
                break;
            case "detail":
                int did = Integer.parseInt(request.getParameter("id"));
                Employee item = sDao.getStaffById(did);
                int orderCount = sDao.countOrdersByEmployeeId(did);
                request.setAttribute("staff", item);
                request.setAttribute("orderCount", orderCount);
                request.getRequestDispatcher("/WEB-INF/employees/templates/staff/staffDetailsTemplate.jsp").forward(request, response);
                break;
            case "pagination":
                int p = Converter.parseOption(request.getParameter("page"), 1);
                int t = sDao.countStaff();
                request.setAttribute("total", t);
                request.setAttribute("limit", limit);
                request.setAttribute("page", p);
                request.getRequestDispatcher("/WEB-INF/employees/common/paginationTeamplate.jsp").forward(request, response);
                break;
            case "create":
                request.getRequestDispatcher("/WEB-INF/employees/templates/staff/createStaffTemplate.jsp").forward(request, response);
                break;
            case "checkEmail":
                String allEmails = request.getParameter("email");
                boolean emailExists = sDao.isEmailExists(allEmails);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(emailExists));
                break;
            case "checkEmailExceptOwn":
                String email = request.getParameter("email");
                int idCheckMail = idStaff != null ? Integer.parseInt(idStaff) : -1;
                boolean emailExist = sDao.isEmailExistsExceptOwn(email, idCheckMail);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(emailExist));
                break;
            case "checkCitizenId":
                String allCitizenId = request.getParameter("citizenId");
                boolean idExists = sDao.isCitizenIdExists(allCitizenId);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(idExists));
                break;
            case "checkCitizenIdExceptOwn":
                String citizenId = request.getParameter("citizenId");
                int idCheckCitizenId = idStaff != null ? Integer.parseInt(idStaff) : -1;
                boolean idExist = sDao.isCitizenIdExistsExceptOwn(citizenId, idCheckCitizenId);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(idExist));
                break;
            case "checkPhone":
                String allPhone = request.getParameter("phone");
                boolean phoneExists = sDao.isPhoneExists(allPhone);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(phoneExists));
                break;
            case "checkPhoneExceptOwn":
                String phoneId = request.getParameter("phone");
                int idCheckPhone = idStaff != null ? Integer.parseInt(idStaff) : -1;
                boolean phoneExist = sDao.isPhoneExistsExceptOwn(phoneId, idCheckPhone);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(phoneExist));
                break;
            case "update":
                try {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee staffToUpdate = sDao.getStaffById(id);
                request.setAttribute("staff", staffToUpdate);
                request.getRequestDispatcher("/WEB-INF/employees/templates/staff/updateStaffTemplate.jsp").forward(request, response);
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
                String newPassword = request.getParameter("newPassword");
                String citizenId = request.getParameter("citizenIdentityId");
                String phone = request.getParameter("phoneNumber");
                String dobStr = request.getParameter("dateOfBirth");
                LocalDate dob = null;
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        dob = LocalDate.parse(dobStr);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                String gender = request.getParameter("gender");
                String address = request.getParameter("address");
                String isBlockedParam = request.getParameter("block");

                staff.setEmail(email);
                staff.setPassword(password);
                staff.setNewPassword(newPassword);
                staff.setName(name);
                staff.setAvatar((avatar != null && !avatar.trim().isEmpty()) ? avatar : null);
                staff.setCitizenIdentityId(citizenId);
                staff.setPhoneNumber(phone);
                staff.setGender(gender);
                staff.setAddress(address);
                staff.setIsBlock(isBlockedParam != null);
                staff.setDateOfBirth(dob);
                staff.setDestroy(false);
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
                    response.setStatus(200);
                } else {
                    response.setStatus(500);
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
                String citizenIdToUpdate = obj.get("citizenIdentityId").getAsString();
                String genderToUpdate = obj.get("gender").getAsString();
                String dobStrToUpdate = obj.get("dob").getAsString();
                String addressToUpdate = obj.get("address").getAsString();
                String phoneToUpdate = obj.get("phoneNumber").getAsString();
                LocalDate dobToUpdate = null;
                try {
                    dobToUpdate = LocalDate.parse(dobStrToUpdate);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                Employee staffToUpdate = new Employee();
                staffToUpdate.setId(staffIdToUpdate);
                staffToUpdate.setName(nameToUpdate);
                staffToUpdate.setEmail(emailToUpdate);
                staffToUpdate.setIsBlock(isBlocked);
                staffToUpdate.setCitizenIdentityId(citizenIdToUpdate);
                staffToUpdate.setGender(genderToUpdate);
                staffToUpdate.setDateOfBirth(dobToUpdate);
                staffToUpdate.setAddress(addressToUpdate);
                staffToUpdate.setPhoneNumber(phoneToUpdate);

                boolean updated = sDao.updateStaff(staffToUpdate);

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
