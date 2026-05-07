package com.nearfix.servlet;

import com.nearfix.dao.ProviderDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/approvals")
public class AdminApprovalServlet extends HttpServlet {

    private final ProviderDAO providerDAO = new ProviderDAO();

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

        List<Provider> providers = providerDAO.getAllProviders();
        req.setAttribute("providers", providers);
        req.getRequestDispatcher("/adminApproval.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        try {
            int providerId = Integer.parseInt(req.getParameter("providerId"));
            String action = req.getParameter("action");

            String status;
            if ("approve".equalsIgnoreCase(action)) {
                status = "approved";
            } else if ("reject".equalsIgnoreCase(action)) {
                status = "rejected";
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/approvals");
                return;
            }

            boolean updated = providerDAO.updateApprovalStatus(providerId, status);

            if (updated) {
                session.setAttribute("success", "Provider status updated successfully.");
            } else {
                session.setAttribute("error", "Failed to update provider status.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid approval request.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/approvals");
    }
}