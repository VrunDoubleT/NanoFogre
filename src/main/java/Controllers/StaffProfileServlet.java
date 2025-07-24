/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.StaffDAO;
import Models.Employee;
import Utils.CloudinaryConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Duong Tran Ngoc Chau - CE181040
 */
@WebServlet(name = "StaffProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class StaffProfileServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;

        if (emp == null || emp.getRole() == null || emp.getRole().getId() != 2) {
            response.sendRedirect(request.getContextPath() + "/staff/auth/login");
            return;
        }

        int staffId = emp.getId();
        String name = request.getParameter("nameEdit");
        String phone = request.getParameter("phoneEdit");
        String dobStr = request.getParameter("dobEdit");
        String gender = request.getParameter("genderEdit");
        String address = request.getParameter("addressEdit");

        LocalDate dob = null;
        if (dobStr != null && !dobStr.isEmpty()) {
            dob = LocalDate.parse(dobStr);
        }

        String avatarUrl = emp.getAvatar();
        Part avatarPart = request.getPart("avatarFile");
        if (avatarPart != null && avatarPart.getSize() > 0) {
            List<Part> images = new ArrayList<>();
            images.add(avatarPart);
            List<String> urls = CloudinaryConfig.uploadImages(images);
            if (!urls.isEmpty()) {
                avatarUrl = urls.get(0);
            }
        }

        Employee updatedEmp = new Employee();
        updatedEmp.setId(staffId);
        updatedEmp.setName(name);
        updatedEmp.setPhoneNumber(phone);
        updatedEmp.setDateOfBirth(dob);
        updatedEmp.setGender(gender);
        updatedEmp.setAddress(address);
        updatedEmp.setAvatar(avatarUrl);

        StaffDAO sDao = new StaffDAO();
        boolean updatedProfile = sDao.updateProfile(updatedEmp);

        if (updatedProfile) {
            Employee updated = sDao.getStaffById(staffId);
            session.setAttribute("employee", updated);
            response.setStatus(200);
        } else {
            response.setStatus(500);
        }
    }
}
