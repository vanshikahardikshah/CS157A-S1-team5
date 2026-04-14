package com.nearfix.servlet;

import com.nearfix.dao.UserDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        UserDAO dao = new UserDAO();

        if ("updateProfile".equals(action)) {
            String name = req.getParameter("name");
            String zipCode = req.getParameter("zipCode");
            if (dao.updateProfile(user.getUserId(), name, zipCode)) {
                user.setName(name);
                user.setZipCode(zipCode);
                session.setAttribute("user", user);
                req.setAttribute("success", "Profile updated.");
            } else {
                req.setAttribute("error", "Failed to update profile.");
            }
        } else if ("changePassword".equals(action)) {
            String oldPassword = req.getParameter("oldPassword");
            String newPassword = req.getParameter("newPassword");
            if (dao.changePassword(user.getEmail(), oldPassword, newPassword)) {
                req.setAttribute("success", "Password changed successfully.");
            } else {
                req.setAttribute("error", "Incorrect current password.");
            }
        } else if ("deleteAccount".equals(action)) {
            String password = req.getParameter("password");
            if (dao.deleteAccount(user.getUserId(), password)) {
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/?deleted=true");
                return;
            } else {
                req.setAttribute("error", "Incorrect password. Account not deleted.");
            }
        }

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}
