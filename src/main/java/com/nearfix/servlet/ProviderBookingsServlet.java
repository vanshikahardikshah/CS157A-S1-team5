package com.nearfix.servlet;

import com.nearfix.dao.BookingDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/provider/bookings")
public class ProviderBookingsServlet extends HttpServlet {

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

        BookingDAO bookingDAO = new BookingDAO();
        req.setAttribute("bookings", bookingDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerBookings.jsp").forward(req, resp);
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

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        String action = req.getParameter("action");
        BookingDAO bookingDAO = new BookingDAO();

        if ("accept".equals(action)) {
            if (bookingDAO.updateStatus(bookingId, "confirmed")) {
                req.setAttribute("success", "Booking confirmed.");
            } else {
                req.setAttribute("error", "Failed to confirm booking.");
            }
        } else if ("reject".equals(action)) {
            if (bookingDAO.updateStatus(bookingId, "cancelled")) {
                req.setAttribute("success", "Booking rejected.");
            } else {
                req.setAttribute("error", "Failed to reject booking.");
            }
        } else if ("complete".equals(action)) {
            if (bookingDAO.updateStatus(bookingId, "completed")) {
                req.setAttribute("success", "Booking marked as completed.");
            } else {
                req.setAttribute("error", "Failed to update booking.");
            }
        }

        req.setAttribute("bookings", bookingDAO.getByProviderId(provider.getProviderId()));
        req.setAttribute("provider", provider);
        req.getRequestDispatcher("/providerBookings.jsp").forward(req, resp);
    }
}
