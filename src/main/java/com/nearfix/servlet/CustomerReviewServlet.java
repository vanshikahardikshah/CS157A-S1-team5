package com.nearfix.servlet;

import com.nearfix.dao.BookingDAO;
import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ReviewDAO;
import com.nearfix.dao.ServiceDAO;
import com.nearfix.model.Booking;
import com.nearfix.model.Provider;
import com.nearfix.model.Review;
import com.nearfix.model.Service;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/customer/review")
public class CustomerReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = requireCustomer(req, resp);
        if (user == null) return;

        Booking booking = loadEligibleBooking(req, resp, user);
        if (booking == null) return;

        attachServiceAndProvider(req, booking);
        req.setAttribute("booking", booking);
        req.getRequestDispatcher("/customerReview.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = requireCustomer(req, resp);
        if (user == null) return;

        Booking booking = loadEligibleBooking(req, resp, user);
        if (booking == null) return;

        int rating;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException e) {
            renderForm(req, resp, booking, "Please choose a rating between 1 and 5.");
            return;
        }
        if (rating < 1 || rating > 5) {
            renderForm(req, resp, booking, "Rating must be between 1 and 5.");
            return;
        }

        String comment = req.getParameter("comment");
        if (comment != null) comment = comment.trim();

        ServiceDAO serviceDAO = new ServiceDAO();
        Service service = serviceDAO.getById(booking.getServiceId());
        if (service == null) {
            renderForm(req, resp, booking, "Service no longer exists.");
            return;
        }

        Review review = new Review();
        review.setBookingId(booking.getBookingId());
        review.setCustomerId(user.getUserId());
        review.setProviderId(service.getProviderId());
        review.setRating(rating);
        review.setComment(comment == null || comment.isEmpty() ? null : comment);

        ReviewDAO reviewDAO = new ReviewDAO();
        if (reviewDAO.createReview(review)) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings?reviewed=true");
        } else {
            renderForm(req, resp, booking, "Failed to save review. Please try again.");
        }
    }

    private User requireCustomer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return null;
        }
        return user;
    }

    private Booking loadEligibleBooking(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String bookingIdParam = req.getParameter("bookingId");
        if (bookingIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
            return null;
        }
        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
            return null;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null || booking.getCustomerId() != user.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings");
            return null;
        }
        if (!"completed".equals(booking.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings?error=notCompleted");
            return null;
        }
        if (new ReviewDAO().getByBookingId(bookingId) != null) {
            resp.sendRedirect(req.getContextPath() + "/customer/bookings?error=alreadyReviewed");
            return null;
        }
        return booking;
    }

    private void attachServiceAndProvider(HttpServletRequest req, Booking booking) {
        Service service = new ServiceDAO().getById(booking.getServiceId());
        Provider provider = service != null ? new ProviderDAO().getById(service.getProviderId()) : null;
        req.setAttribute("service", service);
        req.setAttribute("provider", provider);
    }

    private void renderForm(HttpServletRequest req, HttpServletResponse resp, Booking booking, String error)
            throws ServletException, IOException {
        attachServiceAndProvider(req, booking);
        req.setAttribute("booking", booking);
        req.setAttribute("error", error);
        req.getRequestDispatcher("/customerReview.jsp").forward(req, resp);
    }
}
