package com.nearfix.servlet;

import com.nearfix.dao.UserDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setAttribute("users", userDAO.getAllUsers());
        req.getRequestDispatcher("/adminUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User admin = requireAdminUser(req, resp);
        if (admin == null) return;

        HttpSession session = req.getSession();
        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            if (userId == admin.getUserId()) {
                session.setAttribute("error", "You cannot delete your own admin account.");
            } else if (userDAO.adminDeleteUser(userId)) {
                session.setAttribute("success", "User deleted. Their bookings, reviews, and provider record (if any) were removed.");
            } else {
                session.setAttribute("error", "Failed to delete user.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid user id.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        return requireAdminUser(req, resp) != null;
    }

    private User requireAdminUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return null;
        }
        return user;
    }
}
