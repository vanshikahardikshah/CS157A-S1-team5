package com.nearfix.servlet;

import com.nearfix.dao.BookingDAO;
import com.nearfix.model.BookingDetails;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/bookings")
public class BookingHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        BookingDAO dao = new BookingDAO();
        List<BookingDetails> bookings = dao.getDetailsByCustomerId(user.getUserId());
        req.setAttribute("bookings", bookings);
        if (req.getParameter("booked") != null) {
            req.setAttribute("success", "Booking #" + req.getParameter("booked") + " created. Awaiting provider confirmation.");
        }
        if (req.getParameter("cancelled") != null) {
            req.setAttribute("success", "Booking cancelled.");
        }
        req.getRequestDispatcher("/bookingHistory.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        if ("cancel".equals(req.getParameter("action"))) {
            try {
                int bookingId = Integer.parseInt(req.getParameter("bookingId"));
                new BookingDAO().cancelByCustomer(bookingId, user.getUserId());
                resp.sendRedirect(req.getContextPath() + "/bookings?cancelled=" + bookingId);
                return;
            } catch (NumberFormatException ignore) {}
        }
        resp.sendRedirect(req.getContextPath() + "/bookings");
    }
}
