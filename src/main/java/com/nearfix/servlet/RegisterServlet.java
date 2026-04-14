package com.nearfix.servlet;

import com.nearfix.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");
        String zipCode = req.getParameter("zipCode");

        if (name == null || email == null || password == null || name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (zipCode != null) {
            zipCode = zipCode.trim();
            if (!zipCode.isEmpty() && !zipCode.matches("\\d{5}")) {
                req.setAttribute("error", "Zip code must be 5 digits.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        }

        String role = req.getParameter("role");
        if (role == null || role.isEmpty()) {
            role = "customer";
        }

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(name, email, password, zipCode, role);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Email may already be in use.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
