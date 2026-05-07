package com.nearfix.servlet;

import com.nearfix.dao.BookingDAO;
import com.nearfix.dao.ReviewDAO;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/customer/bookings")
public class CustomerBookingsServlet extends HttpServlet {

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

        BookingDAO bookingDAO = new BookingDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        req.setAttribute("bookings", bookingDAO.getByCustomerId(user.getUserId()));
        req.setAttribute("reviewedBookingIds", reviewDAO.getReviewedBookingIdsForCustomer(user.getUserId()));
        req.getRequestDispatcher("/customerBookings.jsp").forward(req, resp);
    }
}
