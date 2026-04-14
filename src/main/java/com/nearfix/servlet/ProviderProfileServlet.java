package com.nearfix.servlet;

import com.nearfix.dao.ProviderDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/provider/profile")
public class ProviderProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"provider".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        ProviderDAO dao = new ProviderDAO();
        Provider provider = dao.getByUserId(user.getUserId());
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerProfile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"provider".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        String businessName = req.getParameter("businessName");
        String contactNumber = req.getParameter("contactNumber");

        ProviderDAO dao = new ProviderDAO();
        Provider provider = dao.getByUserId(user.getUserId());

        if (provider == null) {
            if (dao.createProvider(user.getUserId(), businessName, contactNumber)) {
                provider = dao.getByUserId(user.getUserId());
                session.setAttribute("provider", provider);
                req.setAttribute("success", "Provider profile created.");
            } else {
                req.setAttribute("error", "Failed to create provider profile.");
            }
        } else {
            if (dao.updateProfile(provider.getProviderId(), businessName, contactNumber)) {
                provider.setBusinessName(businessName);
                provider.setContactNumber(contactNumber);
                session.setAttribute("provider", provider);
                req.setAttribute("success", "Profile updated.");
            } else {
                req.setAttribute("error", "Failed to update profile.");
            }
        }

        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerProfile.jsp").forward(req, resp);
    }
}
