package com.nearfix.servlet;

import com.nearfix.dao.AvailabilityDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.model.Availability;
import com.nearfix.model.Provider;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/provider/availability")
public class ProviderAvailabilityServlet extends HttpServlet {

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

        ProviderDAO providerDAO = new ProviderDAO();
        Provider provider = providerDAO.getByUserId(user.getUserId());
        if (provider == null) {
            resp.sendRedirect(req.getContextPath() + "/provider/profile");
            return;
        }

        AvailabilityDAO availDAO = new AvailabilityDAO();
        req.setAttribute("slots", availDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerAvailability.jsp").forward(req, resp);
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

        ProviderDAO providerDAO = new ProviderDAO();
        Provider provider = providerDAO.getByUserId(user.getUserId());
        if (provider == null) {
            resp.sendRedirect(req.getContextPath() + "/provider/profile");
            return;
        }

        String action = req.getParameter("action");
        AvailabilityDAO availDAO = new AvailabilityDAO();

        if ("add".equals(action)) {
            Availability slot = new Availability();
            slot.setProviderId(provider.getProviderId());
            slot.setAvailableDate(Date.valueOf(req.getParameter("availableDate")));
            slot.setStartTime(Time.valueOf(req.getParameter("startTime") + ":00"));
            slot.setEndTime(Time.valueOf(req.getParameter("endTime") + ":00"));

            if (availDAO.addSlot(slot)) {
                req.setAttribute("success", "Availability slot added.");
            } else {
                req.setAttribute("error", "Failed to add slot.");
            }
        } else if ("delete".equals(action)) {
            int slotId = Integer.parseInt(req.getParameter("slotId"));
            if (availDAO.deleteSlot(slotId, provider.getProviderId())) {
                req.setAttribute("success", "Slot removed.");
            } else {
                req.setAttribute("error", "Failed to remove slot.");
            }
        }

        req.setAttribute("slots", availDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerAvailability.jsp").forward(req, resp);
    }
}
