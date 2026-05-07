package com.nearfix.servlet;

import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        req.getRequestDispatcher("/adminDashboard.jsp").forward(req, resp);
    }
}