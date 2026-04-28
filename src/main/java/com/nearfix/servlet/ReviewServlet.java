package com.nearfix.servlet;

import com.nearfix.dao.ProviderDAO;
import com.nearfix.dao.ReviewDAO;
import com.nearfix.model.Provider;
import com.nearfix.model.Review;
import com.nearfix.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String providerIdStr = req.getParameter("providerId");
        if (providerIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        int providerId;
        try {
            providerId = Integer.parseInt(providerIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        ProviderDAO providerDAO = new ProviderDAO();
        Provider provider = providerDAO.getById(providerId);
        if (provider == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        List<Integer> bookingIds = "customer".equals(user.getRole())
            ? dao.getReviewableBookingIds(user.getUserId(), providerId)
            : java.util.Collections.emptyList();
        List<Review> existing = dao.getByProvider(providerId);

        req.setAttribute("provider", provider);
        req.setAttribute("bookingIds", bookingIds);
        req.setAttribute("existingReviews", existing);
        req.setAttribute("submitted", "true".equals(req.getParameter("submitted")));
        if ("true".equals(req.getParameter("error"))) {
            req.setAttribute("error", "Review could not be submitted. Booking may not be eligible or may already have a review.");
        }
        req.getRequestDispatcher("/review.jsp").forward(req, resp);
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
        try {
            int providerId = Integer.parseInt(req.getParameter("providerId"));
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");
            ReviewDAO dao = new ReviewDAO();
            boolean ok = dao.submitReview(bookingId, user.getUserId(), providerId, rating, comment);
            String suffix = ok ? "&submitted=true" : "&error=true";
            resp.sendRedirect(req.getContextPath() + "/review?providerId=" + providerId + suffix);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
