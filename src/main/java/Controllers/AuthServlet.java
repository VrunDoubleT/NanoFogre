/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAOs.CustomerDAO;
import Models.Customer;
import Utils.Common;
import jakarta.servlet.http.Cookie;
import java.io.IOException;

/**
 *
 * @author Modern 15
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/AuthServlet", "/auth"})
public class AuthServlet extends HttpServlet {

    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Get remembered email from cookie if exists
        String rememberedEmail = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("customer_email".equals(c.getName())) {
                    rememberedEmail = c.getValue();
                    break;
                }
            }
        }
        request.setAttribute("rememberedEmail", rememberedEmail);

        if ("login".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
        } else if ("register".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
        } else if ("forgot".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/customers/pages/forgotPassword.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            // Optionally clear the remembered email cookie
            Cookie cookie = new Cookie("customer_email", "");
            cookie.setMaxAge(0);
            response.addCookie(cookie);
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        Customer customer = customerDAO.login(email, Common.hashPassword(password));

        if (customer != null) {
            if (customer.isIsBlock()) {
                request.setAttribute("error", "Your account is blocked!");
                request.setAttribute("rememberedEmail", email);
                request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);

            // Set cookie if user checks "Remember me"
            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("customer_email", email);
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                response.addCookie(cookie);
            } else {
                // Remove cookie if not checked
                Cookie cookie = new Cookie("customer_email", "");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }

            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.setAttribute("rememberedEmail", email);
            request.getRequestDispatcher("/WEB-INF/customers/pages/loginPage.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        request.setAttribute("name", name);
        request.setAttribute("email", email);

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
            return;
        }

        if (customerDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
            return;
        }

        Customer newCustomer = new Customer();
        newCustomer.setName(name);
        newCustomer.setEmail(email);
        newCustomer.setPassword(Common.hashPassword(password));
        newCustomer.setIsBlock(false);

        if (customerDAO.register(newCustomer)) {
            request.getSession().setAttribute("registerSuccess", true);
            response.sendRedirect(request.getContextPath() + "/auth?action=register&justRegistered=true");
        } else {
            request.setAttribute("error", "Registration failed, please try again!");
            request.getRequestDispatcher("/WEB-INF/customers/pages/registerPage.jsp").forward(request, response);
        }
    }
}