package com.nearfix.servlet;

import com.nearfix.dao.ServiceCategoryDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        ServiceCategoryDAO dao = new ServiceCategoryDAO();
        req.setAttribute("categories", dao.getAll());
        req.getRequestDispatcher("/adminCategories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String action = req.getParameter("action");
        ServiceCategoryDAO dao = new ServiceCategoryDAO();

        if ("create".equals(action)) {
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            if (name == null || name.trim().isEmpty()) {
                req.setAttribute("error", "Category name is required.");
            } else if (!dao.createCategory(name.trim(), description)) {
                req.setAttribute("error", "Failed to create category. Name may already exist.");
            } else {
                req.setAttribute("success", "Category created.");
            }
        } else if ("delete".equals(action)) {
            try {
                int categoryId = Integer.parseInt(req.getParameter("categoryId"));
                if (!dao.deleteCategory(categoryId)) {
                    req.setAttribute("error", "Failed to delete category. It may still have services attached.");
                } else {
                    req.setAttribute("success", "Category deleted.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid category id.");
            }
        }

        req.setAttribute("categories", dao.getAll());
        req.getRequestDispatcher("/adminCategories.jsp").forward(req, resp);
    }
}
