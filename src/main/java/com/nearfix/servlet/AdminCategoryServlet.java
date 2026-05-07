package com.nearfix.servlet;

import com.nearfix.dao.ServiceCategoryDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    private final ServiceCategoryDAO categoryDAO = new ServiceCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;
        req.setAttribute("categories", categoryDAO.getAll());
        req.getRequestDispatcher("/adminCategories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        HttpSession session = req.getSession();
        String action = req.getParameter("action");

        if ("create".equals(action)) {
            String name = req.getParameter("categoryName");
            String description = req.getParameter("description");
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "Category name is required.");
            } else if (categoryDAO.create(name.trim(), description == null ? null : description.trim())) {
                session.setAttribute("success", "Category created.");
            } else {
                session.setAttribute("error", "Failed to create category. Name may already be in use.");
            }
        } else if ("delete".equals(action)) {
            try {
                int categoryId = Integer.parseInt(req.getParameter("categoryId"));
                int serviceCount = categoryDAO.countServicesInCategory(categoryId);
                if (serviceCount > 0) {
                    session.setAttribute("error", "Cannot delete: " + serviceCount + " service(s) still use this category. Reassign or remove them first.");
                } else if (categoryDAO.delete(categoryId)) {
                    session.setAttribute("success", "Category deleted.");
                } else {
                    session.setAttribute("error", "Failed to delete category.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid category id.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return false;
        }
        return true;
    }
}
